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
      "model": "openrouter/google/gemini-2.0-flash-001",
      "api_key": "${OPENROUTER_API_KEY:-not-set}",
      "api_base": "https://openrouter.ai/api/v1"
    },
    {
      "model_name": "openrouter-gpt4",
      "model": "openrouter/openai/gpt-4o-mini",
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

## Claude Code Sessions (openclaw-claude-code)
Voce tem acesso ao `claude-code-skill` para gerenciar sessoes de coding agentes.
Use via ferramenta exec:

- Iniciar sessao: `claude-code-skill session-start <nome>`
- Enviar tarefa: `claude-code-skill session-send <nome> "<tarefa>"`
- Listar sessoes: `claude-code-skill session-list`
- Status: `claude-code-skill session-status <nome>`
- Parar sessao: `claude-code-skill session-stop <nome>`

Exemplos de uso:
- Usuario pede "cria um script python" -> inicia sessao e envia a tarefa
- Usuario pede "continua o codigo" -> envia mensagem para sessao existente

## Idioma
Sempre responda em portugues do Brasil (pt-BR).
IDENTITYEOF
    echo "* IDENTITY.md criado"
fi

# Garantir permissoes (usuario ja e picoclaw via USER no Dockerfile)
chmod -R 755 "$PICOCLAW_HOME"

echo ""
echo "=== PicoClaw Bot iniciando ==="
echo "Modelo: ${PRIMARY_MODEL}"
echo "=============================="
echo ""

# Iniciar claude-code-skill server em background
if command -v claude-code-skill > /dev/null 2>&1; then
    claude-code-skill serve --port 18796 &
    echo "* claude-code-skill server iniciado na porta 18796"
fi

# Executar picoclaw
exec picoclaw gateway
