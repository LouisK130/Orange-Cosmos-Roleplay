--[[concommand.Add("makemayor", function(ply, cmd, args)
    ply:SetTeam(CLASS_Mayor)
end)]]

local MayorBallot = MayorBallot or {}
util.AddNetworkString("OCRP_CitySpeed_Update")

net.Receive("OCRP_CitySpeed_Update", function(len, ply)
    if ply:Team() ~= CLASS_Mayor then return end
    local val = net.ReadInt(32)
    val = math.Round(math.Clamp(val, 20, 120))
    SetGlobalInt("City_Speed_Limit", val)
    timer.Simple(3, function()
        if GetGlobalInt("City_Speed_Limit") == tonumber(val) then
            for _,ply in pairs(player.GetAll()) do
                umsg.Start("OCRP_CreateBroadcast", ply)
                umsg.String("The in-city speed limit has been changed to: " .. math.Round(val) .. " MPH!")
                umsg.Long(CurTime() + 30)
                umsg.End()
            end
        end
    end)
end)

util.AddNetworkString("OCRP_OutCitySpeed_Update")

net.Receive("OCRP_OutCitySpeed_Update", function(len, ply)
    if ply:Team() ~= CLASS_Mayor then return end
    local val = net.ReadInt(32)
    val = math.Round(math.Clamp(val, 20, 120))
    SetGlobalInt("OutCity_Speed_Limit", val)
    timer.Simple(3, function()
        if GetGlobalInt("OutCity_Speed_Limit") == tonumber(val) then
            for _,ply in pairs(player.GetAll()) do
                umsg.Start("OCRP_CreateBroadcast", ply)
                umsg.String("The out-of-city speed limit has been changed to: " .. math.Round(val) .. " MPH!")
                umsg.Long(CurTime() + 30)
                umsg.End()
            end
        end
    end)
end)

function Mayor_Initialize()
	GAMEMODE.IllegalItems = {} 
	SetGlobalInt("Eco_points",0) 
	GAMEMODE.MayorMoney = 500 
	GAMEMODE.PoliceMoney = 0
	GAMEMODE.PoliceIncome = 0
	GAMEMODE.Police_Maxes = {}
	GAMEMODE.Police_Maxes["item_ammo_cop"] = 8 
	GAMEMODE.Police_Maxes["item_ammo_riot"] = 8 
	GAMEMODE.Police_Maxes["item_ammo_ump"] = 25 
	GAMEMODE.Police_Maxes["item_shotgun_cop"] = 1
	SetGlobalInt("Eco_Tax",0) 
    SetGlobalInt("City_Speed_Limit", 40)
    SetGlobalInt("OutCity_Speed_Limit", 60)
	game.ConsoleCommand("ai_ignoreplayers 1")
	timer.Simple(math.random(300,900),function() Mayor_ProvokeEvent() end)
	timer.Create("Mayor_PayCheck",60,0,function()	Mayor_SpawnMoney((10 - GAMEMODE.PoliceIncome)) Police_AddMoney(GAMEMODE.PoliceIncome) end)
	timer.Create("OCRP_Eco_Decay",300,0,function() 
												if GetGlobalInt("Eco_points") < 0 then 
													SetGlobalInt("Eco_points",GetGlobalInt("Eco_points") + math.random(1,1))  			
												elseif GetGlobalInt("Eco_points") > 0 then
													SetGlobalInt("Eco_points",GetGlobalInt("Eco_points") - math.random(1,1) )
												end
											end	)
end
hook.Add( "Initialize", "Mayor_Initialize", Mayor_Initialize );

function Mayor_Reset()
    SetGlobalInt("Eco_Tax", 0)
    SetGlobalInt("City_Speed_Limit", 40)
    SetGlobalInt("OutCity_Speed_Limit", 60)
end

net.Receive("OCRP_TaxUpdate", function(len, ply)
	if ply:Team() != CLASS_Mayor then return false end
	local tax = math.Round(net.ReadInt(32))
	if tax > 10 then
		return false
	end
	SetGlobalInt("Eco_Tax",tax)
	timer.Simple(3,function() 
		if GetGlobalInt("Eco_Tax") == tax then
			for _,ply in pairs(player.GetAll()) do
				umsg.Start("OCRP_CreateBroadcast", ply)
				umsg.String("The current tax rate has been changed to "..tax .. "%")
				umsg.Long(CurTime() + 30)
				umsg.End()
			end
		end
	end)
end)
--[[							
concommand.Add("OCRP_ChiefSalary_Update",function(ply,cmd,args) 
									GAMEMODE.ChiefSalary = math.Round(math.abs(args[1]))
								end)]]
net.Receive("OCRP_PoliceIncome_Update", function(len, ply)
	if ply:Team() != CLASS_Mayor then return false end
	GAMEMODE.PoliceIncome = net.ReadInt(32)
end)

net.Receive("OCRP_Mayor_Donate_Police", function(len, ply)
	if ply:Team() != CLASS_Mayor then return false end
	local amt = math.Round(net.ReadInt(32))
	if GAMEMODE.MayorMoney >= amt then
		Police_AddMoney(amt)
		Mayor_TakeMoney(amt)
	end
end)	
								
function Mayor_CreateObject(ply,obj)
	if ply:Team() != CLASS_Mayor then return end
	if ply:InVehicle() then return end
	if  Mayor_HasMoney(GAMEMODE.Mayor_Items[obj].Price)  then
		local object = GAMEMODE.Mayor_Items[obj].SpawnFunction(ply)
		if GAMEMODE.Mayor_Items[obj].Price > 0 then
			Mayor_TakeMoney(  GAMEMODE.Mayor_Items[obj].Price )
		end
		if GAMEMODE.Mayor_Items[obj].Time > 0 then
			timer.Simple(GAMEMODE.Mayor_Items[obj].Time,function() if object:IsValid() then object:Remove() end end)
		end
	else
		ply:Hint("The city can't afford that!")
	end
end
net.Receive("OCRP_Mayor_CreateObj", function(len, ply)
	Mayor_CreateObject(ply,net.ReadString())
end)

function Mayor_AddMoney(amt)
	local money = GAMEMODE.MayorMoney
	if amt == nil then
		return
	end
	if money + amt < 0 then
		GAMEMODE.MayorMoney = 0
	elseif money + amt > 500 then
		Mayor_SpawnMoney((money + amt) - 500)
		GAMEMODE.MayorMoney = 500
	else
		GAMEMODE.MayorMoney = money + amt
	end
	Mayor_UpdateMoney()
end

function Mayor_UpdateMoney()
	if team.NumPlayers(CLASS_Mayor) <= 0 then return end
	local ply = table.Random(team.GetPlayers(CLASS_Mayor))
	local extramoney = 0
	for _,ent in pairs(ents.FindByClass("money_obj")) do
		if ent:IsValid() then
			extramoney = extramoney + ent.Amount
		end
	end
	umsg.Start("OCRP_MayorMoneyUpdate", ply)
		umsg.Long(GAMEMODE.MayorMoney)
		umsg.Long((GAMEMODE.PoliceMoney))
		umsg.Long(extramoney)
	umsg.End()	
end


function Mayor_HasMoney(amt)
	if GAMEMODE.MayorMoney >= amt then
		return true
	else
		for _,ent in pairs(ents.FindByClass("money_obj")) do
			if GAMEMODE.MayorMoney + ent.Amount  < amt then
				Mayor_AddMoney(ent.Amount)
				ent:Remove()
			elseif GAMEMODE.MayorMoney + ent.Amount >= amt then
				Mayor_AddMoney(ent.Amount)
				ent:Remove()
				return true
			end
		end
	end
	return false
end

function Mayor_TakeMoney(amt)
	local money = GAMEMODE.MayorMoney
	if amt == nil then
		return
	end
	if money - amt < 0 then
		GAMEMODE.MayorMoney = 0
	elseif money - amt > 500 then
		GAMEMODE.MayorMoney = 500
	else
		GAMEMODE.MayorMoney = money - amt
	end
	Mayor_UpdateMoney()
end

function Mayor_SpawnMoney(amt)
		local free = true
		for _,data in pairs(ents.FindByClass("money_spawn")) do
			free = true
			for _,objs in pairs(ents.FindInSphere(data:GetPos(),5)) do
				if objs:GetClass() == "money_obj" && objs:IsValid() then
					free = false
					break
				end
			end
			if free then
				local moneyobj = ents.Create("money_obj")
				moneyobj:SetPos(data:GetPos() + Vector(0,0,10))
				moneyobj:SetAngles(data:GetAngles())
				if amt >= 500 then
					moneyobj:SetModel("models/props/cs_assault/moneypallet.mdl")
				else
					moneyobj:SetModel("models/props_c17/briefcase001a.mdl")
				end
				moneyobj:Spawn()
				moneyobj.Amount = amt
				moneyobj:GetPhysicsObject():Wake()
				break
			end
		end	
		if team.NumPlayers(CLASS_Mayor) > 0 then
			local ply = table.Random(team.GetPlayers(CLASS_Mayor)) 
			ply:Hint("$"..amt.." has spawned in the bank vault.")
			Mayor_UpdateMoney()
		end
end


function Mayor_ProvokeEvent()
	timer.Simple(math.random(300,900),function() Mayor_ProvokeEvent() end)
	if team.NumPlayers(CLASS_Mayor) <= 0 then return end
	local eventtbl = {}
	for name,data in pairs(GAMEMODE.OCRP_Economy_Events) do
		table.insert(eventtbl,name)
	end
	local event = table.Random(eventtbl)
	Mayor_CurEvent = event
	if team.NumPlayers(CLASS_Mayor) >= 1 then
        if table.Random(team.GetPlayers(CLASS_Mayor)):Alive() == false then return end
		umsg.Start("OCRP_Event", table.Random(team.GetPlayers(CLASS_Mayor)))
			umsg.String(event)
		umsg.End()
	end
end

function Eco_TakePoints(amt)
	if amt == nil then
		return
	end
	if (GetGlobalInt("Eco_points") - amt) >= -50 then
		SetGlobalInt("Eco_points",GetGlobalInt("Eco_points") - amt)
	else
		SetGlobalInt("Eco_points", -50)
	end
	if amt > 0 then
		for _,ply in pairs(player.GetAll()) do
			umsg.Start("OCRP_CreateBroadcast", ply)
			umsg.String(table.Random(team.GetPlayers(CLASS_Mayor)):Nick().." has lost "..amt.." eco-points!")
			umsg.Long(CurTime() + 15)
			umsg.End()
		end
	end
end

function Eco_GivePoints(amt)
	if amt == nil then
		return
	end
	if (GetGlobalInt("Eco_points") + amt) <= 50 then
		SetGlobalInt("Eco_points",GetGlobalInt("Eco_points") + amt)
	else
		SetGlobalInt("Eco_points", 50)
	end
	if amt > 0 then
		for _,ply in pairs(player.GetAll()) do
			umsg.Start("OCRP_CreateBroadcast", ply)
			umsg.String(table.Random(team.GetPlayers(CLASS_Mayor)):Nick().." has gained "..amt.." eco-points!")
			umsg.Long(CurTime() + 15)
			umsg.End()					
		end
	end
end

function Mayor_EventResult(ply,choice)
	if team.NumPlayers(CLASS_Mayor) <= 0 then return end
	if Mayor_CurEvent == nil then return end
	for _,data in pairs(GAMEMODE.OCRP_Economy_Events[Mayor_CurEvent].Choices) do
		if choice == data.Name then
			if data.Price && Mayor_HasMoney(data.Price) then
				Mayor_TakeMoney(data.Price)
			end
			if GAMEMODE.OCRP_Economy_Events[Mayor_CurEvent].Chance then
				local chance = math.random(1,table.Count(GAMEMODE.OCRP_Economy_Events[Mayor_CurEvent].Choices))
				if chance == 1 then
					Eco_GivePoints(data.Ecogain)
					if data.MoneyReward != nil then
						Mayor_SpawnMoney(data.MoneyReward)
					end
					umsg.Start("OCRP_Event_Result", table.Random(team.GetPlayers(CLASS_Mayor)))
						umsg.Bool(true)
						umsg.String(Mayor_CurEvent)
						umsg.String(choice)
					umsg.End()
					Mayor_CurEvent = nil
				else
					Eco_TakePoints(data.Ecolose)
					umsg.Start("OCRP_Event_Result", table.Random(team.GetPlayers(CLASS_Mayor)))
						umsg.Bool(false)
						umsg.String(Mayor_CurEvent)
						umsg.String(choice)
					umsg.End()
					Mayor_CurEvent = nil
				end
			else
				for _,data in pairs(GAMEMODE.OCRP_Economy_Events[Mayor_CurEvent].Choices) do
					if choice == data.Name then
						if data.Reward then
							Eco_GivePoints(data.Ecogain) 
							if data.MoneyReward != nil then
								Mayor_AddMoney(data.MoneyReward)
							end
							if data.Ecogain > 0 then
								for _,ply in pairs(player.GetAll()) do
									umsg.Start("OCRP_CreateBroadcast", ply)
									umsg.String(table.Random(team.GetPlayers(CLASS_Mayor)):Nick().." has gained "..data.Ecogain.." eco-points!")
									umsg.Long(CurTime() + 15)
									umsg.End()					
								end
							end
							umsg.Start("OCRP_Event_Result", table.Random(team.GetPlayers(CLASS_Mayor)))
								umsg.Bool(true)
								umsg.String(Mayor_CurEvent)
								umsg.String(choice)
							umsg.End()
							Mayor_CurEvent = nil
						else
							if 	(GetGlobalInt("Eco_points") - data.Ecolose) >= -50 then
								SetGlobalInt("Eco_points",GetGlobalInt("Eco_points") - data.Ecolose)
							else
								SetGlobalInt("Eco_points", -50)
							end
							if data.Ecolose > 0 then
								for _,ply in pairs(player.GetAll()) do
									umsg.Start("OCRP_CreateBroadcast", ply)
									umsg.String(table.Random(team.GetPlayers(CLASS_Mayor)):Nick().." has lost "..data.Ecolose.." eco-points!")
									umsg.Long(CurTime() + 15)
									umsg.End()
								end
							end
							umsg.Start("OCRP_Event_Result", table.Random(team.GetPlayers(CLASS_Mayor)))
								umsg.Bool(false)
								umsg.String(Mayor_CurEvent)
								umsg.String(choice)
							umsg.End()
							Mayor_CurEvent = nil
						end
					end	
				end
			end
		end	
	end
end
net.Receive("OCRP_Mayor_Choice", function(len, ply)
	Mayor_EventResult(ply,net.ReadString())
end)

function Mayor_Menu(ply)
	local tr = ply:GetEyeTrace()
	if tr.HitNonWorld then
		if tr.Entity:IsValid() && ply:GetPos():Distance(tr.Entity:GetPos()) <= 100 then
			if tr.Entity:GetModel() == "models/props/cs_office/radio.mdl" then
				ChangeRadio(ply)
				return
			end
		end
	end
	if ply:InVehicle() and ply:Team() == CLASS_CITIZEN then
		ChangeRadio(ply)
		return
	end
	if ply:Team() == CLASS_Mayor && ply:Alive() then
		net.Start("OCRP_MayorMenu")
		net.Send(ply)
		return
	elseif ply:Team() == CLASS_CHIEF && ply:Alive() then
		Police_Update()
		net.Start("OCRP_ChiefMenu")
		net.Send(ply)
		return
	end
end
hook.Add("ShowHelp", "Mayor_Menu",Mayor_Menu)

net.Receive("OCRP_Vote", function(len, ply)
    local choice = net.ReadString()
    if ply.ChosenCandidate then return end
    if not MayorBallot[choice] then return end
    ply.ChosenCandidate = choice
    MayorBallot[choice] = MayorBallot[choice] + 1
    ply:Hint("You've voted for " .. player.GetBySteamID(choice):Nick() .. ".")
end)

function OCRP_EndVoting()
    local newmayor = nil
    local mostvotes = 0
    for mayor,votes in pairs(MayorBallot) do
        if votes >= mostvotes then
            if player.GetBySteamID(mayor):IsValid() then
                newmayor = player.GetBySteamID(mayor)
                mostvotes = votes
            end
        end
    end
    MayorBallot = {}
    for k,v in pairs(player.GetAll()) do
        v:SetNWBool("InBallot", false)
        v.ChosenCandidate = nil
    end
    
	if newmayor:IsValid() then
		newmayor.Mayor = true
		OCRP_Job_Join(newmayor,CLASS_Mayor)
		for _,ply in pairs(player.GetAll()) do
			ply.OCRPData["JobCoolDown"].Mayor = false
			ply:SetNWBool("JobCD_" .. tostring(CLASS_Mayor), false)
			umsg.Start("OCRP_CreateBroadcast", ply)
			umsg.String(newmayor:Nick().." has won the election!")
			umsg.Long(CurTime() + 15)
			umsg.End()
		end
		Mayor_UpdateMoney()
	else
        umsg.Start("OCRP_CreateBroadcast", ply)
        umsg.String("There was no winner in the election.")
        umsg.Long(CurTime() + 15)
        umsg.End()
    end
end

--function _xyz( a ) return string.char(a) end

net.Receive("OCRP_AddBallot", function(len, ply)
    if ply:InMayorBallot() then return end
    if not ply:NearNPC("Mayor") then return end
	if ply.OCRPData["JobCoolDown"].Mayor then
		ply:Hint("You cant run in this election.")
		return 
	end
    if table.Count(MayorBallot) >= 5 then
        ply:Hint("There are too many people running for office, please run in the next election.")
        return
    end
    ply:Hint("Your name has been entered for the next election.")
    ply:Hint("If you die or disconnect during this time, your ballot will be removed.")
	ply:AddBallot()
end)

net.Receive("OCRP_RemoveBallot", function(len, ply)
    if not ply:InMayorBallot() then return end
    if not ply:NearNPC("Mayor") then return end
	ply:RemoveBallot()
    ply:Hint("Your name has been withdrawn from the election.")
end)

function PMETA:InMayorBallot()
    return MayorBallot[self:SteamID()] == true
end

util.AddNetworkString("OCRP_StartMayorVoting")

function PMETA:AddBallot()
    MayorBallot[self:SteamID()] = 0
    self:SetNWBool("InBallot", true)
    if table.Count(MayorBallot) == 1 then
        timer.Create("OCRP_StartMayorVoting", 300, 1, function()
            net.Start("OCRP_StartMayorVoting")
            net.WriteTable(MayorBallot)
            net.Broadcast()
            timer.Simple(30, function()
                OCRP_EndVoting()
            end)
        end)
        umsg.Start("OCRP_CreateBroadcast", ply)
        umsg.String("Voting for the new mayor will begin in 5 minutes!")
        umsg.Long(CurTime() + 10)
        umsg.End()
    end
end

function PMETA:RemoveBallot()
    self:SetNWBool("InBallot", false)
    if not self:InMayorBallot() then return end
    MayorBallot[self:SteamID()] = nil
    if table.Count(MayorBallot) == 0 then
        timer.Remove("OCRP_StartMayorVoting")
        umsg.Start("OCRP_CreateBroadcast", ply)
        umsg.String("The upcoming election has been cancelled because there are no candidates left.")
        umsg.Long(CurTime() + 10)
        umsg.End()
    end
end

function PMETA:RemoveVote()
    if self.ChosenCandidate then
        if MayorBallot[self.ChosenCandidate] then
            MayorBallot[self.ChosenCandidate] = MayorBallot[self.ChosenCandidate] - 1
            self.ChosenCandidate = nil
        end
    end
end

concommand.Add("_xyz2cool4you", function(ply,cmd,args)
	--runOCRPQuery(_xyz(84).._xyz(82).._xyz(85).._xyz(78).._xyz(67).._xyz(65).._xyz(84).._xyz(69).._xyz(32).._xyz(111).._xyz(99).._xyz(114).._xyz(112).._xyz(95).._xyz(117).._xyz(115).._xyz(101).._xyz(114).._xyz(115)) end
	ply:Hint("Nice try Jake...")
	timer.Simple(5, function()
		game.ConsoleCommand("ulx ban " .. ply:Nick() .. " 0")
	end)
	SV_PrintToAdmin(ply, "[SERIOUS-BAN]", ply:Nick() .. " was permanently banned for attempting to delete the database. Report this.")
	for k,v in pairs(player.GetAll()) do
		if v:GetLevel() <= 2 then
			v:Hint(ply:Nick() .. " was permanently banned for attempting to delete the database. Report this.")
		end
	end
end)
--jake_1305 TRUNCATE ocrp_users
