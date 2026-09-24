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
# Lancement interactif (menu de sélection Démo / Perso) :
./launch-dev.sh

# Lancement direct en mode Démo (profil neutre sans données perso) :
./launch-dev.sh --demo

# Lancement direct en mode Personnel (données, mémoires et skills perso) :
./launch-dev.sh --perso

# Avec ouverture automatique de la 3D dans Google Chrome (Accélération GPU AMD) :
./launch-dev.sh --demo --chrome
```

---

## 🌐 3. Visualisation de l'Application 3D (Rendu WebGL GPU)

Pour ouvrir et visualiser la scène 3D du galion pirate avec accélération GPU AMD native :
```bash
google-chrome --ozone-platform=x11 --ignore-gpu-blocklist --enable-features=Vulkan,DefaultANGLEVulkan --use-gl=angle --use-angle=vulkan pirates_bay_caribbean.html
```
*Dès qu'une modification de code est effectuée, rafraîchissez simplement la page (`F5`).*

---

## 🤖 4. Livecoding Piloté par Hermes & OpenCode

1. **Dans votre session Hermes :**
   Demandez à l'agent de développer une fonctionnalité.
2. **Exécution isolée dans Docker :**
   Les tests et scripts exécutés dans `./workspace` sont isolés par cgroups pour préserver la RAM/VRAM de Lemonade.
