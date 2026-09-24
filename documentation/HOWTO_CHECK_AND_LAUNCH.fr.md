# HowTo Check and Launch Project — Pirates Bay Local AI

[🇬🇧 English Version](HOWTO_CHECK_AND_LAUNCH.en.md) | [🇫🇷 Version Française](HOWTO_CHECK_AND_LAUNCH.fr.md)

Guide complet pour vérifier l'environnement local et déployer le projet **Pirates Bay Local AI** depuis zéro sur n'importe quel poste Linux.

---

## 📋 1. Pré-vérification de l'Environnement Local

Exécuter les requêtes de contrôle avant de démarrer :

### A. Moteur d'Inférence LLM (Lemonade / vLLM)
```bash
# Vérification du serveur Lemonade et de la présence du modèle Qwen Coder
curl -s http://localhost:13305/v1/models | grep -i "Qwen"
```
*Résultat attendu : Présence du modèle `Qwen3-Coder-30B-A3B-Instruct-GGUF`.*

### B. Conteneurisation (Docker & Compose)
```bash
docker info && docker compose version
```
*Résultat attendu : Démon Docker actif et Compose v2 disponible.*

### C. Outillage d'Assistance IA (OpenCode CLI & Hermes)
```bash
opencode --version && hermes --version
```

---

## 🌐 2. Cas d'Usage 1 : Lancer l'Application Web (Visuel)

Pour déployer et afficher directement l'application dans un navigateur :

1. **Récupérer le projet :**
   ```bash
   git clone https://github.com/ThomasK2020/PiratesBayLocalAI.git
   cd PiratesBayLocalAI
   ```

2. **Démarrer le serveur Web local :**
   ```bash
   python3 -m http.server 8080
   ```

3. **Accéder à l'application :**
   Ouvrir `http://localhost:8080/pirates_bay_caribbean.html` dans Chrome ou Firefox.

---

## 🤖 3. Cas d'Usage 2 : Live-Coding Démo avec Hermes Neutre

Pour animer une démo de développement IA sans impacter votre session Hermes ni votre mémoire perso :

### Step 1 : Lancer la Sandbox Docker (Isolation Mémoire 4 Go)
```bash
cd PiratesBayLocalAI
docker compose up -d
```

### Step 2 : Configurer OpenCode CLI (`~/.config/opencode/config.json`)
```json
{
  "provider": "openai",
  "options": {
    "baseURL": "http://localhost:13305/v1",
    "apiKey": "lemonade",
    "model": "Qwen3-Coder-30B-A3B-Instruct-GGUF"
  },
  "execution": {
    "approval": "auto",
    "timeout": 300
  }
}
```

### Step 3 : Démarrer une Session Hermes Neutre (Profil Démo)
```bash
# Lancement sous un profil vierge d'historique et de clés perso
hermes --profile demo
```
*Alternative via OpenCode CLI direct :*
```bash
opencode
```

### Step 4 : Consigne de Démo
Indiquer à l'agent :
> *"Consulte `AGENTS.md`. Prototype et teste tes modifications exclusivement dans le dossier `./workspace`."*
