#!/usr/bin/env bash
# audit-gpu-stack.sh -- print versions of NVIDIA GPU stack components.
# Run monthly. Save output to a private repo or notes file.

echo "=== NVIDIA GPU Stack Audit $(date) ==="
echo ""

echo "Driver:        $(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null || echo 'no GPU')"
echo "CUDA cap:      $(nvidia-smi --query-gpu=compute_cap --format=csv,noheader 2>/dev/null || echo 'no GPU')"
echo "nvidia-ctk:    $(nvidia-ctk --version 2>/dev/null | head -1 || echo 'not installed')"
echo "Docker:        $(docker --version 2>/dev/null || echo 'not installed')"
echo "gcloud:        $(gcloud --version 2>/dev/null | head -1 || echo 'not installed')"
echo ""

echo "Python pkgs:"
for pkg in nemo-toolkit tensorrt-llm tritonclient cudf cuml youtube-transcript-api yt-dlp; do
  ver=$(python -c "import ${pkg//-/_}; print(${pkg//-/_}.__version__)" 2>/dev/null || echo "not installed")
  printf "  %-25s %s\n" "$pkg" "$ver"
done

echo ""
echo "Latest releases (verify against installed):"
echo "  https://github.com/NVIDIA-NeMo/NeMo/releases/latest"
echo "  https://github.com/NVIDIA/TensorRT-LLM/releases/latest"
echo "  https://github.com/triton-inference-server/server/releases/latest"
echo "  https://github.com/NVIDIA/nvidia-container-toolkit/releases/latest"
echo "  https://github.com/jdepoix/youtube-transcript-api/releases/latest"
echo "  https://github.com/yt-dlp/yt-dlp/releases/latest"
