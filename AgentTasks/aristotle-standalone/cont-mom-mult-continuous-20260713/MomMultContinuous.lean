import PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE
import PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz

/-!
# Continuity and measurability of the live Dirac momentum multiplier

This focused target supplies the live hypothesis needed to instantiate the
generic representative-safe `L2` pointwise-isometry lift.  The multiplier is
the repository's actual exact Hermitian-generated flow, not an abstract
surrogate.

The target is deliberately narrower than an `L2` evolution theorem.  It proves
continuity and hence almost-everywhere strong measurability of the pointwise
operator family.  It does not claim an `L2` lift, a group law, Fourier
transport, strong time continuity, a generator theorem, or a PDE.

The intended proof may use either continuity of the matrix exponential under
the explicit definition of `exactFlow`, or the already landed sharp momentum
Lipschitz estimate in `ExactFlowMomentumLipschitz`.
-/

noncomputable section

open MeasureTheory
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE

open ChangingCellScaledLiveWalk
open ChangingCellFourierL2

/-- **Immutable target.** The exact Dirac multiplier varies continuously with
the Euclidean momentum coordinate. -/
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

/-- The live exact multiplier family is strongly measurable, hence is a valid
input to representative-safe pointwise multiplication on vector-valued `L2`. -/
theorem momMult_aestronglyMeasurable (m t : Real) :
    AEStronglyMeasurable (momMult m t) volume := by
  exact (momMult_continuous m t).aestronglyMeasurable

/-! ## Scope controls -/

/-- Continuity is compatible with the already landed pointwise isometry at the
nonzero rest witness; this does not identify the resulting `L2` operator. -/
example (t : Real) (v : Spinor) :
    norm (momMult 4 t restWitnessK v) = norm v :=
  momMult_isometry 4 t restWitnessK v

end PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE
