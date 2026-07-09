/-
# Protected massless modes from a finite chiral index

A finite chiral Dirac carrier is a finite-dimensional complex space `V` with a
chiral grading `Γ` (`Γ² = 1`, `Γ = Γᴴ`, so `V = V₊ ⊕ V₋`) and an **odd** Dirac
operator `D` (`D Γ = −Γ D`), i.e. `D` maps `V₊ → V₋` and `V₋ → V₊`. Mass terms are
odd perturbations of the same kind. The **chiral index** `ind = dim V₊ − dim V₋` is
a topological invariant, and it *protects* massless (zero) modes: `dim ker D ≥
|ind|`, and no odd (mass) perturbation can lift that many. This is the finite shadow
of the Atiyah–Singer / Witten-index mechanism that keeps neutrino-like modes light.

## Targets (this file)

- `odd_ker_ge_index`: for any odd `D : V₊ ⊕ V₋ → V₊ ⊕ V₋` (a block-antidiagonal map
  with blocks `A : V₊ → V₋`, `B : V₋ → V₊`), `dim ker D ≥ |dim V₊ − dim V₋|`
  (rank–nullity: `A` alone forces `dim ker A ≥ dim V₊ − dim V₋`). State it for
  matrices: `D = !![0, B; A, 0]` block form.
- `index_stable_under_odd_perturbation`: adding any odd perturbation (another
  block-antidiagonal `D'`) does not decrease the protected count below `|ind|`.
- `witness_one_protected_mode`: a concrete small carrier with `dim V₊ = 2`,
  `dim V₋ = 1` (`ind = 1`) has **exactly one** protected zero mode, stable under odd
  perturbations — the "exactly one massless mode plus a finite massive pattern"
  target.

Formalize as convenient (raw matrices, `LinearMap`, or `Fin n₊ ⊕ Fin n₋`). The
mathematical core is rank–nullity on the off-diagonal block plus the invariance of
the difference `dim ker A − dim ker Aᴴ` (= the index) under perturbation.
-/

import Mathlib

open Matrix

namespace PhysicsSM.Draft.NullEdge.ChiralIndexProtection

/-- **Protected-mode bound (TARGET).** For an odd (block-antidiagonal) Dirac
operator with corner `A : (Fin np) → (Fin nm)` (as a matrix `Matrix (Fin nm) (Fin np) ℂ`),
the kernel dimension of the corner is at least `np − nm`; hence a chiral index
`np − nm > 0` forces at least `np − nm` protected zero modes. -/
theorem corner_ker_ge_index {np nm : ℕ} (A : Matrix (Fin nm) (Fin np) ℂ) :
    np - nm ≤ Module.finrank ℂ (LinearMap.ker (Matrix.mulVecLin A)) := by
  sorry

/-- **Index stability under odd perturbation (TARGET).** The chiral index
`np − nm` is unchanged if `A` is replaced by `A + A'`, so the protected count is
stable: any perturbed corner still has `dim ker ≥ np − nm`. -/
theorem corner_ker_ge_index_perturbed {np nm : ℕ}
    (A A' : Matrix (Fin nm) (Fin np) ℂ) :
    np - nm ≤ Module.finrank ℂ (LinearMap.ker (Matrix.mulVecLin (A + A'))) := by
  sorry

/-- **Witness: exactly one protected massless mode (TARGET).** A carrier with
`np = 2`, `nm = 1` (index `1`) has at least one protected zero mode, and (for a
generic full-rank corner) exactly one; it is stable under every odd perturbation. -/
theorem witness_one_protected_mode (A : Matrix (Fin 1) (Fin 2) ℂ) :
    1 ≤ Module.finrank ℂ (LinearMap.ker (Matrix.mulVecLin A)) := by
  sorry

end PhysicsSM.Draft.NullEdge.ChiralIndexProtection
