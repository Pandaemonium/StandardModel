import PhysicsSM.Draft.NullEdge.ChangingCellFourierL2
import PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz
import PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry

/-!
# Exact Dirac momentum multiplier on pointwise spinors and L2

This module packages the existing exact Hermitian-generated Dirac flow
`Compact3Plus1DiracRate.exactFlow` as a continuous linear map on the
repository's Euclidean spinor, proves pointwise norm preservation and momentum
continuity, and then packages the measurable family as a representative-safe
linear isometry of momentum-space `L2`.

The proof reuses `Compact3Plus1DiracRate.exactFlow_mem_unitary` (the matrix
belongs to the unitary group) together with the star-algebra structure of
`Matrix.toEuclideanCLM`. The resulting theorem is an exact momentum-space `L2`
isometry. It does not yet prove the time-group law, Fourier transport, strong
time continuity, a generator identity, the position-space PDE, a continuum
limit, or Lorentz restoration.

Provenance: clean-room composition of the project's exact-flow unitarity module
with Mathlib's `Matrix.toEuclideanCLM` C-star-algebra API. The pointwise proof
body was returned by Aristotle project
`e790e78a-eab4-4ddd-bfa6-719a302efb5f`. The continuity proof and generic `L2`
lift were independently audited by the other model family on 2026-07-13.
-/

noncomputable section

open Matrix Complex
open MeasureTheory
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE

open ChangingCellScaledLiveWalk
open ChangingCellFourierL2
open Compact3Plus1DiracRate
open VariablePointwiseL2Isometry

/-- Exact momentum-space Dirac multiplier as a bounded operator on the spinor. -/
def momMult (m t : Real) (k : FourierMomentum3) : Spinor →L[Complex] Spinor :=
  Matrix.toEuclideanCLM (𝕜 := Complex)
    (exactFlow (k 0) (k 1) (k 2) m t)

/-- Pointwise unitarity of the exact Hermitian-generated multiplier. -/
theorem momMult_isometry (m t : Real) (k : FourierMomentum3) (v : Spinor) :
    norm (momMult m t k v) = norm v := by
  have h_unitary : forall u v : Spinor,
      inner Complex ((momMult m t k) u) ((momMult m t k) v) = inner Complex u v := by
    intro u v
    have h_matrix :
        Matrix.conjTranspose (exactFlow (k 0) (k 1) (k 2) m t) *
            exactFlow (k 0) (k 1) (k 2) m t = 1 := by
      convert
        Compact3Plus1DiracRate.exactFlow_mem_unitary
          (k.ofLp 0) (k.ofLp 1) (k.ofLp 2) m t |>.1 using 1
    convert congr_arg
      (fun x : Matrix (Fin 4) (Fin 4) Complex => dotProduct (star u) (x.mulVec v))
      h_matrix using 1 <;>
      simp +decide [Matrix.mulVec, dotProduct, mul_comm, Fin.sum_univ_four]
    · simp +decide [Fin.sum_univ_four, inner]
      simp +decide [momMult, Matrix.mulVec, dotProduct, Fin.sum_univ_four,
        Matrix.mul_apply, Matrix.conjTranspose_apply]
      ring
    · simp +decide [inner, Fin.sum_univ_four]
  simp_all +decide [EuclideanSpace.norm_eq, Complex.normSq, Complex.sq_norm]
  simp_all +decide [Complex.ext_iff, inner]

/-- The exact Dirac multiplier varies continuously with the Euclidean momentum
coordinate. -/
theorem momMult_continuous (m t : Real) : Continuous (momMult m t) := by
  unfold momMult
  have h_toCLM : Isometry
      (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)) := by
    apply Isometry.of_dist_eq
    intro A B
    simpa [dist_eq_norm, map_sub] using
      Matrix.l2_opNorm_toEuclideanCLM (A - B)
  apply h_toCLM.continuous.comp
  let K : NNReal := ⟨3 * |t|, mul_nonneg (by norm_num) (abs_nonneg t)⟩
  exact (LipschitzWith.of_dist_le_mul fun k q => by
    have h0 : |k.ofLp 0 - q.ofLp 0| <= norm (k - q) := by
      simpa [Real.norm_eq_abs] using
        (PiLp.norm_apply_le (k - q) (0 : Fin 3))
    have h1 : |k.ofLp 1 - q.ofLp 1| <= norm (k - q) := by
      simpa [Real.norm_eq_abs] using
        (PiLp.norm_apply_le (k - q) (1 : Fin 3))
    have h2 : |k.ofLp 2 - q.ofLp 2| <= norm (k - q) := by
      simpa [Real.norm_eq_abs] using
        (PiLp.norm_apply_le (k - q) (2 : Fin 3))
    rw [dist_eq_norm]
    refine (ExactFlowMomentumLipschitz.exactFlow_momentum_lipschitz
      (k.ofLp 0) (k.ofLp 1) (k.ofLp 2)
      (q.ofLp 0) (q.ofLp 1) (q.ofLp 2) m t).trans ?_
    change |t| *
        (|k.ofLp 0 - q.ofLp 0| + |k.ofLp 1 - q.ofLp 1| +
          |k.ofLp 2 - q.ofLp 2|) <= (K : Real) * norm (k - q)
    simp only [K, NNReal.coe_mk]
    nlinarith [abs_nonneg t, norm_nonneg (k - q)]).continuous

/-- The live exact multiplier family is almost-everywhere strongly measurable. -/
theorem momMult_aestronglyMeasurable (m t : Real) :
    AEStronglyMeasurable (momMult m t) volume := by
  exact (momMult_continuous m t).aestronglyMeasurable

/-- Representative-safe exact multiplier evolution on momentum-space `L2`. -/
noncomputable def momMultL2Isometry (m t : Real) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) →ₗᵢ[Complex]
      Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  variablePointwiseL2Isometry (volume : Measure FourierMomentum3) (momMult m t)
    (momMult_aestronglyMeasurable m t) (momMult_isometry m t)

/-- The momentum-space `L2` lift agrees almost everywhere with the actual
pointwise Dirac multiplier. -/
theorem momMultL2Isometry_coeFn (m t : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    momMultL2Isometry m t f =ᵐ[(volume : Measure FourierMomentum3)]
      fun k => momMult m t k (f k) := by
  exact variablePointwiseL2Isometry_coeFn
    (volume : Measure FourierMomentum3) (momMult m t)
    (momMult_aestronglyMeasurable m t) (momMult_isometry m t) f

/-- The lifted exact multiplier preserves the full momentum-space `L2` norm. -/
theorem momMultL2Isometry_norm (m t : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    norm (momMultL2Isometry m t f) = norm f := by
  exact (momMultL2Isometry m t).norm_map f

/-! ### Controls

The theorem is universal, so the requested controls are immediate instances. -/

/-- Control `t = 0`: the zero-time multiplier preserves the norm. -/
example (m : Real) (k : FourierMomentum3) (v : Spinor) :
    norm (momMult m 0 k v) = norm v :=
  momMult_isometry m 0 k v

/-- Control `v = 0`: the multiplier sends the zero spinor to a zero-norm spinor. -/
example (m t : Real) (k : FourierMomentum3) :
    norm (momMult m t k (0 : Spinor)) = 0 :=
  (momMult_isometry m t k (0 : Spinor)).trans norm_zero

/-- The nonzero exact rest witness `m = 4`, `k = (3, 0, 0)`. -/
def restWitnessK : FourierMomentum3 :=
  (WithLp.equiv 2 (Fin 3 -> Real)).symm ![3, 0, 0]

/-- Control at the nonzero exact rest witness `m = 4`, `k = (3, 0, 0)`. -/
example (t : Real) (v : Spinor) :
    norm (momMult 4 t restWitnessK v) = norm v :=
  momMult_isometry 4 t restWitnessK v

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE.momMult_isometry' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms momMult_isometry

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE.momMult_continuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms momMult_continuous

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE.momMultL2Isometry_coeFn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms momMultL2Isometry_coeFn

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE.momMultL2Isometry_norm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms momMultL2Isometry_norm

end PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE
