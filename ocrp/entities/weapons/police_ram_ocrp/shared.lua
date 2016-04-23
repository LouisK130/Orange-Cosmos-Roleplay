if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
end
if (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.ViewModelFOV		= 64
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "Police Ram"			
	SWEP.Author				= "Jake_1305"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
end
SWEP.Author			= "Jake_1305"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType			= "shotgun"

SWEP.ViewModel = "models/weapons/v_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 1.0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"



function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Deploy()
end

function SWEP:Reload()
end

function SWEP:Think()
end
	
function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace()
	local function RamNow()
		if tr.Entity:IsDoor() && tr.Entity:GetNWInt("Owner") > 0 &&  player.GetByID(tr.Entity:GetNWInt("Owner")):IsValid() then
				if  tr.Entity:GetClass() == "prop_vehicle_jeep" then
					if tr.Entity:GetDriver():IsPlayer() then
						local ply = tr.Entity:GetDriver()
						ply.RecentlyRammed = true
						timer.Simple(10, function()
							ply.RecentlyRammed = false
						end)
						ply:ExitVehicle()
					end
				end		
			if player.GetByID(tr.Entity:GetNWInt("Owner")):GetWarranted() > 0 then
				local Random = math.random( 1, 100 )
				if Random > 20 then
					self.Owner:Hint("You failed to break open the door.")
				elseif Random <= 20 then
					tr.Entity:Fire('UnLock')
					tr.Entity:Fire('Open', '', .5)
					tr.Entity:SetNWBool("UnLocked",false)
				end
			end
		end
	end
	if !tr.Hit then return end
	if !tr.HitNonWorld then return end
	if !tr.Entity:IsDoor() then
		local Dist = self.Owner:EyePos():Distance(tr.HitPos)
		if Dist > 100 then return false end
		if SERVER then 
			if tr.Entity:GetNWInt("Owner") > 0 && player.GetByID(tr.Entity:GetNWInt("Owner")):GetWarranted() > 0 && tr.Entity:GetClass() == "item_base" then 
				self.Owner:ViewPunch(Angle(math.Rand(-3,3) * self.Primary.Recoil,math.Rand(-3,3) * self.Primary.Recoil,0))
				self.Owner:EmitSound("physics/wood/wood_box_impact_hard"..math.random(1,3)..".wav",100,100)
				tr.Entity:GetPhysicsObject():EnableMotion(true) 
				tr.Entity:GetPhysicsObject():Wake() 
			end 
		end 
		return false 
	end
	local Dist = self.Owner:EyePos():Distance(tr.HitPos)
	if Dist > 100 then return false end
	
	if SERVER then
		self.Owner:ViewPunch(Angle(math.Rand(-3,3) * self.Primary.Recoil,math.Rand(-3,3) * self.Primary.Recoil,0))
		self.Owner:EmitSound("physics/wood/wood_box_impact_hard"..math.random(1,3)..".wav",100,100)
		timer.Simple(1, RamNow)
	end
	
	self.Weapon:SetNextPrimaryFire(CurTime() + 3)
	self.Weapon:SetNextSecondaryFire(CurTime() + 3)
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end



