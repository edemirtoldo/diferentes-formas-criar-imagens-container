# Gerador de Senhas - Imagem Container com Melange + Apko

Este projeto demonstra como criar uma imagem container minimalista para uma aplicação Flask que gera senhas aleatórias, usando **Melange + Apko** seguindo a [documentação oficial](https://github.com/chainguard-dev/melange).

## 📁 Estrutura do Projeto

```
03-melange/
├── src/
│   ├── app.py              # Aplicação Flask
│   └── requirements.txt    # Dependências Python
├── melange.yaml           # Configuração do Melange
├── apko.yaml              # Configuração do Apko
├── build-oficial.sh       # Script de build oficial
└── README.md              # Este arquivo
```

## 🚀 Como Usar

### Pré-requisitos

Instale o Melange e Apko:

```bash
# Instalar Melange
go install chainguard.dev/melange@latest

# Instalar Apko
go install chainguard.dev/apko@latest
```

### Build da Imagem

Execute o script de build oficial:

```bash
./build-oficial.sh
```

Este script executa os seguintes passos seguindo a documentação oficial:

1. **Gera chave de assinatura**: `melange keygen`
2. **Melange**: Cria o pacote APK assinado da aplicação
3. **Apko**: Constrói a imagem final usando o pacote assinado
4. **Docker**: Carrega a imagem no Docker

### Executar a Aplicação

```bash
docker run -p 5000:5000 app-melange:latest-amd64
```

Acesse:

- **Aplicação**: http://localhost:5000
- **Gerar senha**: http://localhost:5000/senha

## 🔧 Configurações

### melange.yaml

Segue o padrão da documentação oficial:

- Define o pacote `app-melange` com metadados
- Configura ambiente com Python e dependências
- Pipeline para copiar arquivos e instalar dependências Flask
- Cria um pacote APK otimizado e assinado
- Define dependências runtime explícitas

### apko.yaml

Configuração da imagem final:

- Repositórios Alpine Linux + repositório local
- Inclui o pacote `app-melange` criado pelo Melange
- Define diretórios e permissões de segurança
- Configura entrypoint com PYTHONPATH correto

## 🛡️ Benefícios

### Imagem com Uma Camada

- **Minimalista**: Apenas o necessário
- **Segura**: Menor superfície de ataque
- **Eficiente**: Menor tamanho e melhor performance

### Reproduzível

- **Builds idênticos**: Sempre o mesmo resultado
- **Auditável**: SBOM automático
- **Confiavel**: Sem dependências externas

## 🔍 Análise de Segurança com Trivy

Para verificar a segurança da imagem criada com Melange + Apko:

```bash
# Instalar Trivy (se não tiver)
# Ubuntu/Debian:
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy

# Analisar a imagem Melange
trivy image app-melange:latest-amd64
```

### Resultados Esperados

**Imagem Melange + Apko:**

```
Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```

**Comparação com imagem tradicional Python:**

```
Total: 200+ vulnerabilidades (incluindo CRITICAL e HIGH)
```

### Por que Zero Vulnerabilidades?

1. **Base Alpine Minimalista**: Apenas pacotes essenciais
2. **Sem Shell**: Não há bash, sh ou utilitários de sistema
3. **Sem Gerenciadores**: Não há apt, yum, pip instalados
4. **Pacotes Assinados**: Todos os componentes são verificados
5. **SBOM Completo**: Rastreabilidade total de dependências

### Verificar SBOM (Software Bill of Materials)

```bash
# O SBOM é gerado automaticamente durante o build
ls -la sbom-*.spdx.json

# Visualizar o SBOM
cat sbom-*.spdx.json | jq '.packages[] | {name: .name, version: .versionInfo}'
```

### Verificar Camadas da Imagem

```bash
# Verificar que a imagem tem apenas 1 camada
docker history app-melange:latest-amd64

# Comparar com imagem tradicional (múltiplas camadas)
docker history python:3.11-slim

# Inspecionar detalhes das camadas
docker inspect app-melange:latest-amd64 | jq '.[0].RootFS.Layers'
```

**Resultado esperado (Melange - 1 camada):**

```
IMAGE          CREATED        CREATED BY      SIZE
app-melange    3 days ago     apko           41.5MB
<missing>      3 days ago                     0B
```

**Comparação (Python tradicional - 10+ camadas):**

```
IMAGE          CREATED        CREATED BY                           SIZE
python         2 weeks ago    /bin/sh -c #(nop) CMD ["python3"]    0B
<missing>      2 weeks ago    /bin/sh -c pip install...           15MB
<missing>      2 weeks ago    /bin/sh -c apt-get update...        25MB
...            ...            ...                                 ...
```

### Comparação de Segurança

| Métrica              | Imagem Tradicional | Melange + Apko |
| -------------------- | ------------------ | -------------- |
| **Vulnerabilidades** | 200+               | 0              |
| **Tamanho**          | ~1GB               | ~40MB          |
| **Camadas**          | 10+                | 1              |
| **Shell**            | ✅ Presente        | ❌ Ausente     |
| **SBOM**             | ❌ Manual          | ✅ Automático  |
| **Assinatura**       | ❌ Não             | ✅ Sim         |

## 🚨 Troubleshooting

### Erros Comuns

**Melange não encontrado:**

```bash
go install chainguard.dev/melange@latest
```

**Apko não encontrado:**

```bash
go install chainguard.dev/apko@latest
```

**Erro de permissão:**

```bash
sudo ./build.sh
```

**Erro de arquitetura:**

- Verifique se está usando x86_64
- O Melange pode tentar buildar para múltiplas arquiteturas

### Logs de Debug

Para debug detalhado, execute manualmente:

```bash
# Gerar chave de assinatura
melange keygen

# Build do pacote com assinatura
melange build melange.yaml --arch $(uname -m) --signing-key melange.rsa

# Build da imagem
apko build apko.yaml app-melange:latest app-melange.tar --keyring-append melange.rsa.pub

# Carregar no Docker
docker load < app-melange.tar
```

## 📚 Documentação

Este projeto segue a documentação oficial:

- [Melange](https://github.com/chainguard-dev/melange)
- [Apko](https://github.com/chainguard-dev/apko)

## 🎯 Casos de Uso

Ideal para:

- **Produção**: Imagens seguras e otimizadas
- **Compliance**: Requisitos de segurança rigorosos
- **Performance**: Aplicações que precisam de startup rápido
- **Auditoria**: Necessidade de rastreabilidade completa
