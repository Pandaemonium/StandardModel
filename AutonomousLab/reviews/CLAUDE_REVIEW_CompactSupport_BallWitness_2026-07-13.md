# Claude review: CompactSupportL2Generator ballWitness proofs (2 closed holes)

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-154806, item CONT-FOURIER-001
- Sources: `CompactSupportL2Generator.lean` (285, sha ff603763 MATCH),
  `OvernightTheoryAxiomGuard.lean` (central guard, sha 79b02425 MATCH)
- Scope: audit ONLY the two newly-closed witness theorems + guards + hole prose.
  The five still-open analytic statements are NOT reviewed as landed.
- Date: 2026-07-13
- Context: this closes 2 of the 7 holes I flagged in my original
  CompactSupportL2Generator review (the non-vacuity witnesses).

## Verdict: ACCEPT

Both `ballWitness_boundedSupport` and `ballWitness_ne_zero` are correct,
representative-independent, non-vacuous, and correctly guarded locally AND
centrally; the prose now accurately says five holes remain. This resolves the
non-vacuity gap from my original review (the compact-support generator theorem
now has a proven nonzero witness). No changes required.

## The two closed theorems

### ballWitness_boundedSupport (line 203) - correct, representative-independent

`ballWitness R w := indicatorConstLp 2 measurableSet_closedBall (finite-measure) w`
(finite measure via `measure_closedBall_lt_top`). The theorem proves
`BoundedSupport R (ballWitness R w)`:
- **Representative independence (the requested check):** the proof does NOT touch
  a raw representative. It rewrites through `indicatorConstLp_coeFn` (the a.e.
  equality `ballWitness R w =ᵐ (closedBall).indicator (fun _ => w)`), then
  `filter_upwards` to reason a.e. `BoundedSupport` is itself the a.e. predicate
  `∀ᵐ k, R < ‖k‖ → f k = 0`, so the whole argument stays representative-free.
- **Closed-ball support inequality:** for `R < ‖k‖` (i.e. `k ∉ closedBall 0 R`),
  `Set.indicator_of_notMem` gives `0`, discharged via
  `Metric.mem_closedBall`/`dist_zero_right`/`not_le`. Correct.

### ballWitness_ne_zero (line 219) - correct nonzero-norm argument

For `R > 0`, `w ≠ 0`: by contradiction from `ballWitness = 0` (so norm `= 0`).
`norm_indicatorConstLp` gives `‖ballWitness‖ = ‖w‖ * vol(closedBall)^(1/2)`:
- **Positivity / finite-volume (the requested check):** `vol(closedBall 0 R)` is
  POSITIVE (`Metric.measure_closedBall_pos ... hR`, needs `R > 0`) and FINITE
  (`measure_closedBall_lt_top`); `ENNReal.toReal_pos` consumes both to give
  `vol.toReal > 0`, then `Real.rpow_pos_of_pos` gives the `(1/2)`-power `> 0`.
- **Nonzero norm:** `‖w‖ ≠ 0` (from `w ≠ 0`) times the positive volume power is
  nonzero (`mul_ne_zero`), contradicting norm `= 0`. Correct. The `R > 0` and
  `w ≠ 0` hypotheses are both genuinely used - not vacuous.

## Guards (local AND central) - both correct

- **Local** (CompactSupportL2Generator 248-270): SIX proper
  `#guard_msgs (whitespace := lax) in #print axioms`, now including
  `ballWitness_boundedSupport` (264-266) and `ballWitness_ne_zero` (268-270),
  all pinned `[propext, Classical.choice, Quot.sound]`. The guard-section
  docstring correctly updated to "the SIX theorems." The two still-`sorry`
  guards (`genMult_apply_memLp`, `momMultL2Isometry_hasDerivAt_zero`) remain
  commented out, and the comment uses the spaced `s o r r y` form (good hygiene).
- **Central** (OvernightTheoryAxiomGuard 3917-3941): the
  "CompactSupportL2Generator: completed norm and momentum-continuity rung"
  section now has proper `#guard_msgs`-wrapped `#print axioms` for ALL SIX,
  including `ballWitness_boundedSupport` (3935-3937) and `ballWitness_ne_zero`
  (3939-3941). So the witnesses are pinned in the lane's central guard too.

## Prose / hole count - correct

Docstring line 18: "remain five explicit draft proof holes." Correct: the module
had 7 holes; the two `ballWitness_*` witnesses are now proved, leaving 5
(`momMult_sub_id_norm_le`, `slope_norm_le`, `genMult_apply_memLp`,
`orbit_slope_tendsto`, `momMultL2Isometry_hasDerivAt_zero`). Confirmed `sorry`
count `= 5`. The five remain genuinely open and are NOT reviewed here as landed.

## Independent build/replay footprint

`lake env lean` on BOTH files: **EXITCODE=0 each**, no `error:`, no `#guard_msgs`
mismatch, no `declaration uses sorry` (the 5 remaining `sorry`s are documented
draft holes, which produce warnings only). So the LOCAL guards (6, incl. both
witnesses) pass, AND the full CENTRAL guard file `OvernightTheoryAxiomGuard`
elaborates green - confirming the two witness `#guard_msgs` there (and every other
central pin) match `[propext, Classical.choice, Quot.sound]`. Both witnesses are
kernel-clean at the standard three, locally and centrally.

## Bottom line

ACCEPT. The two witness proofs are correct and representative-independent, the
positivity/finite-volume and nonzero-norm arguments are sound, both local and
central axiom guards now pin the six completed theorems to the standard three,
and the prose accurately reports five remaining holes. The compact-support
generator theorem is now non-vacuous (a proven nonzero compact-support witness),
closing the gap I flagged originally. The five analytic holes (Duhamel/slope
bounds, MemLp, dominated-convergence derivative) remain the open work.
