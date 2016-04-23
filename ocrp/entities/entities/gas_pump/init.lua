AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/props_equipment/gas_pump.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_FLY)
	self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
end

function ENT:KeyValue(key,value)
end

function ENT:SetType(strType)
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() &&  !activator.CantUse then
		net.Start("OCRP_Gas_Pump")
		net.Send(activator)
		activator.CantUse = true
		timer.Simple(0.3, function()  activator.CantUse = false end)
	end
end