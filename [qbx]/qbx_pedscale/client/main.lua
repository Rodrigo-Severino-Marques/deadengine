local QBCore = exports['qbx_core']
local PlayerData = {}
local currentScale = Config.DefaultScale
local useSetPedScale = false -- Será definido após verificação
local useMatrixFallback = false -- Será definido após verificação

-- Verificar se ox_lib está disponível
local hasOxLib = GetResourceState('ox_lib') == 'started'

-- Verificar qual método de escala está disponível
CreateThread(function()
    Wait(2000)
    
    -- Verificar SetPedScale primeiro
    if Config.UseSetPedScale and SetPedScale and type(SetPedScale) == "function" then
        useSetPedScale = true
        print("^2[INFO] Usando SetPedScale (método oficial)^7")
    elseif Config.UseMatrixFallback then
        useMatrixFallback = true
        if Config.MatrixWarning then
            print("^3[WARNING] SetPedScale não disponível. Usando SetEntityMatrix (método alternativo)^7")
            print("^3[INFO] Limitações do método Matrix:")
            print("  - Hitbox não muda (podes passar por portas pequenas)")
            print("  - Colisões podem falhar")
            print("  - Armas podem ficar desproporcionadas")
            print("  - Podes ter problemas com veículos^7")
        end
    else
        print("^1[ERROR] Nenhum método de escala disponível^7")
    end
end)

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

-- Função para aplicar escala usando SetEntityMatrix (fallback)
-- AVISO: Este método pode causar problemas visuais e não é recomendado
local function applyScaleMatrix(ped, scale)
    -- Desativar SetEntityMatrix - causa problemas de duplicação
    -- Usar apenas SetPedScale se disponível
    return false
    
    -- CÓDIGO ANTIGO (DESATIVADO - CAUSA DUPLICAÇÃO):
    --[[
    if not GetEntityMatrix or not SetEntityMatrix then
        return false
    end
    
    local success, right, forward, up, pos = pcall(function()
        return GetEntityMatrix(ped)
    end)
    
    if not success or not right then
        return false
    end
    
    -- GetEntityMatrix retorna: right, forward, up, position (4 vetores)
    -- Multiplicar cada componente dos vetores pela escala
    local newRight = vector3(right.x * scale, right.y * scale, right.z * scale)
    local newForward = vector3(forward.x * scale, forward.y * scale, forward.z * scale)
    local newUp = vector3(up.x * scale, up.y * scale, up.z * scale)
    
    -- SetEntityMatrix: forwardX, forwardY, forwardZ, rightX, rightY, rightZ, upX, upY, upZ, atX, atY, atZ
    local setSuccess = pcall(function()
        SetEntityMatrix(ped, 
            newForward.x, newForward.y, newForward.z,  -- forward
            newRight.x, newRight.y, newRight.z,        -- right
            newUp.x, newUp.y, newUp.z,                 -- up
            pos.x, pos.y, pos.z)                       -- position
    end)
    
    return setSuccess
    --]]
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
    local success = false
    
    -- Tentar usar SetPedScale primeiro (método oficial)
    if useSetPedScale and SetPedScale and type(SetPedScale) == "function" then
        local success_pcall, err = pcall(function()
            SetPedScale(ped, scale)
        end)
        
        if success_pcall then
            success = true
            -- Verificar se foi aplicada
            Wait(100)
            if GetPedScale and type(GetPedScale) == "function" then
                local currentPedScale = GetPedScale(ped)
                if currentPedScale and math.abs(currentPedScale - scale) > 0.01 then
                    print(string.format("^3[WARNING] Escala não aplicada corretamente. Esperado: %.2f, Atual: %.2f^7", scale, currentPedScale))
                end
            end
        else
            print(string.format("^3[WARNING] SetPedScale falhou: %s. Tentando fallback...^7", tostring(err)))
        end
    end
    
    -- NÃO usar SetEntityMatrix - causa problemas de duplicação visual
    -- Se SetPedScale não funcionou, avisar o utilizador
    if not success then
        if useMatrixFallback then
            print("^1[ERROR] SetPedScale não está disponível e SetEntityMatrix foi desativado (causa duplicação visual)^7")
            print("^3[INFO] Por favor, atualiza o servidor para build 2189+ para usar SetPedScale^7")
        end
    end
    
    if not success then
        print("^1[ERROR] Não foi possível aplicar escala. Nenhum método disponível.^7")
        Notify("Erro ao aplicar escala. Verifica console.", 'error')
        return scale
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
    print(string.format("^5[DEBUG] Versão completa: %s^7", version))
    
    local buildNumber = version:match('v%d+%.%d+%.%d+%.(%d+)')
    if buildNumber then
        local build = tonumber(buildNumber)
        if build then
            if build >= 2189 then
                print(string.format("^2[INFO] Build do FiveM: %d (compatível)^7", build))
            else
                print(string.format("^3[WARNING] Build do FiveM: %d (requer 2189+)^7", build))
            end
        else
            print("^3[WARNING] Não foi possível extrair número da build^7")
        end
    else
        print("^3[WARNING] Não foi possível encontrar build na versão^7")
    end
    
    -- Verificar se SetPedScale existe de várias formas
    print("^5[DEBUG] Verificando SetPedScale...^7")
    print(string.format("^5[DEBUG] type(SetPedScale): %s^7", type(SetPedScale)))
    
    if SetPedScale ~= nil then
        if type(SetPedScale) == "function" then
            print("^2[SUCCESS] SetPedScale está disponível como função^7")
            
            -- Testar se funciona
            local ped = PlayerPedId()
            local testSuccess, testErr = pcall(function()
                SetPedScale(ped, 1.0) -- Testar com escala normal
            end)
            
            if testSuccess then
                print("^2[SUCCESS] SetPedScale funciona corretamente!^7")
                if GetPedScale and type(GetPedScale) == "function" then
                    local testScale = GetPedScale(ped)
                    print(string.format("^2[INFO] Escala atual do ped: %.2f^7", testScale or 0))
                end
            else
                print(string.format("^1[ERROR] SetPedScale existe mas falhou: %s^7", tostring(testErr)))
            end
        else
            print(string.format("^1[ERROR] SetPedScale existe mas não é função (tipo: %s)^7", type(SetPedScale)))
        end
    else
        print("^1[ERROR] SetPedScale é nil (não existe)^7")
        print("^3[INFO] Possíveis causas:")
        print("  - Cliente ainda está na build antiga (17000)")
        print("  - Cliente não foi atualizado após atualizar artifacts do servidor")
        print("  - OneSync não está corretamente ativado")
        print("^3[SOLUÇÃO]:")
        print("  1. FECHA COMPLETAMENTE o FiveM (não apenas desconecta)")
        print("  2. Abre o FiveM novamente")
        print("  3. Reconecta ao servidor")
        print("  4. O cliente deve atualizar automaticamente para a build do servidor^7")
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

-- Aplicar escala continuamente (para garantir que não para)
-- IMPORTANTE: Aplicar apenas uma vez por ped para evitar duplicações
local lastAppliedScale = Config.DefaultScale
local lastAppliedPed = 0

CreateThread(function()
    while true do
        Wait(Config.UpdateInterval)
        local ped = PlayerPedId()
        if DoesEntityExist(ped) and ped ~= 0 then
            local scaleToApply = isMenuOpen and previewScale or currentScale
            
            -- Só aplicar se mudou ou se é um ped diferente
            if (scaleToApply ~= lastAppliedScale or ped ~= lastAppliedPed) and scaleToApply ~= Config.DefaultScale then
                -- Usar APENAS SetPedScale - SetEntityMatrix causa duplicação
                if useSetPedScale and SetPedScale and type(SetPedScale) == "function" then
                    local success = pcall(function()
                        SetPedScale(ped, scaleToApply)
                    end)
                    if success then
                        lastAppliedScale = scaleToApply
                        lastAppliedPed = ped
                    end
                -- NÃO usar SetEntityMatrix - causa problemas de duplicação visual
                -- elseif useMatrixFallback then
                --     applyScaleMatrix(ped, scaleToApply)
                end
            elseif scaleToApply == Config.DefaultScale and lastAppliedScale ~= Config.DefaultScale then
                -- Resetar para escala padrão
                if useSetPedScale and SetPedScale and type(SetPedScale) == "function" then
                    pcall(function()
                        SetPedScale(ped, Config.DefaultScale)
                    end)
                    lastAppliedScale = Config.DefaultScale
                    lastAppliedPed = ped
                end
            end
        end
    end
end)

-- Menu Avançado de Escala com Barra Deslizante (NUI)
local isMenuOpen = false
local previewScale = currentScale
local useNUI = true -- Usar NUI em vez de menu de contexto

-- Função para aplicar escala em tempo real (preview - não guarda)
local function applyPreviewScale(scale, silent)
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return end
    
    -- Limitar escala
    if scale < Config.MinScale then scale = Config.MinScale end
    if scale > Config.MaxScale then scale = Config.MaxScale end
    
    -- Aplicar escala APENAS com SetPedScale - SetEntityMatrix causa duplicação
    if useSetPedScale and SetPedScale and type(SetPedScale) == "function" then
        pcall(function()
            SetPedScale(ped, scale)
        end)
    -- NÃO usar SetEntityMatrix - causa problemas de duplicação visual
    -- elseif useMatrixFallback then
    --     applyScaleMatrix(ped, scale)
    end
    
    previewScale = scale
end

-- Thread para manter escala aplicada continuamente enquanto o menu está aberto
-- REMOVIDO - A thread principal já faz isto, evitar duplicação
-- CreateThread(function()
--     while true do
--         Wait(Config.UpdateInterval)
--         if isMenuOpen then
--             applyPreviewScale(previewScale, true)
--         end
--     end
-- end)

-- Thread para atualizar NUI com valores atuais
CreateThread(function()
    while true do
        Wait(100)
        if isMenuOpen then
            SendNUIMessage({
                type = 'update',
                scale = previewScale
            })
        end
    end
end)

-- Abrir menu NUI avançado de escala
local function openScaleMenu()
    if isMenuOpen then return end
    
    isMenuOpen = true
    previewScale = currentScale
    
    -- Abrir NUI
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'open',
        scale = currentScale,
        minScale = Config.MinScale,
        maxScale = Config.MaxScale,
        defaultHeight = Config.DefaultHeight
    })
    
    -- Thread para fechar menu se ESC for pressionado
    CreateThread(function()
        while isMenuOpen do
            Wait(0)
            if IsControlJustPressed(0, 322) then -- ESC
                closeScaleMenu(true)
                break
            end
        end
    end)
end

-- Fechar menu NUI
local function closeScaleMenu(cancelled)
    if not isMenuOpen then return end
    
    isMenuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'close'
    })
    
    if cancelled then
        applyPreviewScale(currentScale, true)
        Wait(100)
        applyScale(currentScale)
        Notify('Alterações canceladas', 'inform')
    end
end

-- Callbacks NUI
RegisterNUICallback('updateScale', function(data, cb)
    if data.scale then
        previewScale = math.max(Config.MinScale, math.min(Config.MaxScale, data.scale))
        applyPreviewScale(previewScale)
    end
    cb('ok')
end)

RegisterNUICallback('confirmScale', function(data, cb)
    if data.scale then
        local finalScale = math.max(Config.MinScale, math.min(Config.MaxScale, data.scale))
        applyScale(finalScale)
        Notify(Config.Messages.scale_set:format(scaleToCm(finalScale), finalScale), 'success')
    end
    closeScaleMenu(false)
    cb('ok')
end)

RegisterNUICallback('cancelScale', function(data, cb)
    closeScaleMenu(true)
    cb('ok')
end)

-- Comando para abrir menu
RegisterCommand('scalemenu', function()
    if not Config.EnableMenu then
        Notify('Menu de escala desativado', 'error')
        return
    end
    
    openScaleMenu()
end, false)

-- Tecla para abrir menu (se configurado)
if Config.MenuKey and Config.MenuKey ~= false then
    RegisterKeyMapping('scalemenu', 'Abrir Menu de Escala', 'keyboard', Config.MenuKey)
end

