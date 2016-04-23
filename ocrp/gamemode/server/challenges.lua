//////////////////////////////
///      CHALLENGES        ///
//////////////////////////////
GM.Challenges = {}

function OCRP_Challenge_Add( name, desc, reward, pro, item, event )
	table.insert(GAMEMODE.Challenges, {Name = name, Desc = desc, Reward = reward, Pro = pro, Item = item, Event = event})
end

function OCRP_Challenge_Add_Ingame( ply, name, desc, reward, pro, item, event )
	if !ply:IsSuperAdmin() then return end
	
	runOCRPQuery( "INSERT INTO `ocrp_challenges` (`Name`, `Desc`, `Reward`, `Pro`, `Item`, `Event`) VALUES('".. name .."', '".. desc .."', '".. reward .."', '".. pro .."', '".. item .."', '".. event .."')" )
	
	OCRP_Challenge_Add( name, desc, reward, pro, item, event )
end

function OCRP_Challenge_Start( ply, challenge )
	Msg( "[OCRP - Debug] Starting challenge: ".. challenge )
	ply.OCRPData["Challenges"][challenge] = {}
	ply.OCRPData["Challenges"][challenge].Num = 0
end

function OCRP_Challenges_Load()
	runOCRPQuery( "SELECT * FROM `ocrp_challenges`",
	function( results )
		for k, v in pairs(results) do
			OCRP_Challenge_Add( results[k][v['Name']], results[k][v['Desc']], results[k][v['Reward']], results[k][v['Pro']], results[k][v['Item']], results[k][v['Event']] )
			Msg( "Added Challenge >>> ".. results[k][v['Name']] )
		end
	end)
end

function OCRP_Challenge_Ach( ply, challenge )
	Msg( "[OCRP - Debug] Completed challenge!" )
	local Data = ply.OCRPData["Challenges"][challenge]
	local PLYTbl = ply.OCRPData["Challenges"]
	local GMTbl = GAMEMODE.Challenges[challenge]
	
	if Data.Num < GMTbl.Amount then
		Msg( "[OCRP - Debug] Not enough progress to complete!" )
	end
	
	if GMTbl.Unlocks then
		PLYTbl[GMTbl.Unlocks] = PLYTbl[GMTbl.Unlocks] or {}
		PLYTbl[GMTbl.Unlocks].Num = 0
		PLYTbl[GMTbl.Unlocks].CanDo = true
	end
	
	Data.Complete = true
	Msg("Challenge complete!")
	
	OCRP_Challenge_UMSG( ply, challenge, true )
		
end

function OCRP_Challenge_UMSG( ply, challenge, full )
	--Msg( "[OCRP - Debug] -> Running OCRP_Challenge_UMSG" )
	if full then
		--Msg( "[OCRP - Debug] -> Sending usermessage full" )
		umsg.Start( "OCRP_Challenge_Full", ply )
			umsg.String( challenge )
			umsg.Short( ply.OCRPData["Challenges"][challenge].Num )
			umsg.Bool( ply.OCRPData["Challenges"][challenge].CanDo )
			umsg.Bool( ply.OCRPData["Challenges"][challenge].Complete )
		umsg.End()
	else
		umsg.Start( "OCRP_Challenge_Small", ply )
			umsg.String( challenge )
			umsg.Short( ply.OCRPData["Challenges"][challenge].Num )
		umsg.End()
	end
end

function OCRP_Challenge_Gain( ply, typea, info, progress, pro )
	local PLYTbl = ply.OCRPData["Challenges"]
	if typea == "Pro" then
		if pro == "Crafting" or pro == "Druggie" or pro == "Theft" then
			for k, v in pairs( GAMEMODE.Challenges ) do
				if v.Item == info and PLYTbl[v.Other].Num < GAMEMODE.Challenges[v.Other].Amount then
					if !PLYTbl[v.Other].Complete and PLYTbl[v.Other].CanDo then
						if PLYTbl[v.Other].Num + progress == GAMEMODE.Challenges[v.Other].Amount then
							PLYTbl[v.Other].Num = PLYTbl[v.Other].Num + progress
							OCRP_Challenge_Ach( ply, v.Other )
						else
							PLYTbl[v.Other].Num = PLYTbl[v.Other].Num + progress
							OCRP_Challenge_UMSG( ply, v.Other )
						end
					end
				end
			end
		end
	else
		if info == "Running" then
			if PLYTbl["Running_Two"].Num <= 0 then
				PLYTbl["Running_One"].Num = PLYTbl["Running_One"] + progress
			elseif PLYTbl["Running_Three"].Num <= 0 then
				PLYTbl["Running_Two"].Num = PLYTbl["Running_Two"] + progress
			else
				PLYTbl["Running_Three"].Num = PLYTbl["Running_Three"] + progress
			end
		end
	end	
end
		

					
		
function PMETA:OCRP_HasChallenge( challenge )
	if self.OCRPData["Challenges"][challenge] then
		return true
	else
		return false
	end
end
