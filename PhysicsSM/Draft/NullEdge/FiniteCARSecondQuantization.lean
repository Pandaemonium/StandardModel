import PhysicsSM.Draft.NullEdge.FiniteCARFockBasic

/-!
# Determinant-minor finite second quantization

This module defines the occupation-basis exterior-power lift `Gamma(U)` of an
arbitrary finite one-particle matrix.  It proves vacuum preservation, exact
one-particle agreement, linearity, and conservation of particle number and
fermion parity.

Creation-operator covariance, functoriality, unitarity for unitary `U`, and
inherited spatial locality remain successor theorems.  No such stronger claim
is inferred from the sector-diagonal results here.

Provenance: harvested completed prefix of Aristotle project
`b605f8b8-a75d-46b5-92b8-62fc57e82d79`; determinant-minor architecture from
project `4d62041f-b9c0-4530-975e-2fa440d9bc5b`.  Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization

open Finset Matrix
open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic

variable {ι : Type*} [Fintype ι] [DecidableEq ι] [LinearOrder ι]

/-- Occupation-basis vector labelled by `S`. -/
def basisVec (S : Finset ι) : Fock ι := fun T => if T = S then 1 else 0

/-- The empty occupation state. -/
def vac : Fock ι := basisVec ∅

/-- The ordered `T`-by-`S` minor of `U`, zero between unequal sectors. -/
def gammaEntry (U : Matrix ι ι Complex) (T S : Finset ι) : Complex :=
  if h : S.card = T.card then
    Matrix.det (Matrix.of fun a b : Fin T.card =>
      U (T.orderEmbOfFin rfl a) (S.orderEmbOfFin h b))
  else 0

/-- The determinant-minor second quantization of `U`. -/
def Gamma (U : Matrix ι ι Complex) (psi : Fock ι) : Fock ι := fun T =>
  ∑ S : Finset ι, gammaEntry U T S * psi S

omit [Fintype ι] [DecidableEq ι] in
/-- The empty minor is one. -/
theorem gammaEntry_empty
    (U : Matrix ι ι Complex) :
    gammaEntry U ∅ ∅ = 1 := by
  unfold gammaEntry
  aesop

/-- Second quantization fixes the vacuum. -/
theorem Gamma_vac (U : Matrix ι ι Complex) : Gamma U vac = vac := by
  ext T
  by_cases hT : T = ∅ <;> simp +decide [hT, Gamma, vac, basisVec]
  · exact gammaEntry_empty U
  · unfold gammaEntry
    grind

omit [Fintype ι] in
/-- A one-particle minor is the corresponding matrix element. -/
theorem gammaEntry_singleton
    (U : Matrix ι ι Complex) (j k : ι) :
    gammaEntry U {j} {k} = U j k := by
  by_cases h : k = j <;> simp +decide [h, gammaEntry]
  · convert Matrix.det_fin_one _
    simp +decide [Finset.orderEmbOfFin_apply]
  · convert Matrix.det_fin_one _
    congr
    · simp +decide [Finset.orderEmbOfFin_apply]
      rfl
    · convert Finset.orderEmbOfFin_mem {k} _ _
      aesop

omit [DecidableEq ι] in
/-- `Gamma U` is additive in the Fock vector. -/
theorem Gamma_add
    (U : Matrix ι ι Complex) (psi phi : Fock ι) :
    Gamma U (psi + phi) = Gamma U psi + Gamma U phi := by
  ext T
  simp +decide [Gamma, mul_add, Finset.sum_add_distrib]

omit [DecidableEq ι] in
/-- `Gamma U` commutes with complex scalar multiplication. -/
theorem Gamma_smul
    (U : Matrix ι ι Complex) (c : Complex) (psi : Fock ι) :
    Gamma U (c • psi) = c • Gamma U psi := by
  unfold Gamma
  ext T
  simp +decide [mul_left_comm, Finset.mul_sum]

/-- Exact agreement with `U` on occupation-basis one-particle states. -/
theorem Gamma_apply_singleton (U : Matrix ι ι Complex) (j k : ι) :
    Gamma U (basisVec {k}) {j} = U j k := by
  simp only [Gamma, basisVec, mul_ite, mul_one, mul_zero,
    Finset.sum_ite_eq', Finset.mem_univ, if_true]
  exact gammaEntry_singleton U j k

/-- Total particle number in the occupation basis. -/
def totalNumber (psi : Fock ι) : Fock ι := fun S =>
  (S.card : Complex) * psi S

/-- Fermion parity in the occupation basis. -/
def parity (psi : Fock ι) : Fock ι := fun S =>
  (-1 : Complex) ^ S.card * psi S

omit [DecidableEq ι] in
/-- The minor lift preserves particle number for every matrix `U`. -/
theorem Gamma_number
    (U : Matrix ι ι Complex) (psi : Fock ι) :
    Gamma U (totalNumber psi) = totalNumber (Gamma U psi) := by
  ext T
  unfold Gamma totalNumber
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl fun S _ => ?_
  unfold gammaEntry
  split_ifs <;> simp_all +decide [mul_assoc, mul_comm, mul_left_comm]

omit [DecidableEq ι] in
/-- The minor lift preserves fermion parity for every matrix `U`. -/
theorem Gamma_parity
    (U : Matrix ι ι Complex) (psi : Fock ι) :
    Gamma U (parity psi) = parity (Gamma U psi) := by
  ext T
  simp +decide [parity, Gamma]
  rw [Finset.mul_sum]
  grind +locals

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.Gamma_vac' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Gamma_vac

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.Gamma_apply_singleton' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Gamma_apply_singleton

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.Gamma_number' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Gamma_number

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization.Gamma_parity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Gamma_parity

end PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization
