# Claude Novel Skills

> 一套完整的 Claude Code 小说创作技能包，以**去耦合化的角色特点×情节元素**为核心方法，围绕**学习、写作、管理**三大支柱构建。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Skills-blueviolet)](https://claude.ai/code)

[English](#english) | [中文](#中文)

---

## 中文

### 核心理念：去耦合化创作

传统写法是"选一个高冷型女主，按套路写"。本系统的核心理念是：

> **角色特点和情节元素是独立的维度，可以自由组合。**

```
角色表现 = 个性类型 × 情绪状态 × 行为动作 × 语言风格
章节内容 = 事件类型 × 事件风格 × 场景氛围 × 角色特点
```

**两个分类库**（`novel-writing/references/`）：

| 分类库 | 维度 | 规模 |
|--------|------|------|
| `character-traits.md` | 个性类型(16) × 情绪状态(16) × 行为动作(7类40+) × 语言风格(18) | 90+ 独立元素 |
| `plot-elements.md` | 事件类型(20) × 事件风格(14) × 场景氛围(13) | 47 独立元素 |

**效果**：同一个"高冷型"角色，在不同场景可以展现完全不同的一面——害羞时咬唇、愤怒时握拳、好奇时追问。角色不再是一张脸谱，而是一个多面体。

```
场景1：高冷型 × 害羞情绪 × 咬唇行为 × 惜字如金语言 → 意外的可爱
场景2：高冷型 × 愤怒行为 × 握拳行为 × 毒舌语言 → 爆发的张力
场景3：高冷型 × 好奇情绪 × 追问行为 × 偶尔话多语言 → 难得的柔软
```

**分类库可扩展**：通过 `/novel-learn` 分析小说，自动提取新的角色特点和情节元素，存入 `extensions/` 目录供后续创作使用。

### 三支柱架构

```
┌──────────────────────────────────────────────────────────────┐
│                    📚 学习 Learning                           │
│  novel-learn  ← 市场调研 + 小说分析 + 逆向导入 + 元素扩展      │
│                  ↓ 提取去耦合元素到 extensions/                │
├──────────────────────────────────────────────────────────────┤
│                    ✍️ 写作 Writing                             │
│  novel-inspiration → novel-outline → novel-chapter            │
│  novel-quality(评分优化，含去耦合化重组)  novel-deslop(去AI味)   │
├──────────────────────────────────────────────────────────────┤
│                    🔧 共享基础 + 自动管理                      │
│  novel-setup(部署+管理)  novel-writing(技法库+分类库)           │
│  novel-supervisor(自动审查，含去耦合化建议)                     │
└──────────────────────────────────────────────────────────────┘
```

**数据流**：
```
novel-learn(分析小说) → extensions/(新元素) → novel-inspiration(组合创意)
→ novel-outline(组合大纲) → novel-chapter(组合正文) → novel-quality(评估+去耦合化重组)
                                                                    ↓
novel-supervisor(自动审查+反馈) ← PostToolUse hook ← 正文/设定文件变更
```

### 技能一览（8 个）

#### 📚 学习支柱
| 技能 | 命令 | 说明 |
|------|------|------|
| 学习入口 | `/novel-learn` | 市场调研 / 小说分析(12维度+去耦合元素提取) / 逆向导入 |

#### ✍️ 写作支柱
| 技能 | 命令 | 说明 |
|------|------|------|
| 灵感迭代 | `/novel-inspiration` | 去耦合化组合生成 9.0+ 级创意（角色特点×情节元素自由组合） |
| 大纲生成 | `/novel-outline` | 两阶段：全书大纲(8段式) → 章节大纲(10章/批)，每阶段使用去耦合组合 |
| 章节写作 | `/novel-chapter` | 单章精写(9.0+) / `--batch` 批量模式(8.5+)，逐场景选取去耦合组合 |
| 评分优化 | `/novel-quality` | 三量表评分(含去耦合多样性维度) + 靶向优化(去耦合化重组策略) |
| 去 AI 味 | `/novel-deslop` | 6 Gate 扫描 + 3 遍修复，消除 AI 写作痕迹 |

#### 🔧 共享基础 + 自动管理
| 技能 | 命令 | 说明 |
|------|------|------|
| 部署+管理 | `/novel-setup` | 基础设施部署 + 项目自动管理（世界观/一致性/伏笔/进度/备份） |
| 写作技法库 | `/novel-writing` | 核心技法(A-人物/B-情节/C-正文/D-反面教材) + 去耦合分类库 + 扩展库 |

### 自动管理系统

系统通过 **PostToolUse hook + novel-supervisor agent** 自动审查所有写作产出，无需手动调用。

```
Writer 产出内容 → hook 检测 → supervisor 审查(6维度) → 反馈+去耦合建议 → 下一章读取反馈
```

- 每当 `正文/` 或 `设定/` 文件被修改，自动触发 **6 维度一致性检查**
- 自动更新追踪文件（进度/伏笔/时间线）
- 自动生成写作反馈（`追踪/写作反馈.md`），含**去耦合化组合建议**

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
- 部署 CLAUDE.md 项目配置（含去耦合化创作架构说明）
- 安装 hooks（会话开始/结束、提交检查、内容审查、压缩恢复）
- 安装 rules（格式/叙事/管理规范，含去耦合化创作规范）
- 配置 agents（6 个专业 agent，均接入去耦合分类库）

#### 创作流程

```
/novel-learn --调研        # 1. 市场调研，确定题材
  ↓
/novel-inspiration         # 2. 去耦合化组合生成核心创意
  ↓
/novel-outline             # 3. 去耦合化组合生成全书大纲 + 章节大纲
  ↓
/novel-chapter --batch     # 4. 批量创作正文（逐场景选取去耦合组合，自动触发审查+反馈）
  ↓
/novel-setup 检查          # 5. 手动一致性检查（可选，通常自动执行）
```

### 目录结构

```
claude-novel-skills/
├── novel-chapter/           # 章节写作（单章 + 批量模式）
├── novel-deslop/            # 去 AI 味
│   └── references/          # 禁用词表 & 反 AI 写作参考
├── novel-inspiration/       # 灵感迭代（去耦合化组合）
├── novel-learn/             # 学习入口（市场调研 + 小说分析 + 去耦合元素提取）
│   ├── references/          # 趋势分析 & 结构映射参考
│   └── scripts/             # 各平台榜单爬虫脚本
├── novel-outline/           # 大纲生成（全书 + 章节，两阶段，去耦合化组合）
├── novel-quality/           # 评分与优化（含去耦合多样性维度 + 去耦合化重组策略）
├── novel-setup/             # 部署 + 项目自动管理
│   └── references/templates/
│       ├── agents/          # 6 个专业 agent 定义（均接入去耦合分类库）
│       ├── hooks/           # 6 个 hook 脚本 + 2 个库文件
│       ├── rules/           # 3 个规则文件（含去耦合化创作规范）
│       ├── CLAUDE.md.tmpl   # 项目配置模板（含去耦合架构说明）
│       └── settings-hooks.json
└── novel-writing/           # 核心写作技法库 + 去耦合分类库
    ├── references/
    │   ├── character-traits.md   # 角色特点分类库（4维90+元素）
    │   ├── plot-elements.md      # 情节元素分类库（3维47元素）
    │   ├── module-a-character.md # 角色塑造技法（"怎么写"）
    │   ├── module-b-plot.md      # 情节构造技法（"怎么写"）
    │   ├── module-c-prose.md     # 正文写作技法（"怎么写"）
    │   └── module-d-antipatterns.md # 反面教材
    └── extensions/          # 学习扩展（由 novel-learn 产出的新元素）
```

### Agent 协作体系

部署后，项目中会配置 6 个专业 Agent：

| Agent | 职责 | 模型 | 去耦合化集成 |
|-------|------|------|-------------|
| `novel-architect` | 结构架构师：世界观、大纲、伏笔网络 | opus | 使用 plot-elements.md 选取情节元素组合 |
| `novel-writer` | 文字写手：正文写作、情绪执行 | sonnet | 使用两个分类库，逐场景选取去耦合组合 |
| `novel-character` | 角色设计师：人物创建、对话风格 | sonnet | 使用 character-traits.md 选取四维角色组合 |
| `novel-checker` | 一致性检查员：6 维连续性检查（只读） | haiku | 含去耦合一致性维度 |
| `novel-supervisor` | **自动管理者**：审查 + 追踪 + 反馈 | sonnet | 写作反馈含去耦合化组合建议 |
| `novel-learner` | 学习分析师：市场调研、小说分析、技法提取 | haiku | 提取去耦合元素到 extensions/ |

### 平台支持

`/novel-learn` 的市场调研模式支持以下网文平台：

- 起点中文网（Qidian）
- 番茄小说（Fanqie）
- 晋江文学城（JJWXC）
- 七猫小说（Qimao）
- 刺猬猫（Ciweimao）

---

## English

### Core Philosophy: Decoupled Composition

Traditional writing picks "a cold heroine, then writes by trope." This system's core idea:

> **Character traits and plot elements are independent dimensions, freely combinable.**

```
Character Expression = Personality Type × Emotion State × Behavior Action × Language Style
Chapter Content      = Event Type × Event Style × Scene Atmosphere × Character Traits
```

**Two classification libraries** (`novel-writing/references/`):

| Library | Dimensions | Scale |
|---------|-----------|-------|
| `character-traits.md` | Personality(16) × Emotion(16) × Behavior(7 cat./40+) × Language(18) | 90+ elements |
| `plot-elements.md` | Event Type(20) × Event Style(14) × Scene Atmosphere(13) | 47 elements |

**Result**: The same "cold aloof" character can show completely different sides across scenes — shy lip-biting, angry fist-clenching, curious追问. Characters become multidimensional, not flat archetypes.

**Extensible**: `/novel-learn` analyzes novels and auto-extracts new traits and elements into `extensions/` for future use.

### Three-Pillar Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                    📚 Learning                                │
│  novel-learn ← Market research + Novel analysis + Import      │
│                 + Decoupled element extraction to extensions/  │
├──────────────────────────────────────────────────────────────┤
│                    ✍️ Writing                                  │
│  novel-inspiration → novel-outline → novel-chapter            │
│  novel-quality(eval + decoupled recomposition)                │
│  novel-deslop(de-AI)                                          │
├──────────────────────────────────────────────────────────────┤
│                    🔧 Base + Auto-Management                  │
│  novel-setup(deploy+manage)  novel-writing(tech+libraries)    │
│  novel-supervisor(auto-review with decoupled suggestions)     │
└──────────────────────────────────────────────────────────────┘
```

### Skills Overview (8 skills)

| Pillar | Skill | Command | Description |
|--------|-------|---------|-------------|
| 📚 Learn | Learn | `/novel-learn` | Market research / Novel analysis (12 dims + decoupled extraction) / Reverse import |
| ✍️ Write | Inspiration | `/novel-inspiration` | Decoupled combination for 9.0+ ideas |
| ✍️ Write | Outline | `/novel-outline` | Two-phase: full outline → chapter outlines, decoupled at each phase |
| ✍️ Write | Chapter | `/novel-chapter` | Single chapter (9.0+) / `--batch` mode (8.5+), per-scene decoupled selection |
| ✍️ Write | Quality | `/novel-quality` | 3-scale eval (with decoupled diversity dimension) + optimization (decoupled recomposition) |
| ✍️ Write | Deslop | `/novel-deslop` | 6-gate scan + 3-pass repair for AI artifact removal |
| 🔧 Base | Setup+Manage | `/novel-setup` | Infrastructure deployment + automatic project management |
| 🔧 Base | Writing | `/novel-writing` | Core techniques + decoupled classification libraries + extensions |

### Automatic Management

The system automatically reviews all writer output via **PostToolUse hook + novel-supervisor agent**:

```
Writer produces → hook detects → supervisor reviews (6 dims) → feedback + decoupled suggestions → next chapter reads feedback
```

- Auto-triggers **6-dimension consistency checks** when prose or settings files are modified
- Auto-updates tracking files (progress/foreshadowing/timeline)
- Auto-generates writing feedback with **decoupled composition suggestions**

### Installation

```bash
git clone https://github.com/fnb666888/claude-novel-skills.git
cd claude-novel-skills
cp -r novel-* ~/.claude/skills/
```

### Usage

```bash
cd /path/to/your/novel-project
/novel-setup              # Deploy project infrastructure + enable auto-management
/novel-learn --调研        # Market research
/novel-inspiration        # Generate ideas with decoupled combinations
/novel-outline            # Create full + chapter outlines with decoupled combinations
/novel-chapter --batch    # Generate full book (per-scene decoupled selection, auto-triggers review)
```

### Agent Collaboration

| Agent | Role | Model | Decoupled Integration |
|-------|------|-------|----------------------|
| `novel-architect` | Structure architect | opus | Selects plot element combinations from plot-elements.md |
| `novel-writer` | Prose writer | sonnet | Uses both libraries, per-scene decoupled selection |
| `novel-character` | Character designer | sonnet | Uses character-traits.md for 4-dimension character combinations |
| `novel-checker` | Consistency checker (read-only) | haiku | Includes decoupled consistency dimension |
| `novel-supervisor` | Auto-manager | sonnet | Writing feedback includes decoupled composition suggestions |
| `novel-learner` | Learning analyst | haiku | Extracts decoupled elements to extensions/ |

### Platform Support

`/novel-learn` market research supports:

- Qidian (起点中文网)
- Fanqie (番茄小说)
- JJWXC (晋江文学城)
- Qimao (七猫小说)
- Ciweimao (刺猬猫)

## License

[MIT](LICENSE)
