import Mathlib

/-!
# Gauge-boson mass as a reference-orbit Gram matrix

This module formalizes a finite theorem-shaped core of the information-theoretic
Higgs proposal.  Given a reference state `phi`, infinitesimal generators `T a`,
and real couplings `g a`, define the reference-orbit tangent

`v_a = g_a T_a phi`.

The gauge-mass matrix is their Gram matrix.  Consequently it is Hermitian and
positive semidefinite.  Its quadratic form is the squared norm of the combined
reference displacement, and, for a nonzero coupling, a diagonal mass vanishes
exactly when that generator stabilizes the reference state.

The explicit two-generator witness has one unbroken generator with zero orbit
tangent and one broken generator with unit orbit tangent, producing the mass
matrix `diag(0,1)`.

Honest scope: this is finite inner-product-space geometry.  It does not derive
the Standard Model Higgs representation, electroweak couplings, the Weinberg
angle, a Higgs potential, or the Higgs boson's own scalar mass.

Provenance: clean-room formalization of the standard gauge-orbit Gram identity,
motivated by the Pro "broader physics of finite null information" analysis
supplied 2026-07-09.
-/

open scoped InnerProductSpace ComplexOrder

namespace PhysicsSM.Draft.NullEdge.GaugeMassGram

variable {A H : Type*} [Finite A]
  [NormedAddCommGroup H] [InnerProductSpace ℂ H]

/-- The coupling-weighted tangent generated from the reference state. -/
noncomputable def orbitTangent
    (g : A → ℝ) (T : A → H →ₗ[ℂ] H) (phi : H) (a : A) : H :=
  (g a : ℂ) • T a phi

/-- The finite gauge-mass matrix is the Gram matrix of reference-orbit
tangents. -/
noncomputable def gaugeMassMatrix
    (g : A → ℝ) (T : A → H →ₗ[ℂ] H) (phi : H) : Matrix A A ℂ :=
  Matrix.gram ℂ (orbitTangent g T phi)

/-- The gauge-mass matrix is Hermitian. -/
theorem gaugeMassMatrix_isHermitian
    (g : A → ℝ) (T : A → H →ₗ[ℂ] H) (phi : H) :
    (gaugeMassMatrix g T phi).IsHermitian := by
  exact Matrix.isHermitian_gram ℂ _

/-- **Gauge-mass positivity.** The reference-orbit Gram matrix is positive
semidefinite. -/
theorem gaugeMassMatrix_posSemidef
    (g : A → ℝ) (T : A → H →ₗ[ℂ] H) (phi : H) :
    (gaugeMassMatrix g T phi).PosSemidef := by
  exact Matrix.posSemidef_gram ℂ _

/-- The diagonal entry is the squared norm of the corresponding reference
displacement. -/
theorem gaugeMassMatrix_diag
    (g : A → ℝ) (T : A → H →ₗ[ℂ] H) (phi : H) (a : A) :
    gaugeMassMatrix g T phi a a =
      inner ℂ (orbitTangent g T phi a) (orbitTangent g T phi a) := rfl

/-- **Massless generator iff stabilizer.** At nonzero coupling, the diagonal
mass vanishes exactly when the generator leaves the reference state fixed to
first order. -/
theorem diagonal_zero_iff_stabilizer
    (g : A → ℝ) (T : A → H →ₗ[ℂ] H) (phi : H) (a : A) (hg : g a ≠ 0) :
    gaugeMassMatrix g T phi a a = 0 ↔ T a phi = 0 := by
  rw [gaugeMassMatrix_diag, inner_self_eq_zero]
  simp [orbitTangent, hg]

variable [Fintype A]

/-- The full quadratic form is the norm square of the combined generator
displacement. -/
theorem gaugeMass_quadratic_form
    (g : A → ℝ) (T : A → H →ₗ[ℂ] H) (phi : H) (c : A → ℂ) :
    dotProduct (star c) (Matrix.mulVec (gaugeMassMatrix g T phi) c) =
      inner ℂ (∑ a, c a • orbitTangent g T phi a)
        (∑ a, c a • orbitTangent g T phi a) := by
  exact Matrix.star_dotProduct_gram_mulVec _ _ _

/-- A linear combination is massless exactly when it stabilizes the reference
state. -/
theorem quadratic_zero_iff_combination_stabilizes
    (g : A → ℝ) (T : A → H →ₗ[ℂ] H) (phi : H) (c : A → ℂ) :
    dotProduct (star c) (Matrix.mulVec (gaugeMassMatrix g T phi) c) = 0 ↔
      (∑ a, c a • orbitTangent g T phi a) = 0 := by
  rw [gaugeMass_quadratic_form, inner_self_eq_zero]

/-! ## Explicit broken/unbroken witness -/

abbrev RefH := EuclideanSpace ℂ (Fin 2)

/-- A concrete reference state. -/
noncomputable def phi0 : RefH := EuclideanSpace.single 0 1

/-- The zero generator and a generator exchanging the two reference
coordinates. -/
noncomputable def generatorMatrix (a : Fin 2) : Matrix (Fin 2) (Fin 2) ℂ :=
  ![(0 : Matrix (Fin 2) (Fin 2) ℂ), !![0, 1; 1, 0]] a

noncomputable def generator (a : Fin 2) : RefH →ₗ[ℂ] RefH :=
  Matrix.toEuclideanLin (generatorMatrix a)

noncomputable def unitCoupling : Fin 2 → ℝ := ![1, 1]

/-- The concrete mass matrix has one zero and one unit eigen-direction. -/
theorem witness_mass_matrix :
    gaugeMassMatrix unitCoupling generator phi0 = !![0, 0; 0, 1] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [gaugeMassMatrix, orbitTangent, unitCoupling, generator, generatorMatrix,
      phi0, Matrix.gram_apply, Matrix.toEuclideanLin, inner]

/-- The first generator stabilizes the reference and the second genuinely moves
it. -/
theorem witness_stabilizer_split :
    generator 0 phi0 = 0 ∧ generator 1 phi0 ≠ 0 := by
  constructor
  · ext i
    fin_cases i <;>
      simp [generator, generatorMatrix, phi0, Matrix.toEuclideanLin]
  · intro h
    have h1 := congr_arg (fun x : RefH => x.ofLp 1) h
    norm_num [generator, generatorMatrix, phi0, Matrix.toEuclideanLin] at h1

/-- **Nonvacuous gauge-mass Gram verdict.** The finite witness has a positive
semidefinite mass matrix, one unbroken massless generator, and one broken
positive-mass generator. -/
theorem gauge_mass_gram_witness :
    (gaugeMassMatrix unitCoupling generator phi0).PosSemidef ∧
      gaugeMassMatrix unitCoupling generator phi0 0 0 = 0 ∧
      generator 0 phi0 = 0 ∧
      gaugeMassMatrix unitCoupling generator phi0 1 1 = 1 ∧
      generator 1 phi0 ≠ 0 := by
  refine ⟨gaugeMassMatrix_posSemidef unitCoupling generator phi0, ?_,
    witness_stabilizer_split.1, ?_, witness_stabilizer_split.2⟩
  · rw [witness_mass_matrix]
    norm_num
  · rw [witness_mass_matrix]
    norm_num

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.GaugeMassGram.diagonal_zero_iff_stabilizer' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms diagonal_zero_iff_stabilizer

/-- info: 'PhysicsSM.Draft.NullEdge.GaugeMassGram.gauge_mass_gram_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gauge_mass_gram_witness

end PhysicsSM.Draft.NullEdge.GaugeMassGram
