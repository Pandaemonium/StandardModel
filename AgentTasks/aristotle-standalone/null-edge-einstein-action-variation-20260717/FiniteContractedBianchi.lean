import Mathlib

/-!
# Finite-index contracted Bianchi identity

This module isolates the tensor-contraction algebra between an uncontracted
differential Bianchi identity and divergence freedom of the Einstein
combination. It uses a finite orthonormal-frame component model over a field.

`dR e a b c d` represents the `e`-derivative of an all-lowered curvature
component `R a b c d`. The convention is

```text
dR e a b c d + dR c a b d e + dR d a b e c = 0,
```

with antisymmetry in the first and last curvature-index pairs. A diagonal
inverse metric is represented by weights `weight i`; Lorentz signature is the
case in which each weight is `+1` or `-1`, encoded algebraically by
`weight i * weight i = 1`.

The proof explicitly contracts finite sums twice. It does not assume the
contracted identity under a renamed predicate. It is still a component-level
theorem: it does not construct these components from null-edge holonomy, prove
metric compatibility or curvature convergence, or supply a continuum limit.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.FiniteContractedBianchi

section Components

variable {I R : Type*} [Fintype I] [DecidableEq I] [Field R] [CharZero R]

/-- Derivative of an all-lowered curvature tensor in a fixed frame. -/
abbrev CurvatureDerivative := I -> I -> I -> I -> I -> R

/-- Derivative of the Ricci contraction:
`dRic e b d = sum_a weight a * dR e a b a d`. -/
def dRic (weight : I -> R) (dR : CurvatureDerivative (I := I) (R := R))
    (e b d : I) : R :=
  ∑ a, weight a * dR e a b a d

/-- Derivative of scalar curvature in the fixed orthonormal frame. -/
def gradScalar (weight : I -> R)
    (dR : CurvatureDerivative (I := I) (R := R)) (d : I) : R :=
  ∑ b, weight b * dRic weight dR d b b

/-- Divergence of the Ricci derivative in the fixed orthonormal frame. -/
def divRic (weight : I -> R)
    (dR : CurvatureDerivative (I := I) (R := R)) (d : I) : R :=
  ∑ a, weight a * dRic weight dR a a d

/-- Diagonal metric components for the fixed orthonormal frame. -/
def diagonalMetric (weight : I -> R) (b d : I) : R :=
  if b = d then weight b else 0

/-- Derivative of the covariant Einstein combination in the fixed frame. -/
def dEinstein (weight : I -> R)
    (dR : CurvatureDerivative (I := I) (R := R)) (e b d : I) : R :=
  dRic weight dR e b d -
    (1 / 2 : R) * diagonalMetric weight b d * gradScalar weight dR e

/-- Divergence of the finite-index Einstein combination. -/
def divEinstein (weight : I -> R)
    (dR : CurvatureDerivative (I := I) (R := R)) (d : I) : R :=
  ∑ b, weight b * dEinstein weight dR b b d

omit [DecidableEq I] [CharZero R] in
/-- One contraction of the differential Bianchi identity. -/
theorem once_contracted_bianchi
    (weight : I -> R) (dR : CurvatureDerivative (I := I) (R := R))
    (hLast : ∀ e a b c d, dR e a b c d = -dR e a b d c)
    (hBianchi : ∀ e a b c d,
      dR e a b c d + dR c a b d e + dR d a b e c = 0)
    (b c d : I) :
    (∑ a, weight a * dR a a b c d) =
      dRic weight dR c b d - dRic weight dR d b c := by
  have hSecond :
      (∑ a, weight a * dR c a b d a) = -dRic weight dR c b d := by
    unfold dRic
    calc
      (∑ a, weight a * dR c a b d a) =
          ∑ a, -(weight a * dR c a b a d) := by
            apply Finset.sum_congr rfl
            intro a _
            rw [hLast c a b d a]
            ring
      _ = -(∑ a, weight a * dR c a b a d) := by
        rw [Finset.sum_neg_distrib]
  have hThird :
      (∑ a, weight a * dR d a b a c) = dRic weight dR d b c := by
    rfl
  have hSum :
      (∑ a, weight a *
        (dR a a b c d + dR c a b d a + dR d a b a c)) = 0 := by
    apply Finset.sum_eq_zero
    intro a _
    rw [hBianchi a a b c d, mul_zero]
  simp_rw [mul_add] at hSum
  rw [Finset.sum_add_distrib, Finset.sum_add_distrib, hSecond, hThird] at hSum
  linear_combination hSum

omit [DecidableEq I] [CharZero R] in
/-- **Twice-contracted Bianchi identity.** Explicit contraction of the
uncontracted identity and the two curvature antisymmetries gives
`2 * divRic = gradScalar`. -/
theorem contracted_bianchi
    (weight : I -> R) (dR : CurvatureDerivative (I := I) (R := R))
    (hFirst : ∀ e a b c d, dR e a b c d = -dR e b a c d)
    (hLast : ∀ e a b c d, dR e a b c d = -dR e a b d c)
    (hBianchi : ∀ e a b c d,
      dR e a b c d + dR c a b d e + dR d a b e c = 0)
    (d : I) :
    2 * divRic weight dR d = gradScalar weight dR d := by
  have hContractedSum :
      (∑ b, weight b * (∑ a, weight a * dR a a b b d)) =
        ∑ b, weight b *
          (dRic weight dR b b d - dRic weight dR d b b) := by
    apply Finset.sum_congr rfl
    intro b _
    rw [once_contracted_bianchi weight dR hLast hBianchi b b d]
  have hLeft :
      (∑ b, weight b * (∑ a, weight a * dR a a b b d)) =
        -divRic weight dR d := by
    calc
      (∑ b, weight b * (∑ a, weight a * dR a a b b d)) =
          ∑ b, ∑ a, -(weight a * (weight b * dR a b a b d)) := by
            apply Finset.sum_congr rfl
            intro b _
            rw [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro a _
            rw [hFirst a a b b d]
            ring
      _ = -(∑ a, ∑ b, weight a * (weight b * dR a b a b d)) := by
        rw [Finset.sum_comm]
        simp only [Finset.sum_neg_distrib]
      _ = -divRic weight dR d := by
        unfold divRic dRic
        simp_rw [Finset.mul_sum]
  have hRight :
      (∑ b, weight b *
        (dRic weight dR b b d - dRic weight dR d b b)) =
          divRic weight dR d - gradScalar weight dR d := by
    unfold divRic gradScalar
    simp_rw [mul_sub]
    rw [Finset.sum_sub_distrib]
  rw [hLeft, hRight] at hContractedSum
  linear_combination -hContractedSum

/-- The explicit divergence of the Einstein combination is Ricci divergence
minus one half the scalar-curvature gradient. -/
theorem divEinstein_eq
    (weight : I -> R) (dR : CurvatureDerivative (I := I) (R := R))
    (hWeight : ∀ i, weight i * weight i = 1) (d : I) :
    divEinstein weight dR d =
      divRic weight dR d - (1 / 2 : R) * gradScalar weight dR d := by
  unfold divEinstein dEinstein divRic
  simp_rw [mul_sub]
  rw [Finset.sum_sub_distrib]
  congr 1
  rw [Finset.sum_eq_single d]
  · simp only [diagonalMetric, if_pos]
    calc
      weight d * ((1 / 2 : R) * weight d * gradScalar weight dR d) =
          (1 / 2 : R) * (weight d * weight d) * gradScalar weight dR d := by
        ring
      _ = (1 / 2 : R) * gradScalar weight dR d := by
        rw [hWeight d]
        ring
  · intro b _ hbd
    simp [diagonalMetric, hbd]
  · simp

/-- **Finite-index divergence-free Einstein identity.** -/
theorem divEinstein_eq_zero
    (weight : I -> R) (dR : CurvatureDerivative (I := I) (R := R))
    (hWeight : ∀ i, weight i * weight i = 1)
    (hFirst : ∀ e a b c d, dR e a b c d = -dR e b a c d)
    (hLast : ∀ e a b c d, dR e a b c d = -dR e a b d c)
    (hBianchi : ∀ e a b c d,
      dR e a b c d + dR c a b d e + dR d a b e c = 0)
    (d : I) :
    divEinstein weight dR d = 0 := by
  rw [divEinstein_eq weight dR hWeight d]
  rw [← contracted_bianchi weight dR hFirst hLast hBianchi d]
  ring

end Components

/-! ## Nonzero two-dimensional witness -/

abbrev Fin2 := Fin 2

/-- The standard antisymmetric area form on two labels. -/
def witnessArea : Fin2 -> Fin2 -> ℚ := !![0, 1; -1, 0]

/-- A nonzero derivative covector. -/
def witnessQ (e : Fin2) : ℚ :=
  if e = 0 then 1 else 0

/-- A nonzero curvature-derivative tensor `q_e epsilon_ab epsilon_cd`. -/
def witnessDR : CurvatureDerivative (I := Fin2) (R := ℚ) :=
  fun e a b c d => witnessQ e * witnessArea a b * witnessArea c d

/-- Lorentzian `(+,-)` orthonormal-frame weights for the concrete witness. -/
def witnessWeight : Fin2 -> ℚ :=
  fun i => if i = 0 then 1 else -1

theorem witnessDR_first_antisymm (e a b c d : Fin2) :
    witnessDR e a b c d = -witnessDR e b a c d := by
  fin_cases e <;> fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
    norm_num [witnessDR, witnessQ, witnessArea]

theorem witnessDR_last_antisymm (e a b c d : Fin2) :
    witnessDR e a b c d = -witnessDR e a b d c := by
  fin_cases e <;> fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
    norm_num [witnessDR, witnessQ, witnessArea]

theorem witnessDR_bianchi (e a b c d : Fin2) :
    witnessDR e a b c d + witnessDR c a b d e + witnessDR d a b e c = 0 := by
  fin_cases e <;> fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
    norm_num [witnessDR, witnessQ, witnessArea]

/-- The witness exercises the contraction nontrivially, rather than putting
both sides of the contracted identity at zero. -/
theorem witness_nonzero_contractions :
    divRic witnessWeight witnessDR 0 = -1
      /\ gradScalar witnessWeight witnessDR 0 = -2 := by
  norm_num [divRic, dRic, gradScalar, witnessWeight, witnessDR, witnessQ,
    witnessArea, Fin.sum_univ_two]

/-- The contracted-Bianchi hypotheses have a nonzero model, and its Einstein
divergence vanishes by the general theorem. -/
theorem nonzero_contracted_bianchi_witness :
    witnessDR 0 0 1 0 1 = 1
      /\ (∀ e a b c d, witnessDR e a b c d = -witnessDR e b a c d)
      /\ (∀ e a b c d, witnessDR e a b c d = -witnessDR e a b d c)
      /\ (∀ e a b c d,
        witnessDR e a b c d + witnessDR c a b d e + witnessDR d a b e c = 0)
      /\ divRic witnessWeight witnessDR 0 = -1
      /\ gradScalar witnessWeight witnessDR 0 = -2
      /\ divEinstein witnessWeight witnessDR 0 = 0 := by
  refine ⟨by norm_num [witnessDR, witnessQ, witnessArea],
    witnessDR_first_antisymm, witnessDR_last_antisymm, witnessDR_bianchi,
    witness_nonzero_contractions.1, witness_nonzero_contractions.2, ?_⟩
  apply divEinstein_eq_zero witnessWeight witnessDR
  · intro i
    fin_cases i <;> norm_num [witnessWeight]
  · exact witnessDR_first_antisymm
  · exact witnessDR_last_antisymm
  · exact witnessDR_bianchi

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.contracted_bianchi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.contracted_bianchi

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.divEinstein_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.divEinstein_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.nonzero_contracted_bianchi_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.nonzero_contracted_bianchi_witness

end PhysicsSM.Draft.NullEdge.FiniteContractedBianchi
