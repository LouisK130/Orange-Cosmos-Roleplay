include('shared.lua')

ENT.RenderGroup 	= RENDERGROUP_BOTH

local Lights = {}
Lights.Positions = {
{Vector(-38, 218, 32), Angle(0, 0, 0), Color(255,255,255,0), false};
{Vector(38, 218, 32), Angle(0, 0, 0), Color(255,255,255,0), true};
{Vector(-39, 199, 56), Angle(0, 0, 0), Color(255,255,255,0), true};
{Vector(-30, 199, 56), Angle(0, 0, 0), Color(255,255,255,0), true};
{Vector(39, 199, 56), Angle(0, 0, 0), Color(255,255,255,0), false};
{Vector(30, 199, 56), Angle(0, 0, 0), Color(255,255,255,0), false};

{Vector(-42, -180, 63), Angle(180, -180, 0), Color(255,0,0,0), false};
{Vector(42, -180, 63), Angle(180, -180, 0), Color(255,0,0,0), true};
{Vector(-42, -180, 50), Angle(180, -180, 0), Color(255,0,0,0), true};
{Vector(42, -180, 50), Angle(180, -180, 0), Color(255,0,0,0), false};

{Vector(-40, -175, 124), Angle(180, -180, 0), Color(255,255,255,0), false};
--{Vector(-40, -175, 124), Angle(0, 0, 0), Color(255,255,255,0), false};
{Vector(-32, -175, 124), Angle(180, -180, 0), Color(255,255,255,0), false};
--{Vector(-32, -175, 124), Angle(0, 0, 0), Color(255,255,255,0), false};
{Vector(40, -175, 124), Angle(180, -180, 0), Color(255,255,255,0), true};
--{Vector(40, -175, 124), Angle(0, 0, 0), Color(255,255,255,0), true};
{Vector(32, -175, 124), Angle(180, -180, 0), Color(255,255,255,0), true};
--{Vector(32, -175, 124), Angle(0, 0, 0), Color(255,255,255,0), true};

{Vector(-30, 155, 125), Angle(0, 0, 0), Color(255,0,0,0), true};
--{Vector(-30, 155, 125), Angle(180, -180, 0), Color(255,0,0,0), true};
{Vector(-40, 155, 123), Angle(0, 0, 0), Color(255,0,0,0), true};
--{Vector(-40, 155, 123), Angle(180, -180, 0), Color(255,0,0,0), true};
{Vector(8, 160, 125), Angle(0, 0, 0), Color(255,255,255,0), false};
--{Vector(8, 160, 125), Angle(180, -180, 0), Color(255,255,255,0), false};
{Vector(0, 160, 125), Angle(0, 0, 0), Color(255,255,255,0), false};
--{Vector(0, 160, 125), Angle(180, -180, 0), Color(255,255,255,0), false};
{Vector(-8, 160, 125), Angle(0, 0, 0), Color(255,255,255,0), false};
--{Vector(-8, 160, 125), Angle(180, -180, 0), Color(255,255,255,0), false};
{Vector(30, 155, 125), Angle(0, 0, 0), Color(255,0,0,0), true};
--{Vector(30, 155, 125), Angle(180, -180, 0), Color(255,0,0,0), true};
{Vector(40, 155, 123), Angle(0, 0, 0), Color(255,0,0,0), true};
--{Vector(40, 155, 123), Angle(180, -180, 0), Color(255,0,0,0), true};
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
			local truePos = self.Parent:LocalToWorld(Vector(v[1].x, v[1].y, v[1].z))
			local trueAng = Angle(0, v[2].y, v[2].r) - Angle(-90, 90, 0) + self.Parent:GetAngles()
			local LightNrm = trueAng:Up()
			local ViewNormal = truePos - EyePos()
			ViewNormal:Normalize()
			local ViewDot = ViewNormal:Dot( LightNrm )
			local LightOrigin = truePos + ViewNormal * -6
			
			if ( ViewDot >= 0 ) then
				render.SetMaterial( matLight )
				
				-- local Visibile	= util.PixelVisible( truePos, 16, self.PixVis )
				local Visibile = util.PixelVisible( truePos, 32, self.PixVis)
				if Visibile then
					local Col = Color(v[3].r, v[3].g, v[3].b, 255)
					if curLight==1 && v[4]==false then
						render.DrawSprite(LightOrigin, Size, Size, Col, Visibile * ViewDot)
					elseif curLight==2 && v[4]==true then
						render.DrawSprite(LightOrigin, Size, Size, Col, Visibile * ViewDot)
					end
				end
			end
		end
	end
	local dlight = DynamicLight( self:EntIndex() )
	if dlight && (curLight==1) then
		dlight.Pos = self.Parent:LocalToWorld(Vector(0,300,20))
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.Brightness = 6
		dlight.Decay = 2000
		dlight.Size = 200
		dlight.DieTime = CurTime() + 0.1
	elseif dlight && (curLight==2) then
		dlight.Pos = self.Parent:LocalToWorld(Vector(0,200,150))
		dlight.r = 255
		dlight.g = 0
		dlight.b = 0
		dlight.Brightness = 6
		dlight.Decay = 2000
		dlight.Size = 512
		dlight.DieTime = CurTime() + 0.1
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
		sirenambo =  Sound("ocrp/ambulance_siren.mp3");
		self.sirenNoiseambo = CreateSound(self.ourParent, sirenambo);
		self.sirenNoise_Durationambo = SoundDuration(sirenambo) * .98;
	end
	if (self:GetNWBool("siren", false)) then
				if (self.LastSirenPlay_Alt) then
					self.sirenNoise_Alt:Stop();
					self.LastSirenPlay_Alt = nil;
				end
			
				if (!self.LastSirenPlay || self.LastSirenPlay <= CurTime()) then
					self.LastSirenPlay = CurTime() + 6.7;
					self.sirenNoiseambo:Stop();
					self.sirenNoiseambo:Play();
				end
			
	elseif (self.LastSirenPlay) then
			self.sirenNoiseambo:Stop();
			self.LastSirenPlay = nil;
	end
end
