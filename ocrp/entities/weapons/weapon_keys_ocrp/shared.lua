if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.IconLetter			= "I"
end
if (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 64
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "Keys"			
	SWEP.Author				= "Noobulator"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "C"
	killicon.AddFont("weapon_c4_re","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
end
SWEP.Author			= "Noobulator"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_fists.mdl"
SWEP.WorldModel			= ""
SWEP.Instructions		= "For unlocking and locking doors and cars."
SWEP.UseHands			= false

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 1.0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1

SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	self:SetHoldType("slam")
end

function SWEP:Deploy()
end

function SWEP:Reload()
end

function SWEP:Think()
end
	
function SWEP:PrimaryAttack()
	local pos = self.Owner:EyePos()
	local posang = self.Owner:GetAimVector()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(posang*80)
	tracedata.filter = self.Owner
	local trace = util.TraceLine(tracedata)


	self:SetNextPrimaryFire(CurTime() + 0.5)
	if trace.HitWorld then return end
	if trace.HitNonWorld then
		if trace.Entity:IsDoor() then
			if SERVER then
				OCRP_Toggle_Lock(self.Owner,trace.Entity)
			end
		end
	end
	if SERVER then
		if OCRP_Has_Permission(self.Owner,trace.Entity) then
			if trace.Entity:IsVehicle() and !trace.Entity:IsGovCar() and trace.Entity:GetTable().LastSirenPlay and trace.Entity:GetTable().LastSirenPlay + 23 > CurTime() then
				umsg.Start('car_alarm_stop');
					umsg.Entity(trace.Entity);
				umsg.End();
				
				trace.Entity:GetTable().LastSirenPlay = nil;
			end
		else
			if SERVER and trace.Entity:IsVehicle() and (!trace.Entity:GetDriver() or !trace.Entity:GetDriver():IsValid() or !trace.Entity:GetDriver():IsPlayer()) and !trace.Entity:IsGovCar() then
				umsg.Start('car_alarm');
					umsg.Entity(trace.Entity);
				umsg.End();
			
				trace.Entity:GetTable().LastSirenPlay = CurTime();
		
			end
		end
	end
end

if CLIENT then

local UnLocked_Mat = Material("gui/OCRP/OCRP_UnLocked")
local Locked_Mat = Material("gui/OCRP/OCRP_Locked")

function SWEP:DrawHUD()
	local x = ScrW() / 2.0 
	local y = ScrH() / 2.0 
		
	local pos = self.Owner:EyePos()
	local posang = self.Owner:GetAimVector()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(posang*80)
	tracedata.filter = self.Owner
	local trace = util.TraceLine(tracedata)
	if self.Owner:InVehicle() then return end
	if trace.HitWorld then return end
	if trace.HitNonWorld then
		if trace.Entity:IsDoor() then
			if trace.Entity:GetNWBool("UnLocked") then
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(UnLocked_Mat)
				surface.DrawTexturedRect(x-25,y-25,50,50)
			else
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(Locked_Mat)
				surface.DrawTexturedRect(x-25,y-25,50,50)
			end			
		end
	end
end

end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then return end
	local pos = self.Owner:EyePos()
	local posang = self.Owner:GetAimVector()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(posang*80)
	tracedata.filter = self.Owner
	local trace = util.TraceLine(tracedata)


	self:SetNextSecondaryFire(CurTime() + 0.5)
	if trace.HitWorld then return end
	if trace.HitNonWorld then
		if trace.Entity:IsDoor() then
			if player.GetByID(trace.Entity:GetNWInt("Owner")) == self.Owner then
				if CLIENT then
					ChangePermissionsMenu(trace.Entity)
				end
			elseif self.Owner:Team() == CLASS_Mayor then
				if CLIENT then
                    if not trace.Entity.UnOwnable then return end
					if trace.Entity.UnOwnable < 0 && trace.Entity.UnOwnable > -2 then
						ChangePermissionsMenu(trace.Entity)
					end
				end
			end
		end
	end
	self:SetNextSecondaryFire(CurTime() + 1)
end


function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
	return true
end

function SWEP:DrawWorldModel()
end
