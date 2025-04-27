local ESX = exports['es_extended']:getSharedObject()
local isFPSModeActive = false

RegisterCommand(Config.Command, function()
    ShowFPSMenu()
end)

RegisterNetEvent("toggleFPSMode")
AddEventHandler("toggleFPSMode", function(state)
    print(state)
    if state then
        EnableFPSBoost()
        Config.Notify("success", "Dein Charakter wurde geladen.")
    else
        DisableFPSBoost()
        Config.Notify("error", "Dein Charakter wurde geladen.")
    end
end)

function ShowFPSMenu()
    local options = {
        {label = 'FPS-Modus [AN]', value = 'enable_fps'},
        {label = 'FPS-Modus [AUS]', value = 'disable_fps'}
    }

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fps_menu', {
        title = 'FPS Optimierungsmenü',
        align = 'top-left',
        elements = options
    }, function(data, menu)
        if data.current.value == 'enable_fps' then
            EnableFPSBoost()
            TriggerServerEvent("savefpsmode", true)
            Config.Notify("success", "FPS-Modus aktiviert!")
            isFPSModeActive = true
        elseif data.current.value == 'disable_fps' then
            DisableFPSBoost()
            TriggerServerEvent("savefpsmode", false)
            Config.Notify("success", "FPS-Modus deaktiviert!")
            isFPSModeActive = false
        end
    end, function(data, menu)
        menu.close()
    end)
end

function EnableFPSBoost()
    SetTimecycleModifier("yell_tunnel_nodirect")
    SetExtraTimecycleModifier("reflection_correct_ambient")
end

function DisableFPSBoost()
    SetTimecycleModifier()
    ClearTimecycleModifier()
    ClearExtraTimecycleModifier()
end

function CleanUpForFPS()
    local player = PlayerPedId()
    ClearAllBrokenGlass()
    ClearAllHelpMessages()
    LeaderboardsReadClearAll()
    ClearBrief()
    ClearGpsFlags()
    ClearPrints()
    ClearSmallPrints()
    ClearReplayStats()
    LeaderboardsClearCacheData()
    ClearFocus()
    ClearHdArea()
    ClearPedBloodDamage(player)
    ClearPedWetness(player)
    ClearPedEnvDirt(player)
    ResetPedVisibleDamage(player)
end

CreateThread(function()
    while true do
        Wait(60000)
        CleanUpForFPS()
        if isFPSModeActive then
            EnableFPSBoost()
        else
            DisableFPSBoost()
        end
    end
end)
