local TotalPlayTime = TotalPlayTime or 0
local SessionPlayTime = SessionPlayTime or 0

timer.Create("OCRP_UpdatePlaytime", 60, 0, function()
    TotalPlayTime = TotalPlayTime + 1
    SessionPlayTime = SessionPlayTime + 1
end)

net.Receive("OCRP_Update_PlayTime", function()
    TotalPlayTime = net.ReadInt(32)
    SessionPlayTime = 0
end)

OCRP_Alerts = {}
local matoc = Material( "gui/OCRP/OCRP_Orange" )
local matLogo = Material("gui/OCRP/zeta_banner_big.png")
surface.CreateFont("UiBold", {
    font="Tahoma",
    size=12,
    weight=1000,
})
surface.CreateFont("TargetID", {
    font="Trebuchet MS",
    size=22,
    weight=900,
    antialias=true
})
surface.CreateFont("A60", {
    font="Tahoma", -- Used to be Arista 2.0
    size=60,
    weight=400,
    antialias=true,
    shadow=false
})
surface.CreateFont("TargetIDLarge", {
    font="TargetID",
    size=40,
    weight=600,
    antialias=true,
    shadow=false,
})
surface.CreateFont("Trebuchet19", {
    font="Trebuchet MS",
    size=19,
    weight=900
})
surface.CreateFont("Trebuchet22", {
    font="Trebuchet MS",
    size=22,
    weight=900
})
surface.CreateFont("HUDNumber2", {
    font="Trebuchet MS",
    size=42,
    weight=900,
})

local currentlyRadioTexture = Material("ocrpradio/radio");
OCRP_Cur911Alert = {}

function CL_CreateBroadcast( umsg )
	local string = umsg:ReadString()
	local EndTime = umsg:ReadLong()
	OCRP_CurBroadcast = {Message = string,Time = EndTime}	
end
usermessage.Hook('OCRP_CreateBroadcast', CL_CreateBroadcast);

function CL_911Alert( umsg )
	local string = umsg:ReadString()
	local EndTime = umsg:ReadLong()
	OCRP_Cur911Alert = {Message = string,Time = EndTime}	
end
usermessage.Hook('OCRP_911Alert', CL_911Alert);

function CL_LifeAlert( umsg )
	local posx = umsg:ReadLong()
	local posy = umsg:ReadLong()
	local posz = umsg:ReadLong()
	local ply = umsg:ReadEntity()
	table.insert(OCRP_Alerts,{Time = CurTime() + 60,Vect = Vector(posx,posy,posz), Victim = ply})
end
usermessage.Hook('OCRP_LifeAlert', CL_LifeAlert);

net.Receive("OCRP_Arrest", function()
    local endtime = net.ReadInt(32)
    local bail = net.ReadInt(32)
    OCRP_ArrestData = {Time = endtime, Bail = bail}
    if bail > 0 and tonumber(LocalPlayer().Wallet) >= bail then
        GUI_PayBail()
    else
        OCRP_AddHint("You can't afford to pay your bail and must wait in jail.")
    end
end)

local scoreboard = nil

function GM:HUDDrawScoreboard()
	if INTRO then
		return
	end
	ScoreBoard_Frame = vgui.Create( "DPanel" )
	ScoreBoard_Frame:SetTall( 740 )
	ScoreBoard_Frame:SetWide( 850 )
	ScoreBoard_Frame:Center()
	ScoreBoard_Frame:SetVisible( true )
    
	ScoreBoard_Frame.Paint = function()
								draw.RoundedBox(8,75,11,ScoreBoard_Frame:GetWide()-75,ScoreBoard_Frame:GetTall()-12,Color(60,60,60,140))
								draw.RoundedBox(8,85,20,ScoreBoard_Frame:GetWide()-95,ScoreBoard_Frame:GetTall()-32,Color(128,128,128,140))
                                
                                --[[surface.SetMaterial(Gradient_Down)
                                surface.SetDrawColor(0,64,97,255)
                                surface.DrawTexturedRect(85,20,755,140)
                                surface.SetMaterial(Gradient_Up)
                                surface.DrawTexturedRect(85,20,755,140)]]
								--draw.RoundedBox(8,85,20,755,70,Color(0, 64, 97,255))
								--draw.RoundedBox(8,85,80,755,70,Color(0, 64, 97,255))
							
                                surface.SetMaterial(matLogo)
                                surface.SetDrawColor(255,255,255,255)
                                surface.DrawTexturedRect(85, 20, 755, 128)
                            
								surface.SetMaterial(matoc)
								surface.SetDrawColor(255,255,255,255)
								surface.DrawTexturedRect(10,0,165,165)
							
								--[[local struc = {}
								struc.pos = {}
								struc.pos[1] = 500 -- x pos
								struc.pos[2] = 44 -- y pos
								--struc.color = Color(255,120,0,255) -- Red
                                struc.color = Color(255,255,255,255)
								struc.text = "OCRP" -- Text
								struc.font = "A60" -- Font
								struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
								struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
								draw.Text( struc )
							
								local struc = {}
								struc.pos = {}
								struc.pos[1] = 500 -- x pos
								struc.pos[2] = 110 -- y pos
								--struc.color = Color(255,120,0,255) -- Red
                                struc.color = Color(255,255,255,255)
								struc.text = "www.ZetaGaming.net" -- Text
								struc.font = "A60" -- Font
								struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
								struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
								draw.Text( struc )]]
							end
							
	local SList = vgui.Create( "DPanelList", ScoreBoard_Frame )
	SList:SetPos( 85, 160 )
	SList:SetTall( 570 )
	SList:SetWide( 755 )
	SList.Paint = function() return false end
	SList:SetSpacing( 5 )
	SList:EnableHorizontal( true )
	SList:EnableVerticalScrollbar( true )
	
	for k, v in pairs( player.GetAll() ) do
		local teamclr = team.GetColor( v:Team() )
		local SList2 = vgui.Create( "DPanelList" )
		SList2:SetPos( 0, 0 )
		SList2:SetWide( 372.5 )
		SList2:SetTall( 80 )
		SList2.Paint = function()
							draw.RoundedBox(8,30,10,60,60,Color( teamclr.r , teamclr.g , teamclr.b , 255 ))
						end
		SList2:EnableHorizontal( true )
		SList2:SetSpacing( 0 )
		
		local Avatar = vgui.Create( "AvatarImage", SList2 )
		Avatar:SetPos( 35, 15 )
		Avatar:SetSize( 50, 50 )
        Avatar:SetPlayer(v)
        if DisguisedTable and DisguisedTable[v] then
            Avatar:SetPlayer( nil )
        end
		
		local Name = vgui.Create( "DLabel", SList2 )
		Name:SetPos( 95, 8 )
	--	Name:SetFont( "TargetID" )
	--	Name:SetColor( Color(255, 255, 255, 255) )
		Name:SetText( " " )
		Name.Paint = function()
						--[[	local struc = {}
							struc.pos = {}
							struc.pos[1] = 95 -- x pos
							struc.pos[2] = 8 -- y pos
							struc.color = Color(Cos * 255, 50, Cos * 255, Cos * 255) -- Red
							struc.text = v:Nick() -- Text
							struc.font = "TargetID" -- Font
							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
							draw.Text( struc )]]
                            surface.SetTextColor(255,255,255,255)
							if v:IsValid() then
								-- Fuck you with your little tricks for yourselves
                                --if v:SteamID() == "STEAM_0:1:15056821" or v:SteamID() == "STEAM_0:0:5300193" or v:SteamID() == "STEAM_0:0:6717638" then
								--	surface.SetTextColor( 190 * math.abs(math.sin(CurTime() * 1.2)), 0, 0, 255 )
                                local level = 5
                                if not DisguisedTable or (DisguisedTable and not DisguisedTable[v]) then
                                    level = v:GetLevel()
                                end
								if level == 4 then
									surface.SetTextColor( 0, 0, 230 * math.abs(math.sin(CurTime() * .75)), 255 )
                                elseif level == 3 then
                                    surface.SetTextColor(255 * math.abs(math.sin(CurTime()*.75)), math.abs(math.sin(CurTime()*.75))*161, 26 ,255)
								elseif level == 2 then
									surface.SetTextColor( 0, 255 * math.abs(math.sin(CurTime() * 1.2)), 0, 255 )
								elseif level < 2 then
									surface.SetTextColor( 114 * math.abs(math.sin(CurTime() * 1.2)), 0, 153 * math.abs(math.sin(CurTime()*1.2)), 255 )
                                else
									surface.SetTextColor( 255, 255, 255, 255 )
								end
							else
								return
							end
							surface.SetTextPos( 0, 0 )
							surface.SetFont( "TargetID" )
							surface.DrawText( v:Nick() )
							
							local x, y = surface.GetTextSize( v:Nick() )
							local tag
							local clr = {}
                            local level = 5
                            if not DisguisedTable or (DisguisedTable and not DisguisedTable[v]) then
                                level = v:GetLevel()
                            end
							if level == 4 then
								tag = "[VIP]"
								clr.r = 0 
								clr.g = 0 
								clr.b = 230
                            elseif level == 3 then
                                tag = "[Elite]"
                                clr.r = 255
                                clr.g = 161
                                clr.b = 26
							elseif level == 5 then
								tag = ""
								clr.r = 0 
								clr.g = 0 
								clr.b = 0
							elseif level == 0 then
								tag = "[O]"
								clr.r = 180
								clr.g = 0
								clr.b = 0
							elseif level == 1 then
								tag = "[SA]"
								clr.r = 114
								clr.g = 0
								clr.b = 153
							elseif level == 2 then
								tag = "[A]"
								clr.r = 0
								clr.g = 255
								clr.b = 0
							else
								tag = ""
								clr.r = 0 
								clr.g = 0 
								clr.b = 0
							end
							surface.SetTextColor( clr.r, clr.g, clr.b, 255 )
							surface.SetTextPos( x + 7, 0 )
							surface.SetFont( "TargetID" )
							surface.DrawText( tag )
						end
		Name:SetSize( 200, 40 )
	
-- Color(55 + 200 * math.abs(math.sin(CurTime() * 2)), 0, 0, 255)	
		local KD = vgui.Create( "DLabel", SList2 )
		KD:SetPos( 95, 28 )
		KD:SetFont( "TargetID" )
		KD:SetColor( Color(255, 255, 255, 255) )
		KD:SetText( "Kills: ".. v:Frags() ..", Deaths: ".. v:Deaths() )
		KD:SizeToContents()
		
		local Ping = vgui.Create( "DLabel", SList2 )
		Ping:SetPos( 95, 48 )
		Ping:SetFont( "TargetID" )
		Ping:SetColor( Color(255, 255, 255, 255) )
		Ping:SetText( "Ping: ".. v:Ping() )
		Ping:SizeToContents()
		
		SList:AddItem( SList2 )
	
		
	end						
	return true
end

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
---------------------------------------------------------]]
function GM:ScoreboardShow()
	if INTRO then
		return
	end
	if ( scoreboard == nil ) then
		GAMEMODE:HUDDrawScoreboard()
	else
		ScoreBoard_Frame:SetVisible( true )
	end
	gui.EnableScreenClicker(true)
end

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
---------------------------------------------------------]]
function GM:ScoreboardHide()
	if INTRO then
		return
	end
	ScoreBoard_Frame:SetVisible( false )
	gui.EnableScreenClicker(false)
end

function DeathView(ply, pos, angles, fov)
    local view = {}

	view.origin = Vector(21.912748, 973.486877, 419.072144)
	view.angles = Angle(34.760017, -91.980072, 0.000000)

			
    view.fov = fov
 
    return view
end

function GUI_PayBail()

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(260, 60)
    frame:AllowCloseButton(false)
    frame:Center()
    frame:MakePopup()
    
    local caption = vgui.Create("DLabel", frame)
    caption:SetText("Pay your bail to leave?")
    caption:SetFont("UiBold")
    caption:SizeToContents()
    caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 10)
    
    local yes = vgui.Create("OCRP_BaseButton", frame)
    yes:SetText("Pay $" .. OCRP_ArrestData.Bail)
    yes:SetSize(115, 20)
    yes:SetPos(10, 30)
    
    function yes:DoClick()
        net.Start("OCRP_Pay_Bail")
        net.SendToServer()
        frame:Remove()
    end
    
    local no = vgui.Create("OCRP_BaseButton", frame)
    no:SetText("Don't Pay")
    no:SetSize(115, 20)
    no:SetPos(135, 30)
    
    function no:DoClick()
        frame:Remove()
    end
    
end

function CL_DeathTime( umsg )
	local EndTime = umsg:ReadLong()
	local Dying = umsg:ReadBool()
	OCRP_DeathInfo = {SpawnTime = EndTime,Death = Dying}	
end
usermessage.Hook('OCRP_DeathTime', CL_DeathTime);

function GM:HUDShouldDraw(Name)
	if INTRO && Name != "CHudGMod" then
		return false
	end
	if Name == "CHudHealth" or Name == "CHudBattery" or Name =="CHudSecondaryAmmo" or Name == "CHudAmmo" then --or Name == "CHudChat" then
		return false
	end	
	if Name == "CHudDamageIndicator" && !LocalPlayer():Alive() then
		return false
	end
	if LocalPlayer():GetNWBool("Handcuffed") && Name == "CHudWeaponSelection" then
		return false
	end
	return true
end

Gradient_Down = Material("gui/gradient_down")
Gradient_Up = Material("gui/gradient_up")
Gradient = Material("gui/gradient")
OC_Logo = Material("gui/OCRP/OCRP_Orange")
OC_HpBar = Material("gui/OCRP/OCRP_HP_Bar")
OC_AmmoBar = Material("gui/OCRP/OCRP_Ammo_Bar")
OC_Money = Material("gui/OCRP/OCRP_Money")
OC_Clock = Material("gui/OCRP/OCRP_Clock")
OC_Alert = Material("gui/OCRP/OCRP_Alert")
OC_Exit = Material("gui/OCRP/OCRP_Close")
OC_Check_Box = Material("gui/OCRP/OCRP_Check_Box")
OC_Plus = Material("gui/OCRP/OCRP_+")

local Sprint_Box_y = 0
local alpha = 0 
local fade = 0 
local fade2 = 0
local fade911 = 0
local alpha911 = 0

function GM:HUDPaintBackground()

end

OCMessageTop = { Message = nil, Time = 0 }

local Messages = {"Visit our website - www.ZetaGaming.net - for ban requests, forums, suggestions, and more!"}

function UpdateOCTop()
	local Random = math.random(1,2)
	OCMessageTop = {Message = Messages[Random], Time = CurTime() + 30}
end
timer.Create("UpdateOCTop", 120, 0, UpdateOCTop)

surface.CreateFont("SpeedLimit", {
    font = "CloseCaption_Bold",
    size = 35,
    weight = 900,
    antialias = false,
    --shadow = true,
    outline = true
})

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function drawSpeedLimits(isDepth, isSkybox)
	if isSkybox then return end
    local pos = Vector(-5995, -5449, 285)
    local bounce = 20 * math.abs(math.sin(CurTime() * .9))
    pos.z = 255 + bounce
    local ang = EyeAngles()
    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), 90)
    cam.Start3D2D(pos, Angle(0,ang.y,90), 1)
        draw.DrawText("In-City Speed Limit: \n" .. GetGlobalInt("City_Speed_Limit", 40) .. " MPH", "SpeedLimit", 0, 0, Color(177,28,28,255), 1, 1)
        --draw.DrawText(tostring(GetGlobalInt("City_Speed_Limit")) .. " MPH", "Trebuchet19", 0, 20, Color(255,0,0,255), 1, 1)
    cam.End3D2D()
    
    local pos2 = Vector(-4979, -657, 263)
    pos2.z = 243 + bounce
    cam.Start3D2D(pos2, Angle(0,ang.y,90), 1)
        draw.DrawText("Out-of-City Speed Limit: \n" .. GetGlobalInt("OutCity_Speed_Limit", 60) .. " MPH", "SpeedLimit", 0, 0, Color(177,28,28,255), 1, 1)
    cam.End3D2D()
    
    --local pos3 = Vector(-6364, -6286, 302)
    local pos3 = Vector(-6394, -6286, 302)
    pos3.z = 272 + bounce
    local cost = round(1.25*(1+(GetGlobalInt("Eco_Tax")/100)), 2)
    cam.Start3D2D(pos3, Angle(0,90,90), 1)
        draw.DrawText("Gas Price: $" .. cost .. "/L", "SpeedLimit", 0, 0, Color(177,28,28,255), 1, 1)
    cam.End3D2D()
	
--[[	for k,v in pairs(ents.FindByClass("prop_dynamic")) do
		if v:GetModel() == "models/props/cs_office/radio.mdl" then
			cam.Start3D2D(v:GetPos()+Vector(0,0,50), Angle(0,ang.y,90), 1)
				draw.DrawText(v:GetNWString("ID"), "SpeedLimit", 0, 0, Color(255,0,0,255), 1, 1)
			cam.End3D2D()
		end
	end]]
	
	if not TaxiRoute then return end
	-- Draw taxi route too
	for k,v in pairs(TaxiRoute) do
		local arrow_head = {
			{ x = 25, y = 0},
			{ x = 0, y = 25},
			{ x = 50, y = 25}
		}
		if not TaxiRoute[k+1] then continue end
		local first_pos = taxi_nodes[v].Pos
		local second_pos = taxi_nodes[TaxiRoute[k+1]].Pos
		local difference = second_pos - first_pos
		local angle = Angle(0,difference:Angle().y-90,0)
		-- 0, -145, 90
		cam.Start3D2D(taxi_nodes[v].Pos+Vector(0,0,2), angle, 1)
			surface.SetDrawColor(Color(255,0,0,255))
			surface.DrawPoly(arrow_head)
			surface.DrawRect(12.5, 25, 25, 25)
		cam.End3D2D()
	end
end

hook.Add("PostDrawTranslucentRenderables", "OCRP_SpeedLimit_Draw", drawSpeedLimits)

function GM:HUDPaint()
	local client = LocalPlayer()
	local SW,SH = ScrW(),ScrH()
	if INTRO then
		GAMEMODE:Intro_Think()
		return
	end
    
    --setpos -6019.487793 -5386.847656 348.328064;setang 0.713412 -89.844528 0.000000
	
	OCRP_HintsDraw(client)

	if OCMessageTop.Message != nil then
		if OCRP_CurBroadcast then
			local broadnum = OCRP_CurBroadcast.Time or 0
			if broadnum < CurTime() then
				if OCMessageTop.Time <= CurTime() then
					if fade2 > 0 then
						fade2 = fade2 - 0.05
					elseif fade < 0 then
						fade2 = 0
					end
				else
					if fade2 < 1 then
						fade2 = fade2 + 0.01
					elseif fade2 > 1 then
						fade2 = 1
					end
				end
				
				surface.SetFont("Trebuchet19")
				local x,y = surface.GetTextSize(OCMessageTop.Message)
				
				local newx = x
				local newy = y

				surface.SetDrawColor(Color( 50, 50, 50, 255 * fade2))
				surface.DrawRect(SW/2-newx/2-30,5,newx + 60,20)
			
				surface.SetTextColor(Color(255,255,255,255 * fade2))
				surface.SetTextPos(SW/2-x/2,y/2 - 2)
				surface.DrawText(OCMessageTop.Message)
				
				surface.SetDrawColor(Color( 255, 255, 255, 255 * fade2))
				surface.SetMaterial(OC_Logo)
				surface.DrawTexturedRect(SW/2-newx/2-40,2.5,25,25)
				
				surface.SetDrawColor(Color( 255, 255, 255, 255 * fade2 ))
				surface.SetMaterial(OC_Logo)
				surface.DrawTexturedRect(SW/2+newx/2+15,2.5,25,25)
			end
		end
	end
	
	if client:Alive() or OCRP_DeathInfo.SpawnTime == nil then 
	
		if (LocalPlayer():Team() != CLASS_CITIZEN && LocalPlayer():Team() != CLASS_MAYOR && LocalPlayer():GetNWBool("tradio", false)) then
			surface.SetDrawColor(255, 255, 255, 255);
			surface.SetMaterial(currentlyRadioTexture);
			surface.DrawTexturedRect(10 + ScrH() * .1, 5, ScrH() * .1, ScrH() * .1);
		end
	
		if LocalPlayer():GetNWBool("Handcuffed") then
			surface.SetTextColor(Color(200,50,50))
			surface.SetFont("Trebuchet24")
			local x,y = surface.GetTextSize("You have been handcuffed")
			surface.SetTextPos(SW/2-x/2,SH/2-y/2)
			surface.DrawText("You have been handcuffed")
			if OCRP_ArrestData != nil && OCRP_ArrestData.Time >= CurTime() then
				surface.SetTextColor(Color(200,50,50))
				surface.SetFont("Trebuchet24")
				local x,y = surface.GetTextSize("You have been Arrested. You will be released in "..math.Round(OCRP_ArrestData.Time-CurTime()))
				surface.SetTextPos(SW/2-x/2,SH/2-100-27.5-y/2)
				surface.DrawText("You have been Arrested. You will be released in "..math.Round(OCRP_ArrestData.Time-CurTime()))
			end
			GAMEMODE:HUDDrawTargetID()
			return
		end
		
		local intAmmoInMag = 0 
		local intAmmoOutMag = 0
		if LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():IsWeapon() then
			intAmmoInMag = client:GetActiveWeapon():Clip1()
			intAmmoOutMag = client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType())
		end
	
		local Energy = CL_GetEnergy()
		local Money = client.Wallet or 0
		if alpha > 0 then
			alpha = alpha - 1
		elseif alpha < 0 then
			alpha = 0
		end
			----- Health Bar
	--	draw.RoundedBox(10,50,SH -81,351,72,Color( 50, 50, 50, 255 ))
	--	draw.RoundedBox(10,50,SH -80,350,70,Color( 210, 120, 30, 255 ))
		
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(OC_HpBar)
		surface.DrawTexturedRect(50,SH-81,351,72)
		
		surface.SetDrawColor(Color( 100, 100, 100, 255 ))
		surface.DrawRect(100,SH-42.5,280,25)
		
		surface.SetDrawColor((100 - client:Health()) * 2.55, client:Health() * 2.55, 0, 100)
		surface.DrawRect(100,SH-42.5,280*client:Health()/100,25)
		
		surface.SetDrawColor((100 - client:Health()) * 2.55, client:Health() * 2.55, 0, 190)
		surface.SetMaterial(Gradient_Down)
		surface.DrawTexturedRect(100,SH-42.5,280*client:Health()/100,25)

		surface.SetTextColor(Color(255,255,255))
		surface.SetFont("Trebuchet24")
		local x,y = surface.GetTextSize(client:Health())
		surface.SetTextPos(240-x/2,SH-27.5-y/2)
		surface.DrawText(client:Health())
		
		surface.SetDrawColor(Color( 50, 50, 50, 255 ))
		surface.DrawOutlinedRect(100,SH-42.5,281,26)
	
		--- Sprinting

		surface.SetDrawColor(Color( 100, 100, 100, 255 ))
		surface.DrawRect(100,SH-72.5,280,25)

		surface.SetDrawColor(0, 0, Energy * 2.55, 100)
		surface.DrawRect(100,SH-72.5,280*Energy/100,25)
		
		surface.SetDrawColor(0, 0, Energy * 2.55, 190)
		surface.SetMaterial(Gradient_Down)
		surface.DrawTexturedRect(100,SH-72.5,280*Energy/100,25)
		
		surface.SetTextColor(Color(255,255,255))
		surface.SetFont("Trebuchet24")
		local x,y = surface.GetTextSize(Energy)
		surface.SetTextPos(240-x/2,SH-57.5-y/2)
		surface.DrawText(Energy)	
		
		surface.SetDrawColor(Color( 50, 50, 50, 255 ))
		surface.DrawOutlinedRect(100,SH-72.5,281,26)
		
		----Cirle Health
		
		surface.SetDrawColor(Color( 255, 255, 255, 255 ))
		surface.SetMaterial(OC_Logo)
		surface.DrawTexturedRect(0,SH-100,100,100)
		
		
		--- Ammo
		
	---	draw.RoundedBox(10,SW - 201,SH -81,151,72,Color( 50, 50, 50, 255 ))
		
	--	draw.RoundedBox(10,SW - 200,SH -80,150,70,Color( 210, 120, 30, 255 ))
		if LocalPlayer():GetActiveWeapon():IsValid() && (LocalPlayer():GetActiveWeapon():Clip1() >= 0 or LocalPlayer():GetActiveWeapon().PrintName == "Police Taser") && LocalPlayer():GetActiveWeapon():GetClass() != "weapon_physcannon" then
			if LocalPlayer():GetActiveWeapon().PrintName == "Police Taser" then
				intAmmoInMag = "∞"
				intAmmoOutMag = "∞"
			end
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(OC_AmmoBar)
			surface.DrawTexturedRect(SW - 180,SH -80,151,72)
			
			surface.SetTextColor(Color(255,255,255))
			surface.SetFont("HUDNumber5")
			local x,y = surface.GetTextSize( intAmmoInMag)
			surface.SetTextPos(SW - 145 -x/2,SH-40-y/2)
			surface.DrawText( intAmmoInMag)
			
			surface.SetTextColor(Color(255,255,255))
			surface.SetFont("Trebuchet24")
			local x,y = surface.GetTextSize( intAmmoOutMag)
			surface.SetTextPos(SW - 85 -x/2,SH-25-y/2)
			surface.DrawText( intAmmoOutMag)
		end

		
		--- Circle ammo
		--surface.SetDrawColor(Color( 255, 255, 255, 255 ))
		--surface.SetMaterial(OC_Logo)
		--surface.DrawTexturedRect(SW - 70,SH-70,70,70)
		
		
		-- Money
		
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(OC_HpBar)
		surface.DrawTexturedRect(25,SH-140,150,30)
		
		surface.SetTextColor(Color(255,255,255,255))
		surface.SetFont("Trebuchet24")
		local x,y = surface.GetTextSize(Money)
		surface.SetTextPos(100 -x/2,SH-125-y/2)
		surface.DrawText(Money)
		
		--- Circle Money
		surface.SetDrawColor(Color( 255, 255, 255, 255 ))
		surface.SetMaterial(OC_Money)
		surface.DrawTexturedRect(0,SH-150,50,50)
		
		-- Clock, Playtime
		
		surface.SetDrawColor(Color( 255, 255, 255, 255 ))
		surface.SetMaterial(OC_Clock)
		surface.DrawTexturedRect(10,10,50,50)
       -- surface.DrawTexturedRect(10,65,50,50)
        
        local totalText = formatPlayTime(TotalPlayTime)
        local sessionText = formatPlayTime(SessionPlayTime)
        
        surface.SetTextColor(255,255,255,255)
        surface.SetFont("Trebuchet24")
        local x,y = surface.GetTextSize(totalText)
        surface.SetTextPos(65, 35-y/2)
        surface.DrawText(totalText)
        --[[local x,y = surface.GetTextSize(sessionText)
        surface.SetTextPos(65, 90-y/2)
        surface.DrawText(sessionText)]]
        
		
		-- Eco points 
		
		surface.SetDrawColor(Color( 0, 0, 0, 255 ))
		surface.DrawOutlinedRect(SW - 251,24,202,12)
		
		surface.SetDrawColor(Color( 0, 255, 0, 255 ))
		surface.DrawRect(SW - 250,25,200,10)
		
		surface.SetDrawColor(255, 0, 0, 255)
		surface.SetMaterial(Gradient)
		surface.DrawTexturedRect(SW - 250,25,200,10)
		
		surface.SetDrawColor(Color( 0, 0, 0, 255 ))
		surface.DrawLine(SW-150,25,SW-150,40)
		surface.DrawLine(SW-251,25,SW-251,40)
		surface.DrawLine(SW-50,25,SW-50,40)
		
		surface.SetTextColor(255,255,255,255)
		surface.SetFont("Trebuchet24")
		local x,y = surface.GetTextSize("Economy")
		surface.SetTextPos(SW-150-x/2,2)
		surface.DrawText("Economy")
		
		surface.SetDrawColor(Color( 255, 255, 255, 255 ))
		surface.SetMaterial(OC_Money)
		surface.DrawTexturedRect(SW-150-5+(100*(GetGlobalInt("Eco_points")/50)),25,10,10)
        
        surface.SetFont("UiBold")
        local x2,y2 = surface.GetTextSize("Tax Rate: " .. tostring(GetGlobalInt("Eco_Tax", 0)) .. "%")
        surface.SetTextPos(SW-150-x2/2,38)
        surface.DrawText("Tax Rate: " .. tostring(GetGlobalInt("Eco_Tax", 0)) .. "%")

		if OCRP_CurBroadcast.Message != nil then

			if OCRP_CurBroadcast.Time <= CurTime() then
				if fade > 0 then
					fade = fade - 0.05
				elseif fade < 0 then
					fade = 0
				end
			else
				if fade < 1 then
					fade = fade + 0.01
				elseif fade > 1 then
					fade = 1
				end
			end
			
			surface.SetFont("Trebuchet19")
			local x,y = surface.GetTextSize(OCRP_CurBroadcast.Message)
			local x1,y1 = surface.GetTextSize("Broadcast")
			
			local newx = 1
			local newy = 1
			
			if x1 >= x then
				newx = x1
				newy = y1
			else
				newx = x
				newy = y
			end
	
			surface.SetDrawColor(Color( 50, 50, 50, 255 * fade))
			surface.DrawRect(SW/2-newx/2-30,5,newx + 60,40)
			
			surface.SetTextColor(Color(200,55,55,255 * fade))
			surface.SetTextPos(SW/2-x1/2,y1/2 - 2)
			surface.DrawText("Broadcast")
		
			surface.SetTextColor(Color(255,255,255,255 * fade))
			surface.SetTextPos(SW/2-x/2,15+y/2)
			surface.DrawText(OCRP_CurBroadcast.Message)
			
			surface.SetDrawColor(Color( 255, 255, 255, 255 * fade))
			surface.SetMaterial(OC_Alert)
			surface.DrawTexturedRect(SW/2-newx/2-55,0,50,50)
			
			surface.SetDrawColor(Color( 255, 255, 255, 255 * fade ))
			surface.SetMaterial(OC_Alert)
			surface.DrawTexturedRect(SW/2+newx/2+5,0,50,50)
			
		end
		
		if OCRP_Cur911Alert.Message != nil && LocalPlayer():Team() != CLASS_CITIZEN then
			if OCRP_Cur911Alert.Time <= CurTime() then
				if fade911 > 0 then
					fade911 = fade911 - 0.05
				elseif fade911 < 0 then
					fade911 = 0
				end
			else
				if fade911 < 1 then
					fade911 = fade911 + 0.01
				elseif fade911 > 1 then
					fade911 = 1
				end
			end
			
			surface.SetFont("UiBold")
			local x,y = surface.GetTextSize(OCRP_Cur911Alert.Message)
			local x1,y1 = surface.GetTextSize("Broadcast")
			
			local newx = 1
			local newy = 1
			
			if x1 >= x then
				newx = x1
				newy = y1
			else
				newx = x
				newy = y
			end
	
			draw.RoundedBox(8,SW/2-newx/2-30,10+41,newx + 60,28,Color( 50, 50, 50, 255 * fade911))
			
			surface.SetTextColor(Color(200,55,55,255 * fade911))
			surface.SetTextPos(SW/2-x1/2,y1/2 - 2 + 50)
			surface.DrawText("911 Call : ")
		
			surface.SetTextColor(Color(255,255,255,255 * fade911))
			surface.SetTextPos(SW/2-x/2,59+y/2)
			surface.DrawText(OCRP_Cur911Alert.Message)
			
			surface.SetDrawColor(Color( 255, 255, 255, 255 * fade911))
			surface.SetMaterial(OC_Alert)
			surface.DrawTexturedRect(SW/2-newx/2-35,50,30,30)
			
			surface.SetDrawColor(Color( 255, 255, 255, 255 * fade911 ))
			surface.SetMaterial(OC_Alert)
			surface.DrawTexturedRect(SW/2+newx/2+5,50,30,30)	
		end 
		
		if LocalPlayer():InVehicle() && !LocalPlayer():GetVehicle():GetParent():IsValid() then
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(OC_HpBar)
			surface.DrawTexturedRect(SW - 480,SH -70,300,60)
			
			surface.SetDrawColor(Color( 100, 100, 100, 255 ))
			surface.DrawRect(SW -465,SH-45,270,25)
            
            local gas = OCRP_VehicleGas
            if GAMEMODE.OCRP_Cars[LocalPlayer():GetVehicle():GetCarType()] then
                gas = GAMEMODE.OCRP_Cars[LocalPlayer():GetVehicle():GetCarType()].GasTank
            end
			surface.SetDrawColor(math.Round(255-((OCRP_VehicleGas/gas) * 255)),math.Round((gas) * 255), 0, 100)
			surface.DrawRect(SW -465,SH-45,270*OCRP_VehicleGas/gas,25)
			
			surface.SetDrawColor(math.Round(255-((OCRP_VehicleGas/gas) * 255)),math.Round((OCRP_VehicleGas/gas) * 255), 0, 100)
			surface.SetMaterial(Gradient_Down)
			surface.DrawTexturedRect(SW -465,SH-45,270*OCRP_VehicleGas/gas,25)
			
			surface.SetDrawColor(Color( 50, 50, 50, 255 ))
			surface.DrawOutlinedRect(SW -465,SH-45,271,26)
			
			surface.SetTextColor(Color(255,255,255))
			surface.SetFont("UiBold")
			local x,y = surface.GetTextSize("Gas Tank: "..math.Round(((OCRP_VehicleGas)/gas)*100).."%")	
			surface.SetTextPos(SW -330 -x/2,SH-33-y/2)
			surface.DrawText("Gas Tank: "..math.Round(((OCRP_VehicleGas)/gas)*100).."%")		
				
			local speed = math.Round( ( LocalPlayer():GetVehicle():OBBCenter() - LocalPlayer():GetVehicle():GetVelocity() ):Length() / 17.6 )
			if speed <= 3 then
				draw.SimpleTextOutlined("Speed: 0 MPH", 'Trebuchet22', SW - 340, SH -55, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1.5,Color(0,0,0,155));	
			else
				draw.SimpleTextOutlined("Speed: "..speed.." MPH", 'Trebuchet22', SW - 330, SH -55, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1.5,Color(0,0,0,155));	
			end
	
		end
		GAMEMODE:HUDDrawTargetID()
	else
		if !OCRP_DeathInfo.Death then
		--	hook.Add("CalcView", "DeathView", DeathView)
			if alpha < 255 then
				alpha = alpha + 0.1
			elseif alpha > 255 then
				alpha = 255
			end
			surface.SetDrawColor(0,0,0,alpha)
			surface.DrawRect(0,0,ScrW(),ScrH())

			surface.SetFont("Trebuchet24")
			
			if CurTime() > OCRP_DeathInfo.SpawnTime then
				surface.SetTextColor(Color(55,200,55,255))
				local x,y = surface.GetTextSize("Waking Up")
				surface.SetTextPos(SW/2-x/2,SH/2-y/2)
				surface.DrawText("Waking Up")
				OCRP_DeathInfo.Death = false
			else
				surface.SetTextColor(Color(255,255,255,255))
				local x,y = surface.GetTextSize("You're unconscious, waking up in "..((math.Round((CurTime()-OCRP_DeathInfo.SpawnTime)*-10))/10))
				surface.SetTextPos(SW/2-x/2,SH/2-y/2)
				surface.DrawText("You're unconscious, waking up in "..((math.Round((CurTime()-OCRP_DeathInfo.SpawnTime)*-10))/10))
			end
		else
		--	hook.Add("CalcView", "DeathView", DeathView)
			if alpha < 255 then
				alpha = alpha + 0.1
			elseif alpha > 255 then
				alpha = 255
			end
			surface.SetDrawColor(0,0,0,alpha)
			surface.DrawRect(0,0,ScrW(),ScrH())

			surface.SetFont("Trebuchet24")
			
			if CurTime() > OCRP_DeathInfo.SpawnTime then
				surface.SetTextColor(Color(55,200,55,255))
				local x,y = surface.GetTextSize("Respawning..")
				surface.SetTextPos(SW/2-x/2,SH/2-y/2)
				surface.DrawText("Respawning..")
				OCRP_DeathInfo.Death = false
			else
				surface.SetTextColor(Color(255,255,255,255))
				local x,y = surface.GetTextSize("Respawning in "..((math.Round((CurTime()-OCRP_DeathInfo.SpawnTime)*-10))/10))
				surface.SetTextPos(SW/2-x/2,SH/2-y/2)
				surface.DrawText("Respawning in "..((math.Round((CurTime()-OCRP_DeathInfo.SpawnTime)*-10))/10))
			end
		end
	end
end


DeathAlert = Material("materials/icons/heart-break.png")

function GM:HUDDrawTargetID()
	if INTRO then
		return
	end
	--[[if LocalPlayer():Team() == CLASS_MEDIC then
		for _,data in pairs(OCRP_Alerts) do
			if data.Time >= CurTime() then
				if data.Time - CurTime() < 59 and data.Victim:IsValid() and data.Victim:Alive() then
					table.remove(OCRP_Alerts,_)
					return
				end
				local pos = data.Vect:ToScreen()
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(DeathAlert)
				surface.DrawTexturedRect(pos.x-8,pos.y,16,16)
				surface.SetFont("UiBold")
				if not data.DrawnMap then
					DrawLifeAlert(data.Vect, data.Victim)
					OCRP_AddHint("A life alert has been activated, check your map for the location!")
				end
				data.DrawnMap = true
				
				local x,y = surface.GetTextSize("Distance : ".. math.Round(data.Vect:Distance(LocalPlayer():GetPos())))
				
				surface.SetTextPos(pos.x - (x/2),pos.y - 16)
				surface.DrawText("Distance : ".. math.Round(data.Vect:Distance(LocalPlayer():GetPos())))
			else
				table.remove(OCRP_Alerts,_)
			end
		end
	end]]
	-- Doors
	if LocalPlayer():InVehicle() then  
		if LocalPlayer():Team() == CLASS_POLICE || LocalPlayer():Team() == CLASS_CHIEF then
			for _,ent in pairs(ents.FindByClass("prop_vehicle_jeep")) do
				if ent:GetPos():Distance(LocalPlayer():GetPos()) <= 700 && LocalPlayer():GetVehicle() != ent then
					local OurPos = ent:GetPos() + Vector(0, 0, 64);
					local Pos = ent:LocalToWorld(ent:OBBCenter()):ToScreen();
					local speed = math.Round((  ent:OBBCenter() -  ent:GetVelocity() ):Length() * (5024/30) / (60 * 60))
					if speed <= 3 then
						draw.SimpleTextOutlined("Speed : 0 MPH", 'HUDNumber2', Pos.x, Pos.y, Color(255, 255, 255, 255), 1, 1, 2, Color(0, 0, 200, 255));	
					else
						draw.SimpleTextOutlined("Speed : "..speed.." MPH", 'HUDNumber2', Pos.x, Pos.y, Color(255, 255, 255, 255), 1, 1, 2, Color(0, 0, 200, 255));	
					end
				end
			end
		end	
	else
		local tr = util.GetPlayerTrace(LocalPlayer(),LocalPlayer():GetAimVector())
		local trace = util.TraceLine(tr)
		local OurPos = LocalPlayer():GetPos() + Vector(0, 0, 64);
		if SpecEnt then OurPos = SpecEnt:GetPos() + Vector(0,0,64) end
		if trace.Hit and trace.Entity and (trace.Entity:IsDoor() or trace.Entity:GetClass() == 'prop_vehicle_jeep') and trace.Entity:GetPos():Distance(OurPos) < 200 then	
			if trace.Entity:IsDoor() && GAMEMODE.Maps[string.lower(game.GetMap())] != nil then
				local Pos = trace.Entity:LocalToWorld(trace.Entity:OBBCenter()):ToScreen();	
                local unownable = UnOwnableDoors[trace.Entity:EntIndex()] or nil
                local propkey = OwnableDoors[trace.Entity:EntIndex()] or nil
				if trace.Entity:GetNWInt( "Owner" ) > 0 && player.GetByID(trace.Entity:GetNWInt("Owner")):IsValid() then
					draw.SimpleTextOutlined('Owner: ' .. player.GetByID(trace.Entity:GetNWInt( "Owner" )):Nick(), 'TargetIDLarge', Pos.x, Pos.y, Color(255, 255, 255, 255), 1, 1, 2, Color(113, 0, 158, 255));
					--if trace.Entity:IsVehicle() && trace.Entity:GetNWEntity("Driver"):IsValid() then
						--draw.SimpleTextOutlined('Driver: ' .. trace.Entity:GetNWEntity("Driver"):Nick(), 'TargetIDLarge', Pos.x, Pos.y - 20, Color(255, 255, 255, 255), 1, 1, 2, Color(255, 100, 0, 255));
					--end
				elseif unownable == -1 then
					draw.SimpleTextOutlined('Owned By: The City', 'TargetIDLarge', Pos.x, Pos.y, Color(200, 0, 0, 255), 1, 1, 2, Color(0, 0, 0, 255));	
				elseif unownable == -4 then
					draw.SimpleTextOutlined('Unownable', 'TargetIDLarge', Pos.x, Pos.y, Color(0, 0, 0, 255), 1, 1, 2, Color(255, 255, 255, 255));					
				elseif unownable == -2 then
					draw.SimpleTextOutlined('Owned By: Police Department', 'TargetIDLarge', Pos.x, Pos.y, Color(255, 255, 255, 255), 1, 1, 2, Color(0, 0, 200, 255));	
				elseif unownable == -3 then
					draw.SimpleTextOutlined('Public Property', 'TargetIDLarge', Pos.x, Pos.y, Color(255, 255, 255, 255), 1, 1, 2, Color(0, 0, 0, 255));	
				else
					if propkey && GAMEMODE.Properties[string.lower(game.GetMap())][propkey] != nil then 
						draw.SimpleTextOutlined(GAMEMODE.Properties[string.lower(game.GetMap())][propkey].Name, 'TargetIDLarge', Pos.x, Pos.y - 50, Color(255, 255, 255, 255), 1, 1, 2, Color(0, 117, 22, 255));
						draw.SimpleTextOutlined("For sale at the Realtor's office", 'TargetIDLarge', Pos.x, Pos.y, Color(255, 255, 255, 255), 1, 1, 2, Color(0, 117, 22, 255));
					else
						draw.SimpleText("", 'TargetIDLarge', Pos.x, Pos.y - 50, Color(255, 100, 0, 255), 1, 1);
						draw.SimpleText('', 'TargetIDLarge', Pos.x, Pos.y, Color(255, 100, 0, 255), 1, 1);
					end
				end
			end
		end
		for _,ent in pairs(OCRP_ShopItems) do
			if ent:IsValid() && ent.cl_price != nil && ent.cl_desc != nil then
				if ent:GetPos():Distance(LocalPlayer():GetPos()) <= 300 and LocalPlayer():IsLineOfSightClear(ent) then			
					local alp =  255 * (math.abs((ent:GetPos():Distance(LocalPlayer():GetPos())-300))/200)
					local entPos = ent:LocalToWorld(ent:OBBCenter()):ToScreen();
					if ent.cl_price ~= -1 then
						amt = ent.cl_amount or 1
						draw.SimpleTextOutlined(GAMEMODE.OCRP_Items[ent:GetNWString("Class")].Name.." x"..amt, 'TargetID', entPos.x, entPos.y, Color(255, 255, 255, alp), 1, 1, 1, Color(0, 0, 0, alp))
                        draw.SimpleTextOutlined("$"..ent.cl_price, 'TargetID', entPos.x, entPos.y + 40, Color(255, 255, 255, alp), 1, 1, 1, Color(0, 0,0, alp));
					end
					draw.SimpleTextOutlined(ent.cl_desc, 'TargetID', entPos.x, entPos.y + 20, Color(255, 255, 255, alp), 1, 1, 1, Color(0, 0, 0, alp));
				end
			else
				table.remove(OCRP_ShopItems,_)
			end
		end		
		for _, PLY in pairs(player.GetAll()) do
			if LocalPlayer() != PLY and PLY:Alive() then
				local VPos = PLY:GetPos() + Vector( 0, 0, 64 )
                if VPos == Vector(0,0,64) then continue end
				if SpecEnt then OurPos = SpecEnt:GetPos() + Vector(0,0,150) end
				local Distance = VPos:Distance( OurPos )
				local ScrPos = (VPos + Vector( 0, 0, 10 )):ToScreen()
				local ClrA = 255
				
				local trtbl = {}
				trtbl.start = OurPos
				trtbl.endpos = VPos
				trtbl.filter = {LocalPlayer(), PLY}
				
				local TRACE = util.TraceLine( trtbl )
				local r,g,b,a = PLY:GetColor();

				if PLY:GetObserverMode() != 4 and PLY:GetObserverMode() != 5 and a != 0 then
					if !TRACE.Hit then
						if Distance <= 1600 then  
							local alp =  255 * (math.abs((Distance-1600))/600)
							local col = team.GetColor(PLY:Team())
                            if PLY:GetColor().a ~= 0 then
                                draw.SimpleTextOutlined(PLY:Nick(), 'TargetID', ScrPos.x, ScrPos.y, Color(255, 255, 255, alp), 1, 1, 1.5, Color(col.r,col.g,col.b,alp))
                                if PLY:GetNWBool("Handcuffed") then
                                    draw.SimpleTextOutlined("Handcuffed", "TargetID", ScrPos.x, ScrPos.y -30, Color(255,0,0,255, alp), 1, 1, 1, Color(0,0,0,alp))
                                elseif PLY.InMap then
                                    draw.SimpleTextOutlined("[ In Map ]", 'TargetID', ScrPos.x, ScrPos.y - 30, Color(255, 255, 255, alp), 1, 1, 1, Color(0, 0, 0, alp))
                                elseif PLY.Typing then
                                    draw.SimpleTextOutlined("[ Typing ]", 'TargetID', ScrPos.x, ScrPos.y - 30, Color(255, 255, 255, alp), 1, 1, 1, Color(0, 0, 0, alp))
                                end
                                local VORG = PLY:GetNWString("OrgName")
                                if VORG != nil and VORG != "" and PLY:Team() == 1 then
                                    draw.SimpleTextOutlined(VORG,'TargetID', ScrPos.x, ScrPos.y - 15, Color(255, 255, 255, alp), 1, 1, 1, Color(255, 50, 0, alp))
                                end
							end
							if LocalPlayer():Team() == CLASS_POLICE ||  LocalPlayer():Team() == CLASS_CHIEF ||  LocalPlayer():Team() == CLASS_SWAT || LocalPlayer():Team()  == CLASS_Mayor then
								if LocalPlayer():InVehicle() and PLY:InVehicle() then
									local speed = math.Round( ( PLY:GetVehicle():OBBCenter() - PLY:GetVehicle():GetVelocity() ):Length() / 17.6 )
									if speed <= 3 then
										draw.SimpleTextOutlined("Speed: 0 MPH", 'TargetID', ScrPos.x, ScrPos.y + 15, Color(255, 255, 255, alp), 1, 1, 1, Color(0, 0, 200, alp))
									else
										draw.SimpleTextOutlined("Speed: ".. speed .." MPH", 'TargetID', ScrPos.x, ScrPos.y + 15, Color(255, 255, 255, alp), 1, 1, 1, Color(0, 0, 200,alp))
									end
								end
								if PLY:GetNWInt( "Warrant" ) == 1 then
									draw.SimpleTextOutlined("Search Warrant", 'TargetID', ScrPos.x, ScrPos.y + 15, Color(255, 255, 255, alp), 1, 1, 1, Color(0, 0, 255, alp))
								elseif PLY:GetNWInt( "Warrant" ) == 2 then
									draw.SimpleTextOutlined("Arrest Warrant", 'TargetID', ScrPos.x, ScrPos.y + 15, Color(255, 255, 255, alp), 1, 1, 1, Color(0, 0, 255, alp))
								end
							end
						end
					end
				end
			end
		end
	end
end

OCRP_Hints = {}
OCRP_Hints.Messages = {}
OCRP_Hints.LastAdded = 0

local Hint_Text_Height = draw.GetFontHeight("UiBold") -- Used to be DefaultBold
local RecentHints = {}
function OCRP_AddHint(Hint)
		if RecentHints[Hint] then return end
		RecentHints[Hint] = true
		timer.Simple(1, function()
			if not LocalPlayer() or not LocalPlayer():IsValid() then return end
			if not RecentHints then return end
			RecentHints[Hint] = nil
		end)
	local HintTbl = {}
	HintTbl.Text = Hint
	HintTbl.H = Hint_Text_Height + (6 * 2)
	HintTbl.Time = CurTime()
	
	if OCRP_Hints.LastAdded > (HintTbl.Time - 1) then
		HintTbl.Time = OCRP_Hints.LastAdded + 1
	end

	table.insert(OCRP_Hints.Messages, 1, HintTbl)
	AddToChatLogTable("SERVER", "HINT", Hint)

	OCRP_Hints.LastAdded = HintTbl.Time
end

function OCRP_GetHint( um )
	local Hint = um:ReadString()
	OCRP_AddHint(Hint)
end
usermessage.Hook( "OCRP_Hint", OCRP_GetHint)

function OCRP_HintsDraw(client)
	local ry = ScrH() - 300
	for _, Hint in pairs(OCRP_Hints.Messages) do
		if Hint.Time < CurTime() then
			
			local MY = -Hint.H

			local y = ry + 6 + MY

			MY = (MY < 0) and MY + 2 or 0

			local delta = (Hint.Time + 12) - CurTime()
			delta = delta / 12

			if _ >= 5 then
				delta = delta / 2
			end
			
			local A = 200

			if delta > 0.9 then
				A = math.Clamp( (1.0 - delta) * (255 / 0.1), 0, 200)
			elseif delta < 0.6 then
				A = math.Clamp( delta * (255 / 0.6), 0, 200)
			end

			local H = Hint.H
			
			surface.SetFont("UiBold") -- Used to be DefaultBold
			local x2,y2 = surface.GetTextSize(Hint.Text)
			
            draw.RoundedBox(8, ScrW() - 5 - (x2 + 40), y - 1, x2 + 30, H + 2, Color(39,168,216,A))
			draw.RoundedBox(8, ScrW() - 6 - ( x2 + 40 ), y, x2 + 30, H, Color( 25, 25, 25, 255 ) )
			
			surface.SetMaterial( OC_Logo )
			surface.DrawTexturedRect( ScrW() - 6 - ( x2 + 50 ), y - 1, H, H + 2 )
			surface.SetDrawColor( Color(0,0,0,A) )
			
			local HintTEXTColor = Color(255,255,255,255)
			HintTEXTColor.a = math.Clamp(A, 0, HintTEXTColor.a)

			local HintText = {}
			HintText.font = "UiBold" -- Used to be DefaultBold
			HintText.xalign = ScrW() - 6 - (x2+20)
			HintText.yalign = TEXT_ALIGN_TOP
			HintText.color = HintTEXTColor
            HintText.text = Hint.Text

            local x3 = ScrW() - 6 - ( x2 + 20 )
            local y3 = y + 6 + 1 * ( Hint_Text_Height - 13 )
			
            HintText.pos = {x3, y3}

            draw.Text( HintText )

			if A == 0 then 
				OCRP_Hints.Messages[_] = nil 
			end

			ry = y + H + 24
		end
	end
end

function Intro_State_Check( umsg )
	local toquery = umsg:ReadString()
	if sql.TableExists( toquery ) then
		RunConsoleCommand( "Intro_Init_Ignore" )
	end
end
usermessage.Hook( "Intro_Init_Start", Intro_State_Check )

function formatPlayTime(pt)
    local totalText = ""
    if pt < 60 then
        if pt == 1 then
            totalText = "1 Minute"
        else
            totalText = tostring(pt) .. " Minutes"
        end
    elseif pt < 1440 then
        local hours = math.floor(pt/60)
        local minutes = pt % 60
        local hoursText = ""
        local minutesText = ""
        if hours == 1 then
            hoursText = "1 Hour"
        else
            hoursText = tostring(hours) .. " Hours"
        end
        if minutes ~= 0 then
            if minutes == 1 then
                minutesText = ", 1 Minute"
            else
                minutesText = ", " .. tostring(minutes) .. " Minutes"
            end
        end
        totalText = hoursText .. minutesText
    elseif pt < 10080 then
        local days = math.floor(pt/1440)
        local hours = math.floor((pt % 1440) / 60)
        local daysText = ""
        local hoursText = ""
        if days == 1 then
            daysText = "1 Day"
        else
            daysText = tostring(days) .. " Days"
        end
        if hours ~= 0 then
            if hours == 1 then
                hoursText = ", 1 Hour"
            else
                hoursText = ", " .. tostring(hours) .. " Hours"
            end
        end
        totalText = daysText .. hoursText
    elseif pt > 10080 then
        local weeks = math.floor(pt/10080)
        local days = math.floor((pt % 10080) / 1440)
        local hours = math.floor(((pt % 10080) % 1440) / 60)
        local weeksText = ""
        local daysText = ""
        local hoursText = ""
        if weeks == 1 then
            weeksText = "1 Week"
        else
            weeksText = tostring(weeks) .. " Weeks"
        end
        if days ~= 0 then
            if days == 1 then
                daysText = ", 1 Day"
            else
                daysText = ", " .. tostring(days) .. " Days"
            end
        end
        if hours ~= 0 then
            if hours == 1 then
                hoursText = ", 1 Hour"
            else
                hoursText = ", " .. tostring(hours) .. " Hours"
            end
        end
        totalText = weeksText .. daysText .. hoursText
    end
    return totalText
end