--OCRP_Voting = {}
GM.CL_MayorMoney = 0
GM.CL_PolicePayCheck = 0
GM.CL_PoliceMoney = 0
GM.CL_ChiefPayCheck = 15

surface.CreateFont("MenuLarge", {
    font="Verdana",
    size=15,
    weight=600,
    antialias=true,
})

--[[function CL_UpdateVote( umsg )
	local clear = umsg:ReadBool()
	if clear then
		OCRP_Voting = {}
		return
	end

	local Mayor = umsg:ReadEntity()
	local bool = umsg:ReadBool()
	if bool then
		for _,ply in pairs(OCRP_Voting) do
			if ply == Mayor then
				return
			end
		end
		table.insert(OCRP_Voting,Mayor)
	else
		for _,ply in pairs(OCRP_Voting) do
			if ply == Mayor then
				table.remove(OCRP_Voting,_)
			end
		end
	end
end
usermessage.Hook('OCRP_UpdateVote', CL_UpdateVote);]]

local extramoney = 0 

function CL_UpdateMayorMoney( umsg )
	local money = umsg:ReadLong()
	local pmoney = umsg:ReadLong()
	local emoney = umsg:ReadLong()
	GAMEMODE.CL_MayorMoney = money
	GAMEMODE.CL_PoliceMoney =  pmoney
	extramoney = emoney
end
usermessage.Hook('OCRP_MayorMoneyUpdate', CL_UpdateMayorMoney);


function GUI_VoteMenu(candidates)
	if GUI_Vote_Frame != nil then 
		GUI_Vote_Frame:Remove() 
	end
	GUI_Vote_Frame = vgui.Create("DFrame")
	GUI_Vote_Frame:SetTitle("")
	GUI_Vote_Frame:SetSize(400 ,430)
	GUI_Vote_Frame:Center()
	GUI_Vote_Frame.Paint = function()
	
								--draw.RoundedBox(8,0,0,GUI_Vote_Frame:GetWide(),GUI_Vote_Frame:GetTall(),Color( 60, 60, 60, 255 ))
								draw.RoundedBox(8,1,1,GUI_Vote_Frame:GetWide()-2,GUI_Vote_Frame:GetTall()-2,OCRP_Options.Color)
								
								surface.SetTextColor(255,255,255,255)
								surface.SetFont("UiBold")
								local x,y = surface.GetTextSize("Vote for your next mayor")
								surface.SetTextPos(75-x/2,11 - y/2)
								surface.DrawText("Vote for your next mayor")
							end
	GUI_Vote_Frame:MakePopup()
	GUI_Vote_Frame:ShowCloseButton(false)
	
	local GUI_Main_Exit = vgui.Create("DButton")
	GUI_Main_Exit:SetParent(GUI_Vote_Frame)	
	GUI_Main_Exit:SetSize(20,20)
	GUI_Main_Exit:SetPos(375,5)
	GUI_Main_Exit:SetText("")
	GUI_Main_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,GUI_Main_Exit:GetWide(),GUI_Main_Exit:GetTall())
									end
	GUI_Main_Exit.DoClick = function()
								GUI_Vote_Frame:Remove()
							end
	local GUI_Vote_Panel = vgui.Create("DPanelList")
	GUI_Vote_Panel:SetParent(GUI_Vote_Frame)
	GUI_Vote_Panel:SetSize(390,380)
	GUI_Vote_Panel:SetPos(5,40)
	GUI_Vote_Panel:EnableHorizontal(1)
	GUI_Vote_Panel:EnableVerticalScrollbar(true)
	GUI_Vote_Panel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Vote_Panel:GetWide(),GUI_Vote_Panel:GetTall(),Color( 50, 50, 50, 155 ))
								end		
	for stmid,_ in pairs(candidates) do
        local ply = player.GetBySteamID(stmid)
		if ply and ply:IsValid() then
			local GUI_Player = vgui.Create("DButton")
			GUI_Player:SetParent(GUI_Vote_Panel)
			GUI_Player:SetSize(390,30)
			GUI_Player:SetPos(0,0)
			GUI_Player:SetText(ply:Nick())
			GUI_Player.Paint = function()
				draw.RoundedBox(8,0,0,GUI_Player:GetWide(),GUI_Player:GetTall(),Color( 60, 60, 60, 155 ))
				draw.RoundedBox(8,1,1,GUI_Player:GetWide()-2,GUI_Player:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
			end
			GUI_Player.DoClick = function()
				net.Start("OCRP_Vote")
				net.WriteString(ply:SteamID())
				net.SendToServer()
				GUI_Vote_Frame:Remove()
			end
			GUI_Vote_Panel:AddItem(GUI_Player)
		end
	end
							
end
net.Receive("OCRP_StartMayorVoting", function(len)
	GUI_VoteMenu(net.ReadTable())
end)

IllegalItems = {}
for item,data in pairs(GM.OCRP_Items) do
	if data.Illegalizeable then
		IllegalItems[item] = false
	end
end
MAYOR_CANUPDATE = true

function GUI_MayorMenu()
	if LocalPlayer():GetNWBool("Handcuffed") || LocalPlayer():Team() != CLASS_Mayor then return end
	if GUI_Mayor_Frame != nil then
		GUI_Mayor_Frame:Remove()
	end
	
	GUI_Mayor_Frame = vgui.Create("DFrame")
	GUI_Mayor_Frame:SetTitle("")
	GUI_Mayor_Frame:SetSize(520 ,450)
	GUI_Mayor_Frame:Center()
	GUI_Mayor_Frame.Paint = function()
	
								--draw.RoundedBox(8,0,0,GUI_Mayor_Frame:GetWide(),GUI_Mayor_Frame:GetTall(),Color( 60, 60, 60, 255 ))
								draw.RoundedBox(8,1,1,GUI_Mayor_Frame:GetWide()-2,GUI_Mayor_Frame:GetTall()-2,OCRP_Options.Color)
								
								surface.SetTextColor(255,255,255,255)
								surface.SetFont("UiBold")
								local x,y = surface.GetTextSize("Mayor Menu")
								surface.SetTextPos(45-x/2,11 - y/2)
								surface.DrawText("Mayor Menu")
							end
	GUI_Mayor_Frame:MakePopup()
	GUI_Mayor_Frame:ShowCloseButton(false)
								
	local GUI_Main_Exit = vgui.Create("DButton")
	GUI_Main_Exit:SetParent(GUI_Mayor_Frame)	
	GUI_Main_Exit:SetSize(20,20)
	GUI_Main_Exit:SetPos(500,5)
	GUI_Main_Exit:SetText("")
	GUI_Main_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,GUI_Main_Exit:GetWide(),GUI_Main_Exit:GetTall())
									end
	GUI_Main_Exit.DoClick = function()
								GUI_Mayor_Frame:Remove()
							end

	local GUI_Property_Sheet = vgui.Create("DPropertySheet")
	GUI_Property_Sheet:SetParent(GUI_Mayor_Frame)
	GUI_Property_Sheet:SetPos(10,20)
	GUI_Property_Sheet:SetSize(500,444 )
	GUI_Property_Sheet.Paint = function() 
								end	
																
	GUI_Property_Sheet:AddSheet( "Economy", GUI_Rebuild_Eco(GUI_Mayor_Frame) , "icon16/star.png", true, true, "Manage Salaries and the economy" )									
	--GUI_Property_Sheet:AddSheet( "Item Management", GUI_Rebuild_Ill(GUI_Mayor_Frame) , "icon16/box.png", true, true, "Legal/Illegalize items" )		
	GUI_Property_Sheet:AddSheet( "Player Management", GUI_Rebuild_Ply(GUI_Mayor_Frame) , "icon16/user.png", true, true, "Demote/Promote/Warrant" )
    GUI_Property_Sheet:AddSheet( "Law Management", GUI_Rebuild_Laws(GUI_Mayor_Frame), "icon16/shield.png", true, true, "Update laws and speed limits" )
	
	for _,panel in pairs(GUI_Property_Sheet.Items) do
		panel.Tab:SetAutoStretchVertical(false)
		panel.Tab:SetSize(50,50)
		panel.Tab.Paint = function() 
							draw.RoundedBox(8,0,0,panel.Tab:GetWide()-4,panel.Tab:GetTall()+10,Color( 60, 60, 60, 155 ))
						end
	end		

end
net.Receive("OCRP_MayorMenu", function(len)
	if LocalPlayer():Team() == CLASS_Mayor then
		GUI_MayorMenu()
	end
end)

function GUI_Rebuild_Laws(parent)
	local GUI_Laws_Panel = vgui.Create("DPanel", parent)
	GUI_Laws_Panel:SetPos(11,22)
	GUI_Laws_Panel:SetSize(500,400)
	GUI_Laws_Panel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Laws_Panel:GetWide(),GUI_Laws_Panel:GetTall(),Color( 60, 60, 60, 155 ))	
								end
    local GUI_CitySpeed_slider = vgui.Create("DNumSlider", GUI_Laws_Panel)
	GUI_CitySpeed_slider:SetWide(480)
	GUI_CitySpeed_slider:SetPos(10,10)
	GUI_CitySpeed_slider:SetText("In-City Speed Limit:")
	GUI_CitySpeed_slider:SetMin(20)
	GUI_CitySpeed_slider:SetMax(120)
	GUI_CitySpeed_slider:SetDecimals(0)
    GUI_CitySpeed_slider:SetValue(GetGlobalInt("City_Speed_Limit"))
    
    local GUI_OutCitySpeed_slider = vgui.Create("DNumSlider", GUI_Laws_Panel)
	GUI_OutCitySpeed_slider:SetWide(480)
	GUI_OutCitySpeed_slider:SetPos(10,40)
	GUI_OutCitySpeed_slider:SetText("Out-of-City Speed Limit:")
	GUI_OutCitySpeed_slider:SetMin(20)
	GUI_OutCitySpeed_slider:SetMax(120)
	GUI_OutCitySpeed_slider:SetDecimals(0)
    GUI_OutCitySpeed_slider:SetValue(GetGlobalInt("OutCity_Speed_Limit"))
    
    function GUI_CitySpeed_slider:OnValueChanged(val)
        val = math.Clamp(tonumber(val) or 0, 20, 120)
        
        self.Slider:SetSlideX(self.Scratch:GetFraction(val))
        
        if ( self.TextArea != vgui.GetKeyboardFocus() ) then
            self.TextArea:SetValue( self.Scratch:GetTextValue() )
        end
        
        net.Start("OCRP_CitySpeed_Update")
        net.WriteInt(math.Round(tonumber(val)), 32)
        net.SendToServer()
	end
    
    function GUI_OutCitySpeed_slider:OnValueChanged(val)
        val = math.Clamp(tonumber(val) or 0, 20, 120)
        
        self.Slider:SetSlideX(self.Scratch:GetFraction(val))
        
        if ( self.TextArea != vgui.GetKeyboardFocus() ) then
            self.TextArea:SetValue( self.Scratch:GetTextValue() )
        end
        
        net.Start("OCRP_OutCitySpeed_Update")
        net.WriteInt(math.Round(tonumber(val)), 32)
        net.SendToServer()
	end
    return GUI_Laws_Panel
end
function GUI_Rebuild_Eco(parent)
	local GUI_Eco_Panel = vgui.Create("DPanel")
	GUI_Eco_Panel:SetParent(parent)
	GUI_Eco_Panel:SetPos(11,22)
	GUI_Eco_Panel:SetSize(500,400)
	GUI_Eco_Panel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Eco_Panel:GetWide(),GUI_Eco_Panel:GetTall(),Color( 60, 60, 60, 155 ))	
								end	
	local GUI_Economy_Label = vgui.Create("DLabel")
	GUI_Economy_Label:SetParent(GUI_Eco_Panel)
	GUI_Economy_Label:SetColor(Color(255,255,255,255))
	GUI_Economy_Label:SetFont("UiBold")
	GUI_Economy_Label:SetText("Economy Rating : "..(50+GetGlobalInt("Eco_points")).."/100")
	GUI_Economy_Label:SizeToContents()
			
	surface.SetFont("UiBold")
	local x,y = surface.GetTextSize("Economy Rating : "..(5+GetGlobalInt("Eco_points")).."/100")
			
	GUI_Economy_Label:SetPos(10,10-y/2)
	
	local GUI_Eco_Points = vgui.Create("DPanel")
	GUI_Eco_Points:SetParent(GUI_Eco_Panel)
	GUI_Eco_Points:SetPos(10,20)
	GUI_Eco_Points:SetSize(480,15)
	GUI_Eco_Points.Paint = function()
	
		surface.SetDrawColor(Color( 0, 0, 0, 255 ))
		surface.DrawOutlinedRect(0,0,GUI_Eco_Points:GetWide(),GUI_Eco_Points:GetTall()-5)
		
		surface.SetDrawColor(Color( 0, 255, 0, 255 ))
		surface.DrawRect(1,1,GUI_Eco_Points:GetWide(),GUI_Eco_Points:GetTall()-7)
		
		surface.SetDrawColor(255, 0, 0, 255)
		surface.SetMaterial(Gradient)
		surface.DrawTexturedRect(1,1,GUI_Eco_Points:GetWide(),GUI_Eco_Points:GetTall()-7)
		
		surface.SetDrawColor(Color( 0, 0, 0, 255 ))
		surface.DrawLine(GUI_Eco_Points:GetWide()-1,0,GUI_Eco_Points:GetWide()-1,GUI_Eco_Points:GetTall())
		surface.DrawLine(0,0,0,GUI_Eco_Points:GetTall())
		surface.DrawLine(GUI_Eco_Points:GetWide()/2,0,GUI_Eco_Points:GetWide()/2,GUI_Eco_Points:GetTall())
		
		surface.SetDrawColor(Color( 255, 255, 255, 255 ))
		surface.SetMaterial(OC_Money)
		surface.DrawTexturedRect(GUI_Eco_Points:GetWide()/2-5+(GUI_Eco_Points:GetWide()/2*(GetGlobalInt("Eco_points")/50)),0,10,10)		
	end	
	
	local GUI_Economy_Desc = vgui.Create("DLabel")
	GUI_Economy_Desc:SetParent(GUI_Eco_Panel)
	GUI_Economy_Desc:SetColor(Color(255,255,255,255))
	GUI_Economy_Desc:SetFont("UiBold")
	if GetGlobalInt("Eco_points") > 0 then
		GUI_Economy_Desc:SetText("Players Recieve $"..math.Round(GetGlobalInt("Eco_points")/5).." more on their paychecks")
	elseif GetGlobalInt("Eco_points") < 0 then
		GUI_Economy_Desc:SetText("Players Receive $"..math.abs(math.Round(GetGlobalInt("Eco_points")/5)).." less on their paychecks")
	else
		GUI_Economy_Desc:SetText("Players Recieve normal paychecks")
	end
	GUI_Economy_Desc:SetSize(480,30)
	GUI_Economy_Desc:SetWrap(true)
	GUI_Economy_Desc:SetPos(10,40-y/2)

	local GUI_Economy_Budget = vgui.Create("DLabel")
	GUI_Economy_Budget:SetParent(GUI_Eco_Panel)
	GUI_Economy_Budget:SetColor(Color(255,255,255,255))
	GUI_Economy_Budget:SetFont("UiBold")
	GUI_Economy_Budget:SetText("Your City has a spare $"..(GAMEMODE.CL_MayorMoney).."/500 in the city safe")
	GUI_Economy_Budget:SetSize(480,30)
	GUI_Economy_Budget:SetWrap(true)
	GUI_Economy_Budget:SetPos(10,70-y/2)
	GUI_Economy_Budget.Think = function()
								GUI_Economy_Budget:SetText("Your City has a spare $"..(GAMEMODE.CL_MayorMoney).."/500 in the city safe")
							end
	local GUI_Economy_Total = vgui.Create("DLabel")
	GUI_Economy_Total:SetParent(GUI_Eco_Panel)
	GUI_Economy_Total:SetColor(Color(255,255,255,255))
	GUI_Economy_Total:SetFont("UiBold")
	GUI_Economy_Total:SetText("Your City has a total of $"..(GAMEMODE.CL_MayorMoney + extramoney))
	GUI_Economy_Total:SetSize(480,30)
	GUI_Economy_Total:SetWrap(true)
	GUI_Economy_Total:SetPos(10,105-y/2)
	GUI_Economy_Total.Think = function()
								GUI_Economy_Total:SetText("Your City has a total of $"..(GAMEMODE.CL_MayorMoney + extramoney))
							end
							
	local GUI_Police_Budget = vgui.Create("DLabel")
	GUI_Police_Budget:SetParent(GUI_Eco_Panel)
	GUI_Police_Budget:SetColor(Color(255,255,255,255))
	GUI_Police_Budget:SetFont("UiBold")
	GUI_Police_Budget:SetText("Your Police Force has a spare $"..(GAMEMODE.CL_MayorMoney + extramoney).." to use")
	GUI_Police_Budget:SetSize(480,30)
	GUI_Police_Budget:SetWrap(true)
	GUI_Police_Budget:SetPos(10,140-y/2)
	GUI_Police_Budget.Think = function()
								GUI_Police_Budget:SetText("Your Police Force has a spare $"..GAMEMODE.CL_PoliceMoney.." to use")
							end							

	local GUI_Tax_slider = vgui.Create("DNumSlider")
	GUI_Tax_slider:SetParent(GUI_Eco_Panel)
	GUI_Tax_slider:SetWide(480)
	GUI_Tax_slider:SetPos(10,180)
	GUI_Tax_slider:SetText("Tax Percent:")
	GUI_Tax_slider:SetMin(0)
	GUI_Tax_slider:SetMax(10)
	GUI_Tax_slider:SetDecimals(0)
    GUI_Tax_slider:SetValue(GetGlobalInt("Eco_Tax"))
	
	function GUI_Tax_slider:OnValueChanged(val)
        val = math.Clamp( tonumber( val ) or 0, self:GetMin(), self:GetMax() )

        self.Slider:SetSlideX( self.Scratch:GetFraction( val ) )
	
        if ( self.TextArea != vgui.GetKeyboardFocus() ) then
            self.TextArea:SetValue( self.Scratch:GetTextValue() )
        end

        --self:OnValueChanged( val )
		net.Start("OCRP_TaxUpdate")
		net.WriteInt(math.Clamp(GUI_Tax_slider:GetValue(),0,10), 32)
		net.SendToServer()
	end
	
	local GUI_Police_Paycheck = vgui.Create("DNumSlider")
	GUI_Police_Paycheck:SetParent(GUI_Eco_Panel)
	GUI_Police_Paycheck:SetWide(480)
	GUI_Police_Paycheck:SetPos(10,230)
	GUI_Police_Paycheck:SetText("Police Force Income(Money for the police to use):")
	GUI_Police_Paycheck:SetMin(0)
	GUI_Police_Paycheck:SetValue(GAMEMODE.CL_PolicePayCheck)
	GUI_Police_Paycheck:SetMax(10)
	GUI_Police_Paycheck:SetDecimals(0)
	
	function GUI_Police_Paycheck:OnValueChanged(val)
        val = math.Clamp(tonumber(val) or 0, 0, 10)
        
        self.Slider:SetSlideX(self.Scratch:GetFraction(val))
        
        if ( self.TextArea != vgui.GetKeyboardFocus() ) then
            self.TextArea:SetValue( self.Scratch:GetTextValue() )
        end
        net.Start("OCRP_PoliceIncome_Update")
		net.WriteInt(math.Round(math.Clamp(val, 0, 10)), 32)
		net.SendToServer()
		GAMEMODE.CL_PolicePayCheck = math.Clamp(tonumber(val),0,10)
	end
	
	local GUI_Police_Donation = vgui.Create("DNumSlider")
	GUI_Police_Donation:SetParent(GUI_Eco_Panel)
	GUI_Police_Donation:SetWide(480)
	GUI_Police_Donation:SetPos(10,280)
	GUI_Police_Donation:SetText("Amount To Give to the police force:")
	GUI_Police_Donation:SetMin(0)
	GUI_Police_Donation:SetValue(0)
	GUI_Police_Donation:SetMax(500)
	GUI_Police_Donation:SetDecimals(0)
	
	local GUI_Police_Donate = vgui.Create("DButton")
	GUI_Police_Donate:SetParent(GUI_Eco_Panel)
	GUI_Police_Donate:SetPos(10,320)
	GUI_Police_Donate:SetSize(480,20)
	GUI_Police_Donate:SetText("Donate To the Police Force")
	
	GUI_Police_Donate.Paint = function()
								draw.RoundedBox(4,0,0,GUI_Police_Donate:GetWide(),GUI_Police_Donate:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(4,1,1,GUI_Police_Donate:GetWide()-2,GUI_Police_Donate:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
							end	
	GUI_Police_Donate.DoClick = function()
		net.Start("OCRP_Mayor_Donate_Police")
		net.WriteInt(math.Clamp(GUI_Police_Donation:GetValue(), 0, GAMEMODE.CL_MayorMoney), 32)
		net.SendToServer()
	end	
	
	local GUI_Catalog = vgui.Create("DButton")
	GUI_Catalog:SetParent(GUI_Eco_Panel)
	GUI_Catalog:SetPos(10,360)
	GUI_Catalog:SetSize(480,30)
	GUI_Catalog:SetText("Open Shopping Catalog")
	
	GUI_Catalog.Paint = function()
								draw.RoundedBox(8,0,0,GUI_Catalog:GetWide(),GUI_Catalog:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(8,1,1,GUI_Catalog:GetWide()-2,GUI_Catalog:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
							end	
	GUI_Catalog.DoClick = function()
									GUI_Mayor_Catalog()
								end	
								
	return GUI_Eco_Panel								
						
end

function GUI_Rebuild_Ill(parent)

	local GUI_Ill_Panel = vgui.Create("DPanel")
	GUI_Ill_Panel:SetParent(parent)
	GUI_Ill_Panel:SetPos(11,22)
	GUI_Ill_Panel:SetSize(500,400)
	GUI_Ill_Panel.Paint = function() 
									draw.RoundedBox(8,0,0,GUI_Ill_Panel:GetWide(),GUI_Ill_Panel:GetTall(),Color( 60, 60, 60, 155 ))	
								end	
								
	local GUI_Ill_tab_Panel = vgui.Create("DPanelList")
	GUI_Ill_tab_Panel:SetParent(GUI_Ill_Panel)
	GUI_Ill_tab_Panel:SetSize(425,350)
	GUI_Ill_tab_Panel:SetPos(25,0)
	GUI_Ill_tab_Panel:EnableHorizontal(4)
	GUI_Ill_tab_Panel:EnableVerticalScrollbar(true)
	GUI_Ill_tab_Panel:SetSpacing(5)
	GUI_Ill_tab_Panel:SetPadding(5)
	GUI_Ill_tab_Panel.Paint = function()
									--draw.RoundedBox(8,0,0,GUI_Ill_tab_Panel:GetWide(),GUI_Ill_tab_Panel:GetTall(),Color( 50, 50, 50, 155 ))
								end	

	local Inv_Icon_ent = ents.CreateClientProp("prop_physics")

	Inv_Icon_ent:SetPos(Vector(0,0,0))
	Inv_Icon_ent:Spawn()
	Inv_Icon_ent:Activate()	
								
	for item,data in pairs(GAMEMODE.OCRP_Items) do
		if data.Illegalizeable then
			local GUI_Inv_Item_Panel = vgui.Create("DPanelList")
			GUI_Inv_Item_Panel:SetParent(GUI_Ill_tab_Panel)
			
			if bool_local then
				GUI_Inv_Item_Panel:SetSize(100,120)
			else
				GUI_Inv_Item_Panel:SetSize(100,100)
			end
			
			GUI_Inv_Item_Panel:SetPos(0,0)
			GUI_Inv_Item_Panel:SetSpacing(5)
			GUI_Inv_Item_Panel.Paint = function()
											draw.RoundedBox(8,0,0,GUI_Inv_Item_Panel:GetWide(),GUI_Inv_Item_Panel:GetTall(),Color( 60, 60, 60, 155 ))
										end
		
			local GUI_Inv_Item_Icon = vgui.Create("DModelPanel")
			GUI_Inv_Item_Icon:SetParent(GUI_Inv_Item_Panel)
			GUI_Inv_Item_Icon:SetPos(0,0)
			GUI_Inv_Item_Icon:SetSize(100,100)
			
			GUI_Inv_Item_Icon:SetModel(GAMEMODE.OCRP_Items[item].Model)
			
			Inv_Icon_ent:SetModel(GAMEMODE.OCRP_Items[item].Model)
			
			if GAMEMODE.OCRP_Items[item].Angle != nil then
				GUI_Inv_Item_Icon:GetEntity():SetAngles(GAMEMODE.OCRP_Items[item].Angle)
			end
			
			local center = Inv_Icon_ent:OBBCenter()
			local dist = Inv_Icon_ent:BoundingRadius()*1.2
			GUI_Inv_Item_Icon:SetLookAt(center)
			GUI_Inv_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	
		
			local GUI_Inv_Item_Name = vgui.Create("DLabel")
			GUI_Inv_Item_Name:SetColor(Color(255,255,255,255))
			GUI_Inv_Item_Name:SetFont("UiBold")
			GUI_Inv_Item_Name:SetText(GAMEMODE.OCRP_Items[item].Name)
			GUI_Inv_Item_Name:SizeToContents()
			GUI_Inv_Item_Name:SetParent(GUI_Inv_Item_Panel)
			
			surface.SetFont("UiBold")
			local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[item].Name)
			
			GUI_Inv_Item_Name:SetPos(50 - x/2,10-y/2)	
		
	
			local GUI_Check_Illegal = vgui.Create( "DCheckBoxLabel", GUI_Inv_Item_Panel )
			GUI_Check_Illegal:SetPos( 15,80 )
			GUI_Check_Illegal:SetText( "Illegal" )
			GUI_Check_Illegal:SetValue(0)
			
			for item1,bool in pairs(IllegalItems) do
				if item1 == item && bool == true then
					GUI_Check_Illegal:SetValue(1)
					GUI_Check_Illegal:SetChecked(true)
				end
			end
			
			GUI_Check_Illegal:SizeToContents()
			GUI_Check_Illegal.OnChange = function()
											if GUI_Check_Illegal:GetChecked() == true then
												for item1,bool in pairs(IllegalItems) do
													if item1 == item && bool == true then
														return
													end
												end
												IllegalItems[item] = true
											else
												for item1,bool in pairs(IllegalItems) do
													if item1 == item && bool == true then
														IllegalItems[item] = false
													end
												end
											end
										end
									
			GUI_Ill_tab_Panel:AddItem(GUI_Inv_Item_Panel)
		end
	end
	Inv_Icon_ent:Remove()
 
	local GUI_Illegalize = vgui.Create("DButton")
	GUI_Illegalize:SetParent(GUI_Ill_Panel)
	GUI_Illegalize:SetPos(25,360)
	GUI_Illegalize:SetSize(425,30)
	GUI_Illegalize:SetText("Update Illegal Items - This will cause players to lose them when arrested")
	
	GUI_Illegalize.Paint = function()
								draw.RoundedBox(8,0,0,GUI_Illegalize:GetWide(),GUI_Illegalize:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(8,1,1,GUI_Illegalize:GetWide()-2,GUI_Illegalize:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
							end	
	GUI_Illegalize.DoClick = function()
									for item1,bool in pairs(IllegalItems) do
										local int1 = 0
										if bool then
											int1 = 1
										end
										net.Start("OCRP_IllegalizeItem")
										net.WriteString(item1)
										net.WriteInt(int1, 2)
										net.SendToServer()
									end
								end
	return GUI_Ill_Panel
end

function GUI_Rebuild_Ply(parent)
	local GUI_Ply_Panel = vgui.Create("DPanel")
	GUI_Ply_Panel:SetParent(parent)
	GUI_Ply_Panel:SetPos(11,22)
	GUI_Ply_Panel:SetSize(500,400)
	GUI_Ply_Panel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Ply_Panel:GetWide(),GUI_Ply_Panel:GetTall(),Color( 60, 60, 60, 155 ))		
								end	
								
	local GUI_Player_List = vgui.Create("DListView")
	GUI_Player_List:SetParent(GUI_Ply_Panel)
	GUI_Player_List:SetPos(10, 10)
	GUI_Player_List:SetSize(480, 350)
	GUI_Player_List:SetMultiSelect(false)
	GUI_Player_List:AddColumn("Name") -- Add column
	GUI_Player_List:AddColumn("Warrant Type")
	local column = GUI_Player_List:AddColumn("Employment")
	column:SetMinWidth(100)
	column:SetMaxWidth(100)
	for _,ply in pairs(player.GetAll()) do
		if ply != LocalPlayer() then 
			local status = "Citizen"
			if ply:Team() == CLASS_POLICE then
				status = "Police"
			elseif ply:Team() == CLASS_MEDIC then
				status = "Medic"
			elseif ply:Team() == CLASS_CHIEF then
				status = "Police Chief"
			elseif ply:Team() == CLASS_FIREMAN then
				status = "Fireman"
			elseif ply:Team() == CLASS_Mayor then
				status = "Mayor"
			end
				local Warranted = "None"
			if ply:GetNWInt("Warrant") == 1 then
				Warranted = "Search Warrant"
			elseif ply:GetNWInt("Warrant") == 2 then
				Warranted = "Arrest Warrant"
			end
			GUI_Player_List:AddLine(ply:Nick(),Warranted,status)
		end 
	end
	GUI_Player_List.OnRowSelected = function() 
		local GUI_Player_Options = DermaMenu()
		GUI_Player_Options:SetPos(gui.MousePos())
		GUI_Player_Options:AddOption("Search Warrant : "..GUI_Player_List:GetSelected()[1]:GetValue(1),function() 
			net.Start("OCRP_WarrantPlayer")
			net.WriteString(GUI_Player_List:GetSelected()[1]:GetValue(1))
			net.WriteInt(1,32)
            net.SendToServer()
		end)
		GUI_Player_Options:AddOption("Arrest Warrant : "..GUI_Player_List:GetSelected()[1]:GetValue(1),function()
			net.Start("OCRP_WarrantPlayer")
			net.WriteString(GUI_Player_List:GetSelected()[1]:GetValue(1))
			net.WriteInt(2,32)
            net.SendToServer()
		end)
		GUI_Player_Options:AddOption("Remove all Warrants",function()
			net.Start("OCRP_WarrantPlayer")
			net.WriteString(GUI_Player_List:GetSelected()[1]:GetValue(1))
			net.WriteInt(0,32)
            net.SendToServer()
		end)
		if GUI_Player_List:GetSelected()[1]:GetValue(3) != "Citizen" then
			GUI_Player_Options:AddOption("Demote "..GUI_Player_List:GetSelected()[1]:GetValue(1),function() 
				net.Start("OCRP_DemotePlayer")
				net.WriteString(GUI_Player_List:GetSelected()[1]:GetValue(1))
				net.SendToServer()
			end)
			if GUI_Player_List:GetSelected()[1]:GetValue(3) == "Police" then
				GUI_Player_Options:AddOption("Promote To Police Chief - $250",function()
					net.Start("OCRP_Hire_Police_Chief")
					net.WriteString(GUI_Player_List:GetSelected()[1]:GetValue(1)) 
					net.SendToServer()
				end)
			end
		end
		GUI_Player_Options:AddOption("Cancel",function() end)
		GUI_Player_Options:Open()
	end
								
	local GUI_Broadcast = vgui.Create("DButton")
	GUI_Broadcast:SetParent(GUI_Ply_Panel)
	GUI_Broadcast:SetPos(10,375)
	GUI_Broadcast:SetSize(480,20)
	GUI_Broadcast:SetText("Create Advanced Broadcast")
	
	GUI_Broadcast.Paint = function()
								draw.RoundedBox(4,0,0,GUI_Broadcast:GetWide(),GUI_Broadcast:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(4,1,1,GUI_Broadcast:GetWide()-2,GUI_Broadcast:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
							end	
	GUI_Broadcast.DoClick = function()
									GUI_Mayor_Broadcast()
								end	
	return GUI_Ply_Panel						
end

----------------------------------------------------------------------------------
--===============================================================================--
-----------------------------------------------------------------------------------
function CL_Event( umsg )
	local Event = umsg:ReadString()
	GUI_MayorEventMenu(Event)
end
usermessage.Hook('OCRP_Event', CL_Event);

function OCRP_Event_Result( umsg )
	local Reward = umsg:ReadBool()
	local event = umsg:ReadString()
	local choice = umsg:ReadString()
	if Reward then
		for _,data in pairs(GAMEMODE.OCRP_Economy_Events[event].Choices) do
			if data.Name == choice then
				if data.RewardText then
					GUI_Event_Description:SetText(data.RewardText)
					GUI_Main_Image:SetMaterial(OC_Check_Box)
				else
					GUI_Event_Frame:Remove()
				end
			end
		end
	else
		for _,data in pairs(GAMEMODE.OCRP_Economy_Events[event].Choices) do
			if data.Name == choice then
				if data.FailText then
					GUI_Event_Description:SetText(data.FailText)
				else
					GUI_Event_Frame:Remove()
				end
			end
		end
	end
end
usermessage.Hook('OCRP_Event_Result', OCRP_Event_Result);

function GUI_MayorEventMenu(event)
	if LocalPlayer():GetNWBool("Handcuffed") || LocalPlayer():Team() != CLASS_Mayor then return end
	if GUI_Event_Frame != nil && GUI_Event_Frame:IsValid() then
		GUI_Event_Frame:Remove()
	end
	
	GUI_Event_Frame = vgui.Create("DFrame")
	GUI_Event_Frame:SetTitle("")
	GUI_Event_Frame:SetSize(445 ,530)
	GUI_Event_Frame:Center()
	GUI_Event_Frame.Paint = function()
	
								--draw.RoundedBox(8,0,0,GUI_Mayor_Frame:GetWide(),GUI_Mayor_Frame:GetTall(),Color( 60, 60, 60, 255 ))
								draw.RoundedBox(8,1,1,GUI_Event_Frame:GetWide()-2,GUI_Event_Frame:GetTall()-2,OCRP_Options.Color)
								
								surface.SetTextColor(255,255,255,255)
								surface.SetFont("UiBold")
								local x,y = surface.GetTextSize("Event Menu")
								surface.SetTextPos(45-x/2,11 - y/2)
								surface.DrawText("Event Menu")
							end
	GUI_Event_Frame:MakePopup()
	GUI_Event_Frame:ShowCloseButton(false)
	
	GUI_Main_Image = vgui.Create("DImage")
	GUI_Main_Image:SetParent(GUI_Event_Frame)	
	GUI_Main_Image:SetSize(150,150)
	GUI_Main_Image:SetPos(147.5,45)
	
	local GUI_Main_Panel = vgui.Create("DPanel")
	GUI_Main_Panel:SetParent(GUI_Event_Frame)
	GUI_Main_Panel:SetSize(425,180)
	GUI_Main_Panel:SetPos(11,30)
	GUI_Main_Panel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Main_Panel:GetWide(),GUI_Main_Panel:GetTall(),Color( 50, 50, 50, 155 ))
								end	
								
								
	local GUI_Name = vgui.Create("DLabel")	
	GUI_Name:SetParent(GUI_Main_Panel)
	GUI_Name:SetFont("MenuLarge")
	GUI_Name:SetColor(Color(255,255,255,255))
	GUI_Name:SetPos(12.5,10)
	GUI_Name:SetText(GAMEMODE.OCRP_Economy_Events[event].Name)
	GUI_Name:SizeToContents()
	
	local GUI_Economy_Budget = vgui.Create("DLabel")
	GUI_Economy_Budget:SetParent(GUI_Event_Frame)
	GUI_Economy_Budget:SetColor(Color(255,255,255,255))
	GUI_Economy_Budget:SetFont("UiBold")
	GUI_Economy_Budget:SetText("Your City has a spare $"..(GAMEMODE.CL_MayorMoney + extramoney).." in total")
	GUI_Economy_Budget:SetWrap(false)
	GUI_Economy_Budget:SetPos(12.5,15)
	GUI_Economy_Budget:SizeToContents()

	GUI_Economy_Budget.Think = function()
								GUI_Economy_Budget:SetText("Your City has a spare $"..(GAMEMODE.CL_MayorMoney + extramoney).." in total")
								GUI_Economy_Budget:SizeToContents()
							end	
							
	GUI_Event_Description = vgui.Create("DLabel")	
	GUI_Event_Description:SetParent(GUI_Main_Panel)
	GUI_Event_Description:SetSize(400,100)
	GUI_Event_Description:SetColor(Color(255,255,255,255))
	GUI_Event_Description:SetFont("UiBold")
	GUI_Event_Description:SetPos(12.5,30)
	GUI_Event_Description:SetText(GAMEMODE.OCRP_Economy_Events[event].Desc)
	GUI_Event_Description:SetWrap(true)

	if GAMEMODE.OCRP_Economy_Events[event].Chance then
		local GUI_Chance = vgui.Create("DLabel")	
		GUI_Chance:SetParent(GUI_Main_Panel)
		GUI_Chance:SetColor(Color(255,255,255,255))
		GUI_Chance:SetFont("UiBold")
		GUI_Chance:SetPos(100,160)
		GUI_Chance:SetText("There is a chance this could go wrong.")
		GUI_Chance:SizeToContents()
	end

	
	local GUI_Choice_Panel = vgui.Create("DPanelList")
	GUI_Choice_Panel:SetParent(GUI_Event_Frame)
	GUI_Choice_Panel:SetSize(425,25 * table.Count(GAMEMODE.OCRP_Economy_Events[event].Choices) + 5)
	GUI_Choice_Panel:SetPos(11,220)
	GUI_Choice_Panel:SetPadding(5)
	GUI_Choice_Panel:SetSpacing(5)
	GUI_Choice_Panel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Choice_Panel:GetWide(),GUI_Choice_Panel:GetTall(),Color( 50, 50, 50, 155 ))
								end		
	if GAMEMODE.OCRP_Economy_Events[event].Ignore then
		GUI_Ignore = vgui.Create("DButton")	
		GUI_Ignore:SetParent(GUI_Event_Frame)
		GUI_Ignore:SetFont("UiBold")
		GUI_Ignore:SetPos(11, 220 + GUI_Choice_Panel:GetTall() + 10)
		GUI_Ignore:SetText("Ignore, everything is left the way it is.")
		GUI_Ignore:SetSize(425,20)
		GUI_Ignore.Paint = function()
								draw.RoundedBox(4,0,0,GUI_Ignore:GetWide(),GUI_Ignore:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(4,1,1,GUI_Ignore:GetWide()-2,GUI_Ignore:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
							end	
		GUI_Ignore.DoClick = function()
									GUI_Event_Frame:Remove()
								end	
	end
	for _,data in pairs(GAMEMODE.OCRP_Economy_Events[event].Choices) do
	
		local GUI_Choice = vgui.Create("DButton")	
		GUI_Choice:SetParent(GUI_Choice_Panel)
		GUI_Choice:SetFont("UiBold")
		
		if data.Price != nil then
			GUI_Choice:SetText(data.Name.." $"..data.Price)
		else
			GUI_Choice:SetText(data.Name)
		end
		
		GUI_Choice:SetSize((GUI_Choice_Panel:GetWide() -  10)/table.Count(GAMEMODE.OCRP_Economy_Events[event].Choices),20)
		GUI_Choice.Paint = function()
								draw.RoundedBox(4,0,0,GUI_Choice:GetWide(),GUI_Choice:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(4,1,1,GUI_Choice:GetWide()-2,GUI_Choice:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
							end	
		GUI_Choice.DoClick = function()
									if data.Price != nil then
										if (GAMEMODE.CL_MayorMoney + extramoney) < data.Price then return end
									end
										net.Start("OCRP_Mayor_Choice")
										net.WriteString(data.Name)
										net.SendToServer()
										
										local GUI_Main_Exit = vgui.Create("DButton")
										GUI_Main_Exit:SetParent(GUI_Event_Frame)	
										GUI_Main_Exit:SetSize(20,20)
										GUI_Main_Exit:SetPos(420,5)
										GUI_Main_Exit:SetText("")
										GUI_Main_Exit.Paint = function()
																			surface.SetMaterial(OC_Exit)
																			surface.SetDrawColor(255,255,255,255)
																			surface.DrawTexturedRect(0,0,GUI_Main_Exit:GetWide(),GUI_Main_Exit:GetTall())
																		end
										GUI_Main_Exit.DoClick = function()
																	GUI_Event_Frame:Remove()
																end
									for _,v in pairs(GUI_Choice_Panel:GetItems()) do
										v:Remove()
									end
									if GAMEMODE.OCRP_Economy_Events[event].Ignore then
										GUI_Ignore:Remove()
									end
								end	
		GUI_Choice_Panel:AddItem(GUI_Choice)						
	end
	
	GUI_Event_Frame:SetSize(445 ,230  + GUI_Choice_Panel:GetTall() ) 
	GUI_Event_Frame:Center()
	
	if GAMEMODE.OCRP_Economy_Events[event].Ignore then
		GUI_Event_Frame:SetSize(445 ,260 + GUI_Choice_Panel:GetTall() ) 
		GUI_Event_Frame:Center()						
	end

	
	
end

OCRP_Broadcasts = {}

function GUI_Mayor_Broadcast()
	if LocalPlayer():GetNWBool("Handcuffed") || LocalPlayer():Team() != CLASS_Mayor then return end
	local GUI_Broadcast_Frame = vgui.Create("DFrame")
	GUI_Broadcast_Frame:SetTitle("")
	GUI_Broadcast_Frame:SetSize(400 ,250)
	GUI_Broadcast_Frame:Center()
	GUI_Broadcast_Frame.Paint = function()
								draw.RoundedBox(8,1,1,GUI_Broadcast_Frame:GetWide()-2,GUI_Broadcast_Frame:GetTall()-2,OCRP_Options.Color)
								
								surface.SetTextColor(255,255,255,255)
								surface.SetFont("UiBold")
								local x,y = surface.GetTextSize("Broadcast Menu")
								surface.SetTextPos(45-x/2,11 - y/2)
								surface.DrawText("Broadcast Menu")
							end
							
	GUI_Broadcast_Frame:MakePopup() 
	
	local GUI_Old_Casts = vgui.Create("DListView")
	GUI_Old_Casts:SetParent(GUI_Broadcast_Frame)
	GUI_Old_Casts:SetPos(10, 20)
	GUI_Old_Casts:SetSize(380, 130)
	GUI_Old_Casts:SetMultiSelect(false)
	GUI_Old_Casts:AddColumn("Old Broadcasts") -- Add column
	
	for _,text in pairs(OCRP_Broadcasts) do
		if text then
			GUI_Old_Casts:AddLine(text)
		end
	end

	
	local GUI_Message =  vgui.Create("DTextEntry")
	GUI_Message:SetParent(GUI_Broadcast_Frame)
	GUI_Message:SetPos(10,160)
	GUI_Message:SetSize(380,20)
	GUI_Message:SetText("Add Message here")
	GUI_Message:SetEditable(true)
	
	GUI_Old_Casts.OnClickLine = function(parent, line, isselected) 
		GUI_Message:SetText(line:GetValue(1))
		end
		
	local GUI_Time =  vgui.Create("DNumberWang")
	GUI_Time:SetParent(GUI_Broadcast_Frame)
	GUI_Time:SetPos(10,210)
	GUI_Time:SetSize(130,20)
	GUI_Time:SetDecimals(0)	
	GUI_Time:SetValue(60)
	GUI_Time:SetMin(10)
	GUI_Time:SetMax(120)
	
	local GUI_Duration = vgui.Create("DLabel")
	GUI_Duration:SetParent(GUI_Broadcast_Frame)
	GUI_Duration:SetColor(Color(255,255,255,255))
	GUI_Duration:SetFont("UiBold")
	GUI_Duration:SetText("Duration of Broadcast(Seconds)")
	GUI_Duration:SizeToContents()
	GUI_Duration:SetPos(10,195)
	
	local GUI_Broadcast = vgui.Create("DButton")
	GUI_Broadcast:SetParent(GUI_Broadcast_Frame)
	GUI_Broadcast:SetPos(175,210)
	GUI_Broadcast:SetSize(200,20)
	GUI_Broadcast:SetText("Broadcast")
	
	GUI_Broadcast.Paint = function()
								draw.RoundedBox(8,0,0,GUI_Broadcast:GetWide(),GUI_Broadcast:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(8,1,1,GUI_Broadcast:GetWide()-2,GUI_Broadcast:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
							end	
	GUI_Broadcast.DoClick = function()
									local bool = true
									for _,text in pairs(OCRP_Broadcasts) do
										if text == GUI_Message:GetValue() then
											bool = false
										end 
									end
									if bool then
										table.insert(OCRP_Broadcasts,GUI_Message:GetValue())
										if table.Count(OCRP_Broadcasts) >= 7 then
											table.remove(OCRP_Broadcasts,1)
										end	
									end
									RunConsoleCommand("OCRP_Broadcast",GUI_Message:GetValue(),GUI_Time:GetValue())
									GUI_Broadcast_Frame:Remove()
								end	
end 

function GUI_Mayor_Catalog()
	if LocalPlayer():GetNWBool("Handcuffed") || LocalPlayer():Team() != CLASS_Mayor then return end
	GUI_Catalog_Frame = vgui.Create("DFrame")
	GUI_Catalog_Frame:SetTitle("")
	GUI_Catalog_Frame:SetSize(445 ,500)
	GUI_Catalog_Frame:Center()
	GUI_Catalog_Frame.Paint = function()
								draw.RoundedBox(8,1,1,GUI_Catalog_Frame:GetWide()-2,GUI_Catalog_Frame:GetTall()-2,OCRP_Options.Color)
								
								surface.SetTextColor(255,255,255,255)
								surface.SetFont("UiBold")
								local x,y = surface.GetTextSize("Catalog")
								surface.SetTextPos(45-x/2,11 - y/2)
								surface.DrawText("Catalog")
							end
							
	GUI_Catalog_Frame:MakePopup() 	
	
	local GUI_Catalog_Panel = vgui.Create("DPanelList")
	GUI_Catalog_Panel:SetParent(GUI_Catalog_Frame)
	GUI_Catalog_Panel:SetSize(425,460)
	GUI_Catalog_Panel:EnableHorizontal(1)
	GUI_Catalog_Panel:SetSpacing(2.5)
	GUI_Catalog_Panel:SetPadding(2.5)
	GUI_Catalog_Panel:EnableVerticalScrollbar(true)
	GUI_Catalog_Panel:SetPos(11,30)
	GUI_Catalog_Panel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Catalog_Panel:GetWide(),GUI_Catalog_Panel:GetTall(),Color( 50, 50, 50, 155 ))
								end		
	local Cata_Icon_ent = ents.CreateClientProp("prop_physics")

	Cata_Icon_ent:SetPos(Vector(0,0,0))
	Cata_Icon_ent:Spawn()
	Cata_Icon_ent:Activate()	
	
	for item,data in pairs(GAMEMODE.Mayor_Items) do
		local GUI_Cata_Item_Panel = vgui.Create("DPanelList")
		GUI_Cata_Item_Panel:SetParent(GUI_Catalog_Panel)
			
		GUI_Cata_Item_Panel:SetPos(0,0)
		GUI_Cata_Item_Panel:SetSpacing(5)
		GUI_Cata_Item_Panel:SetSize(100,200)
		GUI_Cata_Item_Panel.Paint = function()
											draw.RoundedBox(8,0,0,GUI_Cata_Item_Panel:GetWide(),GUI_Cata_Item_Panel:GetTall(),Color( 60, 60, 60, 155 ))
										end
		
		local GUI_Cata_Item_Icon = vgui.Create("DModelPanel")
		GUI_Cata_Item_Icon:SetParent(GUI_Cata_Item_Panel)
		GUI_Cata_Item_Icon:SetPos(0,0)
		GUI_Cata_Item_Icon:SetSize(100,100)
			
		GUI_Cata_Item_Icon:SetModel(GAMEMODE.Mayor_Items[item].Model)
			
		Cata_Icon_ent:SetModel(GAMEMODE.Mayor_Items[item].Model)
			
		if GAMEMODE.Mayor_Items[item].Angle != nil then
			GUI_Cata_Item_Icon:GetEntity():SetAngles(GAMEMODE.Mayor_Items[item].Angle)
		end
			
		local center = Cata_Icon_ent:OBBCenter()
		local dist = Cata_Icon_ent:BoundingRadius()*1.2
		GUI_Cata_Item_Icon:SetLookAt(center)
		GUI_Cata_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	
		
		local GUI_Cata_Item_Name = vgui.Create("DLabel")
		GUI_Cata_Item_Name:SetParent(GUI_Cata_Item_Panel)
		GUI_Cata_Item_Name:SetColor(Color(255,255,255,255))
		GUI_Cata_Item_Name:SetFont("UiBold")
		GUI_Cata_Item_Name:SetText(GAMEMODE.Mayor_Items[item].Name)
		GUI_Cata_Item_Name:SizeToContents()
			
		surface.SetFont("UiBold")
		local x,y = surface.GetTextSize(GAMEMODE.Mayor_Items[item].Name)
			
		GUI_Cata_Item_Name:SetPos(50 - x/2,10-y/2)	


			local GUI_Cata_Item_Duration = vgui.Create("DLabel")
			GUI_Cata_Item_Duration:SetParent(GUI_Cata_Item_Panel)
			GUI_Cata_Item_Duration:SetColor(Color(255,255,255,255))
			GUI_Cata_Item_Duration:SetFont("UiBold")
			if GAMEMODE.Mayor_Items[item].Time != nil then
				GUI_Cata_Item_Duration:SetText((GAMEMODE.Mayor_Items[item].Time/60).." minutes")
			else
				GUI_Cata_Item_Duration:SetText("Unlimited Time")
			end
			GUI_Cata_Item_Duration:SizeToContents()
				
			surface.SetFont("UiBold")
			local x,y = surface.GetTextSize((GAMEMODE.Mayor_Items[item].Time/60).." minutes")
			if GAMEMODE.Mayor_Items[item].Time == nil then
				x,y = surface.GetTextSize("Unlimited Time")
			end
			local x,y = surface.GetTextSize((GAMEMODE.Mayor_Items[item].Time/60).." minutes")
				
			GUI_Cata_Item_Duration:SetPos(50 - x/2,50-y/2)

		
		local GUI_Cata_Item_Price = vgui.Create("DLabel")
		GUI_Cata_Item_Price:SetParent(GUI_Cata_Item_Panel)
		if GAMEMODE.CL_MayorMoney >= GAMEMODE.Mayor_Items[item].Price then
			GUI_Cata_Item_Price:SetColor(Color(0,255,0,255))
		else
			GUI_Cata_Item_Price:SetColor(Color(255,0,0,255))
		end
		GUI_Cata_Item_Price:SetFont("UiBold")
		GUI_Cata_Item_Price:SetText("$"..GAMEMODE.Mayor_Items[item].Price)
		GUI_Cata_Item_Price:SizeToContents()
			
		surface.SetFont("UiBold")
		local x,y = surface.GetTextSize(GAMEMODE.Mayor_Items[item].Price)
			
		GUI_Cata_Item_Price:SetPos(50 - x/2,105-y/2)	
		
		local GUI_Cata_Item_Desc = vgui.Create("DLabel")
		GUI_Cata_Item_Desc:SetParent(GUI_Cata_Item_Panel)
		GUI_Cata_Item_Desc:SetColor(Color(255,255,255,255))
		GUI_Cata_Item_Desc:SetFont("UiBold")
		GUI_Cata_Item_Desc:SetText(GAMEMODE.Mayor_Items[item].Desc)
		GUI_Cata_Item_Desc:SetSize(100,50)
		GUI_Cata_Item_Desc:SetWrap(true)
		GUI_Cata_Item_Desc:SetPos(5,110)
		
		local GUI_Cata_Item_Buy = vgui.Create("DButton")
		GUI_Cata_Item_Buy:SetParent(GUI_Cata_Item_Panel)
		GUI_Cata_Item_Buy:SetPos(5,175)
		GUI_Cata_Item_Buy:SetSize(90,20)
		GUI_Cata_Item_Buy:SetText("")
		GUI_Cata_Item_Buy.Paint = function()
										draw.RoundedBox(4,0,0,GUI_Cata_Item_Buy:GetWide(),GUI_Cata_Item_Buy:GetTall(),Color( 60, 60, 60, 155 ))
										draw.RoundedBox(4,1,1,GUI_Cata_Item_Buy:GetWide()-1,GUI_Cata_Item_Buy:GetTall()-1,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
													
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 45 -- x pos
										struc.pos[2] = 10 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.text = "Purchase" -- Text
										struc.font = "UiBold" -- Font
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )
										end
												
		GUI_Cata_Item_Buy.DoClick = function()
			net.Start("OCRP_Mayor_CreateObj")
			net.WriteString(item)
			net.SendToServer()
		end
		
		GUI_Catalog_Panel:AddItem(GUI_Cata_Item_Panel)
	end	
	
	Cata_Icon_ent:Remove()	
end

