# HowTo Check and Launch Project — Pirates Bay Local AI

[🇬🇧 English Version](HOWTO_CHECK_AND_LAUNCH.en.md) | [🇫🇷 Version Française](HOWTO_CHECK_AND_LAUNCH.fr.md)

Comprehensive guide to verify the local environment and deploy **Pirates Bay Local AI** from scratch on any Linux workstation.

---

## 📋 1. System Pre-Check

Run the automated diagnostic check:
```bash
cd PiratesBayLocalAI
./check-environment.sh
```

Or manually verify:
* **Lemonade LLM Inference :** `curl -s http://localhost:13305/v1/models | grep -i "Qwen"`
* **Docker Daemon & Compose :** `docker info && docker compose version`
* **AI Tooling :** `opencode --version && hermes --version`

---

## 🚀 2. All-in-One Launcher (`launch-dev.sh`)

The repository includes `launch-dev.sh` to configure the environment, start the Docker sandbox (4 GB RAM limit), and let you select your Hermes profile:

```bash
# Interactive mode (Demo / Personal profile menu):
./launch-dev.sh

# Direct Demo mode (clean profile, no personal memories/data):
./launch-dev.sh --demo

# Direct Personal mode (full personal memories and skills):
./launch-dev.sh --perso

# Open 3D scene in Google Chrome with AMD GPU hardware acceleration:
./launch-dev.sh --demo --chrome
```

---

## 🌐 3. Visual 3D Demo (WebGL & GPU Acceleration)

Open and render the 3D pirate galleon with native AMD GPU acceleration:
```bash
google-chrome --ozone-platform=x11 --ignore-gpu-blocklist --enable-features=Vulkan,DefaultANGLEVulkan --use-gl=angle --use-angle=vulkan pirates_bay_caribbean.html
```
*Whenever code changes are made, hit `F5` in Chrome to reload instantly.*

---

## 🤖 4. Livecoding Driven by Hermes & OpenCode

1. **In Hermes Agent:**
   Direct the agent to implement or test features.
2. **Isolated Docker Execution:**
   Scripts and tests in `./workspace` run inside the container with cgroups protection, ensuring Lemonade's RAM/VRAM is preserved.
