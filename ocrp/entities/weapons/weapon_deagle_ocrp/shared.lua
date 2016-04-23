if (CLIENT) then
	SWEP.PrintName			= "Desert Eagle"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.IconLetter			= "f"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false	
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_deagle_ocrp","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_ocrp"

SWEP.ViewModelFOV		= 72
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"
SWEP.HoldType 			= "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Peircing = 3

SWEP.Primary.Sound			= Sound("Weapon_DEagle.Single")
SWEP.Primary.Recoil			= .7
SWEP.Primary.Damage			= 19
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.07
SWEP.Primary.ClipSize		= 7
SWEP.Primary.Delay			= 0.23
SWEP.Primary.DefaultClip	= 0 
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.SightsPos = Vector (3.6198, 0, 0.6007)
SWEP.SightsAng = Vector (0, 0, 0)

SWEP.IronSightsPos = Vector (5.1676, -0.2058, 2.7344)
SWEP.IronSightsAng = Vector (0, 0, 0)



