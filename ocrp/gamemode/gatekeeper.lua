require("gatekeeper")
   
 -- The cvar that will act as an additional password  
 local pass_new = CreateConVar("sv_password_new", "", FCVAR_PROTECTED | FCVAR_ChatPrint)  
   
 -- The cvar that will make room for a client if they attempt to join  
 local pass_makeroom = CreateConVar("sv_password_makeroom", "", FCVAR_PROTECTED | FCVAR_ChatPrint)  
   
 
local Allowed_Players_SteamId = {
	--"STEAM_0:0:15117776",-- Kaz
	--"STEAM_0:1:15056821",-- Noobulater
	--"STEAM_0:1:15002540", -- SGT Death, Noobs friend
	--"STEAM_0:1:2105220", -- Kitty, Bekka, Noobs freind
	--"STEAM_0:0:181246", -- Zork, Noobs freind
	--"STEAM_0:1:17465744", -- eyefunk, noobs friend
	--"STEAM_0:0:5300193", -- jake
	--"STEAM_0:0:18691624", -- ::frosty
} 
   
 local function PasswordCheck(name, pass, steam, ip)  
      
     -- To make use of the new error messages, you are forced to  
     -- return a table. Garry's hook module does not support hooks  
     -- that return multiple values, and this is the Next Best Thing.  
     -- Valid return values are booleans and tables following the   
     -- following format: { bool allow [, string reason] }  
     -- The reason will only be used by the module if the client  
     -- is not allowed in the server.  

	for _,steamid in pairs(Allowed_Players_SteamId) do
		if steam == steamid  then
			return true
		end
	end
	 
     if pass_new:GetString() == pass and pass_new:GetString() != "" then  
         -- Since the given password matches the 'new' password  
         -- and the new password has been set, returning true  
         -- will prevent the normal password check code  
         -- from being executed.  
           
         return true  
		 
     elseif pass_makeroom:GetString() == pass and pass_makeroom:GetString() != "" then  
         local players = gatekeeper.GetNumClients().total  
           
         -- There is no need to drop anybody if the server isn't full  
         if players == MaxPlayers() then  
             local dropme = players[math.random(1, players)]  
               
             -- <span class="highlight">Gatekeeper</span> exposes a new function to Lua, <span class="highlight">gatekeeper</span>.Drop,  
             -- which allows for the server to drop a client with a custom reason.  
             -- Unlike using RunConsoleCommand to kick the unwanted player, this  
             -- takes place instantly, and because the maxplayers check takes place  
             -- after the password check, any player that provides this password to  
             -- the server will successfully join, without any error message.  
               
           gatekeeper.Drop(dropme:UserID(), Format("Auto-kicking to make room for '%s'", name))  
         end  
           
         -- Provided password was valid; force success and prevent  
         -- the default password check from being executed.  
           
         return true  
     end  
       
     -- Returning nil will allow the default password check to take place  
     -- and, in the case of this example, check sv_password as well.  
     -- In the event of a custom authentication system in which  
     -- the default check doesn't need to be run at all, simply  
     -- returning false here will suffice.  
     return  
 end  
 //hook.Add("PlayerPasswordAuth", "test", PasswordCheck)  
