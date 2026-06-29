# Claude review packet: cycle 21 C108d narrowing instruction

Date: 2026-06-27

## Context

C108d has remained `IN_PROGRESS` across several polls. It is not stale by the
2-hour policy, but the previous contingency review recommended narrowing if the
next poll still showed it running.

We sent the following narrowing instruction to Aristotle:

```text
Minimum success target:
- Prove a concrete 2 by 2 witness showing nonzero chiral trace and nonzero
  odd-part chiral trace.
- It is acceptable to prove ≠ 0 rather than exact = 2.
- It is acceptable to drop the full ↔ theorem if that is the blocker.
- It is acceptable to specialize to the explicit witness instead of proving
  general arbitrary-J helper lemmas.

Suggested simplification:
- Use explicit Fin 2 -> Fin 2 -> Complex definitions via Matrix.of if the
  !![...] notation is causing friction.
- Use fin_cases, ext i j, and direct finite-sum/trace simplification for the
  2 by 2 calculation.
- Do not import or claim anything about Gate C1 release, spectral islands, gauge
  covariance, bad-sector gaps, Krein positivity, anomaly accounting, or path-sum
  control.
```

## Review request

Please review this narrowing decision.

Focus on:

```text
1. Does the narrowed target still preserve the useful C108d contribution?
2. Did we weaken anything essential?
3. If Aristotle returns only the narrowed witness, what should we record as the
   exact remaining theorem debt?
4. Is there a better next instruction if it still does not return?
```

Requested output format:

```text
Verdict: good narrowing / too weak / revise
Useful result preserved:
- ...
Remaining theorem debt:
- ...
Next instruction if still blocked:
- ...
```
