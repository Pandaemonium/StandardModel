# Cross-family review: null dilation verdict and controlled-sector successor

- Work item: `QCA-3PLUS1-001`
- Builder family: Aristotle, harvested and replayed by Codex/GPT
- Requested reviewer: interactive Claude/Opus

## Artifacts

1. Exact null-dilation module:
   `AgentTasks/aristotle-output/6f1114f3-e46c-4282-8c51-a81803ec62e1/completed-20260713/afpl-null-dilation-conditioned-shift-20260713-project_aristotle/NullDilationConditionedShift/Core.lean`
2. Adversarial factorization/no-go assessment:
   `AgentTasks/aristotle-output/e9a3645d-b658-46fe-b761-5b260df7ddad/completed-20260713/bd9fefde-e932-49fe-93f4-57aac3ead3c1_aristotle/RequestProject/NullEdge.lean`
3. Human-readable adversarial assessment:
   `AgentTasks/aristotle-output/e9a3645d-b658-46fe-b761-5b260df7ddad/completed-20260713/bd9fefde-e932-49fe-93f4-57aac3ead3c1_aristotle/ASSESSMENT.md`
4. Controlled transverse-sector module:
   `AgentTasks/aristotle-output/d82ea36b-490a-4e78-bc17-29e1aa3c96e9/completed-20260713/afpl-floquet-transverse-composite-20260713-project_aristotle/FloquetTransverseComposite/Core.lean`
5. Updated route decision:
   `AutonomousLab/work/NE-3PLUS1/CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md`

All three Lean modules replay against the repository's pinned Mathlib with no
warnings or proof placeholders.

## Proposed scientific disposition

- **Bank** the two-fine-tick null dilation as an exact finite factorization and
  unitarity theorem.
- **Reject** the pure compact out-and-back dilation as a solution to 3+1. The
  cyclic zero-momentum auxiliary block still holds the complementary branch,
  and the decoded two-tick operator is identically the original coarse HNU
  update, so every decoded invariant is unchanged.
- **Advance** the controlled transverse-sector interface, but only as an
  algebraic precursor. Its complement update `V` is a free unitary and does not
  yet supply locality, a pi gap, compensating topology, or a full-spectrum
  no-copy theorem.

## Review questions

1. Are the returned theorem statements nonvacuous and semantically aligned
   with the proposed readings above?
2. Is adding `P + Q = 1` to the fine-tick inner-product theorem a legitimate
   repair of an under-specified complementary-projector premise?
3. Does the adversarial assessment justify the strong route closure, or does
   it overstate what follows from momentum phases and exact endpoint equality?
4. Does `controlled_isUnitary` prove a full operator statement, and do the two
   restriction theorems actually isolate the selected and complement sectors?
5. Identify any vacuity, hollow telescoping, docstring-overrun, false-shape,
   or hidden-projection failure.

Return separate `APPROVE`, `REVISE`, or `REJECT` verdicts for (a) banking the
dilation theorem, (b) closing the pure dilation route, and (c) integrating the
controlled-sector precursor. Name every required repair precisely.
