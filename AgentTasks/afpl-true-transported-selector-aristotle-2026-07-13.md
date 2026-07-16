# Aristotle successor: true schedule-indexed transported selectors

```yaml
aristotle:
  project_id: e9a3645d-b658-46fe-b761-5b260df7ddad
  task_id: 7076b7f1-5c2c-4a6b-be1c-b3f24152cf1c
  target_file: RequestProject/TransportedProjectorHolonomy.lean
  expected_module: RequestProject.TransportedProjectorHolonomy
  status: completed but rejected; successor preparing
```

## Prompt

The previous `TransportedProjectorHolonomy` result was useful but likely did
not solve the requested schedule-local problem: `prod_conj` used one global
`G`, while `altRefls` was merely a different reflection list. Correct this
now.

Using the uploaded candidate and its exact HNU dependencies, formalize a
genuinely schedule-indexed transport theorem. Define a finite cyclic schedule
of projector pairs `(P_j,Q_j)` and nonidentity unitaries `G_j` with explicit
relations `P_(j+1)=G_j P_j G_j^*` and likewise for `Q`. Define co-moving
selected/complement updates. Prove the correct ordered telescoping law with
varying `G_j`, including every endpoint factor and the Wilson/holonomy product
that survives around the cycle. Then instantiate on the HNU Pauli-axis
schedule if possible.

Determine by theorem, explicit finite counterexample, or sharpened missing
hypothesis whether the HNU central `-1` can be removed by a pure
schedule-local frame transport while preserving the same physical endpoint,
or whether changing it necessarily changes the connection/holonomy rather
than merely rebasing the schedule. Distinguish global conjugation, passive
local basis changes with consistently transformed links, and physically
different projector/link schedules.

Acceptance:

- At least one explicit nonidentity Pauli/rational `G_j` witness.
- Exact finite ordered-product statements, not prose or a constant-`G`
  special case.
- Preserve the full zero/pi ledger; projection is not cancellation.
- Do not claim locality, primitive nullness, anomaly inflow, or 3+1 completion
  unless proved.
- Add standard-three guards and finish with a semantic report naming exactly
  what was proved and what remains open.
- Run the narrow Lean file first.

## 2026-07-13 harvest verdict

Task `7076b7f1-5c2c-4a6b-be1c-b3f24152cf1c` completed, but its returned
`TransportedProjectorHolonomy.lean` is the prior constant-frame result. Its
`prod_conj` still uses one global `G`, and the alternating list is still a
physically different reflection schedule. The output contains no indexed
`G_j`, no varying-frame endpoint telescope, and no link cocycle. It therefore
fails the explicit acceptance criteria and is not integrated.

The corrected successor isolates the missing noncommutative algebra first. For
frames `g_0,...,g_n` and bare steps `s_0,...,s_(n-1)`, it must prove

```text
(g_n s_(n-1) g_(n-1)^-1) ... (g_1 s_0 g_0^-1)
  = g_n (s_(n-1) ... s_0) g_0^-1.
```

Only after this theorem lands should the project specialize inverse to unitary
adjoint, close the cycle, and reconnect to the HNU central holonomy.

Successor task `11c39c15-83b4-4c03-87eb-25dafbc6b2b9` received the typechecked
standalone handoff
`AgentTasks/aristotle-standalone/schedule-indexed-transport-core-20260713/ScheduleIndexedTransportCore.lean`.
It targets only the genuine varying-frame telescope and its cyclic/central
corollaries.

## 2026-07-13 corrected successor harvest

Task `11c39c15-83b4-4c03-87eb-25dafbc6b2b9` completed the isolated theorem.
The exact returned candidate was downloaded as `schedule-latest.zip`, replayed
directly, and adapted into
`PhysicsSM/Draft/NullEdge/ScheduleIndexedTransportCore.lean`.

The landed draft module proves:

- the full varying-frame endpoint telescope for an arbitrary group;
- cyclic reduction to conjugation by the initial frame;
- preservation of a central bare holonomy under a cyclic passive frame change;
- a noncyclic, noncommutative `SL(2, Z/5Z)` witness whose final frame differs
  from its initial frame and whose dressed product is not the naive constant-
  frame conjugation.

The module replays directly and its targeted Lake build passes. It has local
and aggregate axiom pins. Independent Claude semantic review is open. The
scientific boundary remains explicit: this closes the passive varying-frame
algebra, not the active-link-cocycle or HNU physical-invariant question. A
successor must now prove that an active schedule changes a physical transport
datum, or prove that every consistently transformed cyclic schedule leaves the
central HNU holonomy fixed.

Interactive Claude independently returned `APPROVE` in
`AutonomousLab/reviews/CLAUDE_REVIEW_ScheduleIndexedTransportCore_2026-07-13.md`.
The review verified the product ordering, genuine noncyclic witness, kernel-only
finite decisions, and the crucial scope: this is passive covariance, not an
active escape. The project was therefore marked integrated.

Successor task `32bffbc4-f8df-4d36-82dd-d0aecd0573ff` specializes the generic
telescope to the exact HNU reflection list. It targets a cyclic no-escape
theorem preserving the central `-1`, an open/noncyclic control, and the sharp
boundary that any `-1` to `+1` change must alter a bare step/link datum or the
cycle endpoint condition.
