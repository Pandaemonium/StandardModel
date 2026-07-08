/-
# Finite Witten / Lichnerowicz positivity for the soldering (gravity) channel

Proof job (Aristotle). Roadmap item **F4**: a finite analogue of the
Lichnerowicz–Weitzenböck argument at the heart of Witten's positive-energy
theorem, giving the gravity-shaped E-channel (manuscript §7) its first genuine
positivity + rigidity theorem.

Setup (Mathlib-only). Finite-dimensional complex inner product spaces `H`, `K`.
`A : H ->L[C] K` is the covariant gradient (the soldering derivative); `C : H
->L[C] H` is a self-adjoint, positive-semidefinite "curvature" term (the finite
dominant-energy condition, `0 <= <v, C v>`). The Weitzenböck operator square is
`S := (adjoint A) * A + C`. In Witten's proof, `<v, S v>` is a boundary (ADM
mass) term for a harmonic spinor; the dominant energy condition makes the
curvature term nonnegative, so the mass is nonnegative, and vanishes iff the
spinor is covariantly constant. The finite images:

## Targets (prove kernel-clean, no `s o r r y`)

- **W-psd:** for all `v : H`, `0 <= (inner (v) (S v)).re`, i.e. `S` is positive-
  semidefinite (`0 <= ‖A v‖^2 + (inner v (C v)).re`). The finite positive-mass
  inequality under the dominant-energy condition on `C`.
- **W-selfadjoint:** `S` is self-adjoint (`IsSelfAdjoint S`), given `C` self-
  adjoint.
- **W-vanish (Lichnerowicz rigidity, the headline):** the mass form vanishes iff
  the spinor is BOTH covariantly constant AND curvature-annihilated:
  `(inner v (S v)).re = 0  <->  A v = 0  ∧  C v = 0`.
  (Since `C` is PSD, `(inner v (C v)).re = 0 <-> C v = 0`; and `‖A v‖^2 = 0 <->
  A v = 0`. So the harmonic/zero-mass vectors are exactly the covariantly
  constant, curvature-null ones - the finite Lichnerowicz vanishing theorem.)
- **W-kernel (if clean):** `S v = 0 <-> A v = 0 ∧ C v = 0` (kernel form of the
  same statement). Deliver W-vanish for certain; W-kernel if the PSD API is
  clean.

Provide the definitions and hypotheses in whatever Mathlib spelling is cleanest
(`InnerProductSpace ℂ`, `ContinuousLinearMap.adjoint`, `FiniteDimensional`,
positive-semidefinite as `∀ v, 0 ≤ (inner v (C v)).re` together with
`IsSelfAdjoint C`). Run `lake env lean AllMassWitten/Core.lean` (Mathlib-only).
Report semantic alignment - this is the finite Lichnerowicz vanishing, and the
`C v = 0` clause (not just `<v,Cv> = 0`) is the load-bearing rigidity content.
Commit + push.

## Why it matters

§7 currently has only the algebraic torsion+non-metricity trinity split; F4 gives
it a positivity+rigidity theorem of genuine GR shape (finite-dimensional, so the
kernel eats it). Provenance: all-mass overnight run 2026-07-08, roadmap F4
[orig]; the Lichnerowicz–Weitzenböck argument is classical [import].
-/

import Mathlib

namespace AllMassWitten

/-- Placeholder so the Mathlib-only package is a valid, quickly-building target.
Replace with the F4 setup (H, K, A, C, S) and the theorems W-psd, W-selfadjoint,
W-vanish, W-kernel described in the module docstring. -/
theorem package_ok : True := trivial

end AllMassWitten
