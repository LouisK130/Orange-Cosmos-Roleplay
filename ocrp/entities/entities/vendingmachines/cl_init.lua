include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
end

