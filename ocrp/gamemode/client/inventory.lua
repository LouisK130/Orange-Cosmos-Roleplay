function GM:OnContextMenuOpen()
	RunConsoleCommand("OCRP_EmptyCurWeapon")
end

function CL_HasItem(item,amount)
	
	if amount == nil then amount = 1 end
	if OCRP_Inventory[item] == nil then return false end
	if OCRP_Inventory[item] >= amount then
		return true
	end
	return false
end

function CL_HasRoom(item, amount)
    local have = OCRP_Inventory[item] or 0
    if amount == nil then amount = 1 end
    local max = GAMEMODE.OCRP_Items[item].Max
    
    if max then
        if have+amount > max then
            return false
        end
    end
    local weight = OCRP_Inventory["WeightData"].Cur
    local newweight = GAMEMODE.OCRP_Items[item].Weight * amount
    if weight+newweight > OCRP_Inventory["WeightData"].Max then
        return false
    end
    return true
end

function CL_UpdateItem( item, amount, weightcur, weightmax )
	
	OCRP_Inventory.WeightData = {Cur = tonumber(weightcur),Max = tonumber(weightmax)}
	OCRP_Inventory[tostring(item)] = tonumber(amount)
	
    if OCRP_MAINMENU and OCRP_MAINMENU:IsValid() and OCRP_MAINMENU.tab == "Inventory" then
        local scroll = 0
        for k,v in pairs(OCRP_MAINMENU.CurrentChildren) do
            if v.VBar and v.VBar:IsValid() then
                scroll = v.VBar.Scroll
            end
        end
        ChooseInventoryTab(OCRP_MAINMENU, scroll or 0)
    end
    
    if OCRP_SHOPMENU and OCRP_SHOPMENU:IsValid() then
        local scroll = 0
        if OCRP_SHOPMENU.inv.VBar and OCRP_SHOPMENU.inv.VBar:IsValid() then
            scroll = OCRP_SHOPMENU.inv.VBar.Scroll or 0
        end
        PopulateInventoryContainer(OCRP_SHOPMENU.inv, OCRP_SHOPMENU.shopid, scroll)
    end
    
    if OCRP_CRAFTINGMENU and OCRP_CRAFTINGMENU:IsValid() then
        local scroll = 0
        if OCRP_CRAFTINGMENU.itemList.VBar and OCRP_CRAFTINGMENU.itemList.VBar:IsValid() then
            scroll = OCRP_CRAFTINGMENU.itemList.VBar.Scroll or 0
        end
        OCRP_CRAFTINGMENU:Layout(scroll)
    end
    
end
net.Receive("OCRP_UpdateItem", function()
    CL_UpdateItem(net.ReadString(), net.ReadInt(32), net.ReadInt(32), net.ReadInt(32))
end)