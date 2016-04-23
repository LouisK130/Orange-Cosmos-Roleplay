--Setup the NPC's.
timer.Create( "npc_respawn", 3600, 0, function()
		for _,v in pairs(ents.FindByClass("npc_*")) do 
			v:Remove() 
		end 
		GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].Function() 
end )
function AddNPC(Pos, Ang, cmd, NPC, NPCName, Shopid,timetochange,Mdl)
	local TheNPC = ents.Create(NPC)
	TheNPC:SetPos( Pos + Vector(0,0,90) )
	TheNPC:SetAngles( Ang )
    TheNPC:CapabilitiesClear()
    TheNPC:CapabilitiesAdd(CAP_TURN_HEAD)
	if Mdl != nil then
		TheNPC:SetModel( Mdl )
	end
	if NPCName == "Taxi" then
		TheNPC:SetModel("models/odessa.mdl")
	end
	TheNPC:Spawn()
	if NPC == "npc_monk" then
		TheNPC:Give("weapon_wrench")
		TheNPC:SetCondition(0)
	end
	TheNPC:SetMoveType(MOVETYPE_NONE)
	TheNPC:SetSolid( SOLID_BBOX )
	TheNPC:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	TheNPC.TakeDamage = function()
        TheNPC:SetHealth(9999999999999999999)
    end
	TheNPC:SetHealth(9999999999999999999)
	TheNPC.Cmd = cmd
	TheNPC.Prev = NPCName
	TheNPC.Id = 1
	local npcphys = TheNPC:GetPhysicsObject()
	if npcphys:IsValid() then
		npcphys:EnableMotion(false)
	end

	
	TheNPC.Bubble = ents.Create("prop_physics")
	TheNPC.Bubble:SetModel("models/extras/info_speech.mdl")
	TheNPC.Bubble:SetMoveType( MOVETYPE_NONE )
	TheNPC.Bubble:SetSolid(0)
	TheNPC.Bubble:AddEffects( EF_ITEM_BLINK )
	TheNPC.Bubble:SetParent( TheNPC )
	TheNPC.Bubble:SetPos(TheNPC:GetPos() + Vector(0,0,90))
	TheNPC.Bubble:SetAngles( Ang )
	TheNPC.Bubble.TakeDamage = function() TheNPC.Bubble:SetHealth(9999999999999999999) end
	TheNPC.Bubble:SetHealth(9999999999999999999)
	TheNPC.Bubble:Spawn()
	
	if timetochange == nil then
		timetochange = {Min = 300,Max = 600}
	end
	
	if #Shopid > 1 then
		ID_Vary(TheNPC,Shopid,timetochange)
	else
		TheNPC.Id = Shopid[1]
	end
	
end


function ID_Vary(npc,tbl,timetochange)
	local random1 = table.Random(tbl)
	if random1 != npc.Id then
		npc.Id = random1
	end
	if timetochange == nil then
		timetochange = {Min = 300,Max = 600}
	end
	timer.Simple(math.random(timetochange.Min,timetochange.Max),function() ID_Vary(npc,tbl,timetochange)  end)
end

function PMETA:NearNPC( NPC )
	if self:InVehicle() then return false end
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 100)) do
		if v:IsNPC() then
			if v.Prev == NPC then
				return true
			end
		end
	end
	return false
end
util.AddNetworkString("OCRP_CreateChat")
util.AddNetworkString("OCRP_NPCTalk")
util.AddNetworkString("OCRP_OpenRelatorMenu")

function GM:KeyPress ( ply, key )
	if ply.CantUse then return end
	if key == IN_USE then
		local traceTable = {}
		traceTable.start = ply:GetShootPos();
		traceTable.endpos = traceTable.start + ply:GetAimVector() * 100;
		traceTable.filter = function(ent) if ent:IsNPC() then return true end end
		traceTable.ignoreworld = true
		
		local tr = util.TraceLine(traceTable);
		if tr.Entity and tr.Entity:IsValid() and tr.Entity:IsNPC() and tr.Entity.Cmd then
			if tr.Entity.Cmd == "OCRP_ShopMenu" then
				net.Start("OCRP_CreateChat")
				net.WriteString(tr.Entity.Id)
				net.WriteInt(1, 2)
				net.WriteString(tr.Entity:GetModel())
				net.Send(ply)	
			elseif tr.Entity.Cmd == "OCRP_NPCTalk" then
				net.Start("OCRP_CreateChat")
				net.WriteString(tr.Entity.Id)
				net.WriteInt(0, 2)
				net.WriteString(tr.Entity:GetModel())
				net.Send(ply)
			elseif tr.Entity.Cmd == "OCRP_RelatorMenu" then
				net.Start("OCRP_OpenRelatorMenu")
				net.Send(ply)
			else
				ply:ConCommand(tr.Entity.Cmd)
			end				
			timer.Simple(0.3, function() ply.CantUse = false end)
		end
	end
end

function GM:OnNPCKilled( victim, killer, weapon )
	timer.Simple(1, function()
    for _,v in pairs(ents.FindByClass("npc_*")) do
		if v:GetClass() == "npc_barnacle" then continue end
            v.Bubble:Remove()
			v:Remove() 
	end 
	GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].Function()
    end)
    if not killer:IsPlayer() then
        if killer:GetNWInt("Owner") > 0 then
            killer = ents.GetByIndex(killer:GetNWInt("Owner"))
        end
    end
    if not killer:IsValid() or not killer:IsPlayer() then
        return
    end
    SV_PrintToAdmin(killer, "[NPC-KILL]", killer:Nick() .. " killed an NPC!")
    killer.NPCSKilled = killer.NPCSKilled or 0
    killer.NPCSKilled = killer.NPCSKilled + 1
    if killer.NPCSKilled >= 3 then
        SV_PrintToAdmin(killer, "[NPC-KILL-BAN]", killer:Nick() .. " was banned for killing 3 NPCs!")
        ULib.ban(killer, 60, "Exceeded maximum allowed NPC kills")
    end
    local i = 0
    while i < 5 do
        killer:Hint("Stop! If you keep killing NPC's you will be autobanned!")
        i = i +1
    end
	--timer.Simple(1, function() AddNPC(vict:GetPos(),vict:GetAngles(), vict.Cmd,vict:GetClass(),vict.Prev,vict.Id,nil,vict:GetModel()) end)
end


concommand.Add("OCRP_RespawnNpcs",function(ply,cmd,args)
	SV_PrintToAdmin( ply, "RESPAWN_NPCS", ply:Nick() .." attempted to run OCRP_RespawnNPCs" )
	if ply:GetLevel() < 3 then
		for _,v in pairs(ents.FindByClass("npc_*")) do
			if v:GetClass() == "npc_barnacle" then continue end
            v.Bubble:Remove()
			v:Remove() 
		end 
		GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].Function() 
	end
end)