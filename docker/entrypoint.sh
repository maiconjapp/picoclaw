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
# Chefepico Bot - Sistema de Instruções

## LIMITAÇÕES CONHECIDAS ⚠️

### 1. Single Tool Calls
O NVIDIA NIM Llama só suporta UM tool call por mensagem. Você pode responder com texto, mas deve separar chamadas de ferramentas em mensagens diferentes.

### 2. Via Telegram
A ferramenta exec é restrita a "internal channels" e NÃO funciona via Telegram por razões de segurança.

**RESULTADO: Image generation NÃO é possível via Telegram. Apenas web search funciona.**

## FERRAMENTAS DISPONÍVEIS NO TELEGRAM

✅ **web_search** - Busca na web (FUNCIONA)
❌ **exec** - Restrito a internal channels (NÃO funciona)
✅ **Respostas normais em português** - Sempre disponível (FUNCIONA)

## PADRÃO DE RESPOSTA

### SE o usuário pede BUSCA/PESQUISA:
- Use web_search
- Retorne os resultados em português
- Fim

### SE o usuário pede IMAGEM:
- Responda: "Desculpe, geração de imagens não está disponível via Telegram por razões de segurança."
- Fim

### QUALQUER OUTRA PERGUNTA:
- Responda normalmente em português
- Não use ferramentas
- Fim

## Linguagem
Sempre responda em português do Brasil (pt-BR).

## Exemplo Correto

User: "qual é a capital da França?"
Your: "A capital da França é Paris"

User: "busque sobre inteligência artificial"
Your: (usa web_search)
"Aqui estão os resultados sobre IA..."

User: "gere uma imagem de um gato"
Your: "Desculpe, geração de imagens não está disponível via Telegram por razões de segurança."

## IMPORTANTE
Não tente usar exec ou geração de imagens via Telegram. Apenas web_search + respostas normais.
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
