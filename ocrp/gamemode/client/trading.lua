TradingPartner = TradingPartner or nil
OCRP_TRADEMENU = OCRP_TRADEMENU or nil
ConfirmedTrade = ConfirmedTrade or false
net.Receive("OCRP_OpenTrade", function()
    
    local partner = Entity(net.ReadInt(32))
    
    if not partner or not partner:IsValid() then return end
    
    TradingPartner = partner
    
    OpenTradeWindow()
    
end)

function OpenTradeWindow()

    ConfirmedTrade = false

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(470, 555)
    frame:Center()
    frame:SetOCRPTitle("Trading with " .. TradingPartner:Nick())
    frame:MakePopup()
    
    OCRP_TRADEMENU = frame
    
    local OCDC = frame.Close.DoClick
    
    function frame.Close:DoClick()
        OCDC(self)
        net.Start("OCRP_EndTrade")
        net.SendToServer()
    end
    
    local divider = vgui.Create("DPanel", frame)
    divider:SetSize(1, 535)
    divider:SetPos(frame:GetWide()/2, 10)
    
    function divider:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(39,168,216,255))
    end
    
    for z=1,2 do
    
        local label = vgui.Create("DLabel", frame)
        label:SetFont("UiBold")
        label:SetTextColor(Color(39,168,216,255))
    
        local inv = vgui.Create("DPanelList", frame)
        inv:SetSize(frame:GetWide()/2, 460)
        if z == 1 then
            inv:SetPos(0, 20)
            label:SetText("Your Offer")
        else
            inv:SetPos(frame:GetWide()/2+6, 25)
            label:SetText("Their Offer")
        end
        label:SizeToContents()
        label:SetPos(inv:GetPos()+inv:GetWide()/2-label:GetWide()/2, select(2,inv:GetPos())-label:GetTall()+3)
        inv:EnableHorizontal(true)
        inv:SetSpacing(10)
        inv:SetNoSizing(true)
        inv:SetPadding(10)
        inv.items = {}
        
        function inv:RebuildItems()
        
            local dummyEnt = ents.CreateClientProp("prop_physics")
            dummyEnt:SetPos(Vector(0,0,0))
            dummyEnt:Spawn()
            dummyEnt:Activate()
            inv:Clear()
            for item,amt in pairs(self.items or {}) do
                if not amt or amt == 0 then continue end
                
                local itemPanel = vgui.Create("DPanel")
                itemPanel.item = item
                itemPanel:SetSize(100, 140)
                function itemPanel:Paint(w,h)
                    draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0,255))
                    draw.DrawText(GAMEMODE.OCRP_Items[item].Name, "UiBold", w/2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
                    if amt > 1 then
                        draw.DrawText("x" .. amt, "UiBold", w/2, 18, Color(255,255,255,255), TEXT_ALIGN_CENTER)
                    end
                end
                local itemMdlPanel = vgui.Create("DModelPanel", itemPanel)
                itemMdlPanel:SetSize(80, 80)
                itemMdlPanel:SetPos(5, 30)
                itemMdlPanel:SetModel(GAMEMODE.OCRP_Items[item].Model)
                itemMdlPanel:SetCursor("arrow")
                
                itemMdlPanel.OnCursorEntered = itemPanel.OnCursorEntered
                itemMdlPanel.OnCursorExited = itemPanel.OnCursorExited
                
                -- Make the angles look nice by checking them on the dummy ent
                dummyEnt:SetModel(GAMEMODE.OCRP_Items[item].Model)
                local center = dummyEnt:OBBCenter()
                local dist = dummyEnt:BoundingRadius() * 1.2
                itemMdlPanel:SetLookAt(center)
                itemMdlPanel:SetCamPos(center+Vector(dist, dist, 0))
                
                inv:AddItem(itemPanel)
                
            end
            
            dummyEnt:Remove()
            
            while table.Count(inv:GetItems()) < 6 do
                local filler = vgui.Create("DPanel")
                filler:SetSize(100, 140)
                filler.blank = true
                function filler:Paint(w,h)
                    draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0,255))
                end
                inv:AddItem(filler)
            end
        
        end
        
        inv:RebuildItems()
        
        if z == 1 then
            frame.myinv = inv
        else
            frame.otherinv = inv
        end
        
    end
    
    local moneyBox = vgui.Create("DTextEntry", frame)
    moneyBox:SetSize(150, 25)
    moneyBox:SetPos(frame.myinv:GetPos()+frame.myinv:GetWide()/2-moneyBox:GetWide()/2+5, select(2, frame.myinv:GetPos())+frame.myinv:GetTall()+5)
    moneyBox:SetPaintBorderEnabled(true)
    moneyBox:SetNumeric(true)
    moneyBox:SetText(0)
    
    function moneyBox:Paint(w,h)
        draw.RoundedBox(8,0,0,w,h,Color(0,0,0,255))
        self:DrawTextEntryText(Color(255,255,255,255), Color(100,100,100,255), Color(255,255,255,255))
    end
    
    function moneyBox:OnValueChange(val)
        local realval = math.floor(tonumber(val) or 0)
        moneyBox:SetText(realval)
        net.Start("OCRP_SetTradeMoney")
        net.WriteInt(realval, 32)
        net.SendToServer()
    end
    
    local moneyLabel = vgui.Create("DPanel", frame)
    moneyLabel:SetSize(25, moneyBox:GetTall())
    moneyLabel:SetPos(moneyBox:GetPos()-15, select(2, moneyBox:GetPos()))
    
    function moneyLabel:Paint(w,h)
        draw.RoundedBoxEx(8, 0, 0, w, h, Color(0,0,0,255), true, false, true, false)
        draw.DrawText("$", "UiBold", w/2-3, 6, Color(39,168,216,255), TEXT_ALIGN_CENTER)
    end
    
    moneyBox:MoveToFront()
    
    local confirm = vgui.Create("OCRP_BaseButton", frame)
    confirm:SetSize(150, 20)
    confirm:SetPos(frame.myinv:GetPos()+frame.myinv:GetWide()/2-confirm:GetWide()/2, select(2, moneyBox:GetPos())+moneyBox:GetTall()+15)
    confirm:SetText("Confirm Trade")
    
    function confirm:DoClick()
        if ConfirmedTrade then
            confirm:SetText("Confirm Trade")
            confirm:SetColor(Color(39,168,216,255))
        else
            confirm:SetText("Cancel Confirmation")
            confirm:SetColor(Color(255,0,0,255))
        end
        ConfirmedTrade = !ConfirmedTrade
        net.Start("OCRP_ConfirmTrade")
        net.SendToServer()
        if ConfirmedTrade and frame.otherConfirmed.Confirmed then
            frame:Remove()
        end
    end
    
    frame.confirmButton = confirm
    
    surface.SetFont("UiBold")
    local zerowide = surface.GetTextSize("0")
    
    local otherMoneyLabel = vgui.Create("DLabel", frame)
    otherMoneyLabel:SetText("$")
    otherMoneyLabel:SetFont("UiBold")
    otherMoneyLabel:SetTextColor(Color(39,168,216,255))
    otherMoneyLabel:SizeToContents()
    otherMoneyLabel:SetPos(frame.otherinv:GetPos()+frame.otherinv:GetWide()/2-otherMoneyLabel:GetWide()/2-zerowide/2, select(2, moneyBox:GetPos())+moneyBox:GetTall()/2-otherMoneyLabel:GetTall()/2)
    
    frame.otherMoneyLabel = otherMoneyLabel
    
    local otherMoney = vgui.Create("DLabel", frame)
    otherMoney:SetText("0")
    otherMoney:SetFont("UiBold")
    otherMoney:SetTextColor(Color(255,255,255,255))
    otherMoney:SizeToContents()
    otherMoney:SetPos(otherMoneyLabel:GetPos()+otherMoneyLabel:GetWide()+2, select(2, otherMoneyLabel:GetPos()))
    
    frame.otherMoney = otherMoney
    
    local otherConfirmed = vgui.Create("DLabel", frame)
    otherConfirmed:SetFont("UiBold")
    otherConfirmed.Confirmed = true -- We toggle it off in a sec to draw text, colors, position, etc
    frame.otherConfirmed = otherConfirmed
    toggleOtherConfirmed()
    
    -- Differences between myinv and otherinv
    
    local baseRebuild = frame.myinv.RebuildItems
    
    function frame.myinv:RebuildItems()
        baseRebuild(self)
        for _,itemPanel in pairs(self:GetItems()) do
            if itemPanel.blank then continue end
            local remove = vgui.Create("OCRP_BaseButton", itemPanel)
            remove:SetSize(90, 15)
            remove:SetText("Remove")
            remove:SetPos(5, 115)
            
            function remove:DoClick()
                frame.myinv.items[itemPanel.item] = 0
                net.Start("OCRP_SetTradeItemAmount")
                net.WriteString(itemPanel.item)
                net.WriteInt(0, 32)
                net.SendToServer()
                frame.myinv:RebuildItems()
                OCRP_TRADEMENU.ourRealInv.list:RebuildItems()
            end
        end
    end
    
    frame.myinv:RebuildItems()
    BuildOurRealInventory(frame)
    
end

net.Receive("OCRP_ConfirmTrade", function()
    if not OCRP_TRADEMENU or not OCRP_TRADEMENU:IsValid() then return end
    toggleOtherConfirmed()
    if OCRP_TRADEMENU.otherConfirmed.Confirmed and ConfirmedTrade then
        OCRP_TRADEMENU:Remove()
    end
end)

function toggleOtherConfirmed()
    if not OCRP_TRADEMENU or not OCRP_TRADEMENU:IsValid() then return end
    local otherConfirmed = OCRP_TRADEMENU.otherConfirmed
    local bool = !otherConfirmed.Confirmed
    otherConfirmed.Confirmed = bool
    if bool then
        otherConfirmed:SetText("Confirmed. Waiting for you.")
        otherConfirmed:SetTextColor(Color(39,168,216,255))
    else
        otherConfirmed:SetText("Not Yet Confirmed")
        otherConfirmed:SetTextColor(Color(255,255,255,100))
    end
    otherConfirmed:SizeToContents()
    otherConfirmed:SetPos(OCRP_TRADEMENU.otherinv:GetPos()+OCRP_TRADEMENU.otherinv:GetWide()/2-otherConfirmed:GetWide()/2, select(2, OCRP_TRADEMENU.confirmButton:GetPos())+OCRP_TRADEMENU.confirmButton:GetTall()/2-otherConfirmed:GetTall()/2)
end

net.Receive("OCRP_SetTradeMoney", function()
    if not OCRP_TRADEMENU or not OCRP_TRADEMENU:IsValid() then return end
    local newmoney = net.ReadInt(32)
    local om = OCRP_TRADEMENU.otherMoney
    local oml = OCRP_TRADEMENU.otherMoneyLabel
    local oi = OCRP_TRADEMENU.otherinv
    surface.SetFont("UiBold")
    local twide = surface.GetTextSize(tostring(newmoney))
    om:SetText(newmoney)
    om:SizeToContents()
    oml:SetPos(oi:GetPos()+oi:GetWide()/2-oml:GetWide()/2-twide/2, select(2, oml:GetPos()))
    om:SetPos(oml:GetPos()+oml:GetWide()+2, select(2, oml:GetPos()))
    if OCRP_TRADEMENU.otherConfirmed.Confirmed then
        toggleOtherConfirmed()
    end
    if ConfirmedTrade then
        OCRP_TRADEMENU.confirmButton:DoClick()
    end
end)

function SetItemAmount(item, amount)
    if not OCRP_TRADEMENU or not OCRP_TRADEMENU:IsValid() then return end
    local inv = OCRP_TRADEMENU.otherinv
    inv.items[item] = amount
    inv:RebuildItems()
end

net.Receive("OCRP_SetTradeItemAmount", function()
    local item = net.ReadString()
    local amt = net.ReadInt(32)
    SetItemAmount(item, amt)
    if OCRP_TRADEMENU.otherConfirmed.Confirmed then
        toggleOtherConfirmed()
    end
    if ConfirmedTrade then
        OCRP_TRADEMENU.confirmButton:DoClick()
    end
end)

function BuildOurRealInventory(frame)
    
    local ourinv = vgui.Create("OCRP_BaseMenu")
    ourinv:SetSize(360, 555)
    ourinv:SetPos(frame:GetPos()-ourinv:GetWide()-20, select(2, frame:GetPos()))
    ourinv:SetOCRPTitle("Your Inventory")
    ourinv:AllowCloseButton(false)
    ourinv:MakePopup()
    
    local invlist = vgui.Create("DPanelList", ourinv)
    invlist:SetSize(ourinv:GetWide(), ourinv:GetTall())
    invlist:SetPos(0,0)
    invlist:EnableHorizontal(true)
    invlist:EnableVerticalScrollbar(true)
    invlist:SetSpacing(10)
    invlist:SetNoSizing(true)
    invlist:SetPadding(10)
    
    frame.ourRealInv = ourinv
    ourinv.list = invlist
    
    local OPL = invlist.PerformLayout
    
    function invlist:PerformLayout()
        OPL(self)
        self.VBar:SetTall(self:GetTall()-10)
        self.VBar:SetPos(self:GetWide() - 20, 5)
    end
    
    function invlist:RebuildItems()
        local dummyEnt = ents.CreateClientProp("prop_physics")
        dummyEnt:SetPos(Vector(0,0,0))
        dummyEnt:Spawn()
        dummyEnt:Activate()
        self:Clear()
        for item,amt in pairs(OCRP_Inventory) do
            if item == "WeightData" then continue end
            
            for k,v in pairs(OCRP_TRADEMENU.myinv.items) do
                if k == item then
                    amt = amt - v
                end
            end
            
            local itemPanel = vgui.Create("DPanel")
            itemPanel:SetSize(100, 140)
            function itemPanel:Paint(w,h)
                draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0,255))
                if amt > 0 then
                    draw.DrawText(GAMEMODE.OCRP_Items[item].Name, "UiBold", w/2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
                    if amt > 1 then
                        draw.DrawText("x" .. amt, "UiBold", w/2, 18, Color(255,255,255,255), TEXT_ALIGN_CENTER)
                    end
                end
            end
            if amt > 0 then
                local itemMdlPanel = vgui.Create("DModelPanel", itemPanel)
                itemMdlPanel:SetSize(80, 80)
                itemMdlPanel:SetPos(5, 30)
                itemMdlPanel:SetModel(GAMEMODE.OCRP_Items[item].Model)
                itemMdlPanel:SetCursor("arrow")
                
                itemMdlPanel.OnCursorEntered = itemPanel.OnCursorEntered
                itemMdlPanel.OnCursorExited = itemPanel.OnCursorExited
                
                -- Make the angles look nice by checking them on the dummy ent
                dummyEnt:SetModel(GAMEMODE.OCRP_Items[item].Model)
                local center = dummyEnt:OBBCenter()
                local dist = dummyEnt:BoundingRadius() * 1.2
                itemMdlPanel:SetLookAt(center)
                itemMdlPanel:SetCamPos(center+Vector(dist, dist, 0))
                
                if not GAMEMODE.OCRP_Items[item].DoesntSave then
                    local add = vgui.Create("OCRP_BaseButton", itemPanel)
                    add:SetSize(90, 15)
                    add:SetText("Add")
                    add:SetPos(5, 115)

                    function add:DoClick()
                        AddToTradePopup(item)
                    end
                else
                    local cantdrop = vgui.Create("DLabel", itemPanel)
                    cantdrop:SetFont("UiBold")
                    cantdrop:SetTextColor(Color(100,100,100,255))
                    cantdrop:SetText("Can't be traded")
                    cantdrop:SizeToContents()
                    cantdrop:SetPos(itemPanel:GetWide()/2-cantdrop:GetWide()/2, 115)
                end
            end
            
            self:AddItem(itemPanel)
            
        end
        
        while table.Count(self:GetItems()) < 12 do
            local filler = vgui.Create("DPanel")
            filler:SetSize(100, 140)
            filler.blank = true
            function filler:Paint(w,h)
                draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0,255))
            end
            self:AddItem(filler)
        end
    end

    invlist:RebuildItems()
    
    local OFOR = frame.OnRemove
    
    function frame:OnRemove()
        OFOR(self)
        ourinv:Remove()
        if frame.amtpopup and frame.amtpopup:IsValid() then frame.amtpopup:Remove() end
    end
    
end

function AddToTradePopup(item)
    local ori = OCRP_TRADEMENU.ourRealInv
    ori:SetMouseInputEnabled(false)
    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(200, 100)
    frame:SetPos(ori:GetPos()+ori:GetWide()/2-frame:GetWide()/2, select(2, ori:GetPos())+ori:GetTall()/2-frame:GetTall()/2)
    frame.Outline:MakePopup()
    frame.Outline:SetMouseInputEnabled(false)
    frame:MakePopup()
    
    OCRP_TRADEMENU.amtpopup = frame
    
    local label = vgui.Create("DLabel", frame)
    label:SetFont("UiBold")
    label:SetTextColor(Color(255,255,255,255))
    label:SetText("How many?")
    label:SizeToContents()
    label:SetPos(frame:GetWide()/2-label:GetWide()/2, 10)
    
    OCRP_Inventory = OCRP_Inventory or {}
    local total = OCRP_Inventory[item]
    
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
    
    local add = vgui.Create("OCRP_BaseButton", frame)
    add:SetText("Add to Trade")
    add:SetSize(180, 20)
    add:SetPos(10, 73)
    
    function add:DoClick()
        local quantity = math.floor(total * slider:GetSlideX())
        if quantity > 0 then
            OCRP_TRADEMENU.myinv.items[item] = (OCRP_TRADEMENU.myinv.items[item] or 0) + quantity
            OCRP_TRADEMENU.myinv:RebuildItems()
            ori.list:RebuildItems()
            net.Start("OCRP_SetTradeItemAmount")
            net.WriteString(item)
            net.WriteInt(OCRP_TRADEMENU.myinv.items[item], 32)
            net.SendToServer()
        end
        frame:Remove()
    end
    
    local OOR = frame.OnRemove
    
    function frame:OnRemove()
        OOR(self)
        if ori and ori:IsValid() then
            ori:SetMouseInputEnabled(true)
        end
    end
    
end

net.Receive("OCRP_EndTrade", function()
    if OCRP_TRADEMENU and OCRP_TRADEMENU:IsValid() then
        OCRP_TRADEMENU:Remove()
    end
end)