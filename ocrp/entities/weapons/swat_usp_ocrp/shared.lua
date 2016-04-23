if (CLIENT) then
	SWEP.PrintName			= "USP"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.IconLetter			= "u"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false	
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("swat_usp_ocrp","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_ocrp"

SWEP.ViewModelFOV		= 72
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"

SWEP.HoldType 			= "pistol"

SWEP.Peircing = 3

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_usp.Single")
SWEP.Primary.Recoil			= .3
SWEP.Primary.Damage			= 23
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= 15
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= 0 
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "StriderMinigun"

SWEP.SightsPos = Vector (2.2076, 0, 0.2799)
SWEP.SightsAng = Vector (0, 0, 0)

SWEP.IronSightsPos = Vector (4.5292, -2.1494, 2.6628)
SWEP.IronSightsAng = Vector (0, 0, 0)



