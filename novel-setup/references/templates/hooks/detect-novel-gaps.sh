#!/usr/bin/env bash
# detect-novel-gaps.sh — SessionStart hook
# 检查小说项目中的缺口

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

GAPS_FOUND=0

for novel_dir in "${NOVELS[@]}"; do
  novel_name="$(basename "$novel_dir")"

  # 检查1：有正文但无大纲
  text_count="$(count_md_files "${novel_dir}/正文")"
  outline_count="$(count_md_files "${novel_dir}/大纲")"
  if [ "$text_count" -gt 0 ] && [ "$outline_count" -eq 0 ]; then
    echo "⚠️  ${novel_name}：已有 ${text_count} 章正文但无大纲文件"
    GAPS_FOUND=$((GAPS_FOUND + 1))
  fi

  # 检查2：有正文但无世界观
  world_count="$(count_md_files "${novel_dir}/设定")"
  if [ "$text_count" -gt 5 ] && [ "$world_count" -eq 0 ]; then
    echo "⚠️  ${novel_name}：已有 ${text_count} 章正文但无设定文件"
    GAPS_FOUND=$((GAPS_FOUND + 1))
  fi

  # 检查3：伏笔文件状态
  foreshadow_file="${novel_dir}/追踪/伏笔.md"
  if [ -f "$foreshadow_file" ]; then
    unresolved=$(grep -c "状态.*未回收" "$foreshadow_file" 2>/dev/null || echo "0")
    if [ "$unresolved" -gt 20 ]; then
      echo "⚠️  ${novel_name}：有 ${unresolved} 个未回收伏笔（建议检查）"
      GAPS_FOUND=$((GAPS_FOUND + 1))
    fi
  fi

  # 检查4：进度文件与实际章节数不匹配
  progress_file="${novel_dir}/追踪/进度.md"
  if [ -f "$progress_file" ] && [ "$text_count" -gt 0 ]; then
    recorded=$(grep -oP '已完成[：:]\s*\K\d+' "$progress_file" 2>/dev/null || echo "0")
    if [ "$recorded" -gt 0 ] && [ "$text_count" -ne "$recorded" ]; then
      echo "⚠️  ${novel_name}：进度文件记录 ${recorded} 章，实际 ${text_count} 章"
      GAPS_FOUND=$((GAPS_FOUND + 1))
    fi
  fi
done

if [ "$GAPS_FOUND" -eq 0 ]; then
  # 静默：无问题时不输出
  exit 0
fi

echo ""
echo "💡 使用对应 skill 修复上述问题。"

exit 0
