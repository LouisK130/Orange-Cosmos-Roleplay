if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	--SWEP.HoldType			= "melee"

end

if ( CLIENT ) then
	--SWEP.HoldType			= "melee"

	SWEP.PrintName			= "Snowballs!"	
	SWEP.Author				= "BlackJackit, Edited from IceAxe Realistic Weapon, all credits to the creators"
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false
	SWEP.ViewModelFOV		= 62
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "S"
end
SWEP.HoldType			= "melee"
SWEP.AnimPrefix  = "stunstick"
 
SWEP.Instructions 			= "Left click to launch a snowball \nReload to take another one\n"
SWEP.Category				= "Snowballs!"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel 				= "models/weapons/v_snowball.mdl"
SWEP.WorldModel 			= "models/weapons/w_snowball.mdl" 

SWEP.Weight						= 0.1
SWEP.AutoSwitchTo				= false
SWEP.AutoSwitchFrom				= false

SWEP.Primary.ClipSize			= 1
--SWEP.Primary.Damage				= 1 -- real damage
SWEP.Primary.DefaultClip		= 1
SWEP.Primary.Automatic			= false
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.12
SWEP.Primary.Ammo				= "none"
SWEP.Primary.Delay			    = 1

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Damage			= 0
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo				= "none"

SWEP.IronSightsPos 			= Vector(-15, 0, 15) -- Comment out this line of you don't want ironsights.  This variable must be present if your SWEP is to use a scope.
SWEP.IronSightsAng 			= Vector(0, 0, 0)
SWEP.IronSightZoom			= 1.0 -- How much the player's FOV should zoom in ironsight mode. 

function SWEP:Think()
end

function SWEP:Initialize() 
	self:SetIronsights(false,self.Owner)
 	if ( SERVER ) then 
 		 -- self:SetHoldType( "melee" );
 	end 
	 self:SetHoldType( "melee" );
	util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")
	self.Weapon:SetClip1(1)
	
end 

function SWEP:Deploy()
	return true
end

--[[---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------]]
function SWEP:SecondaryAttack()
end

--[[---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------]]
function SWEP:PrimaryAttack()
	-- if( self.Weapon:Clip1() < 1 ) then
		-- return
	-- else
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
		
		self.Weapon:TakePrimaryAmmo(1);
		
		local trace = {}
		trace.start = self.Owner:GetShootPos()
		trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 10^14
		trace.filter = self.Owner
		local tr = util.TraceLine(trace)
	
		local vAng = (tr.HitPos-self.Owner:GetShootPos()):GetNormal():Angle()
		-- tr.Entity:SetKeyValue("targetname", "disTarg")
		
		if SERVER then
			local Front = self.Owner:GetAimVector();
		local Up = self.Owner:EyeAngles():Up();
		
		if ( SERVER ) then -- only spawn things on server to prevent issues
			local ball = ents.Create("ent_snowball");

			if ValidEntity(ball) then -- 

				ball:SetPos(self.Owner:GetShootPos() + Front * 10 + Up * 10 * -1);
				ball:SetAngles(Front:Angle());
				ball:Spawn();
				ball:Activate();
				ball:SetOwner(self.Owner)
				local Physics = ball:GetPhysicsObject();
	
				if ValidEntity(Physics) then
		
				local Random = Front:Angle();
						
					Random = Random:Forward();
					Physics:ApplyForceCenter(Random * 4000);
				end
			end
		end
		end
	-- end
		self:SetIronsights(true,self.Owner)

	-- self:SetIronsights(false,self.Owner)
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
    self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	--self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:Reload()
	self:SetIronsights(false,self.Owner)
	-- if( self.Weapon:Clip1() < 1 ) then
		-- self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
		-- self.Weapon:SetNextPrimaryFire(CurTime() + 1)
		-- self.Weapon:SetNextSecondaryFire(CurTime() + 1)
		-- self.Weapon:SetClip1(1)
	-- end
	-- return true
end

local IRONSIGHT_TIME = 0.1 -- How long it takes to raise our rifle
function SWEP:SetIronsights(b,player)

if CLIENT or (not player) or player:IsNPC() then return end
	-- Send the ironsight state to the client, so it can adjust the player's FOV/Viewmodel pos accordingly
	self.Weapon:SetNetworkedBool("Ironsights", b)
end

function SWEP:OnRemove()
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:ShootEffects()
end

-- mostly garry's code
function SWEP:GetViewModelPosition(pos, ang)

	if not self.IronSightsPos then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool("Ironsights")
	if bIron ~= self.bLastIron then -- Are we toggling ironsights?
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if bIron then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if not bIron and (fIronTime < CurTime() - IRONSIGHT_TIME) then 
		return pos, ang 
	end
	
	local Mul = 1.0 -- we scale the model pos by this value so we can interpolate between ironsight/normal view
	
	if fIronTime > CurTime() - IRONSIGHT_TIME then
	
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)
		if not bIron then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if self.IronSightsAng then
	
		ang = ang*1
		ang:RotateAroundAxis(ang:Right(), 		self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 			self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), 	self.IronSightsAng.z * Mul)
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end

-- This function handles player FOV clientside.  It is used for scope and ironsight zooming.
function SWEP:TranslateFOV(current_fov)

	local fScopeZoom = self.Weapon:GetNetworkedFloat("ScopeZoom")
	if self.Weapon:GetNetworkedBool("Scope") then return current_fov/fScopeZoom end
	
	local bIron = self.Weapon:GetNetworkedBool("Ironsights")
	if bIron ~= self.bLastIron then -- Do the same thing as in CalcViewModel.  I don't know why this works, but it does.
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()

	end
	
	local fIronTime = self.fIronTime or 0

	if not bIron and (fIronTime < CurTime() - IRONSIGHT_TIME) then 
		return current_fov
	end
	
	local Mul = 1.0 -- More interpolating shit
	
	if fIronTime > CurTime() - IRONSIGHT_TIME then
	
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)
		if not bIron then Mul = 1 - Mul end
	
	end

	current_fov = current_fov*(1 + Mul/self.IronSightZoom - Mul)

	return current_fov

end


