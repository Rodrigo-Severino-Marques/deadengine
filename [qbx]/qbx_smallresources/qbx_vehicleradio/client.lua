local config = lib.loadJson('qbx_vehicleradio.config')
local radioEnabled = not config.disableRadioByDefault

RegisterCommand(config.toggleCommand, function()
    local currentVehicle = cache.vehicle
    if not currentVehicle or currentVehicle == 0 then
        return
    end

    radioEnabled = not radioEnabled

    if radioEnabled then
        TriggerEvent('mqs-notify:sendNotify', 'success', locale('success.vehicle_radio_on'), 3000)
        SetUserRadioControlEnabled(true)
    else
        TriggerEvent('mqs-notify:sendNotify', 'error', locale('error.vehicle_radio_off'), 3000)
        SetVehRadioStation(currentVehicle, "OFF")
        SetUserRadioControlEnabled(false)
    end
end, false)

if config.toggleKey then
    RegisterKeyMapping(config.toggleCommand, "Toggle Vehicle Radio", "keyboard", config.toggleKey)
end

lib.onCache('vehicle', function(currentVehicle)
    if currentVehicle and currentVehicle ~= 0 then
        SetUserRadioControlEnabled(radioEnabled)
        if not radioEnabled then
            SetVehRadioStation(currentVehicle, "OFF")
        end
    else
        SetUserRadioControlEnabled(true)
    end
end)