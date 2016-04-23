AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
util.AddNetworkString("OCRP_ShowItemBank")
util.AddNetworkString("OCRP_DepositItemBank")
util.AddNetworkString("OCRP_WithdrawItemBank")
util.AddNetworkString("OCRP_UpdateItemBankItem")

function ENT:Initialize()
	self:SetModel("models/props_c17/Lockers001a.mdl")
	self:PhysicsInit(0)
	self:SetMoveType(0)
	self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

function ENT:KeyValue(key,value)
end

function ENT:SetType(strType)
end

function ENT:SetAmount(varAmount)
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() && !activator.CantUse then
        if activator:IsGov() then
            activator:Hint("You can't access your item bank as this job.")
            return
        end
		activator.CantUse = true
		timer.Simple(0.3, function() activator.CantUse = false end)
        net.Start("OCRP_ShowItemBank")
        net.WriteTable(activator.OCRPData["ItemBank"])
        net.Send(activator)
	end
end

local PMETA = FindMetaTable("Player")

function PMETA:DepositItemBank(item)
    if not self:HasItem(item,1) then return end
    if self:IsGov() then return end
    local itemTable = GAMEMODE.OCRP_Items[item]
    if self.OCRPData["ItemBank"].WeightData.Cur + itemTable.Weight > self.OCRPData["ItemBank"].WeightData.Max then
        self:Hint("Your item bank doesn't have enough room for that!")
        return
    end
    self.OCRPData["ItemBank"][item] = self.OCRPData["ItemBank"][item] or 0
    self.OCRPData["ItemBank"][item] = self.OCRPData["ItemBank"][item] + 1
    self.OCRPData["ItemBank"].WeightData.Cur = self.OCRPData["ItemBank"].WeightData.Cur + itemTable.Weight
    self:RemoveItem(item, 1)
    self:UpdateItemBankItem(item)
end

function PMETA:WithdrawItemBank(item)
    if not self.OCRPData["ItemBank"][item] or self.OCRPData["ItemBank"][item] <= 0 then return end
    if self:IsGov() then return end
    local itemTable = GAMEMODE.OCRP_Items[item]
    if not self:HasRoom(item, 1) then
        self:Hint("You don't have room for that item!")
        return
    end
    if self:ExceedsMax(item, 1) then
        self:Hint("You can't carry any more of that item!")
        return
    end
    self.OCRPData["ItemBank"][item] = self.OCRPData["ItemBank"][item] or 0
    self.OCRPData["ItemBank"][item] = self.OCRPData["ItemBank"][item] - 1
    self.OCRPData["ItemBank"].WeightData.Cur = self.OCRPData["ItemBank"].WeightData.Cur - itemTable.Weight
    self:GiveItem(item, 1)
    self:UpdateItemBankItem(item)
end

function PMETA:UpdateItemBankItem(item)
    net.Start("OCRP_UpdateItemBankItem")
    net.WriteString(item)
    net.WriteInt(self.OCRPData["ItemBank"][item] or 0, 32)
    net.WriteTable(self.OCRPData["ItemBank"]["WeightData"])
    net.Send(self)
end

net.Receive("OCRP_DepositItemBank", function(len, ply)
    local item = net.ReadString()
    for k,v in pairs(ents.FindByClass("item_bank")) do
        if v:GetPos():DistToSqr(ply:GetPos()) <= 10000 then
            ply:DepositItemBank(item)
            return
        end
    end
end)

net.Receive("OCRP_WithdrawItemBank", function(len, ply)
    local item = net.ReadString()
    for k,v in pairs(ents.FindByClass("item_bank")) do
        if v:GetPos():DistToSqr(ply:GetPos()) <= 10000 then
            ply:WithdrawItemBank(item)
            return
        end
    end
end)