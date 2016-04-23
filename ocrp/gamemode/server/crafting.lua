
function GM:ShowSpare1( ply )
	local tr = ply:GetEyeTrace()
	if tr.HitNonWorld then
		if tr.Entity:GetClass() == "prop_ragdoll" && tr.Entity.player != nil && tr.Entity:GetPos():Distance(ply:GetPos()) <= 100 then
			if ply:Team() == CLASS_CITIZEN && tr.Entity.player:IsValid() && tr.Entity.player:Team() == CLASS_CITIZEN then	
				if ply:HasSkill("skill_loot",1) then
					if tr.Entity.Lootable then
                        ply.LootingEntity = tr.Entity
						net.Start("OCRP_Loot")
                        net.WriteTable(tr.Entity.player.OCRPData["Inventory"])
						net.Send(ply)
						return false
					end
				else
                    ply:Hint("You don't have any looting skill.")
                end
			end
		end
	end
	net.Start("OCRP_CraftingMenu")
	net.Send(ply)
end

function Craft_CraftItem(ply,recipe)
    local craftTable = GAMEMODE.OCRP_Recipies[recipe]
    if ply.LastCraft then
        if CurTime() < ply.LastCraft + (craftTable.Time or 2) then return end
    end
    if not craftTable then return end
    for k,v in pairs(craftTable.Skills) do
        if v <= 0 then continue end
        if not ply:HasSkill(k, v) then return end
    end
    for k,v in pairs(craftTable.Requirements) do
        if v.Amount <= 0 then continue end
        if not ply:HasItem(v.Item, v.Amount) then return end
    end
    if craftTable.HeatSource then
        local tr = ply:GetEyeTrace()
        if not tr.Entity or not tr.Entity:GetClass() == "item_base" or not tr.Entity:GetNWString("Class") == "item_furnace" then
            return
        end
    end
    if craftTable.WaterSource then
        local tr = ply:GetEyeTrace()
        if not tr.Entity or not tr.Entity:GetClass() == "item_base" or not tr.Entity:GetNWString("Class") == "item_sink" then
            return
        end
    end
    if not ply:HasRoom(craftTable.Item, craftTable.Amount) or ply:ExceedsMax(craftTable.Item, craftTable.Amount) then
        return
    end
    
    for k,v in pairs(craftTable.Requirements) do
        ply:RemoveItem(v.Item, v.Amount)
    end
    ply:GiveItem(craftTable.Item, craftTable.Amount or 1)
    ply:Hint("You crafted " .. tonumber(craftTable.Amount or 1) .. " " .. GAMEMODE.OCRP_Items[craftTable.Item].Name)
    ply.LastCraft = CurTime()
end

util.AddNetworkString("CraftItem")
net.Receive("CraftItem", function(len, ply)
	Craft_CraftItem(ply, net.ReadInt(32))
end)