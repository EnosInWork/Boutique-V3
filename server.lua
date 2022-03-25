ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.TimeMessage)
        TriggerClientEvent("Boutique:Notification", -1, Config.AutoMessage)
    end
end)

Citizen.CreateThread(function()
	for k, v in pairs(Config.Case) do
		ESX.RegisterUsableItem(k, function(source)
			local xPlayer = ESX.GetPlayerFromId(source)
			xPlayer.removeInventoryItem(k, 1)
			TriggerClientEvent('Open:Case', source,k)
		end)
	end
end)

RegisterServerEvent('mkbuss:giveReward')
AddEventHandler('mkbuss:giveReward', function (t, data, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if t == "item" then
		xPlayer.addInventoryItem(data, amount)
	elseif t == "weapon" then
		xPlayer.addWeapon(data, 1)
	elseif t == "money" then
		xPlayer.addMoney(data)
	elseif t == "black_money" then
		xPlayer.addAccountMoney('black_money', data)
	end
	
end)

RegisterServerEvent("boutique:getpoints")
AddEventHandler("boutique:getpoints", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
	local _source = source
    if Config.LicenceSysteme == "steam" then
    license = xPlayer.getIdentifier()
    elseif Config.LicenceSysteme == "license" then
    license = ESX.GetIdentifierFromId(source)
    end
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier=@identifier', {
        ['@identifier'] = license
	}, function(data)
		local poi = data[1].pb
		TriggerClientEvent('boutique:retupoints', _source, poi)
	end)
end
end)

ESX.RegisterServerCallback('boutique:GetCodeBoutique', function(source, cb)
    local xPlayer  = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = '".. xPlayer.getIdentifier() .."'", {}, function (result)
        cb(result[1].boutique_id)
    end)
end)

RegisterServerEvent('shop:vehiculeboutique')
AddEventHandler('shop:vehiculeboutique', function(vehicleProps, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
        ['@owner']   = xPlayer.identifier,
        ['@plate']   = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps)
    }, function(rowsChange)
        PerformHttpRequest(Config.discord_webhook, function(err, text, headers) end, 'POST', json.encode({username = "", content = xPlayer.getName() .. " à acheter un véhicule boutique."}), { ['Content-Type'] = 'application/json' })
    end)
end
end)

ESX.RegisterServerCallback('Boutique:DonnePoint', function(source, cb, point, boutique_id)
    local xPlayer  = ESX.GetPlayerFromId(source)
    if xPlayer ~= nil then
   MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = '".. xPlayer.identifier .."'", {}, function (result)
        if result[1].pb >= tonumber(point) then
            local newpoint = result[1].pb - tonumber(point)
            MySQL.Async.execute("UPDATE `users` SET `pb`= '".. newpoint .."' WHERE `identifier` = '".. xPlayer.getIdentifier() .."'", {}, function() end)
            MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `boutique_id` = '".. boutique_id .."'", {}, function (result2)
                local addpoint = result2[1].pb + tonumber(point)
                local xPlayer2 = ESX.GetPlayerFromIdentifier(result2[1].identifier)
                PerformHttpRequest(Config.discord_webhook, function(err, text, headers) end, 'POST', json.encode({username = "Boutique", content = "Transaction : " .. point .. " crédit(s) de la part de " .. xPlayer.getName() .. " a " .. xPlayer2.getName()}), { ['Content-Type'] = 'application/json' })
                xPlayer2.triggerEvent("Boutique:Notification", "Vous avez recu " .. point .. " crédit(s) de la part de " .. xPlayer.getName())
                MySQL.Async.execute("UPDATE `users` SET `pb`= '".. addpoint .."' WHERE `boutique_id` = '".. boutique_id .."'", {}, function() end)
            end)
            cb(true)
        else
            cb(false)
        end
    end)
end
end)

RegisterServerEvent('boutique:deletepoint')
AddEventHandler('boutique:deletepoint', function(point)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
	local _source = source
    if Config.LicenceSysteme == "steam" then
        license = xPlayer.getIdentifier()
    elseif Config.LicenceSysteme == "license" then
        license = ESX.GetIdentifierFromId(source)
    end
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier=@identifier', {
        ['@identifier'] = license
	}, function(data)
        local poi = data[1].pb
        npoint = poi -point

        MySQL.Async.execute('UPDATE `users` SET `pb`=@point  WHERE identifier=@identifier', {
            ['@identifier'] = license,
            ['@point'] = npoint 
        }, function(rowsChange)
        end)
    end)
end
end)


RegisterServerEvent('give:money')
AddEventHandler('give:money', function(w)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
	local _source = source
    xPlayer.addMoney(w)
    PerformHttpRequest(Config.discord_webhook, function(err, text, headers) end, 'POST', json.encode({username = "", content = xPlayer.getName() .. " à acheter de l'argent boutique."}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('give:weapon')
AddEventHandler('give:weapon', function(w)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addWeapon(w, 1)
    PerformHttpRequest(Config.discord_webhook, function(err, text, headers) end, 'POST', json.encode({username = "", content = xPlayer.getName() .. " à acheter une arme boutique."}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('give:item')
AddEventHandler('give:item', function(w)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addInventoryItem(w, 1)
    PerformHttpRequest(Config.discord_webhook, function(err, text, headers) end, 'POST', json.encode({username = "", content = xPlayer.getName() .. " à acheter une caisse boutique."}), { ['Content-Type'] = 'application/json' })
end)

RegisterCommand("giveid", function(source, args, raw)
    local id    = args[1]
    local point = args[2]
    local xPlayer = ESX.GetPlayerFromId(id)
    if Config.LicenceSysteme == "steam" then
        license = xPlayer.getIdentifier()
    elseif Config.LicenceSysteme == "license" then
        license = ESX.GetIdentifierFromId(id)
    end
    if source == 0 then 
        TriggerClientEvent('esx:showAdvancedNotification', id, 'Boutique', '', 'Vous avez reçu vos :\n'..point..' '..Config.CreditName, "CHAR_DREYFUSS", 3)
        PerformHttpRequest(Config.discord_webhook, function(err, text, headers) end, 'POST', json.encode({username = "Boutique Logs", content = "[Give ID Online]\n Give de "..point.." points sur >> "..xPlayer.getName()}), { ['Content-Type'] = 'application/json' })
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier=@identifier', {
            ['@identifier'] = license
        }, function(data)
            local poi = data[1].pb
            npoint = poi + point
    
            MySQL.Async.execute('UPDATE `users` SET `pb`=@point  WHERE identifier=@identifier', {
                ['@identifier'] = license,
                ['@point'] = npoint 
            }, function(rowsChange)
            end)
        end)
    else
        print("Tu ne peut pas faire cette commande ici")
    end
end, false)

RegisterCommand("giveidboutique", function(source, args, raw)
    local id    = args[1]
    local point = args[2]
    if source == 0 then 
       PerformHttpRequest(Config.discord_webhook, function(err, text, headers) end, 'POST', json.encode({username = "Boutique Logs", content = "[Give ID Boutique]\n Give de "..point.." points sur l'id boutique >> "..id}), { ['Content-Type'] = 'application/json' })
        MySQL.Async.fetchAll('SELECT * FROM users WHERE boutique_id=@boutique_id', {
            ['@boutique_id'] = license
        }, function(data)
            local poi = data[1].pb
            npoint = poi + point
    
            MySQL.Async.execute('UPDATE `users` SET `pb`=@point  WHERE boutique_id=@boutique_id', {
                ['@boutique_id'] = license,
                ['@point'] = npoint 
            }, function(rowsChange)
            end)
        end)
    else
        print("Tu ne peut pas faire cette commande ici")
    end
end, false)

RegisterServerEvent('changestateveh')
AddEventHandler('changestateveh', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
		['@stored'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('rGarage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)
