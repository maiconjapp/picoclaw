#!/bin/sh
set -e

HOME=${HOME:=/home/picoclaw}
PICOCLAW_HOME="${HOME}/.picoclaw"

# Criar diretórios se não existirem
mkdir -p "$PICOCLAW_HOME"

# Se config.json já existe, apenas rodar gateway
if [ -f "$PICOCLAW_HOME/config.json" ]; then
    exec picoclaw gateway "$@"
fi

# Gerar config.json dinamicamente
cat > "$PICOCLAW_HOME/config.json" << 'EOF'
{
  "agents": {
    "defaults": {
      "workspace": "~/.picoclaw/workspace",
      "restrict_to_workspace": false,
      "model_name": "nvidia-nim",
      "max_tokens": 4096,
      "temperature": 0.7,
      "max_tool_iterations": 10,
      "summarize_message_threshold": 20,
      "summarize_token_percent": 75
    }
  },
  "model_list": [
    {
      "model_name": "nvidia-nim",
      "model": "openai/llama-3.1-405b-instruct",
      "api_key": "not-needed",
      "api_base": "https://integrate.api.nvidia.com/v1"
    },
    {
      "model_name": "nvidia-nim-70b",
      "model": "openai/llama-3.3-70b-instruct",
      "api_key": "not-needed",
      "api_base": "https://integrate.api.nvidia.com/v1"
    }
  ],
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "7651405976:AAHw_17VXXVgeASPZ9NAmPv_wmGvIxiHySo",
      "base_url": "",
      "proxy": "",
      "allow_from": [7378263230],
      "reasoning_channel_id": ""
    }
  },
  "tools": {
    "web_search": {
      "enabled": true,
      "provider": "duckduckgo"
    }
  }
}
EOF

# Gerar IDENTITY.md com instruções
cat > "$PICOCLAW_HOME/IDENTITY.md" << 'EOF'
# Agent Identity

You are a helpful AI agent with access to:
- Web search (DuckDuckGo) for real-time information
- Image generation via Hugging Face API
- File operations within workspace
- Tool execution

## Image Generation

When asked to create/generate images:
1. Use the `exec` tool with this command:
```
curl -s -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "inputs": "prompt_text_here",
    "model_id": "stabilityai/stable-diffusion-3"
  }' \
  https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-3 \
  -o image.png && echo "Image saved to image.png"
```

2. Always describe what image you're creating
3. Return the file path to the generated image

## Web Search

Use web_search tool for:
- Current information
- Real-time data
- Recent news
- Up-to-date information

## Behavior

- Be helpful and accurate
- Use available tools when appropriate
- Provide clear explanations
- Handle errors gracefully
EOF

echo "✓ Configuration files created"
echo ""
echo "Telegram Bot Token: configured"
echo "Models: NVIDIA NIM (Llama 3.1 405B, Llama 3.3 70B)"
echo "Features: Web Search (DuckDuckGo), Image Generation (Hugging Face)"
echo ""

exec picoclaw gateway "$@"
