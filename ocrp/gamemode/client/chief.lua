GM.CL_Police_Max_Pistol = 16
GM.CL_Police_Max_Buckshot = 8
GM.CL_Police_Max_Ump = 25 

function CL_PoliceUpdate( umsg )
	local pmoney = umsg:ReadLong()
	local pistol = umsg:ReadLong()
	local riot = umsg:ReadLong()
	local ump = umsg:ReadLong()
	GAMEMODE.CL_PoliceMoney =  pmoney
	GAMEMODE.CL_Police_Max_Pistol = pistol
	GAMEMODE.CL_Police_Max_Buckshot = riot
	GAMEMODE.CL_Police_Max_Ump = ump
end
usermessage.Hook('OCRP_PoliceUpdate', CL_PoliceUpdate);

function GUI_ChiefMenu()
	if LocalPlayer():GetNWBool("Handcuffed") || LocalPlayer():Team() != CLASS_CHIEF then return end
	if GUI_Chief_Frame != nil then
		GUI_Chief_Frame:Remove()
	end
	
	GUI_Chief_Frame = vgui.Create("DFrame")
	GUI_Chief_Frame:SetTitle("")
	GUI_Chief_Frame:SetSize(520 ,450)
	GUI_Chief_Frame:Center()
	GUI_Chief_Frame.Paint = function()
	
								--draw.RoundedBox(8,0,0,GUI_Chief_Frame:GetWide(),GUI_Chief_Frame:GetTall(),Color( 60, 60, 60, 255 ))
								draw.RoundedBox(8,1,1,GUI_Chief_Frame:GetWide()-2,GUI_Chief_Frame:GetTall()-2,OCRP_Options.Color)
								
								surface.SetTextColor(255,255,255,255)
								surface.SetFont("UiBold")
								local x,y = surface.GetTextSize("Chief Menu")
								surface.SetTextPos(45-x/2,11 - y/2)
								surface.DrawText("Chief Menu")
							end
	GUI_Chief_Frame:MakePopup()
	GUI_Chief_Frame:ShowCloseButton(false)
								
	local GUI_Main_Exit = vgui.Create("DButton")
	GUI_Main_Exit:SetParent(GUI_Chief_Frame)	
	GUI_Main_Exit:SetSize(20,20)
	GUI_Main_Exit:SetPos(495,5)
	GUI_Main_Exit:SetText("")
	GUI_Main_Exit.Paint = function()
									surface.SetMaterial(OC_Exit)
									surface.SetDrawColor(255,255,255,255)
									surface.DrawTexturedRect(0,0,GUI_Main_Exit:GetWide(),GUI_Main_Exit:GetTall())
								end
	GUI_Main_Exit.DoClick = function()
								GUI_Chief_Frame:Remove()
							end
							
	local GUI_Property_Sheet = vgui.Create("DPropertySheet")
	GUI_Property_Sheet:SetParent(GUI_Chief_Frame)
	GUI_Property_Sheet:SetPos(10,20)
	GUI_Property_Sheet:SetSize(500,444 )
	GUI_Property_Sheet.Paint = function() 
								end	
																						
	GUI_Property_Sheet:AddSheet( "Locker", GUI_Rebuild_Police_Locker(GUI_Chief_Frame) , "gui/silkicons/box", true, true, "Manage the locker" )									
	GUI_Property_Sheet:AddSheet( "Player Management", GUI_Rebuild_Police_Ply(GUI_Chief_Frame) , "gui/silkicons/user", true, true, "Demote/Warrant" )	
	
	for _,panel in pairs(GUI_Property_Sheet.Items) do
		panel.Tab:SetAutoStretchVertical(false)
		panel.Tab:SetSize(50,50)
		panel.Tab.Paint = function() 
							draw.RoundedBox(8,0,0,panel.Tab:GetWide()-4,panel.Tab:GetTall()+10,Color( 60, 60, 60, 155 ))
						end
	end		
														
end

net.Receive("OCRP_ChiefMenu", function(len)
	if LocalPlayer():Team() == CLASS_CHIEF then
		GUI_ChiefMenu()
	end
end)

function GUI_Rebuild_Police_Locker(parent)

	local GUI_Lock_Panel = vgui.Create("DPanel")
	GUI_Lock_Panel:SetParent(parent)
	GUI_Lock_Panel:SetPos(11,22)
	GUI_Lock_Panel:SetSize(500,400)
	GUI_Lock_Panel.Paint = function() 
									draw.RoundedBox(8,0,0,GUI_Lock_Panel:GetWide(),GUI_Lock_Panel:GetTall(),Color( 60, 60, 60, 155 ))	
								end	
								
	local GUI_Max_p228_Ammo_Out = vgui.Create("DNumSlider")
	GUI_Max_p228_Ammo_Out:SetParent(GUI_Lock_Panel)
	GUI_Max_p228_Ammo_Out:SetWide(480)
	GUI_Max_p228_Ammo_Out:SetPos(10,20)
	GUI_Max_p228_Ammo_Out:SetText("Max p228 Ammo per officer:")
	GUI_Max_p228_Ammo_Out:SetMin(8)
	GUI_Max_p228_Ammo_Out:SetValue(GAMEMODE.CL_Police_Max_Pistol)
	GUI_Max_p228_Ammo_Out:SetMax(64)
	GUI_Max_p228_Ammo_Out:SetDecimals(0)
	
	GUI_Max_p228_Ammo_Out.ValueChanged = function()
		net.Start("OCRP_PoliceMax_Update")
		net.WriteString("item_ammo_cop")
		net.WriteInt(math.Round(math.Clamp(math.abs(GUI_Max_p228_Ammo_Out:GetValue()),8,64)), 32)
		net.SendToServer()
		GAMEMODE.CL_Police_Max_Pistol = math.Clamp(tonumber(GUI_Max_p228_Ammo_Out:GetValue()),8,64)
	end

	local GUI_Max_buckshot_Ammo_Out = vgui.Create("DNumSlider")
	GUI_Max_buckshot_Ammo_Out:SetParent(GUI_Lock_Panel)
	GUI_Max_buckshot_Ammo_Out:SetWide(480)
	GUI_Max_buckshot_Ammo_Out:SetPos(10,60)
	GUI_Max_buckshot_Ammo_Out:SetText("Max Shotgun Ammo per officer:")
	GUI_Max_buckshot_Ammo_Out:SetMin(8)
	GUI_Max_buckshot_Ammo_Out:SetValue(GAMEMODE.CL_Police_Max_Buckshot)
	GUI_Max_buckshot_Ammo_Out:SetMax(24)
	GUI_Max_buckshot_Ammo_Out:SetDecimals(0)
	
	GUI_Max_buckshot_Ammo_Out.ValueChanged = function()
		net.Start("OCRP_PoliceMax_Update")
		net.WriteString("item_ammo_riot")
		net.WriteInt(math.Round(math.Clamp(math.abs(GUI_Max_buckshot_Ammo_Out:GetValue()),8,24)), 32)
		net.SendToServer()
		GAMEMODE.CL_Police_Max_Buckshot = math.Clamp(tonumber(GUI_Max_buckshot_Ammo_Out:GetValue()),8,24)
	end

	local GUI_Max_ump_Ammo_Out = vgui.Create("DNumSlider")
	GUI_Max_ump_Ammo_Out:SetParent(GUI_Lock_Panel)
	GUI_Max_ump_Ammo_Out:SetWide(480)
	GUI_Max_ump_Ammo_Out:SetPos(10,100)
	GUI_Max_ump_Ammo_Out:SetText("Max Ump Ammo per officer:")
	GUI_Max_ump_Ammo_Out:SetMin(25)
	GUI_Max_ump_Ammo_Out:SetValue(GAMEMODE.CL_Police_Max_Ump)
	GUI_Max_ump_Ammo_Out:SetMax(125)
	GUI_Max_ump_Ammo_Out:SetDecimals(0)
	
	GUI_Max_ump_Ammo_Out.ValueChanged = function()
		net.Start("OCRP_PoliceMax_Update")
		net.WriteString("item_ammo_ump")
		net.WriteInt(math.Round(math.Clamp(math.abs(GUI_Max_ump_Ammo_Out:GetValue()),25,125)), 32)
		net.SendToServer()
		GAMEMODE.CL_Police_Max_Ump = math.Clamp(tonumber(GUI_Max_ump_Ammo_Out:GetValue()),25,125)
	end	

	local GUI_Economy_Budget = vgui.Create("DLabel")
	GUI_Economy_Budget:SetParent(GUI_Lock_Panel)
	GUI_Economy_Budget:SetColor(Color(255,255,255,255))
	GUI_Economy_Budget:SetFont("UiBold")
	GUI_Economy_Budget:SetText("The police force has a spare $"..(GAMEMODE.CL_PoliceMoney).." to use")
	GUI_Economy_Budget:SetSize(300,30)
	GUI_Economy_Budget:SetWrap(true)
	GUI_Economy_Budget:SetPos(10,140)
	GUI_Economy_Budget.Think = function()
								GUI_Economy_Budget:SetText("The police force has a spare $"..(GAMEMODE.CL_PoliceMoney).." to use")
							end
	
	local GUI_Buy_Label = vgui.Create("DLabel")
	GUI_Buy_Label:SetParent(GUI_Lock_Panel)
	GUI_Buy_Label:SetColor(Color(255,255,255,255))
	GUI_Buy_Label:SetFont("UiBold")
	GUI_Buy_Label:SetText("Purchase items for the police locker below.")
	GUI_Buy_Label:SetPos(10,170)
	GUI_Buy_Label:SizeToContents()
	
	local GUI_Lock_tab_Panel = vgui.Create("DPanelList")
	GUI_Lock_tab_Panel:SetParent(GUI_Lock_Panel)
	GUI_Lock_tab_Panel:SetSize(500,200)
	GUI_Lock_tab_Panel:SetPos(0,190)
	GUI_Lock_tab_Panel:EnableHorizontal(4)
	GUI_Lock_tab_Panel:EnableVerticalScrollbar(true)
	GUI_Lock_tab_Panel:SetSpacing(4)
	GUI_Lock_tab_Panel:SetPadding(4)
	GUI_Lock_tab_Panel.Paint = function()
									--draw.RoundedBox(8,0,0,GUI_Lock_tab_Panel:GetWide(),GUI_Lock_tab_Panel:GetTall(),Color( 50, 50, 50, 155 ))
								end	

	local Inv_Icon_ent = ents.CreateClientProp("prop_physics")

	Inv_Icon_ent:SetPos(Vector(0,0,0))
	Inv_Icon_ent:Spawn()
	Inv_Icon_ent:Activate()	
								
	for _,data in pairs(GAMEMODE.Locker_Items) do
			local GUI_Lock_Item_Panel = vgui.Create("DPanelList")
			GUI_Lock_Item_Panel:SetParent(GUI_Lock_tab_Panel)
			
			GUI_Lock_Item_Panel:SetSize(120,140)
			
			GUI_Lock_Item_Panel:SetPos(0,0)
			GUI_Lock_Item_Panel:SetSpacing(4)
			GUI_Lock_Item_Panel.Paint = function()
											draw.RoundedBox(8,0,0,GUI_Lock_Item_Panel:GetWide(),GUI_Lock_Item_Panel:GetTall(),Color( 60, 60, 60, 155 ))
										end
		
			local GUI_Lock_Item_Icon = vgui.Create("DModelPanel")
			GUI_Lock_Item_Icon:SetParent(GUI_Lock_Item_Panel)
			GUI_Lock_Item_Icon:SetPos(10,10)
			GUI_Lock_Item_Icon:SetSize(100,100)
			
			GUI_Lock_Item_Icon:SetModel(GAMEMODE.OCRP_Items[data.Item].Model)
			
			Inv_Icon_ent:SetModel(GAMEMODE.OCRP_Items[data.Item].Model)
			
			if GAMEMODE.OCRP_Items[data.Item].Angle != nil then
				GUI_Lock_Item_Icon:GetEntity():SetAngles(GAMEMODE.OCRP_Items[data.Item].Angle)
			end
			
			local center = Inv_Icon_ent:OBBCenter()
			local dist = Inv_Icon_ent:BoundingRadius()*1.2
			GUI_Lock_Item_Icon:SetLookAt(center)
			GUI_Lock_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	
		
			local GUI_Lock_Item_Name = vgui.Create("DLabel")
			GUI_Lock_Item_Name:SetColor(Color(255,255,255,255))
			GUI_Lock_Item_Name:SetFont("UiBold")
			GUI_Lock_Item_Name:SetText(GAMEMODE.OCRP_Items[data.Item].Name)
			GUI_Lock_Item_Name:SizeToContents()
			GUI_Lock_Item_Name:SetParent(GUI_Lock_Item_Panel)
			
			surface.SetFont("UiBold")
			local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[data.Item].Name)
			
			GUI_Lock_Item_Name:SetPos(60 - x/2,10-y/2)
				
			local GUI_Lock_Item_Price = vgui.Create("DLabel")
			GUI_Lock_Item_Price:SetParent(GUI_Lock_Item_Panel)
			if GAMEMODE.CL_PoliceMoney >= data.Price then
				GUI_Lock_Item_Price:SetColor(Color(0,255,0,255))
			else
				GUI_Lock_Item_Price:SetColor(Color(255,0,0,255))
			end
			GUI_Lock_Item_Price:SetFont("UiBold")
			GUI_Lock_Item_Price:SetText("$"..data.Price)
			GUI_Lock_Item_Price:SizeToContents()
				
			surface.SetFont("UiBold")
			local x,y = surface.GetTextSize(data.Price)
				
			GUI_Lock_Item_Price:SetPos(60 - x/2,105-y/2)	
		
			local GUI_Lock_Item_Buy = vgui.Create("DButton")
			GUI_Lock_Item_Buy:SetParent(GUI_Lock_Item_Panel)
			GUI_Lock_Item_Buy:SetPos(5,115)
			GUI_Lock_Item_Buy:SetSize(110,20)
			GUI_Lock_Item_Buy:SetText("")
			GUI_Lock_Item_Buy.Paint = function()
											draw.RoundedBox(4,0,0,GUI_Lock_Item_Buy:GetWide(),GUI_Lock_Item_Buy:GetTall(),Color( 60, 60, 60, 155 ))
											draw.RoundedBox(4,1,1,GUI_Lock_Item_Buy:GetWide()-1,GUI_Lock_Item_Buy:GetTall()-1,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
														
											local struc = {}
											struc.pos = {}
											struc.pos[1] = 55 -- x pos
											struc.pos[2] = 10 -- y pos
											struc.color = Color(255,255,255,255) -- Red
											struc.text = "Purchase" -- Text
											struc.font = "UiBold" -- Font
											struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
											struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
											draw.Text( struc )
											end
			GUI_Lock_Item_Buy.DoClick = function()
											if GAMEMODE.CL_PoliceMoney >= data.Price then
												GUI_Amount_Popup_Chief(data.Item)	
											end
										end
			
			GUI_Lock_tab_Panel:AddItem(GUI_Lock_Item_Panel)
			
			
	end
	Inv_Icon_ent:Remove()
	
	
	return GUI_Lock_Panel
end

function GUI_Amount_Popup_Chief(item)
	if GUI_Amount_Frame != nil && GUI_Amount_Frame:IsValid() then GUI_Amount_Frame:Remove() end
	local GUI_Amount_Frame = vgui.Create("DFrame")
	GUI_Amount_Frame:SetSize(200,100)
	GUI_Amount_Frame:Center()
	GUI_Amount_Frame:MakePopup()
	GUI_Amount_Frame:SetTitle("")
	GUI_Amount_Frame.Paint = function()
								draw.RoundedBox(8,1,1,GUI_Amount_Frame:GetWide()-2,GUI_Amount_Frame:GetTall()-2,OCRP_Options.Color)
							end
	local GUI_Amount_slider = vgui.Create("DNumSlider")
	GUI_Amount_slider:SetParent(GUI_Amount_Frame)
	GUI_Amount_slider:SetWide(180)
	GUI_Amount_slider:SetPos(10,25)
	GUI_Amount_slider:SetText("Amount")
	GUI_Amount_slider:SetMin(1)
	GUI_Amount_slider:SetValue(1)
	GUI_Amount_slider:SetMax(math.Round(LocalPlayer().Wallet/GAMEMODE.OCRP_Items[item].Price))
	GUI_Amount_slider:SetDecimals(0)
	
	local GUI_Drop_Button = vgui.Create("DButton")
	GUI_Drop_Button:SetParent(GUI_Amount_Frame)
	GUI_Drop_Button:SetPos(10,70)
	GUI_Drop_Button:SetSize(180,15)
	GUI_Drop_Button:SetText("")
	GUI_Drop_Button.Paint = function()
							draw.RoundedBox(4,0,0,GUI_Drop_Button:GetWide(),GUI_Drop_Button:GetTall(),Color( 60, 60, 60, 155 ))
							draw.RoundedBox(4,1,1,GUI_Drop_Button:GetWide()-2,GUI_Drop_Button:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
											
							local struc = {}
							struc.pos = {}
							struc.pos[1] = 90 -- x pos
							struc.pos[2] = 7 -- y pos
							struc.color = Color(255,255,255,255) -- Red
							struc.text = "Confirm" -- Text
							struc.font = "UiBold" -- Font
							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
							draw.Text( struc )
							end
										
	GUI_Drop_Button.DoClick = function()
								for _,data in pairs(GAMEMODE.Locker_Items) do
									if data.Item == item then
										if GAMEMODE.CL_PoliceMoney >= data.Price then
											net.Start("OCRP_Chief_Supply_Locker")
											net.WriteString(item)
											net.WriteInt(math.Round(GUI_Amount_slider:GetValue()), 32)
											net.SendToServer()
										end
									end
								end
								GUI_Amount_Frame:Remove()
							end
end

function GUI_Rebuild_Police_Ply(parent)
	local GUI_Ply_Panel = vgui.Create("DPanel")
	GUI_Ply_Panel:SetParent(parent)
	GUI_Ply_Panel:SetPos(11,22)
	GUI_Ply_Panel:SetSize(500,400)
	GUI_Ply_Panel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Ply_Panel:GetWide(),GUI_Ply_Panel:GetTall(),Color( 60, 60, 60, 155 ))		
								end	
	local GUI_Police_List = vgui.Create("DListView")
	GUI_Police_List:SetParent(GUI_Ply_Panel)
	GUI_Police_List:SetPos(10, 30)
	GUI_Police_List:SetSize(150, 270)
	GUI_Police_List:SetMultiSelect(false)
	GUI_Police_List:AddColumn("Police Officer Name") -- Add column
	for _,ply in pairs(player.GetAll()) do
		if ply != LocalPlayer() then 
			if ply:Team() == CLASS_POLICE || ply:Team() == CLASS_SWAT then
				GUI_Police_List:AddLine(ply:Nick())
			end
		end 
	end
	GUI_Police_List.OnRowSelected = function() 
		local GUI_Player_Options = DermaMenu()
		GUI_Player_Options:SetPos(gui.MousePos())
		GUI_Player_Options:AddOption("Search Warrant : "..GUI_Police_List:GetSelected()[1]:GetValue(1),function()
			net.Start("OCRP_WarrantPlayer")
			net.WriteString(GUI_Police_List:GetSelected()[1]:GetValue(1))
			net.WriteInt(1,32)
            net.SendToServer()
		end)
		GUI_Player_Options:AddOption("Arrest Warrant : "..GUI_Police_List:GetSelected()[1]:GetValue(1),function()
			net.Start("OCRP_WarrantPlayer")
			net.WriteString(GUI_Police_List:GetSelected()[1]:GetValue(1))
			net.WriteInt(2,32)
            net.SendToServer()
		end)
		GUI_Player_Options:AddOption("Remove all Warrants",function()
			net.Start("OCRP_WarrantPlayer")
			net.WriteString(GUI_Police_List:GetSelected()[1]:GetValue(1))
			net.WriteInt(0,32)
            net.SendToServer()
		end)
		GUI_Player_Options:AddOption("Demote "..GUI_Police_List:GetSelected()[1]:GetValue(1),function()
			net.Start("OCRP_DemotePlayer")
			net.WriteString(GUI_Police_List:GetSelected()[1]:GetValue(1))
			net.SendToServer()
		end)
		GUI_Player_Options:AddOption("Upgrade to SWAT - $50 ",function()
			net.Start("OCRP_Swat_Ask")
			net.WriteString(GUI_Police_List:GetSelected()[1]:GetValue(1))
			net.SendToServer()
		end)

		GUI_Player_Options:AddOption("Cancel",function() end)
		GUI_Player_Options:Open()
	end
	
	local GUI_Citizen_List = vgui.Create("DListView")
	GUI_Citizen_List:SetParent(GUI_Ply_Panel)
	GUI_Citizen_List:SetPos(180, 30)
	GUI_Citizen_List:SetSize(300, 270)
	GUI_Citizen_List:SetMultiSelect(false)
	GUI_Citizen_List:AddColumn("Citizen Name") -- Add column
	GUI_Citizen_List:AddColumn("Warrant Type")
	for _,ply in pairs(player.GetAll()) do
		if ply != LocalPlayer() then 
			local status = "Citizen"
			if ply:Team() == CLASS_CITIZEN then
				local Warranted = "None"
				if ply:GetNWInt("Warrant") == 1 then
					Warranted = "Search Warrant"
				elseif ply:GetNWInt("Warrant") == 1 then
					Warranted = "Arrest Warrant"
				end
				GUI_Citizen_List:AddLine(ply:Nick(),Warranted)
			end
		end 
	end				
	
	GUI_Citizen_List.OnRowSelected = function() 
		local GUI_Player_Options = DermaMenu()
		GUI_Player_Options:SetPos(gui.MousePos())
		GUI_Player_Options:AddOption("Search Warrant : "..GUI_Citizen_List:GetSelected()[1]:GetValue(1),function()
			net.Start("OCRP_WarrantPlayer")
			net.WriteString(GUI_Citizen_List:GetSelected()[1]:GetValue(1))
			net.WriteInt(1,32)
		end)
		GUI_Player_Options:AddOption("Arrest Warrant : "..GUI_Citizen_List:GetSelected()[1]:GetValue(1),function()
			net.Start("OCRP_WarrantPlayer")
			net.WriteString(GUI_Citizen_List:GetSelected()[1]:GetValue(1))
			net.WriteInt(2,32)
		end)
		GUI_Player_Options:AddOption("Remove all Warrants",function()
			net.Start("OCRP_WarrantPlayer")
			net.WriteString(GUI_Citizen_List:GetSelected()[1]:GetValue(1))
			net.WriteInt(0,32)
		end)
		GUI_Player_Options:AddOption("Cancel",function() end)
		GUI_Player_Options:Open()
	end

	local GUI_Economy_Budget = vgui.Create("DLabel")
	GUI_Economy_Budget:SetParent(GUI_Ply_Panel)
	GUI_Economy_Budget:SetColor(Color(255,255,255,255))
	GUI_Economy_Budget:SetFont("UiBold")
	GUI_Economy_Budget:SetText("The police force has a spare $"..(GAMEMODE.CL_PoliceMoney).." to use")
	GUI_Economy_Budget:SetSize(300,30)
	GUI_Economy_Budget:SetWrap(true)
	GUI_Economy_Budget:SetPos(10,330)
	GUI_Economy_Budget.Think = function()
								GUI_Economy_Budget:SetText("The police force has a spare $"..(GAMEMODE.CL_PoliceMoney).." to use")
							end
	
	local GUI_Catalog = vgui.Create("DButton")
	GUI_Catalog:SetParent(GUI_Ply_Panel)
	GUI_Catalog:SetPos(10,360)
	GUI_Catalog:SetSize(480,30)
	GUI_Catalog:SetText("Open Shopping Catalog")
	
	GUI_Catalog.Paint = function()
								draw.RoundedBox(8,0,0,GUI_Catalog:GetWide(),GUI_Catalog:GetTall(),Color( 60, 60, 60, 155 ))
								draw.RoundedBox(8,1,1,GUI_Catalog:GetWide()-2,GUI_Catalog:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
							end	
	GUI_Catalog.DoClick = function()
									GUI_Chief_Catalog()
								end									
	return GUI_Ply_Panel						
end

function GUI_Chief_Catalog()
	if LocalPlayer():GetNWBool("Handcuffed") || LocalPlayer():Team() != CLASS_CHIEF then return end
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
	GUI_Catalog_Panel:SetPos(11,30)
	GUI_Catalog_Panel:EnableVerticalScrollbar(true)
	GUI_Catalog_Panel.Paint = function()
									draw.RoundedBox(8,0,0,GUI_Catalog_Panel:GetWide(),GUI_Catalog_Panel:GetTall(),Color( 50, 50, 50, 155 ))
								end		
	local Cata_Icon_ent = ents.CreateClientProp("prop_physics")

	Cata_Icon_ent:SetPos(Vector(0,0,0))
	Cata_Icon_ent:Spawn()
	Cata_Icon_ent:Activate()	
	
	for item,data in pairs(GAMEMODE.Chief_Items) do
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
			
		GUI_Cata_Item_Icon:SetModel(GAMEMODE.Chief_Items[item].Model)
			
		Cata_Icon_ent:SetModel(GAMEMODE.Chief_Items[item].Model)
			
		if GAMEMODE.Chief_Items[item].Angle != nil then
			GUI_Cata_Item_Icon:GetEntity():SetAngles(GAMEMODE.Chief_Items[item].Angle)
		end
			
		local center = Cata_Icon_ent:OBBCenter()
		local dist = Cata_Icon_ent:BoundingRadius()*1.2
		GUI_Cata_Item_Icon:SetLookAt(center)
		GUI_Cata_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	
		
		local GUI_Cata_Item_Name = vgui.Create("DLabel")
		GUI_Cata_Item_Name:SetParent(GUI_Cata_Item_Panel)
		GUI_Cata_Item_Name:SetColor(Color(255,255,255,255))
		GUI_Cata_Item_Name:SetFont("UiBold")
		GUI_Cata_Item_Name:SetText(GAMEMODE.Chief_Items[item].Name)
		GUI_Cata_Item_Name:SizeToContents()
			
		surface.SetFont("UiBold")
		local x,y = surface.GetTextSize(GAMEMODE.Chief_Items[item].Name)
			
		GUI_Cata_Item_Name:SetPos(50 - x/2,10-y/2)	


			local GUI_Cata_Item_Duration = vgui.Create("DLabel")
			GUI_Cata_Item_Duration:SetParent(GUI_Cata_Item_Panel)
			GUI_Cata_Item_Duration:SetColor(Color(255,255,255,255))
			GUI_Cata_Item_Duration:SetFont("UiBold")
			if GAMEMODE.Chief_Items[item].Time != nil then
				GUI_Cata_Item_Duration:SetText((GAMEMODE.Chief_Items[item].Time/60).." minutes")
			else
				GUI_Cata_Item_Duration:SetText("Unlimited Time")
			end
			GUI_Cata_Item_Duration:SizeToContents()
				
			surface.SetFont("UiBold")
			local x,y = surface.GetTextSize((GAMEMODE.Chief_Items[item].Time/60).." minutes")
			if GAMEMODE.Chief_Items[item].Time == nil then
				x,y = surface.GetTextSize("Unlimited Time")
			end
			local x,y = surface.GetTextSize((GAMEMODE.Chief_Items[item].Time/60).." minutes")
				
			GUI_Cata_Item_Duration:SetPos(50 - x/2,50-y/2)

		
		local GUI_Cata_Item_Price = vgui.Create("DLabel")
		GUI_Cata_Item_Price:SetParent(GUI_Cata_Item_Panel)
		if GAMEMODE.CL_PoliceMoney >= GAMEMODE.Chief_Items[item].Price then
			GUI_Cata_Item_Price:SetColor(Color(0,255,0,255))
		else
			GUI_Cata_Item_Price:SetColor(Color(255,0,0,255))
		end
		GUI_Cata_Item_Price:SetFont("UiBold")
		GUI_Cata_Item_Price:SetText("$"..GAMEMODE.Chief_Items[item].Price)
		GUI_Cata_Item_Price:SizeToContents()
			
		surface.SetFont("UiBold")
		local x,y = surface.GetTextSize(GAMEMODE.Chief_Items[item].Price)
			
		GUI_Cata_Item_Price:SetPos(50 - x/2,105-y/2)	
		
		local GUI_Cata_Item_Desc = vgui.Create("DLabel")
		GUI_Cata_Item_Desc:SetParent(GUI_Cata_Item_Panel)
		GUI_Cata_Item_Desc:SetColor(Color(255,255,255,255))
		GUI_Cata_Item_Desc:SetFont("UiBold")
		GUI_Cata_Item_Desc:SetText(GAMEMODE.Chief_Items[item].Desc)
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
										net.Start("OCRP_Chief_CreateObj")
										net.WriteString(item)
										net.SendToServer()
									end
		
		GUI_Catalog_Panel:AddItem(GUI_Cata_Item_Panel)
	end	
	
	Cata_Icon_ent:Remove()	
end

function CL_AskSwat( umsg )
	GUI_AskSwat()
end
usermessage.Hook('OCRP_AskSwat', CL_AskSwat);

function GUI_AskSwat()
	local GUI_Ask_Frame = vgui.Create("DFrame")
	GUI_Ask_Frame:SetTitle("")
	GUI_Ask_Frame:SetSize(260 ,70)
	GUI_Ask_Frame:Center()
	GUI_Ask_Frame.Paint = function()
								draw.RoundedBox(8,1,1,GUI_Ask_Frame:GetWide()-2,GUI_Ask_Frame:GetTall()-2,OCRP_Options.Color)
							end
	GUI_Ask_Frame:MakePopup()
	GUI_Ask_Frame:ShowCloseButton(false)
	
	local GUI_Ask  = vgui.Create("DLabel")
	GUI_Ask:SetParent(GUI_Ask_Frame) 
	GUI_Ask:SetFont("UiBold")
	GUI_Ask:SetText("You have been offered to be promoted to SWAT for 30 minutes, Will you accept?")
	GUI_Ask:SetPos(5,5)
	GUI_Ask:SetColor(Color(255,255,255,255))
	GUI_Ask:SetSize(250,30)
	GUI_Ask:SetWrap(true)
	
	local GUI_Ask_Search = vgui.Create("DButton")
	GUI_Ask_Search:SetParent(GUI_Ask_Frame)	
	GUI_Ask_Search:SetSize(120,20)
	GUI_Ask_Search:SetPos(5,40)
	GUI_Ask_Search:SetText("Yes")
	GUI_Ask_Search.Paint = function() 
			draw.RoundedBox(8,0,0,GUI_Ask_Search:GetWide(),GUI_Ask_Search:GetTall(),Color( 60, 60, 60, 155 ))
			draw.RoundedBox(8,1,1,GUI_Ask_Search:GetWide()-2,GUI_Ask_Search:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))	
							end
	
	local GUI_Ask_Exit = vgui.Create("DButton")
	GUI_Ask_Exit:SetParent(GUI_Ask_Frame)	
	GUI_Ask_Exit:SetSize(120,20)
	GUI_Ask_Exit:SetPos(130,40)
	GUI_Ask_Exit:SetText("No")
	GUI_Ask_Exit.Paint = function() 
			draw.RoundedBox(8,0,0,GUI_Ask_Exit:GetWide(),GUI_Ask_Exit:GetTall(),Color( 60, 60, 60, 155 ))
			draw.RoundedBox(8,1,1,GUI_Ask_Exit:GetWide()-2,GUI_Ask_Exit:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
			end
	GUI_Ask_Exit.DoClick = function()
		net.Start("OCRP_Swat_Reply")
		net.WriteString("false")
		net.WriteInt(0, 32)
		net.SendToServer()
		GUI_Ask_Frame:Remove()
	end	
	GUI_Ask_Search.DoClick = function()
							--	RunConsoleCommand("OCRP_SearchReply",obj:EntIndex(),requester:EntIndex(),"true")
							--	GUI_Ask_Frame:Remove()
								GUI_Ask_Search:Remove()
								GUI_Ask_Exit:Remove()
								GUI_Ask:SetText("Select your weapon")
								GUI_Ask_Frame:SetSize(260,125)
								
								local SWAT_Icon_ent = ents.CreateClientProp("prop_physics")

								SWAT_Icon_ent:SetPos(Vector(0,0,0))
								SWAT_Icon_ent:Spawn()
								SWAT_Icon_ent:Activate()	
									
									local GUI_SWAT_MP5_Icon = vgui.Create("DModelPanel")
									GUI_SWAT_MP5_Icon:SetParent(GUI_Ask_Frame)
									GUI_SWAT_MP5_Icon:SetPos(130,15)
									GUI_SWAT_MP5_Icon:SetSize(100,100)
										
									GUI_SWAT_MP5_Icon:SetModel("models/weapons/w_smg_ump45.mdl")
										
									SWAT_Icon_ent:SetModel("models/weapons/w_smg_ump45.mdl")
										
									local center = SWAT_Icon_ent:OBBCenter()
									local dist = SWAT_Icon_ent:BoundingRadius()*0.8
									GUI_SWAT_MP5_Icon:SetLookAt(center)
									GUI_SWAT_MP5_Icon:SetCamPos(center+Vector(dist,dist,0))	
									GUI_SWAT_MP5_Icon.DoClick = function()
										GUI_Ask_Frame:Remove()
										net.Start("OCRP_Swat_Reply")
										net.WriteString("true")
										net.WriteInt(1, 32)
										net.SendToServer()
									end
									local GUI_SWAT_Riot_Icon = vgui.Create("DModelPanel")
									GUI_SWAT_Riot_Icon:SetParent(GUI_Ask_Frame)
									GUI_SWAT_Riot_Icon:SetPos(15,15)
									GUI_SWAT_Riot_Icon:SetSize(100,100)
										
									GUI_SWAT_Riot_Icon:SetModel("models/weapons/w_shot_xm1014.mdl")
										
									SWAT_Icon_ent:SetModel("models/weapons/w_shot_xm1014.mdl")
									
									local center = SWAT_Icon_ent:OBBCenter()
									local dist = SWAT_Icon_ent:BoundingRadius()*0.8
									GUI_SWAT_Riot_Icon:SetLookAt(center)
									GUI_SWAT_Riot_Icon:SetCamPos(center+Vector(dist,dist,0))
									GUI_SWAT_Riot_Icon.DoClick = function()
										net.Start("OCRP_Swat_Reply")
										net.WriteString("true")
										net.WriteInt(0, 32)
										net.SendToServer()
										GUI_Ask_Frame:Remove()
									end
								SWAT_Icon_ent:Remove()								
								
							end
end

