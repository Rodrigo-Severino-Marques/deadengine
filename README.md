# DeadEngine - Qbox Project Resources

![Qbox](https://img.shields.io/badge/Qbox-Project-blue)
![FiveM](https://img.shields.io/badge/FiveM-Server-green)

Um servidor FiveM completo construído com o framework Qbox Project, incluindo todos os recursos necessários para um servidor funcional.

## 📋 Índice

- [Sobre](#sobre)
- [Características](#características)
- [Requisitos](#requisitos)
- [Instalação](#instalação)
- [Configuração](#configuração)
- [Recursos Incluídos](#recursos-incluídos)
- [Documentação](#documentação)
- [Contribuir](#contribuir)
- [Licença](#licença)

## 🎯 Sobre

DeadEngine é uma base de servidor FiveM completa construída com o framework Qbox Project. Este repositório contém todos os recursos necessários para configurar e executar um servidor FiveM funcional, incluindo sistemas de inventário, veículos, propriedades, empregos e muito mais.

## ✨ Características

- ✅ Framework Qbox Core completo
- ✅ Sistema de multicharacteres ilimitado
- ✅ Sistema de inventário ox_inventory
- ✅ Sistema de propriedades e apartamentos
- ✅ Múltiplos empregos e sistemas de trabalho
- ✅ Sistema de veículos e garagens
- ✅ Sistema de polícia e ambulância
- ✅ Sistema bancário
- ✅ Sistema de voz (pma-voice)
- ✅ Interface NPWD (telefone)
- ✅ E muito mais!

## 📦 Requisitos

- **Servidor FiveM** (versão mais recente)
- **Base de dados MySQL/MariaDB**
- **Servidor com recursos suficientes** (recomendado: 4GB+ RAM, 2+ CPU cores)

### Dependências Principais

- [oxmysql](https://github.com/CommunityOx/oxmysql)
- [ox_lib](https://github.com/CommunityOx/ox_lib)
- [ox_inventory](https://github.com/CommunityOx/ox_inventory)
- [qbx_core](https://github.com/Qbox-project/qbx_core)

## 🚀 Instalação

### 1. Clonar o Repositório

```bash
git clone https://github.com/SEU_USUARIO/DeadEngine.base.git
cd DeadEngine.base/resources
```

### 2. Configurar a Base de Dados

1. Cria uma base de dados MySQL
2. Importa os ficheiros SQL necessários (ver documentação de cada recurso)
3. Configura a string de conexão no `server.cfg`:

```cfg
set mysql_connection_string "mysql://user:password@localhost/database_name?charset=utf8mb4"
```

### 3. Configurar o server.cfg

1. Copia `server.cfg.example` para `server.cfg` (se existir)
2. Edita o `server.cfg` com as tuas configurações:
   - Licença do FiveM
   - String de conexão MySQL
   - Configurações do servidor
   - Chaves de API necessárias

### 4. Instalar Dependências

Certifica-te de que todos os recursos estão na pasta `resources` e que as dependências estão instaladas.

### 5. Iniciar o Servidor

```bash
# No terminal do servidor FiveM
start server.cfg
```

## ⚙️ Configuração

### Configurações Principais

- **Qbox Core**: Configurações em `[qbx]/qbx_core/config/`
- **Inventário**: Configurações em `[ox]/ox_inventory/data/`
- **Voz**: Configurações em `voice.cfg`
- **Ox Resources**: Configurações em `ox.cfg`

### Limite de Personagens

Por padrão, o sistema permite até 999 personagens por jogador. Para alterar:

1. Edita `[qbx]/qbx_core/config/server.lua`
2. Modifica `defaultNumberOfCharacters` conforme necessário

### Adicionar Armas e Acessórios

Ver guia: [HOW_TO_ADD_WEAPON_PROPS.md](HOW_TO_ADD_WEAPON_PROPS.md)

### Adicionar Roupas

Ver guia: [HOW_TO_ADD_NEW_CLOTHES.md](HOW_TO_ADD_NEW_CLOTHES.md)

## 📚 Recursos Incluídos

### Core e Framework
- `[qbx]/qbx_core` - Framework principal Qbox
- `[ox]/ox_lib` - Biblioteca de funções comuns
- `[ox]/oxmysql` - Driver MySQL
- `[ox]/ox_inventory` - Sistema de inventário
- `[ox]/ox_target` - Sistema de targeting
- `[ox]/ox_doorlock` - Sistema de fechaduras

### Empregos e Sistemas
- `[qbx]/qbx_police` - Sistema de polícia
- `[qbx]/qbx_ambulancejob` - Sistema de ambulância
- `[qbx]/qbx_mechanicjob` - Sistema de mecânico
- `[qbx]/qbx_newsjob` - Sistema de notícias
- E muitos mais...

### Sistemas de Jogo
- `[qbx]/qbx_properties` - Sistema de propriedades
- `[qbx]/qbx_garages` - Sistema de garagens
- `[qbx]/qbx_vehicles` - Sistema de veículos
- `[qbx]/qbx_bankrobbery` - Assaltos a bancos
- `[qbx]/qbx_houserobbery` - Assaltos a casas
- `[qbx]/qbx_storerobbery` - Assaltos a lojas

### Interface e UI
- `[npwd]/npwd` - Sistema de telefone NPWD
- `[qbx]/qbx_hud` - HUD do jogador
- `[qbx]/qbx_radialmenu` - Menu radial
- `[standalone]/illenium-appearance` - Sistema de aparência

### Voz e Áudio
- `[voice]/pma-voice` - Sistema de voz
- `[voice]/mm_radio` - Sistema de rádio

### Outros
- `[standalone]/Renewed-Banking` - Sistema bancário
- `[standalone]/Renewed-Weathersync` - Sistema de clima
- E muitos mais recursos...

## 📖 Documentação

- [Como Adicionar Props de Armas](HOW_TO_ADD_WEAPON_PROPS.md)
- [Como Adicionar Roupas](HOW_TO_ADD_NEW_CLOTHES.md)
- [Documentação Qbox](https://qbox-project.github.io/)
- [Documentação FiveM](https://docs.fivem.net/)

## 🤝 Contribuir

Contribuições são bem-vindas! Por favor:

1. Faz um Fork do projeto
2. Cria uma branch para a tua feature (`git checkout -b feature/AmazingFeature`)
3. Faz commit das tuas alterações (`git commit -m 'Add some AmazingFeature'`)
4. Faz push para a branch (`git push origin feature/AmazingFeature`)
5. Abre um Pull Request

## ⚠️ Avisos Importantes

- **NÃO modifiques o core** fora dos ficheiros de configuração
- Sempre faz backup antes de fazer alterações
- Testa todas as alterações num servidor de desenvolvimento primeiro
- Mantém as dependências atualizadas

## 📝 Licença

Este projeto utiliza várias licenças dependendo dos recursos incluídos. Por favor, consulta os ficheiros LICENSE de cada recurso para mais informações.

## 🙏 Agradecimentos

- [Qbox Project](https://github.com/Qbox-project) - Pelo framework incrível
- [Overextended](https://github.com/overextended) - Pelos recursos ox_*
- Todos os contribuidores da comunidade FiveM

## 📞 Suporte

- [Discord Qbox](https://discord.gg/qbox)
- [Issues GitHub](https://github.com/SEU_USUARIO/DeadEngine.base/issues)

---

**Nota**: Este é um projeto da comunidade. Usa por tua conta e risco. Sempre faz backup dos teus dados antes de fazer alterações.

