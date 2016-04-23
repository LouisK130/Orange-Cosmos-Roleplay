OCRP_CRAFTINGMENU = nil

function OpenCraftingMenu()

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(585, 400)
    frame:Center()
    frame:SetOCRPTitle("Crafting")
    frame:MakePopup()
    
    OCRP_CRAFTINGMENU = frame
    
    local itemList = vgui.Create("DPanelList", frame)
    itemList:EnableVerticalScrollbar(true)
    itemList:SetSpacing(10)
    itemList:SetNoSizing(true)
    itemList:EnableHorizontal(true)
    itemList:SetPadding(10)
    itemList.VBar:SetEnabled(true)
    
    frame.itemList = itemList
    
    -- Draw outline outside actual itemList so items don't cover it
    local op = frame.Paint
    
    function frame:Paint(w,h)
        op(self, w, h)
        draw.RoundedBox(8, itemList:GetPos()-1, select(2, itemList:GetPos())-1, itemList:GetWide()+2, itemList:GetTall()+2, Color(39,168,216,255))
    end
    
    local opl = itemList.PerformLayout
    
    function itemList:PerformLayout(w, h)
        opl(self, w, h)
        self.VBar:SetTall(self:GetTall()-10)
        self.VBar:SetPos(self:GetWide()-17, 5)
    end
    
    function itemList:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(25,25,25,255))
        --draw.RoundedBox(8, 1, 1, w-2, h-2, Color(25,25,25,255))
    end
    
    local title = vgui.Create("DPanel", frame)
    frame.categoryName = categoryName or "Weapons and Ammo"
    frame.category = category or "Wep"
    
    function title:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(25,25,25,255))
        draw.DrawText("These are the craftable items in the " .. frame.categoryName .. " category.", "Trebuchet19", 5, 5, Color(255,255,255,255))
    end
    
    function frame:LayoutInfo(item)
    
        if frame.info and frame.info:IsValid() then frame.info:Remove() end
    
        local info = vgui.Create("OCRP_BaseMenu")
        info:SetSize(200, 400)
        info:SetPos(frame:GetPos()+frame:GetWide()+20, select(2, frame:GetPos()))
        info:AllowCloseButton(false)
        info:MakePopup()
        
        self.info = info
    
        local itemNameText = GAMEMODE.OCRP_Items[item.Item].Name
        if item.Amount then
            itemNameText = itemNameText .. " x" .. item.Amount
        end
        
        surface.SetFont("Trebuchet19")
        local namew,nameh = surface.GetTextSize(itemNameText)
        
        local itemName = vgui.Create("DPanel", info)
        itemName:SetSize(namew, nameh+5)
        itemName:SetPos(info:GetWide()/2-itemName:GetWide()/2, 10)
        
        function itemName:Paint(w,h)
            draw.DrawText(itemNameText, "Trebuchet19", 0, 0, Color(39,168,216,255))
            draw.RoundedBox(0, 0, nameh+2, w, 1, Color(39,168,216,255))
        end
        
        surface.SetFont("UiBold")
        local skillsw,skillsh = surface.GetTextSize("Skills Required")
        local skillsTotalHeight = skillsh+15
        local widestSkill = skillsw
        local skillsInfo = {}
        
        for k,v in pairs(item.Skills) do
            if v <= 0 then continue end
            skillsTotalHeight = skillsTotalHeight + draw.GetFontHeight("UiBold") + 10
            local text = "- " .. GAMEMODE.OCRP_Skills[k].Name .. " " .. tostring(v)
            local newwide = surface.GetTextSize(text)
            if newwide > widestSkill then
                widestSkill = newwide
            end
            skillsInfo[text] = {}
            skillsInfo[text]["color"] = CL_HasSkill(k,v) and Color(255,255,255,255) or Color(255,0,0,255)
            skillsInfo[text]["wide"] = newwide
        end
        
        local skills = vgui.Create("DPanel", info)
        skills:SetSize(widestSkill+10,skillsTotalHeight)
        skills:SetPos(info:GetWide()/2-skills:GetWide()/2, 50)      
        
        function skills:Paint(w,h)
            draw.RoundedBox(8, 0, 0, w, h, Color(35,35,35,255))
            draw.DrawText("Skills Required", "UiBold", w/2-skillsw/2, 5, Color(255,255,255,255))
            draw.RoundedBox(0, w/2-skillsw/2, skillsh+7, skillsw, 1, Color(255,255,255,255))
            local y = skillsh+17
            for k1,v1 in pairs(skillsInfo) do
                draw.DrawText(k1, "UiBold", w/2-v1["wide"]/2, y, v1["color"])
                y = y + draw.GetFontHeight("UiBold") + 10
            end
        end
        
        surface.SetFont("UiBold")
        local itemsw,itemsh = surface.GetTextSize("Items Required")
        local itemsTotalHeight = itemsh+15
        local widestItem = itemsw
        local itemsInfo = {}
        
        for k,v in pairs(item.Requirements) do
        
            if v.Amount <= 0 then continue end
            
            itemsTotalHeight = itemsTotalHeight + draw.GetFontHeight("UiBold") + 10
            local text = "- " .. GAMEMODE.OCRP_Items[v.Item].Name .. " x" .. v.Amount
            local newwide = surface.GetTextSize(text)
            
            if newwide > widestItem then
                widestItem = newwide
            end
            
            itemsInfo[text] = {}
            itemsInfo[text]["color"] = CL_HasItem(v.Item, v.Amount) and Color(255,255,255,255) or Color(255,0,0,255)
            itemsInfo[text]["wide"] = newwide
        
        end
        
        local items = vgui.Create("DPanel", info)
        items:SetSize(widestItem+10,itemsTotalHeight)
        items:SetPos(info:GetWide()/2-items:GetWide()/2, select(2, skills:GetPos())+skillsTotalHeight+20)
        
        function items:Paint(w,h)
            draw.RoundedBox(8, 0, 0, w, h, Color(35,35,35,255))
            draw.DrawText("Items Required", "UiBold", w/2-itemsw/2, 5, Color(255,255,255,255))
            draw.RoundedBox(0, w/2-itemsw/2, itemsh+7, itemsw, 1, Color(255,255,255,255))
            local y = itemsh+17
            for k,v in pairs(itemsInfo) do
                draw.DrawText(k, "UiBold", w/2-v["wide"]/2, y, v["color"])
                y = y + draw.GetFontHeight("UiBold") + 10
            end
        end
        
        local endY = select(2, items:GetPos()) + items:GetTall() + 10
        
        if item.HeatSource then
        
            local needFurnace = vgui.Create("DLabel", info)
            needFurnace:SetText("Furnace Required")
            needFurnace:SetTextColor(Color(255,0,0,255))
            needFurnace:SetFont("UiBold")
            
            local tr = LocalPlayer():GetEyeTrace()
            if tr.Entity and tr.Entity:GetClass() == "item_base" and tr.Entity:GetNWString("Class") == "item_furnace" then
                if tr.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 100 then
                    needFurnace:SetTextColor(Color(255,255,255,255))
                end
            end
            
            needFurnace:SizeToContents()
            needFurnace:SetPos(info:GetWide()/2-needFurnace:GetWide()/2, endY)
            endY = endY + needFurnace:GetTall() + 10
            
        end
        
        local oldP = info.Paint
        
        function info:Paint(w,h)
            oldP(self, w, h)
            local x,y = skills:GetPos()
            draw.RoundedBox(8, x-1, y-1, skills:GetWide()+2, skills:GetTall()+2, Color(39,168,216,255))
            local x,y = items:GetPos()
            draw.RoundedBox(8, x-1, y-1, items:GetWide()+2, items:GetTall()+2, Color(39,168,216,255))
        end
        
        info:SetSize(200, endY)
        
    end
    
    local side = vgui.Create("DPanel")
    
    function frame:Layout(scroll)
    
        surface.SetFont("Trebuchet19")
        local textw,texth = surface.GetTextSize("These are the craftable items in the " .. frame.categoryName .. " category.")
        title:SetSize(textw+10,texth+10)
        title:SetPos(frame:GetWide()/2-title:GetWide()/2, 10)
        
        itemList:SetSize(575, self:GetTall()-10-texth-20)
        itemList:SetPos(5, 5+texth+10+10)
        
        itemList:Clear()

        for _,craftTable in pairs(GAMEMODE.OCRP_Recipies) do -- Really.. The shitty english makes fixing this gamemode hard
        
            if craftTable.Cata == frame.category then
            
                local item = vgui.Create("DPanel")
                item:SetSize(100, 140)
                
                local name = GAMEMODE.OCRP_Items[craftTable.Item].Name
                local amount = craftTable.Amount
                
                function item:Paint(w,h)
                    draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0,255))
                    draw.DrawText(name, "UiBold", w/2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
                    if amount then
                        draw.DrawText("x" .. amount, "UiBold", w/2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER)
                    end
                end
                
                function item:OnCursorEntered()
                    frame:LayoutInfo(craftTable)
                end
                
                function item:OnCursorExited()
                    if frame.info and frame.info:IsValid() then frame.info:Remove() end
                end
                
                local itemMdlPanel = vgui.Create("DModelPanel", item)
                itemMdlPanel:SetSize(80, 80)
                itemMdlPanel:SetPos(5, 30)
                itemMdlPanel:SetModel(GAMEMODE.OCRP_Items[craftTable.Item].Model)
                itemMdlPanel:SetCursor("arrow")
                
                local itemTable = GAMEMODE.OCRP_Items[craftTable.Item]
        
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
                
                itemMdlPanel.OnCursorEntered = item.OnCursorEntered
                itemMdlPanel.OnCursorExited = item.OnCursorExited
                
                -- Can craft?
                local hasSkills = true
                
                for skill,level in pairs(craftTable.Skills) do
                    if level > 0 then
                        if not CL_HasSkill(skill, level) then
                            hasSkills = false
                        end
                    end
                end
                
                local hasItems = true
                
                for _,req in pairs(craftTable.Requirements) do
                    if req.Amount > 0 then
                        if not CL_HasItem(req.Item, req.Amount) then
                            hasItems = false
                        end
                    end
                end
                
                local lookingAtFurnace = false
                
                local tr = LocalPlayer():GetEyeTrace()
                if tr.Entity and tr.Entity:GetClass() == "item_base" and tr.Entity:GetNWString("Class") == "item_furnace" then
                    if tr.Entity:GetPos():Distance(LocalPlayer():GetPos()) < 100 then
                        lookingAtFurnace = true
                    end
                end
                
                if not craftTable.HeatSource then lookingAtFurnace = true end
                
                if hasSkills and hasItems and lookingAtFurnace then
                    
                    local craft = vgui.Create("OCRP_BaseButton", item)
                    craft:SetSize(90, 15)
                    craft:SetPos(5, 115)
                    craft:SetText("Craft")
                    
                    function craft:DoClick()
                        if not CL_HasRoom(craftTable.Item, craftTable.Amount or 1) then
                            OCRP_AddHint("Cannot craft because it would exceed your max weight or max amount for this item.")
                            return
                        end
                        frame:SetMouseInputEnabled(false)
                        side:SetMouseInputEnabled(false)
                        StartCrafting(_, craftTable.Time or 2)
                        timer.Simple(craftTable.Time or 2, function()
                            frame:SetMouseInputEnabled(true)
                            side:SetMouseInputEnabled(true)
                        end)
                    end
                    
                else
                
                    local cantCraft = vgui.Create("DLabel", item)
                    cantCraft:SetFont("UiBold")
                    cantCraft:SetTextColor(Color(255,0,0,255))
                    cantCraft:SetText("Can't Craft")
                    cantCraft:SizeToContents()
                    cantCraft:SetPos(item:GetWide()/2-cantCraft:GetWide()/2, 115)
                    
                end
                
                itemList:AddItem(item)
            
            end
        
        end
        
        -- Fill it with blanks to ensure everything fits and there's a visible scrollbar
        -- This just makes it look better
        
        while #itemList:GetItems() < 11 do
            local filler = vgui.Create("DPanel")
            filler:SetSize(100, 140)
            filler.Paint = function() end
            itemList:AddItem(filler)
        end

        itemList.VBar:SetScroll(scroll or 0)
    end
    
    frame:Layout()
  
    side:SetSize(130, 230)
    side:SetPos(frame:GetPos()-side:GetWide(), select(2, frame:GetPos())+20)
    
    function side:Paint(w,h)
    
        draw.RoundedBoxEx(8, 0, 0, w, h, Color(0,0,0,255), true, false, true, false)
        -- Around weps btn
        draw.RoundedBoxEx(8, 5, 5, w-5, 40, Color(20,20,20,255), true, false, true, false)
        -- Around tables btn
        draw.RoundedBoxEx(8, 5, 5+40+5, w-5, 40, Color(20,20,20,255), true, false, true, false)
        -- Around barriers
        draw.RoundedBoxEx(8, 5, 5+40+5+40+5, w-5, 40, Color(20,20,20,255), true, false, true, false)
        -- Around misc
        draw.RoundedBoxEx(8, 5, 5+40+5+40+5+40+5, w-5, 40, Color(20,20,20,255), true, false, true, false)
        -- Around utils
        draw.RoundedBoxEx(8, 5, 5+40+5+40+5+40+5+40+5, w-5, 40, Color(20,20,20,255), true, false, true, false)
        
    end
    
    local weps = vgui.Create("OCRP_BaseButton", side)
    weps:SetSize(115, 30)
    weps:SetPos(10, 10)
    weps:SetText("Weapons and Ammo")
    
    function weps:DoClick()
        frame.categoryName = "Weapons and Ammo"
        frame.category = "Wep"
        frame:Layout()
    end
    
    local tables = vgui.Create("OCRP_BaseButton", side)
    tables:SetSize(115, 30)
    tables:SetPos(10, 10+40+5)
    tables:SetText("Tables")
    
    function tables:DoClick()
        frame.categoryName = "Tables"
        frame.category = "Tables"
        frame:Layout()
    end
    
    local barriers = vgui.Create("OCRP_BaseButton", side)
    barriers:SetSize(115, 30)
    barriers:SetPos(10, 10+40+5+40+5)
    barriers:SetText("Barriers")
    
    function barriers:DoClick()
        frame.categoryName = "Barriers"
        frame.category = "Barriers"
        frame:Layout()
    end
    
    local misc = vgui.Create("OCRP_BaseButton", side)
    misc:SetSize(115, 30)
    misc:SetPos(10, 10+40+5+40+5+40+5)
    misc:SetText("Misc. Props")
    
    function misc:DoClick()
        frame.categoryName = "Miscellaneous Props"
        frame.category = "Misc"
        frame:Layout()
    end
    
    local utils = vgui.Create("OCRP_BaseButton", side)
    utils:SetSize(115, 30)
    utils:SetPos(10, 10+40+5+40+5+40+5+40+5)
    utils:SetText("Utilities")
    
    function utils:DoClick()
        frame.categoryName = "Utilities"
        frame.category = "Utilities"
        frame:Layout()
    end
    
    local oldOR = frame.OnRemove
    
    function frame:OnRemove()
        oldOR(self)
        if side and side:IsValid() then side:Remove() end
        if self.info and self.info:IsValid() then self.info:Remove() end
    end

end

net.Receive("OCRP_CraftingMenu", function(len)
	OpenCraftingMenu()
    --GUI_Crafting_Menu()
end)

function StartCrafting(recipe, time)
    
    local endtime = CurTime() + time

    local progress = vgui.Create("DProgress")
    progress:SetSize(200, 40)
    progress:Center()
    progress:MakePopup()
    
    function progress:Think()
        local val = math.Clamp(1-(endtime-CurTime())/time, 0, 1)
        self:SetFraction(val)
        if val == 1 then
            net.Start("CraftItem")
                net.WriteInt(recipe, 32)
            net.SendToServer()
            self:Remove()
        end
    end
    
end