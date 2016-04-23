
if SERVER then
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	AddCSLuaFile( "shared.lua" )
	SWEP.Charge = 0
	AddCSLuaFile( "cl_init.lua" )
end
if CLIENT then
	SWEP.PrintName			= "Defibilator"			
	SWEP.Author				= "Noobulater"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.DrawWeaponInfoBox	= false
	SWEP.BounceWeaponIcon   = false
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
	SWEP.Chargee = 0
	SWEP.IconLetter			= "C"
end

SWEP.HoldType = "normal"

SWEP.ViewModelFOV	= 100
SWEP.ViewModel		= "models/weapons/v_defilibrator.mdl"
SWEP.WorldModel		= "models/weapons/w_stunbaton.mdl" 

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Range			= 120
SWEP.Primary.Recoil			= 4.6
SWEP.Primary.Delay			= 1
SWEP.Primary.Damage			= 100
SWEP.Primary.Cone			= 0.02
SWEP.Primary.NumShots		= 1

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false	
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNWInt("Charge",0)
end 

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	if SERVER then
		if self:GetNWInt("Charge") < 100 then
			self:SetNWInt("Charge",self:GetNWInt("Charge") + 25)
			if self:GetNWInt("Charge") >= 75 then
				self.Owner:EmitSound("buttons/blip1.wav",60,100)
			end
		end
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
		if self:GetNWInt("Charge") < 75 then 
			return
		end
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
 	local trace = util.GetPlayerTrace(self.Owner)
 	local tr = util.TraceLine(trace)
	
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
		if tr.Hit then
			if (self.Owner:GetPos() - tr.HitPos):Length() < self.Primary.Range then
				for _,ply in pairs(player.GetAll()) do
					if SERVER then		
						if !ply:Alive() && ply.Ragdoll:GetPos():Distance(tr.HitPos) < 120 then
							if ply.KOInfo.Death then
								local phys = ply:GetRagdoll():GetPhysicsObject()
											
								if phys && phys:IsValid() then
									phys:ApplyForceCenter(ply:GetAimVector() * 120)
								end
								
								local chance = math.random(0,self:GetNWInt("Charge"))
								ply:GetRagdoll().Zaps = ply:GetRagdoll().Zaps + 1
								if chance > 25 then
									local chance1 = math.random(0,self:GetNWInt("Charge"))
									if chance1 > 50 || ply:GetRagdoll().Zaps > 5 then
										local pos = ply:GetRagdoll():GetPos()
										ply:Spawn()
										local tracedata = {}
										tracedata.start = self.Owner:EyePos()
										tracedata.endpos = self.Owner:EyePos()+(Angle(0,self.Owner:GetAngles().y,90):Forward()*60)
										tracedata.filter = self.Owner
										local trace = util.TraceLine(tracedata)
										if trace.Hit then
											ply:SetPos(self.Owner:GetPos() + Angle(0,self.Owner:GetAngles().y,90):Forward() * -60)
										else
											ply:SetPos(self.Owner:GetPos() + Angle(0,self.Owner:GetAngles().y,90):Forward() * 60)
										end
										if ply:HasItem("item_life_alert") then
											self.Owner:Hint("You earned $300 for responding to a life alert call.")
											self.Owner:AddMoney(WALLET,300)							
										end
									end
								end
								self:SetNWInt("Charge",self:GetNWInt("Charge") - 75)
								self.Owner:EmitSound("ambient/energy/zap3.wav",60,100)
							else
								self.Owner:Hint("This person isn't dying.")
							end
							self.Owner:ViewPunch(Angle(math.Rand(-3,3) * self.Primary.Recoil,math.Rand(-3,3) * self.Primary.Recoil,0))
							self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
							self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
							break
						end
					end		
				end				
			end
		end

end





