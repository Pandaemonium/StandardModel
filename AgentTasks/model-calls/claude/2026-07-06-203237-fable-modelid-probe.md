# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `claude-fable-5`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-06T20:32:32`
- Finished: `2026-07-06T20:32:37`
- Timeout seconds: `180`
- Max budget USD: `0.50`
- Return code: `1`

## Command

```text
claude -p --bare --model claude-fable-5 --max-budget-usd 0.50 --output-format text --add-dir 'C:\Projects\StandardModel' --tools ''
```

## Prompt

```text
Respond with exactly the token: FABLE_OK
```

## Response stdout

```text
API Error: Claude Code is unable to respond to this request, which appears to violate our Usage Policy (https://www.anthropic.com/legal/aup). This request triggered restrictions on violative cyber content and was blocked under Anthropic's Usage Policy. To learn more, see https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback. API integrators: you can reduce refusals for your users by configuring a fallback model — see https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback. Try rephrasing the request or attempting a different approach. If you are seeing this refusal repeatedly, try running /model claude-sonnet-4-20250514 to switch models.

```

## Response stderr

```text

```
