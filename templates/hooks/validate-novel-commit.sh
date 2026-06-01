#!/usr/bin/env bash
# validate-novel-commit.sh — PreToolUse hook (Bash, git commit*)
# 提交前检查设定文件完整性（advisory only，不阻止提交）

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/sentinel.sh"

ROOT="$(project_root)"

# 静默检查：未部署则跳过
if ! sentinel_exists; then
  exit 0
fi

# 获取 staged 的 .md 文件
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null | grep '\.md$')
if [ -z "$STAGED_FILES" ]; then
  exit 0
fi

ISSUES=0

# 检查设定文件是否有必填字段
while IFS= read -r file; do
  # 只检查设定目录下的文件
  if echo "$file" | grep -q "设定/"; then
    full_path="${ROOT}/${file}"
    if [ -f "$full_path" ]; then
      # 角色文件必须有基本信息
      if echo "$file" | grep -qi "角色\|人物"; then
        if ! grep -q "姓名\|名字\|名称" "$full_path" 2>/dev/null; then
          echo "⚠️  ${file}：角色文件缺少姓名字段"
          ISSUES=$((ISSUES + 1))
        fi
      fi
    fi
  fi
done <<< "$STAGED_FILES"

# 检查正文中是否有硬编码的角色属性（advisory）
while IFS= read -r file; do
  if echo "$file" | grep -q "正文/"; then
    full_path="${ROOT}/${file}"
    if [ -f "$full_path" ]; then
      # 检查是否有"她今年X岁"这种硬编码年龄
      hardcoded=$(grep -cP '她今年\d+岁|他今年\d+岁|年龄.*\d+岁' "$full_path" 2>/dev/null || echo "0")
      if [ "$hardcoded" -gt 0 ]; then
        echo "💡  ${file}：发现 ${hardcoded} 处硬编码年龄（建议用变量或设定文件引用）"
        ISSUES=$((ISSUES + 1))
      fi
    fi
  fi
done <<< "$STAGED_FILES"

# Advisory only: 始终 exit 0，不阻止提交
exit 0
