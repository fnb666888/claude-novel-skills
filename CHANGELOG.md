# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [6.0.0] - 2026-06-01

### 精简：删除市场调研、部署模板和设置模式

根据用户反馈，删除不需要的功能，精简为学习+写作两大模式。

#### 删除
- **市场调研** - 删除学习模式中的市场调研功能
- **scripts/** - 删除爬虫脚本目录
- **templates/** - 删除部署模板目录（hooks、agents、rules）
- **tools/references/** - 删除参考资料目录
- **设置模式** - 删除整个设置模式（部署、世界观、检查、伏笔、进度等）

#### 变更
- **SKILL.md** - 从三大模式精简为两大模式（学习+写作）
- **README.md** - 更新文档，移除市场调研和设置模式相关内容

#### 保留
- **学习模式** - 小说分析功能（12维度分析）
- **写作模式** - 灵感、大纲、正文、全流程
- **工具集** - techniques/、decoupled/、extensions/
- **规则集** - output-rules.md、quality-rules.md、deslop-rules.md、check-rules.md

---

## [5.0.0] - 2026-06-01

### 重构：单一入口 + 工具化架构

将 8 个独立 skill 合并为单一入口 `/novel`，其他内容重构为工具集和规则集。

#### 新增
- **SKILL.md** - 唯一skill入口，整合学习、写作、设置三大模式
- **tools/** - 工具集目录
  - `tools/techniques/` - 写作技法（模块A/B/C/D）
  - `tools/decoupled/` - 去耦合分类库（角色特点、情节元素）
  - `tools/extensions/` - 学习扩展目录
  - `tools/references/` - 参考资料
- **rules/** - 规则集目录
  - `rules/output-rules.md` - 输出规则
  - `rules/quality-rules.md` - 评分优化规则
  - `rules/deslop-rules.md` - 去AI味规则
  - `rules/check-rules.md` - 检查系统规则
  - `rules/banned-words.md` - 禁用词表
  - `rules/anti-ai-writing.md` - 反AI写作参考

#### 变更
- **架构** - 从8个独立skill重构为单一入口+工具化架构
- **入口** - 统一为 `/novel` 命令，内部路由到学习/写作/设置模式
- **学习模式** - 整合原 novel-learn 的市场调研和小说分析功能
- **写作模式** - 整合原 novel-inspiration、novel-outline、novel-chapter
- **设置模式** - 整合原 novel-setup 的部署和管理功能

#### 删除
- **novel-learn/** - 功能合并到学习模式
- **novel-writing/** - 内容移动到 tools/techniques/ 和 tools/decoupled/
- **novel-inspiration/** - 功能合并到写作-灵感子模式
- **novel-outline/** - 功能合并到写作-大纲子模式
- **novel-chapter/** - 功能合并到写作-正文子模式
- **novel-quality/** - 规则提取到 rules/quality-rules.md
- **novel-deslop/** - 规则提取到 rules/deslop-rules.md
- **novel-setup/** - 功能合并到设置模式，模板移动到 templates/

#### 架构优势
- **简化入口**：用户只需记住 `/novel` 一个命令
- **清晰分层**：工具、规则、模板各司其职
- **完美闭环**：学习→工具→写作→规则→输出
- **易于扩展**：新功能只需添加到对应目录

---

## [2.1.0] - 2026-05-31

### 重构：自动管理系统

将 novel-manage 合并到 novel-setup，实现写作产出的自动审查。

#### 新增
- **novel-supervisor agent** - 自动管理者，被 PostToolUse hook 触发，负责一致性检查 + 追踪更新 + 反馈生成
- **post-content-review.sh hook** - PostToolUse hook，检测正文/设定文件变更并触发 supervisor
- **novel-manager-rule.md** - 合并原 novel-manage-rule + novel-consistency-rule

#### 变更
- **novel-setup** - 完全重写：基础设施部署 + 项目管理子命令（世界观/检查/伏笔/进度/结构/备份/迁移）
- **settings-hooks.json** - 新增 PostToolUse hook 注册（Write/Edit 触发）
- **CLAUDE.md.tmpl** - 更新路由表、协作规则、Agent 列表
- **session-start.sh** - 增强：伏笔预警、超期警告、反馈状态

#### 删除
- **novel-manage/** - 功能已合并到 novel-setup
- novel-manage-rule.md（→ novel-manager-rule.md）
- novel-consistency-rule.md（→ novel-manager-rule.md）

#### 自动管理机制
- PostToolUse hook 检测 Write/Edit → 正文/ 或 设定/
- hook 输出指令 → Claude 调用 novel-supervisor
- supervisor: 读取世界观 → 调用 checker → 更新追踪 → 生成反馈
- 60秒防抖锁防止重复触发

---

## [2.0.0] - 2026-05-31

### 重构：三支柱架构

围绕**学习、写作、管理**三大支柱重组项目，15 个 skill 合并精简为 9 个。

#### 新增
- **novel-quality** - 合并原 novel-evaluation + novel-optimization，统一评分三量表 + 靶向优化 + 读者模拟
- **novel-manage** - 合并原 novel-worldbuilding + novel-consistency，新增伏笔管理、进度追踪、项目维护
- **novel-learner** agent - 替代原 novel-explorer，职责扩展为市场调研 + 小说分析 + 技法提取

#### 变更
- **novel-learn** - 吸收 novel-scan（市场调研）+ novel-import（逆向导入），三模式合一
- **novel-outline** - 吸收 novel-chapter-outline，两阶段设计（全书大纲 + 章节大纲）
- **novel-chapter** - 吸收 novel-batch，单章 + `--batch` 批量双模式
- **novel-setup** - 更新 agents(5个)、hooks(5个)、rules(4个)、CLAUDE.md 模板
- **novel-inspiration** - 更新引用路径（novel-quality、novel-manage）
- **novel-deslop** - 更新引用路径
- **novel-writing** - 无变更

#### 删除
- novel-scan（→ novel-learn）
- novel-import（→ novel-learn）
- novel-chapter-outline（→ novel-outline）
- novel-batch（→ novel-chapter）
- novel-evaluation（→ novel-quality）
- novel-optimization（→ novel-quality）
- novel-worldbuilding（→ novel-manage）
- novel-consistency（→ novel-manage）

#### 基础设施变更
- Agent: novel-explorer → novel-learner
- Hook: detect-novel-gaps.sh 合并到 session-start.sh
- Rule: novel-outline.md 合并到 novel-format.md
- Rule: 新增 novel-manage-rule.md

---

## [1.0.0] - 2026-05-31

### Added

#### Core Skills (15)
- **novel-inspiration** - 迭代灵感生成系统，头脑风暴 + 网搜 + 评分优化至 9.0+
- **novel-outline** - 8 段式完整大纲生成，迭代优化
- **novel-chapter-outline** - 章节大纲批量生成（每 10 章一批），含节奏评分
- **novel-chapter** - 正文写作 6 阶段流水线（构思→调研→写作→评估→优化→分析）
- **novel-batch** - 批量创作工具，支持断点续写与进度追踪
- **novel-writing** - 核心写作技法库（A-人物塑造 / B-情节构建 / C-文字写作 / D-反面教材）
- **novel-evaluation** - 三层量化评估系统（目标达成 40% + 阅读体验 40% + 技法执行 20%）
- **novel-optimization** - 吸引力优化系统（亲密度、幽默感、惊喜感等维度）
- **novel-deslop** - AI 写作痕迹消除系统（6 门扫描 + 3 遍修复）
- **novel-consistency** - 5 维连续性检查（人物/伏笔/时间线/关系/世界观）
- **novel-worldbuilding** - 世界观管理工具（8 部分标准设定文档）
- **novel-learn** - 深度学习工具，阅读完整小说并输出扩展技法
- **novel-import** - 逆向导入工具，从已有文本构建项目结构
- **novel-scan** - 市场调研工具，爬取主流网文平台榜单数据
- **novel-setup** - 一键环境部署（hooks / rules / agents / CLAUDE.md）

#### Infrastructure
- 5 个专业 Agent 定义（architect / writer / character / checker / explorer）
- 6 个 Hook 脚本（会话管理、提交检查、压缩恢复）
- 4 个 Rule 文件（格式/叙事/一致性/大纲规范）
- CLAUDE.md 项目配置模板
- 5 个网文平台榜单爬虫脚本（起点/番茄/晋江/七猫/刺猬猫）
