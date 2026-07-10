/-
# Closing the static-vs-dynamical gap for the carrier Krein flow

Kernel-clean (no `sorry`/`admit`/`native_decide`/new `axiom`; target footprint
`[propext, Classical.choice, Quot.sound]`) proofs of:

1. `HAC_Jmet_selfAdjoint` : `Jmet * HAC = HACᴴ * Jmet`  (`HAC` is `Jmet`-self-adjoint).
2. `HAC_sector_invariant` : `HAC * Piso = Piso * (Pisoᴴ * HAC * Piso)`
   (`range Piso`, the `J`-positive sector, is `HAC`-invariant).
3. The general reusable lemma `J_selfAdjoint_flow_J_unitary`: if `J` is Hermitian,
   `J² = 1`, and `J H = Hᴴ J`, then the flow `exp(-i t H)` is `J`-unitary
   (`Uᴴ J U = J`), together with `HAC_flow_Jmet_unitary` (its instantiation on the
   witness) and `HAC_flow_sector_invariant` (invariance of `range Piso` under the
   flow, lifted from (2)).

Together these upgrade the sector orbit from Euclidean-norm-conserving to
Krein-form-conserving and sector-preserving, closing the audited dynamical half.
-/

import Mathlib
import src.SectorGroundMassWitness

namespace PhysicsSM.Draft.NullEdge.Carrier.CarrierKreinFlow

open Matrix Complex
open PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness

/-! ## Target (1): `HAC` is `Jmet`-self-adjoint -/

set_option maxHeartbeats 1000000 in
/-- **Target (1).** `HAC` is Krein- (`Jmet`-) self-adjoint: `Jmet * HAC = HACᴴ * Jmet`.
A finite matrix identity on the explicit entries. -/
theorem HAC_Jmet_selfAdjoint : Jmet * HAC = HACᴴ * Jmet := by
  ext i j
  simp only [Jmet, Matrix.diagonal_mul, Matrix.mul_diagonal, Matrix.conjTranspose_apply]
  fin_cases i <;> fin_cases j <;> simp [HAC]

/-! ## Target (2): the `J`-positive sector `range Piso` is `HAC`-invariant -/

set_option maxHeartbeats 1000000 in
/-- **Target (2).** The `J`-positive sector `range Piso` is `HAC`-invariant:
`HAC * Piso = Piso * (Pisoᴴ * HAC * Piso)`.  Since `Pisoᴴ Piso = 1` and
`M6 = Pisoᴴ HAC Piso`, this says `HAC` maps `range Piso` into itself. -/
theorem HAC_sector_invariant :
    HAC * Piso = Piso * (Pisoᴴ * HAC * Piso) := by
  rw [compression_eq]
  ext i j
  simp only [Matrix.mul_apply, Fin.sum_univ_succ, Fin.sum_univ_zero]
  fin_cases i <;> fin_cases j <;> simp [HAC, Piso, M6]

/-! ## Target (3): general `J`-self-adjoint generator ⇒ `J`-unitary flow -/

/-- **Key algebraic identity.** If `J H = Hᴴ J` (with `t : ℝ`), then the generator
`A = (-(t:ℂ)) • (Complex.I • H)` satisfies `J * A = -(Aᴴ) * J`. -/
theorem gen_Jmet_anticomm {n : Type*} [Fintype n] [DecidableEq n]
    {J H : Matrix n n ℂ} (hcomm : J * H = Hᴴ * J) (t : ℝ) :
    J * ((-(t : ℂ)) • (Complex.I • H)) =
      -(((-(t : ℂ)) • (Complex.I • H))ᴴ) * J := by
  have hAH : (((-(t : ℂ)) • (Complex.I • H))ᴴ)
      = (t : ℂ) • (Complex.I • Hᴴ) := by
    rw [conjTranspose_smul, conjTranspose_smul, smul_smul, smul_smul]
    congr 1
    simp [Complex.conj_I, Complex.conj_ofReal]
  rw [hAH, Matrix.mul_smul, Matrix.mul_smul, hcomm]
  rw [neg_smul, neg_mul, Matrix.smul_mul, Matrix.smul_mul]

/-- **Target (3), general reusable lemma.** If `J` is Hermitian, `J² = 1`, and
`J H = Hᴴ J` (i.e. `H` is `J`-self-adjoint), then the flow `U = exp(-i t H)` is
`J`-unitary: `Uᴴ J U = J`. -/
theorem J_selfAdjoint_flow_J_unitary {n : Type*} [Fintype n] [DecidableEq n]
    {J H : Matrix n n ℂ} (hJ2 : J * J = 1) (hcomm : J * H = Hᴴ * J) (t : ℝ) :
    (NormedSpace.exp ((-(t : ℂ)) • (Complex.I • H)))ᴴ * J *
        (NormedSpace.exp ((-(t : ℂ)) • (Complex.I • H))) = J := by
  set A : Matrix n n ℂ := (-(t : ℂ)) • (Complex.I • H) with hA
  set U : Matrix n n ℂ := NormedSpace.exp A with hU
  have hJunit : IsUnit J := (⟨J, J, hJ2, hJ2⟩ : (Matrix n n ℂ)ˣ).isUnit
  have hJinv : J⁻¹ = J := Matrix.inv_eq_right_inv hJ2
  -- key: `J * A * J = -Aᴴ`
  have hJA : J * A = -(Aᴴ) * J := gen_Jmet_anticomm hcomm t
  have hconj : J * A * J = -(Aᴴ) := by
    rw [hJA, Matrix.mul_assoc, hJ2, Matrix.mul_one]
  -- conjugation of exp
  have hexpconj : NormedSpace.exp (J * A * J) = J * U * J := by
    have h := Matrix.exp_conj J A hJunit
    rw [hJinv] at h
    exact h
  rw [hconj] at hexpconj
  -- Uᴴ = exp Aᴴ
  have hUH : Uᴴ = NormedSpace.exp (Aᴴ) := by
    rw [hU, (Matrix.exp_conjTranspose A).symm]
  -- exp(Aᴴ) * exp(-Aᴴ) = 1
  have hcancel : NormedSpace.exp (Aᴴ) * NormedSpace.exp (-(Aᴴ)) = 1 := by
    rw [← Matrix.exp_add_of_commute _ _ ((Commute.refl (Aᴴ)).neg_right),
      add_neg_cancel, NormedSpace.exp_zero]
  -- assemble
  have h1 : Uᴴ * (J * U * J) = 1 := by
    rw [hUH, ← hexpconj, hcancel]
  calc Uᴴ * J * U
      = (Uᴴ * (J * U * J)) * J := by
        rw [Matrix.mul_assoc, Matrix.mul_assoc, Matrix.mul_assoc,
          Matrix.mul_assoc, hJ2, Matrix.mul_one]
    _ = J := by rw [h1, Matrix.one_mul]

/-- **Target (3) instantiated.** The Krein flow `exp(-i t HAC)` on the witness is
`Jmet`-unitary: `Uᴴ Jmet U = Jmet`. -/
theorem HAC_flow_Jmet_unitary (t : ℝ) :
    (NormedSpace.exp ((-(t : ℂ)) • (Complex.I • HAC)))ᴴ * Jmet *
        (NormedSpace.exp ((-(t : ℂ)) • (Complex.I • HAC))) = Jmet :=
  J_selfAdjoint_flow_J_unitary Jmet_sq HAC_Jmet_selfAdjoint t

-- The matrix `NormedSpace.exp` series lemmas need the L2 operator-norm instance;
-- this coercion instance otherwise causes an elaboration loop (see the analogous
-- workaround in `Mathlib/Analysis/Normed/Algebra/MatrixExponential.lean`).
attribute [-instance] Matrix.SpecialLinearGroup.hasCoeToGeneralLinearGroup

open scoped Norms.Operator in
/-- **Exponential intertwining.** If `X * P = P * Y` (with `P` possibly
rectangular) then `exp X * P = P * exp Y`. Proved from `X ^ k * P = P * Y ^ k`
and pushing left/right multiplication (continuous linear maps) through the
exponential power series. -/
theorem exp_intertwine {n m : Type*} [Fintype n] [DecidableEq n]
    [Fintype m] [DecidableEq m]
    (X : Matrix n n ℂ) (Y : Matrix m m ℂ) (P : Matrix n m ℂ)
    (h : X * P = P * Y) :
    NormedSpace.exp X * P = P * NormedSpace.exp Y := by
  have hpow : ∀ k : ℕ, X ^ k * P = P * Y ^ k := by
    intro k
    induction k with
    | zero => simp
    | succ k ih => rw [pow_succ, pow_succ, Matrix.mul_assoc, h, ← Matrix.mul_assoc, ih,
        Matrix.mul_assoc]
  let R : Matrix n n ℂ →ₗ[ℂ] Matrix n m ℂ :=
    { toFun := fun Z => Z * P
      map_add' := fun A B => by simp [Matrix.add_mul]
      map_smul' := fun a A => by simp [Matrix.smul_mul] }
  let L : Matrix m m ℂ →ₗ[ℂ] Matrix n m ℂ :=
    { toFun := fun Z => P * Z
      map_add' := fun A B => by simp [Matrix.mul_add]
      map_smul' := fun a A => by simp [Matrix.mul_smul] }
  have hX := (NormedSpace.exp_series_hasSum_exp' (𝕂 := ℂ) X).mapL R.toContinuousLinearMap
  have hY := (NormedSpace.exp_series_hasSum_exp' (𝕂 := ℂ) Y).mapL L.toContinuousLinearMap
  simp only [map_smul] at hX hY
  have hX' : HasSum (fun k => ((k.factorial : ℂ))⁻¹ • (X ^ k * P)) (NormedSpace.exp X * P) := hX
  have hY' : HasSum (fun k => ((k.factorial : ℂ))⁻¹ • (P * Y ^ k)) (P * NormedSpace.exp Y) := hY
  have hfun : (fun k => ((k.factorial : ℂ))⁻¹ • (X ^ k * P))
      = (fun k => ((k.factorial : ℂ))⁻¹ • (P * Y ^ k)) := by
    funext k; rw [hpow]
  rw [hfun] at hX'
  exact hX'.unique hY'

/-- **General invariance lifting.** If `H * P = P * M` (a subspace spanned by the
columns of `P` is `H`-invariant with restriction `M`), then the flow intertwines:
`exp(-i t H) * P = P * exp(-i t M)`, i.e. the flow preserves `range P`. -/
theorem flow_intertwine {n m : Type*} [Fintype n] [DecidableEq n]
    [Fintype m] [DecidableEq m]
    {H : Matrix n n ℂ} {P : Matrix n m ℂ} {M : Matrix m m ℂ}
    (hinv : H * P = P * M) (t : ℝ) :
    NormedSpace.exp ((-(t : ℂ)) • (Complex.I • H)) * P
      = P * NormedSpace.exp ((-(t : ℂ)) • (Complex.I • M)) := by
  have hintertwine : ((-(t : ℂ)) • (Complex.I • H)) * P
      = P * ((-(t : ℂ)) • (Complex.I • M)) := by
    simp only [Matrix.smul_mul, Matrix.mul_smul, hinv]
  exact exp_intertwine _ _ _ hintertwine

/-- **Target (3), sector invariance.** The flow `exp(-i t HAC)` preserves the
`J`-positive sector `range Piso`: `exp(-i t HAC) * Piso = Piso * exp(-i t M6)`
where `M6 = Pisoᴴ HAC Piso` is the compressed sector generator. -/
theorem HAC_flow_sector_invariant (t : ℝ) :
    NormedSpace.exp ((-(t : ℂ)) • (Complex.I • HAC)) * Piso
      = Piso * NormedSpace.exp ((-(t : ℂ)) • (Complex.I • (Pisoᴴ * HAC * Piso))) :=
  flow_intertwine HAC_sector_invariant t

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierKreinFlow.HAC_Jmet_selfAdjoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms HAC_Jmet_selfAdjoint

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierKreinFlow.HAC_sector_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms HAC_sector_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierKreinFlow.J_selfAdjoint_flow_J_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms J_selfAdjoint_flow_J_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierKreinFlow.HAC_flow_Jmet_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms HAC_flow_Jmet_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierKreinFlow.HAC_flow_sector_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms HAC_flow_sector_invariant

end PhysicsSM.Draft.NullEdge.Carrier.CarrierKreinFlow
