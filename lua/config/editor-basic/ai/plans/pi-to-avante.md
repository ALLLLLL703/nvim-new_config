# 把 pi 配置复刻到 avante：可行性评估与实施方案

> 状态：评估文档（未实现）。所有 avante 结论均来自本机 `~/.local/share/nvim/site/pack/core/opt/avante.nvim`（版本 `0.2.0`，commit `f677f35`），pi 结论来自 `~/.pi/agent/`。

## 1. 结论

| 层次 | 可复刻度 | 说明 |
|---|---|---|
| provider / 模型 / 密钥 / endpoint | ✅ 100% | avante `providers` 与 pi `models.json` 结构可一一对应 |
| 指令文件（AGENTS.md） | 🟡 70% | avante 只读**项目根**那一个；全局那份要自己注入 |
| 工具集（读写文件、bash、grep、web） | ✅ 90% | avante 内置工具基本覆盖，可裁剪、可扩展 |
| MCP（rea / nvim / dap） | 🟡 需第三方 | avante 无 MCP 客户端，必须经 mcphub.nvim |
| 子代理 | 🟡 缩水 | 只有只读 `dispatch_agent`，无并行写权限子代理 |
| 上下文压缩 | 🟡 有但不同 | avante 有 memory 摘要式压缩，但没有 CCR/展开机制 |
| skills 加载器 / goal 模式 / TS 扩展 / TUI 主题 | ❌ | pi 的 harness 层能力，avante 无对应抽象 |

一句话：**配置层值得搬，harness 层搬不动**。

## 2. pi 侧资产（`~/.pi/agent/`）

| 项 | 内容 | 位置 |
|---|---|---|
| 默认模型 | `deepseek-flash` | `settings.json:17-18` |
| 自定义 provider | `e-flowcode-deepseek-china` → `https://e-flowcode.cc/v1`，`openai-completions`，模型 `deepseek-v4-flash` | `models.json` |
| 内置 provider 覆盖 | `openai` → `gpt-6-astra`（reasoning, 1.05M context, 128k max） | `models.json` |
| 密钥存储 | `deepseek.key`、`zai-coding-cn.key`、`openai-codex.{access,refresh,expires,accountId}`（OAuth） | `auth.json` |
| 网关密钥 | `AVANTE_FLOWCODE_API_KEY` / `AVANTE_FLOWCODE_CODEX_API_KEY`（**不在 auth.json**） | `~/.config/zsh/alias_and_var/api-key/export.sh` |
| web 搜索密钥 | `jq -r '.deepseek.key' ~/.pi/agent/auth.json` | `web-search.json` |
| MCP | `rea`(npx rea-agents)、`nvim`(`nvim-mcp --connect auto`)、`dap`(http://localhost:8763/mcp) | `mcp.json`、`.mcp.json` |
| 指令 | 全局 `~/.pi/agent/AGENTS.md` + 项目 `AGENTS.md` | — |
| harness 配置 | compaction（reserve 16384 / keepRecent 20000）、retry×6、`httpIdleTimeoutMs` | `settings.json` |
| 扩展 | `herdr-agent-state.ts`、`pi-better-openai` | `extensions/` |
| 包 | mcp-adapter / web-access / subagents / ask-user-question / pi-goal / billion-context / dollar-skills / stop-that-shit / zentui / powerline-footer / awesome-pi-themes / pi-vim | `settings.json:5-18` |

## 3. avante 0.2.0 实际能力（带出处）

| 能力 | 细节 | 出处 |
|---|---|---|
| provider 列表 | claude / openai / azure / copilot / gemini / ollama / bedrock / vertex / cohere / watsonx；**无 deepseek** | `lua/avante/providers/` |
| provider 自定义 | `endpoint` + `api_key_name` + `model` + `extra_request_body` + `timeout` | 现有 `lua/config/editor-basic/ai/ai1.lua` |
| `system_prompt` | `string \| nil \| fun(): string`，每轮求值 | `lua/avante/config.lua:279` |
| 项目规则 | 自动读**项目根**的 `AGENTS.md` / `CLAUDE.md` / `OPENCODE.md` / `.cursorrules` / `.windsurfrules` / `.github/copilot-instructions.md`（取第一个命中） | `lua/avante/utils/prompts.lua:204-224` |
| 自定义模式提示词 | `rules.project_dir` / `rules.global_dir` 里 `<mode>.avanterules` | `lua/avante/path.lua:305-334` |
| 内置工具 | `bash` `view` `create` `write_to_file` `str_replace` `replace_in_file` `edit_file` `insert` `undo_edit` `grep` `glob` `ls` `get_diagnostics` `web_search` `write_todos` `read_todos` `think` `attempt_completion` `dispatch_agent` `delete_tool_use_messages` | `lua/avante/llm_tools/` |
| `custom_tools` | 数组或**函数**；支持 lua `func` 或 shell；带参数 schema | `doc/avante.txt:1665` |
| 工具裁剪 | `disabled_tools = {...}`、按 provider 的 `disable_tools = true`、`auto_approve_tool_permissions` | `lua/avante/config.lua:303`、`:683`、`:924-927` |
| 子代理 | `dispatch_agent`：**只读**，子代理只有 `glob`/`grep`/`ls`/`view`/`attempt_completion`，无 bash/edit | `lua/avante/llm_tools/dispatch_agent.lua:16-40` |
| 上下文压缩 | 有：token 用量 > `context_window * 0.9` 时把历史喂给 `summarize_memory()`，摘要写回 `memory`，旧消息从历史剔除，下一轮经 `_memory.avanterules` 注入 | `lua/avante/llm.lua:32`、`:237-247`、`:405-412`；`memory_summary_provider` 在 `lua/avante/config.lua:321` |
| MCP | **无客户端**。官方指引走 mcphub.nvim | `lua/avante/faq.lua:1-2` |
| ACP provider | `acp_providers`，字段 `command/args/env/auth_method`；会话可带 `mcp_servers`（`name/command/args/env`） | `lua/avante/config.lua:362`、`lua/avante/libs/acp_client.lua:63`、`:861-901`、`doc/avante.txt:2705-2713` |
| 默认快捷键 | `ask=Space a a`、`edit=Space a e`、`new_ask=Space a n`、`stop=Space a S`、`toggle=Space a t`、`selection=Space a C`、`repomap=Space a R`、`select_model=Space a ?`、`select_history=Space a h`、`zen_mode=Space a z`、`select_acp_mode/…Model=Space a m / Space a M` | `lua/avante/config.lua`（`mappings` 段） |
| 扩展机制 | `lua/avante/extensions/` 只有 `nvim_tree` 这类集成模块，**不是 hook 系统** | `lua/avante/extensions/init.lua` |

## 4. mcphub.nvim 接线方式（已确认的官方 API）

来源：`ravitemer/mcphub.nvim` → `doc/extensions/avante.md`、`doc/configuration.md`。

```lua
-- avante 侧
require("avante").setup({
  system_prompt = function()
    local hub = require("mcphub").get_hub_instance()
    return hub and hub:get_active_servers_prompt() or ""
  end,
  custom_tools = function()
    return { require("mcphub.extensions.avante").mcp_tool() } -- 注入 use_mcp_tool / access_mcp_resource
  end,
  disabled_tools = { "bash" }, -- 与 mcphub 内置 neovim server 工具去重
})

-- mcphub 侧
require("mcphub").setup({
  config = vim.fn.expand("~/.config/mcphub/servers.json"),
  port = 37373,
  auto_approve = false,
  extensions = { avante = { make_slash_commands = true } },
  native_servers = {},
})
```

关键点：
- `custom_tools` 支持**函数**，所以可以懒加载、可以按 provider 动态开。
- mcphub 自带 neovim server 的文件/终端工具与 avante 内置工具重名，**必须二选一**（`disabled_tools`）。
- mcphub 支持 VS Code 格式（`servers` 键）、`.mcphub/servers.json` / `.vscode/mcp.json` / `.cursor/mcp.json` 项目级配置、`${env:}` / `${cmd:}` 插值。
- 依赖：`plenary.nvim` + 全局 `mcp-hub` node 二进制（`npm i -g mcp-hub`）。

## 5. 映射决策

### 已定（本轮用户拍板）

1. 本轮**只产出评估文档**，不写实现代码。
2. MCP 走 **mcphub.nvim**（不改 ACP 路线）。
3. `lua/config/editor-basic/ai/` 下按**职责子文件夹**拆分。
4. 密钥**从 pi 的 `auth.json` 读**。
5. opencode 那一套快捷键**只删快捷键**，插件 spec 保留。
6. **不接 codex**，provider 只留 DeepSeek。
7. MCP 服务器**全部接**（含 `lsp`、`computer-use`），只是默认 disabled，由模型按需 `toggle`。
8. 工具调用**全部自动批准**（`auto_approve_tool_permissions = true`）。
9. mcphub 内置的 `neovim` server **不特殊处理**（保留其全部工具，接受与 avante 内置文件工具重名）。
10. `mcp-hub` 二进制用**全局 npm** 安装。

### 已作废（因第 6 条：不接 codex）

| 编号 | 原问题 | 结论 |
|---|---|---|
| Q2 | `openai-codex` 是 OAuth，avante 只认静态 `api_key` | 作废，不接 codex。 |
| Q4 | e-flowcode 中转是否支持 tool calling | 作废，不接 e-flowcode。 |
| Q6 | 是否要 ACP provider | 暂缓（P4），当前机器两个 acp 二进制都没装。 |

`Q3`（`e-flowcode` 密钥不在 `auth.json`）随 Q4 一并作废；`credentials.lua` 仍保留 env 优先逻辑，作为临时覆盖手段。

## 6. 目标目录结构（阶段 P1 起生效）

```
lua/config/editor-basic/ai/
├── init.lua                  # 只做 require 编排
├── ai_comp.lua               # 保留（当前空文件）
├── minuet2.lua               # 保留：补全
├── codex_app_server.lua      # 保留：codex app-server 客户端
├── plans/
│   └── pi-to-avante.md       # 本文档
└── avante/
    ├── init.lua              # 组装 opts → require("avante").setup
    ├── credentials.lua       # ~/.pi/agent/auth.json + env 回退
    ├── providers.lua         # DeepSeek provider 定义
    ├── prompts.lua           # system_prompt：全局 AGENTS.md + MCP 服务器清单
    └── mcp.lua               # mcp.json → servers.json 投影 + mcphub setup + custom_tools
```

`tools.lua` 不单独成文件：`auto_approve_tool_permissions` 是一行配置，`custom_tools` 只有 mcphub 一个来源，拆出去只会增加间接层（STYLE.md 第 5 节）。

- `lua/config/editor-basic/ai/ai1.lua` 的 `opts` 全部迁进 `avante/`，`ai1.lua` 删除。
- 快捷键按仓库现有约定留在 `lua/keymaps/editor-basic/ai/avante.lua`（不要塞进 config 目录）。
- `credentials.lua` 只暴露 `resolve(name)`，返回 `{ api_key = ..., source = "auth_json"|"env" }`，不缓存过期值。

## 7. 分阶段实施

| 阶段 | 内容 | 状态 |
|---|---|---|
| P0 | 评估文档 + 删除 opencode 快捷键 | 已完成（提交 `ff2d861`） |
| P1 | 拆 `avante/`，行为与现状等价 | 已完成：`avante/{init,credentials,providers}.lua`，provider 只剩 DeepSeek |
| P2 | 规则与提示词对齐 | 已完成：`avante/prompts.lua` |
| P3 | mcphub 接入 | 已完成：`avante/mcp.lua` |
| P4（可选） | ACP provider | 未做 |
| P5（不建议） | 自研 skills 加载器 / compaction 增强 | 未做 |

## 8. 风险与坑

1. **nvim-mcp 自指**：avante 在 nvim 内，`nvim-mcp --connect auto` 可能连到宿主自身，工具调用期间再触发 UI 事件 → 卡死或递归。要么不接 `nvim`，要么给 mcphub 配一个独立实例的 socket 路径。
2. **工具重复**：mcphub 内置 neovim server 与 avante 内置文件/bash 工具重复，未去重会导致模型来回犹豫或改错文件。
3. **OAuth 过期**：`openai-codex.access` 会过期，静态 api_key 不可用；需要 refresh 才能长期可用。
4. **压缩语义不同**：avante 的 compaction 是"摘要覆盖旧历史"，没有 pi 的 `decompress`/CCR 回溯能力，长会话里细节一旦被摘要就找不回。
5. **压缩用的模型**：`memory_summary_provider` 不配会用主 provider，等于多花一次钱。
6. **规则冲突**：avante 自动读项目根 `AGENTS.md`，若同时把同一份内容塞进 `system_prompt` 会重复，浪费 token。
7. **`custom_tools` 与 `disabled_tools` 的 provider 作用域**：`disable_tools` 是 provider 级（`lua/avante/config.lua:1234-1243` 有显式报错），别写到顶层。

## 9. P1–P3 实现说明

### 9.1 数据流

```
~/.config/mcp/mcp.json  (mcpServers, pi 唯一真源)
        │  avante/mcp.lua: M.sync_servers()
        ▼
~/.config/mcphub/servers.json  (mcp-hub 的配置，连接字段由生成器覆盖)
        │  rcitemer/mcphub.nvim 启动 mcp-hub --watch
        ▼
mcp-hub 进程 ──▶ hub:get_active_servers_prompt(true, true) ──▶ system_prompt
```

- 装 mcp-hub 必须带 `--prefix`（系统 npm prefix `/usr` 是 root 所有）：

```sh
npm install -g --prefix ~/.local mcp-hub@latest
```

### 9.2 字段投影

| pi (`mcp.json`) | MCPHub (`servers.json`) |
|---|---|
| `command` / `args` / `cwd` / `env` | 同名保留 |
| `type: "http"` + `url` + `headers` | `type: "http"` + `url` + `headers` |
| `bearerTokenEnv: "GITHUB_PAT_TOKEN"` | `headers.Authorization = "Bearer ${GITHUB_PAT_TOKEN}"` |
| `lifecycle` / `requestTimeoutMs` / `startup_timeout_sec` / `tools` / `auth` | 丢弃（MCPHub 只有全局 `mcp_request_timeout`，工具策略交给 `auto_approve`） |

- 新 server 默认 `disabled = true`；已有文件里的 `disabled` / `autoApprove` / `disabled_tools` / `disabled_resources` / `custom_instructions` **全部保留**，否则每次重启会把模型开过的 server 关回去。
- 只有 `vim.deep_equal` 判定内容真变了才写文件；无条件重写会每启动一次就触发一次 hub reload。
- 空表不能直接传给 `vim.json.encode`（`{}` 会被编成 `[]`），所以可选的 `args` / `env` / `headers` 为空时整字段省略。

### 9.3 提示词

- 必须 `hub:get_active_servers_prompt(true, true)`：第二个参数是 `include_disabled`（`lua/mcphub/hub.lua:1577-1583`），不传就只会列出已连接的两个 native server，模型永远不知道该 `toggle` 谁。
- 全局规则来自 `~/.pi/agent/AGENTS.md`，按 mtime 缓存；avante 已自己读项目根 `AGENTS.md`，两者不同源，不会重复。
- `mcp_request_timeout = 180000` 是全局值，按最慢的 `lsp` server 取值。

### 9.4 实测记录

- `nvim --headless` 完整加载，`mode=n`，无报错。
- `servers.json` 生成 10 个 server（jd / dotnet / computer-use / cratesio / lsp / context7 / github / node_repl / open-websearch / codegraph），全部 `disabled: true`。
- 调用 `toggle_mcp_server{server_name="codegraph", action="start"}` → `codegraph:connected`，其余保持 `disabled`，且 hub 把 `disabled: false` 写回 `servers.json`（重启后仍生效）。
- 二次启动后 `servers.json` 内容不变（不重复写盘）。
- system prompt 长度 18295 字符，包含 `## Disabled MCP Servers` 段与各 server 描述。

### 9.5 坑

1. **陈旧 hub 被复用**：mcphub 会先按 root + config 找已有 hub（`lua/mcphub/hub.lua:105`）。若旧 hub 启动时 `servers.json` 尚不存在，它不会重新加载，新 nvim 拿到的只有两个 native server。排查：`pgrep -f 'mcp[-]hub --port'`，有残留就 kill 后重开。
2. **键名**：pi 的 `mcp.json` 用 `mcpServers`，不是 `servers`。
3. **`servers.json` 不是手改入口**：连接字段（command/url/headers）每次启动会被 `mcp.json` 覆盖，只有 `disabled` 这类运行态字段会被保留。
4. **重名工具**：内置 `neovim` server 的 `read_file` / `bash` 与 avante 内置工具同名，本轮按决策全部保留，模型可能选错，后续可改用 `disabled_tools` 收敛。

## 10. 本轮已落地的改动

- 删除 `lua/keymaps/editor-basic/ai/opencode1.lua`（只做 `require("opencode").setup({})`，装的是 opencode 默认键位）。
- `lua/keymaps/editor-basic/ai/init.lua` 去掉对应 `require`。
- `lua/keymaps/editor-basic/ai/ai2.lua` 删除 6 条 opencode 命令键位：`<leader>ao`、`<leader>as`、`<leader>aS`、`<leader>an`、`<leader>am`、`<leader>aM`。
- 保留 `<leader>ax`（`CodexToggle`）与历史注释块；`lua/plugins/editor-basic/ai.lua:9` 的 opencode 插件 spec 按约定保留。
- P1：新增 `avante/{credentials,providers}.lua` 与拆分后的 `avante/init.lua`，provider 只留 DeepSeek（`deepseek-flash`，context 1M / max_tokens 384k，取自 `~/.pi/agent/models-store.json`）。
- P2：新增 `avante/prompts.lua`，把 `~/.pi/agent/AGENTS.md` 与 MCPHub 服务器清单拼进 `system_prompt`（avante 是追加而非替换，见 `llm.lua:351-360`）。
- P3：新增 `avante/mcp.lua`（`mcp.json` → `servers.json` 投影 + MCPHub 懒加载 + `custom_tools`）；`lua/plugins/editor-basic/ai.lua` 加 `ravitemer/mcphub.nvim`；`nvim-pack-lock.json` 随之更新（`mcphub.nvim` 是首个用 rev 钉定版本的条目）。
- `avante/init.lua` 增加 `auto_approve_tool_permissions = true`。
