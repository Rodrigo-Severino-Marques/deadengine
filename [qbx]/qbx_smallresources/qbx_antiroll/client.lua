local config = lib.loadJson('qbx_antiroll.config')
local listening = false

-- Disable jump when armed
CreateThread(function()
    while true do
        Wait(0)
        if IsPedArmed(cache.ped, 4 | 2) and IsControlPressed(0, 25) then
            DisableControlAction(0, 22, true)
        end
    end
end)

-- Vehicle anti-roll system
lib.onCache('vehicle', function(vehicle)
    if vehicle then
        listening = true
        local vehicleClass = GetVehicleClass(vehicle)
        
        if cache.seat == -1 and config.vehicleClassDisableControl[tostring(vehicleClass)] then
            CreateThread(function()
                while listening and cache.vehicle do
                    if IsEntityInAir(cache.vehicle) then
                        DisableControlAction(2, 59) -- Left/Right
                        DisableControlAction(2, 60) -- Up/Down
                    end
                    Wait(10)
                end
            end)
        end
    else
        listening = false
    end
end)
