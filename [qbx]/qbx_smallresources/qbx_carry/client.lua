local config = lib.loadJson('qbx_carry.config')

local carry = {
    InProgress = false,
    targetSrc = -1,
    type = "",
    personCarrying = config.personCarrying,
    personCarried = config.personCarried
}

local function GetClosestPlayer(radius)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = cache.ped
    local playerCoords = GetEntityCoords(playerPed)

    for _, playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords - playerCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end
    
    if closestDistance ~= -1 and closestDistance <= radius then
        return closestPlayer
    else
        return nil
    end
end

local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end        
    end
    return animDict
end

-- RegisterCommand(config.carryCommand, function()
--     if not carry.InProgress then
--         local closestPlayer = GetClosestPlayer(config.maxDistance)
--         if closestPlayer then
--             local targetSrc = GetPlayerServerId(closestPlayer)
--             if targetSrc ~= -1 then
--                 carry.InProgress = true
--                 carry.targetSrc = targetSrc
--                 TriggerServerEvent("qbx_carry:sync", targetSrc)
--                 ensureAnimDict(carry.personCarrying.animDict)
--                 carry.type = "carrying"
--             else
--                 TriggerEvent("mqs-notify:sendNotify", "error", "Ninguém por perto para carregar!", 6000)
--             end
--         else
--             TriggerEvent("mqs-notify:sendNotify", "error", "Ninguém por perto para carregar!", 6000)
--         end
--     else
--         carry.InProgress = false
--         ClearPedSecondaryTask(cache.ped)
--         DetachEntity(cache.ped, true, false)
--         TriggerServerEvent("qbx_carry:stop", carry.targetSrc)
--         carry.targetSrc = 0
--     end
-- end, false)

RegisterNetEvent("qbx_carry:syncTarget", function(targetSrc)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
    carry.InProgress = true
    ensureAnimDict(carry.personCarried.animDict)
    AttachEntityToEntity(cache.ped, targetPed, 0, carry.personCarried.attachX, carry.personCarried.attachY, carry.personCarried.attachZ, 0.5, 0.5, 180, false, false, false, false, 2, false)
    carry.type = "beingcarried"
end)

RegisterNetEvent("qbx_carry:cl_stop", function()
    carry.InProgress = false
    ClearPedSecondaryTask(cache.ped)
    DetachEntity(cache.ped, true, false)
end)

CreateThread(function()
    while true do
        if carry.InProgress then
            if carry.type == "beingcarried" then
                if not IsEntityPlayingAnim(cache.ped, carry.personCarried.animDict, carry.personCarried.anim, 3) then
                    TaskPlayAnim(cache.ped, carry.personCarried.animDict, carry.personCarried.anim, 8.0, -8.0, 100000, carry.personCarried.flag, 0, false, false, false)
                end
            elseif carry.type == "carrying" then
                if not IsEntityPlayingAnim(cache.ped, carry.personCarrying.animDict, carry.personCarrying.anim, 3) then
                    TaskPlayAnim(cache.ped, carry.personCarrying.animDict, carry.personCarrying.anim, 8.0, -8.0, 100000, carry.personCarrying.flag, 0, false, false, false)
                end
            end
        end
        Wait(5)
    end
end)
