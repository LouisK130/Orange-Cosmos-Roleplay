ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Vehicle Headlight"
ENT.Author			= "RealDope"
ENT.Contact			= "N/A"
ENT.RenderGroup 	= RENDERGROUP_BOTH

function ENT:Initialize()
	if SERVER then
	self:DrawShadow( false )
	self.Parent = self:GetParent()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	self:SetNWBool("On", false)
	end
	if CLIENT then
		self.PixVis = util.GetPixelVisibleHandle()
	end
end

function ENT:UpdateLight()

	if ( !IsValid( self.headlight ) ) then return end

	--self.headlight:Input( "SpotlightTexture", NULL, NULL, "sprites/glow_test02.vmt")
	self.headlight:Input( "FOV", NULL, NULL, self:GetFOV())
	self.headlight:SetKeyValue( "farz", self:GetDistance())
	self.headlight:SetKeyValue( "nearz", self:GetStartDistance())

	local c = self:GetColors()
	local b = self:GetBrightness()
	self.headlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r*b, c.g*b, c.b*b ) )

end

function ENT:GetOn()
	return self:GetNWBool("On")
end
function ENT:GetColors()
	local color1 = Color(0,0,0,255)
	if self:GetParent():GetNWString("Headlights") == "Blue" then
		color1.r = 0
		color1.g = 0
		color1.b = 255
	elseif self:GetParent():GetNWString("Headlights") == "Green" then
		color1.r = 0
		color1.g = 204
		color1.b = 0
	elseif self:GetParent():GetNWString("Headlights") == "Red" then
		color1.r = 204
		color1.g = 0
		color1.b = 0
	elseif self:GetParent():GetNWString("Headlights") == "Ice" then
		color1.r = 0
		color1.g = 50
		color1.b = 150
	elseif self:GetParent():GetNWString("Headlights") == "Purple" then
		color1.r = 145
		color1.g = 0
		color1.b = 255
	elseif self:GetParent():GetNWString("Headlights") == "Orange" then
        color1.r = 255
        color1.g = 152
        color1.b = 44
    elseif self:GetParent():GetNWString("Headlights") == "Yellow" then
        color1.r = 220
        color1.g = 220
        color1.b = 0
    elseif self:GetParent():GetNWString("Headlights") == "White" then
        color1.r = 255
        color1.g = 255
        color1.b = 255
    elseif self:GetParent():GetNWString("Headlights") == "Pink" then
        color1.r = 255
        color1.g = 130
        color1.b = 255
    end
	return color1
end
function ENT:GetFOV()
	return 50
end
function ENT:GetBrightness()
	if self:GetParent():GetNWString("Headlights") == "Blue" then
		return 5
	elseif self:GetParent():GetNWString("Headlights") == "Green" then
		return 3
	elseif self:GetParent():GetNWString("Headlights") == "Red" then
		return 5
	elseif self:GetParent():GetNWString("Headlights") == "Ice" then
		return 6
	elseif self:GetParent():GetNWString("Headlights") == "Purple" then
		return 5
	elseif self:GetParent():GetNWString("Headlights") == "Orange" then
		return 5
    elseif self:GetParent():GetNWString("Headlights") == "Yellow" then
		return 4
    elseif self:GetParent():GetNWString("Headlights") == "White" then
		return 4
    elseif self:GetParent():GetNWString("Headlights") == "Pink" then
		return 5
    end
end
function ENT:GetDistance()
	return 7500
end
function ENT:GetStartDistance()
	return 5
end
function ENT:Draw()
	--BaseClass.Draw(self)
end

function ENT:Switch(on)
	if self:GetOn() == on then return end
	self:SetNWBool("On", on)
	if !on then
		SafeRemoveEntity(self.headlight)
		self.headlight = nil
		return
	end
		self.headlight = ents.Create("env_projectedtexture")
		self.headlight:SetParent(self)
		self.headlight:SetLocalPos(Vector(0,0,0))
		self.headlight:SetLocalAngles(Angle(0,180,0))
		self.headlight:SetKeyValue("farz", self:GetDistance())
		self.headlight:SetKeyValue("nearz", 12)
		self.headlight:SetKeyValue("lightfov", self:GetFOV())
		self.headlight:SetKeyValue("enableshadows", 1)
		local c = self:GetColors()
		local b = self:GetBrightness()
		self.headlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r * b, c.g * b, c.b * b ) )
		self.headlight:Spawn()
		--self.headlight:Input("SpotlightTexture", NULL, NULL, "sprites/glow_test02.vmt")
end

function ENT:DrawTranslucent()
	--BaseClass.DrawTranslucent( self )
	
	-- No glow if we're not switched on!
	if ( !self:GetOn() ) then return end
	
	local LightNrm = self:GetAngles():Forward()
	local ViewNormal = self:GetPos() - EyePos()
	local Distance = ViewNormal:Length()
	ViewNormal:Normalize()
	local ViewDot = ViewNormal:Dot( LightNrm * 3 )
	local LightPos = self:GetPos()-Vector(0,0,5) + LightNrm * 5
	
	-- glow sprite
	
	render.SetMaterial( Material( "effects/lamp_beam" ) )
	
	local BeamDot = 0.25
	
	--[[render.StartBeam( 3 )
		render.AddBeam( LightPos + LightNrm * 1, 128, 0.0, Color( self:GetColors().r, self:GetColors().g, self:GetColors().b, 255 * BeamDot) )
		render.AddBeam( LightPos - LightNrm * 100, 128, 0.5, Color( self:GetColors().r, self:GetColors().g, self:GetColors().b, 64 * BeamDot) )
		render.AddBeam( LightPos - LightNrm * 200, 128, 1, Color( self:GetColors().r, self:GetColors().g, self:GetColors().b, 0) )
	render.EndBeam()]]

	if ( ViewDot >= 0 ) then
	
		render.SetMaterial(Material("sprites/light_ignorez"))
		local Visibile	= util.PixelVisible( LightPos, 16, self.PixVis )	
		
		if (!Visibile) then return end
		
		local Size = math.Clamp( Distance * Visibile * ViewDot * .25, 64, 512 )
		
		Distance = math.Clamp( Distance, 32, 800 )
		local Alpha = math.Clamp( (1000 - Distance) * Visibile * ViewDot, 0, 100 )
		local Col = self:GetColors()
		Col.a = Alpha
		
		render.DrawSprite( LightPos, Size, Size, Col, Visibile * ViewDot )
		render.DrawSprite( LightPos, Size*0.4, Size*0.4, Color(255, 255, 255, Alpha), Visibile * ViewDot )
		
	end
end
--[[if SERVER then
util.AddNetworkString("OCRP_ToggleHeadlight")
net.Receive("OCRP_ToggleHeadlight", function(len, ply)
	if TYPING then return end
	if not ply:InVehicle() then return end
	if not ply:GetVehicle() or !(ply:GetVehicle():GetDriver() == ply) then return end
	if not ply:GetVehicle().h1 or not ply:GetVehicle().h2 or not ply:GetVehicle().h1:IsValid() or not ply:GetVehicle().h2:IsValid() then
		ply:Hint("You don't have headlights installed!")
		return
	end
	ply:GetVehicle().h1:Switch(!ply:GetVehicle().h1:GetOn())
	ply:GetVehicle().h2:Switch(!ply:GetVehicle().h2:GetOn())
end)
end

if CLIENT then
	local released = true
	hook.Add("Think", "OCRP_CheckHeadlightToggle", function()
		if not LocalPlayer():InVehicle() then return end
		if gui.IsConsoleVisible() then return end
		if not LocalPlayer():GetVehicle():GetClass() == "prop_vehicle_jeep" then return end
		if input.IsKeyDown(KEY_F) and released then
			net.Start("OCRP_ToggleHeadlight")
			net.SendToServer()
			released = false
		end
		if !input.IsKeyDown(KEY_F) and !released then
			released = true
		end
	end)
end]]