AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua") 
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_c17/pottery09a.mdl")
	self:PhysicsInit(SOLID_BBOX)
	self:SetMoveType(0)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
end

function ENT:KeyValue(key,value)
end

function ENT:SetType(strType)
end


function ENT:Use(activator, caller)
	print(self.Car)
	umsg.Start("store_buycar", activator)
		umsg.String(self.Car)
	umsg.End()
end

