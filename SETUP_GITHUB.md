# Guia de Configuração do GitHub

Este guia explica como criar um repositório Git e fazer push do projeto para o GitHub.

## 📋 Pré-requisitos

1. **Git instalado** - Já está instalado ✅
2. **Conta GitHub** - Cria uma em https://github.com se ainda não tiveres
3. **GitHub CLI (opcional)** - Para facilitar o processo

## 🚀 Passo a Passo

### Passo 1: Inicializar o Repositório Git

Se ainda não inicializaste o repositório, executa:

```powershell
# Navegar para a pasta do projeto
cd "C:\Users\rodri\Desktop\txData\DeadEngine.base\resources"

# Inicializar o repositório Git
git init

# Adicionar todos os ficheiros (exceto os ignorados pelo .gitignore)
git add .

# Fazer o primeiro commit
git commit -m "Initial commit: DeadEngine Qbox Project Resources"
```

### Passo 2: Criar Repositório no GitHub

1. Vai para https://github.com e faz login
2. Clica no botão **"+"** no canto superior direito
3. Seleciona **"New repository"**
4. Preenche os detalhes:
   - **Repository name**: `DeadEngine.base` (ou o nome que preferires)
   - **Description**: "DeadEngine - Qbox Project Resources for FiveM Server"
   - **Visibility**: Escolhe Public ou Private
   - **NÃO** inicializes com README, .gitignore ou license (já temos)
5. Clica em **"Create repository"**

### Passo 3: Ligar o Repositório Local ao GitHub

Após criares o repositório no GitHub, vais ver instruções. Executa estes comandos:

```powershell
# Adicionar o remote (substitui USERNAME pelo teu username do GitHub)
git remote add origin https://github.com/USERNAME/DeadEngine.base.git

# Verificar se foi adicionado corretamente
git remote -v
```

### Passo 4: Fazer Push para o GitHub

```powershell
# Renomear a branch principal para main (se necessário)
git branch -M main

# Fazer push do código para o GitHub
git push -u origin main
```

Se pedir credenciais:
- **Username**: O teu username do GitHub
- **Password**: Usa um **Personal Access Token** (não a tua password normal)

### Passo 5: Criar Personal Access Token (se necessário)

Se o GitHub pedir autenticação:

1. Vai para https://github.com/settings/tokens
2. Clica em **"Generate new token"** → **"Generate new token (classic)"**
3. Dá um nome ao token (ex: "DeadEngine Repo")
4. Seleciona o scope **`repo`** (acesso completo aos repositórios)
5. Clica em **"Generate token"**
6. **Copia o token** (só aparece uma vez!)
7. Usa este token como password quando o Git pedir

## 🔄 Comandos Úteis para o Futuro

### Fazer Alterações e Atualizar

```powershell
# Ver o estado dos ficheiros
git status

# Adicionar ficheiros alterados
git add .

# Fazer commit
git commit -m "Descrição das alterações"

# Fazer push para o GitHub
git push
```

### Criar uma Nova Branch

```powershell
# Criar e mudar para nova branch
git checkout -b feature/nome-da-feature

# Fazer push da nova branch
git push -u origin feature/nome-da-feature
```

### Ver Histórico

```powershell
# Ver commits
git log

# Ver commits de forma compacta
git log --oneline
```

## ⚠️ Notas Importantes

1. **Nunca faças commit de ficheiros sensíveis**:
   - `server.cfg` (contém licenças e chaves)
   - Ficheiros `.key`, `.pem`
   - Strings de conexão de base de dados com passwords

2. **O .gitignore já está configurado** para ignorar:
   - Ficheiros de configuração sensíveis
   - Logs
   - Cache
   - Node modules

3. **Se já tiveres um repositório Git existente**:
   ```powershell
   # Verificar remotes existentes
   git remote -v
   
   # Se quiseres mudar o remote
   git remote set-url origin https://github.com/USERNAME/DeadEngine.base.git
   ```

## 🐛 Resolução de Problemas

### Erro: "remote origin already exists"

```powershell
# Remover o remote existente
git remote remove origin

# Adicionar novamente
git remote add origin https://github.com/USERNAME/DeadEngine.base.git
```

### Erro: "failed to push some refs"

```powershell
# Fazer pull primeiro (se houver alterações no GitHub)
git pull origin main --allow-unrelated-histories

# Depois fazer push
git push -u origin main
```

### Erro de Autenticação

- Verifica se estás a usar um Personal Access Token
- Verifica se o token tem permissões `repo`
- Tenta usar GitHub CLI: `gh auth login`

## 📚 Recursos Adicionais

- [Documentação Git](https://git-scm.com/doc)
- [GitHub Docs](https://docs.github.com/)
- [GitHub CLI](https://cli.github.com/)

## ✅ Checklist

- [ ] Git inicializado
- [ ] .gitignore criado
- [ ] README.md criado
- [ ] Primeiro commit feito
- [ ] Repositório criado no GitHub
- [ ] Remote adicionado
- [ ] Código enviado para o GitHub
- [ ] Personal Access Token criado (se necessário)

---

**Dica**: Depois de fazer push, podes partilhar o link do repositório com outros ou usá-lo para fazer backup do teu servidor!

