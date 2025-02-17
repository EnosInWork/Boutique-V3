if Config.Framework.ESX_Legacy then 
    ESX = exports[Config.Framework.ExtendedName]:getSharedObject()
else
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent(Config.Framework.SharedEvent, function(obj) ESX = obj end)
            Citizen.Wait(500)
        end
    end)
end

local IsDead = false
local GarageOption = false
local voituregive = {}

RegisterNetEvent('boutique:retupoints')
AddEventHandler('boutique:retupoints', function(point)
    pointjoueur = point
end)

RegisterNetEvent("Boutique:Notification")
AddEventHandler("Boutique:Notification", function(message)
    ESX.ShowNotification("~o~Boutique : " .. message)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer 
end)

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

fullcustom = false
curentvehicle_name = ""
curentvehicle_model = ""
curentvehicle_finalpoint = 0
local codepromo = false

function OpenBoutique()
    local menu = RageUI.CreateMenu(Config.Menu.MenuName, Config.Menu.SubMenuName)
    local vehiclemenu = RageUI.CreateSubMenu(menu, "Véhicules", Config.Menu.SubMenuName)
    local vehiclemenuparam = RageUI.CreateSubMenu(menu, "Paramètres", Config.Menu.SubMenuName)
    local armesmenu = RageUI.CreateSubMenu(menu, "Armes", Config.Menu.SubMenuName)
    local moneymenu = RageUI.CreateSubMenu(menu, "Argent", Config.Menu.SubMenuName)
    local caissemenu = RageUI.CreateSubMenu(menu, "Caisse", Config.Menu.SubMenuName)
    local optionsmenu = RageUI.CreateSubMenu(menu, "Options", Config.Menu.SubMenuName)
    menu:SetRectangleBanner(Config.Menu.ColorBanner[1], Config.Menu.ColorBanner[2], Config.Menu.ColorBanner[3], Config.Menu.ColorBanner[4])
    vehiclemenu:SetRectangleBanner(Config.Menu.ColorBanner[1], Config.Menu.ColorBanner[2], Config.Menu.ColorBanner[3], Config.Menu.ColorBanner[4])
    vehiclemenuparam:SetRectangleBanner(Config.Menu.ColorBanner[1], Config.Menu.ColorBanner[2], Config.Menu.ColorBanner[3], Config.Menu.ColorBanner[4])
    armesmenu:SetRectangleBanner(Config.Menu.ColorBanner[1], Config.Menu.ColorBanner[2], Config.Menu.ColorBanner[3], Config.Menu.ColorBanner[4])
    moneymenu:SetRectangleBanner(Config.Menu.ColorBanner[1], Config.Menu.ColorBanner[2], Config.Menu.ColorBanner[3], Config.Menu.ColorBanner[4])
    caissemenu:SetRectangleBanner(Config.Menu.ColorBanner[1], Config.Menu.ColorBanner[2], Config.Menu.ColorBanner[3], Config.Menu.ColorBanner[4])
    optionsmenu:SetRectangleBanner(Config.Menu.ColorBanner[1], Config.Menu.ColorBanner[2], Config.Menu.ColorBanner[3], Config.Menu.ColorBanner[4])
    RageUI.Visible(menu, not RageUI.Visible(menu))
    while menu do
        Citizen.Wait(0)
            RageUI.IsVisible(menu, true, true, true, function()

                RageUI.Separator(Config.Menu.ColorText[1].."Code boutique ~s~→→ "..Config.Menu.ColorText[2]..(code or "Chargement"))
                RageUI.Separator(Config.Menu.ColorText[1].."Vous avez ~s~→→ "..Config.Menu.ColorText[2]..(pointjoueur or "Chargement").." "..Config.Menu.CreditName)

                if codepromo then
                    RageUI.Separator("Code promo: ~g~Activer")
                end

                if Config.ActiveVeh then
                RageUI.ButtonWithStyle("Véhicules", nil, {RightLabel = "→→"}, true , function()
                end, vehiclemenu)
                end
                
                if Config.ActiveWeapon then
                RageUI.ButtonWithStyle("Armes", nil, {RightLabel = "→→"}, true , function()
                end, armesmenu)
                end

                if Config.ActiveCaisse then
                RageUI.ButtonWithStyle("Caisses", nil, {RightLabel = "→→"}, true , function()
                end, caissemenu)
                end

                if Config.ActiveMoney then
                RageUI.ButtonWithStyle("Argent", nil, {RightLabel = "→→"}, true , function()
                end, moneymenu)
                end

                RageUI.ButtonWithStyle("Options", nil, {RightLabel = "→→"}, true , function()
                end, optionsmenu)
                
                end, function()
                end)

                RageUI.IsVisible(optionsmenu, true, true, true, function()

                    if codepromo then
                        RageUI.Separator("Code promo ~g~Actif~s~")
                        RageUI.Separator("Réduction : ~g~"..100 - taxe.."%")
                    end

                    if Config.ActivePromo then
                    RageUI.ButtonWithStyle("Activer la promo", nil, {RightLabel = "→→"}, true , function(Hovered, Active, Selected)
                        if (Selected) then
                            local codex = KeyboardInput('PROMO_BOUTIQUE', "Merci d'entrer le code promo", '', 50)
                            if codex == Config.PromoCode then
                                codepromo = true				
                                ESX.ShowNotification("~g~Code promo validé!")
                            else
                                ESX.ShowNotification("~r~Code promo invalide!")
                            end
                        end
                    end)
                    end

                    RageUI.ButtonWithStyle("Désactiver la promo", nil, {RightLabel = "→→"}, true , function(Hovered, Active, Selected)
                        if (Selected) then
                            codepromo = false				
                            ESX.ShowNotification("~g~Code promo désactivé!")
                            RageUI.CloseAll()
                        end
                    end)
    
                    if Config.EchangePoint then
                        RageUI.ButtonWithStyle("Donner des points boutique", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                local boutique_id = KeyboardInput('ID_BOUTIQUE', "Merci d'entrer l'id boutique de vôtre ami", '', 50)
                                local point = KeyboardInput('ID_BOUTIQUE', "Merci de spécifier le nombre de crédit(s) que vous souhaitez donner", '', 50)
                                ESX.TriggerServerCallback('Boutique:DonnePoint', function(callback)
                                    if callback then
                                        ESX.ShowNotification("~g~Transfert reussi !")
                                    else
                                        ESX.ShowNotification("~r~Vous n'avez pas assez de crédit(s) !")
                                    end
                                end, point, boutique_id)
                            end
                        end)
                    end
    
                end, function()
                end)

            RageUI.IsVisible(vehiclemenu, true, true, true, function()

                if codepromo then
                    RageUI.Separator("Code promo ~g~Actif~s~")
                    RageUI.Separator("Réduction : ~g~"..100 - taxe.."%")
                end

                for k, v in pairs(Config.ListVeh) do

                if v.name == nil then 
					RageUI.Separator(v.category)
				else 
                
                    RageUI.ButtonWithStyle(v.name, nil, { RightLabel = Config.Menu.ColorText[1]..""..tostring(v.point)..""..Config.Menu.ColorText[2].." "..Config.Menu.CreditName },true, function(Hovered, Active, Selected)
                        if (Active) then 
                            RenderSprite("RageUI", v.img, 0, 565, 430, 200, 100)
                        end
                        if (Selected) then
                            curentvehicle_name = v.name
                            curentvehicle_model = v.model
                            curentvehicle_point = v.point
                            curentvehicle_place = v.place
                            curentvehicle_vitesse = v.vitesse
                            if codepromo then
                            curentvehicle_finalpoint = v.point * reduction
                            else
                            curentvehicle_finalpoint = v.point
                            end
                        end
                    end, vehiclemenuparam)
                end
            end

            end, function()
            end)

            RageUI.IsVisible(vehiclemenuparam, true, true, true, function()

            if curentvehicle_vitesse ~= nil and curentvehicle_place ~= nil and curentvehicle_name then
                RageUI.Separator(Config.Menu.ColorText[1].. "" ..curentvehicle_name)
                RageUI.Separator(Config.Menu.ColorText[2].."Vitesse max →→ "..Config.Menu.ColorText[1]..""..curentvehicle_vitesse )
                RageUI.Separator(Config.Menu.ColorText[2].."Nombre de siège →→ "..Config.Menu.ColorText[1].."".. curentvehicle_place )
            end

            RageUI.ButtonWithStyle("Essayer le véhicule", "Permet d'essayer le véhicule 20 secondes", {}, true , function(Hovered, Active, Selected)
                if (Selected) then
				 	posessaie = GetEntityCoords(PlayerPedId())
					Wait(500)
					spawnuniCar(curentvehicle_model)
				end
			end)

            RageUI.Checkbox("Full custom",nil, service,{},function(Hovered,Ative,Selected,Checked)
                if Selected then
                    service = Checked
					if codepromo then
						if Checked then
                            fullcustom = true
							curentvehicle_finalpoint_calcul = curentvehicle_point + Config.CustomPrice
							curentvehicle_finalpoint = curentvehicle_finalpoint_calcul * reduction
						else                         
							fullcustom = false
							curentvehicle_finalpoint = curentvehicle_point * reduction
						end
					else
						if Checked then
							fullcustom = true
							curentvehicle_finalpoint = curentvehicle_point + Config.CustomPrice
						else                         
							fullcustom = false
							curentvehicle_finalpoint = curentvehicle_point - Config.CustomPrice
                    end
                end
                end
            end)

            RageUI.Checkbox("Dans le garage",nil, ingarage,{},function(Hovered,Ative,Selected,Checked)
                if Selected then
                    ingarage = Checked
                    if Checked then
                        GarageOption = true
                    else                         
                        GarageOption = false
                    end
                end
            end)

			RageUI.ButtonWithStyle("~g~Acheter", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if (Selected) then
					if pointjoueur >= curentvehicle_finalpoint then
						give_vehi(curentvehicle_model)
						buying(curentvehicle_finalpoint)
                        RageUI.CloseAll()
					else
						ESX.ShowNotification("~r~Vous n'avez pas assez de fond pour acheter ceci !")
					end
				end
			end)

            RageUI.Separator(Config.Menu.ColorText[1].."Cout de l'achat →→ "..Config.Menu.ColorText[2]..""..curentvehicle_finalpoint.." "..Config.Menu.CreditName)

        end, function()
        end)

        RageUI.IsVisible(armesmenu, true, true, true, function()

            if codepromo then
                RageUI.Separator("Code promo ~g~Actif~s~")
                RageUI.Separator("Réduction : ~g~"..100 - taxe.."%")
            end

			for k, v in pairs(Config.WeaponList) do

                if v.name == nil then 
					RageUI.Separator(v.category)
				else 

				RageUI.ButtonWithStyle(v.name, nil, {RightLabel = Config.Menu.ColorText[1]..""..tostring(v.point)..""..Config.Menu.ColorText[2].." "..Config.Menu.CreditName}, true, function(Hovered, Active, Selected)
                    if (Active) then 
						RenderSprite("RageUI", v.img, 0, 530, 430, 200, 100)
					end
                    if (Selected) then

						curentvehicle_name = v.name
						curentvehicle_model = v.model
						curentvehicle_point = v.point
						if codepromo then
						curentvehicle_finalpoint = v.point * reduction
						else
						curentvehicle_finalpoint = v.point
						end
						if pointjoueur >= curentvehicle_finalpoint then
							buying(curentvehicle_finalpoint)
                            TriggerEvent('esx:showAdvancedNotification', '~o~Boutique', '', 'Vous avez reçu votre :\n'..curentvehicle_name, "CHAR_SOCIAL_CLUB", 3)
                            TriggerServerEvent('give:weapon', curentvehicle_model)
                            RageUI.CloseAll()
						else
							ESX.ShowNotification("~r~Vous n'avez pas assez de fond pour acheter ceci !")
						end
					end
                end)
				end
            end

        end, function()
        end)

        RageUI.IsVisible(caissemenu, true, true, true, function()

            if codepromo then
                RageUI.Separator("Code promo ~g~Actif~s~")
                RageUI.Separator("Réduction : ~g~"..100 - taxe.."%")
            end

            for k, caisse in pairs(Config.LesCaisse) do

                if caisse.name == nil then 
					RageUI.Separator(caisse.category)
				else 
                    
				RageUI.ButtonWithStyle(caisse.name, "~g~Loot disponible : "..caisse.lootdesc, {RightLabel = Config.Menu.ColorText[1]..""..tostring(caisse.point)..""..Config.Menu.ColorText[2].." "..Config.Menu.CreditName}, true , function(Hovered, Active, Selected)
                    if (Active) then 
                        RenderSprite("RageUI", caisse.img, 0, 450, 400, 200, 100)
                    end
                    if (Selected) then
						name = caisse.name
						item = caisse.item
						point = caisse.point
						if codepromo then
                            point = caisse.point * reduction
						else
                            point = caisse.point
						end
						if pointjoueur >= point then
							buying(point)
                            TriggerEvent('esx:showAdvancedNotification', '~o~Boutique', '', 'Vous avez reçu votre :\n'..name, "CHAR_SOCIAL_CLUB", 3)
                            TriggerServerEvent('give:item', item)
                            RageUI.CloseAll()
						else
							ESX.ShowNotification("~r~Vous n'avez pas assez de fond pour acheter ceci !")
						end
				    end
				end)

                end 

            end


                end, function()
                end)

            RageUI.IsVisible(moneymenu, true, true, true, function()

                if codepromo then
                    RageUI.Separator("Code promo ~g~Actif~s~")
                    RageUI.Separator("Réduction : ~g~"..100 - taxe.."%")
                end
    
                for k, v in pairs(Config.MoneyList) do

                    if v.name == nil then 
                        RageUI.Separator(v.category)
                    else 


                    RageUI.ButtonWithStyle(v.name, nil, {RightLabel = Config.Menu.ColorText[1]..""..tostring(v.point)..""..Config.Menu.ColorText[2].." "..Config.Menu.CreditName}, true , function(Hovered, Active, Selected)
                        if (Active) then 
                            RenderSprite("RageUI", v.img, 0, 350, 430, 200, 100)
                        end
                        if Selected then
                            curentvehicle_name = v.name
                            curentvehicle_model = v.model
                            curentvehicle_point = v.point
                            if codepromo then
                            curentvehicle_finalpoint = v.point * reduction
                            else
                            curentvehicle_finalpoint = v.point
                            end
                            if pointjoueur >= curentvehicle_finalpoint then
                                buying(curentvehicle_finalpoint)
                                TriggerEvent('esx:showAdvancedNotification', '~o~Boutique', '', 'Vous avez reçu vos :\n'..curentvehicle_name, "CHAR_SOCIAL_CLUB", 3)
                                TriggerServerEvent('give:money', curentvehicle_model)
                                RageUI.CloseAll()
                            else
                                ESX.ShowNotification("~r~Vous n'avez pas assez de fond pour acheter ceci !")
                            end
                        end
                    end)

                end
            end
            

            end, function()
            end)

        if not RageUI.Visible(menu) and not RageUI.Visible(vehiclemenu) and not RageUI.Visible(vehiclemenuparam) and not RageUI.Visible(armesmenu) and not RageUI.Visible(moneymenu) and not RageUI.Visible(caissemenu) and not RageUI.Visible(optionsmenu) then
            menu = RMenu:DeleteType(menu, true)
        end
    end
end

RegisterCommand('boutique', function()
    TriggerServerEvent('boutique:getpoints')
    ESX.TriggerServerCallback('boutique:GetCodeBoutique', function(thecode)
        code = thecode
        OpenBoutique()
    end)
end, false)
RegisterKeyMapping('boutique', 'Ouvrir menu boutique', 'keyboard', 'F9')
    

function buying(point)
    if pointjoueur >= point then
        TriggerServerEvent('boutique:deletepoint', point)
        Citizen.Wait(300)
        TriggerServerEvent('boutique:getpoints')
    else
        TriggerEvent('esx:showNotification', '~r~Tu ne peut pas acheter cet article.')
    end
end

function spawnuniCar(car)
    local car = GetHashKey(car)
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, -899.62, -3298.74, 13.94, 58.0, true, false)
    SetEntityAsMissionEntity(vehicle, true, true) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
	SetVehicleDoorsLocked(vehicle, 4)
	RageUI.Text({ message = "Vous avez 20 secondes pour tester le véhicule.", time_display = 3000 })
	local timer = 20
	local breakable = false
	breakable = false
	while not breakable do
		Wait(1000)
		timer = timer - 1
		if timer == 10 then
			RageUI.Text({ message = "Il vous reste plus que 10 secondes.", time_display = 3000 })
		end
		if timer == 5 then
			RageUI.Text({ message = "Il vous reste plus que 5 secondes.", time_display = 3000 })
		end
		if timer <= 0 then
			local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
			DeleteEntity(vehicle)
			RageUI.Text({ message = "~r~Vous avez terminé la période d'essai.", time_display = 3000 })
			SetEntityCoords(PlayerPedId(), posessaie)
			breakable = true
			break
		end
	end
end


function SetVehicleMaxMods(vehicle)
    local props = {
      modEngine       = 2,
      modBrakes       = 2,
      modTransmission = 2,
      modSuspension   = 3,
      modTurbo        = true,
    }
    ESX.Game.SetVehicleProperties(vehicle, props)
end

function give_vehi(veh)
    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
    Citizen.Wait(10)
    
    ESX.Game.SpawnVehicle(veh, {x = plyCoords.x + 2, y = plyCoords.y, z = plyCoords.z + 2}, 313.4216, function(vehicle)
        if fullcustom then
            SetVehicleMaxMods(vehicle)
        end
        
        table.insert(voituregive, vehicle)
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        
        if GarageOption then
            TriggerServerEvent('shop:vehiculeboutique', vehicleProps, plate, true)
            TriggerEvent("BoutiqueV3:SendNotif", "Vous avez reçu votre : "..veh.." directement dans votre garage")
            ESX.Game.DeleteVehicle(vehicle)
        else
            TriggerEvent("BoutiqueV3:SendNotif", "Vous avez reçu votre : "..veh)
            TriggerServerEvent('shop:vehiculeboutique', vehicleProps, plate, false)
        end
    end)
end

RegisterNetEvent('BoutiqueV3:SendNotif', function(message)
    Config.Notification(message)
end)