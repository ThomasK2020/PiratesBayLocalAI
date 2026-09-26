#!/usr/bin/env bash
# ==============================================================================
# PiratesBayLocalAI — Livecoding & Agent Orchestrator Launcher
# ==============================================================================
# Architecture : Hermes Agent + OpenCode CLI + Qwen Coder (Lemonade) + Docker
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

# Default mode is DEMO (LocalAIDemo)
MODE="demo"
OPEN_CHROME=false
SKIP_DOCKER=false
INTERACTIVE=false

# 1. Parse Arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --demo)
            MODE="demo"
            shift
            ;;
        --perso)
            MODE="perso"
            shift
            ;;
        -i|--interactive)
            INTERACTIVE=true
            shift
            ;;
        --chrome)
            OPEN_CHROME=true
            shift
            ;;
        --no-docker)
            SKIP_DOCKER=true
            shift
            ;;
        -h|--help)
            echo "Usage: ./launch-dev.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --demo            Start Hermes under clean 'LocalAIDemo' profile (DEFAULT, no personal data)"
            echo "  --perso           Start Hermes under default personal profile (full memories & skills)"
            echo "  -i, --interactive Prompt interactively for profile selection"
            echo "  --chrome          Open pirates_bay_caribbean.html in Google Chrome with AMD GPU flags"
            echo "  --no-docker       Skip Docker sandbox startup"
            echo "  -h, --help        Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Run ./launch-dev.sh --help for available options."
            exit 1
            ;;
    esac
done

echo "======================================================================"
echo "🏴‍☠️  Pirates Bay Local AI — Livecoding & Agent Orchestrator"
echo "======================================================================"

# 2. Optional Interactive Selection
if [ "$INTERACTIVE" = true ]; then
    echo ""
    echo "Choisissez le profil Hermes Agent pour cette session :"
    echo "  [1] Profil DÉMO (LocalAIDemo) — Session neutre [PAR DÉFAUT]"
    echo "  [2] Profil PERSO (Default)   — Avec vos données, mémoires et compétences perso"
    echo ""
    read -r -p "Votre choix (1 ou 2) [défaut: 1]: " USER_CHOICE
    case "${USER_CHOICE}" in
        2|"perso"|"PERSO")
            MODE="perso"
            ;;
        *)
            MODE="demo"
            ;;
    esac
fi

echo "Mode actif : [Profil ${MODE^^}]"

# 3. Verify Local LLM Endpoint & OpenCode Config
echo ""
echo "[1/4] Vérification de l'environnement..."
if ! curl -s "http://localhost:13305/v1/models" >/dev/null 2>&1; then
    echo "⚠️  [ATTENTION] Lemonade n'est pas accessible sur le port 13305."
    echo "    Vérifiez que Lemonade est bien démarré ('snap start lemonade-server.daemon' ou GUI)."
else
    echo "  ✓ Inférence LLM Lemonade accessible (port 13305)."
fi

# 4. Start Docker Sandbox if requested
if [ "$SKIP_DOCKER" = false ]; then
    echo ""
    echo "[2/4] Démarrage de la sandbox Docker (bridage 4 Go RAM)..."
    if docker info >/dev/null 2>&1; then
        docker compose up -d --build
        echo "  ✓ Conteneur Docker 'pirates-bay-sandbox' actif."
    else
        echo "⚠️  [ATTENTION] Démon Docker inactif ou permissions insuffisantes. Poursuite en mode hôte."
    fi
else
    echo ""
    echo "[2/4] Démarrage Docker ignoré (--no-docker)."
fi

# 5. Open Chrome GPU if requested
if [ "$OPEN_CHROME" = true ]; then
    echo ""
    echo "[3/4] Démarrage du serveur HTTP local (Port 8888) & Lancement de Google Chrome (GPU AMD Vulkan)..."
    if ! lsof -i :8888 >/dev/null 2>&1; then
        python3 -m http.server 8888 --directory "${SCRIPT_DIR}" >/dev/null 2>&1 &
        sleep 0.5
    fi
    DISPLAY="${DISPLAY:-:0}" google-chrome --ozone-platform=x11 --ignore-gpu-blocklist --enable-features=Vulkan,DefaultANGLEVulkan --use-gl=angle --use-angle=vulkan --disable-background-networking --app="http://localhost:8888/pirates_bay_caribbean.html" >/dev/null 2>&1 &
    echo "  ✓ Google Chrome lancé en arrière-plan (http://localhost:8888/pirates_bay_caribbean.html)."
else
    echo ""
    echo "[3/4] Rendu 3D : Démarrez 'python3 -m http.server 8888' et ouvrez 'http://localhost:8888/pirates_bay_caribbean.html' dans Chrome."
fi

# 6. Profile Preparation & Hermes Launch
echo ""
echo "[4/4] Préparation du profil Hermes (${MODE})..."

if [ "$MODE" = "demo" ]; then
    DEMO_PROFILE_DIR="${HOME}/.hermes/profiles/LocalAIDemo"
    mkdir -p "${DEMO_PROFILE_DIR}"

    # Link technical skills to demo profile without copying personal memories
    if [ ! -e "${DEMO_PROFILE_DIR}/skills" ] && [ -d "${HOME}/.hermes/skills" ]; then
        ln -s "${HOME}/.hermes/skills" "${DEMO_PROFILE_DIR}/skills" 2>/dev/null || true
    fi

    # Deploy minimal demo config
    cat << 'EOF_CONFIG' > "${DEMO_PROFILE_DIR}/config.yaml"
model:
  provider: gemini
  default: gemini-2.5-flash
EOF_CONFIG

    # Copy Gemini API key if available without leaking secrets
    if [ -f "${HOME}/.hermes/.env" ] && [ ! -f "${DEMO_PROFILE_DIR}/.env" ]; then
        grep -E "^GEMINI_API_KEY=" "${HOME}/.hermes/.env" > "${DEMO_PROFILE_DIR}/.env" 2>/dev/null || true
        chmod 600 "${DEMO_PROFILE_DIR}/.env" 2>/dev/null || true
    fi

    echo "======================================================================"
    echo "🚀 Démarrage de Hermes Agent (Profil DÉMO : LocalAIDemo)..."
    echo "======================================================================"
    exec hermes --profile LocalAIDemo
else
    echo "======================================================================"
    echo "🚀 Démarrage de Hermes Agent (Profil PERSO : Default)..."
    echo "======================================================================"
    exec hermes
fi
