---
name: novel-setup
version: 2.0.0
description: |
  小说创作基础设施部署 + 项目自动管理。
  部署 hooks/rules/agents/CLAUDE.md 到用户项目目录，
  并提供世界观/一致性/伏笔/进度/备份管理。
  系统通过 novel-supervisor 自动审查所有写作产出，无需手动调用。
  触发方式：/novel-setup、「准备写小说」「帮我搭一下环境」「配置小说项目」
---

# novel-setup：基础设施部署 + 项目自动管理

你是小说创作系统的基础设施部署器和项目管理者。

**双重身份**：
1. **部署器**：首次使用时，将 hooks/rules/agents/CLAUDE.md 部署到用户项目
2. **管理者**：部署完成后，提供世界观/一致性/伏笔/进度/备份等管理功能

**自动管理**：系统通过 PostToolUse hook + novel-supervisor agent 自动审查所有写作产出，无需用户手动触发。

**执行铁律：不覆盖用户已有配置，合并而非替换。**

---

## 子命令路由总览

| 子命令 | 功能 | 说明 |
|--------|------|------|
| `世界观` | 世界观管理（新建/查看/编辑/检查） | 从灵感/大纲提取，或手动创建 |
| `检查` | 一致性检查（全书/单章/专项） | 5维度检查 + 写作反馈生成 |
| `伏笔` | 伏笔管理（新增/查看/回收/扫描） | 伏笔生命周期管理 |
| `进度` | 进度追踪（查看/更新） | 章节进度、质量统计 |
| `结构` | 项目目录验证 | 检查目录完整性 |
| `备份` | 项目状态打包 | 备份当前项目状态 |
| `迁移` | 目录结构升级 | 自动迁移非标准结构 |

---

## 使用方式

### 自动管理（默认行为）

系统在以下情况自动触发 novel-supervisor 审查：
- novel-chapter 生成正文章节后
- novel-writer 写入正文内容后
- 用户手动编辑 `正文/` 或 `设定/` 文件后

自动审查内容：
1. 5维度一致性检查（调用 novel-checker）
2. 追踪文件自动更新（进度/伏笔/时间线）
3. 写作反馈生成（追踪/写作反馈.md）

**无需手动触发，系统自动执行。**

### 世界观管理
- `/novel-setup 世界观 新建 [小说名]` — 从零创建世界观设定文档
- `/novel-setup 世界观 查看 [小说名]` — 查看当前世界观设定
- `/novel-setup 世界观 编辑 [小说名]` — 编辑世界观设定
- `/novel-setup 世界观 检查 [小说名] [待检查文件]` — 检查文件是否符合世界观
- `/novel-setup 世界观 从灵感 [灵感文件路径]` — 从已有灵感提取世界观
- `/novel-setup 世界观 从大纲 [大纲文件路径]` — 从已有大纲提取世界观

### 一致性检查
- `/novel-setup 检查 [小说名]` — 全书五维度一致性检查
- `/novel-setup 检查 [小说名] --from 第X章 --to 第Y章` — 检查指定范围
- `/novel-setup 检查章 [章节文件路径]` — 单章与前文连续性检查
- `/novel-setup 检查章 [章节文件路径] --previous [上一章文件路径]` — 指定上一章
- `/novel-setup 角色 [小说名]` — 只检查角色一致性
- `/novel-setup 伏笔检查 [小说名]` — 只检查伏笔回收
- `/novel-setup 时间线 [小说名]` — 只检查时间线
- `/novel-setup 世界观检查 [小说名]` — 只检查世界观一致性

### 伏笔管理
- `/novel-setup 伏笔 新增 [小说名]` — 记录新伏笔
- `/novel-setup 伏笔 查看 [小说名]` — 查看所有伏笔状态
- `/novel-setup 伏笔 回收 [小说名] [伏笔ID]` — 标记伏笔回收
- `/novel-setup 伏笔 扫描 [小说名]` — 扫描未回收伏笔

### 进度追踪
- `/novel-setup 进度 查看 [小说名]` — 查看当前创作进度
- `/novel-setup 进度 更新 [小说名]` — 更新进度记录

### 项目维护
- `/novel-setup 结构 验证 [小说名]` — 检查目录完整性
- `/novel-setup 备份 [小说名]` — 打包当前项目状态
- `/novel-setup 迁移 [小说名]` — 目录结构升级

---

## Phase 0：首次部署（仅执行一次）

当用户首次调用 `/novel-setup` 且 `.novel-deployed` 不存在时，执行基础设施部署。

### 0.1 检测项目状态

1. 检查当前目录是否已部署过（存在 `.novel-deployed`）
   - 如果已存在 → 使用 AskUserQuestion 确认是否重新部署
2. 检查是否有小说项目结构（包含 `灵感/`、`大纲/`、`正文/`、`设定/` 等目录）
   - 有 → 识别为已有项目，显示当前项目信息
   - 无 → 识别为新项目
3. 检查 `.claude/settings.local.json` 是否存在
   - 存在 → 读取现有配置，后续合并
   - 不存在 → 后续创建新文件

### 0.2 部署基础设施

使用 AskUserQuestion 确认部署位置后，依次执行。

#### 部署清单

| Source path | Target path | Merge mode | Validation check |
|-------------|-------------|------------|------------------|
| `templates/CLAUDE.md.tmpl` | `CLAUDE.md` | marker/section merge | contains skill routing sections |
| `templates/hooks/` | `.claude/hooks/` | recursive replace | 6 hook scripts + lib/ exist |
| `templates/rules/*.md` | `.claude/rules/*.md` | replace | every rule contains `paths` frontmatter |
| `templates/agents/*.md` | `.claude/agents/*.md` | replace | 6 agent files exist |
| `novel-references/*.md` | `.claude/skills/novel-setup/references/novel-references/*.md` | replace | every reference resolves |
| `templates/settings-hooks.json` | `.claude/settings.local.json` | merge by hook command | hook JSON valid |
| generated sentinel | `.novel-deployed` | replace | contains version fields |

#### 部署 CLAUDE.md

- 读取 `references/templates/CLAUDE.md.tmpl`
- 替换占位符（见下方「模板占位符」段）
- 写入项目根目录 `CLAUDE.md`（如已存在，按「CLAUDE.md 合并策略」处理）

#### 部署 Hooks

- **递归复制完整目录树**：将 `references/templates/hooks/` 复制到用户项目 `.claude/hooks/`
- 必须保留子目录 `lib/`，其中：
  - `lib/common.sh` 提供 `project_root`、`discover_all_novels`
  - `lib/sentinel.sh` 提供 `.novel-deployed` 字段读取
- 只需对 `.claude/hooks/*.sh` 设置执行权限（`chmod +x`）

#### 部署 Rules

- 读取 `references/templates/rules/` 下所有 `.md` 文件
- 复制到用户项目的 `.claude/rules/` 目录

#### 部署 Agents

- 读取 `references/templates/agents/` 下所有 `.md` 文件
- 复制到用户项目的 `.claude/agents/` 目录
- Agent 文件属于 novel-setup 管理文件，可安全覆盖

#### 部署 Novel References

- 将 `references/novel-references/` 下所有 `.md` 复制到项目内 `.claude/skills/novel-setup/references/novel-references/`
- 校验：凡 agent 或 reference 中出现 `novel-setup/references/novel-references/<file>.md`，源包与目标包都必须存在

#### 合并 Hooks 注册到 settings.local.json

- 读取 `references/templates/settings-hooks.json`
- 读取用户项目的 `.claude/settings.local.json`（如存在）
- 合并 hooks 配置（按「settings-hooks.json 合并算法」处理）
- 写入 `.claude/settings.local.json`

#### 创建部署标记

- 创建 `.novel-deployed` 文件（sentinel file）
- 写入以下字段（YAML `key: value` 格式）：
  ```
  deployed_at: <date -u +"%Y-%m-%dT%H:%M:%SZ">
  agents_version: 2
  setup_skill_version: 2.0.0
  target_cli: claude-code
  resolver_strategy: project-local-skill-reference
  references_dir: .claude/skills/novel-setup/references/novel-references
  ```

### 0.3 验证安装

1. 验证 hooks 注册：检查 `.claude/settings.local.json` 中的 hooks 字段
2. 验证 rules：检查 `.claude/rules/` 下的规则文件存在且包含 `paths` frontmatter
3. 验证 agents：检查 `.claude/agents/` 下的 6 个 agent 定义文件（architect/writer/character/checker/learner/supervisor）
4. 验证 references：检查 `.claude/skills/novel-setup/references/novel-references/` 完整
5. 验证部署标记：检查 `.novel-deployed`
6. 输出安装报告：
   - 列出所有已部署的文件
   - 列出需要注意的事项
   - 提示自动管理已启用
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
- `.novel-deployed` 存在但版本低 → 提示需要更新，重新执行 Phase 0

---

## 参考资料

| 文件 | 用途 |
|------|------|
| references/templates/CLAUDE.md.tmpl | 项目根 CLAUDE.md 模板 |
| references/templates/hooks/ | 6 个 hook 脚本 + lib/（2个库文件） |
| references/templates/rules/ | 4 条 path-scoped 规则模板 |
| references/templates/agents/ | 6 个 agent 定义模板 |
| references/novel-references/ | Agent 参考资料 |
| references/templates/settings-hooks.json | hooks 注册 JSON 片段 |

---

## 流程衔接

| 时机 | 跳转到 | 命令 |
|---|---|---|
| 部署完成，开始创作 | novel-inspiration / novel-chapter | `/novel-inspiration` 或 `/novel-chapter` |
| 市场调研 / 导入 / 学习 | novel-learn | `/novel-learning` |
| 评分优化 | novel-quality | `/novel-quality` |
| 自动管理 | novel-supervisor（自动触发） | 无需手动调用 |

---

## 自动管理机制说明

### 工作原理

```
Writer 产出内容 (novel-chapter / novel-writer / 手动编辑)
    ↓
PostToolUse hook 检测到 Write/Edit → 正文/ 或 设定/
    ↓
Hook 输出指令 → "🔍 内容已更新，启动自动审查"
    ↓
Claude 读取指令 → 调用 novel-supervisor agent
    ↓
Supervisor: 读取世界观 → 调用 novel-checker → 更新追踪 → 生成反馈
    ↓
Supervisor 输出审查报告 → Claude 展示给用户
```

### 防抖机制

- 同一文件在 60 秒内的多次修改，只触发一次审查
- 锁文件：`.claude/.supervisor-lock`
- 审查完成后自动清除

### 与 novel-chapter 的集成

- novel-chapter 每完成一章，PostToolUse hook 自动触发 supervisor
- supervisor 负责更新进度、伏笔、世界观、写作反馈
- novel-chapter 的阶段六可以简化（supervisor 接管大部分工作）

### 反馈循环

```
正文生成 → 自动审查 → 写作反馈 → 下一章读取反馈 → 正文生成
    ↑                                              ↓
    └──────────────────────────────────────────────┘
```

写作反馈文件 `追踪/写作反馈.md` 是管理→写作的核心桥梁。novel-chapter 在生成正文前必须读取此文件，将反馈中的高频问题、角色注意事项、伏笔预警等作为写作约束。
