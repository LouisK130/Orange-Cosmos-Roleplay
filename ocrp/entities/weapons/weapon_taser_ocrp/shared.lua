if (CLIENT) then
	SWEP.PrintName			= "Police Taser"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.IconLetter			= "f"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false	
	SWEP.CSMuzzleFlashes 	= true
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	killicon.AddFont("weapon_taser_ocrp","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_basegun_ocrp"

SWEP.ViewModelFOV		= 45
SWEP.UseHands 			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/c_csgo_taser.mdl"
SWEP.WorldModel			= "models/weapons/csgo_world/w_eq_taser.mdl"
SWEP.HoldType 			= "pistol"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Peircing = 3

SWEP.Primary.Sound			= nil -- We do the sound ourself based on hit or not
SWEP.Primary.Recoil			= 10
SWEP.Primary.Damage			= 100
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.07
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.23
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.SightsPos = Vector (3.6198, 0, 0.6007)
SWEP.SightsAng = Vector (0, 0, 0)

SWEP.RunArmOffset = Vector(1.287, -20, -10.98)
SWEP.RunArmAngle = Vector(70, 0, 0)

SWEP.IronSightsPos = Vector (5.1676, -0.2058, 2.7344)
SWEP.IronSightsAng = Vector (0, 0, 0)

function SWEP:Initialize()

	self:SetHoldType(self.HoldType) 	-- Hold type of the 3rd person animation
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 10)
	if SERVER then
        local target = ents.Create("prop_physics")
        target:SetModel("models/weapons/csgo_world/w_eq_taser.mdl")
        target:SetSolid(SOLID_VPHYSICS)
        target:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
        target:SetColor(Color(0,0,0,0))
        target:SetNoDraw(true)
        target:Spawn()
        target:SetPos(self.Owner:EyePos() + self.Owner:GetAimVector() * 200)
        target:GetPhysicsObject():EnableMotion(false)
        local target2 = ents.Create("prop_physics")
        target2:SetModel("models/weapons/csgo_world/w_eq_taser.mdl")
        target2:SetSolid(SOLID_VPHYSICS)
        target2:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
        target2:SetColor(Color(0,0,0,0))
        target2:SetNoDraw(true)
        target2:Spawn()
        target2:SetPos(self.Owner:EyePos())
        target2:GetPhysicsObject():EnableMotion(false)
        local beam = constraint.Rope(target2, target, 0, 0, Vector(0,0,0), Vector(0,0,0), 150, 0, 0, 20, "cable/blue_elec", false)
        beam:Activate()
        local rnda = self.Primary.Recoil * -1 
        local rndb = self.Primary.Recoil * math.random(-1, 1) 
        self.Owner:ViewPunch(Angle(rnda, rndb, rndb))
        timer.Simple(.1, function()
            if beam:IsValid() then
                beam:Remove()
            end
            if target:IsValid() then
                target:Remove()
            end
            if target2:IsValid() then
                target2:Remove()
            end
        end)
    end
	local tr = util.TraceLine({
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 200,
		filter = function(ent)
		if ent:IsValid() and ent:IsPlayer() and !(ent:EntIndex() == self.Owner:EntIndex()) then
			return true
		end
		end,
	})
	if tr.Entity and tr.Entity:IsValid() then
        if CLIENT then
            self:EmitSound(Sound("weapons/taser/taser_hit.wav"))
        else
            local di = DamageInfo()
            di:SetDamage(100)
            di:SetAttacker(self.Owner)
            di:SetInflictor(self)
            di:SetDamageType(DMG_BULLET)
            tr.Entity:TakeDamageInfo(di)
        end
    else
        if CLIENT then
            self:EmitSound(Sound("weapons/taser/taser_shoot.wav"))
        end
	end
end

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 1 + hand.Ang:Forward() * -3 + hand.Ang:Up() * -1

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 10)
hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 10)
hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

self:SetRenderOrigin(hand.Pos + offset)
self:SetRenderAngles(hand.Ang)

self:DrawModel()

if (CLIENT) then
self:SetModelScale(1,1,1)
end
end