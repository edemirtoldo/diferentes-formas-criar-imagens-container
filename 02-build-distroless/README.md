# 🐳 Build com Chainguard Python Distroless

Neste exemplo, usamos imagens **Chainguard Python** (distroless), que contêm apenas os pacotes necessários para rodar a aplicação, reduzindo vulnerabilidades e camadas desnecessárias.

## 🗂 Estrutura

02-build-distroless/
├── Dockerfile
├── src/
│ ├── app.py
│ └── requirements.txt
└── README.md

## Projeto

Este diretório demonstra como empacotar uma aplicação Flask utilizando uma imagem Chainguard Python distroless para maior segurança e menor tamanho.

## Estrutura

```
.
├── Dockerfile
└── src
    ├── app.py
    └── requirements.txt
```

- **Dockerfile**: Processo de construção da imagem Chainguard distroless.
- **src/app.py**: Código principal da aplicação Flask.
- **src/requirements.txt**: Dependências Python.

## Como construir e executar

1. **Construir a imagem Docker:**

   ```bash
   docker build -t app-distroless .
   ```

2. **Executar o container:**

   ```bash
   docker run -p 5000:5000 app-distroless
   ```

3. **Acessar a aplicação:**

   Abra o navegador e acesse [http://localhost:5000](http://localhost:5000).

## Como analisar a imagem com Trivy

Se você já tem o Trivy instalado no seu Linux, pode analisar a imagem Docker para encontrar vulnerabilidades:

```bash
trivy image app-distroless
```

Para exibir apenas vulnerabilidades críticas:

```bash
trivy image --severity CRITICAL app-distroless
```

## Observações

- O Dockerfile utiliza duas etapas: uma com a imagem `cgr.dev/chainguard/python:latest-dev` para instalar dependências e outra com `cgr.dev/chainguard/python:latest` para gerar a imagem final distroless.
- O uso de distroless reduz a superfície de ataque e o tamanho da imagem.
- Certifique-se de que `requirements.txt` contém todas as dependências necessárias.

## Licença

Este projeto é apenas um exemplo educacional.
