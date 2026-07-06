import Mathlib

/-!
# Plücker / spinor-wedge bridge at 3+1D

This file extends the Plücker/mass bridge to `3+1` dimensions at the finite,
algebraic level of the 2-component (Weyl) spinor formalism.  It ties the
composite invariant mass `m^2 = det P` of a pair of null momenta - where `P` is
the `2 x 2` momentum / Plücker matrix - to the **spinor wedge product**, the
antisymmetric combination of two Weyl spinors.

## Set-up (finite / algebraic 2-spinor dictionary)

A Weyl spinor is an element of `CSpinor = Fin 2 → ℂ`.  The standard
null-momentum ↔ spinor correspondence at the finite level is

`p_{a a'} = λ_a · conj(λ_{a'})`  (`plueckerMatrix`),

a rank-one Hermitian `2 x 2` block; its determinant vanishes, which is exactly
the null (massless) condition for a single momentum.

For a **pair** of null momenta with spinors `ψ, φ` the composite momentum is the
sum of the two Plücker matrices

`P = twoEdgeMomentum ψ φ = ψ ψ† + φ φ†`,

again Hermitian, and its determinant is the composite invariant mass squared.
The Pauli soldering `minkHerm : Momentum4 → Herm2` and its inverse
`momentumOfHerm2` identify `det P` with the Minkowski square `minkowskiSq`.

## Headline identity

`det (twoEdgeMomentum ψ φ) = |spinorWedge ψ φ|^2`

where `spinorWedge ψ φ = ψ₀ φ₁ - ψ₁ φ₀` and `|·|^2` is the (complex) squared
norm `z · conj z`.  Equivalently, in Minkowski language,

`m^2 = minkowskiSq (momentumOfHerm2 P) = |spinorWedge ψ φ|^2`.

Consequently the composite is massless **iff** the spinor wedge vanishes **iff**
the two Weyl spinors are proportional (collinear null momenta):

`massless  ⟺  spinorWedge ψ φ = 0  ⟺  ∃ c, φ = c • ψ`   (for `ψ ≠ 0`).

## Claim discipline

**Honest label:** this is a *finite algebraic identity* in the 2-spinor
formalism - a determinant identity between a sum of two rank-one Hermitian
Plücker blocks and the squared norm of the spinor wedge - **not** a full
field-theoretic derivation.  Everything is kernel-checked and `sorry`-free; the
file depends only on Mathlib.
-/

open scoped Matrix

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace PluckerSpinorBridge

/-! ## Basic objects -/

/-- A two-component (Weyl) spinor. -/
abbrev CSpinor : Type := Fin 2 → ℂ

/-- A real four-momentum. -/
abbrev Momentum4 : Type := Fin 4 → ℝ

/-- A `2 x 2` complex matrix (a candidate Hermitian momentum block). -/
abbrev Mat2 : Type := Matrix (Fin 2) (Fin 2) ℂ

/-- The **squared complex norm** `z · conj z`, valued in `ℂ` (equal to the real
`Complex.normSq z` under the canonical coercion). -/
noncomputable def complexAbsSq (z : ℂ) : ℂ := z * (starRingEnd ℂ) z

/-- The **spinor wedge product** of two Weyl spinors: the antisymmetric
combination `ψ₀ φ₁ - ψ₁ φ₀`.  It is the unique (up to scale) `SL(2,ℂ)`-invariant
antisymmetric bilinear form on `CSpinor`. -/
def spinorWedge (psi phi : CSpinor) : ℂ := psi 0 * phi 1 - psi 1 * phi 0

/-- The **Plücker matrix** of a single null spinor: `p_{a a'} = λ_a conj λ_{a'}`,
i.e. the rank-one Hermitian block `λ λ†`. -/
def plueckerMatrix (lam : CSpinor) : Mat2 := Matrix.vecMulVec lam (star lam)

/-- The **two-edge (composite) momentum** of a pair of null spinors:
`P = ψ ψ† + φ φ†`, the sum of the two Plücker matrices. -/
def twoEdgeMomentum (psi phi : CSpinor) : Mat2 :=
  plueckerMatrix psi + plueckerMatrix phi

/-- The Pauli soldering of a four-momentum into a Hermitian `2 x 2` block:
`minkHerm p = p0·I + p_i σ_i`. -/
noncomputable def minkHerm (p : Momentum4) : Mat2 :=
  !![(p 0 + p 3 : ℂ), (p 1 : ℂ) - (p 2 : ℂ) * Complex.I;
     (p 1 : ℂ) + (p 2 : ℂ) * Complex.I, (p 0 : ℂ) - (p 3 : ℂ)]

/-- The Minkowski square `p0² - p1² - p2² - p3²`. -/
def minkowskiSq (p : Momentum4) : ℝ := (p 0)^2 - (p 1)^2 - (p 2)^2 - (p 3)^2

/-- The real four-momentum extracted from a Hermitian `2 x 2` block; the inverse
of `minkHerm` on Hermitian matrices. -/
noncomputable def momentumOfHerm2 (H : Mat2) : Momentum4 :=
  ![((H 0 0).re + (H 1 1).re) / 2, (H 0 1).re, -(H 0 1).im,
    ((H 0 0).re - (H 1 1).re) / 2]

/-! ## Determinant of the Pauli soldering -/

/-
`det (minkHerm p) = minkowskiSq p` (as a complex number).
-/
theorem det_minkHerm_eq_minkowskiSq (p : Momentum4) :
    (minkHerm p).det = (minkowskiSq p : ℂ) := by
  unfold minkowskiSq minkHerm;
  simpa using by ring_nf; norm_num ; ring;

/-
**Soldering roundtrip**: on a Hermitian block, `minkHerm` recovers the block
from its extracted momentum.
-/
theorem minkHerm_momentumOfHerm2 (H : Mat2) (hH : H.IsHermitian) :
    minkHerm (momentumOfHerm2 H) = H := by
  have h00 : (H 0 0).im = 0 := by
    have h : (starRingEnd ℂ) (H 0 0) = H 0 0 := hH.apply 0 0
    rwa [Complex.conj_eq_iff_im] at h
  have h11 : (H 1 1).im = 0 := by
    have h : (starRingEnd ℂ) (H 1 1) = H 1 1 := hH.apply 1 1
    rwa [Complex.conj_eq_iff_im] at h
  have h10 : H 1 0 = (starRingEnd ℂ) (H 0 1) := (hH.apply 1 0).symm
  have h10re : (H 1 0).re = (H 0 1).re := by rw [h10]; simp
  have h10im : (H 1 0).im = -(H 0 1).im := by rw [h10]; simp
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [minkHerm, momentumOfHerm2, Complex.ext_iff, h00, h11, h10re, h10im] <;> ring

/-! ## Hermiticity and single-edge (null) masslessness -/

/-
A single Plücker matrix `λ λ†` is Hermitian.
-/
theorem plueckerMatrix_isHermitian (lam : CSpinor) :
    (plueckerMatrix lam).IsHermitian := by
  ext i j; simp +decide [ plueckerMatrix, Matrix.vecMulVec ] ; ring;

/-
The two-edge composite momentum `ψ ψ† + φ φ†` is Hermitian.
-/
theorem twoEdgeMomentum_isHermitian (psi phi : CSpinor) :
    (twoEdgeMomentum psi phi).IsHermitian := by
  convert ( plueckerMatrix_isHermitian psi ).add ( plueckerMatrix_isHermitian phi ) using 1

/-
A single null momentum is massless: `det (λ λ†) = 0`.
-/
theorem det_plueckerMatrix_eq_zero (lam : CSpinor) :
    (plueckerMatrix lam).det = 0 := by
  unfold plueckerMatrix;
  norm_num [ Matrix.det_fin_two, Matrix.vecMulVec ] ; ring

/-! ## The headline identity: `det P = |spinorWedge|²` -/

/-
**Bridge (headline)**: the determinant of the composite momentum equals the
squared norm of the spinor wedge.  `det (ψ ψ† + φ φ†) = |ψ ∧ φ|^2`.
-/
theorem det_twoEdgeMomentum_eq_wedge (psi phi : CSpinor) :
    (twoEdgeMomentum psi phi).det = complexAbsSq (spinorWedge psi phi) := by
  rw [ complexAbsSq, Matrix.det_fin_two, twoEdgeMomentum ];
  unfold plueckerMatrix spinorWedge; norm_num [ Matrix.vecMulVec ] ; ring;

/-- The composite invariant mass in Minkowski language equals the squared norm
of the spinor wedge: `m^2 = minkowskiSq (momentumOfHerm2 P) = |ψ ∧ φ|^2`. -/
theorem invariantMassSq_eq_wedge (psi phi : CSpinor) :
    (minkowskiSq (momentumOfHerm2 (twoEdgeMomentum psi phi)) : ℂ)
      = complexAbsSq (spinorWedge psi phi) := by
  rw [← det_minkHerm_eq_minkowskiSq,
    minkHerm_momentumOfHerm2 _ (twoEdgeMomentum_isHermitian psi phi),
    det_twoEdgeMomentum_eq_wedge]

/-! ## Masslessness ⟺ wedge vanishing ⟺ proportional spinors -/

/-
`complexAbsSq z = 0 ↔ z = 0`.
-/
theorem complexAbsSq_eq_zero_iff (z : ℂ) : complexAbsSq z = 0 ↔ z = 0 := by
  unfold complexAbsSq; aesop;

/-- **Bridge (masslessness)**: the composite is massless exactly when the spinor
wedge vanishes. -/
theorem massless_iff_wedge_zero (psi phi : CSpinor) :
    minkowskiSq (momentumOfHerm2 (twoEdgeMomentum psi phi)) = 0
      ↔ spinorWedge psi phi = 0 := by
  rw [← complexAbsSq_eq_zero_iff, ← invariantMassSq_eq_wedge]
  exact_mod_cast Iff.rfl

/-
The spinor wedge vanishes exactly when the two spinors are **proportional**
(one is a scalar multiple of the other), for a non-zero reference spinor `ψ`.
This is the aperture "massless iff collinear" criterion at the spinor level.
-/
theorem wedge_zero_iff_proportional (psi phi : CSpinor) (hpsi : psi ≠ 0) :
    spinorWedge psi phi = 0 ↔ ∃ c : ℂ, phi = c • psi := by
  constructor;
  · intro h;
    -- Since $\psi \neq 0$, we can choose $i$ such that $\psi_i \neq 0$.
    obtain ⟨i, hi⟩ : ∃ i : Fin 2, psi i ≠ 0 := by
      exact Function.ne_iff.mp hpsi;
    fin_cases i <;> simp_all +decide [ funext_iff, Fin.forall_fin_two, spinorWedge ];
    · exact ⟨ phi 0 / psi 0, by rw [ div_mul_cancel₀ _ hi ], by rw [ div_mul_eq_mul_div, eq_div_iff hi ] ; linear_combination' h ⟩;
    · exact ⟨ phi 1 / psi 1, by rw [ div_mul_eq_mul_div, eq_div_iff hi ] ; linear_combination' h.symm, by rw [ div_mul_cancel₀ _ hi ] ⟩;
  · rintro ⟨c, rfl⟩
    simp only [spinorWedge, Pi.smul_apply, smul_eq_mul]
    ring

/-- **Bridge (collinearity)**: for a non-zero spinor `ψ`, the composite of two
null momenta is massless exactly when their Weyl spinors are proportional
(the null momenta are collinear). -/
theorem massless_iff_proportional (psi phi : CSpinor) (hpsi : psi ≠ 0) :
    minkowskiSq (momentumOfHerm2 (twoEdgeMomentum psi phi)) = 0
      ↔ ∃ c : ℂ, phi = c • psi := by
  rw [massless_iff_wedge_zero, wedge_zero_iff_proportional psi phi hpsi]

end PluckerSpinorBridge
end PhysicsSM.Draft.NullEdge.GateI1
