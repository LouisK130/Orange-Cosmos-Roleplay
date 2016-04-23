util.AddNetworkString("BuyItem")
util.AddNetworkString("SellItem")
util.AddNetworkString("PriceItem")

function SV_BuyItem(ply,item,ShopId,amt)
	if ply:InVehicle() then return false end
	if amt then
		if amt == 0 and item == "item_physgun" then
			return false
		end
	end
	local bool = false

	for _,v in pairs(GAMEMODE.OCRP_Shops[ShopId].Items) do 
		if v == item then 
			bool = true
		end
	end
	local price1 = GAMEMODE.OCRP_Items[item].Price * amt
    local taxes = price1 * GetGlobalInt("Eco_Tax")/100
	local price = price1
    if GAMEMODE.OCRP_Shops[ShopId].NoTax then
        taxes = 0
    end
    price = price1 + taxes
	if bool then
		if ply:GetMoney(WALLET) < price then
			ply:Hint("You don't have enough money in your wallet for that!")
			return
		end
		if !ply:HasRoom(item,amt) then
			ply:Hint("You don't have room for that!")
			return
		end
		if ply:ExceedsMax(item, amt) then
			ply:Hint("You can't carry so much of this item!")
			return
        end
        SV_PrintToAdmin(ply, "BUY_NPC_ITEM", "purchased " .. tostring(amt) .. " of " .. tostring(item) .. " for $" .. price)
		ply:GiveItem(item,amt)
        ply:Hint("You purchased " .. tostring(amt) .. " of " .. GAMEMODE.OCRP_Items[item].Name .. " for $" .. price)
        if taxes > 0 then
            ply:Hint("$" .. taxes .. " of your purchase went to the city in taxes.")
        end
		ply:TakeMoney(WALLET,(price))
        if not GAMEMODE.OCRP_Shops[ShopId].NoTax then
            Mayor_AddMoney(taxes)
        end
	end
end
net.Receive("BuyItem", function(len, ply)
	SV_BuyItem(ply,tostring(net.ReadString()),tonumber(net.ReadInt(32)), math.Round(net.ReadInt(32)))
end)


function SV_SellItem(ply,item,ShopId,amount) 

	if ply:InVehicle() then return false end
	
	local bool = false
	for k, v in pairs(ents.FindInSphere(ply:GetPos(), 100)) do
		if v:IsNPC() then
			if v.Id == ShopId then
				bool = true
			end
		end
	end
	if ply:HasItem(item,tonumber(amount)) && bool then
		ply:RemoveItem(item,tonumber(amount))
        local price = GAMEMODE.OCRP_Items[item].Price * GAMEMODE.OCRP_Shops[ShopId].PriceScale.Buying * tonumber(amount)
        SV_PrintToAdmin(ply, "SELL_NPC_ITEM", "sold " .. tostring(amount) .. " of " .. tostring(item) .. " for $" .. price)
		ply:AddMoney(WALLET,price)
        ply:Hint("You sold " .. tostring(amount) .. " of " .. GAMEMODE.OCRP_Items[item].Name .. " for $" .. price)
	end
end
net.Receive("SellItem", function(len, ply)  
	SV_SellItem(ply,net.ReadString(),tonumber(net.ReadInt(32)),math.Round(net.ReadInt(32)))
end)

function META:PriceItem(price,desc)
	local num = 0
	local multi = 1
	local owner = player.GetByID(self:GetNWInt("Owner"))
	if owner:GetLevel() <= 3 then 
		multi = 2
	end
	for _,ent in pairs(ents.FindByClass("item_base")) do 
		if self:GetNWInt("Owner") == ent:GetNWInt("Owner") && ent.price != nil && ent.desc != nil then
			num = num + 1
		end
	end
	if num >= math.Round(OCRPCfg["Shop_Limit"]*multi) then
		player.GetByID(self:GetNWInt("Owner")):Hint("You have hit the priced item limit.")
		return
	end	
    if self.Drug then
        player.GetByID(self:GetNWInt("Owner")):Hint("You cannot price a pot with drugs in it.")
        return
    end
	self.DropTime = 0
	self.price = price
	self.desc = desc
	for _,ply in pairs(player.GetAll()) do
		if ply:IsValid() then
			local amt = 0
			if self.Amount != nil && tonumber(self.Amount) > 1 then
				amt = self.Amount
			else
				amt = 1
			end		
			umsg.Start("CL_PriceItem", ply)
				umsg.Bool(false)
				umsg.Entity(self)
				umsg.Long(tonumber(price))
				umsg.String(tostring(desc))
				umsg.Long(amt)
			umsg.End()
		end
	end
end
net.Receive("PriceItem", function(len, ply)
	ents.GetByIndex(math.Round(net.ReadInt(32))):PriceItem(tonumber(math.Round(net.ReadInt(32))),tostring(net.ReadString()))
end)
