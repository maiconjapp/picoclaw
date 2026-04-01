# Deployment no Railway

## Opção 1: Usar seu Fork no GitHub (Recomendado)

### Passo 1: Criar Fork
1. Vá para https://github.com/sipeed/picoclaw
2. Clique em "Fork"
3. Copie a URL do seu fork (ex: `https://github.com/seuUsuario/picoclaw.git`)

### Passo 2: Atualizar Remote
```bash
git remote set-url origin https://github.com/seuUsuario/picoclaw.git
git branch -M main
git push -u origin main
```

### Passo 3: Conectar ao Railway
1. Acesse https://railway.app
2. Crie um novo projeto ou use o existente (projeto ID: `3afae4d8-cb7d-465a-b62b-99d215ec61a4`)
3. Clique em "+ New" → "GitHub Repo"
4. Selecione seu fork do PicoClaw
5. Railway fará o deploy automaticamente

---

## Opção 2: Deploy Direto via Railway CLI

```bash
# Instalar CLI
npm i -g @railway/cli

# Fazer login
railway login

# Deploy do diretório atual
railway up
```

---

## Verificações Após Deploy

1. **Bot Telegram Respondendo**
   ```
   /start no Telegram
   Esperado: Bot responde "Olá! Sou seu agente de IA."
   ```

2. **Teste Busca Web**
   ```
   Envie: "busque sobre inteligência artificial"
   Esperado: Bot faz busca e retorna resultados
   ```

3. **Teste Geração de Imagem**
   ```
   Envie: "crie uma imagem de um gato preto"
   Esperado: Bot gera imagem e envia no Telegram
   ```

---

## Variáveis de Ambiente

Railway detectará automaticamente:
- `TELEGRAM_BOT_TOKEN` (já configurado em entrypoint.sh)
- `NVIDIA_NIM_API_KEY` (opcional, usa free tier)

Para adicionar via Railway Dashboard:
1. Railway → Seu Projeto → Variables
2. Adicione conforme necessário

---

## Logs

Para ver logs em tempo real:
```bash
railway logs --follow
```

Ou via Dashboard:
1. Railway → Seu Projeto → Deployments
2. Clique no deployment ativo
3. Abra aba "Logs"

---

## Troubleshooting

### Bot não responde
```
railway logs | grep telegram
```

### Erro de API
```
railway logs | grep -i error
```

### Imagens não funcionam
```
railway logs | grep -i image
```

---

## Rollback

Se precisar voltar a versão anterior:
1. Railway → Seu Projeto → Deployments
2. Clique em um deployment anterior
3. Clique em "Redeploy"
