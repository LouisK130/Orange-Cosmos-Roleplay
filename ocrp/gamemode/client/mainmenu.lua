local vgui = vgui
local draw = draw
local surface = surface
local OC_Alert = Material("gui/OCRP/OCRP_Alert")

local PlayerWarnings = {}

OCRP_MAINMENU = nil

net.Receive("UpdatePlayerWarnings", function(len)
    if LocalPlayer():GetLevel() > 2 then return end
    PlayerWarnings = net.ReadTable()
    if GUI_Warnings_tab_Panel and GUI_Warnings_tab_Panel:IsValid() then
        GUI_Rebuild_Warnings(GUI_Warnings_tab_Panel)
    end
end)

function GetTabs()
    -- inv, skills, org, buddies, rules, forums, chat logging, admin logging, warnings
    
    local tabs = {"inventory", "skills", "org", "buddies", "website", "chat"}
    
    return tabs

end

function DropAmountPopup(item)

    if item == "item_pot" or GAMEMODE.OCRP_Items[item].Max == 1 then
        net.Start("OCRP_Dropitem")
        net.WriteString(item)
        net.WriteInt(1, 32)
        net.SendToServer()
        return
    end

    OCRP_MAINMENU:SetMouseInputEnabled(false)
    OCRP_MAINMENU.sidebar:SetMouseInputEnabled(false)

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(200, 100)
    frame:SetPos(OCRP_MAINMENU:GetPos()+OCRP_MAINMENU:GetWide()/2-frame:GetWide()/2, select(2, OCRP_MAINMENU:GetPos())+OCRP_MAINMENU:GetTall()/2-frame:GetTall()/2)
    frame.Outline:MakePopup()
    frame.Outline:SetMouseInputEnabled(false)
    frame:MakePopup()
    
    local title = vgui.Create("DLabel", frame)
    title:SetText("Drop how much?")
    title:SetFont("UiBold")
    title:SetTextColor(Color(255,255,255,255))
    title:SizeToContents()
    title:SetPos(frame:GetWide()/2-title:GetWide()/2, 10)
    
    OCRP_Inventory = OCRP_Inventory or {}
    local total = OCRP_Inventory[item] or 0
    
    local slider = vgui.Create("DSlider", frame)
    slider:SetWide(125)
    slider:SetPos(10,40)
    slider:SetSlideX(1/total)
    
    function slider:Paint(w,h)
        draw.RoundedBox(0, 0, h/2, w, 1, Color(39,168,216,255))
        for i=0,4 do
            local x = i*w/4
            if x == w then x = x-1 end -- Make sure it shows
            draw.RoundedBox(0, x, h/2-7, 1, 15, Color(39,168,216,255))
        end
    end

    local amount = vgui.Create("DTextEntry", frame)
    amount:SetDrawBackground(false)
    amount:SetNumeric(true)
    amount:SetTextColor(Color(39,168,216,255))
    amount:SetFont("UiBold")
    amount:SetText("1")
    surface.SetFont("UiBold")
    local wide = surface.GetTextSize(amount:GetText())
    amount:SetWide(wide+5)
    amount:SetPos(167-amount:GetWide()/2, 42)
    
    function amount:OnChange()
        if self:GetText() == "" or self:GetText() == " " then
            self:SetText("0")
        elseif tonumber(self:GetText()) > total then
            self:SetText("" .. total)
        else
            slider:SetSlideX(tonumber(self:GetText())/total)
        end
        surface.SetFont("UiBold")
        local wide = surface.GetTextSize(self:GetText())
        self:SetWide(wide+5)
        self:SetPos(167-self:GetWide()/2, 42)
    end
    
    function amount:Think()
        if slider:GetDragging() then
            self:SetText(tostring(math.floor(slider.m_fSlideX*total)))
            self:OnChange()
        end
    end
    
    local drop = vgui.Create("OCRP_BaseButton", frame)
    drop:SetText("Drop")
    drop:SetSize(180, 20)
    drop:SetPos(10, 73)
    
    function drop:DoClick()
        local quantity = math.floor(total * slider:GetSlideX())
        if quantity > 0 then
            net.Start("OCRP_Dropitem")
            net.WriteString(item)
            net.WriteInt(quantity, 32)
            net.SendToServer()
        end
        frame:Remove()
    end
    
    local OR = frame.OnRemove
    
    function frame:OnRemove()
        OR(self)
        if OCRP_MAINMENU and OCRP_MAINMENU:IsValid() then
            OCRP_MAINMENU:SetMouseInputEnabled(true)
            if OCRP_MAINMENU.sidebar and OCRP_MAINMENU.sidebar:IsValid() then
                OCRP_MAINMENU.sidebar:SetMouseInputEnabled(true)
            end
        end
    end

end

function OpenMainMenu()

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(825, 500)
    frame:Center()
    frame:MakePopup()
    frame.CurrentChildren = {}
    
    OCRP_MAINMENU = frame
    
    local tabs = GetTabs()
    
    local side = vgui.Create("DPanel")
    side:SetSize(115, 5+(#tabs * 45))
    side:SetPos(frame:GetPos()-side:GetWide(), select(2, frame:GetPos())-5)
    
    frame.sidebar = side
    
    function side:Paint(w,h)
        draw.RoundedBoxEx(8, 0, 0, w, h, Color(0,0,0,255), true, false, true, false)
        for i=1,#tabs do
            draw.RoundedBoxEx(8, 5, 5+(i-1)*45, w-5, 40, Color(20,20,20,255), true, false, true, false)
        end
    end
    
    local OR = frame.OnRemove
    
    function frame:OnRemove()
        OR(self)
        if side and side:IsValid() then side:Remove() end
        EmptyMainMenu(self)
    end
    
    local y = 10
    
    local chooseInv = vgui.Create("OCRP_BaseButton", side)
    chooseInv:SetSize(100, 30)
    chooseInv:SetPos(10, y)
    chooseInv:SetText("Inventory")
    
    function chooseInv:DoClick()
        ChooseInventoryTab(frame)
    end
    
    y = y + 45
    
    local chooseSkills = vgui.Create("OCRP_BaseButton", side)
    chooseSkills:SetSize(100, 30)
    chooseSkills:SetPos(10, y)
    chooseSkills:SetText("Skills")
    
    function chooseSkills:DoClick()
        ChooseSkillsTab(frame)
    end
    
    y = y + 45
    
    local chooseOrg = vgui.Create("OCRP_BaseButton", side)
    chooseOrg:SetSize(100, 30)
    chooseOrg:SetPos(10, y)
    chooseOrg:SetText("Organization")
    
    function chooseOrg:DoClick()
        ChooseOrgTab(frame)
    end
    
    y = y + 45
    
    local chooseBuddies = vgui.Create("OCRP_BaseButton", side)
    chooseBuddies:SetSize(100, 30)
    chooseBuddies:SetPos(10, y)
    chooseBuddies:SetText("Buddies")
    
    function chooseBuddies:DoClick()
        ChooseBuddiesTab(frame)
    end
    
    y = y + 45
    
    local chooseChat = vgui.Create("OCRP_BaseButton", side)
    chooseChat:SetSize(100, 30)
    chooseChat:SetPos(10, y)
    chooseChat:SetText("Chat Log")
    
    function chooseChat:DoClick()
        ChooseChatTab(frame)
    end
    
    y = y + 45
	
	local chooseSite = vgui.Create("OCRP_BaseButton", side)
	chooseSite:SetSize(100, 30)
	chooseSite:SetPos(10, y)
	chooseSite:SetText("Forums")
	
	function chooseSite:DoClick()
		gui.OpenURL("http://zetagaming.net")
	end
    
    ChooseInventoryTab(frame)
    
    --GUI_MainMenu()

end

function EmptyMainMenu(frame)
    for k,v in pairs(frame.CurrentChildren) do
        if v and v:IsValid() then v:Remove() end
    end
    frame.CurrentChildren = {}
end

function fillInvWithBlanks(inv)

    while table.Count(inv:GetItems()) < 15 do
        local filler = vgui.Create("DPanel")
        filler:SetSize(100,140)
        filler.Paint = function() end
        inv:AddItem(filler)
    end

end

function ChooseInventoryTab(frame, scroll)

    EmptyMainMenu(frame)
    
    frame:SetOCRPTitle("Inventory")
    
    frame.tab = "Inventory"
    
    surface.SetFont("Trebuchet19")
    local textw,texth = surface.GetTextSize("These are the items currently in your inventory.")
    
    local caption = vgui.Create("DPanel", frame)
    caption:SetSize(textw+10,texth+10)
    caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 5)
    
    table.insert(frame.CurrentChildren, caption)
    
    function caption:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
        draw.DrawText("These are the items currently in your inventory.", "Trebuchet19", 5, 5, Color(255,255,255,255))
    end
    
    local outline = vgui.Create("DPanel", frame)
    outline:SetSize(frame:GetWide()-20, frame:GetTall()-10-5-texth-50)
    outline:SetPos(10, 5+texth+15)
    
    function outline:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(39,168,216,255))
        draw.RoundedBox(8, 1, 1, w-2, h-2, Color(20,20,20,255))
    end
    
    table.insert(frame.CurrentChildren, outline)
    
    local inv = vgui.Create("DPanelList", frame)
    inv:SetSize(outline:GetWide()-2, outline:GetTall()-2)
    inv:SetPos(outline:GetPos()+1, select(2, outline:GetPos())+1)
    inv:EnableHorizontal(true)
    inv:EnableVerticalScrollbar(true)
    inv:SetSpacing(10)
    inv:SetNoSizing(true)
    inv:SetPadding(10)
    inv.VBar:SetEnabled(true) -- Shouldn't be necesarry but it seems to be to manually set scroll
    inv.VBar.Scroll = scroll or 0
    
    table.insert(frame.CurrentChildren, inv)
    
    local IPL = inv.PerformLayout
    
    function inv:PerformLayout(w,h)
        IPL(self,w,h)
        self.VBar:SetTall(self.VBar:GetTall()-10)
        self.VBar:SetPos(self:GetWide()-20, 5)
    end
    
    function inv:LayoutInfo(itemTable)
    
        if self.info and self.info:IsValid() then self.info:Remove() end
    
        local info = vgui.Create("OCRP_BaseMenu")
        info:SetSize(200, 400)
        info:SetPos(frame:GetPos()+frame:GetWide()+20, select(2, frame:GetPos()))
        info:AllowCloseButton(false)
        info:MakePopup()
        
        self.info = info
        
        table.insert(frame.CurrentChildren, info)
        
        surface.SetFont("Trebuchet19")
        local namew,nameh = surface.GetTextSize(itemTable.Name)
        
        local itemName = vgui.Create("DPanel", info)
        itemName:SetSize(namew, nameh+5)
        itemName:SetPos(info:GetWide()/2-itemName:GetWide()/2, 10)
        
        function itemName:Paint(w,h)
            draw.DrawText(itemTable.Name, "Trebuchet19", 0, 0, Color(39,168,216,255))
            draw.RoundedBox(0, 0, nameh+2, w, 1, Color(39,168,216,255))
        end
        
        local words2 = {}
        local desc1 = itemTable.Desc
        surface.SetFont("UiBold")
        if surface.GetTextSize(desc1) > info:GetWide()-40 then
        
            local desired = surface.GetTextSize(desc1)/2
        
            local words = string.Split(itemTable.Desc, " ")
            desc1 = ""
            surface.SetFont("UiBold")
            local i = 1
            while words[i] and surface.GetTextSize(desc1 .. words[i]) <= desired do
                desc1 = desc1 .. words[i] .. " "
                i = i + 1
            end
            desc1 = string.TrimRight(desc1)
            for ii=i,table.Count(words) do
                table.insert(words2, words[ii])
            end
            
            -- One line is gonna be bigger, lets make sure it's the top
            if surface.GetTextSize(string.Implode(" ", words2)) > surface.GetTextSize(desc1) then
                desc1 = desc1 .. " " .. words2[1]
                table.remove(words2, 1)
            end
        end

        local desc = vgui.Create("DLabel", info)
        desc:SetText(desc1)
        desc:SetFont("UiBold")
        desc:SizeToContents()
        desc:SetPos(info:GetWide()/2-desc:GetWide()/2, select(2, itemName:GetPos())+nameh+15)
        
        local descBottom = select(2, desc:GetPos())
        
        if desc1 ~= itemTable.Desc then -- we had to cut into 2 lines
            local desc2 = string.Implode(" ", words2)
            local descLabel2 = vgui.Create("DLabel", info)
            descLabel2:SetText(desc2)
            descLabel2:SetFont("UiBold")
            descLabel2:SizeToContents()
            descLabel2:SetPos(info:GetWide()/2-descLabel2:GetWide()/2, select(2, desc:GetPos())+draw.GetFontHeight("UiBold")+5)
            descBottom = select(2, descLabel2:GetPos())
            info:SetSize(200, 420)
        end
        
        local weight = vgui.Create("DLabel", info)
        weight:SetText("Weighs:   " .. tostring(itemTable.Weight) .. " each")
        weight:SetFont("UiBold")
        weight:SetTextColor(Color(39,168,216,255))
        weight:SizeToContents()
        weight:SetText("Weighs: ") -- Size based on above but display this. Allows us to break it into two colors
        weight:SetPos(info:GetWide()/2-weight:GetWide()/2, descBottom+25)
        
        local wval = vgui.Create("DLabel", info)
        wval:SetText(tostring(itemTable.Weight) .. " each")
        wval:SetFont("UiBold")
        wval:SetTextColor(Color(255,255,255,255))
        wval:SizeToContents()
        wval:SetPos(weight:GetPos()+45, select(2, weight:GetPos()))
        
        local max = vgui.Create("DLabel", info)
        max:SetText("Max Amount:   " .. tostring(itemTable.Max or "unlimited"))
        max:SetFont("UiBold")
        max:SetTextColor(Color(39,168,216,255))
        max:SizeToContents()
        max:SetText("Max Amount: ")
        max:SetPos(info:GetWide()/2-max:GetWide()/2, select(2, weight:GetPos())+25)
        
        local mval = vgui.Create("DLabel", info)
        mval:SetText(tostring(itemTable.Max or "unlimited"))
        mval:SetFont("UiBold")
        mval:SetTextColor(Color(255,255,255,255))
        mval:SizeToContents()
        mval:SetPos(max:GetPos()+70, select(2, max:GetPos()))
        
        info:SetSize(200, select(2, max:GetPos())+30)
    
    end
    
    for item,amt in pairs(OCRP_Inventory or {}) do
    
        if item == "WeightData" then continue end
        local itemTable = GAMEMODE.OCRP_Items[item]
        if not itemTable then continue end
        if amt == 0 then continue end
        
        local itemPanel = vgui.Create("DPanel")
        itemPanel:SetSize(100, 155)
        itemPanel.amt = amt or 1
        
        local name = GAMEMODE.OCRP_Items[item].Name
        
        function itemPanel:Paint(w,h)
            draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0,255))
            draw.DrawText(name, "UiBold", w/2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
            if itemPanel.amt > 1 then
                draw.DrawText("x" .. itemPanel.amt, "UiBold", w/2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER)
            end
        end
        
        function itemPanel:OnCursorEntered()
            inv:LayoutInfo(GAMEMODE.OCRP_Items[item])
        end
        
        function itemPanel:OnCursorExited()
            if inv.info and inv.info:IsValid() then inv.info:Remove() end
        end
        
        local itemMdlPanel = vgui.Create("DModelPanel", itemPanel)
        itemMdlPanel:SetSize(80, 80)
        itemMdlPanel:SetPos(5, 30)
        itemMdlPanel:SetModel(GAMEMODE.OCRP_Items[item].Model)
        itemMdlPanel:SetCursor("arrow")
        
        itemMdlPanel.OnCursorEntered = itemPanel.OnCursorEntered
        itemMdlPanel.OnCursorExited = itemPanel.OnCursorExited
        
        if itemTable.Angle then
            itemMdlPanel:GetEntity():SetAngles(itemTable.Angle)
        end
        if itemTable.Material then
            itemMdlPanel:GetEntity():SetMaterial(itemTable.Material)
        end
        if itemTable.MdlColor then
            itemMdlPanel:SetColor(itemTable.MdlColor)
        end
        if itemTable.Function then
            local use = vgui.Create("OCRP_BaseButton", itemPanel)
            use:SetSize(90, 15)
            use:SetPos(5, 115)
            use:SetText("Use Item")
            
            function use:DoClick()
                net.Start("OCRP_Useitem")
                net.WriteString(item)
                net.SendToServer()
            end
        else
            --[[local nouse = vgui.Create("DLabel", itemPanel)
            nouse:SetFont("UiBold")
            nouse:SetTextColor(Color(100,100,100,255))
            nouse:SetText("Item has no use")
            nouse:SizeToContents()
            nouse:SetPos(itemPanel:GetWide()/2-nouse:GetWide()/2, 115)]]
        end
        if not itemTable.DoesntSave or item == "item_policeradio" then
            local drop = vgui.Create("OCRP_BaseButton", itemPanel)
            drop:SetSize(90, 15)
            drop:SetPos(5, 135)
            drop:SetText("Drop Item")
            
            function drop:DoClick()
                DropAmountPopup(item)
            end
        else
            local cantdrop = vgui.Create("DLabel", itemPanel)
            cantdrop:SetFont("UiBold")
            cantdrop:SetTextColor(Color(100,100,100,255))
            cantdrop:SetText("Can't be dropped")
            cantdrop:SizeToContents()
            cantdrop:SetPos(itemPanel:GetWide()/2-cantdrop:GetWide()/2, 135)
        end

        FocusModelPanel(itemMdlPanel)
        inv:AddItem(itemPanel)
    
    end
    
    fillInvWithBlanks(inv)
    
    local weight = vgui.Create("DPanel", frame)
    weight:SetSize(frame:GetWide()-20, 20)
    weight:SetPos(10, frame:GetTall()-30)
    
    function weight:Paint(w,h)
        local cur = OCRP_Inventory["WeightData"] and OCRP_Inventory["WeightData"].Cur or 0
        local max = OCRP_Inventory["WeightData"] and OCRP_Inventory["WeightData"].Max or 50
        draw.RoundedBox(8, 0, 0, w, h, Color(255,255,255,150))
        draw.RoundedBox(8, 1, 1, w-2, h-2, Color(20,20,20,255))
        if cur > 0 then
            local col = Color(25,255,0,100)
            if cur/max > .5 and cur/max < .8 then
                col = Color(255,255,0,100)
            elseif cur/max >= .8 then
                col = Color(255,0,0,100)
            end
            draw.RoundedBox(8, 2, 2, cur/max*w, h-4, col)
        end
        draw.SimpleTextOutlined("Weight: " .. tostring(cur) .. " / " .. tostring(max), "UiBold", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
    end
    
    table.insert(frame.CurrentChildren, weight)

end

function ChooseSkillsTab(frame, scroll)

    EmptyMainMenu(frame)
    
    frame:SetOCRPTitle("Skills")
    
    frame.tab = "Skills"
    
    surface.SetFont("Trebuchet19")
    local textw,texth = surface.GetTextSize("These are all the skills. Click the + to spend a point on a skill you have learned.")
    
    local caption = vgui.Create("DPanel", frame)
    caption:SetSize(textw+10,texth+10)
    caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 5)
    
    table.insert(frame.CurrentChildren, caption)
    
    function caption:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
        draw.DrawText("These are all the skills. Click the + to spend a point on a skill you have learned.", "Trebuchet19", 5, 5, Color(255,255,255,255))
    end
    
    local skills = vgui.Create("DPanelList", frame)
    skills:SetSize(frame:GetWide()-20, frame:GetTall()-10-texth-10-55)
    skills:SetPos(10, texth+20+45)
    skills:EnableVerticalScrollbar(true)
    skills.VBar:SetEnabled(true)
    skills:SetNoSizing(true)
    skills:SetSpacing(10)
    skills:SetPadding(10)
    skills.VBar.Scroll = scroll or 0
    
    local oldP = skills.Paint
    
    function skills:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
        oldP(self, w, h)
    end
    
    local oldPL = skills.PerformLayout
    
    function skills:PerformLayout(w,h)
        oldPL(self, w, h)
        self.VBar:SetTall(self:GetTall()-20)
        self.VBar:SetPos(self:GetWide()-17, 10)
    end
    
    function skills:LayoutInfo(skillTable)
    
        if self.info and self.info:IsValid() then self.info:Remove() end
        
        local widestdesc = 0
        surface.SetFont("UiBold")
        
        for level,description in pairs(skillTable.LvlDesc) do
            local descwide = surface.GetTextSize("Level " .. tostring(level) .. ": " .. description)
            if descwide > widestdesc then
                widestdesc = descwide
            end
        end
        
        if widestdesc < 230 then widestdesc = 230 end
    
        local info = vgui.Create("OCRP_BaseMenu")
        info:SetSize(widestdesc+20, 400)
        info:SetPos(frame:GetPos()+frame:GetWide()+20, select(2, frame:GetPos()))
        info:AllowCloseButton(false)
        info:MakePopup()
        
        self.info = info
        
        table.insert(frame.CurrentChildren, info)
        
        surface.SetFont("Trebuchet19")
        local namew,nameh = surface.GetTextSize(skillTable.Name)
        
        local itemName = vgui.Create("DPanel", info)
        itemName:SetSize(namew, nameh+5)
        itemName:SetPos(info:GetWide()/2-itemName:GetWide()/2, 10)
        
        function itemName:Paint(w,h)
            draw.DrawText(skillTable.Name, "Trebuchet19", 0, 0, Color(39,168,216,255))
            draw.RoundedBox(0, 0, nameh+2, w, 1, Color(39,168,216,255))
        end
        
        local desc = vgui.Create("DLabel", info)
        desc:SetText("\"" .. skillTable.Desc .. "\"")
        desc:SetFont("UiBold")
        desc:SizeToContents()
        desc:SetPos(info:GetWide()/2-desc:GetWide()/2, select(2, itemName:GetPos())+nameh+15)
        
        local levels = vgui.Create("DPanel", info)
        levels:SetSize(widestdesc+4, (draw.GetFontHeight("UiBold")+4)*table.Count(skillTable.LvlDesc))
        levels:SetPos(info:GetWide()/2-levels:GetWide()/2, select(2, desc:GetPos())+desc:GetTall()+10)
        
        function levels:Paint(w,h)
            local y = 2
            surface.SetFont("UiBold")
            for level,description in pairs(skillTable.LvlDesc) do
                local actualwide = surface.GetTextSize("Level " .. tostring(level) .. ": " .. description)
                local x = draw.SimpleText("Level " .. tostring(level) .. ": ", "UiBold", w/2-actualwide/2, y, Color(39,168,216,255), TEXT_ALIGN_LEFT)
                draw.SimpleText(description, "UiBold", w/2-actualwide/2+x+2, y, Color(255,255,255,255), TEXT_ALIGN_LEFT)
                --draw.DrawText("Level " .. tostring(level) .. ": " .. description, "UiBold", w/2, y, Color(255,255,255,255), TEXT_ALIGN_CENTER)
                y = y + draw.GetFontHeight("UiBold")+4
            end
        end
        
        if widestdesc < 240 then widestdesc = 240 end
        
        info:SetSize(info:GetWide(), select(2, levels:GetPos())+levels:GetTall()+10)
    
    end
    
    table.insert(frame.CurrentChildren, skills)
    
    local allSkillsSorted = {}
    local addLater = {}
    
    for k,v in pairs(GAMEMODE.OCRP_Skills) do
        if OCRP_Skills[k] > 0 then
            table.insert(allSkillsSorted, k)
        else
            table.insert(addLater, k)
        end
    end
    for k,v in pairs(addLater) do
        table.insert(allSkillsSorted, v)
    end
    
    for _,skill in pairs(allSkillsSorted) do
        local skillTable = GAMEMODE.OCRP_Skills[skill]
        local level = OCRP_Skills[skill] or 0
        
        local skillBar = vgui.Create("DPanel")
        skillBar:SetSize(skills:GetWide()-20, 70)
        
        local max = skillTable.MaxLevel
        local perc = level/max
        local maxwidth = skillBar:GetWide()-71
        local wide = perc*maxwidth
        local color = skillTable.Color or Color(0,0,0,100)
        
        function skillBar:Paint(w,h)
            draw.RoundedBox(8, 5, 0, w-65, h, Color(39,168,216,255))
            draw.RoundedBox(8, 6, 1, w-67, h-2, Color(20,20,20,255))
            if perc > 0 then
                draw.RoundedBox(8, 8, 3, wide, h-6, color)
            else
                draw.RoundedBoxEx(8, 8, 3, 10, h-6, color, true, false, true, false)
            end
            local x = draw.SimpleTextOutlined(skillTable.Name .. " Level ", "TargetID", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
            draw.SimpleTextOutlined(tostring(level), "TargetID", w/2+x/2+2, h/2, Color(39,168,216,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
        end
        
        function skillBar:OnCursorEntered()
            skills:LayoutInfo(skillTable)
        end
        
        function skillBar:OnCursorExited()
            if skills.info and skills.info:IsValid() then skills.info:Remove() end
        end
        
        if level > 0 and level < max then
        
            local add = vgui.Create("DImageButton", skillBar)
            add:SetSize(40,40)
            add:SetMaterial(OC_Plus)
            add:SetPos(skillBar:GetWide()-30-add:GetWide()/2, skillBar:GetTall()/2-add:GetTall()/2)
            
            function add:DoClick()
                net.Start("OCRP_UpgradeSkill")
                net.WriteString(skill)
                net.SendToServer()
            end
            
        elseif level == max then
            
            local cantadd = vgui.Create("DLabel", skillBar)
            cantadd:SetFont("UiBold")
            cantadd:SetText(" Max\nLevel")
            cantadd:SetTextColor(Color(255,0,0,255))
            cantadd:SizeToContents()
            cantadd:SetPos(skillBar:GetWide()-30-cantadd:GetWide()/2, skillBar:GetTall()/2-cantadd:GetTall()/2)
            
        elseif level <= 0 then
        
            local unknown = vgui.Create("DLabel", skillBar)
            unknown:SetFont("UiBold")
            unknown:SetText("   Skill\n    Not\nLearned")
            unknown:SetTextColor(Color(255,0,0,255))
            unknown:SizeToContents()
            unknown:SetPos(skillBar:GetWide()-30-unknown:GetWide()/2, skillBar:GetTall()/2-unknown:GetTall()/2)
        
        end
        
        skills:AddItem(skillBar)
       
    end
    
    while #skills:GetItems() < 5 do
        local filler = vgui.Create("DPanel")
        filler:SetSize(skills:GetWide()-20, 70)
        filler.Paint = function() end
        skills:AddItem(filler)
    end
    
    local labels = vgui.Create("DPanel", frame)
    labels:SetSize(frame:GetWide()-20, select(2, skills:GetPos()) - (select(2, caption:GetPos())+caption:GetTall())-10)
    labels:SetPos(10, select(2, caption:GetPos())+caption:GetTall()+5)
    
    local spent = 0
    for k,v in pairs(OCRP_Skills) do
        spent = spent + v
    end
    local remaining = OCRP_MaxSkillPoints - spent
    
    function labels:Paint(w,h)
        local x = draw.SimpleTextOutlined("Skill Points Spent: ", "TargetID", w/4, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
        draw.SimpleTextOutlined(spent, "TargetID", w/4+x/2, h/2, Color(39,168,216,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
        local x1 = draw.SimpleTextOutlined("Skill Points Remaining: ", "TargetID", 3*w/4, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
        draw.SimpleTextOutlined(remaining, "TargetID", 3*w/4+x1/2, h/2, Color(39,168,216,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
    end
    
    table.insert(frame.CurrentChildren, labels)
    
end

function ChooseOrgTab(frame, scroll, page)
    EmptyMainMenu(frame)
    
    frame:SetOCRPTitle("Organization")
    
    frame.tab = "Org"
    
    function ChooseOrgMembersTab(frame, scroll)
    
        frame.orgtab = "Members"
    
        EmptyMainMenu(frame)
        CreateSideBar(frame)
    
        local orgid = LocalPlayer():GetOrg()
    
        if orgid > 0 then
        
            surface.SetFont("Trebuchet19")
            local textw,texth = surface.GetTextSize("These are the members of your org.")
            
            local caption = vgui.Create("DPanel", frame)
            caption:SetSize(textw+10,texth+10)
            caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 5)
            
            table.insert(frame.CurrentChildren, caption)
            
            function caption:Paint(w,h)
                draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
                draw.DrawText("These are the members of your org.", "Trebuchet19", 5, 5, Color(255,255,255,255))
            end
            
            local members = vgui.Create("DListView", frame)
            members:SetSize(frame:GetWide()-20, frame:GetTall()-select(2,caption:GetPos())-caption:GetTall()-50)
            members:SetPos(10, select(2, caption:GetPos())+caption:GetTall()+10)
            local name = members:AddColumn("Name")
            local id = members:AddColumn("Steam ID")
            local time = members:AddColumn("Playtime")
            local online = members:AddColumn("Online")
            local notes = members:AddColumn("Notes")
            
            if members.VBar and members.VBar:IsValid() and scroll then
                members.VBar.Scroll = scroll
            end
            -- Sizing is weird. It changes but definitely not to these vals
            name:SetWide(150)
            notes:SetWide(200)
            id:SetSize(50)
            time:SetSize(50)
            online:SetSize(1)
            
            function members:Paint(w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(30,30,30,255))
            end
            
            table.insert(frame.CurrentChildren, members)
            
            local outline = vgui.Create("DPanel", frame)
            outline:SetSize(members:GetWide()+2, members:GetTall()+2)
            outline:SetPos(members:GetPos()-1, select(2, members:GetPos())-1)
            
            function outline:Paint(w,h)
                draw.RoundedBox(0,0,0,w,h,Color(39,168,216,255))
            end
            
            outline:MoveToBack()
            
            table.insert(frame.CurrentChildren, outline)
            
            local dolater = {}
            
            for k,v in pairs(OCRP_Orgs[orgid].Members or {}) do
                local ply = player.GetBySteamID(v.SteamID)
                if ply and ply:IsValid() then
                    local pt = formatPlayTime(v.Playtime):gsub(" Minutes", "m"):gsub(" Hours", "h"):gsub(" Days", "d"):gsub(" Weeks", "w")
                    pt = pt:gsub(" Minute", "m"):gsub(" Hour", "h"):gsub(" Day", "d"):gsub(" Week", "w")
                    local line = members:AddLine(ply:Nick(), v.SteamID, pt, "Yes", v.Notes)
                    for _,column in pairs(line.Columns) do
                        if v.SteamID == OCRP_Orgs[orgid].Owner then
                            column:SetTextColor(Color(39,168,216,255))
                        else
                            column:SetTextColor(Color(255,255,255,255))
                        end
                    end
                else
                    table.insert(dolater, v)
                end
            end
            
            for k,v in pairs(dolater) do
                local pt = formatPlayTime(v.Playtime):gsub(" Minutes", "m"):gsub(" Hours", "h"):gsub(" Days", "d"):gsub(" Weeks", "w")
                pt = pt:gsub(" Minute", "m"):gsub(" Hour", "h"):gsub(" Day", "d"):gsub(" Week", "w")
                local line = members:AddLine(v.Name, v.SteamID, pt, "No", v.Notes)
                for _,column in pairs(line.Columns) do
                    if v.SteamID == OCRP_Orgs[orgid].Owner then
                        column:SetTextColor(Color(39,168,216,255))
                    else
                        column:SetTextColor(Color(255,255,255,255))
                    end
                end
            end
            
            if LocalPlayer():SteamID() == OCRP_Orgs[orgid].Owner then
                local kick = vgui.Create("OCRP_BaseButton", frame)
                kick:SetSize(150, 25)
                kick:SetText("Kick Member")
                kick:SetPos(frame:GetWide()/5*4-kick:GetWide()/2, frame:GetTall()-18-kick:GetTall()/2)
                
                function kick:DoClick()
                    local line = members:GetSelectedLine()
                    if not line then OCRP_AddHint("You must select a member to kick.") return end
                    line = members:GetLine(line)
                    local stmid = line:GetColumnText(2)
                    if stmid == LocalPlayer():SteamID() then OCRP_AddHint("You cannot kick yourself. Go to the bank to quit.") return end
                    Org_AreYouSure(stmid, line:GetColumnText(1), "kick", frame)
                end
                
                local setnotes = vgui.Create("OCRP_BaseButton", frame)
                setnotes:SetSize(150, 25)
                setnotes:SetText("Set Member Notes")
                setnotes:SetPos(frame:GetWide()/2-kick:GetWide()/2, select(2, kick:GetPos()))
                
                function setnotes:DoClick()
                    local line = members:GetSelectedLine()
                    if not line then OCRP_AddHint("You must select a member to set notes for.") return end
                    line = members:GetLine(line)
                    OrgSetNotesPopup(line:GetColumnText(2), line:GetColumnText(1))
                end
                
                local makeowner = vgui.Create("OCRP_BaseButton", frame)
                makeowner:SetSize(150, 25)
                makeowner:SetText("Make Owner")
                makeowner:SetPos(frame:GetWide()/5-makeowner:GetWide()/2, select(2, kick:GetPos()))
                
                function makeowner:DoClick()
                    local line = members:GetSelectedLine()
                    if not line then OCRP_AddHint("You must select a member to make the owner.") return end
                    line = members:GetLine(line)
                    local stmid = line:GetColumnText(2)
                    if stmid == LocalPlayer():SteamID() then OCRP_AddHint("You are already the org owner.") return end
                    Org_AreYouSure(stmid, line:GetColumnText(1), "owner", frame)
                end
                
                table.insert(frame.CurrentChildren, kick)
                table.insert(frame.CurrentChildren, setnotes)
                table.insert(frame.CurrentChildren, makeowner)
            else
                local nocontrol = vgui.Create("DLabel", frame)
                nocontrol:SetTextColor(Color(255,255,255,255))
                nocontrol:SetFont("UiBold")
                nocontrol:SetText("Only the org owner can control member settings.")
                nocontrol:SizeToContents()
                nocontrol:SetPos(frame:GetWide()/2-nocontrol:GetWide()/2, frame:GetTall()-18-nocontrol:GetTall()/2)
                
                table.insert(frame.CurrentChildren, nocontrol)
            end
            
        end
    end
        
    function ChooseBrowseOrgsTab(frame, scroll)
    
        frame.orgtab = "BrowseOrgs"

        EmptyMainMenu(frame)
        CreateSideBar(frame)
    
        surface.SetFont("Trebuchet19")
        local text = "You don't have an org. Browse the available ones below and apply."
        if LocalPlayer():GetOrg() > 0 then
            text = "You already have an org. You must quit yours before applying to one of these."
        end
        local textw,texth = surface.GetTextSize(text)
        
        local caption = vgui.Create("DPanel", frame)
        caption:SetSize(textw+10,texth+10)
        caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 5)
        
        table.insert(frame.CurrentChildren, caption)
        
        function caption:Paint(w,h)
            draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
            draw.DrawText(text, "Trebuchet19", 5, 5, Color(255,255,255,255))
        end
        
        table.insert(frame.CurrentChildren, caption)
        
        local orgList = vgui.Create("DPanelList", frame)
        orgList:SetPos(5, select(2, caption:GetPos())+caption:GetTall()+10)
        orgList:SetSize(frame:GetWide()-20, frame:GetTall()-select(2,caption:GetPos())-caption:GetTall()-10)
        orgList:EnableVerticalScrollbar(true)
        orgList:EnableHorizontal(true)
        orgList:SetSpacing(10)
        orgList:SetPadding(10)
        orgList:SetNoSizing(true)
        
        table.insert(frame.CurrentChildren, orgList)
        
        local OLPL = orgList.PerformLayout
        
        function orgList:PerformLayout(w,h)
            OLPL(self, w, h)
            self.VBar:SetTall(self.VBar:GetTall()-20)
            self.VBar:SetPos(self.VBar:GetPos(), 10)
        end
        
        local appliedto = 0
        for orgid,org in pairs(OCRP_Orgs) do
            for _,applicant in pairs(org.Applicants) do
                if applicant.SteamID == LocalPlayer():SteamID() then
                    appliedto = orgid
                end
            end
        end
        
        for orgid,org in pairs(OCRP_Orgs) do
            
            local orgitem = vgui.Create("DPanel")
            orgitem:SetSize(orgList:GetWide()/2 - 20, 100)
            
            local daysdiff = os.difftime(os.time(), org.LastOwnerActivity) / 86400
            local activitystring = ""
            if daysdiff < 1 then
                activitystring = "today"
            elseif daysdiff >= 1 and daysdiff < 2 then
                activitystring = "1 day ago"
            elseif daysdiff < 7 then
                activitystring = math.floor(daysdiff) .. " days ago"
            elseif daysdiff >= 7 and daysdiff < 14 then
                activitystring = "1 week ago"
            elseif daysdiff >= 14 and daysdiff < 21 then
                activitystring = "2 weeks ago"
            elseif daysdiff >= 21 and daysdiff < 28 then
                activitystring = "3 weeks ago"
            elseif daysdiff >= 28 then
                activitystring = "a month ago"
            end
            local fonth = draw.GetFontHeight("UiBold")
            surface.SetFont("UiBold")
            local memw = surface.GetTextSize("Total Members:")
            local memvalw = surface.GetTextSize(table.Count(org.Members))
            local perkw = surface.GetTextSize("Perks Unlocked:")
            local perkwval = surface.GetTextSize(table.Count(org.Perks))
            local oName = "Owned by: " .. org.OwnerName
            if surface.GetTextSize(oName) >= orgitem:GetWide()-10-perkw-(10+memw)-15 then
                oName = oName .. "..."
            end
            while surface.GetTextSize(oName) >= (orgitem:GetWide()-10-perkw)-(10+memw)-15  do -- Space between "Total Members:" and "Perks Unlocked:"
                oName = string.sub(oName, 1, oName:len() - 4)
                oName = oName .. "..."
            end
            function orgitem:Paint(w,h)
                draw.RoundedBox(8, 0, 0, w, h, Color(39,168,216,255))
                draw.RoundedBox(8, 1, 1, w-2, h-2, Color(25,25,25,255))
                draw.DrawText(org.Name, "TargetIDSmall", w/2, 10, Color(39,168,216,255), TEXT_ALIGN_CENTER)
                draw.DrawText(oName, "UiBold", w/2, 30, Color(255,255,255,255), TEXT_ALIGN_CENTER)
                draw.DrawText("Last active: " .. activitystring, "UiBold", w/2, 45, Color(255,255,255,255), TEXT_ALIGN_CENTER)
                draw.DrawText("Total Members:", "UiBold", 10, h/2-fonth-2, Color(39,168,216,255), TEXT_ALIGN_LEFT)
                draw.DrawText(table.Count(org.Members), "UiBold", 10+memw/2-memvalw/2, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT)
                draw.DrawText("Perks Unlocked:", "UiBold", w-10-perkw, h/2-fonth-2, Color(39,168,216,255), TEXT_ALIGN_LEFT)
                draw.DrawText(table.Count(org.Perks), "UiBold", w-10-perkw/2-perkwval/2, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT)
            end
            
            if LocalPlayer():GetOrg() > 0 then
                
                local inorg = vgui.Create("DLabel", orgitem)
                inorg:SetFont("UiBold")
                inorg:SetText("You are already in an org.")
                inorg:SizeToContents()
                inorg:SetPos(orgitem:GetWide()/2-inorg:GetWide()/2, orgitem:GetTall()-inorg:GetTall()-10)
                
            else
            
                if appliedto == 0 then
                
                    local apply = vgui.Create("OCRP_BaseButton", orgitem)
                    apply:SetSize(orgitem:GetWide()/2, 25)
                    apply:SetPos(orgitem:GetWide()/2-apply:GetWide()/2, orgitem:GetTall()-apply:GetTall()-10)
                    apply:SetText("Request to Join")
                    
                    function apply:DoClick()
                        net.Start("OCRP_ApplyToOrg")
                        net.WriteInt(orgid, 32)
                        net.SendToServer()
                    end
                    
                elseif appliedto == orgid then
                    
                    local cancel = vgui.Create("OCRP_BaseButton", orgitem)
                    cancel:SetSize(orgitem:GetWide()/2, 25)
                    cancel:SetPos(orgitem:GetWide()/2-cancel:GetWide()/2, orgitem:GetTall()-cancel:GetTall()-10)
                    cancel:SetColor(Color(255,0,0,255))
                    cancel:SetText("Cancel Request")
                    
                    function cancel:DoClick()
                        net.Start("OCRP_CancelOrgApplication")
                        net.SendToServer()
                    end
                    
                else
                
                    local applied = vgui.Create("DLabel", orgitem)
                    applied:SetFont("UiBold")
                    applied:SetText("Request pending for a different org.")
                    applied:SizeToContents()
                    applied:SetPos(orgitem:GetWide()/2-applied:GetWide()/2, orgitem:GetTall()-applied:GetTall()-10)
                    
                end
                
            end
            

            orgList:AddItem(orgitem)
            
        end
        
        while table.Count(orgList:GetItems()) < 9 do
            local filler = vgui.Create("DPanel")
            filler:SetSize(orgList:GetWide()/2-20, 100)
            filler.Paint = function() end
            orgList:AddItem(filler)
        end
        
    end
    
    function ChooseOrgApplicantsTab(frame, scroll)
    
        frame.orgtab = "Applicants"
    
        EmptyMainMenu(frame)
        CreateSideBar(frame)
    
        local orgid = LocalPlayer():GetOrg()
    
        surface.SetFont("Trebuchet19")
        local textw,texth = surface.GetTextSize("These are the people who want to join your org.")
        
        local caption = vgui.Create("DPanel", frame)
        caption:SetSize(textw+10,texth+10)
        caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 5)
        
        table.insert(frame.CurrentChildren, caption)
        
        function caption:Paint(w,h)
            draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
            draw.DrawText("These are the people who want to join your org.", "Trebuchet19", 5, 5, Color(255,255,255,255))
        end
        
        local applicants = vgui.Create("DListView", frame)
        applicants:SetSize(frame:GetWide()-20, frame:GetTall()-select(2,caption:GetPos())-caption:GetTall()-50)
        applicants:SetPos(10, select(2, caption:GetPos())+caption:GetTall()+10)
        local name = applicants:AddColumn("Name")
        local id = applicants:AddColumn("Steam ID")
        local time = applicants:AddColumn("Playtime")
        local online = applicants:AddColumn("Online")
        
        if applicants.VBar and applicants.VBar:IsValid() and scroll then
            applicants.VBar.Scroll = scroll
        end
        -- Sizing is weird. It changes but definitely not to these vals
        name:SetWide(150)
        id:SetSize(50)
        time:SetSize(50)
        online:SetSize(1)
        
        function applicants:Paint(w,h)
            draw.RoundedBox(0, 0, 0, w, h, Color(30,30,30,255))
        end
        
        table.insert(frame.CurrentChildren, applicants)
        
        local outline = vgui.Create("DPanel", frame)
        outline:SetSize(applicants:GetWide()+2, applicants:GetTall()+2)
        outline:SetPos(applicants:GetPos()-1, select(2, applicants:GetPos())-1)
        
        function outline:Paint(w,h)
            draw.RoundedBox(0,0,0,w,h,Color(39,168,216,255))
        end
        
        outline:MoveToBack()
        
        table.insert(frame.CurrentChildren, outline)

        local dolater = {}
        
        for k,v in pairs(OCRP_Orgs[orgid].Applicants or {}) do
            if not v.SteamID then continue end
            local ply = player.GetBySteamID(v.SteamID)
            if ply and ply:IsValid() then
                local pt = formatPlayTime(v.Playtime):gsub(" Minutes", "m"):gsub(" Hours", "h"):gsub(" Days", "d"):gsub(" Weeks", "w")
                pt = pt:gsub(" Minute", "m"):gsub(" Hour", "h"):gsub(" Day", "d"):gsub(" Week", "w")
                local line = applicants:AddLine(ply:Nick(), v.SteamID, pt, "Yes")
                for _,column in pairs(line.Columns) do
                    column:SetTextColor(Color(255,255,255,255))
                end
            else
                table.insert(dolater, v)
            end
        end
        
        for k,v in pairs(dolater) do
            local pt = formatPlayTime(v.Playtime):gsub(" Minutes", "m"):gsub(" Hours", "h"):gsub(" Days", "d"):gsub(" Weeks", "w")
            pt = pt:gsub(" Minute", "m"):gsub(" Hour", "h"):gsub(" Day", "d"):gsub(" Week", "w")
            local line = applicants:AddLine(v.Name, v.SteamID, pt, "No", v.Notes)
            for _,column in pairs(line.Columns) do
                column:SetTextColor(Color(255,255,255,255))
            end
        end
        
        if LocalPlayer():SteamID() == OCRP_Orgs[orgid].Owner then
            local accept = vgui.Create("OCRP_BaseButton", frame)
            accept:SetSize(150, 25)
            accept:SetText("Accept Applicant")
            accept:SetPos(frame:GetWide()/4-accept:GetWide()/2, frame:GetTall()-18-accept:GetTall()/2)
            
            function accept:DoClick()
                local line = applicants:GetSelectedLine()
                if not line then OCRP_AddHint("You must select an applicant to accept.") return end
                line = applicants:GetLine(line)
                net.Start("OCRP_RespondToApplicant")
                net.WriteString(line:GetColumnText(2))
                net.WriteBool(true)
                net.SendToServer()
            end
            
            local deny = vgui.Create("OCRP_BaseButton", frame)
            deny:SetSize(150, 25)
            deny:SetText("Deny Applicant")
            deny:SetPos(frame:GetWide()/4*3-deny:GetWide()/2, select(2, accept:GetPos()))
            
            function deny:DoClick()
                local line = applicants:GetSelectedLine()
                if not line then OCRP_AddHint("You must select an applicant to deny.") return end
                line = applicants:GetLine(line)
                net.Start("OCRP_RespondToApplicant")
                net.WriteString(line:GetColumnText(2))
                net.WriteBool(false)
                net.SendToServer()
            end
            
            table.insert(frame.CurrentChildren, accept)
            table.insert(frame.CurrentChildren, deny)
        else
            local nocontrol = vgui.Create("DLabel", frame)
            nocontrol:SetTextColor(Color(255,255,255,255))
            nocontrol:SetFont("UiBold")
            nocontrol:SetText("Only the org owner can accept or deny applicants.")
            nocontrol:SizeToContents()
            nocontrol:SetPos(frame:GetWide()/2-nocontrol:GetWide()/2, frame:GetTall()-18-nocontrol:GetTall()/2)
            
            table.insert(frame.CurrentChildren, nocontrol)
        end
    
    end
    
    function ChooseOrgPerksTab(frame)
    
        frame.orgtab = "Perks"
    
        EmptyMainMenu(frame)
        CreateSideBar(frame)
        
        surface.SetFont("Trebuchet19")
        local text = "These are all the perks your org can unlock."
        local textw,texth = surface.GetTextSize(text)
        
        local caption = vgui.Create("DPanel", frame)
        caption:SetSize(textw+10,texth+10)
        caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 5)
        
        table.insert(frame.CurrentChildren, caption)
        
        function caption:Paint(w,h)
            draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
            draw.DrawText(text, "Trebuchet19", 5, 5, Color(255,255,255,255))
        end
        
        table.insert(frame.CurrentChildren, caption)
        
        local perkList = vgui.Create("DPanelList", frame)
        perkList:SetPos(5, select(2, caption:GetPos())+caption:GetTall()+25)
        perkList:SetSize(frame:GetWide()-20, frame:GetTall()-select(2,caption:GetPos())-caption:GetTall()-25)
        perkList:EnableVerticalScrollbar(true)
        perkList:EnableHorizontal(true)
        perkList:SetSpacing(10)
        perkList:SetPadding(10)
        perkList:SetNoSizing(true)
        
        table.insert(frame.CurrentChildren, perkList)
        
        local OLPL = perkList.PerformLayout
        
        function perkList:PerformLayout(w,h)
            OLPL(self, w, h)
            self.VBar:SetTall(self.VBar:GetTall()-20)
            self.VBar:SetPos(self.VBar:GetPos(), 10)
        end
        
        for k,perk in pairs(GAMEMODE.OCRPPerks) do
            
            local perkitem = vgui.Create("DPanel")
            perkitem:SetSize(perkList:GetWide()/2 - 20, 100)

            local fonth = draw.GetFontHeight("UiBold")
            local unlocked = OCRP_Orgs[LocalPlayer():GetOrg()].Perks[k] == true
            surface.SetFont("UiBold")
            local rewardPos = perkitem:GetWide()/2 - surface.GetTextSize("Reward: " .. perk.Reward)/2
            
            function perkitem:Paint(w,h)
                draw.RoundedBox(8, 0, 0, w, h, unlocked and Color(39,168,216,255) or Color(255,0,0,255))
                draw.RoundedBox(8, 1, 1, w-2, h-2, Color(25,25,25,255))
                draw.DrawText(perk.Name, "Trebuchet19", w/2, 5, unlocked and Color(39,168,216,255) or Color(255,0,0,255), TEXT_ALIGN_CENTER)
                draw.DrawText(perk.Desc, "UiBold", w/2, 30, Color(255,255,255,100), TEXT_ALIGN_CENTER)
                local rewardWide = draw.SimpleText("Reward: ", "UiBold", rewardPos, 50, Color(39,168,216,255), TEXT_ALIGN_LEFT)
                draw.SimpleText(perk.Reward, "UiBold", rewardPos+rewardWide+2, 50, Color(255,255,255,255), TEXT_ALIGN_LEFT)
                draw.DrawText(unlocked and "Unlocked" or "Locked", "TargetID", w/2, 67, unlocked and Color(39,168,216,255) or Color(255,0,0,255), TEXT_ALIGN_CENTER)
            end
            
            perkList:AddItem(perkitem)
            
        end
        
        while #perkList:GetItems() < 7 do
            local filler = vgui.Create("DPanel")
            filler:SetSize(perkList:GetWide()/2- 20, 100)
            filler.Paint = function() end
            perkList:AddItem(filler)
        end
        
        local warning = vgui.Create("DLabel", frame)
        warning:SetFont("UiBold")
        warning:SetText("These perks are only active as long as you are in an org with them unlocked.")
        warning:SizeToContents()
        warning:SetPos(frame:GetWide()/2-warning:GetWide()/2, select(2, caption:GetPos())+caption:GetTall()+5)
        
        table.insert(frame.CurrentChildren, warning)
    
    end
    
    function CreateSideBar(frame)
    
        if LocalPlayer():GetOrg() == 0 then return end
    
        local orgside = vgui.Create("DPanel")
        orgside:SetSize(115, 5+(4 * 45))
        orgside:SetPos(frame:GetPos()+frame:GetWide(), select(2, frame:GetPos())+40)
        
        function orgside:Paint(w,h)
            draw.RoundedBoxEx(8, 0, 0, w, h, Color(0,0,0,255), false, true, false, true)
            for i=1,4 do
                draw.RoundedBoxEx(8, 0, 5+(i-1)*45, w-5, 40, Color(20,20,20,255), false, true, false, true)
            end
        end
        
        table.insert(frame.CurrentChildren, orgside)
        
        local y = 10
        
        local chooseMembers = vgui.Create("OCRP_BaseButton", orgside)
        chooseMembers:SetSize(100, 30)
        chooseMembers:SetText("Members")
        chooseMembers:SetPos(5, y)
        
        function chooseMembers:DoClick()
            ChooseOrgMembersTab(frame)
        end
        
        y = y + 45
        
        local chooseApplicants = vgui.Create("OCRP_BaseButton", orgside)
        chooseApplicants:SetSize(100, 30)
        chooseApplicants:SetText("Applicants")
        chooseApplicants:SetPos(5, y)
        
        function chooseApplicants:DoClick()
            ChooseOrgApplicantsTab(frame)
        end
        
        y = y + 45
        
        local choosePerks = vgui.Create("OCRP_BaseButton", orgside)
        choosePerks:SetSize(100, 30)
        choosePerks:SetText("Perks")
        choosePerks:SetPos(5, y)
        
        function choosePerks:DoClick()
            ChooseOrgPerksTab(frame)
        end
        
        y = y + 45
        
        local chooseBrowse = vgui.Create("OCRP_BaseButton", orgside)
        chooseBrowse:SetSize(100, 30)
        chooseBrowse:SetText("Browse Orgs")
        chooseBrowse:SetPos(5, y)
        
        function chooseBrowse:DoClick()
            ChooseBrowseOrgsTab(frame)
        end
    
    end
    
    if page then
        if page == "Members" then ChooseOrgMembersTab(frame, scroll) end
        if page == "Applicants" then ChooseOrgApplicantsTab(frame, scroll) end
        if page == "Perks" then ChooseOrgPerksTab(frame, scroll) end
        if page == "BrowseOrgs" then ChooseBrowseOrgsTab(frame, scroll) end
    else
        if LocalPlayer():GetOrg() > 0 then
            ChooseOrgMembersTab(frame)
        else
            ChooseBrowseOrgsTab(frame)
        end
    end
    
end

function OrgSetNotesPopup(stmid, name)

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(350, 170)
    frame:Center()
    frame:MakePopup()
    
    surface.SetFont("Trebuchet19")
    local textw,texth = surface.GetTextSize("Updating notes for " .. name)
    
    local info = vgui.Create("DPanel", frame)
    info:SetSize(textw+10, texth+10)
    info:SetPos(frame:GetWide()/2-info:GetWide()/2, 10)
    
    function info:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
        draw.DrawText("Updating notes for " .. name, "Trebuchet19", 5, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
    end
    
	local label1 = vgui.Create("DLabel", frame)
	label1:SetFont("UiBold")
	label1:SetText("Notes:")
	label1:SetTextColor(Color(39,168,216,255))
	label1:SizeToContents()
	label1:SetPos(frame:GetWide()/2-175/2-label1:GetWide()/2, select(2, info:GetPos())+info:GetTall()+25)
	
	local notes = vgui.Create("DTextEntry", frame)
	notes:SetSize(175, 30)
	notes:SetPos(label1:GetPos()+label1:GetWide()+10, select(2, label1:GetPos())+label1:GetTall()/2-notes:GetTall()/2)
	
	function notes:Paint(w,h)
		draw.RoundedBox(8,0,0,w,h,Color(0,0,0,255))
		self:DrawTextEntryText(Color(255,255,255,255), Color(100,100,100,255), Color(255,255,255,255))
	end
	
	function notes:OnChange()
		local val = notes:GetText()
		if val:len() >= 50 then
			notes:SetText(string.sub(notes:GetText(), 1, val:len()-1))
			notes:SetCaretPos(val:len()-1)
		end
	end
    
    local confirm = vgui.Create("OCRP_BaseButton", frame)
    confirm:SetSize(label1:GetWide()+10+notes:GetWide(), 30)
    confirm:SetText("Confirm")
    confirm:SetPos(frame:GetWide()/2-confirm:GetWide()/2, select(2, notes:GetPos()) + notes:GetTall()+20)

    function confirm:DoClick()
        local txt = notes:GetText()
        if txt:len() > 50 then
            OCRP_AddHint("Notes cannot be more than 50 characters.")
            return
        end
        net.Start("OCRP_SetOrgNotes")
        net.WriteString(stmid)
        net.WriteString(txt)
        net.SendToServer()
        frame:Remove()
    end

end

function Org_AreYouSure(stmid, name, type, base)
    base:SetMouseInputEnabled(false)
    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(270, 120)
    frame:Center()
    frame:MakePopup()

    local start = SysTime()
    
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, start)
        draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0,255))
        draw.RoundedBox(4, 1, 1, w-2, h-2, Color(25,25,25,255))
        draw.DrawText("Are you sure?", "TargetIDSmall", w/2, 10, Color(39,168,216,255), TEXT_ALIGN_CENTER)
        if type == "kick" then
            draw.DrawText("Kicking: " .. name, "UiBold", w/2, 40, Color(255,255,255,255), TEXT_ALIGN_CENTER)
        elseif type == "owner" then
            draw.DrawText("Making " .. name .. " owner.", "UiBold", w/2, 40, Color(255,255,255,255), TEXT_ALIGN_CENTER)
            draw.DrawText("You will have no control once you make this member owner.", "HUDHintTextSmall", w/2, h-15, Color(255,255,255,255), TEXT_ALIGN_CENTER)
        end
    end
    
    local yes = vgui.Create("OCRP_BaseButton", frame)
    yes:SetText("Yes")
    yes:SetSize(75, 20)
    yes:SetPos(33, 75)
    
    function yes:DoClick()
        if type == "kick" then
            net.Start("OCRP_KickOrgMember")
        elseif type == "owner" then
            net.Start("OCRP_PassOrgOwnership")
        end
        net.WriteString(stmid)
        net.SendToServer()
        frame:Remove()
        base:SetMouseInputEnabled(true)
    end
    
    local no = vgui.Create("OCRP_BaseButton", frame)
    no:SetText("No")
    no:SetSize(75, 20)
    no:SetPos(141, 75)
    
    function no:DoClick()
        frame:Remove()
        base:SetMouseInputEnabled(true)
    end
    
end

function ChooseBuddiesTab(frame)
    EmptyMainMenu(frame)
    
    frame:SetOCRPTitle("Buddies")
    
    frame.tab = "Buddies"
    
    surface.SetFont("Trebuchet19")
    local textw,texth = surface.GetTextSize("You can manage your buddies list here.")
    
    local caption = vgui.Create("DPanel", frame)
    caption:SetSize(textw+10,texth+10)
    caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 5)
    
    table.insert(frame.CurrentChildren, caption)
    
    function caption:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
        draw.DrawText("You can manage your buddies list here.", "Trebuchet19", 5, 5, Color(255,255,255,255))
    end
    
    local buddies = vgui.Create("DListView", frame)
    buddies:SetSize(frame:GetWide()/2-80, frame:GetTall()-40-select(2, caption:GetPos())-caption:GetTall())
    buddies:SetPos(10, select(2, caption:GetPos())+caption:GetTall()+30)
    buddies:SetMultiSelect(false)
    buddies:AddColumn("Username")
    buddies:AddColumn("Steam ID")
    
    function buddies:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(30,30,30,255))
    end
    
    for k,v in pairs(OCRP_Buddies) do
        local ply = player.GetBySteamID(v)
        if ply and ply:IsValid() then
            local line = buddies:AddLine(ply:Nick(), v)
            for _,column in pairs(line.Columns) do
                column:SetTextColor(Color(255,255,255,255))
            end
        end
    end
    
    table.insert(frame.CurrentChildren, buddies)
    
    local nonbuddies = vgui.Create("DListView", frame)
    nonbuddies:SetSize(buddies:GetWide(), buddies:GetTall())
    nonbuddies:SetPos(buddies:GetPos()+buddies:GetWide()+140, select(2, buddies:GetPos()))
    nonbuddies:SetMultiSelect(false)
    nonbuddies:AddColumn("Username")
    nonbuddies:AddColumn("Steam ID")
    
    nonbuddies.Paint = buddies.Paint
    
    table.insert(frame.CurrentChildren, nonbuddies)
    
    local outline1 = vgui.Create("DPanel", frame)
    outline1:SetSize(buddies:GetWide()+2, buddies:GetTall()+2)
    outline1:SetPos(buddies:GetPos()-1, select(2, buddies:GetPos())-1)
    outline1:MoveToBack()
    
    function outline1:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(39,168,216,255))
    end
    
    local outline2 = vgui.Create("DPanel", frame)
    outline2:SetSize(nonbuddies:GetWide()+2, nonbuddies:GetTall()+2)
    outline2:SetPos(nonbuddies:GetPos()-1, select(2, nonbuddies:GetPos())-1)
    outline2:MoveToBack()
    
    outline2.Paint = outline1.Paint
    
    table.insert(frame.CurrentChildren, outline1)
    table.insert(frame.CurrentChildren, outline2)
    
    local blabel = vgui.Create("DLabel", frame)
    blabel:SetText("Online Buddies")
    blabel:SetFont("UiBold")
    blabel:SetTextColor(Color(39,168,216,255))
    blabel:SizeToContents()
    blabel:SetPos(buddies:GetPos()+buddies:GetWide()/2-blabel:GetWide()/2, select(2, buddies:GetPos())-15)
    
    table.insert(frame.CurrentChildren, blabel)
    
    local nblabel = vgui.Create("DLabel", frame)
    nblabel:SetText("Non-Buddy Players")
    nblabel:SetFont("UiBold")
    nblabel:SetTextColor(Color(39,168,216,255))
    nblabel:SizeToContents()
    nblabel:SetPos(nonbuddies:GetPos()+nonbuddies:GetWide()/2-nblabel:GetWide()/2, select(2, nonbuddies:GetPos())-15)
    
    table.insert(frame.CurrentChildren, nblabel)
    
    local removeBuddy = vgui.Create("OCRP_BaseButton", frame)
    removeBuddy:SetSize(120, 30)
    removeBuddy:SetText("Remove Buddy --->")
    removeBuddy:SetPos(buddies:GetPos()+buddies:GetWide()+70-removeBuddy:GetWide()/2, select(2, buddies:GetPos())+2*buddies:GetTall()/3-removeBuddy:GetTall()/2)
    
    function removeBuddy:DoClick()
        local line = buddies:GetSelectedLine()
        if not line then OCRP_AddHint("You must select a buddy to remove.") return end
        line = buddies:GetLine(line)
        if not line or not line:IsValid() or not line:GetColumnText(2) then return end
        local steamid = line:GetColumnText(2)
		net.Start("OCRP_RemoveBuddy")
			net.WriteString(steamid)
		net.SendToServer()
        table.RemoveByValue(OCRP_Buddies, steamid)
        ChooseBuddiesTab(frame)
    end
    
    table.insert(frame.CurrentChildren, removeBuddy)
    
    local addBuddy = vgui.Create("OCRP_BaseButton", frame)
    addBuddy:SetSize(120, 30)
    addBuddy:SetText("<--- Add Buddy")
    addBuddy:SetPos(removeBuddy:GetPos(), select(2, buddies:GetPos())+buddies:GetTall()/3-addBuddy:GetTall()/2)
    
    function addBuddy:DoClick()
        local line = nonbuddies:GetSelectedLine()
        if not line then OCRP_AddHint("You must select a player to add as a buddy.") return end
        line = nonbuddies:GetLine(line)
        if not line or not line:IsValid() or not line:GetColumnText(2) then return end
        local steamid = line:GetColumnText(2)
		net.Start("OCRP_AddBuddy")
			net.WriteString(steamid)
		net.SendToServer()
        table.insert(OCRP_Buddies, steamid)
        ChooseBuddiesTab(frame)
    end
    
    table.insert(frame.CurrentChildren, addBuddy)
    
    for _,ply in pairs(player.GetAll()) do
        if ply:IsValid() and ply:EntIndex() != LocalPlayer():EntIndex() then
            if not table.HasValue(OCRP_Buddies, ply:SteamID()) then
                local line = nonbuddies:AddLine(ply:Nick(), ply:SteamID())
                for _,column in pairs(line.Columns) do
                    column:SetTextColor(Color(255,255,255,255))
                end
            end
        end
    end
end

function ChooseChatTab(frame, scroll)

    EmptyMainMenu(frame)
    
    frame:SetOCRPTitle("Chat Log")
    
    frame.tab = "Chat"
    
    surface.SetFont("Trebuchet19")
    local textw,texth = surface.GetTextSize("This is all the chat you have seen while playing this session.")
    
    local caption = vgui.Create("DPanel", frame)
    caption:SetSize(textw+10,texth+10)
    caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 5)
    
    table.insert(frame.CurrentChildren, caption)
    
    function caption:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
        draw.DrawText("This is all the chat you have seen while playing this session.", "Trebuchet19", 5, 5, Color(255,255,255,255))
    end
    
    local chat = vgui.Create("DListView", frame)
    chat:SetSize(frame:GetWide()-20, frame:GetTall()-30-select(2, caption:GetPos())-caption:GetTall())
    chat:SetPos(10, select(2, caption:GetPos())+caption:GetTall()+20)
    chat:AddColumn("Time"):SetFixedWidth(100)
    chat:AddColumn("Speaker"):SetFixedWidth(100)
    chat:AddColumn("Chat Type"):SetFixedWidth(100)
    chat:AddColumn("Text")
    
    function chat:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(30,30,30,255))
    end
    
    frame.chat = chat
    
    table.insert(frame.CurrentChildren, chat)
    
    local outline = vgui.Create("DPanel", frame)
    outline:SetSize(chat:GetWide()+2, chat:GetTall()+2)
    outline:SetPos(chat:GetPos()-1, select(2, chat:GetPos())-1)
    
    function outline:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(39,168,216,255))
    end
    
    outline:MoveToBack()
    
    for _,t in pairs(ChatLoggingTable or {}) do
        local line = chat:AddLine(t.Time, t.Speaker, t.Type, t.Line)
        for _,column in pairs(line.Columns) do
            column:SetTextColor(Color(255,255,255,255))
        end
		function line:OnRightClick()
		
			local str = "[" .. self:GetColumnText(1) .. "] [".. self:GetColumnText(2) .."] -> [".. self:GetColumnText(3) .."] -> ".. self:GetColumnText(4)
			print(str)
		
		end
    end
    
    table.insert(frame.CurrentChildren, outline)
	
	local rightclickinfo = vgui.Create("DLabel", frame)
	rightclickinfo:SetFont("UiBold")
	rightclickinfo:SetText("Right click a line to print it to console.")
	rightclickinfo:SizeToContents()
	rightclickinfo:SetPos(frame:GetWide()/2-rightclickinfo:GetWide()/2,select(2, chat:GetPos())-rightclickinfo:GetTall()-5)
	
	table.insert(frame.CurrentChildren, rightclickinfo)
	
	if LocalPlayer():GetLevel() <= 2 then
		chat:SetSize(chat:GetWide(), chat:GetTall()-15)
		outline:SetSize(outline:GetWide(), outline:GetTall()-15)
		local admininfo = vgui.Create("DLabel", frame)
		admininfo:SetFont("UiBold")
		admininfo:SetText("You are an admin. You will see all server chat here. A * means the line would not normally have been visible to you.")
		admininfo:SizeToContents()
		admininfo:SetPos(frame:GetWide()/2-admininfo:GetWide()/2, frame:GetTall()-18)
		table.insert(frame.CurrentChildren, admininfo)
	end
    
    if chat.VBar and chat.VBar:IsValid() and scroll then
        timer.Simple(.01, function()
            chat.VBar:SetScroll(scroll)
        end)
    end
	
end

function GM:OnSpawnMenuOpen()
    OpenMainMenu()
    CantCloseMainMenu = true
    timer.Simple(.2, function()
        CantCloseMainMenu = false
    end)
end

function GM:OnSpawnMenuClose()
    MainMenuOpen = false
end

local released = true
hook.Add("Think", "OCRPCloseMainMenuWatcher", function()
    if TYPING or gui.IsConsoleVisible() or (not OCRP_MAINMENU or not OCRP_MAINMENU:IsValid()) then return end
    if input.IsKeyDown(KEY_Q) and released and not CantCloseMainMenu then
        OCRP_MAINMENU.Close:DoClick()
        released = false
    else
        released = true
    end
end)

ChatLoggingTable = ChatLoggingTable or {}
function AddToChatLogTable( speaker, type, line )
	if line == "" then return end
    local t = {}
    t["Speaker"] = speaker
    t["Type"] = type
    t["Line"] = line
    t["Time"] = os.date( "%c" )
    table.insert(ChatLoggingTable, t)
    if #ChatLoggingTable > 500 then
        table.remove(ChatLoggingTable, 1)
    end
    
    if OCRP_MAINMENU and OCRP_MAINMENU:IsValid() and OCRP_MAINMENU.tab == "Chat" then
        local scroll = 0
        if OCRP_MAINMENU.chat and OCRP_MAINMENU.chat.VBar and OCRP_MAINMENU.chat.VBar:IsValid() then
            scroll = OCRP_MAINMENU.chat.VBar.Scroll
        end
        ChooseChatTab(OCRP_MAINMENU, scroll)
    end
    
end

function GUI_BankMenu()

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(300,120)
    frame:SetOCRPTitle("Your Account")
    frame:Center()
    frame:AllowCloseButton(true)
    frame:MakePopup()
    
    surface.SetFont("UiBold")
    local wide,tall = surface.GetTextSize("Current Balance: $" .. LocalPlayer().Bank)
    
    local balBox = vgui.Create("DFrame", frame)
    balBox:SetSize(wide+10, tall+10)
    balBox:SetPos((frame:GetWide()/2)-(balBox:GetWide()/2), 10)
    balBox:ShowCloseButton(false)
    balBox:SetTitle("")
    
    local line1 = surface.GetTextSize("Current Balance: ")
    function balBox:Paint(w,h)
        draw.DrawText("Current Balance: ", "UiBold", (w/2)-wide/2, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
        draw.DrawText("$" .. LocalPlayer().Bank, "UiBold", ((w/2)-wide/2)+line1+3, 5, Color(39,168,216,255), TEXT_ALIGN_LEFT)
    end
    
    local withdrawBox = vgui.Create("DTextEntry", frame)
    withdrawBox:SetSize(150, 25)
    withdrawBox:SetPos(frame:GetWide()/2-withdrawBox:GetWide()/2, 40)
    withdrawBox:SetPaintBorderEnabled(true)
    
    local curval = withdrawBox:GetValue()
    
    function withdrawBox:OnChange()
        local val = withdrawBox:GetValue()
        if not tonumber(val) and val != "" then
            withdrawBox:SetText(curval)
            withdrawBox:SetCaretPos(withdrawBox:GetText():len())
        end
        curval = withdrawBox:GetValue()
    end
    
    function withdrawBox:OnValueChange(val) -- they hit enter, round the value
        if tonumber(val) then
            withdrawBox:SetText("" .. math.floor(tonumber(val)))
            curval = withdrawBox:GetValue()
        end
    end
    
    function withdrawBox:Paint(w,h)
        draw.RoundedBox(8,0,0,w,h,Color(0,0,0,255))
        self:DrawTextEntryText(Color(255,255,255,255), Color(100,100,100,255), Color(255,255,255,255))
    end
    
    local wholeWallet = vgui.Create("OCRP_BaseButton", frame)
    wholeWallet:SetText("Wallet")
    wholeWallet:SetSize(50, 25)
    wholeWallet:SetPos(withdrawBox:GetPos() + withdrawBox:GetWide() + 10, 40)
    
    function wholeWallet:DoClick()
        withdrawBox:SetText("" .. LocalPlayer().Wallet)
    end
    
    local wholeBank = vgui.Create("OCRP_BaseButton", frame)
    wholeBank:SetText("Bank")
    wholeBank:SetSize(50, 25)
    wholeBank:SetPos( withdrawBox:GetPos() - wholeWallet:GetWide() - 10, 40)
    
    function wholeBank:DoClick()
        withdrawBox:SetText("" .. LocalPlayer().Bank)
    end
    
    local withdraw = vgui.Create("OCRP_BaseButton", frame)
    withdraw:SetText("Withdraw")
    withdraw:SetSize(80, 25)
    withdraw:SetPos(withdrawBox:GetPos()-10, 80)
    
    function withdraw:DoClick()
        local price = tonumber(withdrawBox:GetValue() or 0)
        if not price then return end
        if price > (LocalPlayer().Bank or 0) then
            OCRP_AddHint("You don't have enough in your bank to withdraw that much.")
            return
        end
        net.Start("OCRP_Withdraw_Money")
        net.WriteInt(price, 32)
        net.SendToServer()
        frame:Remove()
    end
    
    local deposit = vgui.Create("OCRP_BaseButton", frame)
    deposit:SetText("Deposit")
    deposit:SetSize(80, 25)
    deposit:SetPos(withdrawBox:GetPos()+withdrawBox:GetWide()-deposit:GetWide()+10, 80)
    
    function deposit:DoClick()
        local price = tonumber(withdrawBox:GetValue() or 0)
        if not price then return end
        if price > (LocalPlayer().Wallet or 0) then
            OCRP_AddHint("You don't have enough in your wallet to deposit that much.")
            return
        end
        net.Start("OCRP_Deposit_Money")
        net.WriteInt(price, 32)
        net.SendToServer()
        frame:Remove()
    end
    
end

function GUI_GasMenu(car)
    local gas = OCRP_VehicleGas
    local maxGas = 100
    if GAMEMODE.OCRP_Cars[car:GetNWString("Type")] then
        maxGas = GAMEMODE.OCRP_Cars[car:GetNWString("Type")].GasTank
    end
    if maxGas-gas == 0 then
        OCRP_AddHint("Your car already has a full tank!")
        return
    end
    
    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(250, 110)
    frame:SetOCRPTitle("Gas Pump")
    frame:Center()
    frame:MakePopup()
    
    surface.SetFont("UiBold")
    local wide,tall = surface.GetTextSize("Your car holds " .. maxGas .. " liters. \nYou have " .. gas .. " liters.")
    local wide2,tall2 = surface.GetTextSize("You have " .. gas .. " liters.")
    
    local info = vgui.Create("DFrame", frame)
    info:SetSize(wide+10, tall+10)
    info:SetPos((frame:GetWide()/2)-(info:GetWide()/2), 10)
    info:ShowCloseButton(false)
    info:SetTitle("")
    
    local line1,linetall1 = surface.GetTextSize("Your car holds ")
    local line2 = surface.GetTextSize("You have ")
    function info:Paint(w,h)
        draw.DrawText("Your car holds ", "UiBold", w/2-wide/2, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT)
        draw.DrawText("" .. maxGas .. " liters.", "UiBold", w/2-wide/2+line1, 0, Color(39,168,216,255), TEXT_ALIGN_LEFT)
        draw.DrawText("You have ", "UiBold", w/2-wide2/2, linetall1, Color(255,255,255,255), TEXT_ALIGN_LEFT)
        draw.DrawText("" .. gas .. " liters.", "UiBold", w/2-wide2/2+line2, linetall1, Color(39,168,216,255), TEXT_ALIGN_LEFT)
    end
    
    local slider = vgui.Create("DSlider", frame)
    slider:SetWide(175)
    slider:SetPos(25,40)
    slider:SetSlideX(1)
    
    function slider:Paint(w,h)
        draw.RoundedBox(0, 0, h/2, w, 1, Color(39,168,216,255))
        for i=0,4 do
            local x = i*w/4
            if x == w then x = x-1 end -- Make sure it shows
            draw.RoundedBox(0, x, h/2-7, 1, 15, Color(39,168,216,255))
        end
    end
    
    local amount = vgui.Create("DLabel", frame)
    amount:SetText(maxGas-gas)
    amount:SetPos(220, 42)
    amount:SetFont("UiBold")
    amount:SetTextColor(Color(39,168,216,255))
    amount:SizeToContents()
    
    function amount:Think()
        self:SetText(math.floor((maxGas-gas) * slider:GetSlideX()))
    end
    
    local buy = vgui.Create("OCRP_BaseButton", frame)
    buy:SetSize(100, 20)
    buy:SetText("Buy Gas")
    buy:SetPos(frame:GetWide()/2-buy:GetWide()/2, 75)
    
    function buy:DoClick()
        local gasAmount = math.Round(slider:GetSlideX() * (maxGas - gas))
        local price = gasAmount * 1.25 * (1 + (GetGlobalInt("Eco_Tax")/100))
        if LocalPlayer().Wallet < price then
            OCRP_AddHint("You don't have enough money in your wallet!")
            return
        end
        net.Start("OCRP_Add_Gas")
            net.WriteInt(gasAmount, 16)
        net.SendToServer()
        OCRP_VehicleGas = OCRP_VehicleGas + gasAmount
        frame:Remove()
    end
end

function ResetSkillsMenu()

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(300, 110)
    frame:Center()
    frame:MakePopup()

    local start = SysTime()
    
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, start)
        draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0,255))
        draw.RoundedBox(4, 1, 1, w-2, h-2, Color(25,25,25,255))
        draw.DrawText("Are you sure?", "TargetIDSmall", w/2, 10, Color(39,168,216,255), TEXT_ALIGN_CENTER)
        draw.DrawText("You are resetting all your skills to level 0.", "UiBold", w/2, 30, Color(255,255,255,255), TEXT_ALIGN_CENTER)
        draw.DrawText("You will be given back the books for your current skills.", "UiBold", w/2, 45, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end
    
    local yes = vgui.Create("OCRP_BaseButton", frame)
    yes:SetText("Yes")
    yes:SetSize(75, 20)
    yes:SetPos(50, 75)
    
    function yes:DoClick()
		net.Start("OCRP_Useitem")
			net.WriteString("item_skill_reset")
		net.SendToServer()
        frame:Remove()
    end
    
    local no = vgui.Create("OCRP_BaseButton", frame)
    no:SetText("No")
    no:SetSize(75, 20)
    no:SetPos(175, 75)
    
    function no:DoClick()
        frame:Remove()
    end
	
end

net.Receive("OCRP_Bank", function(len)
	for _,obj in pairs(ents.FindByClass("Bank_atm")) do
		if obj:GetPos():Distance(LocalPlayer():GetPos()) < 100 then
			GUI_BankMenu()
		end
	end
end)

net.Receive("OCRP_Gas_Pump", function(len)
    for _,obj in pairs(ents.FindByClass("gas_pump")) do
        if obj:GetPos():Distance(LocalPlayer():GetPos()) < 100 then
            local carClose = false
            for _,obj2 in pairs(ents.FindByClass("prop_vehicle_jeep")) do
                if obj2:GetPos():Distance(obj:GetPos()) < 300 then
                    if obj2:GetNWInt("Owner") > 0 then
                        if player.GetByID(obj2:GetNWInt("Owner")) and player.GetByID(obj2:GetNWInt("Owner")) == LocalPlayer() then
                            GUI_GasMenu(obj2)
                            carClose = true
                        end
                    end
                end
            end
            if not carClose then
                OCRP_AddHint("Your car is not close enough to refuel!")
            end
            break
        end
    end
end)