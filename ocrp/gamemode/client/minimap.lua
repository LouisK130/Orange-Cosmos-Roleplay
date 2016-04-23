--[[function DrawMinimap()
	if not LocalPlayer().DrawMap then return end
	surface.SetDrawColor(Color(0,0,0,255))
	local height = ScrH()-100
	local width = ScrW()-100
	surface.DrawOutlinedRect((ScrW()/2)-width/2, (ScrH()/2)-height/2, width, height)
	local camd = {}
	camd.angles = Angle( 90, 0, 0 )
	--camd.origin = Vector(0,0,15000)
	camd.origin = Vector(-8120, -8237, 5000)
	camd.x = ((ScrW()/2)-width/2)+1
	camd.y = ((ScrH()/2)-height/2)+1
	camd.w = width - 2
	camd.h = height - 2
	camd.drawhud = false
	camd.dopostprocess = false
	camd.znear = 5000 - 1500
	camd.zfar = 5000 + 1000
	camd.fov = 10
	render.RenderView( camd )
	--setpos -3337.072998 -14804.811523 2848.030762
end]]
-- Called in hud.lua
local released = true
hook.Add("Think", "OCRP_MapToggle", function()
	if TYPING then return end
	if gui.IsConsoleVisible() then return end
    if vgui.GetKeyboardFocus() and not LocalPlayer().DrawingMap then return end
	if input.IsKeyDown(KEY_M) and released then
		if LocalPlayer().CantToggleMap then return end
		LocalPlayer().CantToggleMap = true
		timer.Simple(.3, function()
			LocalPlayer().CantToggleMap = false
		end)
		ToggleMap()
		released = false
	end
	if !input.IsKeyDown(KEY_M) and !released then
		released = true
	end
end)
-- lake values
--topleft_realmap = Vector(-5592, 15330, 0)
--botright_realmap = Vector(-14311, 10326, 0)

topleft_realmap = Vector(12903, 15334, 0)
botright_realmap = Vector(-14311, -12566, 0)
local x1 = 0
local y1 = 0
local rendering_map = false
worldheight = topleft_realmap.x - botright_realmap.x -- 27214
worldwidth = topleft_realmap.y - botright_realmap.y -- 27900

--[[concommand.Add("cache_minimap", function()
	CacheMinimap()
end)

local ox = -10000
local oy = 13000
local oz = 8000
local lo = 0
local bo = 0
local ro = 0
local to = 0
local nz = 6000
local fz = 10000
local fakeheight = ScrH()
local fakewidth = fakeheight * .573619631
concommand.Add("origin_update", function(ply, cmd, args)
	if args[1] == "x" then
		ox = tonumber(args[2])
	elseif args[1] == "y" then
		oy = tonumber(args[2])
	elseif args[1] == "z" then
		oz = tonumber(args[2])
	elseif args[1] == "near" then
		nz = tonumber(args[2])
	elseif args[1] == "far" then
		fz = tonumber(args[2])
	end
end)
concommand.Add("offset_update", function(ply, cmg, args)
	if args[1] == "bot" then
		bo = tonumber(args[2])
	elseif args[1] == "top" then
		to = tonumber(args[2])
	elseif args[1] == "right" then
		ro = tonumber(args[2])
	else
		lo = tonumber(args[2])
	end
end)
function CacheMinimap()
	local to_reset = {}
	for k,v in pairs(ents.GetAll()) do
		if v:IsPlayer() or v:GetClass() == "prop_vehicle_jeep" or v:GetClass() == "prop_ocrp" or v:GetClass() == "item_base" or v:GetClass() == "ocrp_radio" or v:GetClass() == "prop_dynamic" then
			v:SetNoDraw(true)
			table.insert(to_reset, v)
		end
	end
	cam.Start2D()

		rendering_map = true
        
        x_mid_lake = botright_realmap.x + (worldheight/2)
        y_mid_lake = botright_realmap.y + (worldwidth/2)

        render.RenderView {
			origin = Vector(0, 0, 8000),
			angles = Angle(90,0,0),
			x = x1,
			y = y1,
			w = width,
			h = height,
			drawmonitors = true,
			ortho = true,
			ortholeft = 0 - topleft_realmap.y,
			orthobottom = topleft_realmap.x,
			orthoright = 0 - botright_realmap.y,
			orthotop = botright_realmap.x,
			znear = 0,
			zfar = 8000
		}
		rendering_map = false

	cam.End2D()
	cached_map = render.Capture({
		format = "jpeg",
		h = height,
		w = width,
		quality = 100,
		x = x1,
		y = y1
	})

	for k,v in pairs(to_reset) do
		v:SetNoDraw(false)
	end
	to_reset = {}
	file.Write("ocrp_map.txt", cached_map)
end]]
markers = {}
net.Receive("OCRP_SendMarker", function(len)
	local identifier = net.ReadString()
	local icon = net.ReadString()
	local perx = net.ReadFloat()
	local pery = net.ReadFloat()
	markers[identifier] = {Icon = icon, Perx = perx, Pery = pery}
	DrawMarkers()
end)

net.Receive("OCRP_RemoveMarker", function(len)
	markers[net.ReadString()] = nil
	DrawMarkers()
end)

local icon_descs = {}
icon_descs["car-taxi"] = "Call for taxi pickup ( /taxi )"
icon_descs["exclamation-circle"] = "Notify officials"
icon_descs["exclamation-red"] = "Police report"
icon_descs["fire-big"] = "Report a fire"
icon_descs["flag-checker"] = "Taxi destination"
icon_descs["heart-break"] = "Life alert"
icon_descs["marker"] = "You are here"
icon_descs["star"] = "Org base"
icon_descs["store"] = "Items for sale"
icon_descs["target"] = "Org target"
icon_descs["traffic-cone"] = "Call for towtruck"
icon_descs["bandaid"] = "Call for ambulance"

function CanSeeMarkerType(icon)
	local t = LocalPlayer():Team()
	if icon == "car-taxi" then
		return (t == CLASS_TAXI) or (markers[LocalPlayer():SteamID() .. "_car-taxi"] ~= nil)
	elseif icon == "exclamation-circle" then
		return (t == CLASS_POLICE or t == CLASS_MEDIC or t == CLASS_SWAT or t == CLASS_FIREMAN or t == CLASS_CHIEF or t == CLASS_Mayor)
	elseif icon == "exclamation-red" then
		return true
	elseif icon == "fire-big" then
		return true
	elseif icon == "flag-checker" then
		return (t == CLASS_TAXI)
	elseif icon == "heart-break" then
		return t == CLASS_MEDIC
	elseif icon == "marker" then
		return true
	elseif icon == "star" or icon == "target" then
		return LocalPlayer():GetOrg() != 0
	elseif icon == "store" then
		return true
	elseif icon == "traffic-cone" then
		return t == CLASS_Tow
	elseif icon == "bandaid" then
		return true
	end
	return false
end
LocalPlayer().DrawingMap = false
util.PrecacheSound("ocrp/map_unfurl.wav")
local mapMenu
local controls
function ToggleMap()
	if not LocalPlayer():IsValid() then return end
	if not CL_HasItem("item_cell") then
		if not LocalPlayer():GetVehicle() or not LocalPlayer():GetVehicle():IsValid() or
		not LocalPlayer():GetVehicle():GetParent() or not LocalPlayer():GetVehicle():GetParent():IsValid() or
		not LocalPlayer():GetVehicle():GetParent():GetNWInt("Client", 0) == LocalPlayer():EntIndex() then
			OCRP_AddHint("You need a phone to use the map!")
			return
		end
	end
	LocalPlayer().DrawingMap = !LocalPlayer().DrawingMap
	net.Start("OCRP_ToggleMap")
	if LocalPlayer().DrawingMap then
		net.WriteInt(1, 2)
        DrawMap()
	else
		net.WriteInt(0,2)
        if mapMenu and mapMenu:IsValid() then mapMenu:Remove() end
        if controls and controls:IsValid() then controls:Remove() end
	end
	net.SendToServer()
end
function DrawMap()
    if mapMenu and mapMenu:IsValid() then mapMenu:Remove() end
    
    mapMenu = vgui.Create("OCRP_BaseMenu")
    mapMenu:SetSize(ScrH()-100, ScrH()-100)
    mapMenu:Center()
    mapMenu:AllowCloseButton(false)
    mapMenu:MakePopup()
    
    local mapMenuPaint = mapMenu.Paint
    
    function mapMenu:Paint(w,h)
        mapMenuPaint(self, w, h)
        draw.RoundedBox(0, 9, 9, w-18, h-18, Color(39,168,216,255))
    end
    
    local map = vgui.Create("DImage", mapMenu)
    map:SetSize(mapMenu:GetWide()-20, mapMenu:GetTall()-20)
    map:SetPos(10, 10)
    map:SetImage("ocrp_map.jpg")
    map:SetMouseInputEnabled(true)
    
    mapMenu.map = map
    
    function map:OnMousePressed(key)
    
        local mousex, mousey = map:CursorPos()

		if key == MOUSE_RIGHT then
            mapMenu:SetCursor("arrow")
            if PendingIcon then PendingIcon = nil return end
            
			local closest = map:GetClosestChild(mousex, mousey)
			if closest and closest:IsValid() then
				local cx, cy = closest:GetPos()
				if math.Distance(mousex, mousey, cx+12, cy+12) <= 12 then -- The box is 24x24, we "center" cx and cy
					local iconz = closest.TableInfo.Icon
                    local removeable = {"exclamation-circle", "store", "star", "target", "traffic-cone", "car-taxi", "exclamation-red", "bandaid", "fire-big", "flag-checker"}
					if table.HasValue(removeable, iconz) then
						net.Start("OCRP_RemoveMarker")
						net.WriteString(closest.Identifier)
						net.SendToServer()
					end
				end
			end
		elseif key == MOUSE_LEFT then
            if not PendingIcon then return end
            local perx = mousex / map:GetWide()
            local pery = mousey / map:GetTall()
            net.Start("OCRP_SendMarker")
            net.WriteString(PendingIcon)
            net.WriteFloat(perx)
            net.WriteFloat(pery)
            net.SendToServer()
            PendingIcon = nil
            mapMenu:SetCursor("arrow")
        end
        
	end
    
    DrawMarkers()
    DrawButtons()
end

function DrawButtons()
	if not mapMenu or not mapMenu:IsValid() or not mapMenu:IsVisible() then return end
    if controls and controls:IsValid() then controls:Remove() end
    
    local usable = LocalPlayer():GetUsableIcons()
    controls = vgui.Create("OCRP_BaseMenu")
    controls:SetSize(200, 48*(table.Count(icon_descs)+2))
    controls:SetPos(mapMenu:GetPos()+mapMenu:GetWide()+20, select(2, mapMenu:GetPos()))
    controls:AllowCloseButton(false)
    controls:MakePopup()
    controls.Buttons = {}
    
    local controlsPaint = controls.Paint
    
    function controls:Paint(w,h)
        controlsPaint(self, w, h)
        -- Outline the currently selected button
        if PendingIcon and controls.Buttons[PendingIcon] then
            local b = controls.Buttons[PendingIcon]
            local x,y = b:GetPos()
            draw.RoundedBox(8, x-4, y-4, b:GetWide()+8, b:GetTall()+8, Color(39,168,216,255))
            draw.RoundedBox(8, x-2, y-2, b:GetWide()+4, b:GetTall()+4, Color(20,20,20,255))
        end
        draw.RoundedBox(0, 10, 48*(#usable+1), 180, 2, Color(39,168,216,255))
    end
    
    local title = vgui.Create("DLabel", controls)
    title:SetText("Markers You Can Place")
    title:SetFont("Trebuchet19")
    title:SetTextColor(Color(39,168,216,255))
    title:SizeToContents()
    title:SetPos(controls:GetWide()/2-title:GetWide()/2, 10)
    
    local i = 48
    for _,icon in pairs(usable) do
        local button = vgui.Create("DImageButton", controls)
        button:SetSize(24, 24)
        button:SetPos(15, i)
        button:SetImage("materials/icons/".. icon .. ".png")
        
        function button:DoClick()
            if not table.HasValue(LocalPlayer():GetUsableIcons(), icon) then return end -- Something changed and it's not usable anymore (new job? left org? idk)
            PendingIcon = icon
            mapMenu:SetCursor("hand")
        end
        
        local desc = vgui.Create("DLabel", controls)
        desc:SetText(icon_descs[icon])
        desc:SetFont("UiBold")
        desc:SetTextColor(Color(255,255,255,255))
        desc:SizeToContents()
        desc:SetPos(button:GetPos()+button:GetWide()+10, i+button:GetTall()/2-desc:GetTall()/2)
       
        i = i + 48
        
        controls.Buttons[icon] = button

    end
    
    local title2 = vgui.Create("DLabel", controls)
    title2:SetText("Markers You Cannot Place")
    title2:SetFont("Trebuchet19")
    title2:SetTextColor(Color(39,168,216,255))
    title2:SizeToContents()
    title2:SetPos(controls:GetWide()/2-title2:GetWide()/2, 48*(#usable+1)+20)
    
    i = 48*(#usable+1)+20+38
    
    for icon,descr in pairs(icon_descs) do
        if table.HasValue(usable, icon) then continue end
        local img = vgui.Create("DImage", controls)
        img:SetSize(24, 24)
        img:SetPos(15, i)
        img:SetImage("materials/icons/" .. icon .. ".png")
        
        local desc = vgui.Create("DLabel", controls)
        desc:SetText(descr)
        desc:SetFont("UiBold")
        desc:SetTextColor(Color(255,255,255,255))
        desc:SizeToContents()
        desc:SetPos(img:GetPos()+img:GetWide()+10, i+img:GetTall()/2-desc:GetTall()/2)
       
        i = i + 48
       
    end
end

local drawn_markers = {}

function DrawMarkers()
	if not mapMenu or not mapMenu:IsValid() or not mapMenu:IsVisible() then return end
    for k,v in pairs(drawn_markers) do
        if v and v:IsValid() then v:Remove() end
    end
    
	local you_are_here = vgui.Create("DImage", mapMenu.map)
	you_are_here:SetSize(24,24)
	you_are_here:SetImage("materials/icons/marker.png")
	you_are_here.Identifier = "you_are_here"
	you_are_here.TableInfo = {Icon = "marker"}
	local sposx, sposy = CalcScreenPos(LocalPlayer():GetPos())
	you_are_here:SetPos(sposx, sposy-12) -- Subtract the height so the "point" of the marker is on your location
    table.insert(drawn_markers, you_are_here)
	for k,v in pairs(markers) do
		local marker = vgui.Create("DImage", mapMenu.map)
		marker:SetSize(24, 24)
		marker:SetImage("materials/icons/" .. v.Icon .. ".png")
		marker:SetPos(v.Perx * mapMenu.map:GetWide() - 12, v.Pery * mapMenu.map:GetTall() - 12)
		marker.Identifier = k
		marker.TableInfo = v
        table.insert(drawn_markers, marker)
	end
end

function CalcPercents(wpos)
	local worldwidth = math.abs(topleft_realmap.y) + math.abs(botright_realmap.y)
	local worldheight = math.abs(topleft_realmap.x) + math.abs(botright_realmap.x)
	local fakepos = WorldToLocal(Vector(wpos.x, wpos.y, 0), Angle(0,0,0), Vector(topleft_realmap.x, topleft_realmap.y, 0), Angle(0,0,0))
	local fakeperx = math.abs(fakepos.y) / worldwidth
	local fakepery = math.abs(fakepos.x) / worldheight
    return fakeperx,fakepery
end

function CalcScreenPos(wpos)
    local mapwidth = (mapMenu.map and mapMenu.map:IsValid()) and mapMenu.map:GetWide() or ScrH()-120
    local mapheight = (mapMenu.map and mapMenu.map:IsValid()) and mapMenu.map:GetTall() or ScrH()-120
    local fakeperx,fakepery = CalcPercents(wpos)
	return (fakeperx * mapwidth)-12, (fakepery * mapheight)-12 -- Subtract half of the 24x24 size to "center" the marker
end
net.Receive("OCRP_BroadcastMap", function(len)
	local ply = net.ReadEntity()
	ply.InMap = tobool(net.ReadInt(2))
end)
net.Receive("OCRP_TaxiMapOpen", function(len)
	if not markers[LocalPlayer():SteamID() .. "_flag-checker"] then
		OCRP_AddHint("Click somewhere on your map to tell the taxi driver where to go.")
	end
    PendingIcon = "flag-checker"
	ToggleMap()
    if mapMenu and mapMenu:IsValid() then
        mapMenu:SetCursor("hand")
    end
end)
net.Receive("OCRP_SendTaxiRoute", function()
	TaxiRoute = net.ReadTable()
end)
net.Receive("OCRP_LifeAlert_Hacky_Death", function()
    net.Start("OCRP_SendMarker")
    net.WriteString("heart-break")
    local perx,pery = CalcPercents(LocalPlayer():GetPos())
    net.WriteFloat(perx)
    net.WriteFloat(pery)
    net.SendToServer()
end)