/-
# The carrier sector mass gap is aperture minus closure

Proof job (Aristotle). Kernel-checks the phase-diagram result of the dynamics
spectrum simulator (`Scripts/oracle/carrier_spectrum_sim.py`): on the two-edge
Cl(4) carrier the physical-sector mass form is block-diagonal with the `3x3`
Hermitian block

  B(lam, kappa) = !![lam, kappa*I, 0; -kappa*I, lam, 0; 0, 0, lam]   (I = Complex.I)

(aperture strength `lam`, closure strength `kappa`, both real). Its spectrum is
`{lam - kappa, lam, lam + kappa}`, so the **least eigenvalue is `lam - kappa`**
(for `kappa >= 0`): the squared mass gap is *aperture minus closure*, the state
is massive iff `kappa < lam`, and massless exactly on `kappa = lam`. This
generalizes the fixed `(lam,kappa)=(2,1)` point of `T2_positive_mass` to the
whole coupling plane and pins the critical line.

## Targets (prove kernel-clean, no `s o r r y`)

Let `lam kappa : ℝ`, `B := !![(lam:ℂ), kappa*Complex.I, 0; -(kappa*Complex.I),
lam, 0; 0, 0, lam]` (a `Matrix (Fin 3) (Fin 3) ℂ`).

- **B_isHermitian:** `B.IsHermitian`.
- **B_posDef_iff:** `B.PosDef ↔ kappa < lam ∧ -lam < kappa`  (equivalently
  `|kappa| < lam`), i.e. the state is massive exactly when aperture dominates
  closure. (If the two-sided form is awkward, deliver, for `0 ≤ kappa`,
  `B.PosDef ↔ kappa < lam`.)
- **B_massless_iff:** `B.det = 0 ↔ kappa = lam ∨ kappa = -lam`  (the massless
  critical line; for `0 ≤ kappa ≤ lam` this is `kappa = lam`). Equivalently
  `B.det = lam * (lam^2 - kappa^2)`.
- **B_least_eigenvalue (if the eigenvalue API is clean):** the least eigenvalue
  of `B` is `lam - kappa` for `0 ≤ kappa ≤ lam`. State via
  `B.IsHermitian.eigenvalues` or via `PosDef`/`PosSemidef` of `B - (lam-kappa)•1`
  together with singularity — whichever is cleanest. Deliver `B_posDef_iff` and
  `B_massless_iff` for certain; the explicit least-eigenvalue statement as far as
  Mathlib's Hermitian-eigenvalue API cleanly allows.

Run `lake env lean AllMassGap/Core.lean` (Mathlib-only). Report semantic
alignment; the load-bearing content is "mass gap = aperture - closure, massless
iff closure = aperture". Commit + push.

Provenance: all-mass solo run 2026-07-08; kernel-checks carrier_spectrum_sim.py
and generalizes T2_positive_mass. [orig].
-/

import Mathlib

namespace AllMassGap

/-- Placeholder so the Mathlib-only package is valid. Replace with `B` and the
theorems B_isHermitian, B_posDef_iff, B_massless_iff, B_least_eigenvalue from
the module docstring. -/
theorem package_ok : True := trivial

end AllMassGap
