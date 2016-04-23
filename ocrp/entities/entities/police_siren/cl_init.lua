include('shared.lua')

ENT.RenderGroup 	= RENDERGROUP_BOTH

local Lights = {}
Lights.Positions = {
{Vector(-34, 94, 38), Angle(0, 0, 0), Color(255,255,255,255), false};
{Vector(34, 94, 38), Angle(0, 0, 0), Color(255,255,255,255), true};
{Vector(-27, -105, 32), Angle(180, -180, 0), Color(255,0,0,255), false};
{Vector(27, -105, 32), Angle(180, -180, 0), Color(255,0,0,255), true};

{Vector(-6, -19, 81), Angle(0, 0, 0), Color(255,0,0,255), true};
{Vector(-6, -19, 81), Angle(180, -180, 0), Color(255,0,0,255), true};
{Vector(6, -19, 81), Angle(0, 0, 0), Color(0,0,255,255), false};
{Vector(6, -19, 81), Angle(180, -180, 0), Color(0,0,255,255), false};
{Vector(-18, -13, 80), Angle(0, 0, 0), Color(255,0,0,255), false};
{Vector(-18, -25, 80), Angle(180, -180, 0), Color(255,0,0,255), false};
{Vector(19, -12, 80), Angle(0, 0, 0), Color(0,0,255,255), true};
{Vector(19, -26, 80), Angle(180, -180, 0), Color(0,0,255,255), true};
--{Vector(-19, -13, 72), Angle(0, 0, 0), Color(255,0,0,255), false};
{Vector(-8, 115, 34), Angle(0, 0, 0), Color(255,0,0,255), true};
{Vector(8, 115, 34), Angle(0, 0, 0), Color(0,0,255,255), false};
--{Vector(-13, -9, 72), Angle(180, -180, 0), Color(0,0,255,255), false};
--{Vector(-6, -4, 72), Angle(0, 0, 0), Color(255,0,0,255), true};
--{Vector(-6, -4, 72), Angle(180, -180, 0), Color(255,0,0,255), true};]]
}
--[[Lights.PositionsOUT = {
{Vector(19, -13, 72), Angle(0, 0, 0), Color(255,0,0,255), true};
{Vector(19, -13, 72), Angle(180, -180, 0), Color(255,0,0,255), true};
{Vector(6, -4, 72), Angle(0, 0, 0), Color(255,0,0,255), false};
{Vector(6, -4, 72), Angle(180, -180, 0), Color(255,0,0,255), false};
{Vector(-19, -13, 72), Angle(0, 0, 0), Color(255,0,0,255), false};
{Vector(-19, -13, 72), Angle(180, -180, 0), Color(255,0,0,255), false};
{Vector(-6, -4, 72), Angle(0, 0, 0), Color(255,0,0,255), true};
{Vector(-6, -4, 72), Angle(180, -180, 0), Color(255,0,0,255), true};
}]]
--Headlights = Vector(3, -19, 81),
--Headlights = Vector(-27, -105, 32),
--Headlights = Vector(34, 94, 38),

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
	if GetConVarNumber("ocrp_advlights") == 1 then
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
		if dlight && (curLight==1 or curLight==2) then
			dlight.Pos = self.Parent:LocalToWorld(Vector(0,200,20))
			dlight.r = 255
			dlight.g = 255
			dlight.b = 255
			dlight.Brightness = 6
			dlight.Decay = 2000
			dlight.Size = 200
			dlight.DieTime = CurTime() + 0.1
		end
	--[[elseif self.Parent:IsVehicle() and self.Parent:GetDriver() == nil and GetConVarNumber("ocrp_advlights") == 1 then
		for k, v in pairs(Lights.PositionsOUT) do	
			local truePos = self.Parent:LocalToWorld(Vector(v[1].x, v[1].y, v[1].z))
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
		end]]
	--[[elseif GetConVarNumber("ocrp_advlights") == 0 then
		local dlight = DynamicLight( self:EntIndex() )
		if dlight && (curLight==1) then
			dlight.Pos = self.Parent:LocalToWorld(Vector(0,0,100))
			dlight.r = 255
			dlight.g = 0
			dlight.b = 0
			dlight.Brightness = 8
			dlight.Decay = 2000
			dlight.Size = 200
			dlight.DieTime = CurTime() + 0.05
		end
		if dlight && (curLight==2) then
			dlight.Pos = self.Parent:LocalToWorld(Vector(0,0,100))
			dlight.r = 0
			dlight.g = 0
			dlight.b = 255
			dlight.Brightness = 8
			dlight.Decay = 2000
			dlight.Size = 200
			dlight.DieTime = CurTime() + 0.05
		end]]
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
		self.sirenNoise_Duration = SoundDuration(siren) * 0.99;
		self.siren_alt = Sound("ocrp/siren_wail.mp3");
		self.sirenNoise_Alt = CreateSound(self.ourParent, self.siren_alt);
		self.sirenNoise_Alt_Duration = SoundDuration(self.siren_alt) * 0.99;
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
