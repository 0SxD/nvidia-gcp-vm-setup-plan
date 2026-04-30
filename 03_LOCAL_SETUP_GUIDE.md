# Local Without Hardware Upgrades -- NVIDIA AI on Windows 11 + WSL2

**Date:** 2026-04-30

## What Works Without a Discrete NVIDIA GPU

NVIDIA provides multiple pathways for developers to build and iterate on AI applications without owning hardware. You can develop locally using hosted endpoints or CPU-only tools, then scale to GPUs only when you reach training or sustained inference workloads.

### Free Hosted Inference -- build.nvidia.com

[build.nvidia.com](https://build.nvidia.com/) offers free OpenAI-compatible API access to over 100 models including Nemotron, Llama, Mistral, and Qwen. New accounts receive 1,000 free inference credits (request up to 5,000). No credit card required; no expiration.

All models expose the same `/v1/chat/completions` endpoint at `https://integrate.api.nvidia.com/v1`. Rate limit: 40 requests per minute.

### NVIDIA AI Workbench (Desktop App)

AI Workbench does **not require a GPU** to install or run. The Desktop App runs on Windows, macOS, or Linux. You can operate in "remote-only mode" -- using just the app to manage remote machines -- or add a local installation for native projects without GPUs.

**Reference:** [NVIDIA AI Workbench Installation Overview](https://docs.nvidia.com/ai-workbench/user-guide/latest/install/installation-overview.html)

### NIM Anywhere (CPU + Remote)

NIM Anywhere explicitly supports running with or without GPUs. On CPU-only machines, deploy lightweight components (Milvus vector DB, Redis conversation cache) locally while routing model inference to `ai.nvidia.com` hosted endpoints.

**Reference:** [NIM Anywhere GitHub](https://github.com/NVIDIA/nim-anywhere)

### NeMo Guardrails

NeMo Guardrails library runs on CPU with **1 core, 4 GB RAM** (Python 3.10+). The microservice variant requires only 500 MiB. External LLMs can be remote (build.nvidia.com) or local GPU models.

**Reference:** [NeMo Guardrails Installation Guide](https://docs.nvidia.com/nemo/guardrails/latest/getting-started/installation-guide.html)

### RAPIDS cuDF.pandas

`cuDF.pandas` automatically falls back to CPU pandas when GPU operations are unavailable or unsupported. Write standard pandas code; leverage GPU acceleration where available.

**Reference:** [cuDF pandas documentation](https://docs.rapids.ai/api/cudf/stable/cudf_pandas/)

## Windows 11 + WSL2 + Docker Desktop Setup

### Prerequisites

- Windows 11 build 21H2 or higher (check `winver`; build 22621+)
- Virtualization enabled in BIOS (Intel VT-x / AMD-V). Verify via `msinfo32` -> search "Hyper-V"

### Step-by-step

**1. Enable WSL2**

```powershell
wsl --install -d Ubuntu
```

Reboot. WSL2 is now default.

**2. Install Docker Desktop**

Download [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/). Installer auto-detects WSL2 backend. Verify with `docker run hello-world`.

**3. Install NVIDIA AI Workbench**

Download the Windows installer from [NVIDIA AI Workbench Documentation](https://docs.nvidia.com/ai-workbench/user-guide/latest/installation/windows.html).

The installer:
- Places app at `C:\Program Files\NVIDIA AI Workbench`
- Creates `NVIDIA-Workbench` WSL2 distribution
- Installs git, git-lfs, podman (if selected), NVIDIA Container Toolkit (if a host GPU + podman selected)
- Opens Desktop App after setup

Launch the app and choose "Remote Only" if no local GPU, or "Local" to initialize the local environment.

**Reference:** [AI Workbench Windows Installation FAQ](https://docs.nvidia.com/ai-workbench/user-guide/latest/reference/faqs/installation-faq.html)

## NGC Catalog Access

### Create NGC API key

1. Visit [NGC account page](https://org.ngc.nvidia.com/account/api-keys)
2. Create an account (free)
3. Generate a Personal API Key (max 8 per user)

### Docker login to nvcr.io

From WSL2:

```bash
docker login nvcr.io
```

- Username: `$oauthtoken`
- Password: paste your API key

Many NGC images are public and do not require authentication; some (Riva, Merlin) require login.

## build.nvidia.com Quickstart

```python
import openai

openai.api_key = "nvapi-YOUR_KEY"
openai.api_base = "https://integrate.api.nvidia.com/v1"

response = openai.ChatCompletion.create(
    model="meta/llama-3.1-70b-instruct",
    messages=[{"role": "user", "content": "Hello"}],
    temperature=0.5, top_p=1.0, max_tokens=1024,
)
print(response.choices[0].message.content)
```

## Decision Matrix -- Local Track B vs. GCP GPU Track A

| Task | Recommended | Why |
|------|-------------|-----|
| Fine-tune 7B LoRA | Track B (build.nvidia.com + Workbench) | Low vRAM, no GPU needed for data prep |
| Inference-only, low QPS | Track B (build.nvidia.com free credits) | Scale only as traffic grows |
| Prompt engineering, agents | Track B (local Workbench) | Iterate fast; no GPU idle cost |
| RAG pipeline, vector DB | Track B (local cuVS optional) | CPU-friendly indexing |
| LLM training from scratch | Track A (H100 / A100) | Months of GPU time |
| Production NIM container | Track A (L4, sustained) | Training done, now serve |
| Robotics / Isaac Sim | Track A only | Heavy GPU simulation |
| Merlin recommender training | Track A (L4+) | GPU-accelerated feature engineering |
| Riva speech (inference only) | Track B (hosted endpoint) | Riva container needs T4+; otherwise remote |

## Cost Discipline

- **Development:** build.nvidia.com (free tier) + local Workbench for ~90% of iteration
- **Prototype:** hosted endpoints for single-GPU inference testing
- **Production:** provision GCP GPU only after validating demand
- **Sustain:** monitor NGC / build.nvidia.com credit burn; add GCP GPU when throughput or latency demand local inference

Total local-only cost can be zero. GPUs are an optimization once product-market fit is validated.

## Sources

- [NVIDIA AI Workbench Installation Overview](https://docs.nvidia.com/ai-workbench/user-guide/latest/install/installation-overview.html)
- [NVIDIA AI Workbench Windows Installation](https://docs.nvidia.com/ai-workbench/user-guide/latest/installation/windows.html)
- [NVIDIA AI Workbench Installation FAQ](https://docs.nvidia.com/ai-workbench/user-guide/latest/reference/faqs/installation-faq.html)
- [NIM Anywhere GitHub](https://github.com/NVIDIA/nim-anywhere)
- [NeMo Guardrails Installation Guide](https://docs.nvidia.com/nemo/guardrails/latest/getting-started/installation-guide.html)
- [RAPIDS cuDF.pandas Documentation](https://docs.rapids.ai/api/cudf/stable/cudf_pandas/)
- [build.nvidia.com](https://build.nvidia.com/)
- [NGC API Key Generation](https://org.ngc.nvidia.com/account/api-keys)
- [NGC Private Registry User Guide](https://docs.nvidia.com/ngc/gpu-cloud/ngc-private-registry-user-guide/index.html)

(Sourced via Anthropic Explore subagent on 2026-04-30; flagged as billable.)
