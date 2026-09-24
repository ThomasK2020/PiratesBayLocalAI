# Pirates Bay Local AI Coding Sandbox (`PiratesBayLocalAI`)

Environnement de prototypage et de développement sécurisé, conteneurisé et orchestré pour l'assistance par IA locale (**OpenCode CLI**, **Hermes Agent** et **Qwen Coder**).

---

## 🚀 Vue d'ensemble

Le projet **Pirates Bay Local AI** fournit une sandbox de développement isolée en conteneur Docker. Il permet à des agents d'assistance IA d'exécuter du code, d'effectuer des tests et de prototyper en toute sécurité sans risquer de surcharger la mémoire système ou d'impacter le serveur d'inférence LLM local.

### 🛡️ Sécurité & Isolation Mémoire
- **Limitation cgroups :** `4 Go RAM` max et `2 vCPUs` dédiés au conteneur.
- **Sécurité :** Option `no-new-privileges:true`, sans aucun montage du socket Docker hôte.
- **Préservation VRAM/RAM LLM :** L'isolation garantit que l'exécution de code par l'IA ne prive pas le moteur **Lemonade** / **vLLM** de sa mémoire pour les modèles comme `Qwen3-Coder-30B-A3B-Instruct-GGUF`.

---

## 🛠️ Architecture & Prérequis

### 1. Prérequis Système
* **OS :** Linux (Ubuntu / Debian / Arch / Fedora) avec **Docker Engine** & **Docker Compose**.
* **Moteur d'Inférence LLM Local :**
  * **Lemonade** (Port `13305`) ou **vLLM** (Port `8000`).
  * **Modèle recommandé :** `Qwen3-Coder-30B-A3B-Instruct-GGUF` (ou équivalent Qwen Coder).
* **Outillage IA :**
  * **OpenCode CLI** (`opencode`)
  * **Hermes Agent**

---

## 💻 Configuration & Installation

### Step 1 : Cloner le dépôt et vérifier l'environnement
```bash
git clone https://github.com/ThomasK2020/PiratesBayLocalAI.git
cd PiratesBayLocalAI
chmod +x check-environment.sh
./check-environment.sh
```

### Step 2 : Lancer le conteneur Sandbox Docker
```bash
docker compose up -d --build
```
Le conteneur `pirates-bay-sandbox` démarrera en arrière-plan avec le volume `./workspace` prêt à recevoir le code.

### Step 3 : Configurer OpenCode CLI (`~/.config/opencode/config.json`)
Créez ou mettez à jour votre fichier de configuration OpenCode hôte :
```json
{
  "$schema": "https://opencode.ai/config.schema.json",
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
*(Remarque : Pour un serveur vLLM distant/dédié, remplacez `baseURL` par `http://<IP_SERVEUR>:8000/v1`).*

---

## 📂 Structure du Répertoire

```text
PiratesBayLocalAI/
├── README.md                  <- Guide d'installation et documentation
├── check-environment.sh       <- Script de vérification de l'environnement système
├── AGENTS.md                  <- Consignes et règles pour OpenCode / Hermes Agent
├── Dockerfile                 <- Python 3.11-slim + Node.js 20 LTS + Git/Curl
├── docker-compose.yml         <- Configuration du conteneur sandbox bridé
├── requirements.txt           <- Dépendances Python pour le sandbox (pytest, etc.)
├── .gitignore                 <- Fichiers ignorés par Git
├── pirates_bay_caribbean.html <- Application / Interface Web
├── artifacts/                 <- Ressources graphiques (ex: piratebay3D.xcf)
├── backups/                   <- Fichiers de sauvegarde de secours
└── workspace/                 <- Répertoire de travail pour le dev & prototypage IA
```

---

## 🧪 Utilisation avec OpenCode & Hermes Agent

1. Positionnez-vous dans le projet :
   ```bash
   cd PiratesBayLocalAI
   ```
2. Lancez OpenCode CLI :
   ```bash
   opencode
   ```
3. L'agent lira automatiquement `AGENTS.md` et générera/exécutera son code de prototypage exclusivement dans le dossier `./workspace`.
