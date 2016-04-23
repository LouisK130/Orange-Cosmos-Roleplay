RunConsoleCommand("atmos_cl_snowradius", 3200)
gmod_vehicle_viewmode = CreateClientConVar("gmod_vehicle_viewmode", "1", true, true)

include( 'shared.lua' )

--include('client/hints.lua')
include('shared/sh_cars.lua')
--include('shared/sh_challenges.lua')
include('shared/sh_config.lua')
include('shared/sh_crafting.lua')
include('shared/sh_items.lua')
include('shared/sh_mayor_events.lua')
include('shared/sh_mayor_items.lua')
include('shared/sh_chief_items.lua')
include('shared/sh_models.lua')
include('shared/sh_shops.lua')
include('shared/sh_skills.lua')
include('shared/sh_orgperks.lua')
include('client/buddies.lua')
include('client/cars.lua')
--include('client/challenges.lua')
include('client/panels.lua')
include('client/chatbox.lua')
include('client/crafting.lua')
include('client/hud.lua')
include('client/voice.lua')
include('client/identification.lua')
include('client/intro.lua')
include('client/inventory.lua')
include('client/mainmenu.lua')
include('client/mayor.lua')
--include('client/notifications.lua')
include('client/npc_talk.lua')
include('client/orgs.lua')
include('client/professions.lua')
include('client/property.lua')
include('client/rp_main.lua')
include('client/rp_start.lua')
include('client/shops.lua')
include('client/skills.lua')
include('client/trading.lua')
include('client/searching.lua')
include('client/looting.lua')
include('client/chief.lua')
include('client/disguise.lua')
--include('server/day_night.lua')
include('client/minimap.lua')
include('client/fines.lua')
include('client/derma_base.lua')

--AutoAdd_LuaFiles()
OCRP_Inventory = OCRP_Inventory or {WeightData = {Cur = 0,Max = 50}}

OCRP_MyCars = OCRP_MyCars or {}
OCRP_PLAYER = OCRP_PLAYER or {}
OCRP_PLAYER["TRUNK"] = {}
OCRP_PLAYER["TRUNK"]["Items"] = {}
OCRP_PLAYER["Wardrobe"] = OCRP_PLAYER["Wardrobe"] or {}
OCRP_PLAYER["Weight"] = 0
--OCRP_AudioChannels = {}

OCRP_Skills = OCRP_Skills or {}
for skill,_ in pairs(GM.OCRP_Skills) do
	if not OCRP_Skills[skill] then
        OCRP_Skills[skill] = 0
    end
end

OCRP_CurBroadcast = {}

OCRP_TradingInfo = {Money = 0,Items = {}}

OCRP_Options = {Color = Color(210,120,30,155)}--Color(210,120,30,155}

OCRP_DeathInfo = {}

function OCRP_GetMoney_CL( um )
	local wallet = um:ReadLong()
	local bank = um:ReadLong()
	LocalPlayer().Wallet = wallet
	LocalPlayer().Bank = bank
end
usermessage.Hook("ocrp_money", OCRP_GetMoney_CL)

local PMETA = FindMetaTable("Player")

function GM.KuhBewm( UMsg )
	local Entity = UMsg:ReadEntity();
	
	if !Entity or !Entity:IsValid() then return false; end
	
	local effectdata = EffectData()
		effectdata:SetOrigin( Entity:GetPos() )
	util.Effect( "kuhbewm", effectdata )
								
	local effectdata = EffectData()
		effectdata:SetOrigin( Entity:GetPos() )
	util.Effect( "Explosion", effectdata, true, true )
end
usermessage.Hook('KuhBEWMIE', GM.KuhBewm);

function GM:InitPostEntity() 

GLOBAL_EMITTER = ParticleEmitter(Vector(0, 0, -5000));
end

function GM:Initialize()
	FireEmitter = ParticleEmitter(Vector(0, 0, 0));
	SmokeEmitter = ParticleEmitter(Vector(0, 0, 0));
	SmokeEmitter:SetNearClip(50, 200);
    -- Fuck the intro this shitty thing sucked except the dope music
--[[	if !file.Exists("OCRP/Intro.txt", "MOD") then
		INTRO = true
		GAMEMODE:Intro_Start()
	end]]
--[[	for i=1,9 do
		for _,v in pairs(GAMEMODE.OCRP_Models["Males"][i]) do
			util.PrecacheModel(v)
		end
	end
	for i=1,4 do
		for _,v in pairs(GAMEMODE.OCRP_Models["Females"][i]) do
			util.PrecacheModel(v)
		end
	end]]--
	ChatBoxInit()
end

local mat_OC_BlurScreen = Material( "pp/blurscreen" )
function Draw_OCRP_BackgroundBlur( panel )
	local Fraction = 1

	if ( starttime ) then
			Fraction = math.Clamp( (SysTime() - starttime) / 1, 0, 1 )
	end

	local x, y = panel:LocalToScreen( 0, 0 )

	DisableClipping( true )
   
	surface.SetMaterial( mat_OC_BlurScreen )   
	surface.SetDrawColor( 255, 255, 255, 255 )
		   
	for i=0.33, 1, 0.33 do
			mat_OC_BlurScreen:SetMaterialFloat( "$blur", Fraction * 5 * i )
			if ( render ) then render.UpdateScreenEffectTexture() end // Todo: Make this available to menu Lua
			surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
   
	surface.SetDrawColor( 10, 10, 10, 200 * Fraction )
	surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )
   
	DisableClipping( false )
end

surface.CreateFont("A30", {
    font="Arista 2.0",
    size=30,
    weight=400, 
    antialias=true,
    shadow=false
})

surface.CreateFont("HUDNumber5", {
    font="Trebuchet MS",
    size = 45,
    weight=900
})

surface.CreateFont("HUDNumber3", {
    font="Trebuchet MS",
    size=43,
    weight=900
})

surface.CreateFont("Trebuchet20", {
    font="Trebuchet MS",
    size=20,
    weight=900
})

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf ) 
	if (ply:IsInside()) then return; end

	local randSound = math.random(1, 6)
	ply.lastFootSound = self.lastFootSound or 1;
	
	while (randSound == ply.lastFootSound) do
		randSound = math.random(1, 6);
	end
	
	ply.lastFootSound = randSound;
	
	if (GAMEMODE.SnowOnGround) then
		EmitSound(Sound("player/footsteps/snow" .. randSound .. ".wav"), pos, ply:EntIndex(), CHAN_AUTO, 1, 25, 0, 65);
		return true
	end
end

net.Receive("OCRP_UpdateInventory", function()
    OCRP_Inventory = net.ReadTable()
end)
net.Receive("OCRP_UpdateSkills", function() -- Preserve level 0 skills? I think we do this
    local skills = net.ReadTable()
    for k,v in pairs(skills) do
        OCRP_Skills[k] = v
    end
    OCRP_MaxSkillPoints = net.ReadInt(32)
end)