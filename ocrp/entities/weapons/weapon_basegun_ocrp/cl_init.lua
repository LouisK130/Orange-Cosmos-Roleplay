include('shared.lua')
SWEP.PrintName			= "Scripted Weapon"		// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 0						// Slot in the weapon selection menu
SWEP.SlotPos			= 10					// Position in the slot
SWEP.DrawAmmo			= true					// Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= false					// Should draw the default crosshair
SWEP.SwayScale			= 1.0					// The scale of the viewmodel sway
SWEP.BobScale			= 1.0					// The scale of the viewmodel bob
SWEP.RenderGroup 		= RENDERGROUP_OPAQUE
surface.CreateFont("CSKillIcons", {
    font="csd",
    size=ScreenScale(30),
    weight=500,
    antialias=true,
    shadow=true
})    
surface.CreateFont("CSSelectIcons", {
    font="csd",
    size=ScreenScale(60),
    weight=500,
    antialias=true,
    shadow=true
})    

function SWEP:DrawHUD()
	if LocalPlayer().DrawMap then return false end
	if self.Weapon:GetNetworkedBool( "Ironsights", false ) then return false; end
		local x = ScrW() / 2.0 
		local y = ScrH() / 2.0 
		local scale = 15 * self.Primary.Cone
		if !self:GetOwner():OnGround() then
			scale = 15 * self.Primary.Cone * 1.3
		elseif self.Owner:Crouching() then 
			scale = 15 * self.Primary.Cone * .6
		end

		local LastShootTime = self.Weapon:GetNetworkedFloat("LastShootTime",0) 
		scale = scale * (2 - math.Clamp((CurTime() - LastShootTime) * 5,0.0,1.0)) 
		local gap = 30 * scale
		local length = gap + 7
		surface.SetDrawColor(0,255,0,255)
		surface.DrawLine(x - length,y,x - gap,y) 
		surface.DrawLine(x + length,y,x + gap,y) 
		surface.DrawLine(x,y - length,x,y - gap) 
		surface.DrawLine(x,y + length,x,y + gap) 
end

function SWEP:DrawWeaponSelection(x,y,wide,tall,alpha) 
	draw.SimpleText(self.IconLetter,"CSSelectIcons",x + wide/2,y + tall*0.2,Color(255,210,0,255),TEXT_ALIGN_CENTER) 
	draw.SimpleText(self.IconLetter,"CSSelectIcons",x + wide/2 + math.Rand(-4,4),y + tall*0.2 + math.Rand(-12,12),Color(255,210,0,math.Rand(10,80)),TEXT_ALIGN_CENTER) 
	draw.SimpleText(self.IconLetter,"CSSelectIcons",x + wide/2 + math.Rand(-4,4),y + tall*0.2 + math.Rand(-9,9),Color(255,210,0,math.Rand(10,80)),TEXT_ALIGN_CENTER) 
end 

function SWEP:FreezeMovement()
	return false
end
function SWEP:ViewModelDrawn()
end
function SWEP:OnRestore()
end
function SWEP:OnRemove()
end
function SWEP:CustomAmmoDisplay()
end
function SWEP:TranslateFOV(current_fov)
	return current_fov
end
function SWEP:DrawWorldModel()
	self.Weapon:DrawModel()
end
function SWEP:DrawWorldModelTranslucent()
	self.Weapon:DrawModel()
end
function SWEP:AdjustMouseSensitivity()
	return nil
end

local IRONSIGHT_TIME = 0.25
function SWEP:GetViewModelPosition( pos, ang )
	
	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end

function PlayWeaponSound ( UMsg )
	local Ent = UMsg:ReadEntity();
	local Snd = UMsg:ReadString();
	
	if !IsValid(Ent) then return false; end
	
	Ent:EmitSound(Snd, 135, 100); 
end
usermessage.Hook('re_wep', PlayWeaponSound);
