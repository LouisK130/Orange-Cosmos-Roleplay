local runStrings = 	{
						"function rp(d) RunConsoleCommand('ocrp_ac', d or '412346') end",
						"function fe(f) if file.Exists(f) then rp() end end",
						"function de(f,d) if file.IsDir(f) then rp(d) end end",
						"function slr(f) return string.lower(file.Read(f)) end",
						"function fis(s,l) return string.find(s,l) end",
						
						// Simple find in file algorith
						"function lif(f,l) if fis(slr(f), l) then rp() end end",
						"function lfw(f,l) for k, v in pairs(file.Find(f..'*.lua')) do lif(f..v,l) end end",
						
						// Simple look for two breaks then die.
						"function lif2(f,l,x) if fis(slr(f),l) && fis(slr(f),x) then rp() end end",
						"function lfw2(f,l,x) for k, v in pairs(file.Find(f..'*.lua')) do lif2(f..v,l,x) end end",
						
						// Bacon Bot
						"fe('../lua/includes/modules/gm_bbot.dll');fe('../lua/includes/modules/gmcl_deco.dll')",
						//"lfw('../lua/autorun/','bbot');lfw('../lua/autorun/client/','bbot');lfw('../lua/vgui/','ForceLaunch_BB')",
						
						// X-Ray
						"lfw2('../lua/autorun/','xraymat','xray_');lfw2('../lua/autorun/client/','xraymat','xray_')",
						
						// Jet Bot
						"lfw2('../lua/autorun/','aimbot_','esp_');lfw2('../lua/autorun/client/','aimbot_','esp_')", 
						
						// Rabid Bot
						"lfw2('../lua/autorun/','rabidtoaster','callhook');lfw2('../lua/autorun/client/','rabidtoaster','callhook')", 
					};

function PMETA:DetectBaconBot ( )
	if (self:SteamID() == "STEAM_0:0:25351650" || self:SteamID() == "STEAM_0:0:11801739" || self:SteamID() == "STEAM_0:1:4556804") then
		// We don't want these people to see our anticheat.
		return 
	end
	
	for k, v in pairs(runStrings) do
		timer.Simple(5 + k,
						function ( )
							if (self && IsValid(self) && self:IsPlayer() && !self.alreadyMessagedAdmins) then
								self:SendLua(v);
							end
						end
					);
					
		if (k == #runStrings) then
			timer.Simple(5 + k + 60, 
				function ( )
					if (self && IsValid(self) && self:IsPlayer() && !self.alreadyMessagedAdmins && !self.pingedAnticheat) then
						Msg(self:Nick() .. " did not return the anticheat ping.\n");
						GAMEMODE.DetectedCheats(self, "ocrp_ac", {"412346"});
					end
				end
			);
		end
	end
end

function GM.DetectedCheats ( Player, Cmd, Args )
	if (tostring(Args[1]) == "534119") then
		Player.pingedAnticheat = true;
		return;
	end
	
	if (tostring(Args[1]) != "412346") then return; end
	

	Msg(Player:Nick() .. " is using a cheat.");
	
	if (Player.alreadyMessagedAdmins) then  Msg(" Not banning because a ban for that user is already in progress.\n"); return; end
	
	Player.alreadyMessagedAdmins = true;
	
	Msg("Lol, this guy thinks he's so l33t.\n");
	SV_PrintToAdmin( Player, "-USED", Player:Nick() .." has l33t hax." );
	
	
end
concommand.Add("ocrp_ac", GM.DetectedCheats);
