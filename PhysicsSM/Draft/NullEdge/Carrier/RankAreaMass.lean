/-
# Mass as rank/area: the spectral face of `det P`

DRAFT (kernel-clean; no `s o r r y`). The §3<->§4 hinge at the kinematic level,
formalizing the "mass is the *area* the null directions open in spinor space"
reading (Gemini Pro, `Sources/Null_Edge_All_Mass_Literature_Review_2026-07-08.md`):
for the bundle momentum `M = P = sum_i psi_i psi_i^dagger` (a positive-
semidefinite Hermitian matrix, the §3 object whose determinant is the mass
squared),

  massless  <=>  det M = 0  <=>  M rank-deficient (`¬ M.PosDef`)   -- one beam
  massive   <=>  det M > 0  <=>  M positive-definite                -- genuine area

and `det M` equals the product of `M`'s eigenvalues (the light-cone energies).

## What it lands

* `det_nonneg` (**M**): the mass squared is nonnegative.
* `posDef_iff_det_pos` (**M**): positive mass squared <=> `M.PosDef`.
* `det_eq_zero_iff_not_posDef` (**M**): masslessness <=> rank-deficiency.
* `det_eq_prod_eigenvalues₂` (**M**): `2x2` mass-shell - `det M` is the product
  of the two eigenvalues.

## Why it matters

This is the kinematic shadow of the keystone's hypothesis: `sector_ground_mass`
needs a *positive-definite* sector, and here "positive-definite momentum" and
"massive" are literally the same statement about the two-spinor span - the
kinematic reason mass and positivity are the same phenomenon. Aristotle proved
`det_nonneg`, `posDef_iff_det_pos`, `det_eq_zero_iff_not_posDef` for a general
`RCLike` field and any finite size (stronger than the `Fin 2` request).

## Provenance

Statement + Lean proof: Aristotle strengthening round-2 job
`979a3401-3c43-49bc-a475-942913780abb` (2026-07-08), re-checked under the pinned
toolchain - [orig]/[import] (the matrix facts are standard Mathlib).
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.RankAreaMass

open Matrix
open scoped ComplexOrder

variable {n : Type*} [Fintype n] [DecidableEq n]
variable {𝕜 : Type*} [RCLike 𝕜]

/-- **R-nonneg.** The mass squared `det P` of the (positive-semidefinite)
bundle momentum is nonnegative. -/
theorem det_nonneg {M : Matrix n n 𝕜} (hM : M.PosSemidef) : 0 ≤ M.det :=
  hM.det_nonneg

/-- **R-massive.** For the positive-semidefinite momentum `M`, having positive
mass squared (`0 < det M`) is exactly `M` being positive-definite: the null
directions span the full spinor space (genuine area). -/
theorem posDef_iff_det_pos {M : Matrix n n 𝕜} (hM : M.PosSemidef) :
    0 < M.det ↔ M.PosDef := by
  constructor
  · intro h
    rw [hM.posDef_iff_isUnit, Matrix.isUnit_iff_isUnit_det]
    exact isUnit_iff_ne_zero.mpr (ne_of_gt h)
  · intro h
    exact h.det_pos

/-- **R-massless.** For the positive-semidefinite momentum `M`, vanishing mass
squared (`det M = 0`) is exactly rank-deficiency (`¬ M.PosDef`): one coherent
beam rather than a genuine two-dimensional span. -/
theorem det_eq_zero_iff_not_posDef {M : Matrix n n 𝕜} (hM : M.PosSemidef) :
    M.det = 0 ↔ ¬ M.PosDef := by
  rw [← posDef_iff_det_pos hM]
  constructor
  · intro h
    rw [h]
    exact lt_irrefl 0
  · intro h
    by_contra hne
    exact h (lt_of_le_of_ne hM.det_nonneg (Ne.symm hne))

/-- **R-massshell.** For a `2x2` positive-semidefinite momentum `M`, the mass
squared `det M` is the product of its two eigenvalues - the two "light-cone
energies". -/
theorem det_eq_prod_eigenvalues₂ {M : Matrix (Fin 2) (Fin 2) 𝕜} (hM : M.PosSemidef) :
    M.det = (hM.isHermitian.eigenvalues 0 : 𝕜) * (hM.isHermitian.eigenvalues 1 : 𝕜) := by
  rw [hM.isHermitian.det_eq_prod_eigenvalues, Fin.prod_univ_two]

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.RankAreaMass.posDef_iff_det_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms posDef_iff_det_pos

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.RankAreaMass.det_eq_zero_iff_not_posDef' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_eq_zero_iff_not_posDef

end PhysicsSM.Draft.NullEdge.Carrier.RankAreaMass
