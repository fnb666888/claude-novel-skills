# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

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
