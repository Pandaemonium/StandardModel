# Aristotle strategy: compact-auxiliary null dilation for 3+1

Aristotle metadata:

- project_id: e9a3645d-b658-46fe-b761-5b260df7ddad
- task_id: bd9fefde-e932-49fe-93f4-57aac3ead3c1
- output_dir: AgentTasks/aristotle-output/e9a3645d-b658-46fe-b761-5b260df7ddad
- status: completed-and-locally-replayed

## Question

Can every stationary complementary branch in the exact HNU real-space
conditioned shifts be replaced by out-and-back motion in one compact auxiliary
direction, while preserving exact locality, unitarity, the endpoint, the
single zero-quasienergy Weyl sector, and the compensating topology?

## Required audit

- Give the exact finite 16-step architecture and its theorem ladder.
- State the soldering needed to make every fine edge null.
- Census auxiliary bands and crossings rather than projecting them away.
- Track zero- and pi-sector compensating charge.
- Explain whether the auxiliary coordinate can double as the transverse
  selector/domain-wall register.
- Return a no-go or counterexample if compactification only hides the original
  obstruction.

No complete-3+1 claim is licensed by this strategy job alone.

## 2026-07-13 harvest and verdict

Task `bd9fefde-e932-49fe-93f4-57aac3ead3c1` completed with a checked Lean
assessment and a companion `ASSESSMENT.md`, stored under
`AgentTasks/aristotle-output/e9a3645d-b658-46fe-b761-5b260df7ddad/completed-20260713/`.
The Lean assessment replays cleanly against the pinned project Mathlib.

Verdict: the route is an exact, local, unitary factorization but **not** a 3+1
solution. A cyclic auxiliary register has `N` distinct microscopic bands; its
zero-momentum block cannot make the complementary branch move. After two ticks
the auxiliary phases cancel and the decoded operator equals the original HNU
coarse substep for every auxiliary momentum. Consequently every decoded
invariant is preserved verbatim: the obstruction has been relocated into a
net-zero auxiliary excursion, not removed. Any successor must construct
nontrivial complement dynamics, not merely factor the same endpoint.
