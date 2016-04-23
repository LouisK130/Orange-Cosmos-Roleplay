include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:Draw()
	self.Entity:DrawModel()
end

function CL_CreateWeed( umsg )
	local entity = umsg:ReadEntity()
	if entity.WeedObj != nil && entity.WeedObj:IsValid() then
		entity.WeedObj:Remove() 
		entity.WeedObj = nil 
	end
	entity.WeedObj = ents.CreateClientProp("prop_physics") 
	entity.WeedObj:SetModel("models/props_foliage/spikeplant01.mdl")
	entity.WeedObj:SetParent(entity)
	entity.WeedObj:SetPos(entity:GetPos() + entity:GetAngles():Up() * 20)
	entity.WeedObj:SetAngles(entity:GetAngles())
	entity.WeedObj:Spawn()
    entity.WeedObj:SetModelScale(.3, 0)
	timer.Simple(math.random(30,60),function() if entity.WeedObj != nil && entity.WeedObj:IsValid() then entity.WeedObj:Grow() end end )
end
usermessage.Hook('OCRP_CreateWeed', CL_CreateWeed);

function CL_UpdateWeed( umsg )
	local entity = umsg:ReadEntity()
	local ready = umsg:ReadBool()
	
	if ready && entity.WeedObj != nil && entity.WeedObj:IsValid() then 
		entity.WeedObj:SetColor(Color(150,255,150,255))
		entity.WeedObj.Ready = true
	end
end
usermessage.Hook('OCRP_UpdateWeed', CL_UpdateWeed);


function CL_RemoveWeed( umsg )
	local entity = umsg:ReadEntity()
	if entity.WeedObj != nil && entity.WeedObj:IsValid() then 
		entity.WeedObj:SetColor(Color(255,255,255,255))
		entity.WeedObj:Remove()
	end
end
usermessage.Hook('OCRP_RemoveWeed', CL_RemoveWeed);

function META:Grow()
	for _,ply in pairs(player.GetAll()) do
		if self:GetPos():Distance(ply:GetPos()) < 200 then
			if ply.Stank == nil then
				ply.Stank = {Level = 1,}
			else
				ply.Stank.Level = ply.Stank.Level + 1
			end
			timer.Simple(math.random(10,30),function() if ply:IsValid() then ply:EmitScent() end end )
		end
	end
	if self:GetModelScale() <= .8 then -- if it grew every 30 sec for 5 min, it would grow to .8, don't want it to bug and get huge like shitty CG OCRP
		self:SetModelScale(self:GetModelScale() + .05, 0)
		timer.Simple(math.random(30,60),function() if self:IsValid() then self:Grow() end end )
	end
end

function META:EmitScent()
    if self:GetNWBool("AdminMode", false) then return end
	local effectdata = EffectData() 
 		effectdata:SetOrigin( self:LocalToWorld( Vector(0,0,self:OBBMins().z) ) ) 
 		effectdata:SetAngles(Angle(0,0,0)) 
 		effectdata:SetScale( .9 ) 

	self.SmokeTimer = self.SmokeTimer or 0

	if ( self.SmokeTimer > CurTime() ) then return end
	
	self.SmokeTimer = CurTime() + 0.0001

	local vOffset = self:LocalToWorld( Vector(0,0,self:OBBMins().z) )

	local vNormal = (vOffset - self:OBBCenter()):GetNormalized()

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
	
	self.Stank.Level = self.Stank.Level - 1
	if self.Stank.Level > 0 then
		timer.Simple(math.random(10,30),function() if self:IsValid() && self.Stank.Level > 0 then self:EmitScent() end end )
	end
end
