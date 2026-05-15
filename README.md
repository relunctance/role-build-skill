# role-build-skill

[![license](https://img.shields.io/badge/license-MIT-blue.svg)](#)
[![platforms](https://img.shields.io/badge/platforms-claude_code%20%7C%20openclaw%20%7C%20hermes-blue.svg)](#)
[![version](https://img.shields.io/badge/version-1.0.0-green.svg)](#)
[![category](https://img.shields.io/badge/category-Infrastructure-blue.svg)](#)

分析专家擅长的领域和问题，评估并安装所需 skills，在 exp-roles 注册角色，更新 gql-skills 总览索引。

## 触发条件

当用户说：
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

## 关键路径

| 仓库 | 路径 |
|------|------|
| exp-roles | https://github.com/relunctance/exp-roles |
| gql-skills | https://github.com/relunctance/gql-skills |
| find-skills | https://github.com/relunctance/find-skills/SKILL.md |
| skill-created | https://github.com/relunctance/skill-created/SKILL.md |

## 执行步骤

### 第一步：分析专家画像

与用户确认专家信息（角色名称、类型、层级、核心职责、适用场景、工作方式、协作方式、约束限制）。

### 第二步：Skill 搜索与评估

**必须使用 find-skills 搜索**，不能用感觉手写。Health Score 70+（绿色）优先推荐，40-69（黄色）需人工确认，<40（红色）不推荐。

### 第三步：处理缺失 Skill

- 已有 → 直接安装（记录名称和 source）
- 缺失 → skill-created 新建 stub

### 第四步：在 exp-roles 创建角色定义

```
roles/{role-name}/
├── SKILL.md           # 角色详细说明
├── config.yaml        # 角色配置
└── required_skills.txt # 必需 skills 列表
```

### 第五步：校验角色

```bash
cd ~/repos/exp-roles
python3 validators/validate_role.py roles/{role-name}
```

### 第六步~第八步

更新 exp-roles README → 更新 gql-skills 索引 → 推送 GitHub（exp-roles + gql-skills + 新建 skill 仓库）。

## 约束

1. 必须使用 find-skills 搜索，不能凭空捏造
2. 创建后必须运行 validate_role.py 校验
3. 三个仓库都要推送
4. config.yaml name 必须与目录名一致
5. skill source 只支持 `superpowers` 和 `git`

## 安装

使用仓库自带的 setup.sh（自动适配克隆路径）：

```bash
git clone https://github.com/relunctance/role-build-skill.git
cd role-build-skill
bash scripts/setup.sh
```

或手动符号链接（需确认路径）：

```bash
# 请根据实际克隆路径修改 ~/repos/ 部分
mkdir -p ~/.hermes/skills/role-build-skill
ln -sf ~/repos/role-build-skill/SKILL.md ~/.hermes/skills/role-build-skill/SKILL.md
```
