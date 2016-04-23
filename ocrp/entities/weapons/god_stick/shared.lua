if( SERVER ) then
 
        AddCSLuaFile( "shared.lua" );
 
end
 
if( CLIENT ) then
 
        SWEP.PrintName = "Godstick";
        SWEP.Slot = 0;
        SWEP.SlotPos = 5;
        SWEP.DrawAmmo = false;
        SWEP.DrawCrosshair = true;
 
end
 
// Variables that are used on both client and server
 
SWEP.Author               = "a danish mexican"
SWEP.Instructions       = ""
SWEP.Contact        = ""
SWEP.Purpose        = ""
 
SWEP.ViewModelFOV       = 62
SWEP.ViewModelFlip      = false
SWEP.AnimPrefix  = "stunstick"

SWEP.Spawnable      = false
SWEP.AdminSpawnable          = true
 
SWEP.NextStrike = 0;
SWEP.UseHands	= false
  
SWEP.ViewModel = Model( "models/weapons/v_stunstick.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_stunbaton.mdl" );
  
SWEP.Sound = Sound( "weapons/stunstick/stunstick_swing1.wav" );
SWEP.Sound1 = Sound( "npc/metropolice/vo/moveit.wav" );
SWEP.Sound2 = Sound( "npc/metropolice/vo/movealong.wav" );

SWEP.Primary.ClipSize      = -1                                   // Size of a clip
SWEP.Primary.DefaultClip        = 0                    // Default number of bullets in a clip
SWEP.Primary.Automatic    = true            // Automatic/Semi Auto
SWEP.Primary.Ammo                     = ""
 
SWEP.Secondary.ClipSize  = -1                    // Size of a clip
SWEP.Secondary.DefaultClip      = 0            // Default number of bullets in a clip
SWEP.Secondary.Automatic        = false    // Automatic/Semi Auto
SWEP.Secondary.Ammo               = ""
SWEP.Worn = -1

 
--[[---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------]]
function SWEP:Initialize()
 
        if( SERVER ) then

				self.Gear = 1;
        
        end
		
		self:SetHoldType( "melee" );
        
end

function SWEP:DrawWorldModel()
    if self:IsValid() and self.Owner:IsValid() then
        if self:GetOwner():GetColor().a == 255 then
            self:DrawModel()
        end
    end
end

local SLAP_SOUNDS = {
	"physics/body/body_medium_impact_hard1.wav",
	"physics/body/body_medium_impact_hard2.wav",
	"physics/body/body_medium_impact_hard3.wav",
	"physics/body/body_medium_impact_hard5.wav",
	"physics/body/body_medium_impact_hard6.wav",
	"physics/body/body_medium_impact_soft5.wav",
	"physics/body/body_medium_impact_soft6.wav",
	"physics/body/body_medium_impact_soft7.wav"
}
 
 
--[[---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------]]
function SWEP:Precache()
end
 
function SWEP:DoFlash( ply )
 
        umsg.Start( "StunStickFlash", ply ); umsg.End();
 
end

local Gears = {};
 
--[[---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------]]
  function SWEP:PrimaryAttack()
  
        if( CurTime() < self.NextStrike ) then return; end
		if !self.Owner:IsAdmin() and SERVER then
			self.Owner:Kick("Nope.");
			return false;
		end
 
        self.Owner:SetAnimation( PLAYER_ATTACK1 );
		
		if not self.Owner.IsAdminMode then
			self.Weapon:EmitSound( self.Sound );
		end
		
        self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
 
        self.NextStrike = ( CurTime() + .3 );

        if( CLIENT ) then return; end
 
        local trace = self.Owner:GetEyeTrace();
        
        local Gear = self.Owner:GetTable().CurGear or 1;
		
		Gears[Gear][4](self.Owner, trace);
  end
  

  local function AddGear ( Title, Desc, SA, Func )
		table.insert(Gears, {Title, Desc, SA, Func});
  end
function AdminMode(Player, bool)
	local color = Player:GetColor();
	if Player.IsAdminMode and !bool then
		Player:Hint("Admin mode disabled; you are vulnerable and visible.")
		Player.IsAdminMode = false
        Player:SetNWBool("AdminMode", false)
		Player.IsGod = false;
		Player:GodDisable();
		Player:SetColor(Color(255,255,255,255))
		Player:SetNoDraw(false);
	elseif !Player.IsAdminMode and (bool or bool == nil) then
		Player:Hint("Admin mode enabled; you are invulnerable and invisible.")
		Player.IsAdminMode = true
        Player:SetNWBool("AdminMode", true)
		Player.IsGod = true;
		Player:GodEnable();
		Player:SetColor(Color(255,255,255,0));
		Player:SetNoDraw(true);
	end
end

AddGear(" Admin Mode", "God mode and invisibility", false, function(Player, Trace)
	AdminMode(Player)
    local state = Player.IsAdminMode and "on" or "off"
    SV_PrintToAdmin(Player, "ADMIN MODE", "toggled admin mode to " .. state)
end)
AddGear(" Kill Player", "Aim at a player to slay him.", false,
	function ( Player, Trace )
		if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
			Trace.Entity.ForcedDeath = true
			Trace.Entity:Kill();
			Trace.Entity.ForcedDeath = false
			Trace.Entity:Hint("You have been slain by a administrator.")
			SV_PrintToAdmin(Trace.Entity, "ADMIN-SLAY", "slain by " .. Player:Nick() .. "(" .. Player:SteamID() .. ")")
			Trace.Entity:EmitSound("npc/metropolice/vo/amputate.wav");
		end
	end
);
AddGear(" Blacklist from Job", "Aim at a player to blacklist him from his current job.", false,
	function ( Player, Trace )
		if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
            Player:Blacklist(Trace.Entity, Trace.Entity:Team())
		end
	end
);

--[[AddGear(" Warn Player", "Aim at a player to warn him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:Hint("You are doing something you shouldn't be. Stop.");
				Trace.Entity:EmitSound("npc/metropolice/vo/finalwarning.wav");
			end
	end
);]]
AddGear(" Give Hands/Keys", "Re-equips target with hands and keys.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				if Trace.Entity:HasWeapon("weapon_idle_hands_ocrp") then
					Trace.Entity:StripWeapon("weapon_idle_hands_ocrp")
				elseif Trace.Entity:HasWeapon("weapon_keys_ocrp") then
					Trace.Entity:StripWeapon("weapon_keys_ocrp")
				end
				timer.Simple(.5, function ( )
					Trace.Entity:Give("weapon_idle_hands_ocrp")
					Trace.Entity:Give("weapon_keys_ocrp")
					--end
				end);
			end
	end
);

AddGear(" Remove Ticket", "Aim at a ticketed vehicle to remove the ticket and boot.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:GetClass() == "prop_vehicle_jeep" then
                if Trace.Entity.Ticket or Trace.Entity.Boot or Trace.Entity.Booter then
                    Trace.Entity.Ticket = nil
                    Trace.Entity.Boot = nil
                    Trace.Entity.Booter = nil
                    Player:Hint("You have removed the ticket from this car.")
                    SV_PrintToAdmin(Player, "UNTICKET", "removed ticket from " .. Entity(Trace.Entity:GetNWInt("OWner")):Nick() .. "'s car")
                else
                    Player:Hint("This car is not ticketed.")
                end
			end
	end
);

AddGear(" Break Vehicle", "Aim at a vehicle to break it.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:GetClass() == "prop_vehicle_jeep" then
				if Trace.Entity:IsVehicle() and IsValid(Trace.Entity:GetDriver()) then
					Trace.Entity:GetDriver():ExitVehicle();
				end
				GAMEMODE.DoBreakdown( Trace.Entity, true, true)
				--Trace.Entity:SetColor(120,120,120,255)
				Player:Hint("You have disabled this car.")
                SV_PrintToAdmin(Player, "BREAK CAR", "disabled " .. Entity(Trace.Entity:GetNWInt("OWner")):Nick() .. "'s car")
			end
	end
);

AddGear(" Repair Vehicle", "Aim at a vehicle to repair it.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:GetClass() == "prop_vehicle_jeep" then
				OCRP_FixCar( Player, Trace.Entity, true)
				--Trace.Entity:SetColor(255,255,255,255)
				Trace.Entity:Fire('turnon', '', .5)
                SV_PrintToAdmin(Player, "REPAIR CAR", "repaired " .. Entity(Trace.Entity:GetNWInt("OWner")):Nick() .. "'s car")
			end
	end)
--[[AddGear(" Force Changename", "Forces the player to change their name.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Notify(Trace.Entity, 1, 15, "Your name voilates our rules. Change it.")
				Notify(Trace.Entity, 1, 15, "Do not make a name such as Mike Hawk, Ben Dover or Mike Hunt.")
				Notify(Trace.Entity, 1, 15, "No celebrity names allowed.")
				Trace.Entity:ConCommand("rpnamelol")
			Notify(Player, 1, 5, "Forced.");
			end
	end
);
]]
--[[AddGear(" Warn for unrealistic and/or laggy boat", "Tells a player to sort out their boat", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Notify(Trace.Entity, 1, 15, "Your boat is causing lag and/or is unrealistic. Sort it out.")
			Notify(Player, 1, 5, "Warned "..Trace.Entity:Nick());
			end
	end
);]]
AddGear(" English", "Aim at a player to warn him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:EmitSound("ocrp/MOTHERFUCK.wav");
				Player:Hint("Warned. Speak English only.")
				Trace.Entity:Hint("You aren't making sense. Start making sense.")
			end
	end
);
--[[AddGear(" Mute", "Mute a player.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() and Trace.Entity:IsMuted() == false then
				Trace.Entity:ChatPrint("You have been muted.");
				Trace.Entity:SetMuted(true);
				Trace.Entity:EmitSound("CatalystRP/MOTHERFUCK.wav");
				Player:ChatPrint("Player muted.");
				else
				Trace.Entity:SetMuted(false);
				Trace.Entity:ChatPrint("You have been unmuted.");
				Trace.Entity:EmitSound("CatalystRP/MOTHERFUCK.wav");
				Player:ChatPrint("Player unmuted.")
			end
	end
);]]


AddGear(" Handcuff Player", "Aim at a player to handcuff him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:SetNWBool("Handcuffed",true)
				Trace.Entity:SelectWeapon("weapon_idle_hands_ocrp")
				Player:Hint("You Handcuffed "..Trace.Entity:Nick())
                SV_PrintToAdmin(Player, "ADMIN HANDCUFF", "handcuffed " .. Trace.Entity:Nick())
			end
	end
);
AddGear(" Unhandcuff player", "Aim at a player to un-handcuff him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				if Trace.Entity:GetNWBool("Handcuffed") then
					Trace.Entity:SetNWBool("Handcuffed", false)
					Player:Hint("You unhandcuffed "..Trace.Entity:Nick())
                    SV_PrintToAdmin(Player, "ADMIN UNHANDCUFF", "unhandcuffed " .. Trace.Entity:Nick())
				end
			end
	end
);

AddGear(" Siren/Lights Off", "Aim to Turn Siren/Lights Off", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsGovCar() then
                local TTbl = {} for k,v in pairs(Trace.Entity.VC_Script.Siren.Sequences) do if v.Codes then table.Merge(TTbl, table.Copy(v.Codes)) end end
                local HasNoCodes = false if table.Count(TTbl) == 0 then HasNoCodes = true end
                VC_ELS_Lht_SetCode(Trace.Entity, 0, HasNoCodes)
                -- For some reason setting sound code doesn't work, so we just toggle it a few times instead
                while Trace.Entity.VC_ELS_Snd_Sel ~= 0 do
                    VC_ELS_Snd_Cycle(Trace.Entity)
                end
				Player:Hint("Turned Siren/Lights Off.");
			end
	end
);

AddGear(" Demote Player", "Aim to demote a player to citizen", false,
    function(Player, Trace)
        if Trace.Entity:IsValid() and Trace.Entity:IsPlayer() then
            SV_PrintToAdmin(Player, "ADMIN DEMOTE", "demoted " .. Trace.Entity:Nick() .. " from " .. getJobString(Trace.Entity:Team()))
            OCRP_DEMOTE(Player, Trace.Entity)
        end
    end
);


AddGear(" Kick Player", "Aim at a player to kick him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:Kick("Consider this a warning.");
				Trace.Entity:EmitSound("npc/metropolice/vo/finalverdictadministered.wav");
				Player:Hint("Player kicked.");
                SV_PrintToAdmin(PLAYER, "ADMIN KICK", "kicked " .. Trace.Entity:Nick())
			elseif Trace.Entity:IsVehicle() and IsValid(Trace.Entity:GetDriver()) then
				Player:Hint("Driver kicked.")
				Trace.Entity:EmitSound("npc/metropolice/vo/finalverdictadministered.wav");
				Trace.Entity:GetDriver():Kick("Consider this a warning.");
                SV_PrintToAdmin(Player, "ADMIN KICK", "kicked " .. Trace.Entity:Nick())
			end
	end
);
--[[AddGear(" Kick Player", "Aim at a player to kick him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then

				Trace.Entity:Kick("Consider this a warning.");
			end
	end
);]]

AddGear(" Respawn Player", "Aim at a player to respawn him.", false,
	function ( Player, Trace )
        local respawn = nil
        local samePos = false
			if IsValid(Trace.Entity) then
                if Trace.Entity:IsPlayer() then
                    respawn = Trace.Entity
                elseif Trace.Entity:GetClass() ==  "prop_ragdoll" then
                    for k,v in pairs(player.GetAll()) do
                        if !v:Alive() and v.Ragdoll:GetPos():Distance(Trace.HitPos) < 120 then
                            respawn = v
                            samePos = true
                        end
                    end
                end
                if respawn and respawn:IsValid() then
                    respawn:Hint("An administrator has respawned you.");
                    respawn:Spawn();
                    if samePos then
                        respawn:SetPos(Trace.HitPos)
                    end
                    Player:Hint("Player respawned.");
                    local place = samePos and " in the same place" or " back to spawn"
                    SV_PrintToAdmin(Player, "ADMIN RESPAWN", "respawned " .. respawn:Nick() .. place)
                end
			end
	end
);

-- Not good enough to do it just once apparently, have to do it in think repeatedly
--[[function hideInvisWep(ply, oldWep, newWep)
    if ply:IsValid() and ply:GetColor().a == 0 then
		newWep:SetRenderMode(RENDERMODE_TRANSALPHA)
		newWep:SetColor(255,255,255,0)
		newWep:SetNoDraw(true)
    else
		newWep:SetRenderMode(RENDERMODE_NORMAL)
		newWep:SetColor(255,255,255,255)
		newWep:SetNoDraw(false)
	end
end

hook.Add("PlayerSwitchWeapon", "OCRP_Admin_Invis_Wep", hideInvisWep)]]

AddGear(" Heal Player", "Aim at a player to heal them fully, aim at nothing to heal yourself.", false,
    function(Player, tr)
        if tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() then
            tr.Entity:SetHealth(100)
            if tr.Entity.Inhibitors.ForceWalk then
				tr.Entity.Inhibitors.ForceWalk = false
				umsg.Start("inhib_forcewalk", tr.Entity)
					umsg.Bool(false)
				umsg.End()
				tr.Entity:SetRunSpeed(tr.Entity.Speeds.Sprint)
				tr.Entity:Hint("Your leg has been tended to, and has healed")
			end
			if tr.Entity.Inhibitors.BrokenArm then				
				tr.Entity.Inhibitors.BrokenArm = false
				tr.Entity:Hint("Your arm has been tended to, and has healed")
			end
			for _,wound in pairs(tr.Entity.Wounds) do
				if wound:IsValid() then
					wound:Remove()
				end
			end
            tr.Entity:Hint("An administrator has healed you.")
            Player:Hint("Healed: " .. tr.Entity:Nick())
            SV_PrintToAdmin(Player, "ADMIN HEAL", "healed " .. tr.Entity:Nick())
        else
                    if Player.Inhibitors.ForceWalk then
				Player.Inhibitors.ForceWalk = false
				umsg.Start("inhib_forcewalk", Player)
					umsg.Bool(false)
				umsg.End()
				Player:SetRunSpeed(Player.Speeds.Sprint)
				Player:Hint("Your leg has been tended to, and has healed")
			end
			if Player.Inhibitors.BrokenArm then				
				Player.Inhibitors.BrokenArm = false
				Player:Hint("Your arm has been tended to, and has healed")
			end
			for _,wound in pairs(Player.Wounds) do
				if wound:IsValid() then
					wound:Remove()
				end
			end
            Player:SetHealth(100)
            Player:Hint("Healed self.")
            SV_PrintToAdmin(Player, "ADMIN HEAL", "healed him/herself")
        end
    end
);

AddGear(" Unlock Door", "Aim at a door to unlock it.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:Fire('unlock', '', 0);
				Trace.Entity:Fire('open', '', .5);
				Player:Hint("Unlocked.");
			end
	end
);

AddGear(" Lock Door", "Aim at a door to lock it.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:Fire('lock', '', 0);
				Trace.Entity:Fire('close', '', .5);
				Player:Hint("Locked.");
			end
	end
);


--[[AddGear("Revive Player", "Aim at a corpse to revive the player.", true,
	function ( Player, Trace )
			umsg.Start('god_try_revive', Player);
			umsg.End();
	end
);]]


AddGear(" Teleport", "Teleports you to a targeted location.", false,
	function ( Player, Trace )
		local EndPos = Player:GetEyeTrace().HitPos;
		local CloserToUs = (Player:GetPos() - EndPos):Angle():Forward();
		
		Player:SetPos(EndPos + (CloserToUs * 20));
		Player:Hint("Teleported.");
	end
);
AddGear(" Force Hands", "Force a player to use their hands.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:SelectWeapon("weapon_idle_hands_ocrp")
				Trace.Entity:Hint("Don't run around with a physgun, gravgun, keys, or a gun. Use your hands.")
			end
	end
);

--[[AddGear("Info", "Prints info about the player you're targeting.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Notify(Player, 0, 40,"Name: "..Trace.Entity:Nick())
				Notify(Player, 0, 40,"SteamID: "..Trace.Entity:SteamID())
				Notify(Player, 0, 40,"Team: "..team.GetName(Trace.Entity:Team()))
				Notify(Player, 0, 40,"Kills: "..Trace.Entity:Frags())
				Notify(Player, 0, 40,"Deaths: "..Trace.Entity:Deaths())
				if Trace.Entity:GetUserGroup() == "owner" then
					Notify(Player, 4, 40,"Rank: Owner")
				elseif Trace.Entity:GetUserGroup() == "superadmin" then
					Notify(Player, 4, 40,"Rank: Super Admin")
				elseif Trace.Entity:GetUserGroup() == "admin" then
					Notify(Player, 4, 40,"Rank: Admin")
				elseif Trace.Entity:GetUserGroup() == "gold" then
					Notify(Player, 4, 40,"Rank: Gold Member")
				elseif Trace.Entity:GetUserGroup() == "vip" then
					Notify(Player, 1, 40,"Rank: VIP")
				else Notify(Player, 1,40,"Rank: Regular")
				end
				Notify(Player, 0, 40,"HP: " ..Trace.Entity:Health())
				Notify(Player, 0, 40,"Model: "..Trace.Entity:GetModel())	
				if Player:GetUserGroup() == "owner" then
					Notify(Player, 0, 40,"IP/Port: "..Trace.Entity:IPAddress())
				else return end
			end
	end
);]]


AddGear(" Extinguish ( Local )", "Extinguishes the fires near where you aim.", false,
	function ( Player, Trace )
			for k, v in pairs(ents.FindInSphere(Trace.HitPos, 250)) do
				if v:GetClass() == 'prop_fire' then
					v:KillFire();
				elseif v:GetClass() == "env_smoketrail" then
                    v:Remove();
                end
                v:Extinguish()
			end
            SV_PrintToAdmin(Player, "EXTINGUISH LOCAL", "extinguished local fires")
	end
);

 AddGear(" Extinguish ( All )", "Extinguishes all fires on the map.", false,
	function ( Player, Trace )
			for k, v in pairs(ents.FindByClass('prop_fire')) do
				v:KillFire()
			end
            for k,v in pairs(ents.FindByClass('env_smoketrail')) do
                v:Remove()
            end
            SV_PrintToAdmin(Player, "EXTINGUISH GLOBAL", "extinguished global fires")
	end
);
AddGear(" Extinguish ( Item on fire )", "Aim at a burning entity to unburn it", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:Extinguish()
				--Trace.Entity:SetColor(Color(255,255,255,255))
				Player:Hint("Extinguished");
			end
            SV_PrintToAdmin(Player, "EXTINGUISH ITEM", "extinguished an item on fire")
	end
);
--[[AddGear(" Respawn Player", "Aim at a player to respawn him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:Hint("An administrator has respawned you.");
				Trace.Entity:Kill();
				timer.Simple(.5, function ( )
					Trace.Entity:Spawn();
					--end
				end);
				Player:Hint("Player respawned.");
			end
	end
);]]
AddGear(" Unfreeze (Prop)", "Aim at an entity to unfreeze it", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:GetPhysicsObject():EnableMotion( true )
				Trace.Entity:GetPhysicsObject():Wake()
				Player:Hint("Unfrozen");
			end
	end
);

AddGear(" Remover", "Aim at any object to remove it.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if string.find(Trace.Entity:GetClass(), "door") then
					return Player:Hint( "You cannot remove doors, dickknob.");
				elseif string.find(Trace.Entity:GetClass(), "npc") then
					return Player:Hint( "You cannot remove npcs, dickknob.");
				elseif Trace.Entity:IsPlayer() then
                    Trace.Entity:Kill()
                else
                    Trace.Entity:Remove()
				end
			end
	end
);

--[[AddGear("Explode", "Aim at any object to explode it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if Trace.Entity:IsVehicle() and IsValid(Trace.Entity:GetDriver()) then
					Trace.Entity:GetDriver():ExitVehicle();
				end
				
				if string.find(tostring(Trace.Entity), "door") then
					return Player:ChatPrint( "You cannot explode doors, dickknob.");
				elseif string.find(tostring(Trace.Entity), "npc") then
					return Player:ChatPrint( "You cannot explode npcs, dickknob.");
				end;
				
				GAMEMODE.Explode(Trace.Entity:GetPos(), Player)
				
				timer.Simple(.5, function ( )
					if IsValid(Trace.Entity) then
						if Trace.Entity:IsPlayer() then
							Trace.Entity:Kill();
						else
							Trace.Entity:Remove();
						end
					end
				end);
			end
	end
);]]

AddGear(" Freeze", "Target a player to change his freeze state.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				if Trace.Entity.IsFrozens then
					Trace.Entity:Freeze(false);
					Player:Hint( "Player unfrozen.");
					Trace.Entity:Hint("You have been unfrozen by a administrator.")
					Trace.Entity:EmitSound("npc/metropolice/vo/allrightyoucango.wav")
					Trace.Entity.IsFrozens = nil;
				else
					Trace.Entity.IsFrozens = true;
					Trace.Entity:Freeze(true);
					Player:Hint( "Player frozen.");
					Trace.Entity:EmitSound("npc/metropolice/vo/holdit.wav")
					Trace.Entity:Hint("You have been frozen by a administrator.")
				end
                local state = Trace.Entity.IsFrozens and "frozen" or "unfrozen"
                SV_PrintToAdmin(Player, "ADMIN FREEZE", "set " .. Trace.Entity:Nick() .. "'s freeze state to " .. state)
			end
	end
);

AddGear(" Disguise/Remove Disguise", "Disguise yourself as a normal rank user.", false,
	function ( Player, Trace )
		if !Player.IsDisguised then
			AddDisguisedAdmin(Player)
			Player:Hint("You are now disguised!");
		else
			RemoveDisguisedAdmin(Player)
			Player:Hint("You are no longer disguised!");
		end
        local state = Player.IsDisguised and "disguised" or "undisguised"
        SV_PrintToAdmin(Player, "ADMIN DISGUISE", "set his/her disguise state to " .. state)
	end
);
-- This is done with "Admin Mode" now, no need to do either of these
--[[AddGear(" Invisiblity", "Left click to go invisible. Left click again to become visible again.", false,
	function ( Player, Trace )
		local color = Player:GetColor();
		if color.a == 255 then
			Player:Hint("You are now invisible.");
			Player:SetColor(Color(255,255,255,0));
			Player:SetNoDraw(true);
		else
			Player:Hint("You are now visible again.");
			Player:SetColor(Color(255,255,255,255));
			Player:SetNoDraw(false);
		end
        local state = (color.a == 255) and "visible" or "invisible"
        SV_PrintToAdmin(Player, "ADMIN INVISIBILITY", "set his/her invisibility state to " .. state)
	end
);
AddGear(" God Mode", "Left click to alternate between god and mortal.", false,
	function ( Player, Trace )
		if Player.IsGod then
			Player.IsGod = false;
			Player:Hint("You are now vulnerable.");
			Player:GodDisable();
		else
			Player.IsGod = true;
			Player:Hint("You are now invulnerable.");
			Player:GodEnable();
		end
        local state = Player.IsGod and "on" or "off"
        SV_PrintToAdmin(Player, "ADMIN GODMODE", "set his/her godmode state to " .. state)
	end
);]]

AddGear(" Super Slap Player", "Aim at an entity to super slap him.", "Owner",
	function ( Player, Trace )
				if !Player:IsSuperAdmin() then
				Player:Hint("Nope.");
				return false;
			end
			if IsValid(Trace.Entity) then
				if !Trace.Entity:IsPlayer() then
					local RandomVelocity = Vector( math.random(50000) - 25000, math.random(50000) - 25000, math.random(50000) - (50000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					Trace.Entity:GetPhysicsObject():SetVelocity( RandomVelocity )
				else
					local RandomVelocity = Vector( math.random(5000) - 2500, math.random(5000) - 2500, math.random(5000) - (5000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:SetVelocity( RandomVelocity )
					
				end
			end
	end
);

AddGear(" Telekinesis ( Stupid )", "Left click to make it float.", "Owner",
	function ( Player, Trace )
				if !Player:IsSuperAdmin() then
				Player:Hint("Nope.");
				return false;
			end
			local self = Player:GetActiveWeapon();
			if self.Floater then
				self.Floater = nil;
				self.FloatSmart = nil;
			elseif IsValid(Trace.Entity) then
				self.Floater = Trace.Entity;
				self.FloatSmart = nil;
			end
	end
);

AddGear(" Telekinesis ( Smart )", "Left click to make it float and follow your crosshairs.", "Owner",
	function ( Player, Trace )
				if !Player:IsSuperAdmin() then
				Player:Hint("Nope.");
				return false;
			end
			local self = Player:GetActiveWeapon();
			
			if self.Floater then
				self.Floater = nil;
				self.FloatSmart = nil;
			elseif IsValid(Trace.Entity) then
				self.Floater = Trace.Entity;
				self.FloatSmart = true;
			end
	end
);

--[[AddGear("Weather", "Left click to change the weather. ( Takes up to a minute after fire. )", true,
	function ( Player, Trace )
		GAMEMODE.NextCloudChange = 0
		Player:ChatPrint( "Weather changed.");
	end
);

AddGear("Delete Tornados", "Left click to kill all tornados.", true,
	function ( Player, Trace )
			for k, v in pairs(ents.FindByClass('weather_tornado')) do
				v:Remove();
			end
			
			for k, v in pairs(player.GetAll()) do
				v:ChatPrint("All tornados on the map have been removed to preserve gameplay.");
			end
			
			Player:ChatPrint( "Tornados removed.");
	end
);]]

--[[ 
AddGear(" Weather Storm", "Left click to change the weather to stormy.", false,
	function ( Player, Trace )
		if Player:GetLevel() != 0 then
			Player:ChatPrint("This gear requires Owner status.");
			return false;
		end
		
		GAMEMODE.CloudCondition = 8;
		Player:ChatPrint( "Weather changed to stormy.");
	end
);
 ]]

--[[AddGear(" Rick Roll", "Left click to rickroll a player.", false,
	function ( Player, Trace )
		if not Player:IsSuperAdmin() then
			Player:ChatPrint("This option requires Super Administrator.");
			return false;
			else
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
			Trace.Entity:EmitSound("CatalystRP/rick.mp3");
		end	
	end
);]]

--[[AddGear(" Flying Car", "Left click to make a car fly.", false,
	function ( Player, Trace )
		if Player:IsSuperAdmin() then
		if IsValid(Trace.Entity) and Trace.Entity:IsVehicle() then
			Trace.Entity.CanFly = true;
			Player:ChatPrint( "You are now the proud owner of a flying car.");
		end
	end
);]]
AddGear(" Explode", "Aim at an entity to explode it", "Owner",
	function ( Player, Trace )
			if !Player:IsSuperAdmin() then
				Player:Hint("Nope.");
				return false;
			end
		local explode = ents.Create("env_explosion");
		local eyetrace = Player:GetEyeTrace();
			if IsValid(Trace.Entity) then
				Trace.Entity:Ignite(10,0)
				explode:SetPos( eyetrace.HitPos ) 
				--explode:SetOwner( self.Owner ) 
				explode:Spawn() 
				explode:SetKeyValue("iMagnitude","75") 
				//explode:EmitSound("ambient/explosions/explode_" .. math.random(1, 4) .. ".wav", 400, 100 ) 
				explode:Fire("Explode", 0, 0 ) 
				if Trace.Entity:IsPlayer() then
					Trace.Entity:Kill();
				else 
				end	
				Player:Hint("Boom.")
			end
	end
);
AddGear(" Create Fire", "Spawns a fire wherever you're aiming.", "Owner",
	function ( Player, Trace )
		if Player:GetLevel() != 0 then
			Player:Hint("Nope.");
			return false;
		end
		if IsValid(Trace.Entity) then
			Trace.Entity:Ignite(300);
		else
			local Fire = ents.Create('prop_fire');
			Fire:SetPos(Trace.HitPos);
			Fire:Spawn();
			
			Player:ChatPrint( "Fire started.");
		end
	end
);
AddGear(" Mindfuck", "Aim at a player to mindfuck him.", "Owner",
	function ( Player, Trace )
		if Player:GetLevel() != 0 then
			Player:Hint("Nope.");
			return false;
		end
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Player:Hint("the servear accidnet vision plz wat whale fix!111!!")
				Trace.Entity:ConCommand("pp_sharpen 1; pp_sharpen_contrast 20; pp_sharpen_distance -100; pp_motionblur 1; pp_motionblur_addalpha 0.2; pp_sobel 1; pp_sobel_threshold 0.35");
				Player:Hint("Mindfucked.");
			end
	end
);

AddGear(" Un-Mindfuck", "Aim at a player to un-mindfuck him.", "Owner",
	function ( Player, Trace )
		if Player:GetLevel() != 0 then
			Player:Hint("Nope.");
			return false;
		end
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:ConCommand("pp_sharpen 0; pp_motionblur 0; pp_sobel 0;");
				Player:Hint("Player un-mindfucked.");
			end
	end
);
AddGear(" Flying Car", "Left click to make a car fly.", "Owner",
	function ( Player, Trace )
		if Player:GetLevel() != 0 then
			Player:Hint("Nope.");
			return false;
		end
		
		if IsValid(Trace.Entity) and Trace.Entity:IsVehicle() then
			Trace.Entity.CanFly = true;
			Player:Hint("You are now the proud owner of a flying car.");
		end
	end
);

AddGear(" Hiroshima", "Aim at any object to KuhBewm it.", "Owner",
	function ( Player, Trace )
			if Player:GetLevel() != 0 then
				Player:Hint("You aren't epic enough to blow shit up");
				return false;
			end
		local explode = ents.Create("env_explosion");
		local eyetrace = Player:GetEyeTrace();
			if IsValid(Trace.Entity) then
				if Trace.Entity:IsVehicle() and IsValid(Trace.Entity:GetDriver()) then
					Trace.Entity:GetDriver():ExitVehicle();
				end
				
				umsg.Start("KuhBEWMIE");
					umsg.Entity(Trace.Entity);
				umsg.End();
				
				Trace.Entity:Ignite(10,0)
				explode:SetPos( eyetrace.HitPos ) 
				-- explode:SetOwner( self.Owner ) 
				explode:Spawn() 
				explode:SetKeyValue("iMagnitude","55") 
				-- explode:EmitSound("ambient/explosions/explode_" .. math.random(1, 4) .. ".wav", 400, 100 ) 
				explode:Fire("Explode", 0, 0 ) 
				if Trace.Entity:IsPlayer() then
					Trace.Entity:Kill();
					Trace.Entity:Extinguish();
					--Trace.Entity:SetColor(Color(255,255,255,255))
				else 
					--Trace.Entity:SetColor(Color(100,100,100,255))
				end	
				Player:Hint("Boom.");	
			end
	end
);

AddGear(" Burn", "Aim at an entity to burn it", "Owner",
	function ( Player, Trace )
			if Player:GetLevel() != 0 then
				Player:Hint("Nope.");
				return false;
			end
			if IsValid(Trace.Entity) then
				Trace.Entity:Ignite(600,0)
			end
	end
);

--[[
AddGear("[Council]", "", false,
	function ( Player, Trace )
		if Player:GetLevel() != 0 then
			Player:ChatPrint("This gear requires council status.");
			return false;
		end
		

		//if IsValid(Player) then
		//end;
	end
);
]]
-- alphabetize it so admins can fuckin find stuff
local sort_func = function(a,b)
return a[1] < b[1]
end
table.sort(Gears, sort_func)
function SWEP:Think ( )
	if self.Floater then
			local trace = {}
			trace.start = self.Floater:GetPos()
			trace.endpos = trace.start - Vector(0, 0, 100000);
			trace.filter = { self.Floater }
			local tr = util.TraceLine( trace )
		
		local altitude = tr.HitPos:Distance(trace.start);
		
		local ent = self.Spazzer;
		local vec;
		
		if self.FloatSmart then
			local trace = {}
			trace.start = self.Owner:GetShootPos()
			trace.endpos = trace.start + (self.Owner:GetAimVector() * 400)
			trace.filter = { self.Owner, self.Weapon }
			local tr = util.TraceLine( trace )
			
			vec = trace.endpos - self.Floater:GetPos();
		else
			vec = Vector(0, 0, 0);
		end
		
		if altitude < 150 then
			if vec == Vector(0, 0, 0) then
				vec = Vector(0, 0, 25);
			else
				vec = vec + Vector(0, 0, 100);
			end
		end
		
		vec:Normalize()
		
		if self.Floater:IsPlayer() then
			local speed = self.Floater:GetVelocity()
			self.Floater:SetVelocity( (vec * 1) + speed)
		else
			local speed = self.Floater:GetPhysicsObject():GetVelocity()
			self.Floater:GetPhysicsObject():SetVelocity( (vec * math.Clamp((self.Floater:GetPhysicsObject():GetMass() / 20), 10, 20)) + speed)
		end

	end
end

 // Draw the Crosshair
  local chRotate = 0;
 function SWEP:DrawHUD( )
    --[[if (!CLIENT) then return; end
     local godstickCrosshair = surface.GetTextureID("gui/ocrp/OCRP_Orange");
	 local trace = self.Owner:GetEyeTrace();
	 local x = (ScrW()/2);
	 local y = (ScrH()/2);
					
			draw.WordBox( 8, 10, "Target: " .. tostring(trace.Entity), "Scoreboard", Color(50,50,75,100), Color(255,0,0,255) );
			surface.SetDrawColor(255, 0, 0, 255);
			chRotate = chRotate + 8;
		else
			draw.WordBox( 8, (x-100), 10, "Target: " .. tostring(trace.Entity), "Scoreboard", Color(50,50,75,100), Color(255,255,255,255) );
			surface.SetDrawColor(255, 255, 255, 255);
			chRotate = chRotate + 3;
		
		surface.SetTexture(godstickCrosshair);
		surface.DrawTexturedRectRotated(x, y, 64, 64, 0 + chRotate);
		
	]]
 end
 
 function MonitorWeaponVis ( )
	for k, v in pairs(player.GetAll()) do
		if v:IsAdmin() and IsValid(v:GetActiveWeapon()) then
			local pColor = v:GetColor();
			local wColor = v:GetActiveWeapon():GetColor();
			if pColor.a == 0 and wColor.a == 255 then
				v:GetActiveWeapon():SetRenderMode(RENDERMODE_TRANSALPHA)
				v:GetActiveWeapon():SetColor(Color(wColor.r, wColor.b, wColor.g, 0));
			elseif pColor.a == 255 and wColor.a == 0 then
				v:GetActiveWeapon():SetRenderMode(RENDERMODE_NORMAL)
				v:GetActiveWeapon():SetColor(Color(wColor.r, wColor.b, wColor.g, 255));
			end
		end
		
		--[[
		if v:InVehicle() and v:GetVehicle().CanFly then
			local t, r, a = v:GetVehicle();
			
			if ValidEntity(t) then
				local p = t:GetPhysicsObject();
				a = t:GetAngles();
				r = 180 * ((a.r-180) > 0 && 1 or -1) - (a.r - 180);
				p:AddAngleVelocity(p:GetAngleVelocity() * -1 + Angle(a.p * -1, 0, r));
			end
		end
		]]
	end
 end
 hook.Add('Think', 'MonitorWeaponVis', MonitorWeaponVis);
 
--[[function MonitorKeysForFlymobile ( Player, Key )
	if Player:InVehicle() and Player:GetVehicle().CanFly then
		local Force;
		
		if Key == IN_ATTACK then
			Force = Player:GetVehicle():GetUp() * 150000;
		elseif Key == IN_ATTACK2 then
			Force = Player:GetVehicle():GetForward() * 100000;
		end
		
		if Force then
			Player:GetVehicle():GetPhysicsObject():ApplyForceCenter(Force);
		end
	end
 end
 hook.Add('KeyPress', 'MonitorKeysForFlymobile', MonitorKeysForFlymobile);]]
 
 if SERVER then
	  function GodSG ( Player, Cmd, Args )
			Player:GetTable().CurGear = tonumber(Args[1]);
	  end
	  concommand.Add('god_sg', GodSG);
 end
 
 timer.Simple(.5, function () GAMEMODE.StickText = Gears[1][1] .. ' - ' .. Gears[1][2] end);
 
  --[[---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
  ---------------------------------------------------------]]
function SWEP:SecondaryAttack()	
    if SERVER then return false; end
    
    local MENU = DermaMenu()
    
    for k, v in pairs(Gears) do
        local Title = v[1];
        
        if v[3] and self.Owner:GetLevel() > 1 then
            continue
        end
        if v[3] == "Owner" and self.Owner:GetLevel() >= 1 then
            continue
        end
        
        MENU:AddOption(Title, 	function()
                                    RunConsoleCommand('god_sg', k) 
                                    OCRP_AddHint(v[2]);
                                    GAMEMODE.StickText = v[1] .. ' - ' .. v[2];
                                end )
    end
    
    MENU:Open( 100, 100 )	
    gui.SetMousePos( 110, 110 )

end

if CLIENT then
    hook.Add("HUDPaint", "OCRP_PaintAdminMode", function()
        if LocalPlayer():GetNWBool("AdminMode", false) then
            draw.SimpleText("You are in Admin Mode.", "SpeedLimit", ScrW()/2, 20, Color(255,0,0,255), TEXT_ALIGN_CENTER)
        end
    end)
end
  
 --[[function TryRevive ()
	//if !LocalPlayer():IsSuperAdmin() then return false; end
	
	local EyeTrace = LocalPlayer():GetEyeTrace();
	
 			for k, v in pairs(player.GetAll()) do
				if !v:Alive() then
					for _, ent in pairs(ents.FindInSphere(EyeTrace.HitPos, 5)) do						
						if ent == v:GetRagdollEntity() then
							RunConsoleCommand('perp_m_h', v:UniqueID());
							LocalPlayer():PrintMessage(HUD_PRINTTALK, "Player revived.");
							return;
						end
					end
				end
			end
 end
 usermessage.Hook('god_try_revive', TryRevive);]]
