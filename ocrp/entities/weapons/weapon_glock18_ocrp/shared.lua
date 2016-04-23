if (CLIENT) then
	SWEP.PrintName			= "Glock-18"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "c"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false	
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_glock18_ocrp","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_ocrp"

SWEP.ViewModelFOV		= 72
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_glock18.mdl"
SWEP.HoldType 			= "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Peircing = 1

SWEP.Primary.Sound			= Sound("Weapon_Glock.Single")
SWEP.Primary.Recoil			= .4
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.08
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= 0 
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.SightsPos = Vector (2.4479, 0, 0.002)
SWEP.SightsAng = Vector (0, 0, 0)

SWEP.IronSightsPos = Vector (4.3618, -1.0694, 2.9739)
SWEP.IronSightsAng = Vector (0, 0, 0)





