util.AddNetworkString("OCRP_OpenTrade")
util.AddNetworkString("OCRP_SetTradeItemAmount")
util.AddNetworkString("OCRP_SetTradeMoney")
util.AddNetworkString("OCRP_ConfirmTrade")
util.AddNetworkString("OCRP_EndTrade")

function OpenTradeWindow( ply )

    local partner = ply:GetEyeTrace().Entity
    if not partner:IsPlayer() then return end
    if partner:GetPos():Distance(ply:GetPos()) > 100 then return end
    if partner.TradingPartner then ply:Hint(partner:Nick() .. " is already trading with someone.") return end
    if ply.TradingPartner and ply.TradingPartner:IsValid() then return end
    ply.TradingPartner = partner
    partner.TradingPartner = ply
    
    net.Start("OCRP_OpenTrade")
    net.WriteInt(partner:EntIndex(), 32)
    net.Send(ply)
    
    net.Start("OCRP_OpenTrade")
    net.WriteInt(ply:EntIndex(), 32)
    net.Send(partner)
    
    ply.ItemsForTrade = {}
    partner.ItemsForTrade = {}
    ply.MoneyForTrade = 0
    partner.MoneyForTrade = 0
    ply.ConfirmedTrade = false
    partner.ConfirmedTrade = false
    
    SV_PrintToAdmin(ply, "OPEN-TRADE", "opened trade window with " .. partner:Nick())
    
end
hook.Add("ShowSpare2", "ORCP_Trade_Player", OpenTradeWindow)

function SetTradeItemAmount(ply, item, amount)
    if not ply.TradingPartner or not ply.TradingPartner:IsValid() then return end
    if GAMEMODE.OCRP_Items[item].DoesntSave then return end
    ply.ItemsForTrade = ply.ItemsForTrade or {}
    ply.ItemsForTrade[item] = (ply.ItemsForTrade[item] or 0) + amount
    net.Start("OCRP_SetTradeItemAmount")
    net.WriteString(item)
    net.WriteInt(amount, 32)
    net.Send(ply.TradingPartner)
end

net.Receive("OCRP_SetTradeItemAmount", function(len, ply)
    SetTradeItemAmount(ply, net.ReadString(), net.ReadInt(32))
end)

function SetTradeMoney(ply, amount)
    if not ply.TradingPartner or not ply.TradingPartner:IsValid() then return end
    ply.MoneyForTrade = amount
    net.Start("OCRP_SetTradeMoney")
    net.WriteInt(amount, 32)
    net.Send(ply.TradingPartner)
end

net.Receive("OCRP_SetTradeMoney", function(len, ply)
    SetTradeMoney(ply, net.ReadInt(32))
end)

function ConfirmTrade(ply)
    if not ply.TradingPartner or not ply.TradingPartner:IsValid() then return end
    ply.ConfirmedTrade = !(ply.ConfirmedTrade or false)
    
    net.Start("OCRP_ConfirmTrade")
    net.Send(ply.TradingPartner)
    
    if ply.ConfirmedTrade and ply.TradingPartner.ConfirmedTrade then
        
        if not CanTradeHappen(ply, ply.TradingPartner) then
            ply.TradingPartner.TradingPartner = nil
            ply.TradingPartner = nil
            return
        end
        
        for item,amt in pairs(ply.ItemsForTrade or {}) do
            ply:RemoveItem(item,amt)
            ply.TradingPartner:GiveItem(item, amt)
            SV_PrintToAdmin(ply.TradingPartner, "TRADE-ITEM", "got " .. tostring(amt) .. " of " .. item .. " in a trade from " .. ply:Nick() .. ".")
        end
        ply.ItemsForTrade = {}
        
        for item,amt in pairs(ply.TradingPartner.ItemsForTrade or {}) do
            ply.TradingPartner:RemoveItem(item,amt)
            ply:GiveItem(item,amt)
            SV_PrintToAdmin(ply, "TRADE-ITEM", "got " .. tostring(amt) .. " of " .. item .. " in a trade from " .. ply.TradingPartner:Nick() .. ".")
        end
        ply.TradingPartner.ItemsForTrade = {}
        
        local mft1 = ply.MoneyForTrade or 0
        if mft1 > 0 then
            ply:TakeMoney(WALLET, mft1)
            ply.TradingPartner:AddMoney(WALLET, mft1)
            SV_PrintToAdmin(ply.TradingPartner, "TRADE-MONEY", "got $" .. tostring(mft1) .. " from " .. ply:Nick() .. " in a trade.")
            ply.MoneyForTrade = 0
        end
        
        local mft2 = ply.TradingPartner.MoneyForTrade or 0
        if mft2 > 0 then
            ply.TradingPartner:TakeMoney(WALLET, mft2)
            ply:AddMoney(WALLET, mft2)
            SV_PrintToAdmin(ply, "TRADE-MONEY", "got $" .. tostring(mft2) .. " from " .. ply.TradingPartner:Nick() .. " in a trade.")
            ply.TradingPartner.MoneyForTrade = 0
        end
        
        ply:Hint("Trade complete.")
        ply.TradingPartner:Hint("Trade complete.")
        
        ply.TradingPartner.TradingPartner = nil
        ply.TradingPartner = nil
        
    end
    
end

net.Receive("OCRP_ConfirmTrade", function(len, ply)
    ConfirmTrade(ply)
end)

function CanTradeHappen(ply1,ply2)
    local totalweight = 0
    for item,amt in pairs(ply1.ItemsForTrade or {}) do
        if ply2:ExceedsMax(item, amt) then
            ply1:Hint("The trade failed because it would cause " .. ply2:Nick() .. " to exceed the maximum amount of " .. GAMEMODE.OCRP_Items[item].Name .. ".")
            ply2:Hint("The trade failed because it would cause you to exceed the maximum amount of " .. GAMEMODE.OCRP_Items[item].Name .. ".")
            return false
        end
        if not ply1:HasItem(item, amt) then
            ply1:Hint("The trade failed because you do not have all the items you offered.")
            ply2:Hint("The trade failed because " .. ply1:Nick() .. " does not have all the items he offered.")
            return false
        end
        totalweight = totalweight + (GAMEMODE.OCRP_Items[item].Weight or 0)
    end
    
    if ply2.OCRPData["Inventory"].WeightData.Cur + totalweight > ply2.OCRPData["Inventory"].WeightData.Max then
        ply1:Hint("The trade failed because " .. ply2:Nick() .. " does not have enough room for all the items.")
        ply2:Hint("The trade failed because you do not have enough room for all the items.")
        return false
    end
    
    totalweight = 0
    
    for item,amt in pairs(ply2.ItemsForTrade or {}) do
        if ply1:ExceedsMax(item, amt) then
            ply2:Hint("The trade failed because it would cause " .. ply1:Nick() .. " to exceed the maximum amount of " .. GAMEMODE.OCRP_Items[item].Name .. ".")
            ply1:Hint("The trade failed because it would cause you to exceed the maximum amount of " .. GAMEMODE.OCRP_Items[item].Name .. ".")
            return false
        end
        if not ply2:HasItem(item, amt) then
            ply1:Hint("The trade failed because " .. ply2:Nick() .. " does not have all the items he offered.")
            ply2:Hint("The trade failed because you do not have all the items you offered.")
            return false
        end
        totalweight = totalweight + (GAMEMODE.OCRP_Items[item].Weight or 0)
    end
    
    if ply1.OCRPData["Inventory"].WeightData.Cur + totalweight > ply1.OCRPData["Inventory"].WeightData.Max then
        ply2:Hint("The trade failed because " .. ply1:Nick() .. " does not have enough room for all the items.")
        ply1:Hint("The trade failed because you do not have enough room for all the items.")
        return false
    end

    if (ply1.MoneyForTrade or 0) > ply1:GetMoney(WALLET) then
        ply1:Hint("The trade failed because you do not have that much money in your wallet.")
        ply2:Hint("The trade failed because " .. ply1:Nick() .. " does not have that much money in his wallet.")
        return false
    end
    
    if (ply2.MoneyForTrade or 0) > ply2:GetMoney(WALLET) then
        ply2:Hint("The trade failed because you do not have that much money in your wallet.")
        ply1:Hint("The trade failed because " .. ply2:Nick() .. " does not have that much money in his wallet.")
        return false
    end
    
    return true
    
end

net.Receive("OCRP_EndTrade", function(len, ply)
    if ply.TradingPartner and ply.TradingPartner:IsValid() then
        ply.TradingPartner:Hint(ply:Nick() .. " has cancelled the trade.")
        net.Start("OCRP_EndTrade")
        net.Send(ply.TradingPartner)
        ply.TradingPartner.TradingPartner = nil
        ply.TradingPartner = nil
    end
end)