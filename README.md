# Pirates Bay Local AI Coding Sandbox (`PiratesBayLocalAI`)

Environnement de prototypage et de développement sécurisé, conteneurisé et orchestré pour l'assistance par IA locale (**OpenCode CLI**, **Hermes Agent** et **Qwen Coder**).

> [!NOTE]
> ### 🚀 Guide de Lancement Rapide en Local
> Pour démarrer l'application 3D WebGL immédiatement sur votre machine :
> 
> ```bash
> cd PiratesBayLocalAI
> ./launch-dev.sh --demo --chrome
> ```
> *Le script `./launch-dev.sh` gère automatiquement l'activation du serveur HTTP local (Port 8888) et l'ouverture de Google Chrome avec accélération GPU AMD OpenGL.*

> [!IMPORTANT]
> ### ↺ Versions Stables Nommées & Commandes de Basculement
> 
> Dans ce dépôt Git, chaque grande étape est étiquetée par une version immuable :
> 
> | Version Tag | Désignation & Description | Commande de Basculement |
> | :--- | :--- | :--- |
> | **`v3.50`** | 🟡 **Bouée Jaune Uni** (Flottaison Hydrodynamique Stable) | `git checkout v3.50` |
> | **`v3.60-stripes`** | 🔴🟡 **Bouée à Bandes Rouges & Jaunes** (Stripes SOLAS) | `git checkout v3.60-stripes` |
> | **`v3.70-sharks`** | 🦈 **Patrouille de Requins Réalistes** (Taille 0.85m + UI + Motion Design) | `git checkout v3.70-sharks` |
> 
> *Pour revenir à la branche principale active à tout moment :* `git checkout main`
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

## 💻 Configuration & Installation Rapide

### Step 1 : Cloner le dépôt
```bash
git clone https://github.com/ThomasK2020/PiratesBayLocalAI.git
cd PiratesBayLocalAI
```

### Step 2 : Lancer le conteneur Sandbox Docker (pour pytest)
```bash
docker compose up -d --build
```
*Le conteneur `pirates-bay-sandbox` s'exécute en arrière-plan avec le volume `./workspace` prêt à recevoir le code et isolé à 4 Go de RAM.*

### Step 3 : Configurer OpenCode CLI (`~/.config/opencode/config.json`)
Assurez-vous que votre instance OpenCode est reliée au moteur LLM local **Lemonade** (port `13305`) :
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

### Step 4 : Lancer l'application WebGL en local
```bash
./launch-dev.sh --demo --chrome
```
*Le script démarre automatiquement le serveur local `http://localhost:8888` et ouvre Google Chrome avec l'accélération matérielle GPU AMD OpenGL.*

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

Le projet `PiratesBayLocalAI` repose sur une **architecture hybride bi-niveau** :
- **Hermes Agent (Raisonnement & Supervision) :** Pilote la stratégie globale, analyse les cahiers des charges (SOW), formule les prompts d'ingénierie, orchestre le conteneur Docker Sandbox et gère la synchronisation Git / Obsidian Vault.
- **OpenCode CLI & Qwen Coder (Inférence Code Locale / Lemonade Port 13305) :** Exécute la génération, le patching de shaders GLSL ES 3.0 / JavaScript et la création des suites de tests unitaires `pytest` dans le volume isolé `./workspace/`.

### ⚡ 1. Prompt Type Hermes pour Piloter la Chaîne Complète

Pour exécuter un SOW de bout en bout (développement, tests sandbox, déploiement et vault Obsidian) directement depuis la discussion Hermes :

> *"Consulte AGENTS.md et le fichier StatementOfWork/<NOM_DU_SOW>.md. Transfère à OpenCode CLI via 'opencode run --auto' pour implémenter dans ./workspace/pirates_bay_caribbean.html les spécifications fonctionnelles (SF-01 à SF-0N). Crée la suite de tests ./workspace/test_<fonctionnalite>.py, valide l'exécution avec pytest dans le conteneur Docker pirates-bay-sandbox, puis synchronise les fichiers modifiés vers la racine, le dépôt Git principal et le Vault Obsidian."*

---

### 📂 2. Index des Cahiers des Charges (SOW) Disponibles

- `StatementOfWork/SOW_BUOY_PHYSICS.md` : Flottaison physique multi-points, gradients de houle $dz/dx$, tangage & roulis.
- `StatementOfWork/SOW_BUOY_RED_YELLOW_STRIPES.md` : Shading procédural GLSL à 8 secteurs alternés rouge/jaune SOLAS.
- `StatementOfWork/SOW_SHARK_NAVIGATION.md` : Patrouille d'ailerons de requins réalistes (0.85m), zone d'exclusion ($3.5\text{m}$), contrôles UI et Motion design d'arrivée/départ.
