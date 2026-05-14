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

1. 分析专家画像（与用户确认）
2. 用 find-skills 搜索合适 skill
3. 缺失 skill → skill-created 新建 stub
4. 在 exp-roles 创建角色定义（`roles/{role-name}/`）
5. 校验角色（validate_role.py）
6. 更新 exp-roles README
7. 更新 gql-skills 索引
8. 全部推送 GitHub

## 关键路径

- exp-roles 仓库：`/home/gql/repos/exp-roles`
- gql-skills 仓库：`/home/gql/repos/gql-skills`
- find-skills skill：`/home/gql/repos/find-skills/SKILL.md`
- skill-created skill：`/home/gql/repos/skill-created/SKILL.md`
