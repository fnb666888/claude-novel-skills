# Claude Novel Skills

> 小说创作统一系统——单一入口 `/novel` 整合学习、写作、设置三大模式，以**去耦合化的角色特点×情节元素**为核心方法。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Skills-blueviolet)](https://claude.ai/code)

---

## 核心架构

```
/novel（单一入口）
├── 学习模式 → 市场调研 / 小说分析 → 输出到工具集
├── 写作模式 → 灵感 → 大纲 → 正文（可全流程）
│   └── 调用工具集 + 遵守规则集
└── 设置模式 → 部署管理 / 世界观 / 一致性检查
```

### 工具集（tools/）

| 目录 | 内容 | 用途 |
|------|------|------|
| `tools/techniques/` | 写作技法（模块A/B/C/D） | 创作方法论 |
| `tools/decoupled/` | 去耦合分类库 | 角色特点×情节元素 |
| `tools/extensions/` | 学习扩展 | 由学习模式产出 |
| `tools/references/` | 参考资料 | 市场调研等 |

### 规则集（rules/）

| 文件 | 内容 | 用途 |
|------|------|------|
| `rules/output-rules.md` | 输出规则 | 文件格式和路径 |
| `rules/quality-rules.md` | 评分规则 | 评价标准和优化策略 |
| `rules/deslop-rules.md` | 去AI味规则 | 6 Gate + 三遍法 |
| `rules/check-rules.md` | 检查规则 | 角色和情节一致性 |

---

## 核心理念：去耦合化创作

传统写法是"选一个高冷型女主，按套路写"。本系统的核心理念是：

> **角色特点和情节元素是独立的维度，可以自由组合。**

```
角色表现 = 个性类型 × 情绪状态 × 行为动作 × 语言风格
章节内容 = 事件类型 × 事件风格 × 场景氛围 × 角色特点
```

**效果**：同一个"高冷型"角色，在不同场景可以展现完全不同的一面——害羞时咬唇、愤怒时握拳、好奇时追问。角色不再是一张脸谱，而是一个多面体。

---

## 核心体验极端化

**好小说不是各维度都高分，而是某个维度做到极致。**

| 核心体验 | 极端化标准 |
|----------|-----------|
| 暧昧感 | 让读者脸红心跳，反复回味 |
| 诱惑力 | 让读者血脉贲张，欲罢不能 |
| 悲伤感 | 让读者泪流不止，久久不能释怀 |
| 笑点密度 | 让读者笑出声来，停不下来 |
| 悬念感 | 让读者猜不到结局，欲罢不能 |
| 热血感 | 让读者热血沸腾，握紧拳头 |
| 甜蜜度 | 让读者甜到牙疼，嘴角上扬 |
| 治愈感 | 让读者感到温暖，内心平静 |

---

## 使用方式

### 安装

```bash
git clone https://github.com/fnb666888/claude-novel-skills.git
cd claude-novel-skills
cp SKILL.md ~/.claude/skills/novel/SKILL.md
cp -r tools rules templates scripts ~/.claude/skills/novel/
```

### 部署到小说项目

```bash
cd /path/to/your/novel-project
# 在 Claude Code 中运行
/novel 设置 部署
```

### 创作流程

```
/novel 学习 市场调研        # 1. 市场调研，确定题材
/novel 学习 [小说文件]      # 2. 分析小说，提取技法
/novel 灵感                 # 3. 去耦合化组合生成核心创意
/novel 大纲                 # 4. 生成全书大纲 + 章节大纲
/novel 正文 --batch         # 5. 批量创作正文
/novel 设置 检查            # 6. 一致性检查（可选，通常自动执行）
```

### 全流程模式

```
/novel 全流程               # 自动串联：灵感→大纲→正文
```

---

## 目录结构

```
claude-novel-skills/
├── SKILL.md                    # 唯一skill入口（/novel）
├── tools/                      # 工具集
│   ├── techniques/             # 写作技法
│   │   ├── module-a-character.md
│   │   ├── module-b-plot.md
│   │   ├── module-c-prose.md
│   │   └── module-d-antipatterns.md
│   ├── decoupled/              # 去耦合分类库
│   │   ├── character-traits.md
│   │   └── plot-elements.md
│   ├── extensions/             # 学习扩展
│   │   ├── characters/
│   │   ├── plot/
│   │   └── prose/
│   └── references/             # 参考资料
├── rules/                      # 规则集
│   ├── output-rules.md         # 输出规则
│   ├── quality-rules.md        # 评分规则
│   ├── deslop-rules.md         # 去AI味规则
│   ├── banned-words.md         # 禁用词表
│   ├── anti-ai-writing.md      # 反AI写作参考
│   └── check-rules.md          # 检查规则
├── templates/                  # 模板
│   ├── CLAUDE.md.tmpl
│   ├── hooks/
│   ├── rules/
│   ├── agents/
│   └── settings-hooks.json
├── scripts/                    # 爬虫脚本
├── README.md
├── CHANGELOG.md
├── CONTRIBUTING.md
└── LICENSE
```

---

## 闭环工作流

```
学习模式 → tools/extensions/ → 写作模式读取
    ↓
写作模式 → 遵守 rules/ → 调用 tools/ → 输出正文
    ↓
设置模式 → 部署 templates/ → 配置项目 → 自动检查
```

---

## 自动管理系统

系统通过 **PostToolUse hook** 自动审查所有写作产出，无需手动调用。

```
Writer 产出内容 → hook 检测 → 自动检查（五维度） → 反馈生成 → 下一章读取反馈
```

- 每当 `正文/` 或 `设定/` 文件被修改，自动触发 **五维度一致性检查**
- 自动生成写作反馈（`追踪/写作反馈.md`），供后续章节参考

---

## Agent 协作体系

部署后，项目中会配置 6 个专业 Agent：

| Agent | 职责 | 模型 |
|-------|------|------|
| `novel-architect` | 结构架构师：世界观、大纲、伏笔网络 | opus |
| `novel-writer` | 文字写手：正文写作、情绪执行 | sonnet |
| `novel-character` | 角色设计师：人物创建、对话风格 | sonnet |
| `novel-checker` | 一致性检查员：5维度连续性检查 | haiku |
| `novel-supervisor` | 自动管理者：审查 + 追踪 + 反馈 | sonnet |
| `novel-learner` | 学习分析师：市场调研、小说分析、技法提取 | haiku |

---

## 平台支持

市场调研模式支持以下网文平台：

- 起点中文网（Qidian）
- 番茄小说（Fanqie）
- 晋江文学城（JJWXC）
- 七猫小说（Qimao）
- 刺猬猫（Ciweimao）

---

## License

[MIT](LICENSE)
