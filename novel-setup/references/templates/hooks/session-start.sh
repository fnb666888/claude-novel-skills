#!/usr/bin/env bash
# session-start.sh — SessionStart hook
# 显示小说项目状态、写作进度

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

# 检查是否有小说项目
NOVELS=($(discover_all_novels))
if [ ${#NOVELS[@]} -eq 0 ]; then
  echo "💡 未检测到小说项目。使用 /novel-inspiration 开始创作。"
  exit 0
fi

# 显示每个小说的进度
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

  # 世界观状态
  world_count="$(count_md_files "${novel_dir}/设定")"
  echo "   设定：${world_count} 个文件"

  # 进度文件
  progress_file="${novel_dir}/追踪/进度.md"
  if [ -f "$progress_file" ]; then
    current="$(get_current_chapter "$progress_file")"
    echo "   当前：${current}"
  fi
done

exit 0
