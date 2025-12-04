# 🔧 Guia Completo de Configuração OneSync

## ⚠️ IMPORTANTE: Estás a usar txAdmin!

Vejo que tens um comentário do txAdmin no teu `server.cfg` indicando que o OneSync deve ser configurado apenas no painel do txAdmin.

## 📋 Passo a Passo para txAdmin

### 1. Configurar OneSync no txAdmin

1. **Acede ao painel do txAdmin** (geralmente `http://teu-ip:40120`)
2. Vai a **Settings** → **Server Settings**
3. Procura a secção **OneSync**
4. Ativa uma das opções:
   - **OneSync Legacy** (se tiveres menos de 64 jogadores)
   - **OneSync Infinity** (recomendado - suporta até 2048 jogadores)
5. **Guarda as alterações**

### 2. Verificar Build do FiveM

1. No painel do txAdmin, vai a **Settings** → **Server Settings**
2. Procura **"Update Artifacts"** ou **"Change Server Version"**
3. Certifica-te de que estás a usar uma build **2189 ou superior**
4. **Recomendado**: Build **4752 ou superior** (mais recente)

### 3. Reiniciar o Servidor

Após configurar o OneSync no txAdmin:
1. Vai a **Actions** → **Restart Server**
2. Aguarda o servidor reiniciar completamente

## 📋 Passo a Passo para Keymaster (keymaster.fivem.net)

### 1. Configurar OneSync no Keymaster

1. Vai para https://keymaster.fivem.net
2. Faz login na tua conta
3. Clica no teu servidor
4. Procura a opção **"OneSync"** ou **"Server Settings"**
5. Ativa:
   - **OneSync Legacy** OU
   - **OneSync Infinity** (recomendado)
6. **Guarda as alterações**

### 2. Atualizar Artifacts (Build)

1. No Keymaster, procura **"Update Artifacts"** ou **"Change Server Version"**
2. Escolhe uma versão **2189 ou superior**
3. **Recomendado**: Versão **4752 ou superior**
4. Aplica as alterações

### 3. Reiniciar o Servidor

1. No Keymaster, clica em **"Restart Server"**
2. Aguarda o servidor reiniciar

## 🔧 Configuração Manual no server.cfg (Se NÃO usares txAdmin/Keymaster)

Se o teu host não tiver painel de configuração, podes adicionar diretamente no `server.cfg`:

### Opção 1: OneSync Legacy (até 64 jogadores)

```cfg
onesync_enable 1
onesync legacy
```

### Opção 2: OneSync Infinity (recomendado - até 2048 jogadores)

```cfg
onesync_enable 1
onesync on
```

### Opção 3: OneSync Infinity (alternativa)

```cfg
onesync infinity
```

## ✅ Como Verificar se Está Funcionando

### 1. Verificar no Console do Servidor

Quando o servidor iniciar, procura por mensagens como:
```
[OneSync] OneSync enabled
[OneSync] OneSync Infinity enabled
```

### 2. Testar o Script

1. Entra no servidor
2. Usa o comando: `/scale 150`
3. Se funcionar, o teu personagem deve ficar menor
4. Se der erro sobre `SetPedScale`, o OneSync não está ativado corretamente

### 3. Verificar Build

No console do servidor, digita:
```
version
```

Deve mostrar uma build **2189 ou superior**.

## 🐛 Resolução de Problemas

### Erro: "SetPedScale não está disponível"

**Causas possíveis:**
1. OneSync não está ativado
2. Build do FiveM é inferior a 2189
3. Conflito entre configuração do painel e server.cfg

**Soluções:**
1. Verifica se OneSync está ativado no painel (txAdmin/Keymaster)
2. Atualiza os artifacts para build 2189+
3. Se usares txAdmin, **remove** as linhas de OneSync do server.cfg
4. Reinicia o servidor completamente

### Erro: "onesync MUST only be set in the txAdmin settings page"

**Solução:**
- Se vês este aviso, significa que o txAdmin está a gerir o OneSync
- **NÃO** adiciones linhas de OneSync no server.cfg
- Configura apenas no painel do txAdmin

### OneSync não aparece no painel

**Possíveis causas:**
1. Licença do FiveM não suporta OneSync
2. Host não suporta OneSync
3. Build muito antiga

**Soluções:**
1. Verifica se a tua licença suporta OneSync
2. Contacta o suporte do teu host
3. Atualiza para build 2189+

## 📊 Comparação OneSync Legacy vs Infinity

| Característica | Legacy | Infinity |
|----------------|--------|----------|
| Máximo de jogadores | 64 | 2048 |
| Performance | Boa | Melhor |
| Sincronização | Básica | Avançada |
| SetPedScale | ✅ Funciona | ✅ Funciona |
| Recomendado para | Servidores pequenos | Servidores grandes |

## 📝 Checklist Final

- [ ] OneSync ativado no painel (txAdmin/Keymaster) OU no server.cfg
- [ ] Build do FiveM é 2189 ou superior
- [ ] Servidor foi reiniciado após configuração
- [ ] Testei o comando `/scale 150` e funcionou
- [ ] Não há erros no console sobre OneSync

## 🎯 Resumo Rápido

1. **txAdmin/Keymaster**: Configura OneSync no painel
2. **Build**: Atualiza para 2189+ (recomendado 4752+)
3. **Reinicia**: Reinicia o servidor
4. **Testa**: Usa `/scale 150` para verificar

---

**Nota**: Se estiveres a usar txAdmin, **NÃO** adiciones linhas de OneSync no server.cfg. O txAdmin gere isso automaticamente através do painel.

