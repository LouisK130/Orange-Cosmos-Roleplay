if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Fire Axe"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "" 
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = "models/weapons/v_fireaxe.mdl";
SWEP.WorldModel = "models/weapons/w_fireaxe.mdl";

function SWEP:Initialize()
	self:SetHoldType("melee")
end

function SWEP:CanPrimaryAttack ( ) return true; end

function SWEP:PrimaryAttack()	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:EmitSound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav")
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	
	self.Weapon:SetNextPrimaryFire(CurTime() + .5)
	self.Weapon:SetNextSecondaryFire(CurTime() + .5)
	
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
	elseif string.find(EyeTrace.Entity:GetClass(), 'door') then
		self.Weapon:EmitSound("physics/wood/wood_box_impact_hard" .. math.random(1, 3) .. ".wav");
		
		local NearFire = false;
		for k, v in pairs(ents.FindInSphere(EyeTrace.Entity:GetPos(), 500)) do
			if v:GetClass() == 'prop_fire' then
				NearFire = true;
			end
		end
		
		if NearFire then
			EyeTrace.Entity:GetTable().AxeDoorHealth = EyeTrace.Entity:GetTable().AxeDoorHealth or math.random(3, 6);
			EyeTrace.Entity:GetTable().AxeDoorHealth = EyeTrace.Entity:GetTable().AxeDoorHealth - 1;
			
			if EyeTrace.Entity:GetTable().AxeDoorHealth == 0 then
				EyeTrace.Entity:GetTable().AxeDoorHealth = nil;
				
				EyeTrace.Entity:Fire('unlock', '', 0);
				EyeTrace.Entity:Fire('open', '', .5);
			end
		else
			if SERVER then
				self.Owner:Hint("No fire nearby, don't abuse this weapon.");
			end
		end
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack();
end

