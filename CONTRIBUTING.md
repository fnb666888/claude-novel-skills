# Contributing

感谢你对 Claude Novel Skills 的关注！欢迎贡献代码、报告问题或提出建议。

## 如何贡献

### 报告问题

如果你发现了 bug 或有功能建议，请[创建 Issue](https://github.com/fnb666888/claude-novel-skills/issues/new)。

### 提交代码

1. Fork 本仓库
2. 创建你的特性分支：`git checkout -b feature/amazing-feature`
3. 提交你的更改：`git commit -m 'Add amazing feature'`
4. 推送到分支：`git push origin feature/amazing-feature`
5. 创建 Pull Request

### 开发规范

#### Skill 文件结构

每个 skill 目录应包含：

```
skill-name/
├── SKILL.md          # 必需：技能定义文件（含 frontmatter）
└── references/       # 可选：参考资料
    └── *.md
```

#### SKILL.md 格式

```markdown
---
name: skill-name
description: 一句话描述
---

# 技能标题

技能的完整说明和指令...
```

#### 提交信息格式

使用语义化提交信息：

- `feat: 新增 xxx 技能`
- `fix: 修复 xxx 评分逻辑`
- `docs: 更新 README`
- `refactor: 重构 xxx 模块`
- `chore: 更新爬虫脚本`

### 代码风格

- Shell 脚本使用 `#!/bin/bash`，遵循 [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- JavaScript 脚本保持简洁，添加必要注释
- Markdown 文件使用清晰的层级结构

## 许可证

提交代码即表示你同意你的贡献在 [MIT License](LICENSE) 下发布。
