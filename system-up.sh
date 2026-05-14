#!/bin/bash
set -e

echo "🧠 AI Orchestrator SYSTEM START"

# 1. ustaw kubeconfig (k3s standard)
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# 2. sprawdź czy k3s działa
echo "🔍 Checking Kubernetes..."
kubectl get nodes >/dev/null

# 3. sprawdź czy Ollama działa
echo "🔍 Checking Ollama..."
kubectl get pods | grep ollama || echo "⚠ Ollama not ready (will be applied)"

# 4. zawsze wyrównaj stan platformy
echo "🚀 Running bootstrap reconciliation..."
bash "$(dirname "$0")/bootstrap.sh"

echo "✅ SYSTEM READY"
