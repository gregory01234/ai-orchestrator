#!/usr/bin/env bash
set -e

AGENT_NAME="${1:-test-agent}"

TEMPLATE="factory/agent-template.yaml"
OUT="factory/generated-${AGENT_NAME}.yaml"

sed "s/{{AGENT_NAME}}/${AGENT_NAME}/g" "$TEMPLATE" > "$OUT"

kubectl apply -f "$OUT"

echo "✅ Agent deployed: $AGENT_NAME"
