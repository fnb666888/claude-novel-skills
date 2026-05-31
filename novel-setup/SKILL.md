---
name: novel-setup
version: 1.0.0
description: |
  小说创作工具集基础设施部署。将 hooks/rules/agents/CLAUDE.md 等基础设施部署到用户项目目录。
  触发方式：/novel-setup、「准备写小说」「帮我搭一下环境」「配置小说项目」
---

# novel-setup：小说创作工具集基础设施部署

你是小说创作基础设施部署器。将小说创作工具集的全套基础设施（hooks、rules、agents、CLAUDE.md）部署到用户项目目录。

**执行铁律：不覆盖用户已有配置，合并而非替换。**

---

## Phase 1：检测项目状态

1. 检查当前目录是否已部署过（存在 `.novel-deployed`）
   - 如果已存在 → 使用 AskUserQuestion 确认是否重新部署
2. 检查是否有小说项目结构（包含 `灵感/`、`大纲/`、`正文/`、`设定/` 等目录）
   - 有 → 识别为已有项目，显示当前项目信息
   - 无 → 识别为新项目
3. 检查 `.claude/settings.local.json` 是否存在
   - 存在 → 读取现有配置，后续合并
   - 不存在 → 后续创建新文件

## Phase 2：部署基础设施

使用 AskUserQuestion 确认部署位置后，依次执行。

### 2.0 部署清单

| Source path | Target path | Merge mode | Validation check |
|-------------|-------------|------------|------------------|
| `templates/CLAUDE.md.tmpl` | `CLAUDE.md` | marker/section merge | contains 3-pillar skill routing sections |
| `templates/hooks/` | `.claude/hooks/` | recursive replace | `session-*.sh`, `validate-novel-commit.sh`, `lib/common.sh`, `lib/sentinel.sh` exist |
| `templates/rules/*.md` | `.claude/rules/*.md` | replace | every rule contains `paths` frontmatter |
| `templates/agents/*.md` | `.claude/agents/*.md` | replace | 5 agent files exist (architect/writer/character/checker/learner) |
| `novel-references/*.md` | `.claude/skills/novel-setup/references/novel-references/*.md` | replace | every reference resolves |
| `templates/settings-hooks.json` | `.claude/settings.local.json` | merge by hook command | hook JSON valid |
| generated sentinel | `.novel-deployed` | replace | contains version fields |

### 2.1 部署 CLAUDE.md

- 读取 `references/templates/CLAUDE.md.tmpl`
- 替换占位符（见下方「模板占位符」段）
- 写入项目根目录 `CLAUDE.md`（如已存在，按「CLAUDE.md 合并策略」处理）

### 2.2 部署 Hooks

- **递归复制完整目录树**：将 `references/templates/hooks/` 复制到用户项目 `.claude/hooks/`
- 必须保留子目录 `lib/`，其中：
  - `lib/common.sh` 提供 `project_root`、`discover_active_book`
  - `lib/sentinel.sh` 提供 `.novel-deployed` 字段读取
- 只需对 `.claude/hooks/*.sh` 设置执行权限（`chmod +x`）

### 2.3 部署 Rules

- 读取 `references/templates/rules/` 下所有 `.md` 文件
- 复制到用户项目的 `.claude/rules/` 目录

### 2.4 部署 Agents

- 读取 `references/templates/agents/` 下所有 `.md` 文件
- 复制到用户项目的 `.claude/agents/` 目录
- Agent 文件属于 novel-setup 管理文件，可安全覆盖

### 2.5 部署 Novel References

- 将 `references/novel-references/` 下所有 `.md` 复制到项目内 `.claude/skills/novel-setup/references/novel-references/`
- 校验：凡 agent 或 reference 中出现 `novel-setup/references/novel-references/<file>.md`，源包与目标包都必须存在

### 2.6 合并 Hooks 注册到 settings.local.json

- 读取 `references/templates/settings-hooks.json`
- 读取用户项目的 `.claude/settings.local.json`（如存在）
- 合并 hooks 配置（按「settings-hooks.json 合并算法」处理）
- 写入 `.claude/settings.local.json`

### 2.7 创建部署标记

- 创建 `.novel-deployed` 文件（sentinel file）
- 写入以下字段（YAML `key: value` 格式）：
  ```
  deployed_at: <date -u +"%Y-%m-%dT%H:%M:%SZ">
  agents_version: 1
  setup_skill_version: 1.0.0
  target_cli: claude-code
  resolver_strategy: project-local-skill-reference
  references_dir: .claude/skills/novel-setup/references/novel-references
  ```

## Phase 3：验证安装

1. 验证 hooks 注册：检查 `.claude/settings.local.json` 中的 hooks 字段
2. 验证 rules：检查 `.claude/rules/` 下的规则文件存在且包含 `paths` frontmatter
3. 验证 agents：检查 `.claude/agents/` 下的 5 个 agent 定义文件
4. 验证 references：检查 `.claude/skills/novel-setup/references/novel-references/` 完整
5. 验证部署标记：检查 `.novel-deployed`
6. 输出安装报告：
   - 列出所有已部署的文件
   - 列出需要注意的事项
   - 提示用户可以开始使用 `/novel-inspiration` 或 `/novel-chapter`

---

## 模板占位符

| 占位符 | 替换规则 | 示例 |
|--------|----------|------|
| `{项目名}` | 用户项目名称或目录名 | 《我的小说》 |
| `{小说名}` | 小说目录名 | 与 `{项目名}` 相同 |
| `{目标平台}` | 目标发布平台 | 起点、番茄、晋江 |
| `{作者名}` | 用户笔名或昵称 | 未指定时用「作者」 |

## CLAUDE.md 合并策略

用户已有 CLAUDE.md 时，按 marker/section 合并：
1. 优先识别 novel-setup 管理块标记
2. 无标记时，读取用户现有 CLAUDE.md，按 `##` 标题切分为 section map
3. 读取模板 CLAUDE.md.tmpl，同样切分
4. 模板中的标准 section（Skill 路由表、文件结构、协作规则）**覆盖**用户同名 section
5. 用户独有的 section **保留**不动
6. 未知冲突用 AskUserQuestion 让用户选择

## settings-hooks.json 合并算法

hooks 注册合并按 command 字段去重：
1. 读取用户现有 `.claude/settings.local.json`，提取 hooks 部分
2. 读取 `settings-hooks.json` 模板
3. 对每个 hook event：用户已有的 hook command → 保留；模板中的新 command → append
4. 用户独有配置 → 完整保留
5. 写入合并后的完整 settings.local.json

## 重新部署

- `.novel-deployed` 不存在 → 全新安装
- `.novel-deployed` 存在且版本匹配 → 提示已部署，确认是否重新部署
- `.novel-deployed` 存在但版本低 → 提示需要更新，重新执行 Phase 2

---

## 参考资料

| 文件 | 用途 |
|------|------|
| references/templates/CLAUDE.md.tmpl | 项目根 CLAUDE.md 模板（三支柱路由表） |
| references/templates/hooks/ | 5 个 hook 脚本 + lib/（2个库文件） |
| references/templates/rules/ | 4 条 path-scoped 规则模板 |
| references/templates/agents/ | 5 个 agent 定义模板（architect/writer/character/checker/learner） |
| references/novel-references/ | Agent 参考资料 |
| references/templates/settings-hooks.json | hooks 注册 JSON 片段 |

---

## 流程衔接

| 时机 | 跳转到 | 命令 |
|---|---|---|
| 部署完成，开始创作 | novel-inspiration / novel-chapter | `/novel-inspiration` 或 `/novel-chapter` |
| 市场调研 / 导入 / 学习 | novel-learn | `/novel-learning` |
| 评分优化 | novel-quality | `/novel-quality` |
| 项目管理 | novel-manage | `/novel-manage` |
