# Decision checkpoints

Record durable strategic decisions and claim-boundary changes here.

Template:

```text
## YYYY-MM-DD - Decision title

Decision:
- ...

Why:
- ...

Evidence:
- ...

Consequences:
- ...

Revisit if:
- ...
```

## 2026-06-27 - Autonomous-loop harness adopted

Decision:

- Use a durable repo-native harness for long-running autonomous work.

Why:

- The project now spans Lean proof work, Aristotle batches, literature
  ingestion, Claude adversarial review, Pro hard-question packaging, and
  publication strategy.
- Chat history alone is too fragile for this workflow.

Consequences:

- Each loop should update durable state.
- Friction and questions become first-class artifacts.
- Claude is used once per Aristotle round as adversarial reviewer.
- Pro questions are packaged as standalone documents.

Revisit if:

- The harness becomes more overhead than help.
