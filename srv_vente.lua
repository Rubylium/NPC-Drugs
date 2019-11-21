ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)




-- Prix vente weed NPC
local WeedMin = 10
local WeedMax = 20


-- Vente weed
RegisterServerEvent("NPCVente:Weed")
AddEventHandler("NPCVente:Weed", function(num)
    local xPlayer = ESX.GetPlayerFromId(source)
    local nombre = xPlayer.getInventoryItem("weed_pooch")
    local count = 1
    if nombre.count >= num then
        local PrixWeed = math.random(WeedMin,WeedMax)
        local PrixWeedFinal = num * PrixWeed
        xPlayer.removeInventoryItem("weed_pooch", num)
        TriggerClientEvent("NPCVente:Notification", source, "Activité illégal", "~g~Vente de weed", "Ouais je t'en prends ~g~"..num.."~w~\nArgent obtenu: ~g~"..PrixWeedFinal, "CHAR_LESTER", 8)
    else
        TriggerClientEvent("NPCVente:Notification", source, "Activité illégal", "~g~Vente de weed", "Ouai cimer je t'en prends ... Attends mais t'essaye de me vendre quoi la ? Ta rien frère ? Casse toi !", "CHAR_LESTER", 8)
    end
end)