#!/usr/bin/env bash
set -e

echo "🧹 AI CLUSTER CLEAN + REDEPLOY START"

# ----------------------------
# 1. CLEAN ONLY APP LAYER
# ----------------------------

echo "🗑️ Removing AI application pods..."

sudo kubectl delete pods -l app=ollama --ignore-not-found=true
sudo kubectl delete deployment ollama --ignore-not-found=true
sudo kubectl delete pods -l app=orchestrator --ignore-not-found=true
sudo kubectl delete deployment orchestrator --ignore-not-found=true
sudo kubectl delete pods -l app=base-agent --ignore-not-found=true
sudo kubectl delete deployment base-agent --ignore-not-found=true

echo "🧽 Cleaning completed pods (Completed/Unknown states)..."
sudo kubectl get pods --all-namespaces | awk '$4=="Completed" || $4=="Error" {print $2,$1}' | while read pod ns; do
  sudo kubectl delete pod "$pod" -n "$ns" --ignore-not-found=true
done

# ----------------------------
# 2. REAPPLY INFRASTRUCTURE
# ----------------------------

echo "📦 Reapplying clean manifests..."

if [ -f k8s/ollama.yaml ]; then
  sudo kubectl apply -f k8s/ollama.yaml
else
  echo "⚠️ k8s/ollama.yaml not found"
fi

if [ -f k8s/orchestrator.yaml ]; then
  sudo kubectl apply -f k8s/orchestrator.yaml
else
  echo "⚠️ k8s/orchestrator.yaml not found"
fi

# ----------------------------
# 3. STATUS CHECK
# ----------------------------

echo "📊 Cluster status:"
sudo kubectl get pods -o wide

echo "✅ AI CLUSTER CLEAN REDEPLOY DONE"
