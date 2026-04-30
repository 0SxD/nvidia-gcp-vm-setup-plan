#!/usr/bin/env bash
# setup_nim.sh -- run on the GPU VM after first SSH
# Installs Docker + NVIDIA Container Toolkit, logs into NGC, pulls a small NIM.
#
# Required env:
#   NGC_API_KEY -- generate at https://ngc.nvidia.com/account/api-keys
#
# Optional env:
#   NIM_IMAGE   -- default nvcr.io/nim/meta/llama-3.1-8b-instruct:latest
#   NIM_PORT    -- default 8000

set -euo pipefail

if [ -z "${NGC_API_KEY:-}" ]; then
  echo "ERROR: NGC_API_KEY env var is required." >&2
  echo "Generate at https://ngc.nvidia.com/account/api-keys and export it." >&2
  exit 2
fi

NIM_IMAGE="${NIM_IMAGE:-nvcr.io/nim/meta/llama-3.1-8b-instruct:latest}"
NIM_PORT="${NIM_PORT:-8000}"

echo "==> Updating apt..."
sudo apt-get update -y

echo "==> Installing Docker..."
sudo apt-get install -y docker.io

echo "==> Installing NVIDIA Container Toolkit..."
distribution=$(. /etc/os-release; echo "$ID""$VERSION_ID")
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L "https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list" | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list >/dev/null
sudo apt-get update -y
sudo apt-get install -y nvidia-container-toolkit

echo "==> Restarting Docker..."
sudo systemctl restart docker

echo "==> Adding $USER to docker group..."
sudo usermod -aG docker "$USER"

echo "==> Logging into NGC..."
echo "$NGC_API_KEY" | sudo docker login nvcr.io --username '$oauthtoken' --password-stdin

echo "==> Pulling $NIM_IMAGE (this takes a few minutes)..."
sudo docker pull "$NIM_IMAGE"

echo "==> Starting NIM container on port $NIM_PORT..."
sudo docker run -d \
  --gpus all \
  --name nim-llm \
  -p "$NIM_PORT:8000" \
  -e NGC_API_KEY="$NGC_API_KEY" \
  "$NIM_IMAGE"

echo ""
echo "NIM container started. Wait ~30-60 seconds for model load, then test:"
echo "curl -X POST http://localhost:$NIM_PORT/v1/chat/completions \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"model\":\"meta/llama-3.1-8b-instruct\",\"messages\":[{\"role\":\"user\",\"content\":\"hello\"}]}'"
echo ""
echo "Logs: sudo docker logs -f nim-llm"
echo "Stop: sudo docker stop nim-llm && sudo docker rm nim-llm"
