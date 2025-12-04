# qbx_pedscale

Sistema completo de escala de peds/players para servidores FiveM usando Qbox Framework.

## 🚨 IMPORTANTE: Build do FiveM

**Este recurso requer FiveM build 2189 ou superior!**

Se vês o erro "SetPedScale não está disponível":
- ✅ Verifica a build: `version` no console
- ❌ Build atual: `17000` (muito antiga)
- ✅ Build necessária: `2189+` (recomendado: `4752+`)
- 📖 **Ver guia**: `UPDATE_TXADMIN.md` para atualizar no txAdmin

## 📋 Características

- ✅ Alterar altura em centímetros ou escala diretamente
- ✅ Comandos rápidos para aumentar/diminuir tamanho
- ✅ Input dialogs com ox_lib
- ✅ Guardar escala no banco de dados
- ✅ Sincronização entre clientes
- ✅ Comandos admin para alterar outros jogadores
- ✅ Limites de segurança (min/max)
- ✅ Mantém escala após morte/respawn

## 🚀 Instalação

### 1. Copiar Recurso

Coloca a pasta `qbx_pedscale` em `resources/[qbx]/`

### 2. Criar Tabela no Banco de Dados (Opcional)

Se `Config.SaveToDatabase = true`, cria esta tabela:

```sql
CREATE TABLE IF NOT EXISTS `player_ped_scales` (
  `citizenid` varchar(50) NOT NULL,
  `scale` float NOT NULL DEFAULT 1.0,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3. Adicionar ao server.cfg

```cfg
ensure qbx_pedscale
```

## 📝 Comandos

### Comandos de Jogador

| Comando | Descrição | Exemplo |
|---------|-----------|---------|
| `/scale <cm>` | Define altura em centímetros | `/scale 150` |
| `/setscale <escala>` | Define escala diretamente (0.3-2.0) | `/setscale 1.5` |
| `/big` | Aumenta tamanho | `/big` |
| `/small` | Diminui tamanho | `/small` |
| `/resetscale` | Reseta para tamanho normal | `/resetscale` |
| `/setheight` | Abre input dialog para altura | `/setheight` |
| `/setscaleinput` | Abre input dialog para escala | `/setscaleinput` |

### Comandos Admin

| Comando | Descrição | Exemplo |
|---------|-----------|---------|
| `/setscaleplayer <id> <cm>` | Define altura de outro jogador | `/setscaleplayer 1 200` |
| `/resetscaleplayer <id>` | Reseta altura de outro jogador | `/resetscaleplayer 1` |

## ⚙️ Configuração

Edita `config.lua` para personalizar:

```lua
Config.MinScale = 0.3          -- Escala mínima (30%)
Config.MaxScale = 2.0          -- Escala máxima (200%)
Config.DefaultHeight = 180     -- Altura padrão em cm
Config.AdminOnly = false       -- Apenas admins podem usar
Config.SaveToDatabase = true   -- Guardar no banco de dados
```

## 📊 Conversão de Escala

- **Escala 1.0** = 180cm (tamanho normal)
- **Escala 0.5** = 90cm (metade do tamanho)
- **Escala 2.0** = 360cm (dobro do tamanho)

**Fórmula**: `escala = centímetros / 180`

## 🔧 Exports

Outros recursos podem usar:

```lua
-- Definir escala de um jogador
exports['qbx_pedscale']:setPlayerScale(source, 1.5)

-- Obter escala de um jogador
local scale = exports['qbx_pedscale']:getPlayerScale(source)
```

## ⚠️ Notas Importantes

1. **SetPedScale** requer:
   - FiveM build **2189 ou superior** (obrigatório)
   - **OneSync ativado** (obrigatório)
   - OneSync Infinity é **opcional** (só necessário para mais de 64 jogadores)
   
   **🚨 Se vês erro "SetPedScale não está disponível":**
   - Verifica a build: `version` no console
   - Se for inferior a 2189, **atualiza os artifacts** (ver `UPDATE_BUILD.md`)
   - Build atual: v1.0.0.17000 ❌ (muito antiga, precisa atualizar)
   - Build necessária: v1.0.0.2189+ ✅

2. Escalas muito extremas podem causar problemas de colisão
3. As armas podem ficar desproporcionadas (limitação do GTA)
4. A escala é mantida após morte/respawn se guardada no banco de dados

## 🔧 Configuração do OneSync

Para ativar o OneSync, adiciona ao teu `server.cfg`:

```cfg
# OneSync básico (até 64 jogadores)
set onesync on

# OneSync Infinity (até 2048 jogadores) - OPCIONAL
set onesync_enableInfinity 1
```

**Nota**: OneSync Infinity só é necessário se tiveres mais de 64 jogadores. Para servidores menores, OneSync básico é suficiente.

## 🐛 Resolução de Problemas

### Escala não aplica
- Verifica se OneSync está ativado
- Verifica se a build do FiveM é 2189+

### Escala não guarda
- Verifica se a tabela existe no banco de dados
- Verifica se `Config.SaveToDatabase = true`

### Comandos não funcionam
- Verifica se o recurso está iniciado
- Verifica permissões se `Config.AdminOnly = true`

## 📝 Changelog

### v1.0.0
- Versão inicial
- Comandos básicos
- Input dialogs
- Sistema de guardar no banco de dados
- Comandos admin

## 📞 Suporte

Para problemas ou sugestões, abre uma issue no repositório.

## 📄 Licença

Este recurso é fornecido como está. Usa por tua conta e risco.

