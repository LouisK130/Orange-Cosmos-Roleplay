AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()

	self.DropTime = CurTime()
	
	if self.Amount == nil then
		self.Amount = 1
	end
	
	if self:GetNWString("Class") == nil then
		self:Remove()
	end
	
	self:SetModel(GAMEMODE.OCRP_Items[self:GetNWString("Class")].Model)
	
	if GAMEMODE.OCRP_Items[self:GetNWString("Class")].Material != nil then
		self:SetMaterial(GAMEMODE.OCRP_Items[self:GetNWString("Class")].Material)
	end
	
	self:SetHealth(100)
	if GAMEMODE.OCRP_Items[self:GetNWString("Class")].Health != nil then
		self:SetHealth(GAMEMODE.OCRP_Items[self:GetNWString("Class")].Health)
	end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	if  GAMEMODE.OCRP_Items[self:GetNWString("Class")].Protected then
		self.Protected = true
	end
	
	if GAMEMODE.OCRP_Items[self:GetNWString("Class")].SpawnFunction != nil then
		GAMEMODE.OCRP_Items[self:GetNWString("Class")].SpawnFunction(self)
	end
end
function ENT:OnTakeDamage(dmginfo)
	local own3r = player.GetByID(self:GetNWInt("Owner"))	
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if self:GetNWString("Class") == "item_padlock" then
		if self:Health() <= 0 then
			self:GetParent().Padlock = nil
			self:SetParent(nil)
			self:GetPhysicsObject():Wake()
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			self:SetNWString("Class","")
			self:SetModel("models/props_wasteland/prison_padlock001b.mdl")
			timer.Simple(30,function() self:Remove() end)
		end
	elseif self:GetNWString("Class") == "item_explosives" then
		if self:Health() <= 0 then
			if self.explode == nil then
				self.explode = ents.Create("env_explosion")
				self.explode:SetPos(self:GetPos())
				self.explode.Class = self:GetNWString("Class")
				self.explode.Owner = self.Owner
				self.explode:Spawn()
				self.explode:SetKeyValue("iMagnitude","150")
				self.explode:Fire("Explode",0,0)
				if own3r:IsValid() then
				  own3r:UnStoreItem(self:GetNWString("Class"),self.Amount)
				end
				self:Remove()
			end
		end
	elseif GAMEMODE.OCRP_Items[self:GetNWString("Class")].Health != nil then
		if self:Health() <= 0 then
			for _,data in pairs(GAMEMODE.OCRP_Recipies) do
				if self:GetNWString("Class") == data.Item then
					for _,data1 in pairs(data.Requirements) do
						for i = 1,data1.Amount do
							if math.random(1,2) == 1 then
								local DropedEnt = ents.Create("item_base")
								DropedEnt:SetNWString("Class", data1.Item)
								DropedEnt:SetNWInt("Owner",self:GetNWInt("Owner"))
								if player.GetByID(self:GetNWInt("Owner")):IsValid() then
									DropedEnt.Protected = true
									timer.Simple(60,function() if DropedEnt:IsValid() then DropedEnt.Protected = false end end)
								end
								DropedEnt:SetPos(self:GetPos() + self:GetAngles():Up() * math.random(-15,15) + self:GetAngles():Right() * math.random(-15,15) + self:GetAngles():Forward() * math.random(-15,15)  )
								DropedEnt:SetAngles(Angle(math.random(-180,180),math.random(-180,180),math.random(-180,180)))
								DropedEnt:Spawn()
								if DropedEnt:GetPhysicsObject():IsValid() then
									DropedEnt:GetPhysicsObject():ApplyForceCenter(Vector(math.random(10,150),math.random(10,150),math.random(10,150)))
								end
								timer.Simple(300,function() if DropedEnt:IsValid() then DropedEnt:Remove() end end)
							end
						end
					end
				end
			end
			local Dest_Ent = ents.Create("prop_physics")
			Dest_Ent:SetPos(self:GetPos())
			Dest_Ent:SetModel(self:GetModel())
			Dest_Ent:SetAngles(self:GetAngles())
			Dest_Ent:SetMoveType(MOVETYPE_VPHYSICS)
			Dest_Ent:SetSolid(SOLID_VPHYSICS)
			Dest_Ent:SetCollisionGroup(1)
			Dest_Ent:Spawn()
			Dest_Ent:Activate()
			Dest_Ent:GibBreakClient(Dest_Ent:GetPos())
			Dest_Ent:Remove()
			if own3r:IsValid() then
			  own3r:UnStoreItem(self:GetNWString("Class"),self.Amount)
			end
			self:Remove()
		end
	end
end

function ENT:Detach(BASE)
	if self != nil && self:IsValid() then
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:GetPhysicsObject():EnableMotion(true)
		self:GetPhysicsObject():SetPos(self:GetPos())
		self:SetAngles(BASE:GetAngles())
		self:GetPhysicsObject():Wake()
		self.Ladder:Remove()
		if self.AttachedLadder != nil && self.AttachedLadder:IsValid() then
			self.AttachedLadder:Detach(self)
		end
		self.AttachedLadder = nil		
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
	if self.Seats != nil then
		if data.DeltaTime > .5 then
			if data.HitEntity:IsPlayer() && data.HitEntity:Crouching() then
				for _,ent in pairs(self.Seats) do
					if ent:IsValid()  && !ent:GetDriver():IsPlayer() then
						data.HitEntity:EnterVehicle(ent);
						data.HitEntity.CantUse = true
						timer.Simple(1,function() data.HitEntity.CantUse = false end)
						break
					end
				end
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
	if activator:GetNWBool("Handcuffed") then return end
	if activator.CantUse then return end
	activator.CantUse = true
	timer.Simple(1, function() activator.CantUse = false end)
	local own3r = player.GetByID(self:GetNWInt("Owner"))
	
	
	if self.DropTime + 60 >= CurTime() then
		if tonumber(self:GetNWInt("Owner")) != activator:EntIndex() && self:GetNWInt("Owner") > 0 then
			activator:Hint( "This object is protected for one minute." )
			return false
		end
	end
	if self.Drug != nil then
		if activator:Team() == CLASS_POLICE || activator:Team() == CLASS_CHIEF || activator:Team() == CLASS_SWAT then
			activator:Hint("For destroying weed, you recieve a bonus of $100!")
			activator:AddMoney(WALLET,100)
			self.Drug.Ready = false
			self.Drug = nil
			for _,ply in pairs(player.GetAll()) do
				if ply:IsValid() then
					umsg.Start("OCRP_RemoveWeed",ply)
						umsg.Entity(self)
					umsg.End()
				end
			end 
		elseif activator:Team() == CLASS_CITIZEN then
			if self.Drug.Ready then
				local seeds = math.random(0,2)
				local weed  = math.random(2,5)
                    SV_PrintToAdmin(activator, "HARVEST-DRUG", " harvested weed and received " .. tostring(weed) .. " weed and " .. tostring(seeds) .. " seeds")
					activator:GiveItem("item_weed_seed",seeds)
					activator:GiveItem("item_weed_bag",weed)
					self:SetAngles(Angle(0,90,0))
					self:GetPhysicsObject():Wake()
					self.Drug.Ready = false
					self.Drug = nil
					for _,ply in pairs(player.GetAll()) do
						if ply:IsValid() then
							umsg.Start("OCRP_RemoveWeed",ply)
								umsg.Entity(self)
							umsg.End()
						end
					end 				
					
					if !own3r:IsValid() then
						self:SetNWInt("Owner",0)
					end
					return
			else
				activator.CantUse = true
				timer.Simple(0.3, function() activator.CantUse = false end)
				self:SetAngles(Angle(0,90,0))
				self:GetPhysicsObject():Wake()
--[[				if activator:SteamID() == "STEAM_0:1:59948547" then -- LOL REKT MARC
					timer.Simple(2, function()
						if self and self:IsValid() then
							self:GetPhysicsObject():ApplyForceCenter(Vector(2000,0,0))
						end
					end)
				end]]
				return
			end
		end
	elseif self.Drug == nil then
		if GAMEMODE.OCRP_Items[self:GetNWString("Class")] != nil then
            if self:GetNWString("Class") == "item_pot" then
                if activator:Team() == CLASS_POLICE || activator:Team() == CLASS_CHIEF || activator:Team() == CLASS_SWAT then
                    activator:Hint("You can't steal pots as a government official, they're not contraband!")
                    return
                end
            end
            if activator:ExceedsMax(self:GetNWString("Class"), self.Amount) then
                activator:Hint("You can't carry any more of those!")
                return
            end
            if not activator:HasRoom(self:GetNWString("Class"), self.Amount) then
                activator:Hint("You don't have room for this!")
                return
            end
			if self.price then
				if own3r.Arrested then return end
				if self:GetNWInt("Owner") != activator:EntIndex() then
                    if self.price == -1 then return end
					if own3r:GetPos():Distance(self:GetPos()) <= 1500 && own3r:Alive() then
						if activator:GetMoney(WALLET) < self.price then
                            activator:Hint("You don't have enough money!")
                            return
                        end
						if activator:GetMoney(WALLET) >= self.price  then
							activator:TakeMoney(WALLET,self.price)
							local bool = false
							for _,ent in pairs(ents.FindByClass("item_base")) do
								if ent:GetPos():Distance(self:GetPos()) <= 1500 && ent:GetNWString("Class") == "item_cashregister" && ent:GetNWInt("Owner") == self:GetNWInt("Owner") then
									if ent:GetNWInt("Owner") == self:GetNWInt("Owner") || own3r:IsBuddy(player.GetByID(ent:GetNWInt("Owner"))) || player.GetByID(ent:GetNWInt("Owner")):GetOrg() == own3r:GetOrg() then
										bool = true
										break
									end
								end
							end
							if bool && GetGlobalInt("Eco_Tax") > 0 then
								own3r:AddMoney(WALLET,self.price - math.Round(self.price * GetGlobalInt("Eco_Tax")/100 ) )
								Mayor_AddMoney(math.Round(self.price * GetGlobalInt("Eco_Tax")/100 ))
								
								own3r:Hint("You paid "..math.Round(self.price * GetGlobalInt("Eco_Tax")/100 ).." to the city in taxes by having a cash register.")
							else
								own3r:AddMoney(WALLET,self.price )
							end
                            SV_PrintToAdmin(activator, "BUY-ITEM", "purchased " .. GAMEMODE.OCRP_Items[self:GetNWString("Class")].Name .. " from " .. own3r:Nick() .. " for " .. self.price)
							own3r:Hint(activator:Nick().." purchased a "..GAMEMODE.OCRP_Items[self:GetNWString("Class")].Name.." from you.") 
							if GAMEMODE.OCRP_Items[self:GetNWString("Class")] != nil then 
								if GAMEMODE.OCRP_Items[self:GetNWString("Class")].Weapon != nil then
									activator:Give(GAMEMODE.OCRP_Items[self:GetNWString("Class")].Weapon)
									activator:SelectWeapon(GAMEMODE.OCRP_Items[self:GetNWString("Class")].Weapon)
								end
							end
							activator:EmitSound("items/itempickup.wav",110,100)
							activator:GiveItem(self:GetNWString("Class"),self.Amount)
							if GAMEMODE.OCRP_Items[self:GetNWString("Class")].PickUpFunction != nil then
								GAMEMODE.OCRP_Items[self:GetNWString("Class")].PickUpFunction(self,activator)
							end
							if own3r:IsValid() then
							  own3r:UnStoreItem(self:GetNWString("Class"),self.Amount)
							end
							self:Remove()							
							return	
						end
					else
						if activator:Team() == CLASS_CITIZEN && activator:HasSkill("skill_theft",1)	then
							if GAMEMODE.OCRP_Items[self:GetNWString("Class")] != nil then 
								if GAMEMODE.OCRP_Items[self:GetNWString("Class")].Weapon != nil then
									activator:Give(GAMEMODE.OCRP_Items[self:GetNWString("Class")].Weapon)
									activator:SelectWeapon(GAMEMODE.OCRP_Items[self:GetNWString("Class")].Weapon)
								end
							end
                            SV_PrintToAdmin(activator, "STEAL-ITEM", "stole " .. GAMEMODE.OCRP_Items[self:GetNWString("Class")].Name .. " from " .. own3r:Nick())
							activator:EmitSound("items/itempickup.wav",110,100)
							activator:GiveItem(self:GetNWString("Class"),self.Amount)
							if GAMEMODE.OCRP_Items[self:GetNWString("Class")].PickUpFunction != nil then
								GAMEMODE.OCRP_Items[self:GetNWString("Class")].PickUpFunction(self,activator)
							end
							if own3r:IsValid() then
							    own3r:UnStoreItem(self:GetNWString("Class"),self.Amount)
								own3r:Hint("Someone has stolen goods from your shop!")
							end
							self:Remove()
							return
						elseif activator:Team() != CLASS_CITIZEN then
							activator:Hint("You may not steal as a government official.")
							return
						elseif !activator:HasSkill("skill_theft", 1) then
							activator:Hint("You need the theft skill to steal this item!")
							return
                        else
                            activator:Hint("The owner is not far enough away to steal!")
                            return
						end
					end
					return
				end
			end
			if self.Protected && activator != player.GetByID(self:GetNWInt("Owner")) && self:GetNWInt("Owner") > 0 && player.GetByID(self:GetNWInt("Owner")):IsValid() then
				activator:Hint("This item is protected.")
				return 
			end
			if GAMEMODE.OCRP_Items[self:GetNWString("Class")] != nil then 
				if GAMEMODE.OCRP_Items[self:GetNWString("Class")].Weapon != nil then
					activator:Give(GAMEMODE.OCRP_Items[self:GetNWString("Class")].Weapon)
					activator:SelectWeapon(GAMEMODE.OCRP_Items[self:GetNWString("Class")].Weapon)
				end
			end
            local ownerName = own3r:IsValid() and own3r:Nick() or "DISCONNECTED"
            SV_PrintToAdmin(activator, "PICKUP-ITEM", "picked up " .. self.Amount .. " of " .. self:GetNWString("Class") .. " belonging to " .. ownerName)
			activator:EmitSound("items/itempickup.wav",110,100)
			activator:GiveItem(self:GetNWString("Class"),self.Amount)
            if own3r:IsValid() then
                own3r:UnStoreItem(self:GetNWString("Class"),self.Amount)
			end
			if GAMEMODE.OCRP_Items[self:GetNWString("Class")].PickUpFunction != nil then
				GAMEMODE.OCRP_Items[self:GetNWString("Class")].PickUpFunction(self,activator)
			end
			self:Remove()
		end
	end
end

