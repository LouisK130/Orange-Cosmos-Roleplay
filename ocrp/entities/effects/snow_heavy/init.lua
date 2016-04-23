///////////////////////////////
// © 2009-2010 Pulsar Effect //
//    All rights reserved    //
///////////////////////////////
// This material may not be  //
//   reproduced, displayed,  //
//  modified or distributed  //
// without the express prior //
// written permission of the //
//   the copyright holder.   //
///////////////////////////////


function EFFECT:Init ( data )
	self.time = CurTime() + 1;
end

local function snowCollide ( particle, hitPos )
	if (GAMEMODE.SnowOnGround) then
		particle:SetDieTime(0);
	else
		particle:SetStartAlpha(255);
		particle:SetEndAlpha(0);
	end
end

function EFFECT:Emit ( )
	local Filter = LocalPlayer();
	local PredictSpeed = LocalPlayer():GetVelocity();
	
	if LocalPlayer():InVehicle() then
		Filter = {LocalPlayer(), LocalPlayer():GetVehicle()}
		PredictSpeed = LocalPlayer():GetVehicle():GetVelocity()
	end
	
	//local PredictSpeed = PredictSpeed;
	PredictSpeed = Vector(PredictSpeed.x, PredictSpeed.y, 0);

	local SpawnPos = GAMEMODE.GetWeatherSpawnPos(PredictSpeed, Filter);
	
	for i = 0, 500 do
		local a = math.random(9999)
		local b = math.random(1,180)
		local dist = math.random(256,2000)
		local X = math.sin(b) * math.sin(a) * dist
		local Y = math.sin(b) * math.cos(a) * dist
		local offset = Vector(X,Y,0)
		local spawnpos = SpawnPos + offset;
		local point = util.PointContents(spawnpos)
		local isfree = point != CONTENTS_SOLID 
		and point != CONTENTS_MOVEABLE 
		and point != CONTENTS_LADDER 
		and point != CONTENTS_PLAYERCLIP 
		and point != CONTENTS_MONSTERCLIP
		and point != CONTENTS_WATER
		
		if isfree then
		
		local velocity = Vector(math.random(0, 40), math.random(0, 40), math.random(-300, -100));
		spawnpos = spawnpos + Vector(velocity.x, velocity.y, 0);
		
		if (GetVectorTraceUp(spawnpos).HitSky) then
			local particle = GLOBAL_EMITTER:Add("particle/snow", spawnpos)
			
			if (particle) then
				particle:SetVelocity(velocity);
				particle:SetLifeTime(0);
				particle:SetDieTime(10);
				particle:SetStartAlpha(100);
				particle:SetEndAlpha(255);
				particle:SetStartSize(2);
				particle:SetEndSize(2);
				particle:SetAirResistance(0);
				particle:SetCollide(true);
				particle:SetColor(200, 200, 200, 255)
				
				particle:SetCollideCallback(snowCollide);
			end
		end
		end
	end
end

function EFFECT:Think ( )
	if (self.time > CurTime()) then
		self:Emit();
	else
		return false;
	end
end

function EFFECT:Render ( )

end
