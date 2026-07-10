import PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol

/-!
# An exact normalized unitary step from a Clifford symbol

If a `4 x 4` symbol `H` is Hermitian and satisfies `H^2=qI`, then
`U=aI-iH` is exactly two-sided unitary whenever `a^2+q=1`. A nontrivial
rational fixture reuses the landed 3+1 generators with two velocity
coefficients and one mass coefficient all equal to `1/2`.

This is a momentum-space internal step. It does not construct BCC
position-space shifts, prove locality, sum lattice histories, or establish a
3+1 continuum limit.

Provenance: proof completed by Aristotle project
`c6d496f0-26ba-4c77-99da-05bb56e5be19`, informed by the momentum-space walk
literature recorded in the run log and ported through `Clifford3Plus1WalkSymbol`.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.NormalizedCliffordUnitaryStep

open PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol

def step (a : ℝ) (H : Mat4) : Mat4 :=
  (a : ℂ) • (1 : Mat4) - I • H

def IsUnitary (U : Mat4) : Prop := Uᴴ * U = 1 ∧ U * Uᴴ = 1

/-- A Hermitian Clifford symbol with scalar square gives an exact unitary step
when the stay coefficient and symbol norm lie on the unit sphere. -/
theorem step_unitary (a q : ℝ) (H : Mat4)
    (hHermitian : Hᴴ = H)
    (hSq : H * H = (q : ℂ) • (1 : Mat4))
    (hnorm : a ^ 2 + q = 1) :
    IsUnitary (step a H) := by
  constructor <;> norm_num [IsUnitary, step]
  · simp_all +decide only [coe_smul, mul_sub, Algebra.mul_smul_comm,
      mul_one, smul_add, add_mul, Algebra.smul_mul_assoc, one_mul]
    ext i j
    norm_num [Complex.ext_iff, Matrix.mul_apply]
    ring_nf
    by_cases hij : i = j <;> simp_all +decide [Matrix.one_apply]
  · simp_all +decide [sub_mul, mul_add, ← Matrix.ext_iff]
    simp_all +decide [Matrix.mul_apply, Complex.ext_iff]
    grind +locals

noncomputable def witnessH : Mat4 :=
  ((1 / 2 : ℝ) : ℂ) • alpha1 + ((1 / 2 : ℝ) : ℂ) • alpha2 +
    ((1 / 2 : ℝ) : ℂ) • beta

theorem witnessH_hermitian : witnessHᴴ = witnessH := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [witnessH, alpha1, alpha2, beta, Matrix.mul_apply]

theorem witnessH_sq :
    witnessH * witnessH = (((3 / 4 : ℝ) : ℂ) • (1 : Mat4)) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [witnessH, alpha1, alpha2, beta, Matrix.mul_apply,
      Fin.sum_univ_succ] <;>
    ring_nf <;> norm_num [Complex.ext_iff, sq] at *

/-- Massive rational control: three nonzero half-coefficients, including the
mass turn, give `q=3/4`; with `a=1/2` the exact step is unitary and nontrivial. -/
theorem massive_rational_unitary_witness :
    IsUnitary (step (1 / 2) witnessH) ∧
      step (1 / 2) witnessH ≠ 1 := by
  constructor
  · convert step_unitary (1 / 2) (3 / 4) witnessH _ _ _ using 1 <;>
      norm_num [witnessH_hermitian, witnessH_sq]
  · unfold step witnessH
    norm_num [Complex.ext_iff, Matrix.smul_eq_diagonal_mul]
    intro h
    have h03 := congrFun (congrFun h 0) 3
    norm_num [Complex.ext_iff, alpha1, alpha2, beta] at h03
    simp +decide at h03

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NormalizedCliffordUnitaryStep.step_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms step_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.NormalizedCliffordUnitaryStep.massive_rational_unitary_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massive_rational_unitary_witness

end PhysicsSM.Draft.NullEdge.NormalizedCliffordUnitaryStep
