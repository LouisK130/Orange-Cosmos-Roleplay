function PMETA:UpdateSkill(skill)
	umsg.Start("OCRP_UpdateSkill", self)
		umsg.String(skill)
		umsg.Long(self.OCRPData["Skills"][skill])
	umsg.End()
end

function PMETA:UpgradeSkill(skill)
	if self:GetRemainingPoints() < 1 then self:Hint("You don't have anymore skill points to spend!") return end
	if self.OCRPData["Skills"][skill] == nil then self.OCRPData["Skills"][skill] = 0 end
	if self.OCRPData["Skills"][skill] < GAMEMODE.OCRP_Skills[skill].MaxLevel then
		local bool = true
		if GAMEMODE.OCRP_Skills[skill].Requirements != nil then
			for _,data in pairs(GAMEMODE.OCRP_Skills[skill].Requirements) do
				if !self:HasSkill(data.Skill,data.level) then
					bool = false
				end
			end
		end
		if bool then
			self.OCRPData["Skills"][skill] = self.OCRPData["Skills"][skill] + 1
		end
	end
	self:UpdateSkill(skill)
	if GAMEMODE.OCRP_Skills[skill].Function != nil then
		GAMEMODE.OCRP_Skills[skill].Function(self,skill)
	end
    
    local org = OCRP_Orgs[self:GetOrg()]
    if org and not org.Perks[2] then
        if GAMEMODE.OCRPPerks[2].Check(self:GetOrg()) then
            org.Perks[2] = true
            for _,member in pairs(org.Members) do
                local ply = player.GetBySteamID(member.SteamID)
                if ply and ply:IsValid() then
                    ply:Hint("Congratulations, your org has unlocked the " .. GAMEMODE.OCRPPerks[2].Name .. " perk!")
                    GAMEMODE.OCRPPerks[2].Function(ply)
                end
            end
        end
    end
    
end
net.Receive("OCRP_UpgradeSkill", function(len, ply)
	ply:UpgradeSkill(net.ReadString())
end)

function PMETA:HasSkill(skill,level)
	if level == nil then level = 1 end
	if self.OCRPData["Skills"][skill] != nil then
		if self.OCRPData["Skills"][skill] >= level then
			return true
		end
	end
	return false
end

function PMETA:ResetSkills()
	for skill,level in pairs(self.OCRPData["Skills"]) do
		if level > 0 then
			self:GiveItem("item_"..skill)
			self.OCRPData["Skills"][skill] = 0 
			self:UpdateSkill(skill) 
			if GAMEMODE.OCRP_Skills[skill].RemoveFunc != nil then	
				GAMEMODE.OCRP_Skills[skill].RemoveFunc(self,skill)
			end
		end
	end
end

function PMETA:SetMaxPoints(max)
    self.MaxSkillPoints = max
end

function PMETA:GetMaxPoints()
    return self.MaxSkillPoints or 20
end

function PMETA:GetSpentPoints()
    local spent = 0
    for k,v in pairs(self.OCRPData["Skills"]) do
        if k == "MaxPoints" then continue end
        spent = spent + v
    end
    return spent
end

function PMETA:GetRemainingPoints()

    return self:GetMaxPoints() - self:GetSpentPoints()

end

function PMETA:UpdateAllSkills()
    net.Start("OCRP_UpdateSkills")
    net.WriteTable(self.OCRPData["Skills"])
    net.WriteInt(self:GetMaxPoints(), 32)
    net.Send(self)
end