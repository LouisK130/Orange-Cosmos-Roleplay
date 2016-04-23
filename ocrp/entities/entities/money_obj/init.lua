AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	if self.Amount == nil then
		self.Amount = 1
	end
	self:SetHealth(25)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
end
function ENT:OnTakeDamage(dmginfo)
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if self:Health() <= 0 then
		timer.Simple(30,function() self:Remove() end)
		self:Remove()
	end
end
function ENT:StartTouch(ent) 
end
function ENT:EndTouch(ent)
end
function ENT:AcceptInput(name,activator,caller)
end
function ENT:KeyValue(key,value)
end
function ENT:OnRemove()
end
function ENT:OnRestore()
end
function ENT:PhysicsCollide(data,physobj)
	if data.DeltaTime > .5 then
		if data.HitEntity:GetClass() == "money_obj" && self.Amount + data.HitEntity.Amount < 500 then
			if !data.HitEntity.Changing then
				self.Amount = self.Amount + data.HitEntity.Amount
				self.Changing = true
				data.HitEntity:Remove()
				timer.Simple(1,function() if self:IsValid() then self.Changing = false end end)
			end
		end
	end
end
function ENT:PhysicsSimulate(phys,deltatime) 
end
function ENT:PhysicsUpdate(phys) 
end
function ENT:Touch(hitEnt) 
end
function ENT:UpdateTransmitState(Entity)
end
function ENT:Use(activator,caller)
	if !activator:IsPlayer() then return end
	if activator.CantUse then return end
	activator.CantUse = true
	timer.Simple(0.3, function() activator.CantUse = false end)

	if activator:Team() == CLASS_Mayor then
		activator:EmitSound("items/itempickup.wav",110,100)
		self:Remove()
		Mayor_AddMoney(self.Amount)
	elseif activator:Team() == CLASS_CITIZEN then
		activator:EmitSound("items/itempickup.wav",110,100)
		if team.NumPlayers(CLASS_Mayor) > 0 then
			table.Random(team.GetPlayers(CLASS_Mayor)):Hint("Someone has stolen money!")
		end
		local moremuney = 0
		local points = 0
		if GetGlobalInt("Eco_points") > -50 && self.Amount >= 500 then
			if activator:HasSkill("skill_rob",1) then
				moremuney = 100
				if activator:HasSkill("skill_rob",2) then
					moremuney = 200
					points = 1
					if activator:HasSkill("skill_rob",3) then
						moremuney = 300
						if activator:HasSkill("skill_rob",4) then
							moremuney = 400
							points = 2
							if activator:HasSkill("skill_rob",5) then
								moremuney = 500
								if activator:HasSkill("skill_rob",6) then
									moremuney = 600
									points = 3
								end
							end
						end
					end
				end
			end
			SV_PrintToAdmin( activator, "MAYOR_MONEY", activator:Nick() .." has stole the mayors money (briefcases/cashblocks)" )
			activator:Hint("You gained $"..self.Amount + moremuney .. ".")
			SetGlobalInt("Eco_points",GetGlobalInt("Eco_points") - 1 - points )
		else
			activator:Hint("You gained $"..self.Amount .. ".")
		end
		activator:AddMoney(WALLET,self.Amount + moremuney)
		self:Remove()
	end
end

