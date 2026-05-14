#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "📦 Applying Kubernetes state"

kubectl apply -f "$REPO_ROOT/k8s/ollama.yaml"
kubectl apply -f "$REPO_ROOT/k8s/orchestrator.yaml"
kubectl apply -f "$REPO_ROOT/k8s/agents/base-agent.yaml"

echo "📦 Kubernetes state applied"
