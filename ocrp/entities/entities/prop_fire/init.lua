
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local Distance = 75
local NumFireFighters = 0
local MaxFires = 40;
local NumberOfFires = 0;

function ENT:Initialize()
	self.Entity:SetModel("models/props_junk/wood_pallet001a.mdl");

	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:SetAngles(Angle(0, 0, 0));
	self.Entity:SetPos(self:GetPos() + Vector(0, 0, 10));
	
	self:SetNWString("Underglow", "Orange")
	self:SetNWBool("GlowOn", true)
	local glow = ents.Create("vehicle_underglow")
	glow:SetNWBool("Fire", true)
	glow:SetPos(self:GetPos() + Vector(0,0,100))
	glow:SetParent(self)
	glow:Spawn()
	
	self.LastSpread = CurTime();
	self.SpawnTime = CurTime();
	
	NumberOfFires = NumberOfFires + 1;
	
	self.LastDamage = CurTime();
	self.ExtinguisherLeft = math.random(70, 100);
	self.Spores = 0;
	self.HealthAdd = CurTime();
	
	self:DrawShadow(false);
	self.IsAlive = true;
	
	MaxFires = 40 + (NUMBER_FIREMEN * 20)
end

function ENT:SpreadFire()
	if NumberOfFires >= MaxFires then return false; end
	// Try 5 times to spread.
    local heights = {0, 25, 50, 75}
	for i = 1, 5 do
		local RandomStart = self:GetPos() + Vector(math.Rand(-1, 1) * Distance, math.Rand(-1, 1) * Distance, table.Random(heights));
		local UsStart = self:GetPos() + Vector(0, 0, 10);
		// trace to the random spot from us
		local Trace = {};
		Trace.start = UsStart;
		Trace.endpos = RandomStart;
		Trace.filter = self.Entity;
		Trace.mask = MASK_OPAQUE;
		
		local TR1 = util.TraceLine(Trace);
		
		// trace back to make sure theres nothing there
			
		local Trace2 = {};
		Trace2.start = RandomStart;
		Trace2.endpos = UsStart;
		Trace2.filter = self.Entity;
		Trace2.mask = MASK_OPAQUE;
			
		local TR2 = util.TraceLine(Trace2);
		
		if (TR1.Hit and TR2.Hit) or (!TR1.Hit and !TR2.Hit) then
			// trace down to make sure it's not a sheer cliff, or the like
			
			local TrStart = RandomStart;
			local TrEnd = TrStart - Vector(0, 0, 100);
			
			local Trace = {};
			Trace.start = TrStart;
			Trace.endpos = TrEnd;
			Trace.filter = self.Entity;
				
			local TraceResults = util.TraceLine(Trace);
				
			if TraceResults.HitWorld then
				if util.IsInWorld(TraceResults.HitPos) then
					if TraceResults.MatType == MAT_DIRT or 
						TraceResults.MatType == MAT_WOOD or
						TraceResults.MatType == MAT_COMPUTER or
						TraceResults.MatType == MAT_FOLIAGE or
						TraceResults.MatType == MAT_PLASTIC or
						TraceResults.MatType == MAT_SAND or
						TraceResults.MatType == MAT_SLOSH or
						TraceResults.MatType == MAT_TILE or
						TraceResults.MatType == MAT_VENT or
                        TraceResults.MatType == MAT_CONCRETE then

						local NearbyEnts = ents.FindInSphere(TraceResults.HitPos, Distance * .5);
									
						local NearShroom = false;
						for k, v in pairs(NearbyEnts) do
							if v:GetClass() == 'prop_fire' then
								NearShroom = true;
							end
						end
								
						if !NearShroom then
							local Shroom = ents.Create('prop_fire');
							Shroom:SetPos(TraceResults.HitPos);
							Shroom:Spawn();
							self.Spores = self.Spores + 1;
							return;
						end
					end
				end
			end
		end
	end
end

function ENT:KillFire ( ) 
	if self.IsAlive then
		NumberOfFires = NumberOfFires - 1;
		self.IsAlive = false;
	end
	
	self:Remove();
end

function ENT:HitByExtinguisher ( ByWho, IsHose )
	if IsHose then
		self.ExtinguisherLeft = self.ExtinguisherLeft - math.random(15, 20);
	else
		self.ExtinguisherLeft = self.ExtinguisherLeft - math.random(1, 5);
	end
	
	if self.ExtinguisherLeft <= 0 then
		if ByWho and ByWho:IsValid() and ByWho:IsPlayer() then
			if IsHose then
				ByWho:AddMoney(WALLET, 5);
			else
				ByWho:AddMoney(WALLET, 10);
			end
		end
		
		self:KillFire();
	end
end

function ENT:Think ( )
	if self.Spores >= 60 then self:KillFire(); return false; end
	if self:WaterLevel() > 0 then self:KillFire(); return false; end

	local Trace = {};
	Trace.start = self:GetPos();
	Trace.endpos = self:GetPos() + Vector(0, 0, 500)
	Trace.mask = MASK_VISIBLE;
	Trace.filter = self;
    
    local TR = util.TraceLine(Trace);
	local IsOutdoors = TR.HitPos == Trace.endpos;
    
    if IsOutdoors then
        if AtmosGlobal:GetStorming() then
            if not self.RainGoOutTime then
                self.RainGoOutTime = CurTime() + math.random(5, 60)
            end
            if CurTime() >= self.RainGoOutTime then
                self:KillFire()
                return false
            end
        elseif AtmosGlobal:GetSnowing() then
            if not self.SnowGoOutTime then
                self.SnowGoOutTime = CurTime() + math.random(15, 90)
            end
            if CurTime() >= self.SnowGoOutTime then
                self:KillFire()
                return false
            end
        else
            self.RainGoOutTime = nil
            self.SnowGoOutTime = nil
        end
    end
		
	
    if self.HealthAdd + 10 < CurTime() then 
        self.HealthAdd = CurTime(); 
        self.ExtinguisherLeft = math.Clamp(self.ExtinguisherLeft + 1, 0, 120); 
    end

    if self.LastSpread + 15 < CurTime() then
        self:SpreadFire();
        self.LastSpread = CurTime();
    end
	
	
	if self.LastDamage and self.LastDamage + .1 < CurTime() then
		local CloseEnts = ents.FindInSphere(self:GetPos(), math.random(10, 70));
		
		
		self.LastDamage = CurTime();
		
		for k , v in pairs(CloseEnts) do
			if (v:GetClass() == 'prop_physics' or v:GetClass() == 'item_base' or v:GetClass() == 'drug_Weed') then
                if v:GetModel() and v:GetModel() == "models/extras/info_speech.mdl" then return end
				v:GetTable().FireDamage = v:GetTable().FireDamage or 60;
				v:GetTable().FireDamage = v:GetTable().FireDamage - 1;
				
				if v:GetTable().FireDamage == 0 then
					if v:GetModel() == 'models/props_junk/propanecanister001a.mdl' then
						WorldSound(Sound('ambient/explosions/explode_' .. math.random(1, 7) .. '.wav'), v:GetPos(), 150, 255);
						
						for i = 1, 3 do
							self:SpreadFire();
						end
					end
					
					if v:GetClass() == 'item_base' then
						v.ItemSpawner:GetTable().NumProps = v.ItemSpawner:GetTable().NumProps - 1;
					end
					
					v:Remove();
				else
					if !v:IsOnFire() then
						v:Ignite(60, 100);
					end
					
					local C = (v:GetTable().FireDamage / 60) * 255;
					v:SetColor(Color(C, C, C, 255));
				end
            elseif v:GetClass() == "prop_vehicle_jeep" then
                if v:GetModel() == "models/sickness/truckfire.mdl" then return end
                v.LastDamage = v.LastDamage or 0
                if CurTime() - v.LastDamage > .2 then
                    v:TakeCarDamage(15)
                    v.LastDamage = CurTime()
                end
			elseif v:IsPlayer() and v:Alive() and v:GetPos():Distance(self:GetPos()) < 70 then
				if v:Team() != CLASS_FIREMAN then
					v:TakeDamage(2, self, self);
					
					if v:GetPos():Distance(self:GetPos()) < 50 and v:Team() != CLASS_FIREMAN then
						v:TakeDamage(10, self, self);
					end
				else
					v:GetTable().LastFireDamage = v:GetTable().LastFireDamage or 0;
					
					if v:GetTable().LastFireDamage + 1 < CurTime() then
						v:TakeDamage(1, self, self);
					end
				end
			end
		end
	end
end

function ENT:Use( activator, caller )

end

