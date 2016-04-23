util.AddNetworkString("OCRP_RequestSearch")
util.AddNetworkString("OCRP_SearchRequestResponse")
util.AddNetworkString("OCRP_ShowSearch")

function RequestSearch(ply, target)
    net.Start("OCRP_RequestSearch")
    net.WriteString(ply:SteamID())
    net.Send(target)
    ply.SearchRequest = {}
    ply.SearchRequest.target = target:SteamID()
    ply.SearchRequest.expires = CurTime() + 20
end

net.Receive("OCRP_SearchRequestResponse", function(len, target)
    local ply = player.GetBySteamID(net.ReadString())
    if not ply or not ply:IsValid() then return end
    if not ply.SearchRequest or not ply.SearchRequest.target == target:SteamID() then return end
    if ply.SearchRequest.expires < CurTime() then target:Hint("This search request has already expired.") return end
    local answer = net.ReadBool()
    if answer then
        net.Start("OCRP_ShowSearch")
        net.WriteString(target:SteamID())
        net.WriteTable(target.OCRPData["Inventory"])
        net.Send(ply)
    else
        ply:Hint("Your search request was denied.")
    end
    ply.SearchRequest = nil
end)

function GM:ShowTeam( ply )
    if ply.CantUse then return false end
    local ent = ply:GetEyeTrace().Entity
    if not ent or not ent:IsValid() then return false end
    if ent:GetPos():Distance(ply:GetPos()) > 150 then return false end
    if ent:IsPlayer() then
        RequestSearch(ply, ent)
        ply:Hint("Search requested.")
        ply.CantUse = true
        timer.Simple(1, function() if ply:IsValid() then ply.CantUse = false end end)
        return false
    elseif ent:GetClass() == "prop_ragdoll" then
        if ent.player and ent.player:IsValid() and ent.player:Team() == CLASS_CITIZEN then
            net.Start("OCRP_ShowSearch")
            net.WriteString(ent.player:SteamID())
            net.WriteTable(ent.player.OCRPData["Inventory"])
            net.Send(ply)
            ent.player:Hint("Your body is being searched.")
        end
    elseif ent:GetClass() == "item_base" then
        if ent:GetModel() == "models/props_c17/furnituredresser001a.mdl" then
            if ply:Team() != CLASS_CITIZEN then
                ply:Hint("You can't change clothes as this job.")
                return false
            end
            net.Start("OCRP_ShowWardrobe")
            net.Send(ply)
            ply.CantUse = true
            timer.Simple(1, function() if ply:IsValid() then ply.CantUse = false end end)
        else
            if ent:GetNWInt("Owner", 0) == ply:EntIndex() then
                umsg.Start("CL_PriceItem", ply)
                    umsg.Bool(true)
                    umsg.Entity(ent)
                umsg.End()
            else
                ply:Hint("You can't price another player's item.")
            end
        end
    end
end