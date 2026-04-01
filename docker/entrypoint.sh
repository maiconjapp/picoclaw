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
      "temperature": 0.7,
      "max_tool_iterations": 15
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
  }
}
CONFIGEOF
    echo "✓ config.json criado"
fi

# Criar IDENTITY.md se não existir
if [ ! -f "$PICOCLAW_HOME/IDENTITY.md" ]; then
    cat > "$PICOCLAW_HOME/IDENTITY.md" << 'IDENTITYEOF'
# Identidade do Agente

Você é um agente de IA capaz de:

## 🔍 Busca na Web
- Usar a ferramenta `web_search` para buscar informações em tempo real
- Pesquisar no Google/DuckDuckGo quando solicitado

## 🖼️ Geração de Imagens
Use o comando curl para gerar imagens via Hugging Face:

```bash
curl -s -X POST \
  -H "Content-Type: application/json" \
  -d '{"inputs":"descrição da imagem aqui"}' \
  https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-3 \
  -o /tmp/image.png && echo "Imagem gerada: /tmp/image.png"
```

Sempre descreva a imagem que está criando antes de gerar.

## 📝 Comportamento
- Seja sempre helpful
- Use as ferramentas disponíveis apropriadamente
- Forneça explicações claras
- Trate erros com graça
- Responda em português quando necessário
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
