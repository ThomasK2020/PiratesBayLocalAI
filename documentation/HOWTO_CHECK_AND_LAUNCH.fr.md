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

Pour éviter les erreurs de gestion d'image partagée Skia (`SharedImageManager`) liées au protocole `file://` sous Linux Vulkan/ANGLE :

```bash
# 1. Démarrer le serveur HTTP local (Port 8888) :
python3 -m http.server 8888 --directory $(pwd) &

# 2. Lancer Chrome en mode autonome avec accélération GPU AMD OpenGL :
DISPLAY=:0 google-chrome --ignore-gpu-blocklist --disable-background-networking --app="http://localhost:8888/pirates_bay_caribbean.html" &>/dev/null &
```
*Dès qu'une modification de code est effectuée, rafraîchissez simplement la page (`F5`).*

> [!IMPORTANT]
> ### ↺ Gestion des Versions & Procédure de Rollback (`v2.00` / `v3.00`)
> 
> Dans Git, chaque version étiquetée (`v2.00`, `v3.00`, etc.) est un **instantané immuable et permanent**. Vous pouvez consulter, reprendre ou effectuer un rollback vers une version spécifique à tout moment :
> 
> * **Consulter / Tester une version antérieure (ex: `v2.00`) :**
>   ```bash
>   git checkout v2.00
>   ```
> * **Créer une branche de travail à partir d'une version antérieure :**
>   ```bash
>   git checkout -b reprise-v2 v2.00
>   ```
> * **Effectuer un Rollback complet de la branche `main` vers la `v2.00` :**
>   ```bash
>   git reset --hard v2.00
>   git push -f origin main
>   ```

---

## 🤖 4. Livecoding Piloté par Hermes & OpenCode

1. **Dans votre session Hermes :**
   Demandez à l'agent de développer une fonctionnalité.
2. **Exécution isolée dans Docker :**
   Les tests et scripts exécutés dans `./workspace` sont isolés par cgroups pour préserver la RAM/VRAM de Lemonade.
