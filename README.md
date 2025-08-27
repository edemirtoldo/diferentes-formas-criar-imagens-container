# 🐳 Comparativo de Builds Docker: Tradicional vs Distroless vs Melange+Apko

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)](https://flask.palletsprojects.com/)
[![Security](https://img.shields.io/badge/Security-Trivy-4B275F?style=for-the-badge&logo=aqua&logoColor=white)](https://trivy.dev/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

> **Estudo comparativo de segurança e performance** entre diferentes estratégias de containerização

Este repositório demonstra **três abordagens diferentes** para criar imagens Docker de uma aplicação Flask simples que gera senhas aleatórias, comparando **segurança, tamanho e complexidade** com análises detalhadas usando Trivy.

## 📋 Visão Geral dos Projetos

| Projeto                   | Abordagem              | Tamanho | Segurança | Complexidade |
| ------------------------- | ---------------------- | ------- | --------- | ------------ |
| **01-build-convencional** | Dockerfile tradicional | ~140MB  | ⚠️ Baixa  | 🟢 Simples   |
| **02-build-distroless**   | Chainguard Distroless  | ~64MB   | 🟡 Média  | 🟡 Moderada  |
| **03-melange**            | Melange + Apko         | ~42MB   | 🟢 Alta   | 🔴 Avançada  |

---

## 🚀 Quick Start

### Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) 20.10+ (inclui Docker Scout)
- [Trivy](https://trivy.dev/v0.65/getting-started/installation/) (para análise de segurança)
- [Docker Scout](https://docs.docker.com/scout/) (análise complementar)
- [Melange](https://github.com/chainguard-dev/melange) e [Apko](https://github.com/chainguard-dev/apko) (apenas para abordagem 03)

### Instalação Rápida das Ferramentas

```bash
# Trivy - Linux/macOS
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Trivy via package manager
brew install trivy  # macOS
apt-get install trivy  # Ubuntu/Debian

# Docker Scout (já incluído no Docker 24.0+)
docker scout --help

# Docker Scout CLI standalone (opcional)
curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s --
```

---

## 🗂 Estrutura do Repositório

```
.
├── 01-build-convencional/    # Build tradicional com Dockerfile
├── 02-build-distroless/      # Build com imagens Chainguard
├── 03-melange/               # Build com Melange + Apko
├── LICENSE
└── README.md                 # Este arquivo
```

---

## 📁 01-build-convencional

**Abordagem**: Dockerfile tradicional com imagem Python oficial

### Características

- ✅ **Simplicidade**: Dockerfile padrão, fácil de entender
- ✅ **Compatibilidade**: Funciona em qualquer ambiente Docker
- ❌ **Tamanho**: ~140MB (imagem completa do Ubuntu/Debian)
- ❌ **Segurança**: Muitos pacotes desnecessários
- ❌ **Vulnerabilidades**: Sistema operacional completo

### Estrutura

```
01-build-convencional/
├── Dockerfile              # Build tradicional
├── src/
│   ├── app.py             # Aplicação Flask
│   └── requirements.txt   # Dependências Python
└── README.md
```

### Como usar

```bash
cd 01-build-convencional
docker build -t app-convencional .
docker run -p 5000:5000 app-convencional
```

---

## 📁 02-build-distroless

**Abordagem**: Imagens Chainguard Python (distroless)

### Características

- ✅ **Segurança**: Sem shell, sem pacotes desnecessários
- ✅ **Tamanho**: ~64MB (redução de 54%)
- ✅ **Vulnerabilidades**: Muito reduzidas
- ✅ **Atualizações**: Imagens mantidas pela Chainguard
- 🟡 **Complexidade**: Requer conhecimento de distroless

### Estrutura

```
02-build-distroless/
├── Dockerfile              # Build com Chainguard
├── src/
│   ├── app.py             # Aplicação Flask
│   └── requirements.txt   # Dependências Python
└── README.md
```

### Como usar

```bash
cd 02-build-distroless
docker build -t app-distroless .
docker run -p 5000:5000 app-distroless
```

---

## 📁 03-melange

**Abordagem**: Melange + Apko (Supply Chain Security)

### Características

- ✅ **Máxima Segurança**: SBOM automático, assinatura de pacotes
- ✅ **Menor Tamanho**: ~42MB (uma única camada)
- ✅ **Reproduzível**: Builds idênticos sempre
- ✅ **Auditável**: Rastreabilidade completa
- ✅ **Performance**: Startup mais rápido
- 🔴 **Complexidade**: Requer Melange e Apko instalados

### Estrutura

```
03-melange/
├── src/
│   ├── app.py              # Aplicação Flask
│   └── requirements.txt    # Dependências Python
├── melange.yaml           # Configuração do Melange
├── apko.yaml              # Configuração do Apko
├── build-oficial.sh       # Script automatizado
└── README.md
```

### Como usar

```bash
cd 03-melange
./build-oficial.sh
# Pressione Ctrl+C para parar e limpar arquivos temporários
```

---

## 🎯 Quando Usar Cada Abordagem

### 🟢 Build Convencional

**Use quando:**

- Prototipagem rápida
- Desenvolvimento local
- Equipe iniciante em containers
- Não há requisitos rigorosos de segurança

### 🟡 Build Distroless

**Use quando:**

- Produção com requisitos de segurança
- Quer reduzir vulnerabilidades sem complexidade
- Precisa de imagens menores
- Tem experiência com containers

### 🔴 Build Melange + Apko

**Use quando:**

- Máxima segurança é crítica
- Compliance rigoroso (SBOM, assinatura)
- Aplicações de alta performance
- Supply chain security é prioridade
- Tem expertise em ferramentas Chainguard

---

## 🔒 Análise de Segurança com Trivy e Docker Scout

### Resultados do Scan de Vulnerabilidades

| Abordagem              | Total Vulnerabilidades | Críticas | Altas | Médias | Baixas | Tamanho |
| ---------------------- | ---------------------- | -------- | ----- | ------ | ------ | ------- |
| **Build Convencional** | 53                     | 0        | 2     | 0      | 51     | ~140MB  |
| **Build Distroless**   | **0** ✅               | 0        | 0     | 0      | 0      | ~64MB   |
| **Melange + Apko**     | **0** ✅               | 0        | 0     | 0      | 0      | ~42MB   |

### Detalhes - Build Convencional

**Vulnerabilidades por Categoria:**

- **Sistema Operacional (Debian 13.0)**: 51 vulnerabilidades LOW
- **Dependências Python**: 2 vulnerabilidades HIGH

**Principais Vulnerabilidades HIGH:**

- `CVE-2024-6345` - setuptools: Remote code execution via download functions
- `CVE-2025-47273` - setuptools: Path Traversal Vulnerability

### Detalhes - Build Distroless ✅

**Resultado Chainguard Distroless:**

- **Sistema Operacional (Wolfi)**: 0 vulnerabilidades
- **Dependências Python**: 0 vulnerabilidades
- **Total**: **ZERO vulnerabilidades** ✅

**Implementação Atual:**

1. **Base Chainguard**: Multi-stage com `cgr.dev/chainguard/python`
2. **Builder stage**: `cgr.dev/chainguard/python:latest-dev`
3. **Runtime stage**: `cgr.dev/chainguard/python:latest`
4. **✅ Resultado**: Segurança máxima com Wolfi base

### Detalhes - Build Melange + Apko ✅

**Resultado Excepcional:**

- **Sistema Operacional (Alpine Edge)**: 0 vulnerabilidades
- **Dependências Python**: 0 vulnerabilidades (integradas no build)
- **Total**: **ZERO vulnerabilidades encontradas**

**Por que zero vulnerabilidades?**

1. **Alpine Edge minimalista**: Base ultra-enxuta com apenas 20 pacotes
2. **Build customizado**: Melange compila apenas o necessário
3. **Sem arquivos de desenvolvimento**: Apko gera imagem final limpa
4. **Controle total**: Cada componente é explicitamente definido

### 🎯 Impacto dos Resultados

| Métrica                     | Convencional | Distroless | Melange | Melhor Resultado |
| --------------------------- | ------------ | ---------- | ------- | ---------------- |
| **Vulnerabilidades Totais** | 53           | 0          | 0       | **-100%** ✅     |
| **Vulnerabilidades HIGH**   | 2            | 0          | 0       | **-100%** ✅     |
| **Tamanho da Imagem**       | ~140MB       | ~64MB      | ~42MB   | **-70%** ✅      |
| **Pacotes do SO**           | 87           | 24         | 20      | **-77%** ✅      |

**Conclusões Finais:**

- **🏆 Empate na segurança**: Distroless e Melange eliminam 100% das vulnerabilidades
- **🎯 Chainguard é superior**: Wolfi base ultra-segura
- **📊 Ranking correto**: Distroless = Melange > Convencional
- **✅ Objetivo alcançado**: Distroless agora tem menos vulnerabilidades que convencional

**Como executar o scan:**

```bash
# Instalar Trivy (se não tiver)
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Scan da imagem convencional
trivy image app-convencional

# Scan com formato JSON para análise detalhada
trivy image --format json --output results.json app-convencional

# Scan apenas vulnerabilidades críticas e altas
trivy image --severity CRITICAL,HIGH app-convencional

# Scan da imagem distroless (confirmado: 0 vulnerabilidades)
trivy image app-distroless
```

**Recomendações Baseadas nos Resultados:**

1. **❌ Evitar build convencional** para produção (53 vulnerabilidades)
2. **✅ Usar Distroless** para facilidade + segurança (0 vulnerabilidades, 64MB)
3. **🏆 Usar Melange** para máxima otimização (0 vulnerabilidades, 42MB)
4. **Implementar scanning contínuo** no pipeline CI/CD com Trivy

### Próximos Testes

Para completar a análise comparativa, execute:

```bash
# Scan das outras abordagens
trivy image app-distroless
trivy image app-melange  # ou nome da imagem gerada pelo Apko

# Comparação lado a lado
echo "=== CONVENCIONAL ===" && trivy image --quiet app-convencional
echo "=== DISTROLESS ===" && trivy image --quiet app-distroless
echo "=== MELANGE ===" && trivy image --quiet app-melange
```

**Resultados Finais:**

- **Chainguard Distroless**: ✅ **ZERO vulnerabilidades** - Wolfi base ultra-segura
- **Melange**: ✅ **ZERO vulnerabilidades** - Alpine base ultra-segura

---

## 🛡️ Análise Complementar com Docker Scout

O **Docker Scout** oferece análises mais detalhadas e integração nativa com o ecossistema Docker, complementando perfeitamente o Trivy.

### Instalação do Docker Scout

```bash
# Docker Scout já vem integrado no Docker Desktop
# Para CLI standalone:
curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s --

# Ou via Docker:
docker scout --help
```

### Comandos de Análise

#### Análise Básica de Vulnerabilidades

```bash
# Scan básico da imagem
docker scout cves app-convencional
docker scout cves app-distroless
docker scout cves app-melange

# Scan com detalhes completos
docker scout cves --details app-convencional

# Apenas vulnerabilidades críticas e altas
docker scout cves --only-severity critical,high app-convencional
```

#### Comparação Entre Imagens

```bash
# Comparar duas imagens diretamente
docker scout compare app-convencional --to app-distroless

# Comparar com imagem base
docker scout compare app-convencional --to python:3.11-slim

# Ver diferenças em formato JSON
docker scout compare app-convencional --to app-distroless --format json
```

#### Análise de Recomendações

```bash
# Recomendações de atualização
docker scout recommendations app-convencional

# Análise de supply chain
docker scout sbom app-convencional

# Verificar políticas de segurança
docker scout policy app-convencional
```

### Vantagens do Docker Scout vs Trivy

| Recurso                   | Docker Scout   | Trivy | Observações                           |
| ------------------------- | -------------- | ----- | ------------------------------------- |
| **Integração Docker**     | ✅ Nativa      | 🟡    | Scout integrado ao Docker CLI         |
| **Comparação de Imagens** | ✅ Avançada    | ❌    | Scout permite comparação direta       |
| **Recomendações**         | ✅ Inteligente | 🟡    | Scout sugere atualizações específicas |
| **SBOM Generation**       | ✅ Completo    | ✅    | Ambos geram SBOM detalhado            |
| **Base de Dados**         | Docker         | Multi | Scout usa dados do Docker Hub         |
| **Performance**           | 🟡 Moderada    | ✅    | Trivy é mais rápido                   |
| **Formato de Saída**      | JSON/Texto     | Multi | Trivy tem mais formatos               |

### Exemplo de Análise Completa

```bash
#!/bin/bash
# Script de análise completa com Docker Scout

echo "🔍 Análise Docker Scout - Comparativo de Segurança"
echo "=================================================="

# Build das imagens (se necessário)
echo "📦 Construindo imagens..."
cd 01-build-convencional && docker build -t app-convencional . && cd ..
cd 02-build-distroless && docker build -t app-distroless . && cd ..

echo ""
echo "🛡️ Análise de Vulnerabilidades:"
echo "--------------------------------"

# Análise individual
echo "📊 App Convencional:"
docker scout cves --only-severity critical,high app-convencional

echo ""
echo "📊 App Distroless:"
docker scout cves --only-severity critical,high app-distroless

echo ""
echo "🔄 Comparação Direta:"
echo "--------------------"
docker scout compare app-convencional --to app-distroless

echo ""
echo "💡 Recomendações:"
echo "----------------"
docker scout recommendations app-convencional
```

### Integração com CI/CD

```yaml
# Exemplo para GitHub Actions
name: Docker Scout Security Scan

on: [push, pull_request]

jobs:
  scout-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build image
        run: docker build -t ${{ github.repository }}:${{ github.sha }} .

      - name: Docker Scout scan
        uses: docker/scout-action@v1
        with:
          command: cves
          image: ${{ github.repository }}:${{ github.sha }}
          only-severities: critical,high
          exit-code: true
```

### Resultados Esperados

Com base nos testes com Trivy, esperamos que o Docker Scout confirme:

| Imagem               | Vulnerabilidades Scout | Recomendações                 |
| -------------------- | ---------------------- | ----------------------------- |
| **app-convencional** | ~50+ vulnerabilidades  | Migrar para imagem distroless |
| **app-distroless**   | 0-2 vulnerabilidades   | Manter atualizada             |
| **app-melange**      | 0 vulnerabilidades     | Configuração ideal ✅         |

### Comandos de Teste Rápido

```bash
# Teste rápido de todas as imagens
for image in app-convencional app-distroless app-melange; do
  echo "=== Analisando $image ==="
  docker scout cves --only-severity critical,high $image
  echo ""
done

# Comparação em cadeia
docker scout compare app-convencional --to app-distroless --to app-melange
```

---

## 📦 Exemplos Prontos para Uso

### Script de Análise de Segurança Completa

Execute o script `security-analysis.sh` para análise completa com Trivy e Docker Scout:

```bash
# Tornar executável e executar
chmod +x security-analysis.sh
./security-analysis.sh
```

### Script de Comparação Automática

Execute o script `compare-all.sh` para testar todas as abordagens automaticamente:

```bash
# Tornar executável e executar
chmod +x compare-all.sh
./compare-all.sh
```

### Comandos Individuais

Para comparar todas as três abordagens manualmente:

```bash
# 1. Build Convencional
cd 01-build-convencional && docker build -t app-convencional . && cd ..

# 2. Build Distroless
cd 02-build-distroless && docker build -t app-distroless . && cd ..

# 3. Build Melange
cd 03-melange && ./build-oficial.sh
# (Pressione Ctrl+C após testar)

# Comparar tamanhos
docker images | grep app-
```

---

## 📚 Recursos Adicionais

### Ferramentas de Segurança

- [Trivy Documentation](https://trivy.dev/)
- [Docker Scout Documentation](https://docs.docker.com/scout/)
- [Docker Scout CLI](https://github.com/docker/scout-cli)

### Tecnologias Utilizadas

- [Documentação Chainguard](https://edu.chainguard.dev/)
- [Melange Documentation](https://github.com/chainguard-dev/melange)
- [Apko Documentation](https://github.com/chainguard-dev/apko)
- [Distroless Best Practices](https://github.com/GoogleContainerTools/distroless)

### Scripts de Automação

- `security-analysis.sh` - Análise completa com Trivy e Docker Scout
- `compare-all.sh` - Comparação automatizada das três abordagens

---

## 🛠️ Desenvolvimento

### Estrutura de Arquivos

```
.
├── 01-build-convencional/
│   ├── Dockerfile              # Build tradicional
│   ├── src/
│   │   ├── app.py             # Aplicação Flask
│   │   └── requirements.txt   # Dependências
│   └── README.md              # Documentação específica
├── 02-build-distroless/
│   ├── Dockerfile              # Build Chainguard
│   └── src/                   # Mesma aplicação
├── 03-melange/
│   ├── melange.yaml           # Configuração Melange
│   ├── apko.yaml              # Configuração Apko
│   ├── build-oficial.sh       # Script de build
│   └── src/                   # Mesma aplicação
├── compare-all.sh             # Script de comparação
└── README.md                  # Este arquivo
```

### Testando Modificações

1. **Modificar a aplicação**: Edite `src/app.py` em qualquer diretório
2. **Rebuild**: Execute `docker build -t <tag> .` no diretório
3. **Testar**: `docker run -p 5000:5000 <tag>`
4. **Analisar**: `trivy image <tag>`

### Adicionando Nova Abordagem

1. Crie um novo diretório `04-nova-abordagem/`
2. Adicione Dockerfile e documentação
3. Atualize `compare-all.sh`
4. Documente no README principal

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. **Fork** o repositório
2. **Crie** uma branch para sua feature (`git checkout -b feature/nova-abordagem`)
3. **Commit** suas mudanças (`git commit -am 'Adiciona nova abordagem X'`)
4. **Push** para a branch (`git push origin feature/nova-abordagem`)
5. **Abra** um Pull Request

### Tipos de Contribuições

- 🐛 **Bug fixes** em Dockerfiles
- 📚 **Melhorias na documentação**
- 🔒 **Novas análises de segurança**
- 🚀 **Novas abordagens de build**
- 📊 **Benchmarks e comparações**
