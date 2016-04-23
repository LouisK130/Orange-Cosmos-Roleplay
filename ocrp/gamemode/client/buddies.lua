OCRP_Buddies = OCRP_Buddies or {}

net.Receive("OCRP_UpdateBuddies", function()
    OCRP_Buddies = net.ReadTable(OCRP_Buddies)
end)

function GetSpecCL( um )
	SpecEnt = um:ReadEntity()
	LocalPlayer().Spec = tostring(um:ReadBool())
end
usermessage.Hook("Spec", GetSpecCL)

function GetSpecEndCL( um )
	SpecEnt = nil
	LocalPlayer().Spec = nil
end
usermessage.Hook("SpecEnd", GetSpecEndCL)

LocalPlayer().Energy = 100
LocalPlayer().ChargeInt = 0

function CL_GetChargeInt()
	if LocalPlayer().ChargeInt == nil then
		LocalPlayer().ChargeInt = 0
	end
	return LocalPlayer().ChargeInt or 0
end

function CL_GetEnergy()
	LocalPlayer().Energy = LocalPlayer():GetNWInt("Energy")
	return LocalPlayer().Energy
end

function CL_SetEnergy( ZeAmt )
	LocalPlayer().Energy = ZeAmt
	LocalPlayer():SetNWInt("Energy", ZeAmt)
end

function UM_GetForceWalkCL( umsg )
	LocalPlayer().ForceWalk = umsg:ReadBool()
end
usermessage.Hook("inhib_forcewalk", UM_GetForceWalkCL)

function GetForceWalk()
	return LocalPlayer().ForceWalk or false
end

function CL_ResetEnergy( umsg )
	LocalPlayer().Energy = umsg:ReadLong()
end
usermessage.Hook("spawning_energy", CL_ResetEnergy)

function CL_GetSodaCL( umsg )
	CL_SetEnergy( umsg:ReadLong() )
end
usermessage.Hook("soda_energy", CL_GetSodaCL)

function CL_SprintDecay(ply, data)
	if ply:KeyPressed(IN_JUMP) && ply:OnGround() then
		if CL_GetEnergy() > 10 then
			if CL_HasSkill("skill_acro",2) then
				CL_SetEnergy(CL_GetEnergy() - 5)
			else
				CL_SetEnergy(CL_GetEnergy() - 10)
			end
		else
			CL_SetEnergy(0)
		end
	end
	if GetForceWalk() == true then
		return
	end
	if ply:KeyDown(IN_SPEED) && ply:OnGround() && !GetForceWalk() then
		if math.abs(data:GetForwardSpeed()) > 0 || math.abs(data:GetSideSpeed()) > 0 then
		--	data:SetMoveAngles(data:GetMoveAngles())
		--	data:SetSideSpeed(data:GetSideSpeed()* 0.1)
		--	data:SetForwardSpeed(data:GetForwardSpeed())
			if CL_GetEnergy() > 0 && CL_GetChargeInt() <= CurTime()  then
				CL_SetEnergy(CL_GetEnergy() - 1)
				LocalPlayer().ChargeInt = CurTime() + 0.05
			end
		end
	else
		if CL_GetEnergy() < 100 && CL_GetChargeInt() <= CurTime() then
			CL_SetEnergy(CL_GetEnergy() + 1)
			LocalPlayer().ChargeInt = CurTime() + 1
		end
	end
	if CL_GetEnergy() > 0 && !LocalPlayer().CanSprint then
		LocalPlayer().CanSprint = true
	elseif CL_GetEnergy() <= 0 && LocalPlayer().CanSprint  then
		LocalPlayer().CanSprint = false
		LocalPlayer().ChargeInt = CurTime() + 5
	end
end
hook.Add("Move", "CL_SprintDecay",  CL_SprintDecay)
