# Aristotle semantic red-team: YM1 rectangular boundary expectation bridge

You are acting as a semantic red-team reviewer for a Lean 4 mathematical
physics formalization. This is not primarily a proof-search job. The goal is to
audit whether the newly integrated YM1/Q11 theorem and surrounding claim
language match the kernel-checked Lean statements.

Formatting: ASCII only, LF line endings. In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Context

Project: `PhysicsSM`, draft GateYM Yang-Mills ladder.

Recent commit `924ee09` integrated Aristotle project `acedaea2` as:

```text
PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean
```

The main theorem is:

```text
PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryExpectation.rect_boundary_wilson_loop_expectation_area_law
```

The intended claim is:

```text
YM1/Q11 is draft-closed for the concrete rectangular boundary-circuit
expectation theorem: for an arbitrary finite group and a unitary finite
representation, the link-ensemble expectation of the character of the full
rectangular boundary holonomy equals
R.character 1 * Theorem2AreaLaw.wilsonNormalizedGamma beta rho R ^ (Lx * Ly).

This is an expectation-level gauge-orbit theorem. It must NOT be described as a
pointwise identity between the boundary holonomy and the reversed row-major
plaquette product at arbitrary link fields.

No trusted promotion, infinite-volume statement, continuum Yang-Mills theorem,
or physical mass-gap theorem is claimed.
```

## Files to Inspect

Please inspect at least:

```text
PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean
PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryLasso.lean
PhysicsSM/Draft/NullEdge/GateYM/RectTreeGauge.lean
PhysicsSM/Draft/NullEdge/GateYM/TreeGaugeBridge.lean
PhysicsSM/Draft/NullEdge/GateYM/IndependentPlaquetteEnsemble.lean
PhysicsSM/Draft/NullEdge/GateYM/Theorem2AreaLaw.lean
PhysicsSM/Draft/NullEdge/GateYM/FusionConvolution.lean
PhysicsSM/Draft/NullEdge/GateYM/GaugeCoreGeneral.lean
PhysicsSM/Draft/NullEdge/GateYM/PlaquetteCore.lean
PhysicsSM/Draft/NullEdge/GateYM.lean
AgentTasks/ym1-rectboundary-ensemble-aristotle-2026-07-04.md
AgentTasks/paper-units/ym1-area-law-outline.md
AgentTasks/fourday-ym-run-2026-07-05/DAY_1_REPORT.md
AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md
AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md
```

Semantic preflight context pack included in the submission:

```text
AgentTasks/context-packs/ym1-rectboundary-expectation-redteam-20260704-20260704-180906.md
```

Use that pack only as context-selection evidence; the Lean files and run notes
are authoritative.

## Questions

1. Does `rect_boundary_wilson_loop_expectation_area_law` actually express the
   claimed rectangular boundary-circuit Wilson expectation theorem? Check the
   observable, lattice, area exponent, representation hypotheses, and scalar
   `wilsonNormalizedGamma`.
2. Does the proof route genuinely avoid the known-false pointwise identity at
   arbitrary link fields? In particular, inspect `treeSlice_sum_indep_t`,
   `treeSlice_summand_eq`, `linkNumerator_boundary_eq`, and
   `linkExpectation_boundary_eq` for hidden stronger assumptions.
3. Are the bridge lemmas semantically aligned with `RectBoundaryLasso`,
   `RectTreeGauge.rect_wilson_loop_expectation_area_law`,
   `TreeGaugeBridge.linkExpectation`, and
   `IndependentPlaquetteEnsemble.wilson_loop_expectation_area_law`?
4. Are there hidden restrictions or accidental degeneracies such as only
   trivial rectangles, empty plaquette sets, commutative groups, a wrong
   boundary orientation, a reversed area convention, or a mismatch between
   `R.character` and the Wilson local weight representation `rho`?
5. Are the updated claim docs honest? In particular, is it correct to say
   "YM1/Q11 draft-closed for the concrete rectangular boundary-circuit
   expectation theorem" while still refusing trusted promotion,
   infinite-volume, continuum, and physical mass-gap claims?
6. Is any theorem statement too weak for the stated claim, or too strong in a
   way that might be false under the intended physics reading?

## Output Format

Return a concise audit report with:

1. Verdict: ACCEPT, ACCEPT WITH CHANGES, or REJECT.
2. Findings ordered by severity, with file/theorem references.
3. Any exact claim-language corrections needed.
4. Any Lean-level theorem statement or docstring guardrail that should be added
   next to prevent future over-claiming.
5. Recommended next YM1 step: paper-unit proof inventory, promotion-readiness
   review, additional theorem wrapper, documentation cleanup, or park.

Do not weaken Lean theorem statements silently. If you find a semantic
counterexample, hidden hypothesis, convention mismatch, or overclaim, state it
plainly.
