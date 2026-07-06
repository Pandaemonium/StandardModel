# Lane A (aperture) — N-body origin of mass: finalize report

**File delivered:** `PhysicsSM/Draft/NullEdge/GateI1/NBodyAperture.lean`

**Finalize mode:** proof search stopped on request; **no `lake build` was run**.
The status below reflects the source as written (reuse-based lemmas are direct
`exact` applications of already-proved results in `CompositeApertureMass.lean`).

## Proved (by reuse of `CompositeApertureMass` / `ApertureEqualsTurn`)

- `nbody_massSq_eq_double_sum` — `minkowskiSq (∑ p_i) = ∑_i ∑_j minkDot p_i p_j`
  (= `minkowskiSq_sum`).
- `nbody_minkDot_nonneg` — every cross term `minkDot p_i p_j ≥ 0`
  (= `minkDot_nonneg_of_futureNull`).
- `nbody_massSq_nonneg` — composite Minkowski square `≥ 0` for future-null
  constituents (= `compositeMassSq_nonneg`). **Deliverable (1) nonnegativity.**
- `nbody_massSq_eq_zero_iff_pairwise` — massless iff all pairwise products vanish
  (= `compositeMassSq_eq_zero_iff_pairwise`).
- `nbody_aperture_massless_iff_collinear` — **THE N-BODY HEADLINE**: for ANY N,
  `minkowskiSq (∑ p_i) = 0 ↔` the whole null bundle is collinear (one null
  direction) (= `compositeMassSq_eq_zero_iff_collinear`). **Deliverable (2).**

## Open

- `nbody_massSq_eq_sum_pairwise` (`sorry`) — the strict upper-triangular
  `∑_{i<j} 2·minkDot` presentation of deliverable (1). This is only a
  combinatorial re-indexing of the already-proved double sum (diagonal terms
  vanish by nullness; off-diagonal terms pair via `minkDot_comm`). Left `sorry`
  because certifying the re-indexing would require further proof search /
  `lake build`, which the finalize instruction excluded. The mathematically
  equivalent, fully-proved form is `nbody_massSq_eq_double_sum` together with
  `nbody_minkDot_nonneg`.

## Notes

- No new axiom, no `native_decide`, no weakening of statements. All content is
  frame-invariant kinematics (`minkDot`, `minkowskiSq` are Lorentz invariants).
- No prior `ARISTOTLE_SUMMARY.md` or in-progress `NBodyAperture.lean` was present
  in the repository at the start of this session (working tree was clean at the
  initial commit); this file was assembled fresh from the reusable lemmas named
  in the task.
