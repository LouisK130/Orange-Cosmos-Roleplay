util.AddNetworkString("OCRP_UpdateItem")
local EMETA = FindMetaTable("Entity")

function PMETA:UpdateItem(item)
    net.Start("OCRP_UpdateItem")
        net.WriteString(item)
        net.WriteInt(self.OCRPData["Inventory"][item] or 0, 32)
        net.WriteInt(self.OCRPData["Inventory"]["WeightData"].Cur, 32)
        net.WriteInt(self.OCRPData["Inventory"]["WeightData"].Max, 32)
    net.Send(self)
end

function PMETA:GiveItem(item,amount,load)
	if !self:HasItem(item) then
		if GAMEMODE.OCRP_Items[item].Weapondata != nil then
			self:Give(GAMEMODE.OCRP_Items[item].Weapondata.Weapon)
            self:UpdateAmmoCount()
		end
	end
	self:Inv_GiveItem(item,amount)
	
    if load != "LOAD" then
        self:UpdateItem(item)
    end

end

function EMETA:Inv_GiveItem(item, amount)
    self.OCRPData = self.OCRPData or {}
    if not amount then amount = 1; end
    if not self.OCRPData["Inventory"] then
        self.OCRPData["Inventory"] = {}
    end
    if not self.OCRPData["Inventory"][item] then
        self.OCRPData["Inventory"][item] = 0
    end
    self.OCRPData["Inventory"][item] = self.OCRPData["Inventory"][item] + amount
    self.OCRPData["Inventory"].WeightData.Cur = self.OCRPData["Inventory"].WeightData.Cur + ((GAMEMODE.OCRP_Items[item].Weight or 0) * amount)
    if GAMEMODE.OCRP_Items[item].AmmoType != nil then
        if self:IsPlayer() then
            self:UpdateAmmoCount()
        end
    end
    if string.find(item, "ammo") ~= nil then
        if self:IsPlayer() then
            self:UpdateAmmoCount()
        end
    end
end

function EMETA:Inv_RemoveItem(item, amount)
    self.OCRPData = self.OCRPData or {}
    if not amount then amount = 1; end
    if not self.OCRPData["Inventory"] then
        self.OCRPData["Inventory"] = {}
    end
    if not self.OCRPData["Inventory"][item] then
        return
    end
    self.OCRPData["Inventory"][item] = self.OCRPData["Inventory"][item] - amount
    if self.OCRPData["Inventory"][item] <= 0 then
        self.OCRPData["Inventory"][item] = nil
    end
    if GAMEMODE.OCRP_Items[item].AmmoType ~= nil then
        if self:IsPlayer() then
            self:UpdateAmmoCount()
        end
    end
    self.OCRPData["Inventory"].WeightData.Cur = self.OCRPData["Inventory"].WeightData.Cur - ((GAMEMODE.OCRP_Items[item].Weight or 0) * amount)
end

function PMETA:StoreItem(item, amount)
    if not amount then amount = 1; end
    if not self.OCRPData["Storage"] then
        self.OCRPData["Storage"] = {}
    end
    if not self.OCRPData["Storage"][item] then
        self.OCRPData["Storage"][item] = 0
    end
    self.OCRPData["Storage"][item] = self.OCRPData["Storage"][item] + amount
end

function PMETA:UnStoreItem(item, amount)
    if not amount then amount = 1; end
    if not self.OCRPData["Storage"] then
        self.OCRPData["Storage"] = {}
    end
    if not self.OCRPData["Storage"][item] then
        return
    end
    self.OCRPData["Storage"][item] = self.OCRPData["Storage"][item] - amount
    if self.OCRPData["Storage"][item] <= 0 then
        self.OCRPData["Storage"] = nil
    end
end

function PMETA:UseItem(item)
	if !self:Alive() then return end
	if !self:HasItem(item) then return end
	if self:InVehicle() then return end
	if GAMEMODE.OCRP_Items[item].Condition != nil then
		if GAMEMODE.OCRP_Items[item].Condition(self,item) then
			GAMEMODE.OCRP_Items[item].Function(self,item)
			self:RemoveItem(item)
            SV_PrintToAdmin(self, "USE-ITEM", "used " .. tostring(item))
		else
        end
	else
		GAMEMODE.OCRP_Items[item].Function(self,item)
		self:RemoveItem(item)
        SV_PrintToAdmin(self, "USE-ITEM", "used " .. tostring(item))
	end
end
net.Receive("OCRP_Useitem", function(len, ply)
	local item = net.ReadString()
	ply:UseItem(item)
end)

function PMETA:DropItem(item,amount)
    if not amount then amount = 1; end
	if !self:Alive() then return end
	if self.CantUse then self:Hint("Please wait before spawning again") return end
	local num = 0
	local multi = 1
	if self:GetLevel() <= 4 then 
		multi = 2
	end
	if self:GetLevel() <= 3 then 
		multi = 3
	end
	for _,ent in pairs(ents.FindByClass("item_base")) do 
		if ent:GetNWInt("Owner") == self:EntIndex() then
			num = num + 1
		end
	end
	if num >= math.Round(OCRPCfg["Prop_Limit"]*multi) then
		self:Hint("You have hit the prop limit")
		return
	end
	if !self:HasItem(item) then return end
	
    if not GAMEMODE.OCRP_Items[item].Weapondata and item != "item_pot" then
        self:StoreItem(item,amount) -- Dropped weapons stay dropped
    end
	self:RemoveItem(item,amount)	

	
	local tr = self:GetEyeTrace()
    local DropedEnt = nil
    if item == "item_radio" then
        DropedEnt = ents.Create("ocrp_radio")
    else
        DropedEnt = ents.Create("item_base")
    end
	DropedEnt:SetNWString("Class", item)
	DropedEnt:SetNWInt("Owner",self:EntIndex())
	DropedEnt.Amount = amount
	if GAMEMODE.OCRP_Items[item].Spawnable then
		DropedEnt:SetPos(self:GetPos())
	else
		DropedEnt:SetPos(self:EyePos() + (self:GetAimVector() * 30))
	end
	DropedEnt:SetAngles(Angle(0,self:EyeAngles().y ,0))
	DropedEnt:Spawn()
	
	if DropedEnt:GetPhysicsObject():IsValid() then
		DropedEnt:GetPhysicsObject():ApplyForceCenter(self:GetAimVector() * 120)
	end

    SV_PrintToAdmin(self, "DROP_ITEM", tostring(amount) .. " of " .. tostring(item))
	self.CantUse = true
	timer.Simple(1,function() if self:IsValid() then self.CantUse = false end end)
end
net.Receive("OCRP_Dropitem", function(len, ply)
	local item = net.ReadString()
	local amt = net.ReadInt(32)
 	if ply.OCRPData["Inventory"][item] then
		if amt > (ply.OCRPData["Inventory"][item] or 0) then
			return false
		end
	end
	if ply:HasItem(item) then
		ply:DropItem(item,amt)
	end
end)

function PMETA:RemoveItem(item,amount)
    if not amount then amount = 1; end
	
	self:Inv_RemoveItem(item,amount)

	for class,data in pairs(GAMEMODE.OCRP_Items) do 
		if item == class then
			if data.Weapondata != nil then
				if !self:HasItem(item) then
					if data.Weapondata.Weapon == "weapon_physgun" then 
						if self:GetLevel() > 4 then
							self:StripWeapon(data.Weapondata.Weapon)
						end
					else
						self:StripWeapon(data.Weapondata.Weapon)
					end
					--[[if self.VisibleWeps != nil then
						for _,weapon in pairs(self.VisibleWeps) do
							if weapon.Weapon == data.Weapondata.Weapon then
								table.remove(self.VisibleWeps,_)
								weapon:Remove()
								break
							end
						end
					end	]]--
				
				end
			end
		end
	end
	
	self:UpdateItem(item)
end

function PMETA:HasItem(item,amount)
    if not amount then amount = 1; end
	if self.OCRPData["Inventory"] == nil then return false end
	if amount == nil then amount = 1 end
	if self.OCRPData["Inventory"][item] == nil then return false end
	if self.OCRPData["Inventory"][item] >= amount then
		return true
	end
	return false
end

function EMETA:HasRoom(item,amount)
    if not amount then amount = 1; end
	if self.OCRPData["Inventory"] == nil then return false end
    if self.OCRPData["Inventory"].WeightData == nil then return true end -- inventory but no weight? sounds like unlimited space to me
	if amount == nil then amount = 1 end
	if (self.OCRPData["Inventory"].WeightData.Cur + (GAMEMODE.OCRP_Items[item].Weight * amount)) <= self.OCRPData["Inventory"].WeightData.Max then
		return true
	end
	return false
end

function PMETA:UpdateAmmoCount()
	self:StripAmmo()
	for item,amount in pairs(self.OCRPData["Inventory"]) do
		if item != "WeightData" && amount > 0 then
			if GAMEMODE.OCRP_Items[item].AmmoType != nil then
				self:GiveAmmo( amount, GAMEMODE.OCRP_Items[item].AmmoType,true )
			end
		end
	end
end

function PMETA:ExceedsMax(item, amount, maximum)
    amount = amount or 1
    maximum = maximum or GAMEMODE.OCRP_Items[item].Max
	local amt = self.OCRPData["Inventory"][item] or 0
    if maximum then
        if amt + amount > maximum then
            return true
        end
    end
	return false
end

net.Receive("OCRP_DepositItem", function(len, ply)
    local item = net.ReadString()
    local entindex = net.ReadInt(32)
    local depositingIn = ents.GetByIndex(entindex)
    if not depositingIn or not depositingIn:IsValid() then return end
    if depositingIn:GetPos():Distance(ply:GetPos()) > 250 then
        ply:Hint("You are too far away to deposit!")
        return
    end
    if not depositingIn.OCRPData or not depositingIn.OCRPData["Inventory"] then return end
    if not depositingIn:HasRoom(item, 1) then
        ply:Hint("This container can't fit that item!")
        return
    end
    depositingIn:Inv_GiveItem(item, 1)
    ply:Inv_RemoveItem(item, 1)
    local amountLeft = depositingIn.OCRPData["Inventory"][item] or 0
    local plyAmountLeft = ply.OCRPData["Inventory"][item] or 0
    ply:UpdateObjectItem(depositingIn, item)
    ply:UpdateItem(item)
end)

net.Receive("OCRP_WithdrawItem", function(len, ply)
    local item = net.ReadString()
	local entindex = net.ReadInt(32)
    local depositingIn = ents.GetByIndex(entindex)
    if not depositingIn or not depositingIn:IsValid() then return end
    if depositingIn:GetPos():Distance(ply:GetPos()) > 250 then
        ply:Hint("You are too far away to withdraw!")
        return
    end
    if not depositingIn.OCRPData or not depositingIn.OCRPData["Inventory"] then return end
    if not ply:HasRoom(item, 1) then
        ply:Hint("You don't have space for that item!")
        return
    end
    depositingIn:Inv_RemoveItem(item, 1)
    ply:Inv_GiveItem(item, 1)
    local amountLeft = depositingIn.OCRPData["Inventory"][item] or 0
    local plyAmountLeft = ply.OCRPData["Inventory"][item] or 0
    ply:UpdateObjectItem(depositingIn, item)
    ply:UpdateItem(item)
end)