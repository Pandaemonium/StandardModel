Project name: gate-c1-local-promotion-patch-plan-c224

You are Aristotle, working on the StandardModel Lean/null-edge project.

Context:

C218/C219 say the next highest-value local work is promotion of real artifacts
into Draft modules, but Codex should avoid semantic drift and should not claim
local verification unless it actually runs checks.

Task:

1. Produce a minimal patch plan for Codex to create Draft modules from the real
   artifacts.
2. Assume Codex will not run Lean checks unless the user explicitly asks.
3. Prefer additive files under:

```text
PhysicsSM/Draft/NullEdge/GateC1/
```

4. Include a safe fallback if direct copying requires namespace/import edits.
5. State exactly what Codex should report if it performs the patch without
   validation.

Success criteria:

```text
Concrete patch plan.
No theorem statement changes.
No trusted-code promotion.
No implied verification.
```

Please finish with:

```text
Patch plan:
Fallback plan:
Files to create:
Files not to touch:
Post-patch report wording:
```
