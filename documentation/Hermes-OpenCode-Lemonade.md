# Architecture Hybride : Hermes Agent (Gemini) + OpenCode CLI (Qwen Coder Local) + Lemonade

Spécifications d'installation et de déploiement pour le schéma hybride d'assistance IA :
**Gemini** (Discussion & Brain) + **OpenCode CLI / Qwen Coder** (Génération de code local via Lemonade) + **Sandbox Docker**.

---

## 🎯 Schéma d'Architecture

```text
               ┌──────────────────────────────────────────────┐
               │    Hermes Agent (Choix: Demo ou Perso)       │
               │   Discussion & Réflexion ➔ Gemini API       │
               └──────────────────────┬───────────────────────┘
                                      │
                                (Délégation Code)
                                      ▼
               ┌──────────────────────────────────────────────┐
               │              OpenCode CLI                    │
               │    Inférence ➔ Qwen Coder (Lemonade Local)   │
               └──────────────────────┬───────────────────────┘
                                      │
                                      ▼
               ┌──────────────────────────────────────────────┐
               │     Conteneur Docker Sandbox (4 Go RAM)       │
               │       Exécution & Tests dans ./workspace     │
               └──────────────────────────────────────────────┘
```

---

## 🛠️ Spécifications & Prérequis

* **Moteur d'Inférence Local :** Lemonade (`http://localhost:13305/v1` ou `13306`)
* **Modèle LLM Code Local :** `Qwen3-Coder-30B-A3B-Instruct-GGUF`
* **Modèle Brain / Discussion :** `gemini-3.6-flash` / `gemini-3.7-flash`
* **Agent CLI :** Hermes Agent + OpenCode CLI
* **Isolation :** Choix entre Profil Démo (`LocalAIDemo`) et Profil Personnel (`default`) + Conteneur Docker `pirates-bay-sandbox`

---

## ⚙️ Procédure de Configuration Pas à Pas

### Step 1 : Configurer OpenCode CLI pour Qwen Coder Local
Fichier de configuration hôte `~/.config/opencode/config.json` :
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

### Step 2 : Gestion des Profils Hermes (Démo vs Perso)

Vous pouvez lancer Hermes dans deux modes distincts :

1. **Mode Démo (`LocalAIDemo`) — Neutre & Sans données personnelles :**
   - Aucune mémoire personnelle ni historique privé injecté.
   - Idéal pour les présentations, cours ou tests sans compromettre la vie privée.
   - Emplacement : `~/.hermes/profiles/LocalAIDemo/`

2. **Mode Perso (`Default`) — Environnement Complet :**
   - Accès direct à vos mémoires, skills personnalisés et base `state.db`.
   - Idéal pour le développement continu personnel.

---

## 🚀 1. Lancement du Projet & Visualisation Chrome GPU

Le script `launch-dev.sh` orchestre l'ensemble de l'environnement en une seule commande :

```bash
# Lancement tout-en-un par défaut (Vérification Lemonade, Docker Sandbox, Serveur HTTP :8888 et ouverture Chrome) :
./launch-dev.sh

# Lancement avec configuration et démarrage de la session Hermes Agent (profil Démo LocalAIDemo) :
./launch-dev.sh --hermes

# Lancement avec profil Hermes Personnel :
./launch-dev.sh --hermes --perso

# Lancement en mode console sans ouvrir l'interface Chrome (mode headless) :
./launch-dev.sh --no-chrome
```

**Ce qui se passe automatiquement :**
1. **Lemonade Local LLM :** Vérification de l'API OpenAI locale sur `http://localhost:13305/v1`.
2. **Sandbox Docker :** Démarrage du conteneur `pirates-bay-sandbox` (limite 4 Go RAM) montant le dossier `./workspace`.
3. **Serveur HTTP Local (Port 8888) :** Lancement en tâche de fond de `python3 -m http.server 8888` pour contourner les blocages `file://` (Skia SharedImageManager).
4. **Google Chrome GPU AMD :** Ouverture directe en mode application (`--app=http://localhost:8888/pirates_bay_caribbean.html`) avec l'accélération matérielle AMD Radeon 8060S activée.

---

## 🤖 2. S'assurer dans Hermes que l'on peut coder via OpenCode

Pour que **Hermes Agent** puisse déléguer l'écriture et le refactoring de code à **OpenCode CLI** propulsé par le modèle local **Qwen Coder** (Lemonade) :

### A. Vérification de la configuration d'OpenCode hôte
Assurez-vous que le fichier `~/.config/opencode/config.json` pointe bien vers votre instance locale de Lemonade :
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

### B. Vérification de la compétence (`skill`) OpenCode dans Hermes
Dans votre session Hermes, la compétence spécialisée `opencode` doit être disponible :
* **Vérifier le skill :** Hermes charge `skill_view(name='opencode')`.
* **Test de bon fonctionnement (Smoke Test) :**
  ```bash
  opencode run 'Respond with exactly: OPENCODE_SMOKE_OK'
  ```
  Le retour doit contenir `OPENCODE_SMOKE_OK` sans erreur de provider ou de modèle.

### C. Consignes Types pour ordonner à Hermes de coder via OpenCode
Dans le chat avec Hermes, donnez une consigne directive :
> *"Lis `AGENTS.md` et `StatementOfWork/SOW_BUOY_PHYSICS.md`. Délègue l'implémentation de la fonction d'amortissement à OpenCode dans le répertoire `./workspace` avec Qwen Coder local. Lance ensuite les tests unitaires dans le conteneur Docker `pirates-bay-sandbox` et fais-moi un rapport."*

Hermes exécutera alors en tâche de fond :
```bash
opencode run 'Implémente la physique de flottaison selon SOW_BUOY_PHYSICS.md' -f AGENTS.md
```
OpenCode produira le code en local via Qwen Coder sans saturer la VRAM, tandis que Hermes supervisera la qualité et le cycle de vie git.
