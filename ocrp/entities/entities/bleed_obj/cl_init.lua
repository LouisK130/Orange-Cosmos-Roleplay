include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.Time = 1

function ENT:Draw()

end

function ENT:Initialize()
	self:Emit()
end

function ENT:Emit()
	local effectdata = EffectData()
	effectdata:SetStart( self:GetPos() )
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetScale( .5 )
	util.Effect('BloodImpact', effectdata);
	

	local Pos1 = self:GetPos()
	local Pos2 = self:GetPos() - self:GetAngles():Up() * -30
	
	util.Decal("Blood", Pos1, Pos2)

	
	self.Time = self.Time + 1
	timer.Simple(self.Time,function() if self:IsValid() then self:Emit() end end )
end
