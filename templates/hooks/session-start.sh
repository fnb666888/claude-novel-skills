#!/usr/bin/env bash
# session-start.sh — SessionStart hook
# 显示小说项目状态、写作进度、伏笔预警

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/sentinel.sh"

ROOT="$(project_root)"

# 静默检查：未部署则跳过
if ! sentinel_exists; then
  exit 0
fi

# 显示部署状态
VERSION="$(sentinel_setup_version)"
AGENTS_VER="$(sentinel_agents_version)"
echo "📚 小说创作工具集已部署 (v${VERSION}, agents v${AGENTS_VER})"
echo "🤖 自动管理已启用（novel-supervisor）"

# 检查是否有小说项目
NOVELS=($(discover_all_novels))
if [ ${#NOVELS[@]} -eq 0 ]; then
  echo "💡 未检测到小说项目。使用 /novel-inspiration 开始创作。"
  exit 0
fi

# 显示每个小说的进度 + 预警
for novel_dir in "${NOVELS[@]}"; do
  novel_name="$(basename "$novel_dir")"
  echo ""
  echo "📖 ${novel_name}"

  # 正文数量
  text_count="$(count_md_files "${novel_dir}/正文")"
  if [ "$text_count" -gt 0 ]; then
    echo "   正文：${text_count} 章"
  fi

  # 大纲状态
  outline_count="$(count_md_files "${novel_dir}/大纲")"
  echo "   大纲：${outline_count} 个文件"

  # 设定状态
  world_count="$(count_md_files "${novel_dir}/设定")"
  echo "   设定：${world_count} 个文件"

  # 进度文件
  progress_file="${novel_dir}/追踪/进度.md"
  if [ -f "$progress_file" ]; then
    current="$(get_current_chapter "$progress_file")"
    echo "   当前：${current}"
  fi

  # 缺口检测
  if [ "$text_count" -gt 0 ] && [ "$outline_count" -eq 0 ]; then
    echo "   ⚠️  有正文但无大纲"
  fi
  if [ "$text_count" -gt 5 ] && [ "$world_count" -eq 0 ]; then
    echo "   ⚠️  有正文但无设定文件"
  fi

  # 伏笔状态
  foreshadow_file="${novel_dir}/追踪/伏笔.md"
  if [ -f "$foreshadow_file" ]; then
    unresolved=$(grep -c "状态.*未回收" "$foreshadow_file" 2>/dev/null || echo "0")
    overdue=$(grep -c "状态.*超期" "$foreshadow_file" 2>/dev/null || echo "0")
    if [ "$unresolved" -gt 20 ]; then
      echo "   ⚠️  ${unresolved} 个未回收伏笔"
    fi
    if [ "$overdue" -gt 0 ]; then
      echo "   🔴 ${overdue} 个超期伏笔（需优先处理）"
    fi
  fi

  # 写作反馈状态
  feedback_file="${novel_dir}/追踪/写作反馈.md"
  if [ -f "$feedback_file" ]; then
    # 检查反馈文件的最后更新时间
    feedback_age=$(( $(date +%s) - $(stat -c %Y "$feedback_file" 2>/dev/null || stat -f %m "$feedback_file" 2>/dev/null || echo "0") ))
    feedback_days=$(( feedback_age / 86400 ))
    if [ "$feedback_days" -gt 3 ]; then
      echo "   ⚠️  写作反馈 ${feedback_days} 天未更新"
    fi
  fi

  # 进度预警
  if [ -f "$progress_file" ]; then
    # 检查是否有连续低分章节
    low_score_count=$(grep -c "评分.*[0-7]\." "$progress_file" 2>/dev/null || echo "0")
    if [ "$low_score_count" -gt 3 ]; then
      echo "   ⚠️  有 ${low_score_count} 个低分章节需优化"
    fi
  fi
done

echo ""
echo "💡 自动管理：写作产出将自动触发一致性检查和追踪更新"
echo "   手动管理：/novel-setup 查看可用管理命令"

exit 0
