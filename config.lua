Config = {}

Config.Command = "fps"

Config.Notify = function(type, message)
    TriggerEvent('hex_2_hud:notify', "FPS MODE", message, "info", 5000) -- hex_hudv2
    -- your notify export or trigger
end
