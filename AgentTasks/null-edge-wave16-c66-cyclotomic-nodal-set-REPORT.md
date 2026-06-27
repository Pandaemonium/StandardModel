# C66 cyclotomic nodal-set classification — result report

Date: 2026-06-27.

Target module: `PhysicsSM/Draft/NullEdgeNodalSetCyclotomic.lean`
(`PhysicsSM.Draft.NullEdgeNodalSetCyclotomic`). Builds clean, no `sorry`; the
main summary `c66_cyclotomic_summary` uses only `propext, Classical.choice,
Quot.sound`.

## What was solved (preferred-target mapping)

**Target 1 — generalize `q⋆` to a finite orbit (DONE).**
`cycPhase i j` (`q_i = 2π/3`, `q_j = 4π/3`, `0` elsewhere) ranges over the full
ordered-distinct-pair `S₄` orbit (12 points) of the C64 witness. Proven for every
`i ≠ j`:
- `cyc_qform_zero` — scalar Lorentzian zero `qform (phaseU (cycPhase i j)) = 0`;
- `cyc_mink_zero` — full Clifford-determinant zero `mink (pCov …) = 0`;
- `cyc_ne_origin` — nonzero (not the origin component);
- `cyc_off_branchLine` — lies on none of the four certified branch lines.
- `cycPhase_zero_three_eq_extraPhase` — `cycPhase 0 3` is exactly the C64 `q⋆`.

**Target 2 — characterize the cyclotomic family / mechanism (DONE).**
- `qform_zero_iff_sumSq` — abstract criterion `qform u = 0 ↔ (Σuₐ)² = 3·Σuₐ²`.
- `qform_pairVec` — for a two-edge support (`i ≠ j`, values `c,d`),
  `qform (pairVec i j c d) = −½·(c² − c·d + d²)`, so a two-support point is a zero
  **iff** `c/d` is a primitive sixth root of unity.
- `cubeRootPair_vanishes` — the cube-root instance `(ω−1)² − (ω−1)(ω²−1) +
  (ω²−1)² = 0` realizing the family on the torus.

**Target 3 — does the `T_lin`/`g5` split fail on the whole family? (SHARPENED).**
This was sharpened to a closed form and an exact criterion (the naive "fails on
the whole orbit" is *false* and would have been a silent weakening):
- `cyc_Tlin_g5` — `T_lin[g5] (cycPhase i j) = −¾·(g5 i + g5 j)`.
- `cyc_Msplit_g5_zero_iff` — for any `r`, `M_split = 0 ↔ r = 0 ∨ g5 i + g5 j = 0`.
- `g5_split_fails_on_straddle` / `g5_split_fails_whole_qstar_orbit` — the split
  **never** gaps the 8 *straddling* points (one excited edge in each `g5` block
  `{0,1} | {2,3}`), which is precisely the `g5`-symmetry orbit of `q⋆`.
- `g5_split_gaps_within_block` — the split **does** gap the remaining 4
  within-block cyclotomic points (`r ≠ 0`).

So the `g5` split provably controls part of the cyclotomic family but provably
not the part containing `q⋆`.

**Target 4 — full iff classification of the determinant-zero locus (PARTIAL).**
Not claimed. The orbit is the cube-root locus of the *two-support* sub-family;
the full complex sheet `{q | qform (phaseU q) = 0}` is higher-dimensional and is
not classified here (honest scope note in the module docstring).

**Target 5 — strategy for the remaining locus (RECORDED below).**

## Strategy for the remaining classification

- `qform_zero_iff_sumSq` reduces everything to `(Σuₐ)² = 3·Σuₐ²` with
  `uₐ = e^{iqₐ}−1`. Two regimes are now fully understood: one zero component +
  three equal (the certified branch lines, C43/C44) and two zero components
  (cyclotomic, this module — on the torus forced to cube roots by
  `qform_pairVec` plus the sixth-root/modulus constraint).
- Remaining: the no-vanishing-component sheet. Suggested next step — parametrize
  by `wₐ = e^{iqₐ}` on `(S¹)⁴`, expand `(Σwₐ − 4)² = 3 Σ(wₐ−1)²`, and split into
  real/imag parts to get two real equations cutting a 2-surface; then enumerate
  the finitely many cube-root corners via the count vector `(n₀,n₁,n₂)` to confirm
  `(2,1,1)` is the only nontrivial non-branch cube-root multiset (hand
  computation already matches the Lean two-support result).

## Remaining blockers / handoff markers

- No proof holes in the delivered module (no `sorry`, no axioms beyond the
  standard three).
- Open (flagged, not a hole): full classification of the non-two-support zero
  sheet (Target 4).
- The `g5` species split is now known to be insufficient on the `q⋆` straddling
  orbit; a branch/Krein/Weyl projection (the C21
  `OperatorForcesAlignmentAfterProjection` obligation) remains the route to
  control these off-branch zeros. This is nodal control only — no Furey/internal
  legality is claimed.

## Files changed

- Added: `PhysicsSM/Draft/NullEdgeNodalSetCyclotomic.lean`.
- Modified: `PhysicsSMDraft.lean` (added the module to the draft import root).
- Modified: `lake-manifest.json` (the optional `SpherePacking` dependency was
  materialized so the workspace configures; no source code in the project was
  otherwise altered).
