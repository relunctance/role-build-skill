---
name: role-build-skill
description: 专家角色构建器 — 分析专家领域与问题，评估并安装所需 skills，在 exp-roles 中注册角色，更新 gql-skills 索引
triggers:
  - 创建专家角色
  - 构建一个新专家
  - 新建角色
  - 创建一个角色
  - 需要一个专家
  - 添加专家角色
category: Infrastructure
author: relunctance
created: 2026-05-15
updated: 2026-05-15
version: "1.0.0"
tags:
  - role
  - expert
  - exp-roles
  - skill-installation
platforms:
  all: true
---

# role-build-skill

> 分析专家擅长的领域和问题，评估并安装所需 skills，在 exp-roles 注册角色，更新 gql-skills 总览索引

## 触发条件

用户说：
- 创建一个专家角色
- 构建一个新专家
- 新建角色
- 创建一个角色
- 需要一个 {岗位} 专家
- 添加专家角色

## 核心流程

```
用户说"创建一个{角色}" 
  → 分析专家领域 + 适用场景
  → 搜索合适 skill（find-skills）
  → 缺失 skill → skill-created 新建 stub
  → 安装 skill 到专家身上
  → 在 exp-roles 创建角色定义
  → 校验角色（validate_role.py）
  → 更新 exp-roles README
  → 更新 gql-skills 索引
  → 全部推送 GitHub
```

---

## 第一步：分析专家画像

### 与用户确认专家信息

```markdown
## 🎯 专家画像分析

**角色名称**: {角色名（英文-连字符格式）}
**显示名称**: {中文显示名}
**类型**: executor | reviewer | coordinator | observer
**层级**: specialist | generalist | lead

### 核心职责
1. **职责1** - 描述
2. **职责2** - 描述

### 适用场景
- 场景1
- 场景2

### 工作方式
- 原则1：描述
- 原则2：描述

### 协作方式
- 与 {角色A} 协作：描述
- 与 {角色B} 协作：描述

### 约束和限制
- 限制1
- 限制2

请确认专家画像是否准确，或补充调整。
```

---

## 第二步：Skill 搜索与评估

### 调用 find-skills 搜索（重要！）

**必须使用 find-skills 搜索合适的 skill，不能凭感觉手写。**

1. **提取关键词** — 根据专家的职责、工作方式和能力要求，提取 2-3 个核心功能关键词
2. **调用 find-skills** — 使用 `skill_view(name='find-skills')` 加载 skill，搜索 8 大 skill 仓库（Hermes Hub、gql-skills、Superpowers、ClawHub 等）
3. **Health Score 过滤** — 优先推荐 70+ 分（绿色）的 skill，40-69 分（黄色）需人工确认，<40 分（红色）不推荐
4. **与用户确认** — 以表格形式展示推荐结果，标注 Health Score、来源平台、一句话描述，让用户选择

### Skill 推荐展示格式

```markdown
🔍 **Skill 检索：「{关键词1}」「{关键词2}」**

| # | Skill 名称 | Health Score | 来源 | 描述 | 推荐级别 |
|---|-----------|-------------|------|------|---------|
| 1 | systematic-debugging | 🟢 85/100 | Superpowers | 4阶段根因调试 | ⭐ 强烈推荐 |
| 2 | verification-before-completion | 🟢 82/100 | Superpowers | 完成前验证闭环 | ⭐ 强烈推荐 |
| 3 | writing-plans | 🟡 62/100 | Superpowers | 实现计划编写 | 可选 |

请确认要加入哪些 skill？可回复编号（如 1,3）或"全部推荐"
```

### Skill 分类建议

| 角色类型 | 推荐优先搜索的 skill 方向 |
|---------|----------------------|
| executor | 调试、TDD、代码审查、实现计划 |
| reviewer | 代码审查、验证、架构评审 |
| coordinator | 计划、沟通、风险识别 |
| observer | 监控、日志分析、报告生成 |

---

## 第三步：处理缺失 Skill

### 已有 Skill → 直接安装

已有的 skill 记录其名称和 source（superpowers/git），不需要 clone。

### 缺失 Skill → 用 skill-created 新建 stub

```markdown
## 🔧 发现缺失 Skill：{skill-name}

该 skill 不存在，需要先创建 stub：

1. 使用 `skill_created` 创建标准化 skill 仓库
2. 仓库名称：{skill-name}
3. 描述：{一句话描述}
4. 创建后，在该 skill 仓库添加 `.opencode/plugins/` 入口
5. 将新 skill 安装到当前专家身上
```

**使用 skill_created 创建**：

```bash
# 克隆 skill-created
git clone https://github.com/relunctance/skill-created.git /tmp/skill-created

# 使用 skill_created 创建 stub
cd /tmp/skill-created
# 手动执行创建命令（因为 skill_created 本身是 skill，非可执行脚本）
# 实际执行：直接创建标准化仓库结构
```

### Skill source 判断规则

| 来源 | source | 说明 |
|------|--------|------|
| Superpowers 生态 | `superpowers` | obra/superpowers 生态内的 skill |
| 外部 Git 仓库 | `git` | 需要提供 url 字段 |

---

## 第四步：在 exp-roles 创建角色定义

### 目录结构

```
exp-roles/
└── roles/
    └── {role-name}/           # 与 config.yaml name 一致
        ├── SKILL.md           # 角色详细说明
        ├── config.yaml        # 角色配置
        └── required_skills.txt # 必需的 skills 列表
```

### 4.1 创建目录

```bash
mkdir -p exp-roles/roles/{role-name}
```

### 4.2 编写 config.yaml

```yaml
name: {role-name}
display_name: {显示名称}
description: {一句话描述}

attributes:
  type: {executor|reviewer|coordinator|observer}
  tier: {specialist|generalist|lead}

skills:
  required:
    - name: {skill-1}
      source: {superpowers|git}
      url: {可选，仅 source=git 时}
    - name: {skill-2}
      source: {superpowers|git}
  optional:
    - name: {optional-skill}
      source: {superpowers|git}

applicable_phases:
  - execute
  - review
  - verify
  - release

capabilities:
  - 能力1
  - 能力2
```

### 4.3 编写 required_skills.txt

```txt
# 必需的 skills 列表
# 格式: skill-name  # source: superpowers | git [url: https://...]
{skill-1}  # source: {superpowers|git}
{skill-2}  # source: {superpowers|git}
```

### 4.4 编写 SKILL.md

```markdown
# {显示名称}

## 角色职责

{一句话描述角色定位}

## 核心职责

1. **职责1** - 描述
2. **职责2** - 描述
3. **职责3** - 描述

## 适用场景

- 场景1
- 场景2

## 工作方式

1. **原则1** - 描述
2. **原则2** - 描述

## 协作方式

- 与 {角色A} 协作：描述
- 与 {角色B} 协作：描述

## 约束和限制

- 限制1
- 限制2
```

---

## 第五步：校验角色

### 运行 validate_role.py

```bash
cd exp-roles
python3 validators/validate_role.py roles/{role-name}
```

常见错误及修复：

| 错误 | 修复方式 |
|------|---------|
| name 与目录名不一致 | config.yaml name 改为与目录名一致 |
| missing required section | SKILL.md 补充缺失的章节 |
| skill source 不合法 | source 只能是 `superpowers` 或 `git` |
| skills 不一致 | config.yaml 和 required_skills.txt 必须完全一致 |

---

## 第六步：更新 exp-roles README

### 在"已有角色"表格追加新角色

```markdown
| {role-name} | {说明} | {type} | {tier} |
```

---

## 第七步：更新 gql-skills

### 在 gql-skills/SKILL.md 中追加新角色索引

在 Infrastructure 或对应分类下添加：

```markdown
| {role-name} | 🏠内部 | {描述} | [repo](https://github.com/relunctance/exp-roles) · [SKILL.md](https://github.com/relunctance/exp-roles/blob/master/roles/{role-name}/SKILL.md) |
```

同时在更新日志追加：

```markdown
| {日期} | 添加 | {role-name} | 专家角色 |
```

---

## 第八步：推送 GitHub

### 三个仓库都需要推送

```bash
# 1. 推送 exp-roles
cd exp-roles
git add -A
git commit -m "feat: add {role-name} role"
git push

# 2. 推送 gql-skills
cd gql-skills
git add -A
git commit -m "docs: add {role-name} to Infrastructure index"
git push

# 3. 如果新建了 skill 仓库，也需要推送
# （在 skill-created 新建部分处理）
```

---

## 完整执行示例

用户：`创建一个产品专家角色`

```
用户：创建一个产品专家角色

AI：
## 🎯 专家画像分析

**角色名称**: product-expert
**显示名称**: 产品专家
**类型**: coordinator
**层级**: specialist

### 核心职责
1. **需求分析** - 理解用户痛点，转化为产品需求
2. **PRD 撰写** - 编写清晰、可执行的产品需求文档
3. **优先级决策** - 基于价值/成本评估需求优先级
...

请确认专家画像是否准确。
```

用户确认后：

```
## 🔍 Skill 检索：「产品」「需求分析」「优先级」

| # | Skill 名称 | Health Score | 来源 | 描述 | 推荐级别 |
|---|-----------|-------------|------|------|---------|
| 1 | okr-manager | 🟢 78/100 | 外部 | OKR 生命周期管理 | ⭐ 推荐 |
| 2 | writing-plans | 🟡 62/100 | Superpowers | 规划与实现计划 | 可选 |

请确认要加入哪些 skill？
```

用户：`1,2`

```
✅ 开始构建 product-expert 角色...

1. 校验 skill 清单...
2. 在 exp-roles 创建角色定义...
3. 运行校验脚本...
4. 更新 README...
5. 更新 gql-skills 索引...
6. 推送 GitHub...

✅ product-expert 角色构建完成！
- 角色定义：https://github.com/relunctance/exp-roles/tree/master/roles/product-expert
- 已安装 skills: okr-manager, writing-plans
```

---

## 约束与限制

1. **必须使用 find-skills** — 不能凭空捏造 skill，必须先搜索再决定
2. **必须校验角色** — 创建后必须运行 validate_role.py 确保合规
3. **三个仓库都要推送** — exp-roles + gql-skills + 新建的 skill 仓库
4. **config.yaml name 必须与目录名一致** — 这是 schema 强制要求
5. **source 只支持 superpowers 和 git** — 不支持其他 source 类型
