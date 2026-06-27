# Claude adversarial review queue

Claude should be called once per Aristotle round, after submission or after
returned results materially change the state.

Template:

```text
## YYYY-MM-DD - Title

Status: draft | ready | sent | answered | integrated
Aristotle round: ...
Packet path: AgentTasks/...

Ask Claude to attack:
- ...

Required output:
- missed blockers;
- theorem-statement risks;
- overclaim risks;
- next-job recommendations;
- publication-language warnings.
```

## Current next Claude review

Status: draft
Aristotle round: next round after current status check

Ask Claude to attack:

- Whether the C0/C1 split is being used consistently.
- Whether RA-Wilson C0 language is drifting into C1/full Gate C release
  language.
- Whether Gate H/Furey is being incorrectly treated as external branch control.
- Whether the next Lean theorem targets are too abstract to be useful.

## 2026-06-27 - C85/C72 Gate C0 and projected Wilson release review

Status: answered
Aristotle round: Wave 20 C85 plus Wave 17 C72 integration
Packet path: `AgentTasks/null-edge-claude-adversarial-review-c85-c72-2026-06-27.md`
Response log: `AgentTasks/model-calls/claude/2026-06-27-093048-c85-c72-gate-c-review.md`

Ask Claude to attack:

- Whether C85/C72 are being overinterpreted as full Gate C release.
- Whether C72 predicate names are semantically safe.
- Whether the next job should instantiate C85 concretely or pivot to C1
  overlap/domain-wall/spinor-line design.

Required output:

- missed blockers;
- theorem-statement risks;
- overclaim risks;
- next-job recommendations;
- publication-language warnings.

Integrated takeaway:

- Continue, but do not call C85/C72 Gate C or C0 closure externally.
- Prioritize C89 concrete RA-Wilson instantiation.
- Harden C72 naming, ghost-safety, and regulator-moduli predicates through C90.

## Wave 21 C89/C90 submission review

Status: answered
Aristotle round: Wave 21 C89/C90 submission
Packet:
`AgentTasks/null-edge-claude-adversarial-review-wave21-c89-c90-2026-06-27.md`
Log:
`AgentTasks/model-calls/claude/2026-06-27-100807-wave21-c89-c90-review.md`

Takeaways:

- Verdict: continue with C89, downgrade C90 to hygiene, and add a parallel C1
  prep job.
- Main risk: another wave of C0 hardening without an overlap/domain-wall/GW or
  spinor-line C1 attack would be drift.
- Required guardrail: every external claim must name the gate and sector
  explicitly; avoid unqualified `Gate C release`.
- Recommended next jobs: C91/C92 off-branch and ghost predicates, C93 overlap/GW
  interface, C94 domain-wall interface, C95 anti-vectorialization check.
## Cycle 2 C1 route / C93 review

Status: answered
Aristotle round: C93 overlap/Ginsparg-Wilson interface submission
Packet:
`AgentTasks/null-edge-claude-adversarial-review-c1-route-c93-2026-06-27.md`
Usable log:
`AgentTasks/model-calls/claude/2026-06-27-101543-c1-route-c93-review-utf8.md`
Failed/incomplete first log:
`AgentTasks/model-calls/claude/2026-06-27-101419-c1-route-c93-review.md`

Takeaways:

- Verdict: C93 is conditionally right as an interface, not release.
- C93 must include non-release guardrails, index/nontriviality slot, kernel-gap
  hypothesis, anti-vectorialization side condition, and C0-not-C1 separation.
- Next job should likely instantiate C93 against C89's RA-Wilson operator and
  report which fields cannot be populated, rather than starting a parallel
  domain-wall interface immediately.
