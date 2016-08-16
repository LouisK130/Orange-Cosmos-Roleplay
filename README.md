# Orange Cosmos Roleplay (OCRP)
An updated version of the old Garry's Mod gamemode run initially by Orange Cosmos and later by Catalyst Gaming. This version is based on the [code released publicly on Facepunch](https://facepunch.com/showthread.php?t=1090021) by the original creator.

This was a Lua learning project for me. As such, do not expect perfection. Issues are definitely present, but if you report them I'll do my best to fix. I didn't intend initially to release this, but I don't have the time to run it on a server and it feels a waste not to share. I'm also happy to accept pull requests.

## Requires:
* VCMod (Compatible with [1.735](https://scriptfodder.com/scripts/download/21/2229) but not any of the newer versions)
* VCMod ELS (Compatible with [1.123](https://scriptfodder.com/scripts/download/489/2174) but not any of the newer versions)
* [OCRP VCMod Modifications](http://www.mediafire.com/download/wtdws132m9uftua/OCRP_VCMod_Modifications_2.0.zip)
* ULX
* ULib
* [OCRP Content Pack](http://www.mediafire.com/download/c44nhz8mh14whp7/ocrp_content_%28github%29.zip) (on client and server)
* MySQL Database
* [mysqloo module] (https://facepunch.com/showthread.php?t=1515853)
* [rp_evocity_v4b1](http://www.mediafire.com/download/n05bdy0y1t5cabc/RP_EvoCity_v4b1.zip) (could be adapted for other maps with basic knowledge of Lua)

## Recommended:
* Atmos Weather
* Some anticheat


## Notes:
* The messages that display periodically can be modified in server/messages.lua
* The artwork is all for a community I ran called ZetaGaming, you'll have to edit it yourself if you want it to be different.

## Setup:  

1. If you do not have a MySQL server, stop here  

2. Install and update Garry's Mod dedicated server  

3. Add VCMod, VCMod ELS, ULX, and ULib addons to addons folder (Atmos weather optional)  

4. Open addons/vcmod1/lua/autorun/server/VC_Settings.lua and ensure that the settings match those shown in Helpful Snippets section below

4. Download [OCRP VCMod Modifications](http://www.mediafire.com/download/x6767r2gz5fhh9e/OCRP_VCMod_Modifications.zip), unzip, drag and drop both the vcmod1 and vcmod1_els folders into garrysmod/addons

4. Add OCRP Content Pack to server addons folder (materials not necessary if space is tight)  

5. Add rp_evocity_v4b1 to maps folder  

6. Install mysqloo module using instructions at download page  

7. Create a new database on MySQL server named "OCRP" or similar  

8. Create two new tables with the structures below (most SQL clients should have an option to perform a query manually, you can paste in the structures below making sure to replace DATABASE with whatever you named the database in step 7)  

9. Optionally create a new user with privileges limited to these two tables  

10. Open ocrp/gamemode/server/mysql_handle.lua and update the top with your MySQL login information  

11. Open garrysmod/data/ulib/groups.txt and modify to your likings, recommended contents below (make sure to include owner, superadmin, admin, elite, vip, user)  

12. Launch server ensuring rp_evocity_v4b1 is selected map and ocrp selected gamemode  

13. Make sure OCRP Content Pack is installed on client (I recommend you add to a fastdl server but also allow clients to download the zip online somewhere)

14. If you have any problems after this point, make sure you followed the above steps properly and then contact me  

## Helpful Snippets

#### SQL Structures

```
CREATE TABLE `ocrp_users` (
  `STEAM_ID` tinytext NOT NULL,
  `nick` text NOT NULL,
  `org_id` smallint(6) NOT NULL,
  `cars` mediumtext NOT NULL,
  `wallet` bigint(20) NOT NULL,
  `bank` bigint(20) NOT NULL,
  `inv` mediumtext NOT NULL,
  `skills` text NOT NULL,
  `wardrobe` text NOT NULL,
  `face` text NOT NULL,
  `storage` text NOT NULL,
  `playtime` int(11) NOT NULL,
  `model` text NOT NULL,
  `refedby` tinytext NOT NULL,
  `blacklist` text NOT NULL,
  `buddies` text NOT NULL,
  `org_notes` text NOT NULL,
  `itembank` mediumtext NOT NULL
) ENGINE=InnoDB;
```
```
CREATE TABLE `ocrp_orgs` (
  `orgid` int(11) NOT NULL,
  `owner` tinytext NOT NULL,
  `name` tinytext NOT NULL,
  `applicants` text NOT NULL,
  `lastactivity` int(11) NOT NULL,
  `perks` text NOT NULL
) ENGINE=InnoDB;
```
#### VCMod Main settings

```
VC_Settings_Data = {
VC_Enabled = true,

VC_Wheel_Lock = true,
VC_Brake_Lock = true,
VC_Door_Sounds = true,
VC_Truck_BackUp_Sounds = true,
VC_Wheel_Dust = true,
VC_Wheel_Dust_Brakes = true,
VC_Exit_Velocity = true,
VC_Exit_NoCollision = true,
VC_Exhaust_Effect = true,
VC_Passenger_Seats = true,

VC_RepairTool_Speed_M = 1,

VC_Lights = true,
VC_Lights_Night = true,
VC_Lights_HandBrake = false,
VC_Lights_Interior = false,
VC_Lights_Blinker_OffOnExit = false,
VC_HeadLights = true,
VC_LightsOffTime = 300,
VC_HLightsOffTime = 30,
VC_HLights_Dist_M = 0.5,

VC_Cruise_Enabled = true,
VC_Cruise_OffOnExit = true,

VC_Horn_Volume = 1,
VC_Horn_Enabled = true,

VC_NPC_AutoSpawn = false,
VC_NPC_RefundPrice = 75,
VC_NPC_Remove = true,
VC_NPC_Remove_Time = 1000,

VC_Trl_Enabled = false,
VC_Trl_Dist = 200,
VC_Trl_Mult = 1,
VC_Trl_Enabled_Reg = false,

VC_Damage = true,
VC_PhysicalDamage = false,
VC_PhysicalDamage_Mult = 1,
VC_Dmg_Fire_Duration = 30,
VC_Health_Multiplier = 1,
VC_Damage_Expl_Rem = false,
VC_Damage_Expl_Rem_Time = 400,

VC_Reduce_Ply_Dmg_InVeh = false,
VC_Reduce_Ply_Dmg_InVeh_Mult = 1.0,
}
```

#### ULib groups (garrysmod/data/ulib/groups.txt)
```
"owner"	
{
	"allow"	
	{
		"ulx addgroup"
		"ulx adduser"
		"ulx adduserid"
		"ulx banid"
		"ulx cexec"
		"ulx ent"
		"ulx exec"
		"ulx groupallow"
		"ulx groupdeny"
		"ulx hiddenecho"
		"ulx logchat"
		"ulx logdir"
		"ulx logecho"
		"ulx logechocolorconsole"
		"ulx logechocolordefault"
		"ulx logechocoloreveryone"
		"ulx logechocolormisc"
		"ulx logechocolorplayer"
		"ulx logechocolorplayerasgroup"
		"ulx logechocolors"
		"ulx logechocolorself"
		"ulx logevents"
		"ulx logfile"
		"ulx logjoinleaveecho"
		"ulx logspawns"
		"ulx logspawnsecho"
		"ulx luarun"
		"ulx maul"
		"ulx rcon"
		"ulx removegroup"
		"ulx removeuser"
		"ulx removeuserid"
		"ulx renamegroup"
		"ulx setgroupcantarget"
		"ulx stopvote"
		"ulx userallow"
		"ulx userallowid"
		"ulx userdeny"
		"ulx userdenyid"
		"ulx voteecho"
		"xgui_gmsettings"
		"xgui_managebans"
		"xgui_managegroups"
		"xgui_svsettings"
	}
	"inherit_from"	"superadmin"
}
"elite"	
{
	"allow"	
	{
	}
	"can_target"	"elite"
	"inherit_from"	"vip"
}
"admin"	
{
	"allow"	
	{
		"ulx ban"
		"ulx bring"
		"ulx freeze"
		"ulx gag"
		"ulx goto"
		"ulx kick"
		"ulx kickafternamechanges"
		"ulx kickafternamechangescooldown"
		"ulx kickafternamechangeswarning"
		"ulx mute"
		"ulx noclip"
		"ulx reservedslots"
		"ulx return"
		"ulx rslots"
		"ulx rslotsmode"
		"ulx rslotsvisible"
		"ulx seeanonymousechoes"
		"ulx unfreeze"
		"ulx ungag"
		"ulx unmute"
		"ulx who"
	}
	"can_target"	"user"
	"inherit_from"	"user"
}
"superadmin"	
{
	"can_target"	"!%owner"
	"allow"	
	{
		"ulx banid"
		"ulx unban"
		"xgui_managebans"
	}
	"inherit_from"	"admin"
}
"vip"	
{
	"can_target"	"vip"
	"allow"	
	{
	}
	"inherit_from"	"user"
}
"user"	
{
	"allow"	
	{
		"ulx cac"
		"ulx help"
	}
	"can_target"	"user"
}
```
