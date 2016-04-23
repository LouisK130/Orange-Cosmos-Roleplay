if (SERVER) then
	AddCSLuaFile("shared.lua")
end
if (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.ViewModelFOV		= 64
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "Health Kit"			
	SWEP.Author				= "Jake_1305"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
end
SWEP.Author			= "Jake_1305"

SWEP.HoldType = "normal"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel = "models/weapons/v_healthkit.mdl"
SWEP.WorldModel = ""

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 1.0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0

SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:Reload()
end

function SWEP:Think()
end
	
function SWEP:PrimaryAttack(selfuse)
	self.Weapon:SetNextPrimaryFire(CurTime() + 7)
	self.Weapon:SetNextSecondaryFire(CurTime() + 7) 
	
	local tr = self.Owner:GetEyeTrace()
    if selfuse then
        tr.Entity = self.Owner
    end
	local health = tr.Entity:Health()
	
	if !tr.Entity or !tr.Entity:IsPlayer() then return false end
		if SERVER then
			if tr.Entity.Inhibitors.ForceWalk then
				tr.Entity.Inhibitors.ForceWalk = false
				umsg.Start("inhib_forcewalk", tr.Entity)
					umsg.Bool(false)
				umsg.End()
				tr.Entity:SetRunSpeed(tr.Entity.Speeds.Sprint)
				tr.Entity:Hint("Your leg has been tended to, and has healed")
			end
			if tr.Entity.Inhibitors.BrokenArm then				
				tr.Entity.Inhibitors.BrokenArm = false
				tr.Entity:Hint("Your arm has been tended to, and has healed")
			end

			for _,wound in pairs(tr.Entity.Wounds) do
				if wound:IsValid() then
					wound:Remove()
				end
			end
		end
	if health >= 100 then return false end
	
	tr.Entity:SetHealth(math.Clamp(tr.Entity:Health() + 40, 0, 100));
	tr.Entity:EmitSound("items/smallmedkit1.wav",60,100) 
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack(true)
end


if CLIENT then
	function SWEP:DrawWorldModel()
	end
end
