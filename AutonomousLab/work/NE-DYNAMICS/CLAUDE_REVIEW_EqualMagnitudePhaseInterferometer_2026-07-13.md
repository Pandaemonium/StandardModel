# Claude cross-family review: EqualMagnitudePhaseInterferometer (e2cc5463)

- Reviewer: interactive Claude Code (claude family)
- Builder: Codex (Aristotle e2cc5463)
- Work item: `DYN-MODULAR-001`
- Source: `PhysicsSM/Draft/NullEdge/EqualMagnitudePhaseInterferometer.lean` (108 lines),
  sha256 a01c9e73... verified
- Date: 2026-07-13

## Verdict: ACCEPT

## Item-by-item

1. **Equal local magnitudes.** `equal_local_magnitudes`: for all edges,
   `normSq(trivialSquareEdgeField x y) = normSq(squareEdgeField x y)`. The
   trivial field is `1` on every edge; `squareEdgeField` (the landed fixture)
   carries unit-modulus phases. Both magnitudes are `1`. Genuinely equal.
2. **Gauge invariance.** `squareInterferenceScore_gauge_invariant`: the score
   `normSq(1 + closed-loop holonomy)` is invariant under every unit-norm vertex
   gauge `g`, via `closed_pathHolonomy_gauge_invariant` + `square_loop_closes`.
   Correct (closed-loop holonomy is gauge-invariant).
3. **Loop / fixture.** The loop is `pathHolonomyFrom U 0 [1,2,3,0]` (oriented
   square, closes by `square_loop_closes`), and the nontrivial case uses
   `square_nontrivial_gauge_invariant_witness` on the landed `squareEdgeField`
   I-holonomy fixture. Same landed fixture.
4. **Exact scores 4 and 2.** `trivial_square_score`: holonomy `= 1`, so
   `normSq(1 + 1) = 4`. `nontrivial_square_score`: I-holonomy, so
   `normSq(1 + I) = 1 + 1 = 2`. Both correct.
5. **Operationally nondegenerate but supplied-phase only.** The capstone
   `equal_magnitude_profiles_are_operationally_distinct` bundles equal magnitudes,
   `4 != 2` (score difference), AND gauge-robustness (score `= 2` for every
   unit-norm gauge of the nontrivial profile). Docstring: "an operational finite
   U(1) phase discriminator. The edge phases are SUPPLIED data: the theorem does
   not yet derive them from local Pluecker fields, embed the pair-transfer
   dynamics, or claim an experimental prediction." Correctly scoped.

## Overclaim tests

Vacuity: none (`4 != 2`, gauge-invariant). Hollow: none (real gauge-invariant
interference computation). Docstring overreach: none (supplied-phase, no Pluecker
derivation, no experiment). False shape: none -- a gauge-invariant interference
score distinguishing equal-magnitude profiles by closed-loop phase is the correct
shape for an operational discriminator.

## Independent verification

- `lake build ...EqualMagnitudePhaseInterferometer`: Build completed
  successfully (8027 jobs), exit 0. Three `#guard_msgs` blocks fired and passed;
  axiom footprint `[propext, Classical.choice, Quot.sound]`, build-enforced.

## Narrowest defensible claim

Two finite `U(1)` edge profiles with identical local edge magnitudes (the
trivial square and the landed I-holonomy square) are distinguished by an exact,
gauge-invariant closed-loop interference score (`4` vs `2`), and that difference
survives every unit-norm vertex gauge transformation. This is an operational
supplied-phase discriminator on a fixed finite fixture; it does not derive the
edge phases from Pluecker fields, embed pair-transfer dynamics, or constitute an
experimental prediction.
