#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGINS_DIR="${SCRIPT_DIR}/lua/plugins"

AI_FILE="${PLUGINS_DIR}/ai.lua"
COMPLETION_FILE="${PLUGINS_DIR}/completion.lua"

LOCAL_AI_BAK="${PLUGINS_DIR}/ai.lua.bak"
LOCAL_COMPLETION_BAK="${PLUGINS_DIR}/completion.lua.bak"

COPILOT_AI_BAK="${PLUGINS_DIR}/ai.lua.copilot.bak"
COPILOT_COMPLETION_BAK="${PLUGINS_DIR}/completion.lua.copilot.bak"

die() {
  echo "Error: $1" >&2
  exit 1
}

ensure_base_files() {
  [[ -f "${AI_FILE}" ]] || die "Missing ${AI_FILE}"
  [[ -f "${COMPLETION_FILE}" ]] || die "Missing ${COMPLETION_FILE}"
  [[ -f "${LOCAL_AI_BAK}" ]] || die "Missing ${LOCAL_AI_BAK}"
  [[ -f "${LOCAL_COMPLETION_BAK}" ]] || die "Missing ${LOCAL_COMPLETION_BAK}"
}

files_equal() {
  local left="$1"
  local right="$2"
  [[ -f "${left}" && -f "${right}" ]] || return 1
  cmp -s "${left}" "${right}"
}

current_mode() {
  if files_equal "${AI_FILE}" "${LOCAL_AI_BAK}" && files_equal "${COMPLETION_FILE}" "${LOCAL_COMPLETION_BAK}"; then
    echo "local"
    return
  fi

  if files_equal "${AI_FILE}" "${COPILOT_AI_BAK}" && files_equal "${COMPLETION_FILE}" "${COPILOT_COMPLETION_BAK}"; then
    echo "copilot"
    return
  fi

  echo "custom"
}

init_copilot_backup_if_possible() {
  if [[ -f "${COPILOT_AI_BAK}" && -f "${COPILOT_COMPLETION_BAK}" ]]; then
    return
  fi

  if [[ "$(current_mode)" == "local" ]]; then
    die "Copilot backups are missing and active config is local. Restore/copilot config first, then run: $0 save-copilot"
  fi

  cp "${AI_FILE}" "${COPILOT_AI_BAK}"
  cp "${COMPLETION_FILE}" "${COPILOT_COMPLETION_BAK}"
  echo "Initialized Copilot backups:"
  echo "  - ${COPILOT_AI_BAK}"
  echo "  - ${COPILOT_COMPLETION_BAK}"
}

save_copilot() {
  cp "${AI_FILE}" "${COPILOT_AI_BAK}"
  cp "${COMPLETION_FILE}" "${COPILOT_COMPLETION_BAK}"
  echo "Saved current active config as Copilot backups."
}

switch_to_local() {
  init_copilot_backup_if_possible
  cp "${LOCAL_AI_BAK}" "${AI_FILE}"
  cp "${LOCAL_COMPLETION_BAK}" "${COMPLETION_FILE}"
  echo "Switched to local LLM config."
}

switch_to_copilot() {
  [[ -f "${COPILOT_AI_BAK}" ]] || die "Missing ${COPILOT_AI_BAK}. Run: $0 save-copilot"
  [[ -f "${COPILOT_COMPLETION_BAK}" ]] || die "Missing ${COPILOT_COMPLETION_BAK}. Run: $0 save-copilot"
  cp "${COPILOT_AI_BAK}" "${AI_FILE}"
  cp "${COPILOT_COMPLETION_BAK}" "${COMPLETION_FILE}"
  echo "Switched to Copilot config."
}

status() {
  echo "Current mode: $(current_mode)"
  echo "Active files:"
  echo "  - ${AI_FILE}"
  echo "  - ${COMPLETION_FILE}"
  echo "Backups:"
  echo "  - local:   ${LOCAL_AI_BAK}, ${LOCAL_COMPLETION_BAK}"
  echo "  - copilot: ${COPILOT_AI_BAK}, ${COPILOT_COMPLETION_BAK}"
}

toggle() {
  case "$(current_mode)" in
    local)
      switch_to_copilot
      ;;
    copilot|custom)
      switch_to_local
      ;;
    *)
      die "Unknown current mode"
      ;;
  esac
}

usage() {
  cat <<EOF
Usage: $0 [local|copilot|toggle|status|save-copilot]

  local         Switch active config to local LLM backup (*.lua.bak)
  copilot       Switch active config to Copilot backup (*.lua.copilot.bak)
  toggle        Toggle between local and copilot (default)
  status        Show detected active mode
  save-copilot  Save current active files as copilot backups

After switching, restart Neovim and run :Lazy sync.
EOF
}

ensure_base_files

ACTION="${1:-toggle}"
case "${ACTION}" in
  local)
    switch_to_local
    ;;
  copilot)
    switch_to_copilot
    ;;
  toggle)
    toggle
    ;;
  status)
    status
    ;;
  save-copilot)
    save_copilot
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    usage
    exit 1
    ;;
esac
