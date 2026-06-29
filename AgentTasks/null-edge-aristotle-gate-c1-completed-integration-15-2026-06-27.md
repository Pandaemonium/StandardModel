# Null-edge Gate C1 Aristotle completed integration 15

Date: 2026-06-27

Integrated jobs:

```text
C173: CKM mass table one-sector 4D
C179: reference-choice audit after CKM warning
```

Aristotle project/task IDs:

```text
C173 project: 285bd07b-c9a5-43d2-b4c0-e09cc1e18231
C173 task:    5642afae-f82b-4711-bd86-101ba446d786

C179 project: d0628845-f7fb-482e-94ea-265b19bb0f96
C179 task:    c228e0c9-1c89-41a3-9f29-268719dd1cc1
```

Copied artifacts:

```text
AgentTasks/null-edge-c173-ckm-mass-table-integration-2026-06-27.md
AgentTasks/null-edge-c179-reference-choice-integration-2026-06-27.md
AgentTasks/null-edge-c179-reference-choice-audit-2026-06-27.md
```

Downloaded archives:

```text
AgentTasks/aristotle-output/285bd07b-c9a5-43d2-b4c0-e09cc1e18231/project.zip
AgentTasks/aristotle-output/d0628845-f7fb-482e-94ea-265b19bb0f96/project.zip
```

## C173 result

C173 proves the CKM table exactly under the standard elementary-symmetric
convention:

```text
M_V = sum_mu c_mu
M_T = sum_{mu < nu} c_mu c_nu
M_A = sum_{mu < nu < rho} c_mu c_nu c_rho
M_P = product_mu c_mu
M_CKM = M_P + M_V + M_T + M_A.
```

The core identity is:

```text
1 + M_CKM = product_mu (1 + c_mu).
```

So:

```text
M_CKM(level 0) = 15
M_CKM(level > 0) = -1.
```

This validates CKM as a finite mass-table/flavor-texture ingredient.

## C179 result

C179 changes the physical reference priority.

The recommended first physical reference is:

```text
Wilson/Neuberger overlap.
```

The reason is that it has standard doubler-resolution, GW/index structure, and
locality/admissibility theory. CKM remains useful as a mass texture, but literal
naive CKM/tuned naive flavored-overlap is disqualified as the first physical
operator target unless it is independently proven doubler-resolved.

Recommended hierarchy:

```text
1. Wilson/Neuberger overlap.
2. Abstract block scaffold.
3. Domain-wall cross-check/fallback.
4. Adams/staggered-overlap with separate taste-index theorem.
5. Literal naive CKM only if independently doubler-resolved.
```

The operational correction is:

```text
CKM as texture/table: yes.
CKM as literal physical operator reference: no, not first.
```

## Documentation updates made

Updated:

```text
Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md
AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md
AgentTasks/null-edge-c173-ckm-mass-table-aristotle-2026-06-27.md
AgentTasks/null-edge-c179-reference-choice-aristotle-2026-06-27.md
```

## Lean artifact status

Returned Lean artifacts are preserved in Aristotle archives and summaries. They
were not promoted into the live trusted Lean tree during this integration pass.

No local Lean verification was run.
