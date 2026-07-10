# Summary of changes for run c9cfeed1-9e5a-44eb-b210-1b2b9ec682bf
Completed the carrier-sector mass-gap proof job in `AllMassGap/Core.lean` (Mathlib-only). The file builds with `lake env lean` / `lake build` and contains no `sorry`; every result depends only on the standard axioms `propext`, `Classical.choice`, `Quot.sound`.

Definition: `B lam kappa : Matrix (Fin 3) (Fin 3) ℂ = !![lam, kappa*I, 0; -(kappa*I), lam, 0; 0, 0, lam]` (with `open scoped ComplexOrder` so `PosDef`/`PosSemidef` over ℂ resolve).

Proved theorems:
- `B_isHermitian` : `(B lam kappa).IsHermitian`.
- `B_det` : `(B lam kappa).det = lam * (lam^2 - kappa^2)`.
- `B_posDef_iff` : `(B lam kappa).PosDef ↔ kappa < lam ∧ -lam < kappa` (two-sided `|kappa| < lam`, i.e. massive iff aperture dominates closure). Proved via the quadratic-form characterization `posDef_iff_dotProduct_mulVec`.
- `B_posDef_iff_of_nonneg` : for `0 ≤ kappa`, `PosDef ↔ kappa < lam`.
- `B_massless_iff` and `B_massless_iff_of_pos` (see correction below).
- `B_shift_posSemidef` : `B lam kappa - (lam-kappa)•1` (which equals `B kappa kappa`) is positive semidefinite for `0 ≤ kappa` — every eigenvalue of `B` is `≥ lam - kappa`.
- `B_shift_det` : that shifted block is singular (`det = 0`) — `lam - kappa` is an eigenvalue.
- `B_least_eigenvalue` : `IsLeast (Set.range (B_isHermitian lam kappa).eigenvalues) (lam - kappa)` for `0 ≤ kappa` — the least eigenvalue is exactly aperture minus closure. Proved cleanly through the real spectrum: `spectrum ℝ B = range eigenvalues`, `spectrum.sub_singleton_eq` to shift, singularity for membership, and positive-semidefiniteness of the shift for the lower bound.

Semantic alignment / corrections:
- The mass phase diagram is pinned exactly as requested: eigenvalues `{lam-kappa, lam, lam+kappa}`, gap = aperture − closure, massive iff `|kappa| < lam`, and the least eigenvalue `lam - kappa` generalizes the fixed `(lam,kappa)=(2,1)` point.
- The literal task statement `B_massless_iff : det = 0 ↔ kappa = ±lam` is FALSE when `lam = 0`: then `det = lam*(lam²-kappa²) = 0` for every `kappa`. I therefore state the honest unconditional form `B_massless_iff : det = 0 ↔ lam = 0 ∨ kappa = lam ∨ kappa = -lam`, and add `B_massless_iff_of_pos` (`0 < lam`) giving the intended critical line `det = 0 ↔ kappa = ±lam`. The `equivalently det = lam*(lam²-kappa²)` form is exactly `B_det`. This is documented in the theorem docstring.
- The task asked for the least-eigenvalue result under `0 ≤ kappa ≤ lam`. The `kappa ≤ lam` hypothesis (`hlk`) is kept in `B_least_eigenvalue` as requested but turns out to be unnecessary (documented in the docstring); the result holds for all `0 ≤ kappa`. The `B_shift_*` helpers therefore only assume `0 ≤ kappa`.

All work is committed and pushed to `origin/main`.
