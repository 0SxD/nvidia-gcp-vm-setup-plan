# 01 -- NVIDIA Open-Source AI Offerings Catalog

A curated catalog of the major NVIDIA open-source AI / data-science / agent / robotics tools, with GitHub URLs, license, and what they are for. Verified 2026-04-30.

## How to use this catalog

Each entry has:
- **Repo URL** (clone target)
- **License** (most are Apache-2.0 or BSD-3; some are NGC-licensed for containers)
- **Purpose** (1-line)
- **Notable** (key feature or use case)
- **Update channel** (where to check for releases)

For the catalog of containerized inference services, see also `build.nvidia.com` (NVIDIA-hosted endpoints; works without your own GPU) and `catalog.ngc.nvidia.com` (the NGC container registry).

---

## Foundation Model Training

| Tool | URL | License | Purpose |
|---|---|---|---|
| **NeMo Framework** | https://github.com/NVIDIA-NeMo/NeMo | Apache-2.0 | Scalable generative AI framework for LLM, multimodal, ASR, TTS |
| **Megatron-LM** | https://github.com/NVIDIA/Megatron-LM | NVIDIA Source Code | Research training of transformer models at scale |
| **NeMo-Skills** | https://github.com/NVIDIA-NeMo/Skills | Apache-2.0 | Composable skill library for NeMo agents |
| **NeMo-Retriever** | https://github.com/NVIDIA/NeMo-Retriever | Apache-2.0 | Retrieval pipeline for RAG (also nv-ingest) |
| **NeMo-Guardrails** | https://github.com/NVIDIA/NeMo-Guardrails | Apache-2.0 | Programmable guardrails for LLM applications. **CPU-friendly.** |
| **TransformerEngine** | https://github.com/NVIDIA/TransformerEngine | Apache-2.0 | FP8 / mixed-precision transformer training library |

## Inference / Serving

| Tool | URL | License | Purpose |
|---|---|---|---|
| **TensorRT-LLM** | https://github.com/NVIDIA/TensorRT-LLM | Apache-2.0 | LLM-optimized inference on NVIDIA GPUs |
| **Triton Inference Server** | https://github.com/triton-inference-server/server | BSD-3 | Multi-framework inference server |
| **NIM (Inference Microservices)** | https://github.com/NVIDIA/nim-deploy and https://github.com/NVIDIA/nim-anywhere | NGC | Optimized prebuilt containers for popular models |
| **TensorRT** | https://github.com/NVIDIA/TensorRT | Apache-2.0 | DL inference compiler / optimizer (general, not LLM-specific) |
| **GenerativeAIExamples** | https://github.com/NVIDIA/GenerativeAIExamples | Apache-2.0 | Reference workflows: RAG, chatbot, NIM playgrounds |

## Models / Weights

| Tool | URL | Purpose |
|---|---|---|
| **Nemotron** | https://developer.nvidia.com/nemotron | Open-weight family with reasoning specializations |
| **Cosmos** | https://github.com/NVIDIA/Cosmos | Open world-foundation models (video / physical AI) |
| **Megatron-NeMo Megatron Bridge** | https://github.com/NVIDIA-NeMo/Megatron-Bridge | Bridge for Megatron checkpoints |

## Data Science / RAPIDS

| Tool | URL | License | Purpose |
|---|---|---|---|
| **cuDF** | https://github.com/rapidsai/cudf | Apache-2.0 | GPU DataFrames (pandas-compatible) |
| **cuML** | https://github.com/rapidsai/cuml | Apache-2.0 | GPU machine-learning algorithms (scikit-learn-compatible) |
| **cuGraph** | https://github.com/rapidsai/cugraph | Apache-2.0 | GPU graph analytics |
| **cuVS** | https://github.com/rapidsai/cuvs | Apache-2.0 | GPU vector search |
| **cuOpt** | https://github.com/NVIDIA/cuopt | Apache-2.0 | GPU-accelerated decision optimization |
| **cuopt-examples** | https://github.com/NVIDIA/cuopt-examples | Apache-2.0 | Decision optimization example notebooks |

## Speech / Audio / Vision

| Tool | URL | Purpose |
|---|---|---|
| **Riva** | https://github.com/nvidia-riva and https://docs.nvidia.com/riva/ | Speech AI: ASR, TTS, NMT |
| **NeMo ASR/TTS** | (within NeMo repo) | Speech models in NeMo framework |
| **DeepStream** | https://github.com/NVIDIA-AI-IOT/deepstream_python_apps | Video analytics pipeline |

## Robotics

| Tool | URL | Purpose |
|---|---|---|
| **Isaac Sim** | https://github.com/NVIDIA-Omniverse/IsaacGymEnvs and https://docs.nvidia.com/isaac-sim/ | Robotics simulation |
| **Isaac Lab** | https://github.com/isaac-sim/IsaacLab | Modular robot learning environments |
| **Holoscan** | https://github.com/nvidia-holoscan/holoscan-sdk | Real-time sensor processing (medical / edge) |
| **OSMO** | https://github.com/NVIDIA/OSMO | Developer-first platform for Physical AI workloads |

## Physics / Science

| Tool | URL | Purpose |
|---|---|---|
| **Modulus / PhysicsNeMo** | https://github.com/NVIDIA/physicsnemo | Physics-informed ML framework |
| **CUDA-Q** | https://github.com/NVIDIA/cuda-quantum | Quantum-classical programming model |
| **BioNeMo** | https://github.com/NVIDIA/BioNeMo-Framework | Biology / chemistry foundation models |

## Recommenders

| Tool | URL | Purpose |
|---|---|---|
| **Merlin** | https://github.com/NVIDIA-Merlin | End-to-end recommenders (NVTabular, Models, Systems) |

## Medical Imaging

| Tool | URL | Purpose |
|---|---|---|
| **MONAI** | https://github.com/Project-MONAI/MONAI | PyTorch medical-imaging library (NVIDIA-led) |
| **Clara Holoscan** | https://github.com/nvidia-holoscan | Healthcare imaging real-time AI |

## Agents / Autonomous

| Tool | URL | Purpose |
|---|---|---|
| **OpenShell** | https://github.com/NVIDIA/OpenShell | Safe private runtime for autonomous AI agents |
| **NVIDIA skills** | https://github.com/NVIDIA/skills | AI-agent skills published by NVIDIA |
| **NemoClaw** | https://github.com/NVIDIA/NemoClaw | Run OpenClaw inside NVIDIA OpenShell |

## Infrastructure / Container / GPU

| Tool | URL | Purpose |
|---|---|---|
| **NVIDIA Container Toolkit** | https://github.com/NVIDIA/nvidia-container-toolkit | Docker / Podman GPU passthrough |
| **open-gpu-kernel-modules** | https://github.com/NVIDIA/open-gpu-kernel-modules | Open-source NVIDIA Linux kernel module |
| **nvidia-docker (legacy)** | https://github.com/NVIDIA/nvidia-docker | Predecessor to Container Toolkit |
| **AIStore** | https://github.com/NVIDIA/aistore | Scalable storage for AI applications |
| **CCCL (CUDA Core Compute Libraries)** | https://github.com/NVIDIA/cccl | Thrust + CUB + libcu++ |
| **NCCL** | https://github.com/NVIDIA/nccl | Collective communications for multi-GPU |

## NVIDIA AI Workbench (local-first)

| Tool | URL | Purpose |
|---|---|---|
| **AI Workbench** | https://docs.nvidia.com/ai-workbench/ | Local desktop app for AI dev (does NOT require local GPU) |
| **NIM Anywhere** | https://github.com/NVIDIA/nim-anywhere | Workbench + NIM reference workflow (works with or without GPU) |

## NVIDIA-hosted endpoints (no local GPU needed)

- **build.nvidia.com** -- free / pay-per-token endpoints for popular NIM models (test before self-host)
- **catalog.ngc.nvidia.com** -- container registry for NIM, models, helm charts

## Cloud catalog reference

The NVIDIA AI Enterprise / NIM offering is curated at:
- https://docs.nvidia.com/nim/index.html (top-level NIM docs)
- https://www.nvidia.com/en-us/ai-data-science/products/nim-microservices/ (product page)
- https://developer.nvidia.com/nim (developer portal)

## How to keep this catalog fresh

`07_UPDATE_AND_VERIFY.md` lists the per-tool update channels (GitHub releases, NGC catalog, blog feeds). Default cadence: refresh quarterly or when starting a new workstream.
