from flask import Flask, jsonify
import secrets
import string

app = Flask(__name__)

@app.route("/")
def home():
    return "<h1>🚀 Gerador de Senhas</h1><p>Acesse /senha para gerar uma senha aleatória.</p>"

@app.route("/senha")
def gerar_senha():
    caracteres = string.ascii_letters + string.digits + string.punctuation
    senha = ''.join(secrets.choice(caracteres) for i in range(12))
    return jsonify({"senha_gerada": senha})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
