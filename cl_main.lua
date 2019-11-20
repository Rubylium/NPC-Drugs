ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)



_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Intéraction NPC", "~b~Menu d'intéraction NPC.")
_menuPool:Add(mainMenu)
_menuPool:WidthOffset(0)




function menu(menu, npc)
    local ped = NetworkGetEntityFromNetworkId(npc)

	local vendreWeed = NativeUI.CreateItem("Essayer de lui vendre de la weed", " ")
    menu:AddItem(vendreWeed)

	menu.OnItemSelect = function(sender, item, index)
		if item == vendreWeed then
            ClearPedTasks(GetPlayerPed(-1))
            _menuPool:CloseAllMenus()
		end
	end
end


local TargetNpc = nil
local count = 0
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
    end
    menu(mainMenu)

    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if not _menuPool:IsAnyMenuOpen() then
            local ped = NetworkGetEntityFromNetworkId(TargetNpc)
            ClearPedTasks(ped)
        end
    end
end)


function OpenNpcMenu(npc)
    mainMenu:Clear()
    menu(mainMenu, npc)
    Wait(100)
    mainMenu:Visible(not mainMenu:Visible())
    PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)
    TaskTurnPedToFaceEntity(npc, GetPlayerPed(-1), 5000)
    TargetNpc = npc
end


_menuPool:RefreshIndex()
_menuPool:MouseControlsEnabled (false);
_menuPool:MouseEdgeEnabled (false);
_menuPool:ControlDisablingEnabled(false);