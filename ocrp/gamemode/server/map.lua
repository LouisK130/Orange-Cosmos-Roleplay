local v33xAndv4b1DisplayCars = {{Position = Vector(6847, -4751, 56), Ang = Angle(0, 90, 0), Model = "models/tdmcars/aud_rs4avant.mdl"},
								{Position = Vector(4251, -5309, 56), Ang = Angle(0, 180, 0), Model = "models/tdmcars/for_mustanggt.mdl"},
								{Position = Vector(5706, -5299, 56), Ang = Angle(0, 180, 0), Model = "models/tdmcars/dod_challenger70.mdl"},
								{Position = Vector(6282, -3626, 59), Ang = Angle(0, -90, 0), Model = "models/tdmcars/landrover12.mdl"},
								{Position = Vector(6268, -4054, 56), Ang = Angle(0, -90, 0), Model = "models/tdmcars/vw_beetleconv.mdl"},
								{Position = Vector(6285, -4505, 56), Ang = Angle(0, -90, 0), Model = "models/tdmcars/dodgeram.mdl"},
								{Position = Vector(6288, -4755, 56), Ang = Angle(0, -90, 0), Model = "models/tdmcars/for_raptor.mdl"},
								{Position = Vector(4467, -5296, 50), Ang = Angle(0, -180, 0), Model = "models/tdmcars/997gt3.mdl"},
								{Position = Vector(4673, -5290, 57), Ang = Angle(0, 180, 0), Model = "models/tdmcars/350z.mdl"},
								{Position = Vector(6839, -3633, 54), Ang = Angle(0, 90, 0), Model = "models/tdmcars/vw_camper65.mdl"},
								{Position = Vector(6310, -4270, 57), Ang = Angle(0, -90, 0), Model = "models/tdmcars/landrover_defender.mdl"},
								{Position = Vector(6285, -5002, 56), Ang = Angle(0, -90, 0), Model = "models/tdmcars/nissan_gtr.mdl"},
								{Position = Vector(6846, -4494, 56), Ang = Angle(0, 90, 0), Model = "models/tdmcars/jeep_grandche.mdl"},
								{Position = Vector(5097, -5278, 56), Ang = Angle(0, 180, 0), Model = "models/tdmcars/nis_370z.mdl"},
								{Position = Vector(5930, -5293, 56), Ang = Angle(0, 180, 0), Model = "models/tdmcars/skyline_r34.mdl"},
								{Position = Vector(6856, -3871, 56), Ang = Angle(0, 90, 0), Model = "models/tdmcars/ford_coupe_40.mdl"},
								{Position = Vector(6222, -5276, 56), Ang = Angle(0, -135, 0), Model = "models/tdmcars/dod_charger12.mdl"},
								{Position = Vector(6843, -4064, 56), Ang = Angle(0, 90, 0), Model = "models/tdmcars/jeep_wrangler88.mdl"},
								{Position = Vector(4886, -5277, 56), Ang = Angle(0, -180, 0), Model = "models/tdmcars/auditt.mdl"},
								{Position = Vector(6832, -4278, 56), Ang = Angle(0, 90, 0), Model = "models/tdmcars/wrangler.mdl"},
								{Position = Vector(6332, -3842, 56), Ang = Angle(0, -90, 0), Model = "models/tdmcars/trucks/gmc_c5500.mdl"},
								{Position = Vector(5528, -4357, 69), Ang = Angle(0, 126, -1), Model = "models/tdmcars/bug_eb110.mdl"},
								{Position = Vector(5650, -4613, 68), Ang = Angle(0, 90, 0), Model = "models/tdmcars/audir8.mdl"},
								{Position = Vector(5384, -4142, 68), Ang = Angle(0, 141, -1), Model = "models/tdmcars/bug_veyron.mdl"},
								{Position = Vector(5056, -4617, 60), Ang = Angle(0, -90, 0), Model = "models/tdmcars/audi_r8_spyder.mdl"},
								{Position = Vector(4897, -4445, 69), Ang = Angle(0, -90, 0), Model = "models/tdmcars/por_gt3rsr.mdl"},
								{Position = Vector(4752, -4265, 67), Ang = Angle(0, -90, 0), Model = "models/tdmcars/por_918.mdl"},
}

function SpawnCarPlaces()
	for k,v in pairs(v33xAndv4b1DisplayCars) do
        local car = ents.Create("prop_dynamic")
		car:PhysicsInit(SOLID_VPHYSICS)
		car:SetSolid(SOLID_VPHYSICS)
		car:SetCollisionGroup(COLLISION_GROUP_NONE)
		car:SetPos(v.Position - Vector(0,0,7))
		car:SetAngles(v.Ang)
		car:SetModel(v.Model)
		car:Spawn()
        
        local skins = {}
        for k1, v1 in pairs(GAMEMODE.OCRP_Cars) do -- I listed the table with model string instead of car name and I'm too lazy to go back and change it, so we just find it here
            if v1.Model == v.Model then
                skins = v1.Skins
            end
        end
        
        if #skins > 0 then
        
            local r = math.random(1, #skins)
            local skinTable = skins[r]
            
            if skinTable.model and skinTable.model != car:GetModel() then
                car:SetModel( skinTable.model )
            end
        
            local actualSkins = {0,3,9,10,12,14,15}
            if not table.HasValue(actualSkins, skinTable.skin) then
                car:SetSkin(0)
                if skinTable.skin == 1 then
                    car:SetColor(Color(255,0,0,255))
                elseif skinTable.skin == 2 then
                    car:SetColor(Color(0,0,0,255))
                elseif skinTable.skin == 4 then
                    car:SetColor(Color(0,0,255,255))
                elseif skinTable.skin == 5 then
                    car:SetColor(Color(0,255,0,255))
                elseif skinTable.skin == 6 then
                    car:SetColor(Color(255,152,44,255))
                elseif skinTable.skin == 7 then
                    car:SetColor(Color(220,220,0,255))
                elseif skinTable.skin == 8 then
                    car:SetColor(Color(255,130,255,255))
                elseif skinTable.skin == 11 then
                    car:SetColor(Color(110,110,110,255))
                elseif skinTable.skin == 13 then
                    car:SetColor(Color(180,255,255,255))
                end
            else
                car:SetSkin(skinTable.skin)
                car:SetColor(Color(255,255,255,255))
            end
        end
	end
	-- Gas pumps too, a second late so all pumps can spawn
	timer.Simple(2, function()
		for k,v in pairs(ents.FindByClass("prop_dynamic")) do
			if v:GetModel() == "models/props_equipment/gas_pump.mdl" then
				local pump = ents.Create("gas_pump")
				pump:SetPos(v:GetPos())
				pump:SetAngles(v:GetAngles())
				pump:Spawn()
			end
		end
	end)
	-- Little npc_barnacle thing
	SpawnBarnacle() -- Check at server launch
	timer.Create("OCRP_Barncle_Spawn", 60*60, 0, function() -- Then every hour after
		SpawnBarnacle()
	end)
end
local barnacle_places = {
	{Position = Vector(10998, 4810, 573), Col = Color(70,70,70)},
	{Position = Vector(-1428, 6995, 445), Col = Color(100,100,100)},
	{Position = Vector(8077, -8427, 291), Col = Color(70,70,70)},
	{Position = Vector(-7748, -8664, 6), Col = Color(70,70,70)},
	{Position = Vector(-1549, -8588, 342), Col = Color(70,70,70)},
	{Position = Vector(9484, 4480, 374), Col = Color(255,255,255)},
	{Position = Vector(-12205, 11817, 184), Col = Color(70,70,70)},
	{Position = Vector(-10558, 14911, 442), Col = Color(70,70,70)},
}
function SpawnBarnacle(override)
	if OCRP_Barnacle and OCRP_Barnacle:IsValid() then return end
	if math.random(1, 85) == 69 then -- Just about 1.17% chance, checked every hour, means roughly every 3.5 days
		local pos = table.Random(barnacle_places)
		if override then pos = override end
		local b = ents.Create("npc_barnacle")
		b:SetPos(pos.Position)
		b:Spawn()
		b:SetColor(pos.Col)
		OCRP_Barnacle = b
		print("[BARNACLE-SPAWN] A barnacle spawned at: " .. tostring(b:GetPos()))
	end
end
hook.Add("FindUseEntity", "OCRP_Barnacle_Gib_Pickup", function(ply, ent)
	if ent:IsValid() and ent:GetClass() == "gib" then
        SV_PrintToAdmin(ply, "PICKUP-ITEM", "looted 1 gib from a barnacle body!")
		ply:EmitSound("items/itempickup.wav",110,100)
		ply:GiveItem("item_gib", 1)
		ent:Remove()
	end
end)
if string.find(string.lower(game.GetMap()), "rp_evocity_v4b1") or string.lower(game.GetMap()) == "rp_evocity_v33x" then
	hook.Add("InitPostEntity", "SpawnCarPlaces", SpawnCarPlaces)
end
-- TAXI PATHFINDING NODE STUFF
--[[concommand.Add("spawn_taxi_nodes", function(ply)
	for k,v in pairs(taxi_nodes) do
		local x = ents.Create("prop_dynamic")
		x:SetModel("models/props/cs_office/radio.mdl")
		x:PhysicsInit(SOLID_VPHYSICS)
		x:SetSolid(SOLID_VPHYSICS)
		x:SetCollisionGroup(COLLISION_GROUP_NONE)
		x:Spawn()
		x:SetPos(v.Pos)
		x:SetNWString("ID", k)
	end
end)
local nodes = nodes or {}
local i = i or 1
concommand.Add("add_taxi_node", function(ply)
	nodes[i] = ply:GetPos()
	local m = ents.Create("prop_dynamic")
	m:SetModel("models/props/cs_office/radio.mdl")
	m:PhysicsInit(SOLID_VPHYSICS)
	m:SetSolid(SOLID_VPHYSICS)
	m:SetCollisionGroup(COLLISION_GROUP_NONE)
	m:Spawn()
	m:SetPos(ply:GetPos())
	m:SetColor(Color(255,0,0,255))
	m:SetNWString("ID", tostring(i))
	i = i + 1
end)
concommand.Add("clear_taxi_node", function(ply)
	nodes = {}
	i = 1
	for k,v in pairs(ents.FindByClass("prop_dynamic")) do
		if v:GetModel() == "models/props/cs_office/radio.mdl" then
			v:Remove()
		end
	end
end)
concommand.Add("get_taxi_node", function(ply)
	for k,v in pairs(ents.FindInSphere(ply:GetPos(), 100)) do
		if v:GetClass() == "prop_dynamic" and v:GetModel() == "models/props/cs_office/radio.mdl" then
			PrintMessage(HUD_PRINTCONSOLE, v:GetNWString("ID"))
			PrintMessage(HUD_PRINTCONSOLE, "Vector(" .. tostring(v:GetPos().x) .. ", " .. tostring(v:GetPos().y) .. ", " .. tostring(v:GetPos().z) .. ")")
		end
	end
end)
concommand.Add("save_taxi_node", function(ply)
	local s = "local nodes = {\n"
	for k,v in pairs(nodes) do
		s = s .. "{id = " .. tostring(k) .. ", Pos = Vector(" .. tostring(v.x) .. ", " .. tostring(v.y) .. ", " .. tostring(v.z) .. "), Neighbors = {}},\n"
	end
	s = s .. "}"
	file.Write("taxi_nodes.txt", s)
end)]]