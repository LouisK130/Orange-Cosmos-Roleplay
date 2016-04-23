function CL_UpdateOwnerShip( umsg )
	local OwnerId = umsg:ReadLong()
	local Name = umsg:ReadString()
	for _,data in pairs(GAMEMODE.Properties[string.lower(game.GetMap())]) do
		if data.Name == Name then
			GAMEMODE.Properties[string.lower(game.GetMap())][_].OwnerId = OwnerId
		end
	end
end
usermessage.Hook('OCRP_UpdateOwnerShip', CL_UpdateOwnerShip);

UnOwnableDoors = {}
OwnableDoors = {}
OwnedProperties = {}

net.Receive("OCRP_Update_Unownable_Doors", function()
    local doors = net.ReadTable()
    UnOwnableDoors = doors
end)

net.Receive("OCRP_Update_Ownable_Doors", function()
    local doors = net.ReadTable()
    OwnableDoors = doors
end)

net.Receive("OCRP_Update_Owned_Properties", function()
    local properties = net.ReadTable()
    OwnedProperties = properties
end)

OCRP_ShopItems = {}

net.Receive("OCRP_OpenRelatorMenu", function()
	GUI_RealtorMenu1()
end)

function GUI_RealtorMenu1()

    if LocalPlayer():GetNWBool("Handcuffed") then return end
    
    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(700, 525)
    frame:Center()
    frame:SetOCRPTitle("Realtor")
    frame:MakePopup()
    
    local info = vgui.Create("DPanel", frame)
    local type = "apartment"
    
    function info:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(25,25,25,255))
        draw.DrawText("These are the " .. type .. " properties currently for sale.", "Trebuchet19", 5, 5, Color(255,255,255,255))
    end
    
    local propList = vgui.Create("DPanelList", frame)
    propList:EnableVerticalScrollbar(true)
    propList:SetSpacing(10)
    propList:SetNoSizing(true)
    
    local olabel = vgui.Create("DLabel", frame)
    olabel:SetFont("UiBold")
    olabel:SetText("Outside")
    olabel:SizeToContents()
    
    local ilabel = vgui.Create("DLabel", frame)
    ilabel:SetFont("UiBold")
    ilabel:SetText("Inside")
    ilabel:SizeToContents()
    
    function frame:Layout()
        surface.SetFont("Trebuchet19")
        local textw,texth = surface.GetTextSize("These are the " .. type .. " properties currently for sale.")
        info:SetSize(textw+10, texth+10)
        info:SetPos(self:GetWide()/2-info:GetWide()/2, 10)
        
        propList:SetSize(680, self:GetTall()-10-texth-15)
        propList:SetPos(self:GetWide()/2-propList:GetWide()/2, 5+texth+10+10)
        olabel:SetPos(propList:GetPos()+5+(192/2)-olabel:GetWide()/2, select(2, propList:GetPos())-15)
        ilabel:SetPos(propList:GetPos()+propList:GetWide()-5-(192/2)-ilabel:GetWide()/2, select(2, olabel:GetPos()))
        
        propList:Clear()
        for k,v in pairs(GAMEMODE.Properties[string.lower(game.GetMap())]) do
            if v.type == type then
                if OwnedProperties[k] and OwnedProperties[k] != LocalPlayer():SteamID() then continue end
                local propItem = vgui.Create("DPanel")
                propItem:SetSize(660, 118)
                
                surface.SetFont("TargetIDSmall")
                local namew,nameh = surface.GetTextSize(v.Name)
                
                function propItem:Paint(w,h)
                    draw.RoundedBox(8, 0, 0, w, h, Color(39,168,216,255))
                    draw.RoundedBox(8, 1, 1, w-2, h-2, Color(25,25,25,255))
                    draw.DrawText(v.Name, "TargetIDSmall", w/2, 10, Color(39,168,216,255), TEXT_ALIGN_CENTER)
                    draw.RoundedBox(0, w/2-namew/2, 10+nameh+2, namew, 1, Color(39,168,216,255))
                    draw.DrawText(v.Desc, "UiBold", w/2, 35, Color(255,255,255,255), TEXT_ALIGN_CENTER)
                end
                
                local outside = vgui.Create("DImage", propItem)
                outside:SetSize(192, 108)
                outside:SetPos(5, 5)
                outside:SetImage("property-icons/outside/" .. v.Icon1 .. ".jpg")
                
                local inside = vgui.Create("DImage", propItem)
                inside:SetSize(192, 108)
                inside:SetPos(propItem:GetWide()-inside:GetWide()-5, 5)
                inside:SetImage("property-icons/inside/" .. v.Icon2 .. ".jpg")
                
                local rent = vgui.Create("OCRP_BaseButton", propItem)
                rent:SetSize(200, 30)
                rent:SetPos(propItem:GetWide()/2-rent:GetWide()/2, propItem:GetTall()-rent:GetTall()-15)
                
                if OwnedProperties[k] and OwnedProperties[k] == LocalPlayer():SteamID() then
                    rent:SetText("Sell for $" .. math.Round(v.Price/4))
                    rent:SetColor(Color(255,0,0,255))
                    function rent:DoClick()
                        net.Start("OCRP_Sell_Property")
                        net.WriteInt(k, 32)
                        net.SendToServer()
                        frame:Remove()
                    end
                else
                    rent:SetText("Rent for $" .. v.Price)
                    function rent:DoClick()
                        if LocalPlayer().Bank < v.Price then
                            OCRP_AddHint("You do not have enough in your bank to rent this property!")
                            return
                        end
                        net.Start("OCRP_Buy_Property")
                        net.WriteInt(k, 32)
                        net.SendToServer()
                        frame:Remove()
                    end
                end
                propList:AddItem(propItem)
            end
        end
        propList.VBar:SetScroll(0)
    end
    
    frame:Layout()
    
    local filterBackground = vgui.Create("DPanel")
    filterBackground:SetSize(115, 185)
    filterBackground:SetPos(frame:GetPos()-filterBackground:GetWide(), select(2, frame:GetPos())+20)
    
    function filterBackground:Paint(w,h)
    
        draw.RoundedBoxEx(8, 0, 0, w, h, Color(0,0,0,255), true, false, true, false)
        -- Around apts btn
        draw.RoundedBoxEx(8, 5, 5, 110, 40, Color(20,20,20,255), true, false, true, false)
        
        -- Around businesses button
        draw.RoundedBoxEx(8, 5, 50, 110, 40, Color(20,20,20,255), true, false, true, false)
        
        -- Around houses button
        draw.RoundedBoxEx(8, 5, 95, 110, 40, Color(20,20,20,255), true, false, true, false)
        
        -- Around the indstrial button
        draw.RoundedBoxEx(8, 5, 140, 110, 40, Color(20,20,20,255), true, false, true, false)
    end
    
    local apts = vgui.Create("OCRP_BaseButton", filterBackground)
    apts:SetSize(100, 30)
    apts:SetText("Apartments")
    apts:SetPos(10, 10)
    
    function apts:DoClick()
        type = "apartment"
        frame:Layout()
    end
    
    local bsns = vgui.Create("OCRP_BaseButton", filterBackground)
    bsns:SetSize(100, 30)
    bsns:SetText("Businesses")
    bsns:SetPos(10, 55)
    
    function bsns:DoClick()
        type = "business"
        frame:Layout()
    end
    
    local houses = vgui.Create("OCRP_BaseButton", filterBackground)
    houses:SetSize(100, 30)
    houses:SetText("Houses")
    houses:SetPos(10, 100)
    
    function houses:DoClick()
        type = "house"
        frame:Layout()
    end
    
    local indstrl = vgui.Create("OCRP_BaseButton", filterBackground)
    indstrl:SetSize(100, 30)
    indstrl:SetText("Industrials")
    indstrl:SetPos(10, 145)
    
    function indstrl:DoClick()
        type = "industrial"
        frame:Layout()
    end
    
    local oldOR = frame.OnRemove
    
    function frame:OnRemove()
        filterBackground:Remove()
        oldOR(self)
    end

end

function ChangePermissionsMenu(door)

	local frame = vgui.Create("OCRP_BaseMenu")
	frame:SetSize(250, 200)
	frame:SetOCRPTitle("Permissions")
	frame:Center()
	frame:MakePopup()
	
	surface.SetFont("UiBold")
	local textw,texth = surface.GetTextSize("Who can lock and unlock this door?")
	
	local info = vgui.Create("DPanel", frame)
	info:SetSize(textw+10,texth+10)
	info:SetPos(frame:GetWide()/2-info:GetWide()/2, 10)
	
	function info:Paint(w,h)
		draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
		draw.DrawText("Who can lock and unlock this door?", "UiBold", w/2, h/2-texth/2, Color(255,255,255,255), TEXT_ALIGN_CENTER)
	end
	
	local gov = vgui.Create("DCheckBoxLabel", frame)
	gov:SetText("Government Officials")
	gov:SizeToContents()
	gov:SetPos(frame:GetWide()/2-gov:GetWide()/2, 110)
	
	local buddies = vgui.Create("DCheckBoxLabel", frame)
	buddies:SetText("Buddies")
	buddies:SizeToContents()
	buddies:SetPos(gov:GetPos(), 50)
	
	local org = vgui.Create("DCheckBoxLabel", frame)
	org:SetText("Org Members")
	org:SizeToContents()
	org:SetPos(gov:GetPos(), 80)
	
	if door.Permissions == nil then
		gov:SetValue(0)
		buddies:SetValue(1)
		org:SetValue(1)
	else
		gov:SetValue(door.Permissions["Government"] and 1 or 0)
		buddies:SetValue(door.Permissions["Buddies"] and 1 or 0)
		org:SetValue(door.Permissions["Org"] and 1 or 0)
	end
	
	local confirm = vgui.Create("OCRP_BaseButton", frame)
	confirm:SetSize(150, 30)
	confirm:SetPos(50, 150)
	confirm:SetText("Confirm Permissions")
	
	function confirm:DoClick()
		door.Permissions = {}
		door.Permissions["Buddies"] = buddies:GetChecked()
		door.Permissions["Org"] = org:GetChecked()
		door.Permissions["Goverment"] = gov:GetChecked()

		net.Start("OCRP_Set_Permissions")
		net.WriteString(tostring(door.Permissions["Org"]))
		net.WriteString(tostring(door.Permissions["Buddies"]))
		net.WriteString(tostring(door.Permissions["Government"]))
		net.SendToServer()
		frame:Remove()
	end
	
end

function CL_PriceItem( umsg )
	local pricingnow = umsg:ReadBool()
	local ent = umsg:ReadEntity()
	local price = umsg:ReadLong()
	local desc = umsg:ReadString()
	local amount = umsg:ReadLong()
	if !ent:IsValid() then return end
	if pricingnow then
		ShowPriceItemMenu(ent)
	else 
		table.insert(OCRP_ShopItems,ent)
		ent.cl_price = price
		ent.cl_desc = desc
		ent.cl_amount = amount 
	end
end
usermessage.Hook('CL_PriceItem', CL_PriceItem);

function ShowPriceItemMenu(obj)

	local frame = vgui.Create("OCRP_BaseMenu")
	frame:SetSize(300, 200)
	frame:Center()
	frame:SetOCRPTitle("Set Item Price")
	frame:MakePopup()
	
	surface.SetFont("UiBold")
	local textw,texth = surface.GetTextSize("Set the price for others to buy this item.\nA blank price means not for sale.")
	
	local info = vgui.Create("DPanel", frame)
	info:SetSize(textw+10,texth+10)
	info:SetPos(frame:GetWide()/2-info:GetWide()/2, 10)
	
	function info:Paint(w,h)
		draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
		draw.DrawText("Set the price for others to buy this item.\nA blank price means not for sale.", "UiBold", w/2, h/2-texth/2, Color(255,255,255,255), TEXT_ALIGN_CENTER)
	end
	
	local label1 = vgui.Create("DLabel", frame)
	label1:SetFont("UiBold")
	label1:SetText("Description")
	label1:SetTextColor(Color(39,168,216,255))
	label1:SizeToContents()
	label1:SetPos(10, select(2, info:GetPos())+info:GetTall()+25)
	
	local desc = vgui.Create("DTextEntry", frame)
	desc:SetSize(frame:GetWide()-85, 30)
	desc:SetPos(10+label1:GetWide()+10, select(2, label1:GetPos())+label1:GetTall()/2-desc:GetTall()/2)
	
	function desc:Paint(w,h)
		draw.RoundedBox(8,0,0,w,h,Color(0,0,0,255))
		self:DrawTextEntryText(Color(255,255,255,255), Color(100,100,100,255), Color(255,255,255,255))
	end
	
	function desc:OnChange()
		local val = desc:GetText()
		if val:len() >= 40 then
			desc:SetText(string.sub(desc:GetText(), 1, val:len()-1))
			desc:SetCaretPos(val:len()-1)
		end
	end
	
	local label2 = vgui.Create("DLabel", frame)
	label2:SetFont("UiBold")
	label2:SetText("Price")
	label2:SetTextColor(Color(39,168,216,255))
	label2:SizeToContents()
	label2:SetPos(frame:GetWide()/2-(100+label2:GetWide()+10)/2, select(2, desc:GetPos())+desc:GetTall()+25)
	
	local price = vgui.Create("DTextEntry", frame)
	price:SetSize(100, 30)
	price:SetPos(label2:GetPos()+label2:GetWide()+10, select(2, label2:GetPos())+label1:GetTall()/2-price:GetTall()/2)
	price:SetNumeric(true)
	
	price.Paint = desc.Paint
	
	function price:OnChange()
		local val = price:GetText()
		if val:len() >= 10 then
			price:SetText(string.sub(price:GetText(), 1, val:len()-1))
			price:SetCaretPos(val:len()-1)
		end
	end
	
	local confirm = vgui.Create("OCRP_BaseButton", frame)
	confirm:SetSize(200, 30)
	confirm:SetPos(50, select(2, price:GetPos())+price:GetTall()+15)
	confirm:SetText("Confirm Pricing")
	
	function confirm:DoClick()
        local pr = tonumber(price:GetText())
        if not pr or pr < 0 then pr = -1 end
        net.Start("PriceItem")
            net.WriteInt(obj:EntIndex(), 32)
            net.WriteInt(pr, 32)
            net.WriteString(desc:GetText())
        net.SendToServer()
        frame:Remove()
	end
	
end