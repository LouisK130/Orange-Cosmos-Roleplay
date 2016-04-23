-- CONFIG
OCRPCfg = {}
--ALL OF THIS IS OBSOLETE, NONE SEEMS TO TAKE EFFECT
--Money CONFIG
Msg( "OCRP: Loading money config...\n" )
OCRPCfg["MoneyTime"] = 120 -- How often should we give the player their paycheck
OCRPCfg["MoneyAmount_C"] = 60 -- How much we should give the citizens on their paycheck
OCRPCfg["MoneyAmount_MA"] = 130 -- How much we should give the mayor on their paycheck
OCRPCfg["MoneyAmount_M"] = 100 -- How much we should give the medics on their paycheck
OCRPCfg["MoneyAmount_P"] = 90 -- How much we should give the police on their paycheck
OCRPCfg["MoneyStart"] = 10000 -- How much the player starts with on there first join
OCRPCfg["MoneyAmount_V_C"] = math.Round(OCRPCfg["MoneyAmount_C"] * 1.25) -- How much we should give the citizens on their paycheck - VIP
OCRPCfg["MoneyAmount_V_MA"] = math.Round(OCRPCfg["MoneyAmount_MA"] * 1.25) -- How much we should give the mayor on their paycheck - VIP
OCRPCfg["MoneyAmount_V_M"] = math.Round(OCRPCfg["MoneyAmount_M"] * 1.25) -- How much we should give the medics on their paycheck - VIP
OCRPCfg["MoneyAmount_V_P"] = math.Round(OCRPCfg["MoneyAmount_P"] * 1.25) -- How much we should give the police on their paycheck - VIP
Msg( "OCRP: Finished loading money config.\n" )
--End of money CONFIG

OCRPCfg["Prop_Limit"] = 40
OCRPCfg["Shop_Limit"] = 15

--Organization CONFIG
Msg( "OCRP: Loading organization config...\n" )
OCRPCfg["Org_MaxUsers"] = 20 -- How many users can be in a org at any one time
OCRPCfg["Org_StartCost"] = 3500 -- How much it costs to buy a organization
Msg( "OCRP: Finished loading organization config.\n" )
--End of organization CONFIG

--General CONFIG
Msg( "OCRP: Loading general config...\n" )
OCRPCfg["MaxDoors"] = 5 -- How many doors can a player have at any one time?
Msg( "OCRP: Finished loading general config.\n" )
--End of general CONFIG.

CosmosFM_DJs = {
 --"STEAM_0:0:6717638", -- Darthkatzs
}
 
function PMETA:IsDJ()
	if (SERVER) then
		if self.CosmosFMDJ then
			return true
		else
			return false
		end
	elseif (CLIENT) then
		if self.AmDJ then
			return true
		else
			return false
		end
	end
	return false
end

GM.OCRP_Dialogue = {}

GM.OCRP_Dialogue["Job_Cop001"] = {
Dialogue = {},
Condition = function(ply)  
				if ply:Team() > 1 then
					if ply:Team() == CLASS_POLICE || ply:Team() == CLASS_CHIEF || ply:Team() == CLASS_SWAT then
						return "Quit"
					end
				end
				return 1 
			end,
}
			
GM.OCRP_Dialogue["Job_Cop001"].Dialogue["Full"] = { Question = "All our positions are filled, I'm sorry.", YesAnswer = "Oh, okay. I'll come back later.", NoAnswer = "You jerk!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Cop001"].Dialogue["Job"] = { Question = "Quit your current job first, then we can talk.", YesAnswer = "Oh, okay. I'll go do that.", NoAnswer = "But I like this job!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Cop001"].Dialogue["Quit"] = {Question = "How may I help you today?", YesAnswer = "I'm here to quit.", NoAnswer = "You can't help me.",Condition = function(ply) return true end,Function = function(ply) net.Start("OCRP_Job_Quit") net.SendToServer() return "Exit" end,}

GM.OCRP_Dialogue["Job_Cop001"].Dialogue["Quitter"] = {Question = "You just recently quit the force, get lost.", YesAnswer = "Oh sorry, I'll come back later.", NoAnswer = "Screw you, I just wanted to help!", Condition = function(ply) return true end, Function = function(ply) net.Start("OCRP_JobTimeString") net.WriteInt(CLASS_POLICE, 32) net.SendToServer() return "Exit" end, }

GM.OCRP_Dialogue["Job_Cop001"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for work as a cop, are there any positions open?", NoAnswer = "You can't help me.",
Condition = function(ply)
					if ply:GetNWBool("InBallot", false) then
						return 4
					end
					if ply:Team() > 1 then
						if ply:Team() == CLASS_POLICE || ply:Team() == CLASS_CHIEF || ply:Team() == CLASS_SWAT then
							return "Quit"
						else
							return "Job"
						end
					elseif ply:Team() <= 1 then
						if team.NumPlayers(CLASS_POLICE) < #player.GetAll()/4 then 
							if ply:GetNWBool("JobCD_" .. tostring(CLASS_POLICE), false) then
								return "Quitter"
							end
							return 2
						else
							return "Full"
						end
					end
					return "Exit" 
				end,}

GM.OCRP_Dialogue["Job_Cop001"].Dialogue[2] = {Question = "Why yes there are, just sign here.", YesAnswer = "Alright.", NoAnswer = "Woah, I just wanted a gun, not to sign anything.", 
Condition = function(ply)
	if team.NumPlayers(CLASS_POLICE) >= #player.GetAll()/3 then 
		return "Full"
	end 
	return true
end, Function = function(ply)
	net.Start("OCRP_Job_Join")
	net.WriteInt(CLASS_POLICE, 32)
	net.SendToServer() return 3 end,}-- Return the ending dialogue thing

GM.OCRP_Dialogue["Job_Cop001"].Dialogue[3] = {Question = "Okay, here is your badge and gear. Good luck.", YesAnswer = "Yea, like I need luck.", NoAnswer = "Lets rock.", Condition = function(ply) return true end,Function = function(ply) return "Exit" end,}

GM.OCRP_Dialogue["Job_Cop001"].Dialogue[4] = {Question = "You're running for mayor, you cannot join the police force.", YesAnswer = "Oh, okay. I'll go remove my ballot.", NoAnswer = "Well, screw you too!", Condition = function(ply) return true end, Function = function(ply) return "Exit" end, }
GM.OCRP_Dialogue["Job_Tow001"] = {
Dialogue = {},
Condition = function(ply)
    if ply:Team() == CLASS_Tow then
        return "Quit"
    end
    return 1
end,
}
GM.OCRP_Dialogue["Job_Tow001"].Dialogue["Quitter"] = {Question = "You just bailed on us truckers, get lost.", YesAnswer = "Oh sorry, I'll come back later.", NoAnswer = "Screw you, I just wanted to help!", Condition = function(ply) return true end, Function = function(ply) net.Start("OCRP_JobTimeString") net.WriteInt(CLASS_Tow, 32) net.SendToServer() return "Exit" end, }
GM.OCRP_Dialogue["Job_Tow001"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'd like to be a tow truck driver.", NoAnswer = "You can't help me.",
Condition = function(ply)
    if ply:GetNWBool("InBallot", false) then
        return 4
    end
    if ply:Team() > 1 then
        if ply:Team() == CLASS_Tow then
            return "Quit"
        else
            return "Job"
        end
    elseif ply:Team() <= 1 then
        if team.NumPlayers(CLASS_Tow) < #player.GetAll()/4 then
			if ply:GetNWBool("JobCD_" .. tostring(CLASS_Tow), false) then
				return "Quitter"
			end
            return 2
        else
            return "Full"
        end
    end
    return "Exit"
end,}

GM.OCRP_Dialogue["Job_Tow001"].Dialogue[2] = {Question = "We've got an open position just for you, sign here.", YesAnswer = "Awesome, got a pen?", NoAnswer = "Woah, I'm not interested in signing anything.",
Condition = function(ply)
    return true
end, Function = function(ply)
    net.Start("OCRP_Job_Join")
	net.WriteInt(CLASS_Tow, 32)
	net.SendToServer() return 3 end,}
    
GM.OCRP_Dialogue["Job_Tow001"].Dialogue[3] = {Question = "Okay, here are your tools. Good luck.", YesAnswer = "Yea, like I need luck", NoAnswer = "Lets rock.", Condition = function(ply) return true end, Function = function(ply) return "Exit" end,}
GM.OCRP_Dialogue["Job_Tow001"].Dialogue[4] = {Question = "You're running for mayor, you cannot be a tow truck driver.", YesAnswer = "Oh, okay. I'll go remove my ballot.", NoAnswer = "Well, screw you too!", Condition = function(ply) return true end, Function = function(ply) return "Exit" end, }
GM.OCRP_Dialogue["Job_Tow001"].Dialogue["Full"] = { Question = "All our positions are filled, I'm sorry.", YesAnswer = "Oh, okay. I'll come back later.", NoAnswer = "You jerk!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 
GM.OCRP_Dialogue["Job_Tow001"].Dialogue["Job"] = { Question = "Quit your current job first, then we can talk.", YesAnswer = "Oh, okay. I'll go do that.", NoAnswer = "But I like this job!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 
GM.OCRP_Dialogue["Job_Tow001"].Dialogue["Quit"] = {Question = "How may I help you today?", YesAnswer = "I'm here to quit.", NoAnswer = "You can't help me.",Condition = function(ply) return true end,Function = function(ply) net.Start("OCRP_Job_Quit") net.SendToServer() return "Exit" end,}

GM.OCRP_Dialogue["Job_Fire001"] = {
Dialogue = {},
Condition = function(ply)  
				if ply:Team() > 1 then
					if ply:Team() == CLASS_FIREMAN then
						return "Quit"
					end
				end
				return 1 
			end,
}
GM.OCRP_Dialogue["Job_Fire001"].Dialogue["Full"] = { Question = "All our positions are filled, I'm sorry", YesAnswer = "Oh, okay. I'll come back later.", NoAnswer = "You jerk!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Fire001"].Dialogue["Job"] = { Question = "Quit your current job first, then we can talk.", YesAnswer = "Oh, okay. I'll go do that.", NoAnswer = "But I like this job!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Fire001"].Dialogue["Quit"] = {Question = "How may I help you today?", YesAnswer = "I'm here to quit.", NoAnswer = "You can't help me.",Condition = function(ply) return true end,Function = function(ply) net.Start("OCRP_Job_Quit") net.SendToServer() return "Exit" end,}

GM.OCRP_Dialogue["Job_Fire001"].Dialogue["Quitter"] = {Question = "You recently skipped out when we needed you, get lost.", YesAnswer = "Oh sorry, I'll come back later.", NoAnswer = "Screw you, I just wanted to help!", Condition = function(ply) return true end, Function = function(ply) net.Start("OCRP_JobTimeString") net.WriteInt(CLASS_FIREMAN, 32) net.SendToServer() return "Exit" end, }

GM.OCRP_Dialogue["Job_Fire001"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for work as a fireman, are there any positions open?", NoAnswer = "You can't help me.",
Condition = function(ply)  
					if ply:GetNWBool("InBallot", false) then
						return 4
					end
					if ply:Team() > 1 then
						if ply:Team() == CLASS_FIREMAN then
							return "Quit"
						else
							return "Job"
						end
					elseif ply:Team() <= 1 then
						if team.NumPlayers(CLASS_FIREMAN) < #player.GetAll()/5 then 
							if ply:GetNWBool("JobCD_" .. tostring(CLASS_FIREMAN), false) then
								return "Quitter"
							end
							return 2 
						else
							return "Full"
						end 
					end
					return "Exit" 
				end,
}

GM.OCRP_Dialogue["Job_Fire001"].Dialogue[2] = {Question = "Why yes there are, just sign here.", YesAnswer = "Alright.", NoAnswer = "Woah, I just wanted to help people, not sign anything.", 
Condition = function(ply)
	if team.NumPlayers(CLASS_FIREMAN) >= #player.GetAll()/5 then 
		return "Full"
	end
	return true
end, Function = function(ply)
    net.Start("OCRP_Job_Join")
	net.WriteInt(CLASS_FIREMAN, 32)
	net.SendToServer() return 3 end,}-- Return the ending dialogue thing

GM.OCRP_Dialogue["Job_Fire001"].Dialogue[3] = {Question = "Okay, here is your equipment. Good luck.", YesAnswer = "Yea, like I need luck.", NoAnswer = "Lets rock.", Condition = function(ply) return true end,Function = function(ply) return "Exit" end,}

GM.OCRP_Dialogue["Job_Fire001"].Dialogue[4] = {Question = "You're running for mayor, you cannot be a fireman.", YesAnswer = "Oh, okay. I'll go remove my ballot.", NoAnswer = "Well, screw you too!", Condition = function(ply) return true end, Function = function(ply) return "Exit" end, }

GM.OCRP_Dialogue["Job_Taxi001"] = {
Dialogue = {},
Condition = function(ply)
	if ply:Team() == CLASS_TAXI then
		return "Quit"
	end
	return 1
end,
}
GM.OCRP_Dialogue["Job_Taxi001"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for work as a taxi driver, are there any positions open?", NoAnswer = "You can't help me.",
Condition = function(ply)  
					if ply:GetNWBool("InBallot", false) then
						return 4
					end
					if ply:Team() > 1 then
						if ply:Team() == CLASS_TAXI then
							return "Quit"
						else
							return "Job"
						end
					elseif ply:Team() <= 1 then
						if team.NumPlayers(CLASS_TAXI) < #player.GetAll()/4 then
							if ply:GetNWBool("JobCD_" .. tostring(CLASS_TAXI), false) then
								return "Quitter"
							end
							return 2
						else
							return "Full"
						end 
					end
					return "Exit" 
				end,
}
GM.OCRP_Dialogue["Job_Taxi001"].Dialogue["Full"] = { Question = "All our positions are filled, I'm sorry.", YesAnswer = "Oh, okay. I'll come back later.", NoAnswer = "You jerk!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Taxi001"].Dialogue["Job"] = { Question = "Quit your current job first, then we can talk.", YesAnswer = "Oh okay. I'll go do that.", NoAnswer = "But I like this job!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Taxi001"].Dialogue["Quit"] = {Question = "How may I help you today?", YesAnswer = "I'm here to quit.", NoAnswer = "You can't help me.",Condition = function(ply) return true end,Function = function(ply) net.Start("OCRP_Job_Quit") net.SendToServer() return "Exit" end,}

GM.OCRP_Dialogue["Job_Taxi001"].Dialogue["Quitter"] = {Question = "You just quit when we needed drivers, get lost.", YesAnswer = "Oh sorry, I'll come back later.", NoAnswer = "Screw you, I just wanted to help!", Condition = function(ply) return true end, Function = function(ply) net.Start("OCRP_JobTimeString") net.WriteInt(CLASS_TAXI, 32) net.SendToServer() return "Exit" end, }

GM.OCRP_Dialogue["Job_Taxi001"].Dialogue[2] = {Question = "Why yes there are, just sign here.", YesAnswer = "Alright.", NoAnswer = "Woah, I just wanted to get paid to drive, not sign anything.", 
Condition = function(ply)
	if team.NumPlayers(CLASS_TAXI) >= #player.GetAll()/4 then 
		return "Full"
	end
	return true
end, Function = function(ply)
    net.Start("OCRP_Job_Join")
	net.WriteInt(CLASS_TAXI, 32)
	net.SendToServer() return 3 end,}-- Return the ending dialogue thing

GM.OCRP_Dialogue["Job_Taxi001"].Dialogue[3] = {Question = "Okay, here is your equipment. Good luck.", YesAnswer = "Yea, like I need luck.", NoAnswer = "Lets rock.", Condition = function(ply) return true end,Function = function(ply) return "Exit" end,}

GM.OCRP_Dialogue["Job_Taxi001"].Dialogue[4] = {Question = "You're running for mayor, you cannot be a paramedic.", YesAnswer = "Oh, okay. I'll go remove my ballot.", NoAnswer = "Well, screw you too!", Condition = function(ply) return true end, Function = function(ply) return "Exit" end, }

GM.OCRP_Dialogue["Job_TaxiCar001"] = {
Dialogue = {}
}
GM.OCRP_Dialogue["Job_TaxiCar001"].Dialogue["Job"] = { Question = "You're not a taxi driver. Scram.", YesAnswer = "Oh, I'll go sign up now.", NoAnswer = "And you're a loser!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_TaxiCar001"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for a taxi.", NoAnswer = "You can't help me.",
Condition = function(ply)  
					if ply:Team() > 1 then
						if ply:Team() == CLASS_TAXI then
							return 2
						else
							return "Job"
						end
					else
						return "Job"
					end
					return "Exit" 
				end,
}

GM.OCRP_Dialogue["Job_TaxiCar001"].Dialogue[2] = {Question = "Here are the keys.", YesAnswer = "Alright.", NoAnswer = "Nice.", Condition = function(ply) return true end,Function = function(ply)
net.Start("OCRP_SpawnTaxi")
net.SendToServer()
return "Exit" end,}-- Return the ending dialogue thing
----
GM.OCRP_Dialogue["Job_Medic001"] = {
Dialogue = {},
Condition = function(ply)  
				if ply:Team() > 1 then
					if ply:Team() == CLASS_MEDIC then
						return "Quit"
					end
				end
				return 1 
			end,
}
GM.OCRP_Dialogue["Job_Medic001"].Dialogue["Full"] = { Question = "All our positions are filled, I'm sorry.", YesAnswer = "Oh, okay. I'll come back later.", NoAnswer = "You jerk!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Medic001"].Dialogue["Job"] = { Question = "Quit your current job first, then we can talk.", YesAnswer = "Oh okay. I'll go do that.", NoAnswer = "But I like this job!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Medic001"].Dialogue["Quit"] = {Question = "How may I help you today?", YesAnswer = "I'm here to quit.", NoAnswer = "You can't help me.",Condition = function(ply) return true end,Function = function(ply) net.Start("OCRP_Job_Quit") net.SendToServer() return "Exit" end,}

GM.OCRP_Dialogue["Job_Medic001"].Dialogue["Quitter"] = {Question = "You just quit while people were dying, get lost.", YesAnswer = "Oh sorry, I'll come back later.", NoAnswer = "Screw you, I just wanted to help!", Condition = function(ply) return true end, Function = function(ply) net.Start("OCRP_JobTimeString") net.WriteInt(CLASS_MEDIC, 32) net.SendToServer() return "Exit" end, }

GM.OCRP_Dialogue["Job_Medic001"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for work as a paramedic, are there any positions open?", NoAnswer = "You can't help me.",
Condition = function(ply)  
					if ply:GetNWBool("InBallot", false) then
						return 4
					end
					if ply:Team() > 1 then
						if ply:Team() == CLASS_MEDIC then
							return "Quit"
						else
							return "Job"
						end
					elseif ply:Team() <= 1 then
						if team.NumPlayers(CLASS_MEDIC) < #player.GetAll()/4 then
							if ply:GetNWBool("JobCD_" .. tostring(CLASS_MEDIC), false) then
								return "Quitter"
							end
							return 2
						else
							return "Full"
						end 
					end
					return "Exit" 
				end,
}

GM.OCRP_Dialogue["Job_Medic001"].Dialogue[2] = {Question = "Why yes there are, just sign here.", YesAnswer = "Alright.", NoAnswer = "Woah, I just wanted to help people, not sign anything.", 
Condition = function(ply)
	if team.NumPlayers(CLASS_MEDIC) >= #player.GetAll()/4 then 
		return "Full"
	end
	return true
end, Function = function(ply)
    net.Start("OCRP_Job_Join")
	net.WriteInt(CLASS_MEDIC, 32)
	net.SendToServer() return 3 end,}-- Return the ending dialogue thing

GM.OCRP_Dialogue["Job_Medic001"].Dialogue[3] = {Question = "Okay, here is your equipment. Good luck.", YesAnswer = "Yea, like I need luck.", NoAnswer = "Lets rock.", Condition = function(ply) return true end,Function = function(ply) return "Exit" end,}

GM.OCRP_Dialogue["Job_Medic001"].Dialogue[4] = {Question = "You're running for mayor, you cannot be a paramedic.", YesAnswer = "Oh, okay. I'll go remove my ballot.", NoAnswer = "Well, screw you too!", Condition = function(ply) return true end, Function = function(ply) return "Exit" end, }

GM.OCRP_Dialogue["Job_TowTruck01"] = {
Dialogue = {},
}

GM.OCRP_Dialogue["Job_TowTruck01"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for a tow truck.", NoAnswer="You can't help me.",
Condition = function(ply)
					if ply:Team() == CLASS_Tow then
						return 2
					else
						return "Job"
					end
					return "Exit" 
				end,}
                
GM.OCRP_Dialogue["Job_TowTruck01"].Dialogue[2] = {Question = "Alright, here are the keys.", YesAnswer = "Awesome.", NoAnswer = "Thanks.", Condition = function(ply) return true end, Function = function(ply) 
net.Start("OCRP_SpawnTow")
net.SendToServer()
return "Exit" end,}
GM.OCRP_Dialogue["Job_TowTruck01"].Dialogue["Job"] = { Question = "You're not a tow truck driver. Scram.", YesAnswer = "Oh, I'll go sign up now.", NoAnswer = "And you're a loser!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_CopCar01"] = {
Dialogue = {},
}

GM.OCRP_Dialogue["Job_CopCar01"].Dialogue["Enough"] = {Question = "Enough cars are out, patrol with another cop.", YesAnswer = "Oh okay. I'll go find a partner.", NoAnswer = "I didn't sign up for this.", Condition = function(ply) return true end, Function = function(ply) return "Exit" end, }

GM.OCRP_Dialogue["Job_CopCar01"].Dialogue["Job"] = { Question = "You're not a cop. Scram.", YesAnswer = "Oh, I'll go sign up now.", NoAnswer = "And you're a loser!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_CopCar01"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for a service vehicle." , NoAnswer = "You can't help me.",
Condition = function(ply)
					if ply:Team() > 1 then
						if ply:Team() == CLASS_POLICE || ply:Team() == CLASS_CHIEF then
							if TotalCopCars() >= math.Round((#team.GetPlayers(CLASS_POLICE) + #team.GetPlayers(CLASS_CHIEF)) / 2) then
                                if ply:GetLevel() > 3 then
                                    return "Enough"
                                end
							end
							return 2
						elseif ply:Team() == CLASS_SWAT then
							return 3
						else
							return "Job"
						end
					else
						return "Job"
					end
					return "Exit" 
				end,
}

GM.OCRP_Dialogue["Job_CopCar01"].Dialogue[2] = {Question = "Which service vehicle would you like?", YesAnswer = "I'll take the Evo X.", NoAnswer = "I want a SWAT van!", SecondYes = true, Condition = function(ply) return true end,
Function = function(ply) 
	net.Start("OCRP_SpawnPolice")
	net.SendToServer()
	return 3
end,
Function2 = function(ply)
	if ply:Team() == CLASS_SWAT then
		net.Start("OCRP_SpawnSWAT")
		net.SendToServer()
		return 3
	end
	return "SWAT"
end,}-- Return the ending dialogue thing

GM.OCRP_Dialogue["Job_CopCar01"].Dialogue[3] = {Question = "Here are the keys.", YesAnswer = "Alright.", NoAnswer = "Nice.", Condition = function(ply) return true end,Function = function(ply) 
return "Exit" end,}

GM.OCRP_Dialogue["Job_CopCar01"].Dialogue["SWAT"] = {Question = "You're not part of the SWAT force.", YesAnswer = "I guess I'll go ask for a promotion.", NoAnswer = "Well neither are you, loser.", Condition = function(ply) return true end,
Function = function(ply)
return "Exit"
end,}

GM.OCRP_Dialogue["Job_Ambulance01"] = {
Dialogue = {}
}
GM.OCRP_Dialogue["Job_Ambulance01"].Dialogue["Job"] = { Question = "You're not a paramedic. Scram.", YesAnswer = "Oh, I'll go sign up now.", NoAnswer = "And you're a loser!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Ambulance01"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for an ambulance.", NoAnswer = "You can't help me.",
Condition = function(ply)  
					if ply:Team() > 1 then
						if ply:Team() == CLASS_MEDIC then
							return 2
						else
							return "Job"
						end
					else
						return "Job"
					end
					return "Exit" 
				end,
}

GM.OCRP_Dialogue["Job_Ambulance01"].Dialogue[2] = {Question = "Here are the keys.", YesAnswer = "Alright.", NoAnswer = "Nice.", Condition = function(ply) return true end,Function = function(ply)
net.Start("OCRP_SpawnAmbo")
net.SendToServer()
return "Exit" end,}-- Return the ending dialogue thing
---
GM.OCRP_Dialogue["Job_FireEngine01"] = {
Dialogue = {}
}
GM.OCRP_Dialogue["Job_FireEngine01"].Dialogue["Job"] = { Question = "You're not a fireman. Scram.", YesAnswer = "Oh, I'll go sign up now.", NoAnswer = "And you're a loser!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_FireEngine01"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for a fire engine.", NoAnswer = "You can't help me.",
Condition = function(ply)  
					if ply:Team() > 1 then
						if ply:Team() == CLASS_FIREMAN then
							return 2
						else
							return "Job"
						end
					else
						return "Job"
					end
					return "Exit" 
				end,
}

GM.OCRP_Dialogue["Job_FireEngine01"].Dialogue[2] = {Question = "Here are the keys, it's parked outside.", YesAnswer = "Alright.", NoAnswer = "Nice.", Condition = function(ply) return true end,Function = function(ply)
net.Start("OCRP_SpawnFireEngine")
net.SendToServer()
return "Exit" end,}-- Return the ending dialogue thing
--


--Organization
GM.OCRP_Dialogue["Org"] = {
Dialogue = {},
}

GM.OCRP_Dialogue["Org"].Dialogue["Create"] = {Question = "That's going to cost you $5000.", YesAnswer = "Okay, that's fine!", NoAnswer = "Wow, I don't have that kind of cash.", Condition = function(ply) return true end, Function = function(ply) OpenOrgCreation() return "Exit" end,}
GM.OCRP_Dialogue["Org"].Dialogue["InOrg"] = {Question = "You must quit your current one first.", YesAnswer = "Oh, okay. I'd like to quit.", NoAnswer = "I think I'll pass, I like mine!", Condition = function(ply) return true end, Function =
    function(ply)
        return "AreYouSure"
    end
}
GM.OCRP_Dialogue["Org"].Dialogue[1] = {Question = "Hello there, are you looking to start an Organization?.", YesAnswer = "Yeah, that sounds exciting!", NoAnswer = "I really don't think it's really for me, bye.",
Condition = function(ply)
					if ply:GetOrg() > 0 then
						return "InOrg"
					else
						return "Create"
					end
				end,
}
GM.OCRP_Dialogue["Org"].Dialogue["AreYouSure"] = {Question = "Are you sure you want to quit your org?", YesAnswer = "Yes. Please remove me from it.", NoAnswer = "No, nevermind, I want to stay in it.", Condition = function(ply) return true end, Function =
    function(ply)
        net.Start("OCRP_QuitOrg")
        net.SendToServer()
        return "Exit"
    end
}

--[[GM.OCRP_Dialogue["Hydro"] = {
Dialogue = {},
}

GM.OCRP_Dialogue["Hydro"].Dialogue["BuyHydro"] = {Question = "You can have them, but at a price of $25,000", YesAnswer = "I'll take that deal!", NoAnswer = "I don't think I'm ready.", Condition = function(ply) return true end, Function = function(ply) RunConsoleCommand("ocrp_no") return "Exit" end,}
GM.OCRP_Dialogue["Hydro"].Dialogue["Already"] = {Question = "Yo, you already have Hydraulics on your car.", YesAnswer = "Oh, yeah, bye.", NoAnswer = "Woops, I brought the wrong car!", Condition = function(ply) return true end, Function = function(ply) return "Exit" end, }
GM.OCRP_Dialogue["Hydro"].Dialogue[1] = {Question = "Hello there, are you looking for Hydraulics?", YesAnswer = "Yeah, I'm that kinda person.", NoAnswer = "I'm not a pimp, no, thanks.",
Condition = function(ply)
	for k, v in pairs(ents.FindInSphere( ply:GetPos(), 400 )) do
		if v:GetClass() == "prop_vehicle_jeep" then
			if v:GetNWInt("Owner") == ply:EntIndex() then
				tehthing = v
				if (SERVER) then
					if v.Hydros then
					else
					end
				end
				break
			end
		end
	end
	return false
end,
}]]


GM.OCRP_Dialogue["Job_Mayor001"] = {
Dialogue = {},
Condition = function(ply)  
				if ply:Team() == CLASS_Mayor then
					return "Quit"
				end
                if ply:GetNWBool("InBallot", false) then
                    return "QuitBallot"
                end
				return 1 
			end,
}
GM.OCRP_Dialogue["Job_Mayor001"].Dialogue["Full"] = { Question = "There is already a mayor.", YesAnswer = "Oh okay. I'll run in the next election.", NoAnswer = "You jerk!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Mayor001"].Dialogue["Job"] = { Question = "Quit your current job first, then we can talk.", YesAnswer = "Oh okay, I'll go do that.", NoAnswer = "But I like this job!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Mayor001"].Dialogue["QuitBallot"] = {Question = "How may I help you today?", YesAnswer = "I'd like to withdraw my ballot.", NoAnswer = "I don't want your help.",Condition = function(ply) return true end,Function = function(ply) net.Start("OCRP_RemoveBallot") net.SendToServer() return "Exit" end,}

GM.OCRP_Dialogue["Job_Mayor001"].Dialogue["Quit"] = {Question = "How may I help you today?", YesAnswer = "I'd like to resign as the mayor.", NoAnswer = "I don't want your help.",Condition = function(ply) return true end,Function = function(ply) net.Start("OCRP_Job_Quit") net.SendToServer() return "Exit" end,}

GM.OCRP_Dialogue["Job_Mayor001"].Dialogue["Quitter"] = {Question = "You can't run again so soon, it's against the law.", YesAnswer = "Oh sorry, I'll try next time.", NoAnswer = "Wow, what a dumb law.", Condition = function(ply) return true end, Function = function(ply) return "Exit" end, }

GM.OCRP_Dialogue["Job_Mayor001"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking to become the mayor of this town!", NoAnswer = "You can't help me.",
Condition = function(ply)  
					if team.NumPlayers(CLASS_Mayor) >= 1 && ply:Team() != CLASS_Mayor then return "Full" end
					if ply:GetNWBool("InBallot", false) then
						return "QuitBallot"
					end
					if ply:Team() == CLASS_Mayor then
						return "Quit"
					elseif ply:Team() == CLASS_CITIZEN then
						if ply:GetNWBool("JobCD_" .. tostring(CLASS_Mayor), false) then
							return "Quitter"
						end
						return 2
					else
						return "Job"
					end
					return "Exit" 
				end,
}

GM.OCRP_Dialogue["Job_Mayor001"].Dialogue[2] = {Question = "Okay, all you have to do is enter your ballot.", YesAnswer = "Sweet, put my name down!", NoAnswer = "Woah, I just wanted money, not responsibility.", Condition = function(ply) net.Start("OCRP_AddBallot") net.SendToServer() return 3 end,Func = function(ply)  end,}-- Return the ending dialogue thing

GM.OCRP_Dialogue["Job_Mayor001"].Dialogue[3] = {Question = "Good luck.", YesAnswer = "Yea, like I need luck.", NoAnswer = "Time to win some votes!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end,}

GM.OCRP_Dialogue["Skin_001"] = {
Dialogue = {},
}

GM.OCRP_Dialogue["Skin_001"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking to respray my car.", NoAnswer = "I want to buy some hydraulics.", SecondYes = true, Condition = function(ply)
	tehthing = nil
    for k, v in pairs(ents.FindInSphere( ply:GetPos(), 400 )) do
		if v:GetClass() == "prop_vehicle_jeep" then
			if v:GetNWInt("Owner") == ply:EntIndex() then
				tehthing = v
				return true
			end
		end
	end
	return true
end,
 
 Function = function(ply)
    if !tehthing then
        return "NoCar"
    end
	net.Start("CL_ShowSkin")
	net.WriteString(tehthing:GetCarType())
	net.SendToServer()
        return "Exit" 
    end,
 Function2 = function(ply)
	if !tehthing then
		return "NoCar"
	end
    return "BuyHydro"
 end,}
 
GM.OCRP_Dialogue["Skin_001"].Dialogue["NoCar"] = {Question = "I can't upgrade your car if it's not here.", YesAnswer = "Oh okay, I'll go get it.", NoAnswer = "Nevermind then, bye.", Condition =
	function(ply)
		return true
	end,
	Function = function(ply)
		return "Exit"
	end
}

GM.OCRP_Dialogue["Skin_001"].Dialogue["BuyHydro"] = {Question = "Okay, those hydraulics will cost you $25,000.", YesAnswer = "Alright, go for it.", NoAnswer = "Woah, no way dude, that's too much.", Condition = function(ply) return true end,Function = function(ply) net.Start("ocrp_bhydros") net.SendToServer() return "Exit" end,}-- Return the ending dialogue thing

GM.OCRP_Dialogue["Skin_002"] = {
Dialogue = {},
}

GM.OCRP_Dialogue["Skin_002"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I want underglow for my car.", NoAnswer = "I was hoping to install nitrous on my car.", SecondYes = true, Condition = function(ply)
    theskin002car = nil
    for k,v in pairs(ents.FindInSphere(ply:GetPos(), 400)) do
        if v:GetClass() == "prop_vehicle_jeep" then
            if v:GetNWInt("Owner") == ply:EntIndex() then
                theskin002car = v
                return true
            end
        end
    end
    return true
end,

Function = function(ply)
    if !theskin002car then
        return "NoCar"
    end
    return "BuyUnderglow"
end,

Function2 = function(ply)
    if !theskin002car then
        return "NoCar"
    end
    return "BuyNitrous"
end}

GM.OCRP_Dialogue["Skin_002"].Dialogue["NoCar"] = {Question = "I can't upgrade your car if it isn't here.", YesAnswer = "Oh okay, I'll go get it.", NoAnswer = "Nevermind then, bye.", Condition =
	function(ply)
		return true
	end,
	Function = function(ply)
		return "Exit"
	end,
}

GM.OCRP_Dialogue["Skin_002"].Dialogue["BuyUnderglow"] = {Question = "Okay, underglow is going to cost you $15,000.", YesAnswer = "Alright, let me see the color choices.", NoAnswer = "Woah, no way dude, I can't afford that.", Condition =
    function(ply)
        return true
    end,
    Function = function(ply)
        ShowColors("Underglow")
        return "Exit"
    end
}

GM.OCRP_Dialogue["Skin_002"].Dialogue["BuyNitrous"] = {Question = "Okay, nitrous is going to put you back $30,000.", YesAnswer = "Alright, I can live with that.", NoAnswer = "Wow, nevermind, that's way out of my budget.", Condition =
    function(ply)
        return true
    end,
    Function = function(ply)
        net.Start("OCRP_Buy_Nitrous")
        net.SendToServer()
        return "Exit"
    end
}

GM.OCRP_Dialogue["Skin_003"] = {
Dialogue = {},
}

GM.OCRP_Dialogue["Skin_003"].Dialogue[1] = {Question = "How can I help you today?", YesAnswer = "I want headlights for my car.", NoAnswer = "I'd like to color my headlights.", SecondYes = true, Condition =
	function(ply)
	theskin003car = nil
    for k,v in pairs(ents.FindInSphere(ply:GetPos(), 400)) do
        if v:GetClass() == "prop_vehicle_jeep" then
            if v:GetNWInt("Owner") == ply:EntIndex() then
                theskin003car = v
                return true
            end
        end
    end
    return true
	end,
	Function = function(ply)
		if !theskin003car or !theskin003car:IsValid() then
			return "NoCar"
		end
		return "BuyHeadlights"
	end,
	Function2 = function(ply)
		if !theskin003car or !theskin003car:IsValid() then
			return "NoCar"
		end
		if theskin003car:GetNWString("Headlights") == nil or theskin003car:GetNWString("Headlights") == "" then
			return "NoHeadlights"
		end
		return "ColorHeadlights"
	end
}

GM.OCRP_Dialogue["Skin_003"].Dialogue["NoHeadlights"] = {Question = "You need headlights already installed to change the color.", YesAnswer = "Oh okay, I'll come back after I do that.", NoAnswer = "Nevermind, screw this.", Condition = 
	function(ply)
		return true
	end,
	Function = function(ply)
		return "Exit"
	end
}

GM.OCRP_Dialogue["Skin_003"].Dialogue["NoCar"] = {Question = "I can't work on your headlights if your car isn't here.", YesAnswer = "Oh okay, I'll go get it.", NoAnswer = "Sorry, I forgot.", Condition = 
	function(ply)
		return true
	end,
	Function = function(ply)
		return "Exit"
	end
}

GM.OCRP_Dialogue["Skin_003"].Dialogue["BuyHeadlights"] = {Question = "Okay, that'll be $50,000.", YesAnswer = "Alright, go ahead and install them.", NoAnswer = "Whoa, I can't afford that.", Condition =
	function(ply)
		return true
	end,
	Function = function(ply)
		net.Start("OCRP_Buy_Headlights")
		net.WriteString("White")
		net.SendToServer()
		return "Exit"
	end
}

GM.OCRP_Dialogue["Skin_003"].Dialogue["ColorHeadlights"] = {Question = "Okay, that'll be $50,000.", YesAnswer = "Alright, let me see the color choices.", NoAnswer = "Wow, no way I can afford that.", Condition =
	function(ply)
		return true
	end,
	Function = function(ply)
		ShowColors("Headlight")
		return "Exit"
	end
}

GM.OCRP_Dialogue["Heal"] = {
Dialogue = {}
}

GM.OCRP_Dialogue["Heal"].Dialogue[1] = {Question = "How can I help you?", YesAnswer = "I need some medical attention!", NoAnswer = "You can't. Bye.",
Condition = function(ply)
    if ply:Health() >= 100 then
        return "FullHealth"
    end
    return 2
end,
}

GM.OCRP_Dialogue["Heal"].Dialogue[2] = {Question = "Okay, but that's gonna cost you $2,500.", YesAnswer = "That's fine. I really need the help.", NoAnswer = "Woah! Stitches aren't that expensive!",
Condition = function(ply)
    return true
end,
Function = function(ply)
    net.Start("OCRP_HealPlayer")
    net.SendToServer()
    return "Exit"
end,
}

GM.OCRP_Dialogue["Heal"].Dialogue["FullHealth"] = {Question = "I don't see any injuries on you. Get lost.", YesAnswer = "Oh I must have healed on my way here..", NoAnswer = "Well now my feelings need a heal!",
Condition = function(ply) return true end,
Function = function(ply) return "Exit" end,
}

GM.OCRP_Dialogue["Repair"] = {
Dialogue = {},
}

GM.OCRP_Dialogue["Repair"].Dialogue[1] = {Question = "How can I help you?", YesAnswer = "I'm hoping to get my car fixed.", NoAnswer = "You can't. Bye.",
Condition =
    function(ply)
        local car = nil
        for k,v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
            if v:GetPos():Distance(ply:GetPos()) < 500 then
                if v:GetNWInt("Owner") > 0 and v:GetNWInt("Owner") == ply:EntIndex() then
                    car = v
                end
            end
        end
        if car and car:IsValid() then
            local max = GAMEMODE.OCRP_Cars[car:GetNWString("Type", "")] and GAMEMODE.OCRP_Cars[car:GetNWString("Type", "")].Health or 100
            if car:Health() < max then
                return 2
            else
                return "NotBroken"
            end
        else
            return "NoCar"
       end
    end,
}

GM.OCRP_Dialogue["Repair"].Dialogue[2] = {FormatRepairPrice = true, Question = "Okay, that'll cost you $%s!", YesAnswer = "Alright, I can deal with that.", NoAnswer = "Woah nevermind, I don't have that kind of cash.",
Condition = 
    function(ply)
        return true
    end,
Function = 
    function(ply)
        net.Start("OCRP_Repair_Car")
        net.SendToServer()
        return "Exit"
    end,
}

GM.OCRP_Dialogue["Repair"].Dialogue["NoCar"] = {Question = "You don't have a car here to repair, quit wasting my time.", YesAnswer = "Oops, I'll go get it", NoAnswer = "Well screw you too!",
Condition = function(ply) return true end,
Function = function(ply) return "Exit" end,
}
GM.OCRP_Dialogue["Repair"].Dialogue["NotBroken"] = {Question = "Your car isn't broken, quit wasting my time.", YesAnswer = "Oh okay, I'll go smash it up!", NoAnswer = "Yeah... Of course. That's obvious. I totally knew that!",
Condition = function(ply) return true end,
Function = function(ply) return "Exit" end,
}

OCRPCfg[CLASS_POLICE] = {
	Weapons = {"police_ram_ocrp","police_handcuffs","weapon_copgun_ocrp","police_baton","weapon_taser_ocrp"},
	Condition = function() 
					if team.NumPlayers(CLASS_POLICE) < #player.GetAll()/3 then 
						return true 
					end 
				return false 
			end,

	}
OCRPCfg[CLASS_CHIEF] = {
	Weapons = {"police_ram_ocrp","police_handcuffs","weapon_copgun_ocrp","police_baton","weapon_taser_ocrp"},
	Condition = function() 
				return true 
			end,

	}
OCRPCfg[CLASS_SWAT] = {
	Weapons = {"swat_usp_ocrp","police_baton","weapon_taser_ocrp"},
	Condition = function() 
				return true 
			end,

	}	
OCRPCfg[CLASS_MEDIC] = {
	Weapons = {"medic_health_ocrp","paramedic_charge",},
	Condition = function(ply) 
					if team.NumPlayers(CLASS_MEDIC) < #player.GetAll()/4 then 
						return true 
					end 
				return false 
			end,

	}
	
OCRPCfg[CLASS_FIREMAN] = {
	Weapons = {"fire_axe","fire_extinguisher","fire_hose",},
	Condition = function(ply) 
					if team.NumPlayers(CLASS_FIREMAN) < #player.GetAll()/4 then 
						return true 
					end 
				return false 
			end,

	}
	
OCRPCfg[CLASS_Mayor] = {
	Weapons = {},
	Condition = function(ply) 
					if team.NumPlayers(CLASS_Mayor) < 1 then 
						return true 
					end 
				return false 
			end,

	}
    
OCRPCfg[CLASS_Tow] = {
    Weapons = {}, -- add wrench or something
    Condition = function(ply)
        if team.NumPlayers(CLASS_Tow) < #player.GetAll()/4 then
            return true
        end
        return false
    end,
    }
	
OCRPCfg[CLASS_TAXI] = {
	Weapons = {},
	Condition = function(ply)
		if team.NumPlayers(CLASS_TAXI) < #player.GetAll()/4 then
			return true
		end
		return false
	end,
}
    
function TotalCopCars()
	Number = 0
	for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
		if v:IsValid() then
            if v:GetModel() == "models/tdmcars/emergency/mitsu_evox.mdl" then
                Number = Number + 1
            end
		end
    end
    return Number
end