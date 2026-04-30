#!/usr/bin/env bash
# create_vm.sh -- create a GCP Compute Engine VM with an NVIDIA GPU
#
# Usage:
#   ./create_vm.sh L4    # cheapest, inference / RAG (default)
#   ./create_vm.sh A100  # fine-tuning
#   ./create_vm.sh H100  # training
#
# Reads optional env vars:
#   PROJECT_ID  -- GCP project id (required if not set in gcloud config)
#   ZONE        -- default us-central1-a
#   VM_NAME     -- default sage-nvidia-<gpu>-<timestamp>
#   DISK_SIZE   -- default 100GB
#   USE_SPOT    -- "true" for spot/preemptible, "false" for on-demand. Default false.
#
# Verify:
#   gcloud compute ssh "$VM_NAME" --zone="$ZONE" --command "nvidia-smi"

set -euo pipefail

GPU_TYPE="${1:-L4}"
ZONE="${ZONE:-us-central1-a}"
DISK_SIZE="${DISK_SIZE:-100GB}"
USE_SPOT="${USE_SPOT:-false}"

VM_NAME="${VM_NAME:-sage-nvidia-$(echo "$GPU_TYPE" | tr '[:upper:]' '[:lower:]')-$(date +%Y%m%d-%H%M%S)}"

case "$GPU_TYPE" in
  L4)
    MACHINE_TYPE="g2-standard-8"
    ACCEL="type=nvidia-l4,count=1"
    ;;
  A100)
    MACHINE_TYPE="a2-highgpu-1g"
    ACCEL="type=nvidia-a100-40gb,count=1"
    ;;
  H100)
    MACHINE_TYPE="a3-highgpu-1g"
    ACCEL="type=nvidia-h100-80gb,count=1"
    ;;
  *)
    echo "Unknown GPU type: $GPU_TYPE. Choose L4, A100, or H100." >&2
    exit 2
    ;;
esac

EXTRA_ARGS=()
if [ "$USE_SPOT" = "true" ]; then
  EXTRA_ARGS+=( "--provisioning-model=SPOT" )
fi

echo "Creating $VM_NAME in $ZONE with $GPU_TYPE GPU..."
gcloud compute instances create "$VM_NAME" \
  --zone="$ZONE" \
  --machine-type="$MACHINE_TYPE" \
  --image-family="common-cu129-ubuntu-2404-nvidia-580" \
  --image-project="deeplearning-platform-release" \
  --accelerator="$ACCEL" \
  --maintenance-policy=TERMINATE \
  --boot-disk-size="$DISK_SIZE" \
  --metadata="install-nvidia-driver=True" \
  "${EXTRA_ARGS[@]}"

echo ""
echo "VM created. Waiting for boot + driver install..."
sleep 60

echo ""
echo "Verifying GPU driver..."
gcloud compute ssh "$VM_NAME" --zone="$ZONE" --command "nvidia-smi" || {
  echo "WARN: nvidia-smi failed. Driver install may need more time. Try again in 2 min."
  exit 1
}

echo ""
echo "VM $VM_NAME is ready."
echo "SSH:    gcloud compute ssh $VM_NAME --zone=$ZONE"
echo "Stop:   gcloud compute instances stop $VM_NAME --zone=$ZONE"
echo "Delete: gcloud compute instances delete $VM_NAME --zone=$ZONE"
