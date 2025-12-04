local config = lib.loadJson('qbx_flipvehicle.config')

---@param vehicle number? id of the vehicle, default closes vehicle
---@param flipTest boolean? costom fliping task
local function flipVehicle(vehicle, flipTest)
    if cache.vehicle then return end
    if not vehicle then vehicle = lib.getClosestVehicle(GetEntityCoords(cache.ped), config.maxDistance, false) end
    if not vehicle then return TriggerEvent('mqs-notify:sendNotify', 'error', locale('error.no_vehicle_nearby'), 3000) end
    local peedCoords = GetEntityCoords(cache.ped)
    local vehicleCoords = GetEntityCoords(vehicle)

    if #(peedCoords - vehicleCoords) > config.maxDistance then
        return TriggerEvent('mqs-notify:sendNotify', 'error', locale('error.no_vehicle_nearby'), 3000)
    end

    if flipTest then
        SetVehicleOnGroundProperly(vehicle)
        TriggerEvent('mqs-notify:sendNotify', 'success', locale('success.flipped_car'), 3000)
    else
        local completed = false
        local cancelled = false
        
        TriggerEvent('progressbar:client:progress', {
            duration = config.flipingTime,
            label = locale('progress.flipping_car'),
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            },
            animation = {
                animDict = 'mini@repair',
                anim = 'fixing_a_ped',
                flags = 1
            }
        }, function(wasCancelled)
            if wasCancelled then
                cancelled = true
                TriggerEvent('mqs-notify:sendNotify', 'error', locale('error.canceled'), 3000)
            else
                completed = true
                SetVehicleOnGroundProperly(vehicle)
                TriggerEvent('mqs-notify:sendNotify', 'success', locale('success.flipped_car'), 3000)
            end
        end)
    end
end

---@deprecated use FlipVehicle instead
exports('flipVehicle', flipVehicle)

exports('FlipVehicle', flipVehicle)
