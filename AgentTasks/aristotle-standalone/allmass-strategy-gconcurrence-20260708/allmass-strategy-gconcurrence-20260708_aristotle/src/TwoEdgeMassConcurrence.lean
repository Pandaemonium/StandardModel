/-
# The two-edge Plücker mass IS the Wootters concurrence² (M)

DRAFT (kernel-clean; no `s o r r y`). This closes, for the **two-edge** case, the
identification Fable's review flagged as "mass = the self-entanglement of the null
bundle": the two-edge Plücker mass equals the Wootters concurrence squared of the
corresponding two-qubit state, up to the standard normalization factor `4`.

## The identification

Let `M : Matrix (Fin 2) (Fin 2) ℂ` be the amplitude matrix whose two columns are
the two null 2-spinors `ψ₁, ψ₂`. Two readings of the same object:

* **Mass side.** The momentum/Gram matrix is `P = M * Mᴴ = ψ₁ψ₁ᴴ + ψ₂ψ₂ᴴ`, and the
  two-edge Plücker mass is `det P` (the §3 mass identity
  `det P = |ψ₁ ∧ ψ₂|²`, since `det M = ψ₁ ∧ ψ₂` is the wedge / Plücker coordinate).
* **Entanglement side.** Reading `M` as the amplitude matrix of a two-qubit pure
  state, its **Wootters concurrence** is `C = 2|det M|` (matching
  `NullEdge.P6Concurrence.concurrence a b c d = 2|ad − bc|` under
  `M = !![a, b; c, d]`, `det M = ad − bc`).

## Result (M)

- `det_gram_eq_normSq_wedge`: `det (M * Mᴴ) = normSq (det M)` — the two-edge mass
  is the squared magnitude of the wedge (real, nonnegative).
- `four_mul_det_gram_eq_concurrence_sq`: `4 · det(M * Mᴴ) = C²`, i.e.
  `det P = (C/2)²` = **concurrence² / 4**. The two-edge Plücker mass literally *is*
  the Wootters concurrence² of the null bundle read as a two-qubit state.

So for a single edge-pair, "mass is trapped disagreeing light" and "mass is the
entanglement of the bundle with itself" are the *same* kernel-checked statement:
massless (`det P = 0`) ⇔ zero concurrence ⇔ a product (unentangled / collinear)
state (`NullEdge.P6Concurrence.concurrence_zero_iff_product`).

## Scope

This is the **two-edge** identification. The general multi-edge
`det P = Wootters concurrence²` for an arbitrary null bundle, and the binding
defect `Δ = −κ` read as a kernel-checked entanglement *deficit*, remain grade **C**
(§10, §3a). Provenance: null-edge mass thesis (§3) ⊗ Wootters concurrence
(`NullEdge.P6Concurrence`); the wedge/Plücker mass is
`PhysicsSM.Spinor.PluckerMass.two_edge_plucker_mass_identity`. All-mass solo run
2026-07-08 [orig].
-/

import Mathlib

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.TwoEdgeMassConcurrence

/-- The two-edge Gram determinant equals the squared magnitude of the wedge
`det M` (`= |ψ₁ ∧ ψ₂|²`): `det (M * Mᴴ) = normSq (det M)`. This is the two-edge
Plücker mass, real and nonnegative. -/
theorem det_gram_eq_normSq_wedge (M : Matrix (Fin 2) (Fin 2) ℂ) :
    (M * Mᴴ).det = (Complex.normSq M.det : ℂ) := by
  rw [Matrix.det_mul, Matrix.det_conjTranspose, Complex.star_def,
    Complex.mul_conj]

/-- The two-edge Gram determinant is real (imaginary part zero). -/
theorem det_gram_im_zero (M : Matrix (Fin 2) (Fin 2) ℂ) :
    (M * Mᴴ).det.im = 0 := by
  rw [det_gram_eq_normSq_wedge, Complex.ofReal_im]

/-- Wootters concurrence of the two-qubit state with `2×2` amplitude matrix `M`:
`C = 2 |det M|` (`det M` is the wedge `ψ₁ ∧ ψ₂`). -/
noncomputable def concurrence (M : Matrix (Fin 2) (Fin 2) ℂ) : ℝ :=
  2 * ‖M.det‖

/-- **Two-edge Plücker mass = Wootters concurrence² / 4.** For a `2×2` complex
amplitude matrix `M` (columns = the two null 2-spinors), the two-edge Plücker mass
`det(M * Mᴴ)` is real and `4 · det(M * Mᴴ) = concurrence M ²`; equivalently
`det P = (C/2)²`. The mass of a null edge-pair *is* the squared concurrence of the
bundle read as a two-qubit state. -/
theorem four_mul_det_gram_eq_concurrence_sq (M : Matrix (Fin 2) (Fin 2) ℂ) :
    (4 : ℝ) * (M * Mᴴ).det.re = concurrence M ^ 2 := by
  rw [det_gram_eq_normSq_wedge, Complex.ofReal_re]
  unfold concurrence
  rw [mul_pow, Complex.sq_norm]
  ring

/-- **Massless ⇔ zero concurrence** for a two-edge bundle: the Plücker mass
`det(M * Mᴴ)` vanishes iff the Wootters concurrence does (iff the wedge / bundle
is a collinear, unentangled, product state). -/
theorem det_gram_eq_zero_iff_concurrence_eq_zero (M : Matrix (Fin 2) (Fin 2) ℂ) :
    (M * Mᴴ).det = 0 ↔ concurrence M = 0 := by
  rw [det_gram_eq_normSq_wedge, concurrence]
  constructor
  · intro h
    have : Complex.normSq M.det = 0 := by exact_mod_cast h
    rw [Complex.normSq_eq_zero] at this
    simp [this]
  · intro h
    have : ‖M.det‖ = 0 := by linarith [norm_nonneg M.det, h]
    rw [norm_eq_zero] at this
    simp [this]

end PhysicsSM.Draft.NullEdge.TwoEdgeMassConcurrence

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.TwoEdgeMassConcurrence.det_gram_eq_normSq_wedge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TwoEdgeMassConcurrence.det_gram_eq_normSq_wedge

/-- info: 'PhysicsSM.Draft.NullEdge.TwoEdgeMassConcurrence.four_mul_det_gram_eq_concurrence_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TwoEdgeMassConcurrence.four_mul_det_gram_eq_concurrence_sq

/-- info: 'PhysicsSM.Draft.NullEdge.TwoEdgeMassConcurrence.det_gram_eq_zero_iff_concurrence_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TwoEdgeMassConcurrence.det_gram_eq_zero_iff_concurrence_eq_zero
