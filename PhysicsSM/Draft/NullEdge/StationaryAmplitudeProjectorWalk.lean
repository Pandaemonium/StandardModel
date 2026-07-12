import Mathlib

/-!
# Stationary-amplitude projector walk

Clean-room theorem shape motivated by Gupta-Short, arXiv:2601.15885v2,
equations (29)-(31) and Appendix B. This file translates the mathematics, not
their implementation.

The key result is generic: two arbitrary orthogonal projectors need not
commute, yet the displayed range-one Laurent walk is exactly unitary on the
circle because it factors into two projector-controlled phases. The explicit
rational witness has a nonzero onsite amplitude.

## Faithfulness notes

Three of the originally displayed statements are literally false for the given
definitions and had to be corrected to their true mathematical content; each
correction is documented in the relevant docstring.  The corrections do not
touch the definitions, the noncommutation witness, or the nonzero onsite term.

* `stationaryWalk_expansion` needs `z ≠ 0`: the onsite band carries the factor
  `z * z⁻¹`, which collapses to `0` (not `1`) at `z = 0`, so the Laurent
  expansion fails there.  This is exactly the hypothesis every downstream
  unitarity statement already carries.
* `forwardPhase_conjTranspose` / `backwardPhase_conjTranspose`: the adjoint of a
  projector-controlled phase is the *same* kind of phase with the conjugated
  scalar, i.e. `forwardPhase z⁻¹ P` (resp. `backwardPhase z⁻¹ P`) under the
  on-circle relation `conj z = z⁻¹`, not the opposite phase family.  For
  `P = |0⟩⟨0|` and `z = i` one has `(forwardPhase i P)^H = diag(-i, 1)` while
  `backwardPhase i P = diag(1, -i)`, so the original claim is false; unitarity of
  each phase is unaffected and is proved directly below.

Provenance: clean-room theorem shape motivated by Gupta and Short,
arXiv:2601.15885v2, equations (29)--(31) and Appendix B. Proofs and the three
faithfulness corrections were produced by Aristotle project
`bb365801-8c75-4344-80c2-8d0a089a33ca` and independently rebuilt locally.
-/

open Matrix Complex

noncomputable section

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeProjectorWalk

variable {n : Type*} [Fintype n] [DecidableEq n]

abbrev Mat (n : Type*) [Fintype n] := Matrix n n Complex

def complement (P : Mat n) : Mat n := 1 - P

def forwardPhase (z : Complex) (P : Mat n) : Mat n :=
  z • P + complement P

def backwardPhase (z : Complex) (P : Mat n) : Mat n :=
  P + z⁻¹ • complement P

def gammaPlus (P Q : Mat n) : Mat n := P * Q
def gammaZero (P Q : Mat n) : Mat n :=
  P * complement Q + complement P * Q
def gammaMinus (P Q : Mat n) : Mat n := complement P * complement Q

def stationaryWalk (z : Complex) (P Q : Mat n) : Mat n :=
  forwardPhase z P * backwardPhase z Q

def IsUnitary (U : Mat n) : Prop :=
  U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1

/-- Exact range-one Laurent expansion, with a generally nonzero onsite term.

The hypothesis `z ≠ 0` is mathematically necessary and was added to the original
signature: the onsite (band-0) contribution collects the factor `z * z⁻¹`, which
equals `1` precisely when `z ≠ 0`.  At `z = 0` the left-hand side reduces to
`complement P * Q` while the right-hand side is `gammaZero P Q`, and these differ
in general, so the displayed expansion genuinely requires `z ≠ 0`. -/
theorem stationaryWalk_expansion (z : Complex) (P Q : Mat n) (hz : z ≠ 0) :
    stationaryWalk z P Q =
      z • gammaPlus P Q + gammaZero P Q + z⁻¹ • gammaMinus P Q := by
  unfold stationaryWalk forwardPhase backwardPhase gammaPlus gammaZero gammaMinus complement
  simp only [add_mul, mul_add, Matrix.smul_mul, Matrix.mul_smul, smul_smul]
  rw [inv_mul_cancel₀ hz]
  module

/-- Multiplication rule for two forward phases sharing a projector. -/
theorem forwardPhase_mul (P : Mat n) (hp : IsStarProjection P) (a b : Complex) :
    forwardPhase a P * forwardPhase b P = (a * b) • P + complement P := by
  have hidem : P * P = P := hp.isIdempotentElem
  unfold forwardPhase complement
  simp only [mul_add, add_mul, smul_mul_smul, Matrix.smul_mul, Matrix.mul_smul, hidem,
    mul_sub, sub_mul, Matrix.mul_one, Matrix.one_mul]
  module

/-- Multiplication rule for two backward phases sharing a projector. -/
theorem backwardPhase_mul (P : Mat n) (hp : IsStarProjection P) (a b : Complex) :
    backwardPhase a P * backwardPhase b P = P + (a⁻¹ * b⁻¹) • complement P := by
  have hidem : P * P = P := hp.isIdempotentElem
  unfold backwardPhase complement
  simp only [mul_add, add_mul, smul_mul_smul, Matrix.smul_mul, Matrix.mul_smul, hidem,
    mul_sub, sub_mul, Matrix.mul_one, Matrix.one_mul]
  module

/-- Adjoint of a forward phase.

The original claim `(forwardPhase z P)^H = backwardPhase z P` is false: the
adjoint of the projector-controlled phase `z` on `range P` is the phase `conj z`
on the same subspace, hence a *forward* phase again.  Under the on-circle
relation `conj z = z⁻¹` this is `forwardPhase z⁻¹ P`. -/
theorem forwardPhase_conjTranspose (z : Complex) (P : Mat n)
    (hp : IsStarProjection P)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    (forwardPhase z P).conjTranspose = forwardPhase z⁻¹ P := by
  have hsa : P.conjTranspose = P := hp.isSelfAdjoint
  unfold forwardPhase complement
  simp only [conjTranspose_add, conjTranspose_smul, conjTranspose_sub, conjTranspose_one, hsa,
    star_def]
  rw [hcircle]

/-- Adjoint of a backward phase.

The original claim `(backwardPhase z P)^H = forwardPhase z P` is false; as with
the forward phase, the adjoint stays inside the same phase family with the
conjugated scalar, giving `backwardPhase z⁻¹ P` under `conj z = z⁻¹`. -/
theorem backwardPhase_conjTranspose (z : Complex) (P : Mat n)
    (hp : IsStarProjection P)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    (backwardPhase z P).conjTranspose = backwardPhase z⁻¹ P := by
  have hsa : P.conjTranspose = P := hp.isSelfAdjoint
  unfold backwardPhase complement
  simp only [conjTranspose_add, conjTranspose_smul, conjTranspose_sub, conjTranspose_one, hsa,
    star_def]
  rw [map_inv₀, hcircle]

theorem forwardPhase_unitary (z : Complex) (P : Mat n)
    (hz : z ≠ 0) (hp : IsStarProjection P)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary (forwardPhase z P) := by
  constructor
  · rw [forwardPhase_conjTranspose z P hp hcircle, forwardPhase_mul P hp, inv_mul_cancel₀ hz]
    unfold complement; simp
  · rw [forwardPhase_conjTranspose z P hp hcircle, forwardPhase_mul P hp, mul_inv_cancel₀ hz]
    unfold complement; simp

theorem backwardPhase_unitary (z : Complex) (P : Mat n)
    (hz : z ≠ 0) (hp : IsStarProjection P)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary (backwardPhase z P) := by
  constructor
  · rw [backwardPhase_conjTranspose z P hp hcircle, backwardPhase_mul P hp, inv_inv,
      mul_inv_cancel₀ hz]
    unfold complement; simp
  · rw [backwardPhase_conjTranspose z P hp hcircle, backwardPhase_mul P hp, inv_inv,
      inv_mul_cancel₀ hz]
    unfold complement; simp

theorem isUnitary_mul {U V : Mat n}
    (hU : IsUnitary U) (hV : IsUnitary V) : IsUnitary (U * V) := by
  obtain ⟨hU1, hU2⟩ := hU
  obtain ⟨hV1, hV2⟩ := hV
  constructor
  · rw [conjTranspose_mul]
    calc V.conjTranspose * U.conjTranspose * (U * V)
        = V.conjTranspose * (U.conjTranspose * U) * V := by
            rw [Matrix.mul_assoc, Matrix.mul_assoc, ← Matrix.mul_assoc U.conjTranspose]
      _ = 1 := by rw [hU1, Matrix.mul_one, hV1]
  · rw [conjTranspose_mul]
    calc U * V * (V.conjTranspose * U.conjTranspose)
        = U * (V * V.conjTranspose) * U.conjTranspose := by
            rw [Matrix.mul_assoc, Matrix.mul_assoc, ← Matrix.mul_assoc V]
      _ = 1 := by rw [hV2, Matrix.mul_one, hU2]

/-- Exact unitarity without assuming the two projectors commute. -/
theorem stationaryWalk_unitary (z : Complex) (P Q : Mat n)
    (hz : z ≠ 0) (hp : IsStarProjection P) (hq : IsStarProjection Q)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary (stationaryWalk z P Q) := by
  unfold stationaryWalk
  exact isUnitary_mul (forwardPhase_unitary z P hz hp hcircle)
    (backwardPhase_unitary z Q hz hq hcircle)

/-! ## Exact noncommuting two-band witness -/

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

def projA : M2 := !![1, 0; 0, 0]
def projB : M2 := !![9 / 25, 12 / 25; 12 / 25, 16 / 25]

theorem projA_isStarProjection : IsStarProjection projA := by
  constructor
  · change projA * projA = projA
    unfold projA; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two]
  · change star projA = projA
    unfold projA; ext i j; fin_cases i <;> fin_cases j <;> simp

theorem projB_isStarProjection : IsStarProjection projB := by
  constructor
  · change projB * projB = projB
    unfold projB; ext i j; fin_cases i <;> fin_cases j <;>
      · simp [Matrix.mul_apply, Fin.sum_univ_two]; norm_num
  · change star projB = projB
    unfold projB; ext i j; fin_cases i <;> fin_cases j <;> simp

theorem projectors_do_not_commute : projA * projB ≠ projB * projA := by
  unfold projA projB
  intro h
  have h01 := congrFun (congrFun h 0) 1
  simp [Matrix.mul_apply, Fin.sum_univ_two] at h01

/-- The onsite amplitude is genuine, not a rewritten pure shift. -/
theorem gammaZero_nonzero :
    gammaZero projA projB = !![16 / 25, -12 / 25; 12 / 25, 16 / 25] ∧
      gammaZero projA projB ≠ 0 := by
  have hval : gammaZero projA projB = !![16 / 25, -12 / 25; 12 / 25, 16 / 25] := by
    unfold gammaZero complement projA projB
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.sub_apply, Matrix.one_apply,
        Matrix.add_apply, Matrix.vecMul, dotProduct] <;> norm_num
  refine ⟨hval, ?_⟩
  rw [hval]
  intro h
  have h00 := congrFun (congrFun h 0) 0
  simp at h00

/-- Nonvacuous exact unitary with a nonzero stationary amplitude. -/
theorem explicit_stationary_walk_unitary :
    IsUnitary (stationaryWalk I projA projB) ∧ gammaZero projA projB ≠ 0 := by
  have hcircle : starRingEnd Complex I = I⁻¹ := by rw [Complex.inv_I, Complex.conj_I]
  refine ⟨stationaryWalk_unitary I projA projB Complex.I_ne_zero
    projA_isStarProjection projB_isStarProjection hcircle, gammaZero_nonzero.2⟩

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeProjectorWalk.stationaryWalk_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms stationaryWalk_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeProjectorWalk.explicit_stationary_walk_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms explicit_stationary_walk_unitary

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeProjectorWalk
