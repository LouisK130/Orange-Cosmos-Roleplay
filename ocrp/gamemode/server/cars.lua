--[[concommand.Add("spawnseat", function(ply, cmd, args)
    local target = nil
    local tr = util.TraceLine({
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
        filter = function(ent)
            if ent:GetClass() == "prop_vehicle_jeep" then
                target = ent
            end
        end,
    })
    if not target then return end
	local SeatDatabase = list.Get("Vehicles")["Seat_Jeep"];
	
	local Seat = ents.Create("prop_vehicle_prisoner_pod");
	Seat:SetModel(SeatDatabase.Model);
	Seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt");
	Seat:SetPos(target:GetPos());
	Seat:Spawn();
	Seat:Activate();
	Seat:SetParent(target);
	
	--Seat:SetSolid(SOLID_NONE);
	Seat:SetMoveType(MOVETYPE_NONE);
    
    Seat:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	if SeatDatabase.Members then table.Merge(Seat, SeatDatabase.Members); end
	if SeatDatabase.KeyValues then
		for k, v in pairs(SeatDatabase.KeyValues) do
			Seat:SetKeyValue(k, v);
		end
	end
	Seat.VehicleTable = SeatDatabase;
	Seat.ClassOverride = "prop_vehicle_prisoner_pod";
end)
concommand.Add("getseatpos", function(ply, cmd, args)
    local target = nil
    local tr = util.TraceLine({
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
        filter = function(ent)
            if ent:GetClass() == "prop_vehicle_prisoner_pod" then
                target = ent
            end
        end,
    })
	if not target then ply:Hint("You didn't aim at a seat.") return end
	ply:PrintMessage(HUD_PRINTCONSOLE, target:GetParent():GetModel())
	ply:PrintMessage(HUD_PRINTCONSOLE, "GAMEMODE.CreatePassengerSeat(Entity, Vector(" .. math.Round(target:GetLocalPos().x) .. ", " .. math.Round(target:GetLocalPos().y) .. ", " .. math.Round(target:GetLocalPos().z) .. "), " .. "Angle(" .. math.Round(target:GetLocalAngles().x) .. ", " .. math.Round(target:GetLocalAngles().y) .. ", " .. math.Round(target:GetLocalAngles().z) .. "))")
    print(target:GetParent():GetModel())
    print("GAMEMODE.CreatePassengerSeat(Entity, Vector(" .. math.Round(target:GetLocalPos().x) .. ", " .. math.Round(target:GetLocalPos().y) .. ", " .. math.Round(target:GetLocalPos().z) .. "), " .. "Angle(" .. math.Round(target:GetLocalAngles().x) .. ", " .. math.Round(target:GetLocalAngles().y) .. ", " .. math.Round(target:GetLocalAngles().z) .. "))")
end)]]
-- CAR PART MODELS
-- models/props_wasteland/light_spotlight01_base.mdl -- SUSPENSION
-- models/props_wasteland/gear01.mdl -- gearbox
-- models/props_combine/combine_smallmonitor001.mdl -- alternate gearbox <- apparently a proper gearbox.
-- models/props_c17/utilityconnecter006.mdl -- injector/ignition

util.AddNetworkString("OCRP_OpenGarage")

function StringToColor(colorstring, bool)
    local color1 = Color(0,0,0,255)
	if colorstring == "Blue" then
		color1.r = 0
		color1.g = 0
		color1.b = 255
	elseif colorstring == "Green" then
		color1.r = 0
		color1.g = 204
		color1.b = 0
	elseif colorstring == "Red" then
		color1.r = 204
		color1.g = 0
		color1.b = 0
	elseif colorstring == "Ice" then
		color1.r = 0
		color1.g = 50
		color1.b = 150
	elseif colorstring == "Purple" then
		color1.r = 145
		color1.g = 0
		color1.b = 255
	elseif colorstring == "Orange" then
        color1.r = 255
        color1.g = 152
        color1.b = 44
    elseif colorstring == "Yellow" then
        color1.r = 220
        color1.g = 220
        color1.b = 0
    elseif colorstring == "White" then
        color1.r = 255
        color1.g = 255
        color1.b = 255
    elseif colorstring == "Pink" then
        color1.r = 255
        color1.g = 130
        color1.b = 255
    end
    if bool then    
        local t = {}
        t[1] = color1.r
        t[2] = color1.g
        t[3] = color1.b
        return t
    end
	return color1.r .. " " .. color1.g .. " " .. color1.b
end

util.AddNetworkString("OCRP_SendAllCars")

function SendCarsClient( ply )
    local t = {}
    for k,v in pairs(ply.OCRPData["Cars"]) do
        table.insert(t, v.car)
    end
    net.Start("OCRP_SendAllCars")
        net.WriteTable(t)
    net.Send(ply)
end

--[[function SendTrunk( ply, Vehicle )
	for k, v in pairs( Vehicle.Data["Items"] ) do
		umsg.Start("ocrp_trunk_item", ply)
			umsg.String(k)
			umsg.Long(v)
			umsg.Long(1)
		umsg.End()
	end
end

function ShowTrunkMenu( ply )
	umsg.Start( "ocrp_trunk_show", ply )
	umsg.End()
end]]

util.AddNetworkString("OCRP_ShowCarDealer")

function ShowCarDealer( ply, cmd, args )
	if !ply:NearNPC("CarDealer") then return false end
    net.Start("OCRP_ShowCarDealer")
    net.Send(ply)
end
concommand.Add( "SV_CarDealer", ShowCarDealer )

function ShowGarage( ply, cmd, args )
	if !ply:NearNPC("Garage") then return false end
    net.Start("OCRP_OpenGarage")
    net.Send(ply)
end
concommand.Add( "SV_Garage", ShowGarage)

function ToggleUnderglow(ply)
    if ply:InVehicle() and ply:GetVehicle():GetClass() == "prop_vehicle_jeep" then
        local car = ply:GetVehicle()
        ply.GlowTime = ply.GlowTime or 0
        if ply.GlowTime + 1 > CurTime() then
            return
        end
        ply.GlowTime = CurTime()
        if car:GetNWString("Underglow") == "none" then
            ply:Hint("You don't have underglow installed on this car!")
            return
        else
            car:SetNWBool("GlowOn", !car:GetNWBool("GlowOn"))
        end
    end
end

concommand.Add("ocrp_underglow", function(ply, cmd, args)
    ToggleUnderglow(ply, key)
end)

function ActivateNitrous(ply)
    if ply:InVehicle() and ply:GetVehicle():GetClass() == "prop_vehicle_jeep" and not ply:GetVehicle():IsGovCar() then
        if ply:GetVehicle().Broken or ply:GetVehicle().Ticket then return end
        if not ply:GetVehicle().Nitrous or ply:GetVehicle().Nitrous ~= true then
            ply:Hint("You don't have nitrous installed on this car!")
            return
        end
        ply:GetVehicle().NitroTime = ply:GetVehicle().NitroTime or 0
        if ply:GetVehicle().NitroTime + 50 > CurTime() then
            ply:Hint("Your nitrous is on cooldown for " .. math.Round((ply:GetVehicle().NitroTime+50) - CurTime()) .. " seconds!")
            return
        end
        ply:GetVehicle().NitroTime = CurTime()
        local NitroForce = ply:GetVehicle():GetForward() * 2200000
        if GAMEMODE.OCRP_Cars[ply:GetVehicle().CarType].NitroForce then
            NitroForce = ply:GetVehicle():GetForward() * GAMEMODE.OCRP_Cars[ply:GetVehicle().CarType].NitroForce
        end
        
        if NitroForce then
            ply:GetVehicle():GetPhysicsObject():ApplyForceCenter( NitroForce )
            ply:GetVehicle():EmitSound( "vehicles/nitrous.mp3" )
        end
    end
end

concommand.Add("ocrp_nitrous", function(ply, cmd, args)
    ActivateNitrous(ply)
end)

function OCRP_Hydros( ply )
	if ply:InVehicle() and ply:GetVehicle():GetClass() == "prop_vehicle_jeep" then
        if ply:GetVehicle().Broken or ply:GetVehicle().Ticket then return end
        ply.HydroTime = ply.HydroTime or 0
        if ply.HydroTime + 1 > CurTime() then
            return false
        end
        ply.HydroTime = CurTime()
        --[[local mdl = ply:GetVehicle():GetModel()
        if mdl == "models/tdmcars/emergency/mitsu_evox.mdl" or mdl == "models/sickness/stockade2dr.mdl" then
            local light = ply:GetVehicle().Lights[1]
            if not light or not light:IsValid() then return end
            if !light:GetNWBool("siren", false) then
                ply:GetVehicle():EmitSound("ocrp/siren_short.mp3");
            else
                ply:GetVehicle():SetNWBool("siren_wail", !ply:GetVehicle():GetNWBool("siren_wail", false))
            end
        end
        if ply:GetVehicle():GetModel() == "models/sickness/meatwagon.mdl" or ply:GetVehicle():GetModel() == "models/sickness/truckfire.mdl" then
            ply:GetVehicle():EmitSound("ocrp/firetruck_horn.mp3");
        end]]
        if ply:GetVehicle().Hydros == true then
            local Force = ply:GetVehicle():GetUp() * 450000
            if ply:GetVehicle().CarType and GAMEMODE.OCRP_Cars[ply:GetVehicle().CarType] and GAMEMODE.OCRP_Cars[ply:GetVehicle().CarType].HydroPower then
                Force = ply:GetVehicle():GetUp() * GAMEMODE.OCRP_Cars[ply:GetVehicle().CarType].HydroPower
            end
            if Force then
                ply:GetVehicle():GetPhysicsObject():ApplyForceCenter(Force);
            end
        else
            if not ply:GetVehicle():IsGovCar() then
                ply:Hint("You don't have hydraulics installed on this car!")
            end
        end
	end
end

concommand.Add("ocrp_hydros", function(ply, cmd, args)
    OCRP_Hydros(ply)
end)

function OCRP_BuyCar( ply, CarName)
	if !ply:NearNPC("CarDealer") then
		return false
	end
    if !GAMEMODE.OCRP_Cars[CarName] then
        return false
    end
    if ply:Team() != 1 then
        ply:Hint("You can't buy cars as this job. Go quit first.")
        return false
    end
	if !CarName then return false end
	for _, Data in pairs(ply.OCRPData["Cars"]) do
		if Data.car == CarName then
            ply:Hint("You already own this car!")
			return false
		end
	end
    if CarName == "PORSCHE_TRICYCLE" and not ply.CanBuyTricycle then return end
	local CarPrice = GAMEMODE.OCRP_Cars[CarName].Price
	if CarPrice >= ply:GetMoney(BANK) then
        ply:Hint("You don't have enough money in your bank account! Visit an ATM to deposit!")
        return false
    end
    SV_PrintToAdmin(ply, "BUY_CAR", "purchased car " .. CarName)
	ply:TakeMoney(BANK, CarPrice)
	table.insert(ply.OCRPData["Cars"], {car = CarName, skin = 1, hydros = false})
	SendCarsClient(ply)
	OCRP_SpawnVehicle(CarName, ply)
    
    local org = OCRP_Orgs[ply:GetOrg()]
    
    if org and not org.Perks[6] then
        if GAMEMODE.OCRPPerks[6].Check(ply:GetOrg()) then
            org.Perks[6] = true
            for _,member in pairs(org.Members) do
                local p = player.GetBySteamID(member.SteamID)
                if p and p:IsValid() then
                    p:Hint("Congratulations, your org has unlocked the " .. GAMEMODE.OCRPPerks[6].Name .. " perk!")
                    GAMEMODE.OCRPPerks[6].Function(p)
                end
            end
        end
    end
    
end
net.Receive("OCRP_BuyCar", function(len, ply)
	OCRP_BuyCar(ply, net.ReadString())
end)

function OCRP_SpawnCar(ply, CarToSpawn)
	--if !ply:NearNPC("Garage") then return false end
    local t = ply:Team()
    if t == CLASS_Mayor or t == CLASS_CITIZEN then
        local curcar = ply.OCRPData["CurCar"]
        if curcar and curcar:IsValid() then
            local bool = false
            local pos = curcar:GetPos()
			-- Should probably update this to include map checks, these coords are for evocity_v2d
            if pos.x < -3635 and pos.x > -5427 then
                if pos.y < -9974 and pos.y > -10732 then
                    bool = true
                end
            end
            if not bool then
                ply:Hint("You must park your current car in the parking garage before spawning a new one!")
                return false
            end
        end
        local CanSpawn
        for _, Data in pairs(ply.OCRPData["Cars"]) do
            if Data.car == CarToSpawn then
                CanSpawn = true
            end
        end
        if CanSpawn != true then return false end
        OCRP_SpawnVehicle(CarToSpawn, ply)
    else
        ply:Hint("You cannot spawn your private car as this job! Go get a government vehicle.")
    end
	--OCRP_CreateCar( CarToSpawn, Vector(-3790.054932, -262.866974, 153.637131), Angle(0,0,0), ply)
end
--setpos -5427.907715 -9974.211914 261.354736;
--setpos -3635.774414 -10732.915039 70.689255
net.Receive("OCRP_SC", function(len, ply)
	OCRP_SpawnCar(ply, net.ReadString())
end)

function OCRP_SpawnPolice(ply )
	if ply:Team() != CLASS_POLICE && ply:Team() != CLASS_CHIEF then return false end
    if TotalCopCars() >= math.Round((#team.GetPlayers(CLASS_POLICE) + #team.GetPlayers(CLASS_CHIEF)) / 2) then
        if ply:GetLevel() > 3 then
            ply:Hint("There are already too many police cars. Go patrol with another officer.")
            return false
        else
            ply:Hint("There are already too many police cars, but your rank allowed you to spawn another.")
        end
    end
	OCRP_SpawnVehicle("Police", ply)
end
net.Receive("OCRP_SpawnPolice", function(len, ply)
	OCRP_SpawnPolice(ply)
end)

function OCRP_SpawnTow(ply )
    if ply:Team() ~= CLASS_Tow then return false end
    OCRP_SpawnVehicle("Tow", ply)
end
net.Receive("OCRP_SpawnTow", function(len, ply)
	OCRP_SpawnTow(ply)
end)

--[[function OCRP_SpawnPoliceNEW(ply )
	if ply:Team() != CLASS_POLICE && ply:Team() != CLASS_CHIEF then return false end
	if ply:GetLevel() <= 4 then
		OCRP_SpawnVehicle("Police_NEW", ply)
	else
		OCRP_SpawnVehicle("Police", ply)
	end
end
net.Receive("OCRP_SpawnPoliceNEW", function(len, ply)
	OCRP_SpawnPoliceNEW(ply)
end)]]

function OCRP_SpawnSWAT(ply)
	if ply:Team() != CLASS_SWAT then return false end
	OCRP_SpawnVehicle("SWAT", ply)
end
net.Receive("OCRP_SpawnSWAT", function(len, ply)
	OCRP_SpawnSWAT(ply)
end)

function OCRP_SpawnAmbo(ply)
	if ply:Team() != CLASS_MEDIC then return false end
	OCRP_SpawnVehicle("Ambo", ply)
end
net.Receive("OCRP_SpawnAmbo", function(len, ply)
	OCRP_SpawnAmbo(ply)
end)

function OCRP_SpawnFireEngine(ply)
	if ply:Team() != CLASS_FIREMAN then return false end
	OCRP_SpawnVehicle("Fire", ply)
end
net.Receive("OCRP_SpawnFireEngine", function(len, ply)
	OCRP_SpawnFireEngine(ply)
end)
util.AddNetworkString("OCRP_SpawnTaxi")
function OCRP_SpawnTaxi(ply)
	if ply:Team() != CLASS_TAXI then return end
	OCRP_SpawnVehicle("Taxi", ply)
end
net.Receive("OCRP_SpawnTaxi", function(len, ply)
	OCRP_SpawnTaxi(ply)
end)
	
function OCRP_SpawnVehicle(Car, ply)
	local SoFar = 2000
	local TehTBL = GAMEMODE.Maps[string.lower(game.GetMap())].SpawnsCar
	if Car == "CAR_YANKEE" or Car == "CAR_PHANTOM" or Car == "CAR_MULE" or Car == "CAR_BUS" or Car == "CAR_LIMO" or Car == "CAR_INTER" then
		if string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
			TehTBL = {
				{Position = Vector(-3284, -1560, 7), Ang = Angle(0,93,0)},
				{Position = Vector(-3269, -1774, 7), Ang = Angle(0,93,0)},
			}
		elseif string.lower(game.GetMap()) == "rp_evocity_v2d" then
			TehTBL = {
				{Position = Vector(-5802,-10518,140), Ang = Angle(0,0,0)},
				{Position = Vector(-5810,-10345,140), Ang = Angle(0,0,0)},
			}
		end
	end
	if Car == "Ambo" then
		if string.lower(game.GetMap()) == "rp_evocity2_v2p" then
			TehTBL = {
			{Position = Vector(-1064,-1721,220), Ang = Angle(0,-1,0)},
			{Position = Vector(-1081,-2091,220), Ang = Angle(1,-1,0)},
			--{Position = Vector(-5825, -9556, 178)},
			--{Position = Vector(-5809, -9027, 180)},
			}
		elseif string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
			TehTBL = {
				{Position = Vector(4429,-796,63), Ang = Angle(0,0,0)},
				{Position = Vector(4184,-799,63), Ang = Angle(0,0,0)},
				{Position = Vector(3883,-766,62), Ang = Angle(0,0,0)},
				{Position = Vector(3739,-761,64), Ang = Angle(0,0,0)},
				{Position = Vector(3574,-747,65), Ang = Angle(0,0,0)},
			}
		elseif string.lower(game.GetMap()) == "rp_evocity_v4b1" or string.lower(game.GetMap()) == "rp_evocity_v33x" then
			TehTBL = {
				{Position = Vector(-3639, -7770, 213), Ang = Angle(0, 90, 0)},
				{Position = Vector(-3624, -8013, 198), Ang = Angle(0, 90, 0)},
			}
		else
			TehTBL = {
				{Position = Vector(-5799, -10606, 195)},
				{Position = Vector(-5843, -10979, 176)},
				{Position = Vector(-5825, -9556, 178)},
				{Position = Vector(-5809, -9027, 180)},
			}
		end
	elseif Car == "Police" then
		if string.lower(game.GetMap()) == "rp_evocity2_v2p" then
			TehTBL = {
				{Position = Vector(953,-1609,-110), Ang = Angle(0,90,0)},
				{Position = Vector(-193,-1576,-110), Ang = Angle(0,179,0)},
				{Position = Vector(4,-1655,-114), Ang = Angle(0,178,0)},
				{Position = Vector(-74,-2325,-112), Ang = Angle(0,0,0)},
				{Position = Vector(-284,-2246,-111), Ang = Angle(0,0,0)},
			}
		elseif string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
			TehTBL = {
				{Position = Vector(6241,-1746,42), Ang = Angle(0,90,0)},
				{Position = Vector(6243,-1872,42), Ang = Angle(0,90,0)},
				{Position = Vector(5959,-1874,42), Ang = Angle(0,90,0)},
				{Position = Vector(5977,-1744,42), Ang = Angle(0,90,0)},
				{Position = Vector(5519,-1600,36), Ang = Angle(0,-1,0)},
			}
		else
			TehTBL = {
				{Position = Vector(-6183, -9576, 64)},
				{Position = Vector(-6193, -9887, 142)},
				{Position = Vector(-6195, -10183, 142)},
				{Position = Vector(-6194, -10522, 137)},
				{Position = Vector(-6209, -10862, 135)},
			}
		end
	elseif Car == "Police_NEW" then
		if string.lower(game.GetMap()) == "rp_evocity2_v2p" then
			TehTBL = {
				{Position = Vector(953,-1609,-110), Ang = Angle(0,90,0)},
				{Position = Vector(-193,-1576,-110), Ang = Angle(0,179,0)},
				{Position = Vector(4,-1655,-114), Ang = Angle(0,178,0)},
				{Position = Vector(-74,-2325,-112), Ang = Angle(0,0,0)},
				{Position = Vector(-284,-2246,-111), Ang = Angle(0,0,0)},
			}
		elseif string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
			TehTBL = {
				{Position = Vector(6241,-1746,42), Ang = Angle(0,90,0)},
				{Position = Vector(6243,-1872,42), Ang = Angle(0,90,0)},
				{Position = Vector(5959,-1874,42), Ang = Angle(0,90,0)},
				{Position = Vector(5977,-1744,42), Ang = Angle(0,90,0)},
				{Position = Vector(5519,-1600,36), Ang = Angle(0,-1,0)},
			}
		else
			TehTBL = {
				{Position = Vector(-6183, -9576, 64)},
				{Position = Vector(-6193, -9887, 142)},
				{Position = Vector(-6195, -10183, 142)},
				{Position = Vector(-6194, -10522, 137)},
				{Position = Vector(-6209, -10862, 135)},
			}
		end
	elseif Car == "SWAT" then
		if string.lower(game.GetMap()) == "rp_evocity2_v2p" then
			TehTBL = {
				{Position = Vector(953,-1609,-110), Ang = Angle(0,90,0)},
				{Position = Vector(-193,-1576,-110), Ang = Angle(0,179,0)},
				{Position = Vector(4,-1655,-114), Ang = Angle(0,178,0)},
				{Position = Vector(-74,-2325,-112), Ang = Angle(0,0,0)},
				{Position = Vector(-284,-2246,-111), Ang = Angle(0,0,0)},
			}
		elseif string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
			TehTBL = {
				{Position = Vector(6241,-1746,42), Ang = Angle(0,90,0)},
				{Position = Vector(6243,-1872,42), Ang = Angle(0,90,0)},
				{Position = Vector(5959,-1874,42), Ang = Angle(0,90,0)},
				{Position = Vector(5977,-1744,42), Ang = Angle(0,90,0)},
				{Position = Vector(5519,-1600,36), Ang = Angle(0,-1,0)},
			}
		else
			TehTBL = {
				{Position = Vector(-6183, -9576, 64)},
				{Position = Vector(-6193, -9887, 142)},
				{Position = Vector(-6195, -10183, 142)},
				{Position = Vector(-6194, -10522, 137)},
				{Position = Vector(-6209, -10862, 135)},
			}
		end
	elseif  Car == "Fire" then
		if string.lower(game.GetMap()) == "rp_evocity2_v2p" then
			TehTBL = {
			{Position = Vector(-1064,-1721,220), Ang = Angle(0,-1,0)},
			{Position = Vector(-1081,-2291,220), Ang = Angle(1,-1,0)},
			--{Position = Vector(-5825, -9556, 178)},
			--{Position = Vector(-5809, -9027, 180)},
			}
		elseif string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
			TehTBL = {
				{Position = Vector(6241,-1746,42), Ang = Angle(0,90,0)},
				{Position = Vector(6243,-1872,42), Ang = Angle(0,90,0)},
				{Position = Vector(5959,-1874,42), Ang = Angle(0,90,0)},
				{Position = Vector(5977,-1744,42), Ang = Angle(0,90,0)},
				{Position = Vector(5519,-1600,36), Ang = Angle(0,-1,0)},
			}
		else
			TehTBL = {
				{Position = Vector(-6183, -9576, 64)},
				{Position = Vector(-6193, -9887, 142)},
				{Position = Vector(-6195, -10183, 142)},
				{Position = Vector(-6194, -10522, 137)},
				{Position = Vector(-6209, -10862, 135)},
			}
		end
    elseif Car == "Tow" then
			TehTBL = {
				{Position = Vector(-6183, -9576, 64)},
				{Position = Vector(-6193, -9887, 142)},
				{Position = Vector(-6195, -10183, 142)},
				{Position = Vector(-6194, -10522, 137)},
				{Position = Vector(-6209, -10862, 135)},
			}
	elseif Car == "Taxi" then
		TehTBL = {
			{Position = Vector(-6183, -9576, 64)},
			{Position = Vector(-6193, -9887, 142)},
			{Position = Vector(-6195, -10183, 142)},
			{Position = Vector(-6194, -10522, 137)},
			{Position = Vector(-6209, -10862, 135)},
		}
	end
	local closest
	local shortestdistance = 1000000
	for k, v in pairs(TehTBL) do
		if v.Position:Distance(ply:GetPos()) < shortestdistance then 
			local open = true
			for k, ply in pairs(ents.FindInSphere(v.Position, 32)) do
				if ply:IsVehicle() then
					open = false
				end
			end
			if open then
				closest = v
				shortestdistance = v.Position:Distance(ply:GetPos())
			end
		end
	end
	if closest then
		PlaceToPut = closest.Position
		PlaceToAngle = closest.Ang or Angle(0,0,0)
	end
	
	if ply.OCRPData["CurCar"] != nil then
		if ply.OCRPData["CurCar"]:IsValid() then
			ply.OCRPData["CurCar"]:Remove()
		end
	end
	for k, v in pairs(ents.GetAll()) do
		if v:IsVehicle() then
			if v:GetNWInt("Owner") == ply:EntIndex() then
				v:Remove()
			end
		end
	end
	if PlaceToPut and PlaceToAngle then
		OCRP_CreateCar( Car, PlaceToPut, PlaceToAngle, ply)
	end
end

function PMETA:OwnsCar( CarToFind )
	for k, v in pairs( self.OCRPData["Cars"] ) do
		if v.car == CarToFind then
			return true
		end
	end
	return false
end

function OCRP_CreateCar( Car, Pos, Ang, ply )
	local script
	local model
	if Car == "Police" then
	   	script = "scripts/vehicles/tdmcars/mitsu_evox.txt"
		model = "models/tdmcars/emergency/mitsu_evox.mdl"
	elseif Car == "Police_NEW" then
	   	script = "scripts/vehicles/dodgecop.txt"
		model = "models/tdmcars/copcar.mdl"
	elseif Car == "Ambo" then
	    	script = "scripts/vehicles/meatwagon.txt"
		model = "models/sickness/meatwagon.mdl"
	elseif Car == "SWAT" then
	    	script = "scripts/vehicles/newstock.txt"
		model = "models/sickness/stockade2dr.mdl"
	elseif Car == "Fire" then
		script = "scripts/vehicles/truckfire.txt"
		model = "models/sickness/truckfire.mdl"
    elseif Car == "Tow" then
        script = "scripts/vehicles/tow.txt"
        model = "models/sickness/towtruckdr.mdl"
	elseif Car == "Taxi" then
		script = "scripts/vehicles/tdmcars/crownvic_taxi.txt"
		model = "models/tdmcars/crownvic_taxi.mdl"
	else
		script = GAMEMODE.OCRP_Cars[Car].Script
		model = GAMEMODE.OCRP_Cars[Car].Model
	end
	
	local TheCar = ents.Create( "prop_vehicle_jeep" )
	TheCar:SetKeyValue( "vehiclescript", script )
	TheCar:SetPos( Pos )
	TheCar:SetAngles( Ang )
	if type(model) == "table" then
		model = model[1]
	end
	TheCar:SetModel( model )
	TheCar:Spawn()
	TheCar:Activate()
	--TheCar:SetCustomCollisionCheck(true)
	TheCar.CarType = Car
    TheCar:SetNWString("Type", Car) -- not really necesary but i cant remember where i used it and i didn't notice GetCarType() before
	TheCar.OwnerObj = ply
    if GAMEMODE.OCRP_Cars[Car] then
        TheCar:SetNWString("VC_Name", GAMEMODE.OCRP_Cars[Car].Name)
        TheCar.Gas = ply.GasSave[Car] or GAMEMODE.OCRP_Cars[Car].GasTank
        TheCar:SetHealth(ply.HealthSave[Car] or GAMEMODE.OCRP_Cars[Car].Health)
        if TheCar:Health() <= 0 then
            TheCar.Broken = true
            TheCar.BrokenFully = true
        elseif TheCar:Health() < GAMEMODE.OCRP_Cars[Car].Health/4 then
            timer.Simple(1, function()
                TheCar:StartSmoking()
            end)
        end
	else
        TheCar.Gas = 100
        TheCar:SetHealth(100)
    end
    TheCar:SetNWBool("IsGovCar", TheCar:IsGovCar())
	umsg.Start("OCRP_UpdateGas", ply)
			umsg.Long(TheCar.Gas)
	umsg.End()

	TheCar.Permissions = {}
	TheCar.Permissions["Buddies"] = true
	TheCar.Permissions["Org"] = true
	TheCar.Permissions["Goverment"] = false
	TheCar.Permissions["Mayor"] = false
    
	--if ply.OCRPData.CurCar != nil then
		
	--	TheCar.OCRPData = {}
	--	TheCar.OCRPData["Inventory"] = ply.OCRPData.CurCar.OCRPData["Inventory"]
	--else
		TheCar.OCRPData = {}
		TheCar.OCRPData["Inventory"] = {WeightData = {Cur = 0, Max = 100},}
--	end
    
	TheCar.Seats = {}
	TheCar.Exits = {}
	TheCar.Data = {}
	TheCar.Data["Items"] = {}
	TheCar.Data["Weight"] = 0
	if TheCar:IsGovCar() then
		TheCar:SetSkin(0) -- 1 is the regular evox
		TheCar.Permissions["Buddies"] = true
		TheCar.Permissions["Org"] = true
		TheCar.Permissions["Goverment"] = true
		TheCar.Permissions["Mayor"] = true
        TheCar:SetNWString("Headlights", "White")
    end

	TheCar:SetNWInt( "Owner", ply:EntIndex())
	TheCar:Fire("Lock");
	
	TheCar.GasCheck = 0
    if GAMEMODE.OCRP_Cars[Car] then
        TheCar.Name = GAMEMODE.OCRP_Cars[Car].Name
    end
	
	TheCar.Think = function() 
		if TheCar.GasCheck <= CurTime() && !TheCar:IsGovCar() then
			GAMEMODE:DoGasCheck(TheCar)
		end
        if TheCar.smoke and TheCar:GetSpeed() > 0 then
            local chance = .5 * math.Clamp(TheCar:GetSpeed(), 2, 80) -- 40% chance at 80 MPH or faster, scales down to 1% at 2 MPH
            local r = math.random(0, 100)
            if r < chance then
                if TheCar:GetDriver() and TheCar:GetDriver():IsValid() and not TheCar.rope then
                    GAMEMODE.DoBreakdown(TheCar, true)
                end
            end
        end
		timer.Simple(10,function() if TheCar:IsValid() then TheCar:Think() end end)
	end
	if !TheCar:IsGovCar() then
		TheCar:Think() 
	end
	
	ply.OCRPData.CurCar = TheCar -- arent these the same??
	ply.OCRPData["CurCar"] = TheCar -- this and above..
	umsg.Start("OCRP_UpdateCurCar", ply)
    umsg.String(Car)
    umsg.End()
	for _, data in pairs(ply.OCRPData["Cars"]) do
		if data.car == Car then
			if Car != "Police" then
				OCRP_SetSkin(ply, TheCar, data.skin)
			end
            TheCar.underglow = data.underglow
			TheCar.headlights = data.headlights
            if data.underglow and data.underglow ~= "none" then
                TheCar:SetNWString("Underglow", data.underglow)
                TheCar:SetNWBool("GlowOn", false)
                local UG = ents.Create("vehicle_underglow")
                UG:SetPos(TheCar:GetPos() + Vector(0,0,0))
                UG:SetParent(TheCar)
				UG:Spawn()
            end
			if data.headlights and data.headlights ~= "none" then
				TheCar:SetNWString("Headlights", data.headlights)
			end
			
            TheCar.NitrousForce = GAMEMODE.OCRP_Cars[Car].NitrousForce or 2200000
			if tostring(data.hydros) == "true" then
				TheCar.Hydros = true
			else
				TheCar.Hydros = false
			end
            if tostring(data.Nitrous) == "true" then
                TheCar.Nitrous = true
            else
                TheCar.Nitrous = false
            end
		end
	end
end

util.AddNetworkString("OCRP_Open_Skins")

function CL_ShowSkin(ply, car)
	if !ply:NearNPC( "Respray" ) then return false end
    net.Start("OCRP_Open_Skins")
        net.WriteString(car)
    net.Send(ply)
 end
net.Receive("CL_ShowSkin", function(len, ply)
	CL_ShowSkin(ply, net.ReadString())
end)

function OCRP_BuyHydro( ply )
	if !ply:NearNPC( "Respray" ) then
        ply:Hint("Your car is not close enough!")
		return false
	end
	local Car
	for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
		if v:GetNWInt( "Owner" ) == ply:EntIndex() then
			Car = v
			break
		end
	end
	if not Car or not Car:IsValid() then
        ply:Hint("Your car is not close enough!")
        return
    end
	
	if Car == nil then return false end
	if Car.Hydros then
        ply:Hint("You already have hydraulics installed on this car!")
        return false
    end
	
	if ply:GetMoney(WALLET) < 25000 then
		ply:Hint( "You don't have enough money for this!" )
		return false
	end
	
	ply:TakeMoney(WALLET, 25000)
	ply:Hint("Hydraulics have been installed on your car.")
    for _,cartable in pairs(ply.OCRPData["Cars"]) do
        if cartable.car == Car.CarType then
            cartable.hydros = true
        end
    end
	Car.Hydros = true
	SV_PrintToAdmin(ply, "BUY_HYDRO", "purchased hydraulics for his " .. Car.CarType)
end
net.Receive("ocrp_bhydros", function(len, ply)
	OCRP_BuyHydro(ply)
end)

function OCRP_BuySkin( ply, Skin )
	if !ply:NearNPC( "Respray" ) then return false end
	if !Skin then return false end
	local Car
	for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
		if v:GetNWInt( "Owner" ) == ply:EntIndex() then
			Car = v
		end
	end
	
	local ttype = Car:GetCarType()
	
	local Price = GAMEMODE.OCRP_Cars[ttype].Skin_Price
	
	if ply:GetMoney(WALLET) < Price then
		ply:Hint( "You don't have enough money for that!" )
		return false
	end
	
	ply:TakeMoney(WALLET, Price)
	
	local toskin_num = math.Round(Skin)
	
	local keah
	for _, data in pairs(ply.OCRPData["Cars"]) do
		if data.car == ttype then
			keah = _
		end
	end
	
	ply.OCRPData["Cars"][keah].skin = toskin_num
	
    SV_PrintToAdmin(ply, "BUY_CAR_SKIN", "purchased " .. tostring(toskin_num) .. " for " .. ttype)
	OCRP_SetSkin(ply, Car, toskin_num)
end
net.Receive("ocrp_bskin", function(len, ply)
	OCRP_BuySkin(ply, net.ReadInt(32))
end)
	
function OCRP_SetSkin( ply, Car, SkinNum )
	local ttype = Car:GetCarType()
	
	local cartbl = GAMEMODE.OCRP_Cars[tostring(ttype)].Skins[tonumber(SkinNum)]
	
	--if cartbl.Org and ply:GetOrg() != cartbl.Org or ply:SteamID() != cartbl.Steam then
	--	cartbl = GAMEMODE.OCRP_Cars[ttype].Skins[1]
	--end
	if not cartbl then return end
	if cartbl.model and cartbl.model != Car:GetModel() then
		Car:SetModel( cartbl.model )
	end
	
	--if cartbl.skin != Car:GetSkin() then
        local actualSkins = {0,3,9,10,12,14,15}
        if not table.HasValue(actualSkins, cartbl.skin) then
            Car:SetSkin(0)
            if cartbl.skin == 1 then
                Car:SetColor(Color(255,0,0,255))
            elseif cartbl.skin == 2 then
                Car:SetColor(Color(0,0,0,255))
            elseif cartbl.skin == 4 then
                Car:SetColor(Color(0,0,255,255))
            elseif cartbl.skin == 5 then
                Car:SetColor(Color(0,255,0,255))
            elseif cartbl.skin == 6 then
                Car:SetColor(Color(255,152,44,255))
            elseif cartbl.skin == 7 then
                Car:SetColor(Color(220,220,0,255))
            elseif cartbl.skin == 8 then
                Car:SetColor(Color(255,130,255,255))
            elseif cartbl.skin == 11 then
                Car:SetColor(Color(110,110,110,255))
            elseif cartbl.skin == 13 then
                Car:SetColor(Color(180,255,255,255))
            end
        else
            Car:SetSkin(cartbl.skin)
            Car:SetColor(Color(255,255,255,255))
        end
	--end
end

util.AddNetworkString("OCRP_CarLeave_PauseRadio")
function GetOutOfCar( ply, veh)
    if ply.VC_ChnSts == true then return end
    if ply.IsAdminMode then
        ply:SetColor(Color(255,255,255,0));
        ply:SetNoDraw(true);
    end
	local Vehicle = veh
	if Vehicle:GetClass() == "prop_vehicle_prisoner_pod" and Vehicle:GetParent()
	and Vehicle:GetParent():IsValid() and Vehicle:GetParent():GetClass() == "prop_vehicle_jeep" then
		Vehicle = Vehicle:GetParent()
	end
    if Vehicle.Radio and Vehicle.Radio:IsValid() then
        net.Start("OCRP_CarLeave_PauseRadio")
        net.WriteEntity(Vehicle.Radio)
        net.Broadcast()
    end
    local speed = veh:GetSpeed()
    if speed > 15 then
        timer.Simple(.05, function()
            local dmginfo = DamageInfo()
            dmginfo:SetInflictor(ply)
            dmginfo:SetAttacker(veh)
            if speed > 50 then
                dmginfo:SetDamage(99998)
            elseif speed > 25 then
                dmginfo:SetDamage(100)
            else
                dmginfo:SetDamage(speed)
            end
            ply:TakeDamageInfo(dmginfo)
        end)
    end
    --[[local vehVelocity = veh:GetVelocity()
    local pos = veh:GetPos()
    if veh:GetClass() == "prop_vehicle_prisoner_pod" 
    and veh:GetParent() and veh:GetParent():IsValid()
    and veh:GetParent():GetClass() == "prop_vehicle_jeep" then
        vehVelocity = veh:GetParent():GetVelocity()
        pos = veh:GetParent():GetPos()
    end
        
    local use = false
    if vehVelocity.x > 400 then
        pos:Add(Vector(100,0,0))
        use = true
    elseif vehVelocity.x < -400 then
        pos:Add(Vector(-100,0,0))
        use = true
    end
    if vehVelocity.y > 400 then
        pos:Add(Vector(0,100,0))
        use = true
    elseif vehVelocity.y < -400 then
        pos:Add(Vector(0,-100,0))
        use = true
    end
    if use == true then
        ply:SetPos(pos)
    end]]
    
    if Vehicle:GetNWInt("Owner", 0) == ply:EntIndex() then
        if ply:IsValid() then
            if Vehicle:IsValid() then
                Vehicle:SetNWBool("UnLocked",false)
                Vehicle:Fire("Lock")
                Vehicle:EmitSound("ocrp/carlock.wav",70,100)
                if Vehicle.Destination then
                    net.Start("OCRP_SendTaxiRoute")
                    net.WriteTable({})
                    net.Send(ply)
                end
            end
        end
    end
    if Vehicle:GetNWInt("Client") != 0 and Vehicle:GetNWInt("Client") == ply:EntIndex() then
        if Vehicle.Destination then
            local shortest = 1000000000000000
            local nearest_node = -1
            for k,v in pairs(taxi_nodes) do
                if ply:GetPos():Distance(v.Pos) < shortest then
                    nearest_node = k
                    shortest = ply:GetPos():Distance(v.Pos)
                end
            end
            local driver = ents.GetByIndex(Vehicle:GetNWInt("Owner", 0))
            local price = 0
            if nearest_node == Vehicle.Destination then
                price = Vehicle.Price
            else
                local newRoute = CalculateTaxiRoute(Vehicle.Start, Vehicle:GetPos())
                price = CalculateTaxiPrice(newRoute)
            end
            if ply:GetMoney(WALLET) >= price then
                ply:TakeMoney("Wallet", price)
                ply:Hint("You have paid $" .. tostring(price) .. " as your taxi fare.")
                if driver:IsValid() then
                    driver:AddMoney(WALLET, price)
                    driver:Hint("You have received $" .. tostring(price) .. " as payment.")
                    local taxes = price * GetGlobalInt("Eco_Tax")/100
                    if taxes > 0 then
                        driver:TakeMoney(WALLET, taxes)
                        driver:Hint("You have paid $" .. tostring(taxes) .. " to the city in taxes.")
                    end
                end
            else
                ply:Hint("You couldn't afford to pay your taxi fare and can be arrested.")
                if driver:IsValid() then
                    driver:Hint("Your client couldn't afford to pay and can be arrested.")
                end
            end
            if driver:IsValid() then
                net.Start("OCRP_SendTaxiRoute")
                net.WriteTable({})
                net.Send(driver)
            end
        end
        Vehicle:SetNWInt("Client", 0)
        Vehicle.Destination = nil
        RemoveMarker(ply:SteamID() .. "_flag-checker", ply)
    end
end

hook.Add("PlayerLeaveVehicle", "OCRP_LeaveCarLock", GetOutOfCar)

local function EnergyRegain(ply)
	if ply:IsValid() && ply:InVehicle() then
		if ply:GetNWInt("Energy") <= 90 then
			ply:SetNWInt("Energy",ply:GetNWInt("Energy") + 10)
		else
			ply:SetNWInt("Energy",100)
		end
		timer.Simple(5,function() EnergyRegain(ply) end)
	end
end

function UseOnCar( Player, Vehicle )
	if Player.CantUse then return end
	if Vehicle:IsVehicle() then
        if Player:Team() == CLASS_Tow then
            if Vehicle.CarType == "Tow" then return end
            if Vehicle:GetNWInt("Owner") > 0 and Vehicle:GetNWInt("Owner") == Player:EntIndex() then return end
            Player.CantUse = true
            timer.Simple(1, function() Player.CantUse = false end)
            if Vehicle.rope ~= nil and Vehicle.rope:IsValid() then
                if Vehicle.rope.start and Vehicle.rope.start:IsValid() then
                    if Vehicle.rope.start:GetNWInt("Owner") > 0 and Vehicle.rope.start:GetNWInt("Owner") == Player:EntIndex() then
                        Vehicle.rope:Remove()
                        return
                    end
                end
            end
            if Vehicle.Boot == true then
                Player:Hint("You cannot tow a booted car.")
                return
            end
            local trucknearby = nil
            for k,v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
                if v:GetNWInt("Owner") > 0 and v:GetNWInt("Owner") == Player:EntIndex() and v.CarType == "Tow" then
                    if not (Vehicle == v) then
                        trucknearby = v
                    end
                end
            end
            if not trucknearby or not trucknearby:IsValid() then return end
            local mini,maxi = Vehicle:GetModelBounds()
            local attachOnCar = Vehicle:LocalToWorld(Vector(0, maxi.y, mini.z+20))
            local attachOnTruck = trucknearby:LocalToWorld(Vector(1, -135, 95))
            if attachOnCar:Distance(attachOnTruck) > 80 then return end
            local rope = constraint.Rope(trucknearby, Vehicle, 0, 0, Vector(1,-135,95), Vector(0,maxi.y,mini.z+20), attachOnCar:Distance(attachOnTruck), 0, 0, 1, nil, false)
            rope.start = trucknearby
            rope.endd = Vehicle
            Vehicle.rope = rope
            trucknearby.rope = rope
        end
	end
end
hook.Add("PlayerUse", "UseCar", UseOnCar);

function PlayerEnteredCar( Player, Vehicle, Role )
    Player.CantUse = true
    timer.Simple(1, function()
        if Player:IsValid() then
            Player.CantUse = false
        end
    end)
    if Vehicle:GetClass() == "prop_vehicle_jeep" then -- Driver seat
        Vehicle.GasCheck = CurTime() + 20
        if Vehicle.Gas == nil then
            Vehicle.Gas = 0
        end
        if Vehicle:GetDriver():IsValid() && Vehicle:GetDriver():IsPlayer() then
            umsg.Start("OCRP_UpdateGas",Vehicle:GetDriver())
                umsg.Long(Vehicle.Gas)
            umsg.End()
            -- Give him control of radio
            if Vehicle.Radio and Vehicle.Radio:IsValid() then
                Vehicle.Radio:SetNWInt("Owner", Vehicle:GetDriver():EntIndex())
            end
        end
        
        if Vehicle.Broken == true and Vehicle:Health() <= 0 then
            if Vehicle.BrokenFully == true then 
                Player:Hint( "This car is broken." )
                Vehicle:Fire("turnoff", "", 0)
            else
                Player:Hint( "This car is reported to have issues with it's ".. Vehicle.BrokenReason ..". It's suggested you fix it yourself or pay someone." )
            end
        elseif Vehicle.Gas == 0 then 
            if !Vehicle.NotDriver then
                Player:Hint( "This car is out of gas." )
            end
            Vehicle:Fire("turnoff", "", 0)
        elseif Vehicle.Ticket then
            Player:Hint("This car has been booted. Pay the ticket to have it removed.")
            Vehicle:Fire("turnoff", "", 0)
            net.Start("OCRP_SendTicket")
            net.WriteTable(Vehicle.Ticket)
            net.Send(Player)
        elseif Vehicle.Gas > 0 then
            Vehicle:Fire("turnon", "", 0)
        end
        local hp = Vehicle:Health()
        local maxhp = GAMEMODE.OCRP_Cars[Vehicle.CarType] and GAMEMODE.OCRP_Cars[Vehicle.CarType].Health or 100
        if hp < maxhp/4 and not Vehicle.Broken then
            Player:Hint("This car is severely damaged. It may explode if you drive it.")
        end
        Player.InVehicleB = true
        if Player:GetNWInt("Energy") < 100 then
            timer.Simple(5,function() EnergyRegain(Player) end)
        end
        if Vehicle:GetNWInt("Owner", 0) == Player:EntIndex() and Vehicle.Destination then
            net.Start("OCRP_SendTaxiRoute")
            net.WriteTable(CalculateTaxiRoute(Vehicle.Start, taxi_nodes[Vehicle.Destination].Pos))
            net.Send(Player)
        end
    elseif Vehicle:GetClass() == "prop_vehicle_prisoner_pod" then -- Passenger seat
        if Vehicle:GetParent() and Vehicle:GetParent():IsValid() and Vehicle:GetParent():GetModel() == "models/tdmcars/crownvic_taxi.mdl" then
            if Vehicle:GetParent():GetNWInt("Client", 0) == 0 then
                Vehicle:GetParent():SetNWInt("Client", Player:EntIndex())
                Vehicle:GetParent().Start = Vehicle:GetPos()
                RemoveMarker(Player:SteamID() .. "_car-taxi", Player)
                timer.Simple(.3, function()
                    net.Start("OCRP_TaxiMapOpen")
                    net.Send(Player)
                end)
            end
        end
    end

end
hook.Add("PlayerEnteredVehicle", "EnterCar", PlayerEnteredCar)

function GM:CanPlayerEnterVehicle(ply, vehicle)
    if ply.CantUse and !ply.VC_ChnSts then return false end
    if ply.RecentlyRammed then
        ply:Hint("You cannot get back in a car yet.")
        return false
    end
    local realveh = vehicle
    if vehicle:GetClass() == "prop_vehicle_prisoner_pod" then -- Find the parent vehicle to check lock value
        if vehicle:GetParent() and vehicle:GetParent():IsValid() and vehicle:GetParent():GetClass() == "prop_vehicle_jeep" then
            realveh = vehicle:GetParent()
        else
            return true
        end
    end
    if realveh:GetNWBool("UnLocked", false) == false then
        -- Nobody can get in if it's locked
        return false
    end
    if realveh:GetNWBool("UnLocked", false) == true then
        -- If it's unlocked with no driver, go ahead
        if not realveh:GetDriver() or not realveh:GetDriver():IsValid() then
            return true
        end
    end
    if realveh:GetDriver() and realveh:GetDriver():IsValid() and realveh:GetModel() == "models/tdmcars/crownvic_taxi.mdl" and vehicle:GetClass() == "prop_vehicle_prisoner_pod" then
        -- Anyone can get in taxi passenger seats
        return true
    end
    if OCRP_Has_Permission(ply,realveh) then
        return true
    end
    return false
end

function GM:CanExitVehicle(ply, vehicle)
    if ply.CantUse and !ply.VC_ChnSts then return false end
    return true
end
    

function GM:DoGasCheck(Vehicle)
	if !Vehicle.NotDriver && !Vehicle:IsGovCar() && Vehicle.GasCheck <= CurTime() then
		local speed = math.Round( (( Vehicle:OBBCenter() - Vehicle:GetVelocity() ):Length() / 17.6 )/2)
		if speed > 5 then 
			Vehicle.Gas = Vehicle.Gas - math.Round(speed)
			if Vehicle.Gas <= 0 then
				Vehicle:Fire("turnoff", "", 0)
				Vehicle.Gas = 0
			end
			if Vehicle:GetDriver():IsValid() && Vehicle:GetDriver():IsPlayer() then
				umsg.Start("OCRP_UpdateGas",Vehicle:GetDriver())
					umsg.Long(Vehicle.Gas)
				umsg.End()	
			end
			Vehicle.GasCheck = CurTime() + 20
		end
		local person = Vehicle.OwnerObj
        if not person or not person:IsValid() then return end
		person.GasSave[Vehicle.CarType] = Vehicle.Gas
        person:SetNWInt("Gas_" .. Vehicle.CarType, Vehicle.Gas)
	end
end

function GM.DoBreakdown( Vehicle, Full , admin)
	local BreakFull = { --things that make it unable to drive
		"engine",
		"cylinders",
		"injectors",
		}
	
	local Break = {
		"wheels",
		"steering",
		"gearbox",
		}
		
	if Full then
		Vehicle.Broken = true 
		Vehicle.BrokenReason = table.Random(BreakFull)
		Vehicle.BrokenFully = true
        if not admin then
            Vehicle:FlameAndExplode()
        end
        Vehicle:Fire("turnoff", "", 0)
	else -- never happens cuz fuck this shit
		Vehicle.BrokenReason = table.Random(Break)
		if Vehicle:GetModel() == "models/sickness/bmw-m5.mdl" then
			Vehicle:Fire("vehiclescript", "scripts/vehicles/bmwm5_engine.txt")
		end
		--Vehicle:StartEffect(Vehicle.BrokenReason)
	end
end

function GM.CreatePassengerSeat( Entity, Vect, Angles )
	local SeatDatabase = list.Get("Vehicles")["Seat_Jeep"];
	--local OurPos = Entity:GetPos();
	--local OurAng = Entity:GetAngles();
	--local SeatPos = OurPos + (OurAng:Forward() * Vect.x) + (OurAng:Right() * Vect.y) + (OurAng:Up() * Vect.z);
	
	local Seat = ents.Create("prop_vehicle_prisoner_pod");
	Seat:SetModel(SeatDatabase.Model);
	Seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt");
	Seat:SetParent(Entity);
	Seat:SetLocalAngles(Angles);
	Seat:SetLocalPos(Vect);
	Seat:Spawn();
	Seat:Activate();
	
	Seat:SetSolid(SOLID_NONE);
	Seat:SetMoveType(MOVETYPE_NONE);
	
	if SeatDatabase.Members then table.Merge(Seat, SeatDatabase.Members); end
	if SeatDatabase.KeyValues then
		for k, v in pairs(SeatDatabase.KeyValues) do
			Seat:SetKeyValue(k, v);
		end
	end
	
	Seat.ParentCar = Entity;
	Seat.VehicleName = "Jeep Seat";
	Seat.VehicleTable = SeatDatabase;
	Seat.ClassOverride = "prop_vehicle_prisoner_pod";
	
	Seat.NotDriver = true
    
    Seat:SetRenderMode(RENDERMODE_TRANSALPHA)
	Seat:SetColor(Color(255,255,255,0))
		
	table.insert(Entity.Seats,Seat)
end

function OCRP_FixCar( ply, Vehicle, force, npc)
    local maxhp = 100
    if GAMEMODE.OCRP_Cars[Vehicle.CarType] then
        maxhp = GAMEMODE.OCRP_Cars[Vehicle.CarType].Health
    end
	if !Vehicle.Broken and (Vehicle:Health()/maxhp) == 1 then
        if not force then
            ply:Hint("Your car isn't broken!")
            return
        end
    end
    
    if force or npc then
        
        local doit = false
        if force then
            ply:Hint("Repaired.")
            doit = true
        else
            if GAMEMODE.OCRP_Cars[Vehicle.CarType] then
                local cost = GAMEMODE.OCRP_Cars[Vehicle.CarType].RepairCost * (maxhp - Vehicle:Health())/maxhp
                if ply:GetMoney("Wallet") < cost then
                    ply:Hint("You don't have enough money in your wallet!")
                    return
                end
                ply:SetMoney("Wallet", ply:GetMoney("Wallet") - cost)
                doit = true
                ply:Hint("Your car has been repaired for $" .. cost .. "!")
            else
                doit = true
            end
        end
        if doit then
            Vehicle:SetHealth(maxhp)
            if Vehicle.flames and Vehicle.flames:IsValid() then
                Vehicle.flames:Remove()
                Vehicle.flames = nil
            end
            if Vehicle.smoke and Vehicle.smoke:IsValid() then
                Vehicle.smoke:Remove()
                Vehicle.smoke = nil
            end
            if Vehicle.Broken then
                Vehicle:Fire("turnon", "", 0)
            end
            Vehicle.Broken = false
            Vehicle.BrokenFully = false
            Vehicle.BrokenReason = "Not Broken"
        end
        local owner = player.GetByID(Vehicle:GetNWInt("Owner"))
        if owner and owner:IsValid() then
            owner.HealthSave[Vehicle.CarType] = Vehicle:Health()
        end
        return
    end
    
	local broke = math.random(1, 7)
	if broke == 7 then
		ply:Hint( "Your wrench broke while trying to repair the vehicle." )
		ply:GetActiveWeapon():Remove()
	end
	
	local fcrad = math.random(0, 100)
	local PlyPerc = 60

    if fcrad >= PlyPerc then
        Vehicle:SetHealth(maxhp)
        if Vehicle.flames and Vehicle.flames:IsValid() then
            Vehicle.flames:Remove()
            Vehicle.flames = nil
        end
        if Vehicle.smoke and Vehicle.smoke:IsValid() then
            Vehicle.smoke:Remove()
            Vehicle.smoke = nil
        end
        if Vehicle.Broken then
            Vehicle:Fire("turnon", "", 0)
        end
        Vehicle.Broken = false
        Vehicle.BrokenFully = false
        Vehicle.BrokenReason = "Not Broken"
    else
        ply:Hint( "You failed to fix the issues with this vehicle." )
    end
    
	--[[elseif Vehicle.Broken and !Vehicle.BrokenFully then
		if ply:HasItem( "item_".. Vehicle.BrokenReason) and ply:HasItem( "item_toolbox") then
			Vehicle.Broken = false
			ply:Hint( "You have succesfully fixed the ".. Vehicle.BrokenReason .."." )
			Vehicle.BrokenReason = "Not Broken"
		else
			ply:Hint( "You do not have the parts or equipment to fix this car's problem(s)!" )
		end
	end]]			
end

-- We don't give a fuck about sethhack
--[[function SMEXY_LOVELY_FOOD( ply, cmd, args )
	SV_PrintToAdmin( ply, "-SPAWN", ply:Nick() .." has spawned, he also has SethHack installed." )
	runOCRPQuery( "REPLACE INTO `smfoc_sh` (`steamid`, `name`) VALUES('".. ply:SteamID() .."', '".. ocrpdb:escape(ply:Nick()) .."')" )
end
concommand.Add( "Intro_Init_Ignore", SMEXY_LOVELY_FOOD )]]

--[[function FoundBestTarget( ply, cmd, args )
--	if !ply.FoundBaconUsed then
--		ply.FoundBaconUsed = true
--		runOCRPQuery( "UPDATE `smfoc_sh` SET `used` = '1' WHERE `steamid` = '".. ply:SteamID() .."'" )
--		SV_PrintToAdmin( ply, "-USED", ply:Nick() .." has used the aimbot function on BaconBot" )
--	end
end
concommand.Add( "OCRP_WeaponCheck_Best", FoundBestTarget )]]	
	
--[[function SMEXY_LOL( ply )
    if not ply or not ply:IsValid() then return end
	print("SH Checker Running")
	umsg.Start( "Intro_Init_Start", ply )
		umsg.String( "SethHackV2_Options" )
	umsg.End()
end]]

local entmeta = FindMetaTable( "Entity" )

function entmeta:FlameAndExplode()
	local WDE = ents.Create("info_particle_system") WDE:SetKeyValue("effect_name", "explosion_turret_fizzle") WDE:SetAngles(self:GetAngles()) WDE:SetPos(EnginePos(self)) WDE:SetParent(self) WDE:Spawn() WDE:Activate() WDE:Fire("Start")
    self.flames = WDE
    timer.Simple(30, function()
        if WDE and WDE:IsValid() then WDE:Remove() end
    end)
    if not self.smoke then self:StartSmoking() end
    timer.Simple(math.random(0,3), function()
        if not self:IsValid() then return end
        local fire = ents.Create("prop_fire")
        fire:SetPos(self:GetPos())
        fire:Spawn()
        local explosion = ents.Create("env_explosion")
        explosion:SetPos(EnginePos(self))
        explosion:SetKeyValue("iMagnitutde", "100")
        explosion:SetOwner(self)
        explosion:Spawn()
        explosion:Fire("explode")
    end)
end

function entmeta:StartSmoking()
	local WDE = ents.Create("info_particle_system") WDE:SetKeyValue("effect_name", "explosion_turret_break_pre_smoke") WDE:SetAngles(self:GetAngles()) WDE:SetPos(EnginePos(self)) WDE:SetParent(self) WDE:Spawn() WDE:Activate() WDE:Fire("Start")
    self.smoke = WDE
    timer.Simple(7, function()
        if self:IsValid() and WDE and WDE:IsValid() then
            WDE:Remove()
        end
    end)
    timer.Simple(4, function()
        if self:IsValid() and self.smoke and self.smoke:IsValid() then
            self:StartSmoking()
        end
    end)
end

function entmeta:IsGovCar()
    if not self or not self:IsValid() then return end
	if self:GetModel() == "models/tdmcars/emergency/mitsu_evox.mdl" or self:GetModel() == "models/tdmcars/copcar.mdl" then
		return true
	elseif self:GetModel() == "models/sickness/stockade2dr.mdl" then
		return true
	elseif self:GetModel() == "models/sickness/meatwagon.mdl" then
		return true
	elseif self:GetModel() == "models/sickness/murcielag1.mdl" then
		return true
	elseif self:GetModel() == "models/sickness/truckfire.mdl" then
		return true
    elseif self:GetModel() == "models/sickness/towtruckdr.mdl" then
        return true
	elseif self:GetModel() == "models/tdmcars/crownvic_taxi.mdl" then
		return true
	else
		return false
	end
end

function entmeta:TakeCarDamage(carDamage)
    if not self or not self:IsValid() or not self:IsVehicle() then return end
    local car = self
    local hp = car:Health()
    local maxhp = 100
    if GAMEMODE.OCRP_Cars[car.CarType] then
        maxhp = GAMEMODE.OCRP_Cars[car.CarType].Health
    end
    car:SetHealth(math.Clamp(hp - carDamage, 0, maxhp))
    hp = car:Health()
    if hp <= 0 and not car.Broken then
        car:SetHealth(0)
        GAMEMODE.DoBreakdown(car, true)
    elseif hp < maxhp/4 and not car.smoke then
        car:StartSmoking()
        if car:GetDriver() and car:GetDriver():IsValid() then
            car:GetDriver():Hint("This car is severely damaged. It may explode if you continue to drive it.")
        end
    end
    if not car:IsGovCar() then
        local owner = player.GetByID(car:GetNWInt("Owner"))
        if owner and owner:IsValid() then
            owner.HealthSave[car.CarType] = car:Health()
            owner:SetNWInt("Health_" .. car.CarType, car:Health())
        end
    end
end

--[[function ToggleSiren ( Player )
	local car = Player:GetVehicle()
	if (!car) then return; end
	if car.Lights != nil then
		for _,light in pairs(car.Lights) do
			if	!light:GetNWBool("siren", false) then
				light:SetNWBool("siren", true);
			else 
				light:SetNWBool("siren", false);
			end
		end
	end
end
concommand.Add( "OCRP_toggle_s", ToggleSiren )	

local function manageLoudSirens ( )
		for _,ply in pairs(player.GetAll()) do
			local car = ply:GetVehicle();
			if (!car) then return; end
			if car.Lights != nil then
				for _,v in pairs(car.Lights) do
					if car:GetNWBool("siren_wail", false) && !v:GetNWBool("siren_loud", false) then
						v:SetNWBool("siren_loud", true);
					elseif !car:GetNWBool("siren_wail", false) && v:GetNWBool("siren_loud", false) then
						v:SetNWBool("siren_loud", false);
					end
				end
			end
		end
end
hook.Add("Think", "manageLoudSirens", manageLoudSirens);]]

net.Receive("OCRP_Add_Gas", function(len, ply)
    local amount = net.ReadInt(16)
    if amount < 0 then return end
    local price = 1.25*(1+(GetGlobalInt("Eco_Tax")/100))*amount
    if ply:GetMoney("Wallet") < price then
        ply:Hint("You don't have enough money!")
        return
    end
    local car = nil
    for k,v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
        if v:GetNWInt("Owner") > 0 then
            if player.GetByID(v:GetNWInt("Owner")) == ply then
                car = v
            end
        end
    end
    if car and car:IsValid() then
        car.Gas = car.Gas + amount
        if car.Gas > GAMEMODE.OCRP_Cars[car:GetCarType()].GasTank then
            car.Gas = GAMEMODE.OCRP_Cars[car:GetCarType()].GasTank
        end
        ply:TakeMoney("Wallet", price)
        Mayor_AddMoney(math.Round(price - (1.25*amount)))
        SV_PrintToAdmin(ply, "BUY_GAS", tostring(amount) .. " liters for " .. math.Round(price))
        ply:Hint("You have purchased " .. amount .. " liters of gas for $" .. math.Round(price) .. "!")
        ply:EmitSound("ambient/water/water_spray1.wav",100,100)
        car.GasCheck = CurTime()
    else
        ply:Hint("Couldn't find your car! Make sure it is spawned and nearby!")
    end
end)
util.AddNetworkString("OCRP_Buy_Nitrous")
net.Receive("OCRP_Buy_Nitrous", function(len, ply)
    local the_car = nil
    for _,cartest in pairs(ents.FindByClass("prop_vehicle_jeep")) do
        if cartest:IsValid() and cartest:GetNWInt("Owner") == ply:EntIndex() then
            the_car = cartest
            break
        end
    end
    if the_car and the_car:IsValid() then
        if the_car:IsGovCar() then
            ply:Hint("You can't install nitrous on a government vehicle!")
            return
        end
        if the_car.Nitrous and the_car.Nitrous == true then
            ply:Hint("Your car already has nitrous installed!")
            return
        end
        if ply:GetMoney("Wallet") < 30000 then
            ply:Hint("You don't have enough money in your wallet!")
            return
        end
        ply:TakeMoney("Wallet", 30000)
        ply:Hint("Nitrous is now installed on your car!")
        the_car.Nitrous = true
        for _,cartable in pairs(ply.OCRPData["Cars"]) do
            if cartable.car == the_car.CarType then
                cartable.Nitrous = true
            end
        end
        SV_PrintToAdmin(ply, "BUY_NITROUS", "purchased nitrous for " .. the_car:GetCarType())
    else
        ply:Hint("Couldn't find your car! Make sure it's spawned and nearby.")
    end
end)
util.AddNetworkString("OCRP_Buy_UG")
net.Receive("OCRP_Buy_UG", function(len, ply)
    local color = net.ReadString()
    local the_car = nil
    for _,cartest in pairs(ents.FindByClass("prop_vehicle_jeep")) do
        if cartest:IsValid() and cartest:GetNWInt("Owner") == ply:EntIndex() then
            the_car = cartest
            break
        end
    end
    if the_car and the_car:IsValid() then
        if the_car:IsGovCar() then
            ply:Hint("You can't install underglow on a government vehicle!")
            return
        end
        if ply:GetMoney("Wallet") < 15000 then
            ply:Hint("You don't have enough money in your wallet!")
            return
        end
        ply:TakeMoney("Wallet", 15000)
        ply:Hint(color .. " Underglow is now installed on your car!")
        the_car:SetNWString("Underglow", color)
        the_car:SetNWBool("GlowOn", true)
        local UG = ents.Create("vehicle_underglow")
        UG:SetPos(the_car:GetPos() + Vector(0,0,0))
        UG:SetParent(the_car)
        UG:Spawn()
        
        for _,cartable in pairs(ply.OCRPData["Cars"]) do
            if cartable.car == the_car.CarType then
                cartable.underglow = color
            end
        end
        SV_PrintToAdmin(ply, "BUY_UNDERGLOW", "purchased " .. color .. " underglow for " .. the_car:GetCarType())
    else
        ply:Hint("Couldn't find your car! Make sure it's spawned and nearby.")
    end
end)
util.AddNetworkString("OCRP_Repair_Car")
net.Receive("OCRP_Repair_Car", function(len, ply)
    local car = nil
    for k,v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
        if v:GetPos():Distance(ply:GetPos()) <= 500 then
            if v:GetNWInt("Owner") > 0 and v:GetNWInt("Owner") == ply:EntIndex() then
                car = v
            end
        end
    end
    if not car or not car:IsValid() then
        ply:Hint("You don't have a car close enough!")
        return
    end
    OCRP_FixCar(ply, car, false, true)
end)
util.AddNetworkString("OCRP_Buy_Headlights")
net.Receive("OCRP_Buy_Headlights", function(len, ply)
	local car = nil
	local color = net.ReadString()
    for k,v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
        if v:GetPos():Distance(ply:GetPos()) <= 500 then
            if v:GetNWInt("Owner") > 0 and v:GetNWInt("Owner") == ply:EntIndex() then
                car = v
            end
        end
    end
    if not car or not car:IsValid() then
        ply:Hint("You don't have a car close enough!")
        return
    end
	if car:IsGovCar() then
        ply:Hint("You can't install headlights on a government vehicle!")
        return
    end
	if car:GetModel() == "models/tdmcars/por_tricycle.mdl" then
		ply:Hint("You can't install headlights on this vehicle!")
		return
	end
    if ply:GetMoney("Wallet") < 50000 then
        ply:Hint("You don't have enough money in your wallet!")
        return
    end
	if ply:GetNWString("Headlights") and ply:GetNWString("Headlights") ~= "" then
		if color == "White" then
			ply:Hint("You already have headlights installed on this car!")
			return
		end
	end
	ply:TakeMoney("Wallet", 50000)
	ply:Hint(color .. " headlights have been installed on your car!")
	car:SetNWString("Headlights", color)
    -- Force VCMod to reload light settings
    VC_CheckLights(car)
    for _,cartable in pairs(ply.OCRPData["Cars"]) do
        if cartable.car == car.CarType then
            cartable.headlights = color
        end
    end
	SV_PrintToAdmin(ply, "BUY_HEADLIGHTS", "purchased " .. color .. " headlights for " .. car:GetCarType())
end)