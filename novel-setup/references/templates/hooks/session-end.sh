#!/usr/bin/env bash
# session-end.sh — SessionEnd hook
# 默认静默。仅在 NOVEL_SESSION_LOG=1 时记录日志。

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/sentinel.sh"

ROOT="$(project_root)"

# 静默检查：未部署则跳过
if ! sentinel_exists; then
  exit 0
fi

# 默认静默
if [ "$NOVEL_SESSION_LOG" != "1" ]; then
  exit 0
fi

NOVELS=($(discover_all_novels))
if [ ${#NOVELS[@]} -eq 0 ]; then
  exit 0
fi

for novel_dir in "${NOVELS[@]}"; do
  novel_name="$(basename "$novel_dir")"
  log_file="${novel_dir}/追踪/session-log.txt"
  if [ -d "${novel_dir}/追踪" ]; then
    echo "---" >> "$log_file"
    echo "session_end: $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$log_file"
  fi
done

exit 0
