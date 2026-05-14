#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 AI Orchestrator starting on Control Node 01"
echo "ROOT: $REPO_ROOT"

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

kubectl get nodes >/dev/null

bash "$REPO_ROOT/state/apply.sh"

echo "✅ DONE"
