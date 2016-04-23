--This shit is prolly wrong, but hey-ho.
OCRP_Orgs = OCRP_Orgs or {}
OCRP_OfflineChangedMembers = OCRP_OfflineChangedMembers or {}

util.AddNetworkString("OCRP_CreateOrg")
util.AddNetworkString("OCRP_QuitOrg")
util.AddNetworkString("OCRP_UpdateOrgs")
util.AddNetworkString("OCRP_UpdateSingleOrg")
util.AddNetworkString("OCRP_RemoveOrg")
util.AddNetworkString("OCRP_UpdateOrgName")
util.AddNetworkString("OCRP_KickOrgMember")
util.AddNetworkString("OCRP_SetOrgNotes")
util.AddNetworkString("OCRP_RespondToApplicant")
util.AddNetworkString("OCRP_PassOrgOwnership")
util.AddNetworkString("OCRP_ApplyToOrg")
util.AddNetworkString("OCRP_CancelOrgApplication")

net.Receive("OCRP_CreateOrg", function(len, ply)
    CreateNewOrg(ply, net.ReadString())
end)

net.Receive("OCRP_QuitOrg", function(len, ply)
    QuitOrg(ply)
end)

net.Receive("OCRP_KickOrgMember", function(len, ply)
    KickOrgMember(ply, net.ReadString())
end)

net.Receive("OCRP_SetOrgNotes", function(len, ply)
    UpdateOrgNotes(ply, net.ReadString(), net.ReadString())
end)

net.Receive("OCRP_RespondToApplicant", function(len, ply)
    RespondOrgMembershipRequest(ply, net.ReadString(), net.ReadBool())
end)

net.Receive("OCRP_PassOrgOwnership", function(len, ply)
    PassOrgOwnership(ply, net.ReadString())
end)

net.Receive("OCRP_ApplyToOrg", function(len, ply)
    RequestOrgMembership(ply, net.ReadInt(32))
end)

net.Receive("OCRP_CancelOrgApplication", function(len, ply)
    CancelOrgApplication(ply)
end)

function SendOrgsToClient(ply)
    net.Start("OCRP_UpdateOrgs")
    net.WriteTable(OCRP_Orgs)
    net.Send(ply)
end

function BroadcastSingleOrg(orgid)
    local org = OCRP_Orgs[orgid]
    net.Start("OCRP_UpdateSingleOrg")
    net.WriteInt(orgid, 32)
    net.WriteTable(OCRP_Orgs[orgid])
    net.Broadcast()
end

local allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
function CreateNewOrg(ply, name)
    local name = name:Trim()
    for k,v in pairs(string.ToTable(name)) do
        if not string.find(allowed, v) then
            return
        end
    end
    if name:len() > 25 then return end
    if ply:GetOrg() > 0 then return end
    if ply:GetMoney(WALLET) < 5000 then
        ply:Hint("You need $5000 in your wallet to create an organization.")
        return
    end
    for k,v in pairs(OCRP_Orgs) do
        if string.lower(v.Name) == string.lower(name) then
            ply:Hint("That org name is already taken.")
            return
        end
    end
    ply:TakeMoney(WALLET, 5000)
    local neworg = {}
    neworg.Owner = ply:SteamID()
    neworg.OwnerName = ply:Nick()
    neworg.Name = name
    neworg.Members = {}
    neworg.Perks = {}
    neworg.Applicants = {}
    neworg.LastOwnerActivity = os.time()
    local orgid = table.insert(OCRP_Orgs, neworg)
    ply:Hint("You have created the org \"" .. name .. "\".")
    ply:Hint("If you are inactive for 30 days, this org will be automatically deleted.")
    AddOrgMember(ply:SteamID(), ply:Nick(), ply.OCRPData["Playtime"], orgid)
    NewOrg(orgid, name, ply:SteamID(), ply:Nick())
    BroadcastSingleOrg(orgid)
end

function AddOrgMember(stmid, name, playtime, orgid)
    local t = {}
    t.SteamID = stmid
    t.Name = name
    t.Notes = ""
    t.Playtime = playtime
    table.insert(OCRP_Orgs[orgid].Members, t)
    local ply = player.GetBySteamID(stmid)
    if ply and ply:IsValid() then
        ply:SetOrg(orgid)
    end
    for _,appl in pairs(OCRP_Orgs[orgid].Applicants) do
        if appl.SteamID == stmid then
            OCRP_Orgs[orgid].Applicants[_] = nil
        end
    end
    BroadcastSingleOrg(orgid)
end

function CancelOrgApplication(ply)
    for orgid,org in pairs(OCRP_Orgs) do
        for _,applicant in pairs(org.Applicants) do
            if applicant.SteamID == ply:SteamID() then
                OCRP_Orgs[orgid].Applicants[_] = nil
                BroadcastSingleOrg(orgid)
            end
        end
    end
end

function RequestOrgMembership(ply, orgid)
    if ply:GetOrg() > 0 then return end
    if not OCRP_Orgs[orgid] then return end
    local t = {}
    t.SteamID = ply:SteamID()
    t.Name = ply:Nick()
    t.Playtime = ply.OCRPData["Playtime"]
    table.insert(OCRP_Orgs[orgid].Applicants, t)
    ply:Hint("You have applied to join " .. OCRP_Orgs[orgid].Name .. ".")
    BroadcastSingleOrg(orgid)
    local owner = player.GetBySteamID(OCRP_Orgs[orgid].Owner)
    if owner and owner:IsValid() then
        owner:Hint(ply:Nick() .. " has requested to join " .. OCRP_Orgs[orgid].Name)
    end
end

function RespondOrgMembershipRequest(ply, applicant, accepted)
    if ply:GetOrg() == 0 then return end
    local org = OCRP_Orgs[ply:GetOrg()]
    if not org then return end
    if org.Owner != ply:SteamID() then return end
    for _,appl in pairs(org.Applicants) do
        if appl.SteamID == applicant then
            local name = appl.Name
            local p = player.GetBySteamID(applicant)
            if p and p:IsValid() then
                if accepted then
                    p:Hint("You have been accepted into " .. org.Name .. ".")
                else
                    p:Hint("You have been denied from joining " .. org.Name .. ".")
                end
            end
            if accepted then
                AddOrgMember(appl.SteamID, appl.Name, appl.Playtime, ply:GetOrg())
                ply:Hint("You have accepted " .. appl.Name .. " into " .. org.Name .. ".")
            else
                ply:Hint("You have denied " .. appl.Name .. " from joining " .. org.Name .. ".")
                org.Applicants[_] = nil
                BroadcastSingleOrg(ply:GetOrg())
            end
        end
    end
end

function PassOrgOwnership(ply, target)
    if ply:GetOrg() == 0 then return end
    local org = OCRP_Orgs[ply:GetOrg()]
    if not org then return end
    if org.Owner != ply:SteamID() then return end
    for _,member in pairs(org.Members) do
        PrintTable(member)
        if member.SteamID == target then
            org.Owner = target
            org.OwnerName = member.Name
            local targetply = player.GetBySteamID(target)
            if targetply and targetply:IsValid() then
                targetply:Hint(ply:Nick() .. " has made you owner of " .. org.Name .. ".")
            end
            ply:Hint("You have made " .. member.Name .. " owner of " .. org.Name .. ".")
            BroadcastSingleOrg(ply:GetOrg())
        end
    end
end    

function QuitOrg(ply)
    if ply:GetOrg() == 0 then return end
    local orgid = ply:GetOrg()
    local org = OCRP_Orgs[orgid]
    if not org then return end
    if org.Owner == ply:SteamID() then
        for k,v in pairs(org.Members) do
            local mem = player.GetBySteamID(v.SteamID)
            if mem and mem:IsValid() then
                mem:Hint("Your org was disbanded because the owner left. You are no longer in an org.")
                mem:SetOrg(0)
            end
        end
        OCRP_Orgs[orgid] = nil
        RemoveOrg(orgid)
        net.Start("OCRP_RemoveOrg")
        net.WriteInt(orgid, 32)
        net.Broadcast()
    end
    ply:SetOrg(0)
    ply:Hint("You have left your org.")
end

function KickOrgMember(ply, target)
    if ply:GetOrg() == 0 then return end
    local org = OCRP_Orgs[ply:GetOrg()]
    if not org then return end
    if org.Owner != ply:SteamID() then return end
    for _,member in pairs(org.Members) do
        if member.SteamID == target then
            local name = member.Name
            local kicked = player.GetBySteamID(target)
            if kicked and kicked:IsValid() then
                kicked:Hint("You were removed from " .. org.Name .. " by the owner.")
                kicked:SetOrg(0)
            end
            ply:Hint("You removed " .. name .. " from " .. org.Name .. ".")
            org.Members[_] = nil
            table.insert(OCRP_OfflineChangedMembers, {SteamID=target,org_id=0})
            BroadcastSingleOrg(ply:GetOrg())
        end
    end
end

function UpdateOrgNotes(ply, target, notes)
    if ply:GetOrg() == 0 then return end
    local org = OCRP_Orgs[ply:GetOrg()]
    if org.Owner != ply:SteamID() then return end
    for _,member in pairs(org.Members) do
        if member.SteamID == target then
            member.Notes = notes
            local p = player.GetBySteamID(target)
            if not p or not p:IsValid() then
                table.insert(OCRP_OfflineChangedMembers, {SteamID=target,org_notes=notes})
            end
            BroadcastSingleOrg(ply:GetOrg())
        end
    end
end

-- PMETA
function PMETA:InOrg()
	if self:GetOrg() == 0 then
		return false
	else
		return true
	end
end

function PMETA:SetOrg(OrgID)
	self.Org = OrgID
	self:SetNWInt("Org", OrgID)
    self:UpdateOrgName()
end

function PMETA:UpdateOrgName()
    if self:GetOrg() == 0 then
        self:SetNWInt("OrgName", "")
    else
        self:SetNWInt("OrgName", OCRP_Orgs[self:GetOrg()].Name)
    end
end

function PMETA:GetOrg()
	if self.Org == nil then
		return 0
	else
		return self.Org
	end
end