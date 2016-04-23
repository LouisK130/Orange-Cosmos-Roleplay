# Orange Cosmos Roleplay (OCRP)
An updated version of the old Garry's Mod gamemode run initially by Orange Cosmos and later by Catalyst Gaming. This version is based on the [code released publicly on Facepunch](https://facepunch.com/showthread.php?t=1090021) by the original creator.

This was a Lua learning project for me. As such, do not expect perfection. Issues are definitely present, but if you report them I'll do my best to fix. I didn't intend initially to release this, but I don't have the time to run it on a server and it feels a waste not to share. I'm also happy to accept pull requests.

Requires:
* VCMod
* VCMod ELS
* ULX
* ULib
* [OCRP Content Pack](http://www.mediafire.com/download/ao9qdqspov18xae/ocrp-content.zip) (on client and server)
* MySQL Database
* mysqloo module
* [rp_evocity_v4b1](http://www.mediafire.com/download/n05bdy0y1t5cabc/RP_EvoCity_v4b1.zip) (could be adapted for other maps with basic knowledge of Lua)

Recommended:
* Atmos Weather
* Some anticheat


Notes:
* The messages that display periodically can be modified in server/messages.lua
* The artwork is all for a community I ran called ZetaGaming, you'll have to edit it yourself if you want it to be different.

You need to create two SQL tables with the following structures:
```
CREATE TABLE `DATABASE`.`ocrp_users` (
  `STEAM_ID` tinytext,
  `nick` text,
  `org_id` smallint(6) NOT NULL,
  `cars` mediumtext,
  `wallet` bigint(20) NOT NULL,
  `bank` bigint(20) NOT NULL,
  `inv` mediumtext,
  `skills` text,
  `wardrobe` text,
  `face` text,
  `storage` text,
  `playtime` int(11) NOT NULL,
  `model` text,
  `refedby` tinytext,
  `blacklist` text,
  `buddies` text,
  `org_notes` text,
  `itembank` mediumtext
) ENGINE=InnoDB;
```
```
CREATE TABLE `DATABASE`.`ocrp_orgs` (
  `orgid` int(11) NOT NULL,
  `owner` tinytext,
  `name` tinytext,
  `applicants` text,
  `lastactivity` int(11) NOT NULL,
  `perks` text
) ENGINE=InnoDB;
```

Here's a recommended setup for ULib groups (garrysmod/data/ulib/groups.txt)
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
