OCRP_MaxSkillPoints = 20
function CL_UpdateSkill( umsg )
	local skill = umsg:ReadString()
	local level = umsg:ReadLong()
	OCRP_Skills[skill] = level
    
    if OCRP_MAINMENU and OCRP_MAINMENU:IsValid() and OCRP_MAINMENU.tab == "Skills" then
        local scroll = 0
        for k,v in pairs(OCRP_MAINMENU.CurrentChildren or {}) do
            if v.VBar and v.VBar:IsValid() then
                scroll = v.VBar.Scroll
            end
        end
        ChooseSkillsTab(OCRP_MAINMENU, scroll)
    end

end
usermessage.Hook('OCRP_UpdateSkill', CL_UpdateSkill);

function CL_HasSkill(skill,level)
	if level == nil then level = 1 end
	if OCRP_Skills[skill] != nil then
		if OCRP_Skills[skill] >= level then
			return true
		end
	end
	return false
end

function CL_GetSkillPoints()
    local spent = 0
    for k,v in pairs(OCRP_Skills) do
        spent = spent + v
    end
    return spent
end
