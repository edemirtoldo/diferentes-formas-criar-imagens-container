#!/bin/bash

# Script para comparar todas as abordagens de build
# Uso: ./compare-all.sh

set -e

echo "🐳 Comparativo de Builds Docker - Análise Completa"
echo "=================================================="

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para medir tempo
measure_time() {
    start_time=$(date +%s)
    "$@"
    end_time=$(date +%s)
    echo "⏱️  Tempo: $((end_time - start_time))s"
}

# Função para build e análise
build_and_analyze() {
    local dir=$1
    local name=$2
    local tag=$3
    
    echo -e "\n${BLUE}📁 Processando: $name${NC}"
    echo "----------------------------------------"
    
    cd "$dir"
    
    # Build
    echo "🔨 Building imagem..."
    measure_time docker build -t "$tag" .
    
    # Tamanho
    size=$(docker images "$tag" --format "table {{.Size}}" | tail -n 1)
    echo "📏 Tamanho: $size"
    
    # Scan de segurança
    echo "🔍 Executando scan de segurança..."
    trivy image --quiet "$tag" | head -20
    
    cd ..
}

# Limpar imagens antigas
echo "🧹 Limpando imagens antigas..."
docker rmi -f app-convencional app-distroless app-melange 2>/dev/null || true

# Build 1: Convencional
build_and_analyze "01-build-convencional" "Build Convencional" "app-convencional"

# Build 2: Distroless
build_and_analyze "02-build-distroless" "Build Distroless" "app-distroless"

# Build 3: Melange (se disponível)
if command -v melange &> /dev/null && command -v apko &> /dev/null; then
    build_and_analyze "03-melange" "Build Melange" "app-melange"
else
    echo -e "\n${YELLOW}⚠️  Melange/Apko não encontrados. Pulando build 03.${NC}"
    echo "   Instale: https://github.com/chainguard-dev/melange"
fi

# Comparação final
echo -e "\n${GREEN}📊 RESUMO COMPARATIVO${NC}"
echo "=================================================="
docker images | grep -E "(app-convencional|app-distroless|app-melange)" || echo "Nenhuma imagem encontrada"

echo -e "\n✅ Análise completa! Verifique os resultados acima."