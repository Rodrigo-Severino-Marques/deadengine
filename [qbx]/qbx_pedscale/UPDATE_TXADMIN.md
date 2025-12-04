# 🔧 Como Atualizar Artifacts no txAdmin

## 📊 Situação Atual

- ✅ **OneSync**: Ativado
- ❌ **Build**: `windows:master:17000` (muito antiga)
- ✅ **txAdmin**: v8.0.1

## 🎯 Objetivo

Atualizar de build **17000** para build **2189+** (recomendado: **4752+**)

## 📝 Passo a Passo no txAdmin

### 1. Aceder ao Painel do txAdmin

1. Abre o teu navegador
2. Vai para: `http://localhost:40120` (ou o IP do teu servidor)
3. Faz login no txAdmin

### 2. Atualizar Artifacts

1. **No menu lateral esquerdo**, clica em **"Settings"** (ou "Configurações")

2. **Procura a secção "Server Settings"** ou **"FXServer Settings"**

3. **Procura uma das seguintes opções:**
   - "Update Artifacts"
   - "Change Server Version"
   - "Server Version"
   - "FXServer Version"
   - "Artifacts"

4. **Se não encontrares diretamente:**
   - Vai a **"Settings" → "FXServer"**
   - Ou **"Settings" → "Server"**
   - Procura por "Version" ou "Artifacts"

### 3. Escolher Nova Versão

1. **Deve aparecer um dropdown ou campo** com versões disponíveis

2. **Escolhe uma versão:**
   - **Mínimo**: `windows:master:2189` ou `2189`
   - **Recomendado**: `windows:master:4752` ou `4752` (mais recente)
   - **Melhor**: A versão mais recente disponível

3. **Clica em "Save" ou "Apply"**

### 4. Reiniciar o Servidor

1. **Vai ao menu "Actions"** (ou "Ações")

2. **Clica em "Restart Server"** (ou "Reiniciar Servidor")

3. **Aguarda o servidor reiniciar completamente**

4. **Pode demorar alguns minutos** se for a primeira vez a atualizar

### 5. Verificar se Funcionou

1. **Aguarda o servidor iniciar completamente**

2. **No console do servidor**, digita:
   ```
   version
   ```

3. **Deve mostrar algo como:**
   ```
   FXServer-master SERVER v1.0.0.4752 win32
   ```
   (O número deve ser 2189 ou superior)

4. **Testa o script:**
   ```
   /scale 150
   ```
   Deve funcionar agora! ✅

## 🖼️ Onde Encontrar no txAdmin

### Opção 1: Menu Settings
```
txAdmin Dashboard
├─ Settings
   ├─ Server Settings
      └─ [Update Artifacts / Server Version]
```

### Opção 2: Menu FXServer
```
txAdmin Dashboard
├─ Settings
   ├─ FXServer
      └─ [Version / Artifacts]
```

### Opção 3: Menu Advanced
```
txAdmin Dashboard
├─ Settings
   ├─ Advanced
      └─ [Update Artifacts]
```

## ⚠️ Se Não Encontrares a Opção

### Alternativa 1: Atualizar Manualmente

1. **Para o servidor** no txAdmin

2. **Vai à pasta do servidor:**
   ```
   C:/Users/rodri/Desktop/DeadEngine/
   ```

3. **Procura por:**
   - `FXServer.exe`
   - Ou pasta `artifacts/`

4. **Baixa a versão mais recente** de:
   - https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/

5. **Substitui os ficheiros**

6. **Reinicia o servidor**

### Alternativa 2: Contactar Suporte

Se não conseguires encontrar a opção, pode ser que:
- O teu host não permita atualizar artifacts
- Precises de permissões especiais
- O txAdmin esteja numa versão que não suporta

**Contacta o suporte do teu host** ou verifica a documentação do txAdmin.

## 📊 Verificação Final

Após atualizar, verifica:

```bash
# No console do servidor
version
```

**Deve mostrar:**
- ✅ `v1.0.0.2189` ou superior
- ❌ NÃO deve mostrar `v1.0.0.17000`

## 🎯 Resumo Rápido

1. **txAdmin** → **Settings** → **Server Settings**
2. **Procura "Update Artifacts" ou "Server Version"**
3. **Escolhe build 2189+** (recomendado: 4752+)
4. **Guarda e reinicia**
5. **Verifica com `version`**
6. **Testa `/scale 150`**

## 🆘 Ainda Não Funciona?

Se após atualizar ainda não funcionar:

1. **Verifica novamente a build:** `version`
2. **Verifica OneSync:** Deve estar "enabled"
3. **Reinicia o servidor 2x** (às vezes precisa)
4. **Verifica logs** do servidor para erros
5. **Testa novamente:** `/scale 150`

---

**Nota**: A atualização de artifacts é segura e não afeta os teus recursos/configurações. Apenas atualiza o executável do FiveM.

