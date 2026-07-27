import readline from "node:readline";

const lines = readline.createInterface({ input: process.stdin });
let threadNumber = 0;
let turnNumber = 0;
let delayNextThreadStart = false;
const interruptedTurns = new Set();
const subscriptions = new Map();

process.on("SIGTERM", () => {
	setTimeout(() => process.exit(0), 100);
});

function write(message) {
	process.stdout.write(`${JSON.stringify(message)}\n`);
}

lines.on("line", (line) => {
	const message = JSON.parse(line);
	if (message.method === "initialize") {
		write({ id: message.id, result: { userAgent: "fake-codex" } });
		return;
	}
	if (message.method === "initialized") return;
	if (message.method === "thread/start") {
		if ([...subscriptions.values()].some((status) => status === "completed")) {
			write({ id: message.id, error: { message: "completed thread remained subscribed" } });
			return;
		}
		threadNumber += 1;
		const threadId = `thread-${threadNumber}`;
		subscriptions.set(threadId, "active");
		const respond = () => write({ id: message.id, result: { thread: { id: threadId } } });
		if (delayNextThreadStart) {
			delayNextThreadStart = false;
			setTimeout(respond, 150);
		} else {
			respond();
		}
		return;
	}
	if (message.method === "turn/start") {
		turnNumber += 1;
		const turnId = `turn-${turnNumber}`;
		const threadId = message.params.threadId;
		const prompt = message.params.input[0].text;
		if (prompt.includes("DELAY_RESPONSE")) delayNextThreadStart = true;
		const responseDelay = prompt.includes("DELAY_RESPONSE") ? 100 : 0;
		setTimeout(() => write({ id: message.id, result: { turn: { id: turnId } } }), responseDelay);
		if (prompt.includes("RETRY")) {
			write({
				method: "error",
				params: { threadId, turnId, willRetry: true, error: { message: "retrying" } },
			});
		}
		if (prompt.includes("FAIL")) {
			write({
				method: "error",
				params: { threadId, turnId, willRetry: false, error: { message: "fake failure" } },
			});
			return;
		}
		const delay = prompt.includes("DELAY_RESPONSE") ? 120 : prompt.includes("SLOW") ? 200 : 5;
		setTimeout(() => {
			if (interruptedTurns.has(turnId)) return;
			write({
				method: "item/agentMessage/delta",
				params: { threadId, turnId, delta: "first<endCompletion>second" },
			});
			write({
				method: "turn/completed",
				params: { threadId, turn: { id: turnId, status: "completed" } },
			});
			subscriptions.set(threadId, "completed");
		}, delay);
		return;
	}
	if (message.method === "turn/interrupt") {
		interruptedTurns.add(message.params.turnId);
		write({ id: message.id, result: {} });
		return;
	}
	if (message.method === "thread/unsubscribe") {
		subscriptions.delete(message.params.threadId);
		write({ id: message.id, result: {} });
	}
});
