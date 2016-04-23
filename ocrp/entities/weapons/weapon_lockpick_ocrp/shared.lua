if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.IconLetter			= "I"
end
SWEP.HoldType			= "shotgun"
if (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.ViewModelFOV		= 64
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false			
	SWEP.Author				= "Jake_1305"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "C"
end
SWEP.PrintName			= "Lockpick"
SWEP.Author			= "Jake_1305"

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

SWEP.Secondary.Recoil			= 0
SWEP.Secondary.Damage			= -1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.Delay			= 1.0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
end

function SWEP:Reload()
end

function SWEP:Think()
end
	
function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace()
	
	if !tr.Entity:IsDoor() && !tr.Entity:IsPlayer() then return false end
	
	local Dist = self.Owner:EyePos():Distance(tr.HitPos)
	if Dist > 100 then return false end
	if SERVER then
		if tr.Entity:IsDoor() then
			if tr.Entity:GetClass() == "func_door" then
				if !self.Owner:HasSkill("skill_picking",6) then
					self.Weapon:SetNextPrimaryFire(CurTime() + 5)
					return
				end
			end
			if tr.Entity:GetClass() == "prop_vechicle_jeep" then
				if !self.Owner:HasSkill("skill_picking",6) then
					self.Weapon:SetNextPrimaryFire(CurTime() + 5)
					return
				end
			end
			if tr.Entity.PadLock != nil && tr.Entity.PadLock:IsValid() then
				if !self.Owner:HasSkill("skill_picking",5) then
					self.Weapon:SetNextPrimaryFire(CurTime() + 5)
					return
				else
					tr.Entity.PadLock:TakeDamage(100,self.Owner)
				end
			end 
				local snd = {1,3,4}
				self.Owner:EmitSound("weapons/357/357_reload".. tostring(snd[math.random(1, #snd)]) ..".wav", 100, 100)
				--self.Owner:EmitSound("doors/door_locked2.wav",100,100)
				timer.Simple(1,function() 
						local multi = 1
						if self.Owner:HasSkill("skill_picking",1) then
							if self.Owner:HasSkill("skill_picking",2) then
								multi = 1.15
								if self.Owner:HasSkill("skill_picking",3) then
									if self.Owner:HasSkill("skill_picking",4) then
										multi = 1.35
										if self.Owner:HasSkill("skill_picking",5) then
											if self.Owner:HasSkill("skill_picking",6) then
												if self.Owner:HasSkill("skill_picking",7) then
													multi = 1.6
												end
											end
										end
									end
								end
							end
						end
						local Chance = 25 * multi 
						local Random = math.random( 0, 100 )
							if Random > Chance && Random < 60 then
								self.Owner:Hint("Your lockpick broke.")
								self.Owner:SelectWeapon("weapon_idle_hands_ocrp")
								self:Remove()
							--	OCRP_Challenge_Gain( ply, "Pro", "break", 5, "Theft" )								
							elseif Random <= Chance then
								tr.Entity:Fire('UnLock')
								tr.Entity:SetNWBool("UnLocked",true)
								tr.Entity:Fire('Open', '', .5)
								self.Owner:EmitSound("doors/door_latch3.wav",100,100)
							--	OCRP_Challenge_Gain( ply, "Pro", "door", 20, "Theft" )
							else
								self.Owner:Hint("You failed to lockpick the lock.")
							end
						end)
				elseif trace.Entity:IsPlayer() && trace.Entity:GetNWBool("Handcuffed") && self.Owner:HasSkill("skill_picking",3) then
					timer.Simple(1,function(self) 
								trace.Entity:SetNWBool("Handcuffed",false)
								self.Owner:EmitSound("ambient/materials/platedrop1.wav",100,100)
								--OCRP_Challenge_Gain( ply, "Pro", "handcuff", 25, "Theft" )
							end)
				end

	end
	if SERVER then
		if OCRP_Has_Permission(self.Owner,tr.Entity) then
			if tr.Entity:IsVehicle() and !tr.Entity:IsGovCar() and tr.Entity:GetTable().LastSirenPlay and tr.Entity:GetTable().LastSirenPlay + 23 > CurTime() then
				umsg.Start('car_alarm_stop');
					umsg.Entity(tr.Entity);
				umsg.End();
				
				tr.Entity:GetTable().LastSirenPlay = nil;
			end
		else
			if SERVER and tr.Entity:IsVehicle() and (!tr.Entity:GetDriver() or !tr.Entity:GetDriver():IsValid() or !tr.Entity:GetDriver():IsPlayer()) and !tr.Entity:IsGovCar() then
				umsg.Start('car_alarm');
					umsg.Entity(tr.Entity);
				umsg.End();
			
				tr.Entity:GetTable().LastSirenPlay = CurTime();
		
			end
		end
	end
	self.Weapon:SetNextPrimaryFire(CurTime() + 5)
end


function SWEP:EmptyClip()
	if SERVER then
		self.Owner:Hint("Holstering lockpick; this will take 5 seconds.")
		timer.Simple(5,function() 
			if !self.Owner:IsValid() then return end
			if self.Owner:HasWeapon("weapon_lockpick_ocrp") && self.Owner:GetActiveWeapon():GetClass() == "weapon_lockpick_ocrp" then 
				if self.Owner:IsPlayer() then
					self.Owner:GiveItem("item_lockpick",1) 
					self.Owner:StripWeapon("weapon_lockpick_ocrp") 
				end
			end 
		end)
	end
end
