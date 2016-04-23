AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

util.AddNetworkString("OCRP_UpdateStation")

function ENT:Initialize()
	self.DropTime = CurTime()
	
	if self.Amount == nil then
		self.Amount = 1
	end
	
	if self:GetNWString("Class") == nil then
		self:Remove()
	end
	
	self:SetModel(GAMEMODE.OCRP_Items[self:GetNWString("Class")].Model)
	
	if GAMEMODE.OCRP_Items[self:GetNWString("Class")].Material != nil then
		self:SetMaterial(GAMEMODE.OCRP_Items[self:GetNWString("Class")].Material)
	end
	
	self:SetHealth(100)
	if GAMEMODE.OCRP_Items[self:GetNWString("Class")].Health != nil then
		self:SetHealth(GAMEMODE.OCRP_Items[self:GetNWString("Class")].Health)
	end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	if  GAMEMODE.OCRP_Items[self:GetNWString("Class")].Protected then
		self.Protected = true
	end
	
	if GAMEMODE.OCRP_Items[self:GetNWString("Class")].SpawnFunction != nil then
		GAMEMODE.OCRP_Items[self:GetNWString("Class")].SpawnFunction(self)
	end
    self.Station = 0
end

function changeStation(ply)
    if ply.CantUse == true then return end
    ply.CantUse = true
    timer.Simple(.1, function()
        if ply:IsValid() then
            ply.CantUse = false
        end
    end)
	local target = nil
	if ply:GetVehicle() and ply:GetVehicle():IsValid() and ply:GetVehicle():GetClass() == "prop_vehicle_jeep" then
		if !ply:GetVehicle().Radio or !ply:GetVehicle().Radio:IsValid() then
			local radio = ents.Create("ocrp_radio")
			radio:SetNWString("Class", "item_radio")
			radio:SetPos(Vector(0,0,10))
			radio:SetMoveParent(ply:GetVehicle())
			radio:SetRenderMode(RENDERMODE_TRANSALPHA)
			radio:SetColor(Color(0,0,0,0))
			radio:SetNWInt("Owner", ply:EntIndex())
			radio:Spawn()
			ply:GetVehicle().Radio = radio
		end
		target = ply:GetVehicle().Radio
	else
		local tr = util.TraceLine({
			start = ply:EyePos(),
			endpos = ply:EyePos() + ply:EyeAngles():Forward() * 100,
			filter = function(ent)
				if ent:GetClass() == "ocrp_radio" then
					if ent:GetNWInt("Owner") and ent:GetNWInt("Owner") == ply:EntIndex() then
						target = ent
					end
				end
			end,
		})
	end
    if not target or not target:IsValid() then return end
    if target:GetNWInt("Owner") ~= ply:EntIndex() then return end
    local newStation = target.Station + 1
    if target.Stations[newStation] == nil then
        newStation = 0
    end
	target.Station = newStation
	target:SetNWInt("Station", newStation)
	timer.Simple(.1, function()
    net.Start("OCRP_UpdateStation")
    net.WriteInt(newStation, 32)    
    net.WriteEntity(target)
    net.Broadcast()
	end)
end

function PlayPausedRadio(Player, Vehicle, Role)
	if Vehicle.Radio and Vehicle.Radio:IsValid() and Vehicle.Radio:GetNWInt("Station") ~= 0 then
		net.Start("OCRP_UpdateStation")
		net.WriteInt(Vehicle.Radio:GetNWInt("Station"), 32)
		net.WriteEntity(Vehicle.Radio)
		net.Broadcast()
	end
end

hook.Add("ShowSpare2", "OCRP_UpdateStation", changeStation)
hook.Add("PlayerEnteredVehicle", "OCRP_PlayCarRadio", PlayPausedRadio)
util.AddNetworkString("StopRadios")
concommand.Add("OCRP_StopRadios", function(ply)
	net.Start("StopRadios")
	net.Send(ply)
end)