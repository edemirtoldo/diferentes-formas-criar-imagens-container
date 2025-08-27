#!/bin/bash

# Script de Análise de Segurança Completa
# Utiliza Trivy e Docker Scout para análise comparativa

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir cabeçalhos
print_header() {
    echo -e "\n${BLUE}$1${NC}"
    echo "$(printf '=%.0s' {1..50})"
}

# Função para verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar pré-requisitos
print_header "🔍 Verificando Pré-requisitos"

if ! command_exists docker; then
    echo -e "${RED}❌ Docker não encontrado${NC}"
    exit 1
fi

if ! command_exists trivy; then
    echo -e "${YELLOW}⚠️  Trivy não encontrado. Instalando...${NC}"
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
fi

# Verificar Docker Scout
if ! docker scout --help >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Docker Scout não disponível. Certifique-se de ter Docker 24.0+${NC}"
    SCOUT_AVAILABLE=false
else
    SCOUT_AVAILABLE=true
fi

echo -e "${GREEN}✅ Pré-requisitos verificados${NC}"

# Array de imagens para testar
IMAGES=("app-convencional" "app-distroless" "app-melange")

# Construir imagens se necessário
print_header "📦 Construindo Imagens"

echo "🔨 Construindo app-convencional..."
cd 01-build-convencional && docker build -t app-convencional . && cd ..

echo "🔨 Construindo app-distroless..."
cd 02-build-distroless && docker build -t app-distroless . && cd ..

echo -e "${YELLOW}ℹ️  Para app-melange, execute: cd 03-melange && ./build-oficial.sh${NC}"

# Análise com Trivy
print_header "🛡️ Análise de Segurança com Trivy"

for image in "${IMAGES[@]}"; do
    if docker image inspect "$image" >/dev/null 2>&1; then
        echo -e "\n${YELLOW}📊 Analisando $image com Trivy:${NC}"
        
        # Contagem de vulnerabilidades
        echo "📈 Resumo de vulnerabilidades:"
        trivy image --quiet --format table "$image" | head -20
        
        # Apenas críticas e altas
        echo -e "\n🚨 Vulnerabilidades CRÍTICAS e ALTAS:"
        trivy image --severity CRITICAL,HIGH --quiet "$image" || echo "✅ Nenhuma vulnerabilidade crítica/alta encontrada"
        
        echo "$(printf '-%.0s' {1..50})"
    else
        echo -e "${RED}❌ Imagem $image não encontrada${NC}"
    fi
done

# Análise com Docker Scout (se disponível)
if [ "$SCOUT_AVAILABLE" = true ]; then
    print_header "🔍 Análise de Segurança com Docker Scout"
    
    for image in "${IMAGES[@]}"; do
        if docker image inspect "$image" >/dev/null 2>&1; then
            echo -e "\n${YELLOW}📊 Analisando $image com Docker Scout:${NC}"
            
            # Análise básica
            echo "📈 Vulnerabilidades encontradas:"
            docker scout cves --only-severity critical,high "$image" || echo "✅ Nenhuma vulnerabilidade crítica/alta encontrada"
            
            echo "$(printf '-%.0s' {1..50})"
        fi
    done
    
    # Comparações diretas
    print_header "🔄 Comparações Docker Scout"
    
    if docker image inspect "app-convencional" >/dev/null 2>&1 && docker image inspect "app-distroless" >/dev/null 2>&1; then
        echo -e "\n${YELLOW}⚖️  Comparando app-convencional vs app-distroless:${NC}"
        docker scout compare app-convencional --to app-distroless
    fi
    
    if docker image inspect "app-distroless" >/dev/null 2>&1 && docker image inspect "app-melange" >/dev/null 2>&1; then
        echo -e "\n${YELLOW}⚖️  Comparando app-distroless vs app-melange:${NC}"
        docker scout compare app-distroless --to app-melange
    fi
fi

# Resumo final
print_header "📋 Resumo Final"

echo "📊 Tamanhos das imagens:"
docker images | grep -E "(app-convencional|app-distroless|app-melange)" | sort

echo -e "\n💡 Recomendações:"
echo "• Use app-convencional apenas para desenvolvimento/prototipagem"
echo "• Use app-distroless para produção com boa segurança"
echo "• Use app-melange para máxima segurança e compliance"

echo -e "\n🔧 Para análises detalhadas:"
echo "• Trivy JSON: trivy image --format json --output results.json <image>"
echo "• Scout SBOM: docker scout sbom <image>"
echo "• Scout recomendações: docker scout recommendations <image>"

print_header "✅ Análise Completa Finalizada"