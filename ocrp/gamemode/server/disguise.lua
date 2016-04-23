
local DisguisedAdminTable = {}

function AddDisguisedAdmin(ply)
	if !ply:IsAdmin() then return end
	DisguisedAdminTable = DisguisedAdminTable or {}
	DisguisedAdminTable[ply] = ply
	ply.IsDisguised = true
	for k,v in pairs(player.GetAll()) do
		umsg.Start("AddDisAdmin", v)
		umsg.Entity(ply)
		umsg.End()
	end
end

function RemoveDisguisedAdmin(ply)
	if !ply:IsAdmin() then return end
	if DisguisedAdminTable and DisguisedAdminTable[ply] then
		DisguisedAdminTable[ply] = nil
		ply.IsDisguised = false
		for k,v in pairs(player.GetAll()) do
			umsg.Start("RemoveDisAdmin", v)
			umsg.Entity(ply)
			umsg.End()
		end
	end
end

local function SendDisguisedOnInit(ply)
	ply.IsDisguised = false
	timer.Simple(5.5, function()
	for k, v in pairs(DisguisedAdminTable) do
		//if k:IsValid() and k:IsPlayer() then
			//print("sending ", k:Nick())
			umsg.Start("AddDisAdmin", ply)
			umsg.Entity(k)
			umsg.End()
		//end
	end end)
end
hook.Add("PlayerInitialSpawn", "DisguisedPlayerInitialSpawnSend", SendDisguisedOnInit, ply)
