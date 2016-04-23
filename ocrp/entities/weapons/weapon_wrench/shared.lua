if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.PrintName = "Repair Wrench"
SWEP.Author = "::Frosty" 
SWEP.Instructions = "Click To Repair A Vehicle"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ViewModel = "models/weapons/v_wrench.mdl";
SWEP.WorldModel = "models/weapons/w_wrench.mdl";

function SWEP:Initialize()
	self:SetHoldType("melee")
	self.worn = math.random(3,5)
	if self.Owner:IsNPC() then
		self:SetHoldType("normal")
	end
end

function SWEP:CanPrimaryAttack ( ) return true; end

function SWEP:PrimaryAttack()	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Weapon:EmitSound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav")
	
	self.Weapon:SetNextPrimaryFire(CurTime() + 5)
	self.Weapon:SetNextSecondaryFire(CurTime() + 5)
	
	local EyeTrace = self.Owner:GetEyeTrace();
	
	local Distance = self.Owner:EyePos():Distance(EyeTrace.HitPos);
	if Distance > 75 then return false; end
	
	if EyeTrace.MatType == MAT_GLASS then
		self.Weapon:EmitSound("physics/glass/glass_cup_break" .. math.random(1, 2) .. ".wav");
		return false;
	end
	
	if EyeTrace.HitWorld then
		self.Weapon:EmitSound("physics/metal/metal_canister_impact_hard" .. math.random(1, 3) .. ".wav");
		
		util.Decal('Impact.Metal', EyeTrace.HitPos + EyeTrace.HitNormal, EyeTrace.HitPos - EyeTrace.HitNormal);
		return false;
	end
	
	if !EyeTrace.Entity or !EyeTrace.Entity:IsValid() or !EyeTrace.HitNonWorld then return false; end
	
	if EyeTrace.MatType == MAT_FLESH then
		// probably another person or NPC
		self.Weapon:EmitSound("physics/flesh/flesh_impact_hard" .. math.random(1, 6) .. ".wav")
		
		local OurEffect = EffectData();
		OurEffect:SetOrigin(EyeTrace.HitPos);
		util.Effect("BloodImpact", OurEffect);
		
		if SERVER then
			if EyeTrace.Entity:IsPlayer() then
				EyeTrace.Entity:TakeDamage(10, self.Owner, self.Weapon);
			end
		end
		
		return false;
	elseif EyeTrace.Entity:GetClass() == "prop_vehicle_jeep" then
		self.Weapon:EmitSound("physics/metal/metal_canister_impact_hard" .. math.random(1, 3) .. ".wav")
		if SERVER then
			OCRP_FixCar( self.Owner, EyeTrace.Entity )
		end
	end
end

function SWEP:SecondaryAttack()
	--self:PrimaryAttack()
end

function SWEP:EmptyClip()
	if SERVER then
		self.Owner:Hint("Holstering wrench; this will take 5 seconds.")
		timer.Simple(5,function() 
			if !self.Owner:IsValid() then return end
			if self.Owner:HasWeapon("weapon_wrench") && self.Owner:GetActiveWeapon():GetClass() == "weapon_wrench" then 
				if self.Owner:IsPlayer() then
					self.Owner:GiveItem("item_wrench",1) 
					self.Owner:StripWeapon("weapon_wrench") 
				end
			end 
		end)
	end
end

