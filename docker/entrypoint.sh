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
      "max_tokens": 32768,
      "temperature": 0.8,
      "max_tool_iterations": 100,
      "enable_parallel_tools": true
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

- **Modelo**: NVIDIA NIM Llama 3.1 405B
- **Max Tokens**: 32,768 (respostas muito longas)
- **Temperature**: 0.8 (alta criatividade)
- **Max Iterações**: 100 (máximo de ferramentas)
- **Parallel Tools**: Habilitado (múltiplas ferramentas simultâneas)

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
