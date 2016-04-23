GM.Chief_Items = {}

GM.Chief_Items["item_cone"] = {
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
				object.OwnerType = "Chief"
				object:Spawn()
				
				return object
			end,
}

GM.Chief_Items["item_barrier"] = {
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
				object.OwnerType = "Chief"
				object:Spawn()
				
				return object
			end,
}

GM.Chief_Items["item_fence01"] = {
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
				object.OwnerType = "Chief"
				object:Spawn()
				
				return object
			end,
}

GM.Chief_Items["item_fence02"] = {
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
				object.OwnerType = "Chief"
				object:Spawn()
				
				return object
			end,
}

GM.Locker_Items = {
{Item = "item_ammo_cop",Price = 2},
{Item = "item_ammo_riot",Price = 4},
{Item = "item_ammo_ump",Price = 3},
{Item = "item_shotgun_cop",Price = 75},
}

