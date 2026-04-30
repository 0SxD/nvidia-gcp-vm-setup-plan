# 00 -- Plan Overview

## Goal

Stand up an end-to-end environment for using NVIDIA's open-source AI ecosystem (NeMo, NIM, TensorRT-LLM, Triton, RAPIDS, BioNeMo, Modulus, Riva, Isaac Sim, etc.) on Google Cloud Platform (GCP), plus a fallback path for local Windows-WSL2 use without hardware upgrades.

## Two-track delivery

### Track A: GCP Cloud (primary)
A GCP Compute Engine VM running the **NVIDIA Deep Learning VM image** (`deeplearning-platform-release` image project, Ubuntu 22.04 / 24.04 + NVIDIA driver 580) with optional GKE for NIM microservice orchestration.

- Use `--accelerator="type=...,count=N"` to attach NVIDIA GPUs (L4 for inference, A100/H100 for training).
- Use `--metadata="install-nvidia-driver=True"` to auto-install driver on first boot.
- Add **NVIDIA Container Toolkit** for Docker GPU passthrough.
- Add **NGC CLI** to pull NIM containers from `nvcr.io`.
- Source: [Google Cloud -- Create a Deep Learning VM instance from the command line](https://cloud.google.com/deep-learning-vm/docs/cli) and [NVIDIA NGC on GCP guide](https://docs.nvidia.com/ngc/ngc-deploy-public-cloud/ngc-gcp/index.html).

### Track B: Local Windows + WSL2 (fallback, no hardware upgrade)
**NVIDIA AI Workbench** does NOT require a GPU to install or use. It supports remote-only mode where you author locations and execute on a remote GPU host. Locally you can:
- Author projects, edit code, manage envs
- Use NGC catalog playground at `build.nvidia.com` (cloud-hosted endpoints)
- Run CPU-friendly NVIDIA tools (NeMo Guardrails, parts of NeMo for ASR/TTS configuration, RAPIDS cuDF.pandas pure-pandas mode)
- Develop and TEST containers locally; execute against remote GPU host or NIM endpoints
- Source: [NVIDIA AI Workbench Installation FAQ](https://docs.nvidia.com/ai-workbench/user-guide/latest/reference/faqs/installation-faq.html) and [Windows installation reference](https://docs.nvidia.com/ai-workbench/user-guide/latest/installation/windows.html).

## Why both tracks

- **Track A** gives full performance and full feature surface (real NIM container inference, full NeMo training, Triton serving). Cost per day depends on GPU type but scales from ~$0.50/hr (L4) up to ~$10/hr (H100). See `08_COST_AND_REGION_GUIDE.md`.
- **Track B** lets Sage develop, debug containers, and consume NVIDIA-hosted endpoints (build.nvidia.com) for free / pay-per-token without spinning up a GPU VM. Useful for prototype + cost-discipline.

The plan stages BOTH so Sage can flip between them based on what they are doing.

## What this folder does NOT do

- Does NOT execute any `gcloud compute instances create` (would incur charges)
- Does NOT pull NIM containers (requires NGC API key + GPU host)
- Does NOT spend any money against billing
- Does NOT modify any production GCP project

Everything here is plan + research + scripts ready to execute. Sage runs the actual setup after reviewing the open-questions doc (`09_OPEN_QUESTIONS.md`) and approving billing.

## Off-shelf-first compliance

Per `02_system_protocol.md` 143_protocol_a: every component cited is a published NVIDIA open-source repo, an official Google Cloud documentation page, or a vetted community tool (yt-dlp, youtube-transcript-api). No custom code is proposed beyond a minimal startup-script.sh that wires the vendored pieces together.

## Order of operations (when Sage approves)

1. Verify GCP billing is enabled and target project is selected (`09_OPEN_QUESTIONS.md` Q1)
2. Verify GPU quota in target region (`08_COST_AND_REGION_GUIDE.md`)
3. Create NGC API key at `ngc.nvidia.com` (free) -- needed for NIM containers
4. (Optional) Stand up local Track B first with NVIDIA AI Workbench to learn the surface
5. Run `scripts/create_vm.sh` to spin up the Track A VM (parameterized; start with cheapest L4)
6. SSH in, run `nvidia-smi` to verify driver
7. Pull a small NIM container (e.g. `nvcr.io/nim/meta/llama-3.1-8b-instruct`) and verify inference
8. Iterate from there per use case (training -> A100, robotics -> Isaac Sim, etc.)

## What to read next

`01_NVIDIA_OFFERINGS_CATALOG.md` -- the full menu of NVIDIA tools we will be able to access.
