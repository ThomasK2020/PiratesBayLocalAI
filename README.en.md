# Pirates Bay Local AI Coding Sandbox (`PiratesBayLocalAI`)

[🇬🇧 English Version](README.en.md) | [🇫🇷 Version Française](README.fr.md)

Secure, containerized, and orchestrated prototyping and development environment for local AI assistance (**OpenCode CLI**, **Hermes Agent**, and **Qwen Coder**).

> [!NOTE]
> ### 🚀 Local Quick Launch Guide
> To start the 3D WebGL application immediately on your local machine:
> 
> ```bash
> cd PiratesBayLocalAI
> ./launch-dev.sh --demo --chrome
> ```
> *The `./launch-dev.sh` script automatically handles starting the local HTTP server (Port 8888) and opening Google Chrome with AMD OpenGL GPU acceleration.*

> [!IMPORTANT]
> ### ↺ Named Stable Versions & Rollback Commands
> 
> In this Git repository, each major milestone is tagged with an immutable release version:
> 
> | Version Tag | Name & Description | Switch Command |
> | :--- | :--- | :--- |
> | **`v3.50`** | 🟡 **Plain Yellow Buoy** (Stable Hydrodynamic Buoyancy) | `git checkout v3.50` |
> | **`v3.60-stripes`** | 🔴🟡 **Red & Yellow Striped Buoy** (SOLAS Pattern) | `git checkout v3.60-stripes` |
> | **`v3.70-sharks`** | 🦈 **Realistic Shark Patrol** (0.85m Fin + UI + Motion Design) | `git checkout v3.70-sharks` |
> 
> *To return to the active main branch at any time:* `git checkout main`

---

## 🚀 Overview

The **Pirates Bay Local AI** project provides an isolated development sandbox in a Docker container. It allows AI assistant agents to execute code, run unit tests, and prototype features safely without risk of overloading system memory or impacting the local LLM inference server.

### 🛡️ Security & Memory Isolation
- **cgroups Limits:** `4 GB RAM` max and `2 vCPUs` dedicated to the container.
- **Security:** `no-new-privileges:true` option with no Docker socket mounted from the host.
- **LLM VRAM/RAM Preservation:** Isolation ensures AI code execution never starves the local **Lemonade** / **vLLM** inference engine of memory needed for models like `Qwen3-Coder-30B-A3B-Instruct-GGUF`.

---

## 🛠️ Architecture & Prerequisites

### 1. System Prerequisites
* **OS:** Linux (Ubuntu / Debian / Arch / Fedora) with **Docker Engine** & **Docker Compose**.
* **Local LLM Inference Engine:**
  * **Lemonade** (Port `13305`) or **vLLM** (Port `8000`).
  * **Recommended Model:** `Qwen3-Coder-30B-A3B-Instruct-GGUF` (or equivalent Qwen Coder).
* **AI Tooling:**
  * **OpenCode CLI** (`opencode`)
  * **Hermes Agent**

---

## 💻 Quick Setup & Installation

### Step 1: Clone the Repository
```bash
git clone https://github.com/ThomasK2020/PiratesBayLocalAI.git
cd PiratesBayLocalAI
```

### Step 2: Start the Sandbox Docker Container (for pytest)
```bash
docker compose up -d --build
```
*The `pirates-bay-sandbox` container runs in the background with the isolated `./workspace` volume ready to receive code with 4 GB RAM limits.*

### Step 3: Configure OpenCode CLI (`~/.config/opencode/config.json`)
Ensure your OpenCode host instance points to the local **Lemonade** LLM inference endpoint (port `13305`):
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

### Step 4: Launch the 3D WebGL Application Locally
```bash
./launch-dev.sh --demo --chrome
```
*The script automatically starts the local HTTP server `http://localhost:8888` and launches Google Chrome with hardware AMD OpenGL GPU acceleration.*

---

## 📂 Repository Structure

```text
PiratesBayLocalAI/
├── README.md                  <- Main installation guide and documentation
├── README.fr.md               <- French language version
├── README.en.md               <- English language version
├── check-environment.sh       <- System environment checker script
├── node-agent.sh              <- Self-healing daemon & remote management agent
├── StatementOfWork/
│   ├── SOW_BUOY_PHYSICS.md    <- Statement of Work (Buoy Physics)
│   ├── SOW_BUOY_RED_YELLOW_STRIPES.md <- Statement of Work (SOLAS Stripes)
│   └── SOW_SHARK_NAVIGATION.md<- Statement of Work (Shark Patrol)
├── documentation/
│   ├── HOWTO_CHECK_AND_LAUNCH.fr.md <- Step-by-step setup & demo guide (FR)
│   ├── HOWTO_CHECK_AND_LAUNCH.en.md <- Step-by-step setup & demo guide (EN)
│   ├── Hermes-OpenCode-Lemonade.md  <- Hybrid Architecture Guide (Gemini Brain + Qwen Code)
│   └── Troubleshooting-errors.md    <- AI error diagnostic & resolution guide
├── AGENTS.md                  <- Rules and instructions for OpenCode / Hermes Agent
├── Dockerfile                 <- Python 3.11-slim + Node.js 20 LTS + Git/Curl
├── docker-compose.yml         <- Sandboxed Docker container configuration
├── requirements.txt           <- Python dependencies for sandbox (pytest, etc.)
├── pirates_bay_caribbean.html <- 3D WebGL Application / User Interface
└── workspace/                 <- Working directory for AI code generation & prototyping
```

---

## 🧪 Usage with OpenCode & Hermes Agent

The `PiratesBayLocalAI` project operates on a **two-tier hybrid AI architecture**:
- **Hermes Agent (Reasoning & Supervision):** Manages high-level strategy, analyzes Statements of Work (SOW), crafts engineering prompts, orchestrates the Docker Sandbox container, and handles Git / Obsidian Vault synchronization.
- **OpenCode CLI & Qwen Coder (Local Code Inference / Lemonade Port 13305):** Executes code generation, WebGL ES 3.0 / GLSL shader patching, and creates `pytest` unit test suites inside the isolated `./workspace/` volume.

### ⚡ 1. Standard Hermes Prompt Template for End-to-End Orchestration

To execute a Statement of Work end-to-end (development, sandbox testing, deployment, and Obsidian vault update) directly from the Hermes conversation:

> *"Check AGENTS.md and the file StatementOfWork/<SOW_NAME>.md. Delegate to OpenCode CLI via 'opencode run --auto' to implement in ./workspace/pirates_bay_caribbean.html the functional specifications (SF-01 to SF-0N). Create the test suite ./workspace/test_<feature>.py, validate execution with pytest in the Docker container pirates-bay-sandbox, then synchronize modified files to root, main Git repository, and Obsidian Vault."*

---

### 📂 2. Index of Available Statements of Work (SOW)

- `StatementOfWork/SOW_BUOY_PHYSICS.md`: Multi-point hydrodynamic buoyancy, ocean wave gradients $dz/dx$, pitch & roll.
- `StatementOfWork/SOW_BUOY_RED_YELLOW_STRIPES.md`: GLSL procedural shading for 8 alternating SOLAS red/yellow buoy sectors.
- `StatementOfWork/SOW_SHARK_NAVIGATION.md`: Realistic shark fin patrol (0.85m size), exclusion zone ($3.5\text{m}$), UI controls, and arrival/departure motion design.
