net.Receive("OCRP_ShowFineCreation", function()
	ShowFineCreation(Entity(net.ReadInt(32)))
end)

net.Receive("OCRP_SendFine", function()
	ShowFine(net.ReadInt(32), net.ReadString(), Entity(net.ReadInt(32)))
end)

function ShowFineCreation(victim)

	--
	-- Setup some initial values, clicking is for button color
	--
	
	local text = "Fining PLAYER_NAME"
	if victim and victim:IsValid() then
		text = "Fining " .. victim:Nick()
	end
	local clicking = false
	
	--
	-- Build the default OCRP menu frame
	--
	
	local frame = vgui.Create("OCRP_BaseMenu")
	frame:SetSize(300, 175)
	frame:SetPos(ScrW()/2-frame:GetWide()/2, ScrH()/2-frame:GetTall()/2)
	frame.OriginalPaint = frame.Paint
	
	-- Override the paint method but include the old one as well
	-- This way we can draw on the existing panel to add the green outlines etc
	
	function frame:Paint(w,h)
		self.OriginalPaint(self, w, h)
		draw.SimpleText(text, "TargetIDSmall", 6, draw.GetFontHeight("TargetIDSmall")+6, Color(39,168,216,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		draw.RoundedBox(8, 59, 49, 232, 27, Color(39,168,216,255))
		local col = clicking and Color(255,255,255,255) or Color(39,168,216,255)
		draw.RoundedBox(8, frame:GetWide()/3-1, frame:GetTall()-40-1, 102, 32, col)
	end
	
	--
	-- We create the reason box for fining
	--
	
	local reason = vgui.Create("DTextEntry", frame)
	reason:SetSize(230, 25)
	reason:SetPos(60, 50)
	reason:SetPaintBorderEnabled(true)
	function reason:Paint(w,h)
		draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0,255))
		self:DrawTextEntryText(Color(255,255,255,255), Color(100,100,100,255), Color(255,255,255,255))
	end
	
	--
	-- We create a label
	--
	
	local rlabel = vgui.Create("DLabel", frame)
	rlabel:SetText("Reason")
	rlabel:SetFont("Default")
	rlabel:SizeToContents()
	rlabel:SetTextColor(Color(39,168,216,255))
	rlabel:SetPos(30-rlabel:GetWide()/2, 50+reason:GetTall()/2-rlabel:GetTall()/2)
	
	--
	-- The amount slider
	--
	
	local amount = vgui.Create("Slider", frame)
	amount:SetSize(260, 25)
	amount:SetPos(58, 90)
	amount:SetMin(0)
	amount:SetMax(500)
	amount:SetDecimals(0)
	amount:SetValue(0)
	amount.TextArea:SetTextColor(Color(39,168,216,255))
	amount.TextArea:SetEditable(false)
	
	--
	-- Amount label
	--
	
	local alabel = vgui.Create("DLabel", frame)
	alabel:SetText("Amount")
	alabel:SetFont("Default")
	alabel:SizeToContents()
	alabel:SetTextColor(Color(39,168,216,255))
	alabel:SetPos(30-alabel:GetWide()/2, 90+amount:GetTall()/2-alabel:GetTall()/2)
	
	--
	-- Confirm button to send the fine
	--
	
	local confirm = vgui.Create("OCRP_BaseButton", frame)
	confirm:SetText("Confirm Fine")
	confirm:SetSize(100, 30)
	confirm:SetPos(frame:GetWide()/3, frame:GetTall()-40)
	
	-- Send fine when clicked
	
	confirm.DoClick = function()
		if amount:GetValue() <= 0 then
			OCRP_AddHint("You must enter a fine amount greater than $0!")
			return
		end
		if reason:GetValue() == "" then
			OCRP_AddHint("You must enter a valid reason!")
			return
		end
		if string.len(reason:GetValue()) > 50 then
			OCRP_AddHint("Your reason must be less than 50 characters.")
			return
		end
		net.Start("OCRP_SendFine")
		net.WriteInt(amount:GetValue(), 32)
		net.WriteString(reason:GetValue())
		net.WriteInt(victim:EntIndex(), 32)
		net.SendToServer()
		OCRP_AddHint("Fine submitted.")
		frame:Remove()
	end
	
	-- Force it to popup and allow mouse / keyboard input
	
	frame:MakePopup()
end

function ShowFine(amt, reason, finer)
	
	local frame = vgui.Create("OCRP_BaseMenu")
	frame:SetSize(300, 175)
	frame:SetPos(ScrW()/2-frame:GetWide()/2, ScrH()/2-frame:GetTall()/2)
	frame.OriginalPaint = frame.Paint
	function frame:Paint(w,h)
		self.OriginalPaint(self, w, h)
		draw.SimpleText("You have been fined!", "TargetIDSmall", 6, draw.GetFontHeight("TargetIDSmall")+6, Color(39,168,216,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	end
	frame.OriginalClose = frame.Close.DoClick
	function frame.Close:DoClick()
		net.Start("OCRP_RefuseFine")
		net.WriteInt(finer:EntIndex(), 32)
		net.SendToServer()
		frame.OriginalClose(self)
	end
	
	local text = vgui.Create("DLabel", frame)
	text:SetText("You have been fined $" .. tostring(amt) .. " for:")
	text:SetTextColor(Color(39,168,216,255))
	text:SetFont("Default")
	text:SizeToContents()
	text:SetPos(frame:GetWide()/2-text:GetWide()/2, frame:GetTall()/2-text:GetTall()/2-20)
	
	local rtext = vgui.Create("DLabel", frame)
	rtext:SetText(reason)
	rtext:SetTextColor(Color(39,168,216,255))
	rtext:SetFont("Default")
	rtext:SizeToContents()
	rtext:SetPos(frame:GetWide()/2-rtext:GetWide()/2, frame:GetTall()/2-rtext:GetTall()/2+10)
	
	local pay = vgui.Create("OCRP_BaseButton", frame)
	pay:SetText("Pay Fine")
	pay:SetSize(100, 30)
	pay:SetPos(33, frame:GetTall()-40)
	
	function pay:DoClick()
		net.Start("OCRP_PayFine")
		net.WriteInt(amt, 32)
		net.WriteInt(finer:EntIndex(), 32)
		net.SendToServer()
		frame:Remove()
	end
	
	local refuse = vgui.Create("OCRP_BaseButton", frame)
	refuse:SetText("Refuse Fine")
	refuse:SetSize(100, 30)
	refuse:SetPos(166, frame:GetTall()-40)
	
	function refuse:DoClick()
		net.Start("OCRP_RefuseFine")
		net.WriteInt(finer:EntIndex(), 32)
		net.SendToServer()
		frame:Remove()
	end
	
	frame:MakePopup()
end
local close_id = surface.GetTextureID("gui/ocrp/OCRP_Close_ZG.vtf")
local marker_font = surface.CreateFont("Marker", {
	font = "Permanent Marker",
	size = 30,
})
function ShowParkingTicket(timestamp, price, ticketer, issuedto, offense1string, offense2string)
	local ticket = vgui.Create("DImage")
	ticket:SetSize(500,500)
	ticket:Center()
	ticket:SetImage("parking_ticket.png")
	--[[local pFunction = vgui.GetControlTable("DImage").Paint
	if string.len(offense) > 75 then
		offense = string.sub(offense, 1, 75)
	end
	local parsedReason = markup.Parse("<font=Marker><colour=255,0,0,255>" .. offense .. "</colour></font>", 449)
	while parsedReason:GetHeight() > 60 do
		offense = string.sub(offense, 1, string.len(offense)-1)
		parsedReason = markup.Parse("<font=Marker><colour=255,0,0,255>" .. offense .. "</colour></font>", 449)
	end
	function ticket:Paint(w,h)
		pFunction(self, w, h)
		parsedReason:Draw(26, 413, ALIGN_TEXT_CENTER, ALIGN_TEXT_CENTER)
	end]]
    
    local offense1 = vgui.Create("DLabel", ticket)
	offense1:SetPos(26, 413)
	offense1:SetSize(473-offense1:GetPos(), 25)
	offense1:SetTextColor(Color(255,0,0,255))
	offense1:SetFont("Marker")
    offense1:SetText(offense1string)
	
	local offense2 = vgui.Create("DLabel", ticket)
	offense2:SetPos(26, 449)
	offense2:SetSize(offense1:GetWide(), 25)
	offense2:SetTextColor(Color(255,0,0,255))
	offense2:SetFont("Marker")
    offense2:SetText(offense2string)
	
	local datetime = vgui.Create("DLabel", ticket)
	datetime:SetPos(26, 190)
	datetime:SetText(timestamp)
	datetime:SetTextColor(Color(255,0,0,255))
	datetime:SetFont("Marker")
	datetime:SizeToContents()
	datetime:SetSize(datetime:GetWide()+4,datetime:GetTall())
	
	local cost = vgui.Create("DLabel", ticket)
	cost:SetPos(273, 190)
	cost:SetText("$ " .. tostring(price))
	cost:SetTextColor(Color(255,0,0,255))
	cost:SetFont("Marker")
	cost:SizeToContents()
	cost:SetSize(cost:GetWide()+4, cost:GetTall())
	
	local issuer = vgui.Create("DLabel", ticket)
	issuer:SetPos(26, 295)
	issuer:SetText(ticketer:IsValid() and ticketer:Nick() or "Disconnected")
	issuer:SetTextColor(Color(255,0,0,255))
	issuer:SetFont("Marker")
	issuer:SizeToContents()
	issuer:SetSize(issuer:GetWide()+4, issuer:GetTall())
	
	local to = vgui.Create("DLabel", ticket)
	to:SetPos(273, 295)
	to:SetText(issuedto:IsValid() and issuedto:Nick() or "N/A")
	to:SetTextColor(Color(255,0,0,255))
	to:SetFont("Marker")
	to:SizeToContents()
	to:SetSize(to:GetWide()+4, to:GetTall())
    
    local controls = vgui.Create("OCRP_BaseMenu")
	controls:SetSize(200, 50)
	controls:SetPos(ticket:GetPos()+ticket:GetWide()/2-50, select(2, ticket:GetPos())+ticket:GetTall()+26)
	controls:AllowCloseButton(false)
	controls:MakePopup()
	
	local pay = vgui.Create("OCRP_BaseButton", controls)
	pay:SetSize(90, 40)
	pay:SetPos(5, 5)
	pay:SetText("Pay Ticket")
	function pay:DoClick()
        net.Start("OCRP_PayTicket")
        net.WriteInt(issuedto:EntIndex(), 32)
        net.SendToServer()
		ticket:Remove()
	end
    
	local refuse = vgui.Create("OCRP_BaseButton", controls)
	refuse:SetSize(90, 40)
	refuse:SetPos(100, 5)
	refuse:SetText("Refuse Ticket")
	function refuse:DoClick()
		ticket:Remove()
	end
    
	function ticket:OnRemove()
		if controls and controls:IsValid() then
			controls:Remove()
		end
	end
	
	ticket:MakePopup()
end

function ShowParkingTicketCreation(issuedto)
	local ticket = vgui.Create("DFrame")
	ticket:SetSize(500,500)
	ticket:Center()
	ticket:ShowCloseButton(false)
	ticket:SetTitle("")
	ticket:SetDraggable(false)
	local ticketmat = Material("parking_ticket.png")
	function ticket:Paint(w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(ticketmat)
		surface.DrawTexturedRect(0,0,w,h)
	end
	
	local close = vgui.Create("DImageButton", ticket)
	close:SetSize(16,16)
	close:SetPos(500-22, 6)
	close.DoClick = function()
		if ticket:IsValid() then
            net.Start("OCRP_CancelTicket")
                net.WriteInt(issuedto:EntIndex(), 32)
            net.SendToServer()
			ticket:Remove()
		end
	end
	function close:Paint(w,h)
		surface.SetDrawColor(Color(0,0,0,255))
		surface.SetTexture(close_id)
		surface.DrawTexturedRect(0,0,w,h)
	end
	
	local datetime = vgui.Create("DLabel", ticket)
	datetime:SetPos(26, 190)
	datetime:SetText(os.date("%m/%d/%y %I:%M %p", os.time()))
	datetime:SetTextColor(Color(255,0,0,255))
	datetime:SetFont("Marker")
	datetime:SizeToContents()
	datetime:SetSize(datetime:GetWide()+4,datetime:GetTall())
	
	local sign = vgui.Create("DLabel", ticket)
	sign:SetPos(273, 190)
	sign:SetText("$")
	sign:SetTextColor(Color(255,0,0,255))
	sign:SetFont("Marker")
	sign:SizeToContents()
	
	local cost = vgui.Create("DNumberWang", ticket)
	cost:SetPos(273 + sign:GetSize()+1, 189)
	cost:SetSize(75, sign:GetTall())
	cost:SetMinMax(1, 500)
	cost:GetTextArea():SetFont("Marker")
	cost:GetTextArea():SetTextColor(Color(255,0,0,255))
	cost:HideWang()
	cost:SetValue(100)
	
	function cost:OnValueChanged(val)
		if tonumber(val) > 500 then
			timer.Simple(.5, function()
				self:SetValue(500)
			end)
		end
		if tonumber(val) <= 0 then
			timer.Simple(.5, function()
				self:SetValue(1)
			end)
		end
	end
	
	local issuer = vgui.Create("DLabel", ticket)
	issuer:SetPos(26, 295)
	issuer:SetText(LocalPlayer():Nick())
	issuer:SetTextColor(Color(255,0,0,255))
	issuer:SetFont("Marker")
	issuer:SizeToContents()
	issuer:SetSize(issuer:GetWide()+4, issuer:GetTall())
	
	local to = vgui.Create("DLabel", ticket)
	to:SetPos(273, 295)
	to:SetText(issuedto:IsValid() and issuedto:Nick() or "N/A")
	to:SetTextColor(Color(255,0,0,255))
	to:SetFont("Marker")
	to:SizeToContents()
	to:SetSize(to:GetWide()+4, to:GetTall())
	
	local offense1 = vgui.Create("DTextEntry", ticket)
	offense1:SetPos(26, 413)
	offense1:SetSize(473-offense1:GetPos(), 25)
	offense1:SetTextColor(Color(255,0,0,255))
	offense1:SetFont("Marker")
	
	local offense2 = vgui.Create("DTextEntry", ticket)
	offense2:SetPos(26, 449)
	offense2:SetSize(offense1:GetWide(), 25)
	offense2:SetTextColor(Color(255,0,0,255))
	offense2:SetFont("Marker")
	
	function offense1:OnChange()
		surface.SetFont("Marker")
		if surface.GetTextSize(offense1:GetValue()) >= offense1:GetWide()-5 then
			offense1:SetText(string.sub(offense1:GetText(), 1, string.len(offense1:GetText())-1))
			offense1:SetCaretPos(offense1:GetText():len())
		end
	end
	
	function offense2:OnChange()
		surface.SetFont("Marker")
		if surface.GetTextSize(offense2:GetValue()) >= offense2:GetWide()-5 then
			offense2:SetText(string.sub(offense2:GetValue(), 1, string.len(offense2:GetValue())-1))
			offense2:SetCaretPos(offense2:GetText():len())
		end
	end
		
	local controls = vgui.Create("OCRP_BaseMenu")
	controls:SetSize(100, 50)
	controls:SetPos(ticket:GetPos()+ticket:GetWide()/2-50, select(2, ticket:GetPos())+ticket:GetTall()+26)
	controls:AllowCloseButton(false)
	controls:MakePopup()
	
	local confirm = vgui.Create("OCRP_BaseButton", controls)
	confirm:SetSize(90, 40)
	confirm:SetPos(5, 5)
	confirm:SetText("Confirm Ticket")
	function confirm:DoClick()
        print(datetime:GetText())
        print(offense1:GetText())
        print(offense2:GetText())
        net.Start("OCRP_SubmitTicket")
            net.WriteInt(issuedto:EntIndex(), 32)
            net.WriteInt(cost:GetValue(), 32)
            net.WriteString(datetime:GetText())
            net.WriteString(offense1:GetText())
            net.WriteString(offense2:GetText())
        net.SendToServer()
		ticket:Remove()
	end
	
	function ticket:OnRemove()
		if controls and controls:IsValid() then
			controls:Remove()
		end
	end
	
	ticket:MakePopup()
end
net.Receive("OCRP_ShowTicketCreation", function()
    local car = Entity(net.ReadInt(32))
    local owner = car:GetNWInt("Owner")
    ShowParkingTicketCreation(Entity(owner))
end)
net.Receive("OCRP_SendTicket", function()
    local ticket = net.ReadTable()
    ShowParkingTicket(ticket.Time, ticket.Cost, ticket.Issuer, ticket.Victim, ticket.Offense1, ticket.Offense2)
end)