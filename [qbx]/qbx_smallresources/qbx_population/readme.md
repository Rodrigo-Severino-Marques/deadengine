# 🚔 Sistema de Patrulhas Policiais - qbx_population

Sistema customizado de patrulhas policiais que não respondem a incidentes, criado para adicionar ambientação de presença policial no servidor.

## 📋 Características

### ✨ Funcionalidades Principais

- **Patrulhas em Viaturas**: Carros de polícia que patrulham rotas fixas ou aleatórias
- **Patrulhas a Pé**: Peds policiais que andam em áreas específicas
- **Sistema Dinâmico**: Quantidade de patrulhas ajustada baseado em jogadores online
- **Ciclo Dia/Noite**: Redução de peds policiais durante o período noturno (22:00 - 06:00)
- **Performance Otimizada**: Sistema de spawn/despawn baseado em distância do jogador
- **Não-Reativos**: Peds completamente não-reativos a crimes, violência ou jogadores

### 🎯 Comportamento

Os peds de patrulha são configurados para:
- ✅ Não reagir a disparos, lutas ou crimes
- ✅ Não perseguir jogadores
- ✅ Não entrar em combate
- ✅ Não fugir de situações
- ✅ Ser invencíveis (configurável)
- ✅ Ignorar completamente jogadores

**IMPORTANTE**: Isto inclui proteção contra cães e outros NPCs que normalmente atacariam em situações violentas.

## ⚙️ Configuração

### Ativar/Desativar Sistema

No `config.lua`:

```lua
policePatrols = {
    enabled = true,  -- true = ativo | false = desativado
    -- ...
}
```

### Ajustar Quantidade Base

```lua
basePatrols = {
    vehicles = 3,  -- Número base de viaturas
    peds = 6,      -- Número base de peds a pé
},
```

### Sistema Dinâmico por Jogadores

```lua
playersPerUnit = 5,      -- A cada 5 jogadores online, +1 viatura e +1 ped
maxVehicles = 10,        -- Máximo de viaturas simultâneas
maxPeds = 20,            -- Máximo de peds simultâneos
```

**Exemplo**: Com 15 jogadores online:
- Viaturas: 3 (base) + 3 (15÷5) = 6 viaturas
- Peds: 6 (base) + 3 (15÷5) = 9 peds

### Redução Noturna (22:00 - 06:00)

```lua
nightReduction = {
    peds = 0.5,      -- 50% menos peds à noite
    vehicles = 1.0,  -- Viaturas mantêm quantidade normal
},
```

### Modelos Customizáveis

```lua
vehicleModels = {
    'police',    -- Crown Victoria
    'police2',   -- Buffalo
    'police3',   -- Interceptor
    'sheriff',   -- Sheriff Cruiser
    'sheriff2',  -- Sheriff SUV
},

pedModels = {
    's_m_y_cop_01',      -- Polícia masculino
    's_f_y_cop_01',      -- Polícia feminino
    's_m_y_sheriff_01',  -- Sheriff masculino
    's_f_y_sheriff_01',  -- Sheriff feminino
},
```

## 🗺️ Pontos de Patrulha

### Rotas de Viaturas

Existem dois tipos de patrulha para viaturas:

#### 1. Rotas Fixas (Waypoints)

```lua
{
    name = "Centro - Legion Square",
    spawnCoords = vector4(195.72, -933.24, 30.69, 140.0),
    patrolType = "fixed",
    waypoints = {
        vector3(195.72, -933.24, 30.69),
        vector3(293.89, -584.08, 43.26),
        vector3(441.91, -979.33, 30.69),
        vector3(195.72, -933.24, 30.69),  -- Volta ao início
    }
},
```

#### 2. Patrulha Aleatória (Wander)

```lua
{
    name = "Vinewood Boulevard",
    spawnCoords = vector4(377.89, 227.06, 103.39, 160.0),
    patrolType = "wander",
    wanderRadius = 200.0,  -- Raio de patrulha em metros
},
```

### Áreas de Patrulha a Pé

```lua
{
    name = "Legion Square",
    coords = vector3(195.09, -933.91, 30.69),
    radius = 60.0,   -- Raio da área em metros
    maxPeds = 2,     -- Máximo de peds nesta área
},
```

## 🎮 Comandos

### Debug de Patrulhas

```
/policepatrol_debug
```

Mostra informações sobre o sistema de patrulhas:
- Número de jogadores online
- Se é período noturno
- Quantidade target vs. spawned de viaturas e peds
- Lista de viaturas e peds ativos

### Debug de População

```
/population_debug
```

Mostra informações sobre densidade populacional geral (requer `debugMode = true` no config).

## 🔧 Performance

### Otimização de Distância

```lua
spawnDistance = 150.0,      -- Spawna quando jogador está a 150m
despawnDistance = 200.0,    -- Despawna quando jogador está a 200m
updateInterval = 5000,      -- Verifica a cada 5 segundos
```

**Como funciona**:
- Patrulhas só spawnam quando um jogador está próximo (150m)
- Desaparecem automaticamente quando todos os jogadores estão longe (200m)
- Verificação ocorre a cada 5 segundos para economizar recursos

### Recomendações

- **Servidor Pequeno** (1-10 jogadores): Use valores padrão
- **Servidor Médio** (10-32 jogadores): Aumente `maxVehicles` e `maxPeds`
- **Servidor Grande** (32+ jogadores): Considere aumentar `updateInterval` para 7000-10000ms

## 🛡️ Comportamento dos Peds

### Configurações de Comportamento

```lua
behavior = {
    invincible = true,           -- Peds não podem morrer
    ignorePlayer = true,         -- Não reagem a jogador
    drivingStyle = 786603,       -- Estilo normal, respeitando trânsito
    drivingSpeed = 15.0,         -- Velocidade de patrulha (m/s)
},
```

### Driving Styles Comuns

- `786603` - Normal (respeitando trânsito, semáforos)
- `1074528293` - Rushed (mais rápido, menos cuidadoso)
- `537133628` - Avoid traffic (evita trânsito)

## 📍 Localizações Pré-Configuradas

O sistema vem com as seguintes patrulhas pré-configuradas:

### Viaturas
1. **Centro - Legion Square** (rotas fixas)
2. **Vinewood Boulevard** (patrulha aleatória)
3. **Vespucci Beach** (praia)
4. **Sandy Shores** (deserto)
5. **Paleto Bay** (norte)
6. **Aeroporto LSIA** (rotas fixas)

### Peds a Pé
1. **Mission Row** - Delegacia Central
2. **Vespucci Beach** - Calçadão
3. **Legion Square**
4. **Vinewood Boulevard**
5. **Del Perro Pier**
6. **Sandy Shores** - Centro
7. **Paleto Bay** - Centro
8. **Rockford Hills** - Zona rica

## 🚀 Como Adicionar Novas Rotas

### Adicionar Rota de Viatura

1. Vai para o local desejado no jogo
2. Usa `/coords` ou similar para obter coordenadas
3. Adiciona ao `config.lua`:

```lua
{
    name = "Minha Nova Rota",
    spawnCoords = vector4(x, y, z, heading),
    patrolType = "wander",  -- ou "fixed"
    wanderRadius = 200.0,   -- se wander
    -- waypoints = {...}    -- se fixed
},
```

### Adicionar Área de Patrulha a Pé

```lua
{
    name = "Minha Nova Área",
    coords = vector3(x, y, z),
    radius = 75.0,
    maxPeds = 2,
},
```

## 🐛 Troubleshooting

### Patrulhas não aparecem

1. Verifica se `enabled = true` no config
2. Verifica se estás perto o suficiente das rotas configuradas (150m)
3. Usa `/policepatrol_debug` para ver status
4. Verifica console para erros

### Peds reagem a violência

Se um ped reagir, pode ser:
- Um ped NPC normal do GTA, não uma patrulha customizada
- Verifica se a função `MakePedNonReactive()` está a ser chamada corretamente

### Performance Issues

1. Reduz `maxVehicles` e `maxPeds`
2. Aumenta `updateInterval` para 7000 ou 10000
3. Reduz número de áreas de patrulha configuradas
4. Aumenta `despawnDistance` para limpar entidades mais cedo

## 📊 Sistema de Limpeza

O sistema limpa automaticamente todas as entidades quando:
- O recurso é parado (`/stop qbx_smallresources`)
- O recurso é reiniciado (`/restart qbx_smallresources`)

Não é necessário limpeza manual.

## ⚠️ Notas Importantes

1. **Compatibilidade**: Sistema integrado no qbx_population, não requer recursos adicionais
2. **Wanted Level**: Certifica-te que `disableWantedLevel = true` no `policeTraffic` para evitar conflitos
3. **Police Response**: `disablePoliceResponse = true` é recomendado para evitar polícia nativa do GTA
4. **Modelos**: Usa apenas modelos de peds/veículos que existem no jogo

## 🎨 Customização Avançada

### Adicionar Mais Modelos

Podes adicionar qualquer modelo de veículo policial ou ped:

```lua
vehicleModels = {
    'police',
    'police2',
    'police3',
    'police4',
    'policeb',    -- Bike
    'policeold1', -- Vintage
    'policeold2', -- Vintage
    'policet',    -- Transporter
    -- Adiciona os teus modelos customizados aqui
},
```

### Mudar Velocidade de Condução

```lua
behavior = {
    drivingSpeed = 10.0,  -- Mais devagar
    -- drivingSpeed = 20.0,  -- Mais rápido
},
```

## 📝 Changelog

### v1.0.0 (2025-11-06)
- ✨ Sistema inicial de patrulhas policiais
- 🚗 6 rotas de viaturas pré-configuradas
- 👮 8 áreas de patrulha a pé
- 📊 Sistema dinâmico baseado em jogadores
- 🌙 Redução noturna de peds
- 🛡️ Proteção completa contra reatividade
- ⚡ Otimização de performance por distância

---

**Desenvolvido para qbx_smallresources**  
Sistema de patrulhas completamente não-reativo para criar ambientação policial sem interferir no gameplay.
