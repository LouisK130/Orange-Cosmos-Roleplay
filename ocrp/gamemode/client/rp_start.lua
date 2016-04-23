--require("datastream")

local vgui = vgui
local draw = draw
local surface = surface

function AskRef()
    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(500, 170)
    frame:SetOCRPTitle("Who referred you to play here?")
    frame:Center()
    frame:AllowCloseButton(false)
    frame:MakePopup()
    
    surface.SetFont("Trebuchet19")
    local textw,texth = surface.GetTextSize("Use the dropdown to select the player who referred you.\nSelect \"Nobody\" if you were not referred.")
    local textw2 = surface.GetTextSize("Select \"Nobody\" if you were not referred.")
    
    local info = vgui.Create("DPanel", frame)
    info:SetSize(textw+10, texth+10)
    info:SetPos(frame:GetWide()/2-info:GetWide()/2, 5)
    
    function info:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(25,25,25,255))
        draw.DrawText("Use the dropdown to select the player who referred you.", "Trebuchet19", 5, 5, Color(255,255,255,255))
        draw.DrawText("Select \"Nobody\" if you were not referred.", "Trebuchet19", textw/2-textw2/2+5, 5+texth/2, Color(255,255,255,255))
    end
    
    local pselect = vgui.Create("DComboBox", frame)
    pselect:SetSize(200, 30)
    pselect:SetPos(frame:GetWide()/2-pselect:GetWide()/2, 70)
    pselect:AddChoice("Nobody")
    for k,v in pairs(player.GetAll()) do
        if v:IsValid() and v != LocalPlayer() then
            pselect:AddChoice(v:Nick())
        end
    end
    
    local chosen = nil
    local sent = false
    
    function pselect:OnSelect(index, value)
        if value == "Nobody" and index == 1 then return end
        for k,v in pairs(player.GetAll()) do
            if v:IsValid() and v:Nick() == value then
                chosen = v
            end
        end
    end
    
    local finish = vgui.Create("OCRP_BaseButton", frame)
    finish:SetSize(150, 40)
    finish:SetPos(frame:GetWide()/2-finish:GetWide()/2, frame:GetTall()-finish:GetTall()-10)
    finish:SetText("Submit and Play OCRP")
    
    function finish:DoClick()
        if not chosen or not chosen:IsValid() then
            net.Start("OCRP_AddRef")
            net.WriteString("")
            net.SendToServer()
        else
            OCRP_AddHint("Thanks! When you get some more playtime your friend will be rewarded!")
            net.Start("OCRP_AddRef")
            net.WriteString(chosen:SteamID())
            net.SendToServer()
        end
        OCRP_AddHint("If you refer some friends of your own, you'll be rewarded!")
        sent = true
        frame:Remove()
    end
    
    local oldOR = frame.OnRemove
    
    function frame:OnRemove()
        if not sent then
            net.Start("OCRP_AddRef")
            net.WriteString("")
            net.SendToServer()
        end
        oldOR(self)
    end
    
end

net.Receive("OCRP_AskRef", function()
    AskRef()
end)

--[[local function OCRP_Face( um )
	local MdlFrame = vgui.Create( "DFrame" )
	MdlFrame:SetTall( 410 )
	MdlFrame:SetWide( 750 )
	MdlFrame:SetTitle( " " )
	MdlFrame:Center()
	MdlFrame.Paint = function()
						draw.RoundedBox(8,1,1,MdlFrame:GetWide()-2,MdlFrame:GetTall()-2,OCRP_Options.Color)	
					end
	MdlFrame:MakePopup()
	
	local TitlePanel = vgui.Create( "DPanel", MdlFrame )
	TitlePanel:SetTall( 50 )
	TitlePanel:SetWide( 720 )
	TitlePanel:SetPos( 10, 10 )
	TitlePanel.Paint = function()
							draw.RoundedBox(8,1,1,TitlePanel:GetWide()-2,TitlePanel:GetTall()-2,Color(60,60,60,180))	
						end
						
	local SelectPanel = vgui.Create( "DPanel", MdlFrame )
	SelectPanel:SetTall( 330 )
	SelectPanel:SetWide( 500 )
	SelectPanel:SetPos( 10, 70 )
	SelectPanel.Paint = function()
							draw.RoundedBox(8,1,1,SelectPanel:GetWide()-2,SelectPanel:GetTall()-2,Color(60,60,60,180))	
						end
						
	local PreviewPanel = vgui.Create( "DPanel", MdlFrame )
	PreviewPanel:SetTall( 330 )
	PreviewPanel:SetWide( 220 )
	PreviewPanel:SetPos( 520, 70 )
	PreviewPanel.Paint = function()
							draw.RoundedBox(8,1,1,PreviewPanel:GetWide()-2,PreviewPanel:GetTall()-2,Color(60,60,60,180))	
						end
						
	local PreviewMdl = vgui.Create( "DModelPanel", PreviewPanel )
	PreviewMdl:SetTall( 200 )
	PreviewMdl:SetWide( 200 )
	PreviewMdl:SetPos( 5, 5 )
	PreviewMdl:SetModel( LocalPlayer():GetModel() )	
	PreviewMdl:SetCamPos( Vector( 50, 50, 50 ) )
	
	local PreviewSlider = vgui.Create( "DNumSlider", PreviewPanel )
	PreviewSlider:SetWide( 200 )
	PreviewSlider:SetPos( 10, 220 )
	PreviewSlider:SetText( "Angle" )
	PreviewSlider:SetMax( 360 )
	PreviewSlider:SetMin( 0 )
	PreviewSlider:SetDecimals( 0 )
	
	function PreviewMdl:LayoutEntity( ent )
	
		ent:SetAngles( Angle( 0, PreviewSlider:GetValue(), 0) )
		
	end
	
	local ShopLabel = vgui.Create( "DLabel", TitlePanel )
	ShopLabel:SetFont( "TargetID" )
	ShopLabel:SetText( "Kentuckys' Friendly Faces" )
	ShopLabel:SetColor( Color( 255, 255, 255, 255 ) )
	ShopLabel:SetPos( 10, 10 )
	ShopLabel:SizeToContents()
	
	local FaceButton = vgui.Create("DButton", PreviewPanel)
	FaceButton:SetPos(10,265)
	FaceButton:SetSize(200,20)
	FaceButton:SetText("")
	FaceButton.Paint = function()
									draw.RoundedBox(4,0,0,FaceButton:GetWide(),FaceButton:GetTall(),Color( 60, 60, 60, 155 ))
									draw.RoundedBox(4,1,1,FaceButton:GetWide()-2,FaceButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
									
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 100 -- x pos
									struc.pos[2] = 10 -- y pos
									struc.color = Color(255,255,255,255) -- Red
									struc.text = "Face" -- Text
									struc.font = "UiBold" -- Font
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )
								end
	FaceButton.DoClick = function()
							PreviewMdl:SetCamPos( Vector( 50, 0, 60) )
							PreviewMdl:SetLookAt( Vector( 0, 0, 60) )
							PreviewMdl:SetFOV( 40 )
						end
								

	
	local MainClothes = vgui.Create( "DPanelList", SelectPanel )
	MainClothes:SetTall( 320 )
	MainClothes:SetWide( 490 )
	MainClothes:SetPos( 5, 5 )
	MainClothes:SetSpacing( 4 )
	MainClothes:EnableHorizontal( true )
	MainClothes:EnableVerticalScrollbar( true )
	MainClothes.Paint = function()
							draw.RoundedBox(8,0,0,MainClothes:GetWide(),MainClothes:GetTall(),Color(60,60,60,0))
						end
	
	PreviewMdl:SetModel( LocalPlayer():GetModel() )	
	local thekey = 1

	for _, face in pairs( GAMEMODE.OCRP_Models[LocalPlayer():GetSex() .."s"] ) do
		local ClothesList = vgui.Create( "DPanelList" )
		ClothesList:SetTall( 155 )
		ClothesList:SetWide( 120 )
		ClothesList:SetPos( 0, 0 )
		ClothesList.Paint = function()
								draw.RoundedBox(8,0,0,ClothesList:GetWide(),ClothesList:GetTall(),Color(60,60,60,180))
							end
	
		local ClothesName = vgui.Create( "DLabel", ClothesList )
		ClothesName:SetFont( "TargetIDSmall" )
		ClothesName:SetText( tostring( _ ) )
		ClothesName:SetColor( Color( 255, 255, 255, 255 ) )

		surface.SetFont( "TargetIDSmall" )
		local x, y = surface.GetTextSize( tostring( _ ) )
		ClothesName:SetPos( 59 - ( x / 2 ), 2 )
		ClothesName:SizeToContents()

		local ClothesMdl = vgui.Create( "DModelPanel", ClothesList )
		ClothesMdl:SetTall( 94 )
		ClothesMdl:SetWide( 94 )
		ClothesMdl:SetModel( face.Regular ) 
		ClothesMdl:SetPos( 12, 20 )
		ClothesMdl:SetCamPos( Vector( 50, 0, 60) )
		ClothesMdl:SetLookAt( Vector( 0, 0, 60) )

		local TryOnButton = vgui.Create("DButton", ClothesList)
		TryOnButton:SetPos(10,118)
		TryOnButton:SetSize(100,15)
		TryOnButton:SetText("")
		TryOnButton.Paint = function()
										draw.RoundedBox(4,0,0,TryOnButton:GetWide(),TryOnButton:GetTall(),Color( 60, 60, 60, 155 ))
										draw.RoundedBox(4,1,1,TryOnButton:GetWide()-2,TryOnButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 50 -- x pos
										struc.pos[2] = 7 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.text = "Preview" -- Text
										struc.font = "UiBold" -- Font
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )
									end
		TryOnButton.DoClick = function()
									PreviewMdl:SetModel( tostring(face.Regular) )
								end
									
		local BuyClothesButton = vgui.Create("DButton", ClothesList)
		BuyClothesButton:SetPos(10,135)
		BuyClothesButton:SetSize(100,15)
		BuyClothesButton:SetText("")
		BuyClothesButton.Paint = function()
										draw.RoundedBox(4,0,0,BuyClothesButton:GetWide(),BuyClothesButton:GetTall(),Color( 60, 60, 60, 155 ))
										draw.RoundedBox(4,1,1,BuyClothesButton:GetWide()-2,BuyClothesButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 50 -- x pos
										struc.pos[2] = 7 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.text = "Buy" -- Text
										struc.font = "UiBold" -- Font
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )
									end
		
		BuyClothesButton.DoClick = function()
			net.Start("OCRP_ChangeFace")
			net.WriteString(_)
			net.SendToServer()
		end
		
		MainClothes:AddItem( ClothesList )
	end
end]]

local face = face or nil
local gender = gender or nil
local clothes_table = clothes_table or {}
net.Receive("OCRP_UpdateWardrobe", function(len)
	face = net.ReadInt(32)
	gender = net.ReadString()
	clothes_table[1] = tobool(net.ReadInt(2))
	clothes_table[2] = tobool(net.ReadInt(2))
	clothes_table[3] = tobool(net.ReadInt(2))
	clothes_table[4] = tobool(net.ReadInt(2))
	clothes_table[5] = tobool(net.ReadInt(2))
	clothes_table[6] = tobool(net.ReadInt(2))
end)

function ClothesNumberToName(clothes)
	for k,v in pairs(GAMEMODE.OCRP_Models[gender .. "s"][face]) do
		if (clothes == 1 and string.find(v, "clothes1"))
		or (clothes == 2 and string.find(v, "clothes2"))
		or (clothes == 3 and string.find(v, "clothes3"))
		or (clothes == 4 and string.find(v, "clothes4"))
		or (clothes == 5 and string.find(v, "clothes5"))
		or (clothes == 6 and string.find(v, "clothes6")) then
			return k
		end
	end
end

local function OCRP_Wardrobe(um)
    
    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(600, 520)
    frame:SetOCRPTitle("Your Wardrobe")
    frame:Center()
    frame:MakePopup()
    
    surface.SetFont("Trebuchet19")
    local infow,infoh = surface.GetTextSize("These are the outfits you own and can wear.")
    
    local info = vgui.Create("DPanel", frame)
    info:SetSize(infow+10, infoh+10)
    info:SetPos(frame:GetWide()/2-info:GetWide()/2, 5)
    
    function info:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(25,25,25,255))
        draw.DrawText("These are the outfits you own and can wear.", "Trebuchet19", 5, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
    end
    
    local outfitList = vgui.Create("DPanelList", frame)
    outfitList:SetSize(580, 470)
    outfitList:SetPos(frame:GetWide()/2-outfitList:GetWide()/2, 5+info:GetTall()+10)
    outfitList:SetSpacing(10)
    outfitList:EnableHorizontal(true)
    outfitList:EnableVerticalScrollbar(true)
    
    for k,v in pairs(clothes_table) do
        if v then
            local clothesBackground = vgui.Create("DPanel")
            clothesBackground:SetSize(275, 275)
            
            function clothesBackground:Paint(w,h)
                draw.RoundedBox(8, 0, 0, w, h, Color(39,168,216,255))
                draw.RoundedBox(8, 1, 1, w-2,h-2, Color(35,35,35,255))
            end
            
            local name = vgui.Create("DLabel", clothesBackground)
            name:SetFont("Trebuchet19")
            name:SetTextColor(Color(255,255,255,255))
            name:SetText(string.gsub(ClothesNumberToName(k), "_", " "))
            name:SizeToContents()
            name:SetPos(clothesBackground:GetWide()/2-name:GetWide()/2, 10)
            
            local mdl = vgui.Create("DModelPanel", clothesBackground)
            mdl:SetSize(200, 200)
            mdl:SetPos(clothesBackground:GetWide()/2-mdl:GetWide()/2, 15)
            mdl:SetModel(GAMEMODE.OCRP_Models[gender .. "s"][face][ClothesNumberToName(k)])
            
            function mdl:LayoutEntity(Entity)
                Entity:SetAngles(Angle(0, 45, 0))
            end
            
            function mdl:Think()
                if self:IsHovered() then
                    self:SetCursor("arrow")
                end
            end
            
            if LocalPlayer():GetModel() == GAMEMODE.OCRP_Models[gender .. "s"][face][ClothesNumberToName(k)] then
                local wearing = vgui.Create("DLabel", clothesBackground)
                wearing:SetFont("UiBold")
                wearing:SetTextColor(Color(39,168,216,255))
                wearing:SetText("Currently Wearing")
                wearing:SizeToContents()
                wearing:SetPos(clothesBackground:GetWide()/2-wearing:GetWide()/2, clothesBackground:GetTall()-40)
            else
                local select = vgui.Create("OCRP_BaseButton", clothesBackground)
                select:SetSize(150, 30)
                select:SetPos(clothesBackground:GetWide()/2-select:GetWide()/2, clothesBackground:GetTall()-50)
                select:SetText("Wear Outfit")
                
                function select:DoClick()
                    net.Start("OCRP_ChangeOutfit")
                    net.WriteInt(k, 32)
                    net.SendToServer()
                    frame:Remove()
                end
            end
            
            outfitList:AddItem(clothesBackground)
        end
    end
end
net.Receive("OCRP_ShowWardrobe", function(len)
	OCRP_Wardrobe()
end)

local function OCRP_Model()
	if LocalPlayer():Team() != CLASS_CITIZEN then
		return false
	end
    
    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(750, 380)
    frame:Center()
    frame:SetOCRPTitle("Buy New Clothes - $5,000 each")
    frame:AllowCloseButton(true)
    frame:MakePopup()
    
    -- The translucentish background behind the preview area
    -- Decided not to paint this. Really just a placeholder now
    
    local PreviewPanel = vgui.Create( "DPanel", frame )
	PreviewPanel:SetTall( 370 )
	PreviewPanel:SetWide( 210 )
	PreviewPanel:SetPos( 530, 10 )
	PreviewPanel.Paint = function()
		--draw.RoundedBox(8,1,1,PreviewPanel:GetWide()-2,PreviewPanel:GetTall()-2,Color(255,255,255,255))
        --draw.RoundedBox(8,2,2,PreviewPanel:GetWide()-4,PreviewPanel:GetTall()-4,Color(20,20,20,255))
	end
    
    -- The model display for the preview
    
    local PreviewMdl = vgui.Create( "DModelPanel", PreviewPanel )
	PreviewMdl:SetTall( 240 )
	PreviewMdl:SetWide( 200 )
	PreviewMdl:SetPos( 5, 5 )
	PreviewMdl:SetModel( LocalPlayer():GetModel() )	
	PreviewMdl:SetCamPos( Vector( 50, 0, 50 ) )
    PreviewMdl:SetModel(LocalPlayer():GetModel())
    
    function PreviewMdl:Think()
        if self:IsHovered() then
            self:SetCursor("arrow")
        end
    end
    
    frame.Close:MoveToFront()
    
    -- The slider that controls angle of the display
    
    local PreviewSlider = vgui.Create( "DNumSlider", PreviewPanel )
	PreviewSlider:SetWide( 200 )
	PreviewSlider:SetPos( 10, 250 )
	PreviewSlider:SetText( "Angle" )
	PreviewSlider:SetMax( 360 )
	PreviewSlider:SetMin( 0 )
	PreviewSlider:SetDecimals( 0 )
    PreviewSlider:SetValue(0)
    PreviewSlider.TextArea:SetTextColor(Color(39,168,216,255))
    PreviewSlider.Label:SetTextColor(Color(39,168,216,255))
    
    function PreviewMdl:LayoutEntity( ent )
		ent:SetAngles( Angle( 0, PreviewSlider:GetValue(), 0) )
	end
    
    -- The button to set view to face area
    
    local FaceButton = vgui.Create("OCRP_BaseButton", PreviewPanel)
	FaceButton:SetPos(10,297)
	FaceButton:SetSize(190,26)
	FaceButton:SetText("View Face")
	FaceButton.DoClick = function()
		PreviewMdl:SetCamPos( Vector( 50, 0, 60) )
		PreviewMdl:SetLookAt( Vector( 0, 0, 60) )
		PreviewMdl:SetFOV( 40 )
	end
    
    -- The button to set view to body area
    
    local BodyButton = vgui.Create("OCRP_BaseButton", PreviewPanel)
	BodyButton:SetPos(10,333)
	BodyButton:SetSize(190,26)
	BodyButton:SetText("View Body")
	BodyButton.DoClick = function()
		PreviewMdl:SetCamPos( Vector( 50, 0, 50) )
		PreviewMdl:SetLookAt( Vector( 0, 0, 40) )
		PreviewMdl:SetFOV( 70 )	
	end
    
    -- The grid container that holds our clothing choices
    
    local MainClothes = vgui.Create( "DPanelList", frame )
	MainClothes:SetTall( 370 )
	MainClothes:SetWide( 520 )
	MainClothes:SetPos( 5, 10 )
	MainClothes:SetSpacing( 4 )
	MainClothes:EnableHorizontal( true )
	MainClothes:EnableVerticalScrollbar( true )
	MainClothes.Paint = function() end
    
    for k, v in pairs( GAMEMODE.OCRP_Models[gender .."s"][face]  ) do
    
		local ClothesList = vgui.Create( "DPanel" )
		ClothesList:SetTall( 179 )
		ClothesList:SetWide( 166 )
		ClothesList:SetPos( 0, 0 )
		ClothesList.Paint = function()
			draw.RoundedBox(8,0,0,ClothesList:GetWide(),ClothesList:GetTall(),Color(60,60,60,180))
		end
		
		local ClothesName = vgui.Create( "DLabel", ClothesList )
		ClothesName:SetFont( "TargetIDSmall" )
		ClothesName:SetText( string.gsub(k, "_", " ") )
		ClothesName:SetColor( Color( 255, 255, 255, 255 ) )
		
		surface.SetFont( "TargetIDSmall" )
		local x, y = surface.GetTextSize( string.gsub(k, "_", " "))
		ClothesName:SizeToContents()
		ClothesName:SetPos( ClothesList:GetWide()/2-ClothesName:GetWide()/2, 7 )
		
		local ClothesMdl = vgui.Create( "DModelPanel", ClothesList )
        ClothesMdl:SetSize(120, 120)
		ClothesMdl:SetModel( v )
		ClothesMdl:SetPos( ClothesList:GetWide()/2-ClothesMdl:GetWide()/2, 15)
        
        function ClothesMdl:Think()
            if self:IsHovered() then
                self:SetCursor("arrow")
            end
        end
        
        local TryOnButton = vgui.Create("OCRP_BaseButton", ClothesList)
        TryOnButton:SetSize(100,15)
        TryOnButton:SetPos(ClothesList:GetWide()/2-TryOnButton:GetWide()/2, ClothesList:GetTall()-40)
        TryOnButton:SetText("Try On")
        TryOnButton.DoClick = function()
            PreviewMdl:SetModel( v )
        end
        
        if k == "Formal" and LocalPlayer():GetLevel() > 3 then
            local cant = vgui.Create("DLabel", ClothesList)
            cant:SetFont("UiBold")
            cant:SetText("Cannot Purchase")
            cant:SizeToContents()
            cant:SetPos(ClothesList:GetWide()/2-cant:GetWide()/2, ClothesList:GetTall()-20)
            cant:SetTextColor(Color(255,0,0,255))
        else
            
            local BuyClothesButton = vgui.Create("OCRP_BaseButton", ClothesList)
            BuyClothesButton:SetSize(100,15)
            BuyClothesButton:SetPos(ClothesList:GetWide()/2-BuyClothesButton:GetWide()/2, ClothesList:GetTall()-20)
            BuyClothesButton:SetText("Buy")
            BuyClothesButton.DoClick = function()
                net.Start("OCRP_BuyOutfit")
                net.WriteString(k)
                net.SendToServer()
                frame:Remove()
            end
        end
		
		MainClothes:AddItem( ClothesList )
	end
end
net.Receive("OCRP_ShowModel", function(len)
	OCRP_Model()
end)

--[[function OCRP_Gender()
	local Gender_Frame = vgui.Create( "DFrame" )
	Gender_Frame:SetTall( 400 )
	Gender_Frame:SetWide( 400 )
	Gender_Frame:Center()
	Gender_Frame:SetTitle( "Select your gender.." )
	Gender_Frame:ShowCloseButton( false )
	Gender_Frame.Paint = function()
								Draw_OCRP_BackgroundBlur(Gender_Frame)
								return false
						end
	Gender_Frame:SetBackgroundBlur( true )
	Gender_Frame:MakePopup()

	local Gender_Male_Model = vgui.Create( "DModelPanel", Gender_Frame )
	Gender_Male_Model:SetTall( 170 )
	Gender_Male_Model:SetWide( 185 )
	Gender_Male_Model:SetPos( 10, 25 )
	Gender_Male_Model:SetModel( "kaldkkda.mdl" )
	
	local Gender_Female_Model = vgui.Create( "DModelPanel", Gender_Frame )
	Gender_Female_Model:SetTall( 170 )
	Gender_Female_Model:SetWide( 185 )
	Gender_Female_Model:SetPos( 205, 25 )
	Gender_Female_Model:SetModel( "kaldkkda.mdl" )
	
	local Gender_Male_Info_List2 = vgui.Create( "DPanel", Gender_Frame )
	Gender_Male_Info_List2:SetTall( 170 )
	Gender_Male_Info_List2:SetWide( 185 )
	Gender_Male_Info_List2:SetPos( 10, 200 )
	
	local Gender_Male_Info_Text = vgui.Create( "DLabel", Gender_Male_Info_List2 )
	Gender_Male_Info_Text:SetPos( 5, 5 )
	Gender_Male_Info_Text:SetTall( 160 )
	Gender_Male_Info_Text:SetWide( 175 )
	Gender_Male_Info_Text:SetText( "This is a male, he has all the features of a male." )
	Gender_Male_Info_Text:SetWrap( true )
	
	
	local Gender_Female_Info = vgui.Create( "DPanel", Gender_Frame )
	Gender_Female_Info:SetTall( 170 )
	Gender_Female_Info:SetWide( 185 )
	Gender_Female_Info:SetPos( 200, 200 )
end]]

net.Receive("OCRP_ShowStartModel", function()
	OCRP_Start_Model()
end)


function OCRP_Start_Model()
    
    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(750, 390)
    frame:Center()
    frame:SetOCRPTitle("Choose a Model")
    frame:AllowCloseButton(false)
    frame:MakePopup()
    
    -- The translucentish background behind the preview area
    
    local PreviewPanel = vgui.Create( "DPanel", frame )
	PreviewPanel:SetTall( 370 )
	PreviewPanel:SetWide( 210 )
	PreviewPanel:SetPos( 530, 10 )
	PreviewPanel.Paint = function()
		--draw.RoundedBox(8,1,1,PreviewPanel:GetWide()-2,PreviewPanel:GetTall()-2,Color(255,255,255,255))
        --draw.RoundedBox(8,2,2,PreviewPanel:GetWide()-4,PreviewPanel:GetTall()-4,Color(20,20,20,255))
	end
    
    -- The model display for the preview
    
    local PreviewMdl = vgui.Create( "DModelPanel", PreviewPanel )
	PreviewMdl:SetTall( 240 )
	PreviewMdl:SetWide( 200 )
	PreviewMdl:SetPos( 5, 5 )
	PreviewMdl:SetModel( LocalPlayer():GetModel() )	
	PreviewMdl:SetCamPos( Vector( 50, 0, 50 ) )
    PreviewMdl:SetModel(LocalPlayer():GetModel())
    
    -- The slider that controls angle of the display
    
    local PreviewSlider = vgui.Create( "DNumSlider", PreviewPanel )
	PreviewSlider:SetWide( 200 )
	PreviewSlider:SetPos( 10, 250 )
	PreviewSlider:SetText( "Angle" )
	PreviewSlider:SetMax( 360 )
	PreviewSlider:SetMin( 0 )
	PreviewSlider:SetDecimals( 0 )
    PreviewSlider:SetValue(0)
    PreviewSlider.TextArea:SetTextColor(Color(39,168,216,255))
    PreviewSlider.Label:SetTextColor(Color(39,168,216,255))
    
    function PreviewMdl:LayoutEntity( ent )
		ent:SetAngles( Angle( 0, PreviewSlider:GetValue(), 0) )
	end
    
    -- The button to set view to face area
    
    local FaceButton = vgui.Create("OCRP_BaseButton", PreviewPanel)
	FaceButton:SetPos(10,297)
	FaceButton:SetSize(190,26)
	FaceButton:SetText("View Face")
	FaceButton.DoClick = function()
		PreviewMdl:SetCamPos( Vector( 50, 0, 60) )
		PreviewMdl:SetLookAt( Vector( 0, 0, 60) )
		PreviewMdl:SetFOV( 40 )
	end
    
    -- The button to set view to body area
    
    local BodyButton = vgui.Create("OCRP_BaseButton", PreviewPanel)
	BodyButton:SetPos(10,333)
	BodyButton:SetSize(190,26)
	BodyButton:SetText("View Body")
	BodyButton.DoClick = function()
		PreviewMdl:SetCamPos( Vector( 50, 0, 50) )
		PreviewMdl:SetLookAt( Vector( 0, 0, 40) )
		PreviewMdl:SetFOV( 70 )	
	end
    
    -- The grid container that holds our clothing choices
    
    local MainClothes = vgui.Create( "DPanelList", frame )
	MainClothes:SetTall( 370 )
	MainClothes:SetWide( 520 )
	MainClothes:SetPos( 5, 10 )
	MainClothes:SetSpacing( 4 )
	MainClothes:EnableHorizontal( true )
	MainClothes:EnableVerticalScrollbar( true )
	MainClothes.Paint = function() end
    
    local mdls = {}
    for k,v in pairs(GAMEMODE.OCRP_Models["Males"]) do
        mdls["Male " .. k] = v
    end
    for k,v in pairs(GAMEMODE.OCRP_Models["Females"]) do
        mdls["Female " .. k] = v
    end
    
    for k, v in pairs( mdls ) do
    
		local ClothesList = vgui.Create( "DPanel" )
		ClothesList:SetTall( 155 )
		ClothesList:SetWide( 120 )
		ClothesList:SetPos( 0, 0 )
		ClothesList.Paint = function()
			draw.RoundedBox(8,0,0,ClothesList:GetWide(),ClothesList:GetTall(),Color(60,60,60,180))
		end
		
		local ClothesName = vgui.Create( "DLabel", ClothesList )
		ClothesName:SetFont( "TargetIDSmall" )
		ClothesName:SetText( k )
		ClothesName:SetColor( Color( 255, 255, 255, 255 ) )
		
		surface.SetFont( "TargetIDSmall" )
		local x, y = surface.GetTextSize( k)
		ClothesName:SetPos( 59 - ( x / 2 ), 2 )
		ClothesName:SizeToContents()
		
		local ClothesMdl = vgui.Create( "DModelPanel", ClothesList )
		ClothesMdl:SetTall( 94 )
		ClothesMdl:SetWide( 94 )
		ClothesMdl:SetModel( v["Regular"] )
		ClothesMdl:SetPos( 12, 20 )
        
        function ClothesMdl:Think()
            if self:IsHovered() then
                self:SetCursor("arrow")
            end
        end
		
		local TryOnButton = vgui.Create("OCRP_BaseButton", ClothesList)
		TryOnButton:SetPos(10,115)
		TryOnButton:SetSize(100,15)
		TryOnButton:SetText("Try On")
		TryOnButton.DoClick = function()
			PreviewMdl:SetModel( v["Regular"] )
		end
        
		local BuyClothesButton = vgui.Create("OCRP_BaseButton", ClothesList)
		BuyClothesButton:SetPos(10,135)
		BuyClothesButton:SetSize(100,15)
		BuyClothesButton:SetText("Select")
		BuyClothesButton.DoClick = function()
			net.Start("OCRP_InitialFaceChoice")
			net.WriteString(k)
			net.SendToServer()
			frame:Remove()
		end
		
		MainClothes:AddItem( ClothesList )
	end
    
end