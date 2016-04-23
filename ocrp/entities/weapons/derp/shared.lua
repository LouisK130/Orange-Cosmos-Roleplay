if( SERVER ) then
 
        AddCSLuaFile( "shared.lua" );
 
end
 
if( CLIENT ) then
 
        SWEP.PrintName = "El Palo De Dios";
        SWEP.Slot = 0;
        SWEP.SlotPos = 5;
        SWEP.DrawAmmo = false;
        SWEP.DrawCrosshair = true;
 
end
 
// Variables that are used on both client and server
 
SWEP.Author               = "huntsypoo"
SWEP.Instructions       = "Left click to fire, right click to change"
SWEP.Contact        = ""
SWEP.Purpose        = ""
 
SWEP.ViewModelFOV       = 62
SWEP.ViewModelFlip      = false
SWEP.AnimPrefix  = "stunstick"
 
SWEP.Spawnable      = false
SWEP.AdminSpawnable          = true
SWEP.HoldType	= "melee"
 
SWEP.NextStrike = 0;
  
SWEP.ViewModel = Model( "models/weapons/v_stunstick.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_stunbaton.mdl" );
  
SWEP.Sound = Sound( "weapons/stunstick/stunstick_swing1.wav" );
SWEP.Sound1 = Sound( "npc/metropolice/vo/moveit.wav" );
SWEP.Sound2 = Sound( "npc/metropolice/vo/movealong.wav" );
 
SWEP.Primary.ClipSize      = -1                                   // Size of a clip
SWEP.Primary.DefaultClip        = 0                    // Default number of bullets in a clip
SWEP.Primary.Automatic    = false            // Automatic/Semi Auto
SWEP.Primary.Ammo                     = ""
 
SWEP.Secondary.ClipSize  = -1                    // Size of a clip
SWEP.Secondary.DefaultClip      = 0            // Default number of bullets in a clip
SWEP.Secondary.Automatic        = false    // Automatic/Semi Auto
SWEP.Secondary.Ammo               = ""
 
 
 
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

local WARNINGS = {
	"An admin thinks you're being retarded. Cease this faggotry at once!",
	"Whatever it is you're doing now, stop.",
	"It appears you have incurred the wrath of an admin. Shape up or be punished.",
	"Apparently you're being a gigantic faggot. Stop it",
	"Stop being a minge, otherwise you shall be filled to the brim with lawnmower oil.",
	"I think you need to learn to RP properly."
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
		if !self.Owner:IsAdmin() then
			self.Owner:Kick("Your plan was flawed.");
			return false;
		end
 
        self.Owner:SetAnimation( PLAYER_ATTACK1 );
		
		local r, g, b, a = self.Owner:GetColor();
		
		if a != 0 then
			self.Weapon:EmitSound( self.Sound );
		end
		
        self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
 
        self.NextStrike = ( CurTime() + .3 );
        
        if( CLIENT ) then return; end
 
        local trace = self.Owner:GetEyeTrace();
        
        local Gear = self.Owner:GetTable().CurGear or 1;
		
		if Gears[Gear][3] and !self.Owner:IsSuperAdmin() then
			self.Owner:Hint("This gear requires Super Admin status.");
			return false;
		end
		
		Gears[Gear][4](self.Owner, trace);
  end
  

  local function AddGear ( Title, Desc, SA, Func )
		table.insert(Gears, {Title, Desc, SA, Func});
  end
AddGear("Kill Player", "Aim at a player to slay him.", false,
	function ( Player, Trace )
		if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
			Trace.Entity:EmitSound("npc/partyescort.wav",75,100)
			Trace.Entity:Kill();
			Player:Hint("Player killed.");
		end
	end
);

AddGear("Slap Player", "Aim at an entity to slap him.", false,
	function ( Player, Trace )
				if !Trace.Entity:IsPlayer() then
					local RandomVelocity = Vector( math.random(5000) - 2500, math.random(5000) - 2500, math.random(5000) - (5000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:GetPhysicsObject():SetVelocity( RandomVelocity )
					Player:Hint("Entity slapped.");
				else
					local RandomVelocity = Vector( math.random(500) - 250, math.random(500) - 250, math.random(500) - (500 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:SetVelocity( RandomVelocity )
					Player:Hint("Player slapped.");
				end
	end
);

AddGear("Warn Player", "Aim at a player to warn him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				local RandomWarn = WARNINGS[ math.random(#WARNINGS) ]
				Trace.Entity:Hint( RandomWarn );
				Player:Hint("Player warned.");
			end
	end
);

AddGear("Kick Player", "Aim at a player to kick him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:Kick("Consider this a warning.");
				Player:Hint("Player kicked.");
			elseif Trace.Entity:IsVehicle() and IsValid(Trace.Entity:GetDriver()) then
				Player:Hint("Driver kicked")
				Trace.Entity:GetDriver():Kick("Your driving is utter shit. Consider this a warning!");
			end
	end
);

AddGear("Un-Handcuff Player", "Aim at a player to un-handcuff him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				if Trace.Entity:GetNWBool("Handcuffed") then
					Trace.Entity:SetNWBool("Handcuffed", false)
					Player:Hint("You Un-Handcuffed "..Trace.Entity:Nick())
				end
			end
	end
);

AddGear("Force Hands", "Force a player to use their hands.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:SelectWeapon("weapon_idle_hands_ocrp")
				Trace.Entity:Hint("Use your hands for everyday things.")
			end
	end
);

AddGear("Info", "Prints info about the player you're targeting.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Player:PrintMessage(HUD_PRINTCONSOLE,"Name: "..Trace.Entity:Nick())
				Player:PrintMessage(HUD_PRINTCONSOLE,"SteamID: "..Trace.Entity:SteamID())
				Player:PrintMessage(HUD_PRINTCONSOLE,"Team: "..team.GetName(Trace.Entity:Team()))
				Player:PrintMessage(HUD_PRINTCONSOLE,"Kills: "..Trace.Entity:Frags())
				Player:PrintMessage(HUD_PRINTCONSOLE,"Deaths: "..Trace.Entity:Deaths())
				if Trace.Entity:GetLevel() == 0 then
					Player:PrintMessage(HUD_PRINTCONSOLE,"Rank: Owner")
				elseif Trace.Entity:GetLevel() == 1 then
					Player:PrintMessage(HUD_PRINTCONSOLE,"Rank: Super Admin")
				elseif Trace.Entity:GetLevel() == 2 then
					Player:PrintMessage(HUD_PRINTCONSOLE,"Rank: Admin")
                elseif Trace.Entity:GetLevel() == 3 then
                    Player:PrintMessage(HUD_PRINTCONSOLE, "Rank: Elite")
				elseif Trace.Entity:GetLevel() == 4 then
					Player:PrintMessage(HUD_PRINTCONSOLE,"Rank: VIP")
				else
                    Player:PrintMessage(HUD_PRINTCONSOLE,"Rank: Regular")
				end
				Player:PrintMessage(HUD_PRINTCONSOLE,"HP: " ..Trace.Entity:Health())
				Player:PrintMessage(HUD_PRINTCONSOLE,"Model: "..Trace.Entity:GetModel())	
				if Player:GetLevel() <=1 then
					Player:PrintMessage(HUD_PRINTCONSOLE,"IP/Port: "..Trace.Entity:IPAddress())
				else return end
				Player:PrintMessage(HUD_PRINTCONSOLE," ")
			elseif IsValid(Trace.Entity) and Trace.Entity:GetClass()=="item_base" then
				Player:PrintMessage(HUD_PRINTCONSOLE,"OWNER:"..Trace.Entity:GetNWInt("Owner"):Nick())
			end
	end
);


AddGear("Issue Hands/Keys", "Re-equips target with hands and keys.", false,
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

AddGear("Break Vehicle", "Aim at a vehicle to break it.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:GetClass() == "prop_vehicle_jeep" then
				if Trace.Entity:IsVehicle() and IsValid(Trace.Entity:GetDriver()) then
					Trace.Entity:GetDriver():ExitVehicle();
				end
				GAMEMODE.DoBreakdown( Trace.Entity, true )
				Trace.Entity:SetColor(120,120,120,255)
				Player:Hint("You have disabled this car")
			end
	end
);

AddGear("Repair Vehicle", "Aim at a vehicle to repair it.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:GetClass() == "prop_vehicle_jeep" then
				OCRP_FixCar( Player, Trace.Entity )
				Trace.Entity:SetColor(255,255,255,255)
				Trace.Entity:Fire('turnon', '', .5)
			end
	end
);

AddGear("Teleport", "Teleports you to a targeted location.", false,
	function ( Player, Trace )
		local EndPos = Player:GetEyeTrace().HitPos;
		local CloserToUs = (Player:GetPos() - EndPos):Angle():Forward();
		
		Player:SetPos(EndPos + (CloserToUs * 20));
		Player:Hint("Teleported.");
	end
);

AddGear("Un-Mindfuck", "Aim at a player to un-mindfuck him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:ConCommand("pp_sharpen 0; pp_motionblur 0; pp_sobel 0;");
				Player:Hint("Player un-mindfucked. :)");
			end
	end
);


AddGear("Extinguish", "Aim at a burning entity to unburn it", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:Extinguish()
				Trace.Entity:SetColor(255,255,255,255)
				Player:Hint("Extinguished");
			end
	end
);

AddGear("Unfreeze (Prop)", "Aim at an entity to unfreeze it", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:GetPhysicsObject():EnableMotion( true )
				Trace.Entity:GetPhysicsObject():Wake()
				Player:Hint("Unfrozen");
			end
	end
);

--[[AddGear("Assplode", "Aim at an entity to explode it", false,
	function ( Player, Trace )
		local explode = ents.Create("env_explosion");
		local eyetrace = Player:GetEyeTrace();
			if IsValid(Trace.Entity) then
				Trace.Entity:Ignite(10,0)
				explode:SetPos( eyetrace.HitPos ) 
				--explode:SetOwner( self.Owner ) 
				explode:Spawn() 
				explode:SetKeyValue("iMagnitude","75") 
				explode:EmitSound("ambient/explosions/explode_" .. math.random(1, 4) .. ".wav", 400, 100 ) 
				explode:Fire("Explode", 0, 0 ) 
				if Trace.Entity:IsPlayer() then
					Trace.Entity:Kill();
					Trace.Entity:SetColor(255,255,255,255)
				else 
					Trace.Entity:SetColor(100,100,100,255)
				end	
				Player:Hint("Boom.");
			end
	end
);]]


AddGear("Respawn Player", "Aim at a player to respawn him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:Hint("An administrator has respawned you.");
				Trace.Entity:Kill();
				timer.Simple(.5, function ( )
					Trace.Entity:Spawn();
					--end
				end);
				Trace.Entity:EmitSound("vo/heavy_battlecry06.wav",75,100);
				Player:Hint("Player respawned.");
			end
	end
);

AddGear("ENGLISH", "Politely message a player to speak english.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:EmitSound("ocrp/MOTHERFUCK.wav",120,100);
			end
	end
);

AddGear("Unlock Door", "Aim at a door to unlock it.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:Fire('unlock', '', 0);
				Trace.Entity:Fire('open', '', .5);
				Player:Hint("Door unlocked.");
			end
	end
);

AddGear("Lock Door", "Aim at a door to Lock it.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:Fire('close', '', 0);
				Trace.Entity:Fire('lock', '', 0.5);
				Player:Hint("Door locked.");
			end
	end
);

AddGear("Super Slap Player", "Aim at an entity to super slap him.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if !Trace.Entity:IsPlayer() then
					local RandomVelocity = Vector( math.random(50000) - 25000, math.random(50000) - 25000, math.random(50000) - (50000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:GetPhysicsObject():SetVelocity( RandomVelocity )
					Player:Hint("Entity super slapped.");
				else
					local RandomVelocity = Vector( math.random(5000) - 2500, math.random(5000) - 2500, math.random(5000) - (5000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:Hint("WEEEEEEEEEEEEEEEEEEE!");
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:EmitSound("vo/aperture_ai/07_part2_success-1.wav",75,100)
					Trace.Entity:SetVelocity( RandomVelocity )
					Player:Hint("Player super slapped.");
				end
			end
	end
);

AddGear("Handcuff Player", "Aim at a player to handcuff him.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:SetNWBool("Handcuffed",true)
				Trace.Entity:SelectWeapon("weapon_idle_hands_ocrp")
				Player:Hint("You Handcuffed "..Trace.Entity:Nick())
			end
	end
);



--[[AddGear("Disable Car", "Aim at a car to disable it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsVehicle() then
				Trace.Entity:DisableVehicle(true);
				Player:PrintMessage(HUD_PRINTTALK, "Vehicle disabled.");
			end
	end
);

AddGear("Fix Car", "Aim at a disabled car to fix it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsVehicle() then
				Trace.Entity.Disabled = false;
				Trace.Entity:SetColor(255, 255, 255, 255);
				Trace.Entity:Fire('turnon', '', .5)
				Player:PrintMessage(HUD_PRINTTALK, "Vehicle repaired.");
			end
	end
);]]

AddGear("Remover", "Aim at any object to remove it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if Trace.Entity:IsVehicle() then return
				end
				
				if Trace.Entity:IsPlayer() then
					Trace.Entity:Kill();
				else
					Trace.Entity:Remove();
				end
			end
	end
);




AddGear("Freeze", "Target a player to change his freeze state.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				if Trace.Entity.IsFrozens then
					Trace.Entity:Freeze(false);
					Player:Hint("Player unfrozen.");
					Trace.Entity:PrintMessage(HUD_PRINTTALK, "You have been unfrozen.");
					Trace.Entity.IsFrozens = nil;
				else
					Trace.Entity.IsFrozens = true;
					Trace.Entity:Freeze(true);
					Player:Hint("Player frozen.");
					Trace.Entity:PrintMessage(HUD_PRINTTALK, "You have been frozen.");
				end
			end
	end
);

AddGear("Invisiblity", "Left click to go invisible. Left click again to become visible again.", true,
	function ( Player, Trace )
		local r, g, b, a = Player:GetColor();
		
		if a == 255 then
			Player:Hint("You are now invisible.");
			Player:SetColor(255, 255, 255, 0);
		else
			Player:Hint("You are now visible again.");
			Player:SetColor(255, 255, 255, 255);
		end
	end
);

--[[AddGear("Explode ( No Damage )", "Aim at any object to explode it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if Trace.Entity:IsVehicle() and IsValid(Trace.Entity:GetDriver()) then
					Trace.Entity:GetDriver():ExitVehicle();
				end
				
				umsg.Start('Assplode');
					umsg.Entity(Trace.Entity);
				umsg.End();
				
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

AddGear("[O] Mindfuck", "Aim at a player to mindfuck him.", false,
	function ( Player, Trace )
			if Player:GetLevel() != 0 then
				Player:Hint("This gear requires Owner status.");
				return false;
			end
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:ConCommand("pp_sharpen 1; pp_sharpen_contrast 20; pp_sharpen_distance -100; pp_motionblur 1; pp_motionblur_addalpha 0.2; pp_sobel 1; pp_sobel_threshold 0.35");
				Player:Hint("Player mindfucked. :D");
			end
	end
);

AddGear("[O] RickRoll", "Aim at a player to RickRoll him.", false,
	function ( Player, Trace )
			if Player:GetLevel() != 0 then
				Player:Hint("This gear requires Owner status.");
				return false;
			end
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:EmitSound("ocrp/rick_v2.mp3",70,100);
				Player:Hint("Player rickrolled. :D");
			end
	end
);

AddGear("[O] Telekinesis ( Stupid )", "Left click to make it float.", false,
	function ( Player, Trace )
		if Player:GetLevel() != 0 then
			Player:Hint("This gear requires Owner status.");
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

AddGear("[O] Telekinesis ( Smart )", "Left click to make it float and follow your crosshairs.", false,
	function ( Player, Trace )
		if Player:GetLevel() != 0 then
			Player:Hint("This gear requires Owner status.");
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

AddGear("Player Remover", "Make em crash.", false,
	function ( Player, Trace )
			if Player:GetLevel() != 0 then
				Player:Hint("This gear requires Owner status.");
				return false;
			end
			if IsValid(Trace.Entity) then
				if Trace.Entity:IsPlayer() and !Trace.Entity:IsAdmin() then
					Trace.Entity:Remove();
				else
					return
				end
			end
	end
);


AddGear("KuhBewm", "Aim at any object to KuhBewm it.", false,
	function ( Player, Trace )
			if Player:GetLevel() != 0 then
				Player:Hint("This gear requires Owner status.");
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
					Trace.Entity:SetColor(255,255,255,255)
				else 
					Trace.Entity:SetColor(100,100,100,255)
				end	
				Player:Hint("Boom.");	
			end
	end
);
AddGear("Burn", "Aim at an entity to burn it", false,
	function ( Player, Trace )
			if Player:GetLevel() != 0 then
				Player:Hint("This gear requires Owner status.");
				return false;
			end
			if IsValid(Trace.Entity) then
				Trace.Entity:Ignite(15,0)
				Player:Hint("IT BURRRNNSSS!!");
			end
	end
);

AddGear("Burn (2.5 min.)", "Aim at an entity to burn it", false,
	function ( Player, Trace )
			if Player:GetLevel() != 0 then
				Player:Hint("This gear requires Owner status.");
				return false;
			end
			if IsValid(Trace.Entity) then
				Trace.Entity:Ignite(150,0)
				Player:Hint("IT BURRRNNSSS!!");
			end
	end
);

AddGear("Burn (10 min.)", "Aim at an entity to burn it", false,
	function ( Player, Trace )
			if Player:GetLevel() != 0 then
				Player:Hint("This gear requires Owner status.");
				return false;
			end
			if IsValid(Trace.Entity) then
				Trace.Entity:Ignite(600,0)
			end
	end
);

--[[AddGear("Revive Player", "Aim at a corpse to revive the player.", true,
	function ( Player, Trace )
			umsg.Start('god_try_revive', Player);
			umsg.End();
	end
);]]


AddGear("God Mode", "Left click to alternate between god and mortal.", false,
	function ( Player, Trace )
			if Player:GetLevel() != 0 then
				Player:Hint("This gear requires Owner status.");
				return false;
			end
		if Player.IsGod then
			Player.IsGod = false;
			Player:Hint("You are now vulnerable.");
			Player:GodDisable();
		else
			Player.IsGod = true;
			Player:Hint("You are now invulnerable.");
			Player:GodEnable();
		end
	end
);


AddGear("[O] Flying Car", "Left click to make a car fly.", false,
	function ( Player, Trace )
		if Player:GetLevel() != 0 then
			Player:Hint("This gear requires Owner status.");
			return false;
		end
		
		if IsValid(Trace.Entity) and Trace.Entity:IsVehicle() then
			Trace.Entity.CanFly = true;
			Player:Hint("You are now the proud owner of a flying car.");
		end
	end
);

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
			trace.endpos = trace.start + (self.Owner:GetAimVector() * 300)
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
			local speed = self.Floater:GetPhysicsObject():GetVelocity()*1.02
			self.Floater:GetPhysicsObject():SetVelocity( (vec * math.Clamp((self.Floater:GetPhysicsObject():GetMass() / 15), 10, 20)) + speed)
		end
	end
end
 

 function MonitorWeaponVis ( )
	for k, v in pairs(player.GetAll()) do
		if v:IsAdmin() and IsValid(v:GetActiveWeapon()) then
			local pr, pg, pb, pa = v:GetColor();
			local wr, wg, wb, wa = v:GetActiveWeapon():GetColor();
			
			if pa == 0 and wa == 255 then
				v:GetActiveWeapon():SetColor(wr, wg, wb, 0);
			elseif pa == 255 and wa == 0 then
				v:GetActiveWeapon():SetColor(wr, wg, wb, 255);
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
 
 function MonitorKeysForFlymobile ( Player, Key )
	if Player:InVehicle() and Player:GetVehicle().CanFly then
		local Force;
		
		if Key == IN_ATTACK then
			Force = Player:GetVehicle():GetUp() * 450000;
		elseif Key == IN_ATTACK2 then
			Force = Player:GetVehicle():GetForward() * 200000;
		end
		
		if Force then
			Player:GetVehicle():GetPhysicsObject():ApplyForceCenter(Force);
		end
	end
 end
 hook.Add('KeyPress', 'MonitorKeysForFlymobile', MonitorKeysForFlymobile);
 
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
			
			if v[3] then
				Title = "[SA] " .. Title;
			end
			
			MENU:AddOption(Title, 	function()
										RunConsoleCommand('god_sg', k) 
										LocalPlayer():PrintMessage(HUD_PRINTCONSOLE, v[2]);
										GAMEMODE.StickText = v[1] .. ' - ' .. v[2];
									end )
		end
		
		MENU:Open( 100, 100 )	
		timer.Simple( 0, gui.SetMousePos, 110, 110 )
	
	
  end 

