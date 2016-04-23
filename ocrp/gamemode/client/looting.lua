net.Receive("OCRP_Loot", function()
    OpenLootingMenu(net.ReadTable())
end)

net.Receive("OCRP_UpdateLootingTable", function()
    PopulateLootingInventory(net.ReadTable())
end)

OCRP_LOOTINGMENU = nil

function OpenLootingMenu(items)

    local nick = LocalPlayer():GetEyeTrace().Entity:IsPlayer() and LocalPlayer():GetEyeTrace().Entity:Nick() or "UNKNOWN"

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(825, 500)
    frame:Center()
    frame:SetOCRPTitle("Looting: " .. nick)
    frame:MakePopup()
    
    OCRP_LOOTINGMENU = frame
    
    surface.SetFont("Trebuchet19")
    local textw,texth = surface.GetTextSize("These are the items the corpse has. You may not be skilled enough to loot some of them.")
    
    local caption = vgui.Create("DPanel", frame)
    caption:SetSize(textw+10, texth+10)
    caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 10)
    
    function caption:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
        draw.DrawText("These are the items the corpse has. You may not be skilled enough to loot some of them.", "Trebuchet19", 5, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
    end
    
    local outline = vgui.Create("DPanel", frame)
    outline:SetSize(frame:GetWide()-20, frame:GetTall()-10-5-texth-25)
    outline:SetPos(10, 5+texth+25)
    
    function outline:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(39,168,216,255))
        draw.RoundedBox(8, 1, 1, w-2, h-2, Color(20,20,20,255))
    end
    
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
    
    local IPL = inv.PerformLayout
    
    function inv:PerformLayout(w,h)
        IPL(self,w,h)
        self.VBar:SetTall(self.VBar:GetTall()-10)
        self.VBar:SetPos(self:GetWide()-20, 5)
    end
    
    frame.inv = inv
    
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
    
    PopulateLootingInventory(items)
    
    local OR = frame.OnRemove
    
    function frame:OnRemove()
        OR(self)
        if self.info and self.info:IsValid() then
            self.info:Remove()
        end
    end

end

function PopulateLootingInventory(items)

    if not OCRP_LOOTINGMENU or not OCRP_LOOTINGMENU:IsValid() then return end

    local frame = OCRP_LOOTINGMENU
    local inv = OCRP_LOOTINGMENU.inv
    inv:Clear()
    
    for item,amt in pairs(items or {}) do
    
        if item == "WeightData" then continue end
        local itemTable = GAMEMODE.OCRP_Items[item]
        if not itemTable then continue end
        if amt == 0 then continue end
        
        local itemPanel = vgui.Create("DPanel")
        itemPanel:SetSize(100, 135)
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
        
        if itemTable.Angle then
            itemMdlPanel:GetEntity():SetAngles(itemTable.Angle)
        end
        if itemTable.Material then
            itemMdlPanel:GetEntity():SetMaterial(itemTable.Material)
        end
        if itemTable.MdlColor then
            itemMdlPanel:SetColor(itemTable.MdlColor)
        end
        
        itemMdlPanel.OnCursorEntered = itemPanel.OnCursorEntered
        itemMdlPanel.OnCursorExited = itemPanel.OnCursorExited
        
        if itemTable.Angle then
            itemMdlPanel:GetEntity():SetAngles(itemTable.Angle)
        end
        if itemTable.Material then
            itemMdlPanel:GetEntity():SetMaterial(itemTable.Material)
        end
        
        FocusModelPanel(itemMdlPanel)
        
        local canloot = GAMEMODE.OCRP_Items[item].LootData and CL_HasSkill("skill_loot",GAMEMODE.OCRP_Items[item].LootData.Level) or false
        
        if canloot then
            local loot = vgui.Create("OCRP_BaseButton", itemPanel)
            loot:SetSize(90, 15)
            loot:SetPos(5, 115)
            loot:SetText("Loot")
            
            function loot:DoClick()
                StartLootingBar(item, GAMEMODE.OCRP_Items[item].LootData.Time or 2)
            end
        else
            local cantloot = vgui.Create("DLabel", itemPanel)
            cantloot:SetFont("UiBold")
            cantloot:SetText("Can't loot")
            cantloot:SizeToContents()
            cantloot:SetTextColor(Color(255,0,0,255))
            cantloot:SetPos(itemPanel:GetWide()/2-cantloot:GetWide()/2, 115)
        end
        inv:AddItem(itemPanel)
    
    end
    
    while table.Count(inv:GetItems()) < 21 do
        local blank = vgui.Create("DPanel")
        blank:SetSize(100, 135)
        blank.Paint = function() end
        inv:AddItem(blank)
    end

end

function StartLootingBar(item, time)

    net.Start("OCRP_BeginLooting")
    net.SendToServer()

    OCRP_LOOTINGMENU:SetMouseInputEnabled(false)
    local endtime = CurTime() + time

    local progress = vgui.Create("DProgress")
    progress:SetSize(200, 40)
    progress:Center()
    progress:MakePopup()
    
    function progress:Think()
        local val = math.Clamp(1-(endtime-CurTime())/time, 0, 1)
        self:SetFraction(val)
        if val == 1 then
            net.Start("OCRP_LootItem")
                net.WriteString(item)
            net.SendToServer()
            self:Remove()
            OCRP_LOOTINGMENU:SetMouseInputEnabled(true)
        end
    end

end