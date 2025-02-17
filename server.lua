if Config.Framework.ESX_Legacy then 
    ESX = exports[Config.Framework.ExtendedName]:getSharedObject()
else
    ESX = nil
    TriggerEvent(Config.Framework.SharedEvent, function(obj) ESX = obj end)
end

Discord_Webhook = ""

if Config.AutoNotif.Active then 
    CreateThread(function()
        while true do
            Citizen.Wait(Config.AutoNotif.TimeMessage * 60000)
            TriggerClientEvent("Boutique:Notification", -1, Config.AutoNotif.AutoMessage)
        end
    end)
end

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
        if Config.Framework.useOxInventory then 
            xPlayer.addInventoryItem(data, 1)
        else
		    xPlayer.addWeapon(data, 1)
        end
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
AddEventHandler('shop:vehiculeboutique', function(vehicleProps, plate, stored)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plate = GeneratePlate()

	if xPlayer ~= nil then
        MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
            ['@owner']   = xPlayer.identifier,
            ['@plate']   = plate,
            ['@vehicle'] = json.encode(vehicleProps),
        }, function(rowsChange)
            PerformHttpRequest(Discord_Webhook, function(err, text, headers) end, 'POST', json.encode({username = "", content = xPlayer.getName() .. " à acheter un véhicule boutique."}), { ['Content-Type'] = 'application/json' })
            
            if stored then 
                TriggerEvent("changestateveh", plate, Config.ValueStoredOnGarage)
            else
                TriggerEvent("changestateveh", plate, Config.ValueVehicleOut)
            end

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
                PerformHttpRequest(Discord_Webhook, function(err, text, headers) end, 'POST', json.encode({username = "Boutique", content = "Transaction : " .. point .. " crédit(s) de la part de " .. xPlayer.getName() .. " a " .. xPlayer2.getName()}), { ['Content-Type'] = 'application/json' })
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
    PerformHttpRequest(Discord_Webhook, function(err, text, headers) end, 'POST', json.encode({username = "", content = xPlayer.getName() .. " à acheter de l'argent boutique."}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('give:weapon')
AddEventHandler('give:weapon', function(w)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if Config.Framework.useOxInventory then 
        xPlayer.addInventoryItem(w, 1)
    else
        xPlayer.addWeapon(w, 1)
    end

    PerformHttpRequest(Discord_Webhook, function(err, text, headers) end, 'POST', json.encode({username = "", content = xPlayer.getName() .. " à acheter une arme boutique."}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('give:item')
AddEventHandler('give:item', function(w)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addInventoryItem(w, 1)
    PerformHttpRequest(Discord_Webhook, function(err, text, headers) end, 'POST', json.encode({username = "", content = xPlayer.getName() .. " à acheter une caisse boutique."}), { ['Content-Type'] = 'application/json' })
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
        TriggerClientEvent('esx:showAdvancedNotification', id, 'Boutique', '', 'Vous avez reçu vos :\n'..point..' '..Config.Menu.CreditName, "CHAR_DREYFUSS", 3)
        PerformHttpRequest(Discord_Webhook, function(err, text, headers) end, 'POST', json.encode({username = "Boutique Logs", content = "[Give ID Online]\n Give de "..point.." points sur >> "..xPlayer.getName()}), { ['Content-Type'] = 'application/json' })
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
        PerformHttpRequest(Discord_Webhook, function(err, text, headers) end, 'POST', json.encode({username = "Boutique Logs", content = "[Give ID Boutique]\n Give de "..point.." points sur l'id boutique >> "..id}), { ['Content-Type'] = 'application/json' })
        MySQL.Async.fetchAll('SELECT * FROM users WHERE boutique_id = @boutique_id', {
            ['@boutique_id'] = tonumber(id)
        }, function(data)
            local poi = data[1].pb
            npoint = tonumber(poi) + tonumber(point)
    
            MySQL.Async.execute('UPDATE users SET pb = @point WHERE boutique_id = @boutique_id', {
                ['@boutique_id'] = tonumber(id),
                ['@point'] = npoint 
            }, function(rowsChange)
                print("Vous venez de donner " .. tostring(npoint) .. " à l'id boutique : " .. tostring(id))
            end)
        end)
    else
        print("Tu ne peut pas faire cette commande ici")
    end
end, false)

RegisterServerEvent('changestateveh')
AddEventHandler('changestateveh', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)
    local StoredColumn = Config.StoredColumnName

	MySQL.Async.execute('UPDATE owned_vehicles SET '..StoredColumn..' = @'..StoredColumn..' WHERE plate = @plate', {
		['@'..StoredColumn..''] = state,
		['@plate'] = plate
	}, function(rowsChanged)
	end)
end)


---------------------------------------------------------------------------- 

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
    local generatedPlate
    local doBreak = false

    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())
        generatedPlate = GenerateFormattedPlate(Config.PlateFormat)
        tablesql = Config.TableNameVehicle

        local result = ExecuteSql("SELECT 1 FROM "..tablesql.." WHERE plate = '"..generatedPlate.."'")
        if result[1] == nil then 
            doBreak = true
        end

        if doBreak then
            break
        end
    end

    return generatedPlate
end

function GenerateFormattedPlate(format)
    local plate = ""
    for i = 1, #format do
        local char = format:sub(i, i)
        if char == "L" then
            plate = plate .. string.upper(GetRandomLetter(1)) 
        elseif char == "N" then
            plate = plate .. GetRandomNumber(1)
        end
    end
    return plate
end

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
		return GetRandomLetter(length - 1) .. string.upper(Charset[math.random(1, #Charset)]) -- Conversion en majuscules
	else
		return ''
	end
end

function ExecuteSql(query, params)
    local isBusy = true
    local result = nil

    if Config.Framework.Mysql == "oxmysql" then
        exports.oxmysql:execute(query, params, function(data)
            result = data
            isBusy = false
        end)
    elseif Config.Framework.Mysql == "ghmattimysql" then
        exports.ghmattimysql:execute(query, params, function(data)
            result = data
            isBusy = false
        end)
    elseif Config.Framework.Mysql == "mysql-async" then   
        if MySQL and MySQL.Async then
            MySQL.Async.fetchAll(query, params, function(data)
                result = data
                isBusy = false
            end)
        else
            print("^1[ERROR] MySQL Async not found! Check if mysql-async is properly installed.^0")
            return nil
        end
    else
        print("^1[ERROR] Invalid database framework in Config.Framework.Mysql!^0")
        return nil
    end

    local timeout = 5000 -- Timeout en millisecondes (5s max)
    local startTime = GetGameTimer()

    while isBusy do
        Citizen.Wait(0)
        if GetGameTimer() - startTime > timeout then
            print("^1[ERROR] SQL execution timed out! Query: " .. query .. "^0")
            return nil
        end
    end

    return result
end
