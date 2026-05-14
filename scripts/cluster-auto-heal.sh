#!/usr/bin/env bash
set -e

echo "🧠 AI CLUSTER AUTO-HEAL v1"
echo "==========================="

echo ""
echo "🔎 Checking unhealthy pods..."

UNHEALTHY=$(kubectl get pods -A | grep -E "CrashLoopBackOff|Error|ImagePullBackOff" || true)

if [ -z "$UNHEALTHY" ]; then
  echo "🟢 No issues detected"
  exit 0
fi

echo "🔴 Issues found:"
echo "$UNHEALTHY"

echo ""
echo "🔁 Restarting affected deployments..."

# restart deployments only (safe heal)
kubectl rollout restart deployment ollama --ignore-not-found=true
kubectl rollout restart deployment base-agent --ignore-not-found=true

echo ""
echo "⏳ Waiting for rollout..."

kubectl rollout status deployment ollama --timeout=120s || true
kubectl rollout status deployment base-agent --timeout=120s || true

echo ""
echo "✅ AUTO-HEAL COMPLETE"
