---
paths: ["src/ai/**", "src/agents/**", "src/workflows/**", "src/graph/**"]
---

# LangGraph Conventions

## StateGraph Patterns
- Define state as a TypedDict with clear field annotations
- Use `Annotated` with reducers for fields that accumulate (e.g. messages)
- Keep state minimal — store only what nodes need to read/write
- Use `add_messages` reducer for chat message lists

## Node Design
- Each node is a function: `(state) -> partial state update`
- Nodes should be pure functions with no side effects where possible
- One responsibility per node — keep them small and testable
- Name nodes descriptively: `classify_intent`, `generate_response`

## Edge Design
- Use conditional edges for branching logic
- Define routing functions that return the next node name
- Use `END` sentinel for terminal states
- Keep the graph acyclic unless explicitly designing a loop with exit condition

## Tool Definitions
- Define tools with `@tool` decorator and clear docstrings
- Tools must validate their inputs before execution
- Return structured data, not free-form text
- Handle tool errors gracefully — return error messages, do not raise

## Streaming
- Use `astream_events` for real-time token streaming
- Filter events by `event` type and `name` for relevant updates
- Handle `on_chat_model_stream` for LLM token output

## Error Recovery
- Add retry logic with exponential backoff for LLM calls
- Define fallback nodes for critical failures
- Log state at error boundaries for debugging
- Use `langgraph.errors` for typed exception handling
