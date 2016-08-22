TYPING = false
OCRP_CHATBOX = OCRP_CHATBOX or nil
local LastMessages = {}

RunConsoleCommand("gm_clearfonts" )
surface.CreateFont("UiGood", {
    font = "UiBold",
    size = ScreenScale(7),
    weight = 700,
    antialias = true,
    shadow = false
})

GM.Chat = {}
GM.Chat["OOC"] = {Text = " (OOC): ",ChatColor = Color(255,255,255,255)}
GM.Chat["LOOC"] = {Text = " (LOOC): ",ChatColor = Color( 190, 190, 190, 255 )}
GM.Chat["Yell"] = {Text = " (Yell): ",ChatColor = Color(255, 165, 0, 255 )}
GM.Chat["Local"] = {Text = ": ",ChatColor = Color(255,243,169,255) }
GM.Chat["Emote"] = {Text = " ",ChatColor = Color( 210, 30, 30, 255 ),NameColor = Color( 210, 30, 30, 255 ) }
GM.Chat["Whisper"] = {Text = " (Whisper): ",ChatColor = Color(215, 255, 222, 255 )}
GM.Chat["911"] = {Text = " (911): ",ChatColor = Color( 255, 30, 30, 255 ),NameColor = Color(255, 30, 30,255)}
GM.Chat["Broadcast"] = {Text = " (Broadcast): ",ChatColor = Color( 255, 30, 30, 255 ),NameColor = Color(255, 30, 30,255)}
GM.Chat["Gov Radio"] = {Text = " (Radio): ",ChatColor = Color(90,204,255,255)}
GM.Chat["Advert"] = {Text = "(Advert): ",ChatColor = Color(255,255,255,255),NameColor = Color(255,255,255,255)}
GM.Chat["PM"] = {Text = " (PM): ",ChatColor = Color( 0, 220, 20, 255 )}
GM.Chat["Org"] = {Text = " (Org): ",ChatColor = Color(0,255,255,255)}
GM.Chat["To Admins"] = {Text = " (To Admins): ", ChatColor = Color(69,185,255,255), NameColor = Color(69,185,255,255)}

function ChatBoxInit()
	if OCRP_CHATBOX and OCRP_CHATBOX:IsValid() then OCRP_CHATBOX:Remove() end
	
	local chatbox = vgui.Create("DPanel")
	chatbox:SetSize(ScrW()/3, ScrH()/6)
	chatbox:SetPos(20, 5/8*ScrH())
	chatbox.Paint = function() end
	
	function chatbox:AnimationThink()
		if not TYPING and self.FadeTime != -1 and self.FadeTime <= CurTime() and self:GetAlpha() > 0 then
			local fraction = math.Clamp((CurTime()-self.FadeTime)/3, 0, 1)
			local fade = Lerp(fraction, 255, 0)
			self:SetAlpha(fade)
		end
		self:AnimationThinkInternal()
	end
	
	OCRP_CHATBOX = chatbox
	
	local richtext = vgui.Create("RichText", OCRP_CHATBOX)
	richtext:SetSize(OCRP_CHATBOX:GetWide(), OCRP_CHATBOX:GetTall()-35)
	richtext:SetVerticalScrollbarEnabled(true)
	
	function richtext:PerformLayout()
		richtext:SetFontInternal("UiGood")
	end
	richtext:PerformLayout() -- Manually call it just in case?
	
	OCRP_CHATBOX.richtext = richtext
	
	chat.Open(1)
	chat.Close()
	
end

TeamChatOOC = false
function GM:StartChat(tsay)

    if OCRP_CHATBOX.label and OCRP_CHATBOX.label:IsValid() then OCRP_CHATBOX.label:Remove() end
    if OCRP_CHATBOX.textbox and OCRP_CHATBOX.textbox:IsValid() then OCRP_CHATBOX.textbox:Remove() end

	net.Start("OCRP_IsTyping")
    net.WriteInt(LocalPlayer():EntIndex(), 32)
    net.WriteBool(true)
	net.SendToServer()
	TYPING = true
	
	TeamChatOOC = tsay
	
	local bar = OCRP_CHATBOX.richtext:GetChildren()[1]
	if bar:GetName() == "ScrollBar" then
		bar:SetVisible(true)
	end
	
	OCRP_CHATBOX.FadeTime = -1
	OCRP_CHATBOX:SetAlpha(255)
	
	local label = vgui.Create("DPanel", OCRP_CHATBOX)
	
	local fonth = draw.GetFontHeight("UiGood")
	
	function label:Paint(w,h)
		draw.RoundedBox(8, 0, 0, w, h, Color(39,168,216,255))
		draw.RoundedBox(8, 1, 1, w-2, h-2, Color(30,30,30,255))
		draw.DrawText(self.text or "Local", "UiGood", w/2, h/2-fonth/2, Color(39,168,216,255), TEXT_ALIGN_CENTER)
	end
	
	OCRP_CHATBOX.label = label
	
	local textbox = vgui.Create("DTextEntry", OCRP_CHATBOX)
	textbox:SetDrawBackground(false)
	textbox:SetFont("UiGood")
	textbox:SetTextColor(Color(255,255,255,255))
	
	function textbox:OnChange()
		self:SetCaretPos(self:GetText():len())
	end
	
	OCRP_CHATBOX.textbox = textbox
	
	function label:SetText(text)
		self.text = text
		surface.SetFont("UiGood")
		local size = surface.GetTextSize(text)+20
		if size < 80 then size = 80 end
		self:SetSize(size, 30)
		if OCRP_CHATBOX.textbox and OCRP_CHATBOX.textbox:IsValid() then
			OCRP_CHATBOX.textbox:SetSize(OCRP_CHATBOX:GetWide()-(self:GetPos()+self:GetWide()), self:GetTall())
			OCRP_CHATBOX.textbox:SetPos(self:GetPos()+self:GetWide()+5, select(2, self:GetPos()))
		end
	end
	
	label:SetText("Local") -- Do it once to size
	label:SetPos(0, OCRP_CHATBOX:GetTall()-label:GetTall())
	label:SetText("Local") -- And once to place the textbox properly
	
	if tsay then
		label:SetText("OOC")
	end
	
	return true

end

function GM:FinishChat()
	timer.Simple(.05, function()
        TYPING = false
    end)
	TeamChatOOC = false
	net.Start("OCRP_IsTyping")
    net.WriteInt(LocalPlayer():EntIndex(), 32)
    net.WriteBool(false)
	net.SendToServer()
    
    if not OCRP_CHATBOX or not OCRP_CHATBOX:IsValid() then return end
	
	OCRP_CHATBOX.FadeTime = CurTime() + 7
	
	local bar = OCRP_CHATBOX.richtext:GetChildren()[1]
	if bar:GetName() == "ScrollBar" then
		bar:SetVisible(false)
	end
	
	if OCRP_CHATBOX.label and OCRP_CHATBOX.label:IsValid() then OCRP_CHATBOX.label:Remove() end
	if OCRP_CHATBOX.textbox and OCRP_CHATBOX.textbox:IsValid() then OCRP_CHATBOX.textbox:Remove() end
end

function GM:ChatTextChanged(text)
	local count = table.Count(string.Explode(" ", text))
	if not TeamChatOOC then
		if text == "" then
			OCRP_CHATBOX.label:SetText("Local")
		elseif (count >= 2 and string.ToTable(text)[1] == "/") or text == "/" then
			local type,msg = GetChatType(text)
			OCRP_CHATBOX.label:SetText(type)
			text = msg
		end
	end
	
	OCRP_CHATBOX.textbox:SetText(text)
	OCRP_CHATBOX.textbox:OnChange()
end

function GM:OnPlayerChat(plySpeaker, strText, boolTeamOnly, boolPlayerIsDead)

	if strText != "" then
    
		local type,msg,pmtarget = GetChatType(strText)
		local col = GAMEMODE.Chat[type].NameColor or self:GetTeamColor(plySpeaker)
        local addText = true
        if plySpeaker == LocalPlayer() then
            -- This function prints some error msgs for us and decides whether to suppress or not
            addText = FilterLocalPlayerChat(type, msg, pmtarget)
        end
        
        if addText then
    
            local rt = OCRP_CHATBOX.richtext -- easier...
            if rt:GetNumLines() > 999 then -- Can't seem to use rt:GetText(), so we'll just clear it all instead
                rt:SetText("")
                rt:InsertColorChange(100,100,100,255)
                rt:AppendText("Your chatbox reached 1000 lines and was cleared to avoid lagging you.")
                rt:AppendText("\nYou may still use the Chat Log tab in the Q menu to see old chat.")
            end
            if OCRP_CHATBOX.FadeTime != -1 then
                OCRP_CHATBOX.FadeTime = CurTime() + 7
            end
            OCRP_CHATBOX:SetAlpha(255)
            rt:InsertColorChange(col.r, col.g, col.b, col.a)
            if type != "Advert" then
                rt:AppendText(plySpeaker:Nick() .. GAMEMODE.Chat[type].Text)
            else
                rt:AppendText(GAMEMODE.Chat[type].Text)
            end
            col = GAMEMODE.Chat[type].ChatColor or Color(255,255,255,255)
            rt:InsertColorChange(col.r, col.g, col.b, col.a)
            rt:AppendText(msg .. "\n")
            
            AddToChatLogTable(plySpeaker:Nick(), type, msg)
            
            local t = {}
            t.ChatType = type
            t.Line = msg
            t.Time = os.date("%c")
            LastMessages[plySpeaker:Nick()] = t
            
        end
		
	end

end

function FilterLocalPlayerChat(type, text, pmtarget)

    -- This function used to filter, but now we do that serverside.
    
    if type == "Emote" and text == "calls for a taxi." then
        local x,y = CalcPercents(LocalPlayer():GetPos())
        net.Start("OCRP_SendMarker")
        net.WriteString("car-taxi")
        net.WriteFloat(x)
        net.WriteFloat(y)
        net.SendToServer()
    end
    
    return true

end

net.Receive("OCRP_IsTyping", function()
    local ply = Entity(net.ReadInt(32))
    local bool = net.ReadBool()
    ply.Typing = bool
end)

-- Overwrite chat.AddText so messages like ULX come to our chatbox
-- This is mostly just copied off some garrysmod wiki tutorial on chatboxes
local oldAT = chat.AddText
function chat.AddText( ... )
    local args = { ... } -- Create a table of varargs
    print("AT")
    PrintTable(args)

    local rt = OCRP_CHATBOX.richtext
    
	for _, obj in pairs( args ) do
		if type( obj ) == "table" then -- We were passed a color object
			rt:InsertColorChange( obj.r, obj.g, obj.b, 255 )
		elseif type( obj ) == "string" then -- This is just a string
			rt:AppendText( obj )
		elseif obj:IsPlayer() then
			local col = GAMEMODE:GetTeamColor( obj ) -- Get the player's team color
			rt:InsertColorChange( col.r, col.g, col.b, 255 ) -- Make their name that color
			rt:AppendText( obj:Nick() )
		end
	end

	-- Gotta end our line for this message
	rt:AppendText( "\n" )

	-- Call the original function
	oldAT( ... )
end

function JoinLeaveA( playerindex, playername, text, messagetype )
	if messagetype == "chat" then return false end
	if messagetype == "joinleave" then
		--ChatAdd(text,"","msg",playername)
	end
	if messagetype == "none" then
		if string.find(text, "killed") then
			if string.find(text, "using") then
				return false
			end
		end
	end
end
hook.Add( "ChatText", "JoinLeaveHook", JoinLeaveA );

function PrintToAdmin( Speaker, ChatType, Message, bool )
	local SpeakerName = bool and Speaker or Speaker:Nick()
    if LastMessages and LastMessages[SpeakerName] then
		local t = LastMessages[SpeakerName]
        if t.ChatType == ChatType and t.Line == Message and t.Time == os.date("%c") then
            -- We got this message as a regular player. Don't need it as an admin too.
            return
        end
    end
	--[[if ChatType == "RESPAWN_NPCS" then
		if LocalPlayer():IsAdmin() then
			ChatAdd(Message,"OCRP","admin",LocalPlayer())
		end
		return false
	end
	if ChatType == "-USED" then
		if LocalPlayer():IsSuperAdmin() then
			ChatAdd(Message,"OCRP","superadmin",LocalPlayer())
			return false
		end
		return false
	end
	if ChatType == "-SPAWN" then
		if LocalPlayer():IsSuperAdmin() then
			ChatAdd(Message,"OCRP","superadmin",LocalPlayer())
			return false
		end
		return false
	end]]
    if ChatType == "OOC" then return end
	if LocalPlayer():GetLevel() <= 2 then
		LocalPlayer():PrintMessage( HUD_PRINTCONSOLE, "\n[".. SpeakerName .."] -> [".. ChatType .."] -> ".. Message )
		AddToChatLogTable(SpeakerName, "*"..ChatType, Message)
	end
end

function CLPrintToAdminUM( um )
	PrintToAdmin( um:ReadString(), um:ReadString(), um:ReadString(), true )
end
usermessage.Hook( "ocrp_printadmin", CLPrintToAdminUM )
