
// Snow
local REPLACING_TEXTURES = {	--"concrete/concretefloor001a", 
								-- "stone/stonefloor011a", 
								-- "concrete/concretefloor006a", 
								"nature/grassfloor001a", 
								"nature/grassfloor002a", 
								"nature/grassfloor003a", 
								-- "concrete/concretefloor011a", 
								"ajacks/ajacks_road6", 
								"ajacks/ajacks_road8", 
							    "ajacks/ajacks_road7", 
								"ajacks/ajacks_road1", 
							    "ajacks/ajacks_road3",
															    "ajacks/ajacks_road2", 

															    "ajacks/ajacks_road5", 
								"ajacks/ajacks_10", 
								-- "concrete/concretefloor031a",
								-- "stone/stonefloor_inn01",
								-- //"concrete/concreteceiling003a",
								-- "metal/metalgrate004a",
								-- "concrete/concretefloor027a",
								"de_cbble/grounddirt",
								-- "nature/blendgraveldirt01",
								-- "nature/blendgrassdirt01",
								-- "concrete/concretefloor027b",
								"CS_HAVANA/GROUND01GRASS",
								"WOOD/MILROOF001",
"DE_TRAIN/TRAIN_CEMENT_FLOOR_01",
"DE_TRAIN/TRAIN_CEMENTWEAR_01",
--"STONE/INFFLRC",
"CONCRETE/CURBREDA",
"DE_TIDES/TIDES_DIRT",
"CONCRETE/CONCRETEFLOOR024A",
"DE_PRODIGY/METAL01",
"BUILDING_TEMPLATE/ROOF_TEMPLATE001A",
"WOOD/WOODSHINGLES002A",
"DE_TRAIN/TRAIN_GRASS_FLOOR_01",
"DE_NUKE/NUKROOFA",
"WAREHOUSE/SE1_METAL_ROOF_CORRUG_04",
"DE_NUKE/NUKROOF01",
"DE_TIDES/TIDES_ROOF_1",
"nature/blendgrassgravel001a",
"NATURE/BLENDDIRTGRASS008A",

"models/props_foliage/tree_pine_01_branches",
"nature/blendgrassgravel001b",
"nature/blenddirtgrass00",
"HIGHRISE/SE1_CEMENT_OFFICE_FLOOR_01",
 "CONCRETE/CONCRETEFLOOR038A",
 "CONCRETE/CONCRETEFLOOR037A",
 "DE_TIDES/TIDES_GRASS_A",
 "DE_TRAIN/TRAIN_CEMENT_FLOOR_02",
 //"env/plant/jungle_wall_02_hi",
 "de_aztec/ground01grass",
"de_cbble/grassfloor01",
"PROPS/RUBBERROOF002A",
"de_train/train_grass_floor_01",
"models/msc/e_bigbush",
-- "nature/cliffface001a",
-- "models/props_wasteland/rockcliff02a",
"models/aoc_trees/pine_branch03",
"models/aoc_trees/pine_branch02",
"nature/blendcliffgrass001a",
"models/props_wasteland/rockcliff0",

								"models/msc/e_leaves",
								"models/msc/e_leaves2",
								"models/msc/e_leaves3",
								"models/props/de_inferno/largebushi",
								"models/props/de_inferno/largebushh",
								"models/props/de_inferno/largebushg",
								"models/props/de_inferno/largebushb",
								"models/props/de_inferno/prodgrassa",
								"models/props/de_inferno/largebushf",
								"models/props/de_inferno/largebushc",
								"models/props/de_inferno/largebushc1",
								"models/props/de_inferno/bushgreen",
								"models/props_foliage/hedge_128",
"maps/rp_evocity_v2pdless/DE_TRAIN/TRAIN_CEMENTWEAR_01",
"maps/rp_evocity_v2pdless/cs_assault/pavement001a_-8124_-10028_144",
"maps/rp_evocity_v2pdless/cs_assault/pavement001a_-7835_-10036_144",
"maps/rp_evocity_v2pdless/cs_assault/pavement001a_-6806_-7527_137",
"maps/rp_evocity_v2pdless/cs_assault/pavement001a_-9368_-8601_200",
"maps/rp_evocity_v2pdless/cs_assault/pavement001a_-6925_-4674_133",
"maps/rp_evocity_v2pdless/cs_assault/pavement001a_3250_4088_126",
"maps/rp_evocity_v2pdless/cs_assault/pavement001a_3498_4227_126",
"maps/rp_evocity_v2pdless/metal/metalroof005a_3637_3853_126",
"maps/rp_evocity_v2pdless/cs_assault/pavement001a_-6702_-7698_137",
"maps/rp_evocity_v2pdless/cs_assault/pavement001a_-9310_-9239_200",
							};
							
							

local function EnableSnow ( )
	if (GAMEMODE.SnowOnGround) then return; end
	GAMEMODE.SnowOnGround = true;
	
	for k, v in pairs(REPLACING_TEXTURES) do
		if (v[1] && v[3]) then
			v[1]:SetTexture("$basetexture", v[3]);
		end
	end
end

local function BuildSnowMaterials ( )
	for k, v in pairs(REPLACING_TEXTURES) do
		local defaultSnowMaterial = Material("Nature/snowfloor001a"):GetTexture("$basetexture");
	
		local newTable = {};
		
		newTable[1] = Material(v);
		
		--local snowName = "ocrp/snow/" .. string.GetFileFromFilename(v);
		--print(snowName)

		--if file.Exists("../materials/" .. snowName .. ".vmt", "GAME") then
        --    print(snowName)
		--	newTable[3] = Material(snowName):GetTexture("$basetexture");
		--else
			newTable[3] = defaultSnowMaterial;
		--end
		
		newTable[2] = newTable[1]:GetTexture("$basetexture");
		
		REPLACING_TEXTURES[k] = newTable;
        print(tostring(newTable[1]))
        print(tostring(newTable[2]))
        print(tostring(newTable[3]))
	end
end
hook.Add("Initialize", "BuildSnowMaterials", BuildSnowMaterials);

local function selectSnow ( )

	
	local stormTables = {};
	// Snow
	stormTables[1] = {};
		stormTables[1][1] = {   ALLOW_SNOWGROUND		= true;   } // Clear skies
		stormTables[1][2] = {   ALLOW_SNOWGROUND		= true;   } // Partly Cloudy
		stormTables[1][3] = {   ALLOW_SNOWGROUND		= true;   } // Mostly Cloudy 
		stormTables[1][4] = {   ALLOW_SNOWGROUND		= true;   } // Mostly Cloudy
	
		// Stormy
		stormTables[1][5] = {
								SHOULD_SNOWGROUND 		= true;
								ALLOW_SNOWGROUND		= true;
								PRECIP_EFFECT			= "snow_heavy",
							}
		// Stormy_Light
		stormTables[1][6] = {
								SHOULD_SNOWGROUND 		= true;
								ALLOW_SNOWGROUND		= true;
								PRECIP_EFFECT			= "snow_light",
							}
		// Stormy_Pre
		stormTables[1][7] = {
								SHOULD_SNOWGROUND 		= true;
								ALLOW_SNOWGROUND		= true;
								PRECIP_EFFECT			= "snow_light",
							}
		// Stormy_Severe
		stormTables[1][8] = {
								SHOULD_SNOWGROUND 		= true;
								ALLOW_SNOWGROUND		= true;
								PRECIP_EFFECT			= "snow_blizzard",
							}
							
		stormTables[1][9] = {   ALLOW_SNOWGROUND		= true;   } // Heatwave
							
	
	GAMEMODE.StormTable = stormTables;
end
hook.Add("InitPostEntity", "selectSnow", selectSnow);

// Actual stuff.
local lastWeather = 0;
local lastStormTable = nil;
local nextSound = 0;
local nextPrecip = 0;
local nextThunder = 0;
local lastLighteningTime = 0;
local lighteningTime = .5;
local allowSnow = 1;

local CLOUDS_STORMY = 5;
local CLOUDS_STORMY_LIGHT = 6;
local CLOUDS_STORMY_PRE = 7;
local CLOUDS_STORMY_SEVERE = 8;

local function weatherThink ( )
	// Standard global stuff
	local currentWeather = CLOUDS_STORMY_SEVERE;
	local currentTemp = GetGlobalInt("temp", 30);
	
	// Discover our storm values;
	local shouldSnow = currentTemp <= 34;
	local shouldSlush = currentTemp < 37 && currentTemp > 34;
	local shouldRain = currentTemp >= 38;
	
	local ourShouldVal = 1;
	//if (shouldSlush) then ourShouldVal = 2; end
	//if (shouldRain) then ourShouldVal = 3; end
	
	// Transition noises
	if (currentWeather != lastWeather && LocalPlayer():IsOutside()) then
		local currentStormTable = GAMEMODE.StormTable[ourShouldVal][currentWeather];
		
		if (currentStormTable && currentStormTable["FADE_IN_SOUND"]) then
			if (!lastStormTable || !lastStormTable["LOOP_SOUND"]) then
				// They weren't playing a sound. Lets fade in.
				surface.PlaySound("perp2/" .. currentStormTable["FADE_IN_SOUND"]);
				nextSound = CurTime() + SoundDuration("perp2/" .. currentStormTable["FADE_IN_SOUND"]);
			end
		elseif (lastStormTable &&  lastStormTable["LOOP_SOUND"]) then
			lastStormTable["LOOP_SOUND"]:Stop()
			surface.PlaySound("perp2/" .. lastStormTable["FADE_OUT_SOUND"]);
			nextSound = CurTime() + SoundDuration("perp2/" .. lastStormTable["FADE_OUT_SOUND"]);
		end
		
		lastStormTable = currentStormTable;
		lastWeather = currentWeather;
		allowSnow = CurTime() + math.random(10, 20);
	end
	
	
	// Precipitation
	if (lastStormTable && lastStormTable["PRECIP_EFFECT"] && nextPrecip <= CurTime()) then	
		util.Effect(lastStormTable["PRECIP_EFFECT"], EffectData());
		
		if (lastStormTable["PRECIP_EFFECT"] == "rain_heavy") then
			nextPrecip = CurTime() + .5;
		else
			nextPrecip = CurTime() + 1;
		end
	end


		EnableSnow();

end
hook.Add("Think", "weatherThink", weatherThink);

local WeatherEffects = {};
local LastWeatherUpdate = 0;
local TransitionTime = 60;
local InsideTransitionTime = 1;
local LastWeather = CLOUDS_STORMY;
local CurrentWeather = CLOUDS_STORMY;	
WeatherEffects[CLOUDS_STORMY] = {
									cmod = {
										contrast = 1.02,
										brightness = -0.01,
										color = 0.81,

												
										   }
							    }

							  

function GM.WeatherEffects ( )	
	local tab = {};
	tab["$pp_colour_addr"] = 0
	tab["$pp_colour_addg"] = 0
	tab["$pp_colour_addb"] = 0
	tab["$pp_colour_mulr"] = 0
	tab["$pp_colour_mulg"] = 0
	tab["$pp_colour_mulb"] = 0
	tab["$pp_colour_colour"] = 1
	tab["$pp_colour_brightness"] = 0
	tab["$pp_colour_contrast"] = 1
	
	local bloom = {};
	bloom.darken = 0;
	bloom.multiply = 0;
	bloom.sizex = 0;
	bloom.sizey = 0;
	bloom.passes = 0;
	
	local Draw_CMod = false;
	local Draw_Bloom = false;
	
	local PercentTransitioned = math.Clamp((CurTime() - LastWeatherUpdate) / TransitionTime, 0, 1);
	local InversePersent = 1 - PercentTransitioned;
	local NewWeatherTable = WeatherEffects[CurrentWeather];
	local OldWeatherTable = WeatherEffects[LastWeather];
	
	if PercentTransitioned < 1 then
		if NewWeatherTable.bloom then
			Draw_Bloom = true;
			
			bloom.darken = bloom.darken + NewWeatherTable.bloom.darken * PercentTransitioned;
			bloom.multiply = bloom.multiply + NewWeatherTable.bloom.multiply * PercentTransitioned;
			bloom.sizex = bloom.sizex + NewWeatherTable.bloom.sizex * PercentTransitioned;
			bloom.sizey = bloom.sizey + NewWeatherTable.bloom.sizey * PercentTransitioned;
			bloom.passes = bloom.passes + NewWeatherTable.bloom.passes * PercentTransitioned;
		end
		
		if OldWeatherTable.bloom then
			Draw_Bloom = true;
			
			bloom.darken = bloom.darken + OldWeatherTable.bloom.darken * InversePersent;
			bloom.multiply = bloom.multiply + OldWeatherTable.bloom.multiply * InversePersent;
			bloom.sizex = bloom.sizex + OldWeatherTable.bloom.sizex * InversePersent;
			bloom.sizey = bloom.sizey + OldWeatherTable.bloom.sizey * InversePersent;
			bloom.passes = bloom.passes + OldWeatherTable.bloom.passes * InversePersent;
		end
		
		if NewWeatherTable.cmod then
			Draw_CMod = true;
			
			tab["$pp_colour_brightness"] = tab["$pp_colour_brightness"] + NewWeatherTable.cmod.brightness * PercentTransitioned;
			tab["$pp_colour_contrast"] = tab["$pp_colour_contrast"] - (1 - NewWeatherTable.cmod.contrast) * PercentTransitioned;
			tab["$pp_colour_colour"] = tab["$pp_colour_colour"] - (1 - NewWeatherTable.cmod.color) * PercentTransitioned;
		end
		
		if OldWeatherTable.cmod then
			Draw_CMod = true;
				
			tab["$pp_colour_brightness"] = tab["$pp_colour_brightness"] + OldWeatherTable.cmod.brightness * InversePersent;
			tab["$pp_colour_contrast"] = tab["$pp_colour_contrast"] - (1 - OldWeatherTable.cmod.contrast) * InversePersent;
			tab["$pp_colour_colour"] = tab["$pp_colour_colour"] - (1 - OldWeatherTable.cmod.color) * InversePersent;
		end
	else		
		if NewWeatherTable.bloom then
			Draw_Bloom = true;
		
			bloom.darken = NewWeatherTable.bloom.darken;
			bloom.multiply = NewWeatherTable.bloom.multiply;
			bloom.sizex = NewWeatherTable.bloom.sizex;
			bloom.sizey = NewWeatherTable.bloom.sizey;
			bloom.passes = NewWeatherTable.bloom.passes;
		end
		
		if NewWeatherTable.cmod then
			Draw_CMod = true;
		
			tab["$pp_colour_brightness"] = NewWeatherTable.cmod.brightness
			tab["$pp_colour_contrast"] = NewWeatherTable.cmod.contrast
			tab["$pp_colour_colour"] = NewWeatherTable.cmod.color
		end
	end
	
	local Filter = LocalPlayer();
	if LocalPlayer():InVehicle() then
		Filter = {LocalPlayer(), LocalPlayer():GetVehicle()}
	end
	
	local TrUp = {}
	TrUp.start = LocalPlayer():GetShootPos();
	TrUp.endpos = LocalPlayer():GetShootPos() + Vector(0, 0, 70);
	TrUp.filter = Filter;
	
	local TrUp2 = {}
	TrUp2.start = LocalPlayer():GetShootPos();
	TrUp2.endpos = LocalPlayer():GetShootPos() + Vector(0, 0, 10000);
	TrUp2.filter = Filter;
	
	local TrRes = util.TraceLine(TrUp);
	local TrRes2 = util.TraceLine(TrUp2);
	
	TrRes.Hit = TrRes.Hit and !TrRes.HitSky and !LocalPlayer():InVehicle();
	TrRes2.Hit = TrRes2.Hit and !TrRes2.HitSky;
	
	if TrRes.Hit then
		if WasInside then
			if EnterInsidePos:Distance(LocalPlayer():GetPos()) > 250 then
				AreInside = true;
			else
				AreInside = false;
			end
		else
			WasInside = true;
			EnterInsidePos = LocalPlayer():GetPos();
		end
	else
		AreInside = false;
		WasInside = false;
	end
	
	if AreInside then
		CurrentlyInsideStart = CurrentlyInsideStart or CurTime();
		local TransInsidePerc = math.Clamp((CurTime() - CurrentlyInsideStart) / InsideTransitionTime, 0, 1);
		local InverseInsidePerc = 1 - TransInsidePerc;
		
		if TransInsidePerc == 1 then
			Draw_Bloom = false;
			Draw_CMod = false;
		else
			if Draw_CMod then
				tab["$pp_colour_brightness"] = tab["$pp_colour_brightness"] * InverseInsidePerc;
				tab["$pp_colour_contrast"] = 1 - (1 - tab["$pp_colour_contrast"]) * InverseInsidePerc;
				tab["$pp_colour_colour"] = 1 - (1 - tab["$pp_colour_colour"]) * InverseInsidePerc;
			end
			
			if Draw_Bloom then
				bloom.darken = bloom.darken * InverseInsidePerc;
				bloom.multiply = bloom.multiply * InverseInsidePerc;
				bloom.sizex = bloom.sizex * InverseInsidePerc;
				bloom.sizey = bloom.sizey * InverseInsidePerc;
				bloom.passes = bloom.passes * InverseInsidePerc;
			end
		end
	elseif CurrentlyInsideStart then
		local TransInsidePerc = math.Clamp((CurTime() - CurrentlyInsideStart) / InsideTransitionTime, 0, 1);
		local InverseInsidePerc = 1 - TransInsidePerc;
		
		if TransInsidePerc == 1 then
			CurrentlyInsideEnd = CurTime();
		else
			CurrentlyInsideEnd = nil;
		end
		
		CurrentlyInsideStart = nil
	elseif CurrentlyInsideEnd then
		local TransInsidePerc = math.Clamp((CurTime() - CurrentlyInsideEnd) / InsideTransitionTime, 0, 1);
		local InverseInsidePerc = 1 - TransInsidePerc;
		
		if TransInsidePerc == 1 then
			CurrentlyInsideEnd = nil;
		else
			if Draw_CMod then
				tab["$pp_colour_brightness"] = tab["$pp_colour_brightness"] * TransInsidePerc;
				tab["$pp_colour_contrast"] = 1 - (1 - tab["$pp_colour_contrast"]) * TransInsidePerc;
				tab["$pp_colour_colour"] = 1 - (1 - tab["$pp_colour_colour"]) * TransInsidePerc;
			end
			
			if Draw_Bloom then
				bloom.darken = bloom.darken * TransInsidePerc;
				bloom.multiply = bloom.multiply * TransInsidePerc;
				bloom.sizex = bloom.sizex * TransInsidePerc;
				bloom.sizey = bloom.sizey * TransInsidePerc;
				bloom.passes = bloom.passes * TransInsidePerc;
			end
		end
	end
	

	if Draw_Bloom and render.SupportsPixelShaders_2_0() then	
		DrawBloom(bloom.darken, bloom.multiply, bloom.sizex, bloom.sizey, math.Round(bloom.passes), 0, 1, 1, 1);
	end
	
	if Draw_CMod then
		DrawColorModify(tab);
	end
	
	if PlayHeavyFadeOut and PlayHeavyFadeOut < CurTime() then
		PlayHeavyFadeOut = nil;
		surface.PlaySound(HeavyRainSound_FadeOut)
	end
	
	if PlayLightFadeOut and PlayLightFadeOut < CurTime() then
		PlayLightFadeOut = nil;
		surface.PlaySound(LightRainSound_FadeOut)
	end
end
hook.Add("RenderScreenspaceEffects", "GM.WeatherEffects", GM.WeatherEffects)

function GM.GetWeatherSpawnPos ( PredictSpeed, Filter )
	local SPos = {}
	SPos.start = LocalPlayer():GetPos() + PredictSpeed;
	SPos.endpos = SPos.start + Vector(0,0,51200);
	SPos.filter = Filter
	
	local TrRes = util.TraceLine(SPos);
	
	local SpawnPos;
	if (TrRes.HitSky) then
		local SPos = {}
		SPos.start = LocalPlayer():GetPos() + PredictSpeed;
		SPos.endpos = SPos.start + Vector(0,0,512);
		SPos.filter = Filter
		
		local TrRes2 = util.TraceLine(SPos);
			
		SpawnPos = TrRes2.HitPos;
	else
		local SPos = {}
		SPos.start = LocalPlayer():GetPos() + PredictSpeed;
		SPos.endpos = SPos.start + Vector(0,0,51200);
		SPos.filter = Filter
		
		local TrRes2 = util.TraceLine(SPos);
			
		SpawnPos = TrRes2.HitPos + Vector(0, 0, 128);
	end
	
	return SpawnPos;
end

