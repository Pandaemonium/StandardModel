# Task: torus-genuine zero-or-pi doubling (Paper B frontier, correctly shaped)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, Paper B lane.
Self-contained package (12 modules). Your predecessor project proved the
combined-balance gate, the live two-point census (origin zero-crossing +
all-`π` corner PI-crossing with charges `+1` and `-1`), and the `ℝ³`-shaped
universal statement - while correctly documenting that the `ℝ³` shape is
too weak: periodicity makes `(2π, 0, 0)` an origin alias. This job states
the TORUS-GENUINE version via lattice noncongruence.

## Target

`PhysicsSM/Draft/NullEdge/Strict3Plus1TorusDoubling.lean` - five theorems
ending in a hole (ladder, partial success pre-registered):

1. `latticeCongruentZero_origin`, `latticeCongruentZero_two_pi` - witness
   plumbing (`n = 0`; `n = (1,0,0)`).
2. `not_latticeCongruentZero_all_pi` - each coordinate would need
   `π = 2π n`, i.e. `2n = 1` in `ℤ` after cancelling `π ≠ 0`; kill by
   parity/integrality (`Real.pi_ne_zero`; no irrationality needed).
3. `splitU_torus_doubling` - the LIVE walk's torus-genuine doubling:
   witness the all-`π` corner. Its pi-crossing
   (`det (splitU (π,π,π) + 1) = 0`) was established inside the
   predecessor's census proof (`splitStep_combined_corner_census` in the
   included successor file); re-derive it as a named lemma if extracting
   from the existential is awkward - the determinant computation pattern
   is right there in that proof (`norm_num [Matrix.det_succ_row_zero]`
   after unfolding the walk).
4. `admissible_doubling_torus` - the RESEARCH FRONTIER, now correctly
   shaped: every `AdmissibleWalk` has a combined crossing NOT congruent to
   the origin lattice. Intended route: a degree/winding-parity argument
   for `q ↦ det (U q - 1) * det (U q + 1)` over a fundamental domain
   `[0, 2π)³` (continuity + periodicity from the structure fields;
   Mathlib's `intermediate_value`-family and compactness may substitute
   for a full degree theory in a first version - e.g. a parity argument
   along the axis path `t ↦ U (axisRay j t)` from `0` to `2π` using the
   Dirac-tangent derivative at `0`). If out of reach, prove targets 1-3
   and return a precise proof-plan report (candidate charge construction,
   missing Mathlib ingredients, <= 3 follow-up lemmas). A kernel
   COUNTEREXAMPLE (an admissible walk with all combined crossings on the
   origin lattice) is a first-class outcome - do not suppress it.

## Constraints

- Do not modify included modules; do not weaken target 4.
- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with
  `lake env lean PhysicsSM/Draft/NullEdge/Strict3Plus1TorusDoubling.lean`
  first.

## Success criteria

Target 4 proven or refuted is FULL success; targets 1-3 plus a precise
plan report is partial success. Completion report: solved targets,
statement changes, remaining holes, axioms used.
