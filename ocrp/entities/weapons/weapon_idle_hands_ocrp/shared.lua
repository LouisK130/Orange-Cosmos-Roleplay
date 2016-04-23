
if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
end

if ( CLIENT ) then
	SWEP.ViewModelFOV		= 62
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1

	SWEP.PrintName			= "Hands"			
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

end


SWEP.Weight = 5;
SWEP.AutoSwitchTo = true;
SWEP.AutoSwitchFrom = true; 
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true
SWEP.Instructions		= "Use these for regular activities such as walking around, NOT keys."
SWEP.UseHands			= false

SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			=.7
SWEP.Primary.Range = 80
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.HoldType = "normal"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

--SWEP.ViewModel = "models/weapons/v_fists.mdl"
SWEP.ViewModel = "models/ocrp2players/weapons/v_fists.mdl"
SWEP.WorldModel = ""
SWEP.Assault = false


function SWEP:Initialize()
	self:SetHoldType("normal")
	self.Hidden = true
	if SERVER then
		self:DrawShadow( false )
	end
	if CLIENT then
	--	self.Weapon:DrawModel(false)
	end
end 

function SWEP:Deploy()
	--self.Weapon:EmitSound(self.DeploySound,100,math.random(90,120))
	self.Hidden = true
	if SERVER then
		self:DrawShadow( false )
		if self.Owner:Alive() then
			timer.Simple(0.1,function() 
                if self:IsValid() and self.Owner:IsValid() then
                    self.Owner:DrawViewModel(false)
                end
           end)
		end
	end
	return true
end

function SWEP:Holster(wep)
	return true
end

function SWEP:Reload()
	if self.Owner:GetNWInt("Energy") >= 1 then
        
	end
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	if self.Owner:GetNWBool("Handcuffed") then return end
	if not IsFirstTimePredicted() then return end
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	if !self.Hidden then 
		self.HoldType = "normal"
		timer.Simple(0.25,function()  self:SetHoldType(self.HoldType) end)
		if SERVER then
			self.Owner:DrawViewModel(false)
		end
		self.Hidden = true
		return 
	else
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
		self.HoldType = "melee" 
		timer.Simple(0.25,function() self:SetHoldType(self.HoldType) end)
		if SERVER then
			self.Owner:DrawViewModel(true)
		end
		self.Hidden = false
		return 
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if self.Owner:GetNWBool("Handcuffed") then return end
	if not IsFirstTimePredicted() then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
 	local trace = util.GetPlayerTrace(self.Owner)
 	local tr = util.TraceLine(trace)
	local EyeTrace = self.Owner:GetEyeTrace();

	if !self.Hidden then
		if self.Owner:GetNWInt("Energy") < 3 then return end
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self.Weapon:EmitSound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav");
		if SERVER then
			self.Owner:SetNWInt("Energy",self.Owner:GetNWInt("Energy") - 3)
		end
		if (self.Owner:GetPos() - tr.HitPos):Length() <= self.Primary.Range then
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
					end
				end				
				if tr.Entity:IsPlayer() then
					self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random(1, 5) .. ".wav")
					util.Decal("Blood",tr.HitPos + tr.HitNormal,tr.HitPos - tr.HitNormal)
					if SERVER then self:SpawnBlood(tr) end
				end
			elseif EyeTrace.HitWorld then
					self.Weapon:EmitSound("physics/flesh/flesh_impact_hard" .. math.random(1, 5) .. ".wav");
		
					return false;
			end
		end
	else
		if (self.Owner:GetPos() - tr.HitPos):Length() <= self.Primary.Range then
			if tr.HitNonWorld then
				if SERVER then 
					if tr.Entity:IsDoor() then
						tr.Entity:EmitSound("physics/wood/wood_crate_impact_hard3.wav",100,math.random(95,110))
					elseif tr.Entity:IsPlayer() then
						tr.Entity:SetVelocity(self.Owner:EyeAngles():Forward() * 200 + self.Owner:EyeAngles():Up() * 40 )
						tr.Entity:ViewPunch(Angle(math.Rand(-3,3) * self.Primary.Recoil,math.Rand(-3,3) * self.Primary.Recoil,0))
					end
				end				
			end
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

function SWEP:DrawWorldModel()
end
