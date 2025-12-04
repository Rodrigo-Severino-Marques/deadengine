local QBCore = exports['qbx_core']

-- Verificar se o jogador tem permissão
local function hasPermission(source)
    if not Config.AdminOnly then
        return true
    end

    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end

    return QBCore.Functions.HasPermission(source, Config.AdminPermission)
end

-- Guardar escala no banco de dados
local function saveScale(citizenid, scale)
    if not Config.SaveToDatabase then return end

    MySQL.insert.await('INSERT INTO player_ped_scales (citizenid, scale) VALUES (?, ?) ON DUPLICATE KEY UPDATE scale = ?', {
        citizenid, scale, scale
    })
end

-- Carregar escala do banco de dados
local function loadScale(citizenid)
    if not Config.SaveToDatabase then return Config.DefaultScale end

    local result = MySQL.query.await('SELECT scale FROM player_ped_scales WHERE citizenid = ?', {citizenid})
    if result and result[1] then
        return result[1].scale
    end

    return Config.DefaultScale
end

-- Evento: Cliente define sua própria escala
RegisterNetEvent('qbx_pedscale:server:setScale', function(scale)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Limitar escala
    if scale < Config.MinScale then scale = Config.MinScale end
    if scale > Config.MaxScale then scale = Config.MaxScale end

    -- Guardar no banco de dados
    if Config.SaveToDatabase then
        saveScale(Player.PlayerData.citizenid, scale)
    end
end)

-- Evento: Cliente pede para carregar escala
RegisterNetEvent('qbx_pedscale:server:loadScale', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local scale = loadScale(Player.PlayerData.citizenid)
    
    -- Enviar escala para o cliente
    TriggerClientEvent('qbx_pedscale:client:applyScale', src, scale)
end)

-- Comando Admin: /setscaleplayer <id> <centímetros>
RegisterCommand(Config.Commands.setscaleplayer, function(source, args)
    if not hasPermission(source) then
        QBCore.Functions.Notify(source, Config.Messages.no_permission, 'error')
        return
    end

    if not args[1] or not args[2] then
        QBCore.Functions.Notify(source, Config.Messages.usage_admin:format(Config.Commands.setscaleplayer), 'inform')
        return
    end

    local targetId = tonumber(args[1])
    local cm = tonumber(args[2])

    if not targetId or not cm then
        QBCore.Functions.Notify(source, Config.Messages.invalid_number, 'error')
        return
    end

    local TargetPlayer = QBCore.Functions.GetPlayer(targetId)
    if not TargetPlayer then
        QBCore.Functions.Notify(source, Config.Messages.player_not_found, 'error')
        return
    end

    local scale = cm / Config.DefaultHeight
    if scale < Config.MinScale then scale = Config.MinScale end
    if scale > Config.MaxScale then scale = Config.MaxScale end

    -- Guardar no banco de dados
    if Config.SaveToDatabase then
        saveScale(TargetPlayer.PlayerData.citizenid, scale)
    end

    -- Aplicar no cliente alvo
    TriggerClientEvent('qbx_pedscale:client:applyScale', targetId, scale)

    -- Notificar ambos
    QBCore.Functions.Notify(source, Config.Messages.scale_set_other:format(targetId, cm, scale), 'success')
    QBCore.Functions.Notify(targetId, Config.Messages.scale_set:format(cm, scale), 'success')
end, false)

-- Comando Admin: /resetscaleplayer <id>
RegisterCommand('resetscaleplayer', function(source, args)
    if not hasPermission(source) then
        QBCore.Functions.Notify(source, Config.Messages.no_permission, 'error')
        return
    end

    if not args[1] then
        QBCore.Functions.Notify(source, 'Uso: /resetscaleplayer <id>', 'inform')
        return
    end

    local targetId = tonumber(args[1])
    if not targetId then
        QBCore.Functions.Notify(source, Config.Messages.invalid_number, 'error')
        return
    end

    local TargetPlayer = QBCore.Functions.GetPlayer(targetId)
    if not TargetPlayer then
        QBCore.Functions.Notify(source, Config.Messages.player_not_found, 'error')
        return
    end

    -- Guardar escala padrão
    if Config.SaveToDatabase then
        saveScale(TargetPlayer.PlayerData.citizenid, Config.DefaultScale)
    end

    -- Aplicar no cliente alvo
    TriggerClientEvent('qbx_pedscale:client:applyScale', targetId, Config.DefaultScale)

    -- Notificar ambos
    QBCore.Functions.Notify(source, Config.Messages.scale_reset_other:format(targetId), 'success')
    QBCore.Functions.Notify(targetId, Config.Messages.scale_reset, 'success')
end, false)

-- Export para outros recursos
exports('setPlayerScale', function(source, scale)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end

    if scale < Config.MinScale then scale = Config.MinScale end
    if scale > Config.MaxScale then scale = Config.MaxScale end

    if Config.SaveToDatabase then
        saveScale(Player.PlayerData.citizenid, scale)
    end

    TriggerClientEvent('qbx_pedscale:client:applyScale', source, scale)
    return true
end)

exports('getPlayerScale', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return Config.DefaultScale end

    return loadScale(Player.PlayerData.citizenid)
end)

