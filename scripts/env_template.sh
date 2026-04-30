#!/usr/bin/env bash
# env_template.sh -- copy to env.sh, fill in values, source before running other scripts.
#
# DO NOT COMMIT env.sh -- already in .gitignore.

# ---------- GCP ----------
export PROJECT_ID="your-gcp-project-id-here"
export ZONE="us-central1-a"
export REGION="us-central1"

# Set this only if you want to override the auto-generated VM name in create_vm.sh
# export VM_NAME="my-nvidia-l4"

# ---------- NVIDIA NGC ----------
# Generate at https://ngc.nvidia.com/account/api-keys -- "Personal API Key"
# Make sure "NGC Catalog" + "NIM" are in "Services Included".
export NGC_API_KEY="paste-your-key-here"

# ---------- build.nvidia.com (free hosted NIM) ----------
# Generate at https://build.nvidia.com -> Settings -> API Keys
export NVIDIA_API_KEY="paste-your-nvapi-key-here"

# ---------- Cost discipline ----------
# Use spot/preemptible for dev to save 60-91% on GPU cost.
# Risk: instance can be reclaimed at any time.
export USE_SPOT="true"

# Default GPU + disk
export GPU_TYPE="L4"
export DISK_SIZE="100GB"

# ---------- NIM image to pull ----------
# Smallest popular NIM. Swap for any model from https://catalog.ngc.nvidia.com/
export NIM_IMAGE="nvcr.io/nim/meta/llama-3.1-8b-instruct:latest"
export NIM_PORT="8000"

echo "env loaded. PROJECT_ID=$PROJECT_ID ZONE=$ZONE GPU_TYPE=$GPU_TYPE USE_SPOT=$USE_SPOT"
