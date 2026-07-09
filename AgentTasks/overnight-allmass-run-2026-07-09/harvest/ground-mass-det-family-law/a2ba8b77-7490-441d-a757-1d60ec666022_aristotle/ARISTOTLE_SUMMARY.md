# Summary of changes for run a2ba8b77-7490-441d-a757-1d60ec666022
Delivered `RequestProject/Main.lean` (namespace `GroundMassDetFamilyLaw`) plus `ARISTOTLE_SUMMARY.md`. The file builds cleanly under Mathlib with no `sorry`/`admit`/`native_decide`/new axiom, and every headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`.

Setup: `P lam kap = !![lam, kap; kap, lam]` over `ℚ` (real symmetric 2×2), ground mass `mu- = lam-kap`, top mass `mu+ = lam+kap`, defect `mu- - lam`.

All nine targets proved (via `Matrix.det_fin_two`/`trace_fin_two`/`mul_adjugate` + fin_cases/ring/norm_num; no transcendental, no Complex, no nlinarith):
1. `char_poly`: `(X • 1 - P).det = (X-(lam-kap))*(X-(lam+kap))`.
2. `det_closed`: `det = lam^2 - kap^2`.
3. `trace_closed`: `trace = 2*lam`.
4. `det_eq_eigenvalue_product`: `det = (lam-kap)*(lam+kap)`.
5. `defect_exact`: `(lam-kap) - lam = -kap` (exact defect, all lam,kap).
6. `groundmass_det_family_law` (prize): `det = (lam-kap)*(2*lam-(lam-kap))` — ground mass is the smaller root of `mu^2 - tr*mu + det = 0`.
7. `spectral_answers_to_invariants`: `mu+*mu- = det` and `mu+ + mu- = tr` (spectrum an exact function of `(tr,det)`).
8. `free_bridge_adjugate`: `P * adj P = det P • 1`.
9. `ground_mass_det_verdict`: packages 4,5,6,7.

Mandatory non-degeneracy witnesses are all in-theorem: `witness_massive` (lam=5,kap=3: mu-=2, mu+=8, det=16, defect=-3, 16=2*(10-2)); `witness_critical` (lam=kap=4: mu-=0, det=0); `witness_overclosure` (lam=3,kap=5: mu-=-2<0, det=-16); and `witness_ground_masses_distinct` showing the ground masses 2,0,-2 are pairwise distinct (non-vacuous).

`ARISTOTLE_SUMMARY.md` states the honest reading: this converts the central §3↔§4 tie from the witness-level coincidence of the killed trace-side `budget = c*detP` into an exact determinant-side family law (ground mass answers to `det` given `tr`); it references (does not import) `BudgetSignMismatch`/`MassPhaseDiagram` and does not re-derive the spectrum/determinant — the new content is the family-law synthesis and the exact-defect / spectral-vs-invariants framing. All work committed and pushed.

# Ground-mass ↔ determinant family law (determinant-side)

`RequestProject/Main.lean`, namespace `GroundMassDetFamilyLaw`. Builds under Mathlib
(Lean 4.28.0); no `sorry`/`admit`/`native_decide`/new axiom. Every headline carries an
in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>` confirming the footprint
is exactly `[propext, Classical.choice, Quot.sound]`.

## Honest reading

A prior kernel kill-test (`BudgetSignMismatch`, a REFERENCE only) showed the naive
TRACE-side slogan `budget = c * detP` is FALSE as a family law: the sum-of-squares budget
and the Gram determinant depend on the off-diagonal with OPPOSITE sign, so no constant `c`
works for all configs (it fits only at a single witness). This module proves the CORRECT,
EXACT law, which lives on the DETERMINANT / SPECTRAL side.

It converts the central §3↔§4 tie from a witness-level coincidence (the killed trace-side
`budget = c * detP`) into an EXACT determinant-side FAMILY law: the ground mass answers to
`det` given `tr`, for ALL `(lam, kap)`. It does NOT re-derive the spectrum/determinant of
the block (those are `MassPhaseDiagram`'s); the new content is the family-law synthesis and
the exact-defect / spectral-vs-invariants framing.

## Setup

`P lam kap = !![lam, kap; kap, lam]` over `ℚ` — the aperture-closure sector block (real
symmetric `2×2`, same avatar as `BudgetSignMismatch`'s `detP` and `MassPhaseDiagram`'s `B3`
aperture-closure part). `lam` = free sector mass, `kap` = closure coupling, ground mass
`mu- = lam - kap`, top mass `mu+ = lam + kap`, binding defect `Delta = mu- - lam`.

## Results

1. `char_poly`: `(X • 1 - P).det = (X - (lam-kap)) * (X - (lam+kap))` — eigenvalues exactly `lam ± kap`.
2. `det_closed`: `(P).det = lam^2 - kap^2`.
3. `trace_closed`: `(P).trace = 2*lam`.
4. `det_eq_eigenvalue_product` (payload): `det = (lam-kap)*(lam+kap) = mu- * mu+`.
5. `defect_exact` (payload): `(lam-kap) - lam = -kap` for ALL `lam kap` — the defect is
   EXACTLY the closure coupling, not a fitted multiple of `detP`.
6. `groundmass_det_family_law` (PRIZE): `det = mu- * (tr - mu-)`, i.e. the ground mass is
   the smaller root of `mu^2 - tr*mu + det = 0`.
7. `spectral_answers_to_invariants` (contrast, payload): `mu+*mu- = det` AND `mu+ + mu- = tr`
   — the spectrum is an exact function of `(tr, det)`. Contrast (cf. `BudgetSignMismatch`):
   the trace-side budget is NOT a function of `det` alone; the ground mass IS fixed by
   `(tr, det)`. This is why the correct §3↔§4 tie is determinant-side.
8. `free_bridge_adjugate`: `P * adj P = det P • 1` (2×2 Cramer/adjugate identity), the free
   determinant bridge holds identically.
9. `ground_mass_det_verdict` (verdict): packages 4, 5, 6, 7.

## Non-degeneracy witnesses

- `witness_massive` (`lam=5, kap=3`): `mu- = 2`, `mu+ = 8`, `det = 16`, defect `-3`, `16 = 2*(10-2)`.
- `witness_critical` (`lam=kap=4`): `mu- = 0` (massless ground; binding saturates), `det = 0`.
- `witness_overclosure` (`lam=3, kap=5`): `mu- = -2 < 0` (tachyonic ground; over-closure), `det = -16`.
- `witness_ground_masses_distinct`: ground masses `2, 0, -2` are pairwise distinct, so the law is non-vacuous.
