-- Note that OtherName must match the table key
-- I don't think this was initially the case, but that's an easy way to get car ID from only the table values

GM.OCRP_Cars = {}

GM.OCRP_Cars["BUGATTI_EB110"] = {
    Name = "Bugatti EB110",
    OtherName = "BUGATTI_EB110",
    Desc = "Woke up in a new THIS",
    Script = "scripts/vehicles/tdmcars/eb110.txt",
    Model = "models/tdmcars/bug_eb110.mdl",
    Price = 1200000,
    Health = 90,
    Speed = 110,
    GasTank = 500,
    StengthText = "Moderate",
    RepairCost = 1000,
    SeatsNum = 2,
    Skin_Price = 10000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(18, -2, 6), Angle(0,0,10))
    end,
	Headlights = Vector(21, 81, 33),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["AUDI_R8"] = {
    Name = "Audi R8",
    OtherName = "AUDI_R8",
    Desc = "Drive this and you're Robert Downey Jr.",
    Script = "scripts/vehicles/tdmcars/audir8.txt",
    Model = "models/tdmcars/audir8.mdl",
    Price = 835000,
    Health = 90,
    Speed = 85,
    GasTank = 500,
    StengthText = "Moderate",
    RepairCost = 800,
    SeatsNum = 2,
    Skin_Price = 10000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -5, 8), Angle(0,0,10))
    end,
	Headlights = Vector(31, 93, 26),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["BUGATTI_VEYRON"] = {
    Name = "Bugatti Veyron",
    OtherName = "BUGATTI_VEYRON",
    Desc = "This car is really cheap I swear.",
    Script = "scripts/vehicles/tdmcars/veyron.txt",
    Model = "models/tdmcars/bug_veyron.mdl",
    Price = 1550000,
    Health = 90,
    Speed = 130,
    GasTank = 500,
    StrengthText = "Moderate",
    RepairCost = 1250,
    SeatsNum = 2,
    Skin_Price = 12000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -5, 12), Angle(0,0,10))
    end,
	Headlights = Vector(26, 92, 31),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["JEEP_WRANGLER"] = {
    Name = "Jeep Wrangler",
    OtherName = "JEEP_WRANGLER",
    Desc = "No Roof",
    Script = "scripts/vehicles/tdmcars/wrangler88.txt",
    Model = "models/tdmcars/jeep_wrangler88.mdl",
    Price = 90000,
    Health = 120,
    Speed = 50,
    GasTank = 700,
    StrengthText = "Very Strong",
    RepairCost = 500,
    SeatsNum = 4,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 15, 30), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(12, 51, 33), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-10, 52, 33), Angle(0,0,10))
    end,
	Headlights = Vector(19, 79, 47),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["WRANGLER"] = {
    Name = "Jeep Wrangler",
    OtherName = "WRANGLER",
    Desc = "Lets you control your turret",
    Script = "scripts/vehicles/tdmcars/wrangler.txt",
    Model = "models/tdmcars/wrangler.mdl",
    Price = 110000,
    Health = 120,
    Speed = 65,
    GasTank = 700,
    StrengthText = "Very Strong",
    RepairCost = 500,
    SeatsNum = 4,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(17, 12, 33), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(11, 55, 33), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-11, 55, 33), Angle(0,0,10))
    end,
	Headlights = Vector(21, 76, 47),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["JEEP_GRANDCHE"] = {
    Name = "Grand Cherokee",
    OtherName = "JEEP_GRANDCHE",
    Desc = "Cherokee Middle School",
    Script = "scripts/vehicles/tdmcars/grandche.txt",
    Model = "models/tdmcars/jeep_grandche.mdl",
    Price = 110000,
    Health = 130,
    Speed = 65,
    GasTank = 750,
    StrengthText = "Very Strong",
    RepairCost = 500,
    SeatsNum = 4,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(19, 0, 34), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(22,46, 30), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-18, 45, 30), Angle(0,0,10))
    end,
	Headlights = Vector(30, 104, 45),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["DODGE_CHALLENGER"] = {
    Name = "Dodge Challenger",
    OtherName = "DODGE_CHALLENGER",
    Desc = "I challenge you to dodge this.",
    Script = "scripts/vehicles/tdmcars/challenger70.txt",
    Model = "models/tdmcars/dod_challenger70.mdl",
    Price = 70000,
    Health = 100,
    Speed = 70,
    GasTank = 600,
    StrengthText = "Strong",
    RepairCost = 500,
    SeatsNum = 4,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(17, 12, 14), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(18, 47, 20), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-16, 44, 20), Angle(0,0,10))
    end,
	Headlights = Vector(34, 110, 33),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["DODGE_CHARGER12"] = {
    Name = "Dodge Charger 2012",
    OtherName = "DODGE_CHARGER12",
    Desc = "CHARGE!! (again)",
    Script = "scripts/vehicles/tdmcars/charger2012.txt",
    Model = "models/tdmcars/dod_charger12.mdl",
    Price = 140000,
    Health = 100,
    Speed = 80,
    GasTank = 650,
    StrengthText = "Strong",
    RepairCost = 600,
    SeatsNum = 4,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(19, 2, 21), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-16, 51, 21), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(17, 49, 22), Angle(0,0,10))
    end,
	Headlights = Vector(29, 106, 35),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["DODGE_CHARGER_SRT8"] = {
    Name = "Dodge Charger SRT8",
    OtherName = "DODGE_CHARGER_SRT8",
    Desc = "CHARGE!!",
    Script = "scripts/vehicles/tdmcars/chargersrt8.txt",
    Model = "models/tdmcars/chargersrt8.mdl",
    Price = 130000,
    Health = 100,
    Speed = 85,
    GasTank = 700,
    StrengthText = "Strong",
    RepairCost = 650,
    SeatsNum = 4,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(17, 2, 19), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(18, 46, 19), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 46, 19), Angle(0,0,10))
    end,
	Headlights = Vector(30, 99, 33),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["DODGE_RAM"] = {
    Name = "Dodge Ram",
    OtherName = "DODGE_RAM",
    Desc = "I'll ram your dodge",
    Script = "scripts/vehicles/tdmcars/dodgeram.txt",
    Model = "models/tdmcars/dodgeram.mdl",
    Price = 125000,
    Health = 125,
    Speed = 80,
    GasTank = 400,
    StrengthText = "Very Strong",
    RepairCost = 700,
    SeatsNum = 2,
    Skin_Price = 5000,
    Seats = function(ply, Entity) -- add two on either side of bed trololol
        GAMEMODE.CreatePassengerSeat(Entity, Vector(21, -3, 32), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-41, 79, 50), Angle(0,-90,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(40, 79, 50), Angle(0,90,10))
    end,
	Headlights = Vector(34, 108, 42),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["AUDI_RS4"] = {
    Name = "Audi RS4 Avant",
    OtherName = "AUDI_RS4",
    Desc = "We Audi -- family style",
    Script = "scripts/vehicles/tdmcars/rs4avant.txt",
    Model = "models/tdmcars/aud_rs4avant.mdl",
    Price = 80000,
    Health = 90,
    Speed = 75,
    GasTank = 800,
    StrengthText = "Moderate",
    RepairCost = 500,
    SeatsNum = 4,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(18, -5, 15), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(18, 34, 14), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-18, 34, 14), Angle(0,0,10))
    end,
	Headlights = Vector(33, 105, 32),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["AUDI_R8_SPYDER"] = {
    Name = "Audi R8 Spyder",
    OtherName = "AUDI_R8_SPYDER",
    Desc = "Drive this and you're Tony Stark",
    Script = "scripts/vehicles/tdmcars/audir8spyd.txt",
    Model = "models/tdmcars/audi_r8_spyder.mdl",
    Price = 845000,
    Health = 85,
    Speed = 100,
    GasTank = 500,
    StrengthText = "Moderate",
    RepairCost = 1100,
    SeatsNum = 2,
    Skin_Price = 10000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(19, 0, 16), Angle(0,0,10))
    end,
	Headlights = Vector(34, 88, 33),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["AUDI_TT"] = {
    Name = "Audi TT",
    OtherName = "AUDI_TT",
    Desc = "TTT?",
    Script = "scripts/vehicles/tdmcars/auditt.txt",
    Model = "models/tdmcars/auditt.mdl",
    HydroPower = 300000, -- default is 450000 and is WAY too strong for audi TT
    Price = 150000,
    Health = 100,
    Speed = 80,
    GasTank = 700,
    StrengthText = "Strong",
    RepairCost = 650,
    SeatsNum = 4,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 0, 8), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(18, 39, 12), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-14, 39, 10), Angle(0,0,10))
    end,
	Headlights = Vector(34, 85, 29),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["FORD_MUSTANG_GT"] = {
    Name = "Ford Mustang",
    OtherName = "FORD_MUSTANG_GT",
    Desc = "Mustaaaaang",
    Script = "scripts/vehicles/tdmcars/mustanggt.txt",
    Model = "models/tdmcars/for_mustanggt.mdl",
    Price = 100000,
    Health = 100,
    Speed = 75,
    GasTank = 550,
    StrengthText = "Strong",
    RepairCost = 650,
    SeatsNum = 2,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 2, 19), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(19, 41, 22), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 42, 15), Angle(0,0,10))
    end,
	Headlights = Vector(33, 100, 34),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["FORD_RAPTOR"] = {
    Name = "Ford Raptor",
    OtherName = "FORD_RAPTOR",
    Desc = "My raptor is level 90",
    Script = "scripts/vehicles/tdmcars/raptorsvt.txt",
    Model = "models/tdmcars/for_raptor.mdl",
    Price = 200000,
    Health = 130,
    Speed = 60,
    GasTank = 400,
    StrengthText = "Extremely Strong",
    RepairCost = 700,
    SeatsNum = 4,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(23, 12, 33), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(23, 17, 35), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(43, 82, 60), Angle(0,90,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-42, 80, 60), Angle(0,-90,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-20, 23, 37), Angle(0,0,10))
    end,
	Headlights = Vector(35, 118, 48),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

-- Great car, sounds are broken :(
--[[GM.OCRP_Cars["FORD_GT"] = {
    Name = "Ford GT",
    OtherName = "FORD_GT",
    Desc = "GTA?",
    Script = "scripts/vehicles/tdmcars/gt05.txt",
    Model = "models/tdmcars/gt05.mdl",
    Price = 50000,
    Health = 100,
    Speed = 70,
    GasTank = 600,
    StrengthText = "Strong",
    RepairCost = 1500,
    SeatsNum = 2,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -5, 8), Angle(0,0,10))
    end,
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}]]

GM.OCRP_Cars["FORD_DELUXE_COUPE"] = {
    Name = "Ford Deluxe Coupe 1940",
    OtherName = "FORD_DELUXE_COUPE",
    Desc = "This thing is pimpin",
    Script = "scripts/vehicles/tdmcars/coupe40.txt",
    Model = "models/tdmcars/ford_coupe_40.mdl",
    Price = 30000,
    Health = 100,
    Speed = 45,
    GasTank = 700,
    StrengthText = "Strong",
    RepairCost = 250,
    SeatsNum = 2,
    Skin_Price = 3000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(14, -9, 27), Angle(0,0,10))
    end,
	Headlights = Vector(28, 100, 34),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["NISSAN_SKYLINE"] = {
    Name = "Nissan Skyline",
    OtherName = "NISSAN_SKYLINE",
    Desc = "City Skylines 2",
    Script = "scripts/vehicles/tdmcars/skyline_r34.txt",
    Model = "models/tdmcars/skyline_r34.mdl",
    Price = 315000,
    Health = 100,
    Speed = 80,
    GasTank = 600,
    StrengthText = "Strong",
    RepairCost = 400,
    SeatsNum = 4,
    Skin_Price = 5500,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 4, 18), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-16, 39, 16), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-15, 42, 18), Angle(0,0,10))
    end,
	Headlights = Vector(27, 98, 31),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["NISSAN_350Z"] = {
    Name = "Nissan 350z",
    OtherName = "NISSAN_350Z",
    Desc = "Nissan dayZ",
    Script = "scripts/vehicles/tdmcars/350z.txt",
    Model = "models/tdmcars/350z.mdl",
    Price = 125000,
    Health = 100,
    Speed = 80,
    GasTank = 650,
    StrengthText = "Strong",
    RepairCost = 650,
    SeatsNum = 2,
    Skin_Price = 6000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-18, -11, 12), Angle(0,0,10))
    end,
	Headlights = Vector(30, 84, 32),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["NISSAN_370Z"] = {
    Name = "Nissan 370z",
    OtherName = "NISSAN_370Z",
    Desc = "Nissan Da- wait this isn't even in dayz",
    Script = "scripts/vehicles/tdmcars/370z.txt",
    Model = "models/tdmcars/nis_370z.mdl",
    Price = 175000,
    Health = 95,
    Speed = 85,
    GasTank = 650,
    StrengthText = "Strong",
    RepairCost = 700,
    SeatsNum = 2,
    Skin_Price = 7500,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(19, 10, 13), Angle(0,0,10))
    end,
	Headlights = Vector(32, 86, 34),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["NISSAN_GT-R"] = {
    Name = "Nissan GT-R",
    OtherName = "NISSAN_GT-R",
    Desc = "GTA?",
    Script = "scripts/vehicles/tdmcars/gtr.txt",
    Model = "models/tdmcars/nissan_gtr.mdl",
    Price = 450000,
    Health = 100,
    Speed = 100,
    GasTank = 700,
    StrengthText = "Strong",
    RepairCost = 1750,
    SeatsNum = 2,
    Skin_Price = 7500,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 10, 16), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(16, 49, 21), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-16, 46, 21), Angle(0,0,10))
    end,
	Headlights = Vector(31, 99, 35),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["VW_CAMPER"] = {
    Name = "VW Camper",
    OtherName = "VW_CAMPER",
    Desc = "Aww yiss. Campin'.",
    Script = "scripts/vehicles/tdmcars/vwcamper.txt",
    Model = "models/tdmcars/vw_camper65.mdl",
    Price = 50000,
    Health = 100,
    Speed = 40,
    GasTank = 350,
    StrengthText = "Strong",
    RepairCost = 300,
    SeatsNum = 7,
    Skin_Price = 1250,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(18, 44, 33), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(25, 45, 33), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(2, 44, 33), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-23, 45, 33), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-25, 12, 33), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-4, 12, 33), Angle(0,0,10))
    end,
	Headlights = Vector(24, 90, 38),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["VW_BEETLE_CONV"] = {
    Name = "VW Beetle Convertible",
    OtherName = "VW_BEETLE_CONV",
    Desc = "SQUASH IT!",
    Script = "scripts/vehicles/tdmcars/vwbeetleconv.txt",
    Model = "models/tdmcars/vw_beetleconv.mdl",
    Price = 50000,
    Health = 75,
    Speed = 60,
    GasTank = 300,
    StrengthText = "Weak",
    RepairCost = 350,
    SeatsNum = 4,
    Skin_Price = 1250,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(17, 0, 18), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(14, 40, 18), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-11, 40, 18), Angle(0,0,10))
    end,
	Headlights = Vector(31, 82, 35),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["PORSCHE_911"] = {
    Name = "Porsche 911 GT3-RSR",
    OtherName = "PORSCHE_911",
    Desc = "Formula One",
    Script = "scripts/vehicles/tdmcars/porgt3rsr.txt",
    Model = "models/tdmcars/por_gt3rsr.mdl",
    Price = 815000,
    Health = 100,
    Speed = 110,
    GasTank = 500,
    StrengthText = "Strong",
    RepairCost = 750,
    SeatsNum = 1,
    Skin_Price = 8000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(31, 83, 29),
    Skins = {
		--{skin = 0, name = "White"}
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["PORSCHE_997"] = {
    Name = "Porsche 997 GT3",
    OtherName = "PORSCHE_997",
    Desc = "Full synergy",
    Script = "scripts/vehicles/tdmcars/997gt3.txt",
    Model = "models/tdmcars/997gt3.mdl",
    Price = 685000,
    Health = 100,
    Speed = 90,
    GasTank = 450,
    StrengthText = "Strong",
    RepairCost = 850,
    SeatsNum = 2,
    Skin_Price = 8000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(18, 1, 14), Angle(0,0,10))
    end,
	Headlights = Vector(30, 82, 38),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["PORSCHE_918"] = {
    Name = "Porsche 918 Spyder",
    OtherName = "PORSCHE_918",
    Desc = "Saw one in my shower",
    Script = "scripts/vehicles/tdmcars/918spyd.txt",
    Model = "models/tdmcars/por_918.mdl",
    Price = 1250000,
    Health = 90,
    Speed = 115,
    GasTank = 500,
    StrengthText = "Strong",
    RepairCost = 900,
    SeatsNum = 2,
    Skin_Price = 8000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(16, 3, 11), Angle(0,0,10))
    end,
	Headlights = Vector(35, 90, 34),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["LANDROVER"] = {
    Name = "Range Rover 2008",
    OtherName = "LANDROVER",
    Desc = "The driving range",
    Script = "scripts/vehicles/tdmcars/landrover.txt",
    Model = "models/tdmcars/landrover.mdl",
    Price = 300000,
    Health = 130,
    Speed = 65,
    GasTank = 450,
    StrengthText = "Extremely Strong",
    RepairCost = 750,
    SeatsNum = 4,
    Skin_Price = 5500,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(21, 3, 32), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(21, 48, 32), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-21, 49, 32), Angle(0,0,10))
    end,
	Headlights = Vector(33, 108, 42),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["LANDROVER_DEFENDER"] = {
    Name = "Landrover Defender",
    OtherName = "LANDROVER_DEFENDER",
    Desc = "The beast.",
    Script = "scripts/vehicles/tdmcars/lrdefender.txt",
    Model = "models/tdmcars/landrover_defender.mdl",
    Price = 300000,
    Health = 110,
    Speed = 55,
    GasTank = 550,
    StrengthText = "Very Strong",
    RepairCost = 650,
    SeatsNum = 4,
    Skin_Price = 2000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-19, -16, 48), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(32, 64, 52), Angle(0,90,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-34, 65, 51), Angle(0,-90,10))
    end,
	Headlights = Vector(27, 81, 56),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["LANDROVER12"] = {
    Name = "Range Rover 2012",
    OtherName = "LANDROVER12",
    Desc = "Rovin' da Lands.",
    Script = "scripts/vehicles/tdmcars/landrover12.txt",
    Model = "models/tdmcars/landrover12.mdl",
    Price = 375000,
    Health = 135,
    Speed = 70,
    GasTank = 550,
    StrengthText = "Extremely Strong",
    RepairCost = 600,
    SeatsNum = 4,
    Skin_Price = 6000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-20, -4, 33), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(19, -49, 34), Angle(0,0,10))
        GAMEMODE.CreatePassengerSeat(Entity, Vector(-19, -49, 33), Angle(0,0,10))
    end,
	Headlights = Vector(33, 113, 45),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["c5500"] = {
    Name = "Box Truck",
    OtherName = "c5500",
    Desc = "So boxy it's about to pick Riven",
    Script = "scripts/vehicles/tdmcars/c5500.txt",
    Model = "models/tdmcars/trucks/gmc_c5500.mdl",
    Price = 500000,
    Health = 175,
    Speed = 55,
    GasTank = 500,
    StengthText = "Insanely Strong",
    RepairCost = 800,
    SeatsNum = 2,
    Skin_Price = 10000,
    Seats = function(ply, Entity)
        GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -29, 38), Angle(0,0,10))
    end,
	Headlights = Vector(37, 117, 39),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
    },
    MovePos = Vector(0,0,0)
}
--[[GM.OCRP_Cars["CAR_BMW_M5"] = {
	Name = "BMW M5",
	OtherName = "CAR_BMW_M5", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/bmw.txt",
	Model = "models/sickness/bmw-m5.mdl",
	Price = 55500,
	Health = 100,
	Speed = 60,
	GasTank = 800,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 5000,
	Skins = {
				{skin = 0, name = "White"},
				{skin = 1, name = "Red"},
				{skin = 2, name = "Purple"},
				{skin = 3, name = "Navy"},
				{skin = 4, name = "Green"},
				{skin = 5, name = "Dark Red"},
				{skin = 6, name = "Black"},
				{skin = 7, name = "Light Blue"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -5, 8), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 30, 5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 30, 5), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_SHELBY"] = {
	Name = "Shelby",
	OtherName = "CAR_SHELBY", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/shelby.txt",
	Model = "models/shelby/shelby.mdl",
	Price = 255000,
	Health = 100,
	Speed = 60,
	GasTank = 800,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 5000,
	Skins = {
				{skin = 0, name = "White"},
				{skin = 1, name = "Red"},
				{skin = 2, name = "Blue"},
				{skin = 3, name = "Silver"},
				{skin = 4, name = "Orange"},
				{skin = 5, name = "Light Blue"},
				{skin = 6, name = "Green"},
				{skin = 7, name = "Black"},
				{skin = 8, name = "Brown"},
				{skin = 9, name = "Purple"},
				{skin = 10, name = "Pink"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(16, 4, 13), Angle(0, 0, 10));
			end,
	MovePos = Vector(0,0,0),
	Exits = { Vector( -72.3996, -6.1857, 1.8621 ), Vector(72.3996, -0.1439, 0.3239) },
}

GM.OCRP_Cars["CAR_ORACLE"] = {
	Name = "Oracle XS Sedan",
	OtherName = "CAR_ORACLE", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/oracle.txt",
	Model = "models/sickness/oracledr.mdl",
	Price = 75000,
	Health = 100,
	Speed = 70,
	GasTank = 650,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 5600,
	Skins = {
				{skin = 0, name = "Black"},
				{skin = 1, name = "White"},
				{skin = 2, name = "Red"},
				{skin = 3, name = "Green"},
				{skin = 4, name = "Dark Blue"},
				{skin = 5, name = "Dark Red"},
				{skin = 6, name = "Purple"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -8, 15), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 35, 18.5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 35, 18.5), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_ROLLS"] = {
	Name = "Rolls Royce Phantom",
	OtherName = "CAR_ROLLS", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/roller.txt",
	Model = "models/sickness/superddr.mdl",
	Price = 1750000,
	Health = 100,
	Speed = 60,
	GasTank = 850,
	StrengthText = "Strong",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 10000,
	Skins = {
				{skin = 0, name = "Carbon Black"},
				{skin = 1, name = "Carbon White"},
				{skin = 2, name = "Carbon Silver"},
				{skin = 3, name = "Carbon Red"},
				{skin = 4, name = "Purple Blue"},
				{skin = 5, name = "Carbon Light Blue"},
				{skin = 6, name = "Carbon Marine"},
				{skin = 7, name = "Carbon Dark Green"},
				{skin = 8, name = "Carbon Baby Red"},
				{skin = 9, name = "Carbon Baby Blue"},
				{skin = 10, name = "Carbon Dark Red"},
				{skin = 11, name = "Carbon Cream"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(17, 45, 20.5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 45, 20.5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -6, 20), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_BUGGY"] = {
	Name = "Ex-Military Desert Rat",
	OtherName = "CAR_BUGGY", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/bf2buggy.txt",
	Model = "models/bf2bb.mdl",
	Price = 150000,
	Health = 150,
	Speed = 80,
	GasTank = 650,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 5600,
	Skins = {
				{skin = 0, name = "Rustic"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(0, 95, 58), Angle(0, 0 ,-10))
			end,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_EMPEROR"] = {
	Name = "Lincoln Emperor",
	OtherName = "CAR_EMPEROR", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/emperor.txt",
	Model = "models/sickness/emperordr.mdl",
	Price = 30000,
	Health = 100,
	Speed = 70,
	GasTank = 650,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 5600,
	Skins = {
				{skin = 0, name = "Black"},
				{skin = 1, name = "White"},
				{skin = 2, name = "Grey"},
				{skin = 3, name = "Red"},
				{skin = 4, name = "Green"},
				{skin = 5, name = "Blue"},
			
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -8, 15), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 35, 14), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 35, 14), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_GOLF"] = {
	Name = "VW Golf GTi",
	OtherName = "CAR_GOLF", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/golf.txt",
	Model = {
				"models/golf/golf.mdl",
				"models/golf/gol2.mdl",
				"models/golf/gol3.mdl",
			},
	Price = 60000,
	Health = 100,
	Speed = 70,
	GasTank = 650,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 5200,
	Skins = {
				{skin = 0, name = "Grey"},
				{skin = 1, name = "Blue"},
				{skin = 2, name = "Green"},
				{skin = 0, name = "Red"},
				{skin = 1, name = "Yellow"},
				{skin = 2, name = "Black"},
				{skin = 0, name = "Purple"},
				{skin = 1, name = "Taxi"},
				{skin = 2, name = "Light Blue"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 5, 15), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 57, 17), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 57, 17), Angle(0, 0 ,10))
			end,
	MovePos = Vector(20,5,10),
}

GM.OCRP_Cars["CAR_BLISTA"] = {
	Name = "Blista Sport",
	OtherName = "CAR_BLISTA", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/blista.txt",
	Model = 	"models/sickness/blistadr.mdl",
	Price = 40000,
	Health = 100,
	Speed = 60,
	GasTank = 650,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 5200,
	Skins = {
				{skin = 0, name = "Black"},
				{skin = 1, name = "White"},
				{skin = 2, name = "Red"},
				{skin = 3, name = "Green"},
				{skin = 4, name = "Blue"},
				{skin = 5, name = "Yellow"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 5, 15), Angle(0, 0 ,10))
				--GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 57, 17), Angle(0, 0 ,10))
				--GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 57, 17), Angle(0, 0 ,10))
			end,
	MovePos = Vector(20,5,10),
}


GM.OCRP_Cars["CAR_LIMO"] = {
	Name = "Dundreary Stretch Limousine",
	OtherName = "CAR_LIMO", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/stretch.txt",
	Model = "models/sickness/stretchdr.mdl",
	Price = 350000,
	Health = 120,
	Speed = 60,
	GasTank = 300,
	StrengthText = "Strong",
	RepairCost = 1000,
	SeatsNum = 8,
	Skin_Price = 8000,
	Skins = {
				{skin = 0, name = "Black"},
				{skin = 1, name = "White"},
				{skin = 2, name = "Grey"},
				{skin = 3, name = "Red"},
				{skin = 4, name = "Dark Green Fade"},
				{skin = 5, name = "Dark Turq"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-22,112,18), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(22,112,18), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-18,0,18), Angle(0, -90 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-18,28,18), Angle(0, -90 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-18,56,18), Angle(0, -90 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(22,-48,18), Angle(0, 0 ,10))			
			end,
	Exits = {
				Vector(-90,36,22),
				Vector(82,36,22),
				Vector(22,24,90),
				Vector(2,100,30),
			},
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_HUMMER"] = {
	Name = "Hummer H2",
	OtherName = "CAR_HUMMER", -- For the hell of it.
	Desc = "A nice sleek, hummer, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/hummer.txt",
	Model = "models/sickness/hummer-h2.mdl",
	Price = 80000,
	Health = 150,
	Speed = 55,
	GasTank = 300,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 6000,
	Skins = {
				{skin = 0, name = "Red"},
				{skin = 1, name = "Black"},
				{skin = 2, name = "Silver"},
				{skin = 3, name = "White"},
				{skin = 4, name = "Green"},
				{skin = 5, name = "Blue"},
				{skin = 6, name = "Gray"},
				{skin = 8, name = "Yellow"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, -14, 36), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, 20, 36), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-25, 20, 36), Angle(0, 0 ,10))
			end,
	Exits = {
				Vector(-85.4888, 32.0606, 70),
				Vector(-85.7425, -21.2776, 70),
				Vector(85.3276, -25.8024, 70),
				Vector(85.5768, 35.7472, 70),
			},
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_BUS"] = {
	Name = "City Bus",
	OtherName = "CAR_BUS", -- For the hell of it.
	Desc = "A nice sleek van, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/evotrans.txt",
	Model = "models/sickness/gtabus.mdl",
	Price = 155000,
	Health = 150,
	Speed = 40,
	GasTank = 400,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 17,
	Skin_Price = 6000,
	Skins = {
				{skin = 0, name = "Green"},
				{skin = 1, name = "Blue"},
				{skin = 2, name = "Black"},
				{skin = 3, name = "Full Black"},
				{skin = 4, name = "Red"},
				{skin = 5, name = "Full White"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(40, -100, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -100, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-40, -100, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-20, -100, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(40, -70, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -70, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-40, -70, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-20, -70, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(40, -40, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -40, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-40, -40, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-20, -40, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(40, -10, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -10, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-40, -10, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-20, -10, 52), Angle(0, 0 ,0))
			
			end,
	-- Exits = {
				-- Vector(75.4888, 12.0606, 20.5582),
				-- Vector(-75.7425, 12.2776, 20.6878),
				-- Vector(-75.7425, -40, 20.6878),
			-- },
	MovePos = Vector(0,0,0),
}


GM.OCRP_Cars["CAR_VAN"] = {
	Name = "Vapid ST Van MK2",
	OtherName = "CAR_VAN", -- For the hell of it.
	Desc = "A nice sleek van, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/van.txt",
	Model = "models/sickness/speedodr.mdl",
	Price = 55000,
	Health = 150,
	Speed = 65,
	GasTank = 400,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 6,
	Skin_Price = 6000,
	Skins = {
				{skin = 0, name = "Black"},
				{skin = 1, name = "White"},
				{skin = 2, name = "Red"},
				{skin = 3, name = "Pale Green"},
				{skin = 4, name = "Pale Blue"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(22, -30, 30), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, 52, 33), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, 67, 33), Angle(0, 180 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-25, 52, 33), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-25, 67, 33), Angle(0, 180 ,0))
			end,
	Exits = {
				Vector(75.4888, 12.0606, 20.5582),
				Vector(-75.7425, 12.2776, 20.6878),
				Vector(-75.7425, -40, 20.6878),
			},
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_MINIVAN"] = {
	Name = "Vapid Minivan Sport",
	OtherName = "CAR_MINIVAN", -- For the hell of it.
	Desc = "A nice sleek minivan, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/minivan.txt",
	Model = "models/sickness/minivandr.mdl",
	Price = 60000,
	Health = 100,
	Speed = 60,
	GasTank = 500,
	StrengthText = "Average Strength",
	RepairCost = 1000,
	SeatsNum = 5,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "Black"},
				{skin = 1, name = "White"},
				{skin = 2, name = "Grey"},
				{skin = 3, name = "Purple/Maroon"},
				{skin = 4, name = "Dark Green"},
				{skin = 5, name = "Dark Turq."},
				{skin = 6, name = "Taxi Yellow"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(18,-13,19.5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(18,31,19.5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(0,31,19.5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-18,31,19.5), Angle(0, 0 ,10))
			end,
	Exits = {
				Vector(-90,36,22),
				Vector(82,36,22),
				Vector(-90,18,22),
				Vector(82,18,22),
			},
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_PMP"] = {
	Name = "PMP600",
	OtherName = "CAR_PMP", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/pmp600.txt",
	Model = "models/sickness/pmp600dr.mdl",
	Price = 69500,
	Health = 100,
	Speed = 60,
	GasTank = 550,
	StrengthText = "Strong",
	RepairCost = 3000,
	SeatsNum = 4,
	Skin_Price = 9000,
	Skins = {
				{skin = 0, name = "Grey"},
				{skin = 1, name = "White"},
				{skin = 2, name = "Dark Pink"},
				{skin = 3, name = "Dark Green"},
				{skin = 4, name = "Turquoise"},
				{skin = 5, name = "Purple"},
				{skin = 6, name = "Orange"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -1, 10), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 20, 10), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-20, 20, 10), Angle(0, 0 ,10))
			end,
	MovePos = {Vec = Vector(-18,8,18), Ang = Angle(0,90,0)},
}

GM.OCRP_Cars["CAR_ASTON"] = {
	Name = "Aston Martin Vanquish",
	OtherName = "CAR_ASTON", -- For the hell of it.
	Desc = "The British pride. This car beats them all on the track!",
	Script = "scripts/vehicles/vanquish.txt",
	Model = "models/sickness/vanquish.mdl",
	Price = 300000,
	Health = 120,
	Speed = 90,
	GasTank = 800,
	StrengthText = "Strong",
	RepairCost = 3000,
	SeatsNum = 2,
	Skin_Price = 7000,
	Skins = {
				{skin = 0, name = "Green"},
				{skin = 1, name = "Blue"},
				{skin = 2, name = "Dark Blue"},
				{skin = 3, name = "White"},
				{skin = 4, name = "Red"},
				{skin = 5, name = "Black"},
				{skin = 6, name = "Cream"},
				{skin = 7, name = "Forest Green"},
				{skin = 8, name = "Brown"},

			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, 10, 15), Angle(0, 0, 20))
			end,
	MovePos = {Vec = Vector(-23, -30, 20), Ang = Angle(0, 90, 0)}
}


GM.OCRP_Cars["CAR_LAMBO"] = {
	Name = "Lamborghini Miura SV",
	OtherName = "CAR_LAMBO", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/lambo.txt",
	Model = "models/lambo/lambo.mdl",
	Price = 225000,
	Health = 120,
	Speed = 85,
	GasTank = 800,
	StrengthText = "Strong",
	RepairCost = 3000,
	SeatsNum = 2,
	Skin_Price = 7000,
	Skins = {
				{skin = 0, name = "White"},
				{skin = 1, name = "Red"},
				{skin = 2, name = "Blue"},
				{skin = 3, name = "Silver"},
				{skin = 4, name = "Orange"},
				{skin = 5, name = "Light Blue"},
				{skin = 6, name = "Green"},
				{skin = 7, name = "Black"},
				{skin = 8, name = "Brown"},
				{skin = 9, name = "Purple"},
				{skin = 10, name = "Pink"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, 10, 15), Angle(0, 0, 20))
			end,
	MovePos = {Vec = Vector(-23, -30, 20), Ang = Angle(0, 90, 0)}
}

GM.OCRP_Cars["CAR_STALLION"] = {
	Name = "Stallion GTO",
	OtherName = "CAR_STALLION", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/stallion.txt",
	Model = "models/sickness/stalliondr.mdl",
	Price = 110000,
	Health = 120,
	Speed = 85,
	GasTank = 800,
	StrengthText = "Strong",
	RepairCost = 3000,
	SeatsNum = 2,
	Skin_Price = 5000,
	Skins = {
				{skin = 0, name = "Black"},
				{skin = 1, name = "White"},
				{skin = 2, name = "Red"},
				{skin = 3, name = "Green"},
				{skin = 4, name = "Blue"},
				{skin = 5, name = "Yellow"},

			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 10, 10), Angle(0, 0, 20))
			end,
	MovePos = Vector(0,0,0) --{Vec = Vector(-23, -30, 20), Ang = Angle(0, 90, 0)}
}

GM.OCRP_Cars["CAR_VIRGO"] = {
	Name = "Lincoln Virgo",
	OtherName = "CAR_VIRGO", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/virgo.txt",
	Model = "models/sickness/virgodr.mdl",
	Price = 100000,
	Health = 120,
	Speed = 85,
	GasTank = 800,
	StrengthText = "Strong",
	RepairCost = 3000,
	SeatsNum = 2,
	Skin_Price = 5000,
	Skins = {
				{skin = 0, name = "Black"},
				{skin = 1, name = "White"},
				{skin = 2, name = "Red"},
				{skin = 3, name = "Green"},
				{skin = 4, name = "Blue"},

			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 10, 10), Angle(0, 0, 20))
			end,
	MovePos = Vector(0,0,0) --{Vec = Vector(-23, -30, 20), Ang = Angle(0, 90, 0)}
}

GM.OCRP_Cars["CAR_CATERHAM"] = {
	Name = "Caterham Roadster",
	OtherName = "CAR_CATERHAM", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/caterham.txt",
	Model = "models/caterham/caterham.mdl",
	Price = 289500,
	Health = 80,
	Speed = 100,
	GasTank = 350,
	StrengthText = "Weak",
	RepairCost = 6000,
	SeatsNum = 2,
	Skin_Price = 10000,
	Skins = {
				{skin = 0, name = "White"},
				{skin = 1, name = "Red"},
				{skin = 2, name = "Blue"},
				{skin = 3, name = "Grey"},
				{skin = 4, name = "Orange"},
				{skin = 5, name = "Light Blue"},
				{skin = 6, name = "Green"},
				{skin = 7, name = "Black"},
				{skin = 8, name = "Brown"},
				{skin = 9, name = "Purple"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(12, 30, 10), Angle(0, 0, 10))
			end,
	MovePos = {Vec = Vector(-10,-45,15), Ang = Angle(0, 90, 0)}
}

GM.OCRP_Cars["CAR_MINI"] = {
	Name = "Mini",
	OtherName = "CAR_MINI", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/mini.txt",
	Model = "models/mini/mini.mdl",
	Price = 29500,
	Health = 80,
	Speed = 50,
	GasTank = 600,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 4000,
	Skins = {
				{skin = 0, name = "White"},
				{skin = 1, name = "Red"},
				{skin = 2, name = "Blue"},
				{skin = 3, name = "Silver"},
				{skin = 4, name = "Orange"},
				{skin = 5, name = "Light Blue"},
				{skin = 6, name = "Green"},
				{skin = 7, name = "Black"},
				{skin = 8, name = "Brown"},
				{skin = 9, name = "Purple"},
				{skin = 10, name = "Pink"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-14, -6, 10), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(14, 36, 10), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-14, 36, 10), Angle(0, 0 ,0))
			end,
	MovePos = {Vec = Vector(14, -6, 18), Ang = Angle(0, 90, 0)}
}

GM.OCRP_Cars["CAR_CORVETTE"] = {
	Name = "Corvette",
	OtherName = "CAR_CORVETTE", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/corvette.txt",
	Model = {
				"models/corvette/corvette.mdl",
				"models/corvette/corvett2.mdl",
				"models/corvette/corvett3.mdl",
				"models/corvette/corvett4.mdl",
				"models/corvette/corvetoc.mdl",
			},
	Price = 115000,
	Health = 120,
	Speed = 75,
	GasTank = 700,
	StrengthText = "Strong",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 6000,
	Skins = {
				{skin = 0, name = "Blue"},
				{skin = 1, name = "Silver"},
				{skin = 2, name = "Yellow"},
				{skin = 0, name = "Red"},
				{skin = 1, name = "Green"},
				{skin = 2, name = "Black"},
				{skin = 0, name = "Purple"},
				{skin = 0, name = "Special", Org = 99},
				{skin = 2, name = "Light Blue"},
				{skin = 1, name = "Blue with Stripes"},
				{skin = 2, name = "Yellow with Stripes"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(23, 15, 13), Angle(0, 0, 10))
			end,
	MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["CAR_VOODOO"] = {
	Name = "Voodoo SS",
	OtherName = "CAR_VOODOO", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/lowrider.txt",
	Model = "models/sickness/voodoodr.mdl",
	Price = 50000,
	Health = 120,
	Speed = 45,
	GasTank = 500,
	StrengthText = "Strong",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "Blue/White"},
				{skin = 1, name = "Black/White"},
				{skin = 2, name = "Green/White"},
				{skin = 3, name = "White/Light Blue"},
				{skin = 4, name = "Orange/White"},
				{skin = 5, name = "Purple/White"},
				{skin = 6, name = "Purple/Black"},
				{skin = 7, name = "Black/Light Blue"},
				{skin = 8, name = "Green/Black"},
				{skin = 9, name = "Dark Blue/Light Blue"},
				{skin = 10, name = "Orange/Black"},
				{skin = 11, name = "Orange/Purple"},
				
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -8, 12), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 33, 10), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 33, 10), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["CAR_ESCALADE"] = {
	Name = "Albany Cavalcade RS",
	OtherName = "CAR_ESCALADE", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/escalade.txt",
	Model = "models/sickness/cavalcadedr.mdl",
	Price = 62500,
	Health = 160,
	Speed = 52,
	GasTank = 400,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 5,
	Skin_Price = 6500,
	Skins = {
				{skin = 0, name = "Black"},
				{skin = 1, name = "White"},
				{skin = 2, name = "Grey"},
				{skin = 3, name = "Dark Pink"},
				{skin = 4, name = "Green"},
				{skin = 5, name = "Turquoise"},				
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -8, 30), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(22, 35, 30), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(0, 35, 30), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-22, 35, 30), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0)
}


GM.OCRP_Cars["CAR_YANKEE"] = {
	Name = "DS9 Yankee Truck",
	OtherName = "CAR_YANKEE", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/yankee.txt",
	Model = {
				"models/sickness/yankeedr.mdl",
				"models/yankee/yankeedr1.mdl",
			},
	Price = 69500,
	Health = 150,
	Speed = 50,
	GasTank = 500,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "White"},
				{skin = 1, name = "MTL Black"},
				{skin = 2, name = "Brown"},
				{skin = 3, name = "Blue"},
				{skin = 4, name = "EDOT Orange"},
				{skin = 4, name = "CosmosFM", dj = "true"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(23, -42, 52), Angle(0, 0, 0))
			end,
	MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["CAR_MULE"] = {
	Name = "Maibatsu Mule Cargo Truck",
	OtherName = "CAR_MULE", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/mulebox.txt",
	Model = "models/sickness/muledr.mdl",
	Price = 75500,
	Health = 150,
	Speed = 60,
	GasTank = 500,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "White"},
				{skin = 1, name = "MTL Black"},
				{skin = 2, name = "Brown"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(23, -109, 60), Angle(0, 0, 0))
			end,
	MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["CAR_INTER"] = {
	Name = "International 2674 Truck",
	OtherName = "CAR_INTER", -- For the hell of it.
	Desc = "Perfect to transport large objects and vehicles.",
	Script = "scripts/vehicles/international_2674.txt",
	Model = "models/sickness/international_2674.mdl",
	Price = 69500,
	Health = 150,
	Speed = 50,
	GasTank = 500,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "Edot"},
				{skin = 1, name = "MTL Blue"},
				{skin = 2, name = "White"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -30, 55), Angle(0, 0, 0))
			end,
	MovePos = Vector(0,0,0)
}


GM.OCRP_Cars["CAR_PHANTOM"] = {
	Name = "Phantom SemiTruck",
	OtherName = "CAR_PHANTOM", -- For the hell of it.
	Desc = "A tank.",
	Script = "scripts/vehicles/phantom.txt",
	Model = "models/sickness/phantomdr.mdl",
	Price = 99500,
	Health = 500,
	Speed = 50,
	GasTank = 1000,
	StrengthText = "TAAAAANK",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "White"},
				{skin = 1, name = "Black"},
				{skin = 2, name = "Brown"},
				{skin = 3, name = "Semi Turquoise"},
				{skin = 4, name = "Orange"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -30, 55), Angle(0, 0, 0))
			end,
	MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["CAR_HUNTLEY"] = {
	Name = "Vapid Hunltey Sport 4x4",
	OtherName = "CAR_HUNTLEY", -- For the hell of it.
	Desc = "Sports SUV with a range of colours.",
	Script = "scripts/vehicles/sports-suv.txt",
	Model = "models/sickness/huntleydr.mdl",
	Price = 130000,
	Health = 150,
	Speed = 50,
	GasTank = 420,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 5,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "Black/White"},
				{skin = 1, name = "Blue/White"},
				{skin = 2, name = "Red/White"},
				{skin = 3, name = "Maroon/White"},
				{skin = 4, name = "Green/White"},
				{skin = 6, name = "White"},
				{skin = 7, name = "Black/Blue"},
				{skin = 8, name = "Black/Red"},
				{skin = 9, name = "Black/Maroon"},
				{skin = 10, name = "Black/Green"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 1, 30), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(22, 50, 35), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(0, 50, 35), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-22, 50, 35), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["CAR_ATV"] = {
	Name = "ATV",
	OtherName = "CAR_ATV", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/rubicon.txt",
	Model = {
				"models/rubicon.mdl",
				"models/rubicon2.mdl",
			},
	Price = 1500,
	Health = 60,
	Speed = 30,
	GasTank = 125,
	StrengthText = "Weak",
	RepairCost = 500,
	SeatsNum = 1,
	Skin_Price = 3000,
	Skins = {
				{skin = 0, name = "Red"},
				{skin = 1, name = "Blue"},
				{skin = 2, name = "Black"},
				{skin = 0, name = "Orange"},
				{skin = 1, name = "Green"},
				{skin = 2, name = "Pink"},
			},
	Seats = function( ply, Entity )
			end,
	MovePos = {Vec = Vector(0, -23, 40), Ang = Angle(25, 90, 0)}
}

GM.OCRP_Cars["CAR_MURC"] = {
	Name = "Murcielago",
	OtherName = "CAR_MURC", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/murcielago.txt",
	Model = {	
				"models/sickness/murcielago.mdl",
				"models/sickness/murcielag1.mdl",
			},
	Price = 300000,
	Health = 60,
	Speed = 30,
	GasTank = 600,
	StrengthText = "Strong",
	RepairCost = 500,
	SeatsNum = 2,
	Skin_Price = 3000,
	Skins = {
				{skin = 0, name = "Yellow"},
				{skin = 1, name = "Black"},
				{skin = 2, name = "Orange"},
				{skin = 3, name = "Grey/Silver"},
				{skin = 4, name = "Purple"},
				{skin = 5, name = "Lime"},
				{skin = 6, name = "Light Blue"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(50, 0, 5), Angle(0, 0, 0))
			end,
	MovePos = {Vec = Vector(0, -23, 40), Ang = Angle(25, 90, 0)}
}

GM.OCRP_Cars["Police"] = {
	Model = "models/sickness/lcpddr.mdl",
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 0, 13), Angle(0, 0, 10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 28, 13), Angle(0, 0, 10))	
				GAMEMODE.CreatePassengerSeat(Entity, Vector(5, 28, 13), Angle(0, 0, 10))
			end,
	Exits = {},
	GasTank = 1,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["Police_NEW"] = {
	Model = "models/tdmcars/copcar.mdl",
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 0, 13), Angle(0, 0, 10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 28, 13), Angle(0, 0, 10))	
				GAMEMODE.CreatePassengerSeat(Entity, Vector(5, 28, 13), Angle(0, 0, 10))
			end,
	Exits = {},
	GasTank = 1,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["Ambo"] = {
	Model = "models/sickness/meatwagon.mdl",
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, -53, 34), Angle(0, 0, 10))
			end,
	Exits = {
				Vector(-70.3399, 70.0193, 0.2515),
				Vector(70.520, 59.9409, 0.3834),
			},
	GasTank = 1,		
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["Fire"] = {
	Model = "models/sickness/truckfire.mdl",
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(23, -121, 46), Angle(0, 0, 0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(23, -60, 46), Angle(0, 0, 0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-23, -60, 46), Angle(0, 0, 0))
			end,
	Exits = {
				Vector(104, 133, -2),
				Vector(104, 68, -2),
				Vector(-104, 133, -2),
				Vector(-104, 68, -2),
			},
	GasTank = 1,		
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["SWAT"] = {
	Model = "models/sickness/stockade2dr.mdl",
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(23, -31, 50), Angle(0, 0, 0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(28, 100, 50), Angle(0, 90, 0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-28, 100, 50), Angle(0, 270, 0))
			end,
	Exits = {
				Vector(104, 133, -2),
				Vector(104, 68, -2),
				Vector(-104, 133, -2),
				Vector(-104, 68, -2),
			},
	GasTank = 1,		
	MovePos = Vector(0,0,0),
}
]]
-- SECOND ADDITIONS START HERE, PRICING UNDONE
GM.OCRP_Cars["BMW_E34"] = {
    Name = "BMW M5 E34",
    OtherName = "BMW_E34",
    Desc = "The ultimate driving machine.",
    Script = "scripts/vehicles/tdmcars/bmwm5e34.txt",
    Model = "models/tdmcars/bmwm5e34.mdl",
    Price = 150000,
    Health = 95,
    Speed = 75,
    GasTank = 400,
    StrengthText = "Strong",
    RepairCost = 750,
    SeatsNum = 4,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(29, 107, 32),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["BMW_E60"] = {
    Name = "BMW M5 E60",
    OtherName = "BMW_E60",
    Desc = "The ultimater driving machine.",
    Script = "scripts/vehicles/tdmcars/bmwm5e60.txt",
    Model = "models/tdmcars/bmwm5e60.mdl",
    Price = 250000,
    Health = 95,
    Speed = 90,
    GasTank = 425,
    StrengthText = "Strong",
    RepairCost = 750,
    SeatsNum = 4,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(32, 102, 34),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["BUG_VEYRON_SS"] = {
    Name = "Bugatti Veyron SS",
    OtherName = "BUG_VEYRON_SS",
    Desc = "I just came",
    Script = "scripts/vehicles/tdmcars/veyronss.txt",
    Model = "models/tdmcars/bug_veyronss.mdl",
    Price = 1100000,
    Health = 90,
    Speed = 115,
    GasTank = 350,
    StrengthText = "Below Average",
    RepairCost = 1500,
    SeatsNum = 2,
    Skin_Price = 10000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(33, 95, 30),
    Skins = {
        --{skin = 0, name = "Default"},
    },
    MovePos = Vector(0,0,0)
}
--[[GM.OCRP_Cars["CHEV_BLAZER"] = {
    Name = "Chevrolet Blazer",
    OtherName = "CHEV_BLAZER",
    Desc = "Like the deagle?",
    Script = "scripts/vehicles/tdmcars/blazer.txt",
    Model = "models/tdmcars/chev_blazer.mdl",
    Price = 50000,
    Health = 105,
    Speed = 60,
    GasTank = 450,
    StrengthText = "Strong",
    RepairCost = 700,
    SeatsNum = 4,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(25, 101, 40),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["CHEV_C10"] = {
    Name = "Chevrolet C10",
    OtherName = "CHEV_C10",
    Desc = "Like c4?",
    Script = "scripts/vehicles/tdmcars/c10.txt",
    Model = "models/tdmcars/chev_c10.mdl",
    Price = 80000,
    Health = 115,
    Speed = 60,
    GasTank = 450,
    StrengthText = "Strong",
    RepairCost = 700,
    SeatsNum = 4,
    Skin_Price = 6000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(37, 115, 34),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}]]
GM.OCRP_Cars["CAMARO_ZL1"] = {
    Name = "Chevrolet Camaro ZL1",
    OtherName = "CAMARO_ZL1",
    Desc = "Actually a secret robot",
    Script = "scripts/vehicles/tdmcars/che_camarozl1.txt",
    Model = "models/tdmcars/chev_camzl1.mdl",
    Price = 265000,
    Health = 100,
    Speed = 100,
    GasTank = 450,
    StrengthText = "Strong",
    RepairCost = 850,
    SeatsNum = 4,
    Skin_Price = 6000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(34, 107, 34),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["ASTON_DBS"] = {
    Name = "Aston Martin DBS",
    OtherName = "ASTON_DBS",
    Desc = "Astroid?",
    Script = "scripts/vehicles/tdmcars/dbs.txt",
    Model = "models/tdmcars/dbs.mdl",
    Price = 710000,
    Health = 90,
    Speed = 85,
    GasTank = 350,
    StrengthText = "Below Average",
    RepairCost = 1500,
    SeatsNum = 4,
    Skin_Price = 10000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(31, 103, 33),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["DELOREAN"] = {
    Name = "Delorean",
    OtherName = "DELOREAN",
    Desc = "Back to the future?",
    Script = "scripts/vehicles/tdmcars/delorean.txt",
    Model = "models/tdmcars/del_dmc.mdl",
    Price = 250000,
    Health = 100,
    Speed = 60,
    GasTank = 500,
    StrengthText = "Strong",
    RepairCost = 400,
    SeatsNum = 2,
    Skin_Price = 4000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(30, 99, 31),
    Skins = {
        {skin = 0, name = "Light Grey"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["LAMBO_DIABLO"] = {
    Name = "Lamborghini Diablo",
    OtherName = "LAMBO_DIABLO",
    Desc = "Like the game?",
    Script = "scripts/vehicles/tdmcars/diablo.txt",
    Model = "models/tdmcars/lambo_diablo.mdl",
    Price = 985000,
    Health = 90,
    Speed = 90,
    GasTank = 350,
    StrengthText = "Below Average",
    RepairCost = 1350,
    SeatsNum = 2,
    Skin_Price = 10000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(29, 109, 21),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["FERRARI_ENZO"] = {
    Name = "Ferrari Enzo",
    OtherName = "FERRARI_ENZO",
    Desc = "Peyton Manning",
    Script = "scripts/vehicles/tdmcars/enzo.txt",
    Model = "models/tdmcars/fer_enzo.mdl",
    Price = 955000,
    Health = 90,
    Speed = 95,
    GasTank = 350,
    StrengthText = "Below Average",
    RepairCost = 1350,
    SeatsNum = 2,
    Skin_Price = 10000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(36, 85, 32),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["FORD_FOCUS"] = {
    Name = "Ford Focus",
    OtherName = "FORD_FOCUS",
    Desc = "FOCUS! CONCENTRATE!",
    Script = "scripts/vehicles/tdmcars/focussvt.txt",
    Model = "models/tdmcars/for_focussvt.mdl",
    Price = 85000,
    Health = 130,
    Speed = 65,
    GasTank = 450,
    StrengthText = "Very Strong",
    RepairCost = 900,
    SeatsNum = 4,
    Skin_Price = 5000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(28, 93, 35),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["FORD_GT"] = {
    Name = "Ford GT",
    OtherName = "FORD_GT",
    Desc = "Ford GTFO",
    Script = "scripts/vehicles/tdmcars/gt05.txt",
    Model = "models/tdmcars/gt05.mdl",
    Price = 780000,
    Health = 100,
    Speed = 95,
    GasTank = 400,
    StrengthText = "Strong",
    RepairCost = 850,
    SeatsNum = 2,
    Skin_Price = 7500,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(32, 95, 29),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["HUMMER_H1"] = {
    Name = "Hummer H1",
    OtherName = "HUMMER_H1",
    Desc = "?",
    Script = "scripts/vehicles/tdmcars/h1.txt",
    Model = "models/tdmcars/hummerh1.mdl",
    Price = 665000,
    Health = 225,
    Speed = 50,
    GasTank = 200,
    StrengthText = "TAAAAANK",
    RepairCost = 2000,
    SeatsNum = 4,
    Skin_Price = 8000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(-22, 104, 49),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["JEEP_WILLY"] = {
    Name = "Jeep Willy",
    OtherName = "JEEP_WILLY",
    Desc = "Standard Jeep",
    Script = "scripts/vehicles/tdmcars/jeewillys.txt",
    Model = "models/tdmcars/jee_willys.mdl",
    Price = 50000,
    Health = 150,
    Speed = 50,
    GasTank = 300,
    StrengthText = "Strong",
    RepairCost = 850,
    SeatsNum = 4,
    Skin_Price = 7000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(-19, 63, 47),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["FERRARI_LAFERRARI"] = {
    Name = "Ferrari LaFerrari",
    OtherName = "FERRARI_LAFERRARI",
    Desc = "Ferrari LaFerrari LaFerrari LaFerrari",
    Script = "scripts/vehicles/tdmcars/laferrari.txt",
    Model = "models/tdmcars/fer_lafer.mdl",
    Price = 1050000,
    Health = 90,
    Speed = 115,
    GasTank = 400,
    StrengthText = "Below Average",
    RepairCost = 1500,
    SeatsNum = 2,
    Skin_Price = 10000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(36, 96, 30),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["MCLAREN_F1"] = {
    Name = "Mclaren F1",
    OtherName = "MCLAREN_F1",
    Desc = "It's a Mclaren",
    Script = "scripts/vehicles/tdmcars/mclarenf1.txt",
    Model = "models/tdmcars/mclaren_f1.mdl",
    Price = 825000,
    Health = 90,
    Speed = 100,
    GasTank = 400,
    StrengthText = "Below Average",
    RepairCost = 1400,
    SeatsNum = 1,
    Skin_Price = 9000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(35, 79, 28),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["MCLAREN_P1"] = {
    Name = "Mclaren P1",
    OtherName = "MCLAREN_P1",
    Desc = "?",
    Script = "scripts/vehicles/tdmcars/mclarenp1.txt",
    Model = "models/tdmcars/mclaren_p1.mdl",
    Price = 1450000,
    Health = 85,
    Speed = 115,
    GasTank = 425,
    StrengthText = "Strong",
    RepairCost = 1000,
    SeatsNum = 2,
    Skin_Price = 9500,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(34, 100, 28),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["MERCEDES_E63"] = {
    Name = "Mercedes E63",
    OtherName = "MERCEDES_E63",
    Desc = "e=63^2",
    Script = "scripts/vehicles/tdmcars/mere63.txt",
    Model = "models/tdmcars/mer_e63.mdl",
    Price = 580000,
    Health = 110,
    Speed = 90,
    GasTank = 450,
    StrengthText = "Strong",
    RepairCost = 1300,
    SeatsNum = 4,
    Skin_Price = 8500,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(36, 105, 33),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["MITSU_ECLIPSE_GT"] = {
    Name = "Mitsubishi Eclipse GT",
    OtherName = "MITSU_ECLIPSE_GT",
    Desc = "Solar or lunar?",
    Script = "scripts/vehicles/tdmcars/mitsu_eclipgt.txt",
    Model = "models/tdmcars/mitsu_eclipgt.mdl",
    Price = 188000,
    Health = 105,
    Speed = 70,
    GasTank = 400,
    StrengthText = "Strong",
    RepairCost = 800,
    SeatsNum = 2,
    Skin_Price = 8000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(31, 95, 33),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["MITSU_EVOX"] = {
    Name = "Mitsubishi EvoX",
    OtherName = "MITSU_EVOX",
    Desc = "Perfect for EvoCity",
    Script = "scripts/vehicles/tdmcars/mitsu_evox.txt",
    Model = "models/tdmcars/mitsu_evox.mdl",
    Price = 375000,
    Health = 105,
    Speed = 80,
    GasTank = 400,
    StrengthText = "Strong",
    RepairCost = 900,
    SeatsNum = 4,
    Skin_Price = 7500,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(33, 98, 38),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["MERCEDES_ML63"] = {
    Name = "Mercedes ML63",
    OtherName = "MERCEDES_ML63",
    Desc = "MLK?",
    Script = "scripts/vehicles/tdmcars/ml63.txt",
    Model = "models/tdmcars/mer_ml63.mdl",
    Price = 535000,
    Health = 130,
    Speed = 70,
    GasTank = 350,
    StrengthText = "Very Strong",
    RepairCost = 1200,
    SeatsNum = 4,
    Skin_Price = 8500,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(30, 102, 41),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["LAMBO_MURCI_SV"] = {
    Name = "Lamborghini Murcielago",
    OtherName = "LAMBO_MURCI_SV",
    Desc = "Have murcy",
    Script = "scripts/vehicles/tdmcars/murcielagosv.txt",
    Model = "models/tdmcars/lambo_murcielagosv.mdl",
    Price = 975000,
    Health = 90,
    Speed = 105,
    GasTank = 375,
    StrengthText = "Below Average",
    RepairCost = 1400,
    SeatsNum = 2,
    Skin_Price = 10000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(34, 93, 29),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["PORSCHE_TRICYCLE"] = {
    Name = "Porsche Tricycle",
    OtherName = "PORSCHE_TRICYCLE",
    Desc = "LOL",
    Script = "scripts/vehicles/tdmcars/porcycle.txt",
    Model = "models/tdmcars/por_tricycle.mdl",
    Price = 5000000,
    Health = 500000,
    Speed = 5,
    GasTank = 10000,
    StrengthText = "Invulnerable",
    RepairCost = 10000,
    SeatsNum = 1,
    Skin_Price = 50000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(35, 118, 48),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["TOYOTA_PRIUS"] = {
    Name = "Toyota Prius",
    OtherName = "TOYOTA_PRIUS",
    Desc = "Save the trees man",
    Script = "scripts/vehicles/tdmcars/prius.txt",
    Model = "models/tdmcars/prius.mdl",
    Price = 95000,
    Health = 115,
    Speed = 50,
    GasTank = 600,
    StrengthText = "Strong",
    RepairCost = 800,
    SeatsNum = 4,
    Skin_Price = 7000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(27, 97, 35),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["LAMBO_REVENTON"] = {
    Name = "Lamborghini Reventon",
    OtherName = "LAMBO_REVENTON",
    Desc = "The Revenant",
    Script = "scripts/vehicles/tdmcars/reventonr.txt",
    Model = "models/tdmcars/reventon_roadster.mdl",
    Price = 955000,
    Health = 85,
    Speed = 100,
    GasTank = 350,
    StrengthText = "Below Average",
    RepairCost = 1500,
    SeatsNum = 2,
    Skin_Price = 10000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(36, 102, 30),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["MAZDA_RX8"] = {
    Name = "Mazda RX8",
    OtherName = "MAZDA_RX8",
    Desc = "DanK",
    Script = "scripts/vehicles/tdmcars/rx8.txt",
    Model = "models/tdmcars/rx8.mdl",
    Price = 196000,
    Health = 100,
    Speed = 65,
    GasTank = 425,
    StrengthText = "Strong",
    RepairCost = 1000,
    SeatsNum = 4,
    Skin_Price = 8000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(29, 96, 32),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["TESLA_MODEL_S"] = {
    Name = "Tesla Model S",
    OtherName = "TESLA_MODEL_S",
    Desc = "Nikola's Baby",
    Script = "scripts/vehicles/tdmcars/teslamodels.txt",
    Model = "models/tdmcars/tesla_models.mdl",
    Price = 966600,
    Health = 95,
    Speed = 85,
    GasTank = 800,
    StrengthText = "Below Average",
    RepairCost = 1300,
    SeatsNum = 5,
    Skin_Price = 8000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(38, 102, 36),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        --{skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        --{skin = 12, name = "Blue Camo"},
        --{skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["DODGE_VIPER"] = {
    Name = "Dodge Viper",
    OtherName = "DODGE_VIPER",
    Desc = "?",
    Script = "scripts/vehicles/tdmcars/vipviper.txt",
    Model = "models/tdmcars/vip_viper.mdl",
    Price = 755000,
    Health = 90,
    Speed = 90,
    GasTank = 350,
    StrengthText = "Below Average",
    RepairCost = 1450,
    SeatsNum = 2,
    Skin_Price = 10000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(36, 94, 34),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}
GM.OCRP_Cars["MAZDA_FURAI"] = {
    Name = "Mazda Furai",
    OtherName = "MAZDA_FURAI",
    Desc = "Coolest looking car in the game.",
    Script = "scripts/vehicles/tdmcars/furai.txt",
    Model = "models/tdmcars/maz_furai.mdl",
    Price = 1150000,
    Health = 115,
    Speed = 90,
    GasTank = 350,
    StrengthText = "Below Average",
    RepairCost = 1450,
    SeatsNum = 2,
    Skin_Price = 10000,
    Seats = function(ply, Entity)
    end,
	Headlights = Vector(36, 94, 34),
    Skins = {
        {skin = 0, name = "White"},
        {skin = 1, name = "Red"},
        {skin = 2, name = "Black"},
        {skin = 4, name = "Blue"},
        {skin = 5, name = "Green"},
        {skin = 6, name = "Orange"},
        {skin = 7, name = "Yellow"},
        {skin = 8, name = "Pink"},
        {skin = 11, name = "Grey"},
        {skin = 13, name = "Ice"},
        {skin = 15, name = "Shiny Purple"},
        {skin = 3, name = "Black Carbon Fiber"},
        {skin = 9, name = "Metal"},
        {skin = 10, name = "Camo"},
        {skin = 12, name = "Blue Camo"},
        {skin = 14, name = "Wood"},
    },
    MovePos = Vector(0,0,0)
}

for k,v in pairs(GM.OCRP_Cars) do
	util.PrecacheModel(v["Model"])
end
-- Gov vehicles
util.PrecacheModel("models/tdmcars/emergency/mitsu_evox.mdl") -- Cop Car 1
util.PrecacheModel("models/tdmcars/copcar.mdl") -- Cop Car 2
util.PrecacheModel("models/sickness/meatwagon.mdl") -- Ambulance
util.PrecacheModel("models/sickness/stockade2dr.mdl") -- SWAT Van
util.PrecacheModel("models/sickness/truckfire.mdl") -- Firetruck
util.PrecacheModel("models/sickness/towtruckdr.mdl") -- Towtruck
util.PrecacheModel("models/tdmcars/crownvic_taxi.mdl") -- Towtruck