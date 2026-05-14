#!/usr/bin/env bash
set -e

echo "🧠 SYSTEM TRUTH SOURCE"
echo "======================"

check() {
  ns="default"
  name=$1

  status=$(kubectl get pods -n $ns | grep "$name" | awk '{print $3}' || true)

  if [[ "$status" == "Running" ]]; then
    echo "🟢 $name = RUNNING"
  elif [[ -n "$status" ]]; then
    echo "🟡 $name = $status"
  else
    echo "🔴 $name = MISSING"
  fi
}

check "ollama"
check "orchestrator"
check "base-agent"

echo ""
echo "📊 RAW KUBERNETES STATE:"
kubectl get pods -o wide

echo ""

if kubectl get pods | grep -q "CrashLoop\|Error\|ImagePullBackOff"; then
  echo "❌ SYSTEM NOT READY FOR AGENTS"
else
  echo "✅ READY FOR AGENTS"
fi
