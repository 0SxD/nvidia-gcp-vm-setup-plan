# NVIDIA GPU Stack -- Update and Verification Guide

**Date:** 2026-04-30

## Cadence Summary

| Component | Check Frequency | Update Frequency | Priority |
|---|---|---|---|
| Deep Learning VM image | Monthly | Monthly (recreate VM) | High |
| NVIDIA driver | Monthly | Quarterly | Medium |
| Container Toolkit | Monthly | Quarterly | Medium |
| NIM container tags | Weekly | Bi-weekly | High |
| NeMo Framework | Monthly | Monthly | Medium |
| TensorRT-LLM | Monthly | Quarterly stable | Medium |
| Triton Inference Server | Monthly | Quarterly | Medium |
| RAPIDS | Monthly | Quarterly | Low |
| AI Workbench | Monthly | as available | Low |
| gcloud CLI | Monthly | Bi-weekly | Low |

## 1. Deep Learning VM Image Family

- **Source:** [Google Cloud Deep Learning VM Docs](https://docs.cloud.google.com/deep-learning-vm/docs)
- **Listing:** [Console marketplace](https://console.cloud.google.com/marketplace/product/click-to-deploy/deeplearning)
- **Update behavior:** image-family aliases (e.g., `common-cu129-ubuntu-2404-nvidia-580`) auto-pull the latest version at instance creation. Existing instances do NOT auto-update.
- **Verify on running instance:**
```bash
gcloud compute instances describe MY_VM --zone=ZONE \
  --format='value(disks[0].source)'
```

## 2. NVIDIA Driver

- **Source:** [CUDA driver downloads](https://developer.nvidia.com/cuda-downloads)
- **Compatibility:** [CUDA compatibility](https://docs.nvidia.com/deploy/cuda-compatibility/index.html)
- **Verify:** `nvidia-smi` -- driver shown top-right.

## 3. NVIDIA Container Toolkit

- **GitHub releases:** https://github.com/NVIDIA/nvidia-container-toolkit/releases
- **Verify:** `nvidia-ctk --version`

## 4. NIM Container Tags

- **Source:** [NGC catalog](https://catalog.ngc.nvidia.com/)
- **Verify a model image:**
```bash
docker pull nvcr.io/nim/<vendor>/<model>:latest
docker inspect nvcr.io/nim/<vendor>/<model>:latest --format='{{json .Config.Labels}}'
```
- Tag with date suffix (e.g., `:v20260430`) in production for reproducibility.

## 5. NeMo Framework

- **GitHub releases:** https://github.com/NVIDIA-NeMo/NeMo/releases
- **Verify:** `python -c "import nemo; print(nemo.__version__)"` or `pip show nemo-toolkit`.

## 6. TensorRT-LLM

- **GitHub releases:** https://github.com/NVIDIA/TensorRT-LLM/releases
- **Verify:** `python -c "import tensorrt_llm; print(tensorrt_llm.__version__)"`

## 7. Triton Inference Server

- **GitHub releases:** https://github.com/triton-inference-server/server/releases
- **Verify in container:** `docker run --rm nvcr.io/nvidia/tritonserver:<tag> tritonserver --version`

## 8. RAPIDS (cuDF, cuML)

- **Releases:** https://github.com/rapidsai/rapids
- **Containers:** [NGC RAPIDS](https://catalog.ngc.nvidia.com/) (search "rapids")
- **Verify:** `python -c "import cudf, cuml; print(cudf.__version__, cuml.__version__)"`

## 9. AI Workbench Desktop App

- **Page:** [NVIDIA AI Workbench](https://www.nvidia.com/en-us/ai-data-science/ai-workbench/)
- **Verify:** Help -> About AI Workbench
- **Update:** Help -> Check for Updates (auto-check on launch)

## 10. gcloud CLI

- **Releases:** https://github.com/google-cloud-sdk/google-cloud-sdk/releases
- **Verify:** `gcloud --version`
- **Update:** `gcloud components update`

## Audit Script (drop on a GPU host, run monthly)

```bash
#!/bin/bash
echo "=== NVIDIA GPU Stack Audit $(date) ==="
echo "Driver: $(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null || echo 'no GPU')"
echo "CUDA cap: $(nvidia-smi --query-gpu=compute_cap --format=csv,noheader 2>/dev/null || echo 'no GPU')"
echo "nvidia-ctk: $(nvidia-ctk --version 2>/dev/null || echo 'not installed')"
echo "gcloud: $(gcloud --version 2>/dev/null | head -1 || echo 'not installed')"
echo "NeMo: $(python -c 'import nemo; print(nemo.__version__)' 2>/dev/null || echo 'not installed')"
echo "TensorRT-LLM: $(python -c 'import tensorrt_llm; print(tensorrt_llm.__version__)' 2>/dev/null || echo 'not installed')"
echo "Triton client: $(python -c 'import tritonclient; print(tritonclient.__version__)' 2>/dev/null || echo 'not installed')"
echo "cuDF: $(python -c 'import cudf; print(cudf.__version__)' 2>/dev/null || echo 'not installed')"
```

Save as `scripts/audit-gpu-stack.sh`, schedule via cron or systemd timer.

## Sources

- [Google Cloud Deep Learning VM Docs](https://docs.cloud.google.com/deep-learning-vm/docs)
- [NVIDIA CUDA Compatibility](https://docs.nvidia.com/deploy/cuda-compatibility/index.html)
- [NVIDIA CUDA Release Notes](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html)
- [nvidia-container-toolkit Releases](https://github.com/NVIDIA/nvidia-container-toolkit/releases)
- [NGC Catalog](https://catalog.ngc.nvidia.com/)
- [NeMo Releases](https://github.com/NVIDIA-NeMo/NeMo/releases)
- [TensorRT-LLM Releases](https://github.com/NVIDIA/TensorRT-LLM/releases)
- [Triton Server Releases](https://github.com/triton-inference-server/server/releases)
- [RAPIDS](https://github.com/rapidsai/rapids)
- [NVIDIA AI Workbench](https://www.nvidia.com/en-us/ai-data-science/ai-workbench/)
- [Google Cloud SDK Releases](https://github.com/google-cloud-sdk/google-cloud-sdk/releases)
