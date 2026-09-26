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

## 🚀 Script de Lancement Tout-en-un (`launch-dev.sh`)

Le script `launch-dev.sh` permet de tout démarrer et gère le choix du profil :

```bash
# 1. Mode Démo (Profil neutre sans mémoires perso)
./launch-dev.sh --demo

# 2. Mode Perso (Profil par défaut avec données perso)
./launch-dev.sh --perso

# 3. Lancement interactif (menu de sélection)
./launch-dev.sh

# 4. Avec ouverture automatique de la page 3D dans Chrome (GPU AMD) :
./launch-dev.sh --demo --chrome
```

---

## 💡 Exemple de Consigne Livecoding pour Hermes

Une fois dans la session Hermes :
> *"Lis `AGENTS.md`. Utilise OpenCode pour générer et tester le code de la fonctionnalité X dans `./workspace`. Vérifie ensuite les tests dans le conteneur Docker."*
