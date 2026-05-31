# Claude Novel Skills

> 一套完整的 Claude Code 小说创作技能包，涵盖从灵感构思到批量成书的全流程。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Skills-blueviolet)](https://claude.ai/code)

[English](#english) | [中文](#中文)

---

## 中文

### 简介

Claude Novel Skills 是一组为 [Claude Code](https://claude.ai/code) 设计的 slash command 技能包，帮助你用 AI 辅助完成网络小说的全流程创作。支持起点、番茄、晋江、七猫、刺猬猫等主流网文平台的数据分析。

### 技能一览

| 技能 | 类型 | 命令 | 说明 |
|------|------|------|------|
| 灵感迭代 | 🎯 | `/novel-inspiration` | 头脑风暴 + 网搜 + 评分优化，生成 9.0+ 级创意 |
| 大纲生成 | 🎯 | `/novel-outline` | 8 段式完整大纲，迭代优化至 9.0+ |
| 章节大纲 | 🎯 | `/novel-chapter-outline` | 每 10 章为一批，含节奏评分与优化 |
| 正文写作 | 🎯 | `/novel-chapter` | 6 阶段流水线：构思→调研→写作→评估→优化→分析 |
| 批量创作 | 🎯 | `/novel-batch` | 从大纲自动全书创作，支持断点续写 |
| 写作技法库 | 📚 | `/novel-writing` | 核心技法：A-人物塑造 / B-情节构建 / C-文字写作 / D-反面教材 |
| 世界观管理 | 📚 | `/novel-worldbuilding` | 8 部分标准世界设定文档，统一管理 |
| 评估系统 | 🔧 | `/novel-evaluation` | 三层量化评分：目标达成 40% + 阅读体验 40% + 技法执行 20% |
| 吸引力优化 | 🔧 | `/novel-optimization` | 针对亲密度、幽默感、惊喜感等维度优化 |
| 去 AI 味 | 🔧 | `/novel-deslop` | 6 门扫描 + 3 遍修复，消除 AI 写作痕迹 |
| 一致性检查 | 🔧 | `/novel-consistency` | 5 维连续性检查：人物/伏笔/时间线/关系/世界观 |
| 深度学习 | 🎯 | `/novel-learn` | 阅读完整小说，12 维分析后输出扩展技法到 extensions/ |
| 逆向导入 | 🎯 | `/novel-import` | 从已有小说文本反向构建项目目录结构 |
| 市场调研 | 🎯 | `/novel-scan` | 爬取主流网文平台榜单数据，输出选题决策报告 |
| 环境部署 | 🏗️ | `/novel-setup` | 一键部署 hooks、rules、agents 到小说项目 |

> **类型说明**：🎯 用户技能（用户直接调用）| 📚 技法库（知识库，也可独立使用）| 🔧 工具技能（主要被流水线内部调用）| 🏗️ 基础设施（项目部署配置）

### 快速开始

#### 安装

**方式一：一键安装（推荐）**

```bash
git clone https://github.com/fnb666888/claude-novel-skills.git
cd claude-novel-skills
# 将所有 skill 复制到 Claude Code 技能目录
cp -r novel-* ~/.claude/skills/
```

**方式二：手动安装**

将 `novel-*` 目录逐个复制到 `~/.claude/skills/` 目录下。

#### 部署到小说项目

```bash
# 进入你的小说项目目录
cd /path/to/your/novel-project

# 在 Claude Code 中运行
/novel-setup
```

`/novel-setup` 会自动：
- 创建标准目录结构（设定/大纲/正文/追踪）
- 部署 CLAUDE.md 项目配置
- 安装 hooks（会话开始/结束、提交检查、压缩恢复）
- 安装 rules（格式/叙事/一致性/大纲规范）
- 配置 agents（架构师/写手/角色设计师/检查员/探索者）

#### 创作流程

```
/novel-scan          # 1. 市场调研，确定题材
  ↓
/novel-inspiration   # 2. 迭代灵感，产出核心创意
  ↓
/novel-outline       # 3. 生成完整大纲（8 段式）
  ↓
/novel-worldbuilding # 4. 构建世界观设定
  ↓
/novel-chapter-outline # 5. 分批生成章节大纲
  ↓
/novel-batch         # 6. 批量创作正文（自动调用 /novel-chapter）
  ↓
/novel-consistency   # 7. 一致性检查
  ↓
/novel-deslop        # 8. 去 AI 味优化
```

### 目录结构

```
claude-novel-skills/
├── novel-batch/             # 批量创作
├── novel-chapter/           # 正文写作
├── novel-chapter-outline/   # 章节大纲
├── novel-consistency/       # 一致性检查
├── novel-deslop/            # 去 AI 味
│   └── references/          # 禁用词表 & 反 AI 写作参考
├── novel-evaluation/        # 评估系统
├── novel-import/            # 逆向导入
│   └── references/          # 结构映射 & 格式参考
├── novel-inspiration/       # 灵感迭代
├── novel-learn/             # 深度学习
├── novel-optimization/      # 吸引力优化
├── novel-outline/           # 大纲生成
├── novel-scan/              # 市场调研
│   ├── references/          # 趋势分析 & 读者画像参考
│   └── scripts/             # 各平台榜单爬虫脚本
├── novel-setup/             # 环境部署
│   └── references/templates/
│       ├── agents/          # 5 个专业 agent 定义
│       ├── hooks/           # 6 个 hook 脚本 + 2 个库文件
│       ├── rules/           # 4 个规则文件
│       ├── CLAUDE.md.tmpl   # 项目配置模板
│       └── settings-hooks.json
├── novel-worldbuilding/     # 世界观管理
└── novel-writing/           # 核心写作技法库
```

### Agent 协作体系

部署后，项目中会配置 5 个专业 Agent：

| Agent | 职责 | 模型 |
|-------|------|------|
| `novel-architect` | 结构架构师：世界观、大纲、伏笔网络、节奏控制 | opus |
| `novel-writer` | 文字写手：章节写作、去 AI 味、格式合规 | sonnet |
| `novel-character` | 角色设计师：人物创建、对话风格、关系网络 | sonnet |
| `novel-checker` | 一致性检查员：5 维连续性检查（只读） | haiku |
| `novel-explorer` | 状态查询器：项目进度查询（只读） | haiku |

### 平台支持

`/novel-scan` 支持以下网文平台的榜单数据爬取：

- 起点中文网（Qidian）
- 番茄小说（Fanqie）
- 晋江文学城（JJWXC）
- 七猫小说（Qimao）
- 刺猬猫（Ciweimao）

---

## English

### Introduction

Claude Novel Skills is a comprehensive set of [Claude Code](https://claude.ai/code) slash commands for AI-assisted novel writing. It covers the entire workflow from brainstorming to batch book generation, with built-in market research tools for Chinese web novel platforms.

### Skills Overview

| Skill | Command | Description |
|-------|---------|-------------|
| Inspiration | `/novel-inspiration` | Iterative brainstorming + web search + scoring to generate 9.0+ ideas |
| Outline | `/novel-outline` | 8-part full novel outline with iterative optimization |
| Chapter Outline | `/novel-chapter-outline` | 10-chapter batches with rhythm scoring |
| Chapter Writing | `/novel-chapter` | 6-stage pipeline: brainstorm → research → write → evaluate → optimize → analyze |
| Batch Creation | `/novel-batch` | Automated full-book generation from outline with breakpoint resume |
| Writing Techniques | `/novel-writing` | Core library: A-Character / B-Plot / C-Prose |
| Evaluation | `/novel-evaluation` | 3-tier scoring: goal achievement 40% + reader experience 40% + technique 20% |
| Optimization | `/novel-optimization` | Targets intimacy, humor, surprise, and other attraction dimensions |
| Deslop | `/novel-deslop` | 6-gate scan + 3-pass repair to remove AI writing artifacts |
| Consistency | `/novel-consistency` | 5-dimension continuity: character/foreshadowing/timeline/relationship/world |
| Worldbuilding | `/novel-worldbuilding` | 8-section standard world-setting document |
| Learn | `/novel-learn` | Read full novels, analyze across 12 dimensions, output extensions to technique library |
| Import | `/novel-import` | Reverse-engineer existing novel text into standard project structure |
| Market Scan | `/novel-scan` | Scrape ranking data from Chinese web novel platforms |
| Setup | `/novel-setup` | One-click deployment of hooks, rules, agents to novel project |

### Installation

```bash
git clone https://github.com/fnb666888/claude-novel-skills.git
cd claude-novel-skills
cp -r novel-* ~/.claude/skills/
```

### Usage

```bash
cd /path/to/your/novel-project
# In Claude Code:
/novel-setup          # Deploy project infrastructure
/novel-scan           # Market research
/novel-inspiration    # Generate ideas
/novel-outline        # Create full outline
/novel-batch          # Generate full book
```

## License

[MIT](LICENSE)
