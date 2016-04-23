function GM:inv_UpdateProf(str_Prof,int_Exp,Int_ExpM,Int_ExpP,ply)
	local ga3 = Int_ExpM 
	local ga4 = Int_ExpP
	umsg.Start("OCRP_UpdateProf", ply)
	umsg.String(str_Prof)
	umsg.Long(int_Exp)
	umsg.Long(tonumber(ga3))
	umsg.Long(tonumber(ga4))
	umsg.End()
end

function PMETA:Prof_GiveEXP(pro,XP,XPM,XPP)
	if pro != "Pro_Crafting" then
		local MAX = GAMEMODE.OCRP_Professions[pro].MaxXP || 1000
		if self.OCRPData["Professions"][pro].Exp < MAX then
			self.OCRPData["Professions"][pro].Exp = self.OCRPData["Professions"][pro].Exp + XP
		end	
		GAMEMODE.inv_UpdateProf(nil,pro,self.OCRPData["Professions"][pro].Exp,0,0,self)
	else
		local MAX = GAMEMODE.OCRP_Professions[pro].MaxXP || 1000
		local totalxp =  self.OCRPData["Professions"][pro].Exp.Mechanical + self.OCRPData["Professions"][pro].Exp.Practical
		if totalxp + XPM + XPP < 1000 then
			if self.OCRPData["Professions"][pro].Exp.Skill + XP < 500 then
				self.OCRPData["Professions"][pro].Exp.Skill = self.OCRPData["Professions"][pro].Exp.Skill + XP
			else
				self.OCRPData["Professions"][pro].Exp.Skill = 500
			end
			if self.OCRPData["Professions"][pro].Exp.Mechanical + XPM < 1000 then
				self.OCRPData["Professions"][pro].Exp.Mechanical = self.OCRPData["Professions"][pro].Exp.Mechanical + XPM
			else
				self.OCRPData["Professions"][pro].Exp.Mechanical = 1000
			end
			if self.OCRPData["Professions"][pro].Exp.Practical + XPP < 1000 then
				self.OCRPData["Professions"][pro].Exp.Practical = self.OCRPData["Professions"][pro].Exp.Practical + XPP
			else
				self.OCRPData["Professions"][pro].Exp.Practical = 1000
			end
		end
		GAMEMODE.inv_UpdateProf(nil,pro,tonumber(self.OCRPData["Professions"][pro].Exp.Skill),tonumber(self.OCRPData["Professions"][pro].Exp.Mechanical),tonumber(self.OCRPData["Professions"][pro].Exp.Practical),self)
	end
	if pro == "Pro_Hitman" then
		self.RechargeTime = .5 / GAMEMODE.OCRP_Professions["Pro_Hitman"].SpeedDecay[self:Prof_GetEXP("Pro_Hitman")]
	end
end

--concommand.Add("GiveExp", function(ply, command, args) ply:Prof_GiveEXP(args[1],100) end)

function PMETA:Prof_HasProf(pro,compareprof)
	for _,prfesion in pairs(self.OCRPData["Professions"]) do
		if pro == compareprof then
			return true
		end
	end
	return false
end

function PMETA:Prof_GetEXP(pro)
	return self.OCRPData["Professions"][pro].Exp
end

function PMETA:Prof_Reset()
	for _,pro in pairs(self.OCRPData["Professions"]) do -- Deactivates the rest
		if _ == "Pro_Crafting" then
			pro.Exp.Skill = 0
			pro.Exp.Practical = 0
			pro.Exp.Mechanical = 0
			GAMEMODE.inv_UpdateProf(nil,_,pro.Exp.Skill,pro.Exp.Mechanical,pro.Exp.Practical,self)
		else
			pro.Exp = 0
			GAMEMODE.inv_UpdateProf(nil,_,0,0,0,self)
		end
	end
end

function PMETA:Prof_Deactivate()
	for _,pro in pairs(self.OCRPData["Professions"]) do -- Deactivates the rest
		GAMEMODE.inv_UpdateProf(nil,_,pro.Exp,0,0,self)
	end
end

net.Receive("OCRP_ResetProf", function(len, ply)
	ply:Prof_Reset()
end)
