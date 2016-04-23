util.AddNetworkString("OCRP_LifeAlert_Hacky_Death")
function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply.Ragdoll = ents.Create("prop_ragdoll")
	ply.Ragdoll:SetModel(ply:GetModel())
	ply.Ragdoll:SetPos(ply:GetPos())
	ply.Ragdoll:SetAngles(ply:GetAngles());
	ply.Ragdoll:Spawn()
	ply.Ragdoll:Activate()
	ply.Ragdoll:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ply.Ragdoll:GetPhysicsObject():ApplyForceCenter(dmginfo:GetDamageForce() * dmginfo:GetDamage()/5);
	ply.Ragdoll.player = ply
	ply.Ragdoll.Lootable = false
	
	ply:GetRagdoll().Zaps = 0
	ply:GetRagdoll().Decay = 0 

	ply:AddDeaths( 1 )
	
	ply:BodyArmor(0)
	
	--[[for _,weapon in pairs(ply.VisibleWeps) do 
		if weapon:IsValid() then
			weapon:SetNoDraw(true)
		end
	end]]--
	local tim3r = 0 
	if attacker:GetClass() == "env_explosion" then
		ply.KOInfo = {Wait = CurTime() + 60, Death = true,}
	elseif attacker:GetClass() == "prop_vehicle_jeep" then
		ply.KOInfo = {Wait = CurTime() + 10, Death = false,}
        if dmginfo:GetDamage() == 99998 then
            ply.KOInfo = {Wait = CurTime() + 60, Death = true,}
        end
	elseif attacker:IsPlayer() && attacker:Alive() then
		if attacker:GetActiveWeapon():GetClass() != "weapon_idle_hands_ocrp" && attacker:GetActiveWeapon():GetClass() != "weapon_bat_ocrp" && attacker:GetActiveWeapon():GetClass() != "police_baton" then
			if attacker:GetActiveWeapon():GetClass() == "weapon_taser_ocrp" then
				ply.KOInfo = {Wait = CurTime() + 15, Death = false,}
				local hp = (ply:Health() or 100) + 100
				timer.Simple(15.1, function()
					if ply:IsValid() then
						ply:SetHealth(hp)
					end
				end)
			else
				ply.KOInfo = {Wait = CurTime() + 60, Death = true,}
				ply.Ragdoll.Lootable = true
			end
		else
			ply.KOInfo = {Wait = CurTime() + 30, Death = false,}
		end
	elseif dmginfo:IsFallDamage() then
		ply.KOInfo = {Wait = CurTime() + 60, Death = true,}
	elseif dmginfo:IsExplosionDamage( ) then
		ply.KOInfo = {Wait = CurTime() + 60, Death = true,}
		ply.Ragdoll.Lootable = true
	else
		ply.KOInfo = {Wait = CurTime() + 60, Death = true,}
	end
	if ply.ForcedDeath then
		ply.KOInfo = {Wait = CurTime() + 60, Death = true,}
	end
	if attacker:GetClass() == "prop_fire" then
		if ply.KOInfo and ply.KOInfo.Death == false then
			SV_PrintToAdmin(ply, "KNOCKOUT-FIRE", ply:Nick() .. " was knocked out by a fire.")
		else
			SV_PrintToAdmin(ply, "DEATH-FIRE", ply:Nick() .. " burned in a fire.")
		end
    end
	if attacker:IsPlayer() && attacker:GetActiveWeapon() && attacker:GetActiveWeapon():GetClass() then
		if ply.KOInfo and ply.KOInfo.Death == false then
			SV_PrintToAdmin( ply, "KNOCKOUT-WEAPON", ply:Nick() .." was knocked out by " .. attacker:Nick() .. "(" .. attacker:SteamID() .. ")" .. ". Using " .. attacker:GetActiveWeapon():GetClass() )
		else
			SV_PrintToAdmin( ply, "DEATH-WEAPON", ply:Nick() .." was killed by " .. attacker:Nick() .. "(" .. attacker:SteamID() .. ")" .. ". Using " .. attacker:GetActiveWeapon():GetClass() )
		end
	end
    if dmginfo:GetInflictor() and dmginfo:GetInflictor():GetClass() == "prop_vehicle_jeep" then
        if dmginfo:GetInflictor():GetDriver() and dmginfo:GetInflictor():GetDriver():IsValid() then
			if ply.KOInfo and ply.KOInfo.Death == false then
				SV_PrintToAdmin(ply, "KNOCKOUT-VEHICLE", ply:Nick() .. " was knocked out by a car. Driver: " .. dmginfo:GetInflictor():GetDriver():Nick() .. "(" .. dmginfo:GetInflictor():GetDriver():SteamID() .. ")")
			else
				SV_PrintToAdmin(ply, "DEATH-VEHICLE", ply:Nick() .. " was killed by a car. Driver: " .. dmginfo:GetInflictor():GetDriver():Nick() .. "(" .. dmginfo:GetInflictor():GetDriver():SteamID() .. ")")
			end
        else
			if ply.KOInfo and ply.KOInfo.Death == false then
				SV_PrintToAdmin(ply, "KNOCKOUT-VEHICLE", ply:Nick() .. " was knocked out by a car. Driver: UNKNOWN/ERROR")
			else
				SV_PrintToAdmin(ply, "DEATH-VEHICLE", ply:Nick() .. " was killed by a car. Driver: UNKNOWN/ERROR")
			end
        end
    end
    if dmginfo:GetInflictor() and dmginfo:GetInflictor():IsPlayer() and dmginfo:GetAttacker() and dmginfo:GetAttacker():GetClass() == "prop_vehicle_jeep" then
        if ply.KOInfo.Death then
            SV_PrintToAdmin(ply, "DEATH-VEHICLE", ply:Nick() .. " jumped out of a moving car and was killed.")
        else
            SV_PrintToAdmin(ply, "KNOCKOUT-VEHICLE", ply:Nick() .. " jumped out of a moving car and was knocked out.")
        end
    end
    
    if ply:Team() != CLASS_CITIZEN then
        ply.Ragdoll.Lootable = false
    end
	
 	umsg.Start("OCRP_DeathTime", ply)
	umsg.Long(ply.KOInfo.Wait)
	umsg.Bool(ply.KOInfo.Death)
	umsg.End()
 
 	if ply:HasItem("item_life_alert") and ply.KOInfo.Death then
        net.Start("OCRP_LifeAlert_Hacky_Death")
        net.Send(ply)
        ply:RemoveItem("item_life_alert", 1)
        ply:Hint("Your life alert has called medics and been used up.")
	end
 
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
 
		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
		end
 
	end
 	for item,data in pairs(GAMEMODE.OCRP_Items) do
		if data.Weapondata != nil then
			if ply:GetActiveWeapon() != nil && data.Weapondata.Weapon == ply:GetActiveWeapon():GetClass() && ply:HasItem(item) && ply:Team() == CLASS_CITIZEN && !data.Weapondata.DontDrop then
				ply:DropItem(item)
				break
			end
		end
	end
end
function GM:PlayerDeathThink( ply )

	if (  ply.KOInfo.Wait != nil && ply.KOInfo.Wait > CurTime() ) then return end
	if !ply:Alive() then
		if ply.KOInfo.Death then 
			if ply:Team() == CLASS_Mayor then
                Mayor_Reset()
			end
            OCRP_Job_Quit(ply)			
			ply.Inhibitors = {ForceWalk =  false,BrokenArm = false,GravGuning = false,}
			umsg.Start("inhib_forcewalk")
				umsg.Bool( false )
			umsg.End()
			Rag_Decay(ply.Ragdoll)
			ply.Ragdoll = nil
			ply:Spawn()
			ply:SetNWBool("Handcuffed",false)
            ply:RemoveBallot()
		else
			local pos = ply:GetRagdoll():GetPos()
			ply:Spawn()
			ply:SetHealth(math.random(10,50))
			ply:SetPos(pos)	
			--umsg.Start("SpawningDeath", ply)
			--umsg.End()
		end
	end

end

function Rag_Decay(self) 
	if self:GetClass() != "prop_ragdoll" then
		return
	end
	local decay = self.Decay
	local pos = self:GetPos()
	local angles = self:GetAngles()
	self:Remove()

	self = ents.Create("prop_ragdoll")
	self.Decay = decay + 1
	if self.Decay  >= 1 then
		self:SetModel("models/humans/corpse1.mdl")
		if self.Decay >= 2 then
			self:SetModel("models/humans/Charple01.mdl")
			if self.Decay >= 3 then
				self:Remove()
				return
			end
		end
	end
	self:SetPos(pos)
	self:SetAngles(angles);
	self:Spawn()
	self:Activate()
	self:SetCollisionGroup( 1 )
	
	timer.Simple(180,function() if self:IsValid() then Rag_Decay(self) end end)
end

-- Same as default GMOD but with messages removed
function GM:PlayerDeath(victim, inflictor, attacker)
	if ( attacker == ply ) then
	
		net.Start( "PlayerKilledSelf" )
			net.WriteEntity( ply )
		net.Broadcast()
		
		--MsgAll( attacker:Nick() .. " suicided!\n" )
		
	return end

	if ( attacker:IsPlayer() ) then
	
		net.Start( "PlayerKilledByPlayer" )
		
			net.WriteEntity( ply )
			net.WriteString( inflictor:GetClass() )
			net.WriteEntity( attacker )
		
		net.Broadcast()
		
		--MsgAll( attacker:Nick() .. " killed " .. ply:Nick() .. " using " .. inflictor:GetClass() .. "\n" )
		
	return end
	
	net.Start( "PlayerKilled" )
	
		net.WriteEntity( ply )
		net.WriteString( inflictor:GetClass() )
		net.WriteString( attacker:GetClass() )

	net.Broadcast()
	
	--MsgAll( ply:Nick() .. " was killed by " .. attacker:GetClass() .. "\n" )
end