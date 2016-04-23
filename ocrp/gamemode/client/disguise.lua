DisguisedTable = DisguisedTable or {}

local function AddDisguisedAdmin(um)
	local ply = um:ReadEntity()
    if not ply:IsValid() then return end
	DisguisedTable = DisguisedTable or {}
	DisguisedTable[ply] = ply
end
usermessage.Hook("AddDisAdmin", AddDisguisedAdmin)

local function RemoveDisguisedAdmin(um)
	local ply = um:ReadEntity()
	DisguisedTable = DisguisedTable or {}
	if DisguisedTable and DisguisedTable[ply] then
		DisguisedTable[ply] = nil
	end
end
usermessage.Hook("RemoveDisAdmin", RemoveDisguisedAdmin)

