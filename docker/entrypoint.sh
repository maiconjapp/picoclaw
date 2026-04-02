#!/bin/sh
set -e

HOME=/home/picoclaw
PICOCLAW_HOME="${HOME}/.picoclaw"

# Criar diretorios e arquivos de configuracao
mkdir -p "$PICOCLAW_HOME"

# Detectar modelo primario baseado nas variaveis de ambiente disponiveis
if [ -n "${OPENROUTER_API_KEY:-}" ]; then
    PRIMARY_MODEL="openrouter-gemini-flash"
    echo "* Usando OpenRouter como modelo primario"
else
    PRIMARY_MODEL="nvidia-nim"
    echo "* Usando NVIDIA NIM como modelo primario"
fi

# Se config.json nao existe, criar
if [ ! -f "$PICOCLAW_HOME/config.json" ]; then
    cat > "$PICOCLAW_HOME/config.json" << CONFIGEOF
{
  "agents": {
    "defaults": {
      "workspace": "~/.picoclaw/workspace",
      "restrict_to_workspace": false,
      "model_name": "${PRIMARY_MODEL}",
      "max_tokens": 16384,
      "temperature": 0.7,
      "max_tool_iterations": 50
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
      "model_name": "openrouter-gemini-flash",
      "model": "google/gemini-2.0-flash-001",
      "api_key": "${OPENROUTER_API_KEY:-not-set}",
      "api_base": "https://openrouter.ai/api/v1"
    },
    {
      "model_name": "openrouter-gpt4",
      "model": "openai/gpt-4o-mini",
      "api_key": "${OPENROUTER_API_KEY:-not-set}",
      "api_base": "https://openrouter.ai/api/v1"
    }
  ],
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "${TELEGRAM_TOKEN:-not-set}",
      "allow_from": [${TELEGRAM_ALLOW_FROM:-0}]
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
    echo "* config.json criado"
fi

# Criar IDENTITY.md se nao existir
if [ ! -f "$PICOCLAW_HOME/IDENTITY.md" ]; then
    cat > "$PICOCLAW_HOME/IDENTITY.md" << 'IDENTITYEOF'
# Chefepico Bot

Voce e um assistente inteligente que responde em portugues do Brasil.
Seja direto e pratico. Use as ferramentas disponiveis para ajudar o usuario.

## Ferramentas
- web_search: buscar informacoes na internet
- exec: executar comandos do sistema
- read_file / write_file: ler e escrever arquivos

## Idioma
Sempre responda em portugues do Brasil (pt-BR).
IDENTITYEOF
    echo "* IDENTITY.md criado"
fi

# Garantir permissoes
chown -R picoclaw:picoclaw "$PICOCLAW_HOME"
chmod -R 755 "$PICOCLAW_HOME"

echo ""
echo "=== PicoClaw Bot iniciando ==="
echo "Modelo: ${PRIMARY_MODEL}"
echo "=============================="
echo ""

# Executar picoclaw
exec picoclaw gateway
