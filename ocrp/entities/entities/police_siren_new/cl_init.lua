
include('shared.lua')

ENT.RenderGroup 	= RENDERGROUP_BOTH

local Lights = {}
Lights.Positions = {
{Vector(-32, 112, 36), Angle(0, 0, 0), Color(255,255,255,255), false};
{Vector(32, 112, 36), Angle(0, 0, 0), Color(255,255,255,255), false};
{Vector(-28, -106, 50), Angle(180, -180, 0), Color(255,0,0,255), false};
{Vector(28, -106, 50), Angle(180, -180, 0), Color(255,0,0,255), true};

{Vector(0, 0, 76), Angle(0, 0, 0), Color(0,0,255,255), true};
{Vector(6, 0, 76), Angle(0, 0, 0), Color(0,0,255,255), true};
{Vector(12, 0, 76), Angle(0, 0, 0), Color(0,0,255,255), true};
{Vector(18, 0, 76), Angle(0, 0, 0), Color(0,0,255,255), true};
{Vector(24, 0, 76), Angle(0, 0, 0), Color(0,0,255,255), true};
{Vector(30, -2, 76), Angle(0, -45, 0), Color(0,0,255,255), true};
{Vector(-6, 0, 76), Angle(0, 0, 0), Color(0,0,255,255), true};
{Vector(-12, 0, 76), Angle(0, 0, 0), Color(0,0,255,255), true};
{Vector(-18, 0, 76), Angle(0, 0, 0), Color(0,0,255,255), true};
{Vector(-24, 0, 76), Angle(0, 0, 0), Color(0,0,255,255), true};
{Vector(-30, -2, 76), Angle(0, 45, 0), Color(0,0,255,255), true};

{Vector(0, -12, 76), Angle(180, -180, 0), Color(0,0,255,255), true};
{Vector(6, -12, 76), Angle(180, -180, 0), Color(0,0,255,255), true};
{Vector(12, -12, 76), Angle(180, -180, 0), Color(0,0,255,255), true};
{Vector(18, -12, 76), Angle(180, -180, 0), Color(0,0,255,255), true};
{Vector(24, -12, 76), Angle(180, -180, 0), Color(0,0,255,255), true};
{Vector(30, -10, 76), Angle(180, -135, 0), Color(0,0,255,255), true};
{Vector(-6, -12, 76), Angle(180, -180, 0), Color(0,0,255,255), true};
{Vector(-12, -12, 76), Angle(180, -180, 0), Color(0,0,255,255), true};
{Vector(-18, -12, 76), Angle(180, -180, 0), Color(0,0,255,255), true};
{Vector(-24, -12, 76), Angle(180, -180, 0), Color(0,0,255,255), true};
{Vector(-30, -10, 76), Angle(180, -225, 0), Color(0,0,255,255), true};
}

function ENT:Draw ( ) self:DrawTranslucent() end

function ENT:Initialize ( )	
	self:SetNotSolid(true)
	self:DrawShadow(false)
	self.PixVis = util.GetPixelVisibleHandle()
	self.Parent = self:GetParent()
end

ENT.TimeSound = 0
local matLight = Material( "sprites/light_glow02_add" )
local Size = 50

function ENT:DrawTranslucent()
	if not self.Parent:IsValid() then
		self.Parent = self:GetParent()
	end
	if !self:GetNWBool("On") then return end
	--Light Timer
	local shouldBeOn_1, shouldBeOn_2
	local shouldBeOn_C = math.sin(CurTime() * 8)
	if (shouldBeOn_C > .5 && shouldBeOn_C < .9) then
		shouldBeOn_1 = true
	elseif (shouldBeOn_C > -0.9 && shouldBeOn_C < -0.5) then
		shouldBeOn_2 = true
	end
	local curLight = 0
	if (shouldBeOn_1) then curLight = 1 end
	if (shouldBeOn_2) then curLight = 2 end
	
	--LightPlacement
	if GetConVarNumber("ocrp_advlights") == 1 then --Only displays the sprites if the driver is present (reduces lag)
		for k, v in pairs(Lights.Positions) do	
			local truePos = self.Parent:LocalToWorld(Vector(v[1].x+24, v[1].y, v[1].z))
			local trueAng = Angle(0, v[2].y, v[2].r) - Angle(-90, 90, 0) + self.Parent:GetAngles()
			local LightNrm = trueAng:Up()
			local ViewNormal = truePos - EyePos()
			ViewNormal:Normalize()
			local ViewDot = ViewNormal:Dot( LightNrm )
			local LightOrigin = truePos + ViewNormal * -6
			
			if ( ViewDot >= 0 ) then
				render.SetMaterial( matLight )
				
				local Visibile	= util.PixelVisible( LightOrigin, 16, self.PixVis )
				if (Visibile) then
					local Col = v[3]
					if curLight==1 && v[4]==false then
						render.DrawSprite(LightOrigin, Size, Size, Col, Visibile * ViewDot)
					elseif curLight==2 && v[4]==true then
						render.DrawSprite(LightOrigin, Size, Size, Col, Visibile * ViewDot)
					end
				end
			end
		end
		local dlight = DynamicLight( self:EntIndex() )
		if dlight && curLight==2 then
			dlight.Pos = self.Parent:LocalToWorld(Vector(24,0,150))
			dlight.r = 0
			dlight.g = 0
			dlight.b = 255
			dlight.Brightness = 8
			dlight.Decay = 2000
			dlight.Size = 200
			dlight.DieTime = CurTime() + 0.05
		elseif dlight && curLight==1 then
			dlight.Pos = self.Parent:LocalToWorld(Vector(24,200,30))
			dlight.r = 255
			dlight.g = 255
			dlight.b = 255
			dlight.Brightness = 6
			dlight.Decay = 2000
			dlight.Size = 200
			dlight.DieTime = CurTime() + 0.05
		end
	end
end

function ENT:Think()
	if (!self.ourParent) then
		local closestDist = 10000;
		local closet;
		
		for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
			local dist = v:GetPos():Distance(self:GetPos());
			if (dist < closestDist) then
				closest = v;
				closestDist = dist;
			end
		end
				
		if (!closest) then return; end
	
		self.ourParent = closest;
		siren =  Sound("ocrp/siren_long.mp3");
		self.sirenNoise = CreateSound(self.ourParent, siren);
		self.sirenNoise_Duration = SoundDuration(siren) * 0.98;
		self.siren_alt = Sound("ocrp/siren_wail.mp3");
		self.sirenNoise_Alt = CreateSound(self.ourParent, self.siren_alt);
		self.sirenNoise_Alt_Duration = SoundDuration(self.siren_alt) * 0.98;
	end
	if (self:GetNWBool("siren", false)) then
		if (self:GetNWBool("siren_loud", false)) then
			if (self.LastSirenPlay) then
				self.sirenNoise:Stop();
				self.LastSirenPlay = nil;
			end
		
			if (!self.LastSirenPlay_Alt || self.LastSirenPlay_Alt <= CurTime()) then
				self.LastSirenPlay_Alt = CurTime() + 2.85;
				self.sirenNoise_Alt:Stop();
				self.sirenNoise_Alt:Play();
			end
		else
			if (self.LastSirenPlay_Alt) then
				self.sirenNoise_Alt:Stop();
				self.LastSirenPlay_Alt = nil;
			end 

			if (!self.LastSirenPlay || self.LastSirenPlay <= CurTime()) then
				self.LastSirenPlay = CurTime() + 3.9;
				self.sirenNoise:Stop();
				self.sirenNoise:Play();
			end
		end
	elseif (self.LastSirenPlay) then
		self.sirenNoise:Stop();
		self.LastSirenPlay = nil;
	elseif (self.LastSirenPlay_Alt) then
		self.sirenNoise_Alt:Stop();
		self.LastSirenPlay_Alt = nil;
	end
end
