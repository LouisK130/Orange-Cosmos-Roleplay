include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:Draw()

end

function ENT:Initialize()
	self:Emit()
	timer.Simple(math.random(10,30),function() if self:IsValid() then self:Emit() end end )
end

function ENT:Emit()
	local effectdata = EffectData() 
 		effectdata:SetOrigin( self.Entity:LocalToWorld( Vector(0,0,self.Entity:OBBMins().z) ) ) 
 		effectdata:SetAngles( self.Entity:GetForward() ) 
 		effectdata:SetScale( .9 ) 

	self.SmokeTimer = self.SmokeTimer or 0

	if ( self.SmokeTimer > CurTime() ) then return end
	
	self.SmokeTimer = CurTime() + 0.0001

	local vOffset = self.Entity:LocalToWorld( Vector(0,0,self.Entity:OBBMins().z) )

	local vNormal = (vOffset - self.Entity:GetPos()):GetNormalized()

	local emitter = ParticleEmitter( vOffset )
	
		local particle = emitter:Add( "particles/smokey", vOffset )
		particle:SetVelocity(VectorRand()*12)
		particle:SetGravity(Vector(5,5,3))
		particle:SetDieTime(math.Rand(2,2.5))
		particle:SetStartAlpha(math.Rand(40,50))
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(9,14))
		particle:SetEndSize(math.Rand(35,45))
		particle:SetRoll(math.Rand(200,300))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(200,255,200)
		particle:SetAirResistance(5)
				
	emitter:Finish()
	timer.Simple(math.random(10,30),function() if self:IsValid() then self:Emit() end end )
end
