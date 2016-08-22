GM.PlayerTable = {}
GM.PlayTimes = {}

util.AddNetworkString("OCRP_Update_PlayTime")
util.AddNetworkString("AdminRespawnPlayerInNeed")
util.AddNetworkString("OCRP_AddWarning")
util.AddNetworkString("OCRP_RemoveWarning")
util.AddNetworkString("OCRP_HealPlayer")

net.Receive("OCRP_HealPlayer", function(len,ply)
    if not ply:NearNPC("Heal") then return end
    if ply:Health() >= 100 then return end
    if ply:GetMoney(WALLET) < 2500 then
        ply:Hint("You don't have enough in your wallet to pay!")
        return
    end
    if ply.Inhibitors.ForceWalk then
        ply.Inhibitors.ForceWalk = false
        umsg.Start("inhib_forcewalk", ply)
            umsg.Bool(false)
        umsg.End()
        ply:SetRunSpeed(ply.Speeds.Sprint)
        ply:Hint("Your leg has been tended to, and has healed.")
    end
    if ply.Inhibitors.BrokenArm then
        ply.Inhibitors.BrokenArm = false
        ply:Hint("Your arm has been tended to, and has healed.")
    end
    -- Uhhh I guess we'll keep this code. I don't think wounds exists. Maybe I'll add them later?
    for _,wound in pairs(ply.Wounds) do
        if wound:IsValid() then
            wound:Remove()
        end
    end
	
	ply:SetHealth(100);
	ply:EmitSound("items/smallmedkit1.wav",60,100)
    ply:TakeMoney(WALLET, 2500)
    ply:Hint("You have been healed for $2,500.")
end)

net.Receive("OCRP_AddWarning", function(len, ply)
    if ply and ply:IsValid() then
        if ply:GetLevel() > 2 then return end
        local warned = net.ReadEntity()
        if not warned or not warned:IsValid() then
            ply:Hint("That's not a valid player to warn!")
            return
        end
        local reason = net.ReadString()
        warned:AddWarning(ply:Nick(), reason)
        warned:Hint("You have been warned for: " .. reason)
        for k,v in pairs(player.GetAll()) do
            if v:IsValid() and v:GetLevel() <= 2 then
                v:SendWarnings()
            end
        end
    end
end)

net.Receive("OCRP_RemoveWarning", function(len, ply)
    if ply and ply:IsValid() then
        if ply:GetLevel() > 2 then return end
        local warned =  net.ReadEntity()
        local admin = net.ReadString()
        local reason = net.ReadString()
        local Date = net.ReadString()
        if not warned or not warned:IsValid() then return end
        warned:RemoveWarning(admin, reason, Date)
        for k,v in pairs(player.GetAll()) do
            if v:IsValid() and v:GetLevel() <= 2 then
                v:SendWarnings()
            end
        end
    end
end)

net.Receive("AdminRespawnPlayerInNeed", function(len, ply)
    if ply and ply:IsValid() then
        local helped = net.ReadEntity()
        if helped and helped:IsValid() then
            helped:Spawn()
            helped:Hint("An administrator has respawned you.")
        else
            ply:Hint("That player is no longer valid!")
        end
    end
end)

util.AddNetworkString("OCRP_Update_Unownable_Doors")
util.AddNetworkString("OCRP_Update_Ownable_Doors")

function StartPlaytimeCounter(ply)

    local id = "OCRP_Play_Time_" .. ply:SteamID()

    timer.Create(id, 60, 0, function()
        if not ply or not ply:IsValid() then timer.Remove(id) return end
        ply.OCRPData["Playtime"] = ply.OCRPData["Playtime"] + 1
        ply.OCRPData["Playtime_Session"] = ply.OCRPData["Playtime_Session"] + 1
        local refedby = ply.OCRPData["RefedBy"]
        if not refedby or string.find(refedby, "|true") then return end
        if ply.OCRPData["Playtime"] >= 60 then
            local p = player.GetBySteamID(refedby)
            if not p or not p:IsValid() then return end
            p:AddMoney(WALLET, 5000)
            p:Hint("Thanks for referring your friend " .. ply:Nick() .. "! Here's $5000 to show our gratitude!")
            ply.OCRPData["RefedBy"] = ply.OCRPData["RefedBy"] .. "|true"
        end
        if ply:GetOrg() > 0 then
            for _,member in pairs(OCRP_Orgs[ply:GetOrg()].Members or {}) do
                if member.SteamID == ply:SteamID() then
                    member.Playtime = member.Playtime + 1
                end
            end
        end
        for _,org in pairs(OCRP_Orgs) do
            for _,app in pairs(org.Applicants) do
                if app.SteamID == ply:SteamID() then
                    app.Playtime = app.Playtime + 1
                end
            end
        end
    end)
    
    net.Start("OCRP_Update_PlayTime")
    net.WriteInt(ply.OCRPData["Playtime"], 32)
    net.Send(ply)

end

function InitializeEntInformation(ply)

    for _,ent in pairs(ents.FindByClass("item_base")) do
        if ent.price != nil then
            local amt = ent.Amount or 1
            umsg.Start("CL_PriceItem", ply)
                umsg.Bool(false)
                umsg.Entity(ent)
                umsg.Long(tonumber(ent.price))
                umsg.String(tostring(ent.desc))	
                umsg.Long(amt)		
            umsg.End()
        end
        if ent.Drug then
            umsg.Start("OCRP_CreateWeed", ply)
            umsg.Entity(ent)
            umsg.End()
        end
    end
    
    local unownedDoors = {}
    local ownableDoors = {}
    for k,v in pairs(ents.GetAll()) do
        if v:IsValid() and v:IsDoor() then
            if v.UnOwnable then
                unownedDoors[v:EntIndex()] = v.UnOwnable
            elseif v.PropertyKey then
                ownableDoors[v:EntIndex()] = v.PropertyKey
            end
        end
    end
    -- These are all separate since I'm afraid they may accidentally exceed net msg max size and cause problems
    net.Start("OCRP_Update_Unownable_Doors")
    net.WriteTable(unownedDoors)
    net.Send(ply)
    net.Start("OCRP_Update_Ownable_Doors")
    net.WriteTable(ownableDoors)
    net.Send(ply)
    net.Start("OCRP_Update_Owned_Properties")
    net.WriteTable(OwnedProperties)
    net.Send(ply)

end

function LoadingSuccess(ply) -- We make it a global function cuz it has to be called after InitalModelSelection too

    if not ply:IsValid() then return end

    StartPlaytimeCounter(ply)
    ply:UpdateMoney()
    ply:SendWardrobeUpdate()
    SendCarsClient(ply)
    SendOrgsToClient(ply)
    
    InitializeEntInformation(ply)
    
    timer.Simple(10, function()
        if not ply or not ply:IsValid() then return end
        OCRPWelcome(ply)
    end)
    
    CollectNeededMarkers(ply)
    
    ply.MaxDrugs = 5
    
    timer.Simple(5, function()
    
        if ply:GetLevel() <= 4 then
            ply:Give("weapon_physgun")
            if ply:GetLevel() == 4 then
                ply.MaxDrugs = ply.MaxDrugs + 2
                ply.OCRPData["ItemBank"].WeightData.Max = ply.OCRPData["ItemBank"].WeightData.Max * 1.5
            elseif ply:GetLevel() < 4 then
                ply.MaxDrugs = ply.MaxDrugs + 5
                ply.OCRPData["ItemBank"].WeightData.Max = ply.OCRPData["ItemBank"].WeightData.Max * 2
            end
        end
        if ply:GetLevel() <= 2 then
            ply:Give("god_stick")
        end
        
    end)
  
    ply:Freeze(false)
    
    local org = OCRP_Orgs[ply:GetOrg()]
    
    if org then
        for k,v in pairs(org.Perks or {}) do
            if v then
                GAMEMODE.OCRPPerks[k].Function(ply)
            end
        end
        if org.Owner == ply:SteamID() then
            org.OwnerName = ply:Nick()
            org.LastOwnerActivity = os.time()
            if next(org.Applicants) != nil then
                timer.Simple(25, function() ply:Hint("You have pending org applications. Check them in the Q menu.") end)
            end
        end
        local checks = {}
        checks[1] = 1
        checks[2] = 2
        checks[3] = 6
        for i=1,3 do
            local id = checks[i]
            local perk = GAMEMODE.OCRPPerks[id]
            if not org.Perks[id] and perk.Check(ply:GetOrg()) then
                org.Perks[id] = true
                for _,member in pairs(org.Members) do
                    local p = player.GetBySteamID(member.SteamID)
                    if p and p:IsValid() then
                        p:Hint("Congratulations, your org has unlocked the " .. perk.Name .. " perk!")
                        perk.Function(p)
                    end
                end
            end
        end
    end
    
    local droppedOne = false
    while ply:GetSpentPoints() > ply:GetMaxPoints() do
        local level,key = table.Random(ply.OCRPData["Skills"])
        if level > 1 then
            ply.OCRPData["Skills"][key] = level - 1
            ply:UpdateSkill(key)
            droppedOne = true
        end
    end
    if droppedOne then
        timer.Simple(20, function()
            ply:Hint("You have spent more skill points than are available to you.")
            ply:Hint("A random skill level was lowered to bring you back to the proper amount of points.")
        end)
    end
    
    ply.Loaded = true

end

function GM:PlayerInitialSpawn(ply)
	if ply:IsBot() then return end
    ply.Loaded = false
    ply:Freeze(true)
    ply:AllowFlashlight(true)
    ply:SetTeam(CLASS_CITIZEN)
	ply:SetModel("models/player/Group01/male_07.mdl")
    
	ply.Speeds = {Sprint = 300,Run = 150}
	ply.RecentHints = {}
	ply.OCRPData = {}
	ply.OCRPData["Inventory"] = {WeightData = {Cur = 0,Max = 50}} -- Just makes the table
    ply.OCRPData["ItemBank"] = {WeightData = {Cur=0,Max=50}}
	ply.OCRPData["Buddies"] = {} -- Buddies table
	ply.OCRPData["Blacklists"] = {}
	ply.OCRPData["Cars"] = {}
	ply.OCRPData["Wardrobe"] = {}
	ply.OCRPData["Money"] = {}
	ply.OCRPData["Storage"] = {}
	ply.OCRPData["JobCoolDown"] = {}
    ply.OCRPData["Playtime"] = 0
    ply.OCRPData["Playtime_Session"] = 0
    ply.GasSave = {}
    ply.HealthSave = {}
    ply.OCRPData["Skills"] = {}
    
    ply.RechargeTime  = .05
	ply.SprintDecay = .05
	ply.Wounds = {}
	ply.Inhibitors = {ForceWalk =  false,BrokenArm = false,GravGuning = false,}
    
    timer.Simple(3, function()
    
        LoadSQLUser(ply, LoadingSuccess)
        
    end)

end

function GM:PlayerSpawn( ply )
	if ply:IsBot() then return end
	ply:SetParent(nil)
	if GAMEMODE.Maps[string.lower(game.GetMap())] != nil then
		if GAMEMODE.Maps[string.lower(game.GetMap())].SpawnsCitizen != nil then
			local free = true
			local data = table.Random(GAMEMODE.Maps[string.lower(game.GetMap())].SpawnsCitizen)
				for _,objs in pairs(ents.FindInSphere(data.Position,32)) do
					if objs:IsPlayer() then
						local free = false
						break
					end
				end
			if free then
				ply:SetPos(data.Position + Vector(0,0,10))
				ply:SetEyeAngles(data.Ang)
			else
				for _,data in pairs(GAMEMODE.Maps[string.lower(game.GetMap())].SpawnsCitizen) do
					free = true
					for _,objs in pairs(ents.FindInSphere(data.Position,32)) do
						if objs:IsPlayer() then
							local free = false
							break
						end
					end
					if free then
						ply:SetPos(data.Position + Vector(0,0,10))
						ply:SetEyeAngles(data.Ang)
						break
					end
				end	
			end
		end
	end	
	
	if ply:GetRagdoll() then 
		ply:GetRagdoll():Remove() 
		ply.Ragdoll = nil
	end
	for _,wound in pairs(ply.Wounds) do
		if wound:IsValid() then
			wound:Remove()
		end
	end
	
	--[[for _,weapon in pairs(ply.VisibleWeps) do 
		if weapon:IsValid() then
			weapon:SetNoDraw(false)
		end
	end	]]
	
	ply:SetupHands()
	--- Energy ----
	SV_SetEnergy(ply, 100)
	ply.ChargeInt = 0 
	umsg.Start("spawning_energy", ply)
		umsg.Long(100)
	umsg.End()
	---------------
	
	ply.KOInfo = {}
	ply:Give("weapon_keys_ocrp")
	ply:Give("weapon_idle_hands_ocrp")
	ply:Give("weapon_physcannon")
	ply:SelectWeapon("weapon_idle_hands_ocrp")
	
	if ply.Stank != nil then
		ply.Stank.obj:Remove()
		ply:SetColor(255,255,255,255)
	end 
	
	GAMEMODE.SetPlayerSpeed(ply,ply,ply.Speeds.Run,ply.Speeds.Sprint)
	
	if ply:Team() > 1 then
		for _,weapon in pairs(OCRPCfg[ply:Team()].Weapons) do
			ply:Give(weapon)
		end
	end
	
	ply:SetNWInt("Warrant",0)
	
	for item,amount in pairs(ply.OCRPData["Inventory"]) do
		if item != "WeightData" && GAMEMODE.OCRP_Items[item].Weapondata != nil && amount > 0 then
            if ply:Team() == 1 then
                ply:Give(GAMEMODE.OCRP_Items[item].Weapondata.Weapon)
            end
		end	
	end
	for skill,level in pairs(ply.OCRPData["Skills"]) do
		if GAMEMODE.OCRP_Skills[skill].Function != nil then
			GAMEMODE.OCRP_Skills[skill].Function(ply,skill)
		end
	end
	ply:StripAmmo()
	ply:UpdateAmmoCount()
	
	if ply:GetLevel() <= 4 then
		ply:Give("weapon_physgun")
	end
	if ply:GetLevel() <= 2 then
		ply:Give("god_stick")
	end
end

local eteams = {2,3,4,5,6,7}
function PMETA:IsGov()
    return table.HasValue(eteams, self:Team())
end

function PMETA:CreateWound(pos,time)
--[[
	local wound = ents.Create("bleed_obj")
	wound:SetPos(pos)
	wound:SetParent(self)
	wound:Spawn()
	wound:DrawShadow( false )
	
	table.insert(self.Wounds,wound)
	timer.Simple(60,function() if wound:IsValid() then wound:Remove() end end)]]

end

function PMETA:BodyArmor(grade)
	if self.BArmor != nil && self.BArmor:IsValid() then
		if grade == 0 then
			self.BArmor:Remove()
			self.BArmor = nil
		else
			self.BArmor.Grade = grade
			self.BArmor.Health = 50
		end
	else
		if grade == 0 then
			self.BArmor = nil
			return
		end
		self.BArmor = ents.Create("body_armor")
		self.BArmor.Grade = grade
		self.BArmor.Health = 50
		self.BArmor:SetPos(self:GetPos() + Vector(0,0,40)) 
		self.BArmor:SetNWInt("Owner",self:EntIndex()) 
		self.BArmor:SetAngles(self:GetAngles())
		self.BArmor:SetParent(self)
		self.BArmor:Spawn()
	end
	self:Hint("You are now wearing body armor.")
end

function GM:SetPlayerSpeed( ply, run, sprint )

	ply:SetWalkSpeed( run )
	ply:SetRunSpeed( sprint )
	
end

function SV_GetEnergy( ply )
	return ply:GetNWInt("Energy", 100)
end

function SV_SetEnergy( ply, ZeAmt )
	ply:SetNWInt("Energy", ZeAmt)
end

--[[function InvisibilityCheck ( ply )
	local r, g, b, a = Player:GetColor();
	if ply:IsValid() & a == 0 then
		for _,obj in pairs(ply.VisibleWeps) do
			if obj:IsValid() then 
				obj:SetNoDraw(true) 
			end
			ply:Hint("Your weapons are hidden")
		end
	elseif ply:IsValid() & a == 255 then
		for _,obj in pairs(ply.VisibleWeps) do
			if obj:IsValid() then 
				obj:SetNoDraw(false)
			end
			ply:Hint("Your weapons are now on display")
		end
	end
end]]
function SprintDecay(ply, data)
	if ply:IsBot() then return end
	if ply:KeyPressed(IN_JUMP) && ply:OnGround() then
		if  SV_GetEnergy(ply) > 10 then
			if ply:HasSkill("skill_acro") then
				ply:SetJumpPower(240)
			else
				ply:SetJumpPower(160)
			end
			if ply:HasSkill("skill_acro",2) then
				SV_SetEnergy(ply, SV_GetEnergy(ply) - 5)
			else
				SV_SetEnergy(ply, SV_GetEnergy(ply) - 10)
			end
		else
			ply:SetJumpPower(115)
			SV_SetEnergy(ply,0)
		end
	end
	if ply.Inhibitors and (ply.Inhibitors.ForceWalk || ply.Inhibitors.GravGuning) then
		return
	end
	if ply:KeyDown(IN_SPEED) && ply:OnGround() && !ply.Inhibitors.ForceWalk then
		if math.abs(data:GetForwardSpeed()) > 0 || math.abs(data:GetSideSpeed()) > 0 then
			data:SetMoveAngles(data:GetMoveAngles())
			data:SetSideSpeed(data:GetSideSpeed()* 0.5)
			data:SetForwardSpeed(data:GetForwardSpeed())
			if SV_GetEnergy(ply) > 0 && ply.ChargeInt <= CurTime()  then
                SV_SetEnergy(ply, SV_GetEnergy(ply) - 1)
                local nextDecay = CurTime() + 0.05 -- 20 times per second
                if ply:HasSkill("skill_end", 1) then
                    nextDecay = CurTime() + 0.06666 -- 15 times per second (-25%)
                end
                if ply:HasSkill("skill_end", 2) then
                    nextDecay = CurTime() + .1 -- 10 times per second (-50%)
                end
                if ply:HasSkill("skill_end", 3) then
                    nextDecay = CurTime() + .2 -- 5 times per second (-75%)
                end
                ply.ChargeInt = nextDecay
			end
		end
	else
		if SV_GetEnergy(ply) < 100 && ply.ChargeInt <= CurTime() then
			SV_SetEnergy(ply, SV_GetEnergy(ply) + 1)
			ply.ChargeInt = CurTime() + 1
		end
	end
	if SV_GetEnergy(ply) > 0 && !ply.CanSprint then
		ply:SetRunSpeed(ply.Speeds.Sprint)
		ply.CanSprint = true
	elseif SV_GetEnergy(ply) <= 0 && ply.CanSprint  then
		ply:SetRunSpeed(ply.Speeds.Run)
		ply.CanSprint = false
		ply.ChargeInt = CurTime() + 5
	end
	--print("SERVER: ".. SV_GetEnergy(ply))
end
hook.Add("Move", " SprintDecay",  SprintDecay)


function GM:EntityTakeDamage( ent, dmginfo)
    inflictor = dmginfo:GetInflictor()
    attacker = dmginfo:GetAttacker()
    amount = dmginfo:GetDamage()
	if ent:IsNPC() then
        if ent:GetClass() != "npc_barnacle" then
            return true
        end
	end
	if !ent:IsVehicle() && ent.Seats != nil then
		for _,seat in pairs(ent.Seats) do
			if seat:IsValid() && seat:GetDriver():IsPlayer() then
				seat:GetDriver():TakeDamage(amount)
			end
		end
	end
    if ent:GetClass() == "prop_vehicle_jeep" and attacker:IsPlayer() and dmginfo:IsBulletDamage() or dmginfo:IsExplosionDamage() then
        ent:TakeCarDamage(dmginfo:GetDamage() * 8000)
        dmginfo:SetDamage(0)
    end
	if ent:GetClass() == "prop_ragdoll" && ent.player != nil  then
		if  dmginfo:IsBulletDamage() || dmginfo:IsExplosionDamage() then
			OCRP_Job_Quit(ent.player)
			ent.Inhibitors = {ForceWalk =  false,BrokenArm = false,GravGuning = false,}
			umsg.Start("inhib_forcewalk")
				umsg.Bool( false )
			umsg.End()
			ent.player.Ragdoll = nil
			ent.player:Spawn()
			ent.player:SetNWBool("Handcuffed",false)
			Rag_Decay(ent)
			return
		end
	end
	if ent:IsPlayer() then
		if ent.Damage then
			dmginfo:ScaleDamage(ent.Damage)	
			ent.Damage = nil
		end
	end
--[[if ent:IsPlayer() then
		if dmginfo:GetAttacker():IsValid() then
			if dmginfo:GetAttacker():IsPlayer() && dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "weapon_knife_ocrp" && dmginfo:GetAttacker():Crouching() then
				print(math.Round(ent:GetAngles():Forward().y) - math.Round(dmginfo:GetAttacker():GetAngles():Forward().y))
				if math.Round(ent:GetAngles():Forward().y) - math.Round(dmginfo:GetAttacker():GetAngles():Forward().y) <= 1 then
					dmginfo:ScaleDamage( 5 )
				end
			end
		end
	end]]
 
	if ( ent:IsDoor() )  then
		if ent.PadLock && ent.PadLock != nil then
			ent.PadLock:TakeDamage(dmginfo:GetDamage(),dmginfo:GetAttacker(),dmginfo:GetAttacker())
		end
	end
end


function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	if dmginfo:IsFallDamage() then
		dmginfo:ScaleDamage( .25 )
		ply.Damage = .25
	end
	if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 2 )
		ply.Damage = 4
	end
	if ( hitgroup == HITGROUP_LEFTLEG ) || (hitgroup == HITGROUP_RIGHTLEG) then
		ply.Inhibitors.ForceWalk = true
		umsg.Start("inhib_forcewalk", ply)
			umsg.Bool( true )
		umsg.End()
		ply:SetRunSpeed(ply.Speeds.Run)
		ply:Hint("Your leg is broken.")
	end
	if ( hitgroup == HITGROUP_LEFTARM ) || (hitgroup == HITGROUP_RIGHTARM) then
		if math.random(1,2) == 1 then
			ply.Inhibitors.BrokenArm = true
			ply:Hint("Your arm is broken, you don't have the strength to hold anything more than a pistol.")
            if ply:GetActiveWeapon().Assault then
                ply:SelectWeapon("weapon_idle_hands_ocrp")
                ply:Hint("That gun is too heavy to carry with a broken arm.")
            end
		end
	end	
	if ( hitgroup == HITGROUP_STOMACH ) ||  ( hitgroup == HITGROUP_CHEST ) && (ply.BArmor and ply.BArmor:IsValid()) then
		if dmginfo:IsBulletDamage() then
			if dmginfo:GetAttacker():GetActiveWeapon().Peircing  != nil then 
				if ply.BArmor and ply.BArmor:IsValid() and (dmginfo:GetAttacker():GetActiveWeapon().Peircing < ply.BArmor.Grade) then
					dmginfo:SetDamage(0)
					ply:SetVelocity(dmginfo:GetDamageForce()/8)
					ply.Damage = 0
				elseif ply.BArmor and ply.BArmor:IsValid() and dmginfo:GetAttacker():GetActiveWeapon().Peircing == ply.BArmor.Grade then
					if math.random(1,2) == 1 then
						dmginfo:ScaleDamage( .5 )
						ply:SetVelocity(dmginfo:GetDamageForce()/6 )
						ply.Damage = .5
					else
						dmginfo:ScaleDamage( 0 )
						ply:SetVelocity(dmginfo:GetDamageForce()/6 )
						ply.Damage = 0
					end		
				else
					ply:SetVelocity(dmginfo:GetDamageForce() /4 )
					ply.Damage = .75
				end
			end
		end
	end
 	if ply:HasSkill("skill_str",2) then
		dmginfo:ScaleDamage( 0.75 )
		ply.Damage = .75
	end
end

function DisableNoclip( ply )
	return ply:GetLevel() <= 2
end
hook.Add("PlayerNoClip", "DisableNoclip", DisableNoclip)

function GM:CleanUp(ply)
	for _,ent in pairs(ents.GetAll()) do
		if ent:GetClass() == "item_base" or ent:GetClass() == "ocrp_radio" then
			if ent:GetNWInt("Owner") > 0 && !player.GetByID(ent:GetNWInt("Owner")):IsValid() then
                if not GAMEMODE.OCRP_Items[ent:GetNWString("Class")].WeaponData and ent:GetNWString("Class") != "item_pot" then
                    ent:Remove()
                    if ent.Ladder != nil then
                        ent.Ladder:Remove()
                    end
                end
			end
		elseif ent:IsVehicle() then
			if ent:GetNWInt("Owner") > 0 && !player.GetByID(ent:GetNWInt("Owner")):IsValid() then
				ent:Remove()
			end
		elseif ent:IsDoor() && ent:GetClass() != "prop_vehicle_jeep" then
			if ent:GetNWInt("Owner") > 0 && !player.GetByID(ent:GetNWInt("Owner")):IsValid() then
				ent:SetNWInt("Owner",nil)
				ent.Permissions = {}
				ent.Permissions["Buddies"] = false
				ent.Permissions["Org"] = false
				ent.Permissions["Goverment"] = true
				ent.Permissions["Mayor"] = true
			end
		elseif ent:GetClass() == "prop_ragdoll" then
			if ent.player != nil && !ent.player:IsValid() then
				ent:Remove()
			end
		end
	end
end

function Player_Disconnect(ply)
	if ply:IsBot() then return end
    if not ply.Loaded then return end
	if ply.OCRPData["CurCar"] then
        local car = ply.OCRPData.CurCar
        if car and car:IsValid() and car.Ticket then
            local amt = car.Ticket.Cost
            if ply:GetMoney("Wallet") >= amt then
                ply:TakeMoney("Wallet", amt)
            elseif ply:GetMoney("Bank") >= amt then
                ply:TakeMoney("Bank", amt)
            end
            if car.Ticket.Issuer and car.Ticket.Issuer:IsValid() then
                car.Ticket.Issuer:AddMoney("Bank", amt/2, false)
                car.Ticket.Issuer:Hint(ply:Nick() .. "'s ticket was automatically paid because they disconnected. Half went to your bank and half went to the city.")
            end
            for k,v in pairs(player.GetAll()) do
                if v.Mayor then
                    v:Hint("The city has received 50% of a $" .. tostring(amt) .. " fine.")
                end
            end
            Mayor_AddMoney(amt/2)
        end
	end

    local stmid = ply:SteamID()
    if timer.Exists("OCRP_Play_Time_" .. stmid) then
        timer.Remove("OCRP_Play_Time_" .. stmid)
    end
    if not ply:Alive() then
        SV_PrintToAdmin(ply, "DEAD LEAVE", ply:Nick() .. " left the server while dead!")
    end
	for k,v in pairs(markers) do
		if v.Owner == ply:SteamID() and (v.Icon == "target" or v.Icon == "star" or v.Icon == "car-taxi" or v.Icon == "flag-checker" or v.Icon == "heart-break" or v.Icon == "store" or v.Icon == "traffic-cone") then
			RemoveMarker(k, ply)
		end
	end
    
    OCRP_Job_Quit(ply)
    
    -- Keep their info in memory to save at next SQL push

        local id = ply:SteamID()
        GAMEMODE.DisconnectSaves = GAMEMODE.DisconnectSaves or {}
        GAMEMODE.DisconnectSaves[id] = {}
        GAMEMODE.DisconnectSaves[id]["wallet"] = ply:GetMoney(WALLET)
        GAMEMODE.DisconnectSaves[id]["bank"] = ply:GetMoney(BANK)
        GAMEMODE.DisconnectSaves[id]["cars"] = ply:CompileString("car")
        GAMEMODE.DisconnectSaves[id]["inv"] = ply:CompileString("inv")
        GAMEMODE.DisconnectSaves[id]["skills"] = ply:CompileString("skill")
        GAMEMODE.DisconnectSaves[id]["model"] = ply:GetModel()
        GAMEMODE.DisconnectSaves[id]["wardrobe"] = ply:CompileString("wardrobe")
        GAMEMODE.DisconnectSaves[id]["face"] = ply.OCRPData["Face"]
        GAMEMODE.DisconnectSaves[id]["playtime"] = ply.OCRPData["Playtime"]
        GAMEMODE.DisconnectSaves[id]["storage"] = ply:CompileString("storage")
        GAMEMODE.DisconnectSaves[id]["buddies"] = ply:CompileString("buddies")
        GAMEMODE.DisconnectSaves[id]["refedby"] = ply.OCRPData["RefedBy"] or ""
        GAMEMODE.DisconnectSaves[id]["blacklist"] = ply:CompileString("blacklist")
        GAMEMODE.DisconnectSaves[id]["nick"] = ply:Nick()
        GAMEMODE.DisconnectSaves[id]["org_id"] = ply:GetOrg()
        GAMEMODE.DisconnectSaves[id]["org_notes"] = ""
        GAMEMODE.DisconnectSaves[id]["itembank"] = ply:CompileString("itembank")
        if ply:GetOrg() > 0 then
            local org = OCRP_Orgs[ply:GetOrg()]
            for _,member in pairs(org.Members) do
                if member.SteamID == ply:SteamID() then
                    GAMEMODE.DisconnectSaves[id]["org_notes"] = member.Notes or ""
                end
            end
        end
    
    for k,v in pairs(ents.FindByClass("item_base")) do
        if v:GetNWString("Class") == "item_pot" and v:GetNWInt("Owner", 0) == ply:EntIndex() then
            v:SetNWInt("Owner", -1)
        end
    end
    
    if table.Count(player.GetAll()) == 1 then -- he's our last guy, push data
        print("[OCRP] Last player leaving, pushing data now.")
        PushSQLData()
        PushOrgSQLData()
    end
    
    for k,v in pairs(OwnedProperties) do
        if ply:SteamID() == v then
            OCRP_Sell_Property(ply, k, true)
            net.Start("OCRP_Update_Owned_Properties")
                net.WriteTable(OwnedProperties)
            net.Broadcast()
        end
    end
    
    if ply.ChosenCandidate then
        ply:RemoveVote()
    end
    
    if ply:InMayorBallot() then
        ply:RemoveBallot()
    end
    
	timer.Simple(0.5,function() GAMEMODE:CleanUp(ply) end)
end
hook.Add( "PlayerDisconnected", "playerdisconnected", Player_Disconnect ) // Add PlayerDisconnected hook that calls our function.

function GM:CanPlayerSuicide( ply )
	return false
end

function GM:GravGunPunt( ply, Target )
	return false 
end 

function GM:GravGunPickupAllowed( ply, ent )
	if ent:IsValid() then
		if (ent:GetClass() != "item_base" and ent:GetClass() != "ocrp_radio" and ent:GetClass() != "money_obj") then
			return false 
		end
	end
	return true 
end

concommand.Add("OCRP_EmptyCurWeapon",function(ply,cmd,args)
   if not ply:GetActiveWeapon() or not ply:GetActiveWeapon().Primary then return end
   if ply:GetActiveWeapon().Primary.ClipSize > 0 && ply:GetActiveWeapon():Clip1() > 0 then
        if ply:GetActiveWeapon().EmptyClip then
            ply:GetActiveWeapon():EmptyClip()
            ply:UpdateAmmoCount()
        end
    end
	if ply:GetActiveWeapon().PrintName == "Repair Wrench" or ply:GetActiveWeapon().PrintName == "Lockpick" then
		ply:GetActiveWeapon():EmptyClip()
	end
end)
	
function PMETA:GetRagdoll()
	if self.Ragdoll != nil && self.Ragdoll:IsValid() then
		return self.Ragdoll
	end
	return false
end

function GravPickup( ply, ent )
	if (ent:GetClass() == "item_base") && ent.DropTime + 60 < CurTime() then
		return false 
	end
	ply.Inhibitors.GravGuning = true
	ply:SetRunSpeed(ply.Speeds.Run)
	return true 
end
hook.Add("GravGunOnPickedUp", "GravPickup", GravPickup);

function gravDrop(ply,ent)
	ply.Inhibitors.GravGuning = false
    if not ply.Inhibitors.ForceWalk and SV_GetEnergy(ply) > 0 then
        ply:SetRunSpeed(ply.Speeds.Sprint)
    end
end
 
hook.Add( "GravGunOnDropped", "firyLaunch", gravDrop)

function GM:OnPhysgunReload(wep,ply)
	return false
end

function AdminPhysgunFreeze(ply,key)
    if key != IN_ATTACK2 then return end
    local target = ply.PhysgunTarget
    if target and target:IsValid() then
        if target.IsFrozens then
            target:Freeze(false);
            ply:Hint("Player unfrozen.")
            target:Hint("You have been unfrozen by a administrator.")
            target:EmitSound("npc/metropolice/vo/allrightyoucango.wav")
            target.IsFrozens = nil;
        else
            target.IsFrozens = true;
            target:Freeze(true);
            ply:Hint( "Player frozen.");
            target:EmitSound("npc/metropolice/vo/holdit.wav")
            target:Hint("You have been frozen by a administrator.")
        end
        local state = target.IsFrozens and "frozen" or "unfrozen"
        SV_PrintToAdmin(ply, "ADMIN FREEZE", "set " .. target:Nick() .. "'s freeze state to " .. state)
    end
end

hook.Add("KeyPress", "AdminPhysgunFreeze", AdminPhysgunFreeze)

hook.Add("OnPhysgunFreeze", "OCRP_AdminCarFreeze", function( weapon, physobj, ent, ply )
    if ent:GetClass() == 'prop_vehicle_jeep' then
        timer.Simple(0.01, function()
            ent.CarWeld = constraint.Weld(ent, game.GetWorld(), 0, 0, 0, false)
        end)
    end
end)

hook.Add("PhysgunPickup", "car_freeze_pickup", function( ply, ent )
    if ent:GetClass() == 'prop_vehicle_jeep' then
        if ent.CarWeld and ent.CarWeld:IsValid() then
            ent.CarWeld:Remove()
        end
    end
end)

function GM:EntityEmitSound(data)

    if data.Entity:GetClass() == "weapon_physcannon" then
        data.SoundLevel = 50
        return true
    end

end