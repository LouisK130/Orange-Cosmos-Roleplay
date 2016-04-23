function RPMainMenu()
	local fx = ScrW() / 2 - 250
	local fy = ScrH() / 2 - 350
	local RPMainFrame = vgui.Create( "DFrame" )
	RPMainFrame:SetPos( fx, fy )
	RPMainFrame:SetSize( 500, 700 )
	RPMainFrame:SetTitle( "OCRP: Main Menu" )
	RPMainFrame:MakePopup()
end

function GM.Assplode ( UMsg )
	local Entity = UMsg:ReadEntity();
	
	if !Entity or !Entity:IsValid() then return false; end
	
	local effectdata = EffectData()
		effectdata:SetOrigin( Entity:GetPos() )
	util.Effect( "car_bomb", effectdata )
								
	local effectdata = EffectData()
		effectdata:SetOrigin( Entity:GetPos() )
	util.Effect( "Explosion", effectdata, true, true )
end
usermessage.Hook('Assplode', GM.Assplode);
