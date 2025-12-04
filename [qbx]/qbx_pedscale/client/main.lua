local QBCore = exports['qbx_core']
local PlayerData = {}
local currentScale = Config.DefaultScale

-- Verificar se ox_lib está disponível
local hasOxLib = GetResourceState('ox_lib') == 'started'

-- Função helper para notificações (compatível com QBX)
local function Notify(message, type)
    if hasOxLib and lib and lib.notify then
        lib.notify({
            title = 'Escala',
            description = message,
            type = type or 'inform'
        })
    else
        exports.qbx_core:Notify(message, type or 'inform')
    end
end

-- Função helper para input dialog
local function InputDialog(title, options)
    if hasOxLib and lib and lib.inputDialog then
        return lib.inputDialog(title, options)
    else
        -- Fallback simples sem dialog
        return nil
    end
end

-- Função para converter centímetros para escala
local function cmToScale(cm)
    return cm / Config.DefaultHeight
end

-- Função para converter escala para centímetros
local function scaleToCm(scale)
    return math.floor(scale * Config.DefaultHeight)
end

-- Função para aplicar escala com limites
local function applyScale(scale)
    -- Limitar escala
    if scale < Config.MinScale then
        scale = Config.MinScale
        Notify(Config.Messages.too_small:format(Config.MinScale), 'error')
    elseif scale > Config.MaxScale then
        scale = Config.MaxScale
        Notify(Config.Messages.too_large:format(Config.MaxScale), 'error')
    end

    local ped = PlayerPedId()
    
    -- Verificar se a native SetPedScale existe e é uma função
    if type(SetPedScale) ~= "function" then
        print("^1[ERROR] SetPedScale não existe ou não é uma função^7")
        print("^3[INFO] Build atual: 22934 (deve funcionar)^7")
        print("^3[SOLUÇÃO]: Reconecta ao servidor (sai e entra novamente)^7")
        Notify("SetPedScale não disponível. Reconecta ao servidor.", 'error')
        return scale
    end
    
    -- Tentar aplicar a escala
    local success, err = pcall(function()
        SetPedScale(ped, scale)
    end)
    
    if not success then
        -- SetPedScale falhou
        print(string.format("^1[ERROR] SetPedScale falhou: %s^7", tostring(err)))
        print("^3[INFO] Build: 22934 - Deve funcionar, mas:")
        print("  - Reconecta ao servidor (sai e entra)")
        print("  - Verifica se OneSync está ativado^7")
        Notify("Erro ao aplicar escala. Tenta reconectar ao servidor.", 'error')
        return scale
    end
    
    -- Verificar se a escala foi aplicada (se GetPedScale existir)
    Wait(100)
    if GetPedScale and type(GetPedScale) == "function" then
        local currentPedScale = GetPedScale(ped)
        if currentPedScale and math.abs(currentPedScale - scale) > 0.01 then
            print(string.format("^3[WARNING] Escala não foi aplicada corretamente. Esperado: %.2f, Atual: %.2f^7", scale, currentPedScale))
        else
            print(string.format("^2[SUCCESS] Escala aplicada: %.2f^7", scale))
        end
    end
    
    currentScale = scale

    -- Sincronizar com servidor
    TriggerServerEvent('qbx_pedscale:server:setScale', scale)

    return scale
end

-- Comando: /scale <centímetros>
RegisterCommand(Config.Commands.scale, function(source, args)
    if not args[1] then
        Notify(Config.Messages.usage:format(Config.Commands.scale), 'inform')
        return
    end

    local cm = tonumber(args[1])
    if not cm then
        Notify(Config.Messages.invalid_number, 'error')
        return
    end

    local scale = cmToScale(cm)
    scale = applyScale(scale)

    Notify(Config.Messages.scale_set:format(cm, scale), 'success')
end, false)

-- Comando: /setscale <escala>
RegisterCommand(Config.Commands.setscale, function(source, args)
    if not args[1] then
        Notify(Config.Messages.usage_scale:format(Config.Commands.setscale), 'inform')
        return
    end

    local scale = tonumber(args[1])
    if not scale then
        Notify(Config.Messages.invalid_number, 'error')
        return
    end

    scale = applyScale(scale)

    Notify(Config.Messages.scale_set:format(scaleToCm(scale), scale), 'success')
end, false)

-- Comando: /big - Aumenta tamanho
RegisterCommand(Config.Commands.big, function()
    local newScale = currentScale + Config.BigIncrement
    newScale = applyScale(newScale)

    Notify(Config.Messages.big_used:format(newScale), 'success')
end, false)

-- Comando: /small - Diminui tamanho
RegisterCommand(Config.Commands.small, function()
    local newScale = currentScale - Config.SmallIncrement
    newScale = applyScale(newScale)

    Notify(Config.Messages.small_used:format(newScale), 'success')
end, false)

-- Comando: /resetscale - Reseta para tamanho normal
RegisterCommand(Config.Commands.reset, function()
    applyScale(Config.DefaultScale)
    Notify(Config.Messages.scale_reset, 'success')
end, false)

-- Input Dialog para definir altura
RegisterCommand('setheight', function()
    local input = InputDialog('Definir Altura', {
        {
            type = 'number',
            label = 'Altura em Centímetros',
            description = 'Altura desejada (ex: 150, 180, 200)',
            required = true,
            min = math.floor(Config.MinScale * Config.DefaultHeight),
            max = math.floor(Config.MaxScale * Config.DefaultHeight),
            default = scaleToCm(currentScale)
        }
    })

    if not input then 
        Notify('Input dialog não disponível. Usa /scale <cm> em vez disso.', 'error')
        return 
    end

    local cm = input[1]
    if not cm then return end
    
    local scale = cmToScale(cm)
    scale = applyScale(scale)

    Notify(Config.Messages.scale_set:format(cm, scale), 'success')
end, false)

-- Input Dialog para definir escala diretamente
RegisterCommand('setscaleinput', function()
    local input = InputDialog('Definir Escala', {
        {
            type = 'number',
            label = 'Escala',
            description = string.format('Escala desejada (%.2f - %.2f)', Config.MinScale, Config.MaxScale),
            required = true,
            min = Config.MinScale,
            max = Config.MaxScale,
            default = currentScale,
            step = 0.01
        }
    })

    if not input then 
        Notify('Input dialog não disponível. Usa /setscale <escala> em vez disso.', 'error')
        return 
    end

    local scale = input[1]
    if not scale then return end
    
    scale = applyScale(scale)

    Notify(Config.Messages.scale_set:format(scaleToCm(scale), scale), 'success')
end, false)

-- Evento do servidor para aplicar escala (admin) - removido, não é necessário

-- Verificar disponibilidade do SetPedScale ao iniciar
CreateThread(function()
    Wait(5000) -- Aguardar recursos e cliente carregarem completamente
    
    print("^5[DEBUG] Verificando disponibilidade do SetPedScale...^7")
    
    -- Verificar versão do FiveM primeiro
    local version = GetConvar('version', '')
    local buildNumber = version:match('v%d+%.%d+%.%d+%.(%d+)')
    if buildNumber then
        local build = tonumber(buildNumber)
        if build then
            if build >= 2189 then
                print(string.format("^2[INFO] Build do FiveM: %d (compatível)^7", build))
            else
                print(string.format("^3[WARNING] Build do FiveM: %d (requer 2189+)^7", build))
            end
        end
    end
    
    -- Verificar se SetPedScale existe
    if type(SetPedScale) == "function" then
        print("^2[SUCCESS] SetPedScale está disponível^7")
        local ped = PlayerPedId()
        if GetPedScale and type(GetPedScale) == "function" then
            local testScale = GetPedScale(ped)
            print(string.format("^2[INFO] Escala atual do ped: %.2f^7", testScale or 0))
        end
    else
        print("^1[ERROR] SetPedScale NÃO está disponível^7")
        print("^3[INFO] Possíveis causas:")
        print("  - Cliente não foi reiniciado após atualizar artifacts")
        print("  - OneSync não está corretamente ativado")
        print("  - Build do cliente não corresponde à do servidor")
        print("^3[SOLUÇÃO]:")
        print("  1. Reinicia completamente o servidor")
        print("  2. Reconecta ao servidor (sai e entra novamente)")
        print("  3. Verifica se OneSync está ativado^7")
    end
end)

-- Carregar escala ao spawnar
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = exports.qbx_core:GetPlayerData()
    Wait(1000)
    TriggerServerEvent('qbx_pedscale:server:loadScale')
end)

-- Aplicar escala quando recebida do servidor
RegisterNetEvent('qbx_pedscale:client:applyScale', function(scale)
    if scale and scale > 0 then
        applyScale(scale)
    end
end)

-- Manter escala após morte/respawn
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        Wait(100)
        if currentScale ~= Config.DefaultScale then
            applyScale(currentScale)
        end
    end
end)

-- Aplicar escala periodicamente (para garantir sincronização)
CreateThread(function()
    while true do
        Wait(5000)
        if currentScale ~= Config.DefaultScale then
            local ped = PlayerPedId()
            if DoesEntityExist(ped) then
                pcall(function()
                    SetPedScale(ped, currentScale)
                end)
            end
        end
    end
end)

