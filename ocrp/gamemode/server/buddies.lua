util.AddNetworkString("OCRP_UpdateBuddies")

net.Receive("OCRP_AddBuddy", function(len, ply)
	AddBud(ply, net.ReadString())
end)
net.Receive("OCRP_RemoveBuddy", function(len, ply)
	RemoveBud(ply, net.ReadString())
end)

function AddBud( ply, NewBudID)
	table.insert(ply.OCRPData["Buddies"], NewBudID)
end

function RemoveBud( ply, ToRemoveID)
    table.RemoveByValue(ply.OCRPData["Buddies"], ToRemoveID)
end

function PMETA:IsBuddy( bud )
    return table.HasValue(self.OCRPData["Buddies"], bud:SteamID())
end

function PMETA:Hint( hint, admin, sel )
    if not self:IsValid() then return end
	if hint != nil and !admin then
		if not self.RecentHints then self.RecentHints = {} end
		if self.RecentHints[hint] then return end
		self.RecentHints[hint] = true
		timer.Simple(1, function()
			if not self or not self:IsValid() then return end
			if not self.RecentHints then return end
			self.RecentHints[hint] = nil
		end)
		umsg.Start("OCRP_Hint", self)
			umsg.String( hint )
		umsg.End()
	elseif hint != nil and admin then
		if !sel then
			for k, v in pairs(player.GetAll()) do
				umsg.Start("OCRP_Hint", v)
					umsg.String( hint )
				umsg.End()
			end
		else
			umsg.Start("OCRP_Hint", sel)
				umsg.String( hint )
			umsg.End()
		end
	end
end

--[[function Debug_Log( ply, t, ... )
	local arg = {...}
	local argString = table.ToString( arg )
	local DebugLog = ""
	local f = "OCRP/Logs/".. t ..".txt"
	if file.Exists(f) then
		DebugLog = file.Read(f)
	end
	DebugLog = DebugLog .. "["..os.date().."] - ["..ply:Nick().."] -> Data: { ".. argString .." }\n"
	file.Write(f,DebugLog)
end

function RemoveAllBuds( ply, cmd, args)
	for k, v in pairs(ply.OCRPData["Buddies"]) do
		ply.OCRPData["Buddies"][k] = nil
		umsg.Start("ocrp_buds", ply)
			umsg.Entity(v)
		umsg.End()
	end
end
concommand.Add("OCRP_RemoveAllBuddies", RemoveAllBuds)

function OCRP_SPECTATEGM(ply,ply2,viewtype,un)
	if un then
		umsg.Start("SpecEnd", ply)
		umsg.End()
		ply:UnSpectate()
		ply:Spawn()
		ply.SpecEntity = nil
		return
	end
	local obs_mode
	if viewtype == "First" then
		obs_mode = OBS_MODE_IN_EYE
	else 
		obs_mode = OBS_MODE_CHASE
	end
	if ply != ply2 then
		--for _,obj in pairs(ply.VisibleWeps) do
		--	if obj:IsValid() then 
		--		obj:SetNoDraw(true) 
		--	end
		--end
		ply:Spectate( obs_mode )
		ply:SpectateEntity( ply2 )
		ply.SpecEntity = ply2
		umsg.Start("Spec", ply)
			umsg.Entity(ply2)
			umsg.Bool(true)
		umsg.End()
	end
end]]