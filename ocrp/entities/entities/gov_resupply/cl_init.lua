include('shared.lua')
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
end

net.Receive("OCRP_ShowPoliceResupply", function()
    ShowPoliceResupply(net.ReadTable())
end)

POLICELOCKERMENU = nil

function ShowPoliceResupply(policeItems)

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(360, 360)
    frame:SetOCRPTitle("Police Locker")
    frame:Center()
    frame:MakePopup()
    
    POLICELOCKERMENU = frame
    
    surface.SetFont("Trebuchet19")
    local textw,texth = surface.GetTextSize("Police force items.")
    
    local caption = vgui.Create("DPanel", frame)
    caption:SetSize(textw+10,texth+10)
    caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 10)
    
    function caption:Paint(w,h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30,255))
        draw.DrawText("Police force items.", "Trebuchet19", 5, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
    end
    
    local inv = vgui.Create("DPanelList", frame)
    inv:SetSize(360, frame:GetTall()-select(2, caption:GetPos())-caption:GetTall()-10)
    inv:SetPos(0, select(2, caption:GetPos())+caption:GetTall()+10)
    inv:SetPadding(10)
    inv:SetSpacing(10)
    inv:SetNoSizing(true)
    inv:EnableVerticalScrollbar(true)
    inv:EnableHorizontal(true)
    
    local pl = inv.PerformLayout
    
    function inv:PerformLayout()
        pl(self)
        self.VBar:SetTall(self:GetTall()-10)
        self.VBar:SetPos(self:GetWide() - 20, 5)
    end
    
    POLICELOCKERMENU.inv = inv
    
    PopulatePoliceResupplyInv(policeItems)

end

function PopulatePoliceResupplyInv(policeItems)
    
    local dummyEnt = ents.CreateClientProp("prop_physics")
    dummyEnt:SetPos(Vector(0,0,0))
    dummyEnt:Spawn()
    dummyEnt:Activate()
    POLICELOCKERMENU.inv:Clear()
    
    for item,amt in pairs(policeItems) do
        if not amt or amt == 0 then continue end
        local itemPanel = vgui.Create("DPanel")
        itemPanel:SetSize(100, 140)
        
        function itemPanel:Paint(w,h)
            draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0,255))
            draw.DrawText(GAMEMODE.OCRP_Items[item].Name, "UiBold", w/2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
            if amt > 1 then
                draw.DrawText("x" .. amt, "UiBold", w/2, 18, Color(255,255,255,255), TEXT_ALIGN_CENTER)
            end
        end
        
        local itemMdlPanel = vgui.Create("DModelPanel", itemPanel)
        itemMdlPanel:SetSize(80, 80)
        itemMdlPanel:SetPos(5, 30)
        itemMdlPanel:SetModel(GAMEMODE.OCRP_Items[item].Model)
        itemMdlPanel:SetCursor("arrow")
        
        itemMdlPanel.OnCursorEntered = itemPanel.OnCursorEntered
        itemMdlPanel.OnCursorExited = itemPanel.OnCursorExited
        
        -- Make the angles look nice by checking them on the dummy ent
        dummyEnt:SetModel(GAMEMODE.OCRP_Items[item].Model)
        local center = dummyEnt:OBBCenter()
        local dist = dummyEnt:BoundingRadius() * 1.2
        itemMdlPanel:SetLookAt(center)
        itemMdlPanel:SetCamPos(center+Vector(dist, dist, 0))
        
        local withdraw = vgui.Create("OCRP_BaseButton", itemPanel)
        withdraw:SetSize(90, 15)
        withdraw:SetPos(5, 115)
        withdraw:SetText("Withdraw")
        
        function withdraw:DoClick()
            net.Start("OCRP_WithdrawPoliceItem")
            net.WriteString(item)
            net.SendToServer()
        end
        
        POLICELOCKERMENU.inv:AddItem(itemPanel)
    end
    
    while table.Count(POLICELOCKERMENU.inv:GetItems()) < 7 do
        local filler = vgui.Create("DPanel")
        filler:SetSize(100, 140)
        filler.Paint = function() end
        POLICELOCKERMENU.inv:AddItem(filler)
    end
    
    dummyEnt:Remove()
    
end

net.Receive("OCRP_WithdrawPoliceItem", function()
    if POLICELOCKERMENU and POLICELOCKERMENU:IsValid() then
        PopulatePoliceResupplyInv(net.ReadTable())
    end
end)