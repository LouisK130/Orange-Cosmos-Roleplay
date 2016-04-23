util.AddNetworkString("OCRP_UpdateLootingTable")

sound.Add( {
    name = "OCRP_LootingSound",
    channel = CHAN_BODY,
    volume = .1,
    pitch = {95, 110},
    sound = "physics/body/body_medium_scrape_rough_loop1.wav"
} )

function PMETA:LootItem(item)
    self:StopSound("OCRP_LootingSound")
    local target = self.LootingEntity
    if not target or not target:IsValid() or not target.Lootable then return end
    if not target.player or not target.player:IsValid() or target.player:Alive() then return end
    if not self:HasSkill("skill_loot", GAMEMODE.OCRP_Items[item].LootData.Level) then return end
    if not target.player:HasItem(item, 1) then return end
    local chance = math.random(1,2)
    if chance == 2 then self:Hint("Looting failed.") return end
    target.player:RemoveItem(item, 1)
    
    local DropedEnt = nil
    if item == "item_radio" then
        DropedEnt = ents.Create("ocrp_radio")
    else
        DropedEnt = ents.Create("item_base")
    end
    
	DropedEnt:SetNWString("Class", item)
	DropedEnt:SetNWInt("Owner",self:EntIndex())
	DropedEnt.Amount = 1
	DropedEnt:SetPos(target:GetPos() + Vector(0,0,30))
	DropedEnt:SetAngles(Angle(0,self:EyeAngles().y ,0))
	DropedEnt:Spawn()
	if DropedEnt:GetPhysicsObject():IsValid() then
		DropedEnt:GetPhysicsObject():ApplyForceCenter(self:GetAimVector() * 120)
	end
    self:StoreItem(item, 1)
    
    SV_PrintToAdmin(self, "LOOT-ITEM", "looted 1 " .. item .. " from " .. target.player:Nick() .. "'s body.")
    self:Hint("Successfully looted 1 " .. GAMEMODE.OCRP_Items[item].Name)
    net.Start("OCRP_UpdateLootingTable")
    net.WriteTable(target.player.OCRPData["Inventory"])
    net.Send(self)
end
net.Receive("OCRP_LootItem", function(len, ply)
    ply.NextLoot = ply.NextLoot or CurTime()
    if CurTime() < ply.NextLoot then return end
    local item = net.ReadString()
    ply.NextLoot = CurTime() + (GAMEMODE.OCRP_Items[item].LootData.Time or 2)
	ply:LootItem(item)
end)

net.Receive("OCRP_BeginLooting", function(len, ply)
    ply:EmitSound("OCRP_LootingSound", 40, 100)
end)
