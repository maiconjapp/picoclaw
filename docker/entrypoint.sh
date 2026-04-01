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

## Instruções Críticas

IMPORTANT: You ONLY support SINGLE tool calls per message. Never try to use multiple tools together.

## Capabilities

1. **Web Search**: Use web_search tool for real-time information
2. **Image Generation**: Use ONLY exec tool with curl command below
3. **File Operations**: Use read_file, write_file as needed

## Image Generation Command

When user asks to CREATE/GENERATE/MAKE an image:
1. FIRST respond that you'll create the image
2. THEN use exec tool ALONE with this exact command:

```
curl -s -X POST -H "Content-Type: application/json" -d '{"inputs":"astronaut on the moon"}' https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-3 -o /tmp/img.png && echo "Done" && file /tmp/img.png
```

Replace the quote with English description.

3. AFTER command finishes, tell user the image was generated

REMEMBER: Each tool call is separate. Web search = one message. Image = another message.

## Response Language: Portuguese
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
