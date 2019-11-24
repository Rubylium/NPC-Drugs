function NotificationNpc(title, subject, msg, icon, iconType)
	AddTextEntry('showAdNotification', msg)
	SetNotificationTextEntry('showAdNotification')
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
end

RegisterNetEvent("NPCVente:Notification")
AddEventHandler("NPCVente:Notification", function(title, subject, msg, icon, iconType)
	AddTextEntry('showAdNotification', msg)
	SetNotificationTextEntry('showAdNotification')
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
end)

NearestePed = nil
local DejaVenduPed = {}
Citizen.CreateThread(function()
    while ESX == nil do
        Wait(100)
    end
    while true do
        local zone = GetZoneDevant()
        local ped = ESX.Game.GetClosestPed(zone, {})
        local model = GetEntityModel(ped)
        if ped ~= GetPlayerPed(-1) and not IsPedAPlayer(ped) and not IsPedDeadOrDying(ped, 1) then
            if model ~= GetHashKey("s_f_y_cop_01") and model ~= GetHashKey("s_m_y_cop_01") then -- Blacklist des modèles ici, flème de faire une liste
                local coords = GetEntityCoords(ped, true)
                local distance = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), true), coords, true), 0)
                if distance <= 10 then
                    for k,v in ipairs(DejaVenduPed) do
                        local NetPed = NetworkGetEntityFromNetworkId(v)
                        if NetPed ~= ped then 
                            NearestePed = ped
                        else
                            NearestePed = nil
                        end
                    end
                else
                    NearestePed = nil
                end
            end
        end
        Citizen.Wait(1000)
    end
end)


Citizen.CreateThread(function()
    while ESX == nil do
        Wait(100)
    end
    while true do
        if NearestePed ~= nil then
            local ped = NearestePed
            local coords = GetEntityCoords(ped, true)
            local distance = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), true), coords, true), 0)
            --print(distance)
            if distance <= 5.0 then
                if distance >= 3.0 then
                    DrawMarker(32, coords.x, coords.y, coords.z+1.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 170, 0, 0, 2, 1, nil, nil, 0)
                else
                    DrawMarker(32, coords.x, coords.y, coords.z+1.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 0, 2, 1, nil, nil, 0)
                    DrawText3D(coords.x, coords.y, coords.z, "Appuyer sur [~b~E~w~] pour parler avec la personne")
                    if IsControlJustReleased(1, 46) then
                        local PedNetId = NetworkGetNetworkIdFromEntity(ped)
                        OpenNpcMenu(PedNetId)
                    end
                end
            else
                NearestePed = nil
            end
        end
        Citizen.Wait(1)
    end
end)


function GetZoneDevant()
    local backwardPosition = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 2.0, 0.0)
	return backwardPosition
end



function DrawText3D(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)

	if onScreen then
		SetTextScale(0.25, 0.25)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text)) / 350
		DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
	end
end



-- Vente 
  

function VenteWeed(npc)
    local ped = NetworkGetEntityFromNetworkId(npc)
    FreezeEntityPosition(ped, true)
    local random = math.random(1,10)

    if random <= 8 then
        local weedBuy = math.random(1,5)
        local heading = GetEntityHeading(ped)
        local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.14, 0.0)

        
        SetEntityHeading(PlayerPedId(), heading - 180.1)
        SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z, 0)
        Wait(300)
        while not HasAnimDictLoaded("mp_ped_interaction") do
            RequestAnimDict("mp_ped_interaction")
            Citizen.Wait(1)
        end
        
        TriggerServerEvent("NPCVente:Weed", weedBuy)
        TaskPlayAnim(GetPlayerPed(-1), "mp_ped_interaction", "hugs_guy_a", 2.0, 2.0, -1, 0, 0, false, false, false)
        TaskPlayAnim(ped, "mp_ped_interaction", "hugs_guy_a", 2.0, 2.0, -1, 0, 0, false, false, false)
        Wait(4500)
        FreezeEntityPosition(ped, false)
    
        local NetId = NetworkGetNetworkIdFromEntity(ped)
        table.insert(DejaVenduPed, NetId)
        NearestePed = nil
    else
        NotificationNpc("Activité illégal", "~g~Vente de weed", "Ouai cimer je t'en prends ... Attends mais t'essaye de me vendre quoi la ? Ta rien frère ? Casse toi !", "CHAR_LESTER", 8)
        TaskCombatPed(ped, GetPlayerPed(-1), 0, 16)
    end
end



function VenteCoke(npc)
    local ped = NetworkGetEntityFromNetworkId(npc)
    FreezeEntityPosition(ped, true)
    local random = math.random(1,10)

    if random <= 8 then
        local cokeBuy = math.random(1,5)
        local heading = GetEntityHeading(ped)
        local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.14, 0.0)

        
        SetEntityHeading(PlayerPedId(), heading - 180.1)
        SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z, 0)
        Wait(300)
        while not HasAnimDictLoaded("mp_ped_interaction") do
            RequestAnimDict("mp_ped_interaction")
            Citizen.Wait(1)
        end
        
        TriggerServerEvent("NPCVente:coke", cokeBuy)
        TaskPlayAnim(GetPlayerPed(-1), "mp_ped_interaction", "hugs_guy_a", 2.0, 2.0, -1, 0, 0, false, false, false)
        TaskPlayAnim(ped, "mp_ped_interaction", "hugs_guy_a", 2.0, 2.0, -1, 0, 0, false, false, false)
        Wait(4500)
        FreezeEntityPosition(ped, false)

        local NetId = NetworkGetNetworkIdFromEntity(ped)
        table.insert(DejaVenduPed, NetId)
        NearestePed = nil
    else
        NotificationNpc("Activité illégal", "~g~Vente de coke", "Ouai cimer je t'en prends ... Attends mais t'essaye de me vendre quoi la ? Ta rien frère ? Casse toi !", "CHAR_LESTER", 8)
        TaskCombatPed(ped, GetPlayerPed(-1), 0, 16)
    end
end