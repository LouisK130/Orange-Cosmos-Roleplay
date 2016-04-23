net.Receive("OCRP_RequestSearch", function()
    local from = player.GetBySteamID(net.ReadString())
    if not from or not from:IsValid() then return end
    ShowSearchRequest(from)
end)

function ShowSearchRequest(from)

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(200, 100)
    frame:Center()
    frame:AllowCloseButton(false)
    frame:MakePopup()
    
    surface.SetFont("Trebuchet19")
    local name = from:Nick()
    local textw,texth = surface.GetTextSize("wants to search your inventory.")
    
    while surface.GetTextSize(name) >= textw do
        name = name:sub(1, name:len()-4) .. "..."
    end
    
    local _,nameh = surface.GetTextSize(name)
    
    local caption = vgui.Create("DPanel", frame)
    caption:SetSize(textw+10, texth+nameh+25)
    caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 10)
    
    function caption:Paint(w,h)
        draw.DrawText(name, "UiBold", w/2, 5, Color(39,168,216,255), TEXT_ALIGN_CENTER)
        draw.DrawText("wants to search your inventory.", "UiBold", w/2, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end
    
    local allow = vgui.Create("OCRP_BaseButton", frame)
    allow:SetSize(75, 20)
    allow:SetPos(50/3, frame:GetTall()-30)
    allow:SetText("Allow")
    
    function allow:DoClick()
        net.Start("OCRP_SearchRequestResponse")
        net.WriteString(from:SteamID())
        net.WriteBool(true)
        net.SendToServer()
        frame:Remove()
    end
    
    local deny = vgui.Create("OCRP_BaseButton", frame)
    deny:SetSize(75,20)
    deny:SetPos(2*50/3+75, frame:GetTall()-30)
    deny:SetText("Deny")
    
    function deny:DoClick()
        net.Start("OCRP_SearchRequestResponse")
        net.WriteString(from:SteamID())
        net.WriteBool(false)
        net.SendToServer()
        frame:Remove()
    end

end

net.Receive("OCRP_ShowSearch", function()
    local who = player.GetBySteamID(net.ReadString())
    local inv = net.ReadTable()
    ShowSearch(who, inv)
end)

function ShowSearch(who, items)

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(800, 500)
    frame:SetOCRPTitle(who:Nick() .. "'s Inventory")
    frame:Center()
    frame:MakePopup()
    
    surface.SetFont("Trebuchet19")
    local textw,texth = surface.GetTextSize("These are the items in " .. who:Nick() .. "'s inventory.")
    
    local caption = vgui.Create("DPanel", frame)
    caption:SetSize(textw+10, texth+10)
    caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 10)
    
    function caption:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
        draw.DrawText("These are the items in " .. who:Nick() .. "'s inventory.", "Trebuchet19", 5, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
    end
    
    local inv = vgui.Create("DPanelList", frame)
    inv:SetSize(800, frame:GetTall()-select(2, caption:GetPos())-caption:GetTall()-20)
    inv:SetPos(0, select(2, caption:GetPos())+caption:GetTall()+8)
    inv:SetPadding(10)
    inv:SetSpacing(10)
    inv:SetNoSizing(true)
    inv:EnableVerticalScrollbar(true)
    inv:EnableHorizontal(true)
    
    local pl = inv.PerformLayout
    
    function inv:PerformLayout()
        pl(self)
        self.VBar:SetTall(self:GetTall()-10)
        self.VBar:SetPos(self:GetWide() - 20, 5)
    end
    
    local oldP = frame.Paint
    
    function frame:Paint(w,h)
        oldP(self, w, h)
        draw.RoundedBox(8, frame:GetWide()+2, frame:GetTall()+2, frame:GetPos()-1, select(2, frame:GetPos())-1, Color(39,168,216,255))
    end
    
    function inv:LayoutInfo(itemTable)
    
        if self.info and self.info:IsValid() then self.info:Remove() end
    
        local info = vgui.Create("OCRP_BaseMenu")
        info:SetSize(200, 400)
        info:SetPos(frame:GetPos()+frame:GetWide()+20, select(2, frame:GetPos()))
        info:AllowCloseButton(false)
        info:MakePopup()
        
        self.info = info
        
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
    
    for item,amt in pairs(items) do
        if item == "WeightData" then continue end
        if not amt or amt == 0 then continue end
        local itemPanel = vgui.Create("DPanel")
        itemPanel:SetSize(100, 130)
        
        function itemPanel:Paint(w,h)
            draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0,255))
            draw.DrawText(GAMEMODE.OCRP_Items[item].Name, "UiBold", w/2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
            if amt > 1 then
                draw.DrawText("x" .. amt, "UiBold", w/2, 18, Color(255,255,255,255), TEXT_ALIGN_CENTER)
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
        
        local itemTable = GAMEMODE.OCRP_Items[item]
        
        if itemTable.Angle then
            itemMdlPanel:GetEntity():SetAngles(itemTable.Angle)
        end
        if itemTable.Material then
            itemMdlPanel:GetEntity():SetMaterial(itemTable.Material)
        end
        if itemTable.MdlColor then
            itemMdlPanel:SetColor(itemTable.MdlColor)
        end
        
        FocusModelPanel(itemMdlPanel)
        
        inv:AddItem(itemPanel)

    end
    
    while table.Count(inv:GetItems()) < 15 do
        local filler = vgui.Create("DPanel")
        filler:SetSize(100, 140)
        filler.Paint = function() end
        inv:AddItem(filler)
    end

end