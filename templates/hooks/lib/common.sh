#!/usr/bin/env bash
# common.sh — 共享函数库
# 被所有 hook 脚本 source

# 获取项目根目录
project_root() {
  if [ -n "$CLAUDE_PROJECT_DIR" ]; then
    echo "$CLAUDE_PROJECT_DIR"
    return
  fi
  # 尝试 git root
  local git_root
  git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ -n "$git_root" ]; then
    echo "$git_root"
    return
  fi
  # 回退到 cwd
  pwd
}

# 解析项目内路径
resolve_project_path() {
  local root
  root="$(project_root)"
  echo "${root}/$1"
}

# 检查 .novel-deployed 是否存在
is_novel_deployed() {
  local root
  root="$(project_root)"
  [ -f "${root}/.novel-deployed" ]
}

# 获取小说项目目录列表（包含 大纲/ 子目录的目录）
discover_all_novels() {
  local root
  root="$(project_root)"
  find "$root" -maxdepth 2 -type d -name "大纲" 2>/dev/null | while read -r d; do
    dirname "$d"
  done
}

# 获取进度文件中的当前章节
get_current_chapter() {
  local progress_file="$1"
  if [ -f "$progress_file" ]; then
    grep -oP '当前章节[：:]\s*\K[^\s]+' "$progress_file" 2>/dev/null || echo "未知"
  else
    echo "未知"
  fi
}

# 统计目录下 .md 文件数
count_md_files() {
  local dir="$1"
  if [ -d "$dir" ]; then
    find "$dir" -maxdepth 1 -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' '
  else
    echo "0"
  fi
}
