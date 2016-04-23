util.AddNetworkString("OCRP_AskRef")
util.AddNetworkString("OCRP_AddRef")

net.Receive("OCRP_AddRef", function(len, ply)
    if not ply:IsValid() then return end
    local stmid = net.ReadString()
    if not stmid or stmid == "" then return end
    ply.OCRPData["RefedBy"] = stmid
    for k,v in pairs(player.GetAll()) do
        if v:IsValid() and v:SteamID() == stmid then
            v:Hint("Thanks for referring a new player! When your friend gets more playtime, you'll be rewarded!")
        end
    end
end)