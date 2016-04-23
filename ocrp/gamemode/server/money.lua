WALLET = "Wallet"
BANK = "Bank"

concommand.Add("ocrp_givemoney", function(ply, cmd, args)
    if ply and ply:IsValid() then return end
    local ply = player.GetBySteamID(args[1]);
    if not ply or not ply:IsValid() then
        print("Failed to give $" .. args[2] .. " to " .. args[1])
        return
    end
    ply:AddMoney(WALLET, tonumber(args[2]))
    ply:Hint("You received $" .. args[2])
    print("Gave $" .. args[2] .. " to " .. ply:Nick() .. " (" .. ply:SteamID() .. ")")
end)
    

function PMETA:UpdateMoney()
	umsg.Start("ocrp_money", self)
		umsg.Long(self:GetMoney( WALLET ))
		umsg.Long(self:GetMoney( BANK ))
	umsg.End()
end

function PMETA:GetMoney( Type )
	return self.OCRPData["Money"][Type]
end

function PMETA:SetMoney( Type, Amount )
	self.OCRPData["Money"][Type] = Amount
	self:UpdateMoney()
end

function PMETA:TakeMoney( Type, Amount )
    if not self.Loaded then return end
    if Amount < 0 then return end
	if self.OCRPData["Money"][Type] < Amount then
		return false
	end
	self.OCRPData["Money"][Type] = self.OCRPData["Money"][Type] - Amount
	self:UpdateMoney()
end

function PMETA:AddMoney( Type, Amount, Bool )
    if not self.Loaded then return end
    if Amount < 0 then return end
	if Type == BANK and Bool then
		if self.OCRPData["Money"][WALLET] < Amount then
			return false
		end
	elseif Type == WALLET and Bool then
		if self.OCRPData["Money"][BANK] < Amount then
			return false
		end
	end
	self.OCRPData["Money"][Type] = self.OCRPData["Money"][Type] + Amount
	self:UpdateMoney()
    
    local org = OCRP_Orgs[self:GetOrg()]
    if org and not org.Perks[1] then
        if GAMEMODE.OCRPPerks[1].Check(self:GetOrg()) then
            org.Perks[1] = true
            for _,member in pairs(org.Members) do
                local ply = player.GetBySteamID(member.SteamID)
                if ply and ply:IsValid() then
                    ply:Hint("Congratulations, your org has unlocked the " .. GAMEMODE.OCRPPerks[1].Name .. " perk!")
                    GAMEMODE.OCRPPerks[1].Function(ply)
                end
            end
        end
    end
end

--[[

function PMETA:SetMoney( Type, amount )
	if Type == WALLET then
		self:SetNWInt( "wallet", amount )
	else
		self:SetNWInt( "bank", amount )
	end
	SaveMoney(self)
end
	
function PMETA:GetMoney( Type )
	if Type == WALLET then
		return tonumber(self:GetNWInt( "wallet" ))
	else
		return tonumber(self:GetNWInt( "bank" ))
	end
end


function PMETA:TakeMoney( Type, amount )
	local curwallet = self:GetMoney(WALLET)
	local curbank = self:GetMoney(BANK)
	
	if Type == WALLET then
		self:SetMoney(WALLET, curwallet - math.Round(amount) )
	else
		self:SetMoney(BANK, curbank - math.Round(amount) )
	end

end

function PMETA:AddMoney( Type, amount)
	local curwallet = self:GetMoney(WALLET)
	local curbank = self:GetMoney(BANK)
	
	if Type == WALLET then
		self:SetMoney(WALLET, curwallet + math.Round(amount) )
	else
		self:SetMoney(BANK, curbank + math.Round(amount) )
	end
end]]--
local wages = {}
wages[CLASS_CITIZEN] = 30
wages[CLASS_POLICE] = 150
wages[CLASS_MEDIC] = 220
wages[CLASS_FIREMAN] = 200
wages[CLASS_SWAT] = 275
wages[CLASS_CHIEF] = 300
wages[CLASS_Mayor] = 300
wages[CLASS_Tow] = 225
wages[CLASS_TAXI] = 100


function PMETA:PayWage()
	if !self:IsValid() then return end
	if !self.Loaded then return false end
	local bonus = 1
	if self:GetLevel() <= 4 then
		bonus = 1.25
    end
    if self:GetLevel() <= 3 then
        bonus = 1.5
    end
    local wage = wages[self:Team()] or 50
    local amt = math.Round(wage * bonus + (GetGlobalInt("Eco_points") / 5))
    if self.OrgExtraMoney then
        amt = amt + self.OrgExtraMoney
    end
    self:AddMoney(BANK, amt)
	if self:Team() == CLASS_CITIZEN then
		self:Hint("You have recieved $"..tostring(amt).." of welfare for being a Citizen of this city. It has been sent to your bank account.")		
	elseif self:Team() == CLASS_POLICE then
		self:Hint("You have recieved $"..tostring(amt).." for being a Police officer of this city. It has been sent to your bank account.")		
	elseif self:Team() == CLASS_MEDIC then
		self:Hint("You have recieved $"..tostring(amt).." for being a Paramedic of this city. It has been sent to your bank account.")
	elseif self:Team() == CLASS_FIREMAN then
		self:Hint("You have recieved $"..tostring(amt).." for being a Fire Fighter of this city. It has been sent to your bank account.")
	elseif self:Team() == CLASS_SWAT then
		self:Hint("You have recieved $"..tostring(amt).." for being part of the SWAT team of this city. It has been sent to your bank account.")	
	elseif self:Team() == CLASS_CHIEF then
		self:Hint("You have recieved $"..tostring(amt).." for being a police chief of this city. It has been sent to your bank account.")		
	elseif self:Team() == CLASS_Mayor then
		self:Hint("You have recieved $"..tostring(amt).." for being the Mayor of this city. It has been sent to your bank account.")
    elseif self:Team() == CLASS_Tow then
		self:Hint("You have recieved $"..tostring(amt).." for being a Tow Truck Driver of this city. It has been sent to your bank account.")
	elseif self:Team() == CLASS_TAXI then
		self:Hint("You have recieved $"..tostring(amt).." for being a Taxi Driver of this city. It has been sent to your bank account.")
	end
end

function ManageWages()
	local Number = 1
	for k, v in pairs(player.GetAll()) do
		if v:Team() == CLASS_CITIZEN then
			v.OCRPData["MyModel"] = v:GetModel()
		end
		Number = Number + 1
		timer.Simple(Number, function() v:PayWage() end)
	end
	Number = 1
end

timer.Create( "WagesAll", 180, 0, ManageWages)

function PMETA:Withdraw( amount )
	
	if self:GetMoney(BANK) < amount then
        return
	end
	SV_PrintToAdmin(self, "WITHDRAW-MONEY", "withdrew $" .. tostring(amount))
    self:TakeMoney(BANK, amount)
	self:AddMoney(WALLET, amount)
end

net.Receive("OCRP_Withdraw_Money", function(len, ply)
	local amt = net.ReadInt(32)
	if math.Round(amt) < 0 then return end
	for _,obj in pairs(ents.FindByClass("Bank_atm")) do
		if obj:GetPos():Distance(ply:GetPos()) < 100 then
			ply:Withdraw(math.Round(amt))
            return
		end
	end
end)

net.Receive("OCRP_Deposit_Money", function(len, ply)
	local amt = net.ReadInt(32)
	if math.Round(amt) < 0 then return end
	for _,obj in pairs(ents.FindByClass("Bank_atm")) do
		if obj:GetPos():Distance(ply:GetPos()) < 100 then
			ply:Deposit(math.Round(amt))
            return
		end
	end
end)

function PMETA:Deposit( amount )
	if amount < 0 then
		return false
	end
    if amount > self:GetMoney(WALLET) then
        return
    end
	SV_PrintToAdmin(self, "DEPOSIT-MONEY", "deposited $" .. tostring(amount))
    self:TakeMoney(WALLET, amount)
	self:AddMoney(BANK, amount)
end
	
