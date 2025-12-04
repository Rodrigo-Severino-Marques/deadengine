-- QB-SitAnywhere Server Script
-- Handles stress reduction for QBX compatibility

RegisterNetEvent('qb-sitanywhere:server:reduceStress', function(amount)
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    
    if Player then
        -- Try to reduce stress using QBX methods
        if Player.Functions then
            -- QBX method
            Player.Functions.SetMetaData('stress', math.max(0, (Player.PlayerData.metadata.stress or 0) - amount))
        else
            -- Fallback method
            TriggerClientEvent('hud:client:UpdateStress', src, amount)
        end
    end
end)
