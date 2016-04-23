local Offer = {Money = 0,Items = {}}

local shopid = 1
local invContainer = nil
local shopContainer = nil

OCRP_SHOPMENU = nil

function GUI_ShopMenu(shopi)

	if LocalPlayer():GetNWBool("Handcuffed") then return end
	if GUI_Shop_Frame != nil then
		GUI_Shop_Frame:Remove()
	end
	shopid = tonumber(shopi)
	
	if GAMEMODE.OCRP_Shops[shopid].Restricted != nil then
		for _,team in pairs(GAMEMODE.OCRP_Shops[shopid].Restricted) do
			if LocalPlayer():Team() == team then 
				return 
			end
		end
	end
	
    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(733, 333)
    frame:SetOCRPTitle(GAMEMODE.OCRP_Shops[shopid].Name .. ": " .. GAMEMODE.OCRP_Shops[shopid].Description)
    frame:Center()
    frame:MakePopup()
    frame.shopid = shopid
    
    OCRP_SHOPMENU = frame
    
    local p = frame.Paint
    
    local inv = vgui.Create("DPanelList", frame)
    inv:SetSize(348, 280)
    inv:SetPos(11, 40)
    inv:SetPadding(8)
    inv:SetSpacing(5)
    inv:SetNoSizing(true)
    inv:EnableVerticalScrollbar(true)
    inv:EnableHorizontal(true)
    inv.VBar:SetEnabled(true)
    
    frame.inv = inv
    
    local pl = inv.PerformLayout
    
    function inv:PerformLayout()
        pl(self)
        self.VBar:SetTall(self:GetTall()-10)
        self.VBar:SetPos(self:GetWide() - 20, 5)
    end
    
    function inv:LayoutInfo(itemTable)
    
        if frame.info and frame.info:IsValid() then frame.info:Remove() end
    
        local info = vgui.Create("OCRP_BaseMenu")
        info:SetSize(200, 400)
        info:SetPos(frame:GetPos()+frame:GetWide()+20, select(2, frame:GetPos()))
        info:AllowCloseButton(false)
        info:MakePopup()
        
        frame.info = info
        
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
        
        info:SetSize(200, select(2, weight:GetPos())+30)
    
    end
    
    function inv:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(25,25,25,255))
    end
    
    local invLabel = vgui.Create("DLabel", frame)
    invLabel:SetText("Your Inventory")
    invLabel:SetFont("UiBold")
    invLabel:SizeToContents()
    invLabel:SetPos(inv:GetPos() + inv:GetWide()/2-invLabel:GetWide()/2, 20)
    invLabel:SetTextColor(Color(255,255,255,255))
    
    local shop = vgui.Create("DPanelList", frame)
    shop:SetSize(348, 280)
    shop:SetPos(372, 40)
    shop:SetPadding(8)
    shop:SetSpacing(5)
    shop:SetNoSizing(true)
    shop:EnableVerticalScrollbar(true)
    shop:EnableHorizontal(true)
    local plS = shop.PerformLayout
    
    function shop:PerformLayout()
        plS(self)
        self.VBar:SetTall(self:GetTall()-10)
        self.VBar:SetPos(self:GetWide() - 20, 5)
    end
    
    function shop:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(25,25,25,255))
    end
    
    shop.LayoutInfo = inv.LayoutInfo
    
    function frame:Paint(w,h)
        -- Draw the outlines OUTSIDE the shop containers so they don't get covered when scrolling
        p(self, w, h)
        draw.RoundedBox(8, inv:GetPos()-1, select(2, inv:GetPos())-1, inv:GetWide()+2, inv:GetTall()+2, Color(39,168,216,255))
        draw.RoundedBox(8, shop:GetPos()-1, select(2, shop:GetPos())-1, shop:GetWide()+2, shop:GetTall()+2, Color(39,168,216,255))
    end
    
    local shopLabel = vgui.Create("DLabel", frame)
    shopLabel:SetText("Items for Sale")
    shopLabel:SetFont("UiBold")
    shopLabel:SizeToContents()
    shopLabel:SetPos(shop:GetPos() + shop:GetWide()/2-shopLabel:GetWide()/2, 20)
    shopLabel:SetTextColor(Color(255,255,255,255))
    
    invContainer = inv
    shopContainer = shop
    
    PopulateShopContainer(shop, shopid)
    PopulateInventoryContainer(inv, shopid)
    
    local OR = frame.OnRemove
    
    function frame:OnRemove()
        if frame.info and frame.info:IsValid() then frame.info:Remove() end
        OR(self)
    end
    
end

function PopulateInventoryContainer(inv, shopid, scroll)
    inv.VBar.Scroll = scroll or 0
    inv:Clear()
    OCRP_Inventory = OCRP_Inventory or {}
    
    local items = GAMEMODE.OCRP_Shops[shopid].Items or {}
    local buying = GAMEMODE.OCRP_Shops[shopid].Buying or {}
    
    for itemName,amount in pairs(OCRP_Inventory) do
        if itemName == "" or itemName == "WeightData" or itemName == "empty" then continue end
        if amount <= 0 then continue end
        if not table.HasValue(items, itemName) and not table.HasValue(buying, itemName )then continue end
        
        local itemPanel = vgui.Create("DPanel")
        itemPanel:SetSize(100, 140)
        
        function itemPanel:Paint(w,h)
            draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0,255))
        end
        
        function itemPanel:OnCursorEntered()
            inv:LayoutInfo(GAMEMODE.OCRP_Items[itemName])
        end
        
        function itemPanel:OnCursorExited()
            if inv:GetParent().info and inv:GetParent().info:IsValid() then inv:GetParent().info:Remove() end
        end
        
        local itemMdlPanel = vgui.Create("DModelPanel", itemPanel)
        itemMdlPanel:SetSize(80, 80)
        itemMdlPanel:SetPos(5, 30)
        itemMdlPanel:SetModel(GAMEMODE.OCRP_Items[itemName].Model)
        itemMdlPanel:SetCursor("arrow")
        
        itemMdlPanel.OnCursorEntered = itemPanel.OnCursorEntered
        itemMdlPanel.OnCursorExited = itemPanel.OnCursorExited
        
        local itemTable = GAMEMODE.OCRP_Items[itemName]
        
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
        
        local nameText = GAMEMODE.OCRP_Items[itemName].Name
        
        local name = vgui.Create("DLabel", itemPanel)
        name:SetText(nameText)
        name:SetFont("UiBold")
        name:SetTextColor(Color(255,255,255,255))
        name:SizeToContents()
        name:SetPos(itemPanel:GetWide()/2-name:GetWide()/2, 5)
        
        if amount > 1 then
            local amt = vgui.Create("DLabel", itemPanel)
            amt:SetText("x" .. amount)
            amt:SetFont("UiBold")
            amt:SetTextColor(Color(255,255,255,255))
            amt:SizeToContents()
            amt:SetPos(name:GetPos()+name:GetWide()/2-amt:GetWide()/2, 18)
        end
        
        if table.HasValue(buying, itemName) then
            local sell = vgui.Create("OCRP_BaseButton", itemPanel)
            sell:SetSize(90, 15)
            sell:SetPos(5, 115)
            sell:SetText("Sell")
            
            local price = GAMEMODE.OCRP_Items[itemName].Price * GAMEMODE.OCRP_Shops[shopid].PriceScale.Buying
            
            function sell:DoClick()
                ShopAmountPopup(itemName, "Selling", price)
            end
        else
            local notforsale = vgui.Create("DLabel", itemPanel)
            notforsale:SetFont("UiBold")
            notforsale:SetTextColor(Color(255,0,0,255))
            notforsale:SetText("Not Sellable")
            notforsale:SizeToContents()
            notforsale:SetPos(itemPanel:GetWide()/2-notforsale:GetWide()/2, 115)
        end
        
        inv:AddItem(itemPanel)
        
    end
        
    while #inv:GetItems() < 4 do
        local filler = vgui.Create("DPanel")
        filler:SetSize(100, 140)
        filler.Paint = function() end
        inv:AddItem(filler)
    end
    
end
        
function PopulateShopContainer(shop, shopid)

    shop:Clear()
    
    local items = GAMEMODE.OCRP_Shops[shopid].Items
    
    for _,itemName in pairs(items) do
    
        if not itemName then continue end
        local item = GAMEMODE.OCRP_Items[itemName]
        if not item then continue end
        
        local itemPanel = vgui.Create("DPanel")
        itemPanel:SetSize(100,140)
        
        function itemPanel:Paint(w,h)
            draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0,255))
            --draw.RoundedBox(8, 1, 1, w-2, h-2, Color(0,0,0,255))
        end
        
        function itemPanel:OnCursorEntered()
            shop:LayoutInfo(GAMEMODE.OCRP_Items[itemName])
        end
        
        function itemPanel:OnCursorExited()
            if shop:GetParent().info and shop:GetParent().info:IsValid() then shop:GetParent().info:Remove() end
        end
        
        local itemMdlPanel = vgui.Create("DModelPanel", itemPanel)
        itemMdlPanel:SetSize(80, 80)
        itemMdlPanel:SetPos(5, 30)
        itemMdlPanel:SetModel(GAMEMODE.OCRP_Items[itemName].Model)
        itemMdlPanel:SetCursor("arrow")
        
        itemMdlPanel.OnCursorEntered = itemPanel.OnCursorEntered
        itemMdlPanel.OnCursorExited = itemPanel.OnCursorExited
        
        local itemTable = GAMEMODE.OCRP_Items[itemName]
        
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
        
        local amt = item.Price * GAMEMODE.OCRP_Shops[shopid].PriceScale.Selling
        if not GAMEMODE.OCRP_Shops[shopid].NoTax then
            amt = amt * (1 + (GetGlobalInt("Eco_Tax")/100))
        end
        
        local buy = vgui.Create("OCRP_BaseButton", itemPanel)
        buy:SetSize(90, 15)
        buy:SetPos(5, 115)
        buy:SetText("Buy")
        
        function buy:DoClick()
            if LocalPlayer().Wallet < amt then
                OCRP_AddHint("You don't have enough in your wallet for this.")
                return
            end
            ShopAmountPopup(itemName, "Buying", amt)
        end
        
        local name = vgui.Create("DLabel", itemPanel)
        name:SetText(item.Name)
        name:SetFont("UiBold")
        name:SetTextColor(Color(255,255,255,255))
        name:SizeToContents()
        name:SetPos(itemPanel:GetWide()/2-name:GetWide()/2, 5)
        
        local price = vgui.Create("DLabel", itemPanel)
        price:SetText("$" .. amt)
        price:SetFont("UiBold")
        price:SetTextColor(LocalPlayer().Wallet >= amt and Color(39,168,216,255) or Color(255,0,0,255))
        price:SizeToContents()
        price:SetPos(itemPanel:GetWide()/2-price:GetWide()/2, 20)
        
        shop:AddItem(itemPanel)
    
    end
    
    while #shop:GetItems() < 4 do
        local filler = vgui.Create("DPanel")
        filler:SetSize(100, 140)
        filler.Paint = function() end
        shop:AddItem(filler)
    end
    
end

-- type = "Buying" or "Selling"
function ShopAmountPopup(item, type, price)

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(200, 100)
    frame:SetOCRPTitle(type .. ": " .. GAMEMODE.OCRP_Items[item].Name)
    frame:SetPos(ScrW()/2-frame:GetWide()/2, 200)
    frame:MakePopup()
    
    local cost = vgui.Create("DLabel", frame)
    cost:SetText("Price: $" .. price .. " each")
    cost:SetFont("UiBold")
    cost:SizeToContents()
    cost:SetTextColor(Color(255,255,255,255))
    cost:SetPos(frame:GetWide()/2-cost:GetWide()/2, 10)
    
    OCRP_Inventory = OCRP_Inventory or {}
    local total = (type == "Buying") and (math.floor(LocalPlayer().Wallet / price)) or (OCRP_Inventory[item] or 0)
    
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
    
    local buy = vgui.Create("OCRP_BaseButton", frame)
    buy:SetText(type == "Buying" and "Purchase" or "Sell")
    buy:SetSize(180, 20)
    buy:SetPos(10, 73)
    
    function buy:DoClick()
        local quantity = math.floor(total * slider:GetSlideX())
        if quantity > 0 then
            if type == "Buying" then
                net.Start("BuyItem")
                    net.WriteString(item)
                    net.WriteInt(shopid, 32)
                    net.WriteInt(quantity, 32)
                net.SendToServer()
            else
                net.Start("SellItem")
                    net.WriteString(item)
                    net.WriteInt(shopid, 32)
                    net.WriteInt(quantity, 32)
                net.SendToServer()
            end
        end
        frame:Remove()
    end
    
end