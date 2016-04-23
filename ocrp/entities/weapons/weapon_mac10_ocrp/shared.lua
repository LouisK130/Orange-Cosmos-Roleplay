if (CLIENT) then
	SWEP.PrintName			= "MAC-10 SMG"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 0
	SWEP.IconLetter			= "d"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_mp5_ocrp","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_ocrp"

SWEP.ViewModelFOV		= 72
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mac10.mdl"

SWEP.HoldType = "smg"

SWEP.Peircing = 3

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_Mac10.Single")
SWEP.Primary.Recoil			= .6
SWEP.Primary.Delay			= 0.06
SWEP.Primary.Damage			= 23
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.08
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true 
SWEP.Primary.Ammo			= "SMG1"

SWEP.Assualt = true

SWEP.SightsPos = Vector (5.5851, 1.2612, -0.4635)
SWEP.SightsAng = Vector (-0.382, 7.5612, 7.1634)

SWEP.IronSightsPos = Vector (6.4857, -5.1825, 2.8605)
SWEP.IronSightsAng = Vector (1.0528, 5.3537, 6.88)



