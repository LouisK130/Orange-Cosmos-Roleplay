util.AddNetworkString("OCRP_AddBuddy")
util.AddNetworkString("OCRP_RemoveBuddy")
util.AddNetworkString("OCRP_ChiefMenu")
util.AddNetworkString("OCRP_Bank")
util.AddNetworkString("OCRP_Gas_Pump")
util.AddNetworkString("OCRP_CraftingMenu")
util.AddNetworkString("OCRP_Loot")
util.AddNetworkString("OCRP_LootItem")
util.AddNetworkString("OCRP_VoteMenu")
util.AddNetworkString("OCRP_MayorMenu")
util.AddNetworkString("OCRP_SC")
util.AddNetworkString("OCRP_BuyCar")
util.AddNetworkString("OCRP_SpawnPolice")
util.AddNetworkString("OCRP_SpawnTow")
util.AddNetworkString("OCRP_SpawnPoliceNEW")
util.AddNetworkString("OCRP_SpawnSWAT")
util.AddNetworkString("OCRP_SpawnAmbo")
util.AddNetworkString("OCRP_SpawnFireEngine")
util.AddNetworkString("CL_ShowSkin")
util.AddNetworkString("ocrp_bhydros")
util.AddNetworkString("ocrp_bskin")
util.AddNetworkString("OCRP_IsTyping")
util.AddNetworkString("OCRP_EndTyping")
util.AddNetworkString("OCRP_Broadcast")
util.AddNetworkString("OCRP_Chief_CreateObj")
util.AddNetworkString("OCRP_PoliceMax_Update")
util.AddNetworkString("OCRP_Chief_Supply_Locker")
util.AddNetworkString("OCRP_Swat_Ask")
util.AddNetworkString("OCRP_Swat_Reply")
util.AddNetworkString("OCRP_Hire_Police_Chief")
util.AddNetworkString("OCRP_Useitem")
util.AddNetworkString("OCRP_Dropitem")
util.AddNetworkString("OCRP_DepositItem")
util.AddNetworkString("OCRP_WithdrawItem")
util.AddNetworkString("OCRP_Job_Join")
util.AddNetworkString("OCRP_Job_Quit")
util.AddNetworkString("OCRP_DemotePlayer")
util.AddNetworkString("OCRP_WarrantPlayer")
util.AddNetworkString("OCRP_TaxUpdate")
util.AddNetworkString("OCRP_PoliceIncome_Update")
util.AddNetworkString("OCRP_Arrest_Player")
util.AddNetworkString("OCRP_Mayor_Donate_Police")
util.AddNetworkString("OCRP_Handcuffplayer")
util.AddNetworkString("OCRP_Pay_Bail")
util.AddNetworkString("OCRP_IllegalizeItem")
util.AddNetworkString("OCRP_BeginLooting")
util.AddNetworkString("OCRP_Mayor_CreateObj")
util.AddNetworkString("OCRP_Mayor_Choice")
util.AddNetworkString("OCRP_Vote")
util.AddNetworkString("OCRP_AddBallot")
util.AddNetworkString("OCRP_RemoveBallot")
util.AddNetworkString("OCRP_Withdraw_Money")
util.AddNetworkString("OCRP_Deposit_Money")
util.AddNetworkString("OCRP_AddToWardrobe")
util.AddNetworkString("OCRP_PickWardrobeChoice")
util.AddNetworkString("OCRP_ChangeFace")
util.AddNetworkString("OCRP_ResetProf")
util.AddNetworkString("OCRP_Buy_Property")
util.AddNetworkString("OCRP_Sell_Property")
util.AddNetworkString("OCRP_Set_Permissions")
util.AddNetworkString("OCRP_SearchReply")
util.AddNetworkString("OCRP_Search")
util.AddNetworkString("SV_BuyClothes")
util.AddNetworkString("OCRP_UpgradeSkill")
util.AddNetworkString("OCRP_SendTrade")
util.AddNetworkString("OCRP_EndTrade")
util.AddNetworkString("OCRP_ConfirmTrade")
util.AddNetworkString("OCRP_ToggleMap")
util.AddNetworkString("OCRP_BroadcastMap")
util.AddNetworkString("OCRP_SendMarker")
util.AddNetworkString("OCRP_RemoveMarker")
util.AddNetworkString("OCRP_ShowStartModel")
util.AddNetworkString("OCRP_TaxiMapOpen")
util.AddNetworkString("OCRP_SendTaxiRoute")

sound.Add({
	name = "unfurl_map",
	channel = CHAN_AUTO,
	volume = 1,
	level = 70,
	pitch = 100,
	sound = "ocrp/map_unfurl.wav",
})
net.Receive("OCRP_ToggleMap", function(len, ply)
	local bool = net.ReadInt(2)
	ply:EmitSound("unfurl_map")
	timer.Simple(1, function()	
		ply:StopSound("unfurl_map", 60, 100, 1)
	end)
	net.Start("OCRP_BroadcastMap")
	net.WriteEntity(ply)
	net.WriteInt(bool, 2)
	net.Broadcast()
end)
if not markers then markers = {} end
net.Receive("OCRP_RemoveMarker", function(len, ply)
	local identifier = net.ReadString()
	if markers[identifier] and (markers[identifier].Owner == ply:SteamID()
		or markers[identifier].Icon == "exclamation-red" and ply:Team() == CLASS_POLICE
		or markers[identifier].Icon == "fire-big" and ply:Team() == CLASS_FIREMAN
		or markers[identifier].Icon == "bandaid" and ply:Team() == CLASS_MEDIC
		or markers[identifier].Icon == "exclamation-circle" and (ply:Team() == CLASS_Mayor or ply:Team() == CLASS_CHIEF)) then
		SV_PrintToAdmin(ply, "[REMOVE-MARKER]", "removed " .. markers[identifier].Icon .. " marker.")
		RemoveMarker(identifier, ply)
	end
end)
function RemoveMarker(identifier, ply)
	if markers[identifier] then
        if ply and not string.find(identifier, ply:SteamID()) then return end
		local i = markers[identifier].Icon
		if i == "traffic-cone" then
			for k,v in pairs(player.GetAll()) do
				if v:IsValid() and v:Team() == CLASS_Tow then
					v:Hint("Someone has removed their towtruck request.")
				end
			end
		elseif i == "car-taxi" then
			for k,v in pairs(player.GetAll()) do
				if v:IsValid() and v:Team() == CLASS_TAXI then
					v:Hint("Someone has removed their taxi request.")
				end
			end
		elseif i == "flag-checker" then
			for k,v in pairs(player.GetAll()) do
				if v:IsValid() and v:Team() == CLASS_TAXI then
					v:Hint("Your client has removed their destination.")
				end
			end
			for k,v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
				if v:IsValid() and v:GetNWInt("Client") == ply:EntIndex() then
					v.Destination = nil
				end
			end
		elseif i == "star" or i == "target" then
			local m = "base"
			if i == "target" then m = "target" end
			if ply and ply:IsValid() then
			for k,v in pairs(player.GetAll()) do
				if v:IsValid() and v:GetOrg() ~= 0 and v:GetOrg() == ply:GetOrg() then
					v:Hint(ply:Nick() .. " has removed your org " .. m .. " marker.")
				end
			end
			end
		elseif i == "exclamation-red" then
			for k,v in pairs(player.GetAll()) do
				if v:IsValid() and v:Team() == CLASS_POLICE then
					v:Hint(ply:Nick() .. " has cancelled a 911 police request.")
				end
			end
		elseif i == "bandaid" then
			for k,v in pairs(player.GetAll()) do
				if v:IsValid() and v:Team() == CLASS_MEDIC then
					v:Hint(ply:Nick() .. " has cancelled a 911 ambulance request.")
				end
			end
		elseif i == "fire-big" then
			for k,v in pairs(player.GetAll()) do
				if v:IsValid() and v:Team() == CLASS_FIREMAN then
					v:Hint(ply:Nick() .. " has cancelled a 911 fire report.")
				end
			end
		elseif i == "exclamation-circle" then
			for k,v in pairs(player.GetAll()) do	
				if v:IsValid() and (v:Team() == CLASS_CHIEF or v:Team() == CLASS_Mayor or v:Team() == CLASS_MEDIC or v:Team() == CLASS_POLICE or v:Team() == CLASS_FIREMAN or v:Team() == CLASS_SWAT) then
					v:Hint(ply:Nick() .. " has cancelled a government notification.")
				end
			end
		end
		markers[identifier] = nil
		net.Start("OCRP_RemoveMarker")
		net.WriteString(identifier)
		net.Broadcast()
	end
end
function CollectNeededMarkers(ply)
	local tosend = {}
	for k,v in pairs(markers) do
		if v.Icon == "star" or v.Icon == "target" then
			local own
			for _,p in pairs(player.GetAll()) do	
				if p:IsValid() and p:SteamID() == v.Owner then
					own = p
					break
				end
			end
			if own and own:IsValid() and own:GetOrg() ~= 0 and own:GetOrg() == ply:GetOrg() then
				tosend[k] = v
			end
		elseif v.Icon == "store" then
			tosend[k] = v
		end
	end
	for k,v in pairs(tosend) do
		net.Start("OCRP_SendMarker")
		net.WriteString(k)
		net.WriteString(v.Icon)
		net.WriteFloat(v.Perx)
		net.WriteFloat(v.Pery)
		net.Send(ply)
	end
end
net.Receive("OCRP_SendMarker", function(len, ply)
	local icon = net.ReadString()
	local perx = net.ReadFloat()
	local pery = net.ReadFloat()
	local recipients = {}
	local time
	SV_PrintToAdmin(ply, "[MARKER-PLACE]", "placed a " .. icon .. " marker.")
	if icon == "bandaid" then
		time = 180
		for k,v in pairs(player.GetAll()) do
			if v:IsValid() and v:Team() == CLASS_MEDIC then
				v:Hint("Someone has requested an ambulance, check your map for the location!")
				table.insert(recipients, v)
			end
		end
	elseif icon == "car-taxi" then
		time = 180
		for k,v in pairs(player.GetAll()) do
			if v:IsValid() and v:Team() == CLASS_TAXI then
				v:Hint("Someone has requested taxi pickup, check your map for the location!")
				table.insert(recipients, v)
			end
		end
	elseif icon == "exclamation-circle" then
		if not ply:Team() == CLASS_Mayor and not ply:Team() == CLASS_CHIEF then return end
		time = 300
		for k,v in pairs(player.GetAll()) do
			if v:IsValid() and (v:Team() == CLASS_POLICE or v:Team() == CLASS_MEDIC or v:Team() == CLASS_FIREMAN or v:Team() == CLASS_SWAT or v:Team() == CLASS_CHIEF) then
				local job = "mayor"
				if ply:Team() == CLASS_CHIEF then
					job = "police chief"
				end
				v:Hint("The " .. job .. " has sent you an alert, check your map for the location.")
				table.insert(recipients, v)
			end
		end
	elseif icon == "exclamation-red" then
		time = 180
		for k,v in pairs(player.GetAll()) do
			if v:IsValid() and (v:Team() == CLASS_POLICE or v:Team() == CLASS_SWAT or v:Team() == CLASS_CHIEF) then
				v:Hint("Someone has called 911 requesting immediate assistance, check your map for the location!")
				table.insert(recipients, v)
			end
		end
	elseif icon == "fire-big" then
		time = 180
		for k,v in pairs(player.GetAll()) do	
			if v:IsValid() and v:Team() == CLASS_FIREMAN then
				v:Hint("Someone has reported a fire, check your map for the location!")
				table.insert(recipients, v)
			end
		end
	elseif icon == "flag-checker" then
		local route = CalculateTaxiRoute(ply:GetPos(), PersToWorld(perx, pery))
		local price = CalculateTaxiPrice(route)
		for k,v in pairs(player.GetAll()) do
			if v:IsValid() and v:Team() == CLASS_TAXI then
				if v:GetVehicle() and v:GetVehicle():IsValid() and v:GetVehicle():GetNWInt("Client") == ply:EntIndex() then
					v:GetVehicle().Destination = route[table.getn(route)]
					v:GetVehicle().Price = price
					if price == 0 then
						ply:Hint("You're already at your destination!")
						RemoveMarker(ply:SteamID() .. "_flag-checker", ply)
					else
						v:Hint("Your client has marked a destination, the price is $" .. tostring(price))
						ply:Hint("Your taxi fare is going to be $" .. tostring(price))
						if ply:GetMoney("Wallet") < price then
							ply:Hint("You don't have enough money in your wallet to pay for this taxi ride!")
							v:Hint("Your client cannot afford this fare. You may wish to take them to an ATM.")
						end
						net.Start("OCRP_SendTaxiRoute")
						net.WriteTable(route)
						net.Send(v)
						table.insert(recipients, v)
					end
				end
			end
		end
	elseif icon == "heart-break" then
		time = 60
		for k,v in pairs(player.GetAll()) do
			if v:IsValid() and v:Team() == CLASS_MEDIC then
				v:Hint("A life alert has been activated, check your map for the location!")
				table.insert(recipients, v)
			end
		end
	elseif icon == "star" then
		for k,v in pairs(player.GetAll()) do
			if v:IsValid() and v:InOrg() and v:GetOrg() == ply:GetOrg() and v:HasItem("item_cell") then
				v:Hint(ply:Nick() .. " has marked your org base, check your map for the location!")
				table.insert(recipients, v)
				for k1,v1 in pairs(markers) do
					if v1.Icon == "star" then
						local own
						for _,p in pairs(player.GetAll()) do
							if v1.Owner == p:SteamID() then
								own = p
								break
							end
						end
						if own and own:IsValid() and own:GetOrg() ~= 0 and own:GetOrg() == ply:GetOrg() then
							RemoveMarker(k1)
						end
					end
				end
			end
		end
	elseif icon == "store" then
		for k,v in pairs(player.GetAll()) do
			table.insert(recipients, v)
		end
	elseif icon == "target" then
		for k,v in pairs(player.GetAll()) do
			if v:IsValid() and v:InOrg() and v:GetOrg() == ply:GetOrg() and v:HasItem("item_cell") then
				v:Hint(ply:Nick() .. " has marked your org target, check your map for the location!")
				table.insert(recipients, v)
				for k1,v1 in pairs(markers) do
					if v1.Icon == "target" then
						local own
						for _,p in pairs(player.GetAll()) do
							if v1.Owner == p:SteamID() then
								own = p
								break
							end
						end
						if own and own:IsValid() and own:GetOrg() ~= 0 and own:GetOrg() == ply:GetOrg() then
							RemoveMarker(k1)
						end
					end
				end
			end
		end
	elseif icon == "traffic-cone" then
		time = 180
		for k,v in pairs(player.GetAll()) do
			if v:IsValid() and v:Team() == CLASS_Tow then
				v:Hint("Someone has requested a towtruck, check your map for the location!")
				table.insert(recipients, v)
			end
		end
	end
	if not table.HasValue(recipients, ply) then table.insert(recipients, ply) end
	for k,v in pairs(recipients) do	
		net.Start("OCRP_SendMarker")
		net.WriteString(ply:SteamID() .. "_" .. icon)
		net.WriteString(icon)
		net.WriteFloat(perx)
		net.WriteFloat(pery)
		net.Send(v)
	end
	if icon == "flag-checker" then
		net.Start("OCRP_TaxiMapOpen")
		net.Send(ply)
	end
	if time then
        local stmid = ply:SteamID()
		timer.Simple(time, function()
			RemoveMarker(stmid .. "_" .. icon)
		end)
	end
	markers[ply:SteamID() .. "_" .. icon] = {Perx = perx, Pery = pery, Icon = icon, Owner = ply:SteamID()}
	recipients = {}
end)

function CalculateTaxiRoute(begin, destination)
	local starter = -1
	local ender = -1
	local shortest = 1000000000000000
	local shortestend = 10000000000000
	for k,v in pairs(taxi_nodes) do
		if begin:Distance(v.Pos) < shortest then
			starter = k
			shortest = begin:Distance(v.Pos)
		end
		if destination:Distance(v.Pos) < shortestend then
			ender = k
			shortestend = destination:Distance(v.Pos)
		end
	end
	if starter == -1 then print("failed to find starter node") return end
	if ender == -1 then print("failed to find end node") return end

	-- Now we have a starting node and an ending node, expand frontier
	local frontier = {}
	table.insert(frontier, starter)
	came_from = {}
	came_from[starter] = -1
	local tests = 0
	while table.getn(frontier) > 0 and tests <= 100 do -- limit while to not crash server if something goes wrong
		local current = frontier[1]
		table.remove(frontier, 1)
		for k,v in pairs(taxi_nodes[current].Neighbors) do
			if not came_from[v] then
				table.insert(frontier, v)
				came_from[v] = current
			end
		end
		tests = tests + 1
	end
	local path = {}
	local current = ender
	tests = 0
	while current != starter and tests <= 100 do
		table.insert(path, 1, came_from[current])
		current = came_from[current]
		tests = tests + 1
	end
	table.insert(path, ender)
	return path
end
function CalculateTaxiPrice(path)
	local distance = 0
	local last = -1
	for k,v in pairs(path) do
		if last != -1 then
			distance = distance + taxi_nodes[v].Pos:Distance(taxi_nodes[last].Pos)
		end
		last = v
	end
	return 100 + math.Round(.01*distance)
end

function PersToWorld(perx, pery)
	local topleft_realmap = Vector(12903, 15334, 0)
	local botright_realmap = Vector(-14311, -12566, 0)
	local worldheight = math.abs(topleft_realmap.x) + math.abs(botright_realmap.x)
	local worldwidth = math.abs(topleft_realmap.y) + math.abs(botright_realmap.y)
	local fakepos = Vector(0-pery*worldwidth, 0-perx*worldheight, 0)
	return LocalToWorld(fakepos, Angle(0,0,0), topleft_realmap, Angle(0,0,0))
end