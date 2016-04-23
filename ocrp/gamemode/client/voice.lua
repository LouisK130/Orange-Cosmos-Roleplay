
ChatRadius_Whisper = 200;
ChatRadius_Local = 600;
ChatRadius_Yell = 800;

local function thinkRadioStatic ( )
	if (GAMEMODE.PlayStatic) then
		if (!GAMEMODE.StaticNoise) then
			GAMEMODE.StaticNoise = CreateSound(LocalPlayer(), "/ocrp/cradio_static.mp3");
		end
		
		if (!GAMEMODE.NextStaticPlay || GAMEMODE.NextStaticPlay < CurTime()) then
			GAMEMODE.NextStaticPlay = CurTime() + SoundDuration("/ocrp/cradio_static.mp3") - .1;
			GAMEMODE.StaticNoise:Stop();
			GAMEMODE.StaticNoise:Play();
		end
	elseif (GAMEMODE.NextStaticPlay) then
		GAMEMODE.NextStaticPlay = nil;
		GAMEMODE.StaticNoise:Stop();
	end
end
hook.Add("Think", "thinkRadioStatic", thinkRadioStatic);

local function PlayerStartVoice ( ply ) 
		--print("start.\n");
	if (ply == LocalPlayer()) then GAMEMODE.CurrentlyTalking = true; return; end
	
	if (ply:GetPos():Distance(LocalPlayer():GetPos()) > (ChatRadius_Local + 50) && ply:Team() != CLASS_CITIZEN && ply:Team() != CLASS_MAYOR) then
		GAMEMODE.PlayStatic = true;
		ply.PlayingStaticFor = true;
		--Msg("start.\n");
		surface.PlaySound("ocrp/cradio_start.mp3");
	end
end
hook.Add( "PlayerStartVoice", "PlayerStartedTheirVoice", PlayerStartVoice)
	
local function PlayerEndVoice ( ply ) 
	if (ply == LocalPlayer()) then GAMEMODE.CurrentlyTalking = nil; return ;end
	
	if (ply.PlayingStaticFor) then
		ply.PlayingStaticFor = nil;
		--Msg("stop.\n");
		surface.PlaySound("ocrp/cradio_close.mp3");
	end
	
	if (!GAMEMODE.PlayStatic) then return; end
	
	local shouldPlayStatic = false;
	for k, v in pairs(player.GetAll()) do
		if (v.PlayingStaticFor) then
			shouldPlayStatic = true;
		end
	end
	
	GAMEMODE.PlayStatic = shouldPlayStatic;
end
hook.Add( "PlayerEndVoice", "PlayerEndedTheirVoice", PlayerEndVoice)
local function monitorKeyPress_WalkieTalkie ( )
 LocalPlayer().StringRedun = LocalPlayer().StringRedun or {};
 if vgui.GetKeyboardFocus() != nil then return end
 if TYPING then return; end
  if LocalPlayer().TYPING then return; end
  if LocalPlayer():Team() == CLASS_CITIZEN or LocalPlayer():Team() == CLASS_TAXI or LocalPlayer():Team() == CLASS_Tow then return end

	if (input.IsKeyDown(KEY_H)) then
		if (!GAMEMODE.lastTDown) then
			GAMEMODE.lastTDown = true;
			
			if (LocalPlayer():GetNWBool("tradio", false)) then
				RunConsoleCommand("ocrp_tr", "0");
				LocalPlayer().StringRedun["tradio"] = {entity = LocalPlayer(), value = false};
			else
				RunConsoleCommand("ocrp_tr", "1");
				LocalPlayer().StringRedun["tradio"] = {entity = LocalPlayer(), value = true};
			end
		end
	else GAMEMODE.lastTDown = nil; end
end
hook.Add("Think", "monitorKeyPress_WalkieTalkie", monitorKeyPress_WalkieTalkie);

