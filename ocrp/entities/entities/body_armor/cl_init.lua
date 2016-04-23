include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:Initialize() 
end


function ENT:Draw()
	if self:GetNWInt("Owner") > 0 && LocalPlayer():EntIndex() != self:GetNWInt("Owner") then 
		local ply = player.GetByID(self:GetNWInt("Owner"))
		local ply_spine1 = ply:LookupBone("ValveBiped.Bip01_Spine4")		
		local pos,ang = ply:GetBonePosition( ply_spine1 )
		local ply_spine2 = ply:LookupBone("ValveBiped.Bip01_Spine2")		
		local pos2,ang2 = ply:GetBonePosition( ply_spine2 )
		local ent_spine = self.Entity:LookupBone("ValveBiped.Bip01_Spine1")
		local ent_spine2 = self.Entity:LookupBone("ValveBiped.Bip01_Spine2")
		--self.Entity:SetBonePosition(ent_spine1,pos,ang)
		--self.Entity:SetBonePosition(ent_spine2,pos2,ang2)
		local ang = ang + Angle(75,0,90)
		self.Entity:SetPos(pos + ang:Up() * -64 + ang:Forward() * 3)
		self.Entity:SetAngles(ang)
		self.Entity:DrawModel()
	end
end



