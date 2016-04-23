if (CLIENT) then
	SWEP.PrintName			= "M4 rifle"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 0
	SWEP.IconLetter			= "w"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_m4_ocrp","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")

end

SWEP.Base				= "weapon_basegun_ocrp"

SWEP.HoldType 			= "ar2"

SWEP.ViewModelFOV		= 72
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_m4a1.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Peircing = 6

SWEP.Primary.Sound			= Sound("Weapon_M4A1.Single")
SWEP.Primary.Recoil			= .8
SWEP.Primary.Damage			= 24
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.08 
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true 
SWEP.Primary.Ammo			= "ar2"

SWEP.Assualt = true

SWEP.SightsPos = Vector (2.568, 0, -1.2626)
SWEP.SightsAng = Vector (0, 0, 4.4562)

SWEP.IronSightsPos = Vector (5.8817, -5.1431, 1.3028)
SWEP.IronSightsAng = Vector (2.6006, 1.192, 2.63)




