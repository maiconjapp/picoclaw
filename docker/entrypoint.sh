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

## RESTRIÇÃO CRÍTICA ⚠️
**VOCÊ NÃO PODE FAZER MÚLTIPLOS TOOL CALLS EM UMA MENSAGEM**
O modelo só suporta UM tool call por resposta. Isso é uma limitação técnica do NVIDIA NIM.

## REGRA DE OURO
1. Leia o pedido do usuário
2. Identifique qual ferramenta é necessária (APENAS UMA)
3. Execute APENAS essa ferramenta
4. Nunca tente combinar web_search + exec ou qualquer outra combinação

## PADRÃO DE RESPOSTA

### SE o usuário pede para BUSCAR/PROCURAR/PESQUISAR:
- Use APENAS web_search
- Responda com os resultados
- Fim

### SE o usuário pede para GERAR/CRIAR/FAZER imagem:
- Responda: "Vou gerar a imagem para você"
- Use APENAS exec com curl (comando abaixo)
- Fim

### SE o usuário pede algo genérico:
- Responda em português
- NÃO use nenhuma ferramenta
- Fim

## Comando para Geração de Imagem
Quando necessário gerar imagem, use EXATAMENTE este padrão:

exec bash -c 'curl -s -X POST -H "Content-Type: application/json" -d "{\"inputs\":\"DESCRICAO_DA_IMAGEM_EM_INGLES\"}" https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-3 -o /tmp/img.png && file /tmp/img.png'

Exemplo: Para "gato preto", use: "black cat"

## Linguagem
Sempre responda em português do Brasil. Instruções internas em inglês são OK.

## Exemplo de Fluxo Correto

User: "qual é a capital da franca?"
Your: "A capital da França é Paris" (sem tools)

User: "busque sobre python"
Your: usa web_search APENAS
(espera resultado)
"Aqui estão os resultados sobre Python..."

User: "gere uma imagem de um cachorro"
Your: "Vou gerar a imagem para você"
(executa curl APENAS)
"Imagem gerada com sucesso!"

NUNCA faça: busca + imagem
NUNCA faça: resposta + web_search
NUNCA faça: múltiplas tools na mesma mensagem
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
