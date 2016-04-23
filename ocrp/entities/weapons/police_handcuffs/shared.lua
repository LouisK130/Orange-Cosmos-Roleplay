if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.IconLetter			= "I"
end
if (CLIENT) then
	SWEP.DrawAmmo			= true
	SWEP.ViewModelFOV		= 80
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "Hand-cuffs"			
	SWEP.Author				= "Noobulater"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "C"
end
SWEP.Author			= "Noobulater"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel = "models/katharsmodels/handcuffs/handcuffs-1.mdl";
SWEP.WorldModel = "models/weapons/w_fists.mdl";

if CLIENT then
	function SWEP:GetViewModelPosition ( Pos, Ang )
		Ang:RotateAroundAxis(Ang:Forward(), 90);
		Pos = Pos + Ang:Forward() * 6;
		Pos = Pos + Ang:Right() * 2;
		
		return Pos, Ang;
	end 
end

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 1.0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay			= 5.0

SWEP.HoldType = "melee"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:Reload()
end

function SWEP:Think()
end
	
function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace()
	if !tr.Entity:IsPlayer() then return false end

	local Dist = self.Owner:EyePos():Distance(tr.HitPos)
	if Dist > 100 then return false end
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	tr.Entity:Freeze( true )
	if SERVER then
		if tr.Entity:GetNWBool("Handcuffed") then
			tr.Entity:Hint("You are being arrested.")
		else
			self.Owner:Hint("The player needs to be handcuffed before arresting them.")
		end
		timer.Simple(5,function() tr.Entity:Freeze(false) end)
	elseif CLIENT and IsFirstTimePredicted() then
		if tr.Entity:GetNWBool("Handcuffed") then
			ShowArrestOptions(tr.Entity)
		end
	end
end

function SWEP:SecondaryAttack()
	local tr = self.Owner:GetEyeTrace()
	if !tr.Entity:IsPlayer() && tr.Entity:GetClass() != "prop_ragdoll" then return false end
	local Dist = self.Owner:EyePos():Distance(tr.HitPos)
	if Dist > 100 then return false end
	if SERVER then
		if tr.Entity:GetClass() == "prop_ragdoll" && !tr.Entity.player:IsValid() then return false end
		local player = tr.Entity
		if tr.Entity:GetClass() == "prop_ragdoll" && tr.Entity.player:IsValid() then
			player = tr.Entity.player
			player:SetNWBool("Handcuffed",true)
			self.Owner:Hint("You handcuffed "..player:Nick())
            SV_PrintToAdmin(self.Owner, "HANDCUFF", self.Owner:Nick() .. " handcuffed " .. player:Nick() .."'s body")
		else
			if player:GetNWBool("Handcuffed") then
				player:SetNWBool("Handcuffed", false)
				self.Owner:Hint("You unhandcuffed "..player:Nick())
                SV_PrintToAdmin(self.Owner, "UNHANDCUFF", self.Owner:Nick() .. " unhandcuffed " .. player:Nick())
			end
		end
	end
	if CLIENT then
		if !tr.Entity:GetNWBool("Handcuffed") && tr.Entity:IsPlayer() then
			self.Target = tr.Entity
			self.JailTime = CurTime() + 1
		end
	end
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	
end

function SWEP:Think()
	local tr = self.Owner:GetEyeTrace()
	if !tr.Entity:IsPlayer() then return false end
	local Dist = self.Owner:EyePos():Distance(tr.HitPos)
	if Dist > 100 then return false end
end
	

if CLIENT then

function ShowArrestOptions(ply)

    local frame = vgui.Create("OCRP_BaseMenu")
    frame:SetSize(250, 150)
    frame:Center()
    frame:SetOCRPTitle("Arrest Options")
    frame:MakePopup()
    
    local name = "Arresting " .. ply:Nick()
    surface.SetFont("UiBold")
    while surface.GetTextSize(name) > 200 do
        name = name:sub(1, name:len()-4) .. "..."
    end
    
    local textw,texth = surface.GetTextSize(name)
    
    local caption = vgui.Create("DPanel", frame)
    caption:SetSize(textw+10,texth+10)
    caption:SetPos(frame:GetWide()/2-caption:GetWide()/2, 10)
    
    function caption:Paint(w,h)
        draw.DrawText(name, "UiBold", 5, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
    end
    
    local timelabel = vgui.Create("DLabel", frame)
    timelabel:SetText("Time (s): ")
    timelabel:SetFont("UiBold")
    timelabel:SetTextColor(Color(39,168,216,255))
    timelabel:SizeToContents()
    timelabel:SetPos(10, 40+timelabel:GetTall()/2)
    
    local total = 120
    
    local slider = vgui.Create("DSlider", frame)
    slider:SetWide(125)
    slider:SetPos(timelabel:GetPos()+timelabel:GetWide()+10, 40)
    slider:SetSlideX(30/total)
    
    function slider:Paint(w,h)
        draw.RoundedBox(0, 0, h/2, w, 1, Color(39,168,216,255))
        for i=0,4 do
            local x = i*w/4
            if x == w then x = x-1 end -- Make sure it shows
            draw.RoundedBox(0, x, h/2-7, 1, 15, Color(39,168,216,255))
        end
    end
    
    local time = vgui.Create("DLabel", frame)
    time:SetFont("UiBold")
    time:SetTextColor(Color(39,168,216,255))
    time:SetText("30")
    time:SizeToContents()
    time:SetPos(slider:GetPos()+slider:GetWide()+15, select(2, slider:GetPos())+slider:GetTall()/2-time:GetTall()/2)
    
    function time:Think()
        if time:GetText() != tostring(math.Round(slider:GetSlideX()*total)) then
            time:SetText(tostring(math.Round(slider:GetSlideX()*total)))
            time:SizeToContents()
            time:SetPos(slider:GetPos()+slider:GetWide()+15, select(2, time:GetPos()))
        end
    end
    
    local baillabel = vgui.Create("DLabel", frame)
    baillabel:SetText("Bail ($): ")
    baillabel:SetFont("UiBold")
    baillabel:SetTextColor(Color(39,168,216,255))
    baillabel:SizeToContents()
    baillabel:SetPos(10, select(2, slider:GetPos())+slider:GetTall()+10+(baillabel:GetTall()/2))
    
    local bailTotal = 1000
    
    local bailSlider = vgui.Create("DSlider", frame)
    bailSlider:SetWide(125)
    bailSlider:SetPos(slider:GetPos(), select(2, slider:GetPos())+slider:GetTall()+10)
    bailSlider:SetSlideX(100/bailTotal)
    
    function bailSlider:Paint(w,h)
        draw.RoundedBox(0, 0, h/2, w, 1, Color(39,168,216,255))
        for i=0,4 do
            local x = i*w/4
            if x == w then x = x-1 end -- Make sure it shows
            draw.RoundedBox(0, x, h/2-7, 1, 15, Color(39,168,216,255))
        end
    end
    
    local bail = vgui.Create("DLabel", frame)
    bail:SetFont("UiBold")
    bail:SetTextColor(Color(39,168,216,255))
    bail:SetText("100")
    bail:SizeToContents()
    bail:SetPos(bailSlider:GetPos()+bailSlider:GetWide()+15, select(2, bailSlider:GetPos())+bailSlider:GetTall()/2-bail:GetTall()/2)
    
    function bail:Think()
        if bail:GetText() != tostring(math.Round(bailSlider:GetSlideX()*bailTotal)) then
            bail:SetText(tostring(math.Round(bailSlider:GetSlideX()*bailTotal)))
            bail:SizeToContents()
            bail:SetPos(bailSlider:GetPos()+bailSlider:GetWide()+15, select(2, bail:GetPos()))
        end
    end

    local confirm = vgui.Create("OCRP_BaseButton", frame)
    confirm:SetSize(150, 20)
    confirm:SetPos(frame:GetWide()/2-confirm:GetWide()/2, frame:GetTall()-confirm:GetTall()-10)
    confirm:SetText("Confirm Arrest")
    
    function confirm:DoClick()
    
        local time = tonumber(time:GetText())
        local bail = tonumber(bail:GetText())
        
        if time < 30 then
            OCRP_AddHint("Arrest time must be atleast 30 seconds.")
            return
        elseif bail < 100 then
            OCRP_AddHint("Bail must be atleast $100.")
            return
        end
    
		net.Start("OCRP_Arrest_Player")
            net.WriteInt(ply:EntIndex(), 32)
            net.WriteInt(time, 32)
            net.WriteInt(bail, 32)
		net.SendToServer()
        
        frame:Remove()
    
    end

end


function SWEP:DrawHUD()
	local tr = self.Owner:GetEyeTrace()
	if !tr.Entity:IsPlayer() then self.Target = nil self.JailTime = nil end

	local Dist = self.Owner:EyePos():Distance(tr.HitPos)
	if Dist > 100 then self.Target = nil self.JailTime = nil return false end
	
	if tr.Entity == self.Target then
		if self.JailTime <= CurTime() then
			net.Start("OCRP_Handcuffplayer")
			net.WriteInt(self.Target:EntIndex(), 32)
			net.SendToServer()
			self.Target = nil
			self.JailTime = nil
			return
		else
			
			surface.SetDrawColor(50,50,50,155)
			surface.DrawRect(ScrW()/2 - 101,ScrH()/2 - 11,202,22)

			surface.SetDrawColor(200,200,200,155)
			surface.DrawRect(ScrW()/2 - 100,ScrH()/2 - 10,200*(((self.JailTime-CurTime())/1)),20)
			
			surface.SetTextColor(255,255,255,255)
			surface.SetFont("UiBold")
			local x,y = surface.GetTextSize("Handcuffing")
			surface.SetTextPos(ScrW()/2 -x/2,ScrH()/2-y/2)
			surface.DrawText("Handcuffing")
			
		end
	end
	
end

end
