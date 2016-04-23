if (CLIENT) then
	SWEP.PrintName			= "P228 Service Issue Pistol"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.IconLetter			= "u"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false	
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_copgun_ocrp","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_ocrp"

SWEP.ViewModelFOV		= 72
SWEP.ViewModelFlip		= true
SWEP.ViewModel			= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_p228.mdl"
SWEP.HoldType 			= "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Peircing = 2

SWEP.Primary.Sound			= Sound("Weapon_P228.Single")
SWEP.Primary.Recoil			= .3
SWEP.Primary.Damage			= 17
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.06
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.15
SWEP.Primary.DefaultClip	= 0 
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "StriderMinigun"

SWEP.SightsPos = Vector (2.2076, 0, 0.2799)
SWEP.SightsAng = Vector (0, 0, 0)

SWEP.IronSightsPos = Vector (4.7687, -2.6132, 2.7894)
SWEP.IronSightsAng = Vector (0, 0, 0)


