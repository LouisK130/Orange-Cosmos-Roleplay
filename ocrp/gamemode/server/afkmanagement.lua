--AFKManager

local MonitorKeys = {
IN_ATTACK,
IN_DUCK,
IN_FORWARD,
IN_BACK,
IN_USE,
IN_CANCEL,
IN_LEFT,
IN_RIGHT,
IN_MOVELEFT,
IN_MOVERIGHT,
IN_ATTACK2,
IN_RELOAD,
IN_ALT1,
IN_ALT2,
IN_SPEED,
IN_WALK,
IN_ZOOM,
IN_WEAPON1,
IN_WEAPON2,
};

local function CheckAFK( ply )
	local CurTime = CurTime()
	ply.NextCheck = ply.NextCheck or CurTime
	ply.lastaction = ply.lastaction or CurTime
	if ply.NextCheck >= CurTime then return end
	--KeyPressCheck
	for index, inkey in pairs(MonitorKeys) do
		if ply:KeyDown(inkey) or ply:KeyDownLast(inkey) then
			ply.lastaction = CurTime
		end
	end
	--DistanceCheck
	local plyCurrentPos = ply:GetPos()
	ply.lastpos = ply.lastpos or plyCurrentPos
	if plyCurrentPos:Distance( ply.lastpos ) >= 5 then
		ply.lastaction = CurTime
		ply.lastpos = plyCurrentPos
	end
	--AFK Kicker
	if (ply.lastaction <= (CurTime - 900)) then --300 = 5mins
		ply:Hint("You're flagged as afk, move or you'll be kicked!")
		local sound = "vo/npc/vortigaunt/warningfm.wav"
		ply:SendLua("surface.PlaySound( \"" .. sound .. "\" ) ")
		if (ply.lastaction <= (CurTime - 1200)) then --480 = 8mins
			ply:Kick("Kicked For Being AFK")
			return
		end
	end
	ply.NextCheck = CurTime + 20
end

local function AFKManager ( )
	for k, v in pairs(player.GetAll()) do
		if !v:IsAdmin() then
			CheckAFK(v)
		end
	end
end
--hook.Add("Tick", "AFKManager", AFKManager)
