
include('shared.lua')

--[[---------------------------------------------------------
   Name: DrawTranslucent
   Desc: Draw translucent
---------------------------------------------------------]]
function ENT:Draw()
end

function ENT:Think ( )	
	--[[
	local Trace = {}
	Trace.start = LocalPlayer():GetShootPos()
	Trace.endpos = self:GetPos();
	Trace.filter = {LocalPlayer(), self};
	Trace.mask = MASK_OPAQUE;
	local TraceRes = util.TraceLine(Trace);

	if TraceRes.Hit then return false; end
	]]
	
	if !LocalPlayer():CanSee(self) and !LocalPlayer():InVehicle() then return false; end
	if self.LastEffect + .15 < CurTime() then
		self.LastEffect = CurTime();
		
		local effect = EffectData();
			effect:SetOrigin(self:GetPos());
		util.Effect("fire", effect);
	end
	
	if self.LastPlayTime + self.InBetween < CurTime() then
		self.SoundEffect:Stop();
		self.SoundEffect:Play();
		self.LastPlayTime = CurTime();
	end
end

function ENT:Initialize ( )	
	self.LastEffect = CurTime();
	
	self.SoundID = math.random(1, 2);
	
	if self.SoundID == 1 then
		self.SoundEffect = CreateSound(self, Sound('ambient/fire/fire_med_loop1.wav'));
		self.InBetween = 6.5;
	elseif self.SoundID == 2 then
		self.SoundEffect = CreateSound(self, Sound('ambient/fire/firebig.wav'));
		self.InBetween = 5;
	else -- wtf jake this isn't ever gonna happen
		self.SoundEffect = CreateSound(self, Sound('ambient/fire/fire_big_loop1.wav'));
		self.InBetween = 5;
	end
	
	self.LastPlayTime = 0;
end

function ENT:OnRemove ( )
	self.SoundEffect:Stop();
end

