#!/usr/bin/env bash

set -e

echo "🧠 AI CLUSTER MONITOR"
echo "====================="

echo ""
echo "📊 POD STATUS"
kubectl get pods -o wide

echo ""
echo "🚨 PROBLEMY (Error / Crash / ImagePull / Pending)"
PROBLEMS=$(kubectl get pods -A | grep -E "Error|Crash|ImagePull|Pending" || true)

if [ -z "$PROBLEMS" ]; then
  echo "🟢 SYSTEM OK"
else
  echo "🔴 SYSTEM ISSUES DETECTED:"
  echo "$PROBLEMS"
fi

echo ""
echo "🔁 RESTART ANALYSIS"
kubectl get pods -A -o json | jq -r '
  .items[]
  | select(.status.restartCount > 0)
  | "\(.metadata.namespace)/\(.metadata.name) restarts=\(.status.restartCount)"
' || echo "No restart data / jq missing"

echo ""
echo "✅ MONITOR COMPLETE"
