concommand.Add("texturecheck", function()
    print(LocalPlayer():GetEyeTrace().HitTexture or "none")
    print("Mat: " .. LocalPlayer():GetEyeTrace().MatType or "no mat")
    print("Hit: " .. tostring(LocalPlayer():GetEyeTrace().HitPos))
end)

include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
end