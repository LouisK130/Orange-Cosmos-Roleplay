if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Fire Hose"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = ""
SWEP.Instructions = "Left Click: Extinguish Fires"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = "";
SWEP.WorldModel = "";
SWEP.Instructions	= "Put out fires fast."

SWEP.ShootSound = Sound("ambient/waterfalloutside.wav");

if CLIENT then
	function SWEP:GetViewModelPosition ( Pos, Ang )
		Pos = Pos + Ang:Forward() * -15;
		Pos = Pos + Ang:Right() * -8;
		Pos = Pos + Ang:Up() * -65;
		
		return Pos, Ang;
	end 
end

function SWEP:Initialize()
	//if SERVER then
		--self:SetHoldType("normal")
	//end
end

function SWEP:CanPrimaryAttack ( ) return true; end

function SWEP:PrimaryAttack()
	local NearbyFireTruck = false;
	for k, v in pairs(ents.FindByClass('prop_vehicle_jeep')) do
		if v:GetPos():Distance(self.Owner:GetPos()) < 1250 and v:GetModel() == 'models/sickness/truckfire.mdl' then
			NearbyFireTruck = true;
			break;
		end
	end
	
	if !NearbyFireTruck then		
		if SERVER then
			self.Owner:Hint("You must be near a firetruck to use this!");
		end
		return false;
	end
	
	if self:GetTable().LastNoise == nil then
		self:GetTable().LastNoise = true;
	end
	if self:GetTable().LastNoise then
		self.Weapon:EmitSound(self.ShootSound)
		self:GetTable().LastNoise = false;
	else
		self:GetTable().LastNoise = true;
	end
	
	--self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Weapon:SetNextPrimaryFire(CurTime() + .1)
	
	if CLIENT or (game.SinglePlayer() and SERVER) then		
		local ED = EffectData();
			ED:SetEntity(self.Owner);
		util.Effect('fire_hose_water', ED);
	end
	
	self.Owner:ViewPunch(Angle(math.Rand(-1,-0.5), math.Rand(-0.5,0.5), 0 ))
	
	if SERVER then
		local Trace2 = {};
		Trace2.start = self.Owner:GetShootPos();
		Trace2.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 200;
		Trace2.filter = self.Owner;

		local Trace = util.TraceLine(Trace2);
				
		local CloseEnts = ents.FindInSphere(Trace.HitPos, math.random(65, 135))
		
		for k, v in pairs(CloseEnts) do
			if v:GetClass() == 'prop_fire' then
				v:HitByExtinguisher(self.Owner, true)
			end
			
			if v:IsOnFire() then v:Extinguish() end
		end
	end
		if timer.Exists("fire_hose_water_sound_stop") then
			timer.Destroy("fire_hose_water_sound_stop")
		end
		timer.Create("fire_hose_water_sound_stop", .2, 1, function()
			self:StopSound("ambient/waterfalloutside.wav")
		end)
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack();
end

