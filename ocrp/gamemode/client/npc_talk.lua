--TODO
local draw = draw
local vgui = vgui
local CurOption = 1

function CL_CreateChat(string1, bool, mdl)
	if bool then
		GUI_ShopMenu(string1, mdl)
	else
		GUI_JobMenu(string1, mdl)
	end
end
net.Receive("OCRP_CreateChat", function(len)
	CL_CreateChat(net.ReadString(), tobool(net.ReadInt(2)), net.ReadString())
end)

function GUI_JobMenu(JobId, mdl)

	CurOption = 1
    
    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(590, 200)
    frame:Center()
    frame:AllowCloseButton(true)
    frame:MakePopup()
    
    -- Put a black box behind the face
    local FaceBackground = vgui.Create("DPanel", frame)
    FaceBackground:SetSize(185, 185)
    FaceBackground:SetPos(9, 9)
    
    function FaceBackground:Paint(w,h)
        draw.RoundedBox(8, 9, 9, 173, 173, Color(39,168,216,255))
        draw.RoundedBox(8, 10, 10, 171, 171, Color(25,25,25,255))
    end
    
    local FacePanel = vgui.Create("DModelPanel", frame)
    FacePanel:SetSize(180, 180)
    FacePanel:SetPos(10, 10)
    FacePanel:SetModel(mdl)
    FacePanel:SetCamPos(Vector(25, 0, 58))
    FacePanel:SetLookAt(Vector(0,0,58))
    FacePanel:SetFOV(90)
    
    function FacePanel:LayoutEntity(ent)
        self:SetCamPos(Vector(25, 0, 58))
        self:SetLookAt(Vector(0,0,58))
    end
    
    function FacePanel:Think()
        if self:IsHovered() then
            self:SetCursor("arrow")
        end
    end
	
	if GAMEMODE.OCRP_Dialogue[JobId].Condition != nil then
        local conditionValue = GAMEMODE.OCRP_Dialogue[JobId].Condition(LocalPlayer())
		if conditionValue == true then
			if GAMEMODE.OCRP_Dialogue[JobId].Function != nil then
                local functionValue = GAMEMODE.OCRP_Dialogue[JobId].Function(LocalPlayer())
				if functionValue == "Exit" then
					GUI_Job_Frame:Remove()
					return
				end
                CurOption = functionValue
			end
		elseif conditionValue != true && conditionValue != false then
			CurOption = conditionValue
		elseif conditionValue == "Exit" then
			GUI_Job_Frame:Remove()
			return
		end
	end
	
	GUI_Rebuild_Dialogue(frame,JobId)
	
end

function GUI_Rebuild_Dialogue(parent,JobId)
	if GUI_Dialogue_Panel_List != nil && GUI_Dialogue_Panel_List:IsValid() then
		GUI_Dialogue_Panel_List:Remove()
    end
    
	local GUI_Label_Say = vgui.Create("DLabel", parent)
	GUI_Label_Say:SetColor(Color(255,255,255,255))
	GUI_Label_Say:SetFont("UiBold")
					
	surface.SetFont("UiBold")
    local text = GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Question
    if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].FormatRepairPrice == true then
        for k,v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
            if v:GetNWInt("Owner") > 0 and v:GetNWInt("Owner") == LocalPlayer():EntIndex() then
                if v:GetNWBool("IsGovCar") == true then text = "Ok, that'll be on the house, thank the mayor!" break end
                local cartable = GAMEMODE.OCRP_Cars[v:GetNWString("Type")]
                local cost = cartable.RepairCost * (cartable.Health - v:Health())/cartable.Health
                text = string.format(GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Question, tostring(cost))
            end
        end
    end
	local x,y = surface.GetTextSize(text)
    GUI_Label_Say:SetText(text)
	GUI_Label_Say:SizeToContents()
	GUI_Label_Say:SetPos(390 - x/2,50-y/2)
    
    local Button1 = vgui.Create("OCRP_BaseButton", parent)
    Button1:SetPos(203, 88)
    Button1:SetSize(375, 45)
    Button1:SetText(GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].YesAnswer)
    
    function Button1:DoClick()
		if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition != nil then
            local conditionValue = GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition(LocalPlayer())
			if conditionValue == true then
				if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Function != nil then
                    local functionValue = GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Function(LocalPlayer())
					if functionValue == "Exit" then
						parent:Remove()
						return
					end
					CurOption = functionValue
				end
			elseif conditionValue != true && conditionValue != false then
				CurOption = conditionValue
			elseif conditionValue == "Exit" then
				parent:Remove()
				return
			end
		end
        GUI_Label_Say:Remove()
        GUI_Rebuild_Dialogue(parent,JobId)
    end
    
    local Button2 = vgui.Create("OCRP_BaseButton", parent)
    Button2:SetPos(203, 144)
    Button2:SetSize(375, 45)
    Button2:SetText(GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].NoAnswer)
    
    function Button2:DoClick()
        if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].SecondYes then
            if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition != nil then
                local conditionValue = GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Condition(LocalPlayer())
                if conditionValue == true then
                    if GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Function2 != nil then
                        local functionValue = GAMEMODE.OCRP_Dialogue[JobId].Dialogue[CurOption].Function2(LocalPlayer())
                        if functionValue == "Exit" then
                            parent:Remove()
                            return
                        end
                        CurOption = functionValue
                    end
                elseif conditionValue != true && conditionValue != false then
                    CurOption = conditionValue
                elseif conditionValue == "Exit" then
                    parent:Remove()
                    return
                end
            end
            GUI_Label_Say:Remove()
            GUI_Rebuild_Dialogue(parent,JobId)
        else
            parent:Remove()
        end
    end
end