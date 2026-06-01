#!/usr/bin/env bash
# pre-compact.sh — PreCompact hook
# 在上下文压缩前保存写作状态

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/sentinel.sh"

ROOT="$(project_root)"

# 静默检查：未部署则跳过
if ! sentinel_exists; then
  exit 0
fi

# 检查是否有追踪目录
NOVELS=($(discover_all_novels))
if [ ${#NOVELS[@]} -eq 0 ]; then
  exit 0
fi

for novel_dir in "${NOVELS[@]}"; do
  context_file="${novel_dir}/追踪/上下文.md"
  if [ -f "$context_file" ]; then
    # 记录上下文文件行数（用于 post-compact 恢复提示）
    line_count=$(wc -l < "$context_file" 2>/dev/null || echo "0")
    echo "📝 上下文已记录：${novel_name} 追踪/上下文.md (${line_count} 行)"

    # 检查 git 状态
    cd "$ROOT" 2>/dev/null
    uncommitted=$(git diff --stat 2>/dev/null | tail -1)
    if [ -n "$uncommitted" ]; then
      echo "📝 Git 状态：${uncommitted}"
    fi
  fi
done

exit 0
