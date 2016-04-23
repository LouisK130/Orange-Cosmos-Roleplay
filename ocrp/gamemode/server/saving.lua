util.AddNetworkString("OCRP_UpdateInventory")
util.AddNetworkString("OCRP_UpdateSkills")

function PMETA:UnCompileString( t, to_uncompile_string )
	local ExplodedStr = string.Explode( ";", to_uncompile_string )
	if t == "inv" then
		for k, v in pairs(ExplodedStr) do
			local ExplodedSecond = string.Explode( ".", v )
			if GAMEMODE.OCRP_Items[ExplodedSecond[1]] != nil then
				if tonumber(ExplodedSecond[2]) >= 1 then
					if ExplodedSecond[1] != "item_ammo_cop" then
						self:GiveItem(ExplodedSecond[1],tonumber(ExplodedSecond[2]),"LOAD")
					end
				end
			end
		end
        net.Start("OCRP_UpdateInventory")
        net.WriteTable(self.OCRPData["Inventory"])
        net.Send(self)
    elseif t == "itembank" then
		for k, v in pairs(ExplodedStr) do
			local ExplodedSecond = string.Explode( ".", v )
			if GAMEMODE.OCRP_Items[ExplodedSecond[1]] != nil then
				if tonumber(ExplodedSecond[2]) >= 1 then
                    self.OCRPData["ItemBank"].WeightData.Cur = self.OCRPData["ItemBank"].WeightData.Cur + GAMEMODE.OCRP_Items[ExplodedSecond[1]].Weight
                    self.OCRPData["ItemBank"][ExplodedSecond[1]] = tonumber(ExplodedSecond[2])
				end
			end
		end
	elseif t == "car" then
		for k, v in pairs(ExplodedStr) do
			local ExplodedSecond = string.Explode( ".", v )
			if GAMEMODE.OCRP_Cars[ExplodedSecond[1]] != nil then
				if !ExplodedSecond[3] then
					ExplodedSecond[3] = false
				end
				table.insert(self.OCRPData["Cars"], {car = ExplodedSecond[1], skin = tonumber(ExplodedSecond[2]), hydros = ExplodedSecond[3], underglow = ExplodedSecond[4], Nitrous = ExplodedSecond[5], headlights = ExplodedSecond[6]})
				if ExplodedSecond[7] ~= "nil" then
					self.GasSave[ExplodedSecond[1]] = tonumber(ExplodedSecond[7])
                    self:SetNWInt("Gas_" .. ExplodedSecond[1], tonumber(ExplodedSecond[7]))
				end
				if ExplodedSecond[8] ~= "nil" then
					self.HealthSave[ExplodedSecond[1]] = tonumber(ExplodedSecond[8])
                    self:SetNWInt("Health_" .. ExplodedSecond[1], tonumber(ExplodedSecond[8]))
				end
			end
		end
		SendCarsClient( self )
	elseif t == "skill" then
		for k, v in pairs(ExplodedStr) do
			local ExplodedSecond = string.Explode( ".", v )
			if GAMEMODE.OCRP_Skills[ExplodedSecond[1]] != nil then
				self.OCRPData["Skills"][ExplodedSecond[1]] = tonumber(ExplodedSecond[2])
				if GAMEMODE.OCRP_Skills[ExplodedSecond[1]].Function then
					GAMEMODE.OCRP_Skills[ExplodedSecond[1]].Function( self, ExplodedSecond[1] )
				end
			end
		end
        self:UpdateAllSkills()
	elseif t == "wardrobe" then
		for k, v in pairs(ExplodedStr) do
			if v == "" then continue end
			if table.HasValue(self.OCRPData["Wardrobe"], v) then continue end
			table.insert(self.OCRPData["Wardrobe"], tonumber(v))
		end
		self:SendWardrobeUpdate()
	elseif t == "storage" then
        local given = false
        local held = false
        local restored = {}
		for k, v in pairs(ExplodedStr) do
			local ExplodedSecond = string.Explode( ".", v )
			if ExplodedSecond and ExplodedSecond[1] then
				if GAMEMODE.OCRP_Items[ExplodedSecond[1]] != nil then
					if tonumber(ExplodedSecond[2]) >= 1 then
                        local i = 1
                        while i <= tonumber(ExplodedSecond[2]) do
                            if self:HasRoom(ExplodedSecond[1], 1) and not self:ExceedsMax(ExplodedSecond[1], 1) then
                                given = true
                                self:UnStoreItem(ExplodedSecond[1], 1)
                                self:GiveItem(ExplodedSecond[1],1,"LOAD")
                                restored[ExplodedSecond[1]] = (restored[ExplodedSecond[1]] or 0) + 1
                            else
                                held = true
                                self:StoreItem(ExplodedSecond[1], 1)
                            end
                            i = i + 1
                        end
					end
				end
			end
		end
        for k,v in pairs(restored) do
            SV_PrintToAdmin(self, "RESTORE-ITEM", "was given back " .. tostring(v) .. " of " .. k .. " from last disconnect.")
        end
        if given == true then
            self:Hint("You have been given back some dropped items you left when you last disconnected.")
        end
        if held == true then
            self:Hint("Some items were not given back to you because you do not have enough room or they exceed your max for that item!")
            self:Hint("Make room and reconnect to get your items back.")
        end
        net.Start("OCRP_UpdateInventory")
        net.WriteTable(self.OCRPData["Inventory"])
        net.Send(self)
		--runOCRPQuery("UPDATE `ocrp_users` SET `storage` = 'None' WHERE `STEAM_ID` = '".. self:SteamID() .."'")
    elseif t == "blacklist" then
        self.OCRPData["Blacklists"] = {}
        for k,v in pairs(ExplodedStr) do
            self.OCRPData["Blacklists"][k] = true
        end
    elseif t == "buddies" then
        self.OCRPData["Buddies"] = self.OCRPData["Buddies"] or {}
        for k,v in pairs(ExplodedStr) do
            table.insert(self.OCRPData["Buddies"], v)
        end
        net.Start("OCRP_UpdateBuddies")
            net.WriteTable(self.OCRPData["Buddies"])
        net.Send(self)
	end
end

function PMETA:CompileString( t )
	local Compiled = ""
	if t == "inv" then
		for item, amt in pairs(self.OCRPData["Inventory"]) do
			if item != "WeightData" && !GAMEMODE.OCRP_Items[item].DoesntSave then
				Compiled = Compiled ..item.."."..tostring(amt)..";"
			end
		end
    elseif t == "itembank" then
		for item, amt in pairs(self.OCRPData["ItemBank"]) do
			if item != "WeightData" && !GAMEMODE.OCRP_Items[item].DoesntSave then
				Compiled = Compiled ..item.."."..tostring(amt)..";"
			end
		end
	elseif t == "car" then
		for _, d in pairs(self.OCRPData["Cars"]) do
            d.underglow = d.underglow or "none"
            d.Nitrous = d.Nitrous or false
			d.headlights = d.headlights or "none"
			Compiled = Compiled ..d.car.."."..tostring(d.skin).."."..tostring(d.hydros).."." .. tostring(d.underglow) .. "." .. tostring(d.Nitrous) .. "." ..
				tostring(d.headlights) .. "." .. tostring(self.GasSave[d.car]) .. "." .. tostring(self.HealthSave[d.car]) .. ";"
		end
	elseif t == "skill" then
		for skill, level in pairs(self.OCRPData["Skills"]) do
			Compiled = Compiled ..skill.."."..tostring(level)..";"
		end
	elseif t == "wardrobe" then
		local added = {}
		for _, d in pairs(self.OCRPData["Wardrobe"]) do
			if d == "" then continue end
			if table.HasValue(added, d) then continue end
			Compiled = Compiled .. d .. ";"
			table.insert(added, d)
		end
	elseif t == "storage" then
		for item, amt in pairs(self.OCRPData["Storage"] or {}) do
			if !GAMEMODE.OCRP_Items[item].DoesntSave then
				Compiled = Compiled ..item.."."..tostring(amt)..";"
			end
		end
    elseif t == "blacklist" then
        if self.OCRPData["Blacklists"] then
            for k,v in pairs(self.OCRPData["Blacklists"]) do
                if v == true then
                    if tonumber(k) > 1 then
                        Compiled = Compiled .. k .. ";"
                    end
                end
            end
        end
    elseif t == "warnings" then
        for _,warning in pairs(self.OCRPData["Warnings"]) do
            Compiled = Compiled ..warning.admin.."."..warning.reason.."." .. warning.Date .. ";"
        end
    elseif t == "buddies" then
        for _,buddy in pairs(self.OCRPData["Buddies"]) do
            if type(buddy) == "string" and string.len(buddy) > 0 then
                Compiled = Compiled .. buddy .. ";"
            end
        end
	end
	return Compiled
end