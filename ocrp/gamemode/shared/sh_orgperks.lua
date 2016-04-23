GM.OCRPPerks = {}

GM.OCRPPerks[1] = {}
GM.OCRPPerks[1].Name = "Heavy Money"
GM.OCRPPerks[1].Desc = "Have online players with $5,000,000 collectively."
GM.OCRPPerks[1].Reward = "Ability to carry 5 more pounds."
GM.OCRPPerks[1].Check = function(orgid)
    
    local totalmoney = 0
    
    for _,member in pairs(OCRP_Orgs[orgid].Members) do
        local ply = player.GetBySteamID(member.SteamID)
        if ply and ply:IsValid() then
            totalmoney = totalmoney + ply:GetMoney(BANK) + ply:GetMoney(WALLET)
        end
    end
    
    return totalmoney >= 5000000
    
end
GM.OCRPPerks[1].Function = function(ply)
    ply.OCRPData["Inventory"].WeightData.Max = ply.OCRPData["Inventory"].WeightData.Max + 5
    for k,v in pairs(ply.OCRPData["Inventory"]) do
        if k != "WeightData" then
            ply:UpdateItem(k) -- update random item to send weight data
            return
        end
    end
end

GM.OCRPPerks[2] = {}
GM.OCRPPerks[2].Name = "Skilled Individuals"
GM.OCRPPerks[2].Desc = "Have 3 different online people at max level for every skill."
GM.OCRPPerks[2].Reward = "1 extra skill point."
GM.OCRPPerks[2].Check = function(orgid)

    local skillsAtMax = {}
    
    for _,member in pairs(OCRP_Orgs[orgid].Members) do
        local ply = player.GetBySteamID(member.SteamID)
        if ply and ply:IsValid() then
            for skill,skillTable in pairs(GAMEMODE.OCRP_Skills) do
                local max = skillTable.MaxLevel
                if ply:HasSkill(skill, max) then
                    skillsAtMax[skill] = skillsAtMax[skill] or 0
                    skillsAtMax[skill] = skillsAtMax[skill] + 1
                end
            end
        end
    end
    
    local threeinall = true
    
    for skill,_ in pairs(GAMEMODE.OCRP_Skills) do
        if (skillsAtMax[skill] or 0) < 3 then
            threeinall = false
        end
    end

    return threeinall
    
end
GM.OCRPPerks[2].Function = function(ply)
    ply:SetMaxPoints(ply:GetMaxPoints() + 1)
    ply:UpdateAllSkills()
end

GM.OCRPPerks[3] = {}
GM.OCRPPerks[3].Name = "Diverse Workforce"
GM.OCRPPerks[3].Desc = "Have 8 people working 8 different jobs at once."
GM.OCRPPerks[3].Reward = "$25 more on every paycheck."
GM.OCRPPerks[3].Check = function(orgid)
    local jobs = {2,3,4,5,6,7,8,9}
    local jobsDone = {}
    
    for _,member in pairs(OCRP_Orgs[orgid].Members) do
        local ply = player.GetBySteamID(member.SteamID)
        if ply and ply:IsValid() and ply:Team() != 1 then
            jobs[ply:Team()] = true
        end
    end
    
    local allJobs = true
    
    for k,v in pairs(jobs) do
        if not jobsDone[v] then
            allJobs = false
        end
    end
    
    return allJobs
end
GM.OCRPPerks[3].Function = function(ply)
    ply.OrgExtraMoney = "25"
end

GM.OCRPPerks[4] = {}
GM.OCRPPerks[4].Name = "Drug Cartel"
GM.OCRPPerks[4].Desc = "Have 125 pots of weed planted at once."
GM.OCRPPerks[4].Reward = "1 extra max weed plant at a time."
GM.OCRPPerks[4].Check = function(orgid)

    local pots = 0
    
    for _,pot in pairs(ents.FindByClass("item_base")) do
        if pot.Drug then
            local ply = Entity(pot:GetNWInt("Owner"))
            if ply and ply:IsValid() and ply:GetOrg() == orgid then
                pots = pots + 1
            end
        end
    end
    
    return pots >= 125
end
GM.OCRPPerks[4].Function = function(ply)
    ply.MaxDrugs = ply.MaxDrugs or 5
    ply.MaxDrugs = ply.MaxDrugs + 1
end

GM.OCRPPerks[5] = {}
GM.OCRPPerks[5].Name = "No Lives"
GM.OCRPPerks[5].Desc = "Have 1 year of collective playtime."
GM.OCRPPerks[5].Reward = "UNDECIDED"
GM.OCRPPerks[5].Check = function(orgid)
    local pt = 0
    for _,member in pairs(OCRP_Orgs[orgid]) do
        pt = pt + member.Playtime
    end
    
    return pt >= 525600
end
GM.OCRPPerks[5].Function = function(ply)
end

GM.OCRPPerks[6] = {}
GM.OCRPPerks[6].Name = "Need for Speed"
GM.OCRPPerks[6].Desc = "Have online players with all the cars collectively."
GM.OCRPPerks[6].Reward = "Ability to purchase the Porsche Tricycle."
GM.OCRPPerks[6].Check = function(orgid)
    local cars = {}
    for _,member in pairs(OCRP_Orgs[orgid].Members) do
        local ply = player.GetBySteamID(member.SteamID)
        if ply and ply:IsValid() then
            for _,carTable in pairs(ply.OCRPData["Cars"]) do
                cars[carTable.car] = true
            end
        end
    end
    local haveAll = true
    for car,_ in pairs(GAMEMODE.OCRP_Cars) do
        if not cars[car] then haveAll = false end
    end
    return haveAll
end
GM.OCRPPerks[6].Function = function(ply)
    ply.CanBuyTricycle = true
    ply:SetNWBool("CanBuyTricycle", true)
end