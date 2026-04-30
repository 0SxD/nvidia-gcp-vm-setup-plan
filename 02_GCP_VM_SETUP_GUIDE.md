# GCP GPU VM Setup Guide for NVIDIA Open-Source AI Tooling

**Date:** 2026-04-30
**Target:** NVIDIA NIM, NGC containers, and AI inference/training workloads on Google Cloud Platform.

## 1. Prerequisites

Before creating a GPU instance, ensure you have:

- **gcloud CLI installed:** Follow [Google Cloud's quickstart](https://cloud.google.com/sdk/docs/install).
- **Authenticated:** Run `gcloud auth login` and select your account.
- **Project selected:** Run `gcloud config set project PROJECT_ID` with your GCP project ID.
- **Billing enabled:** Verify in [Google Cloud Console](https://console.cloud.google.com/billing).
- **GPU quota requested:** Navigate to **IAM & Admin > Quotas**, search for "GPUs (all regions)" or specific GPU types (e.g., "NVIDIA L4 GPUs"), select the metric, and request an increase. GCP processes quota requests within 24--48 hours.
- **NGC API key generated:** Visit [ngc.nvidia.com](https://ngc.nvidia.com), sign in with your NVIDIA account (free), go to **Account > API Keys**, and generate a new API key. Store it securely; you'll need it for Docker authentication.

**Reference:** [Google Cloud Deep Learning VM CLI Quickstart](https://docs.cloud.google.com/deep-learning-vm/docs/cli) and [NVIDIA NGC Getting Started](https://docs.nvidia.com/ngc/ngc-deploy-public-cloud/ngc-gcp/index.html)

## 2. Choose GPU and Region

Select the GPU based on your workload:

- **NVIDIA L4 (G2 family, cheapest):** `g2-standard-8` instance. Best for inference and RAG. 24 GB GDDR6 memory per GPU. Cost-effective for production inference endpoints.
- **NVIDIA A100 40GB (A2 family):** `a2-highgpu-1g` instance. Suitable for moderate model fine-tuning and inference with larger batches.
- **NVIDIA H100 80GB SXM (A3 High/Mega family):** `a3-highgpu-1g` (1 GPU) or `a3-highgpu-8g` (8 GPUs). For serious training and large-scale fine-tuning. Requires Spot or Flex-start provisioning for instances with fewer than 8 GPUs.

**Recommended region:** `us-central1-a` or `us-west1-b` (typically best availability for L4 and A100). Check quota availability in your preferred region before proceeding.

**Reference:** [Compute Engine GPU machine types](https://docs.cloud.google.com/compute/docs/gpus) and [Accelerator-optimized instances](https://docs.cloud.google.com/compute/docs/gpus/create-gpu-vm-accelerator-optimized).

## 3. Create the VM

### L4 GPU example (recommended for inference)

```bash
export VM_NAME="nvidia-l4-instance"
export ZONE="us-central1-a"
export MACHINE_TYPE="g2-standard-8"
export DISK_SIZE="100GB"

gcloud compute instances create $VM_NAME \
  --zone=$ZONE \
  --machine-type=$MACHINE_TYPE \
  --image-family=common-cu129-ubuntu-2404-nvidia-580 \
  --image-project=deeplearning-platform-release \
  --accelerator="type=nvidia-l4,count=1" \
  --maintenance-policy=TERMINATE \
  --boot-disk-size=$DISK_SIZE \
  --metadata="install-nvidia-driver=True"
```

### A100 GPU example (for fine-tuning)

```bash
export VM_NAME="nvidia-a100-instance"
export ZONE="us-central1-a"
export MACHINE_TYPE="a2-highgpu-1g"

gcloud compute instances create $VM_NAME \
  --zone=$ZONE \
  --machine-type=$MACHINE_TYPE \
  --image-family=common-cu129-ubuntu-2404-nvidia-580 \
  --image-project=deeplearning-platform-release \
  --accelerator="type=nvidia-a100-40gb,count=1" \
  --maintenance-policy=TERMINATE \
  --boot-disk-size=100GB \
  --metadata="install-nvidia-driver=True"
```

### H100 GPU example (for training)

```bash
export VM_NAME="nvidia-h100-instance"
export ZONE="us-central1-a"
export MACHINE_TYPE="a3-highgpu-1g"

gcloud compute instances create $VM_NAME \
  --zone=$ZONE \
  --machine-type=$MACHINE_TYPE \
  --image-family=common-cu129-ubuntu-2404-nvidia-580 \
  --image-project=deeplearning-platform-release \
  --accelerator="type=nvidia-h100-80gb,count=1" \
  --provisioning-model=SPOT \
  --maintenance-policy=TERMINATE \
  --boot-disk-size=100GB \
  --metadata="install-nvidia-driver=True"
```

**Note:** The `common-cu129-ubuntu-2404-nvidia-580` image includes CUDA 12.9 and NVIDIA driver 580 pre-installed. [Image reference](https://docs.cloud.google.com/deep-learning-vm/docs/images).

## 4. First boot verification

```bash
gcloud compute ssh $VM_NAME --zone=$ZONE
nvidia-smi
nvcc --version
```

Expected: `nvidia-smi` shows GPU memory + utilization; `nvcc --version` shows CUDA 12.9.

## 5. Install NVIDIA Container Toolkit and Docker

```bash
sudo apt-get update
sudo apt-get install -y docker.io

distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker

sudo usermod -aG docker $USER
newgrp docker
```

## 6. Login to NGC registry

```bash
export NGC_API_KEY="your-ngc-api-key-here"
echo $NGC_API_KEY | docker login nvcr.io --username '$oauthtoken' --password-stdin
docker pull nvcr.io/nvidia/cuda:12.4.1-runtime-ubuntu22.04
```

## 7. Pull and run a small NIM

```bash
docker run -d \
  --gpus all \
  --name llama-3.1-8b \
  -p 8000:8000 \
  -e NGC_API_KEY=$NGC_API_KEY \
  nvcr.io/nim/meta/llama-3.1-8b-instruct:latest

docker logs llama-3.1-8b
docker ps
```

The NIM exposes an OpenAI-compatible API on port 8000.

## 8. Test the inference endpoint

```bash
curl -X POST http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta/llama-3.1-8b-instruct",
    "messages": [{"role": "user", "content": "What is the capital of France?"}],
    "temperature": 0.7,
    "max_tokens": 256
  }'
```

## 9. Optional -- Deploy NVIDIA NIM on GKE

```bash
gcloud container clusters create my-nim-cluster \
  --region us-central1 \
  --num-nodes 3 --enable-autoscaling --min-nodes 1 --max-nodes 10

gcloud container node-pools create gpu-pool \
  --cluster=my-nim-cluster --region=us-central1 \
  --machine-type=g2-standard-8 \
  --accelerator=type=nvidia-l4,count=1 \
  --num-nodes=1

# Helm install per https://github.com/NVIDIA/nim-deploy
```

See [NVIDIA NIM on GKE blog](https://cloud.google.com/blog/products/containers-kubernetes/nvidia-nims-are-available-on-gke) and [NVIDIA NIM deployment guide](https://docs.nvidia.com/nim/large-language-models/latest/deployment-guide.html).

## 10. Tear down

```bash
gcloud compute instances stop $VM_NAME --zone=$ZONE   # cheaper; preserves disk
gcloud compute instances delete $VM_NAME --zone=$ZONE # permanent
gcloud compute instances list --zone=$ZONE
```

## Sources

- [Google Cloud Deep Learning VM CLI](https://docs.cloud.google.com/deep-learning-vm/docs/cli)
- [Google Cloud Deep Learning VM Images](https://docs.cloud.google.com/deep-learning-vm/docs/images)
- [Google Cloud Compute Engine GPUs](https://docs.cloud.google.com/compute/docs/gpus)
- [Google Cloud Accelerator-Optimized Instances](https://docs.cloud.google.com/compute/docs/gpus/create-gpu-vm-accelerator-optimized)
- [NVIDIA NGC Deployment on GCP](https://docs.nvidia.com/ngc/ngc-deploy-public-cloud/ngc-gcp/index.html)
- [NVIDIA NIM Deployment Guide](https://docs.nvidia.com/nim/large-language-models/latest/deployment-guide.html)
- [NVIDIA NIM on Google Kubernetes Engine](https://cloud.google.com/blog/products/containers-kubernetes/nvidia-nims-are-available-on-gke)
- [NGC Catalog](https://catalog.ngc.nvidia.com/) (NVIDIA-maintained registry of containers, models, helm charts)
- [NGC API Key generation](https://ngc.nvidia.com)

(Sourced via Anthropic Explore subagent on 2026-04-30; flagged as billable. Future research will use OR-dispatched kimi/deepseek per Sage standing rule.)
