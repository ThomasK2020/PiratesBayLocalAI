# HowTo Check and Launch Project — Pirates Bay Local AI

[🇬🇧 English Version](HOWTO_CHECK_AND_LAUNCH.en.md) | [🇫🇷 Version Française](HOWTO_CHECK_AND_LAUNCH.fr.md)

Complete guide to verify the local environment and deploy the **Pirates Bay Local AI** project from scratch on any Linux workstation.

---

## 📋 1. Local Environment Pre-checks

Run the following checks before starting:

### A. LLM Inference Engine (Lemonade / vLLM)
```bash
# Check Lemonade server status and Qwen Coder model presence
curl -s http://localhost:13305/v1/models | grep -i "Qwen"
```
*Expected output: Presence of model `Qwen3-Coder-30B-A3B-Instruct-GGUF`.*

### B. Containerization (Docker & Compose)
```bash
docker info && docker compose version
```
*Expected output: Active Docker daemon and Compose v2 available.*

### C. AI Agent Tools (OpenCode CLI & Hermes)
```bash
opencode --version && hermes --version
```

---

## 🌐 2. Use Case 1: Launch Web Application (UI View)

To deploy and display the web application directly in a browser:

1. **Clone the project:**
   ```bash
   git clone https://github.com/ThomasK2020/PiratesBayLocalAI.git
   cd PiratesBayLocalAI
   ```

2. **Start local web server:**
   ```bash
   python3 -m http.server 8080
   ```

3. **Access application:**
   Open `http://localhost:8080/pirates_bay_caribbean.html` in Chrome or Firefox.

---

## 🤖 3. Use Case 2: Live-Coding Demo with Neutral Hermes

To run an AI development demo without impacting your personal Hermes session or memory:

### Step 1: Start Docker Sandbox (4GB RAM Cgroups Limit)
```bash
cd PiratesBayLocalAI
docker compose up -d
```

### Step 2: Configure OpenCode CLI (`~/.config/opencode/config.json`)
```json
{
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
```

### Step 3: Start a Neutral Hermes Session (Demo Profile)
```bash
# Launch under a fresh profile with no personal history or keys
hermes --profile demo
```
*Alternative using OpenCode CLI directly:*
```bash
opencode
```

### Step 4: Demo Prompt
Give the instruction to the agent:
> *"Read `AGENTS.md`. Prototype and test your changes exclusively inside `./workspace`."*
