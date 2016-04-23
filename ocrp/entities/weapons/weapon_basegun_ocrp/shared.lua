SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"
SWEP.AnimPrefix		= "python"

SWEP.Threat = 0

SWEP.HoldType 			= "pistol"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Peircing = 1

SWEP.Primary.ClipSize		= 0					// Size of a clip
SWEP.Primary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "pistol"

SWEP.ReloadSpeed = 2.5
SWEP.ReloadTime = 0

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IMultiplier = .75

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	for item,data in pairs(GAMEMODE.OCRP_Items) do
		if data.AmmoType == self.Primary.Ammo then
			self.Primary.AmmoItem = item
			break
		end
	end
end


function SWEP:Precache()
end

function SWEP:PrimaryAttack()
	if (!self:CanPrimaryAttack()) then return end
	if SERVER then
	self.Weapon:TossWeaponSound()
	--[[	if self.LastBeacon == "lol"  then
			local beacon = ents.Create("beacon_small")
			beacon:SetPos(self:GetOwner():GetPos()) 
			beacon:Spawn()
			self.LastBeacon = beacon
		elseif self.LastBeacon:IsValid() && self.LastBeacon:GetPos():Distance(self:GetOwner():GetPos()) >= 400 then
			local beacon = ents.Create("beacon_small")
			beacon:SetPos(self:GetOwner():GetPos()) 
			beacon:Spawn()
			self.LastBeacon = beacon
		end--]]
	end
	self:CSShootBullet(self.Primary.Damage,self.Primary.Recoil,self.Primary.NumShots,self.Primary.Cone)
	self.Owner:ViewPunch(Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil,math.Rand(-0.1,0.1) *self.Primary.Recoil,0)) 
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:TakePrimaryAmmo(1)
 	if (game.SinglePlayer() && SERVER) || CLIENT then 
 		self.Weapon:SetNetworkedFloat("LastShootTime",CurTime()) 
 	end 
end

function SWEP:SetIronsights( b )
	self.Weapon:SetNetworkedBool( "Ironsights", b )
end

SWEP.NextSecondaryAttack = 0

function SWEP:SecondaryAttack()

	if ( !self.IronSightsPos ) then return end
	if ( self.NextSecondaryAttack > CurTime() ) then return end
	
	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
		

		if bIronsights then
			if SERVER then
				GAMEMODE:SetPlayerSpeed(self:GetOwner(),self.Owner.Speeds.Run /3,self.Owner.Speeds.Sprint/3)
			end
			self.Primary.Cone = self.Primary.Cone * self.IMultiplier
		else
			if SERVER then
				GAMEMODE:SetPlayerSpeed(self:GetOwner(),self.Owner.Speeds.Run,self.Owner.Speeds.Sprint)
			end
			self.Primary.Cone = self.Primary.Cone / self.IMultiplier
		end
	
	self:SetIronsights( bIronsights )
	
	self.NextSecondaryAttack = CurTime() + 0.3
	
end

function SWEP:OnRestore()

	self.NextSecondaryAttack = 0
	self:SetIronsights( false )
	
end

function SWEP:CheckReload()
end

function SWEP:Reload()
	if self.Weapon:Clip1() >= self.Primary.ClipSize  || self:GetNWBool("reloading") then return end
	if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then return end
	if self:GetNetworkedBool( "Ironsights") then
		self.Primary.Cone = self.Primary.Cone / self.IMultiplier
	end
	self:SetIronsights( false )
	self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
	self.Owner:SetAnimation(PLAYER_RELOAD)
	self:SetNWBool("reloading", true)
	self:SetNextPrimaryFire(CurTime() + self.ReloadSpeed)
	self:SetNextSecondaryFire(CurTime() + self.ReloadSpeed)
	if SERVER then
		self.ReloadTime = CurTime() +  self.ReloadSpeed
		GAMEMODE:SetPlayerSpeed(self:GetOwner(),self.Owner.Speeds.Run,self.Owner.Speeds.Sprint)
	end
	timer.Simple(self.ReloadSpeed, function()
        if not self or not self:IsValid() then return end
        self:SetNWBool("reloading", false)
        if self != self.Owner:GetActiveWeapon() then return end -- must be holding it out to reload
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		if SERVER then
		if (self:GetOwner():GetAmmoCount(self.Primary.Ammo) + self.Weapon:Clip1()) >= self.Primary.ClipSize then
			self.Owner:RemoveItem(self.Primary.AmmoItem,self.Primary.ClipSize - self.Weapon:Clip1())
			self.Weapon:SetClip1(self.Primary.ClipSize)
		else
			self.Weapon:SetClip1(self:GetOwner():GetAmmoCount(self.Primary.Ammo) + self.Weapon:Clip1())
			self.Owner:RemoveItem(self.Primary.AmmoItem,self:GetOwner():GetAmmoCount(self.Primary.Ammo))
		end
		end
		self:SetNWBool("reloading", false)
	end)
end

function SWEP:EmptyClip()
	if self:GetNWBool("reloading") then return end
	if !self:CanPrimaryAttack() then return end
	self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
	self.Owner:SetAnimation(PLAYER_RELOAD)
	timer.Simple(self.ReloadSpeed, function()
        if self and self:IsValid() then
            if self != self.Owner:GetActiveWeapon() then return end
            self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
            if SERVER then
                self.Owner:GiveItem(self.Primary.AmmoItem,self.Weapon:Clip1())
                self.Weapon:SetClip1(0)
            end
        end
	end)
	self:SetNextPrimaryFire(CurTime() + self.ReloadSpeed)
	self:SetNextSecondaryFire(CurTime() + self.ReloadSpeed)
end

--[[if SERVER then concommand.Add("give_cop", function(ply)
	ply:StripWeapon("weapon_copgun_ocrp")
	ply:Give("weapon_copgun_ocrp")
	ply:GiveItem("item_ammo_cop", 100)
end)
end]]

function SWEP:Holster(wep)
	self:SetIronsights( false )
	if SERVER then
		if self:GetNWBool("reloading") then
			self:SetNWBool("reloading",false)
		end
	end
	return true
end

function SWEP:Deploy()
	if SERVER then
		if self.Owner.Inhibitors.BrokenArm && self.Assualt then
			self.Owner:SelectWeapon("weapon_idle_hands_ocrp")
			self.Owner:Hint("That gun is too heavy to carry with a broken arm.")
			return false
		end
	end
	self:SetIronsights( false )
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	return true
end

function SWEP:CSShootBullet(dmg,recoil,numbul,cone)
	if self.Owner:Crouching() then cone = cone*.6 end
	if !self.Owner:OnGround() then cone = cone*1.3 end
	numbul = numbul or 1 
	cone = cone or 0.01 
	if SERVER then
		local multi = 1
		if self.Owner:HasSkill("skill_conc",1) then
			multi = .9
			if self.Owner:HasSkill("skill_conc",2) then
				multi = .8
				if self.Owner:HasSkill("skill_conc",3) then
					multi = .7
					if self.Owner:HasSkill("skill_conc",4) then
						multi = .6
						if self.Owner:HasSkill("skill_conc",5) then
							multi = .5
						end
					end
				end
			end
		end
		cone = cone * multi
	end
	local bullet = {} 
	bullet.Num 		= numbul 
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector(cone,cone,0)
	bullet.Tracer	= 1
	bullet.Force	= 5
	bullet.Damage	= dmg 
	self.Owner:FireBullets(bullet) 
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:MuzzleFlash()
	if self.Owner:IsNPC() then return end 
	if (game.SinglePlayer() && SERVER) || (!game.SinglePlayer() && CLIENT) then 
		local eyeang = self.Owner:EyeAngles() 
		eyeang.pitch = eyeang.pitch - recoil 
		self.Owner:SetEyeAngles(eyeang) 
	end 
end

function SWEP:TakePrimaryAmmo(num)
	if self.Weapon:Clip1() <= 0 then 
		if self:Ammo1() <= 0 then return end
		self.Owner:RemoveAmmo(num,self.Weapon:GetPrimaryAmmoType())
	return end
	self.Weapon:SetClip1(self.Weapon:Clip1() - num)	
end
function SWEP:TakeSecondaryAmmo(num)
	if self.Weapon:Clip2() <= 0 then 
		if self:Ammo2() <= 0 then return end
		self.Owner:RemoveAmmo(num,self.Weapon:GetSecondaryAmmoType())
	return end
	self.Weapon:SetClip2(self.Weapon:Clip2() - num)	
end

function SWEP:CanPrimaryAttack()
	if self.Weapon:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.2)
		self:Reload()
		return false
	end
	return true
end

function SWEP:CanSecondaryAttack()
	if self.Weapon:GetNetworkedBool("reloading") then return end 

	return true
end

function SWEP:ContextScreenClick(aimvec,mousecode,pressed,ply)
end
function SWEP:OnRemove()
end
function SWEP:OwnerChanged()
end
function SWEP:Ammo1()
	return self.Owner:GetAmmoCount(self.Weapon:GetPrimaryAmmoType())
end
function SWEP:Ammo2()
	return self.Owner:GetAmmoCount(self.Weapon:GetSecondaryAmmoType())
end
function SWEP:SetDeploySpeed(speed)
	self.m_WeaponDeploySpeed = tonumber(speed)
end
