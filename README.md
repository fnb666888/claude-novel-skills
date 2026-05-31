# Claude Novel Skills

> 一套完整的 Claude Code 小说创作技能包，围绕**学习、写作、管理**三大支柱构建。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Skills-blueviolet)](https://claude.ai/code)

[English](#english) | [中文](#中文)

---

## 中文

### 简介

Claude Novel Skills 是一组为 [Claude Code](https://claude.ai/code) 设计的 slash command 技能包，帮助你用 AI 辅助完成网络小说的全流程创作。支持起点、番茄、晋江、七猫、刺猬猫等主流网文平台的数据分析。

### 三支柱架构

```
┌─────────────────────────────────────────────────────────┐
│                    📚 学习 Learning                      │
│  novel-learn  ← 市场调研 + 小说分析 + 导入 + 技法扩展     │
├─────────────────────────────────────────────────────────┤
│                    ✍️ 写作 Writing                        │
│  novel-inspiration → novel-outline → novel-chapter       │
│  novel-quality(评分优化)  novel-deslop(去AI味)            │
├─────────────────────────────────────────────────────────┤
│                    📁 管理 Management                     │
│  novel-manage  ← 文件组织 + 世界观 + 一致性 + 进度 + 备份  │
├─────────────────────────────────────────────────────────┤
│                    🔧 共享基础                            │
│  novel-writing(技法库)  novel-setup(基础设施)              │
└─────────────────────────────────────────────────────────┘
```

### 技能一览（9 个）

#### 📚 学习支柱
| 技能 | 命令 | 说明 |
|------|------|------|
| 学习入口 | `/novel-learn` | 市场调研 / 小说分析(12维度) / 逆向导入，三模式合一 |

#### ✍️ 写作支柱
| 技能 | 命令 | 说明 |
|------|------|------|
| 灵感迭代 | `/novel-inspiration` | 头脑风暴 + 网搜 + 评分优化，生成 9.0+ 级创意 |
| 大纲生成 | `/novel-outline` | 两阶段：全书大纲(8段式) → 章节大纲(10章/批) |
| 章节写作 | `/novel-chapter` | 单章精写(9.0+) / `--batch` 批量模式(8.5+) |
| 评分优化 | `/novel-quality` | 三量表评分 + 靶向优化 + 读者模拟 |
| 去 AI 味 | `/novel-deslop` | 6 Gate 扫描 + 3 遍修复，消除 AI 写作痕迹 |

#### 📁 管理支柱
| 技能 | 命令 | 说明 |
|------|------|------|
| 项目管理 | `/novel-manage` | 世界观管理 + 一致性检查(5维) + 伏笔追踪 + 进度监控 + 备份 |

#### 🔧 共享基础
| 技能 | 命令 | 说明 |
|------|------|------|
| 写作技法库 | `/novel-writing` | 核心技法：A-人物 / B-情节 / C-正文 / D-反面教材 |
| 环境部署 | `/novel-setup` | 一键部署 hooks、rules、agents 到小说项目 |

### 快速开始

#### 安装

```bash
git clone https://github.com/fnb666888/claude-novel-skills.git
cd claude-novel-skills
cp -r novel-* ~/.claude/skills/
```

#### 部署到小说项目

```bash
cd /path/to/your/novel-project
# 在 Claude Code 中运行
/novel-setup
```

`/novel-setup` 会自动：
- 创建标准目录结构（灵感/大纲/设定/正文/追踪/素材）
- 部署 CLAUDE.md 项目配置（三支柱路由表）
- 安装 hooks（会话开始/结束、提交检查、压缩恢复）
- 安装 rules（格式/叙事/一致性/管理规范）
- 配置 agents（架构师/写手/角色设计师/检查员/学习分析师）

#### 创作流程

```
/novel-learn --调研        # 1. 市场调研，确定题材
  ↓
/novel-inspiration         # 2. 迭代灵感，产出核心创意
  ↓
/novel-outline             # 3. 生成全书大纲 + 章节大纲
  ↓
/novel-chapter --batch     # 4. 批量创作正文（自动评分+去AI味）
  ↓
/novel-manage 检查          # 5. 一致性检查 + 进度追踪
```

### 目录结构

```
claude-novel-skills/
├── novel-chapter/           # 章节写作（单章 + 批量模式）
├── novel-deslop/            # 去 AI 味
│   └── references/          # 禁用词表 & 反 AI 写作参考
├── novel-inspiration/       # 灵感迭代
├── novel-learn/             # 学习入口（市场调研 + 小说分析 + 导入）
│   ├── references/          # 趋势分析 & 结构映射参考
│   └── scripts/             # 各平台榜单爬虫脚本
├── novel-manage/            # 项目管理（世界观 + 一致性 + 伏笔 + 进度）
├── novel-outline/           # 大纲生成（全书 + 章节，两阶段）
├── novel-quality/           # 评分与优化（三量表 + 靶向优化）
├── novel-setup/             # 环境部署
│   └── references/templates/
│       ├── agents/          # 5 个专业 agent 定义
│       ├── hooks/           # 5 个 hook 脚本 + 2 个库文件
│       ├── rules/           # 4 个规则文件
│       ├── CLAUDE.md.tmpl   # 项目配置模板
│       └── settings-hooks.json
└── novel-writing/           # 核心写作技法库
    ├── references/          # 4 个核心模块
    └── extensions/          # 学习扩展（由 novel-learn 产出）
```

### Agent 协作体系

部署后，项目中会配置 5 个专业 Agent：

| Agent | 职责 | 模型 | 归属支柱 |
|-------|------|------|----------|
| `novel-architect` | 结构架构师：世界观、大纲、伏笔网络 | opus | 管理+写作 |
| `novel-writer` | 文字写手：正文写作、情绪执行 | sonnet | 写作 |
| `novel-character` | 角色设计师：人物创建、对话风格 | sonnet | 写作 |
| `novel-checker` | 一致性检查员：5 维连续性检查（只读） | haiku | 管理 |
| `novel-learner` | 学习分析师：市场调研、小说分析、技法提取 | haiku | 学习 |

### 平台支持

`/novel-learn` 的市场调研模式支持以下网文平台：

- 起点中文网（Qidian）
- 番茄小说（Fanqie）
- 晋江文学城（JJWXC）
- 七猫小说（Qimao）
- 刺猬猫（Ciweimao）

---

## English

### Introduction

Claude Novel Skills is a comprehensive set of [Claude Code](https://claude.ai/code) slash commands for AI-assisted novel writing, organized around three pillars: **Learning**, **Writing**, and **Management**.

### Skills Overview (9 skills)

| Pillar | Skill | Command | Description |
|--------|-------|---------|-------------|
| 📚 Learn | Learn | `/novel-learn` | Market research / Novel analysis (12 dims) / Reverse import |
| ✍️ Write | Inspiration | `/novel-inspiration` | Brainstorming + web search + scoring for 9.0+ ideas |
| ✍️ Write | Outline | `/novel-outline` | Two-phase: full outline → chapter outlines (10/batch) |
| ✍️ Write | Chapter | `/novel-chapter` | Single chapter (9.0+) / `--batch` mode (8.5+) |
| ✍️ Write | Quality | `/novel-quality` | 3-scale evaluation + targeted optimization + reader simulation |
| ✍️ Write | Deslop | `/novel-deslop` | 6-gate scan + 3-pass repair for AI artifact removal |
| 📁 Manage | Manage | `/novel-manage` | Worldbuilding + consistency (5D) + foreshadowing + progress |
| 🔧 Base | Writing | `/novel-writing` | Core library: A-Character / B-Plot / C-Prose / D-Antipatterns |
| 🔧 Base | Setup | `/novel-setup` | One-click deployment of hooks, rules, agents |

### Installation

```bash
git clone https://github.com/fnb666888/claude-novel-skills.git
cd claude-novel-skills
cp -r novel-* ~/.claude/skills/
```

### Usage

```bash
cd /path/to/your/novel-project
/novel-setup              # Deploy project infrastructure
/novel-learn --调研        # Market research
/novel-inspiration        # Generate ideas
/novel-outline            # Create full + chapter outlines
/novel-chapter --batch    # Generate full book
/novel-manage 检查         # Consistency check + progress tracking
```

## License

[MIT](LICENSE)
