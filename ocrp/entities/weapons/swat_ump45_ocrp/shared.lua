if (CLIENT) then
	SWEP.PrintName			= "UMP45"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "q"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("swat_ump45_ocrp","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_ocrp"

SWEP.ViewModelFOV		= 72
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_ump45.mdl"

SWEP.HoldType = "smg"

SWEP.Peircing = 5

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.ReloadSpeed = 2.9

SWEP.Primary.Sound			= Sound("Weapon_UMP45.Single")
SWEP.Primary.Recoil			= .5
SWEP.Primary.Delay			= 0.08
SWEP.Primary.Damage			= 21
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true 
SWEP.Primary.Ammo			= "CombineCannon"

SWEP.Assualt = true

SWEP.SightsPos = Vector (1.825, -0.5372, -0.471)
SWEP.SightsAng = Vector (0, 0, 0)

SWEP.IronSightsPos = Vector (7.3105, -4.3257, 3.1677)
SWEP.IronSightsAng = Vector (-1.132, 0.2334, 2.1047)




