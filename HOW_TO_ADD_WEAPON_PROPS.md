# Como Adicionar Props/Acessórios de Armas

Este guia explica onde e como adicionar props de armas, acessórios e addons ao teu servidor QBX usando ox_inventory.

## Localização

Os props e acessórios de armas são configurados em:
```
[ox]/ox_inventory/data/weapons.lua
```

## Estrutura do Ficheiro

O ficheiro `weapons.lua` contém três secções principais:

1. **Weapons** - Definições de armas base
2. **Components** - Acessórios/props de armas (lanternas, silenciadores, miras, etc.)
3. **Ammo** - Tipos de munição

## Adicionar Novos Componentes/Acessórios de Armas

### Passo 1: Abrir o Ficheiro de Armas

Navega para: `[ox]/ox_inventory/data/weapons.lua`

### Passo 2: Encontrar a Secção Components

A secção Components começa aproximadamente na linha 721. Tem este aspeto:

```lua
Components = {
    ['at_flashlight'] = {
        label = 'Tactical Flashlight',
        weight = 120,
        type = 'flashlight',
        client = {
            component = {
                `COMPONENT_AT_AR_FLSH`,
                `COMPONENT_AT_AR_FLSH_REH`,
                `COMPONENT_AT_PI_FLSH`,
                -- ... mais componentes
            },
            usetime = 2500
        }
    },
    -- ... mais componentes
}
```

### Passo 3: Adicionar o Teu Novo Componente

Adiciona o teu novo componente de arma seguindo este formato:

```lua
['your_component_name'] = {
    label = 'Nome de Exibição',        -- Nome mostrado no inventário
    weight = 280,                      -- Peso do item
    type = 'attachment_type',          -- Tipo: 'flashlight', 'muzzle', 'sight', 'grip', 'magazine', etc.
    client = {
        image = 'component_image.png', -- Opcional: Imagem personalizada (colocar em ox_inventory/web/images/)
        component = {
            `COMPONENT_NAME_1`,        -- Hash do componente GTA V
            `COMPONENT_NAME_2`,        -- Adiciona múltiplos se funcionar em várias armas
            -- ... mais hashes de componentes
        },
        usetime = 2500                 -- Tempo em milissegundos para anexar/desanexar
    }
}
```

### Passo 4: Tipos de Componentes

Tipos de componentes comuns:
- `'flashlight'` - Lanternas
- `'muzzle'` - Silenciadores, compensadores
- `'sight'` - Miras (macro, pequena, média, grande)
- `'grip'` - Empunhaduras
- `'magazine'` - Carregadores estendidos, tambores
- `'barrel'` - Acessórios de cano

### Passo 5: Encontrar Hashes de Componentes do GTA V

Podes encontrar hashes de componentes de armas do GTA V em:
- Documentação nativa do GTA V
- Listas de componentes de armas online
- Usando nativas do FiveM como `GetWeaponComponentTypeModel()`

Exemplos de hashes de componentes:
- `COMPONENT_AT_AR_FLSH` - Lanterna de Rifle de Assalto
- `COMPONENT_AT_PI_SUPP` - Silenciador de Pistola
- `COMPONENT_AT_SCOPE_MACRO` - Mira Macro
- `COMPONENT_AT_AR_AFGRIP` - Empunhadura

### Passo 6: Adicionar aos Itens (Opcional)

Se quiseres que o componente apareça como item nas lojas ou seja fabricável, também podes precisar de adicioná-lo a:
```
[ox]/ox_inventory/data/items.lua
```

No entanto, os componentes definidos em `weapons.lua` são automaticamente registados como itens pela ponte qbx_core.

## Exemplo: Adicionar um Silenciador Personalizado

```lua
['at_suppressor_custom'] = {
    label = 'Silenciador Personalizado',
    weight = 300,
    type = 'muzzle',
    client = {
        image = 'at_suppressor_custom.png',
        component = {
            `COMPONENT_AT_PI_SUPP_02`,
            `COMPONENT_AT_AR_SUPP_02`,
        },
        usetime = 3000
    }
}
```

## Exemplo: Adicionar uma Mira Personalizada

```lua
['at_scope_custom'] = {
    label = 'Mira 4x Personalizada',
    weight = 350,
    type = 'sight',
    client = {
        image = 'at_scope_custom.png',
        component = {
            `COMPONENT_AT_SCOPE_MEDIUM_MK2`,
            `COMPONENT_AT_SCOPE_LARGE_MK2`,
        },
        usetime = 2500
    }
}
```

## Adicionar Novas Armas

Para adicionar armas completamente novas (não apenas acessórios), adiciona-as à secção **Weapons** no topo do ficheiro:

```lua
Weapons = {
    ['WEAPON_YOURWEAPON'] = {
        label = 'Nome da Tua Arma',
        weight = 2000,
        durability = 0.03,
        ammoname = 'ammo-9',  -- Tipo de munição que usa
    },
    -- ... armas existentes
}
```

## Notas

- **Reinício Necessário**: Após fazer alterações, reinicia o recurso `ox_inventory`
- **Compatibilidade de Componentes**: Certifica-te de que o hash do componente que estás a usar é compatível com o tipo de arma
- **Imagens**: Coloca imagens personalizadas no diretório `[ox]/ox_inventory/web/images/`
- **Testes**: Testa cada componente para garantir que se anexa corretamente às armas pretendidas

## Resolução de Problemas

- **Componente não aparece**: Verifica se o hash do componente está correto e é compatível com a arma
- **Não é anexável**: Verifica se o `type` corresponde à ranhura de acessório (ex: não podes colocar uma mira numa ranhura de boca)
- **Imagem não aparece**: Garante que o ficheiro de imagem existe no diretório correto e o nome do ficheiro corresponde exatamente

## Recursos Adicionais

- Documentação do ox_inventory: https://overextended.github.io/docs/ox_inventory
- Componentes de Armas do GTA V: Consulta a documentação nativa do FiveM ou recursos de modding do GTA V
