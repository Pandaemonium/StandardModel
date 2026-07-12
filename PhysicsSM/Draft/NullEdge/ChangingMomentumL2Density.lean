import PhysicsSM.Draft.NullEdge.ChangingMomentumCellSampling
import Mathlib.Analysis.Normed.Lp.SmoothApprox

/-!
# D-R3 successor: arbitrary-L2 smooth Lipschitz density bridge

Close the analytic hinge between the landed compact-support Lipschitz sampler
and arbitrary complex `L2(R^3)` momentum data.  Preserve every theorem
statement.  Do not weaken global Lipschitz continuity to a local statement,
and do not drop the noncompact quadratic boundary control.

The first theorem is a project-facing specialization of Mathlib's continuous
compact-support density theorem.  The second theorem is the load-bearing
finite-dimensional fact: a compactly supported smooth function is globally
Lipschitz.  The final two declarations show that compact support is not a
decorative hypothesis.

Proof provenance: Aristotle project
`f39b6a29-5fbc-4cc2-9a6f-606591339941`, using the Mathlib API map recorded in
`SPARK_LEAN_L2_DENSITY_2026-07-11.md`.  The extracted result was independently
checked before integration on 2026-07-11.  No external code was copied.
-/

noncomputable section

open scoped ENNReal
open MeasureTheory Set

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density

open ChangingMomentumCellIsometry

/-- Every complex `L2(R^3)` field admits a continuous compactly supported
approximation with arbitrarily small squared error. -/
theorem memLp_exists_continuous_compact_sq_approx
    {f : Momentum3 -> Complex} (hf : MemLp f 2 volume)
    {ε : Real} (hε : 0 < ε) :
    ∃ g : Momentum3 -> Complex,
      HasCompactSupport g ∧
      (∫ x, ‖f x - g x‖ ^ (2 : Real) ∂volume) ≤ ε ∧
      Continuous g ∧ MemLp g 2 volume := by
  have hf' : MemLp f (ENNReal.ofReal 2) volume := by
    rwa [show ENNReal.ofReal 2 = 2 by norm_num]
  obtain ⟨g, hsupp, hint, hcont, hmem⟩ :=
    hf'.exists_hasCompactSupport_integral_rpow_sub_le (by norm_num : (0 : ℝ) < 2) hε
  refine ⟨g, hsupp, hint, hcont, ?_⟩
  rwa [show ENNReal.ofReal 2 = 2 by norm_num] at hmem

/-- In finite-dimensional momentum space, smoothness plus compact support
supplies the global Lipschitz constant required by the cell sampler. -/
theorem compactSupport_contDiff_exists_global_lipschitz
    {g : Momentum3 -> Complex} (hgK : HasCompactSupport g)
    (hgD : ContDiff Real ⊤ g) :
    ∃ L : Real, 0 ≤ L ∧
      ∀ x y, ‖g x - g y‖ ≤ L * ‖x - y‖ := by
  obtain ⟨C, hC⟩ := ContDiff.lipschitzWith_of_hasCompactSupport hgK hgD (by simp)
  refine ⟨C, C.2, fun x y => ?_⟩
  have := hC.dist_le_mul x y
  rwa [dist_eq_norm, dist_eq_norm] at this

/-- Standard smoothness (`C^infinity`) plus compact support gives the same
global Lipschitz conclusion.  This is the differentiability order returned by
Mathlib's `Lp` smooth-approximation theorem. -/
theorem compactSupport_contDiff_infty_exists_global_lipschitz
    {g : Momentum3 -> Complex} (hgK : HasCompactSupport g)
    (hgD : ContDiff Real (↑(⊤ : ENat)) g) :
    ∃ L : Real, 0 ≤ L ∧
      ∀ x y, ‖g x - g y‖ ≤ L * ‖x - y‖ := by
  obtain ⟨C, hC⟩ := ContDiff.lipschitzWith_of_hasCompactSupport hgK hgD (by simp)
  refine ⟨C, C.2, fun x y => ?_⟩
  have := hC.dist_le_mul x y
  rwa [dist_eq_norm, dist_eq_norm] at this

/-- Every complex `L2(R^3)` field admits a compactly supported smooth
approximation in `eLpNorm`. -/
theorem memLp_exists_contDiff_compact_eLpNorm_approx
    {f : Momentum3 -> Complex} (hf : MemLp f 2 volume)
    {ε : Real} (hε : 0 < ε) :
    ∃ g : Momentum3 -> Complex,
      HasCompactSupport g ∧ ContDiff Real (↑(⊤ : ENat)) g ∧
      eLpNorm (f - g) 2 volume ≤ ENNReal.ofReal ε := by
  exact hf.exist_eLpNorm_sub_le (by norm_num) (by norm_num) hε

/-- The approximant can be chosen with exactly the compact support,
smoothness, and global Lipschitz control consumed by the landed cell sampler. -/
theorem memLp_exists_compact_global_lipschitz_eLpNorm_approx
    {f : Momentum3 -> Complex} (hf : MemLp f 2 volume)
    {ε : Real} (hε : 0 < ε) :
    ∃ g : Momentum3 -> Complex, ∃ L : Real,
      HasCompactSupport g ∧ ContDiff Real (↑(⊤ : ENat)) g ∧ 0 ≤ L ∧
      (∀ x y, ‖g x - g y‖ ≤ L * ‖x - y‖) ∧
      eLpNorm (f - g) 2 volume ≤ ENNReal.ofReal ε := by
  obtain ⟨g, hgK, hgD, hgApprox⟩ :=
    memLp_exists_contDiff_compact_eLpNorm_approx hf hε
  obtain ⟨L, hL, hgLip⟩ :=
    compactSupport_contDiff_infty_exists_global_lipschitz hgK hgD
  exact ⟨g, L, hgK, hgD, hL, hgLip, hgApprox⟩

/-- Boundary-control function: a smooth quadratic without compact support. -/
def quadraticAxis (x : Momentum3) : Complex :=
  (x 0 : Complex) ^ 2

theorem quadraticAxis_contDiff : ContDiff Real ⊤ quadraticAxis := by
  unfold quadraticAxis
  apply ContDiff.pow
  apply Complex.ofRealCLM.contDiff.comp
  exact contDiff_apply ℝ ℝ 0

/-- Compact support is load-bearing: the smooth quadratic has no global
Lipschitz constant. -/
theorem quadraticAxis_not_global_lipschitz :
    ¬ ∃ L : Real, 0 ≤ L ∧
      ∀ x y, ‖quadraticAxis x - quadraticAxis y‖ ≤ L * ‖x - y‖ := by
  rintro ⟨L, hL, hbound⟩
  set t : ℝ := L + 1 with ht
  have htpos : 0 < t := by positivity
  set x : Momentum3 := fun i => if i = 0 then t else 0 with hx
  have hx0 : x 0 = t := by simp [hx]
  have hxnorm : ‖x‖ = t := by
    apply le_antisymm
    · rw [pi_norm_le_iff_of_nonneg htpos.le]
      intro i
      by_cases hi : i = 0
      · simp [hx, hi, Real.norm_eq_abs, abs_of_nonneg htpos.le]
      · simp [hx, hi, htpos.le]
    · calc t = ‖x 0‖ := by rw [hx0, Real.norm_eq_abs, abs_of_nonneg htpos.le]
        _ ≤ ‖x‖ := norm_le_pi_norm x 0
  have key := hbound x 0
  have hq0 : quadraticAxis (0 : Momentum3) = 0 := by simp [quadraticAxis]
  rw [hq0, sub_zero, sub_zero, hxnorm] at key
  have hqx : ‖quadraticAxis x‖ = t ^ 2 := by
    simp only [quadraticAxis, hx0]
    rw [norm_pow, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg htpos.le]
  rw [hqx] at key
  nlinarith [key, htpos]

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density.memLp_exists_continuous_compact_sq_approx' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms memLp_exists_continuous_compact_sq_approx

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density.compactSupport_contDiff_exists_global_lipschitz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms compactSupport_contDiff_exists_global_lipschitz

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density.memLp_exists_compact_global_lipschitz_eLpNorm_approx' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms memLp_exists_compact_global_lipschitz_eLpNorm_approx

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density.quadraticAxis_not_global_lipschitz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quadraticAxis_not_global_lipschitz

end PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density
