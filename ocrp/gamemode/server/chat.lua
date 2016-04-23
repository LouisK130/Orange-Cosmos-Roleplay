function GM:PlayerSay(pSpeaker, strText, bTeamOnly)
	if bTeamOnly then
		strText =  "// " .. strText
	end
	local type,msg,pmtarget = GetChatType(strText)
    if not pSpeaker:Alive() and type != "OOC" then
        pSpeaker:Hint("You can only use OOC chat while dead.")
        return ""
    end
    if type == "Advert" and !pSpeaker:HasItem("item_cell") then
        pSpeaker:Hint("You need a cellphone to make adverts.")
        return ""
    end
    if type == "PM" and !pSpeaker:HasItem("item_cell") then
        pSpeaker:Hint("You need a cellphone to PM other players.")
        return ""
    end
    if type == "Org" and !pSpeaker:HasItem("item_cell") then
        pSpeaker:Hint("You need a cellphone to use Org chat.")
        return ""
    end
    if type == "911" and !pSpeaker:HasItem("item_cell") then
        pSpeaker:Hint("You need a cellphone to call 911.")
        return ""
    end
    if type == "PM" and (not pmtarget or not pmtarget:IsValid()) then
        pSpeaker:Hint("Failed to find a valid PM target. Make sure you spelled their name correctly.")
        return ""
    end
    if type == "Gov Radio" and !pSpeaker:IsGov() and !pSpeaker:HasItem("item_policeradio") then
        pSpeaker:Hint("You need a police radio to use government chat.")
        return ""
    end
    if type == "Broadcast" and pSpeaker:Team() != CLASS_Mayor then
        pSpeaker:Hint("You must be the mayor to broadcast.")
        return ""
    end
    
	SV_PrintToAdmin(pSpeaker, type, msg)
	if type == "Command" then return "" end
	return strText
end

function GM:PlayerCanSeePlayersChat( strText, bTeamOnly, pListener, pSpeaker )
	if pListener.SpecEntity != nil then
		pListener = pListener.SpecEntity
	end
	if bTeamOnly then
		return true
	end
	local chatType,msg,pmtarget = GetChatType(strText)
	if chatType == false then return false end
    
    if pListener == pSpeaker then
        return true
    end
	
	if not pSpeaker:Alive() and chatType != "OOC" then
		return false
	end
	
	local dist = pSpeaker:GetPos():Distance(pListener:GetPos())
	
	if chatType == "OOC" then
		return true
	end
	
	if chatType == "Local"  or chatType == "Emote" or chatType == "LOOC" then
		if pSpeaker:Visible(pListener) then
			return dist <= 600
		else
			return dist <= 300
		end
	end
	
	if chatType == "To Admins" then
		return pListener:GetLevel() <= 2
	end
	
	if chatType == "Advert" then
		return pSpeaker:HasItem("item_cell")
	end
	
	if chatType == "PM" then
		if pSpeaker:HasItem("item_cell") then
			if pmtarget and pmtarget:IsValid() and pListener == pmtarget then
                return true
            end
		end
		return false
	end
	
	if chatType == "Org" then
		if pSpeaker:HasItem("item_cell") then
			return pSpeaker:GetOrg() == pListener:GetOrg()
		end
		return false
	end

	if chatType == "911" then
		if pSpeaker:HasItem("item_cell") then
			return pListener:IsGov()
		end
		return false
	end
	
	if chatType == "Gov Radio" then
		if pSpeaker:HasItem("item_policeradio") then
			return pListener:IsGov()
		end
		return false
	end
	
	if chatType == "Yell" then
		if pSpeaker:Visible(pListener) then
			return dist <= 1000
		else
			return dist <= 600
		end
	end
	
	if chatType == "Whisper" then
		if pSpeaker:Visible(pListener) then
			return dist <= 300
		else
			return dist <= 150
		end
	end
	
	if chatType == "Broadcast" then
		return pSpeaker:Team() == 6
	end
	
	return false
end

--This doesn't even make sense?
--[[function ISaid( pSpeaker, strText, team, death )
	for _,ply1 in pairs(player.GetAll()) do
		if GAMEMODE:PlayerCanSeePlayersChat( strText, false, ply1, pSpeaker ) then
			return strText
		end
	end
end
hook.Add( "PlayerSay", "ISaid", ISaid );]]

net.Receive("OCRP_IsTyping", function(len, ply)
    local ent = net.ReadInt(32)
    local bool = net.ReadBool()
    net.Start("OCRP_IsTyping")
    net.WriteInt(ent, 32)
    net.WriteBool(bool)
    net.Broadcast()
end)					
net.Receive("OCRP_Broadcast", function(len, ply)
	if ply:Team() != CLASS_Mayor  then return end
	for _,ply1 in pairs(player.GetAll()) do
		umsg.Start("OCRP_CreateBroadcast", ply1)
		umsg.String(net.ReadString())
		umsg.Long(30)
		umsg.End()
	end
end)

--[[function GM:PlayerCanHearPlayersVoice( ply1, ply2 )
	if ply1.SpecEntity != nil then
		ply1 = ply1.SpecEntity
	end
	if !ply1:IsValid() or !ply2:IsValid() then return false end
	if !ply1:Alive() then return false end
	if !ply2:Alive() then return false end
	if ply1:GetPos():Distance(ply2:GetPos()) < 500 then 
		if ply1:Visible(ply2) then
			return true 
		elseif ply1:GetPos():Distance(ply2:GetPos()) < 150 then
			return true 
		end	
	end
	return false
end
]]

-- function PoliceRadioToggle( ply,cmd,args )
	-- if !ply.PoliceRadio then ply.PoliceRadio = true end
	-- if ply.PoliceRadio == true then
		-- ply.PoliceRadio = false
	-- else
		-- ply.PoliceRadio = true
	-- end
-- end
-- concommand.Add("OCRP_PoliceRadioToggle",PoliceRadioToggle)

-- function GM:PlayerCanHearPlayersVoice( ply1, ply2 )
	-- if ply1.SpecEntity != nil then
		-- ply1 = ply1.SpecEntity
	-- end
	-- if !ply1:IsValid() or !ply2:IsValid() then return false, false end
	-- if !ply1:Alive() then return false, false end
	-- if !ply2:Alive() then return false, false end
	-- if (ply2:Team() != CLASS_CITIZEN and ply2.PoliceRadio == true) and (ply1:Team() != CLASS_CITIZEN) then
		-- return true
	-- end
	-- if ply1:GetPos():Distance(ply2:GetPos()) < 700 then -- JAKE: When you see this - Added the fading voice functionality. Piss easy to remove, just remove the second fale/trues. May end up keeping though.
		-- if ply1:Visible(ply2) then
			-- return true, true 
		-- elseif ply1:GetPos():Distance(ply2:GetPos()) < 150 then
			-- return true, true
		-- end	
	-- end
	-- return false, false
-- end

ChatRadius_Whisper = 200;
ChatRadius_Whisper2 = 40000
ChatRadius_Local = 600;
ChatRadius_Local2 = 360000
ChatRadius_Yell = 800;
ChatRadius_Yell2 = 640000

-- ply1 is listener ply2 is speaker
function GM:PlayerCanHearPlayersVoice ( ply1, ply2 )
	if ply1.SpecEntity != nil then
		ply1 = ply1.SpecEntity
	end
	if !ply1:IsValid() or !ply2:IsValid() then return false, false end
	if !ply1:Alive() then return false, false end
	if !ply2:Alive() then return false, false end

	if ply1:GetPos():DistToSqr(ply2:GetPos()) < 490000 then -- JAKE: When you see this - Added the fading voice functionality. Piss easy to remove, just remove the second fale/trues. May end up keeping though.
		if ply1:Visible(ply2) then
			return true, true 
		elseif ply1:GetPos():DistToSqr(ply2:GetPos()) < 22500 then
			return true, true
		end	
	end

    if ply2:HasItem("item_policeradio") and ply2:IsGov() and ply2:GetNWBool("tradio", false) then
        if ply1:HasItem("item_policeradio") and ply1:IsGov() then
            return true
        end
        for k,v in pairs(player.GetAll()) do
            if v:IsGov() and v:HasItem("item_policeradio") and ply1:GetPos():DistToSqr(v:GetPos()) < ChatRadius_Whisper2 then
                return true
            end
        end
    end
	
	return false
end

function GM.ChangeRadioTalking ( Player, Cmd, Args )
	if (!Args[1]) then return; end
	
    if not Player:HasItem("item_policeradio") then
        Player:SetNWBool("tradio", false)
        Player:Hint("You don't have a radio!")
        return
    end
    
	if (tonumber(Args[1]) == 1) then
		Player:SetNWBool("tradio", true);
	else
		Player:SetNWBool("tradio", false);
	end
end
concommand.Add("ocrp_tr", GM.ChangeRadioTalking);

if not file.Exists("ocrp_logs", "DATA") then
    file.CreateDir("ocrp_logs")
end

function SV_PrintToAdmin( Speaker, ChatType, Message )
    local formattedMsg = "[" .. os.date("%c") .. "] [".. Speaker:Nick() .."("..Speaker:SteamID()..")] -> [".. tostring(ChatType) .."] -> ".. tostring(Message)
    print(formattedMsg)
    file.Append("ocrp_logs/" .. os.date("%m-%d-%y") .. ".txt", formattedMsg .. "\n")
	for k, v in pairs(player.GetAll()) do
        if v:GetLevel() <= 2 then
            umsg.Start( "ocrp_printadmin", v )
                umsg.String( Speaker:Nick() )
                umsg.String( ChatType )
                umsg.String( Message )
            umsg.End()
        end
	end
end