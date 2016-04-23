AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/weapons/w_snowball_thrown.mdl");
	self.Entity:PhysicsInit(SOLID_VPHYSICS);
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
	self.Entity:SetSolid(SOLID_VPHYSICS);
	self.Entity:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableGravity(true);
	end
	//self.Trail = util.SpriteTrail(self.Entity, 0, Color(255,255,255,255), false, 15, 1, 0.2, 1/(15+1)*0.5, "trails/laser.vmt") 
end

function ENT:Think()
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16;
	local ent = ents.Create("ent_snowball");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	ent:SetOwner(ply)
	
	return ent;
end

function ENT:PhysicsCollide(data)
     local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetMass(1)
		end

	local pos = self.Entity:GetPos() --Get the position of the snowball
	local effectdata = EffectData()
	effectdata:SetStart( pos )
	effectdata:SetOrigin( pos )
	effectdata:SetScale( 1 )
	--util.Effect( "HelicopterImpact", effectdata ) -- effect
	self.Entity:EmitSound("physics/body/body_medium_impact_soft" .. math.random(1, 7) .. ".wav", 70, 100 )
	util.Effect( "inflator_magic", effectdata ) -- effect
	util.Effect( "WheelDust", effectdata ) -- effect
	util.Effect( "GlassImpact", effectdata ) -- effect
	self.Entity:Remove(); --Remove the snowball
end 
