#!/usr/bin/env bash

set -e

MODE="${1:-help}"

REPO="https://github.com/gregory01234/ai-orchestrator.git"

run_bootstrap() {
  echo "🚀 BOOTSTRAP START"
  rm -rf ai-orchestrator
  git clone "$REPO"
  cd ai-orchestrator
  chmod +x bootstrap.sh
  sudo ./bootstrap.sh
  sudo bash ./system-up.sh
}

run_clean() {
  echo "🧹 CLEAN START"
  rm -rf ai-orchestrator
  git clone "$REPO"
  cd ai-orchestrator
  chmod +x scripts/cluster-clean-redeploy.sh
  sudo ./scripts/cluster-clean-redeploy.sh
}

run_health() {
  echo "🧠 HEALTH CHECK"
  rm -rf ai-orchestrator
  git clone "$REPO"
  cd ai-orchestrator
  chmod +x scripts/cluster-health.sh
  sudo ./scripts/cluster-health.sh
}

run_monitor() {
  echo "📊 MONITOR"
  rm -rf ai-orchestrator
  git clone "$REPO"
  cd ai-orchestrator
  chmod +x scripts/cluster-monitor.sh
  sudo ./scripts/cluster-monitor.sh
}

run_heal() {
  echo "🔁 AUTO HEAL"
  rm -rf ai-orchestrator
  git clone "$REPO"
  cd ai-orchestrator
  chmod +x scripts/cluster-auto-heal.sh
  sudo ./scripts/cluster-auto-heal.sh
}

case "$MODE" in
  bootstrap)
    run_bootstrap
    ;;
  clean)
    run_clean
    ;;
  health)
    run_health
    ;;
  monitor)
    run_monitor
    ;;
  heal)
    run_heal
    ;;
  *)
    echo "🧠 SYSTEM RUNNER v1"
    echo "Usage:"
    echo "  sudo ./system.sh bootstrap"
    echo "  sudo ./system.sh clean"
    echo "  sudo ./system.sh health"
    echo "  sudo ./system.sh monitor"
    echo "  sudo ./system.sh heal"
    ;;
esac
