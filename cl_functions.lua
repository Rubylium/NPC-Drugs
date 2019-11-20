function NotificationNpc(title, subject, msg, icon, iconType)
	AddTextEntry('showAdNotification', msg)
	SetNotificationTextEntry('showAdNotification')
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
end

NearestePed = nil
Citizen.CreateThread(function()
    while ESX == nil do
        Wait(100)
    end
    while true do
        local zone = GetZoneDevant()
        local ped = ESX.Game.GetClosestPed(zone, {})
        if ped ~= GetPlayerPed(-1) and not IsPedAPlayer(ped) then
            local coords = GetEntityCoords(ped, true)
            local distance = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), true), coords, true), 0)
            if distance <= 10 then
                NearestePed = ped
            else
                NearestePed = nil
            end
        end
        Citizen.Wait(2000)
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
            if distance <= 10.0 then
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
	--local coords = GetEntityCoords(GetPlayerPed(-1), true)
    local backwardPosition = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 2.0, 0.0)
    --print(backwardPosition)
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