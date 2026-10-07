# HowTo Check and Launch Project — Pirates Bay Local AI

[🇬🇧 English Version](HOWTO_CHECK_AND_LAUNCH.en.md) | [🇫🇷 Version Française](HOWTO_CHECK_AND_LAUNCH.fr.md)

Guide complet pour vérifier l'environnement local et déployer le projet **Pirates Bay Local AI** depuis zéro sur n'importe quel poste Linux.

---

## 📋 1. Pré-vérification de l'Environnement Local

Exécuter le script de diagnostic automatisé :
```bash
cd PiratesBayLocalAI
./check-environment.sh
```

Ou manuellement :
* **Inférence LLM Lemonade :** `curl -s http://localhost:13305/v1/models | grep -i "Qwen"`
* **Démon Docker & Compose :** `docker info && docker compose version`
* **Outils d'Assistance IA :** `opencode --version && hermes --version`

---

## 🚀 2. Lancement Tout-en-un (`launch-dev.sh`)

Le projet fournit le script interactif `launch-dev.sh` qui configure l'environnement, démarre la sandbox Docker (4 Go RAM) et vous permet de choisir votre profil :

```bash
# Lancement standard (Docker sandbox + serveur HTTP local :8888 + Chrome GPU automatique) :
./launch-dev.sh

# Lancement avec configuration et démarrage de Hermes Agent :
./launch-dev.sh --hermes

# Lancement interactif (choix du profil Hermes Démo ou Perso) :
./launch-dev.sh --hermes -i

# Lancement sans interface graphique Chrome (headless) :
./launch-dev.sh --no-chrome
```

---

## 🌐 3. Visualisation de l'Application 3D (Rendu WebGL GPU)

Pour éviter les erreurs de gestion d'image partagée Skia (`SharedImageManager`) liées au protocole `file://` sous Linux Vulkan/ANGLE :

```bash
# 1. Démarrer le serveur HTTP local (Port 8888) :
python3 -m http.server 8888 --directory $(pwd) &

# 2. Lancer Chrome en mode autonome avec accélération GPU AMD OpenGL :
DISPLAY=:0 google-chrome --ignore-gpu-blocklist --disable-background-networking --app="http://localhost:8888/pirates_bay_caribbean.html" &>/dev/null &
```
*Dès qu'une modification de code est effectuée, rafraîchissez simplement la page (`F5`).*

> [!IMPORTANT]
> ### ↺ Versions Stables Nommées & Procédure de Rollback
> 
> Dans Git, chaque étape importante du projet est étiquetée par une version immuable :
> 
> | Tag Version | Nom & Description | Commande de Basculement |
> | :--- | :--- | :--- |
> | **`v3.50`** | 🟡 **Bouée Jaune Uni** (Flottaison Hydrodynamique Multi-points) | `git checkout v3.50` |
> | **`v3.60-stripes`** | 🔴🟡 **Bouée à Bandes Rouges & Jaunes** (Stripes SOLAS) | `git checkout v3.60-stripes` |
> | **`v3.70-sharks`** | 🦈 **Patrouille de Requins Réalistes** (0.85m + UI + Motion Design) | `git checkout v3.70-sharks` |
> 
> *Pour revenir à la branche principale active à tout moment :* `git checkout main`

---

## 🤖 4. Livecoding Piloté par Hermes & OpenCode

1. **Dans votre session Hermes :**
   Demandez à l'agent de développer une fonctionnalité.
2. **Exécution isolée dans Docker :**
   Les tests et scripts exécutés dans `./workspace` sont isolés par cgroups pour préserver la RAM/VRAM de Lemonade.
