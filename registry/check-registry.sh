#!/usr/bin/env bash
set -euo pipefail

echo "🧠 AGENT REGISTRY CHECK"

FILE="registry/agents.json"

for agent in $(jq -r '.agents[].name' "$FILE"); do
  if kubectl get deployment "$agent" >/dev/null 2>&1; then
    echo "🟢 $agent = EXISTS"
  else
    echo "🔴 $agent = MISSING"
  fi
done

echo "✅ REGISTRY CHECK DONE"
