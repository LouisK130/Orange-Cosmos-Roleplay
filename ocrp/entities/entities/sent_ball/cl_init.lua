
include('shared.lua')

ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT

local matBall = Material( "sprites/sent_ball" )

--[[---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------]]
function ENT:Initialize()
	
	local i = math.random( 0, 3 )
	
	if ( i == 0 ) then
		self.Color = Color( 255, 0, 0, 255 )
	elseif ( i == 1 ) then
		self.Color = Color( 0, 255, 0, 255 )
	elseif ( i == 2 ) then
		self.Color = Color( 255, 255, 0, 255 )
	else
		self.Color = Color( 0, 0, 255, 255 )
	end
	
	self.LightColor = Vector( 0, 0, 0 )
	
end

--[[---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------]]
function ENT:Draw()
	
	local pos = self.Entity:GetPos()
	local vel = self.Entity:GetVelocity()
		
	render.SetMaterial( matBall )
	
	local lcolor = render.GetLightColor( self:GetPos() ) * 2
	
	lcolor.x = self.Color.r * mathx.Clamp( lcolor.x, 0, 1 )
	lcolor.y = self.Color.g * mathx.Clamp( lcolor.y, 0, 1 )
	lcolor.z = self.Color.b * mathx.Clamp( lcolor.z, 0, 1 )
		
	if ( vel:Length() > 1 ) then
	
		for i = 1, 10 do
		
			local col = Color( lcolor.x, lcolor.y, lcolor.z, 200 / i )
			render.DrawSprite( pos + vel*(i*-0.005), 32, 32, col )
			
		end
	
	end
		
	render.DrawSprite( pos, 32, 32, Color( lcolor.x, lcolor.y, lcolor.z, 255 ) )
	
end


