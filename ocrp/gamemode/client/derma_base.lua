local BASE_MENU = {}

function BASE_MENU:Init()
    self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)
	self:SetSizable(false)
	self.OriginalSetSize = vgui.GetControlTable("DFrame").SetSize
	self.OriginSetPos = vgui.GetControlTable("DFrame").SetPos
	
	self.Outline = vgui.Create("DPanel")
    if self:GetParent() and self:GetParent():IsValid() then
        self.Outline:SetParent(self:GetParent())
    end

	self.Outline.Paint = function()
        draw.RoundedBox(4, 0, 0, self.Outline:GetWide(), self.Outline:GetTall(), Color(0,0,0,255))
	end
    
    self.Outline:SetMouseInputEnabled(false)
    
	self.Close = vgui.Create("DImageButton", self)
	self.Close:SetSize(16,16)
	self.Close:SetImage("gui/ocrp/OCRP_Close_ZG.vtf")
	self.Close.DoClick = function()
		if self:IsValid() then
			self:Remove()
		end
	end
    
end

function BASE_MENU:AllowCloseButton(bool)
	if bool then
		self.Close:Show()
	else
		self.Close:Hide()
	end
end

function BASE_MENU:SetSize(w,h)
	self.Outline:SetSize(w+10,h+10)
	self.Close:SetPos(w-22, 6)
	self.OriginalSetSize(self, w, h)
end

function BASE_MENU:SetPos(x,y)
    if self.Outline and self.Outline:IsValid() then
        self.Outline:SetPos(x-5,y-5)
    end
    if self.Title and self.Title:IsValid() then
        self.Title:SetPos(x,y-self.Title:GetTall())
    end
	self.OriginSetPos(self, x, y)
end

function BASE_MENU:OnRemove()
	if self.Outline and self.Outline:IsValid() then
		self.Outline:Remove()
	end
    if self.Title and self.Title:IsValid() then
        self.Title:Remove()
    end
end

function BASE_MENU:Paint(w,h)
	draw.RoundedBox(4, 0, 0, w, h, Color(20, 20, 20, 255))
end

function BASE_MENU:Center()
    self:SetPos(ScrW()/2-self:GetWide()/2, ScrH()/2-self:GetTall()/2)
end

function BASE_MENU:SetOCRPTitle(title)

    if self.Title and self.Title:IsValid() then self.Title:Remove() end

    surface.SetFont("TargetIDSmall")

    local x,y = self:GetPos()
    local w,h = self:GetSize()
    local tw,th = surface.GetTextSize(title)
    
    local titlebox = vgui.Create("OCRP_BaseMenu")
    titlebox:SetSize(tw + 16, 30)
    titlebox:SetPos(x, y - titlebox:GetTall())
    titlebox:AllowCloseButton(false)
    
    -- Custom paint function so the bottom two corners don't round. Looks better this way
    
    titlebox.Paint = function()
        draw.RoundedBoxEx(4, 0, 0, titlebox:GetWide(), titlebox:GetTall(), Color(20, 20, 20, 255), true, true, false, false)
		draw.SimpleText(title, "TargetIDSmall", 6, draw.GetFontHeight("TargetIDSmall")+6, Color(39,168,216,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        draw.RoundedBox(2, 6, draw.GetFontHeight("TargetIDSmall")+8, tw, 2, Color(39,168,216,255))
    end
    
    titlebox:MakePopup()
    
    self.Title = titlebox

end

vgui.Register("OCRP_BaseMenu", BASE_MENU, "DFrame")

local BASE_BUTTON = {}

function BASE_BUTTON:Init()
	self.Clicking = false
	self:SetTextColor(Color(39,168,216,255))
    self:SetFont("UiBold")
end

function BASE_BUTTON:Paint(w,h)
    if not self.col_override then self.col_override = Color(39,168,216,255) end
	local col = self.Clicking and Color(255,255,255,255) or self.col_override
	draw.RoundedBox(8, 0, 0, w, h, col)
	draw.RoundedBox(8, 1, 1, w-2, h-2, Color(20, 20, 20, 255))
end

function BASE_BUTTON:SetColor(col_override)
    self.col_override = col_override
    self:SetTextColor(col_override or Color(39,168,216,255))
end

function BASE_BUTTON:OnMousePressed(key)
	if key == MOUSE_LEFT then
		self.Clicking = true
		self:SetTextColor(Color(255,255,255,255))
	end
end

function BASE_BUTTON:OnMouseReleased(key)
	if key == MOUSE_LEFT then
		self.Clicking = false
		self:SetTextColor(self.col_override or Color(39,168,216,255))
		self:DoClick()
	end
end

function BASE_BUTTON:OnCursorExited()
    self.Clicking = false
    self:SetTextColor(self.col_override or Color(39,168,216,255))
end

vgui.Register("OCRP_BaseButton", BASE_BUTTON, "DButton")

function FocusModelPanel(mdlpnl)
    local mn, mx = mdlpnl.Entity:GetRenderBounds()
    local size = 0
    size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
    size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
    size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

    mdlpnl:SetFOV( 45 )
    mdlpnl:SetCamPos( Vector( size, size, size ) )
    mdlpnl:SetLookAt( (mn + mx) * 0.5 )
    
    -- Add some exceptions...
    
    if mdlpnl.Entity:GetModel() == "models/weapons/w_beerbot.mdl" then
        mdlpnl:SetFOV(20)
    end
    
    if mdlpnl.Entity:GetModel() == "models/kevlarvest/kevlarvest.mdl" then
        mdlpnl:SetFOV(10)
    end
    
end