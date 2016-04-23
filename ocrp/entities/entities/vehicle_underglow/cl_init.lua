include( "shared.lua" )

ENT.RenderGroup 	= RENDERGROUP_BOTH

function ENT:Draw() 
	self:DrawTranslucent() 
end

function ENT:Initialize()
	self:SetNotSolid( true )
	self:DrawShadow( false )
	self.PixVis = util.GetPixelVisibleHandle()
	self.Parent = self:GetParent()
end

--[[
Underglow Colors
Blue = 0,0,204,255
Green = 0,204,0,255
Red = 204,0,0,255
Very Light Blue = 0,50,150,255
Purple = 204,0,51,255
--]]

function ENT:DrawTranslucent()
	if not IsValid( self.Parent ) then
		self.Parent = self:GetParent()
	end
	if not self.Parent:GetNWBool("GlowOn") then 
		return 
	end
	
	local GlowLight = DynamicLight( self:EntIndex() )
	GlowLight.Pos = self.Parent:LocalToWorld( Vector(0, 0, 20) )
	if self:GetNWBool("Fire") then
		GlowLight.Pos = self.Parent:LocalToWorld(Vector(0,0,50))
	end
		
	if self.Parent:GetNWString("Underglow") == "Blue" then
		GlowLight.r = 0
		GlowLight.g = 0
		GlowLight.b = 255
	elseif self.Parent:GetNWString("Underglow") == "Green" then
		GlowLight.r = 0
		GlowLight.g = 204
		GlowLight.b = 0
	elseif self.Parent:GetNWString("Underglow") == "Red" then
		GlowLight.r = 204
		GlowLight.g = 0
		GlowLight.b = 0
	elseif self.Parent:GetNWString("Underglow") == "Ice" then
		GlowLight.r = 0
		GlowLight.g = 50
		GlowLight.b = 150
	elseif self.Parent:GetNWString("Underglow") == "Purple" then
		GlowLight.r = 145
		GlowLight.g = 0
		GlowLight.b = 255
	elseif self.Parent:GetNWString("Underglow") == "Orange" then
        GlowLight.r = 255
        GlowLight.g = 152
        GlowLight.b = 44
    elseif self.Parent:GetNWString("Underglow") == "Yellow" then
        GlowLight.r = 220
        GlowLight.g = 220
        GlowLight.b = 0
    elseif self.Parent:GetNWString("Underglow") == "White" then
        GlowLight.r = 255
        GlowLight.g = 255
        GlowLight.b = 255
    elseif self.Parent:GetNWString("Underglow") == "Pink" then
        GlowLight.r = 255
        GlowLight.g = 130
        GlowLight.b = 255
    end
	GlowLight.Brightness = 7
	GlowLight.Decay = 2000
	GlowLight.Size = 150
	GlowLight.DieTime = CurTime() + 0.2
	
	if not self.ourParent and not self:GetNWBool("Fire") then
		local closestDist = 10000
		local closest
		
		for k, v in pairs( ents.FindByClass("prop_vehicle_jeep") ) do
			local distance = v:GetPos():Distance( self:GetPos() )
			if distance < closestDist then
				closest = v
				closestDist = distance
			end
		end
				
		if not closest then 
			return 
		end
	
		self.ourParent = closest
	end
end