# OpenCode & Hermes Agent Guidelines — Pirates Bay Coding Sandbox

## Contexte & Précisions Techniques
- Environnement de test et de dev sécurisé conteneurisé (Python 3.11, Node.js 20, Git).
- Exécution isolée dans le volume `/app/workspace`.
- Utilisation recommandée avec le modèle LLM **Qwen Coder** (`Qwen3-Coder-30B-A3B-Instruct-GGUF` via Lemonade/vLLM).

## Consignes pour l'Agent :
1. Écrire le code de prototypage et de développement uniquement dans `./workspace`.
2. Ajouter des tests automatisés avec `pytest` dans `./workspace` pour valider chaque nouvelle fonctionnalité.
3. Exécuter le conteneur via Docker Compose avec bridage cgroups (4 Go RAM max) pour préserver la mémoire système du serveur d'inférence LLM.
