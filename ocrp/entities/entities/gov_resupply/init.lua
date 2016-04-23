AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
util.AddNetworkString("OCRP_ShowPoliceResupply")
util.AddNetworkString("OCRP_WithdrawPoliceItem")

function ENT:Initialize()
	local angles = self:GetAngles()
	local newangles = angles
	self:SetAngles(Angle(0,0,0))
	self:SetModel("models/props_lab/lockers.mdl")
	self:PhysicsInit(0)
	self:SetMoveType(0)
	self:SetSolid(SOLID_VPHYSICS)
	self.LockerDoor1 = ents.Create("prop_physics")
	self.LockerDoor1:SetParent(self)
	self.LockerDoor1:SetModel("models/props_lab/lockerdoorleft.mdl")
	self.LockerDoor1:SetPos(self:GetPos() + Vector(10,0,38))
	self.LockerDoor1:SetKeyValue( "spawnflags", 8)
	self.LockerDoor1:Spawn()
	self.LockerDoor1:SetMoveType(0)
	self.LockerDoor1:SetSolid(0)
	self.LockerDoor1:SetCollisionGroup(0)
	self.LockerDoor2 = ents.Create("prop_physics")
	self.LockerDoor2:SetParent(self)
	self.LockerDoor2:SetModel("models/props_lab/lockerdoorleft.mdl")
	self.LockerDoor2:SetPos(self:GetPos() + Vector(10,-15,38))
	self.LockerDoor2:SetKeyValue( "spawnflags", 8)
	self.LockerDoor2:Spawn()
	self.LockerDoor2:SetCollisionGroup(0)
	self.LockerDoor2:SetMoveType(0)
	self.LockerDoor2:SetSolid(0)
	self.LockerDoor3 = ents.Create("prop_physics")
	self.LockerDoor3:SetParent(self)
	self.LockerDoor3:SetKeyValue( "spawnflags", 8)
	self.LockerDoor3:SetModel("models/props_lab/lockerdoorsingle.mdl")
	self.LockerDoor3:SetPos(self:GetPos() + Vector(10,16,38))
	self.LockerDoor3:Spawn()
	self.LockerDoor3:SetMoveType(0)
	self.LockerDoor3:SetCollisionGroup(0)
	self.LockerDoor3:SetSolid(0)
	self:SetAngles(newangles)
    self.items = {}
    self.items["item_ammo_cop"] = 32
    self.items["item_ammo_riot"] = 8
    self.items["item_ammo_ump"] = 25
    self.items["item_shotgun_cop"] = 1
end

function ENT:KeyValue(key,value)
end

function ENT:SetType(strType)
end

function ENT:SetAmount(varAmount)
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() && !activator.CantUse then
		activator:Resupply()
		activator.CantUse = true
		timer.Simple(0.3, function() activator.CantUse = false end)
		if activator:Team() == CLASS_POLICE || activator:Team() == CLASS_CHIEF || activator:Team() == CLASS_SWAT  then
			net.Start("OCRP_ShowPoliceResupply")
            net.WriteTable(self.items)
            net.Send(activator)
		end
	end
end

net.Receive("OCRP_WithdrawPoliceItem", function(len, ply)
    if ply:Team() != CLASS_POLICE and ply:Team() != CLASS_CHIEF and ply:Team() != CLASS_SWAT then return end
    local item = net.ReadString()
    if not ply:HasRoom(item, 1) then
        ply:Hint("You don't have room for this!")
        return
    elseif ply:ExceedsMax(item, 1) then
        ply:Hint("You can't carry any more of this item!")
        return
    end
    for k,v in pairs(ents.FindByClass("gov_resupply")) do
        if v:GetPos():Distance(ply:GetPos()) < 150 then
            if v.items[item] >= 1 then
                v.items[item] = v.items[item] - 1
                ply:GiveItem(item, 1)
                net.Start("OCRP_WithdrawPoliceItem")
                net.WriteTable(v.items)
                net.Send(ply)
            end
        end
    end
end)