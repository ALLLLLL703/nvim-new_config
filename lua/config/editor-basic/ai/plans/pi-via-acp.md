# pi × ACP：让外部客户端直接驱动 pi

本文记录一条**不重写 agent、只换前端**的路径：pi 以 ACP server 的形式被 avante（或任何 ACP 客户端）驱动。

结论先行：**avante 能接 pi，但必须经过 `pi-acp` 这层网桥** —— pi 自己不会说 ACP。

## 1. 三方角色

```
avante.nvim (ACP client)  ──ACP over stdio──>  pi-acp (bridge)  ──spawn──>  pi --mode rpc
     lua/avante/libs/acp_client.lua            ~/.local/bin/pi-acp            (真 agent)
```

- **客户端**：avante 有一套完整 ACP 客户端实现（`lua/avante/libs/acp_client.lua`），支持 `fs.readTextFile/writeTextFile`、`session/request_permission`、`tool_call`/`tool_call_update`、`agent_message_chunk`、`usage_update`、mode/model 切换、`acp_follow_agent_locations`。
- **网桥**：`pi-acp`（npm，上游 `svkozak/pi-acp`），ACP JSON-RPC 2.0 over stdio ↔ `pi --mode rpc` 双向翻译。
- **agent**：`pi` 本体，模型、skills、MCP、subagents、compaction 全在 pi 侧跑，配置无需改动。

## 2. 为什么 pi 不能直连

- `pi --help` 的 `--mode` 只有 `text | json | rpc`，没有 `acp` 子命令。
- pi 的包内没有 `agent-client-protocol` 依赖（grep `packages/*/dist` 无命中）。
- 所以 pi 提供的对外接口是：交互 TUI、print/json 一次性模式、`--mode rpc` 长连接 JSONL、TypeScript SDK。ACP 不在其中。

## 3. 实测记录（2026-10-28）

环境：pi 1.4.0、node v26.12.1、`deepseek/deepseek-flash`（contextWindow 1000000）。

裸 ACP 探针（`initialize` → `session/new` → `session/prompt`）结果：

| 步骤 | 观察 |
| --- | --- |
| `initialize` | `protocolVersion = 1`，`authMethods = ["pi_terminal_login"]` |
| `session/new` | 返回 `sessionId`、`models.availableModels`（约 80 个，含 `deepseek/deepseek-flash`、`deepseek/deepseek-v4-pro`）与 `currentModelId = deepseek/deepseek-flash` |
| `session/prompt` | 先流式 `agent_thought_chunk`，再 `agent_message_chunk`，`stopReason = end_turn` |
| `usage_update` | `{ used = 20827, size = 1000000 }` —— pi 的真实上下文占用被报给客户端 |
| startup info | 回复开头带 pi 版本 + Skills 列表（`~/.agents/skills/*`），可用 pi settings 的 `quietStartup: true` 关掉 |

## 4. 接法 A：avante

前提：`pi` 在 PATH（1.0.0+，网桥要求 pi >= 0.81）、`pi-acp` 已装。

```bash
# npm 全局 prefix 是 /usr（root 所有），所以装到用户 prefix
npm install -g --prefix ~/.local pi-acp@0.0.34
```

`acp_providers` 的一项就是全部接线（定义见 `lua/avante/config.lua:362` 起的那批内置 provider）：

```lua
acp_providers = {
	pi = {
		command = "pi-acp",
		args = {},
		-- avante 会先塞 PATH 再合并这里（lua/avante/libs/acp_client.lua:421-439）
		env = { NODE_NO_WARNINGS = "1" },
	},
}
```

然后用已有的 ACP 快捷键切 provider：

- `<leader>aM` → `select_acp_model`（在 `availableModels` 里选模型）
- `<leader>am` → `select_acp_mode`

注意：ACP provider 走的是**独立会话**，与 avante 内置 provider 的 `system_prompt` / `custom_tools` / MCPHub 工具链无关 —— 那些东西在 pi 侧由 pi 自己加载（skills、MCP、AGENTS.md 全部生效）。

## 5. 接法 B：自研 agent 前端

如果之后自己写 nvim 里的 agent UI，只需要实现 ACP **client** 侧：

1. spawn `pi-acp`，stdin/stdout 走 NDJSON JSON-RPC。
2. `initialize`（`protocolVersion = 1`，声明 `clientCapabilities.fs`）。
3. `session/new { cwd, mcpServers: [] }` 拿 `sessionId`。
4. `session/prompt { sessionId, prompt = [{ type = "text", text = ... }] }`。
5. 消费 `session/update` 通知：`agent_message_chunk` / `agent_thought_chunk` / `tool_call` / `tool_call_update` / `usage_update` / `session_info_update`。
6. 收到 `session/request_permission` 时回 `{ outcome = { outcome = "selected", optionId = ... } }`。

即：客户端只画渲染 + 转发权限，agent 能力完全由 pi 提供。

## 6. 坑与限制

- **npx 启动慢**：`command = "npx", args = { "-y", "pi-acp" }` 每次拉包会拖几秒，装成全局 bin 更稳。
- **env 会整体覆盖**：avante 只额外保证 `PATH`，其它变量要在 `env` 里显式给。
- **网桥是 MVP**：上游自述部分 ACP 特性未实现、以 Zed 为准；客户端差异可能导致兼容问题。
- **session 映射**：pi 自己存 `~/.pi/agent/sessions/`，网桥另存 `~/.pi/pi-acp/session-map.json` 以支持 `session/load`。两个目录都别随手清。
- **usage_update 依赖 pi 的 `get_session_stats`**：老版本没有 `contextUsage` 就不报用量。
- **permission**：avante 用 `lua/avante/ui/acp_confirm_adapter.lua` 弹确认，pi 侧工具仍需按 ACP 权限流程逐个批。
- **与 mcphub 工具重名无关**：ACP 会话里 pi 用自己的 MCP 客户端，`mcp.json` / MCPHub 两套互不干扰。

## 7. 参考

- ACP 规范：https://agentclientprotocol.com/overview/introduction
- 网桥源码：https://github.com/svkozak/pi-acp
- avante ACP 客户端：`lua/avante/libs/acp_client.lua`、`lua/avante/acp_config_selector.lua`
- pi CLI 集成说明：`/usr/lib/node_modules/pi/packages/coding-agent/docs/cli-integration.md`
