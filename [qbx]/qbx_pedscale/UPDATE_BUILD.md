# 🚨 Problema Identificado: Build do FiveM Muito Antiga

## ❌ Problema Atual

A tua build do FiveM é: **v1.0.0.17000**

Esta build é **muito antiga** e não suporta `SetPedScale`.

**Requisito mínimo**: Build **2189 ou superior**  
**Recomendado**: Build **4752 ou superior** (mais recente)

## ✅ Solução: Atualizar Artifacts

### Para txAdmin:

1. **Acede ao painel do txAdmin**
   - Geralmente: `http://teu-ip:40120`

2. **Vai a Settings → Server Settings**

3. **Procura "Update Artifacts" ou "Change Server Version"**

4. **Escolhe uma versão recente:**
   - Mínimo: **2189**
   - Recomendado: **4752** ou a mais recente disponível

5. **Aplica as alterações**

6. **Reinicia o servidor**

### Para Keymaster (keymaster.fivem.net):

1. **Vai para https://keymaster.fivem.net**

2. **Faz login e seleciona o teu servidor**

3. **Procura "Update Artifacts" ou "Change Server Version"**

4. **Escolhe uma versão recente:**
   - Mínimo: **2189**
   - Recomendado: **4752** ou a mais recente

5. **Aplica e reinicia**

### Para Hosts com Painel Próprio:

1. **Procura no painel do teu host:**
   - "Update Artifacts"
   - "Change Server Version"
   - "Server Version"
   - "FiveM Version"

2. **Escolhe build 2189+**

3. **Reinicia o servidor**

## 📊 Comparação de Builds

| Build | Ano | SetPedScale | Status |
|-------|-----|-------------|--------|
| 17000 | ~2020 | ❌ Não | Muito antiga |
| 2189 | 2022 | ✅ Sim | Mínimo necessário |
| 4752 | 2024+ | ✅ Sim | Recomendada |

## ⚠️ Importante

- **Backup**: Faz backup antes de atualizar
- **Recursos**: Alguns recursos antigos podem precisar de atualização
- **Testes**: Testa tudo após atualizar

## ✅ Após Atualizar

1. **Reinicia o servidor completamente**

2. **Verifica a versão novamente:**
   ```
   version
   ```
   Deve mostrar algo como: `v1.0.0.4752` ou superior

3. **Testa o script:**
   ```
   /scale 150
   ```
   Deve funcionar agora!

## 🐛 Se Ainda Não Funcionar Após Atualizar

1. **Verifica OneSync:**
   - Deve estar ativado
   - Preferencialmente OneSync Infinity

2. **Verifica logs:**
   - Procura por erros no console
   - Verifica se `SetPedScale` aparece como disponível

3. **Reinicia novamente:**
   - Às vezes precisa de reiniciar 2x após atualizar artifacts

## 📝 Nota

A build 17000 é de aproximadamente 2020/2021. Muitas funcionalidades novas do FiveM requerem builds mais recentes. Atualizar os artifacts é seguro e recomendado para ter acesso a todas as funcionalidades modernas.

