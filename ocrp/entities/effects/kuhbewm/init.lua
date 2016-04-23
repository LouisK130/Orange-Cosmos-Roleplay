local Textures = {}
Textures.Glow1 = Material("sprites/light_glow02")
Textures.Glow2 = Material("sprites/flare1")
for k,mat in pairs(Textures) do
	mat:SetInt("$spriterendermode",9)
	mat:SetInt("$ignorez",1)
	mat:SetInt("$illumfactor",8)
end

function EFFECT:Init(data)
	local vOffset = data:GetOrigin()
			
	if LocalPlayer():GetPos():Distance(vOffset) < 750 then
		surface.PlaySound("ambient/explosions/explode_" .. math.random(1, 4) .. ".wav");
	else
		surface.PlaySound('ambient/explosions/explode_9.wav');
	end

	self.Scale = data:GetScale()
	self.ScaleSlow = math.sqrt(self.Scale)
	self.ScaleSlowest = math.sqrt(self.ScaleSlow)
	self.Normal = data:GetNormal()
	self.RightAngle = self.Normal:Angle():Right():Angle()
	self.Position = data:GetOrigin() - 12*self.Normal
	self.Position2 = self.Position + self.Scale*64*self.Normal
	local CurrentTime = CurTime()
	self.Duration = 0.5*self.Scale 
	self.KillTime = CurrentTime + self.Duration
	self.GlowAlpha = 200
	self.GlowSize = 100*self.Scale
	self.FlashAlpha = 100
	self.FlashSize = 0
	local emitter = ParticleEmitter(self.Position)
	for i=1,math.ceil(self.Scale*math.random(1,10)) do

	end
	for i=1,math.ceil(self.Scale*120) do
		local vecang = VectorRand()*8
		local particle = emitter:Add("particle/particle_smokegrenade",self.Position - vecang*9*k)
		particle:SetColor(80,80,80,255)
		particle:SetVelocity((math.Rand(50,400)*vecang)*self.Scale)
		particle:SetDieTime(math.Rand(7,9)*self.Scale)
		particle:SetAirResistance(150)
		particle:SetStartAlpha(150)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(300,300)*self.ScaleSlow)
		particle:SetEndSize(math.Rand(300,300)*self.ScaleSlow)
		particle:SetRoll(math.Rand(20,80))
		particle:SetRollDelta(0.6*math.random(-1,1))
	end
	for i=1,math.ceil(self.Scale*50) do
		local vecang = VectorRand()*8	
		local particle = emitter:Add("Effects/fire_cloud"..math.random(1,2),self.Position - vecang*9*k)
		particle:SetColor(200,200,200,255)
		particle:SetVelocity((math.Rand(50,200)*vecang)*self.Scale)
		particle:SetDieTime(math.Rand(0.5,2)*self.Scale)
		particle:SetAirResistance(150)
		particle:SetStartAlpha(150)                        
		particle:SetEndAlpha(0)                        
		particle:SetStartSize(math.Rand(25,300)*self.ScaleSlow)
		particle:SetEndSize(math.Rand(25,300)*self.ScaleSlow)
		particle:SetRoll(math.Rand(20,80))
		particle:SetRollDelta(0.6*math.random(-1,1))
		if math.random(1,10) == 1 then
			local vecang = VectorRand()*8	
			local particle = emitter:Add("Effects/fire_embers"..math.random(1,3),self.Position - vecang*9*k)
			particle:SetColor(200,200,200,255)
			particle:SetVelocity((math.Rand(10,30)*vecang)*self.Scale)
			particle:SetDieTime(math.Rand(8,10)*self.Scale)
			particle:SetAirResistance(30)
			particle:SetStartAlpha(255)                        
			particle:SetEndAlpha(200)                        
			particle:SetStartSize(math.Rand(2,10)*self.ScaleSlow)
			particle:SetEndSize(math.Rand(2,10)*self.ScaleSlow)
			particle:SetRoll(math.Rand(20,100))
			particle:SetRollDelta(0.6*math.random(-3,3))
			particle:SetGravity(Vector(0,0,200))
		end
	end
	emitter:Finish()
end

function EFFECT:Think()
	local TimeLeft = self.KillTime - CurTime()
	local TimeScale = TimeLeft/self.Duration
	local FTime = FrameTime()
	if TimeLeft > 0 then 
		self.FlashAlpha = self.FlashAlpha - 200*FTime
		self.FlashSize = self.FlashSize + 60000*FTime
		self.GlowAlpha = 200*TimeScale
		self.GlowSize = TimeLeft*self.Scale
		return true
	else
		return false	
	end
end

function EFFECT:Render()
	render.SetMaterial(Textures.Glow1)
	render.DrawSprite(self.Position2,7000*self.GlowSize,5500*self.GlowSize,Color(255,240,220,self.GlowAlpha))
	if self.FlashAlpha > 0 then
		render.SetMaterial(Textures.Glow2)
		render.DrawSprite(self.Position2,self.FlashSize,self.FlashSize,Color(255,245,215,self.FlashAlpha))
	end
end
