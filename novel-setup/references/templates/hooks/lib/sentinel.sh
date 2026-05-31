#!/usr/bin/env bash
# sentinel.sh — 读取 .novel-deployed 哨兵文件字段
# 被 hook 脚本 source

NOVEL_SENTINEL_FILE=".novel-deployed"

# 读取哨兵文件的指定字段
sentinel_get() {
  local field="$1"
  local root
  root="$(project_root)"
  local file="${root}/${NOVEL_SENTINEL_FILE}"
  if [ ! -f "$file" ]; then
    echo ""
    return
  fi
  awk -F': ' -v key="$field" '$1 == key { $1=""; sub(/^ /, ""); print }' "$file"
}

# 检查哨兵文件是否存在
sentinel_exists() {
  local root
  root="$(project_root)"
  [ -f "${root}/${NOVEL_SENTINEL_FILE}" ]
}

# 获取 agents_version
sentinel_agents_version() {
  sentinel_get "agents_version"
}

# 获取 setup_skill_version
sentinel_setup_version() {
  sentinel_get "setup_skill_version"
}
