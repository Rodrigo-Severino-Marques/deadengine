# 🚀 Quick Start - GitHub Setup

## ✅ O que já foi feito:

1. ✅ Repositório Git inicializado
2. ✅ `.gitignore` criado (ignora ficheiros sensíveis)
3. ✅ `README.md` criado (documentação principal)
4. ✅ Guias criados:
   - `HOW_TO_ADD_WEAPON_PROPS.md`
   - `HOW_TO_ADD_NEW_CLOTHES.md`
   - `SETUP_GITHUB.md`

## 📝 Próximos Passos:

### 1. Configurar o Git (se ainda não fizeste)

```powershell
cd "C:\Users\rodri\Desktop\txData\DeadEngine.base\resources"
git config user.name "Teu Nome"
git config user.email "teu@email.com"
```

### 2. Adicionar Ficheiros ao Git

**⚠️ IMPORTANTE**: Antes de adicionar tudo, considera:

- O projeto é **MUITO GRANDE** (muitos recursos)
- Pode demorar muito tempo a fazer push
- Alguns recursos podem ser privados/licenciados

**Opção A: Adicionar Tudo (Recomendado para backup completo)**
```powershell
git add .
git commit -m "Initial commit: DeadEngine Qbox Project Resources"
```

**Opção B: Adicionar Apenas Documentação Primeiro**
```powershell
git add .gitignore README.md *.md
git commit -m "Initial commit: Documentation and guides"
# Depois adiciona os recursos quando estiveres pronto
```

### 3. Criar Repositório no GitHub

1. Vai para https://github.com/new
2. Nome: `DeadEngine.base` (ou o que preferires)
3. Descrição: "DeadEngine - Qbox Project Resources"
4. **NÃO** inicializes com README (já temos)
5. Clica "Create repository"

### 4. Ligar e Fazer Push

```powershell
# Adicionar remote (substitui USERNAME)
git remote add origin https://github.com/USERNAME/DeadEngine.base.git

# Renomear branch para main
git branch -M main

# Fazer push
git push -u origin main
```

**Nota**: Se pedir autenticação, usa um [Personal Access Token](https://github.com/settings/tokens)

## 📊 Tamanho Estimado

O projeto completo pode ter:
- **Milhares de ficheiros**
- **Centenas de MB** ou mais
- **Tempo de upload**: Depende da tua internet (pode demorar 30min+)

## 💡 Dicas

1. **Primeira vez**: Adiciona apenas a documentação primeiro para testar
2. **Depois**: Adiciona os recursos em batches se necessário
3. **Backup**: O GitHub é um ótimo backup do teu código
4. **Privacidade**: Considera um repositório privado se tiveres código sensível

## 🆘 Precisa de Ajuda?

Consulta `SETUP_GITHUB.md` para um guia detalhado!

