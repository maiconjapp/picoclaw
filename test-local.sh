#!/bin/bash

# Script para testar bot localmente antes de fazer deploy
# Uso: ./test-local.sh

set -e

echo "════════════════════════════════════════════════════"
echo "🚀 Iniciando teste local do PicoClaw Bot"
echo "════════════════════════════════════════════════════"
echo ""

# Verificar se Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker não está instalado!"
    echo "Instale Docker de: https://www.docker.com/"
    exit 1
fi

# Verificar se docker-compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose não está instalado!"
    echo "Instale de: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✓ Docker e Docker Compose encontrados"
echo ""

# Build da imagem
echo "📦 Building imagem Docker..."
docker-compose build

echo ""
echo "🚀 Iniciando container..."
docker-compose up -d

echo ""
echo "⏳ Aguardando inicialização (10 segundos)..."
sleep 10

echo ""
echo "✓ Container iniciado!"
echo ""
echo "════════════════════════════════════════════════════"
echo "📋 Logs do container:"
echo "════════════════════════════════════════════════════"
docker-compose logs --tail=50

echo ""
echo "════════════════════════════════════════════════════"
echo "✓ Bot está rodando localmente!"
echo "════════════════════════════════════════════════════"
echo ""
echo "📱 Para testar via Telegram:"
echo "   1. Envie uma mensagem para @Chefepico_bot"
echo "   2. Espere a resposta"
echo ""
echo "🛑 Para parar:"
echo "   docker-compose down"
echo ""
echo "📊 Para ver logs em tempo real:"
echo "   docker-compose logs --follow"
echo ""
