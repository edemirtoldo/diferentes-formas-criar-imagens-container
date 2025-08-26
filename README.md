# 🐳 Comparativo de Builds Docker: Tradicional vs Distroless vs Melange+Apko

Este repositório demonstra **três abordagens diferentes** para criar imagens Docker de uma aplicação Flask simples que gera senhas aleatórias, comparando segurança, tamanho e complexidade.

## 📋 Visão Geral dos Projetos

| Projeto                   | Abordagem              | Tamanho | Segurança | Complexidade |
| ------------------------- | ---------------------- | ------- | --------- | ------------ |
| **01-build-convencional** | Dockerfile tradicional | ~140MB  | ⚠️ Baixa  | 🟢 Simples   |
| **02-build-distroless**   | Chainguard Distroless  | ~64MB   | 🟡 Média  | 🟡 Moderada  |
| **03-melange**            | Melange + Apko         | ~42MB   | 🟢 Alta   | 🔴 Avançada  |

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
docker build -t app-tradicional .
docker run -p 5000:5000 app-tradicional
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

## 🔒 Análise de Segurança com Trivy

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

**Resultado Excepcional:**

- **Sistema Operacional (Wolfi)**: 0 vulnerabilidades
- **Dependências Python**: 0 vulnerabilidades
- **Total**: **ZERO vulnerabilidades encontradas**

**Por que zero vulnerabilidades?**

1. **Base Wolfi**: Sistema operacional minimalista da Chainguard
2. **Sem setuptools vulnerável**: Não inclui ferramentas de desenvolvimento
3. **Apenas runtime**: Somente bibliotecas essenciais para execução
4. **Atualizações constantes**: Imagens mantidas pela Chainguard

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

- **Segurança**: Distroless e Melange **eliminam 100%** das vulnerabilidades
- **Tamanho**: Melange é **30% menor** que Distroless e **70% menor** que convencional
- **Minimalismo**: Melange tem **apenas 20 pacotes** vs 87 do convencional

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

**Resultados Confirmados:**

- **Distroless**: ✅ **ZERO vulnerabilidades** - Redução de 100% comparado ao convencional
- **Melange**: ✅ **ZERO vulnerabilidades** - Menor tamanho (42MB) com máxima segurança

---

## 🚀 Testando Todas as Abordagens

Para comparar todas as três abordagens:

```bash
# 1. Build Convencional
cd 01-build-convencional && docker build -t app-tradicional . && cd ..

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

- [Documentação Chainguard](https://edu.chainguard.dev/)
- [Melange Documentation](https://github.com/chainguard-dev/melange)
- [Apko Documentation](https://github.com/chainguard-dev/apko)
- [Distroless Best Practices](https://github.com/GoogleContainerTools/distroless)

---

## 🤝 Contribuindo

Sinta-se à vontade para abrir issues ou pull requests para melhorar os exemplos!
