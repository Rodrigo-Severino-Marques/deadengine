local config = lib.loadJson('qbx_elastico.config')

exports.qbx_core:CreateUseableItem(config.scrunchieItem, function(source, item)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end
    
    if exports.ox_inventory:GetItem(source, item.name, nil, item.slot) then
        TriggerClientEvent('qbx_elastico:client:useScrunchie', source)
    end
end)
