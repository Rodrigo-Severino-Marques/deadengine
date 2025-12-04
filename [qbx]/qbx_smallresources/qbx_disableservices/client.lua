local config = lib.load('qbx_disableservices.config')

CreateThread(function()
    SetMaxWantedLevel(config.maxWantedLevel)
    for key, value in ipairs(config.enabledServices) do
        EnableDispatchService(key, value)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
            if IsPedInAnyVehicle(PlayerPedId()) then
                SetUserRadioControlEnabled(false)
                if GetPlayerRadioStationName() ~= nil then
                SetVehRadioStation(GetVehiclePedIsIn(PlayerPedId()),"OFF")
                end
        end
    end
end)