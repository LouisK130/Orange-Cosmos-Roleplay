require("mysqloo")

ocrpdb = mysqloo.connect('HOST', 'USERNAME', 'PASSWORD', 'DATABASE', 3306)

ocrpdb:connect()

function runOCRPQuery(sql, callback, errcallback)
    local q = ocrpdb:query(sql)
    function q:onSuccess(data)
        if callback then
            callback(data)
        end
    end
    function q:onError(err, sql)
        print("Query failed! Attempted: " .. sql)
        print("Error: " .. err)
        if ocrpdb:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ocrpdb:connect()
        end
		if errcallback then
			errcallback(sql, err)
		end
    end
    q:start()
end

timer.Create("OCRP_PushSQLDataTimer", 900, 0, function()
    PushSQLData()
    PushOrgSQLData()
end)

function PushSQLData()

    GAMEMODE.DisconnectSaves = GAMEMODE.DisconnectSaves or {}

    if #player.GetAll() == 0 and table.Count(GAMEMODE.DisconnectSaves) == 0 then
        return -- nothing to save
    end

    local columns = {"wallet", "bank", "org_id", "org_notes", "cars", "inv", "skills", "model", "wardrobe", "face", "playtime", "storage", "buddies", "blacklist", "refedby", "nick", "itembank"}
    local q = "UPDATE `ocrp_users` SET "
    
    local updates = {}
    
    for _,column in pairs(columns) do
        updates[column] = "`" .. column .. "` = CASE "
    end
    
    for id,t in pairs(GAMEMODE.DisconnectSaves) do
        if not t or table.Count(t) == 0 then continue end -- Don't save blank data. Not sure how this is happening but it has twice already.
        for _,column in pairs(columns) do
            updates[column] = updates[column] .. "WHEN `STEAM_ID` = '" .. ocrpdb:escape(id) .. "' THEN '" .. ocrpdb:escape(tostring(t[column])) .. "' "
        end
    end
    
    for _,ply in pairs(player.GetAll()) do
        if not ply.Loaded then continue end
        if not ply:IsValid() then continue end
        local t = {}
        t["wallet"] = ply:GetMoney(WALLET)
        t["bank"] = ply:GetMoney(BANK)
        t["inv"] = ply:CompileString("inv")
        t["cars"] = ply:CompileString("car")
        t["skills"] = ply:CompileString("skill")
        t["wardrobe"] = ply:CompileString("wardrobe")
        t["face"] = tostring(ply.OCRPData["Face"])
        t["playtime"] = tostring(ply.OCRPData["Playtime"])
        t["storage"] = ply:CompileString("storage")
        t["buddies"] = ply:CompileString("buddies")
        t["nick"] = ply:Nick()
        t["refedby"] = ply.OCRPData["RefedBy"] or ""
        t["blacklist"] = ply:CompileString("blacklist")
        t["org_id"] = ply:GetOrg()
        -- Rebuild their model path so we don't accidentally save their job model
        t["model"] = ply:Team() == CLASS_CITIZEN and ply:GetModel() or ply.OCRPData["MyModel"]
        t["org_notes"] = ""
        t["itembank"] = ply:CompileString("itembank")
        
        if ply:GetOrg() > 0 then
            local org = OCRP_Orgs[ply:GetOrg()]
            for _,member in pairs(org.Members) do
                if member.SteamID == ply:SteamID() then
                    t["org_notes"] = member.Notes or ""
                end
            end
        end
        
        for _,column in pairs(columns) do
            updates[column] = updates[column] .. "WHEN `STEAM_ID` = '" .. ocrpdb:escape(ply:SteamID()) .. "' THEN '" .. ocrpdb:escape(tostring(t[column])) .. "' "
        end
    end
    
    for column,query in pairs(updates) do
        q = q .. query .. "END, "
    end
    
    q = string.TrimRight(q, " ")
    q = string.TrimRight(q, ",")
    q = q .. " WHERE "
    
    for id,_ in pairs(GAMEMODE.DisconnectSaves) do
        q = q .. "`STEAM_ID` = '" .. id .. "' OR "
    end
    for _,ply in pairs(player.GetAll()) do
        q = q .. "`STEAM_ID` = '" .. ply:SteamID() .. "' OR"
    end
    
    q = string.sub(q, 1, q:len()-3)
    q = q .. ";"
    
    --file.Write("sql.txt", q)
    
    runOCRPQuery(q, function()
        GAMEMODE.DisconnectSaves = {}
        print("[OCRP] Pushed all user data to database.")
    end)

end

function LoadSQLUser(ply, success_callback)

    if not ply:IsValid() then return end
    
    GAMEMODE.DisconnectSaves = GAMEMODE.DisconnectSaves or {}
    if GAMEMODE.DisconnectSaves[ply:SteamID()] then -- We cached their info in mem and haven't pushed it to DB yet, so don't bother checking DB
        print("[OCRP] Loaded user " .. ply:Nick() .. " from memory.")
        local t = GAMEMODE.DisconnectSaves[ply:SteamID()]
        ply.OCRPData["Money"]["Bank"] = tonumber(t["bank"])
        ply.OCRPData["Money"]["Wallet"] = tonumber(t["wallet"])
        ply.OCRPData["Playtime"] = tonumber(t["playtime"])
        ply.OCRPData["Face"] = t["face"]
        ply.OCRPData["RefedBy"] = t["refedby"]
        ply:UnCompileString("inv", t["inv"])
        ply:UnCompileString("car", t["cars"])
        ply:UnCompileString("skill", t["skills"])
        ply:UnCompileString("storage", t["storage"])
        ply:UnCompileString("wardrobe", t["wardrobe"])
        ply:UnCompileString("blacklist", t["blacklist"])
        ply:UnCompileString("buddies", t["buddies"])
        ply:UnCompileString("itembank", t["itembank"])
        if ply.OCRPData["Face"] == nil or ply.OCRPData["Face"] == "" then
            net.Start("OCRP_ShowStartModel")
            net.Send(ply)
        else
            ply:SetModel(t["model"])
        end
        ply:SetOrg(t["org_id"])
        GAMEMODE.DisconnectSaves[ply:SteamID()] = nil
        success_callback(ply)
        return
    end

    local q = "SELECT * FROM `ocrp_users` WHERE `STEAM_ID` = '" .. ocrpdb:escape(ply:SteamID()) .. "';"
    
    local failure = function()
        if ply:IsValid() then
            ply:Kick("An error occured while trying to load your data. Please retry and post on the forums if this problem persists.")
        end
    end
    
    local success = function(results)
    
        if results and #results >= 1 then
        
            local result = results[1]
            ply.OCRPData["Money"]["Bank"] = tonumber(result["bank"])
            ply.OCRPData["Money"]["Wallet"] = tonumber(result["wallet"])
            ply.OCRPData["Playtime"] = tonumber(result["playtime"])
            ply.OCRPData["Face"] = result["face"]
            ply.OCRPData["Org"] = result["org_id"]
            ply.OCRPData["RefedBy"] = result["refedby"]
            ply:UnCompileString("inv", result["inv"])
            ply:UnCompileString("car", result["cars"])
            ply:UnCompileString("skill", result["skills"])
            ply:UnCompileString("storage", result["storage"])
            ply:UnCompileString("wardrobe", result["wardrobe"])
            ply:UnCompileString("blacklists", result["blacklist"])
            ply:UnCompileString("buddies", result["buddies"])
            ply:UnCompileString("itembank", result["itembank"])
            
            if ply.OCRPData["Face"] == nil or ply.OCRPData["Face"] == "" then
                net.Start("OCRP_ShowStartModel")
                net.Send(ply)
            else
                ply:SetModel(result["model"])
            end
            ply:SetOrg(result["org_id"])
            print("[OCRP] Loaded user " .. ply:Nick() .. " from database.")
            success_callback(ply)
        else
        
            NewPlayer(ply)
            
        end
    
    end
    
    runOCRPQuery(q, success, failure)
end

function NewPlayer(ply)

    ply.OCRPData["Money"]["Wallet"] = 500
    ply.OCRPData["Money"]["Bank"] = 4500
    ply.OCRPData["Playtime"] = 0
    ply:SetOrg(0)
    
    local q = "INSERT INTO `ocrp_users` (STEAM_ID, nick, wallet, bank, playtime, org_id) VALUES ('" .. ocrpdb:escape(ply:SteamID()) .. "', '" .. ocrpdb:escape(ply:Nick()) .. "', '500', '4500', '0', '0');"
     
    runOCRPQuery(q, function()
        print("[OCRP] Created new user " .. ply:Nick() .. " in the database.")
        net.Start("OCRP_ShowStartModel")
        net.Send(ply)
    end)
end

function NewOrg(id, name, owner, ownername)
    
    local ownerval = owner .. "|" .. ownername
    
    local q = "INSERT INTO `ocrp_orgs` (orgid, owner, name, lastactivity, perks) VALUES ('" .. id .. "', '" .. ocrpdb:escape(ownerval) .. "', '" .. ocrpdb:escape(name) .. "', '" .. os.time() .. "', '');"
    
    runOCRPQuery(q, function()
        print("[OCRP] Created new org " .. name .. " in the database.")
    end)
end

function RemoveOrg(id)

    local q = "DELETE FROM `ocrp_orgs` WHERE `orgid` = '" .. id .. "';"
    
    runOCRPQuery(q, function()
        print("[OCRP] Deleted org with id " .. id .. ".")
    end)
    
    local q = "UPDATE `ocrp_users` SET `org_id` = '0', `org_notes` = '' WHERE `org_id` = '" .. id .. "';"
    
    runOCRPQuery(q, function()
        print("[OCRP] Removed all members of org with id " .. id .. ".")
    end)
    
end

function GM:ShutDown()

    PushSQLData()
    PushOrgSQLData()

end

function PushOrgSQLData()

    if #player.GetAll() == 0 then return end
    if table.Count(OCRP_Orgs) == 0 then return end

    local columns = {"orgid", "owner", "name", "applicants", "perks"}
    local q = "UPDATE `ocrp_orgs` SET "
    local updates = {}
    
    for _,column in pairs(columns) do
        updates[column] = "`" .. column .. "` = CASE "
    end
    
    for orgid,org in pairs(OCRP_Orgs) do
        local t = {}
        t["orgid"] = orgid
        t["owner"] = org.Owner .. "|" .. org.OwnerName
        t["name"] = org.Name
        t["applicants"] = CompileOrgString(orgid, "applicants")
        t["perks"] = CompileOrgString(orgid, "perks")
        for _,column in pairs(columns) do
            updates[column] = updates[column] .. "WHEN `orgid` = '" .. orgid .. "' then '" .. ocrpdb:escape(tostring(t[column])) .. "' "
        end
    end
    
    for column,query in pairs(updates) do
        q = q .. query .. "END, "
    end
    
    q = string.TrimRight(q, " ")
    q = string.TrimRight(q, ",")
    q = q .. " WHERE "
    
    for id,_ in pairs(OCRP_Orgs) do
        q = q .. "`orgid` = '" .. id .. "' OR "
    end
    
    q = string.sub(q, 1, q:len()-3)
    q = q .. ";"
    
    runOCRPQuery(q, function()
        print("[OCRP] Pushed all org data to database.")
    end)
    
end

function LoadOrgSQLData()
    
    local q = "SELECT * from `ocrp_orgs`;"
    
    local failure = function()
        for i=1,5 do
            print("[OCRP] An error occurred while trying to load org data from the database. This is a critical error!")
        end
    end
    
    local success = function(results)
    
        for k,v in pairs(results) do
            local t = {}
            t.Owner = string.sub(v.owner, 1, string.find(v.owner, "|")-1)
            t.OwnerName = string.sub(v.owner, string.find(v.owner, "|")+1, v.owner:len())
            t.Name = v.name
            t.Applicants = UnCompileOrgString(v.orgid, v.applicants, "applicants")
            t.LastOwnerActivity = v.lastactivity
            t.Perks = UnCompileOrgString(v.orgid, v.perks, "perks")
            t.Members = {}
            OCRP_Orgs[v.orgid] = t
        end
        
        print("[OCRP] Loaded org data from database.")
        
        local success2 = function(results)
        
            for k,v in pairs(results) do
                
                local t = {}
                t.Name = v.nick
                t.SteamID = v.STEAM_ID
                t.Notes = v.org_notes
                t.Playtime = v.playtime
                
                table.insert(OCRP_Orgs[v.org_id].Members, t)
                
            end
            
            print("[OCRP] Loaded org member data from database.")
            
        end
        
        local failure2 = function()
            for i=1,5 do
                print("[OCRP] An error occurred while trying to load org member data from the database. This is a critical error!")
            end
        end
        
        local q = "SELECT * FROM `ocrp_users` WHERE org_id > 0;"
        
        runOCRPQuery(q, success2, failure2)
        
    end
    
    runOCRPQuery(q, success, failure)

end

hook.Add("Initialize", "OCRPLoadOrgData", LoadOrgSQLData)

function CompileOrgString(orgid, str)
    local compiled = ""
    if not orgid or orgid == 0 then return compiled end
    local org = OCRP_Orgs[orgid]
    if not org then return compiled end
    
    if str == "applicants" then
        for k,v in pairs(org.Applicants or {}) do
            compiled = compiled .. v.SteamID .. "." .. v.Playtime .. "." .. v.Name .. ";"
        end
    elseif str == "perks" then
        for k,v in pairs(org.Perks or {}) do
            compiled = compiled .. tostring(k) .. ";"
        end
    end
    return compiled
end

function UnCompileOrgString(orgid, data, str)
    local uncompiled = {}
    if not orgid or orgid == 0 then return uncompiled end
    if str == "applicants" then
        for k,v in pairs(string.Explode(";", data, false)) do
            if v == "" then continue end
            local appinfo = string.Explode(".", v, false)
            local t = {}
            t.SteamID = appinfo[1]
            t.Playtime = tonumber(appinfo[2])
            local i = 3
            t.Name = ""
            while i <= #appinfo do
                t.Name = t.Name .. appinfo[i] .. "."
                i = i + 1
            end
            t.Name = string.sub(t.Name, 1, t.Name:len()-1)
            table.insert(uncompiled, t)
        end
    elseif str == "perks" then
        for k,v in pairs(string.Explode(";", data, false)) do
            if not GAMEMODE.OCRPPerks[tonumber(v)] then continue end
            uncompiled[tonumber(v)] = true
        end
    end
    return uncompiled
end

concommand.Add("ocrp_forcesqlpush", function(ply, cmd, args)
    if ply and ply:IsValid() then return end
    PushSQLData()
    PushOrgSQLData()
end)