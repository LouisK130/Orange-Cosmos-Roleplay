AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	if string.lower(game.GetMap()) == "rp_evocity2_v2p" then
		self:SetModel("models/props_unique/atm01.mdl")
	elseif string.lower(game.GetMap()) == "rp_evocity_v4b1" or string.lower(game.GetMap()) == "rp_evocity_v33x" or string.lower(game.GetMap()) == "rp_evocity_v4b1_d_test" then
		self:SetModel("models/props_unique/atm01.mdl")
	else
		self:SetModel("models/env/misc/bank_atm/bank_atm.mdl")
	end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_FLY)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetKeyValue("disableshadows", "1")
end

function ENT:KeyValue(key,value)
end

function ENT:SetType(strType)
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() &&  !activator.CantUse then
		net.Start("OCRP_Bank")
		net.Send(activator)
		activator.CantUse = true
		timer.Simple(0.3, function()  activator.CantUse = false end)
	end
end