local config = require 'qbx_population.config'

-- 🚨 Inicialização: Desativar serviços de dispatch EXCETO ambulâncias
CreateThread(function()
    if config.policeTraffic.disablePoliceResponse then
        -- Desativa dispatch services EXCETO ambulâncias (5)
        for i = 1, 15 do
            if i ~= 5 then  -- Mantém ambulâncias ativas
                EnableDispatchService(i, false)
            else
                EnableDispatchService(i, true)  -- ✅ Ativa ambulâncias
            end
        end
        
        -- Lista completa de dispatch services:
        -- 1: Police Automobile ❌
        -- 2: Police Helicopter ❌
        -- 3: Fire Department ❌
        -- 4: SWAT Automobile ❌
        -- 5: Ambulance ✅ ATIVO
        -- 6: Police Riders ❌
        -- 7: Police Vehicle Request ❌
        -- 8: Police Roadblock ❌
        -- 9: PoliceAutomobileWaitPulledOver ❌
        -- 10: PoliceAutomobileWaitCruising ❌
        -- 11: Gang Members ❌
        -- 12: SWAT Helicopter ❌
        -- 13: Police Boat ❌
        -- 14: Army Vehicle ❌
        -- 15: Biker Backup ❌
    end
end)

-- 🎯 Função para aplicar a densidade populacional
local function ApplyPopulationDensity(pedMultiplier, vehicleMultiplier)
    -- Peds (NPCs a pé)
    SetPedDensityMultiplierThisFrame(pedMultiplier or config.pedDensity)
    SetScenarioPedDensityMultiplierThisFrame(config.scenarioPedDensity, config.scenarioPedDensity)
    
    -- Veículos
    SetVehicleDensityMultiplierThisFrame(vehicleMultiplier or config.vehicleDensity)
    SetRandomVehicleDensityMultiplierThisFrame(config.randomVehicleDensity)
    SetParkedVehicleDensityMultiplierThisFrame(config.parkedVehicleDensity)
end

-- 🗺️ Função para verificar se o jogador está numa zona customizada
local function GetCustomZoneDensity(playerCoords)
    for _, zone in ipairs(config.customZones) do
        local distance = #(playerCoords - zone.coords)
        
        if distance <= zone.radius then
            if config.debugMode then
                print(string.format("[POPULAÇÃO] Entraste na zona: %s (Distância: %.2fm)", zone.name, distance))
            end
            return zone.pedDensity, zone.vehicleDensity
        end
    end
    
    return nil, nil
end

-- 👮 Função para controlar tráfego de polícia
local function ManagePoliceTraffic()
    local policeConfig = config.policeTraffic
    
    if not policeConfig.enabled then
        -- Desativa tráfego de polícia completamente
        SetPoliceIgnorePlayer(PlayerId(), true)
        SetMaxWantedLevel(0)
        SetCreateRandomCops(false)
        SetCreateRandomCopsNotOnScenarios(false)
        SetCreateRandomCopsOnScenarios(false)
        return
    end
    
    -- Controle de densidade de polícia
    if policeConfig.vehicleDensity > 0 then
        SetCreateRandomCops(true)
        SetCreateRandomCopsNotOnScenarios(true)
        SetCreateRandomCopsOnScenarios(true)
    else
        SetCreateRandomCops(false)
        SetCreateRandomCopsNotOnScenarios(false)
        SetCreateRandomCopsOnScenarios(false)
    end
    
    -- Desativar wanted level
    if policeConfig.disableWantedLevel then
        SetMaxWantedLevel(0)
        if GetPlayerWantedLevel(PlayerId()) > 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end
    end
    
    -- Desativar resposta policial
    if policeConfig.disablePoliceResponse then
        SetPoliceIgnorePlayer(PlayerId(), true)
        SetDispatchCopsForPlayer(PlayerId(), false)
    end
    
    -- Desativar perseguições
    if policeConfig.disablePolicePursuit then
        SetPoliceRadarBlips(false)
        SetPlayerCanBeHassledByGangs(PlayerId(), false)
    end
    
    -- Desativar helicópteros de polícia
    if policeConfig.disablePoliceHelicopters then
        SetPlayerCanUseCover(PlayerId(), false)
        EnableDispatchService(15, false) -- Police helicopter
    end
    
    -- Desativar scanner de polícia
    if policeConfig.disablePoliceScanner then
        StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
    end
end

-- 🛣️ Função auxiliar: garantir spawn de viaturas em nodes de estrada
local function FindClosestRoadPosition(targetCoords, searchRadius, maxAttempts)
    local maxTries = maxAttempts or 6
    local radius = searchRadius or 35.0
    local baseCoords = vector4(targetCoords.x, targetCoords.y, targetCoords.z, targetCoords.w or 0.0)
    
    for attempt = 1, maxTries do
        local found, nodeCoords, heading = GetClosestVehicleNodeWithHeading(baseCoords.x, baseCoords.y, baseCoords.z, 1, 3.0, 0)
        if found and nodeCoords then
            return vector4(nodeCoords.x, nodeCoords.y, nodeCoords.z, heading or baseCoords.w), true
        end
        
        local angle = math.random() * 2.0 * math.pi
        local distance = radius * (attempt / maxTries)
        baseCoords = vector4(
            targetCoords.x + math.cos(angle) * distance,
            targetCoords.y + math.sin(angle) * distance,
            targetCoords.z,
            targetCoords.w or 0.0
        )
    end
    
    return vector4(targetCoords.x, targetCoords.y, targetCoords.z, targetCoords.w or 0.0), false
end

-- 🚶 Função auxiliar: procurar passeio/navmesh seguro para peds
local function FindSidewalkPosition(areaCenter, radius, maxAttempts)
    local maxTries = maxAttempts or 10
    
    for attempt = 1, maxTries do
        local angle = math.random() * 2.0 * math.pi
        local distance = math.random() * radius
        local candidate = vector3(
            areaCenter.x + math.cos(angle) * distance,
            areaCenter.y + math.sin(angle) * distance,
            areaCenter.z + 1.0
        )
        
        local found, safeCoords = GetSafeCoordForPed(candidate.x, candidate.y, candidate.z, false, 16)
        if found then
            local success, groundZ = GetGroundZFor_3dCoord(safeCoords.x, safeCoords.y, safeCoords.z, false)
            if success then
                safeCoords = vector3(safeCoords.x, safeCoords.y, groundZ)
            end
            
            return safeCoords, true
        end
    end
    
    return vector3(areaCenter.x, areaCenter.y, areaCenter.z), false
end

-- 🔄 Loop principal de controle de população
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        -- Verifica se o jogador está numa zona customizada
        local customPedDensity, customVehicleDensity = GetCustomZoneDensity(playerCoords)
        
        -- Aplica a densidade (customizada ou padrão)
        ApplyPopulationDensity(customPedDensity, customVehicleDensity)
        
        -- Desativa peds/veículos completamente se configurado
        if config.disableNPCPeds then
            SetPedDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        end
        
        if config.disableNPCVehicles then
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
        end
        
        -- Gerencia tráfego de polícia
        ManagePoliceTraffic()
        
        Wait(config.updateInterval)
    end
end)

-- 📊 Comando de Debug (Admin)
if config.debugMode then
    RegisterCommand('population_debug', function()
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        print("═════════════════════════════════════")
        print("🔍 DEBUG DE POPULAÇÃO")
        print("═════════════════════════════════════")
        print(string.format("📍 Coordenadas: %.2f, %.2f, %.2f", playerCoords.x, playerCoords.y, playerCoords.z))
        print(string.format("🚶 Densidade de Peds: %.2f", config.pedDensity))
        print(string.format("🚗 Densidade de Veículos: %.2f", config.vehicleDensity))
        
        local customPed, customVeh = GetCustomZoneDensity(playerCoords)
        if customPed or customVeh then
            print("🎯 ZONA CUSTOMIZADA ATIVA:")
            print(string.format("   Peds: %.2f | Veículos: %.2f", customPed or config.pedDensity, customVeh or config.vehicleDensity))
        else
            print("🌍 Densidade padrão ativa")
        end
        print("═════════════════════════════════════")
    end, false)
end

-- ╔════════════════════════════════════════════════════════════════╗
-- ║            SISTEMA DE PEDS AMBIENTAIS A CAMINHAR               ║
-- ╚════════════════════════════════════════════════════════════════╝

if config.ambientPeds and config.ambientPeds.enabled then
    local ambientConfig = config.ambientPeds
    local spawnedAmbientPeds = {}
    
    local function CalculateAmbientTarget()
        local playerCount = #GetActivePlayers()
        local basePeds = ambientConfig.basePeds or 0
        local playersPerPed = math.max(ambientConfig.playersPerPed or 1, 1)
        local extra = math.floor(playerCount / playersPerPed)
        return math.min(basePeds + extra, ambientConfig.maxPeds or (basePeds + extra))
    end
    
    local function GetModelPool(area)
        if area.models and #area.models > 0 then
            return area.models
        end
        return ambientConfig.models or {}
    end
    
    local function AssignAmbientBehavior(ped, area)
        local behaviorConfig = ambientConfig.behavior or {}
        local areaBehavior = area.behavior or {}
        
        local wanderRadius = areaBehavior.wanderRadius or (area.radius * (behaviorConfig.wanderRadiusMultiplier or 0.6))
        local scenarioChance = areaBehavior.scenarioChance or behaviorConfig.scenarioChance or 0.0
        local goToCoordChance = areaBehavior.goToCoordChance or behaviorConfig.goToCoordChance or 0.0
        local walkSpeed = areaBehavior.walkSpeed or behaviorConfig.walkSpeed or 1.0
        local reassignInterval = behaviorConfig.reassignInterval or 25000
        local reassignVariance = behaviorConfig.reassignIntervalVariance or 10000
        
        ClearPedTasks(ped)
        
        if scenarioChance > 0 and math.random() < scenarioChance then
            TaskUseNearestScenarioToCoord(ped, area.coords.x, area.coords.y, area.coords.z, math.max(wanderRadius, 20.0), 0)
        elseif goToCoordChance > 0 and math.random() < goToCoordChance then
            local targetCoords, hasTarget = FindSidewalkPosition(area.coords, wanderRadius)
            if hasTarget then
                TaskGoStraightToCoord(ped, targetCoords.x, targetCoords.y, targetCoords.z, walkSpeed, -1, 0.0, 0.0)
                SetPedDesiredMoveBlendRatio(ped, walkSpeed)
            else
                TaskWanderInArea(ped, area.coords.x, area.coords.y, area.coords.z, wanderRadius, walkSpeed, 1.0)
            end
        else
            TaskWanderInArea(ped, area.coords.x, area.coords.y, area.coords.z, wanderRadius, walkSpeed, 1.0)
        end
        
        SetPedKeepTask(ped, true)
        return GetGameTimer() + reassignInterval + math.random(0, reassignVariance)
    end
    
    local function SpawnAmbientPed(area)
        local models = GetModelPool(area)
        if not models or #models == 0 then
            return nil
        end
        
        local modelName = models[math.random(#models)]
        local modelHash = GetHashKey(modelName)
        
        RequestModel(modelHash)
        local attempts = 0
        while not HasModelLoaded(modelHash) and attempts < 40 do
            attempts = attempts + 1
            Wait(25)
        end
        
        if not HasModelLoaded(modelHash) then
            return nil
        end
        
        local spawnCoords = area.coords
        local sidewalkCoords, hasSidewalk = FindSidewalkPosition(area.coords, area.radius)
        if hasSidewalk then
            spawnCoords = sidewalkCoords
        end
        
        local heading = math.random() * 360.0
        local ped = CreatePed(4, modelHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, false)
        if not DoesEntityExist(ped) then
            SetModelAsNoLongerNeeded(modelHash)
            return nil
        end
        
        SetEntityAsMissionEntity(ped, true, true)
        PlaceObjectOnGroundProperly(ped)
        SetBlockingOfNonTemporaryEvents(ped, false)
        SetPedCanRagdoll(ped, true)
        SetPedCanPlayAmbientAnims(ped, true)
        SetPedCanPlayAmbientBaseAnims(ped, true)
        SetPedFleeAttributes(ped, 0, false)
        SetPedKeepTask(ped, true)
        SetPedDesiredMoveBlendRatio(ped, 1.0)
        
        local nextBehaviorUpdate = AssignAmbientBehavior(ped, area)
        SetModelAsNoLongerNeeded(modelHash)
        
        return {
            entity = ped,
            area = area,
            nextBehaviorUpdate = nextBehaviorUpdate
        }
    end
    
    local function CountPedsInArea(areaName)
        local count = 0
        for _, pedData in ipairs(spawnedAmbientPeds) do
            if pedData.area.name == areaName then
                count = count + 1
            end
        end
        return count
    end
    
    local function ManageAmbientPeds(playerCoords)
        for index = #spawnedAmbientPeds, 1, -1 do
            local pedData = spawnedAmbientPeds[index]
            local ped = pedData.entity
            
            if not DoesEntityExist(ped) then
                table.remove(spawnedAmbientPeds, index)
            else
                local pedCoords = GetEntityCoords(ped)
                local distance = #(playerCoords - pedCoords)
                if distance > (ambientConfig.despawnDistance or 170.0) then
                    DeleteEntity(ped)
                    table.remove(spawnedAmbientPeds, index)
                end
            end
        end
    end
    
    local function RefreshAmbientBehaviors(currentTime)
        for i = #spawnedAmbientPeds, 1, -1 do
            local pedData = spawnedAmbientPeds[i]
            local ped = pedData.entity
            
            if not DoesEntityExist(ped) then
                table.remove(spawnedAmbientPeds, i)
            else
                if pedData.nextBehaviorUpdate <= currentTime or IsPedStill(ped) then
                    pedData.nextBehaviorUpdate = AssignAmbientBehavior(ped, pedData.area)
                end
            end
        end
    end
    
    local function SpawnAmbientPedsAsNeeded(playerCoords)
        local areas = ambientConfig.areas or {}
        if #areas == 0 then
            return
        end
        
        local targetTotal = CalculateAmbientTarget()
        if #spawnedAmbientPeds >= targetTotal then
            return
        end
        
        for _, area in ipairs(areas) do
            if #spawnedAmbientPeds >= targetTotal then
                break
            end
            
            local distance = #(playerCoords - area.coords)
            if distance <= (ambientConfig.spawnDistance or 120.0) then
                local areaCount = CountPedsInArea(area.name)
                local maxAreaPeds = area.maxPeds or 3
                
                while areaCount < maxAreaPeds and #spawnedAmbientPeds < targetTotal do
                    local pedData = SpawnAmbientPed(area)
                    if not pedData then
                        break
                    end
                    
                    table.insert(spawnedAmbientPeds, pedData)
                    areaCount = areaCount + 1
                end
            end
        end
    end
    
    CreateThread(function()
        Wait(4000)
        while true do
            local playerPed = PlayerPedId()
            if not playerPed or playerPed == 0 then
                Wait(ambientConfig.updateInterval or 4000)
            else
                local playerCoords = GetEntityCoords(playerPed)
                ManageAmbientPeds(playerCoords)
                SpawnAmbientPedsAsNeeded(playerCoords)
                RefreshAmbientBehaviors(GetGameTimer())
                Wait(ambientConfig.updateInterval or 4000)
            end
        end
    end)
    
    AddEventHandler('onResourceStop', function(resourceName)
        if GetCurrentResourceName() ~= resourceName then
            return
        end
        
        for _, pedData in ipairs(spawnedAmbientPeds) do
            if DoesEntityExist(pedData.entity) then
                DeleteEntity(pedData.entity)
            end
        end
    end)
end

-- ╔════════════════════════════════════════════════════════════════╗
-- ║          SISTEMA DE PATRULHAS POLICIAIS CUSTOMIZADAS          ║
-- ╚════════════════════════════════════════════════════════════════╝

if config.policePatrols and config.policePatrols.enabled then
    
    -- 📊 Variáveis de Tracking de Entidades
    local spawnedPatrolVehicles = {}  -- {entity, route, waypointIndex, driver}
    local spawnedPatrolPeds = {}      -- {entity, area}
    
    -- 🎯 Função: Calcular quantidade dinâmica de patrulhas baseado em jogadores online
    local function CalculatePatrolCount()
        local playerCount = #GetActivePlayers()
        local patrolConfig = config.policePatrols
        
        -- Calcular viaturas
        local extraVehicles = math.floor(playerCount / patrolConfig.playersPerUnit)
        local vehicleCount = math.min(
            patrolConfig.basePatrols.vehicles + extraVehicles,
            patrolConfig.maxVehicles
        )
        
        -- Calcular peds
        local extraPeds = math.floor(playerCount / patrolConfig.playersPerUnit)
        local pedCount = math.min(
            patrolConfig.basePatrols.peds + extraPeds,
            patrolConfig.maxPeds
        )
        
        -- Aplicar redução noturna se for período noturno
        if IsNightTime() then
            pedCount = math.floor(pedCount * patrolConfig.nightReduction.peds)
            vehicleCount = math.floor(vehicleCount * patrolConfig.nightReduction.vehicles)
        end
        
        return vehicleCount, pedCount
    end
    
    -- 🌙 Função: Verificar se é período noturno (22:00 - 06:00)
    function IsNightTime()
        local hour = GetClockHours()
        return hour >= 22 or hour < 6
    end
    
    -- 🚫 Função: Tornar ped completamente não-reativo (CRÍTICO)
    local function MakePedNonReactive(ped)
        -- Bloqueia reações a eventos temporários
        SetBlockingOfNonTemporaryEvents(ped, true)
        
        -- Desativa fuga
        SetPedFleeAttributes(ped, 0, false)
        
        -- Desativa combate completamente
        SetPedCombatAttributes(ped, 17, true)  -- BF_CanFightArmedPedsWhenNotArmed
        SetPedCombatAttributes(ped, 46, true)  -- BF_AlwaysFight
        SetPedCombatAttributes(ped, 5, true)   -- BF_CanTauntInVehicle
        SetPedCombatAttributes(ped, 1, true)   -- BF_CanUseCover
        
        -- Define relação neutra com jogador
        SetPedRelationshipGroupHash(ped, GetHashKey("PLAYER"))
        
        
        -- Configurações de comportamento
        SetEntityInvincible(ped, config.policePatrols.behavior.invincible)
        SetPedCanBeTargetted(ped, false)
        SetPedCanBeTargettedByPlayer(ped, PlayerId(), false)
        SetPedCanBeTargettedByTeam(ped, 0, false)
        
        -- Desativa reações a crimes
        SetPedAsNoLongerNeeded(ped)
        SetEntityAsMissionEntity(ped, true, true)
    end
    
    -- 🚔 Função: Spawnar viatura de patrulha
    local function SpawnPatrolVehicle(route)
        local patrolConfig = config.policePatrols
        local spawnCoords = route.spawnCoords
        local roadSpawnCoords = spawnCoords
        
        if spawnCoords then
            local nodeCoords, hasNode = FindClosestRoadPosition(spawnCoords, 40.0, 8)
            if hasNode then
                roadSpawnCoords = nodeCoords
            end
        end
        
        -- Escolhe modelo aleatório de viatura
        local modelName = patrolConfig.vehicleModels[math.random(#patrolConfig.vehicleModels)]
        local modelHash = GetHashKey(modelName)
        
        -- Request do modelo
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(50)
        end
        
        -- Spawna a viatura
        local vehicle = CreateVehicle(
            modelHash,
            roadSpawnCoords.x,
            roadSpawnCoords.y,
            roadSpawnCoords.z,
            roadSpawnCoords.w,
            true,
            false
        )
        
        SetVehicleOnGroundProperly(vehicle)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleDoorsLocked(vehicle, 2)  -- Locked
        SetVehicleSiren(vehicle, false)
        
        -- Escolhe modelo aleatório de ped
        local pedModelName = patrolConfig.pedModels[math.random(#patrolConfig.pedModels)]
        local pedModelHash = GetHashKey(pedModelName)
        
        RequestModel(pedModelHash)
        while not HasModelLoaded(pedModelHash) do
            Wait(50)
        end
        
        -- Spawna o motorista
        local driver = CreatePedInsideVehicle(
            vehicle,
            4,  -- PED_TYPE_CIVMALE
            pedModelHash,
            -1,  -- Driver seat
            true,
            false
        )
        
        -- Configura o motorista para ser não-reativo
        MakePedNonReactive(driver)
        
        -- Configura comportamento de condução
        SetDriverAbility(driver, 1.0)
        SetDriverAggressiveness(driver, 0.0)
        
        -- Normaliza waypoints para nodes de estrada
        local sanitizedWaypoints = nil
        if route.patrolType == "fixed" and route.waypoints then
            sanitizedWaypoints = {}
            for index, waypoint in ipairs(route.waypoints) do
                local roadWaypoint = FindClosestRoadPosition(vector4(waypoint.x, waypoint.y, waypoint.z, roadSpawnCoords.w), 30.0, 6)
                sanitizedWaypoints[index] = vector3(roadWaypoint.x, roadWaypoint.y, roadWaypoint.z)
            end
        end
        
        -- Inicia patrulha
        if route.patrolType == "fixed" and sanitizedWaypoints and #sanitizedWaypoints > 0 then
            -- Patrulha com waypoints fixos
            local firstWaypoint = sanitizedWaypoints[1]
            TaskVehicleDriveToCoordLongrange(
                driver,
                vehicle,
                firstWaypoint.x,
                firstWaypoint.y,
                firstWaypoint.z,
                patrolConfig.behavior.drivingSpeed,
                patrolConfig.behavior.drivingStyle,
                10.0
            )
        else
            -- Patrulha aleatória (wander)
            TaskVehicleDriveWander(
                driver,
                vehicle,
                patrolConfig.behavior.drivingSpeed,
                patrolConfig.behavior.drivingStyle
            )
        end
        
        SetModelAsNoLongerNeeded(modelHash)
        SetModelAsNoLongerNeeded(pedModelHash)
        
        return {
            entity = vehicle,
            driver = driver,
            route = {
                name = route.name,
                patrolType = route.patrolType,
                waypoints = sanitizedWaypoints,
                wanderRadius = route.wanderRadius,
                spawnCoords = roadSpawnCoords
            },
            waypointIndex = 1
        }
    end
    
    -- 👮 Função: Spawnar ped de patrulha a pé
    local function SpawnPatrolPed(area)
        local patrolConfig = config.policePatrols
        
        -- Escolhe modelo aleatório
        local pedModelName = patrolConfig.pedModels[math.random(#patrolConfig.pedModels)]
        local pedModelHash = GetHashKey(pedModelName)
        
        RequestModel(pedModelHash)
        while not HasModelLoaded(pedModelHash) do
            Wait(50)
        end
        
        -- Procura posição segura no passeio dentro da área
        local spawnCoords = area.coords
        local sidewalkCoords = FindSidewalkPosition(area.coords, area.radius)
        if sidewalkCoords then
            spawnCoords = sidewalkCoords
        end
        
        local pedHeading = math.random() * 360.0
        
        -- Spawna o ped
        local ped = CreatePed(
            4,  -- PED_TYPE_CIVMALE
            pedModelHash,
            spawnCoords.x,
            spawnCoords.y,
            spawnCoords.z,
            pedHeading,
            true,
            false
        )
        PlaceObjectOnGroundProperly(ped)
        
        -- Configura para ser não-reativo
        MakePedNonReactive(ped)
        
        -- Define tarefa de patrulha a pé (wandering na área)
        TaskWanderInArea(ped, area.coords.x, area.coords.y, area.coords.z, area.radius, 1.0, 1.0)
        
        SetModelAsNoLongerNeeded(pedModelHash)
        
        return {
            entity = ped,
            area = area
        }
    end
    
    -- 🗑️ Função: Limpar entidade
    local function DeletePatrolEntity(entityData, isVehicle)
        if isVehicle then
            if DoesEntityExist(entityData.driver) then
                DeleteEntity(entityData.driver)
            end
            if DoesEntityExist(entityData.entity) then
                DeleteEntity(entityData.entity)
            end
        else
            if DoesEntityExist(entityData.entity) then
                DeleteEntity(entityData.entity)
            end
        end
    end
    
    -- 📏 Função: Verificar distância e gerenciar entidades
    local function ManagePatrolEntities()
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local patrolConfig = config.policePatrols
        
        -- Gerenciar viaturas
        for i = #spawnedPatrolVehicles, 1, -1 do
            local vehicleData = spawnedPatrolVehicles[i]
            
            if DoesEntityExist(vehicleData.entity) then
                local vehicleCoords = GetEntityCoords(vehicleData.entity)
                local distance = #(playerCoords - vehicleCoords)
                
                -- Despawn se muito longe
                if distance > patrolConfig.despawnDistance then
                    DeletePatrolEntity(vehicleData, true)
                    table.remove(spawnedPatrolVehicles, i)
                else
                    -- Verificar se precisa ir para próximo waypoint (apenas rotas fixas)
                    if vehicleData.route.patrolType == "fixed" and vehicleData.route.waypoints and #vehicleData.route.waypoints > 0 then
                        local currentWaypoint = vehicleData.route.waypoints[vehicleData.waypointIndex]
                        if currentWaypoint then
                            local waypointDistance = #(vehicleCoords - currentWaypoint)
                            
                            -- Se chegou perto do waypoint, vai para o próximo
                            if waypointDistance < 10.0 then
                                vehicleData.waypointIndex = vehicleData.waypointIndex + 1
                                if vehicleData.waypointIndex > #vehicleData.route.waypoints then
                                    vehicleData.waypointIndex = 1
                                end
                                
                                local nextWaypoint = vehicleData.route.waypoints[vehicleData.waypointIndex]
                                if nextWaypoint then
                                    TaskVehicleDriveToCoordLongrange(
                                        vehicleData.driver,
                                        vehicleData.entity,
                                        nextWaypoint.x,
                                        nextWaypoint.y,
                                        nextWaypoint.z,
                                        patrolConfig.behavior.drivingSpeed,
                                        patrolConfig.behavior.drivingStyle,
                                        10.0
                                    )
                                end
                            end
                        end
                    end
                end
            else
                -- Entidade foi deletada pelo engine, remove da lista
                table.remove(spawnedPatrolVehicles, i)
            end
        end
        
        -- Gerenciar peds
        for i = #spawnedPatrolPeds, 1, -1 do
            local pedData = spawnedPatrolPeds[i]
            
            if DoesEntityExist(pedData.entity) then
                local pedCoords = GetEntityCoords(pedData.entity)
                local distance = #(playerCoords - pedCoords)
                
                -- Despawn se muito longe
                if distance > patrolConfig.despawnDistance then
                    DeletePatrolEntity(pedData, false)
                    table.remove(spawnedPatrolPeds, i)
                end
            else
                -- Entidade foi deletada pelo engine, remove da lista
                table.remove(spawnedPatrolPeds, i)
            end
        end
    end
    
    -- 🔄 Função: Spawnar novas patrulhas conforme necessário
    local function SpawnPatrolsAsNeeded()
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local patrolConfig = config.policePatrols
        
        local targetVehicles, targetPeds = CalculatePatrolCount()
        
        -- Spawnar viaturas se necessário
        if #spawnedPatrolVehicles < targetVehicles then
            for _, route in ipairs(patrolConfig.fixedVehicleRoutes) do
                if #spawnedPatrolVehicles >= targetVehicles then break end
                
                -- Verifica se jogador está próximo o suficiente
                local distance = #(playerCoords - vector3(route.spawnCoords.x, route.spawnCoords.y, route.spawnCoords.z))
                
                if distance <= patrolConfig.spawnDistance then
                    -- Verifica se já existe uma viatura nesta rota
                    local routeExists = false
                    for _, v in ipairs(spawnedPatrolVehicles) do
                        if v.route.name == route.name then
                            routeExists = true
                            break
                        end
                    end
                    
                    if not routeExists then
                        local vehicleData = SpawnPatrolVehicle(route)
                        if vehicleData then
                            table.insert(spawnedPatrolVehicles, vehicleData)
                        end
                    end
                end
            end
        end
        
        -- Spawnar peds se necessário
        if #spawnedPatrolPeds < targetPeds then
            for _, area in ipairs(patrolConfig.pedPatrolAreas) do
                if #spawnedPatrolPeds >= targetPeds then break end
                
                -- Verifica se jogador está próximo o suficiente
                local distance = #(playerCoords - area.coords)
                
                if distance <= patrolConfig.spawnDistance then
                    -- Conta quantos peds já existem nesta área
                    local pedsInArea = 0
                    for _, p in ipairs(spawnedPatrolPeds) do
                        if p.area.name == area.name then
                            pedsInArea = pedsInArea + 1
                        end
                    end
                    
                    -- Spawna se ainda não atingiu o máximo da área
                    if pedsInArea < area.maxPeds then
                        local pedData = SpawnPatrolPed(area)
                        if pedData then
                            table.insert(spawnedPatrolPeds, pedData)
                        end
                    end
                end
            end
        end
    end
    
    -- 🔄 Loop principal de gerenciamento de patrulhas
    CreateThread(function()
        -- Aguarda o jogo carregar completamente
        Wait(5000)
        
        while true do
            if config.policePatrols.enabled then
                ManagePatrolEntities()
                SpawnPatrolsAsNeeded()
            end
            
            Wait(config.policePatrols.updateInterval)
        end
    end)
    
    -- 📊 Comando de Debug para patrulhas
    RegisterCommand('policepatrol_debug', function()
        local vehicleCount, pedCount = CalculatePatrolCount()
        local isNight = IsNightTime()
        local playerCount = #GetActivePlayers()
        
        print("═════════════════════════════════════")
        print("🚔 DEBUG DE PATRULHAS POLICIAIS")
        print("═════════════════════════════════════")
        print(string.format("👥 Jogadores Online: %d", playerCount))
        print(string.format("🌙 Período Noturno: %s", isNight and "Sim" or "Não"))
        print(string.format("🚗 Viaturas Target: %d | Spawned: %d", vehicleCount, #spawnedPatrolVehicles))
        print(string.format("👮 Peds Target: %d | Spawned: %d", pedCount, #spawnedPatrolPeds))
        print("")
        print("📍 Viaturas Ativas:")
        for i, v in ipairs(spawnedPatrolVehicles) do
            print(string.format("  %d. %s (Waypoint: %d)", i, v.route.name, v.waypointIndex))
        end
        print("")
        print("📍 Peds Ativos:")
        for i, p in ipairs(spawnedPatrolPeds) do
            print(string.format("  %d. %s", i, p.area.name))
        end
        print("═════════════════════════════════════")
    end, false)
    
    -- 🗑️ Limpeza ao descarregar o recurso
    AddEventHandler('onResourceStop', function(resourceName)
        if GetCurrentResourceName() == resourceName then
            -- Limpa todas as viaturas
            for _, vehicleData in ipairs(spawnedPatrolVehicles) do
                DeletePatrolEntity(vehicleData, true)
            end
            
            -- Limpa todos os peds
            for _, pedData in ipairs(spawnedPatrolPeds) do
                DeletePatrolEntity(pedData, false)
            end
        end
    end)
    
end

-- 📝 Log de inicialização
if config.debugMode then
    CreateThread(function()
        Wait(2000)
        print("═════════════════════════════════════")
        print("✅ Sistema de População Carregado")
        print("═════════════════════════════════════")
        print(string.format("🚶 Peds: %.0f%%", config.pedDensity * 100))
        print(string.format("🚗 Veículos: %.0f%%", config.vehicleDensity * 100))
        print(string.format("🎭 Zonas Customizadas: %d", #config.customZones))
        if config.policePatrols and config.policePatrols.enabled then
            print(string.format("🚔 Patrulhas Policiais: Ativo"))
        end
        print("═════════════════════════════════════")
    end)
end

