# Aristotle audit job: P9/P7 operational guardrails after latest finite wins

This is a no-code strategy/audit job. Do not build Lean, do not edit Lean files,
and do not try to prove the whole program. We want a theorem-selection report
that changes what Codex should submit next.

## Physics context

Program lane / paper: P9 source visibility and P7/P1 observer-channel mass.

Four-layer status:

- finite identity: several small finite theorems are now kernel-checked;
- naturality: still under audit, especially for coarse maps and observer
  channels;
- dynamics: not proved here;
- physical interpretation: source visibility and observer-channel mass remain
  guardrail programs, not completed physics.

Recent finite results:

1. `PhysicsSM.Draft.NullEdgeP9OperationalGap` proves that the six-point T1
   witness has an operational diamond-local gap at bucket `1`.
2. `PhysicsSM.Draft.NullEdgeP9OperationalGapCoarseMap` proves that the named
   critical coarse map erases that operational gap.
3. `PhysicsSM.Draft.NullEdgeP9SubdiamondRestrictionPreservesLocalReadout`
   proves a generic Alexandrov/subdiamond preservation theorem under
   transitivity.
4. `PhysicsSM.Draft.NullEdgeP9SubdiamondNonvacuity` proves that the witness has
   a proper subdiamond separator, so the preservation theorem is not merely
   whole-diamond tautology.
5. `PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet` proves that two
   trace-one positive real symmetric `2 x 2` density proxies can have the same
   determinant mass observable but different off-diagonal coherence.

Why this matters physically: P9 needs to know whether finite source visibility
is a stable observer-channel phenomenon or an artifact of hand-picked readouts.
P7/P1 needs to know whether determinant mass is only one visible scalar while
chirality/hidden coherence is operationally separate.

What would weaken or falsify the interpretation:

- If P9 gaps survive or vanish only under hand-picked coarse maps, demote the
  branch to a catalog of examples.
- If subdiamond preservation is vacuous or non-intrinsic, do not use it as
  source-visibility evidence.
- If P7 coherence cannot be operationally separated by a named finite
  observable, demote it from physics to parametrization.

## Audit request

Please give an adversarial but constructive theorem-selection report.

Return exactly these sections:

1. **Top theorem to submit next.** Give one finite Lean-style theorem statement
   that would most reduce ambiguity. Include definitions needed, expected proof
   method, and whether it is likely a proof job or a counterexample job.
2. **Second and third choices.** Same format, but shorter.
3. **Coarse-map universality audit.** Is the next P9 job more likely to be:
   enumerate all surjective order-preserving maps of the six-point witness,
   prove a class theorem, or find a preserving counter-map? Explain.
4. **P7 operational-separation audit.** Give the smallest rational `2 x 2`
   observable/POVM-style witness that separates the banked same-det
   different-coherence pair, or explain why that is the wrong next move.
5. **Suggested next steps.** List the next 3 Codex actions after reading your
   report.

## Completion report

End with:

- what was planned:
- useful counterexamples/construction blockers found:
- suggested next high-value theorem or fallback lane:
- suggested literature or convention check:
- highest-risk remaining gap:
