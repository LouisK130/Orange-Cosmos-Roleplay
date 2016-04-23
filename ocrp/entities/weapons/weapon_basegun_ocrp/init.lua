AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

SWEP.Weight				= 5			// Decides whether we should switch from/to this
SWEP.AutoSwitchTo		= true		// Auto switch to if we pick it up
SWEP.AutoSwitchFrom		= true		// Auto switch from if you pick up a better weapon

function SWEP:OnRestore()
end
function SWEP:AcceptInput( name, activator, caller, data )
	return false
end
function SWEP:KeyValue( key, value )
end
function SWEP:OnRemove()
end

function SWEP:Equip( NewOwner )
end
function SWEP:EquipAmmo( NewOwner )
end
function SWEP:OnDrop()
end
function SWEP:ShouldDropOnDie()
	return true
end
function SWEP:GetCapabilities()
	return CAP_WEAPON_RANGE_ATTACK1 or CAP_INNATE_RANGE_ATTACK1
end
function SWEP:NPCShoot_Secondary( ShootPos, ShootDir )
	self:SecondaryAttack()
end
function SWEP:NPCShoot_Primary( ShootPos, ShootDir )
	self:PrimaryAttack()
end

function SWEP:TossWeaponSound ( )
	--[[
	if string.find(string.gsub(self.Primary.Sound, ".wav", ""), ".") then
		self.Weapon:EmitSound(self.Primary.Sound);
	else
	]]
		umsg.Start('re_wep');
			umsg.Entity(self);
			umsg.String(self.Primary.Sound);
		umsg.End();
	//end
end

// These tell the NPC how to use the weapon
AccessorFunc( SWEP, "fNPCMinBurst", 		"NPCMinBurst" )
AccessorFunc( SWEP, "fNPCMaxBurst", 		"NPCMaxBurst" )
AccessorFunc( SWEP, "fNPCFireRate", 		"NPCFireRate" )
AccessorFunc( SWEP, "fNPCMinRestTime", 	"NPCMinRest" )
AccessorFunc( SWEP, "fNPCMaxRestTime", 	"NPCMaxRest" )
