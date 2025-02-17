local script_active = true
local draw = {}

RegisterNUICallback('NUI:OFF', function(data, cb)
	SetNuiFocus(false,false)
    SendNUIMessage({
        type = "off"
    })
end)

RegisterNetEvent("Open:Case")
AddEventHandler("Open:Case", function(data)
	local sum = 0
	draw = {}
	for k, v in pairs(Config.Case[data].list) do
		local rate = Config.Chance[v.tier].rate * 100
		for i=1,rate do 
			if v.item then
				if v.amount then
					table.insert(draw, {item = v.item ,amount = v.amount, tier = v.tier})
				else
					table.insert(draw, {item = v.item ,amount = 1, tier = v.tier})
				end
			elseif v.weapon then
				table.insert(draw, {weapon = v.weapon , tier = v.tier})
			elseif v.vehicle then
				table.insert(draw, {vehicle = v.vehicle, tier = v.tier})
			elseif v.money then
				table.insert(draw, {money = v.money, tier = v.tier})
			elseif v.black_money then
				table.insert(draw, {black_money = v.black_money, tier = v.tier})
			end
			i = i + 1
		end
		sum = sum + rate
	end
	local random = math.random(1,sum)
	SetNuiFocus(true,true)
	SendNUIMessage({
        type = "ui",
		data = Config.Case[data].list,
		img = Config["image_source"],
		win = draw[random]
    })
	Wait(9000)
	if draw[random].item then
		TriggerServerEvent('mkbuss:giveReward', 'item',draw[random].item,draw[random].amount)
	elseif draw[random].weapon then
		TriggerServerEvent('mkbuss:giveReward', 'weapon',draw[random].weapon)
	elseif draw[random].vehicle then
		give_vehi(draw[random].vehicle)
	elseif draw[random].money then
		TriggerServerEvent('mkbuss:giveReward', 'money',draw[random].money)
	elseif draw[random].black_money then
		TriggerServerEvent('mkbuss:giveReward', 'black_money',draw[random].black_money)
	end
end)