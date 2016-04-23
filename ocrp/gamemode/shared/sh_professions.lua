GM.OCRP_Professions = {}

	
GM.OCRP_Professions["Pro_Cook"] = {
	Name = "Professional Cook",-- The Name
	Desc = "Used to create food that give great temporary buffs.",-- The description
	XPPerMin = 20,
	XPPerAttack = 2,
}

GM.OCRP_Professions["Pro_Hitman"].MenuFunc = function(parent,activeprof)

													for exp,multiplier in pairs(GAMEMODE.OCRP_Professions["Pro_Hitman"].Resistance) do
												
														local GUI_Line = vgui.Create("DBevel",parent)
														GUI_Line:SetPos(80,40 +(400- (400*(exp/1000))))
														GUI_Line:SetSize(300,3)
														GUI_Line.Paint = function(GUI_Line)
																				surface.SetDrawColor(Color( 60, 60, 60, 155 ))
																				surface.DrawOutlinedRect(0,0,300,3 )
																				
																				surface.SetDrawColor(OCRP_Options.Color)
																				surface.DrawRect(1,1,298,1 )
																			
																			end
																			
														local GUI_Label = vgui.Create("DLabel")
														GUI_Label:SetColor(Color(255,255,255,255))
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize("You take "..((1-multiplier)*100).." less damage.")
														
														GUI_Label:SetPos(380,40 +(400- (400*(exp/1000)))- y/2)
														GUI_Label:SetFont("UiBold")
														GUI_Label:SetText("You take "..((1-multiplier)*100).."% less damage.")
														GUI_Label:SizeToContents()
														GUI_Label:SetParent(parent)
													end


													for exp,multiplier in pairs(GAMEMODE.OCRP_Professions["Pro_Hitman"].Power) do
												
														local GUI_Line = vgui.Create("DBevel",parent)
														GUI_Line:SetPos(80,40 +(400- (400*(exp/1000))))
														GUI_Line:SetSize(300,3)
														GUI_Line.Paint = function(GUI_Line)
																				surface.SetDrawColor(Color( 60, 60, 60, 155 ))
																				surface.DrawOutlinedRect(0,0,300,3 )
																				
																				surface.SetDrawColor(OCRP_Options.Color)
																				surface.DrawRect(1,1,298,1 )
																			
																			end
																			
														local GUI_Label = vgui.Create("DLabel")
														GUI_Label:SetColor(Color(255,255,255,255))
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize("You deal "..((multiplier)*100).."% more damage with melee weapons.")
														
														GUI_Label:SetPos(380,40 +(400- (400*(exp/1000)))- y/2)
														GUI_Label:SetFont("UiBold")
														GUI_Label:SetText("You deal "..((multiplier-1)*100).."% more damage with melee weapons.")
														GUI_Label:SizeToContents()
														GUI_Label:SetParent(parent)
													end													
													
													for exp,multiplier in pairs(GAMEMODE.OCRP_Professions["Pro_Hitman"].SpeedDecay) do
												
														local GUI_Line = vgui.Create("DBevel",parent)
														GUI_Line:SetPos(80,40 +(400- (400*(exp/1000))))
														GUI_Line:SetSize(50,3)
														GUI_Line.Paint = function(GUI_Line)
																				surface.SetDrawColor(Color( 60, 60, 60, 155 ))
																				surface.DrawOutlinedRect(0,0,50,3 )
																				
																				surface.SetDrawColor(OCRP_Options.Color)
																				surface.DrawRect(1,1,48,1 )
																			
																			end
																			
														local GUI_Label = vgui.Create("DLabel")
														GUI_Label:SetColor(Color(255,255,255,255))
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize("You last "..((1-multiplier)*100).."% longer while sprinting.")
														
														GUI_Label:SetPos(130,40 +(400- (400*(exp/1000))) - y/2)
														GUI_Label:SetFont("UiBold")
														GUI_Label:SetText("You last "..((1-multiplier)*100).."% longer while sprinting.")
														GUI_Label:SizeToContents()
														GUI_Label:SetParent(parent)	
													
													end

													for exp,multiplier in pairs(GAMEMODE.OCRP_Professions["Pro_Hitman"].Accuracy) do
												
														local GUI_Line = vgui.Create("DBevel",parent)
														GUI_Line:SetPos(80,40 +(400- (400*(exp/1000))))
														GUI_Line:SetSize(50,3)
														GUI_Line.Paint = function(GUI_Line)
																				surface.SetDrawColor(Color( 60, 60, 60, 155 ))
																				surface.DrawOutlinedRect(0,0,50,3 )
																				
																				surface.SetDrawColor(OCRP_Options.Color)
																				surface.DrawRect(1,1,48,1 )
																			
																			end
																			
														local GUI_Label = vgui.Create("DLabel")
														GUI_Label:SetColor(Color(255,255,255,255))
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize("You are "..((1-multiplier)*100).."% more accurate with guns.")
														
														GUI_Label:SetPos(130,40 +(400- (400*(exp/1000))) - y/2)
														GUI_Label:SetFont("UiBold")
														GUI_Label:SetText("You are "..((1-multiplier)*100).."% more accurate with guns.")
														GUI_Label:SizeToContents()
														GUI_Label:SetParent(parent)	
													
													end

end

GM.OCRP_Professions["Pro_Theft"].MenuFunc = function(parent,activeprof)

													for door,data in pairs(GAMEMODE.OCRP_Professions["Pro_Theft"].Ignore) do
												
														local GUI_Line = vgui.Create("DBevel",parent)
														GUI_Line:SetPos(80,40 +(400- (400*(data.XPRequired/1000))))
														GUI_Line:SetSize(350,3)
														GUI_Line.Paint = function(GUI_Line)
																				surface.SetDrawColor(Color( 60, 60, 60, 155 ))
																				surface.DrawOutlinedRect(0,0,350,3 )
																				
																				surface.SetDrawColor(OCRP_Options.Color)
																				surface.DrawRect(1,1,348,1 )
																			
																			end
																			
														local GUI_Label = vgui.Create("DLabel")
														GUI_Label:SetColor(Color(255,255,255,255))
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize(data.Description)
														
														GUI_Label:SetPos(430,40 +(400- (400*(data.XPRequired/1000)))- y/2)
														GUI_Label:SetFont("UiBold")
														GUI_Label:SetText(data.Description)
														GUI_Label:SizeToContents()
														GUI_Label:SetParent(parent)
													end

													for door,data in pairs(GAMEMODE.OCRP_Professions["Pro_Theft"].LockPicking) do
												
														local GUI_Line = vgui.Create("DBevel",parent)
														GUI_Line:SetPos(80,40 +(400- (400*(data.XPRequired/1000))))
														GUI_Line:SetSize(300,3)
														GUI_Line.Paint = function(GUI_Line)
																				surface.SetDrawColor(Color( 60, 60, 60, 155 ))
																				surface.DrawOutlinedRect(0,0,300,3 )
																				
																				surface.SetDrawColor(OCRP_Options.Color)
																				surface.DrawRect(1,1,298,1 )
																			
																			end
																			
														local GUI_Label = vgui.Create("DLabel")
														GUI_Label:SetColor(Color(255,255,255,255))
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize(data.Description)
														
														GUI_Label:SetPos(380,40 +(400- (400*(data.XPRequired/1000)))- y/2)
														GUI_Label:SetFont("UiBold")
														GUI_Label:SetText(data.Description)
														GUI_Label:SizeToContents()
														GUI_Label:SetParent(parent)
													end

													
													for exp,value in pairs(GAMEMODE.OCRP_Professions["Pro_Theft"].Chance) do
												
														local GUI_Line = vgui.Create("DBevel",parent)
														GUI_Line:SetPos(80,40 +(400- (400*(exp/1000))))
														GUI_Line:SetSize(50,3)
														GUI_Line.Paint = function(GUI_Line)
																				surface.SetDrawColor(Color( 60, 60, 60, 155 ))
																				surface.DrawOutlinedRect(0,0,50,3 )
																				
																				surface.SetDrawColor(OCRP_Options.Color)
																				surface.DrawRect(1,1,48,1 )
																			
																			end
																			
														local GUI_Label = vgui.Create("DLabel")
														GUI_Label:SetColor(Color(255,255,255,255))
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize("You have a "..value.."% chance to lockpick successfully.")
														
														GUI_Label:SetPos(130,40 +(400- (400*(exp/1000))) - y/2)
														GUI_Label:SetFont("UiBold")
														GUI_Label:SetText("You have a "..value.."% chance to lockpick successfully.")
														GUI_Label:SizeToContents()
														GUI_Label:SetParent(parent)	
													
													end													

end

GM.OCRP_Professions["Pro_Grower"].MenuFunc = function(parent,activeprof)

													for drug,data in pairs(GAMEMODE.OCRP_Professions["Pro_Grower"].Drugs) do
												
														local GUI_Line = vgui.Create("DBevel",parent)
														GUI_Line:SetPos(80,40 +(400- (400*(data.XPRequired/1000))))
														GUI_Line:SetSize(300,3)
														GUI_Line.Paint = function(GUI_Line)
																				surface.SetDrawColor(Color( 60, 60, 60, 155 ))
																				surface.DrawOutlinedRect(0,0,300,3 )
																				
																				surface.SetDrawColor(OCRP_Options.Color)
																				surface.DrawRect(1,1,298,1 )
																			
																			end
																			
														local GUI_Label = vgui.Create("DLabel")
														GUI_Label:SetColor(Color(255,255,255,255))
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize("You can grow "..drug..".")
														
														GUI_Label:SetPos(380,40 +(400- (400*(data.XPRequired/1000)))- y/2)
														GUI_Label:SetFont("UiBold")
														GUI_Label:SetText("You can grow "..drug..".")
														GUI_Label:SizeToContents()
														GUI_Label:SetParent(parent)
													end
													
													for expr, multiplier in pairs(GAMEMODE.OCRP_Professions["Pro_Grower"].MoneyMultiplier) do
												
														local GUI_Line = vgui.Create("DBevel",parent)
														GUI_Line:SetPos(80,40 +(400- (400*(expr/1000))))
														GUI_Line:SetSize(300,3)
														GUI_Line.Paint = function(GUI_Line)
																				surface.SetDrawColor(Color( 60, 60, 60, 155 ))
																				surface.DrawOutlinedRect(0,0,300,3 )
																				
																				surface.SetDrawColor(OCRP_Options.Color)
																				surface.DrawRect(1,1,298,1 )
																			
																			end
																			
														local GUI_Label = vgui.Create("DLabel")
														GUI_Label:SetColor(Color(255,255,255,255))
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize("You get "..((multiplier-1)*100).."% more money when selling drugs.")
														
														GUI_Label:SetPos(380,40 +(400- (400*(expr/1000)))- y/2)
														GUI_Label:SetFont("UiBold")
														GUI_Label:SetText("You get "..((multiplier-1)*100).."% more money when selling drugs.")
														GUI_Label:SizeToContents()
														GUI_Label:SetParent(parent)
													end
													
													for exp,multiplier in pairs(GAMEMODE.OCRP_Professions["Pro_Grower"].Smell) do
												
														local GUI_Line = vgui.Create("DBevel",parent)
														GUI_Line:SetPos(80,40 +(400- (400*(exp/1000))))
														GUI_Line:SetSize(50,3)
														GUI_Line.Paint = function(GUI_Line)
																				surface.SetDrawColor(Color( 60, 60, 60, 155 ))
																				surface.DrawOutlinedRect(0,0,50,3 )
																				
																				surface.SetDrawColor(OCRP_Options.Color)
																				surface.DrawRect(1,1,48,1 )
																			
																			end
																			
														local GUI_Label = vgui.Create("DLabel")
														GUI_Label:SetColor(Color(255,255,255,255))
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize("You emit "..((1-multiplier)*100).."% less smell.")
														
														GUI_Label:SetPos(130,40 +(400- (400*(exp/1000))) - y/2)
														GUI_Label:SetFont("UiBold")
														GUI_Label:SetText("You emit "..((1-multiplier)*100).."% less smell.")
														GUI_Label:SizeToContents()
														GUI_Label:SetParent(parent)	
													
													end
											
																									
													for exp,multiplier in pairs(GAMEMODE.OCRP_Professions["Pro_Grower"].TimesMultiplier) do
												
														local GUI_Line = vgui.Create("DBevel",parent)
														GUI_Line:SetPos(80,40 +(400- (400*(exp/1000))))
														GUI_Line:SetSize(50,3)
														GUI_Line.Paint = function(GUI_Line)
																				surface.SetDrawColor(Color( 60, 60, 60, 155 ))
																				surface.DrawOutlinedRect(0,0,50,3 )
																				
																				surface.SetDrawColor(OCRP_Options.Color)
																				surface.DrawRect(1,1,48,1 )
																			
																			end
																			
														local GUI_Label = vgui.Create("DLabel")
														GUI_Label:SetColor(Color(255,255,255,255))
														
														surface.SetFont("UiBold")
														local x,y = surface.GetTextSize("Drugs take "..(multiplier*100).."% time to grow.")
														
														GUI_Label:SetPos(130,40 +(400- (400*(exp/1000))) - y/2)
														GUI_Label:SetFont("UiBold")
														GUI_Label:SetText("Drugs take "..(multiplier*100).."% time to grow.")
														GUI_Label:SizeToContents()
														GUI_Label:SetParent(parent)	
													
													end
											
												end

end
