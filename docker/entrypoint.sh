#!/bin/sh
set -e

HOME=/home/picoclaw
PICOCLAW_HOME="${HOME}/.picoclaw"

# Criar diretórios e arquivos de configuração
mkdir -p "$PICOCLAW_HOME"

# Se config.json não existe, criar
if [ ! -f "$PICOCLAW_HOME/config.json" ]; then
    cat > "$PICOCLAW_HOME/config.json" << 'CONFIGEOF'
{
  "agents": {
    "defaults": {
      "workspace": "~/.picoclaw/workspace",
      "restrict_to_workspace": false,
      "model_name": "nvidia-nim",
      "max_tokens": 4096,
      "temperature": 0.5,
      "max_tool_iterations": 20
    }
  },
  "model_list": [
    {
      "model_name": "nvidia-nim",
      "model": "openai/llama-3.1-405b-instruct",
      "api_key": "not-needed",
      "api_base": "https://integrate.api.nvidia.com/v1"
    }
  ],
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "7651405976:AAHw_17VXXVgeASPZ9NAmPv_wmGvIxiHySo",
      "allow_from": [7378263230]
    }
  },
  "tools": {
    "web": {
      "enabled": true
    },
    "exec": {
      "enabled": true
    },
    "read_file": {
      "enabled": true
    },
    "write_file": {
      "enabled": true
    }
  }
}
CONFIGEOF
    echo "✓ config.json criado"
fi

# Criar IDENTITY.md se não existir
if [ ! -f "$PICOCLAW_HOME/IDENTITY.md" ]; then
    cat > "$PICOCLAW_HOME/IDENTITY.md" << 'IDENTITYEOF'
# Identidade do Agente - Chefepico Bot

Você é um agente de IA poderoso capaz de:

## 🔍 Busca na Web
- Use web_search para informações em tempo real
- Pesquisa em português funciona perfeitamente
- Sempre forneça fontes confiáveis

## 🖼️ Geração de Imagens
SEMPRE que alguém pedir para criar/gerar/fazer uma imagem, use EXATAMENTE este comando via exec:

```
curl -s -X POST \
  -H "Content-Type: application/json" \
  -d "{\"inputs\":\"PROMPT_AQUI\"}" \
  https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-3 \
  --output /tmp/generated_image.png && file /tmp/generated_image.png
```

Substitua PROMPT_AQUI pela descrição da imagem em INGLÊS.

IMPORTANTE:
- Não reclame que não pode fazer imagens
- Sempre tente fazer a imagem
- Se funcionar, informe ao usuário: "Imagem gerada com sucesso!"
- Se falhar, tente novamente com descrição mais simples

## 📝 Comportamento
- Seja proativo em criar imagens
- Responda em português
- Use as ferramentas disponíveis
IDENTITYEOF
    echo "✓ IDENTITY.md criado"
fi

# Garantir permissões
chown -R picoclaw:picoclaw "$PICOCLAW_HOME"
chmod -R 755 "$PICOCLAW_HOME"

echo ""
echo "═══════════════════════════════════════════════════"
echo "✓ Bot Telegram PicoClaw iniciando..."
echo "═══════════════════════════════════════════════════"
echo "Recuros:"
echo "  • Modelos: NVIDIA NIM (Llama 3.1 405B)"
echo "  • Busca: DuckDuckGo integrado"
echo "  • Imagens: Hugging Face Stable Diffusion 3"
echo "═══════════════════════════════════════════════════"
echo ""

# Executar picoclaw como picoclaw user
exec su - picoclaw -c "picoclaw gateway $@"
