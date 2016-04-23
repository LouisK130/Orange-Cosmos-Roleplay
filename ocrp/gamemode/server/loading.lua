--[[local retried = false
function GM:LoadSQL( ply )
	if !ply:IsValid() then return end
	timer.Simple(4, function()
		if !ply:IsValid() then return end
		runOCRPQuery( "SELECT wallet, bank, blacklist, buddies, inv, cars, skills, wardrobe, face, playtime, storage, clothes FROM ocrp_users WHERE STEAM_ID='".. ply:SteamID() .."'",
		function( Results)
			if #Results >= 1 and Results[1]["wallet"] and Results[1]["wallet"] != "" then
                GAMEMODE.PlayTimes[ply:SteamID()]["Total"] = Results[1]["playtime"]
                net.Start("OCRP_Update_PlayTime")
                    net.WriteInt(GAMEMODE.PlayTimes[ply:SteamID()]["Total"], 32)
                    net.WriteInt(0, 32) -- session is 0, just starting
                net.Send(ply)
				if Results[1]["model"] then ply:SetModel( Results[1]["model"] ) end
				if Results[1]["model"] == "" or Results[1]["face"] == "" then
					ply:SetModel("models/ocrp2players/clothes1/10/male_01.mdl")
					net.Start("OCRP_ShowStartModel")
					net.Send(ply)
				end
				ply:SetMoney( WALLET, tonumber(Results[1]["wallet"]) )
				ply:SetMoney( BANK, tonumber(Results[1]["bank"]) )
				timer.Simple(.3, function()
					runOCRPQuery( "UPDATE `ocrp_users` SET `nick` = '".. ocrpdb:escape(ply:Nick()) .."' WHERE `STEAM_ID` = '".. ply:SteamID() .."'" )
				end)
				ply:UnCompileString("inv", Results[1]["inv"])
				ply:UnCompileString("car", Results[1]["cars"])
				ply:UnCompileString("skill", Results[1]["skills"])
                ply:UnCompileString("storage", Results[1]["storage"])
                ply:UnCompileString("warnings", Results[1]["warnings"])
				ply.OCRPData["Face"] = Results[1]["face"] or ""
				ply.OCRPData["Gender"] = string.find(ply.OCRPData["Face"], "female") and "Female" or "Male"
				ply:UnCompileString("wardrobe", Results[1]["wardrobe"])
                ply:UnCompileString("blacklists", Results[1]["blacklist"])
                ply:UnCompileString("buddies", Results[1]["buddies"])
				ply.Loaded = true
			else
				NewRPUser( ply )
				ply.Loaded = true
			end
		end,
		function(err)
			if not retried and ply:IsValid() then
				retried = true
				GAMEMODE:LoadSQL(ply)
			elseif ply:IsValid() then
				ply:Kick("There was an error loading your information. Please try rejoining. If this persists, report it on the forums.")
			end
		end)
	end)
	timer.Simple(5, function()
		if !ply:IsValid() then return end
		runOCRPQuery( "SELECT org_id FROM `ocrp_users` WHERE `STEAM_ID` = '".. ply:SteamID() .."'",
		function( results )
			if #results >= 1 then
				ply:SetOrg(results[1]["org_id"])
				if results and results[1]["org_id"] then
					ply.Org = results[1]["org_id"]
					ply:SetNWInt("org_id", results[1]["org_id"])
				end
				if tonumber(results[1]["org_id"]) != 0 then
					if !GAMEMODE.Orgs[ply.Org] then
                        if not ply:GetOrg() then return end
						runOCRPQuery("SELECT org_name, org_owner, org_notes FROM `ocrp_orgs` WHERE `org_id` = '".. ply:GetOrg() .."'", function( Results )
							if #Results == 0 then return false end
							GAMEMODE.Orgs[ply:GetOrg()] = {}
							GAMEMODE.Orgs[ply:GetOrg()].Members = {}
							GAMEMODE.Orgs[ply:GetOrg()].Name = Results[1]["org_name"]
							GAMEMODE.Orgs[ply:GetOrg()].Owner = Results[1]["org_owner"]
							GAMEMODE.Orgs[ply:GetOrg()].Notes = Results[1]["org_notes"]
							runOCRPQuery("SELECT `STEAM_ID`, `nick` FROM `ocrp_users` WHERE `org_id` = '".. ply:GetOrg() .."'", function( Res )
								for k, v in pairs(Res) do
									table.insert(GAMEMODE.Orgs[ply:GetOrg()].Members, {Name = Res[k]["nick"], SteamID = Res[k]["STEAM_ID"]})
								end
								SendOrg( ply )
							end)
						end)
						timer.Simple(.7, function()
                            if not ply:GetOrg() or not GAMEMODE.Orgs[ply:GetOrg()] then return end
							if string.len( GAMEMODE.Orgs[ply:GetOrg()].Name ) > 25 then
								ply:SetNWString("OrgName", "Org name exceeds 25 chars")
							else
								ply:SetNWString("OrgName", GAMEMODE.Orgs[ply:GetOrg()].Name)
							end
							SecondaryID( ply )
						end)
					else
                        if not ply:GetOrg() or not ply.Org then return end
						SendOrg( ply )
						if string.len( GAMEMODE.Orgs[ply:GetOrg()].Name ) > 25 then
							ply:SetNWString("OrgName", "Org name exceeds 25 chars")
						else
							ply:SetNWString("OrgName", GAMEMODE.Orgs[ply:GetOrg()].Name)
						end
						timer.Simple(1, function()
							SecondaryID( ply )
						end)
					end
				end
				ply.Loaded = true
			else
				ply.Loaded = true
			end
		end)
	end)
    timer.Simple(7, function()
        if !ply:IsValid() then return end
        runOCRPQuery("SELECT * FROM `ocrp_users` WHERE `refedby`='" .. ply:SteamID() .. "';", function(results)
            if results and results[1] then
                for _,refed in pairs(results) do
                    if tonumber(refed["playtime"]) < 60 then continue end
                    ply:Hint("Thanks for referring your friend! Here's $5000 to show our gratitude!")
                    ply:SetMoney("Wallet", ply:GetMoney("Wallet") + 5000)
                    SaveMoney(ply)
                    runOCRPQuery("UPDATE `ocrp_users` SET `refedby`='" .. refed["refedby"] .. "|true' WHERE `STEAM_ID`='" .. refed["STEAM_ID"] .. "';")
                end
            end
        end)
    end)
	SendOrg(ply)
	timer.Simple(15, function()
	if not ply.Loaded then
		if not retried then
			GAMEMODE:LoadSQL(ply)
			retried = true
		else
			if ply:IsValid() then
				ply:Kick("There was an error loading your information. Please try rejoining. If this persists, report it on the forums.")
			end
		end
	end
	end)
end]]