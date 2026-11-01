# Mesh Avatar Studio 一键部署指南

> 第三方部署指南 · 非 Mesh Avatar Studio 官方仓库。官方项目：[shinshin86/mesh-avatar-studio](https://github.com/shinshin86/mesh-avatar-studio)
> 内容来自官方文档（2026-10-29）。项目迭代快，请以[官方文档](https://github.com/shinshin86/mesh-avatar-studio#try-the-sample)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 一张正面插画就能变成会眨眼、会说话、会转头的 2D 网格头像，网格点位还能自己拖。

⚠️ 需要 Node.js 22.17+ 与 Git。编辑器本身只要 Node；用 Agent 生成新头像时还需要 Claude Code 或 Codex，重建图层可选装 uv / Python 与 Playwright。Windows 建议用 git clone，ZIP 解压可能带权限限制。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/mesh-avatar-studio-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会检查 Node 22.17+，用 npx 拉取模板、安装依赖并启动本地编辑器，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）

4. **打开管理面板**
   浏览器访问 [http://127.0.0.1:5173](http://127.0.0.1:5173)，按官方引导完成初始化配置。

## Mesh Avatar Studio 是什么？

Mesh Avatar Studio 是开源的把单张插画做成会眨眼、说话、转头、呼吸的 2D 网格头像，并带本地编辑器（协议：MIT，<img src="https://img.shields.io/github/stars/shinshin86/mesh-avatar-studio?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

把一张正面插画拆成可动网格：Agent 负责拆层与布点，本地编辑器负责微调，浏览器里实时预览眨眼、说话、转头、呼吸和发丝摆动。

- 一张图出角色：正面头肩插画即可生成
- 本地编辑器：拖动网格点，右侧实时预览
- 分层可控：头发、眼睛、嘴巴等独立图层
- Agent 协作：Claude Code / Codex 按指南建项目
- 纯前端预览：编辑器与 Live 页面只要 Node
- 样例齐全：内置 Miko 样例，可直接改

（来源：[官方仓库](https://github.com/shinshin86/mesh-avatar-studio)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 1.6k stars 10 月新项目 | 名称搜索仅 5 条结果 |
| 交互直观 | 拖网格点就能看动作变化 |
| 门槛低 | 编辑器只要 Node 22.17+ |
| Agent 协作 | 拆层和布点可以交给编码 Agent |
| 本地运行 | 素材与项目都在自己电脑上 |
| MIT 可商用可二开 | — |

| 需要注意 | 说明 |
|---|---|
| 只适合正面头肩插画 侧脸效果差 | — |
| 生成新头像要配 Claude Code 或 Codex | — |
| 高级图层重建要 Python / uv / Playwright | — |
| 不是 Live2D 全功能替代 复杂表情有限 | — |
| 项目很新 文档与接口仍会变 | — |

> 以上基于官方文档与社区反馈整理（2026-10-29），以官方最新文档为准。

## 快速部署（官方方式）

```bash
node -e "const [a,b]=process.versions.node.split('.').map(Number); if(a<22||(a===22&&b<17)){console.error('需要 Node.js 22.17+，当前 '+process.versions.node);process.exit(1)}"
npx create-mesh-avatar-studio
cd mesh-avatar-studio
npm run dev
echo "已启动：http://127.0.0.1:5173"
```

启动后浏览器访问 [http://127.0.0.1:5173](http://127.0.0.1:5173)（管理面板）。（来源：[https://github.com/shinshin86/mesh-avatar-studio#try-the-sample](https://github.com/shinshin86/mesh-avatar-studio#try-the-sample)）

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认 Node 22.17+、npx create-mesh-avatar-studio、端口 5173 | 已核对 2026-10-29 |
| README 确认 Agent 建头像流程与可选 uv / Python / Playwright | 已核对 2026-10-29 |
| 未实测 npx 拉取与 npm run dev | 说明 2026-10-29 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-10-29 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-29 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

项目本身不含 MCP；本仓库的 MCP 只提供部署步骤、Agent 提示语与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-29）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\mesh-avatar-studio-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 用 Agent 生成自己的头像

在仓库目录里打开 Claude Code 或 Codex，把插画路径发给它：

```text
Create an avatar from this image following docs/agent-guide.md: /path/to/your-image.png
```

Agent 会读取 docs/agent-guide.md，按缩放网格布点、切图层，并用固定姿势自检。项目保存在 `projects/<name>/`，不会被提交。

推荐素材：正面、头肩、透明背景的 PNG。

## 手动安装

```bash
git clone https://github.com/shinshin86/mesh-avatar-studio.git
cd mesh-avatar-studio
npm install
npm run doctor
npm run dev
```

`npm run doctor` 会检查 Node、uv / Python、Playwright 等可选工具，缺什么会直接提示。

## 注意

- 编辑器与 Live 页面只需要 Node，生成头像才需要 Agent
- Windows 上不要用别人账号或沙箱创建的目录，可能读不到项目文件
- 重建图层与动作审阅依赖 uv / Python / Playwright，不装也能手动编辑
- 样例是只读的，改动前先选 Copy and keep editing

## 常见坑

- Node 版本不够：升到 22.17+ 再执行 npx
- npx 卡住：换 npm 镜像，或先 git clone 再 npm install
- npm run dev 端口被占：按终端提示换端口
- Windows 读不到项目：把项目放在自己的用户目录，检查文件夹权限
- Agent 建头像失败：确认插画是正面头肩、背景透明，并按 docs/agent-guide.md 执行
- 没有 Live 预览：用 Chrome 或 Edge 打开 /play/

## 免责声明

本仓库为第三方指南，与 Mesh Avatar Studio 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-29），项目迭代快，请以[官方文档](https://github.com/shinshin86/mesh-avatar-studio#try-the-sample)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
