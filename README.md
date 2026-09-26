# Pirates Bay Local AI Coding Sandbox (`PiratesBayLocalAI`)

Environnement de prototypage et de développement sécurisé, conteneurisé et orchestré pour l'assistance par IA locale (**OpenCode CLI**, **Hermes Agent** et **Qwen Coder**).

### 🖥️ Lancement de la Démo 3D (Serveur HTTP Local - Recommandé)
Pour éviter les erreurs de gestion d'image partagée Skia (`SharedImageManager`) liées au protocole `file://` sous Linux Vulkan/ANGLE :

1. **Démarrer le serveur HTTP local (Port 8888) :**
   ```bash
   python3 -m http.server 8888 --directory $(pwd) &
   ```

2. **Lancer Chrome avec l'accélération GPU AMD Vulkan :**
   * **Mode Application (Recommandé) :**
     ```bash
     DISPLAY=:0 google-chrome --ozone-platform=x11 --ignore-gpu-blocklist --enable-features=Vulkan,DefaultANGLEVulkan --use-gl=angle --use-angle=vulkan --app="http://localhost:8888/pirates_bay_caribbean.html" &
     ```
   * **Version Prototypée (`./workspace`) :**
     ```bash
     DISPLAY=:0 google-chrome --ozone-platform=x11 --ignore-gpu-blocklist --enable-features=Vulkan,DefaultANGLEVulkan --use-gl=angle --use-angle=vulkan --app="http://localhost:8888/workspace/pirates_bay_caribbean.html" &
     ```

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
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "lemonade": {
      "npm": "@ai-sdk/openai",
      "options": {
        "baseURL": "http://127.0.0.1:13305/v1",
        "apiKey": "lemonade"
      },
      "models": {
        "Qwen3-Coder-30B-A3B-Instruct-GGUF": {
          "name": "Qwen3-Coder-30B-A3B-Instruct-GGUF"
        }
      },
      "name": "Lemonade Local"
    }
  },
  "model": "lemonade/Qwen3-Coder-30B-A3B-Instruct-GGUF"
}
```

### Step 4 : Lancer la Session de Livecoding (`launch-dev.sh`)
```bash
# Lancement interactif (choix entre profil Démo neutre ou profil Perso) :
./launch-dev.sh

# Lancement direct en Démo avec ouverture 3D GPU AMD dans Chrome :
./launch-dev.sh --demo --chrome
```

---

## 📂 Structure du Répertoire

```text
PiratesBayLocalAI/
├── README.md                  <- Guide d'installation et documentation
├── check-environment.sh       <- Script de vérification de l'environnement système
├── node-agent.sh              <- Démon / Agent d'auto-réparation & pilotage distant
├── StatementOfWork/
│   └── SOW_BUOY_PHYSICS.md    <- Cahier des charges technico-fonctionnel (Physique Bouée)
├── documentation/
│   ├── HOWTO_CHECK_AND_LAUNCH.md  <- Guide pas à pas d'installation & démo (FR / EN)
│   ├── Hermes-OpenCode-Lemonade.md<- Architecture Hybride (Gemini Brain + Qwen Code)
│   └── Troubleshooting-errors.md  <- Guide de diagnostic & résolution des erreurs IA
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
