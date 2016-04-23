AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel(self.Mdl)
	self:SetHealth(100000)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
 
	if phys and phys:IsValid() then
		phys:EnableMotion(false)
	end
end

function ENT:StartTouch(ent) 
end
function ENT:EndTouch(ent)
end
function ENT:AcceptInput(name,activator,caller)
end
function ENT:KeyValue(key,value)
end
function ENT:OnRemove()
end
function ENT:OnRestore()
end
function ENT:PhysicsCollide(data,physobj)
end
function ENT:PhysicsSimulate(phys,deltatime) 
end
function ENT:PhysicsUpdate(phys) 
end
function ENT:Touch(hitEnt) 
end
function ENT:UpdateTransmitState(Entity)
end
function ENT:Use(activator,caller)
	if !activator:IsPlayer() then return end
	activator:Hint( "Happy birthday, Kaz." )
	if activator:HasItem( "item_present_one" ) then
		activator:Hint( "You already have a present!" )
		return false
	end
	activator:GiveItem( "item_present_one" )
	activator:Hint( "Heres a present, enjoy!" )
end

