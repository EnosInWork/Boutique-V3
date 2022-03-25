local script_active = true
ESX = nil
local draw = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end	
end)


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

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomNumber(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ''
    end
end

function GetRandomLetter(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ''
    end
end

RegisterNetEvent('mkbuss:RewardVehicle')
AddEventHandler('mkbuss:RewardVehicle', function(model)
    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
    Citizen.Wait(10)
    ESX.Game.SpawnVehicle(veh, {x = plyCoords.x+2 ,y = plyCoords.y, z = plyCoords.z+2}, 313.4216, function (vehicle)
        local plate = exports[Config.ExportName]:GeneratePlate()
        table.insert(voituregive, vehicle)		
        local vehicleProps = ESX.Game.GetVehicleProperties(voituregive[#voituregive])
        vehicleProps.plate = plate
        SetVehicleNumberPlateText(voituregive[#voituregive] , plate)
        TriggerServerEvent('shop:vehiculeboutique', vehicleProps, plate)
        TriggerEvent('esx:showAdvancedNotification', 'Boutique', '', 'Vous avez reçu votre :\n '..veh, Config.img_notif, 3)
    end)
end)