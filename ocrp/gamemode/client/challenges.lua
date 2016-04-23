function OCRP_Challenges_UMSG_CL_FULL( um )
	local InfoName = um:ReadString()
	OCRP_PLAYER[InfoName] = OCRP_PLAYER[InfoName] or {}
	OCRP_PLAYER[InfoName].Num = um:ReadShort()
	OCRP_PLAYER[InfoName].CanDo = um:ReadBool()
	OCRP_PLAYER[InfoName].Complete = um:ReadBool()
end
usermessage.Hook( "OCRP_Challenge_Full", OCRP_Challenges_UMSG_CL_FULL )

function OCRP_Challenges_UMSG_CL_SMALL( um )
	local InfoName = um:ReadString()
	OCRP_PLAYER[InfoName] = OCRP_PLAYER[InfoName] or {}
	OCRP_PLAYER[InfoName] = um:ReadShort()
end
usermessage.Hook( "OCRP_Challenge_Small", OCRP_Challenges_UMSG_CL_SMALL )

function OCRP_ShowChall( um )
	OCRP_Challenges()
end
usermessage.Hook( "ocrp_chall_show", OCRP_ShowChall )

function OCRP_Challenges_ChangePage( PAGE, LIST )
	if PAGE == "PRO" then
		for _, Data in pairs( GAMEMODE.Challenges ) do
			if Data.Pro != "GENERAL" then
				local adImage
				
				if OCRP_PLAYER[Data.Other].Complete then
					adImage = "gui/silkicons/check_on"
				elseif !OCRP_PLAYER[Data.Other].CanDo then
					adImage = "gui/silkicons/check_off"
				else
					adImage = "gui/OCRP/OCRP_Orange"
				end
				
				local SubList = vgui.Create( "DPanelList" )
				SubList:SetTall( 80 )
				SubList:SetWide( 293.5 )
				SubList:SetPos( 0, 0 )
				SubList.Paint = function()
					draw.RoundedBox(8,0,0,SubList:GetWide(),SubList:GetTall(),Color(60,60,60,180))
				end
				
				local Name = vgui.Create( "DLabel", SubList )
				Name:SetPos( 5, 5 )
				Name:SetFont( "Trebuchet18" )
				Name:SetText( Data.Name )
				Name:SizeToContents()
				
				if !OCRP_PLAYER[Data.Other].CanDo then
					local image1 = vgui.Create( "DImage", SubList )
					image1:SetTall( 16 )
					image1:SetWide( 16 )
					image1:SetImage( adImage )
					image1:SetPos( 272.5, 4 )
				
				elseif Data.Diff == 3 then
					local image1 = vgui.Create( "DImage", SubList )
					image1:SetTall( 16 )
					image1:SetWide( 16 )
					image1:SetImage( adImage )
					image1:SetPos( 272.5, 4 )
					
					local image2 = vgui.Create( "DImage", SubList )
					image2:SetTall( 16 )
					image2:SetWide( 16 )
					image2:SetImage( adImage )
					image2:SetPos( 254.5, 4 )
					
					local image3 = vgui.Create( "DImage", SubList )
					image3:SetTall( 16 )
					image3:SetWide( 16 )
					image3:SetImage( adImage )
					image3:SetPos( 236.5, 4 )
				elseif Data.Diff == 2 then
					local image1 = vgui.Create( "DImage", SubList )
					image1:SetTall( 16 )
					image1:SetWide( 16 )
					image1:SetImage( adImage )
					image1:SetPos( 272.5, 4 )
					
					local image2 = vgui.Create( "DImage", SubList )
					image2:SetTall( 16 )
					image2:SetWide( 16 )
					image2:SetImage( adImage )
					image2:SetPos( 254.5, 4 )
				else
					local image1 = vgui.Create( "DImage", SubList )
					image1:SetTall( 16 )
					image1:SetWide( 16 )
					image1:SetImage( adImage )
					image1:SetPos( 272.5, 4 )
				end
				
				local Desc = vgui.Create( "DLabel", SubList )
				Desc:SetPos( 5, 22 )
				Desc:SetText( Data.Desc )
				Desc:SetWide( 286 )
				Desc:SetTall( 30 )
				Desc:SetWrap( true )
				
				local Progressa = vgui.Create( "OCProgressBar", SubList )
				Progressa:SetTall( 20 )
				Progressa:SetWide( 283.5 )
				Progressa:SetPos( 5, 55 )
				Progressa:SetMin( 0 )
				Progressa:SetMax( Data.Amount )
				Progressa:SetValue( OCRP_PLAYER[Data.Other].Num )
				
				LIST:AddItem( SubList )
			end
		end
	else
		for _, Data in pairs( GAMEMODE.Challenges ) do
			if Data.Pro == "GENERAL" then
				local adImage
				
				if OCRP_PLAYER[Data.Other].Complete then
					adImage = "gui/silkicons/check_on"
				elseif !OCRP_PLAYER[Data.Other].CanDo then
					adImage = "gui/silkicons/check_off"
				else
					adImage = "gui/OCRP/OCRP_Orange"
				end
				
				local SubList = vgui.Create( "DPanelList" )
				SubList:SetTall( 80 )
				SubList:SetWide( 293.5 )
				SubList:SetPos( 0, 0 )
				SubList.Paint = function()
					draw.RoundedBox(8,0,0,SubList:GetWide(),SubList:GetTall(),Color(60,60,60,180))
				end
				
				local Name = vgui.Create( "DLabel", SubList )
				Name:SetPos( 5, 5 )
				Name:SetFont( "Trebuchet18" )
				Name:SetText( Data.Name )
				Name:SizeToContents()
				
				if !OCRP_PLAYER[Data.Other].CanDo then
					local image1 = vgui.Create( "DImage", SubList )
					image1:SetTall( 16 )
					image1:SetWide( 16 )
					image1:SetImage( adImage )
					image1:SetPos( 272.5, 4 )
				
				elseif Data.Diff == 3 then
					local image1 = vgui.Create( "DImage", SubList )
					image1:SetTall( 16 )
					image1:SetWide( 16 )
					image1:SetImage( adImage )
					image1:SetPos( 272.5, 4 )
					
					local image2 = vgui.Create( "DImage", SubList )
					image2:SetTall( 16 )
					image2:SetWide( 16 )
					image2:SetImage( adImage )
					image2:SetPos( 254.5, 4 )
					
					local image3 = vgui.Create( "DImage", SubList )
					image3:SetTall( 16 )
					image3:SetWide( 16 )
					image3:SetImage( adImage )
					image3:SetPos( 236.5, 4 )
				elseif Data.Diff == 2 then
					local image1 = vgui.Create( "DImage", SubList )
					image1:SetTall( 16 )
					image1:SetWide( 16 )
					image1:SetImage( adImage )
					image1:SetPos( 272.5, 4 )
					
					local image2 = vgui.Create( "DImage", SubList )
					image2:SetTall( 16 )
					image2:SetWide( 16 )
					image2:SetImage( adImage )
					image2:SetPos( 254.5, 4 )
				else
					local image1 = vgui.Create( "DImage", SubList )
					image1:SetTall( 16 )
					image1:SetWide( 16 )
					image1:SetImage( adImage )
					image1:SetPos( 272.5, 4 )
				end
				
				local Desc = vgui.Create( "DLabel", SubList )
				Desc:SetPos( 5, 22 )
				Desc:SetText( Data.Desc )
				Desc:SetWide( 286 )
				Desc:SetTall( 30 )
				Desc:SetWrap( true )
				
				local Progressa = vgui.Create( "OCProgressBar", SubList )
				Progressa:SetTall( 20 )
				Progressa:SetWide( 283.5 )
				Progressa:SetPos( 5, 55 )
				Progressa:SetMin( 0 )
				Progressa:SetMax( Data.Amount )
				Progressa:SetValue( OCRP_PLAYER[Data.Other].Num )
				
				LIST:AddItem( SubList )
			end
		end
	end
end
	
	
function OCRP_Challenges()
	local Frame = vgui.Create( "DFrame" )
	Frame:SetTall( 700 )
	Frame:SetWide( 600 )
	Frame:SetTitle( "OCRP: Challenges" )
	Frame.Paint = function()
						draw.RoundedBox(8,1,1,Frame:GetWide()-2,Frame:GetTall()-2,OCRP_Options.Color)	
					end
	Frame:Center()
	Frame:ShowCloseButton(false)
	Frame:MakePopup()
	
	local GUI_Main_Exit = vgui.Create("DButton")
	GUI_Main_Exit:SetParent(Frame)	
	GUI_Main_Exit:SetSize(20,20)
	GUI_Main_Exit:SetPos(575,5)
	GUI_Main_Exit:SetText("")
	GUI_Main_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,GUI_Main_Exit:GetWide(),GUI_Main_Exit:GetTall())
									end
	GUI_Main_Exit.DoClick = function()			
								Frame:Close()
							end
	
	local MainList = vgui.Create( "DPanelList", Frame )
	MainList:SetTall( 640 )
	MainList:SetWide( 590 )
	MainList:SetPos( 5, 55 )
	MainList:SetSpacing( 2 )
	MainList:EnableHorizontal( true )
	MainList.Paint = function()
						draw.RoundedBox(8,0,0,MainList:GetWide(),MainList:GetTall(),Color(60,60,60,180))
					end
					
		local ProButton = vgui.Create( "DButton", Frame )
	ProButton:SetTall( 26 )
	ProButton:SetWide( 250 )
	ProButton:SetText( " " )
	ProButton:SetPos( 40, 25 )
	ProButton.Paint = function()
									draw.RoundedBox(8,0,0,ProButton:GetWide(),ProButton:GetTall(),Color( 60, 60, 60, 155 ))
									draw.RoundedBox(8,1,1,ProButton:GetWide()-2,ProButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
												
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 125 -- x pos
									struc.pos[2] = 13 -- y pos
									struc.color = Color(255,255,255,255) -- Red
									struc.text = "Professions" -- Text
									struc.font = "UiBold" -- Font
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )
						end
	ProButton.DoClick = function( ProButton )
		local tbl = MainList:GetItems()
		for k, v in pairs( tbl ) do
			MainList:RemoveItem( v )
		end
		OCRP_Challenges_ChangePage( "PRO", MainList ) 
	end
		
	local GeneralButton = vgui.Create( "DButton", Frame )
	GeneralButton:SetTall( 26 )
	GeneralButton:SetWide( 250 )
	GeneralButton:SetText( " " )
	GeneralButton:SetPos( 300, 25 )
	GeneralButton.Paint = function()
									draw.RoundedBox(8,0,0,GeneralButton:GetWide(),GeneralButton:GetTall(),Color( 60, 60, 60, 155 ))
									draw.RoundedBox(8,1,1,GeneralButton:GetWide()-2,GeneralButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
												
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 125 -- x pos
									struc.pos[2] = 13 -- y pos
									struc.color = Color(255,255,255,255) -- Red
									struc.text = "General" -- Text
									struc.font = "UiBold" -- Font
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )
							end
	GeneralButton.DoClick = function( GeneralButton )
		local tbl = MainList:GetItems()
		for k, v in pairs( tbl ) do
			MainList:RemoveItem( v )
		end
		OCRP_Challenges_ChangePage( "GENERAL", MainList )
	end
	
	OCRP_Challenges_ChangePage( "PRO", MainList )
end
concommand.Add("OCRP_Challenges", OCRP_Challenges)
