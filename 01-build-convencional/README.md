# Projeto: Build Convencional de Aplicação Flask com Docker

Este diretório contém um exemplo de empacotamento de uma aplicação Flask utilizando um Dockerfile convencional.

## Estrutura

```
.
├── Dockerfile
└── src
    ├── app.py
    └── requirements.txt
```

- **Dockerfile**: Define o processo de construção da imagem Docker.
- **src/app.py**: Código principal da aplicação Flask.
- **src/requirements.txt**: Lista de dependências Python.

## Como construir e executar

1. **Construir a imagem Docker:**

   ```bash
   docker build -t app-convencional .
   ```

2. **Executar o container:**

   ```bash
   docker run -p 5000:5000 app-convencional
   ```

3. **Acessar a aplicação:**

   Abra o navegador e acesse [http://localhost:5000](http://localhost:5000).

## Como analisar a imagem com Trivy

Se você já tem o Trivy instalado no seu Linux, pode analisar a imagem Docker para encontrar vulnerabilidades:

```bash
trivy image app-convencional
```

Para exibir apenas vulnerabilidades críticas:

```bash
trivy image --severity CRITICAL app-convencional
```

## Observações

- Certifique-se de que o arquivo `requirements.txt` contém todas as dependências necessárias para o funcionamento da aplicação.
- O Dockerfile utiliza a imagem oficial do Python e instala as dependências no momento do build.

## Licença

Este projeto é apenas um exemplo educacional.
