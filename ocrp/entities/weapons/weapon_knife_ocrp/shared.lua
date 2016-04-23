
if SERVER then
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	AddCSLuaFile( "shared.lua" )
	
end
if CLIENT then
	SWEP.PrintName			= "knife"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 0
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.DrawWeaponInfoBox	= false
	SWEP.BounceWeaponIcon   = false
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	SWEP.IconLetter			= "j"
	surface.CreateFont("CSSelectIcons", {
        font="csd",
        size=ScreenScale(60),
        weight=500,
        antialias=true,
        shadow=true
    })
end

SWEP.ViewModelFOV	= 62
SWEP.ViewModel		= "models/weapons/v_knife_t.mdl"
SWEP.WorldModel		= "models/weapons/w_knife_t.mdl" 

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Range			= 90
SWEP.Primary.Recoil			= 4.6
SWEP.Primary.Delay			= 1
SWEP.Primary.Damage			= 20
SWEP.Primary.Cone			= 0.02
SWEP.Primary.NumShots		= 1

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false	
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Swing = Sound("weapons/knife/knife_slash1.wav")
SWEP.HitSound = Sound("weapons/knife/knife_hitwall1.wav")
SWEP.DeploySound = Sound("weapons/knife/knife_deploy1.wav")
SWEP.FleshHitSounds = {
"weapons/knife/knife_hit1.wav",
"weapons/knife/knife_hit2.wav",
"weapons/knife/knife_hit3.wav",
"weapons/knife/knife_hit4.wav"
}

function SWEP:Initialize()
	self:SetHoldType("melee")
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
end 

function SWEP:Deploy()
	self.Weapon:EmitSound(self.DeploySound,100,math.random(90,120))
	return true
end

function SWEP:Holster(wep)
    return true
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
 	local trace = util.GetPlayerTrace(self.Owner)
 	local tr = util.TraceLine(trace)
	
	//self.Weapon:EmitSound("weapons/knife/knife_slash1.wav",100,math.random(90,120))
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if (self.Owner:GetPos() - tr.HitPos):Length() < self.Primary.Range then
		self.Owner:ViewPunch(Angle(math.Rand(-3,3) * self.Primary.Recoil,math.Rand(-3,3) * self.Primary.Recoil,0))
		if tr.HitNonWorld then
			if SERVER then 
				if tr.Entity:IsPlayer() then
						local dmg = self.Primary.Damage
						if self.Owner:HasSkill("skill_str",1) then
							dmg = dmg * 1.25
							if self.Owner:HasSkill("skill_str",3) then
								dmg = dmg * 1.25
							end
						end
						tr.Entity:TakeDamage(dmg,self.Owner) 
				elseif tr.Entity:GetClass() != "prop_vehicle_jeep" && !tr.Entity:IsNPC() then
					tr.Entity:TakeDamage(5,self.Owner) 
				end
			end				

			if tr.Entity:IsPlayer() then
				self.Weapon:EmitSound(self.FleshHitSounds[1],100,math.random(95,110))
				util.Decal("Blood",tr.HitPos + tr.HitNormal,tr.HitPos - tr.HitNormal)
				if SERVER then self:SpawnBlood(tr) end
			elseif tr.Entity:GetClass() != "prop_vehicle_jeep" && !tr.Entity:IsNPC()  then
				self.Weapon:EmitSound(self.HitSound,100,math.random(95,110))
				local phys = tr.Entity:GetPhysicsObject()
				if phys && phys:IsValid() then
					phys:ApplyForceCenter(self.Owner:GetAimVector() * 120)
				end
			end
		else
			self.Weapon:EmitSound(self.HitSound,100,math.random(95,110))
			util.Decal("ManhackCut",tr.HitPos + tr.HitNormal,tr.HitPos - tr.HitNormal)
		end
	end
end

function SWEP:SpawnBlood(tr)
	local effectdata = EffectData()
	effectdata:SetOrigin(tr.HitPos)
	effectdata:SetNormal(tr.HitNormal)
	util.Effect("bodyshot", effectdata)
	util.Decal("Blood",tr.HitPos + tr.HitNormal,tr.HitPos - tr.HitNormal)
end

function SWEP:DrawWeaponSelection(x,y,wide,tall,alpha)
	draw.SimpleText(self.IconLetter,"CSSelectIcons",x + wide/2,y + tall*0.2,Color(255,210,0,255),TEXT_ALIGN_CENTER) 
	draw.SimpleText(self.IconLetter,"CSSelectIcons",x + wide/2 + math.Rand(-4,4),y + tall*0.2 + math.Rand(-12,12),Color(255,210,0,math.Rand(10,80)),TEXT_ALIGN_CENTER) 
	draw.SimpleText(self.IconLetter,"CSSelectIcons",x + wide/2 + math.Rand(-4,4),y + tall*0.2 + math.Rand(-9,9),Color(255,210,0,math.Rand(10,80)),TEXT_ALIGN_CENTER) 
end

