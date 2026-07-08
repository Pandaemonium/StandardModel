/-
# The full 6x6 sector mass gap is aperture minus |closure|

Proof job (Aristotle). Mathlib-only. The two-edge Cl(4) carrier's physical sector
form is (at general couplings) the block diagonal `Msec(lam,kappa) = B(lam,kappa)
(+) B(lam,-kappa)` of the 3x3 mass block and its closure-mirror (kernel-checked at
the fixed point (2,1) in the project as M6 = B(2,1)(+)B(2,-1)). Since B(lam,kappa)
has spectrum {lam-kappa, lam, lam+kappa}, the sector spectrum is the union
{lam-|kappa|, lam, lam+|kappa|} (each doubled), so the SECTOR mass gap (least
eigenvalue) is `lam - |kappa|`.

## Targets (prove kernel-clean, no `sorry`)

Define `Msec (lam kappa : ℝ) : Matrix (Fin 6) (Fin 6) ℂ` as the block diagonal of
`B lam kappa` and `B lam (-kappa)` (via `Matrix.fromBlocks ... 0 0 ...` reindexed
by `finSumFinEquiv`, or a direct `!![...]`). Prove:

- **Msec_isHermitian:** `(Msec lam kappa).IsHermitian`.
- **Msec_least_eigenvalue:** for `0 <= kappa <= lam`, the least eigenvalue of
  `Msec lam kappa` is `lam - kappa` (= `lam - |kappa|` since kappa >= 0): the full
  physical-sector squared mass gap is aperture minus |closure|. Deliver via
  `IsLeast (Set.range (Msec_isHermitian ..).eigenvalues) (lam - kappa)`, mirroring
  the block-level `B_least_eigenvalue` (reproduced below) - the least eigenvalue of
  a block-diagonal Hermitian matrix is the min of the blocks' least eigenvalues,
  and both blocks B(lam,kappa), B(lam,-kappa) have least eigenvalue lam-kappa for
  0<=kappa<=lam.
- **Msec_posDef_iff (if clean):** `(Msec lam kappa).PosDef <-> |kappa| < lam`.

Reproduce `B`, `B_isHermitian`, `B_least_eigenvalue`, `B_posDef_iff` from the
kernel-checked MassGapWitness (Mathlib-only) as needed. Report semantic alignment:
the load-bearing content is "the full sector mass gap = aperture - |closure|",
lifting the block result to the actual 6-dim sector form.

Provenance: all-mass solo run 2026-07-08 [orig]. Run lake env lean
AllMassSectorGap/Core.lean; commit + push.
-/

import Mathlib

namespace AllMassSectorGap

open Matrix Complex
open scoped ComplexOrder

/-- The carrier-sector 3x3 Hermitian mass block. -/
noncomputable def B (lam kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![(lam : ℂ), (kappa : ℂ) * Complex.I, 0;
     -((kappa : ℂ) * Complex.I), (lam : ℂ), 0;
     0, 0, (lam : ℂ)]

theorem B_isHermitian (lam kappa : ℝ) : (B lam kappa).IsHermitian := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ B ]

/-- Placeholder. Replace with `Msec`, `Msec_isHermitian`, `Msec_least_eigenvalue`
(+ optionally `Msec_posDef_iff`), kernel-clean, reproducing the needed B-spectral
lemmas from MassGapWitness. -/
theorem package_ok : True := trivial

end AllMassSectorGap
