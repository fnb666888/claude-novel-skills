#!/usr/bin/env bash
# post-compact.sh — PostCompact hook
# 在上下文压缩后提示恢复写作上下文

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/sentinel.sh"

ROOT="$(project_root)"

# 静默检查：未部署则跳过
if ! sentinel_exists; then
  exit 0
fi

NOVELS=($(discover_all_novels))
if [ ${#NOVELS[@]} -eq 0 ]; then
  exit 0
fi

for novel_dir in "${NOVELS[@]}"; do
  novel_name="$(basename "$novel_dir")"
  context_file="${novel_dir}/追踪/上下文.md"
  if [ -f "$context_file" ]; then
    echo "📖 请读取 ${novel_name}/追踪/上下文.md 以恢复写作上下文。"
  fi
done

exit 0
