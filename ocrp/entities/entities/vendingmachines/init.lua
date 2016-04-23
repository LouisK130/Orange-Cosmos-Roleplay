AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props/cs_office/vending_machine.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.OwnerType = "Mayor"
end

function ENT:KeyValue(key,value)
end

function ENT:SetType(strType)
end

function ENT:Use(ply, caller)
	if ply:IsPlayer() && !ply.CantUse then
        net.Start("OCRP_CreateChat")
        net.WriteString("30")
        net.WriteInt(1, 2)
        net.WriteString(tr.Entity:GetModel())
        net.Send(ply)				
		ply.CantUse = true
		timer.Simple(0.3, function() ply.CantUse = false end)
	end
end
