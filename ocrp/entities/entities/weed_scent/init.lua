AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("")
	self:SetNoDraw(false)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_FLY)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(0)	
	self:DrawShadow( false )
end

function ENT:OnTakeDamage(dmg)
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

function ENT:Think() 
end

function ENT:Touch(hitEnt) 
end

function ENT:UpdateTransmitState(Entity)
end

function ENT:Use(activator,caller)
end

