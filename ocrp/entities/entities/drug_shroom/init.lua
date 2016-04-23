AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/fungi/sta_skyboxshroom1.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	--self:SetMoveType(MOVETYPE_NONE)
    --self:SetSolid(SOLID_NONE)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    -- Collision bounds are a little glitchy by default, even before we fuck around with model scale
    -- So let's make it a nice simple cube, larger than the model. Should fix players getting stuck
    --[[
    local minvec,maxvec = self:GetCollisionBounds()
    local min = math.min(minvec.x,minvec.y,minvec.z)
    local max = math.max(maxvec.x,maxvec.y,maxvec.z)
    minvec = Vector(min-5, min-5, min-5)
    maxvec = Vector(max+5, max+5, max+20)
    self:SetCollisionBounds(minvec, maxvec)
    --]]
    -- Well I couldn't make it work so we make it non-solid instead
    self:SetUseType(SIMPLE_USE)
    self:SetModelScale(.3, 0)
end

local growTime = 360 -- seconds
local harvestableTime = 60
local rotTime = 60
local hangTime = 60

local growRate = .7 / (growTime * 2)
local rotRate = 195 / (rotTime * 2)

-- Sort of hacky I guess, but we use color and model scale to decide "harvestableness"
-- < model scale 1 means no harvest
-- = model scale 1 means harvest
-- 255 rgb means normal harvest
-- < 255 rgb means rotten harvest
-- = 60 rgb means no harvest

function ENT:Think()
    if not self.LastGrow then self.LastGrow = 0 end
    if CurTime() - self.LastGrow >= .5 and self:GetModelScale() < 1 then
        self:SetModelScale(math.Clamp(self:GetModelScale()+growRate, .3, 1), 0)
        if self:GetModelScale() > .8 and not self.TriedToSpread then
            local r = math.random()
            if r >= .7 then -- 30% chance to try to spread ('trying' to spread pretty much guaranteed if possible (i.e. not blocked))
                self:TrySpread()
            end
            self.TriedToSpread = true
        end
        self.LastGrow = CurTime()
    end
    if self:GetModelScale() == 1 and CurTime() - self.LastGrow > harvestableTime then
        if not self.LastRot then self.LastRot = 0 end
        if CurTime() - self.LastRot >= .5 then
            if self:GetColor().r > 60 then -- Turn grey
                local c = math.Clamp(self:GetColor().r - rotRate, 60, 255)
                self:SetColor(Color(c,c,c,255))
                self.LastRot = CurTime()
            elseif CurTime() - self.LastRot > hangTime then
                self:Remove()
            end
        end
    end
end

function ENT:TrySpread()
    if self.Spore and self.Spore:IsValid() then return end
    local top = self:GetPos() + Vector(0, 0, self:OBBMaxs().z)
    for i = 1,10 do
        if self.Spore and self.Spore:IsValid() then return end
        local xchange = math.random(30, 60)
        if math.random(2) == 2 then
            xchange = -xchange
        end
        local ychange = math.random(30, 60)
        if math.random(2) == 2 then
            ychange = -ychange
        end
        local change = Vector(xchange, ychange, -self:OBBMaxs().z-10)
        local endpoint = top + change
        local tr = util.TraceLine({
            start = top,
            endpos = endpoint,
            filter = function(ent) if ent == self then return false end end,
        })
        if not tr.MatType then continue end
        local open = true
        for k,v in pairs(ents.FindInSphere(tr.HitPos, 15)) do
            open = false
        end
        local tr2 = util.TraceLine({
            start = self:GetPos(),
            endpos = self:GetPos()+Vector(0,0,30),
            filter = function(ent) if ent == self then return false end end,
        })
        if tr2.Hit then open = false end
        if not open then continue end
        if tr.MatType == 68 or tr.MatType == 85 or string.find(tr.HitTexture or "", "grass") or string.find(tr.HitTexture or "", "dirt") then
            local spore = ents.Create("drug_shroom")
            spore:SetPos(tr.HitPos)
            spore:SetNWInt("Owner", self:GetNWInt("Owner") or -1)
            spore:Spawn()
            self.Spore = spore
        end
    end

end

function ENT:Use( activator, caller )

    if not activator:IsPlayer() then return end
    if activator:GetNWBool("Handcuffed") then return end

    if self:GetModelScale() < 1 then
        activator:Hint("This shroom is still too small to pick.")
        return
    end
    
    if self:GetColor().r <= 60 then
        activator:Hint("This shroom is too rotten to pick.")
        return
    end

    if activator.CantUse then return end
    activator.CantUse = true
    timer.Simple(.3, function()
        if activator:IsValid() then activator.CantUse = false end
    end)
    
    local owner = Entity(self:GetNWInt("Owner"))
    local name = "DISCONNECTED"
    if owner:IsValid() then name = owner:Nick() end
    
    if self:GetColor().r == 255 then
        activator:GiveItem("item_shroom")
        SV_PrintToAdmin(activator, "HARVEST-SHROOM", "picked a shroom belonging to " .. name)
        self:Remove()
    end
    
    if self:GetColor().r < 255 then
        activator:GiveItem("item_shroom_rotten")
        SV_PrintToAdmin(activator, "HARVEST-SHROOM", "picked a rotten shroom belonging to " .. name)
        self:Remove()
    end
end

