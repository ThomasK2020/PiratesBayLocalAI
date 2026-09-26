# Pirates Bay Local AI Coding Sandbox (`PiratesBayLocalAI`)

Environnement de prototypage et de développement sécurisé, conteneurisé et orchestré pour l'assistance par IA locale (**OpenCode CLI**, **Hermes Agent** et **Qwen Coder**).

### 🖥️ Lancement de la Démo 3D (Serveur HTTP Local - Recommandé)
Pour éviter les erreurs de gestion d'image partagée Skia (`SharedImageManager`) liées au protocole `file://` sous Linux Vulkan/ANGLE :

1. **Démarrer le serveur HTTP local (Port 8888) :**
   ```bash
   python3 -m http.server 8888 --directory $(pwd) &
   ```

2. **Lancer Chrome avec l'accélération GPU AMD OpenGL (Sans blocage Vulkan) :**
   * **Mode Application (Recommandé) :**
     ```bash
     DISPLAY=:0 google-chrome --ignore-gpu-blocklist --disable-background-networking --app="http://localhost:8888/pirates_bay_caribbean.html" &>/dev/null &
     ```
   * **Version Prototypée (`./workspace`) :**
     ```bash
     DISPLAY=:0 google-chrome --ignore-gpu-blocklist --disable-background-networking --app="http://localhost:8888/workspace/pirates_bay_caribbean.html" &>/dev/null &
     ```

> [!IMPORTANT]
> ### ↺ Gestion des Versions & Procédure de Rollback (v3.50 / v3.60)
> 
> Dans Git, chaque version étiquetée (`v2.00`, `v3.00`, `v3.50`, `v3.60`, etc.) est un **instantané immuable et permanent**. Vous pouvez consulter, tester ou effectuer un rollback vers une version spécifique à tout moment :
> 
> * **Consulter / Tester la version stable précédente (`v3.50`) :**
>   ```bash
>   git checkout v3.50
>   ```
>   *(Pour revenir à la version actuelle `v3.60` : `git checkout main`)*
> 
> * **Créer une branche de travail à partir de `v3.50` :**
>   ```bash
>   git checkout -b fix-v3.50 v3.50
>   ```
> 
> * **Effectuer un Rollback complet de la branche `main` vers la `v3.50` :**
>   ```bash
>   git reset --hard v3.50
>   git push -f origin main
>   ```

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
      "npm": "@ai-sdk/openai-compatible",
      "name": "Lemonade Local",
      "options": {
        "baseURL": "http://127.0.0.1:13305/v1"
      },
      "models": {
        "Qwen3-Coder-30B-A3B-Instruct-GGUF": {
          "name": "Qwen3-Coder-30B-A3B-Instruct-GGUF"
        }
      }
    }
  },
  "model": "lemonade/Qwen3-Coder-30B-A3B-Instruct-GGUF"
}
```

### Step 4 : Lancer la Session de Livecoding (`launch-dev.sh`)
```bash
# Lancement standard (Démarre la sandbox Docker, le serveur HTTP :8888 et ouvre Chrome GPU automatiquement) :
./launch-dev.sh

# Lancement avec configuration et démarrage de session Hermes Agent :
./launch-dev.sh --hermes

# Lancement sans interface graphique Chrome (mode headless) :
./launch-dev.sh --no-chrome
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
