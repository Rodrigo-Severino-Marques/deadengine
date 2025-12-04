# Como Adicionar Roupas Novas

Este guia explica onde e como adicionar novos itens de roupa ao teu servidor QBX usando illenium-appearance.

## Visão Geral

O QBX usa **illenium-appearance** para roupa e personalização de personagens. Os itens de roupa são carregados automaticamente do sistema de roupa nativo do GTA V, mas podes personalizar quais itens estão disponíveis e adicionar restrições.

## Ficheiro de Configuração Principal

O ficheiro de configuração principal está localizado em:
```
[standalone]/illenium-appearance/shared/config.lua
```

## Estrutura do Sistema de Roupa

O illenium-appearance usa o sistema de roupa nativo do GTA V, que inclui:

### Componentes (Itens de Roupa)
- **Component ID 0**: Rosto
- **Component ID 1**: Máscara
- **Component ID 2**: Cabelo
- **Component ID 3**: Parte Superior (Torso)
- **Component ID 4**: Parte Inferior (Calças)
- **Component ID 5**: Mochila/Paraquedas
- **Component ID 6**: Sapatos
- **Component ID 7**: Cachecol e Correntes
- **Component ID 8**: Camisa
- **Component ID 9**: Colete à Prova de Balas
- **Component ID 10**: Decalques/Insígnias
- **Component ID 11**: Casaco

### Props (Acessórios)
- **Prop ID 0**: Chapéus
- **Prop ID 1**: Óculos
- **Prop ID 2**: Acessórios de Orelha
- **Prop ID 6**: Relógios
- **Prop ID 7**: Pulseiras

## Adicionar Itens de Roupa Personalizados

### Método 1: Usar Roupa Nativa do GTA V

O GTA V já tem milhares de itens de roupa integrados. Para os tornar disponíveis:

1. **Não é necessária configuração** - A maioria dos itens de roupa já está disponível no menu de aparência
2. **Acesso via menu de aparência** - Os jogadores podem aceder a toda a roupa disponível através de:
   - Lojas de roupa (configuradas em `config.lua` em `Config.Stores`)
   - Criação de personagem
   - Comando `/appearance` (se ativado)

### Método 2: Desativar/Ativar Categorias de Roupa

Podes desativar categorias inteiras de roupa em `config.lua`:

```lua
Config.DisableComponents = {
    Masks = false,          -- Define como true para desativar máscaras
    UpperBody = false,      -- Define como true para desativar parte superior
    LowerBody = false,      -- Define como true para desativar calças
    Bags = false,           -- Define como true para desativar mochilas
    Shoes = false,          -- Define como true para desativar sapatos
    ScarfAndChains = false, -- Define como true para desativar cachecóis
    BodyArmor = false,      -- Define como true para desativar coletes
    Shirts = false,         -- Define como true para desativar camisas
    Decals = false,         -- Define como true para desativar decalques
    Jackets = false         -- Define como true para desativar casacos
}

Config.DisableProps = {
    Hats = false,           -- Define como true para desativar chapéus
    Glasses = false,        -- Define como true para desativar óculos
    Ear = false,           -- Define como true para desativar acessórios de orelha
    Watches = false,       -- Define como true para desativar relógios
    Bracelets = false      -- Define como true para desativar pulseiras
}
```

### Método 3: Adicionar Peds/Modelos Personalizados

Para adicionar modelos de ped personalizados (que podem ter roupa única), edita:
```
[standalone]/illenium-appearance/shared/peds.lua
```

Adiciona o teu modelo de ped à secção apropriada:

```lua
Config.Peds = {
    pedConfig = {
        {
            peds = {
                "your_custom_ped_model",
                "another_custom_ped",
                -- ... peds existentes
            }
        }
    }
}
```

### Método 4: Lista Negra de Itens Específicos

Para colocar itens de roupa específicos na lista negra, edita:
```
[standalone]/illenium-appearance/shared/blacklist.lua
```

Exemplo:
```lua
return {
    components = {
        -- Lista negra de combinações específicas de drawable/textura de componentes
        -- Formato: {component_id, drawable_id, texture_id}
        {1, 0, 0},  -- Lista negra de máscara drawable 0, textura 0
        {3, 15, 0}, -- Lista negra de parte superior drawable 15, textura 0
    },
    props = {
        -- Lista negra de combinações específicas de drawable/textura de props
        -- Formato: {prop_id, drawable_id, texture_id}
        {0, 1, 0},  -- Lista negra de chapéu drawable 1, textura 0
    }
}
```

## Adicionar Lojas de Roupa

Configura as localizações das lojas de roupa em `config.lua`:

```lua
Config.Stores = {
    {
        type = "clothing",
        coords = vector4(x, y, z, heading),
        size = vector3(4, 4, 4),
        rotation = 45,
        usePoly = false,
        showBlip = true,
        points = {
            -- Opcional: Define zona de polígono personalizada
            vector3(x1, y1, z1),
            vector3(x2, y2, z2),
            -- ... mais pontos
        }
    },
    -- ... mais lojas
}
```

## Adicionar Roupa Personalizada via DLC/Addon

### Passo 1: Instalar DLC de Roupa

1. Coloca o teu DLC/addon de roupa na pasta `resources` do teu servidor
2. Garante que tem um `fxmanifest.lua` adequado que carrega os ficheiros de roupa
3. Adiciona o recurso ao teu `server.cfg`

### Passo 2: Verificar se a Roupa Foi Carregada

A roupa deve estar automaticamente disponível se:
- O DLC estiver corretamente instalado
- Os ficheiros de roupa estiverem no formato correto
- O recurso estiver iniciado

### Passo 3: Testar no Jogo

1. Abre o menu de aparência numa loja de roupa
2. Navega para a categoria de roupa apropriada
3. A tua roupa personalizada deve aparecer na lista

## Fatos de Trabalho/Gangue

Para adicionar fatos específicos de trabalho ou gangue, podes usar o sistema de gestão:

1. **Via Menu no Jogo**: Usa o menu de gestão de fatos de trabalho/gangue (se `Config.BossManagedOutfits = true`)
2. **Via Base de Dados**: Os fatos são armazenados na tabela `management_outfits`
3. **Via Código**: Usa os exports do illenium-appearance para guardar fatos programaticamente

## Tatuagens

As tatuagens são configuradas em:
```
[standalone]/illenium-appearance/shared/tattoos.lua
```

Adiciona tatuagens personalizadas seguindo o formato existente:

```lua
{
    name = "Nome da Tatuagem",
    label = "Nome de Exibição",
    hashMale = "tattoo_hash_male",
    hashFemale = "tattoo_hash_female",
    zone = "ZONE_NAME",  -- ex: "ZONE_TORSO", "ZONE_LEFT_ARM"
    collection = "collection_name",
    cost = 500  -- Opcional: Substitui o custo padrão da tatuagem
}
```

## Opções de Configuração

Opções de configuração principais em `config.lua`:

```lua
Config.ClothingCost = 100      -- Custo para mudar de roupa
Config.BarberCost = 100        -- Custo para cortes de cabelo
Config.TattooCost = 100        -- Custo por tatuagem
Config.SurgeonCost = 100       -- Custo para cirurgia plástica

Config.NewCharacterSections = {
    Ped = true,                -- Permitir seleção de ped
    HeadBlend = true,          -- Permitir mistura de cabeça
    FaceFeatures = true,       -- Permitir edição de características faciais
    HeadOverlays = true,       -- Permitir sobreposições (barba, maquilhagem, etc.)
    Components = true,         -- Permitir componentes de roupa
    Props = true,             -- Permitir props/acessórios
    Tattoos = true            -- Permitir tatuagens
}
```

## Testar as Tuas Alterações

1. **Reiniciar Recursos**: Após fazer alterações, reinicia `illenium-appearance`
2. **Limpar Cache**: Os jogadores podem precisar de limpar o cache de aparência
3. **Testar na Criação de Personagem**: Cria um novo personagem para testar
4. **Testar na Loja de Roupa**: Visita uma loja de roupa para verificar se os itens aparecem

## Resolução de Problemas

### Roupa Não Aparece
- **Verificar Instalação do DLC**: Garante que o DLC de roupa personalizada está corretamente instalado
- **Verificar Formato do Ficheiro**: Os ficheiros de roupa devem estar no formato correto do GTA V
- **Verificar Lista Negra**: Certifica-te de que o item não está na lista negra
- **Componente Ativado**: Verifica se a categoria de componente não está desativada na configuração

### Problemas de Performance
- **Demasiados Itens**: Ter milhares de itens pode causar lag
- **Usar Lista Negra**: Coloca itens não usados na lista negra para melhorar o desempenho
- **Otimizar Zonas**: Reduz os tamanhos das zonas das lojas de roupa se necessário

### Aparência Não Guarda
- **Verificar Base de Dados**: Verifica se a tabela `playerskins` existe e está acessível
- **Verificar Permissões**: Garante que o recurso tem permissões de escrita na base de dados
- **Verificar Framework**: Verifica se a integração do framework está a funcionar

## Recursos Adicionais

- GitHub do illenium-appearance: Consulta o repositório para documentação mais recente
- IDs de Roupa do GTA V: Usa recursos online para encontrar IDs específicos de drawable/textura de roupa
- Fóruns do FiveM: Procura tutoriais e recursos de DLC de roupa

## Notas

- **Não É Necessário Adicionar Itens Manualmente**: O sistema de roupa nativo do GTA V fornece automaticamente todos os itens de roupa disponíveis
- **DLC Necessário para Personalizado**: Para adicionar roupa verdadeiramente personalizada, precisas de um DLC/addon do GTA V formatado corretamente
- **Limites de Componentes**: Cada componente tem um número máximo de drawables e texturas (varia conforme o tipo de componente)
- **Específico por Género**: Alguns itens de roupa são específicos por género e só aparecerão para o género apropriado
