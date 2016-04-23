OCRP_Orgs = OCRP_Orgs or {}

net.Receive("OCRP_UpdateOrgs", function()
    OCRP_Orgs = net.ReadTable()
    UpdateOrgTab()
end)

net.Receive("OCRP_UpdateSingleOrg", function()
    local orgid = net.ReadInt(32)
    OCRP_Orgs[orgid] = net.ReadTable()
    UpdateOrgTab()
end)

net.Receive("OCRP_RemoveOrg", function()
    local orgid = net.ReadInt(32)
    OCRP_Orgs[orgid] = nil
    UpdateOrgTab()
end)

timer.Create("OCRP_ClientOtherPlayersPlayTime", 60, 0, function()
    for k,v in pairs(player.GetAll()) do
        if not v or not v:IsValid() then continue end
        if v:GetOrg() > 0 then
            for _,member in pairs(OCRP_Orgs[v:GetOrg()].Members) do
                if member.SteamID == v:SteamID() then
                    member.Playtime = member.Playtime or 0
                    member.Playtime = member.Playtime + 1
                end
            end
        end
        for orgid,org in pairs(OCRP_Orgs) do
            for _,applicant in pairs(org.Applicants) do
                if applicant.SteamID == v:SteamID() then
                    applicant.Playtime = applicant.Playtime or 0
                    applicant.Playtime = applicant.Playtime + 1
                end
            end
        end
    end
    UpdateOrgTab()
end)

function UpdateOrgTab()
    if OCRP_MAINMENU and OCRP_MAINMENU:IsValid() and OCRP_MAINMENU.tab == "Org" then
        local scroll = 0
        for k,v in pairs(OCRP_MAINMENU.CurrentChildren or {}) do
            if v.VBar and v.VBar:IsValid() then
                scroll = v.VBar.Scroll
            end
        end
        local page = OCRP_MAINMENU.orgtab
        ChooseOrgTab(OCRP_MAINMENU, scroll, page)
    end
end
function OpenOrgCreation()

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(350, 170)
    frame:Center()
    frame:MakePopup()
    
    surface.SetFont("Trebuchet19")
    local textw,texth = surface.GetTextSize("Choose a unique name for your org.")
    
    local info = vgui.Create("DPanel", frame)
    info:SetSize(textw+10, texth+10)
    info:SetPos(frame:GetWide()/2-info:GetWide()/2, 10)
    
    function info:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
        draw.DrawText("Choose a unique name for your org.", "Trebuchet19", 5, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
    end
    
	local label1 = vgui.Create("DLabel", frame)
	label1:SetFont("UiBold")
	label1:SetText("Org Name")
	label1:SetTextColor(Color(39,168,216,255))
	label1:SizeToContents()
	label1:SetPos(frame:GetWide()/2-175/2-label1:GetWide()/2, select(2, info:GetPos())+info:GetTall()+25)
	
	local name = vgui.Create("DTextEntry", frame)
	name:SetSize(175, 30)
	name:SetPos(label1:GetPos()+label1:GetWide()+10, select(2, label1:GetPos())+label1:GetTall()/2-name:GetTall()/2)
	
	function name:Paint(w,h)
		draw.RoundedBox(8,0,0,w,h,Color(0,0,0,255))
		self:DrawTextEntryText(Color(255,255,255,255), Color(100,100,100,255), Color(255,255,255,255))
	end
	
	function name:OnChange()
		local val = name:GetText()
		if val:len() >= 25 then
			name:SetText(string.sub(name:GetText(), 1, val:len()-1))
			name:SetCaretPos(val:len()-1)
		end
	end
    
    local confirm = vgui.Create("OCRP_BaseButton", frame)
    confirm:SetSize(label1:GetWide()+10+name:GetWide(), 30)
    confirm:SetText("Confirm")
    confirm:SetPos(frame:GetWide()/2-confirm:GetWide()/2, select(2, name:GetPos()) + name:GetTall()+20)
    
    local allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "

    function confirm:DoClick()
        local txt = name:GetText():Trim()
        for k,v in pairs(string.ToTable(txt)) do
            if not string.find(allowed, v) then
                OCRP_AddHint("Your org name may contain only English characters and spaces.")
                return
            end
        end
        if txt:len() < 5 or txt:len() > 25 then
            OCRP_AddHint("Your org name must be between 5 and 25 characters.")
            return
        end
        net.Start("OCRP_CreateOrg")
        net.WriteString(txt)
        net.SendToServer()
        frame:Remove()
    end
    
    local warning = vgui.Create("DLabel", frame)
    warning:SetFont("UiBold")
    warning:SetText("You will not be able to change this name.")
    warning:SizeToContents()
    warning:SetPos(frame:GetWide()/2-warning:GetWide()/2, frame:GetTall()-warning:GetTall()-5)
        
end

function PMETA:GetOrg()
    return self:GetNWString("Org", 0)
end