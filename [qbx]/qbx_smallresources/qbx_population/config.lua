return {
    -- ╔════════════════════════════════════════════════════════════════╗
    -- ║          CONFIGURAÇÃO DE DENSIDADE POPULACIONAL                ║
    -- ╠════════════════════════════════════════════════════════════════╣
    -- ║ VALORES: 0.0 a 1.0                                            ║
    -- ║ 0.0 = Sem NPCs/Veículos | 1.0 = Densidade Máxima             ║
    -- ╚════════════════════════════════════════════════════════════════╝

    -- 🚶 DENSIDADE DE PEDS (NPCs a pé)
    pedDensity = 0.8,                    -- Quantidade de peds normais (0.0 a 1.0) [Aumentado para 80%]
    scenarioPedDensity = 0.8,            -- Peds em cenários (sentados, fumando, etc.) [Aumentado para 80%]
    
    -- 🚗 DENSIDADE DE VEÍCULOS
    vehicleDensity = 0.8,                -- Veículos em movimento (0.0 a 1.0) [Aumentado para 80%]
    randomVehicleDensity = 0.8,          -- Veículos aleatórios [Aumentado para 80%]
    parkedVehicleDensity = 0.8,          -- Veículos estacionados [Aumentado para 80%]
    
    -- 🎭 COMPORTAMENTO DOS NPCS
    disableNPCPeds = false,              -- Desativa TODOS os peds? (true/false)
    disableNPCVehicles = false,          -- Desativa TODOS os veículos? (true/false)
    
    -- 📍 ZONAS DE DENSIDADE CUSTOMIZADA
    -- Áreas específicas com densidade diferente
    customZones = {
        -- Centro da Cidade (Legion Square / Pillbox Hill)
        {
            name = "Centro da Cidade - Legion Square",
            coords = vector3(195.0, -933.0, 30.0),    -- Legion Square
            radius = 400.0,                            -- Raio em metros
            pedDensity = 1.0,                          -- Densidade máxima
            vehicleDensity = 1.0,                      -- Densidade máxima
        },
        
        -- Vinewood / Hollywood Hills
        {
            name = "Vinewood Boulevard",
            coords = vector3(377.0, 227.0, 103.0),    -- Vinewood
            radius = 350.0,
            pedDensity = 0.9,                          -- Muitos NPCs
            vehicleDensity = 0.9,                      -- Muitos veículos
        },
        
        -- Vespucci Beach (Praia)
        {
            name = "Vespucci Beach",
            coords = vector3(-1286.0, -1267.0, 4.0),  -- Praia
            radius = 300.0,
            pedDensity = 0.95,                         -- Muitos turistas
            vehicleDensity = 0.8,                      -- Carros moderados
        },
        
        -- Sandy Shores
        -- {
        --     name = "Sandy Shores",
        --     coords = vector3(1851.0, 3690.0, 34.0),   -- Centro Sandy
        --     radius = 250.0,
        --     pedDensity = 0.6,                          -- Povoado pequeno
        --     vehicleDensity = 0.7,                      -- Carros moderados
        -- },
        
        -- Paleto Bay
        {
            name = "Paleto Bay",
            coords = vector3(-448.0, 6007.0, 31.0),   -- Centro Paleto
            radius = 200.0,
            pedDensity = 0.6,                          -- Povoado pequeno
            vehicleDensity = 0.7,                      -- Carros moderados
        },
    },
    
    -- 🚶‍♀️ SISTEMA DE PEDS AMBIENTAIS (CAMINHANDO NA CIDADE)
    ambientPeds = {
        enabled = true,                    -- Ativar peds adicionais a caminhar
        basePeds = 18,                     -- Quantidade base de peds ativos
        playersPerPed = 3,                 -- A cada X jogadores adiciona +1 ped
        maxPeds = 45,                      -- Limite absoluto de peds simultâneos
        
        spawnDistance = 120.0,             -- Distância mínima para spawn em relação ao jogador
        despawnDistance = 170.0,           -- Distância máxima antes de remover o ped
        updateInterval = 4000,             -- Intervalo de atualização (ms)
        
        models = {                         -- Modelos genéricos para a cidade
            'a_m_y_business_01',
            'a_m_y_business_02',
            'a_m_y_business_03',
            'a_f_y_business_01',
            'a_f_y_business_02',
            'a_f_y_business_03',
            'a_f_m_tourist_01',
            'a_m_m_tourist_01',
            'a_m_y_hipster_02',
            'a_f_y_hipster_02',
            'a_m_y_genstreet_02',
            'a_f_y_genhot_01',
            'a_m_m_eastsa_01',
            'a_f_y_juggalo_01',
            'a_m_m_socenlat_01',
            'a_m_y_vinewood_02',
            'a_f_y_vinewood_02'
        },
        
        behavior = {
            wanderRadiusMultiplier = 0.6,   -- Percentual do raio da área usado para patrulha
            walkSpeed = 1.0,                -- Velocidade alvo (1.0 = caminhada)
            reassignInterval = 30000,       -- Tempo base para reatribuir comportamento (ms)
            reassignIntervalVariance = 15000, -- Variação aleatória adicional (ms)
            scenarioChance = 0.3,           -- Probabilidade global de usar um cenário
            goToCoordChance = 0.6           -- Probabilidade de andar até novo ponto antes de vagar
        },
        
        areas = {
            {
                name = "Centro - Passeios",
                coords = vector3(215.0, -925.0, 30.7),
                radius = 200.0,
                maxPeds = 8,
                behavior = {
                    scenarioChance = 0.45,
                    wanderRadius = 80.0
                },
                models = {
                    'a_m_y_business_01',
                    'a_f_y_business_04',
                    'a_f_y_business_02',
                    'a_m_y_paparazzi_01',
                    'a_m_y_genstreet_01'
                }
            },
            {
                name = "Vinewood - Calçada Principal",
                coords = vector3(350.0, 205.0, 104.0),
                radius = 180.0,
                maxPeds = 6,
                behavior = {
                    scenarioChance = 0.25,
                    wanderRadius = 90.0
                },
                models = {
                    'a_m_y_vinewood_02',
                    'a_m_y_vinewood_03',
                    'a_f_y_vinewood_02',
                    'a_f_y_vinewood_04'
                }
            },
            {
                name = "Vespucci - Calçadão",
                coords = vector3(-1292.0, -1285.0, 4.0),
                radius = 220.0,
                maxPeds = 7,
                behavior = {
                    scenarioChance = 0.35,
                    wanderRadius = 120.0
                },
                models = {
                    'a_m_y_beach_01',
                    'a_m_y_beach_02',
                    'a_f_y_beach_01',
                    'a_f_y_bevhills_02'
                }
            },
            {
                name = "Del Perro Pier",
                coords = vector3(-1830.0, -1220.0, 13.0),
                radius = 160.0,
                maxPeds = 5,
                behavior = {
                    scenarioChance = 0.4,
                    wanderRadius = 70.0
                }
            },
            {
                name = "Paleto Bay - Centro",
                coords = vector3(-420.0, 6045.0, 31.0),
                radius = 140.0,
                maxPeds = 4,
                behavior = {
                    scenarioChance = 0.2,
                    wanderRadius = 60.0
                }
            }
        }
    },
    
    -- 👮 CONFIGURAÇÕES DE POLÍCIA NPC (NATIVA DO GTA)
    -- ⚠️ IMPORTANTE: Se usas o sistema de patrulhas customizadas (policePatrols),
    --    recomenda-se DESATIVAR a polícia nativa do GTA para evitar conflitos!
    policeTraffic = {
        enabled = false,                  -- Desativado (usar apenas patrulhas customizadas)
        vehicleDensity = 0.0,             -- Zero spawns de polícia nativa
        pedDensity = 0.0,                 -- Zero spawns de peds nativos
        
        -- 🚫 DESATIVAR INTERAÇÕES DA POLÍCIA
        disablePoliceResponse = true,     -- Desativar resposta a crimes
        disableWantedLevel = true,        -- Desativar wanted level completamente
        disablePolicePursuit = true,      -- Desativar perseguições
        disablePoliceHelicopters = true,  -- Desativar helicópteros de polícia
        disablePoliceScanner = true,      -- Desativar scanner de polícia (rádio)
    },
    
    -- 🔧 CONFIGURAÇÕES AVANÇADAS
    updateInterval = 1000,                -- Intervalo de atualização (em milissegundos)
    debugMode = false,                    -- Mostrar informações de debug no console
    
    -- ╔════════════════════════════════════════════════════════════════╗
    -- ║          SISTEMA DE PATRULHAS POLICIAIS CUSTOMIZADAS          ║
    -- ╠════════════════════════════════════════════════════════════════╣
    -- ║ Sistema de patrulhas que NÃO RESPONDEM a incidentes          ║
    -- ║ Apenas para criar ambientação de presença policial           ║
    -- ╚════════════════════════════════════════════════════════════════╝
    
    policePatrols = {
        enabled = true,                   -- Ativar sistema de patrulhas customizadas
        
        -- 📊 QUANTIDADE DINÂMICA BASEADA EM JOGADORES ONLINE
        basePatrols = {
            vehicles = 3,                 -- Número base de viaturas de patrulha
            peds = 6,                     -- Número base de peds a pé
        },
        
        -- A cada X jogadores, adiciona +1 viatura e +1 ped
        playersPerUnit = 5,               -- Exemplo: 10 jogadores = 5 viaturas (3 base + 2 extra)
        maxVehicles = 10,                 -- Máximo de viaturas simultâneas
        maxPeds = 20,                     -- Máximo de peds simultâneos
        
        -- 🌙 REDUÇÃO NOTURNA (22:00 - 06:00)
        nightReduction = {
            peds = 0.5,                   -- 50% menos peds à noite
            vehicles = 1.0,               -- Viaturas mantêm quantidade normal
        },
        
        -- 🚔 MODELOS DE VIATURAS E PEDS
        vehicleModels = {
            'police',                     -- Crown Victoria
            'police2',                    -- Buffalo
            'police3',                    -- Interceptor
            'sheriff',                    -- Sheriff Cruiser
            'sheriff2',                   -- Sheriff SUV
        },
        
        pedModels = {
            's_m_y_cop_01',              -- Polícia masculino
            's_f_y_cop_01',              -- Polícia feminino
            's_m_y_sheriff_01',          -- Sheriff masculino
            's_f_y_sheriff_01',          -- Sheriff feminino
        },
        
        -- 🗺️ PONTOS FIXOS DE PATRULHA (VIATURAS)
        -- Coordenadas onde viaturas spawnam e patrulham
        fixedVehicleRoutes = {
            -- Centro da Cidade (Legion Square / Pillbox Hill)
            {
                name = "Centro - Legion Square",
                spawnCoords = vector4(195.72, -933.24, 30.69, 140.0),
                patrolType = "fixed",     -- "fixed" = rotas fixas | "wander" = aleatório
                waypoints = {
                    vector3(195.72, -933.24, 30.69),
                    vector3(293.89, -584.08, 43.26),
                    vector3(441.91, -979.33, 30.69),
                    vector3(195.72, -933.24, 30.69),
                }
            },
            
            -- Vinewood / Hollywood
            {
                name = "Vinewood Boulevard",
                spawnCoords = vector4(377.89, 227.06, 103.39, 160.0),
                patrolType = "wander",
                wanderRadius = 200.0,
            },
            
            -- Vespucci Beach (Praia)
            {
                name = "Vespucci Beach",
                spawnCoords = vector4(-1204.42, -1490.36, 4.38, 125.0),
                patrolType = "wander",
                wanderRadius = 250.0,
            },
            
            -- Sandy Shores
            {
                name = "Sandy Shores",
                spawnCoords = vector4(1851.36, 3690.75, 34.27, 210.0),
                patrolType = "wander",
                wanderRadius = 300.0,
            },
            
            -- Paleto Bay
            {
                name = "Paleto Bay",
                spawnCoords = vector4(-448.26, 6007.86, 31.72, 315.0),
                patrolType = "wander",
                wanderRadius = 200.0,
            },
            
            -- Airport / LSIA
            {
                name = "Aeroporto LSIA",
                spawnCoords = vector4(-1041.97, -2738.69, 13.88, 330.0),
                patrolType = "fixed",
                waypoints = {
                    vector3(-1041.97, -2738.69, 13.88),
                    vector3(-1336.51, -3044.44, 13.94),
                    vector3(-1645.37, -3142.33, 13.99),
                    vector3(-1041.97, -2738.69, 13.88),
                }
            },
        },
        
        -- 👮 ÁREAS DE PATRULHA A PÉ (PEDS)
        -- Locais onde peds policiais andam a pé
        pedPatrolAreas = {
            -- Mission Row (Delegacia Central)
            {
                name = "Mission Row - Delegacia",
                coords = vector3(441.24, -981.15, 30.69),
                radius = 80.0,
                maxPeds = 2,              -- Máximo de peds nesta área
            },
            
            -- Vespucci Beach Walk
            {
                name = "Vespucci Beach - Calçadão",
                coords = vector3(-1286.93, -1267.17, 4.52),
                radius = 100.0,
                maxPeds = 3,
            },
            
            -- Legion Square
            {
                name = "Legion Square",
                coords = vector3(195.09, -933.91, 30.69),
                radius = 60.0,
                maxPeds = 2,
            },
            
            -- Vinewood Boulevard
            {
                name = "Vinewood Boulevard",
                coords = vector3(377.89, 227.06, 103.39),
                radius = 70.0,
                maxPeds = 2,
            },
            
            -- Del Perro Pier
            {
                name = "Del Perro Pier",
                coords = vector3(-1820.13, -1193.31, 13.31),
                radius = 50.0,
                maxPeds = 2,
            },
            
            -- Sandy Shores (Sheriff)
            {
                name = "Sandy Shores - Centro",
                coords = vector3(1851.36, 3690.75, 34.27),
                radius = 90.0,
                maxPeds = 2,
            },
            
            -- Paleto Bay (Sheriff)
            {
                name = "Paleto Bay - Centro",
                coords = vector3(-448.26, 6007.86, 31.72),
                radius = 80.0,
                maxPeds = 2,
            },
            
            -- Rockford Hills (Zona rica)
            {
                name = "Rockford Hills",
                coords = vector3(-884.21, -24.41, 40.77),
                radius = 75.0,
                maxPeds = 1,
            },
        },
        
        -- 🎲 SPAWN ALEATÓRIO
        -- Além dos pontos fixos, spawna também aleatoriamente
        randomSpawning = {
            enabled = true,
            percentage = 0.3,             -- 30% das patrulhas são aleatórias
        },
        
        -- ⚙️ PERFORMANCE E OTIMIZAÇÃO
        spawnDistance = 150.0,            -- Distância mínima do jogador para spawnar
        despawnDistance = 200.0,          -- Distância máxima para manter spawned
        updateInterval = 5000,            -- Verificar entidades a cada 5 segundos
        
        -- 🛡️ COMPORTAMENTO DAS PATRULHAS
        behavior = {
            invincible = true,            -- Peds não podem morrer
            ignorePlayer = true,          -- Não reagem a jogador
            drivingStyle = 786603,        -- Estilo de condução (normal, respeitando trânsito)
            drivingSpeed = 15.0,          -- Velocidade de patrulha (m/s)
        },
    },
}

