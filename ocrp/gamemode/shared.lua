--[[function AutoAdd_LuaFiles()
	if SERVER then
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/client/*') || {} ) do
			if string.find(file,".lua") then
				AddCSLuaFile('client/'..file)
				Msg(file..",")
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/shared/*') || {}) do
			if string.find(file,".lua") then
				AddCSLuaFile('shared/'..file)
				include('shared/'..file)
				Msg(file..",")
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/server/*') || {} ) do
			if string.find(file,".lua") then
				include('server/'..file)
				Msg(file..",")
			end
		end
	else
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/shared/*') || {}) do
			if string.find(file,".lua") then
				include('shared/'..file)
				Msg(file..",")
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/client/*') || {} ) do
			if string.find(file,".lua") then
				include('client/'..file)
				Msg(file..",")
			end
		end
	end
end
]]

GM.Name 		= "Orange Cosmos RP (ZG)"
GM.Author 		= "Jake_1305, Noobulator, RealDope"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= false

GM.Path = "OCRP";
GM.CurrentTime = 0;

--Let's add the CLASSES
CLASS_CITIZEN = 1 -- The Citizen Class
CLASS_MEDIC = 2 -- The Medic Class
CLASS_POLICE = 3 -- The Police Class
CLASS_SWAT = 4 -- Mayor Team
CLASS_CHIEF = 5
CLASS_Mayor = 6 -- Mayor Team
CLASS_FIREMAN = 7
CLASS_Tow = 8
CLASS_TAXI = 9
--End adding CLASSES

PMETA = FindMetaTable( "Player" )
function PMETA:GetLevel() -- Workaround for assmod level system, not sure how well will work..
    local group = self:GetUserGroup()
    if group == "owner" then
        return 0
    elseif group == "superadmin" then
        return 1
    elseif group == "admin" then
        return 2
    elseif group == "elite" then
        return 3
    elseif group == "vip" then
        return 4
    else
        return 5
    end
end

function PMETA:IsBetterOrSame(ply)
    if self:GetLevel() <= ply:GetLevel() then
        return true
    end
    return false
end

hook.Add("EntityTakeDamage", "OCRPCarTakeDamage", function(ent, info)
    if ent:IsPlayer() and ent:IsValid() then
        if info:GetDamageType() == 17 then
            local carDamage = info:GetDamage() * 1.65
            if ent:GetVehicle() and ent:GetVehicle():IsValid() then
                ent:GetVehicle():TakeCarDamage(carDamage)
                --[[local car = ent:GetVehicle()
                local hp = car:Health()
                local maxhp = 100
                if GAMEMODE.OCRP_Cars[car.CarType] then
                    maxhp = GAMEMODE.OCRP_Cars[car.CarType].Health
                end
                car:SetHealth(hp - carDamage)
                hp = car:Health()
                if hp <= 0 and not car.Broken then
                    car:SetHealth(0)
                    GAMEMODE.DoBreakdown(car, true)
                elseif hp < maxhp/4 and not car.smoke then
                    car:StartSmoking()
                    ent:Hint("This car is severely damaged. It may explode if you continue to drive it.")
                end
                if not car:IsGovCar() then
                    ent.HealthSave[car.CarType] = car:Health()
                    ent:SetNWInt("Health_" .. car.CarType, car:Health())
                end]]
            end
        end
    end
end)

NUMBER_FIREMEN = 0

--Lets set up the teams as the following:
team.SetUp (CLASS_CITIZEN, "Citizen", Color (34, 180, 0, 255))
team.SetUp (CLASS_MEDIC, "Medic", Color (255, 135, 255, 255))
team.SetUp (CLASS_FIREMAN, "Fireman", Color (255, 165, 0, 255))
team.SetUp (CLASS_POLICE, "Police", Color (30,30,220, 255))
team.SetUp (CLASS_SWAT, "SWAT", Color (50,50,140, 255))
team.SetUp (CLASS_CHIEF, "Police Chief", Color (50,50,255, 255))
team.SetUp (CLASS_Mayor, "Mayor", Color (240, 0, 0, 255))
team.SetUp (CLASS_Tow, "Tow Truck Driver", Color(196, 200, 0, 255))

GM.Properties = {}
GM.Properties["rp_evocity_v4b1"] = {}

    GM.Properties["rp_evocity_v4b1"][1] = {Name="City Shop A",Desc="Nice open shop\nRight on main street.",Price=800, Doors={}, type="business",Icon1="cityshopa",Icon2="cityshopa"}
    GM.Properties["rp_evocity_v4b1"][1].Doors[2495] = true
    GM.Properties["rp_evocity_v4b1"][1].Doors[2494] = true
    
    GM.Properties["rp_evocity_v4b1"][2] = {Name="City Shop B",Desc="Nice open shop.\nRight on main street.",Price=800, Doors={}, type="business",Icon1="cityshopb",Icon2="cityshopb"}
    GM.Properties["rp_evocity_v4b1"][2].Doors[2492] = true
    GM.Properties["rp_evocity_v4b1"][2].Doors[2493] = true
    
    GM.Properties["rp_evocity_v4b1"][3] = {Name="City Shop C",Desc="Large shop with 2 floors.\nVisible from main street.",Price=1000, Doors={}, type="business",Icon1="cityshopc",Icon2="cityshopc"}
    GM.Properties["rp_evocity_v4b1"][3].Doors[2490] = true
    GM.Properties["rp_evocity_v4b1"][3].Doors[2491] = true
    
    GM.Properties["rp_evocity_v4b1"][4] = {Name="Burger King",Desc="Large, popular spot.\nEquipped with kitchen and tables.",Price=1500, Doors={}, type="business",Icon1="burgerking",Icon2="burgerking"}
    GM.Properties["rp_evocity_v4b1"][4].Doors[2312] = true
    GM.Properties["rp_evocity_v4b1"][4].Doors[2311] = true
    GM.Properties["rp_evocity_v4b1"][4].Doors[3945] = true
    GM.Properties["rp_evocity_v4b1"][4].Doors[3903] = true

    GM.Properties["rp_evocity_v4b1"][5] = {Name="Empire Room 1",Desc="Comfortable hotel room.\nBathroom and bedroom.", Price=750, Doors ={}, type="apartment",Icon1="empire",Icon2="empire"}
    GM.Properties["rp_evocity_v4b1"][5].Doors[2015] = true
    GM.Properties["rp_evocity_v4b1"][5].Doors[2050] = true
    
    GM.Properties["rp_evocity_v4b1"][6] = {Name="Empire Room 2",Desc="Comfortable hotel room.\nBathroom and bedroom.",Price=750, Doors ={}, type="apartment",Icon1="empire",Icon2="empire"}
    GM.Properties["rp_evocity_v4b1"][6].Doors[2014] = true
    GM.Properties["rp_evocity_v4b1"][6].Doors[2045] = true

    GM.Properties["rp_evocity_v4b1"][7] = {Name="Empire Room 3",Desc="Comfortable hotel room.\nBathroom and bedroom.",Price=750, Doors ={}, type="apartment",Icon1="empire",Icon2="empire"}
    GM.Properties["rp_evocity_v4b1"][7].Doors[2016] = true
    GM.Properties["rp_evocity_v4b1"][7].Doors[2049] = true

    GM.Properties["rp_evocity_v4b1"][8] = {Name="Empire Room 4",Desc="Comfortable hotel room.\nBathroom and bedroom.",Price=750, Doors ={}, type="apartment",Icon1="empire",Icon2="empire"}
    GM.Properties["rp_evocity_v4b1"][8].Doors[2017] = true
    GM.Properties["rp_evocity_v4b1"][8].Doors[2046] = true

    GM.Properties["rp_evocity_v4b1"][9] = {Name="Empire Room 5",Desc="Comfortable hotel room.\nIn the far back.",Price=850, Doors ={}, type="apartment",Icon1="empire",Icon2="empire"}
    GM.Properties["rp_evocity_v4b1"][9].Doors[2018] = true
    GM.Properties["rp_evocity_v4b1"][9].Doors[2048] = true

    GM.Properties["rp_evocity_v4b1"][10] = {Name="Empire Room 6",Desc="Comfortable hotel room.\nIn the far back.",Price=850, Doors ={}, type="apartment",Icon1="empire",Icon2="empire"}
    GM.Properties["rp_evocity_v4b1"][10].Doors[2019] = true
    GM.Properties["rp_evocity_v4b1"][10].Doors[2047] = true
    
    GM.Properties["rp_evocity_v4b1"][11] = {Name="City Shop D",Desc="Large and open.\nSituated on the upper main street.",Price=700, Doors={}, type="business",Icon1="cityshopd",Icon2="cityshopd"}
    GM.Properties["rp_evocity_v4b1"][11].Doors[1340] = true
    
    GM.Properties["rp_evocity_v4b1"][12] = {Name="City Shop E",Desc="Large and open.\nSituated on the upper main street.",Price=700, Doors={}, type="business",Icon1="cityshope",Icon2="cityshope"}
    GM.Properties["rp_evocity_v4b1"][12].Doors[1342] = true
    
    GM.Properties["rp_evocity_v4b1"][13] = {Name="City Shop F",Desc="Large and open.\nSituated on the upper main street.",Price=700, Doors={}, type="business",Icon1="cityshopf",Icon2="cityshopf"}
    GM.Properties["rp_evocity_v4b1"][13].Doors[1343] = true
    
    GM.Properties["rp_evocity_v4b1"][14] = {Name="Main Street Shop",Desc="Large and open.\nTucked behind Nexus, across from garage.",Price=900, Doors={}, type="business",Icon1="mainstreetshop",Icon2="mainstreetshop"}
    GM.Properties["rp_evocity_v4b1"][14].Doors[2190] = true

    GM.Properties["rp_evocity_v4b1"][15] = {Name="Izzie's Palace",Desc="Dimly lit night club in the city.\nPassive RP only.",Price=2500, Doors={}, type="business",Icon1="izzies",Icon2="izzies"}
    GM.Properties["rp_evocity_v4b1"][15].Doors[2435] = true
    GM.Properties["rp_evocity_v4b1"][15].Doors[2436] = true
    GM.Properties["rp_evocity_v4b1"][15].Doors[2474] = true
    GM.Properties["rp_evocity_v4b1"][15].Doors[2475] = true
    GM.Properties["rp_evocity_v4b1"][15].Doors[2489] = true
    
    GM.Properties["rp_evocity_v4b1"][16] = {Name="The Bar",Desc="Classy bar with outdoor seating.\nLocated below the apartments.",Price=1500, Doors={}, type="business",Icon1="thebar",Icon2="thebar"}
    GM.Properties["rp_evocity_v4b1"][16].Doors[2804] = true
    GM.Properties["rp_evocity_v4b1"][16].Doors[2805] = true
    GM.Properties["rp_evocity_v4b1"][16].Doors[2803] = true
    GM.Properties["rp_evocity_v4b1"][16].Doors[2802] = true
    GM.Properties["rp_evocity_v4b1"][16].Doors[2766] = true
    GM.Properties["rp_evocity_v4b1"][16].Doors[2767] = true
    GM.Properties["rp_evocity_v4b1"][16].Doors[2768] = true
    GM.Properties["rp_evocity_v4b1"][16].Doors[2769] = true
    GM.Properties["rp_evocity_v4b1"][16].Doors[2863] = true
    
    GM.Properties["rp_evocity_v4b1"][17] = {Name="Apartment Lobby Shop 1",Desc="Well lit shop.\nJust inside the apartment building.",Price=500, Doors={}, type="business",Icon1="apartments",Icon2="apartmentlobbyshop1"}
    GM.Properties["rp_evocity_v4b1"][17].Doors[2925] = true

    GM.Properties["rp_evocity_v4b1"][18] = {Name="Apartment Lobby Shop 2",Desc="Well lit shop.\nJust inside the apartment building.",Price=500, Doors={}, type="business",Icon1="apartments",Icon2="apartmentlobbyshop2"}
    GM.Properties["rp_evocity_v4b1"][18].Doors[2815] = true

    GM.Properties["rp_evocity_v4b1"][19] = {Name="Apartment Street Shop 1",Desc="Small shop.\nSmall counter in back.",Price=500, Doors={}, type="business",Icon1="apartmentshop1",Icon2="apartmentshop1"}
    GM.Properties["rp_evocity_v4b1"][19].Doors[2821] = true

    GM.Properties["rp_evocity_v4b1"][20] = {Name="Apartment Street Shop 2",Desc="Medium sized shop.\nSmall back room.",Price=700, Doors={}, type="business",Icon1="apartmentshop2",Icon2="apartmentshop2"}
    GM.Properties["rp_evocity_v4b1"][20].Doors[2820] = true
    GM.Properties["rp_evocity_v4b1"][20].Doors[2831] = true
    
    GM.Properties["rp_evocity_v4b1"][21] = {Name="Apartment 1",Desc="Medium sized apartment.\nBathroom, kitchen, side room.",Price=1250, Doors={}, type="apartment",Icon1="apartments",Icon2="apartment1"}
    GM.Properties["rp_evocity_v4b1"][21].Doors[2885] = true
    GM.Properties["rp_evocity_v4b1"][21].Doors[2884] = true
    GM.Properties["rp_evocity_v4b1"][21].Doors[2889] = true
    GM.Properties["rp_evocity_v4b1"][21].Doors[2880] = true
    
    GM.Properties["rp_evocity_v4b1"][22] = {Name="Apartment 2",Desc="Slightly smaller apartment.",Price=1000, Doors={}, type="apartment",Icon1="apartments",Icon2="apartment2"}
    GM.Properties["rp_evocity_v4b1"][22].Doors[2894] = true
    GM.Properties["rp_evocity_v4b1"][22].Doors[2896] = true
    GM.Properties["rp_evocity_v4b1"][22].Doors[2895] = true
    GM.Properties["rp_evocity_v4b1"][22].Doors[2888] = true
    
    GM.Properties["rp_evocity_v4b1"][23] = {Name="Apartment 3",Desc="Slightly smaller apartment.\nOn the third floor.",Price=1150, Doors={}, type="apartment",Icon1="apartments",Icon2="apartment3"}
    GM.Properties["rp_evocity_v4b1"][23].Doors[2897] = true
    GM.Properties["rp_evocity_v4b1"][23].Doors[2924] = true
    GM.Properties["rp_evocity_v4b1"][23].Doors[2819] = true
    GM.Properties["rp_evocity_v4b1"][23].Doors[2909] = true
    
    GM.Properties["rp_evocity_v4b1"][24] = {Name="Apartment 4",Desc="Slightly smaller apartment.\nOn the third floor with a patio.",Price=1350, Doors={}, type="apartment",Icon1="apartments",Icon2="apartment4"}
    GM.Properties["rp_evocity_v4b1"][24].Doors[2898] = true
    GM.Properties["rp_evocity_v4b1"][24].Doors[2899] = true
    GM.Properties["rp_evocity_v4b1"][24].Doors[2900] = true
    GM.Properties["rp_evocity_v4b1"][24].Doors[2770] = true
    GM.Properties["rp_evocity_v4b1"][24].Doors[2771] = true

    GM.Properties["rp_evocity_v4b1"][25] = {Name="Apartment 5",Desc="Medium sized apartment.\nPrivate roof access.",Price=1600, Doors={}, type="apartment",Icon1="apartments",Icon2="apartment5"}
    GM.Properties["rp_evocity_v4b1"][25].Doors[2920] = true
    GM.Properties["rp_evocity_v4b1"][25].Doors[2919] = true
    GM.Properties["rp_evocity_v4b1"][25].Doors[2901] = true
    GM.Properties["rp_evocity_v4b1"][25].Doors[2913] = true
    GM.Properties["rp_evocity_v4b1"][25].Doors[2865] = true
    GM.Properties["rp_evocity_v4b1"][25].Doors[2866] = true

    GM.Properties["rp_evocity_v4b1"][26] = {Name="Studio Apartment 1",Desc="Medium sized apartment.\nEntrance around back.",Price=1100, Doors={}, type="apartment",Icon1="studioapartments",Icon2="studioapartment1"}
    GM.Properties["rp_evocity_v4b1"][26].Doors[2822] = true
    GM.Properties["rp_evocity_v4b1"][26].Doors[2832] = true

    GM.Properties["rp_evocity_v4b1"][27] = {Name="Studio Apartment 2",Desc="Larger classy apartment.\nEntrance around back.",Price=1100, Doors={}, type="apartment",Icon1="studioapartments",Icon2="studioapartment2"}
    GM.Properties["rp_evocity_v4b1"][27].Doors[2824] = true
    GM.Properties["rp_evocity_v4b1"][27].Doors[2930] = true
    GM.Properties["rp_evocity_v4b1"][27].Doors[2823] = true
    
    GM.Properties["rp_evocity_v4b1"][28] = {Name="Abandoned Warehouse",Desc="Large, indoor, and open.\nRight outside of town.",Price=1250, Doors={}, type="industrial",Icon1="abandonedwarehouse",Icon2="abandonedwarehouse"}
    GM.Properties["rp_evocity_v4b1"][28].Doors[3688] = true
    GM.Properties["rp_evocity_v4b1"][28].Doors[3690] = true
    GM.Properties["rp_evocity_v4b1"][28].Doors[3689] = true
    
    GM.Properties["rp_evocity_v4b1"][29] = {Name="Industrial Garage and Office 1",Desc="Small office and medium sized garage.\n3 loading bays.",Price=1000, Doors={}, type="industrial",Icon1="industrialgarage1",Icon2="industrialgarage1"}
    GM.Properties["rp_evocity_v4b1"][29].Doors[3233] = true
    GM.Properties["rp_evocity_v4b1"][29].Doors[3234] = true
    GM.Properties["rp_evocity_v4b1"][29].Doors[3231] = true
    GM.Properties["rp_evocity_v4b1"][29].Doors[3230] = true
    GM.Properties["rp_evocity_v4b1"][29].Doors[3232] = true
    
    GM.Properties["rp_evocity_v4b1"][30] = {Name="Industrial Garage and Office 2",Desc="Very small office and larger garage.\n1 loading bay.",Price=1350, Doors={}, type="industrial",Icon1="industrialgarage2",Icon2="industrialgarage2"}
    GM.Properties["rp_evocity_v4b1"][30].Doors[3224] = true
    GM.Properties["rp_evocity_v4b1"][30].Doors[3225] = true
    GM.Properties["rp_evocity_v4b1"][30].Doors[3223] = true
    
    GM.Properties["rp_evocity_v4b1"][31] = {Name="Industrial Plant",Desc="Large outdoor area.\nTall building with much space.",Price=1750, Doors={}, type="industrial",Icon1="industrialplant",Icon2="industrialplant"}
    GM.Properties["rp_evocity_v4b1"][31].Doors[3246] = true
    GM.Properties["rp_evocity_v4b1"][31].Doors[3248] = true
    GM.Properties["rp_evocity_v4b1"][31].Doors[2646] = true
    GM.Properties["rp_evocity_v4b1"][31].Doors[2645] = true
    
    GM.Properties["rp_evocity_v4b1"][32] = {Name="Industrial Building 1",Desc="Large, open, indoor space.\n2 doors and 2 loading bays.",Price=1400, Doors={}, type="industrial",Icon1="industrialbuilding1",Icon2="industrialbuilding1"}
    GM.Properties["rp_evocity_v4b1"][32].Doors[2639] = true
    GM.Properties["rp_evocity_v4b1"][32].Doors[2614] = true
    GM.Properties["rp_evocity_v4b1"][32].Doors[2613] = true
    GM.Properties["rp_evocity_v4b1"][32].Doors[2640] = true
    
    GM.Properties["rp_evocity_v4b1"][33] = {Name="Industrial Building 2",Desc="Small room and large back room.\n2 entrances and 2 loading bays.",Price=1550, Doors={}, type="industrial",Icon1="industrialbuilding2",Icon2="industrialbuilding2"}
    GM.Properties["rp_evocity_v4b1"][33].Doors[2609] = true
    GM.Properties["rp_evocity_v4b1"][33].Doors[2611] = true
    GM.Properties["rp_evocity_v4b1"][33].Doors[2610] = true
    GM.Properties["rp_evocity_v4b1"][33].Doors[2615] = true
    
    GM.Properties["rp_evocity_v4b1"][34] = {Name="Industrial Shop 1",Desc="Medium sized 1 entrance shop.\nSmall backroom.",Price=900, Doors={}, type="industrial",Icon1="industrialshop1",Icon2="industrialshop1"}
    GM.Properties["rp_evocity_v4b1"][34].Doors[1614] = true
    GM.Properties["rp_evocity_v4b1"][34].Doors[1621] = true

    GM.Properties["rp_evocity_v4b1"][35] = {Name="Industrial Shop 2",Desc="Medium sized 1 entrance shop.\nLarger backroom.",Price=1050, Doors={}, type="industrial",Icon1="industrialshop2",Icon2="industrialshop2"}
    GM.Properties["rp_evocity_v4b1"][35].Doors[1625] = true
    GM.Properties["rp_evocity_v4b1"][35].Doors[1626] = true

    GM.Properties["rp_evocity_v4b1"][36] = {Name="MTL",Desc="Massive industrial complex.\n3 separate buildings and a security gate.",Price=3500, Doors={}, type="industrial",Icon1="mtl",Icon2="mtl"}
    GM.Properties["rp_evocity_v4b1"][36].Doors[2589] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2571] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2602] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2540] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2527] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2525] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2526] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[3219] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[3221] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[3296] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[3351] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2590] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2599] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2600] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2601] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2545] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2543] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2542] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2544] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2548] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2549] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[3212] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2573] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2572] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2575] = true
    GM.Properties["rp_evocity_v4b1"][36].Doors[2574] = true
    
    GM.Properties["rp_evocity_v4b1"][37] = {Name="Whispering Oaks Motel Room 1",Desc="Tiny motel room with bed.\nSmall back room.",Price=350, Doors={}, type="apartment",Icon1="motel",Icon2="motel"}
    GM.Properties["rp_evocity_v4b1"][37].Doors[3450] = true
    GM.Properties["rp_evocity_v4b1"][37].Doors[3197] = true
    
    GM.Properties["rp_evocity_v4b1"][38] = {Name="Whispering Oaks Motel Room 2",Desc="Tiny motel room with bed.\nSmall back room.",Price=350, Doors={}, type="apartment",Icon1="motel",Icon2="motel"}
    GM.Properties["rp_evocity_v4b1"][38].Doors[3196] = true
    GM.Properties["rp_evocity_v4b1"][38].Doors[3449] = true

    GM.Properties["rp_evocity_v4b1"][39] = {Name="Whispering Oaks Motel Room 3",Desc="Tiny motel room with bed.\nSmall back room.",Price=350, Doors={}, type="apartment",Icon1="motel",Icon2="motel"}
    GM.Properties["rp_evocity_v4b1"][39].Doors[3198] = true
    GM.Properties["rp_evocity_v4b1"][39].Doors[3448] = true

    GM.Properties["rp_evocity_v4b1"][40] = {Name="Whispering Oaks Motel Room 4",Desc="Tiny motel room with bed.\nSmall back room.",Price=350, Doors={}, type="apartment",Icon1="motel",Icon2="motel"}
    GM.Properties["rp_evocity_v4b1"][40].Doors[3199] = true
    GM.Properties["rp_evocity_v4b1"][40].Doors[3447] = true

    GM.Properties["rp_evocity_v4b1"][41] = {Name="Whispering Oaks Motel Room 5",Desc="Tiny motel room with bed.\nSmall back room.",Price=350, Doors={}, type="apartment",Icon1="motel",Icon2="motel"}
    GM.Properties["rp_evocity_v4b1"][41].Doors[3200] = true
    GM.Properties["rp_evocity_v4b1"][41].Doors[3446] = true

    GM.Properties["rp_evocity_v4b1"][42] = {Name="Whispering Oaks Motel Room 6",Desc="Tiny motel room with bed.\nSmall back room.",Price=350, Doors={}, type="apartment",Icon1="motel",Icon2="motel"}
    GM.Properties["rp_evocity_v4b1"][42].Doors[3201] = true
    GM.Properties["rp_evocity_v4b1"][42].Doors[3445] = true

    GM.Properties["rp_evocity_v4b1"][43] = {Name="Night Club",Desc="Huge club with private rooms and bars.\n2 separate buildings.",Price=3000, Doors={}, type="business",Icon1="nightclub",Icon2="nightclub"}
    GM.Properties["rp_evocity_v4b1"][43].Doors[2296] = true
    GM.Properties["rp_evocity_v4b1"][43].Doors[2281] = true
    GM.Properties["rp_evocity_v4b1"][43].Doors[2280] = true
    GM.Properties["rp_evocity_v4b1"][43].Doors[3831] = true
    GM.Properties["rp_evocity_v4b1"][43].Doors[3832] = true
    GM.Properties["rp_evocity_v4b1"][43].Doors[2279] = true
    GM.Properties["rp_evocity_v4b1"][43].Doors[3782] = true
    GM.Properties["rp_evocity_v4b1"][43].Doors[3783] = true
    GM.Properties["rp_evocity_v4b1"][43].Doors[3784] = true
    GM.Properties["rp_evocity_v4b1"][43].Doors[2283] = true
    GM.Properties["rp_evocity_v4b1"][43].Doors[2282] = true
    
    GM.Properties["rp_evocity_v4b1"][44] = {Name="Cabin in the Woods 1",Desc="Small 3 room cabin.\nFar outside of town.",Price=800, Doors={}, type="house",Icon1="cabin1",Icon2="cabin"}
    GM.Properties["rp_evocity_v4b1"][44].Doors[1353] = true
    GM.Properties["rp_evocity_v4b1"][44].Doors[1355] = true
    GM.Properties["rp_evocity_v4b1"][44].Doors[1354] = true
    
    GM.Properties["rp_evocity_v4b1"][45] = {Name="Cabin in the Woods 2",Desc="Small 3 room cabin.\nFar outside of town.",Price=800, Doors={}, type="house",Icon1="cabin2",Icon2="cabin"}
    GM.Properties["rp_evocity_v4b1"][45].Doors[1360] = true
    GM.Properties["rp_evocity_v4b1"][45].Doors[1362] = true
    GM.Properties["rp_evocity_v4b1"][45].Doors[1361] = true

    
    GM.Properties["rp_evocity_v4b1"][46] = {Name="Cabin in the Woods 3",Desc="Small 3 room cabin.\nFar outside of town.",Price=800, Doors={}, type="house",Icon1="cabin3",Icon2="cabin"}
    GM.Properties["rp_evocity_v4b1"][46].Doors[1367] = true
    GM.Properties["rp_evocity_v4b1"][46].Doors[1369] = true
    GM.Properties["rp_evocity_v4b1"][46].Doors[1368] = true

    GM.Properties["rp_evocity_v4b1"][47] = {Name="Small House in the Woods",Desc="Medium sized 3 room cabin.\nFar outside of town.",Price=950, Doors={}, type="house",Icon1="woodshouse",Icon2="woodshouse"}
    GM.Properties["rp_evocity_v4b1"][47].Doors[2310] = true
    GM.Properties["rp_evocity_v4b1"][47].Doors[2305] = true
    GM.Properties["rp_evocity_v4b1"][47].Doors[2304] = true

    GM.Properties["rp_evocity_v4b1"][48] = {Name="Suburban House 1",Desc="Large 3 floor house.\nMedium sized back yard.",Price=2500, Doors={}, type="house",Icon1="subs1",Icon2="subs1"}
    GM.Properties["rp_evocity_v4b1"][48].Doors[3128] = true
    GM.Properties["rp_evocity_v4b1"][48].Doors[3129] = true
    GM.Properties["rp_evocity_v4b1"][48].Doors[3102] = true
    GM.Properties["rp_evocity_v4b1"][48].Doors[3193] = true
    GM.Properties["rp_evocity_v4b1"][48].Doors[3901] = true
    GM.Properties["rp_evocity_v4b1"][48].Doors[3131] = true
    GM.Properties["rp_evocity_v4b1"][48].Doors[3130] = true
    
    GM.Properties["rp_evocity_v4b1"][49] = {Name="Suburban House 2",Desc="Large 3 floor house.\nHuge back yard.",Price=2500, Doors={}, type="house",Icon1="subs2",Icon2="subs2"}
    GM.Properties["rp_evocity_v4b1"][49].Doors[3123] = true
    GM.Properties["rp_evocity_v4b1"][49].Doors[3187] = true
    GM.Properties["rp_evocity_v4b1"][49].Doors[3108] = true
    GM.Properties["rp_evocity_v4b1"][49].Doors[3109] = true
    GM.Properties["rp_evocity_v4b1"][49].Doors[3106] = true
    GM.Properties["rp_evocity_v4b1"][49].Doors[3107] = true
    GM.Properties["rp_evocity_v4b1"][49].Doors[3110] = true
    GM.Properties["rp_evocity_v4b1"][49].Doors[3111] = true
    GM.Properties["rp_evocity_v4b1"][49].Doors[3900] = true
    
    GM.Properties["rp_evocity_v4b1"][50] = {Name="Suburban House 3",Desc="Large 1 floor house.\nLarge back yard.",Price=2000, Doors={}, type="house",Icon1="subs3",Icon2="subs3"}
    GM.Properties["rp_evocity_v4b1"][50].Doors[3154] = true
    GM.Properties["rp_evocity_v4b1"][50].Doors[3153] = true
    GM.Properties["rp_evocity_v4b1"][50].Doors[3155] = true
    GM.Properties["rp_evocity_v4b1"][50].Doors[3150] = true
    GM.Properties["rp_evocity_v4b1"][50].Doors[3152] = true
    GM.Properties["rp_evocity_v4b1"][50].Doors[3147] = true
    GM.Properties["rp_evocity_v4b1"][50].Doors[3151] = true
    GM.Properties["rp_evocity_v4b1"][50].Doors[3191] = true

    GM.Properties["rp_evocity_v4b1"][51] = {Name="Lakeside House 1",Desc="Medium sized house.\nBy the lakeside.",Price=1150, Doors={}, type="house",Icon1="lakehouse1",Icon2="lakehouse"}
    GM.Properties["rp_evocity_v4b1"][51].Doors[1513] = true
    GM.Properties["rp_evocity_v4b1"][51].Doors[1512] = true
    GM.Properties["rp_evocity_v4b1"][51].Doors[1511] = true

    GM.Properties["rp_evocity_v4b1"][52] = {Name="Lakeside House 2",Desc="Medium sized house.\nBy the lakeside.",Price=1150, Doors={}, type="house",Icon1="lakehouse2",Icon2="lakehouse"}
    GM.Properties["rp_evocity_v4b1"][52].Doors[1309] = true
    GM.Properties["rp_evocity_v4b1"][52].Doors[1308] = true
    GM.Properties["rp_evocity_v4b1"][52].Doors[1307] = true
    
    GM.Properties["rp_evocity_v4b1"][53] = {Name="Lakeside House 3",Desc="Medium sized house.\nBy the lakeside.",Price=1150, Doors={}, type="house",Icon1="lakehouse3",Icon2="lakehouse"}
    GM.Properties["rp_evocity_v4b1"][53].Doors[1522] = true
    GM.Properties["rp_evocity_v4b1"][53].Doors[1521] = true
    GM.Properties["rp_evocity_v4b1"][53].Doors[1520] = true
    
    GM.Properties["rp_evocity_v4b1"][54] = {Name="Lakeside House 4",Desc="Medium sized house.\nBy the back of the lake.",Price=1300, Doors={}, type="house",Icon1="lakehouse4",Icon2="lakehouse"}
    GM.Properties["rp_evocity_v4b1"][54].Doors[1540] = true
    GM.Properties["rp_evocity_v4b1"][54].Doors[1539] = true
    GM.Properties["rp_evocity_v4b1"][54].Doors[1538] = true
    
    GM.Properties["rp_evocity_v4b1"][55] = {Name="Lakeside House 5",Desc="Medium sized house.\nBy the back of the lake.",Price=1300, Doors={}, type="house",Icon1="lakehouse5",Icon2="lakehouse"}
    GM.Properties["rp_evocity_v4b1"][55].Doors[1531] = true
    GM.Properties["rp_evocity_v4b1"][55].Doors[1530] = true
    GM.Properties["rp_evocity_v4b1"][55].Doors[1529] = true

    GM.Properties["rp_evocity_v4b1"][56] = {Name="Neighborhood House 1",Desc="Small house near the lake.\n3 back rooms and no windows.",Price=1300, Doors={}, type="house",Icon1="hoodhouse1",Icon2="hoodhouse1"}
    GM.Properties["rp_evocity_v4b1"][56].Doors[1287] = true
    GM.Properties["rp_evocity_v4b1"][56].Doors[1288] = true
    GM.Properties["rp_evocity_v4b1"][56].Doors[1289] = true
    GM.Properties["rp_evocity_v4b1"][56].Doors[1290] = true

    GM.Properties["rp_evocity_v4b1"][57] = {Name="Neighborhood House 2",Desc="Small house near the lake.\n3 back rooms and no windows.",Price=1300, Doors={}, type="house",Icon1="hoodhouse2",Icon2="hoodhouse1"}
    GM.Properties["rp_evocity_v4b1"][57].Doors[1297] = true
    GM.Properties["rp_evocity_v4b1"][57].Doors[1298] = true
    GM.Properties["rp_evocity_v4b1"][57].Doors[1299] = true
    GM.Properties["rp_evocity_v4b1"][57].Doors[1300] = true

    GM.Properties["rp_evocity_v4b1"][58] = {Name="Neighborhood House 3",Desc="Medium sized house near the lake.\nKitchen and 2 back rooms.",Price=1350, Doors={}, type="house",Icon1="hoodhouse3",Icon2="lakehouse"}
    GM.Properties["rp_evocity_v4b1"][58].Doors[1466] = true
    GM.Properties["rp_evocity_v4b1"][58].Doors[1465] = true
    GM.Properties["rp_evocity_v4b1"][58].Doors[1464] = true

    GM.Properties["rp_evocity_v4b1"][59] = {Name="Neighborhood House 4",Desc="Medium sized house near the lake.\nKitchen and 2 back rooms.",Price=1350, Doors={}, type="house",Icon1="hoodhouse4",Icon2="lakehouse"}
    GM.Properties["rp_evocity_v4b1"][59].Doors[1475] = true
    GM.Properties["rp_evocity_v4b1"][59].Doors[1474] = true
    GM.Properties["rp_evocity_v4b1"][59].Doors[1473] = true

    GM.Properties["rp_evocity_v4b1"][60] = {Name="City Office 1",Desc="Small office near Nexus.\nHigh up with no windows.",Price=550, Doors={}, type="business",Icon1="cityoffices",Icon2="cityoffice1"}
    GM.Properties["rp_evocity_v4b1"][60].Doors[3661] = true

    GM.Properties["rp_evocity_v4b1"][61] = {Name="City Office 2",Desc="Small office near Nexus.\nHigh up with no windows.",Price=550, Doors={}, type="business",Icon1="cityoffices",Icon2="cityoffice1"} 
    GM.Properties["rp_evocity_v4b1"][61].Doors[3660] = true
    
    GM.Properties["rp_evocity_v4b1"][62] = {Name="City Office 3",Desc="Small office near Nexus.\nHigh up with no windows.",Price=650, Doors={}, type="business",Icon1="cityoffices",Icon2="cityoffice3"}
    GM.Properties["rp_evocity_v4b1"][62].Doors[3673] = true
    
    GM.Properties["rp_evocity_v4b1"][63] = {Name="City Office 4",Desc="Small office near Nexus.\nHigh up with no windows.",Price=650, Doors={}, type="business",Icon1="cityoffices",Icon2="cityoffice3"}
    GM.Properties["rp_evocity_v4b1"][63].Doors[3672] = true
    
    GM.Properties["rp_evocity_v4b1"][64] = {Name="City Office 5",Desc="Small office near Nexus.\nHigh up with cubicles.",Price=650, Doors={}, type="business",Icon1="cityoffices",Icon2="cityoffice5"}
    GM.Properties["rp_evocity_v4b1"][64].Doors[3671] = true

GM.Maps = {}

GM.Maps["rp_evocity_v4b1"] = {}
GM.Maps["rp_evocity_v4b1"].Remove = {}
GM.Maps["rp_evocity_v4b1"].UnOwnable = {}
GM.Maps["rp_evocity_v4b1"].Public = {}
GM.Maps["rp_evocity_v4b1"].ActUnOwnable = {}
GM.Maps["rp_evocity_v4b1"].Police = {}
GM.Maps["rp_evocity_v4b1"].Open = {}
GM.Maps["rp_evocity_v4b1"].Locked = {}
GM.Maps["rp_evocity_v4b1"].Jails = {}
GM.Maps["rp_evocity_v4b1"].SpawnsCitizen = {}
GM.Maps["rp_evocity_v4b1"].SpawnsCar = {}
GM.Maps["rp_evocity_v4b1"].AddObjs = {}

    GM.Maps["rp_evocity_v4b1"].Public[3602] = true
    GM.Maps["rp_evocity_v4b1"].Public[3603] = true
    GM.Maps["rp_evocity_v4b1"].Public[3605] = true
    GM.Maps["rp_evocity_v4b1"].Public[3604] = true
    GM.Maps["rp_evocity_v4b1"].Public[3607] = true
    GM.Maps["rp_evocity_v4b1"].Public[3606] = true
    GM.Maps["rp_evocity_v4b1"].Public[2256] = true
    GM.Maps["rp_evocity_v4b1"].Public[2257] = true
    GM.Maps["rp_evocity_v4b1"].Public[2181] = true
    GM.Maps["rp_evocity_v4b1"].Public[2255] = true
    GM.Maps["rp_evocity_v4b1"].Public[2207] = true
    GM.Maps["rp_evocity_v4b1"].Public[2208] = true
    GM.Maps["rp_evocity_v4b1"].Public[2234] = true
    GM.Maps["rp_evocity_v4b1"].Public[2233] = true
    GM.Maps["rp_evocity_v4b1"].Public[2236] = true
    GM.Maps["rp_evocity_v4b1"].Public[2235] = true
    GM.Maps["rp_evocity_v4b1"].Public[2318] = true
    GM.Maps["rp_evocity_v4b1"].Public[2319] = true
    GM.Maps["rp_evocity_v4b1"].Public[2314] = true
    GM.Maps["rp_evocity_v4b1"].Public[2313] = true
    GM.Maps["rp_evocity_v4b1"].Public[1939] = true
    GM.Maps["rp_evocity_v4b1"].Public[1938] = true
    GM.Maps["rp_evocity_v4b1"].Public[1941] = true
    GM.Maps["rp_evocity_v4b1"].Public[1940] = true
    GM.Maps["rp_evocity_v4b1"].Public[1341] = true
    GM.Maps["rp_evocity_v4b1"].Public[2100] = true
    GM.Maps["rp_evocity_v4b1"].Public[2099] = true
    GM.Maps["rp_evocity_v4b1"].Public[2102] = true
    GM.Maps["rp_evocity_v4b1"].Public[2101] = true
    GM.Maps["rp_evocity_v4b1"].Public[2103] = true
    GM.Maps["rp_evocity_v4b1"].Public[2868] = true
    GM.Maps["rp_evocity_v4b1"].Public[2867] = true
    GM.Maps["rp_evocity_v4b1"].Public[3472] = true
    GM.Maps["rp_evocity_v4b1"].Public[3471] = true
    GM.Maps["rp_evocity_v4b1"].Public[3475] = true
    GM.Maps["rp_evocity_v4b1"].Public[3476] = true
    GM.Maps["rp_evocity_v4b1"].Public[2464] = true
    GM.Maps["rp_evocity_v4b1"].Public[2463] = true
    GM.Maps["rp_evocity_v4b1"].Public[2939] = true
    GM.Maps["rp_evocity_v4b1"].Public[2938] = true
    GM.Maps["rp_evocity_v4b1"].Public[3028] = true
    GM.Maps["rp_evocity_v4b1"].Public[3029] = true
    GM.Maps["rp_evocity_v4b1"].Public[2942] = true
    GM.Maps["rp_evocity_v4b1"].Public[2943] = true
    GM.Maps["rp_evocity_v4b1"].Public[3031] = true
    GM.Maps["rp_evocity_v4b1"].Public[3030] = true
    GM.Maps["rp_evocity_v4b1"].Public[3027] = true
    GM.Maps["rp_evocity_v4b1"].Public[3033] = true
    GM.Maps["rp_evocity_v4b1"].Public[3032] = true
    GM.Maps["rp_evocity_v4b1"].Public[3034] = true
    GM.Maps["rp_evocity_v4b1"].Public[3035] = true
    GM.Maps["rp_evocity_v4b1"].Public[2940] = true
    GM.Maps["rp_evocity_v4b1"].Public[2941] = true
    
    GM.Maps["rp_evocity_v4b1"].UnOwnable[2714] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[2713] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[2715] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[2716] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[2721] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[2195] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[2196] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[2247] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[2248] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[1344] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[1345] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[1346] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[2110] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[2111] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[1347] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[1348] = true
    GM.Maps["rp_evocity_v4b1"].UnOwnable[2326] = true
    
    GM.Maps["rp_evocity_v4b1"].ActUnOwnable[3195] = true -- Motel lobby
    GM.Maps["rp_evocity_v4b1"].ActUnOwnable[1377] = true -- Church
    GM.Maps["rp_evocity_v4b1"].ActUnOwnable[1376] = true -- Church
    
    GM.Maps["rp_evocity_v4b1"].Police[2191] = true
    GM.Maps["rp_evocity_v4b1"].Police[2218] = true
    GM.Maps["rp_evocity_v4b1"].Police[2273] = true
    GM.Maps["rp_evocity_v4b1"].Police[1829] = true
    GM.Maps["rp_evocity_v4b1"].Police[1828] = true
    GM.Maps["rp_evocity_v4b1"].Police[1833] = true
    GM.Maps["rp_evocity_v4b1"].Police[1831] = true
    GM.Maps["rp_evocity_v4b1"].Police[1832] = true
    GM.Maps["rp_evocity_v4b1"].Police[1862] = true
    GM.Maps["rp_evocity_v4b1"].Police[1891] = true
    GM.Maps["rp_evocity_v4b1"].Police[1839] = true
    GM.Maps["rp_evocity_v4b1"].Police[1836] = true
    GM.Maps["rp_evocity_v4b1"].Police[1837] = true
    GM.Maps["rp_evocity_v4b1"].Police[1844] = true
    GM.Maps["rp_evocity_v4b1"].Police[1846] = true
    GM.Maps["rp_evocity_v4b1"].Police[1847] = true
    GM.Maps["rp_evocity_v4b1"].Police[1849] = true
    GM.Maps["rp_evocity_v4b1"].Police[1835] = true

    GM.Maps["rp_evocity_v4b1"].Open[2103] = true
    GM.Maps["rp_evocity_v4b1"].Open[2101] = true
    GM.Maps["rp_evocity_v4b1"].Open[2102] = true
    GM.Maps["rp_evocity_v4b1"].Open[3472] = true
    GM.Maps["rp_evocity_v4b1"].Open[3471] = true
    
    GM.Maps["rp_evocity_v4b1"].Locked[2248] = true
    GM.Maps["rp_evocity_v4b1"].Locked[2247] = true
    for k,v in pairs(GM.Maps["rp_evocity_v4b1"].Police) do
        GM.Maps["rp_evocity_v4b1"].Locked[k] = true
    end
    --setpos -4859.861816 -4484.997070 264.031250;setang 0.685909 -91.829506 0.000000
    GM.Maps["rp_evocity_v4b1"].Function = function()
        AddNPC(Vector(-7405,-6605,76), Angle(0, 90, 0), "OCRP_ShopMenu", "npc_gman","BP gas",{8})
        AddNPC(Vector(10416,13248,76), Angle(0, 90, 0), "OCRP_ShopMenu", "npc_gman", "BP gas", {8})
        AddNPC(Vector(-3547,-5700,198), Angle(0, 180, 0), "OCRP_ShopMenu", "npc_barney","Materials",{5,6,7}, {Min=300, Max=900})
        AddNPC(Vector(-10779,-10374,72), Angle(0, -135, 0), "OCRP_ShopMenu", "npc_eli","Materials",{2,3,4,31,32,33}, {Min=300, Max=900})
        AddNPC(Vector(-3787,-7016,198), Angle(0, 180, 0), "OCRP_NPCTalk", "npc_mossman","Medic",{"Job_Medic001"})
        AddNPC(Vector(-7203, -9243, 72), Angle(0, 90, 0), "OCRP_NPCTalk", "npc_metropolice","Cop",{"Job_Cop001"})
        AddNPC(Vector(-5327,-9224,72), Angle(0, 180, 0), "OCRP_NPCTalk", "npc_kleiner","Mayor",{"Job_Mayor001"})	
        AddNPC(Vector(5069,-3539,228), Angle(0, -90, 0), "SV_CarDealer", "npc_eli","CarDealer",{})	
        AddNPC(Vector(-7585,-7821,72), Angle(0, 0, 0), "OCRP_RelatorMenu", "npc_alyx","Relator",{})
        AddNPC(Vector(-5333,-10245,86), Angle(0, 145, 0), "SV_Garage", "npc_eli", "Garage", {})
        AddNPC(Vector(-7679,-8990,72), Angle(0, 0, 0), "OCRP_NPCTalk","npc_metropolice" ,"Cop",{"Job_CopCar01"})
        AddNPC(Vector(-3456, -7623, 198), Angle(0, -136, 0), "OCRP_NPCTalk","npc_mossman", "Ambo",{"Job_Ambulance01"})					
        AddNPC(Vector(-7585,-7658,72), Angle(0, 0, 0), "OCRP_NPCTalk", "npc_alyx","Org",{"Org"})
        AddNPC(Vector(-3483, -8534, 198),Angle(0,135,0), "OCRP_NPCTalk", "npc_alyx","Respray",{"Skin_001"})
        AddNPC(Vector(-3836, -8532, 198),Angle(0,45,0), "OCRP_NPCTalk", "npc_alyx", "UG_Nitrous",{"Skin_002"})
        --AddNPC(Vector(-7662,-4443,72), Angle(0, 180, 0), "OCRP_ShopMenu", "npc_gman","Buying",{9})
        AddNPC(Vector(-4859,-4484,200), Angle(0, -90, 0), "OCRP_Model", "npc_gman", "KFC", {})
        AddNPC(Vector(-7683,-9061,75), Angle(0, 0, 0), "OCRP_NPCTalk", "npc_eli","Fireman",{"Job_FireEngine01"})
        AddNPC(Vector(-7292, -9248, 72),  Angle(0,90,0), "OCRP_NPCTalk", "npc_eli","Fireman",{"Job_Fire001"})		
        AddNPC(Vector(2852, 6480, 68), Angle(0, 45, 0), "OCRP_ShopMenu", "npc_gman","Cheepies",{28})
        AddNPC(Vector(-6807, -8685, 72), Angle(0, -135, 0), "OCRP_NPCTalk", "npc_monk","Tow", {"Job_Tow001"})
        AddNPC(Vector(-7666, -8905, 136), Angle(0,-45,0), "OCRP_NPCTalk", "npc_eli","Taxi", {"Job_TaxiCar001"})
        AddNPC(Vector(-7679, -9150, 72), Angle(0, 0, 0), "OCRP_NPCTalk", "npc_monk","Tow", {"Job_TowTruck01"})
        AddNPC(Vector(-7204, -8683, 136), Angle(0, -45, 0), "OCRP_NPCTalk", "npc_eli","Taxi", {"Job_Taxi001"})
        AddNPC(Vector(4049, -3448, 64), Angle(0, -45, 0), "OCRP_NPCTalk", "npc_monk", "Repair", {"Repair"})
        AddNPC(Vector(-4767,-4475,200), Angle(0, -90, 0), "OCRP_ShopMenu", "npc_barney","Furniture",{29})
        AddNPC(Vector(-5327,-9351,72), Angle(0,180, 0), "OCRP_ShopMenu", "npc_kleiner","Librarian",{11,12,13,14,15,16,17,18,19,20,21,22,23,24,25},{Min = 120,Max = 300})					
        AddNPC(Vector(-3655, -8519, 198), Angle(0, 90, 0), "OCRP_NPCTalk", "npc_alyx","Headlights", {"Skin_003"})
        AddNPC(Vector(-10381, 9547, 100), Angle(0, -90, 0), "OCRP_NPCTalk", "npc_mossman","Heal", {"Heal"}) -- This bitch was bein all fucky, 100 is way too low but otherwise she's on the roof?!

    end
    
    GM.Maps["rp_evocity_v4b1"].Jails = {
        
        {Position = Vector(-6925.6293945313,-9629.4482421875,-401.97326660156), Ang = Angle(0,176.00149536133,0)},
        {Position = Vector(-7219.8896484375,-9514.357421875,-406.89608764648), Ang = Angle(0,172.17324829102,0)},
        {Position = Vector(-7218.5922851563,-9386.880859375,-408.76699829102), Ang = Angle(0,179.60371398926,0)},
        {Position = Vector(-7214.7612304688,-9274.4580078125,-409.47213745117), Ang = Angle(0,177.63339233398,0)},
        {Position = Vector(-7216.71875,-9148.072265625,-401.05822753906), Ang = Angle(0,179.15913391113,0)},
        {Position = Vector(-7220.4833984375,-9012.4541015625,-411.62066650391), Ang = Angle(0,167.65403747559,0)},
        
    }
    
    GM.Maps["rp_evocity_v4b1"].SpawnsCitizen = {
    
        {Position = Vector(-8193, -11735, 72), Ang = Angle(0, -86, 0)},
        {Position = Vector(-8136, -11735, 72), Ang = Angle(0, -90, 0)},
        {Position = Vector(-8048, -11736, 72), Ang = Angle(0, -90, 0)},
        {Position = Vector(-7957, -11736, 72), Ang = Angle(0, -90, 0)},
        {Position = Vector(-7868, -11736, 72), Ang = Angle(0, -90, 0)},
        {Position = Vector(-7784, -11736, 72), Ang = Angle(0, -90, 0)},
        {Position = Vector(-7700, -11736, 72), Ang = Angle(0, -90, 0)},
        {Position = Vector(-7609, -11737, 72), Ang = Angle(0, -90, 0)},
        {Position = Vector(-7518, -11737, 72), Ang = Angle(0, -90, 0)},
        {Position = Vector(-7437, -11737, 72), Ang = Angle(0, -90, 0)},
        {Position = Vector(-7347, -11737, 72), Ang = Angle(0, -90, 0)},
        {Position = Vector(-7268, -11737, 72), Ang = Angle(0, -90, 0)},
        {Position = Vector(-7199, -11737, 72), Ang = Angle(0, -90, 0)},
        {Position = Vector(-7126, -11739, 72), Ang = Angle(0, -92, 0)},
        {Position = Vector(-7068, -11741, 72), Ang = Angle(0, -92, 0)},
        {Position = Vector(-6998, -11744, 72), Ang = Angle(0, -92, 0)},
        {Position = Vector(-6931, -11746, 72), Ang = Angle(0, -92, 0)},
        {Position = Vector(-6878, -11748, 72), Ang = Angle(0, -92, 0)},
        {Position = Vector(-6850, -11741, 72), Ang = Angle(0, -92, 0)},
        {Position = Vector(-6802, -11725, 72), Ang = Angle(0, -92, 0)},
        {Position = Vector(-6739, -11725, 72), Ang = Angle(0, -92, 0)},
        {Position = Vector(-6670, -11728, 72), Ang = Angle(0, -92, 0)},
        {Position = Vector(-6616, -11730, 72), Ang = Angle(0, -92, 0)}, 
        
	}
    
	GM.Maps["rp_evocity_v4b1"].SpawnsCar = {
    
        {Position = Vector(-3843, -10297, 71), Ang = Angle(0, -90, 0)},
        {Position = Vector(-4030, -10300, 71), Ang = Angle(0, -89, 0)},
        {Position = Vector(-4275, -10305, 71), Ang = Angle(0, -89, 0)},
        {Position = Vector(-4457, -10309, 71), Ang = Angle(0, -89, 0)},
        {Position = Vector(-4656, -10313, 71), Ang = Angle(0, -89, 0)},
        {Position = Vector(-4868, -10317, 71), Ang = Angle(0, -89, 0)},
        {Position = Vector(-5086, -10321, 71), Ang = Angle(0, -89, 0)},
        {Position = Vector(4557, -5874, 56), Ang = Angle(0, -20, 0)},
        {Position = Vector(4879, -5869, 56), Ang = Angle(0, -20, 0)},
        {Position = Vector(5227, -5864, 56), Ang = Angle(0, -20, 0)},
        {Position = Vector(5541, -5908, 56), Ang = Angle(0, -20, 0)}, 
        
    }
    
    GM.Maps["rp_evocity_v4b1"].AddObjs = {
    
        {	Class = "bank_atm",
			Pos = Vector(-7072.244141, -7893.078613, 72.329773),
			Angles = Angle(0,0,0),
			Skin = 1,
			Activate = false,
			Hide = true, -- Model is already in the map, this one's at the bank
		},
		{	Class = "bank_atm",
			Pos = Vector(-4830.996582, -4840.573730, 200.329681),
			Angles = Angle(0,90,0),
			Skin = 1,
			Activate = false,
			Hide = true, -- Model already in map, at tides
		},
		{	Class = "bank_atm",
			Pos = Vector(-7025, -11701, 71),
			Angles = Angle(0,-90,0),
			Skin = 1,
			Activate = false,
			Hide = false, -- We totally add this, near spawn, across from Izzie's
		},
		{	Class = "bank_atm",
			Pos = Vector(4617, -3542, 228),
			Angles = Angle(0,0,0),
			Skin = 1,
			Activate = false,
			Hide = false, -- Another completely lua-added one, at the dealership
		},
		{	Class = "bank_atm",
			Pos = Vector(10504, 13529, 66),
			Angles = Angle(0,180,0),
			Skin = 1,
			Activate = false,
			Hide = false, -- Another completely lua-added one, at the BP out of town
		},
		{	Class = "bank_atm",
			Pos = Vector(-7339, -4492, 72),
			Angles = Angle(0,-90,0),
			Skin = 1,
			Activate = false,
			Hide = true, -- BK
		},
		{	Class = "bank_atm",
			Pos = Vector(-7371, -6163, 72),
			Angles = Angle(0,-180,0),
			Skin = 1,
			Activate = false,
			Hide = true, -- BP in town
		},
		{	Class = "bank_atm",
			Pos = Vector(-6918, -9668, 72),
			Angles = Angle(0,90,0),
			Skin = 1,
			Activate = false,
			Hide = true, -- Nexus
		},
		{	Class = "gov_resupply",
			Pos = Vector(-6780, -9135, 72),
			Angles = Angle(0, -180, 0),
			Activate = false,
		},
		{	Class = "money_spawn",
			Pos = Vector(-6436.1708984375,-9613.8857421875,3828.5251464844),
			Angles = Angle(0,90,0),
			Activate = true,
		},
		{	Class = "money_spawn",
			Pos = Vector(-6437.9213867188,-9501.400390625,3828.5251464844),
			Angles = Angle(0,90,0),
			Activate = true,
		},
		{	Class = "money_spawn",
			Pos = Vector(-6440.4887695313,-9336.421875,3828.5251464844),
			Angles = Angle(0,90,0),
			Activate = true,
		},
		{	Class = "money_spawn",
			Pos = Vector(-6442.3559570313,-9216.4375,3828.5251464844),
			Angles = Angle(0,90,0),
			Activate = true,
		},
        {   Class = "item_bank",
            Pos = Vector(-7264, -7939, 107),
            Angles = Angle(0, 90, 0),
            Activate = false,
        },
        {   Class = "item_bank",
            Pos = Vector(-7312, -7939, 107),
            Angles = Angle(0, 90, 0),
            Activate = false,
        },
        {   Class = "item_bank",
            Pos = Vector(-7360, -7939, 107),
            Angles = Angle(0, 90, 0),
            Activate = false,
        },
        
    }

META = FindMetaTable( "Entity" )

function META:IsDoor()

	local class = self:GetClass();
	
	if( class == "func_door" or
		class == "func_door_rotating" or
		class == "prop_door_rotating" or
		class == "prop_vehicle_jeep") then
		
		return true;
		
	end
	
	return false;

end
 
 function GM.IsRaining ( )
	return GAMEMODE.IsStorming() or GetGlobalInt('ocrp_weather', WEATHER_NORMAL) == WEATHER_RAINY;
end

function GM.IsStorming ( )
	return GetGlobalInt('ocrp_weather', WEATHER_NORMAL) == WEATHER_STORMY or GetGlobalInt('ocrp_weather', WEATHER_NORMAL) == WEATHER_STORMY_HEAVY;
end

function GM:ScaleNPCDamage(npc, htigroup, info)
	if npc:GetClass() == "npc_barnacle" then
		timer.Simple(2, function()
			if npc:Health() <= 0 then
				timer.Simple(30, function()
					if npc:IsValid() then
						npc:Remove()
					end
				end)
			end
		end)
		return
	end
    info:ScaleDamage(0)
end


function physgunPickup( ply, ent )
	if SERVER then
	if ent:IsPlayer() then
		if ply:GetLevel() <= 2 then
			if ent:IsBetterOrSame(ply) then
				return false
			end
			ent:SetMoveType(MOVETYPE_FLY)
			ent.Physgunned = true
            ent.StopFallDamage = true
            ply.PhysgunTarget = ent
            return true
		end
    elseif ent:GetClass() == "prop_vehicle_jeep" then --or (ent:GetClass() == "prop_dynamic" and GetGlobalBool("dev_testing")) then
        if ply:GetLevel() <= 2 then
			ent:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			return true
        end
        return false
	elseif ent:IsDoor() then
		return false
    elseif ent:GetClass() == "prop_physics_multiplayer" then
        return false
    elseif ent:GetClass() == "gas_pump" then
        return false
	elseif ent:GetClass() == "prop_ocrp" then
		return false
	elseif ent:GetClass() == "func_rotating" then
		return false
	elseif ent:GetClass() == "func_brush" then
		return false
    elseif ent:GetClass() == "drug_shroom" then
        return false
    elseif ent:GetClass() == "item_bank" then
        return false
	elseif ent:GetClass() == "gov_resupply" then
		return false
	elseif ent:GetClass() == "vendingmachines" then
        if ply:GetLevel() <= 2 or ply:Team() == CLASS_Mayor then
            return true
        end
		return false
	elseif ent:GetClass() == "item_base" or ent:GetClass() == "ocrp_radio" then	
		if ent:GetNWInt("Class") == "item_ladder" then
			return false
		elseif ent:GetNWInt("Class") == "item_pot" then
			return false
		end
		if ply:EntIndex() != ent:GetNWInt("Owner") then
            if ply:GetLevel() <= 2 then
                return true
            end
			return false
		end
	elseif ent:GetClass() == "prop_ragdoll" then 
        if ply:GetLevel() <= 2 then
            return true
        end
		return false
	elseif ent:GetClass() == "func_button" then
		return false
	elseif ent:GetClass() == "func_movelinear" then
		return false
	elseif ent:GetClass() == "gov_resupply" then
		return false
	elseif ent:GetClass() == "prop_dynamic" then
		return false
	elseif ent:GetClass() == "func_tracktrain" then 
		return false
	elseif ent:GetClass() == "func_breakable_surf" then
		return false
	elseif ent:GetClass() == "func_rotating" then
		return false
	elseif ent:GetClass() == "func_breakable" then
		return false
	elseif ent:GetClass() == "bank_atm"  then
		if ply:Team() == CLASS_Mayor && ent.OwnerType == "Mayor" then
			return true
		else
			return false
		end
	elseif ent.OwnerType == "Mayor" then
		if ply:Team() == CLASS_Mayor || ply:Team() == CLASS_CHIEF then
			return true
		else
			return false
		end
	elseif ent.OwnerType == "Chief" then
		if ply:Team() == CLASS_Mayor || ply:Team() == CLASS_CHIEF || ply:Team() == CLASS_POLICE || ply:Team() == CLASS_SWAT then
			return true
		else
			return false
		end
	elseif ent:IsNPC() then
		return false 
	end
	end
end

function PhysgunDrop(ply, ent)
    if ent:IsValid() and ent:IsPlayer() then
        ent.StopFallDamage = true
		ent.Physgunned = false
		ent:SetMoveType(MOVETYPE_WALK)
        timer.Simple(1.5, function()
            ent.StopFallDamage = false
        end)
        ply.PhysgunTarget = nil
    elseif ent:IsValid() and ent:GetClass() == "prop_vehicle_jeep" then
		ent:SetCollisionGroup(COLLISION_GROUP_VEHICLE)
	elseif ent:IsValid() and ent:GetClass() == "prop_dynamic" then
		ent:SetCollisionGroup(COLLISION_GROUP_NONE)
	end
end

function fallDamage(ply, speed)
    if ply:IsValid() and ply.StopFallDamage then
        return 0
    end
end

hook.Add("GetFallDamage", "OCRPPhysgunDmgFix", fallDamage)

hook.Add("PhysgunDrop", "physgunDropOCRP", PhysgunDrop)
 
hook.Add( "PhysgunPickup", "physgunPickupOCRP", physgunPickup );

function PMETA:GetOrg()
	if self.Org == nil then
		return 0
	else
		return self.Org
	end
end

function PMETA:OCRP_GetCar()
	for k, v in pairs(ents.FindByClass( "prop_vehicle_jeep" )) do
		if v:GetNWInt( "Owner" ) == self:EntIndex() then
			return v
		end
	end
end

function PMETA:GetUsableIcons()
	local icons = {}
	table.insert(icons, "exclamation-red") -- Police report
	table.insert(icons, "fire-big") -- Fire report
	table.insert(icons, "bandaid") -- Ambulance report
    table.insert(icons, "traffic-cone")
	if self:Team() == CLASS_Mayor or self:Team() == CLASS_CHIEF then
		table.insert(icons, "exclamation-circle")
	end
	if self:GetVehicle() and self:GetVehicle():IsValid() and self:GetVehicle():GetParent() and self:GetVehicle():GetParent():IsValid()
	and self:GetVehicle():GetParent():GetModel() == "models/tdmcars/crownvic_taxi.mdl" and self:GetVehicle():GetParent():GetNWInt("Client") == self:EntIndex() then
		table.insert(icons, "flag-checker")
	end
	if self:GetLevel() <= 4 then
		table.insert(icons, "store")
	end
	if self:GetOrg() ~= 0 then
		table.insert(icons, "star")
		table.insert(icons, "target")
	end
	return icons
end

function META:GetCarType()
	for _, data in pairs(GAMEMODE.OCRP_Cars) do
		if type(data.Model) == "table" then
			for a, d in pairs(data.Model) do
				if self:GetModel() == d then
					return _
				end
			end
		else
			if self:GetModel() == data.Model then
				return _
			end
		end
	end
	return "NULL"
end

function PMETA:InGang()
	if self:InOrg() then
		if GAMEMODE.Orgs[self:GetOrg()].Type == "Gang" then
			return true
		else
			return false
		end
	end
	return false
end

function PMETA:InBusiness()
	if self:InOrg() then
		if GAMEMODE.Orgs[self:GetOrg()].Type == "Business" then
			return true
		else
			return false
		end
	end
	return false
end

function PMETA:GetSex()
	if string.find( string.lower( self:GetModel() ), "female" ) then
		return "Female"
	elseif string.find( string.lower( self:GetModel() ), "male" ) then
		return "Male"
	end
end

function ModelPrinter( ply, ent )
    if not ply:IsValid() then return end
	if SERVER then
		ply.CantUse = true
		timer.Simple(0.9,function() 
        if not ply:IsValid() then return end
        ply.CantUse = false end)
	end
end
hook.Add("PhysgunDrop", "ModelPrinter", ModelPrinter)

function gravgunPunt( userid, target )
	return false
end
 
hook.Add( "GravGunPunt", "gravgunPunt", gravgunPunt )


function GetVectorTraceUp ( vec )
	local trace = {};
	trace.start = vec;
	trace.endpos = vec + Vector(0, 0, 999999999);
	trace.mask = MASK_SOLID_BRUSHONLY;
	
	return util.TraceLine(trace);
end

function PMETA:GetUpTrace ( )
	local ourEnt = self;
	if (self:InVehicle()) then
		ourEnt = self:GetVehicle();
	end
	
	return GetVectorTraceUp(ourEnt:GetPos());
end

function PMETA:IsOutside ( ) return self:GetUpTrace().HitSky; end
function PMETA:IsInside ( ) return !self:IsOutside(); end

-- TIME_PER_DAY 	= 60 * 60 * 3.5; // 3.5 hours is one cycle.
-- DAY_LENGTH		= 1440;

-- DAY_START		= 5 * 60; // 5 am
-- DAY_END		= 18.5 * 60; // 6:30 pm
-- DAWN			= DAY_LENGTH / 4;
-- DAWN_START	= DAWN - 144;
-- DAWN_END		= DAWN + 144;
-- NOON			= DAY_LENGTH / 2;
-- DUSK			= DAY_LENGTH - DAWN;
-- DUSK_START	= DUSK - 144;
-- DUSK_END		= DUSK + 144;

-- local nextTick = CurTime();
-- local timePerMinute = TIME_PER_DAY / DAY_LENGTH * .5;
-- MONTH_DAYS = {31, 28, 30, 31, 30, 31, 30, 31, 30, 31, 30, 31};
-- CLOUD_NAMES = {"Clear Skies", "Partly Cloudy", "Mostly Cloudy [ PRE ]", "Mostly Clouy [ POST ]", "Stormy", "Stormy [ LIGHT ]", "Stormy [ PRE ]", "Stormy [ SEVERE ]", "Heat Wave"};
							 

-- local function manageTime ( )
	-- if (!GAMEMODE.CurrentTime || (SERVER && !GAMEMODE.timeEntities.shadow_control) || nextTick > CurTime()) then return; end
	-- nextTick = nextTick + timePerMinute;
	
	-- GAMEMODE.CurrentTime = GAMEMODE.CurrentTime + .5;
	-- if (GAMEMODE.CurrentTime > DAY_LENGTH) then
		-- GAMEMODE.CurrentTime = .5;
		
		-- GAMEMODE.CurrentDay = GAMEMODE.CurrentDay + 1;
		
		-- if (GAMEMODE.CurrentDay > MONTH_DAYS[GAMEMODE.CurrentMonth]) then
			-- GAMEMODE.CurrentDay = 1;
			-- GAMEMODE.CurrentMonth = GAMEMODE.CurrentMonth + 1;
			
			-- if (GAMEMODE.CurrentMonth > 12) then
				-- GAMEMODE.CurrentMonth = 1;
				-- GAMEMODE.CurrentYear = GAMEMODE.CurrentYear + 1;
				-- // Happy near years
			-- end
		-- end
		
		-- if SERVER then GAMEMODE.SaveDate(); end
	-- end
		
	-- if SERVER then GAMEMODE.progressTime(); end
-- end
-- hook.Add("Think", "manageTime", manageTime);

-- function GM.GetTime ( )
	-- local perHour = DAY_LENGTH / 24;
	-- local perMinute = DAY_LENGTH / 1440;
	
	-- local hours = math.floor(GAMEMODE.CurrentTime / perHour);
	-- local mins = math.floor(GAMEMODE.CurrentTime / perMinute) - hours * 60;
	
	-- return hours, mins;
-- end

function PMETA:CanSee ( Entity, Strict )
	if Strict then
		if !self:HasLOS(Entity) then return false; end
	end

	local fov = self:GetFOV()
	local Disp = Entity:GetPos() - self:GetPos()
	local Dist = Disp:Length()
	local EntWidth = Entity:BoundingRadius() * 0.5;
	
	local MaxCos = math.abs( math.cos( math.acos( Dist / math.sqrt( Dist * Dist + EntWidth * EntWidth ) ) + fov * ( math.pi / 180 ) ) )
	Disp:Normalize()

	if Disp:Dot( self:EyeAngles():Forward() ) > MaxCos and Entity:GetPos():Distance(self:GetPos()) < 5000 then
		return true
	end
	
	return false
end

local chatTypes = {}
chatTypes["//"] = "OOC"
chatTypes["/ooc"] = "OOC"
chatTypes["///"] = "LOOC"
chatTypes["/looc"] = "LOOC"
chatTypes["/taxi"] = "Emote"
chatTypes["/me"] = "Emote"
chatTypes["/help"] = "Emote"
chatTypes["/advert"] = "Advert"
chatTypes["/ad"] = "Advert"
chatTypes["/pm"] = "PM"
chatTypes["/org"] = "Org"
chatTypes["/911"] = "911"
chatTypes["/radio"] = "Gov Radio"
chatTypes["/y"] = "Yell"
chatTypes["/yell"] = "Yell"
chatTypes["/w"] = "Whisper"
chatTypes["/whisper"] = "Whisper"
chatTypes["/broadcast"] = "Broadcast"
chatTypes["/a"] = "To Admins"
chatTypes["/admin"] = "To Admins"

function GetChatType(s)

	local words = string.Explode(" ", s)
	local word1 = string.lower(words[1])
	
	local type = chatTypes[word1] or false
	
	local msg = nil
	
	if type == false then
		local char1 = string.ToTable(s)[1]
		if char1 == "/" then
			type = "Command"
			msg = s
		else
			type = "Local"
			msg = s
		end
	end
    local pmtarget = nil
    if word1 == "/pm" then
        local target = ULib.getUser(words[2], false)
        if target and target:IsValid() then
            words[2] = "(To " .. target:Nick() .. ")"
            pmtarget = target
        end
    end
	
	if not msg then
		msg = ""
		for k,v in pairs(words) do
			if k == 1 then continue end
			msg = msg .. v .. " "
		end
		msg = string.TrimRight(msg)
	end
	
	if word1 == "/taxi" then msg = "calls for a taxi." end
	if word1 == "/help" then msg = "yells for help!" end
    if word1 == "/pm" then
        return type,msg,pmtarget -- return a PM target too
    end
	
	return type,msg

end

taxi_nodes = {} -- THESE ARE FOR v4b1
taxi_nodes[1] = {Pos = Vector(-6011.3715820313, -12202.829101563, 64.03125), Neighbors = {2,8}}
taxi_nodes[2] = {Pos = Vector(-6005.0161132813, -10108.526367188, 64.03125), Neighbors = {1,3}}
taxi_nodes[3] = {Pos = Vector(-6001.1967773438, -8289.603515625, 64.03125), Neighbors = {4,13,9}}
taxi_nodes[4] = {Pos = Vector(-8166.478515625, -8284.671875, 64.03125), Neighbors = {3,5,14}}
taxi_nodes[5] = {Pos = Vector(-9907.3818359375, -8309.4130859375, 64.03125), Neighbors = {4,6}}
taxi_nodes[6] = {Pos = Vector(-9899.5546875, -10150.01953125, 64.03125), Neighbors = {5,7}}
taxi_nodes[7] = {Pos = Vector(-9896.6689453125, -12194.791992188, 64.03125), Neighbors = {6,8}}
taxi_nodes[8] = {Pos = Vector(-7662.9262695313, -12197.869140625, 64.03125), Neighbors = {1,7}}
taxi_nodes[9] = {Pos = Vector(-4316.693359375, -8293.740234375, 190.03125), Neighbors = {3, 10}}
taxi_nodes[10] = {Pos = Vector(-4321.3583984375, -6749.01953125, 190.03125), Neighbors = {9, 11}}
taxi_nodes[11] = {Pos = Vector(-4321.5571289063, -5451.1103515625, 190.03125), Neighbors = {10,12}}
taxi_nodes[12] = {Pos = Vector(-6010.93359375, -5445.9038085938, 64.03125), Neighbors = {11,13,14,15}}
taxi_nodes[13] = {Pos = Vector(-6005.0146484375, -6749.2587890625, 64.03125), Neighbors = {12, 3}}
taxi_nodes[14] = {Pos = Vector(-8161.9379882813, -5447.876953125, 64.03125), Neighbors = {4, 12}}
taxi_nodes[15] = {Pos = Vector(-5858.931640625, -936.30114746094, 64.03125), Neighbors = {12, 16}}
taxi_nodes[16] = {Pos = Vector(-4972.1284179688, -635.32690429688, 64.03125), Neighbors = {15, 53, 17}}
taxi_nodes[17] = {Pos = Vector(-5115.8090820313, 8638.0712890625, 64.03125), Neighbors = {16, 18}}
taxi_nodes[18] = {Pos = Vector(-7686.314453125, 8969.37890625, 64.03125), Neighbors = {17, 19}}
taxi_nodes[19] = {Pos = Vector(-7679.1459960938, 10655.2109375, 186.31237792969), Neighbors = {18, 20, 66}}
taxi_nodes[20] = {Pos = Vector(-5340.8359375, 12972.96484375, 186.31231689453), Neighbors = {19, 21, 68}}
taxi_nodes[21] = {Pos = Vector(-4991.837890625, 14708.62109375, 186.03125), Neighbors = {20, 22}}
taxi_nodes[22] = {Pos = Vector(-1893.0665283203, 14493.075195313, 58.312408447266), Neighbors = {21, 23}}
taxi_nodes[23] = {Pos = Vector(-1625.8609619141, 12886.44921875, 58.312530517578), Neighbors = {22, 24}}
taxi_nodes[24] = {Pos = Vector(151.90325927734, 12191.100585938, 58.3125), Neighbors = {23, 25}}
taxi_nodes[25] = {Pos = Vector(415.13079833984, 10230.66796875, 58.3125), Neighbors = {24, 26}}
taxi_nodes[26] = {Pos = Vector(3422.7136230469, 9889.1328125, 58.03125), Neighbors = {25, 27, 28}}
taxi_nodes[27] = {Pos = Vector(3411.4733886719, 12592.09765625, 50.03125), Neighbors = {26}}
taxi_nodes[28] = {Pos = Vector(6716.2998046875, 10121.7734375, 58.31233215332), Neighbors = {26, 29}}
taxi_nodes[29] = {Pos = Vector(8336.7607421875, 12295.151367188, 58.3125), Neighbors = {28, 30}}
taxi_nodes[30] = {Pos = Vector(11307.6171875, 12530.505859375, 58.03125), Neighbors = {29, 69}}
taxi_nodes[31] = {Pos = Vector(12065.150390625, 9448.8544921875, 64.3125), Neighbors = {69, 32}}
taxi_nodes[32] = {Pos = Vector(12062.377929688, 6631.7724609375, 64.03125), Neighbors = {31, 33}}
taxi_nodes[33] = {Pos = Vector(12042.232421875, 2806.6828613281, 64.3125), Neighbors = {32, 34}}
taxi_nodes[34] = {Pos = Vector(11392.999023438, 1568.9609375, 64.03125), Neighbors = {33, 35}}
taxi_nodes[35] = {Pos = Vector(9776.1044921875, 1164.9453125, 64.03125), Neighbors = {34, 36, 38}}
taxi_nodes[36] = {Pos = Vector(9125.6318359375, 1886.0301513672, 68.034072875977), Neighbors = {35, 37}}
taxi_nodes[37] = {Pos = Vector(8878.1708984375, 3517.7072753906, 0.31250381469727), Neighbors = {36}}
taxi_nodes[38] = {Pos = Vector(7948.6616210938, 229.48156738281, 64.03125), Neighbors = {35, 39}}
taxi_nodes[39] = {Pos = Vector(7726.34375, -2427.6528320313, 64.03125), Neighbors = {38, 40}}
taxi_nodes[40] = {Pos = Vector(7727.4165039063, -4729.07421875, 64.03125), Neighbors = {39, 41}}
taxi_nodes[41] = {Pos = Vector(7378.73828125, -6402.1967773438, 64.03125), Neighbors = {40, 42}}
taxi_nodes[42] = {Pos = Vector(5370.2426757813, -6522.5727539063, 64.03125), Neighbors = {41, 43}}
taxi_nodes[43] = {Pos = Vector(4023.6591796875, -6534.9487304688, 64.03125), Neighbors = {42, 44, 45, 46}}
taxi_nodes[44] = {Pos = Vector(4021.3994140625, -8085.5297851563, 63.266593933105), Neighbors = {43}}
taxi_nodes[45] = {Pos = Vector(4018.3740234375, -5551.380859375, 56.03125), Neighbors = {43}}
taxi_nodes[46] = {Pos = Vector(2351.0473632813, -6528.0859375, 64.03125), Neighbors = {43, 47}}
taxi_nodes[47] = {Pos = Vector(56.727153778076, -6525.9438476563, 64.03125), Neighbors = {46, 48, 49}}
taxi_nodes[48] = {Pos = Vector(100.41773223877, -7437.9145507813, 53.03125), Neighbors = {47}}
taxi_nodes[49] = {Pos = Vector(-843.01654052734, -6183.3720703125, 64.03125), Neighbors = {47, 50}}
taxi_nodes[50] = {Pos = Vector(-965.6083984375, -4470.7373046875, 64.03125), Neighbors = {49, 51}}
taxi_nodes[51] = {Pos = Vector(-965.86962890625, -2416.4702148438, 64.03125), Neighbors = {50, 52}}
taxi_nodes[52] = {Pos = Vector(-962.44213867188, -644.61596679688, 64.03125), Neighbors = {51, 53, 54}}
taxi_nodes[53] = {Pos = Vector(-3235.3452148438, -649.66345214844, 64.03125), Neighbors = {16, 52}}
taxi_nodes[54] = {Pos = Vector(26.604526519775, -116.56253814697, 64.03125), Neighbors = {52, 55}}
taxi_nodes[55] = {Pos = Vector(54.742713928223, 1793.0655517578, 64.03125), Neighbors = {54, 56}}
taxi_nodes[56] = {Pos = Vector(51.603355407715, 3210.3876953125, 64.03125), Neighbors = {55, 57, 61}}
taxi_nodes[57] = {Pos = Vector(2536, 3204.8483886719, 64.03125), Neighbors = {56, 58, 60}}
taxi_nodes[58] = {Pos = Vector(4661.5151367188, 3209.7658691406, 64.03125), Neighbors = {57, 59}}
taxi_nodes[59] = {Pos = Vector(4666.5649414063, 5000.3325195313, 64.03125), Neighbors = {58, 60, 65}}
taxi_nodes[60] = {Pos = Vector(2536.7446289063, 5000.42578125, 64.03125), Neighbors = {57, 59, 61}}
taxi_nodes[61] = {Pos = Vector(61.002227783203, 4995.0654296875, 64.03125), Neighbors = {56, 60, 62}}
taxi_nodes[62] = {Pos = Vector(152.71060180664, 8169.4599609375, 64.03125), Neighbors = {61, 63}}
taxi_nodes[63] = {Pos = Vector(1834.0347900391, 8582.119140625, 64.03125), Neighbors = {62, 64}}
taxi_nodes[64] = {Pos = Vector(4253.5219726563, 8484.0712890625, 64.03125), Neighbors = {63, 65}}
taxi_nodes[65] = {Pos = Vector(4665.578125, 6789.6401367188, 64.03125), Neighbors = {59, 64}}
taxi_nodes[66] = {Pos = Vector(-9683.1396484375, 10715.169921875, 185.36457824707), Neighbors = {19, 67}}
taxi_nodes[67] = {Pos = Vector(-13535.340820313, 11459.353515625, 186.03121948242), Neighbors = {66}}
taxi_nodes[68] = {Pos = Vector(-3968.0661621094, 12990.700195313, 186.03125), Neighbors = {20}}
taxi_nodes[69] = {Pos = Vector(12057.672851563, 11461.168945313, 58.312362670898), Neighbors = {30, 31}}
