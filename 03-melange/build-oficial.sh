#!/bin/bash

set -e

echo "🚀 Build seguindo documentação oficial do Melange..."

# Limpar builds anteriores
rm -rf packages app-melange.tar

# 1. Gerar chave de assinatura (seguindo documentação)
echo "🔑 Gerando chave de assinatura..."
if [ ! -f melange.rsa ]; then
    melange keygen
fi

# 2. Build do pacote com Melange (seguindo documentação)
echo "📦 Build do pacote com Melange..."
melange build melange.yaml --arch $(uname -m) --signing-key melange.rsa

echo "✅ Build do Melange concluído!"

# 3. Build da imagem final com Apko (usando chave pública)
echo "🐳 Build da imagem com Apko..."
apko build apko.yaml app-melange:latest app-melange.tar --keyring-append melange.rsa.pub

echo "✅ Build da imagem final concluído!"

# 4. Carregar a imagem no Docker
echo "📥 Carregando imagem no Docker..."
docker load < app-melange.tar

echo "✅ Imagem carregada no Docker!"

# 5. Verificar se a imagem foi criada
echo "📋 Imagens disponíveis:"
docker images | grep app-melange

echo ""
echo "🎉 Imagem criada com sucesso usando Melange + Apko!"
echo "📦 Esta imagem segue exatamente a documentação oficial!"
echo ""

# Função para limpeza automática quando o script for interrompido
cleanup() {
    echo ""
    echo "🛑 Container interrompido!"
    echo "🧹 Limpando arquivos temporários..."
    rm -f sbom-*.spdx.json
    rm -f melange.rsa melange.rsa.pub
    rm -f app-melange.tar
    echo "✅ Arquivos temporários removidos!"
    exit 0
}

# Configurar trap para capturar Ctrl+C
trap cleanup SIGINT SIGTERM

echo "🐳 Executando aplicação..."
echo "🌐 Acesse: http://localhost:5000"
echo "🔑 Gerar senha: http://localhost:5000/senha"
echo "⚠️  Pressione Ctrl+C para parar o container e limpar arquivos temporários"
echo ""

# Executar o container (Apko usa 'amd64' em vez de 'x86_64')
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    DOCKER_ARCH="amd64"
else
    DOCKER_ARCH="$ARCH"
fi

docker run -p 5000:5000 app-melange:latest-$DOCKER_ARCH