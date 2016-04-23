
GM.OCRP_Shops = {}
--[[
GM.OCRP_Shops[1] = {-- i guess just by ids, maybe names, change if u want
Name = "Big Bobs house of rope", -- Name of it
Description = "We can g-rope your body.",
Items = {"item_pot",},-- put avaible items here 
}]]--

--[[GM.OCRP_Shops[1] = {-- i guess just by ids, maybe names, change if u want
Name = "'Ruggies", -- Name of it
Description = "We are environmentally friendly.",
PriceScale = {Buying = 0.5,Selling = 1,},
Restricted = {CLASS_POLICE,CLASS_CHIEF,CLASS_SWAT,CLASS_MEDIC,CLASS_Mayor},
}]]

GM.OCRP_Shops[2] = {
Name = "'Ruggies", 
Description = "We are environmentally friendly.",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_weed_seed"},
Restricted = {CLASS_POLICE,CLASS_CHIEF,CLASS_SWAT,CLASS_MEDIC,CLASS_Mayor},
Buying = {"item_shroom"},
NoTax = true
}

GM.OCRP_Shops[3] = {
Name = "'Ruggies", 
Description = "We are environmentally friendly.",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_weed_seed"},
Buying = {"item_weed_bag"},
Restricted = {CLASS_POLICE,CLASS_CHIEF,CLASS_SWAT,CLASS_MEDIC,CLASS_Mayor},
NoTax = true
}

GM.OCRP_Shops[4] = {
Name = "'Ruggies", 
Description = "We are environmentally friendly.",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_shroom"},
Buying = {"item_weed_bag"},
Restricted = {CLASS_POLICE,CLASS_CHIEF,CLASS_SWAT,CLASS_MEDIC,CLASS_Mayor},
NoTax = true
}

GM.OCRP_Shops[5] = {
Name = "Bussens & Parkin Hardware", 
Description = "One stop shop for all hardware.",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_metal","item_pole", "item_dockplank", "item_cardboard","item_wood","item_plastic","item_clay","item_cinderblock","item_furnace","item_sink","item_physgun",},
}

GM.OCRP_Shops[6] = {
Name = "Bussens & Parkin Hardware", 
Description = "One stop shop for all hardware.",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_pole","item_wood","item_plastic", "item_dockplank", "item_clay","item_cinderblock","item_furnace","item_sink","item_physgun",},
Buying = {"item_metal","item_pole","item_cardboard", "item_dockplank", "item_wood","item_plastic","item_clay","item_cinderblock","item_furnace","item_sink",}
}

GM.OCRP_Shops[7] = {
Name = "Bussens & Parkin Hardware", 
Description = "One stop shop for all hardware.",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_metal","item_pole","item_cardboard", "item_dockplank", "item_clay","item_cinderblock","item_furnace","item_sink","item_physgun",},
Buying = {"item_metal","item_pole","item_cardboard", "item_dockplank", "item_wood","item_plastic","item_clay","item_cinderblock","item_furnace","item_sink",}
}

GM.OCRP_Shops[8] = {
Name = "BP Gasoline", 
Description = "Gas 'em up.",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_gascan","item_oil","item_radio","item_cell","item_emergency_gascan"},
}

GM.OCRP_Shops[9] = {
Name = "Box Head", 
Description = "Store your stuff, in a box!",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_container_small01","item_container_small02","item_container_small03","item_container_large01","item_container_large02","item_safe01",}
}

GM.OCRP_Shops[10] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_craft_basic", "item_skill_herb"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[11] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_craft_mech", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[12] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_craft_bal", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[13] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_craft_circ", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[14] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_end", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[15] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_str", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[16] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_conc", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[17] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_craft_weapon", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[18] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_picking", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[19] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_craft_weapon", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[20] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_acro", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[21] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_reset", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[22] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_pack", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[23] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_loot", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[24] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_rob", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[25] = {
Name = "The Librarian", 
Description = "One book at a time...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_skill_theft", "item_skill_herb","item_skill_craft_basic"},
Buying = {"item_skill_craft_basic","item_skill_craft_bal","item_skill_craft_circ","item_skill_end","item_skill_str","item_skill_conc","item_skill_herb","item_skill_picking","item_skill_craft_weapon","item_skill_acro","item_skill_reset","item_skill_pack","item_skill_loot","item_skill_craft_mech","item_skill_rob","item_skill_theft",},
}
GM.OCRP_Shops[28] = {
Name = "Cheepies Exports",
Description = "We buy anything...",
PriceScale = {Buying = 0.25,Selling = 5,},
Items = {},
Buying = {
			"item_gib",
			"item_safe01",
			"item_chair01",
			"item_barrier",
			"item_gbeans",
			"item_lockpick",
			"item_wood",
			"item_weed_bag",
			"item_skill_end",
			"item_clay",
			"item_padlock",
			"item_cone",
			"item_m4a1",
			"item_weed_seed",
			"item_metal",
			"item_physgun",
			"item_shotgun",
			"item_explosives",
			"item_oil",
			"item_sink",
			"item_mp5",
			"item_skill_craft_basic",
			"item_skill_str",
			"item_drawer",
			"item_nrg_drink",
			"item_skill_craft_bal",
			"item_skill_picking",
			"item_pipe",
			"item_gbean_seed",
			"item_container_large01",
			"item_medkit",
			"item_skill_conc",
			"item_skill_acro",
			"item_ak47",
			"item_angledbarrier",
			"item_cashregister",
			"item_fiveseven",
			"item_plastic",
			"item_wood_barricade",
			"item_cell",
			"item_recttable",
			"item_mac10",
			"item_chair02",
			"item_gascan",
			"item_emergency_gascan",
			"item_wardrobe",
			"item_longtable",
			"item_casing",
			"item_glock18",
			"item_circtable",
			"item_couch",
			"item_container_small03",
			"item_container_small02",
			"item_container_large02",
			"item_furnace",
			"item_skill_craft_mech",
			"item_skill_loot",
			"item_cardboard",
			"item_container_small01",
			"item_skill_pack",
			"item_skill_reset",
			"item_life_alert",
			"item_knife",
			"item_wood_fence",
			"item_skill_herb",
			"item_deagle",
			"item_radio",
			"item_skill_craft_weapon",
			"item_skill_craft_circ",
			"item_ladder",
			"item_pot",
			"item_skill_rob",
			"item_halffence",
			"item_metal_fence",
			"item_pole",
			"item_desk",
			"item_cinderblock",
			"item_wrench",
			},
}
GM.OCRP_Shops[29] = {
Name = "Larry's Furniture", 
Description = "What ever you need, we got it.",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_couch","item_circtable","item_recttable","item_angledbarrier","item_longtable","item_drawer","item_wardrobe","item_cashregister",},
}

GM.OCRP_Shops[30] = {
Name = "Soda Machine", 
Description = "Insert money please...",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_nrg_drink"},
Buying = {},
}

GM.OCRP_Shops[31] = {
Name = "'Ruggies", 
Description = "We are environmentally friendly.",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_shroom", "item_weed_seed"},
Restricted = {CLASS_POLICE,CLASS_CHIEF,CLASS_SWAT,CLASS_MEDIC,CLASS_Mayor},
Buying = false,
NoTax = true
}

GM.OCRP_Shops[32] = {
Name = "'Ruggies", 
Description = "We are environmentally friendly.",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {"item_shroom"},
Buying = {"item_shroom", "item_weed_bag"},
Restricted = {CLASS_POLICE,CLASS_CHIEF,CLASS_SWAT,CLASS_MEDIC,CLASS_Mayor},
NoTax = true
}

GM.OCRP_Shops[33] = {
Name = "'Ruggies", 
Description = "We are environmentally friendly.",
PriceScale = {Buying = 0.5,Selling = 1,},
Items = {},
Buying = {"item_weed_bag","item_shroom", "item_shroom_rotten"},
Restricted = {CLASS_POLICE,CLASS_CHIEF,CLASS_SWAT,CLASS_MEDIC,CLASS_Mayor},
NoTax = true
}

