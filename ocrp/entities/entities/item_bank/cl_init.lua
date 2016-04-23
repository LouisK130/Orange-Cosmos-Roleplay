include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
end

net.Receive("OCRP_ShowItemBank", function()
    local items = net.ReadTable()
    ShowItemBank(items)
end)

OCRP_ItemBank = OCRP_ItemBank or {}

ITEMBANKMENU = nil
ITEMBANKINV = nil

function ShowItemBank(items)

    OCRP_ItemBank = items

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(470, 545)
    frame:SetOCRPTitle("Your Item Bank")
    frame:Center()
    frame:SetPos(ScrW()/2-(frame:GetWide()+15), select(2, frame:GetPos()))
    frame:MakePopup()
    
    ITEMBANKMENU = frame
    
    local OOR = frame.OnRemove
    
    function frame:OnRemove()
        if ITEMBANKINV and ITEMBANKINV:IsValid() then
            ITEMBANKINV:Remove()
        end
        OOR(self)
    end
    
    surface.SetFont("Trebuchet19")
    local textw,texth = surface.GetTextSize("These are the items in your bank.")
    
    local caption = vgui.Create("DPanel", frame)
    caption:SetSize(textw+10,texth+10)
    caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 10)
    
    function caption:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
        draw.DrawText("These are the items in your bank.", "Trebuchet19", 5, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
    end
    
    local inv = vgui.Create("DPanelList", frame)
    inv:SetSize(470, frame:GetTall()-select(2, caption:GetPos())-caption:GetTall()-50)
    inv:SetPos(0, select(2, caption:GetPos())+caption:GetTall()+10)
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
    
    ITEMBANKMENU.itemBank = inv
    
    PopulateItemBank(items, true)
    
    local weight = vgui.Create("DPanel", frame)
    weight:SetSize(frame:GetWide()-20, 20)
    weight:SetPos(10, frame:GetTall()-30)
    
    function weight:Paint(w,h)
        local cur = items["WeightData"] and items["WeightData"].Cur or 0
        local max = items["WeightData"] and items["WeightData"].Max or 100
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

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(470, 545)
    frame:SetOCRPTitle("Your Inventory")
    frame:Center()
    frame:SetPos(ScrW()/2+15, select(2, frame:GetPos()))
    frame:MakePopup()
    
    ITEMBANKINV = frame
    
    local OOR = frame.OnRemove
    
    function frame:OnRemove()
        if ITEMBANKMENU and ITEMBANKMENU:IsValid() then
            ITEMBANKMENU:Remove()
        end
        OOR(self)
    end
    
    surface.SetFont("Trebuchet19")
    local textw,texth = surface.GetTextSize("These are the items in your inventory.")
    
    local caption = vgui.Create("DPanel", frame)
    caption:SetSize(textw+10,texth+10)
    caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 10)
    
    function caption:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
        draw.DrawText("These are the items in your inventory.", "Trebuchet19", 5, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
    end
    
    local inv = vgui.Create("DPanelList", frame)
    inv:SetSize(470, frame:GetTall()-select(2, caption:GetPos())-caption:GetTall()-50)
    inv:SetPos(0, select(2, caption:GetPos())+caption:GetTall()+10)
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
    
    ITEMBANKINV.inv = inv
    
    PopulateItemBank(OCRP_Inventory, false)
    
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

end

function PopulateItemBank(items, bank)

    if bank then
        ITEMBANKMENU.itemBank:Clear()
    else
        ITEMBANKINV.inv:Clear()
    end
    
    for item,amt in pairs(items) do
        if not amt or amt == 0 then continue end
        if item == "WeightData" then continue end
        local itemPanel = vgui.Create("DPanel")
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
        
        FocusModelPanel(itemMdlPanel)
        
        local withdraw = vgui.Create("OCRP_BaseButton", itemPanel)
        withdraw:SetSize(90, 15)
        withdraw:SetPos(5, 115)
        if bank then
            withdraw:SetText("Withdraw")
            
            function withdraw:DoClick()
                net.Start("OCRP_WithdrawItemBank")
                net.WriteString(item)
                net.SendToServer()
            end
        else
            withdraw:SetText("Deposit")
            
            function withdraw:DoClick()
                net.Start("OCRP_DepositItemBank")
                net.WriteString(item)
                net.SendToServer()
            end
        end
        if bank then
            ITEMBANKMENU.itemBank:AddItem(itemPanel)
        else
            ITEMBANKINV.inv:AddItem(itemPanel)
        end
    end
    if bank then
        while table.Count(ITEMBANKMENU.itemBank:GetItems()) < 12 do
            local filler = vgui.Create("DPanel")
            filler:SetSize(100, 140)
            filler.Paint = function() draw.RoundedBox(8, 0, 0, 100, 140, Color(0,0,0,255)) end
            ITEMBANKMENU.itemBank:AddItem(filler)
        end
    else
        while table.Count(ITEMBANKINV.inv:GetItems()) < 12 do
            local filler = vgui.Create("DPanel")
            filler:SetSize(100, 140)
            filler.Paint = function() draw.RoundedBox(8, 0, 0, 100, 140, Color(0,0,0,255)) end
            ITEMBANKINV.inv:AddItem(filler)
        end
    end
    
end

net.Receive("OCRP_UpdateItemBankItem", function()
    local item = net.ReadString()
    local amt = net.ReadInt(32)
    local weight = net.ReadTable()
    OCRP_ItemBank[item] = amt
    OCRP_ItemBank["WeightData"] = weight
    if ITEMBANKMENU and ITEMBANKMENU:IsValid() then
        PopulateItemBank(OCRP_ItemBank, true)
    end
    if ITEMBANKINV and ITEMBANKINV:IsValid() then
        PopulateItemBank(OCRP_Inventory, false)
    end
end)