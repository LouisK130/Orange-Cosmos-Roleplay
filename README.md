# Orange-Cosmos-Roleplay
An updated version of the old Garry's Mod gamemode

This was a Lua learning project for me. As such, do not expect perfection. Issues are definitely present, but if you report them I'll do my best to fix. I didn't intend initially to release this, but I don't have the time to run it on a server and it feels a waste not to share. I'm also happy to accept pull requests.

Requires:
* VCMod
* VCMod ELS
* ULX
* ULib
* OCRP Content Pack
* MySQL Database
* mysqloo module
* rp_evocity_v4b1 (could be adapted for other maps with basic knowledge of Lua)

Recommended:
* Atmos Weather
* Some anticheat


Notes:
* The messages that display periodically can be modified in server/messages.lua
* The artwork is all for a community I ran called ZetaGaming, you'll have to edit it yourself if you want it to be different.

You need to create two SQL tables with the following structures
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
