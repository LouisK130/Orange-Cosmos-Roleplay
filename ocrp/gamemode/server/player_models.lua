util.AddNetworkString("OCRP_InitialFaceChoice")
util.AddNetworkString("OCRP_ChangeOutfit")
util.AddNetworkString("OCRP_BuyOutfit")
util.AddNetworkString("OCRP_ShowWardrobe")
util.AddNetworkString("OCRP_UpdateWardrobe")
util.AddNetworkString("OCRP_ShowModel")

concommand.Add("OCRP_Model", function(ply, cmd, args)
	if ply:NearNPC("KFC") then
		net.Start("OCRP_ShowModel")
		net.Send(ply)
	end
end)

net.Receive("OCRP_InitialFaceChoice", function(len, ply)
	local face = string.lower(net.ReadString())
	if not face or face == "" then return end
	ply.OCRPData["Face"] = face
	local key = ply:FindKey()
	if string.find(face, "female") then
		ply.OCRPData["Model"] = GAMEMODE.OCRP_Models["Females"][key].Regular
		ply:SetModel(GAMEMODE.OCRP_Models["Females"][key].Regular)
	else
		ply.OCRPData["Model"] = GAMEMODE.OCRP_Models["Males"][key].Regular
		ply:SetModel(GAMEMODE.OCRP_Models["Males"][key].Regular)
	end
	
    LoadingSuccess(ply)
    
    net.Start("OCRP_AskRef")
    net.Send(ply)
end)

net.Receive("OCRP_ChangeOutfit", function(len, ply)
	local face = ply.OCRPData["Face"]
	local gender = ply:GetGender()
	local clothesint = net.ReadInt(32)
	if not face or not clothesint or not gender then return end
	if ply:OwnsClothes(clothesint) then
		local mdl = GAMEMODE.OCRP_Models[gender .. "s"][ply:FindKey()][ClothesNumberToName(clothesint, gender, ply:FindKey())]
		ply.OCRPData["Model"] = mdl
		ply:SetModel(mdl)
        ply:Hint("You're now wearing your " .. string.gsub(ClothesNumberToName(clothesint, gender, ply:FindKey()), "_", " ") .. " outfit.")
	end
end)

net.Receive("OCRP_BuyOutfit", function(len, ply)
	local face = ply.OCRPData["Face"]
	local gender = ply:GetGender()
    local buyingString = net.ReadString()
    if buyingString == "Formal" and ply:GetLevel() > 3 then return end
	local buying = ClothesNameToNumber(buyingString, gender, ply:FindKey())
	if not face or not buying or not gender then return end
	if ply:OwnsClothes(buying) then
		ply:Hint("You already own those clothes!")
		return
	end
	if ply:GetMoney("Wallet") < 5000 then
		ply:Hint("You don't have enough money for this!")
		return
	end
	ply:TakeMoney("Wallet",5000)
	table.insert(ply.OCRPData["Wardrobe"], buying)
	ply:Hint("You've bought new clothes, visit a wardrobe to put them on!")
	ply:SendWardrobeUpdate()
end)

function PMETA:GetGender()
	if string.find(self.OCRPData["Face"], "female") then
		return "Female"
	else
        return "Male"
	end
end

function PMETA:SendWardrobeUpdate()
	if not table.HasValue(self.OCRPData["Wardrobe"], 1) then -- Everyone owns 1
		table.insert(self.OCRPData["Wardrobe"], 1)
	end
	net.Start("OCRP_UpdateWardrobe")
	net.WriteInt(self:FindKey(), 32)
	net.WriteString(self:GetGender())
	net.WriteInt(table.HasValue(self.OCRPData["Wardrobe"], 1) and 1 or 0, 2)
	net.WriteInt(table.HasValue(self.OCRPData["Wardrobe"], 2) and 1 or 0, 2)
	net.WriteInt(table.HasValue(self.OCRPData["Wardrobe"], 3) and 1 or 0, 2)
	net.WriteInt(table.HasValue(self.OCRPData["Wardrobe"], 4) and 1 or 0, 2)
	net.WriteInt(table.HasValue(self.OCRPData["Wardrobe"], 5) and 1 or 0, 2)
	net.WriteInt(table.HasValue(self.OCRPData["Wardrobe"], 6) and 1 or 0, 2)
	net.Send(self)
end
	
function PMETA:OwnsClothes(clothes)
	local wardrobe = self.OCRPData["Wardrobe"]
	if table.HasValue(wardrobe, clothes) then
		return true
	end
	return false
end

function ClothesNumberToName(clothes, gender, key)
	for k,v in pairs(GAMEMODE.OCRP_Models[gender .. "s"][key]) do
		if (clothes == 1 and string.find(v, "clothes1"))
		or (clothes == 2 and string.find(v, "clothes2"))
		or (clothes == 3 and string.find(v, "clothes3"))
		or (clothes == 4 and string.find(v, "clothes4"))
		or (clothes == 5 and string.find(v, "clothes5"))
		or (clothes == 6 and string.find(v, "clothes6")) then
			return k
		end
	end
end

function ClothesNameToNumber(clothes, gender, key)
	for k,v in pairs(GAMEMODE.OCRP_Models[gender .. "s"][key]) do
		if string.lower(k) == string.lower(clothes) then
			return FindClothes(v)
		end
	end
end

function FindClothes( mdl ) -- Clothes number
	if string.find(mdl, "clothes1") then
		return 1
	elseif string.find(mdl, "clothes2") then
		return 2
	elseif string.find(mdl, "clothes3") then
		return 3
	elseif string.find(mdl, "clothes4") then
		return 4
	elseif string.find(mdl, "clothes5") then
		return 5
	elseif string.find(mdl, "clothes6") then
		return 6
	end
end
	
function PMETA:FindKey() -- Face number
	local mdl = self.OCRPData["Face"]
    if not mdl then return 0 end
	local key = 0
	if string.find(mdl, "1") then
		key = 1
	elseif string.find(mdl, "2") then
		key = 2
	elseif string.find(mdl, "3") then
		key = 3
	elseif string.find(mdl, "4") then
		key = 4
	elseif string.find(mdl, "5") then
		key = 5
	elseif string.find(mdl, "6") then
		key = 6
	elseif string.find(mdl, "7") then
		key = 7
	elseif string.find(mdl, "8") then
		key = 8
	elseif string.find(mdl, "9") then
		key = 9
	end
	return key
end

function PMETA:SetJobModel()
	local t = self:Team()
	local mdl = string.lower(self:GetGender()) .. "_0" .. tostring(self:FindKey()) .. ".mdl"
	local path = "models/ocrp2players/"
	if t == CLASS_POLICE then
		path = path .. "police/l1/"
    elseif t == CLASS_CHIEF then
        path = path .. "police/l5/"
	elseif t == CLASS_Mayor then
		path = path .. "mayor/10/"
	elseif t == CLASS_FIREMAN then
		path = path .. "firefighter/10/"
	elseif t == CLASS_Tow then
		path = path .. "towtruck/10/"
	elseif t == CLASS_SWAT then
		path = path .. "swat/10/"
	elseif t == CLASS_MEDIC then
		path = path .. "paramedic/10/"
	end
	if t != CLASS_TAXI then
		self:SetModel(path .. mdl)
	end
end