if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.HoldType			= "melee"
	SWEP.IconLetter			= "I"
end
if (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.ViewModelFOV		= 64
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "Ent Index"			
	SWEP.Author				= "Noobulater"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "C"
end
SWEP.Author			= "Noobulater"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 1.0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay			= 5.0

SWEP.Time = 0

function SWEP:Initialize()
	if (SERVER) then
		self:SetHoldType(self.HoldType)
	end
end

function SWEP:Deploy()
end

function SWEP:Reload()
	if ( self.Time > CurTime() ) then return end
	local tr = self.Owner:GetEyeTrace()
	local Vect = tr.HitPos
	local Ang = tr.Entity:GetAngles()
	print("")
	Msg("{Position = Vector("..math.Round(Vect.x)..","..math.Round(Vect.y)..","..math.Round(Vect.z).."), Ang = Angle("..math.Round(Ang.p)..","..math.Round(Ang.y)..","..math.Round(Ang.r)..")},")
	self.Time = CurTime() + 0.3
end

function SWEP:Think()
end
	
function SWEP:PrimaryAttack()
	if ( self.Time > CurTime() ) then return end
	local tr = self.Owner:GetEyeTrace()
	print(tr.HitPos)
	if tr.Entity then
		print(tr.Entity:EntIndex())
		print(tr.Entity)
		print(tr.Entity:GetPos())
	end
	self.Time = CurTime() + 0.3
end

function SWEP:SecondaryAttack()
	local tr = self.Owner:GetEyeTrace()
	if ( self.Time > CurTime() ) then return end
	if tr.Entity then
		local Vect = tr.Entity:LocalToWorld(tr.Entity:OBBCenter())
		print("")
		Msg("Vector("..math.Round(Vect.x)..","..math.Round(Vect.y)..","..math.Round(Vect.z).."),")
	end

	self.Time = CurTime() + 0.3
	
end

concommand.Add("Updatemodel",function(ply,cmd,args) end)
