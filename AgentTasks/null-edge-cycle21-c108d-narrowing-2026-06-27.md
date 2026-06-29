# Null-edge autonomous loop cycle 21: C108d narrowing

Date: 2026-06-27

## Objective

Continue the requested 30-cycle autonomous-loop run by polling C108d, sending the
prepared narrowing instruction after another in-progress status, and reviewing
whether the narrowed target preserves the useful theorem content.

## Aristotle

- C108d project `00918b10-3d0f-415e-a012-1059581f1f48`, task
  `3d3903ff-45c6-4658-a58e-707e1495f067`, remains `IN_PROGRESS`.
- Sent a narrowing instruction:
  prioritize a concrete finite 2 by 2 nonzero witness, allow `≠ 0` instead of
  exact `= 2`, allow dropping the full iff if it is the blocker, and preserve
  the no-release claim boundary.

## Literature search

- Query/source:
  `neo4j_paper_search.py --chunks --query "finite witness nonzero trace exact value unnecessary chiral index origin matrix example"`.
- Result summary:
  top chunks included Nielsen-Ninomiya chiral-block matrices, Dirac-Kahler
  chiral/flavour projection, minimally doubled chiralities and spectral flow,
  finite trace simplifications in loop diagrams, nonabelian trace formulas, and
  finite matrix norm examples.
- Plan impact:
  no strategy change. The search supports using finite explicit matrix witnesses
  as non-vacuity checks, not as release claims.

## Track A

- Polled C108d; still running.
- Sent the narrowing instruction to Aristotle.
- Sent the narrowing decision to Claude for adversarial review.

## Track B

- No separate Track B artifact was created. The cycle's real action was C1_NU
  finite witness narrowing.

## Claude

- Sent mandatory cycle review:
  `AgentTasks/model-calls/claude/2026-06-27-164241-cycle21-c108d-narrowing-review.md`.
- Claude verdict:
  good narrowing.
- Useful result preserved:
  a concrete kernel-checked 2 by 2 witness with nonzero chiral trace and
  nonzero odd-part chiral trace is enough for finite non-vacuity.
- Remaining theorem debt if only the narrowed witness returns:
  general arbitrary-`J` helper lemmas, full iff characterization, and any
  uniformity/basis-independence statement.

## Validation

- No local Lean/pre-commit run.

## Next cycle

- Poll C108d first.
- If it returns, recover/preserve and review it.
- If still blocked, consider an even smaller split into two explicit examples:
  nonzero chiral trace first, odd-part nonzero second.
