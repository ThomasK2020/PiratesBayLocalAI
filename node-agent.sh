#!/usr/bin/env bash
# ==============================================================================
# PiratesBayLocalAI — Node Remote Health Agent & Self-Healing Daemon
# ==============================================================================

set -u

NODE_STATUS_FILE="/tmp/pirates_bay_node_status.json"
LEMONADE_URL="${LEMONADE_URL:-http://localhost:13305/v1/models}"

# Function: Generate Health Report
get_health_json() {
    local docker_ok=false
    local lemonade_ok=false
    local model_ok=false
    local opencode_config_ok=false

    docker info &>/dev/null && docker_ok=true
    curl -s "$LEMONADE_URL" &>/dev/null && lemonade_ok=true
    curl -s "$LEMONADE_URL" 2>/dev/null | grep -iq "Qwen" && model_ok=true
    [ -f "$HOME/.config/opencode/config.json" ] && opencode_config_ok=true

    cat << EOF
{
  "hostname": "$(hostname)",
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "docker_daemon": $docker_ok,
  "lemonade_server": $lemonade_ok,
  "qwen_model_loaded": $model_ok,
  "opencode_config": $opencode_config_ok
}
EOF
}

# Function: Auto-Fix Identified Errors
auto_fix() {
    echo "=== Auto-Healing Process Started on $(hostname) ==="
    
    # Fix 1: Docker
    if ! docker info &>/dev/null; then
        echo "[FIX] Starting Docker service..."
        sudo systemctl enable --now docker 2>/dev/null || true
    fi

    # Fix 2: OpenCode Config
    if [ ! -f "$HOME/.config/opencode/config.json" ]; then
        echo "[FIX] Creating missing ~/.config/opencode/config.json..."
        mkdir -p "$HOME/.config/opencode"
        cat << 'EOF_OC' > "$HOME/.config/opencode/config.json"
{
  "$schema": "https://opencode.ai/config.schema.json",
  "provider": "openai",
  "options": {
    "baseURL": "http://localhost:13305/v1",
    "apiKey": "lemonade",
    "model": "Qwen3-Coder-30B-A3B-Instruct-GGUF"
  },
  "execution": {
    "approval": "auto",
    "timeout": 300
  }
}
EOF_OC
    fi

    # Fix 3: Lemonade Server
    if ! curl -s "$LEMONADE_URL" &>/dev/null; then
        echo "[FIX] Restarting Lemonade service..."
        sudo systemctl restart lemonade.service 2>/dev/null || true
    fi

    echo "=== Auto-Healing Process Complete ==="
}

# CLI Arguments Handling
case "${1:-status}" in
    --status|status)
        get_health_json
        ;;
    --fix|fix)
        auto_fix
        ;;
    --daemon|daemon)
        echo "Starting Node Agent Daemon..."
        while true; do
            get_health_json > "$NODE_STATUS_FILE"
            sleep 30
        done
        ;;
    *)
        echo "Usage: $0 [--status | --fix | --daemon]"
        exit 1
        ;;
esac
