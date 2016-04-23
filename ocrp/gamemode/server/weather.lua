print("weather init")

local CLOUDS_CLEAR = 1;
local CLOUDS_PARTLY = 2;
local CLOUDS_MOSTLY_PRE = 3;
local CLOUDS_MOSTLY_POST = 4;
local CLOUDS_STORMY = 5;
local CLOUDS_STORMY_LIGHT = 6;
local CLOUDS_STORMY_PRE = 7;
local CLOUDS_STORMY_SEVERE = 8;
local CLOUDS_HEATWAVE = 9;

local SEASON_SPRING = 1;
local SEASON_SUMMER = 2;
local SEASON_AUTUMN = 3;
local SEASON_WINTER = 4;

local DAY_LENGTH = 24

local CLOUD_CONDITION_TO_STRING = {"CLOUDS_CLEAR", "CLOUDS_PARTLY", "CLOUDS_MOSTLY_PRE", "CLOUDS_MOSTLY_POST", "CLOUDS_STORMY", "CLOUDS_STORMY_LIGHT", "CLOUDS_STORMY_PRE", "CLOUDS_STORMY_SEVERE", "CLOUDS_HEATWAVE"};
local SEASON_TO_STRING = {"SEASON_SPRING", "SEASON_SUMMER", "SEASON_AUTUMN", "SEASON_WINTER"};

local MONTH_SEASON_CONV = {SEASON_WINTER, SEASON_WINTER, SEASON_SPRING, SEASON_SPRING, SEASON_SPRING, SEASON_SUMMER, SEASON_SUMMER, SEASON_SUMMER, SEASON_AUTUMN, SEASON_AUTUMN, SEASON_AUTUMN, SEASON_WINTER};

local CLOUD_CHANGES = {
						CLOUDS_CLEAR 			= {DAY_LENGTH * .1, DAY_LENGTH * .5},
						CLOUDS_PARTLY			= {DAY_LENGTH * .1, DAY_LENGTH * .5},
						CLOUDS_MOSTLY_PRE 		= {DAY_LENGTH * .1, DAY_LENGTH * .5},
						CLOUDS_STORMY_LIGHT 	= {DAY_LENGTH * .1, DAY_LENGTH * .5},
						CLOUDS_STORMY_PRE		= {DAY_LENGTH * .025, DAY_LENGTH * .05},
						CLOUDS_STORMY 			= {DAY_LENGTH * .1, DAY_LENGTH * .5},
						CLOUDS_STORMY_SEVERE 	= {DAY_LENGTH * .1, DAY_LENGTH * .5},
						CLOUDS_MOSTLY_POST 		= {DAY_LENGTH * .1, DAY_LENGTH * .5},
						CLOUDS_HEATWAVE 		= {DAY_LENGTH * .1, DAY_LENGTH * .5},
					}
					
local SEASON_LIGHT_VALUES = {
								SEASON_WINTER = {
													CLOUDS_CLEAR 			= 'q',
													CLOUDS_HEATWAVE 	 	= 'z',
													
													CLOUDS_PARTLY 			= 'j',
													
													CLOUDS_MOSTLY_PRE 		= 'g',
													CLOUDS_STORMY_LIGHT		= 'g',
													CLOUDS_MOSTLY_POST 	 	= 'g',
													
													CLOUDS_STORMY_PRE 		= 'd',
													CLOUDS_STORMY	 		= 'd',
													
													CLOUDS_STORMY_SEVERE 	= 'b',
												},
												
								SEASON_SPRING = {
													CLOUDS_CLEAR 			= 'z',
													CLOUDS_HEATWAVE 	 	= 'z',
													
													CLOUDS_PARTLY 			= 'l',
													
													CLOUDS_MOSTLY_PRE 		= 'd',
													CLOUDS_STORMY_LIGHT		= 'd',
													CLOUDS_MOSTLY_POST 	 	= 'd',
													
													CLOUDS_STORMY_PRE 		= 'c',
													CLOUDS_STORMY	 		= 'b',
													
													CLOUDS_STORMY_SEVERE 	= 'a',
												},
												
								SEASON_SUMMER = {
													CLOUDS_CLEAR 			= 'z',
													CLOUDS_HEATWAVE 	 	= 'z',
													
													CLOUDS_PARTLY 			= 'l',
													
													CLOUDS_MOSTLY_PRE 		= 'c',
													CLOUDS_STORMY_LIGHT		= 'c',
													CLOUDS_MOSTLY_POST 	 	= 'c',
													
													CLOUDS_STORMY_PRE 		= 'c',
													CLOUDS_STORMY	 		= 'b',
													
													CLOUDS_STORMY_SEVERE 	= 'a',
												},
												
								SEASON_AUTUMN = {
													CLOUDS_CLEAR 			= 'z',
													CLOUDS_HEATWAVE 	 	= 'z',
													
													CLOUDS_PARTLY 			= 'l',
													
													CLOUDS_MOSTLY_PRE 		= 'c',
													CLOUDS_STORMY_LIGHT		= 'c',
													CLOUDS_MOSTLY_POST 	 	= 'c',
													
													CLOUDS_STORMY_PRE 		= 'c',
													CLOUDS_STORMY	 		= 'b',
													
													CLOUDS_STORMY_SEVERE 	= 'a',
												},
							}

local SEASON_TEMP_CLOUDS = {
								SEASON_WINTER = {						// 	     Day, 		        Night
													CLOUDS_CLEAR 			= {	{1, 2}	, 	{-1, 1} },
													CLOUDS_PARTLY 			= {	{0, 1}	, 	{-1, 0} },
													CLOUDS_MOSTLY_PRE 		= {	{-1, 0}	, 	{-2, -1} },
													CLOUDS_STORMY_LIGHT		= {	{-1, 1}	,	{-2, -1} },
													CLOUDS_STORMY_PRE 		= {	{-1, 1}	,	{-2, -1} },
													CLOUDS_STORMY	 		= {	{-1, 1}	,	{-2, -1} },
													CLOUDS_STORMY_SEVERE 	= {	{-1, 1}	,	{-2, -1} },
													CLOUDS_MOSTLY_POST 	 	= {	{-1, 1}	,	{-2, -1} },
													CLOUDS_HEATWAVE 	 	= {	{1, 3}	,	{-0.5, 2} },
												},
												
								SEASON_SPRING = {						// 	     Day, 		        Night
													CLOUDS_CLEAR 			= {	{0, 2}	, 	{-1, 1} },
													CLOUDS_PARTLY 			= {	{0, 2}	, 	{-1, 1} },
													CLOUDS_MOSTLY_PRE 		= {	{0, 1}	, 	{-1, 1} },
													CLOUDS_STORMY_LIGHT		= {	{-1, 0}	,	{-2, 0} },
													CLOUDS_STORMY_PRE 		= {	{-1, 0}	,	{-2, 0} },
													CLOUDS_STORMY	 		= {	{-1, 0}	,	{-2, 0} },
													CLOUDS_STORMY_SEVERE 	= {	{-2, 0}	,	{-2, 0} },
													CLOUDS_MOSTLY_POST 	 	= {	{-1, 0}	,	{-2, 0} },
													CLOUDS_HEATWAVE 	 	= {	{2, 4}	,	{0, 3} },
												},
												
								SEASON_SUMMER = {						// 	     Day, 		        Night
													CLOUDS_CLEAR 			= {	{1, 3}	, 	{-1, 2} },
													CLOUDS_PARTLY 			= {	{1, 2}	, 	{-1, 1} },
													CLOUDS_MOSTLY_PRE 		= {	{0, 1}	, 	{-1, 1} },
													CLOUDS_STORMY_LIGHT		= {	{-1, 1}	,	{-1, 0} },
													CLOUDS_STORMY_PRE 		= {	{0, 1}	,	{-1, 0} },
													CLOUDS_STORMY	 		= {	{-1, 1}	,	{-1, 0} },
													CLOUDS_STORMY_SEVERE 	= {	{-2, 0}	,	{-2, 0} },
													CLOUDS_MOSTLY_POST 	 	= {	{0, 1}	,	{-1, 0} },
													CLOUDS_HEATWAVE 	 	= {	{2, 5}	,	{1, 4} },
												},
												
								SEASON_AUTUMN = {						// 	     Day, 		        Night
													CLOUDS_CLEAR 			= {	{0, 2}	, 	{-1, 1} },
													CLOUDS_PARTLY 			= {	{0, 2}	, 	{-1, 1} },
													CLOUDS_MOSTLY_PRE 		= {	{0, 1}	, 	{-1, 1} },
													CLOUDS_STORMY_LIGHT		= {	{-1, 0}	,	{-2, 0} },
													CLOUDS_STORMY_PRE 		= {	{-1, 0}	,	{-2, 0} },
													CLOUDS_STORMY	 		= {	{-1, 0}	,	{-2, 0} },
													CLOUDS_STORMY_SEVERE 	= {	{-1, 0}	,	{-2, 0} },
													CLOUDS_MOSTLY_POST 	 	= {	{-1, 0}	,	{-2, 0} },
													CLOUDS_HEATWAVE 	 	= {	{2, 4}	,	{0, 3} },
												},
							};

local SEASON_WEATHER_PROB = {
								SEASON_WINTER = {
											CLOUDS_CLEAR = {
													{30, CLOUDS_PARTLY}, 
													{60, CLOUDS_CLEAR}, 
													{10, CLOUDS_MOSTLY_PRE},
												},
											CLOUDS_PARTLY = {
													{40, CLOUDS_CLEAR},
													{30, CLOUDS_PARTLY},
													{30, CLOUDS_MOSTLY_PRE},
												},
											CLOUDS_MOSTLY_PRE = {
													{40, CLOUDS_STORMY_LIGHT},
													{20, CLOUDS_STORMY_PRE}, 
													{30, CLOUDS_MOSTLY_PRE}, 
													{10, CLOUDS_PARTLY}, 
												},
											CLOUDS_STORMY_LIGHT = {
													{30, CLOUDS_STORMY_LIGHT},
													{20, CLOUDS_STORMY},
													{50, CLOUDS_MOSTLY_POST},
												},
											CLOUDS_STORMY_PRE = {
													{100, CLOUDS_STORMY},
												},
											CLOUDS_STORMY = {
													{40, CLOUDS_STORMY},
													{10, CLOUDS_STORMY_SEVERE},
													{50, CLOUDS_MOSTLY_POST},
												},
											CLOUDS_STORMY_SEVERE = {
													{100, CLOUDS_MOSTLY_POST},
												},
											CLOUDS_MOSTLY_POST = {
													{30, CLOUDS_STORMY},
													{40, CLOUDS_PARTLY},
													{30, CLOUDS_CLEAR},
												},
											},
											
								SEASON_SPRING = {
											CLOUDS_CLEAR = {
													{40, CLOUDS_PARTLY},
													{40, CLOUDS_CLEAR}, 
													{10, CLOUDS_HEATWAVE}, 
													{10, CLOUDS_MOSTLY_PRE},
												},
											CLOUDS_HEATWAVE = {
													{100, CLOUDS_CLEAR}, 
												},
											CLOUDS_PARTLY = {
													{30, CLOUDS_CLEAR},
													{25, CLOUDS_PARTLY},
													{45, CLOUDS_MOSTLY_PRE},
												},
											CLOUDS_MOSTLY_PRE = {
													{40, CLOUDS_STORMY_LIGHT},
													{20, CLOUDS_STORMY_PRE},
													{30, CLOUDS_MOSTLY_PRE}, 
													{10, CLOUDS_PARTLY}, 
												},
											CLOUDS_STORMY_LIGHT = {
													{20, CLOUDS_STORMY_LIGHT},
													{20, CLOUDS_STORMY},
													{60, CLOUDS_MOSTLY_POST},
												},
											CLOUDS_STORMY_PRE = {
													{100, CLOUDS_STORMY},
												},
											CLOUDS_STORMY = {
													{35, CLOUDS_STORMY},
													{25, CLOUDS_STORMY_SEVERE},
													{40, CLOUDS_MOSTLY_POST},
												},
											CLOUDS_STORMY_SEVERE = {
													{100, CLOUDS_MOSTLY_POST},
												},
											CLOUDS_MOSTLY_POST = {
													{30, CLOUDS_STORMY},
													{40, CLOUDS_PARTLY},
													{30, CLOUDS_CLEAR},
												},
											},
											
								SEASON_SUMMER = {
											CLOUDS_CLEAR = {
													{20, CLOUDS_PARTLY}, 
													{50, CLOUDS_CLEAR}, 
													{20, CLOUDS_HEATWAVE}, 
													{10, CLOUDS_MOSTLY_PRE},
												},
											CLOUDS_HEATWAVE = {
													{30, CLOUDS_HEATWAVE}, 
													{70, CLOUDS_CLEAR}, 
												},
											CLOUDS_PARTLY = {
													{30, CLOUDS_CLEAR},
													{25, CLOUDS_PARTLY},
													{45, CLOUDS_MOSTLY_PRE},
												},
											CLOUDS_MOSTLY_PRE = {
													{40, CLOUDS_STORMY_LIGHT},
													{20, CLOUDS_STORMY_PRE},
													{30, CLOUDS_MOSTLY_PRE}, 
													{10, CLOUDS_PARTLY}, 
												},
											CLOUDS_STORMY_LIGHT = {
													{30, CLOUDS_STORMY_LIGHT},
													{10, CLOUDS_STORMY},
													{60, CLOUDS_MOSTLY_POST},
												},
											CLOUDS_STORMY_PRE = {
													{100, CLOUDS_STORMY},
												},
											CLOUDS_STORMY = {
													{40, CLOUDS_STORMY},
													{20, CLOUDS_STORMY_SEVERE},
													{40, CLOUDS_MOSTLY_POST},
												},
											CLOUDS_STORMY_SEVERE = {
													{100, CLOUDS_MOSTLY_POST},
												},
											CLOUDS_MOSTLY_POST = {
													{30, CLOUDS_STORMY},
													{40, CLOUDS_PARTLY},
													{30, CLOUDS_CLEAR},
												},
											},
							
								SEASON_AUTUMN = {
											CLOUDS_CLEAR = {
													{40, CLOUDS_PARTLY}, 
													{40, CLOUDS_CLEAR}, 
													{10, CLOUDS_HEATWAVE}, 
													{10, CLOUDS_MOSTLY_PRE},
												},
											CLOUDS_HEATWAVE = {
													{100, CLOUDS_CLEAR}, 
												},
											CLOUDS_PARTLY = {
													{30, CLOUDS_CLEAR},
													{25, CLOUDS_PARTLY},
													{45, CLOUDS_MOSTLY_PRE},
												},
											CLOUDS_MOSTLY_PRE = {
													{40, CLOUDS_STORMY_LIGHT},
													{20, CLOUDS_STORMY_PRE},
													{30, CLOUDS_MOSTLY_PRE}, 
													{10, CLOUDS_PARTLY}, 
												},
											CLOUDS_STORMY_LIGHT = {
													{20, CLOUDS_STORMY_LIGHT},
													{20, CLOUDS_STORMY},
													{60, CLOUDS_MOSTLY_POST},
												},
											CLOUDS_STORMY_PRE = {
													{100, CLOUDS_STORMY},
												},
											CLOUDS_STORMY = {
													{40, CLOUDS_STORMY},
													{15, CLOUDS_STORMY_SEVERE},
													{45, CLOUDS_MOSTLY_POST},
												},
											CLOUDS_STORMY_SEVERE = {
													{100, CLOUDS_MOSTLY_POST},
												},
											CLOUDS_MOSTLY_POST = {
													{30, CLOUDS_STORMY},
													{40, CLOUDS_PARTLY},
													{30, CLOUDS_CLEAR},
												},
											},
							};

AVERAGE_TEMPERATURES = {
								{20, 41},
								{24, 46},
								{34, 57},
								{44, 67},
								{55, 77},
								{64, 87},
								{69, 93},
								{68, 91},
								{58, 82},
								{45, 69},
								{32, 54},
								{23, 43}
							  };
                              
MONTH_DAYS = {30,30,30,30,30,30,30,30,30,30,30,30}
							  
local TRUE_TEMPERATURES = {};

GM.CurrentTemperature = 30;
GM.CloudCondition = CLOUDS_STORMY;
GM.NextCloudChange = DAY_LENGTH * .25;
GM.NextTempChange = DAY_LENGTH / 24;
local CLOUD_DIRECTION = 1;

local function setupWeather ( )
	local lastTempHigh = (AVERAGE_TEMPERATURES[1][1] + AVERAGE_TEMPERATURES[1][2] + AVERAGE_TEMPERATURES[1][2]) * (1/3);
	local lastTempLow = (AVERAGE_TEMPERATURES[1][1] + AVERAGE_TEMPERATURES[1][1] + AVERAGE_TEMPERATURES[1][2]) * (1/3);
	local curPattern = -1;
	local nextChange = 2;

	for k, v in pairs(AVERAGE_TEMPERATURES) do
		TRUE_TEMPERATURES[k] = {};
		
		local average = (v[1] + v[2]) * .5;
		local trueMaxMin, trueMinMin = v[2] - 5, v[1] - 5;
		local trueMaxMax, trueMinMax = v[2] + 10, v[1] + 5;
		
		for i = 1, MONTH_DAYS[k] do
			if (nextChange == 0) then
				curPattern = 0;
				
				if (lastTempHigh + lastTempLow) * .5 > average then
					while (curPattern == 0) do
						curPattern = math.Clamp(math.random(-5, 2), -2, 1);
					end
				else
					while (curPattern == 0) do
						curPattern = math.Clamp(math.random(-2, 5), -2, 1);
					end
				end
				
				nextChange = math.random(3, 5);
			end
			nextChange = nextChange - 1;
			
			local thisChangeUpper = math.random(50, 200) * curPattern * .01;
			local thisChangeLower = math.random(50, 200) * curPattern * .01;
			
			lastTempLow = math.Clamp(lastTempLow + thisChangeLower, trueMinMin, trueMinMax);
			lastTempHigh = math.Clamp(lastTempHigh + thisChangeUpper, trueMaxMin, trueMaxMax);
		
			TRUE_TEMPERATURES[k][i] = {lastTempLow, lastTempHigh};
		end
	end
    GAMEMODE.NextCloudChange = 0
    GAMEMODE.calculateWeather()
end
hook.Add("Initialize", "setupWeather", setupWeather);



local CLOUDS_CLEAR = 1;
local CLOUDS_PARTLY = 2;
local CLOUDS_MOSTLY_PRE = 3;
local CLOUDS_MOSTLY_POST = 4;
local CLOUDS_STORMY = 5;
local CLOUDS_STORMY_LIGHT = 6;
local CLOUDS_STORMY_PRE = 7;
local CLOUDS_STORMY_SEVERE = 8;
local CLOUDS_HEATWAVE = 9;

local CLOUD_NAMES = {"CLOUDS_CLEAR", "CLOUDS_PARTLY", "CLOUDS_MOSTLY_PRE", "CLOUDS_MOSTLY_POST", "CLOUDS_STORMY", "CLOUDS_STORMY_LIGHT", "CLOUDS_STORMY_PRE", "CLOUDS_STORMY_SEVERE", "CLOUDS_HEATWAVE"}

function GM.calculateWeather ( ) 
	local CurrentSeason = SEASON_WINTER;

	// Cloud Conditions
	if (GAMEMODE.NextCloudChange <= 0) then
		local rand = math.random(1, 100);
		local ourTable = SEASON_WEATHER_PROB[SEASON_TO_STRING[CurrentSeason]][CLOUD_CONDITION_TO_STRING[GAMEMODE.CloudCondition]];
		
		for k, v in pairs(ourTable) do
			if (rand <= v[1]) then
				GAMEMODE.CloudCondition = v[2];
				break;
			else
				rand = rand - v[1];
			end
		end
		
		GAMEMODE.NextCloudChange = math.random(DAY_LENGTH * .1, DAY_LENGTH * .5);
		
		GAMEMODE.LastWeatherChange = CurTime();
		GAMEMODE.NextWeatherChange = CurTime() + GAMEMODE.NextCloudChange;
		SetGlobalInt("clouds", GAMEMODE.CloudCondition);
		Msg("Weather pattern changed to '" .. CLOUD_NAMES[GAMEMODE.CloudCondition] .. "'.\n");
	end
	GAMEMODE.NextCloudChange = GAMEMODE.NextCloudChange - .5;
	
	// Temperature
	if (GAMEMODE.NextTempChange <= 0) then
		local ourTable = SEASON_TEMP_CLOUDS[SEASON_TO_STRING[CurrentSeason]][CLOUD_CONDITION_TO_STRING[GAMEMODE.CloudCondition]];
		
		if (GAMEMODE.CurrentTime < DAWN_START || GAMEMODE.CurrentTime > DUSK_START) then
			ourTable = ourTable[2];
		else
			ourTable = ourTable[1];
		end
		
		local tempChange = math.random(ourTable[1], ourTable[2]);
		
		local trueTempChange = math.random(20, 50) * .01 * tempChange;
		GAMEMODE.CurrentTemperature = math.Clamp(GAMEMODE.CurrentTemperature + trueTempChange, TRUE_TEMPERATURES[GAMEMODE.CurrentMonth][GAMEMODE.CurrentDay][1], TRUE_TEMPERATURES[GAMEMODE.CurrentMonth][GAMEMODE.CurrentDay][2]);
		
		SetGlobalInt("temp", GAMEMODE.CurrentTemperature);
		Msg("Temperature changed to " .. GAMEMODE.CurrentTemperature .. ". ( Change: " .. trueTempChange .. " )\n");
	
		GAMEMODE.NextTempChange = DAY_LENGTH / math.random(20, 50);
	end
	GAMEMODE.NextTempChange = GAMEMODE.NextTempChange - .5;
end

function GM.handleSnow ( )
	local storming = GAMEMODE.CloudCondition == CLOUDS_STORMY || GAMEMODE.CloudCondition == CLOUDS_STORMY_LIGHT || GAMEMODE.CloudCondition == CLOUDS_STORMY_SEVERE;

	if (!GAMEMODE.SnowOnGround && GetGlobalInt("temp", 35) <= 32 && storming && GAMEMODE.LastWeatherChange + 20 <= CurTime()) then
		GAMEMODE.SnowOnGround = true;
	elseif (GAMEMODE.SnowOnGround && GetGlobalInt("temp", 35) > 32 && GAMEMODE.LastWeatherChange + 10 <= CurTime()) then
		GAMEMODE.SnowOnGround = nil;
	end
end
hook.Add("Think", "handleSnow", GM.handleSnow);

function GM.manipulateLightTable ( ourTable )
	local originalPattern = ourTable.pattern;
	local CurrentSeason = SEASON_WINTER;
	
	local maxLight = SEASON_LIGHT_VALUES[SEASON_TO_STRING[CurrentSeason]][CLOUD_CONDITION_TO_STRING[GAMEMODE.CloudCondition]];
	local newPatByte = math.Clamp(string.byte(ourTable.pattern), string.byte(ourTable.pattern), string.byte(maxLight));
	
	GAMEMODE.LastLightingCond = GAMEMODE.LastLightingCond or newPatByte;
	if (newPatByte > GAMEMODE.LastLightingCond) then
		GAMEMODE.LastLightingCond = GAMEMODE.LastLightingCond + 1;
	elseif (newPatByte < GAMEMODE.LastLightingCond) then
		GAMEMODE.LastLightingCond = GAMEMODE.LastLightingCond - 1;
	end
	
	ourTable.pattern = string.char(GAMEMODE.LastLightingCond);
	
	if (maxLight != 'z' || GAMEMODE.CurrentTemperature <= 33) then
		GAMEMODE.PushDayEffects(false);
	elseif (maxLight == 'z' && originalPattern != 'a') then
		GAMEMODE.PushDayEffects(true);
	end
	
	return ourTable;
end

