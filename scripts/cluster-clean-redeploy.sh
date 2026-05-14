#!/usr/bin/env bash
set -euo pipefail

echo "🧹 AI ORCHESTRATOR: CLEAN + REDEPLOY START"

# =========================================================
# 0. SAFETY: CLUSTER ACCESS CHECK
# =========================================================
echo "🔎 Checking cluster connection..."

kubectl cluster-info >/dev/null 2>&1 || {
  echo "❌ Kubernetes cluster not reachable"
  exit 1
}

# =========================================================
# 1. CLEAN APPLICATION LAYER (KNOWN SERVICES)
# =========================================================
echo "🗑️ Cleaning known AI workloads..."

APPS=("ollama" "orchestrator" "base-agent")

for app in "${APPS[@]}"; do
  echo "→ Cleaning app: $app"

  kubectl delete deployment "$app" --ignore-not-found=true
  kubectl delete service "$app" --ignore-not-found=true

  kubectl delete pods -l app="$app" --ignore-not-found=true
done

# =========================================================
# 2. REMOVE ZOMBIE / ORPHAN PODS (NO OWNER)
# =========================================================
echo "🧟 Removing orphan (zombie) pods..."

kubectl get pods -A -o json \
| jq -r '
  .items[]
  | select(.metadata.ownerReferences == null)
  | select(.metadata.namespace != "kube-system")
  | "\(.metadata.namespace) \(.metadata.name)"
' \
| while read -r ns pod; do
    echo "→ Deleting orphan pod: $ns/$pod"
    kubectl delete pod "$pod" -n "$ns" --ignore-not-found=true
done

# =========================================================
# 3. REMOVE FAILED / EVicted / COMPLETED JOB ARTIFACTS
# =========================================================
echo "🧽 Cleaning failed/completed pods..."

kubectl get pods -A --no-headers | while read -r ns name ready status rest; do
  case "$status" in
    Completed|Error|CrashLoopBackOff|Evicted)
      echo "→ Removing $ns/$name ($status)"
      kubectl delete pod "$name" -n "$ns" --ignore-not-found=true
      ;;
  esac
done

# =========================================================
# 4. OPTIONAL: CLEAN OLD REPLICASETS (ZOMBIE HISTORY)
# =========================================================
echo "📦 Cleaning old ReplicaSets (safe pruning)..."

kubectl get rs -A -o json \
| jq -r '
  .items[]
  | select(.spec.replicas == 0)
  | "\(.metadata.namespace) \(.metadata.name)"
' \
| while read -r ns rs; do
    echo "→ Deleting ReplicaSet: $ns/$rs"
    kubectl delete rs "$rs" -n "$ns" --ignore-not-found=true
done

# =========================================================
# 5. APPLY CLEAN INFRASTRUCTURE (REDEPLOY CORE)
# =========================================================
echo "📦 Reapplying infrastructure manifests..."

MANIFESTS=(
  "k8s/ollama.yaml"
  "k8s/orchestrator.yaml"
  "k8s/base-agent.yaml"
)

for file in "${MANIFESTS[@]}"; do
  if [ -f "$file" ]; then
    echo "→ Applying $file"
    kubectl apply -f "$file"
  else
    echo "⚠️ Missing manifest: $file"
  fi
done

# =========================================================
# 6. FINAL HEALTH CHECK
# =========================================================
echo "📊 Final cluster state:"

kubectl get pods -A -o wide

echo ""
echo "✅ AI ORCHESTRATOR CLEAN + REDEPLOY COMPLETE"
echo "🧠 Cluster should now be in deterministic baseline state"
