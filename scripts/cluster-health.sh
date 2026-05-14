#!/usr/bin/env bash

echo "🧠 AI CLUSTER HEALTH CHECK"
echo "=========================="

echo ""
echo "📊 PODS:"
kubectl get pods -o wide

echo ""
echo "🚨 PROBLEMY:"
kubectl get pods -A | grep -E "Error|Crash|ImagePull|Pending" || echo "OK"

echo ""
echo "🔁 RESTART COUNTS:"
kubectl get pods -A -o json | jq -r '
  .items[] |
  select(.status.restartCount > 0) |
  "\(.metadata.name) restarts=\(.status.restartCount)"
' || true

echo ""
echo "✅ DONE"
