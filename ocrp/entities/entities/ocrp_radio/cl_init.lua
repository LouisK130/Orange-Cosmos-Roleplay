include( "shared.lua" )
CreateClientConVar("OCRP_RadiosEnabled", "1", true, false)
CreateClientConVar("OCRP_RadioVol", "100", true, false)
CreateClientConVar("OCRP_MaxRadios", "0", true, false)
CreateClientConVar("OCRP_MaxRadioDupes", "2", true, false)
CreateClientConVar("OCRP_MaxRadioDistance", "1000", true, false)

local max = GetConVar("OCRP_MaxRadioDistance"):GetInt() or 1000
local maxdistance = max * max

cvars.AddChangeCallback("OCRP_MaxRadioDistance", function(cvar, old, new)
    local new = tonumber(new)
    local old = tonumber(old)
    if not new or new <= 200 then
        GetConVar("OCRP_MaxRadioDistance"):SetInt(old)
        print("Error, distance must be a number greater than 200.")
        return
    end
    maxdistance = new * new
    for k,v in pairs(ents.FindByClass("ocrp_radio")) do
        if v:GetPos():DistToSqr(LocalPlayer():GetPos()) > maxdistance then
            v.AudioChannel:SetVolume(0)
        end
        if v:GetPos():DistToSqr(LocalPlayer():GetPos()) <= maxdistance then
            local vol = cvars.Number("OCRP_RadioVol") or 100
            v.AudioChannel:SetVolume(vol/100)
        end
    end
end)

cvars.AddChangeCallback("OCRP_RadiosEnabled", function(cvar, old, new)
    if old == "1" and new == "0" then
        for k,v in pairs(ents.FindByClass("ocrp_radio")) do
            if old == "0" and new != "0" then
                if v:GetPos():DistToSqr(LocalPlayer():GetPos()) <= maxdistance then
                    UpdateStation(b:GetNWInt("Station"), v, true)
                end
            elseif old != "0" and new == "0" then
                if v.AudioChannel and v.AudioChannel:IsValid() then
                    v.AudioChannel:Stop()
                end
            end
        end
    end
end)

cvars.AddChangeCallback("OCRP_MaxRadios", function(cvar, old, new)
    for k,v in pairs(ents.FindByClass("ocrp_radio")) do
        if v:GetPos():DistToSqr(LocalPlayer():GetPos()) <= maxdistance then
            CheckExceedsMax(v)
        end
    end
end)

cvars.AddChangeCallback("OCRP_MaxRadioDupes", function(cvar, old, new)
    for k,v in pairs(ents.FindByClass("ocrp_radio")) do
        if v:GetPos():DistToSqr(LocalPlayer():GetPos()) <= maxdistance then
            CheckExceedsDupes(v)
        end
    end
end)

cvars.AddChangeCallback("OCRP_RadioVol", function(cvar, old, new)
    local vol = tonumber(new)
    if not vol then
        GetConVar("OCRP_RadioVol"):SetInt(tonumber(old))
        print("Error, radio volume must be a number.")
        return
    end
    vol = math.Clamp(vol, 1, 100)
    for k,v in pairs(ents.FindByClass("ocrp_radio")) do
        if v.AudioChannel and v.AudioChannel:IsValid() then
            v.AudioChannel:SetVolume(vol / 100)
        end
    end
end)

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
    self.PlayingStation = 0
end

-- This hook mutes radios that are too far away or exceed maxdupes/maxtotal
function ENT:Think()

    if self.AudioChannel and self.AudioChannel:IsValid() then
    
    	-- Check for radios moving into player's range
		local pos = Vector()
		pos:Set(self.AudioChannel:GetPos())
        self.AudioChannel:SetPos(self:GetPos())
		if pos:DistToSqr(LocalPlayer():GetPos()) > maxdistance and self:GetPos():DistToSqr(LocalPlayer():GetPos()) <= maxdistance then
			CheckExceedsMax(self)
			CheckExceedsDupes(self)
            local vol = cvars.Number("OCRP_RadioVol") or 100
            self.AudioChannel:SetVolume(vol/100)
		end
        -- Check for radio moving out of player range
        if pos:DistToSqr(LocalPlayer():GetPos()) <= maxdistance and self:GetPos():DistToSqr(LocalPlayer():GetPos()) > maxdistance then
            CheckExceedsMax(self)
            CheckExceedsDupes(self)
            self.AudioChannel:SetVolume(0)
        end
        
		-- Check for player moving into radio's range
		if not LocalPlayer().oldPos or (LocalPlayer().oldPos:DistToSqr(self:GetPos()) > maxdistance and LocalPlayer():GetPos():DistToSqr(self:GetPos()) <= maxdistance) then
			CheckExceedsMax(self)
			CheckExceedsDupes(self)
            local vol = cvars.Number("OCRP_RadioVol") or 100
            self.AudioChannel:SetVolume(vol/100)
		end
        
        -- Check for player moving out of radio range
        if LocalPlayer().oldPos and LocalPlayer().oldPos:DistToSqr(self:GetPos()) <= maxdistance and LocalPlayer():GetPos():DistToSqr(self:GetPos()) > maxdistance then
            self.AudioChannel:SetVolume(0)
            CheckExceedsMax(self)
            CheckExceedsDupes(self)
        end
        
		LocalPlayer().oldPos = LocalPlayer():GetPos()
    end
end
    

function ENT:OnStop()
	if self.AudioChannel then
		self.AudioChannel:Stop()
	end
    if self:GetNWInt("Owner") > 0 and self:GetNWInt("Owner") == LocalPlayer():EntIndex() then
        displayStation("")
    end
end

function ENT:OnRemove()
	LocalPlayer().StationName = ""
	if self.AudioChannel then
		self.AudioChannel:Stop()
	end
	if not LocalPlayer():IsValid() then return end
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) <= maxdistance then -- This radio is relevant to our counts, lets have a recount!
		for k,v in pairs(ents.FindByClass("ocrp_radio")) do
			if v == self then continue end -- We don't want to replay this one.. It's about to be removed
			if v.maxmuted then
				CheckExceedsMax(v)
			end
			if v.dupemuted then
				CheckExceedsDupes(v)
			end
		end
	end
end

function CheckExceedsMax(radio)
	if radio:GetNWInt("Station") == 0 then return end -- The radio is on station "Off"
	-- Find all radios within range to count for radio control
	local checkRadios = {}
	for k,v in pairs(ents.FindByClass("ocrp_radio")) do
		if v == radio then continue end -- Don't count self
		if v:GetPos():DistToSqr(LocalPlayer():GetPos()) <= maxdistance then
			if v.AudioChannel and v.AudioChannel:IsValid() then -- We only care about playing radios
				checkRadios[v] = v.AudioChannel
			end
		end
	end
	-- Make sure that adding this radio won't exceed total maximum allowed in range radios
	local maxi = cvars.Number("OCRP_MaxRadios") or 0
	if maxi > 0 and table.Count(checkRadios) >= maxi then
		if radio.AudioChannel and radio.AudioChannel:IsValid() and !radio.maxmuted then
			OCRP_AddHint("A radio has been muted because it exceeded your OCRP_MaxRadios setting.")
			radio.maxmuted = true
			radio.AudioChannel:Stop()
			return
		end
	else -- If adding this won't exceed the limit AND it's got an active station, play it
		if (not radio.AudioChannel or not radio.AudioChannel:IsValid()) and (radio:GetNWInt("Station") > 0 and !radio.loading and radio.maxmuted) then
			OCRP_AddHint("A radio has been unmuted because it no longer exceeds your OCRP_MaxRadios setting.")
			radio.maxmuted = false
			radio.loading = true
			UpdateStation(radio:GetNWInt("Station"), radio, true)
		end
	end
end

function CheckExceedsDupes(radio)
	if radio:GetNWInt("Station") == 0 then return end -- The radio is on station "Off"
	-- Make sure that adding this radio won't exceed total allowed on this station
	-- Find all radios within range to count for radio control
	local checkRadios = {}
	for k,v in pairs(ents.FindByClass("ocrp_radio")) do
		if v == radio then continue end -- Don't count self
		if v:GetPos():DistToSqr(LocalPlayer():GetPos()) <= maxdistance then
			if v.AudioChannel and v.AudioChannel:IsValid() then -- We only care about playing radios
				checkRadios[v] = v.AudioChannel
			end
		end
	end
	local maxi = cvars.Number("OCRP_MaxRadioDupes") or 2
	-- Count current in-range radios on this station
	local dupes = {}
	for k,v in pairs(checkRadios) do
		if k:GetNWInt("Station") == radio:GetNWInt("Station") then
			dupes[k] = v
		end
	end
	if table.Count(dupes) >= maxi then
	if radio.AudioChannel and radio.AudioChannel:IsValid() and !radio.dupemuted then
		OCRP_AddHint("A radio has been muted because it exceeded your OCRP_MaxRadioDupes setting.")
		radio.dupemuted = true
		radio.AudioChannel:Stop()
		return
	end
	else
		if (not radio.AudioChannel or not radio.AudioChannel:IsValid()) and (radio:GetNWInt("Station") > 0 and !radio.loading and radio.dupemuted) then
			OCRP_AddHint("A radio has been unmuted because it no longer exceeds your OCRP_MaxRadioDupes setting.")
			radio.loading = true
			radio.dupemuted = false
			UpdateStation(radio:GetNWInt("Station"), radio, true)
		end
	end
end

function UpdateStation(newStation, radio, silent)
	if not cvars.Bool("OCRP_RadiosEnabled", true) then return end
	radio.Stop = false
	if not radio:IsValid() then return end
    if radio.AudioChannel then
        radio.AudioChannel:Stop()
    end
    if newStation == 0 then
        if radio:GetNWInt("Owner") > 0 and radio:GetNWInt("Owner") == LocalPlayer():EntIndex() and !silent then
            displayStation("Off", radio)
        end
		return
    else
		if !silent then
			displayStation(radio.Stations[newStation].Name, radio)
		end
		timer.Simple(1, function()
			if newStation == radio:GetNWInt("Station") then
				if radio.Stop then return end
				if radio:GetNWInt("Owner") > 0 and radio:GetNWInt("Owner") == LocalPlayer():EntIndex() and !silent then
					displayStation("Loading...", radio)
				end
				sound.PlayURL(radio.Stations[newStation].URL, "3d loop", function(chnl, errid, err)
					radio.loading = false
					if not radio:IsValid() or radio.Stop then 
						chnl:Stop()
						return
					end
					if errid == nil then
						if not radio:GetNWInt("Station") or not radio.Stations[radio:GetNWInt("Station")] or chnl:GetFileName() ~= radio.Stations[radio:GetNWInt("Station")].File then
							chnl:Stop()
							return
						end
						local vol = cvars.Number("OCRP_RadioVol") or 100
						chnl:SetVolume(vol / 100)
						chnl:Set3DFadeDistance(200, 100000000)
						radio.AudioChannel = chnl
						--OCRP_AudioChannels[radio:EntIndex()] = chnl
						chnl:SetPos(radio:GetPos())
						if radio:GetNWInt("Owner") > 0 and radio:GetNWInt("Owner") == LocalPlayer():EntIndex() and !silent then
							displayStation(radio.Stations[newStation].Name, radio)
						end
						-- Decide if we want to allow this to play
						CheckExceedsMax(radio)
						CheckExceedsDupes(radio)
					else
						print("Error initializing radio station! Code: " .. errid)
						print("Error: " .. err)
						if radio:GetNWInt("Owner") > 0 and radio:GetNWInt("Owner") == LocalPlayer():EntIndex() and !silent then
							displayStation("Error", radio)
						end
					end
				end)
			end
		end)
	end
end

net.Receive("OCRP_UpdateStation", function()
    local newStation = net.ReadInt(32)
    local radio = net.ReadEntity()
	UpdateStation(newStation, radio)
end)

net.Receive("StopRadios", function(len)
	for k,v in pairs(ents.FindByClass("ocrp_radio")) do
		if v:IsValid() and v.AudioChannel and v.AudioChannel:IsValid() then
			v.AudioChannel:Stop()
		end
	end
end)

net.Receive("OCRP_CarLeave_PauseRadio", function(len)
	local radio = net.ReadEntity()
	if radio and radio:IsValid() then
		if radio.AudioChannel and radio.AudioChannel:IsValid() then
			radio.AudioChannel:Stop()
		end
		radio.Stop = true
		LocalPlayer().StationName = ""
	end
end)

function displayStation(name, radio)
	if LocalPlayer():EntIndex() ~= radio:GetNWInt("Owner") then return end
    LocalPlayer().StationName = name
    timer.Simple(3, function()
        if LocalPlayer().StationName == name and name ~= "Loading..." then
            LocalPlayer().StationName = ""
        end
    end)
end

local function RadioDrawing()
	if LocalPlayer().StationName and LocalPlayer().StationName ~= "" then
		surface.SetFont("A30")
		local x, y = surface.GetTextSize(LocalPlayer().StationName)
		draw.RoundedBox( 8, (ScrW() / 2) - (x / 2) - 5, (ScrH() / 2) - 25, (x + 38), 50, Color( 255, 140, 0, 180) )
--		surface.SetDrawColor( 128, 140, 0, 180 )
--		surface.DrawOutlinedRect( (ScrW() / 2) - ( x /2 ) - 5, ScrH() / 2 - 25, (x+38), 50)
--		surface.SetDrawColor( 255, 165, 0, 180 )
--		surface.DrawRect( (ScrW() / 2) - ( x /2 ) - 5, ScrH() / 2 - 25, (x+38), 50)	
		surface.SetMaterial(Material("gui/OCRP/OCRP_Orange"))
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect((ScrW() / 2) - (x/2) - 40,(ScrH() / 2) - 30,60,60)

		draw.SimpleText(LocalPlayer().StationName, 'A30', (ScrW() / 2) + 23, ScrH() / 2, Color(255, 255, 255, 255), 1, 1);
		
	end
end
hook.Add('HUDPaint', 'RadioDrawSomeShit', RadioDrawing);