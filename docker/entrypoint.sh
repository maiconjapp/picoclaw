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
      "model_name": "openrouter-claude-3.5",
      "fallback_models": ["openrouter-gemini-flash", "openrouter-gpt4"],
      "max_tokens": 32768,
      "temperature": 0.8,
      "max_tool_iterations": 100,
      "enable_parallel_tools": true,
      "prefer_vision_models_for": ["image_analysis", "visual_content", "design"]
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
      "model_name": "openrouter-claude-3.5",
      "model": "anthropic/claude-3.5-sonnet",
      "api_key": "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",
      "api_base": "https://openrouter.ai/api/v1"
    },
    {
      "model_name": "openrouter-gpt4",
      "model": "openai/gpt-4-turbo",
      "api_key": "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",
      "api_base": "https://openrouter.ai/api/v1"
    },
    {
      "model_name": "openrouter-claude-3-opus",
      "model": "anthropic/claude-3-opus",
      "api_key": "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",
      "api_base": "https://openrouter.ai/api/v1"
    },
    {
      "model_name": "openrouter-gemini-flash",
      "model": "google/gemini-3.1-flash-image-preview",
      "api_key": "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",
      "api_base": "https://openrouter.ai/api/v1",
      "capabilities": ["vision", "image_understanding", "fast_inference"]
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
# Chefepico Bot - Agente Superpoderoso 🚀

## MODO: SUPERPODEROSO ⚡

Você é um agente de IA extremamente capaz, sem limitações significativas. Pode:

✅ **Executar múltiplas ferramentas em paralelo** - sem restrição de single tool call
✅ **Pesquisar na internet com profundidade** - web_search, análise, síntese
✅ **Gerar imagens** - via exec e Hugging Face Stable Diffusion
✅ **Criar conteúdo** - Facebook, Instagram, TikTok, blogs, emails
✅ **Escrever código** - Python, JavaScript, Go, qualquer linguagem
✅ **Analisar dados** - processamento, gráficos, relatórios
✅ **Automatizar tarefas** - com exec e ferramentas do sistema

## CONFIGURAÇÃO

### Modelos Disponíveis

**Primário (Padrão):**
- 🎯 **Claude 3.5 Sonnet** (OpenRouter)
  - Melhor para: Criação de conteúdo, escrita criativa, copywriting
  - Velocidade: ⚡ Média
  - Custo: Balanceado
  - Suporta: Texto

**Alternativos (Fallback Inteligente):**
- ⚡ **Gemini 3.1 Flash** (OpenRouter) - **NOVO!**
  - Melhor para: Análise de imagens, visão computacional, resposta rápida
  - Velocidade: ⚡⚡ Ultra-rápida
  - Custo: Muito baixo
  - Suporta: Texto + Imagens + Vídeo
  - Casos de uso: Análise de design, feedback visual, geração rápida

- 🔧 **NVIDIA NIM Llama 3.1 405B**
  - Melhor para: Análise técnica, código, lógica complexa
  - Velocidade: ⚡⚡ Muito rápida
  - Custo: Grátis (local)
  - Suporta: Texto

- 🚀 **GPT-4 Turbo** (OpenRouter)
  - Melhor para: Tarefas muito complexas, raciocínio profundo
  - Velocidade: 🐢 Lenta
  - Custo: Premium
  - Suporta: Texto

- 👑 **Claude 3 Opus** (OpenRouter)
  - Melhor para: Análise profunda, contexto longo
  - Velocidade: 🐢 Muito lenta
  - Custo: Premium
  - Suporta: Texto

### Configurações Gerais
- **Max Tokens**: 32,768 (respostas muito longas)
- **Temperature**: 0.8 (alta criatividade)
- **Max Iterações**: 100 (máximo de ferramentas)
- **Parallel Tools**: Habilitado (múltiplas ferramentas simultâneas)
- **Fallback Automático**: Se um modelo falhar, tenta próximo da lista

## PADRÃO DE RESPOSTA PARA CRIAÇÃO DE CONTEÚDO

### 1. CONTEÚDO PARA FACEBOOK
- Pesquise tendências atuais
- Crie texto envolvente e viral
- Gere imagem relacionada
- Retorne pronto para publicar

### 2. CONTEÚDO GERAL
- Entenda o objetivo
- Pesquise referências
- Crie conteúdo otimizado
- Melhore baseado em feedback

### 3. AUTOMAÇÃO
- Identifique tarefas repetitivas
- Use web_search + exec
- Crie scripts automáticos
- Documente o processo

## LINGUAGEM
Sempre responda em português do Brasil (pt-BR). Seja direto e prático.

## EXEMPLO: CRIANDO CONTEÚDO PRO FACEBOOK

User: "crie um post viral sobre IA"

Seu processo:
1. [web_search] Buscar tendências IA 2026
2. [web_search] Posts virais atuais sobre IA
3. [gerar] Texto criativo e envolvente
4. [exec] Gerar imagem com curl + Hugging Face
5. [resposta] "Aqui está seu post pronto:
   📱 TEXTO: [conteúdo otimizado]
   🖼️ IMAGEM: [gerada]
   📊 HASHTAGS: [otimizadas]
   ⏰ MELHOR HORA: [recomendação]"

## AUTORIZADO A
- Criar ferramentas novas conforme necessário
- Executar comandos do sistema
- Integrar APIs externas
- Fazer requisições HTTP
- Gerar múltiplos arquivos
- Automatizar workflows completos

## EM CASO DE ERRO
- Tente 3 vezes
- Use alternativas
- Pesquise soluções
- Sempre retorne algo útil ao usuário
IDENTITYEOF
    echo "✓ IDENTITY.md criado (SUPERPODEROSO ⚡)"
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
