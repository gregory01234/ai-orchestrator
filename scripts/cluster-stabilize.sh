#!/usr/bin/env bash
set -e

echo "🧱 AI STABILIZATION v2 START"

echo "⏳ Waiting for pods to be READY..."

kubectl wait --for=condition=Ready pod -l app=ollama --timeout=120s || true
kubectl wait --for=condition=Ready pod -l app=base-agent --timeout=120s || true
kubectl wait --for=condition=Ready pod -l app=orchestrator --timeout=120s || true

echo "🔍 Checking system health..."

ERRORS=$(kubectl get pods -A | grep -E "CrashLoop|Error|ImagePull|Pending" || true)

if [ ! -z "$ERRORS" ]; then
  echo "❌ SYSTEM NOT HEALTHY"
  echo "$ERRORS"
  exit 1
fi

echo "🟢 SYSTEM HEALTHY"
echo "✅ STABILIZATION COMPLETE"
