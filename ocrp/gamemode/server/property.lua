
--[[
	0 - For sale
	-1 - Unownable
	-2 - Police Doors
	>1 - Owned
]]--

util.AddNetworkString("OCRP_Update_Owned_Properties")
OwnedProperties = {}

function OCRP_Purchase_Property(ply,property)
    for k,v in pairs(OwnedProperties) do
        if v == ply:SteamID() then
            ply:Hint("You already own a property. You must sell that one first.")
            return
        end
    end
    local propertyTable = GAMEMODE.Properties[string.lower(game.GetMap())][property]
	if propertyTable then
        if ply:GetMoney(BANK) >= propertyTable.Price then
            for k,v in pairs(propertyTable.Doors) do
                local e = ents.GetMapCreatedEntity(k)
                if e and e:IsValid() then
                    e:SetNWInt("Owner", ply:EntIndex())
                    e.Permissions = {}
                    e.Permissions["Buddies"] = true
                    e.Permissions["Org"] = true
                    e.Permissions["Goverment"] = false
                    e.Permissions["Mayor"] = false
                end
            end 
            ply:TakeMoney(BANK, propertyTable.Price)
            OwnedProperties[property] = ply:SteamID()
            net.Start("OCRP_Update_Owned_Properties")
            net.WriteTable(OwnedProperties)
            net.Broadcast()
            ply:Hint("You rented "..GAMEMODE.Properties[string.lower(game.GetMap())][property].Name.." for $" .. propertyTable.Price .. ".")
            ply:Hint("This property only lasts until you disconnect. You may sell it at anytime for some of the money back.")
        end
	end
end
net.Receive("OCRP_Buy_Property", function(len, ply)
	if !ply:NearNPC( "Relator" ) then return false end
	OCRP_Purchase_Property(ply,net.ReadInt(32))
end)

function OCRP_Sell_Property(ply,property,norefund)
    if not OwnedProperties[property] == ply:SteamID() then ply:Hint("You don't own this property!") return end -- I think they'd have to cheat to do this?
    local propertyTable = GAMEMODE.Properties[string.lower(game.GetMap())][property]
	if propertyTable then
        for k,v in pairs(propertyTable.Doors) do
            local e = ents.GetMapCreatedEntity(k)
            if e and e:IsValid() then
                e:SetNWInt("Owner", 0)
                e.Permissions = {}
                e.Permissions["Buddies"] = false
                e.Permissions["Org"] = false
                e.Permissions["Government"] = false
                e.Permissions["Mayor"] = false
                e:Fire("Close")
                e:SetNWInt("UnLocked", true)
                e:Fire("Unlock")
                if e.PadLock then
                    e.PadLock:SetParent(nil)
                    e.PadLock:GetPhysicsObject():Wake()
                    e.PadLock = nil
                end
            end
        end
        if not norefund then
            ply:AddMoney(BANK, math.Round(propertyTable.Price/4))
            ply:Hint("$"..math.Round(propertyTable.Price/4) .." has been sent to your bank from the realtor.")
        end
        OwnedProperties[property] = nil
        net.Start("OCRP_Update_Owned_Properties")
        net.WriteTable(OwnedProperties)
        net.Broadcast()
        
	end
end
net.Receive("OCRP_Sell_Property", function(len, ply)
	if !ply:NearNPC( "Relator" ) then return false end
	OCRP_Sell_Property(ply,math.Round(net.ReadInt(32)))
end)

function OCRP_Set_Permissions(ply,door,Org,Bud,Gov)
	if door.UnOwnable != nil && ply:Team() == CLASS_CITIZEN then return end 
	if Bud == "nil" then Bud = "false" end
	if Org == "nil" then Org = "false" end
	if Gov == "nil" then Gov = "false" end
	if May == "nil" then May = "false" end
	
	if door:GetNWInt( "Owner" ) == ply:EntIndex() then
		door.Permissions = {}
		door.Permissions["Buddies"] = tobool(Bud)
		door.Permissions["Org"] = tobool(Org)
		door.Permissions["Goverment"] = tobool(Gov)
	elseif ply:Team() == CLASS_Mayor then
		door.Permissions = {}
		door.Permissions["Buddies"] = tobool(Bud)
		door.Permissions["Org"] = tobool(Org)
		door.Permissions["Goverment"] = tobool(Gov)
	end
end
net.Receive("OCRP_Set_Permissions", function(len, ply)
	local trace = util.GetPlayerTrace(ply)
	local tr = util.TraceLine(trace)
	if tr.Entity:IsValid() && tr.Entity:IsDoor() then
		OCRP_Set_Permissions(ply,tr.Entity,net.ReadString(),net.ReadString(),net.ReadString())
	end
end)

function OCRP_Has_Permission(ply,obj)
	if obj.Permissions == nil then return ply:EntIndex() == obj:GetNWInt("Owner", 0) end
	if obj.UnOwnable then
		if obj.UnOwnable == -1 then
            return ply:Team() == CLASS_Mayor
        elseif obj.UnOwnable == -2 then
            return ply:Team() == CLASS_Mayor or ply:Team() == CLASS_POLICE or ply:Team() == CLASS_SWAT or ply:Team() == CLASS_CHIEF
        end
        return false
	end
	local permtbl = obj.Permissions
	local owner = ents.GetByIndex(obj:GetNWInt("Owner"))
	
	if obj:GetClass() == "prop_vehicle_prisoner_pod" and obj:GetParent() and obj:GetParent():IsValid() then
		obj = obj:GetParent()
	end
	
	if obj:IsVehicle() and obj:GetDriver():IsPlayer() then
		owner = obj:GetDriver()
	end
	
	if owner == ply then 
		return true
	end
	if permtbl["Buddies"] and owner:IsValid() then
		if owner:IsBuddy(ply) then
			return true
		end
	end
	local etable = {2,3,4,5,6,7}
	if permtbl["Goverment"] && table.HasValue(etable, ply:Team()) then
		return true
	end
	if permtbl["Org"] && owner != nil then
		if tonumber(owner.Org) > 0 then
			if ply:GetOrg() == owner:GetOrg() then
				return true
			end
		end
	end

	return false
end

function OCRP_Toggle_Lock(ply,door)
	if OCRP_Has_Permission(ply,door) then
		if door:GetNWBool("UnLocked") then
			door:SetNWBool("UnLocked",false)
            door:Fire("Lock")
			door:EmitSound("doors/door_latch1.wav",70,100)
		else
			door:SetNWBool("UnLocked",true)
            door:Fire("Unlock")
			door:EmitSound("doors/door_latch3.wav",70,100)
			if door.PadLock != nil && ply == door.PadLock.Owner then
				door.PadLock:SetParent(nil)
				door.PadLock:GetPhysicsObject():Wake()
				door.PadLock = nil
			end
		end	
	end
end
