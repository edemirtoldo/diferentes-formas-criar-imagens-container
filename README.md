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
- ❌ **Tamanho**: ~1GB (imagem completa do Ubuntu/Debian)
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
- ✅ **Tamanho**: ~100MB (redução de 90%)
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
- ✅ **Menor Tamanho**: ~40MB (uma única camada)
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
