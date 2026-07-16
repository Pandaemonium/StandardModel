import PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE
import PhysicsSM.Draft.NullEdge.MomMultL2StrongContinuity
import PhysicsSM.Draft.NullEdge.ExactFlowGenerator
import PhysicsSM.Draft.NullEdge.HermitianExpLipschitz
import PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry

/-!
# Compact-momentum-support L2 generator of the exact Dirac flow

This module is the compact-support successor to the stalled full graph-domain
attempt. It works with the actual live momentum-space objects
`ChangingCellFourierPDE.momMult` / `momMultL2Isometry` and the live fibre
generator `ExactFlowGenerator.fibreGenerator` (`G_m(k) v = -i H(k,m) v`).

Status: the finite-dimensional norm bounds, momentum continuity, Duhamel bound,
measurability, bounded-support `MemLp` packaging, and nonzero witness are
complete and guard-pinned below. The sequential `Lp` slope limit is the one
remaining explicit draft proof hole. The final strong derivative is now an
exact wrapper around that slope theorem, so it still inherits the placeholder
dependency until the genuine dominated-convergence proof lands. Step 1 below
is complete; step 2 describes the remaining analytic target.

The construction is intended to proceed in two genuine analytic steps.

1. **Bounded support implies the generator representative is `L2`.** For a
   momentum-space state `f` whose (representative-independent) support lives in
   a ball of finite radius `R`, the fibre-generator norm is bounded on that
   ball, so the pointwise action `k ↦ -i H(k,m) (f k)` is strongly measurable
   and belongs to `L2`. We package it as an `Lp` element `genRepr` through
   `MemLp.toLp`, never selecting a representative-dependent value.

2. **The exact orbit has that strong derivative at zero.** The orbit
   `t ↦ momMultL2Isometry m t f` is differentiable at `t = 0` in the genuine
   `Lp` norm, with derivative `genRepr`. The proof is a real dominated-
   convergence argument for difference quotients: the pointwise slope converges
   to `-i H(k,m)(f k)` by the fibre derivative, and it is dominated uniformly in
   the time step by `2‖H(k,m)‖‖f k‖`, which is `L2` on the support ball by the
   Duhamel estimate `‖exp(-itH) - 1‖ ≤ |t|‖H‖`.

Scope (deliberately narrow, matching the work item): no bounded full-`L2`
generator, no time-flow operator-norm continuity or Stone theorem, no Fourier
transport, no position-space PDE, no lattice limit, and no Lorentz restoration.
-/

noncomputable section

open Matrix Complex
open MeasureTheory Filter Topology
open scoped Matrix.Norms.L2Operator ENNReal

namespace PhysicsSM.Draft.NullEdge.CompactSupportL2Generator

open ChangingCellScaledLiveWalk
open ChangingCellFourierL2
open ChangingCellFourierPDE
open Compact3Plus1DiracRate
open ExactFlowGenerator
open MomMultL2StrongContinuity
open VariablePointwiseL2Isometry
open HermitianExpLipschitz

/-! ## Bounded-support predicate (representative independent) -/

/-- Representative-independent bounded-support predicate: almost every momentum
outside the ball of radius `R` maps the canonical `Lp` representative to zero.
Because it is phrased through the almost-everywhere coercion of the `Lp` class,
it does not depend on the choice of representative. -/
def BoundedSupport (R : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) : Prop :=
  ∀ᵐ k ∂(volume : Measure FourierMomentum3), R < ‖k‖ → f k = 0

/-! ## The fibre generator as a continuous linear map family -/

/-- The pointwise fibre-generator action `G_m(k) = -i H(k,m)` as a bounded
operator on the spinor fibre, using the live `ExactFlowGenerator.fibreGenerator`. -/
def genMult (m : Real) (k : FourierMomentum3) : Spinor →L[Complex] Spinor :=
  Matrix.toEuclideanCLM (𝕜 := Complex) (fibreGenerator (k 0) (k 1) (k 2) m)

/-! ## Item 2: explicit fibre-generator norm bound on the support ball -/

/-- The fibre generator has the same L2 operator norm as the Dirac fibre
Hamiltonian, hence is bounded by `|k₀| + |k₁| + |k₂| + |m|`. -/
theorem fibreGenerator_opNorm_le (kx ky kz m : Real) :
    ‖fibreGenerator kx ky kz m‖ ≤ |kx| + |ky| + |kz| + |m| := by
  rw [fibreGenerator, norm_smul, norm_neg, Complex.norm_I, one_mul]
  exact norm_H_le_B4 kx ky kz m

/-- On the ball `‖k‖ ≤ R`, the fibre generator norm is bounded by `3R + |m|`. -/
theorem fibreGenerator_opNorm_le_on_ball (m R : Real) (k : FourierMomentum3)
    (hk : ‖k‖ ≤ R) :
    ‖fibreGenerator (k 0) (k 1) (k 2) m‖ ≤ 3 * R + |m| := by
  refine le_trans (fibreGenerator_opNorm_le (k 0) (k 1) (k 2) m) ?_
  have h0 : |k 0| ≤ R := le_trans (by simpa [Real.norm_eq_abs] using PiLp.norm_apply_le k 0) hk
  have h1 : |k 1| ≤ R := le_trans (by simpa [Real.norm_eq_abs] using PiLp.norm_apply_le k 1) hk
  have h2 : |k 2| ≤ R := le_trans (by simpa [Real.norm_eq_abs] using PiLp.norm_apply_le k 2) hk
  linarith

/-- Pointwise operator bound for the generator action. -/
theorem genMult_apply_norm_le (m : Real) (k : FourierMomentum3) (v : Spinor) :
    ‖genMult m k v‖ ≤ ‖fibreGenerator (k 0) (k 1) (k 2) m‖ * ‖v‖ := by
  rw [genMult, ← Matrix.l2_opNorm_toEuclideanCLM (fibreGenerator (k 0) (k 1) (k 2) m)]
  exact ContinuousLinearMap.le_opNorm _ _

/-- The generator family is continuous in the momentum coordinate. -/
theorem genMult_continuous (m : Real) : Continuous (genMult m) := by
  have hcoord : ∀ i : Fin 3,
      Continuous (fun k : FourierMomentum3 => ((k i : Real) : Complex)) := by
    intro i
    exact Complex.continuous_ofReal.comp
      (PiLp.continuous_apply (p := 2) (β := fun _ : Fin 3 => Real) i)
  have hfib : Continuous
      (fun k : FourierMomentum3 => fibreGenerator (k 0) (k 1) (k 2) m) := by
    unfold fibreGenerator H
    exact ((((((hcoord 0).smul continuous_const).add
      ((hcoord 1).smul continuous_const)).add
      ((hcoord 2).smul continuous_const)).add continuous_const).const_smul (-I))
  have hiso : Isometry (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)) :=
    AddMonoidHomClass.isometry_of_norm _ Matrix.l2_opNorm_toEuclideanCLM
  exact hiso.continuous.comp hfib

/-- The generator family is almost-everywhere strongly measurable. -/
theorem genMult_aestronglyMeasurable (m : Real) :
    AEStronglyMeasurable (genMult m) (volume : Measure FourierMomentum3) :=
  (genMult_continuous m).aestronglyMeasurable

/-! ## The Duhamel difference-quotient bound (key analytic input) -/

/-- Duhamel / mean-value bound: the exact multiplier differs from the identity
by at most `|t| ‖H(k,m)‖ ‖v‖`. This is the non-tautological analytic estimate
that dominates the difference quotients. -/
theorem momMult_sub_id_norm_le (m t : Real) (k : FourierMomentum3) (v : Spinor) :
    ‖momMult m t k v - v‖ ≤ |t| * ‖H (k 0) (k 1) (k 2) m‖ * ‖v‖ := by
  have hmat : ‖exactFlow (k 0) (k 1) (k 2) m t - 1‖
      ≤ |t| * ‖H (k 0) (k 1) (k 2) m‖ := by
    have hL := hermitian_exp_lipschitz (H (k 0) (k 1) (k 2) m) 0
      (H_isHermitian _ _ _ _) (Matrix.isHermitian_zero) t
    simpa [exactFlow, smul_zero, NormedSpace.exp_zero, sub_zero] using hL
  have hstep : Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
        (exactFlow (k 0) (k 1) (k 2) m t - 1) v = momMult m t k v - v := by
    rw [map_sub, map_one, ContinuousLinearMap.sub_apply,
      ContinuousLinearMap.one_apply]
    rfl
  rw [← hstep]
  calc ‖Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
          (exactFlow (k 0) (k 1) (k 2) m t - 1) v‖
      ≤ ‖exactFlow (k 0) (k 1) (k 2) m t - 1‖ * ‖v‖ := by
        rw [← Matrix.l2_opNorm_toEuclideanCLM
          (exactFlow (k 0) (k 1) (k 2) m t - 1)]
        exact ContinuousLinearMap.le_opNorm _ _
    _ ≤ (|t| * ‖H (k 0) (k 1) (k 2) m‖) * ‖v‖ := by gcongr
    _ = |t| * ‖H (k 0) (k 1) (k 2) m‖ * ‖v‖ := by ring

/-- Uniform-in-time slope bound: the difference quotient of the multiplier
action is bounded by `‖H(k,m)‖ ‖v‖`, independently of the time step (and valid
even at the degenerate step `t = 0`, where the slope is zero). -/
theorem slope_norm_le (m t : Real) (k : FourierMomentum3) (v : Spinor) :
    ‖t⁻¹ • (momMult m t k v - v)‖ ≤ ‖H (k 0) (k 1) (k 2) m‖ * ‖v‖ := by
  rcases eq_or_ne t 0 with ht | ht
  · subst ht
    simp only [_root_.inv_zero, zero_smul, norm_zero]
    exact mul_nonneg (norm_nonneg _) (norm_nonneg _)
  · rw [norm_smul, Real.norm_eq_abs, abs_inv]
    have hw := momMult_sub_id_norm_le m t k v
    have hpos : 0 < |t| := abs_pos.mpr ht
    calc |t|⁻¹ * ‖momMult m t k v - v‖
        ≤ |t|⁻¹ * (|t| * ‖H (k 0) (k 1) (k 2) m‖ * ‖v‖) := by
          gcongr
      _ = ‖H (k 0) (k 1) (k 2) m‖ * ‖v‖ := by
          field_simp

/-! ## Item 3: MemLp of the generator representative -/

/-- Under bounded support, the generator action is `L2`. -/
theorem genMult_apply_memLp (m R : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3))
    (hf : BoundedSupport R f) :
    MemLp (fun k => genMult m k (f k)) 2 (volume : Measure FourierMomentum3) := by
  set C : ℝ := 3 * R + |m| with hC
  have hmeas : AEStronglyMeasurable (fun k => genMult m k (f k))
      (volume : Measure FourierMomentum3) :=
    appliedRepresentative_aestronglyMeasurable (volume : Measure FourierMomentum3)
      (genMult m) (genMult_aestronglyMeasurable m) f
  have hbound_mem : MemLp ((C : ℝ) • (⇑f)) 2 (volume : Measure FourierMomentum3) :=
    (Lp.memLp f).const_smul C
  refine MemLp.mono hbound_mem hmeas ?_
  filter_upwards [hf] with k hk
  by_cases hkR : R < ‖k‖
  · rw [hk hkR]
    simp
  · push_neg at hkR
    have hfib : ‖fibreGenerator (k 0) (k 1) (k 2) m‖ ≤ C :=
      fibreGenerator_opNorm_le_on_ball m R k hkR
    have hfk : (0 : ℝ) ≤ ‖f k‖ := norm_nonneg _
    calc ‖genMult m k (f k)‖
        ≤ ‖fibreGenerator (k 0) (k 1) (k 2) m‖ * ‖f k‖ :=
          genMult_apply_norm_le m k (f k)
      _ ≤ C * ‖f k‖ := by gcongr
      _ ≤ |C| * ‖f k‖ := by gcongr; exact le_abs_self C
      _ = ‖((C : ℝ) • (⇑f)) k‖ := by
          rw [Pi.smul_apply, norm_smul, Real.norm_eq_abs]

/-- The packaged `Lp` element representing `k ↦ -i H(k,m)(f k)`. -/
def genRepr (m R : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3))
    (hf : BoundedSupport R f) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  (genMult_apply_memLp m R f hf).toLp

/-- The packaged generator element is represented almost everywhere by the
pointwise generator action. -/
theorem genRepr_coeFn (m R : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3))
    (hf : BoundedSupport R f) :
    genRepr m R f hf =ᵐ[(volume : Measure FourierMomentum3)]
      fun k => genMult m k (f k) :=
  (genMult_apply_memLp m R f hf).coeFn_toLp

/-! ## Item 4: the strong Lp derivative at zero -/

/-- Sequential difference-quotient convergence in the genuine `Lp` norm: for any
time steps `u n → 0` (through nonzero values), the `Lp` difference quotients of
the exact orbit converge to the packaged generator element. -/
theorem orbit_slope_tendsto (m R : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3))
    (hf : BoundedSupport R f)
    (u : ℕ → Real) (hu : Tendsto u atTop (𝓝[≠] (0 : Real))) :
    Tendsto (fun n => (u n)⁻¹ •
        (momMultL2Isometry m (u n) f - f)) atTop (𝓝 (genRepr m R f hf)) := by
  sorry

/-- **Compact-support L2 generator theorem.** For a bounded-support
momentum-space state, the exact orbit `t ↦ momMultL2Isometry m t f` has a strong
`Lp` derivative at `t = 0`, equal to the packaged generator action
`k ↦ -i H(k,m)(f k)`. -/
theorem momMultL2Isometry_hasDerivAt_zero (m R : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3))
    (hf : BoundedSupport R f) :
    HasDerivAt (fun t : Real => (momMultL2Isometry m t f :
        Lp Spinor 2 (volume : Measure FourierMomentum3)))
      (genRepr m R f hf) 0 := by
  rw [hasDerivAt_iff_tendsto_slope_zero]
  apply Filter.tendsto_iff_seq_tendsto.2
  intro u hu
  simpa [Function.comp_def, momMultL2Isometry_zero_time] using
    orbit_slope_tendsto m R f hf u hu

/-! ## Item 5: a nonzero compact-support witness -/

/-- Indicator of a finite-measure momentum ball, times a constant spinor, as an
`L2` element. This is the compact-support witness family. -/
def ballWitness (R : Real) (w : Spinor) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  indicatorConstLp 2 (measurableSet_closedBall)
    (by
      have : (volume (Metric.closedBall (0 : FourierMomentum3) R)) < ⊤ :=
        measure_closedBall_lt_top
      exact this.ne) w

/-- The ball-indicator witness has bounded support of radius `R`. -/
theorem ballWitness_boundedSupport (R : Real) (w : Spinor) :
    BoundedSupport R (ballWitness R w) := by
  unfold BoundedSupport
  have hμ : (volume (Metric.closedBall (0 : FourierMomentum3) R)) ≠ ∞ :=
    measure_closedBall_lt_top.ne
  have hcoe : ∀ᵐ k : FourierMomentum3 ∂(volume : Measure FourierMomentum3),
      ballWitness R w k =
        (Metric.closedBall (0 : FourierMomentum3) R).indicator (fun _ => w) k := by
    unfold ballWitness
    exact indicatorConstLp_coeFn
  filter_upwards [hcoe] with k hk hR
  rw [hk, Set.indicator_of_notMem]
  simpa [Metric.mem_closedBall, dist_zero_right, not_le] using hR

/-- For a positive radius and a nonzero constant spinor, the witness is a
nonzero compact-support state, so the generator theorem is not vacuous. -/
theorem ballWitness_ne_zero (R : Real) (hR : 0 < R) (w : Spinor) (hw : w ≠ 0) :
    ballWitness R w ≠ 0 := by
  intro hzero
  have hnorm : ‖ballWitness R w‖ = 0 := by rw [hzero, norm_zero]
  have hμfinite :
      (volume (Metric.closedBall (0 : FourierMomentum3) R)) ≠ ∞ :=
    measure_closedBall_lt_top.ne
  have hμpos :
      0 < (volume (Metric.closedBall (0 : FourierMomentum3) R)).toReal :=
    ENNReal.toReal_pos
      (Metric.measure_closedBall_pos volume (0 : FourierMomentum3) hR).ne'
      hμfinite
  have hpow : 0 <
      (volume (Metric.closedBall (0 : FourierMomentum3) R)).toReal ^
        (1 / (2 : ENNReal).toReal) :=
    Real.rpow_pos_of_pos hμpos _
  have hnormw : ‖w‖ ≠ 0 := norm_ne_zero_iff.mpr hw
  unfold ballWitness at hnorm
  rw [norm_indicatorConstLp (by norm_num) (by norm_num), measureReal_def] at hnorm
  exact (mul_ne_zero hnormw hpow.ne') hnorm

/-! ## Axiom guards for completed rungs

These guard the nine theorems proved across this successor task
(`fibreGenerator_opNorm_le`, `fibreGenerator_opNorm_le_on_ball`,
`genMult_apply_norm_le`, `genMult_continuous`, `momMult_sub_id_norm_le`,
`slope_norm_le`, `genMult_apply_memLp`, `ballWitness_boundedSupport`, and
`ballWitness_ne_zero`) and confirm they depend only on the standard three
axioms. -/

/-- info: 'PhysicsSM.Draft.NullEdge.CompactSupportL2Generator.fibreGenerator_opNorm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fibreGenerator_opNorm_le

/-- info: 'PhysicsSM.Draft.NullEdge.CompactSupportL2Generator.fibreGenerator_opNorm_le_on_ball' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fibreGenerator_opNorm_le_on_ball

/-- info: 'PhysicsSM.Draft.NullEdge.CompactSupportL2Generator.genMult_apply_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms genMult_apply_norm_le

/-- info: 'PhysicsSM.Draft.NullEdge.CompactSupportL2Generator.genMult_continuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms genMult_continuous

/-- info: 'PhysicsSM.Draft.NullEdge.CompactSupportL2Generator.momMult_sub_id_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms momMult_sub_id_norm_le

/-- info: 'PhysicsSM.Draft.NullEdge.CompactSupportL2Generator.slope_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms slope_norm_le

/-- info: 'PhysicsSM.Draft.NullEdge.CompactSupportL2Generator.genMult_apply_memLp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms genMult_apply_memLp

/-- info: 'PhysicsSM.Draft.NullEdge.CompactSupportL2Generator.ballWitness_boundedSupport' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ballWitness_boundedSupport

/-- info: 'PhysicsSM.Draft.NullEdge.CompactSupportL2Generator.ballWitness_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ballWitness_ne_zero

/- The following guard targets the final theorem, whose proof is complete but
still depends transitively on the remaining `orbit_slope_tendsto` handoff
marker. It will report a placeholder dependency until dominated convergence is
completed, so it remains commented out. -/
-- /-- info: 'PhysicsSM.Draft.NullEdge.CompactSupportL2Generator.momMultL2Isometry_hasDerivAt_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
-- #guard_msgs (whitespace := lax) in
-- #print axioms momMultL2Isometry_hasDerivAt_zero

end PhysicsSM.Draft.NullEdge.CompactSupportL2Generator
