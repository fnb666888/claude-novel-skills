#!/usr/bin/env bash
# post-content-review.sh — PostToolUse hook
# 检测内容变更（正文/设定），输出指令触发 novel-supervisor 自动审查
#
# 触发条件：Write/Edit 工具修改了 正文/ 或 设定/ 目录下的文件
# 防抖机制：使用锁文件防止 60 秒内重复触发

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"
source "${SCRIPT_DIR}/lib/sentinel.sh"

ROOT="$(project_root)"

# 静默检查：未部署则跳过
if ! sentinel_exists; then
  exit 0
fi

# 获取变更文件路径（从环境变量或参数）
CHANGED_FILE="${CLAUDE_TOOL_INPUT_FILE_PATH:-$1}"

# 如果没有文件路径，静默退出
if [ -z "$CHANGED_FILE" ]; then
  exit 0
fi

# 判断是否为目标目录（正文/ 或 设定/）
is_content_file() {
  local file="$1"
  case "$file" in
    */正文/*|*/设定/*) return 0 ;;
    *) return 1 ;;
  esac
}

# 如果不是内容文件，静默退出
if ! is_content_file "$CHANGED_FILE"; then
  exit 0
fi

# 防抖：检查锁文件
LOCK_FILE="${ROOT}/.claude/.supervisor-lock"
LOCK_TTL=60  # 秒

if [ -f "$LOCK_FILE" ]; then
  # 检查锁文件是否过期
  lock_age=$(( $(date +%s) - $(stat -c %Y "$LOCK_FILE" 2>/dev/null || stat -f %m "$LOCK_FILE" 2>/dev/null || echo "0") ))
  if [ "$lock_age" -lt "$LOCK_TTL" ]; then
    # 锁未过期，跳过
    exit 0
  fi
fi

# 创建锁文件
mkdir -p "${ROOT}/.claude"
echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" > "$LOCK_FILE"

# 判断变更类型
change_type="内容变更"
case "$CHANGED_FILE" in
  */正文/*) change_type="正文章节变更" ;;
  */设定/世界观.md) change_type="世界观设定变更" ;;
  */设定/角色/*) change_type="角色设定变更" ;;
  */设定/势力/*) change_type="势力设定变更" ;;
  */设定/*) change_type="设定文件变更" ;;
esac

# 输出指令（Claude 会读取这段输出并执行）
echo ""
echo "🔍 **自动管理者触发**"
echo ""
echo "变更类型: ${change_type}"
echo "变更文件: ${CHANGED_FILE}"
echo ""
echo "请调用 novel-supervisor agent 审查本次变更。"
echo "调用方式: Agent(subagent_type: 'novel-supervisor', prompt: '审查文件 ${CHANGED_FILE} 的变更，执行5维度一致性检查，更新追踪文件，生成写作反馈。')"
echo ""
echo "⏱️ 防抖锁已创建（${LOCK_TTL}秒内不会重复触发）"
echo ""

exit 0
