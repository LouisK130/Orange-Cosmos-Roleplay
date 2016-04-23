GM.OCRP_Skills = {}

GM.OCRP_Skills["skill_conc"] = {
	Name = "Concentration Training",
	Desc = "Increases weapon accuracy.",
	Model = "models/props_lab/binderbluelabel.mdl",
	MaxLevel = 5,
    Color = Color(255,0,0,100),
	LvlDesc = {"Accuracy with guns increased by 10%.","Accuracy with guns increased by 20%.","Accuracy with guns increased by 30%.","Accuracy with guns increased by 40%.","Accuracy with guns increased by 50%."},
}

GM.OCRP_Skills["skill_end"] = {
	Name = "Endurance Training",
	Desc = "Allows you to run longer.",
	Model = "models/props_lab/binderblue.mdl",
	MaxLevel = 3,
    Color = Color(170,70,190,150),
	LvlDesc = {"Energy Decay Reduced by 25%.","Energy Decay Reduced by 50%.","Energy Decay Reduced by 75%"},
	Function = function(ply,skill)
				--[[local multiplier = 1
				local multi = 1
				local jump_multi = 1
					if skill  == "skill_end" then
						if ply:HasSkill("skill_end",1) then
							multi = multi + 0.15
							if ply:HasSkill("skill_end",2) then
								multiplier = multiplier + .75
								if ply:HasSkill("skill_end",3) then
									multi = multi + 0.15
								end
							end
						end
					end
					ply.SprintDecay = .05 * multiplier
					ply.Speeds.Sprint = 327 * multi]]
				end,
}

GM.OCRP_Skills["skill_str"] = {
	Name = "Strength Training",
	Desc = "Take less damage and swing harder.",
	Model = "models/props_lab/binderredlabel.mdl",
	MaxLevel = 3,
    Color = Color(255,0,0,100),
	LvlDesc = {"Melee attack power increased by 25%.","Damage Taken reduced by 25%.","Melee attack power increased by 50%."},
}

GM.OCRP_Skills["skill_picking"] = {
	Name = "Lockpicking",
	Desc = "Allows you to lockpick doors.",
	Model = "models/props_lab/binderredlabel.mdl",
	MaxLevel = 7,
    Color = Color(255,130,0,100),
	LvlDesc = {"Lockpick doors.","Lockpick success 15% more often.","Lockpick handcuffs.","Lockpick success 20% more often.","Lockpick padlocks.","Lockpick cars and large doors.","Lockpicks success 25% more often."},
}

GM.OCRP_Skills["skill_herb"] = {
	Name = "Herbalism",
	Desc = "Allows you to grow plants.",
	Model = "models/props_lab/bindergreenlabel.mdl",
	MaxLevel = 4,
    Color = Color(0,255,0,100),
	LvlDesc = {"The ability to grow weed.","10% less time to grow drugs.","20% less time to grow drugs.","30% less time to grow drugs.",},
}

GM.OCRP_Skills["skill_craft_bal"] = {
	Name = "Ballistics Crafting",
	Desc = "Allows you to craft advanced weapons.",
	Model = "models/props_lab/binderredlabel.mdl",
	MaxLevel = 5,
    Color = Color(0,200,255,100),
	Requirements = {{Skill =  "skill_craft_basic", level = 1},},
	LvlDesc = {"The ability to craft advanced weapons."},
}

GM.OCRP_Skills["skill_craft_circ"] = {
	Name = "Circuitry Crafting",
	Desc = "Allows you to craft electronic items.",
	Model = "models/props_lab/bindergraylabel01b.mdl",
	MaxLevel = 1,
    Color = Color(0,200,255,100),
	Requirements = {{Skill =  "skill_craft_basic", level = 3},},
	LvlDesc = {"The ability to craft electronic items.",},
}

GM.OCRP_Skills["skill_craft_mech"] = {
	Name = "Mechanical Crafting",
	Desc = "Allows you to craft advanced weapons.",
	Model = "models/props_lab/bindergraylabel01a.mdl",
	MaxLevel = 5,
    Color = Color(0,200,255,100),
	Requirements = {{Skill =  "skill_craft_basic", level = 1},},
	LvlDesc = {"The ability to craft advanced weapons."},
}

--[[GM.OCRP_Skills["skill_food"] = {
	Name = "Food Making",
	Desc = "Allows players to make food",
	Model = "models/props_lab/bindergraylabel01a.mdl",
	MaxLevel = 5,
	LvlDesc = {"The ability to make food."},
}]]

GM.OCRP_Skills["skill_craft_weapon"] = {
	Name = "Weapon Crafting",
	Desc = "Allows you to craft weapons.",
	Model = "models/props_lab/binderredlabel.mdl",
	MaxLevel = 5,
    Color = Color(0,200,255,100),
	Requirements = {{Skill =  "skill_craft_basic", level = 1},},
	LvlDesc = {"The ability to craft weapons."},
}

GM.OCRP_Skills["skill_craft_basic"] = {
	Name = "Basic Crafting",
	Desc = "Allows you to craft items.",
	Model = "models/props_lab/bindergreen.mdl",
	MaxLevel = 4,
    Color = Color(0,200,255,100),
	LvlDesc = {"The ability to craft basic items."},
}

GM.OCRP_Skills["skill_acro"] = {
	Name = "Acrobatic Training",
	Desc = "Allows you to jump higher.",
	Model = "models/props_lab/binderblue.mdl",
	MaxLevel = 2,
    Color = Color(170,70,190,150),
	LvlDesc = {"Jump 50% higher.","Costs 5 less energy to jump.",},
	Function = function(ply,skill)
					local jump_multi = 1
					if skill  == "skill_acro" then 
						if ply:HasSkill("skill_acro",1) then
							jump_multi = 1.5
						end
					end
					ply:SetJumpPower(160*jump_multi)
				end,
	RemoveFunc = function(ply,skill)
					ply:SetJumpPower(160)
				end,
}

GM.OCRP_Skills["skill_pack"] = {
	Name = "Back-Pack Training",
	Desc = "Allow you to carry more weight.",
	Model = "models/props_lab/binderblue.mdl",
	MaxLevel = 1,
    Color = Color(170,70,190,150),
	LvlDesc = {"Carry 25 more pounds.",},
	Function = function(ply,skill)
					if ply:HasSkill(skill,1) then
						ply.OCRPData["Inventory"].WeightData.Max = ply.OCRPData["Inventory"].WeightData.Max + 25
                        for k,v in pairs(ply.OCRPData["Inventory"]) do
                            if k != "WeightData" then
                                ply:UpdateItem(k) -- Update 1 random item to update weightdata
                                return
                            end
                        end
					end
				end,
	RemoveFunc = function(ply,skill)
					ply.OCRPData["Inventory"].WeightData.Max = ply.OCRPData["Inventory"].WeightData.Max - 25
                    for k,v in pairs(ply.OCRPData["Inventory"]) do
                        if k != "WeightData" then
                            ply:UpdateItem(k) -- Update 1 random item to update weightdata
                            return
                        end
                    end
				end,
}

GM.OCRP_Skills["skill_loot"] = {
	Name = "Looting",
	Desc = "Allows you to steal items from bodies.",
	Model = "models/props_lab/bindergreenlabel.mdl",
	MaxLevel = 8,
    Color = Color(255,130,0,100),
	LvlDesc = {	
				"Loot bodies.",
				"Loot drugs and pots.",
				"Loot ammo and materials.",
				"Loot melee weapons.",
				"Loot pistols.",
				"Loot shotguns.",
				"Loot SMGs.",
				"Loot assualt weapons.",
	},
	Requirements = {{Skill =  "skill_rob", level = 6},},
}

GM.OCRP_Skills["skill_rob"] = {
	Name = "Robbery",
	Desc = "Allows you to steal more mayor money.",
	Model = "models/props_lab/binderredlabel.mdl",
	MaxLevel = 6,
    Color = Color(255,130,0,100),
	LvlDesc = {	"Steal $100 more from mayor cash blocks.",
				"Steal $200 more from mayor cash blocks.",
				"Steal $300 more from mayor cash blocks.",
				"Steal $400 more from mayor cash blocks.",
				"Steal $500 more from mayor cash blocks.",
				"Steal $600 more from mayor cash blocks.",
	},
}
GM.OCRP_Skills["skill_theft"] = {
	Name = "Theft",
	Desc = "Allows theft of store goods.",
	Model = "models/props_lab/binderredlabel.mdl",
	MaxLevel = 1,
    Color = Color(255,130,0,100),
	LvlDesc = {	"Take merchandise from shops if the owner isn't around.",},
}
