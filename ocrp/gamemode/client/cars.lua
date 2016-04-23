OCRP_VehicleGas = 0
OCRP_CurCar = "none"

function GetCurCar(umsg)
    local car = umsg:ReadString()
    if car == "none" then return end
    if not GAMEMODE.OCRP_Cars[car] then return end
    OCRP_CurCar = GAMEMODE.OCRP_Cars[car].Name
end
usermessage.Hook("OCRP_UpdateCurCar", GetCurCar)

net.Receive("OCRP_SendAllCars", function()
    OCRP_MyCars = {}
    local t = net.ReadTable()
    for k,v in pairs(t) do
        table.insert(OCRP_MyCars, {car = v})
    end
end)

function FixMaterial(mat)
	local params = {}
	params["$basetexture"] = mat:GetString("$basetexture")
	if string.find(mat:GetName(), "skin15") then
		params["$forcedcolor"] = "{100 0 100}"
		params["$rimlight"] = 1
		params["$rimlightboost"] = 3
		params["$phongsfix"] = "{254 113 0}"
	end
	return CreateMaterial(mat:GetName() .. "_Fixed", "UnlitGeneric", params)
end

color_table = {
    White = Color(255,255,255),
    Red = Color(255,0,0),
    Black = Color(0,0,0),
    Blue = Color(0,0,255),
    Green = Color(0,255,0),
    Orange = Color(255,152,44),
    Yellow = Color(220,220,0),
    Pink = Color(255,130,255),
    Grey = Color(110,110,110),
    Ice = Color(180,255,255),
    Shiny_Purple = FixMaterial(Material("models/tdmcars/shared/skin15.vmt")),
    Black_Carbon_Fiber = FixMaterial(Material("models/tdmcars/shared/skin3.vmt")),
    Metal = FixMaterial(Material("models/tdmcars/shared/skin9.vmt")),
    Camo = FixMaterial(Material("models/tdmcars/shared/skin10.vmt")),
    Blue_Camo = FixMaterial(Material("models/tdmcars/shared/skin12.vmt")),
    Wood = FixMaterial(Material("models/tdmcars/shared/skin14.vmt"))
}

function CarDealerMenu()

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(363, 500)
    frame:SetOCRPTitle("Car Dealership")
    frame:Center()
    frame:MakePopup()
    
    -- We define these here so they are accessible from the carItems
    -- But we don't set them up until later
    local previewFrame = vgui.Create("OCRP_BaseMenu")
    local previewDisplay = vgui.Create("DModelPanel", previewFrame)
    local previewColorArea = vgui.Create("DFrame", previewFrame)
    local carInfoArea = vgui.Create("OCRP_BaseMenu")

    local numcars = #OCRP_MyCars or 0
	local totalcars = table.Count(GAMEMODE.OCRP_Cars) or 0
    local left = totalcars - numcars
    
    surface.SetFont("TargetIDSmall")
    local wide,tall = surface.GetTextSize("There are " .. totalcars .. " cars total. \nYou have " .. left .. " more to purchase.")
    
    local topBox = vgui.Create("DFrame", frame)
    topBox:SetSize(wide+10, tall+10)
    topBox:SetPos(frame:GetWide()/2-(wide+10)/2, 10)
    topBox:ShowCloseButton(false)
    topBox:SetTitle("")

    function topBox:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(25,25,25,255))
        draw.DrawText("You have ".. numcars .." cars. \nYou have " .. left .. " more to purchase.", "TargetIDSmall", w/2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end
    
    local carList = vgui.Create("DPanelList", frame)
    carList:SetPos(5, tall+30)
    carList:SetSize(348, 430)
    carList:EnableVerticalScrollbar(true)
    carList:SetSpacing(10)
    carList:SetNoSizing(true)

    for k,v in pairs(GAMEMODE.OCRP_Cars) do
    
        local canAfford = LocalPlayer().Bank >= v.Price
        local owned = false
        for _,mycar in pairs(OCRP_MyCars) do
            if mycar.car == v.OtherName then
                owned = true
            end
        end
        
        local carItem = vgui.Create("DPanel")
        carItem:SetSize(320, 80)
        
        local textWide, textTall = surface.GetTextSize(v.Name)
        local canBuyTri = LocalPlayer():GetNWBool("CanBuyTricycle")
        
        function carItem:Paint(w,h)
            draw.RoundedBox(8,0,0,w,h,Color(39,168,216,255))
            draw.RoundedBox(8,1,1,w-2,h-2,Color( 25, 25, 25, 255 ))
            draw.RoundedBox(0,80,10,1,60,Color(39,168,216,255))
            draw.DrawText(v.Name, "TargetIDSmall", 80 + (w-80)/2, 10, Color(39,168,216,255), TEXT_ALIGN_CENTER)
            draw.RoundedBox(0, 80 + (w-80)/2 - textWide/2, 10 + textTall + 3, textWide, 1, Color(39,168,216,255))
            if owned then
                draw.DrawText("$" .. v.Price .. " -- Owned", "TargetIDSmall", 80 + (w-80)/2, 45, Color(100,100,100,255), TEXT_ALIGN_CENTER)
            elseif not canBuyTri and k == "PORSCHE_TRICYCLE" then
                draw.DrawText("Not Unlocked", "TargetIDSmall", 80 + (w-80)/2, 45, Color(255,0,0,255), TEXT_ALIGN_CENTER)
            else
                draw.DrawText("$" .. v.Price, "TargetIDSmall", 80 + (w-80)/2, 45, canAfford and Color(255,255,255,255) or Color(255,0,0,255), TEXT_ALIGN_CENTER)
            end
        end
        
        local carIcon = vgui.Create( "SpawnIcon", carItem )
        carIcon:SetSize( 70, 70 )
        carIcon:SetPos( 5, 5 )
        carIcon:SetModel( v.Model )
        carIcon.OnMousePressed = function()
            previewDisplay:SetModel(v.Model)
            previewDisplay.Entity:SetSkin(0)
            previewDisplay.Entity:SetColor(Color(255,255,255,255))
            previewDisplay.carTable = v
            previewColorArea:SetupSkins()
            carInfoArea:layout()
        end
        
        carItem.mdl = v.Model
        carItem.table = v
        carList:AddItem(carItem)
    end
    
    table.sort(carList.Items, function(a,b) return a.table.Price < b.table.Price end)
    
    previewDisplay.carTable = carList:GetItems()[1].table
    
        
    -- Preview area
    previewFrame:SetSize(500, 500)
    previewFrame:SetOCRPTitle("Car Preview")
    previewFrame:SetPos(frame:GetPos()-previewFrame:GetWide()-50, select(2, frame:GetPos()))
    previewFrame:AllowCloseButton(false)
    previewFrame:MakePopup()

    
    surface.SetFont("TargetIDSmall")
    local wide1,tall1 = surface.GetTextSize("Select a car by clicking its icon on the list.\nSelect a skin to see how it looks on a car.")
    
    local previewInfoBox = vgui.Create("DFrame", previewFrame)
    previewInfoBox:SetSize(wide1+10, tall1+10)
    previewInfoBox:SetPos(previewFrame:GetWide()/2-(wide1+10)/2, 10)
    previewInfoBox:ShowCloseButton(false)
    previewInfoBox:SetTitle("")
    
    function previewInfoBox:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(25,25,25,255))
        draw.DrawText("Select a car by clicking its icon on the list.\nSelect a skin to see how it looks on a car.", "TargetIDSmall", w/2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end

    previewDisplay:SetPos(5, 10+tall1+10+10)
    previewDisplay:SetSize(490, 495 - previewDisplay:GetPos())
    previewDisplay:SetCamPos(Vector(300,0,100))
    previewDisplay:SetModel(carList:GetItems()[1].mdl)
    previewDisplay:SetLookAt(previewDisplay.Entity:GetPos()+Vector(0,0,50))
    
    function previewDisplay:OnCursorEntered()
        previewDisplay:SetCursor("arrow")
    end
    
    local note = vgui.Create("DLabel", previewFrame)
    note:SetText("Above display only for reference. Respray sold separately.")
    note:SetFont("UiBold")
    note:SizeToContents()
    note:SetPos(previewFrame:GetWide()/2-note:GetWide()/2, previewFrame:GetTall()-note:GetTall()-5)
    
    -- Skin choosing stuff
    
    function previewColorArea:SetupSkins()
        self.skins = self.skins or {}
        for k1,v1 in pairs(self.skins) do
            v1:Remove()
        end
        self.skins = {}
        
        for _,color in pairs(carList:GetItems()[1].table.Skins) do
            local ColorPanel = vgui.Create("DButton", self)
            ColorPanel:SetSize(45,45)
            ColorPanel:SetText("")
            local cstring = string.gsub(color.name, " " , "_")
            ColorPanel.Paint = function()
                if type(color_table[cstring]) == "table" then
                    surface.SetDrawColor(color_table[cstring])
                    surface.DrawRect(0, 0, 45, 45)
                else
                    if string.find(tostring(color_table[cstring]), "skin15") then -- This texture is broken, but it's basically just (100,0,100)
                        surface.SetDrawColor(Color(100,0,100))
                        surface.DrawRect(0,0,45,45)
                    else
                        surface.SetMaterial(color_table[cstring])
                        surface.DrawTexturedRect(0, 0, 45, 45)
                    end
                end
            end
            ColorPanel.DoClick = function()
                if type(color_table[cstring]) == "table" then
                    previewDisplay.Entity:SetSkin(0)
                    previewDisplay:SetColor(color_table[cstring])
                else
                    previewDisplay:SetColor(Color(255,255,255))
                    previewDisplay.Entity:SetSkin(color.skin)
                end
            end
            table.insert(self.skins, ColorPanel)
        end
        
        local x = math.Clamp(#self.skins*50, 0, 400)
        local y = #self.skins <= 8 and 45 or 95
        if x > 0 then
            self:SetSize(x+5, y+10)
        else
            surface.SetFont("UiBold")
            local wide2,tall2 = surface.GetTextSize("No skins available for this car")
            self:SetSize(wide2+10, tall2+10)
        end
        self:SetPos(previewDisplay:GetWide()/2-self:GetWide()/2, select(2, previewInfoBox:GetPos())+previewInfoBox:GetTall()+20)
        
        local i,h = 5, 5
        for k,v in pairs(self.skins) do
            if i >= 400 then
                h = h + 50
                i = 5
            end
            v:SetPos(i,h)
            i = i + 50
        end
        
    end
    
    previewColorArea:SetTitle("")
    previewColorArea:ShowCloseButton(false)
    previewColorArea:SetupSkins()
    
    function previewColorArea:Paint(w,h)
        if #self.skins == 0 then
            draw.DrawText("No skins available for this car", "UiBold", 5, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
        else
            draw.RoundedBox(8, 0, 0, w, h, Color(39,168,216,255))
            draw.RoundedBox(8, 1, 1, w-2, h-2, Color(25,25,25,255))
        end
    end
    
    carInfoArea:SetPos(frame:GetPos()+frame:GetWide()+50, select(2, frame:GetPos()))
    carInfoArea:SetSize(363, 500)
    carInfoArea:SetOCRPTitle("Car Info")
    carInfoArea:AllowCloseButton(false)
    carInfoArea:MakePopup()
    
    local carTitle = vgui.Create("DFrame", carInfoArea)
    carTitle:SetTitle("")
    carTitle:ShowCloseButton(false)
    
    function carTitle:Paint(w,h)
        --draw.RoundedBox(8, 0, 0, w, h, Color(25,25,25,255))
        draw.DrawText(previewDisplay.carTable.Name, "TargetIDSmall", w/2, 5, Color(39,168,216,255), TEXT_ALIGN_CENTER)
        draw.RoundedBox(0, 5, h-2, w-10, 1, Color(39,168,216,255))
    end
    
    -- Price, Health, Speed, Gas tank, Repair cost, Seats, Respray price
    
    local desc = vgui.Create("DLabel", carInfoArea)
    desc:SetFont("UiBold")
    
    local priceLabel = vgui.Create("DLabel", carInfoArea)
    priceLabel:SetFont("Trebuchet19")
    priceLabel:SetTextColor(Color(255,255,255,255))
    
    local price = vgui.Create("DLabel", carInfoArea)
    price:SetFont("Trebuchet19")
    price:SetTextColor(Color(39,168,216,255))
    
    local seatsLabel = vgui.Create("DLabel", carInfoArea)
    seatsLabel:SetFont("Trebuchet19")
    seatsLabel:SetTextColor(Color(255,255,255,255))
    
    local seats = vgui.Create("DLabel", carInfoArea)
    seats:SetFont("Trebuchet19")
    seats:SetTextColor(Color(39,168,216,255))
    
    local repairLabel = vgui.Create("DLabel", carInfoArea)
    repairLabel:SetFont("Trebuchet19")
    repairLabel:SetTextColor(Color(255,255,255,255))
    
    local repair = vgui.Create("DLabel", carInfoArea)
    repair:SetFont("Trebuchet19")
    repair:SetTextColor(Color(39,168,216,255))
    
    local resprayLabel = vgui.Create("DLabel", carInfoArea)
    resprayLabel:SetFont("Trebuchet19")
    resprayLabel:SetTextColor(Color(255,255,255,255))
    
    local respray = vgui.Create("DLabel", carInfoArea)
    respray:SetFont("Trebuchet19")
    respray:SetTextColor(Color(39,168,216,255))
    
    local speedLabel = vgui.Create("DLabel", carInfoArea)
    speedLabel:SetFont("Trebuchet19")
    speedLabel:SetTextColor(Color(255,255,255,255))
    
    local speedBar = vgui.Create("DProgress", carInfoArea)
    speedBar:SetSize(150, 30)
    
    local speed = vgui.Create("DLabel", carInfoArea)
    speed:SetFont("UiBold")
    speed:SetTextColor(Color(39,168,216,255))
    
    local strengthLabel = vgui.Create("DLabel", carInfoArea)
    strengthLabel:SetFont("Trebuchet19")
    strengthLabel:SetTextColor(Color(255,255,255,255))
    
    local strengthBar = vgui.Create("DProgress", carInfoArea)
    strengthBar:SetSize(150, 30)
    
    local strength = vgui.Create("DLabel", carInfoArea)
    strength:SetFont("UiBold")
    strength:SetTextColor(Color(39,168,216,255))
    
    local gasLabel = vgui.Create("DLabel", carInfoArea)
    gasLabel:SetFont("Trebuchet19")
    gasLabel:SetTextColor(Color(255,255,255,255))
    
    local gasBar = vgui.Create("DProgress", carInfoArea)
    gasBar:SetSize(150, 30)
    
    local gas = vgui.Create("DLabel", carInfoArea)
    gas:SetFont("UiBold")
    gas:SetTextColor(Color(39,168,216,255))
    
    function carInfoArea:layout()
    
        local ct = previewDisplay.carTable
        
        surface.SetFont("TargetIDSmall")
        local titleWide,titleTall = surface.GetTextSize(previewDisplay.carTable.Name)
        carTitle:SetSize(titleWide+10, titleTall+10)
        carTitle:SetPos(self:GetWide()/2-carTitle:GetWide()/2, 10)
        
        desc:SetText("\"" .. ct.Desc .. "\"")
        desc:SizeToContents()
        desc:SetPos(self:GetWide()/2-desc:GetWide()/2, 50)
        
        priceLabel:SetText("Price: $" .. ct.Price) -- Size with price but then remove
        priceLabel:SizeToContents()
        priceLabel:SetText("Price:")
        priceLabel:SetPos(self:GetWide()/2-priceLabel:GetWide()/2, 80)
        
        surface.SetFont("Trebuchet19")
        local sxwide = surface.GetTextSize("Price:")
        local sx = priceLabel:GetPos() + sxwide
        
        price:SetText("$" .. ct.Price)
        price:SizeToContents()
        price:SetPos(priceLabel:GetPos()+50, 80)

        seatsLabel:SetText("Number of Seats:")
        seatsLabel:SizeToContents()
        seatsLabel:SetPos(sx - seatsLabel:GetWide(), 120)
        
        seats:SetText(ct.SeatsNum)
        seats:SizeToContents()
        seats:SetPos(186, 120)
        
        repairLabel:SetText("Cost to Fully Repair:")
        repairLabel:SizeToContents()
        repairLabel:SetPos(sx - repairLabel:GetWide(), 160)
        
        repair:SetText("$" .. ct.RepairCost)
        repair:SizeToContents()
        repair:SetPos(186, 160)
        
        resprayLabel:SetText("Cost to Respray:")
        resprayLabel:SizeToContents()
        resprayLabel:SetPos(sx-resprayLabel:GetWide(), 200)
        
        respray:SetText("$" .. ct.Skin_Price)
        respray:SizeToContents()
        respray:SetPos(186, 200)
        
        speedLabel:SetText("Max Speed: ")
        speedLabel:SizeToContents()
        speedLabel:SetPos(20, 250)
        
        speedBar:SetFraction(ct.Speed/130)
        speedBar:SetPos(20+speedLabel:GetWide()+20, 244)

        speed:SetText(ct.Speed .. " MPH")
        speed:SizeToContents()
        speed:SetPos(speedBar:GetPos()+speedBar:GetWide()+20, 252)
        
        strengthLabel:SetText("Strength: ")
        strengthLabel:SizeToContents()
        strengthLabel:SetPos(20, 300)
        
        strengthBar:SetFraction(ct.Health/225)
        strengthBar:SetPos(20+speedLabel:GetWide()+20, 294)
        
        strength:SetText(ct.Health .. " HP")
        strength:SizeToContents()
        strength:SetPos(strengthBar:GetPos()+strengthBar:GetWide()+20, 302)
        
        gasLabel:SetText("Gas Tank: ")
        gasLabel:SizeToContents()
        gasLabel:SetPos(20, 350)
        
        gasBar:SetFraction(ct.GasTank/1000)
        gasBar:SetPos(20+speedLabel:GetWide()+20, 344)
        
        gas:SetText(ct.GasTank .. " Liters")
        gas:SizeToContents()
        gas:SetPos(gasBar:GetPos()+gasBar:GetWide()+20, 352)
    end
    
    carInfoArea:layout()
    
    local buy = vgui.Create("OCRP_BaseButton", carInfoArea)
    buy:SetText("Purchase Car")
    buy:SetSize(200, 30)
    buy:SetPos(carInfoArea:GetWide()/2-buy:GetWide()/2, 425)
    
    function buy:DoClick()
        for k,v in pairs(OCRP_MyCars) do
            if v.car == previewDisplay.carTable.OtherName then
                OCRP_AddHint("You already own this car!")
                return
            end
        end
        if LocalPlayer().Bank < previewDisplay.carTable.Price then
            OCRP_AddHint("You don't have enough in your bank for this car.")
            return
        end
        AreYouSure(previewDisplay.carTable.OtherName, previewDisplay.carTable.Price, previewDisplay.carTable.Name, frame)
    end
    
    function RemoveWholeMenu()
        if frame and frame:IsValid() then frame:Remove() end
        if previewFrame and previewFrame:IsValid() then previewFrame:Remove() end
        if carInfoArea and carInfoArea:IsValid() then carInfoArea:Remove() end
    end
    
    -- Only frame has a button for the time being
    frame.Close.DoClick = RemoveWholeMenu
    previewFrame.Close.DoClick = RemoveWholeMenu
    carInfoArea.Close.DoClick = RemoveWholeMenu
    
end

function AreYouSure(car, price, name, base)

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(250, 110)
    frame:Center()
    frame:MakePopup()

    local start = SysTime()
    
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, start)
        draw.RoundedBox(4, 0, 0, w, h, Color(0,0,0,255))
        draw.RoundedBox(4, 1, 1, w-2, h-2, Color(25,25,25,255))
        draw.DrawText("Are you sure?", "TargetIDSmall", w/2, 10, Color(39,168,216,255), TEXT_ALIGN_CENTER)
        draw.DrawText("Buying: " .. name, "UiBold", w/2, 30, Color(255,255,255,255), TEXT_ALIGN_CENTER)
        draw.DrawText("For: $" .. price, "UiBold", w/2, 45, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end
    
    local yes = vgui.Create("OCRP_BaseButton", frame)
    yes:SetText("Yes")
    yes:SetSize(75, 20)
    yes:SetPos(33, 75)
    
    function yes:DoClick()
        net.Start("OCRP_BuyCar")
            net.WriteString(car)
        net.SendToServer()
        frame:Remove()
        base.Close:DoClick()
    end
    
    local no = vgui.Create("OCRP_BaseButton", frame)
    no:SetText("No")
    no:SetSize(75, 20)
    no:SetPos(141, 75)
    
    function no:DoClick()
        frame:Remove()
    end
    
end

net.Receive("OCRP_ShowCarDealer", function()
    CarDealerMenu()
end)

function OpenGarageMenu()

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(363, 500)
    frame:SetOCRPTitle("Your Garage")
    frame:Center()
    frame:MakePopup()
    
    local numcars = #OCRP_MyCars or 0
	local totalcars = table.Count(GAMEMODE.OCRP_Cars) or 0
    local left = totalcars - numcars
    
    surface.SetFont("TargetIDSmall")
    local wide,tall = surface.GetTextSize("You have ".. numcars .." cars. \nYou have " .. left .. " more to purchase. \nYour current car is: " .. OCRP_CurCar)
    
    local topBox = vgui.Create("DFrame", frame)
    topBox:SetSize(wide+10, tall+10)
    topBox:SetPos(frame:GetWide()/2-(wide+10)/2, 10)
    topBox:ShowCloseButton(false)
    topBox:SetTitle("")

    function topBox:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(25,25,25,255))
        draw.DrawText("You have ".. numcars .." cars. \nYou have " .. left .. " more to purchase. \nYour current car is: " .. OCRP_CurCar, "TargetIDSmall", w/2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end
    
    local carList = vgui.Create("DPanelList", frame)
    carList:SetPos(5, tall+30)
    carList:SetSize(348, 415)
    carList:EnableVerticalScrollbar(true)
    carList:SetSpacing(10)
    carList:SetNoSizing(true)

    for k,v in pairs(OCRP_MyCars) do
        if v.car then
            local carItem = vgui.Create("DPanel")
            carItem:SetSize(320, 80)
            local hp = LocalPlayer():GetNWInt("Health_" .. v.car, GAMEMODE.OCRP_Cars[v.car].Health)
            local maxhp = GAMEMODE.OCRP_Cars[v.car].Health
            local perHp = math.Clamp(math.ceil(hp/maxhp*100), 0, 100)
            local gas = LocalPlayer():GetNWInt("Gas_" .. v.car, GAMEMODE.OCRP_Cars[v.car].GasTank)
            local maxGas = GAMEMODE.OCRP_Cars[v.car].GasTank
            local perGas = math.Clamp(math.ceil(gas/maxGas*100), 0, 100)
            local textWide, textTall = surface.GetTextSize(GAMEMODE.OCRP_Cars[v.car].Name)
            local textWide2, textTall2 = surface.GetTextSize("Health: " .. perHp .. "%")
            function carItem:Paint(w,h)
                draw.RoundedBox(8,0,0,w,h,Color(39,168,216,255))
				draw.RoundedBox(8,1,1,w-2,h-2,Color( 25, 25, 25, 255 ))
                draw.RoundedBox(0,80,10,1,60,Color(39,168,216,255))
                draw.DrawText(GAMEMODE.OCRP_Cars[v.car].Name, "TargetIDSmall", 80 + (w-80)/2, 10, Color(39,168,216,255), TEXT_ALIGN_CENTER)
                draw.RoundedBox(0, 80 + (w-80)/2 - textWide/2, 10 + textTall + 3, textWide, 1, Color(39,168,216,255))
                draw.DrawText("Health: " .. perHp .. "%", "TargetIDSmall", 80 + (w-80)/2, 10+textTall+8, perHp > 0 and Color(255,255,255,255) or Color(255,0,0,255), TEXT_ALIGN_CENTER)
                draw.DrawText("Gas: " .. perGas .. "%", "TargetIDSmall", 80 + (w-80)/2, 10+textTall+8+textTall2+2, perGas > 0 and Color(255,255,255,255) or Color(255,0,0,255), TEXT_ALIGN_CENTER)
            end
            local mdl = GAMEMODE.OCRP_Cars[v.car].Model
            if type(mdl) == "table" then
                mdl = GAMEMODE.OCRP_Cars[v.car].Model[1]
            end
            
            local carIcon = vgui.Create( "SpawnIcon", carItem )
			carIcon:SetSize( 70, 70 )
			carIcon:SetPos( 5, 5 )
			carIcon:SetModel( mdl )
			carIcon.OnMousePressed = function()
				net.Start("OCRP_SC")
                    net.WriteString(v.car)
				net.SendToServer()
				frame:Remove()
			end
            
            carList:AddItem(carItem)
        end
    end
    
    while #carList:GetItems() < 5 do
        local filler = vgui.Create("DPanel")
        filler:SetSize(320, 80)
        filler.Paint = function() end
        carList:AddItem(filler)
    end
    
end

net.Receive("OCRP_OpenGarage", function()
    OpenGarageMenu()
end)

function OpenSkinMenu(car)

    if not GAMEMODE.OCRP_Cars[car] then
        OCRP_AddHint("This car does not have any skins available!")
        return
    end
    
    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(400, 375)
    frame:SetOCRPTitle("Respray Choices")
    frame:Center()
    frame:AllowCloseButton(true)
    frame:MakePopup()
    
    surface.SetFont("Trebuchet19")
    local infotext = "A respray for this vehicle costs $" .. GAMEMODE.OCRP_Cars[car].Skin_Price or 5000
    local textw,texth = surface.GetTextSize(infotext)
    
    local info = vgui.Create("DFrame", frame)
    info:ShowCloseButton(false)
    info:SetTitle("")
    info:SetSize(textw+10, texth+10)
    info:SetPos(frame:GetWide()/2-info:GetWide()/2, 10)
    
    function info:Paint(w,h)
        draw.RoundedBox(8,0,0,w,h,Color(25,25,25,255))
        draw.DrawText(infotext, "Trebuchet19", w/2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end
    
    local skinlist = vgui.Create("DPanelList", frame)
    skinlist:SetSize(380, 310)
    skinlist:SetPos(frame:GetWide()/2-skinlist:GetWide()/2, 55)
    skinlist:EnableVerticalScrollbar(true)
    skinlist:SetSpacing(10)
    skinlist:SetNoSizing(true)
    
    for k,v in pairs(GAMEMODE.OCRP_Cars[car].Skins) do
        
        local skinitem = vgui.Create("DPanel")
        skinitem:SetSize(350, 60)
        
        for i=1,2 do
            local color = vgui.Create("DPanel", skinitem)
            color:SetSize(50,50)

            local cstring = string.gsub(v.name, " " , "_")
            
            function color:Paint(w,h)
                if type(color_table[cstring]) == "table" then
                    surface.SetDrawColor(color_table[cstring])
                    surface.DrawRect(0, 0, w, h)
                else
                    if string.find(tostring(color_table[cstring]), "skin15") then -- This texture is broken, but it's basically just (100,0,100)
                        surface.SetDrawColor(Color(100,0,100))
                        surface.DrawRect(0,0,w,h)
                    else
                        surface.SetMaterial(color_table[cstring])
                        surface.DrawTexturedRect(0, 0, w, h)
                    end
                end
            end
            if i == 1 then
                color:SetPos(5,5)
            elseif i == 2 then
                color:SetPos(skinitem:GetWide()-color:GetWide()-5, 5)
            end
        end
        
        function skinitem:Paint(w,h)
            draw.RoundedBox(8, 0, 0, w, h, Color(39,168,216,255))
            draw.RoundedBox(8, 1, 1, w-2,h-2, Color(25,25,25,255))
            --draw.DrawText(v.name, "UiBold", w/2, 25, Color(255,255,255,255), TEXT_ALIGN_CENTER)
        end
        
        local buy = vgui.Create("OCRP_BaseButton", skinitem)
        buy:SetSize(180, 30)
        buy:SetPos(skinitem:GetWide()/2-buy:GetWide()/2, skinitem:GetTall()/2-buy:GetTall()/2)
        buy:SetText("Purchase " .. v.name)
        
        function buy:DoClick()
            net.Start("ocrp_bskin")
			net.WriteInt(k, 32)
			net.SendToServer()
            frame:Remove()
        end
        
        skinlist:AddItem(skinitem)
    
    end

end

net.Receive("OCRP_Open_Skins", function()
    local car = net.ReadString()
    OpenSkinMenu(car)
end)

function ShowColors(kind)

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(400, 375)
    frame:SetOCRPTitle(kind .. " Colors")
    frame:Center()
    frame:MakePopup()
    
    local cost = "$50000"
    if kind == "Underglow" then
        cost = "$15000"
    end
    
    surface.SetFont("Trebuchet19")
    local infotext = "Colors for this vehicle cost " .. cost .. " each."
    local textw,texth = surface.GetTextSize(infotext)
    
    local info = vgui.Create("DPanel", frame)
    info:SetSize(textw+10, texth+10)
    info:SetPos(frame:GetWide()/2-info:GetWide()/2, 10)
    
    function info:Paint(w,h)
        draw.RoundedBox(8,0,0,w,h,Color(25,25,25,255))
        draw.DrawText(infotext, "Trebuchet19", w/2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end
    
    local colorlist = vgui.Create("DPanelList", frame)
    colorlist:SetSize(380, 310)
    colorlist:SetPos(frame:GetWide()/2-colorlist:GetWide()/2, 55)
    colorlist:EnableVerticalScrollbar(true)
    colorlist:SetSpacing(10)
    colorlist:SetNoSizing(true)

    local colors = {"Blue", "Green", "Red", "Ice", "Purple", "White", "Orange", "Yellow", "Pink"}
    
	for _,color in pairs(colors) do
        
        local coloritem = vgui.Create("DPanel")
        coloritem:SetSize(350, 60)
        
        for i=1,2 do
            local colordisplay = vgui.Create("DPanel", coloritem)
            colordisplay:SetSize(50,50)
            
            function colordisplay:Paint(w,h)
                surface.SetDrawColor(StringToColor(color))
                surface.DrawRect(0, 0, w, h)
            end
            
            if i == 1 then
                colordisplay:SetPos(5,5)
            elseif i == 2 then
                colordisplay:SetPos(coloritem:GetWide()-colordisplay:GetWide()-5, 5)
            end
        end
        
        function coloritem:Paint(w,h)
            draw.RoundedBox(8, 0, 0, w, h, Color(39,168,216,255))
            draw.RoundedBox(8, 1, 1, w-2,h-2, Color(25,25,25,255))
            --draw.DrawText(v.name, "UiBold", w/2, 25, Color(255,255,255,255), TEXT_ALIGN_CENTER)
        end
        
        local buy = vgui.Create("OCRP_BaseButton", coloritem)
        buy:SetSize(180, 30)
        buy:SetPos(coloritem:GetWide()/2-buy:GetWide()/2, coloritem:GetTall()/2-buy:GetTall()/2)
        buy:SetText("Purchase " .. color)
        
        function buy:DoClick()
            if kind == "Underglow" then
                net.Start("OCRP_Buy_UG")

            else
                net.Start("OCRP_Buy_Headlights")
            end
            net.WriteString(color)
            net.SendToServer()
            frame:Remove()
        end
        
        colorlist:AddItem(coloritem)
        
    end
end

function StringToColor(colorstring)
    local color1 = Color(0,0,0,255)
	if colorstring == "Blue" then
		color1.r = 0
		color1.g = 0
		color1.b = 255
	elseif colorstring == "Green" then
		color1.r = 0
		color1.g = 204
		color1.b = 0
	elseif colorstring == "Red" then
		color1.r = 204
		color1.g = 0
		color1.b = 0
	elseif colorstring == "Ice" then
		color1.r = 0
		color1.g = 50
		color1.b = 150
	elseif colorstring == "Purple" then
		color1.r = 145
		color1.g = 0
		color1.b = 255
	elseif colorstring == "Orange" then
        color1.r = 255
        color1.g = 152
        color1.b = 44
    elseif colorstring == "Yellow" then
        color1.r = 220
        color1.g = 220
        color1.b = 0
    elseif colorstring == "White" then
        color1.r = 255
        color1.g = 255
        color1.b = 255
    elseif colorstring == "Pink" then
        color1.r = 255
        color1.g = 130
        color1.b = 255
    end
	return color1
end

function CL_UpdateGas( umsg )
	local gas = umsg:ReadLong()
	OCRP_VehicleGas = gas
end
usermessage.Hook("OCRP_UpdateGas", CL_UpdateGas)

function GM.CarAlarm ( UMsg )
	local Entity = UMsg:ReadEntity();
	
	if !Entity or !Entity:IsValid() then return false; end
	
	if !Entity:GetTable().CarAlarmLoop then
		Entity:GetTable().CarAlarmLoop = CreateSound(Entity, Sound('ocrp/car_alarm.mp3'));
		Entity:GetTable().CarAlarmLoop_LastPlay = 0;
	end
	
	if Entity:GetTable().CarAlarmLoop_LastPlay + 25 < CurTime() then
		Entity:GetTable().CarAlarmLoop:Play();
		Entity:GetTable().CarAlarmLoop_LastPlay = CurTime();
	end
end
usermessage.Hook('car_alarm', GM.CarAlarm);


function GM.CarAlarmStop ( UMsg )
	local Entity = UMsg:ReadEntity();
	
	if !Entity or !Entity:IsValid() then return false; end
	
	if Entity:GetTable().CarAlarmLoop_LastPlay and Entity:GetTable().CarAlarmLoop_LastPlay + 23 > CurTime() then
		Entity:GetTable().CarAlarmLoop:Stop();
		Entity:GetTable().CarAlarmLoop_LastPlay = 0;
	end
end
usermessage.Hook('car_alarm_stop', GM.CarAlarmStop);