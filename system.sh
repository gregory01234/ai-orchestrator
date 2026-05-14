#!/usr/bin/env bash
set -e

MODE="${1:-help}"

REPO="https://github.com/gregory01234/ai-orchestrator.git"

ROOT_DIR="$(pwd)/ai-orchestrator"

ensure_repo() {
  if [ ! -d "$ROOT_DIR" ]; then
    echo "📦 Cloning repo..."
    git clone "$REPO" "$ROOT_DIR"
  fi
}

run_bootstrap() {
  echo "🚀 BOOTSTRAP START"
  ensure_repo
  cd "$ROOT_DIR"
  chmod +x bootstrap.sh
  sudo ./bootstrap.sh
  sudo bash ./system-up.sh
}

run_clean() {
  echo "🧹 CLEAN START"
  ensure_repo
  cd "$ROOT_DIR"
  chmod +x scripts/cluster-clean-redeploy.sh
  sudo ./scripts/cluster-clean-redeploy.sh
}

run_health() {
  echo "🧠 HEALTH CHECK"
  ensure_repo
  cd "$ROOT_DIR"
  chmod +x scripts/cluster-health.sh
  sudo ./scripts/cluster-health.sh
}

run_monitor() {
  echo "📊 MONITOR"
  ensure_repo
  cd "$ROOT_DIR"
  chmod +x scripts/cluster-monitor.sh
  sudo ./scripts/cluster-monitor.sh
}

run_heal() {
  echo "🔁 AUTO HEAL"
  ensure_repo
  cd "$ROOT_DIR"
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
    echo "🧠 SYSTEM RUNNER v1.1 (HARDENED)"
    echo "Usage:"
    echo "  sudo ./system.sh bootstrap"
    echo "  sudo ./system.sh clean"
    echo "  sudo ./system.sh health"
    echo "  sudo ./system.sh monitor"
    echo "  sudo ./system.sh heal"
    ;;
esac
