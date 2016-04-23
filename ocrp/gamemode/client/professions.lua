local vgui = vgui
local surface = surface
local draw = draw

function CL_UpdateProf( umsg )
	local Prof = umsg:ReadString()
	local Exp = umsg:ReadLong()
	local ExpM = umsg:ReadLong()
	local ExpP = umsg:ReadLong()

	if Prof == "Pro_Crafting" then
		OCRP_Professions[Prof] = {Exp = {Skill = Exp,Mechanical = ExpM,Practical = ExpP,}}
	else
		OCRP_Professions[Prof] = {Exp = tonumber(Exp)}
	end
	
	if GUI_Main_Frame != nil && GUI_Main_Frame:IsValid() then
		GUI_Prof_Panel_List:Remove()
		GUI_Rebuild_Professions(GUI_Prof_tab_Panel)
	end
end
usermessage.Hook('OCRP_UpdateProf', CL_UpdateProf);

local OC_1 = Material("gui/OCRP/OCRP_Orange")

function GUI_Rebuild_Professions(parent)

		GUI_Prof_Panel_List = vgui.Create("DPanelList")
		GUI_Prof_Panel_List:SetParent(parent)
		GUI_Prof_Panel_List:SetSize(746,480)
		GUI_Prof_Panel_List:SetPos(0,0)
		GUI_Prof_Panel_List.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Prof_Panel_List:GetWide(),GUI_Prof_Panel_List:GetTall(),Color( 60, 60, 60, 155 ))
									end
		GUI_Prof_Panel_List:SetPadding(7.5)
		GUI_Prof_Panel_List:SetSpacing(5)
		GUI_Prof_Panel_List:EnableHorizontal(3)
		GUI_Prof_Panel_List:EnableVerticalScrollbar(true)

							
	local activeprof = nil
	for Prof,data in pairs(OCRP_Professions) do
		if data.Active then
			activeprof = tostring(Prof)
		end
	end
	
	if activeprof == nil then
	
		local GUI_Prof_Name = vgui.Create("DLabel")
		GUI_Prof_Name:SetColor(Color(255,255,255,255))
		
		surface.SetFont("Trebuchet22")
		local x,y = surface.GetTextSize("Select A Profession")
		
		GUI_Prof_Name:SetPos(373 - x/2,25 - y/2)
		GUI_Prof_Name:SetFont("Trebuchet22")
		GUI_Prof_Name:SetText("Select A Profession")
		GUI_Prof_Name:SizeToContents()
		GUI_Prof_Name:SetParent(GUI_Prof_Panel_List)
		
		local GUI_Prof_Desc = vgui.Create("DLabel")
		GUI_Prof_Desc:SetColor(Color(255,255,255,255))
		
		surface.SetFont("Trebuchet22")
		local x,y = surface.GetTextSize("A profession allows your character to get increased perks, Click on one to select it.")
		
		GUI_Prof_Desc:SetPos(373 - x/2,420 - y/2)
		GUI_Prof_Desc:SetFont("Trebuchet22")
		GUI_Prof_Desc:SetText("A profession allows your character to get increased perks, Click on one to select it.")
		GUI_Prof_Desc:SizeToContents()
		GUI_Prof_Desc:SetParent(GUI_Prof_Panel_List)
		
		local numb = 60
		
		for Prof,data in pairs(OCRP_Professions || {} ) do	
		
			local GUI_Prof_Bar = vgui.Create("DButton")
			GUI_Prof_Bar:SetParent(GUI_Prof_Panel_List)
			GUI_Prof_Bar:SetSize(700,40)
			GUI_Prof_Bar:SetPos(23,numb)
			GUI_Prof_Bar:SetText("")
			GUI_Prof_Bar:SetToolTip(GAMEMODE.OCRP_Professions[Prof].Desc)
			GUI_Prof_Bar.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Prof_Bar:GetWide(),GUI_Prof_Bar:GetTall(),Color( 55, 55, 55, 255 ))
										draw.RoundedBox(8,1,1,GUI_Prof_Bar:GetWide()-2,GUI_Prof_Bar:GetTall()-2,Color( 180, 90, 0, 155 ))
										
										
											if Prof == "Pro_Crafting" then
												local totalxp = data.Exp.Mechanical + data.Exp.Practical
																					
												if totalxp > 0 then
													draw.RoundedBox(8,1,1,(GUI_Prof_Bar:GetWide()-2)*(totalxp/1000),(GUI_Prof_Bar:GetTall()-2),OCRP_Options.Color)
												end
											
											else
											
												if data.Exp > 0 then
													draw.RoundedBox(8,1,1,(GUI_Prof_Bar:GetWide()-2)*(data.Exp/1000),(GUI_Prof_Bar:GetTall()-2),OCRP_Options.Color)
												end									
										end
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 350 -- x pos
										struc.pos[2] = 10 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.font = "UiBold" -- Font
										struc.text = GAMEMODE.OCRP_Professions[Prof].Name -- Text
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )

										local struc = {}
										struc.pos = {}
										struc.pos[1] = 350 -- x pos
										struc.pos[2] = 30 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.font = "UiBold" -- Font
										struc.text = "0/1000" -- Text
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )	
										
									end
				GUI_Prof_Bar.DoClick = function()
											RunConsoleCommand("OCRP_SetProf",Prof)
										end
										
			numb = numb + 60
		end
		return GUI_Prof_Panel_List
	elseif activeprof == "Pro_Crafting" then

		local GUI_Prof_Name = vgui.Create("DLabel")
		GUI_Prof_Name:SetColor(Color(255,255,255,255))
		
		surface.SetFont("Trebuchet22")
		local x,y = surface.GetTextSize("Professional "..GAMEMODE.OCRP_Professions[activeprof].Name)
		
		GUI_Prof_Name:SetPos(373 - x/2,25 - y/2)
		GUI_Prof_Name:SetFont("Trebuchet22")
		GUI_Prof_Name:SetText("Professional "..GAMEMODE.OCRP_Professions[activeprof].Name)
		GUI_Prof_Name:SizeToContents()
		GUI_Prof_Name:SetParent(GUI_Prof_Panel_List)
	
													local GUI_Prof_Crafting_List = vgui.Create("DPanelList")
													GUI_Prof_Crafting_List:SetParent(GUI_Prof_Panel_List)
													GUI_Prof_Crafting_List:SetSize(702,310)
													GUI_Prof_Crafting_List:SetPos(22,80)
													GUI_Prof_Crafting_List.Paint = function()
																					draw.RoundedBox(8,0,0,GUI_Prof_Crafting_List:GetWide(),GUI_Prof_Crafting_List:GetTall(),Color( 60, 60, 60, 155 ))
																					
																					local struc = {}
																					struc.pos = {}
																					struc.pos[1] = 300 -- x pos
																					struc.pos[2] = 200 -- y pos
																					struc.color = Color(155,155,155,155) 
																					struc.font = "UiBold" -- Font
																					struc.text = "Earn Experiance to unlock new items" -- Text
																					struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
																					struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
																					draw.Text( struc )
																					
																				end
													GUI_Prof_Crafting_List:SetPadding(5)
													GUI_Prof_Crafting_List:SetSpacing(5)
													GUI_Prof_Crafting_List:EnableHorizontal(3)
													GUI_Prof_Crafting_List:EnableVerticalScrollbar(true)
												
												local WidthSize = 100
												
												local Craft_Icon_ent = ents.CreateClientProp("prop_physics")

												Craft_Icon_ent:SetPos(Vector(0,0,0))
												Craft_Icon_ent:Spawn()
												Craft_Icon_ent:Activate()	
												
												for _,data in pairs(GAMEMODE.OCRP_Professions["Pro_Crafting"].Recipies) do
												
														local GUI_Craft_Item_Panel = vgui.Create("DPanel")
														GUI_Craft_Item_Panel:SetParent(GUI_Prof_Crafting_List)
														GUI_Craft_Item_Panel:SetSize(220,150)
														GUI_Craft_Item_Panel:SetPos(0,0)
														GUI_Craft_Item_Panel.Paint = function()
																					draw.RoundedBox(8,0,0,GUI_Craft_Item_Panel:GetWide(),GUI_Craft_Item_Panel:GetTall(),Color( 60, 60, 60, 155 ))
																					
																	
																					end
													
														local GUI_Craft_Item_Icon = vgui.Create("DModelPanel")
														GUI_Craft_Item_Icon:SetParent(GUI_Craft_Item_Panel)
														GUI_Craft_Item_Icon:SetPos(10,10)
														GUI_Craft_Item_Icon:SetSize(WidthSize,WidthSize)
														
														GUI_Craft_Item_Icon:SetModel(GAMEMODE.OCRP_Items[data.Item].Model)
														
														Craft_Icon_ent:SetModel(GAMEMODE.OCRP_Items[data.Item].Model)
														
														if GAMEMODE.OCRP_Items[data.Item].Angle != nil then
															GUI_Craft_Item_Icon:GetEntity():SetAngles(GAMEMODE.OCRP_Items[data.Item].Angle)
														end
														
														local center = Craft_Icon_ent:OBBCenter()
														local dist = Craft_Icon_ent:BoundingRadius()*1.2
														GUI_Craft_Item_Icon:SetLookAt(center)
														GUI_Craft_Item_Icon:SetCamPos(center+Vector(dist,dist,0))	
													
														local GUI_Craft_Item_Name = vgui.Create("DLabel")
														GUI_Craft_Item_Name:SetColor(Color(255,255,255,255))
														GUI_Craft_Item_Name:SetFont("UiBold")
														GUI_Craft_Item_Name:SetText(GAMEMODE.OCRP_Items[data.Item].Name)
														GUI_Craft_Item_Name:SizeToContents()
														GUI_Craft_Item_Name:SetParent(GUI_Craft_Item_Panel)
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[data.Item].Name)
														
														GUI_Craft_Item_Name:SetPos(60 - x/2,10-y/2)
														
														local GUI_Craft_Item_Desc = vgui.Create("DLabel")
														GUI_Craft_Item_Desc:SetColor(Color(255,255,255,255))
														GUI_Craft_Item_Desc:SetFont("UiBold")
														GUI_Craft_Item_Desc:SetText(GAMEMODE.OCRP_Items[data.Item].Desc)
														GUI_Craft_Item_Desc:SizeToContents()
														GUI_Craft_Item_Desc:SetParent(GUI_Craft_Item_Panel)
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[data.Item].Desc)
														
														GUI_Craft_Item_Desc:SetPos(60 - x/2,100-y/2)
														
														if data.Amount != nil && data.Amount > 1 then
															local GUI_Craft_Item_Amt = vgui.Create("DLabel")
															GUI_Craft_Item_Amt:SetColor(Color(255,255,255,255))
															GUI_Craft_Item_Amt:SetFont("UiBold")
															GUI_Craft_Item_Amt:SetText("x"..data.Amount)
															GUI_Craft_Item_Amt:SizeToContents()
															GUI_Craft_Item_Amt:SetParent(GUI_Craft_Item_Panel)
															
															surface.SetFont("UiBold")
															local x,y = surface.GetTextSize("x"..data.Amount)
															
															GUI_Craft_Item_Amt:SetPos(60 - x/2,25-y/2)
														end

														if data.HeatSource != nil && data.HeatSource then
															local GUI_Craft_Heat = vgui.Create("DLabel")
															GUI_Craft_Heat:SetColor(Color(255,100,100,255))
															GUI_Craft_Heat:SetFont("UiBold")
															GUI_Craft_Heat:SetText("Furnace Required")
															GUI_Craft_Heat:SizeToContents()
															GUI_Craft_Heat:SetParent(GUI_Craft_Item_Panel)
															
															surface.SetFont("UiBold")
															local x,y = surface.GetTextSize("Furnace Required")
															
															GUI_Craft_Heat:SetPos(55 - x/2,30-y/2)
														elseif data.WaterSource != nil && data.WaterSource then
															local GUI_Craft_Water = vgui.Create("DLabel")
															GUI_Craft_Water:SetColor(Color(100,100,255,255))
															GUI_Craft_Water:SetFont("UiBold")
															GUI_Craft_Water:SetText("Sink Required")
															GUI_Craft_Water:SizeToContents()
															GUI_Craft_Water:SetParent(GUI_Craft_Item_Panel)
															
															surface.SetFont("UiBold")
															local x,y = surface.GetTextSize("Water Source Required")
															
															GUI_Craft_Water:SetPos(55 - x/2,50-y/2)		
														elseif data.Explosive != nil && data.Explosive then
															local GUI_Craft_Explosive = vgui.Create("DLabel")
															GUI_Craft_Explosive:SetColor(Color(255,150,90,255))
															GUI_Craft_Explosive:SetFont("UiBold")
															GUI_Craft_Explosive:SetText("WARNING Explosive")
															GUI_Craft_Explosive:SizeToContents()
															GUI_Craft_Explosive:SetParent(GUI_Craft_Item_Panel)
															
															surface.SetFont("UiBold")
															local x,y = surface.GetTextSize("WARNING Explosive")
															
															GUI_Craft_Explosive:SetPos(55 - x/2,50-y/2)																
														end
														
														local GUI_Label_Requirements = vgui.Create("DLabel")
														GUI_Label_Requirements:SetColor(Color(255,255,255,255))
														GUI_Label_Requirements:SetFont("UiBold")
														GUI_Label_Requirements:SetText("Requirements : ")
														GUI_Label_Requirements:SizeToContents()
														GUI_Label_Requirements:SetParent(GUI_Craft_Item_Panel)
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize("Requirements : ")
														
														GUI_Label_Requirements:SetPos(165 - x/2,10-y/2)
														
														local Number = 30
														
														for k,reqitem in pairs(data.Requirements) do
															
															local GUI_Item_RequireMent = vgui.Create("DLabel")
															GUI_Item_RequireMent:SetColor(Color(255,255,255,255))
															GUI_Item_RequireMent:SetFont("UiBold")
															GUI_Item_RequireMent:SetText(GAMEMODE.OCRP_Items[reqitem].Name)
															GUI_Item_RequireMent:SizeToContents()
															GUI_Item_RequireMent:SetParent(GUI_Craft_Item_Panel)
															
															surface.SetFont("UiBold")
															local x,y = surface.GetTextSize(GAMEMODE.OCRP_Items[reqitem].Name)
															
															GUI_Item_RequireMent:SetPos(165 - x/2,Number-y/2)								
															
															Number = Number + 13
															
														end
														
															local GUI_Craft_Item_Craft = vgui.Create("DButton")
															GUI_Craft_Item_Craft:SetParent(GUI_Craft_Item_Panel)
															GUI_Craft_Item_Craft:SetPos(5,120)
															GUI_Craft_Item_Craft:SetSize(210,20)
															GUI_Craft_Item_Craft:SetText("")
															GUI_Craft_Item_Craft.Paint = function()																		
																																				if OCRP_Professions[activeprof].Exp.Skill >= data.XPRequired.Skill && OCRP_Professions[activeprof].Exp.Mechanical >= data.XPRequired.Mechanical && OCRP_Professions[activeprof].Exp.Practical >= data.XPRequired.Practical then 

																							draw.RoundedBox(8,0,0,GUI_Craft_Item_Craft:GetWide(),GUI_Craft_Item_Craft:GetTall(),Color( 60, 60, 60, 155 ))
																							draw.RoundedBox(8,1,1,GUI_Craft_Item_Craft:GetWide()-2,GUI_Craft_Item_Craft:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
					
																																				
																							local struc = {}
																							struc.pos = {}
																							struc.pos[1] = 105 -- x pos
																							struc.pos[2] = 10 -- y pos
																							struc.color = Color(255,255,255,255) -- Red
																							struc.font = "UiBold" -- Font
																							struc.text = "Craft" -- Text
																							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
																							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
																							draw.Text( struc )
																							
																							local struc = {}
																							struc.pos = {}
																							struc.pos[1] = 150 -- x pos
																							struc.pos[2] = 10 -- y pos
																							struc.color = Color( 255, 255, 30, 255 ) -- Red
																							struc.font = "UiBold" -- Font
																							struc.text = "+"..data.XPOnDoing.Skill -- Text
																							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
																							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
																							draw.Text( struc )
																							
																							local struc = {}
																							struc.pos = {}
																							struc.pos[1] = 170 -- x pos
																							struc.pos[2] = 10 -- y pos
																							struc.color = Color( 30, 255, 255, 255 ) -- Red
																							struc.font = "UiBold" -- Font
																							struc.text = "+"..data.XPOnDoing.Mechanical -- Text
																							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
																							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
																							draw.Text( struc )
																							
																							
																							local struc = {}
																							struc.pos = {}
																							struc.pos[1] = 190 -- x pos
																							struc.pos[2] = 10 -- y pos
																							struc.color = Color( 250, 160, 0, 255 ) -- Red
																							struc.font = "UiBold" -- Font
																							struc.text = "+"..data.XPOnDoing.Practical -- 
																							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
																							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
																							draw.Text( struc )																							
																							
else
																							local struc = {}
																							struc.pos = {}
																							struc.pos[1] = 40 -- x pos
																							struc.pos[2] = 10 -- y pos
																							struc.color = Color( 255, 255, 30, 155 ) -- Red
																							struc.font = "UiBold" -- Font
																							struc.text = data.XPRequired.Skill.." Required" -- Text
																							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
																							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
																							draw.Text( struc )
																							
																							local struc = {}
																							struc.pos = {}
																							struc.pos[1] = 110 -- x pos
																							struc.pos[2] = 10 -- y pos
																							struc.color = Color( 30, 155, 155, 155 ) -- Red
																							struc.font = "UiBold" -- Font
																							struc.text = data.XPRequired.Mechanical.." Required" -- Text
																							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
																							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
																							draw.Text( struc )
																							
																							
																							local struc = {}
																							struc.pos = {}
																							struc.pos[1] = 180 -- x pos
																							struc.pos[2] = 10 -- y pos
																							struc.color = Color( 180, 90, 0, 155 ) -- Red
																							struc.font = "UiBold" -- Font
																							struc.text = data.XPRequired.Practical.." Required" -- Text
																							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
																							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
																							draw.Text( struc )																						
																							end
																						end
															GUI_Craft_Item_Craft.DoClick = function()
																										if OCRP_Professions[activeprof].Exp.Skill >= data.XPRequired.Skill && OCRP_Professions[activeprof].Exp.Mechanical >= data.XPRequired.Mechanical && OCRP_Professions[activeprof].Exp.Practical >= data.XPRequired.Practical then 
																							RunConsoleCommand("OCRP_CraftItem",data.Item) 
																							end
																						end
																							
														GUI_Prof_Crafting_List:AddItem(GUI_Craft_Item_Panel)
														
													end
												
												Craft_Icon_ent:Remove()	
	
			local GUI_Prof_Bar = vgui.Create("DButton")
			GUI_Prof_Bar:SetParent(GUI_Prof_Panel_List)
			GUI_Prof_Bar:SetSize(330,60)
			GUI_Prof_Bar:SetPos(23,400)
			GUI_Prof_Bar:SetText("")
			GUI_Prof_Bar.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Prof_Bar:GetWide(),GUI_Prof_Bar:GetTall(),Color( 55, 55, 55, 255 ))
										draw.RoundedBox(8,1,1,GUI_Prof_Bar:GetWide()-2,GUI_Prof_Bar:GetTall()-2,Color( 180, 90, 0, 155 ))
										
										local totalxp = OCRP_Professions[activeprof].Exp.Mechanical + OCRP_Professions[activeprof].Exp.Practical
										
										if totalxp > 20 then
											draw.RoundedBox(8,1,(GUI_Prof_Bar:GetTall()-2)-(GUI_Prof_Bar:GetTall()-2)*(totalxp/1000),(GUI_Prof_Bar:GetWide()-2),(GUI_Prof_Bar:GetTall()-2)*(totalxp/1000),Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										end
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 165 -- x pos
										struc.pos[2] = 30 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.font = "UiBold" -- Font
										struc.text = totalxp.."/1000" -- Text
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )	
										
									end

			local GUI_Prof_Bar = vgui.Create("DBevel")
			GUI_Prof_Bar:SetParent(GUI_Prof_Panel_List)
			GUI_Prof_Bar:SetSize(330,20)
			GUI_Prof_Bar:SetPos(373,400)
			GUI_Prof_Bar:SetText("")
			GUI_Prof_Bar.Paint = function()
										draw.RoundedBox(4,0,0,GUI_Prof_Bar:GetWide(),GUI_Prof_Bar:GetTall(),Color( 55, 55, 55, 255 ))
										draw.RoundedBox(4,1,1,GUI_Prof_Bar:GetWide()-2,GUI_Prof_Bar:GetTall()-2,Color( 155, 155, 30, 155 ))
										
										if OCRP_Professions[activeprof].Exp.Skill > 20 then
											draw.RoundedBox(4,1,(GUI_Prof_Bar:GetTall()-2)-(GUI_Prof_Bar:GetTall()-2)*(OCRP_Professions[activeprof].Exp.Skill/500),(GUI_Prof_Bar:GetWide()-2),(GUI_Prof_Bar:GetTall()-2)*(OCRP_Professions[activeprof].Exp.Skill/500),Color( 185, 185, 30, 155 ))
										end
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 165 -- x pos
										struc.pos[2] = 10 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.font = "UiBold" -- Font
										struc.text = "Skill "..OCRP_Professions[activeprof].Exp.Skill.."/1000 xp" -- Text
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )	
										
										end


										


			local GUI_Prof_Bar = vgui.Create("DBevel")
			GUI_Prof_Bar:SetParent(GUI_Prof_Panel_List)
			GUI_Prof_Bar:SetSize(330,20)
			GUI_Prof_Bar:SetPos(373,420)
			GUI_Prof_Bar:SetText("")
			GUI_Prof_Bar.Paint = function()
										draw.RoundedBox(4,0,0,GUI_Prof_Bar:GetWide(),GUI_Prof_Bar:GetTall(),Color( 55, 55, 55, 255 ))
										draw.RoundedBox(4,1,1,GUI_Prof_Bar:GetWide()-2,GUI_Prof_Bar:GetTall()-2,Color( 30, 155, 155, 155 ))
										
										if OCRP_Professions[activeprof].Exp.Mechanical > 20 then
											draw.RoundedBox(4,1,(GUI_Prof_Bar:GetTall()-2)-(GUI_Prof_Bar:GetTall()-2)*(OCRP_Professions[activeprof].Exp.Mechanical/500),(GUI_Prof_Bar:GetWide()-2),(GUI_Prof_Bar:GetTall()-2)*(OCRP_Professions[activeprof].Exp.Mechanical/500),Color( 30, 185, 185, 155 ))
										end
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 165 -- x pos
										struc.pos[2] = 10 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.font = "UiBold" -- Font
										struc.text = "Mechanical "..OCRP_Professions[activeprof].Exp.Mechanical.."/1000 xp" -- Text
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )	
										
										end

			local GUI_Prof_Bar = vgui.Create("DBevel")
			GUI_Prof_Bar:SetParent(GUI_Prof_Panel_List)
			GUI_Prof_Bar:SetSize(330,20)
			GUI_Prof_Bar:SetPos(373,440)
			GUI_Prof_Bar:SetText("")
			GUI_Prof_Bar.Paint = function()
										draw.RoundedBox(4,0,0,GUI_Prof_Bar:GetWide(),GUI_Prof_Bar:GetTall(),Color( 55, 55, 55, 255 ))
										draw.RoundedBox(4,1,1,GUI_Prof_Bar:GetWide()-2,GUI_Prof_Bar:GetTall()-2,Color( 180, 90, 0, 155 ))
										
										if OCRP_Professions[activeprof].Exp.Practical > 20 then
											draw.RoundedBox(4,1,(GUI_Prof_Bar:GetTall()-2)-(GUI_Prof_Bar:GetTall()-2)*(OCRP_Professions[activeprof].Exp.Practical/500),(GUI_Prof_Bar:GetWide()-2),(GUI_Prof_Bar:GetTall()-2)*(OCRP_Professions[activeprof].Exp.Practical/500),Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										end
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 165 -- x pos
										struc.pos[2] = 10 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.font = "UiBold" -- Font
										struc.text = "Practical "..OCRP_Professions[activeprof].Exp.Practical.."/500 xp" -- Text
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )	
										
										end										

		local GUI_Prof_Reselect = vgui.Create("DButton")
		GUI_Prof_Reselect:SetParent(GUI_Prof_Panel_List)
		GUI_Prof_Reselect:SetSize(20,20)
		GUI_Prof_Reselect:SetPos(716,10)
		GUI_Prof_Reselect:SetText("")
		GUI_Prof_Reselect:SetToolTip("Re-select Profession")
		GUI_Prof_Reselect.Paint = function()
								surface.SetMaterial(OC_1)
								surface.DrawTexturedRect(0,0,GUI_Prof_Reselect:GetWide(),GUI_Prof_Reselect:GetTall())
							end
		GUI_Prof_Reselect.DoClick = function()
			net.Start("OCRP_ResetProf")
			net.SendToServer()
		end	

										
	else
	
						
		local GUI_Prof_Name = vgui.Create("DLabel")
		GUI_Prof_Name:SetColor(Color(255,255,255,255))
		
		surface.SetFont("Trebuchet22")
		local x,y = surface.GetTextSize("Professional "..GAMEMODE.OCRP_Professions[activeprof].Name)
		
		GUI_Prof_Name:SetPos(373 - x/2,25 - y/2)
		GUI_Prof_Name:SetFont("Trebuchet22")
		GUI_Prof_Name:SetText("Professional "..GAMEMODE.OCRP_Professions[activeprof].Name)
		GUI_Prof_Name:SizeToContents()
		GUI_Prof_Name:SetParent(GUI_Prof_Panel_List)
		
			local GUI_Prof_Bar = vgui.Create("DButton")
			GUI_Prof_Bar:SetParent(GUI_Prof_Panel_List)
			GUI_Prof_Bar:SetSize(60,400)
			GUI_Prof_Bar:SetPos(23,40)
			GUI_Prof_Bar:SetText("")
			GUI_Prof_Bar.Paint = function()
										draw.RoundedBox(8,0,0,GUI_Prof_Bar:GetWide(),GUI_Prof_Bar:GetTall(),Color( 55, 55, 55, 255 ))
										draw.RoundedBox(8,1,1,GUI_Prof_Bar:GetWide()-2,GUI_Prof_Bar:GetTall()-2,Color( 180, 90, 0, 155 ))
										
										if OCRP_Professions[activeprof].Exp > 20 then
											draw.RoundedBox(8,1,(GUI_Prof_Bar:GetTall()-2)-(GUI_Prof_Bar:GetTall()-2)*(OCRP_Professions[activeprof].Exp/1000),(GUI_Prof_Bar:GetWide()-2),(GUI_Prof_Bar:GetTall()-2)*(OCRP_Professions[activeprof].Exp/1000),Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										end
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 30 -- x pos
										struc.pos[2] = 200 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.font = "UiBold" -- Font
										struc.text = OCRP_Professions[activeprof].Exp.."/1000" -- Text
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )	
										
									end	
									
		if GAMEMODE.OCRP_Professions[activeprof].MenuFunc != nil then
			GAMEMODE.OCRP_Professions[activeprof].MenuFunc(GUI_Prof_Panel_List,activeprof)
		end

		local GUI_Prof_Reselect = vgui.Create("DButton")
		GUI_Prof_Reselect:SetParent(GUI_Prof_Panel_List)
		GUI_Prof_Reselect:SetSize(20,20)
		GUI_Prof_Reselect:SetPos(716,10)
		GUI_Prof_Reselect:SetText("")
		GUI_Prof_Reselect:SetToolTip("Re-select Profession")
		GUI_Prof_Reselect.Paint = function()
								surface.SetMaterial(OC_1)
								surface.DrawTexturedRect(0,0,GUI_Prof_Reselect:GetWide(),GUI_Prof_Reselect:GetTall())
							end
		GUI_Prof_Reselect.DoClick = function()
			net.Start("OCRP_ResetProf")
			net.SendToServer()
		end	
		
		return GUI_Prof_Panel_List	
	end
	
	return GUI_Prof_Panel_List
end


