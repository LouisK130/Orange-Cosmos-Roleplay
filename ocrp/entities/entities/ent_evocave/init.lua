AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	timer.Simple(6,function() self:Check() end)
	self:DrawShadow( false )
end


function ENT:Check() 
	for _,ent in pairs(player.GetAll()) do
		if ent:GetPos():Distance(self:GetPos()) <= 2000 then 
			if ent:InVehicle() then
				ent:ExitVehicle()
				ent:GetVehicle():Remove()
			end
			ent:SetPos(Vector(-7195,-9059,2000))
			ent:SetVelocity(Vector(0,0,0))
		end
	end
	timer.Simple(6,function() self:Check() end)
end


