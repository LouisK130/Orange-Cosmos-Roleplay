GM.Mayor_Items = {}

GM.Mayor_Items["item_atm"] = {
Name = "ATM Machine",
Desc = "Can be used by players to withdrawl and deposit cash.",
Price = 300,
Time = 1800,
Model = "models/env/misc/bank_atm/bank_atm.mdl",
SpawnFunction = 
			function(ply) 
				local object = ents.Create("bank_atm")
				object:SetPos(ply:EyePos() + (ply:GetAimVector() * 50))
				object:DropToFloor()
				object.OwnerType = "Mayor"
				object:Spawn()
				
				return object
			end,
}

GM.Mayor_Items["item_cone"] = {
Name = "Traffic Cone",
Desc = "Good for signaling a warning.",
Price = 10,
Time = 1800,
Model = "models/props_junk/TrafficCone001a.mdl",
SpawnFunction = 
			function(ply) 
				local object = ents.Create("prop_physics")
				object:SetPos(ply:EyePos() + (ply:GetAimVector() * 50))
				object:SetModel("models/props_junk/TrafficCone001a.mdl")
				object:DropToFloor()
				object.OwnerType = "Mayor"
				object:Spawn()
				
				return object
			end,
}

GM.Mayor_Items["item_barrier"] = {
Name = "Barrier",
Desc = "Good for making road blocks.",
Price = 60,
Time = 1800,
Model = "models/props_c17/concrete_barrier001a.mdl",
SpawnFunction = 
			function(ply) 
				local object = ents.Create("prop_physics")
				object:SetPos(ply:EyePos() + (ply:GetAimVector() * 50))
				object:SetModel("models/props_c17/concrete_barrier001a.mdl")
				object:DropToFloor()
				object.OwnerType = "Mayor"
				object:Spawn()
				
				return object
			end,
}

GM.Mayor_Items["item_fence01"] = {
Name = "Fence",
Desc = "Good for restricted areas.",
Price = 50,
Time = 1800,
Model = "models/props_wasteland/wood_fence01a.mdl",
SpawnFunction = 
			function(ply) 
				local object = ents.Create("prop_physics")
				object:SetPos(ply:EyePos() + (ply:GetAimVector() * 50))
				object:SetModel("models/props_wasteland/wood_fence01a.mdl")
				object:DropToFloor()
				object.OwnerType = "Mayor"
				object:Spawn()
				
				return object
			end,
}

GM.Mayor_Items["item_fence02"] = {
Name = "Fence",
Desc = "Good for restricted areas.",
Price = 30,
Time = 1800,
Model = "models/props_c17/fence01a.mdl",
SpawnFunction = 
			function(ply) 
				local object = ents.Create("prop_physics")
				object:SetPos(ply:EyePos() + (ply:GetAimVector() * 50))
				object:SetModel("models/props_c17/fence01a.mdl")
				object:DropToFloor()
				object.OwnerType = "Mayor"
				object:Spawn()
				
				return object
			end,
}


GM.Mayor_Items["item_money01"] = {
Name = "$500",
Desc = "Good for storing extra cash. 1 Eco Point loss if stolen.",
Price = 500,
Time = 0,
Model = "models/props/cs_assault/moneypallet.mdl",
SpawnFunction = 
			function(ply) 
				local object = ents.Create("money_obj")
				object:SetPos(ply:EyePos() + (ply:GetAimVector() * 50))
				object:SetModel("models/props/cs_assault/moneypallet.mdl")
				object:DropToFloor()
				object.OwnerType = "Mayor"
				object.Amount = 500
				object:Spawn()
				object:GetPhysicsObject():Wake()
				
				return object
			end,
}

GM.Mayor_Items["item_money02"] = {
Name = "$100",
Desc = "Good for paying ransoms. No eco-loss if stolen.",
Price = 120,
Time = 0,
Model = "models/props_c17/briefcase001a.mdl",
SpawnFunction = 
			function(ply) 
				local object = ents.Create("money_obj")
				object:SetPos(ply:EyePos() + (ply:GetAimVector() * 50))
				object:SetModel("models/props_c17/briefcase001a.mdl")
				object:DropToFloor()
				object.OwnerType = "Mayor"
				object.Amount = 100
				object:Spawn()
				object:GetPhysicsObject():Wake()
				
				return object
			end,
}

GM.Mayor_Items["item_moneyspawn01"] = {
Name = "Money Spawnpoint",
Desc = "Money will spawn at this location, only 4 allowed.",
Price = 0,
Time = 0,
Model = "models/props/cs_assault/moneypallet.mdl",
SpawnFunction = 
			function(ply) 
				if table.Count(ents.FindByClass("money_spawn")) >= 4 then
					for _,v in pairs(ents.FindByClass("money_spawn")) do 
						if v:IsValid() then
							v:Remove()
							break
						end
					end
				end
				local object = ents.Create("money_spawn")
				object:SetPos(ply:EyePos() + (ply:GetAimVector() * 50))
				object:SetModel("models/props/cs_assault/moneypallet.mdl")
				object:DropToFloor()
				object.OwnerType = "Mayor"
				object:Spawn()
				object:GetPhysicsObject():Wake()
				
				return object
			end,
}


GM.Mayor_Items["item_vend_machine"] = {
Name = "Vending Machine",
Desc = "Sells sodas. Money goes towards the city.",
Price = 200,
Time = 1800,
Model = "models/props/cs_office/vending_machine.mdl",
SpawnFunction = 
			function(ply) 
				local object = ents.Create("vendingmachines")
				object:SetPos(ply:EyePos() + (ply:GetAimVector() * 50))
				object:DropToFloor()
				object.OwnerType = "Mayor"
				object:Spawn()
				object:GetPhysicsObject():Wake()
				
				return object
			end,
}
