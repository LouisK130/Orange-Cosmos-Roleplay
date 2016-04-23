util.AddNetworkString("OCRP_ShowFineCreation")
util.AddNetworkString("OCRP_SendFine")
util.AddNetworkString("OCRP_PayFine")
util.AddNetworkString("OCRP_RefuseFine")
util.AddNetworkString("OCRP_ShowTicketCreation")
util.AddNetworkString("OCRP_CancelTicket")
util.AddNetworkString("OCRP_SendTicket")
util.AddNetworkString("OCRP_PayTicket")
util.AddNetworkString("OCRP_SubmitTicket")

hook.Add("ShowHelp", "OCRP_Fine", function(ply)
    if ply.CantUse == true then return end
    ply.CantUse = true
    timer.Simple(1, function()
        if ply:IsValid() then
            ply.CantUse = false
        end
    end)
    if ply:Team() == CLASS_POLICE or ply:Team() == CLASS_CHIEF then
        local victim = ply:GetEyeTrace().Entity
        if not victim:IsValid() or not victim:IsPlayer() then return end
        if victim:GetPos():Distance(ply:GetPos()) > 100 then return end
        if victim:Team() == CLASS_POLICE or victim:Team() == CLASS_CHIEF or victim:Team() == CLASS_SWAT then
            ply:Hint("You cannot fine this person.")
            return
        end
        net.Start("OCRP_ShowFineCreation")
        net.WriteInt(victim:EntIndex(), 32)
        net.Send(ply)
    elseif ply:Team() == CLASS_Tow then
        local victim = ply:GetEyeTrace().Entity
        if not victim:IsValid() then return end
        if victim:GetPos():Distance(ply:GetPos()) > 100 then return end
        if not victim:GetClass() == "prop_vehicle_jeep" then return end
        if not victim.OwnerObj or not victim.OwnerObj:IsValid() then return end
        if victim.Ticket then
            if ply:EntIndex() == victim.Ticket.Issuer:EntIndex() then
                victim.Ticket = nil
                victim.Boot = nil
                victim.Booter = nil
                ply:Hint("Ticket removed.")
                return
            else
                ply:Hint("You cannot remove another tow truck driver's ticket.")
                return
            end
        end
        if victim:IsGovCar() then
            ply:Hint("You cannot ticket a government vehicle.")
            return
        end
        if victim:BootCar(ply) then
            net.Start("OCRP_ShowTicketCreation")
            net.WriteInt(victim:EntIndex(), 32)
            net.Send(ply)
        end
    end
end)

net.Receive("OCRP_CancelTicket", function(len, ply)
    local victim = Entity(net.ReadInt(32))
    if not victim or not victim:IsValid() or not victim.OCRPData.CurCar or not victim.OCRPData.CurCar:IsValid() then return end
    victim.OCRPData.CurCar.Boot = false
    victim.OCRPData.CurCar.Booter = nil
end)

net.Receive("OCRP_SendFine", function(len, ply)
	local amt = net.ReadInt(32)
	local reason = net.ReadString()
	local victim = Entity(net.ReadInt(32))
	victim = victim:IsValid() and victim or ply
	net.Start("OCRP_SendFine")
	net.WriteInt(amt, 32)
	net.WriteString(reason)
	net.WriteInt(ply:EntIndex(), 32)
	net.Send(victim)
    victim.FineAmount = amt
    SV_PrintToAdmin(ply, "POLICE FINE", ply:Nick() .. " fined " .. victim:Nick() .. " for $" .. amt .. " with reason: " .. reason)
end)

net.Receive("OCRP_PayFine", function(len, ply)
	local amt = net.ReadInt(32)
	local finer = Entity(net.ReadInt(32))
    if amt < 0 then return end
    if amt != ply.FineAmount then return end
	if not ply:IsValid() then return end
	if ply:GetMoney("Wallet") >= amt then
		ply:TakeMoney("Wallet", amt)
		ply:Hint("You have paid your $" .. tostring(amt) .. " fine from your wallet!")
	elseif ply:GetMoney("Bank") >= amt then
		ply:TakeMoney("Bank", amt)
		ply:Hint("You have paid your $" .. tostring(amt) .. " fine from your bank!")
	else
		ply:Hint("You do not have enough money to pay your fine! The police officer has been notified and you may be arrested.")
		if finer:IsValid() then
			finer:Hint("This person does not have enough money to pay their fine. You may arrest him/her.")
			return
		end
	end
	if finer:IsValid() then
		finer:Hint("This person has paid their fine. Half went to your bank and half went to the city.")
        finer:AddMoney("Bank", amt/2, false)
	end
	for k,v in pairs(player.GetAll()) do
		if v.Mayor then
			v:Hint("The city has received 50% of a $" .. tostring(amt) .. " fine.")
		end
	end
    ply.FineAmount = nil
	Mayor_AddMoney(amt/2)
    SV_PrintToAdmin(ply, "PAY POLICE FINE", ply:Nick() .. " paid his/her fine of $" .. amt)
end)

net.Receive("OCRP_RefuseFine", function(len, ply)
	local finer = Entity(net.ReadInt(32))
	if finer:IsValid() then
		finer:Hint("This person has refused to pay their fine. You should arrest him/her.")
	end
	ply:Hint("You have refused to pay your fine. You may be arrested.")
    SV_PrintToAdmin(ply, "REFUSE POLICE FINE", ply:Nick() .. " refused to pay his/her fine.")
end)

net.Receive("OCRP_SubmitTicket", function(len, ply)
    ply:Hint("Ticket submitted.")
    local victim = Entity(net.ReadInt(32))
    local cost = net.ReadInt(32)
    local time = net.ReadString()
    local offense1 = net.ReadString()
    local offense2 = net.ReadString()
    
    local car = victim.OCRPData.CurCar
    local ticket = {}
    ticket["Issuer"] = ply
    ticket["Victim"] = victim
    ticket["Cost"] = cost
    ticket["Time"] = time
    ticket["Offense1"] = offense1
    ticket["Offense2"] = offense2
    
    car.Ticket = ticket
    
    SV_PrintToAdmin(ply, "TOW TICKET", ply:Nick() .. " ticketed " .. victim:Nick() .. " for $" .. cost .. " with reasons " .. offense1 .. " / " .. offense2)
end)

net.Receive("OCRP_PayTicket", function(len, ply)
    local victim = Entity(net.ReadInt(32))
    if not victim:IsValid() then return end
    local car = victim.OCRPData.CurCar
    if not car or not car:IsValid() then return end
    if not car.Ticket then return end
    local amt = car.Ticket.Cost
	if ply:GetMoney("Wallet") >= amt then
		ply:TakeMoney("Wallet", amt)
		ply:Hint("You have paid the $" .. tostring(amt) .. " ticket from your wallet!")
	elseif ply:GetMoney("Bank") >= amt then
		ply:TakeMoney("Bank", amt)
		ply:Hint("You have paid the $" .. tostring(amt) .. " ticket from your bank!")
	else
		ply:Hint("You do not have enough money to pay the ticket!")
        return
	end
    car:Fire("turnon", "", 0)
    if car.Ticket.Issuer and car.Ticket.Issuer:IsValid() then
        car.Ticket.Issuer:AddMoney("Bank", amt/2, false)
        car.Ticket.Issuer:Hint(victim:Nick() .. "'s ticket was paid. Half went to your bank and half went to the city.")
    end
	for k,v in pairs(player.GetAll()) do
		if v.Mayor then
			v:Hint("The city has received 50% of a $" .. tostring(amt) .. " fine.")
		end
	end
	Mayor_AddMoney(amt/2)
    car.Ticket = nil
    car.Boot = false
    car.Booter = nil
    SV_PrintToAdmin(ply, "PAY TOW TICKET", ply:Nick() .. " paid his/her ticket of $" .. amt)
end)