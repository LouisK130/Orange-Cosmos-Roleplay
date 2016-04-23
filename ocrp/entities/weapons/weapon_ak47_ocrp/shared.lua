if (CLIENT) then
	SWEP.PrintName			= "Ak47 rifle"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 0
	SWEP.IconLetter			= "b"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_ak47_ocrp","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_ocrp"

SWEP.ViewModelFOV		= 72
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_ak47.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_Ak47.Single")
SWEP.Primary.Recoil			= 1.0
SWEP.Primary.Damage			= 27
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.07
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.16 
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true 
SWEP.Primary.Ammo			= "ar2"

SWEP.Peircing = 6

SWEP.Assualt = true

SWEP.HoldType 			= "ar2"

SWEP.SightsPos = Vector(2.0174, -1.8695, -0.7269)
SWEP.SightsAng = Vector(0, 0, 0)

SWEP.IronSightsPos = Vector(6.0767, -6.3995, 2.3282)
SWEP.IronSightsAng = Vector(2.815, -0.1889, 0.5205)


