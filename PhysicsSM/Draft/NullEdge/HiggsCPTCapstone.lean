import Mathlib
import PhysicsSM.Draft.NullEdge.HiggsLongitudinalMode
import PhysicsSM.Draft.NullEdge.DiracVelocityOperator
import PhysicsSM.Draft.NullEdge.ZigzagWeyl
import PhysicsSM.Draft.NullEdge.ZitterbewegungAverage
import PhysicsSM.Draft.NullEdge.CPTAntiparticleZigzag

open scoped BigOperators

set_option maxHeartbeats 8000000
set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# "Mass from massless channels": a finite capstone (two honest avatars)

This file composes the finite, kernel-checked results of the null-edge suite into a single
capstone package supporting the manuscript phrase **"mass from massless channels"** in two
*separate, non-confused* finite avatars:

* **Massive vectors** as a retained **longitudinal** mode
  (`HiggsLongitudinalMode`): a massless vector has `2` transverse polarizations, a massive
  vector has `3` — the extra longitudinal ("eaten Goldstone") mode *is* the mass.  A finite
  degree-of-freedom count over `ℚ` with the Minkowski metric.

* **Fermions** as **luminal zigzag averages**
  (`DiracVelocityOperator`, `ZigzagWeyl`, `ZitterbewegungAverage`, `CPTAntiparticleZigzag`):
  the Dirac velocity operator has spectrum exactly `±c`; a massive Dirac fermion is two null
  Weyl components coupled by mass; the subluminal drift is the mass-weighted convex average of
  the two `±c` luminal channels; and the antiparticle is the CPT-mirror zigzag.

The three headline theorems below simply *re-assert and compose* the already-proved finite
verdicts of the imported modules; each conjunct is one of those verdicts (or an explicit fact
drawn from them), so the whole package is a single finite, kernel-checked statement.

Honest scope: this is a **finite counting and finite one-carrier CPT/zigzag package**.  It does
**not** claim the dynamical Higgs mechanism, baryogenesis, or full QFT.
-/

namespace HiggsCPTCapstone

/-- **Capstone package.**  The vector-boson longitudinal-counting verdict, the Dirac
velocity-spectrum and massless-luminal verdicts, the Weyl zigzag verdict (`m = 3`), the
Zitterbewegung convex-averaging verdict on the `3-4-5` shell with its explicit instance, and
the CPT antiparticle verdict — all as a single conjunction, each a finite kernel-checked fact.

This is the two-avatar statement of "mass from massless channels": massive vectors keep a
longitudinal mode, fermions are luminal zigzag averages. -/
theorem mass_from_massless_channel_capstone :
    -- vector avatar: longitudinal counting verdict
    (HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null = 2 ∧
      HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time = 3 ∧
      HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time =
        HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null + 1 ∧
      HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_null HiggsLongitudinalMode.k_null = 0 ∧
      HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_time HiggsLongitudinalMode.k_time = 16) ∧
    -- fermion avatar: Dirac velocity spectrum is exactly ±c
    (DiracVelocityOperator.alpha1 * DiracVelocityOperator.alpha1 = 1 ∧
      DiracVelocityOperator.alpha1.trace = 0 ∧
      DiracVelocityOperator.alpha1 ≠ 1 ∧ DiracVelocityOperator.alpha1 ≠ -1 ∧
      (DiracVelocityOperator.alpha1.mulVec DiracVelocityOperator.vplus =
          DiracVelocityOperator.vplus ∧ DiracVelocityOperator.vplus ≠ 0) ∧
      (DiracVelocityOperator.alpha1.mulVec DiracVelocityOperator.vminus =
          -DiracVelocityOperator.vminus ∧ DiracVelocityOperator.vminus ≠ 0)) ∧
    -- the mass term is the chirality-flipping coupling (massless is luminal-diagonal)
    (DiracVelocityOperator.alpha1 * DiracVelocityOperator.beta =
          -(DiracVelocityOperator.beta * DiracVelocityOperator.alpha1) ∧
      DiracVelocityOperator.alpha2 * DiracVelocityOperator.beta =
          -(DiracVelocityOperator.beta * DiracVelocityOperator.alpha2) ∧
      DiracVelocityOperator.alpha3 * DiracVelocityOperator.beta =
          -(DiracVelocityOperator.beta * DiracVelocityOperator.alpha3) ∧
      (∀ (v : Fin 4 → ℂ) (a b : ℂ),
        DiracVelocityOperator.alpha1.mulVec v = a • v →
          DiracVelocityOperator.beta.mulVec v = b • v → a * b = 0 ∨ v = 0)) ∧
    -- Penrose zigzag verdict at m = 3
    ((ZigzagWeyl.gamma5 * ZigzagWeyl.gamma5 = (1 : ZigzagWeyl.M4) ∧
        Matrix.trace ZigzagWeyl.gamma5 = 0 ∧
        ZigzagWeyl.gamma5 * ZigzagWeyl.Dmass 3 * ZigzagWeyl.gamma5 = - ZigzagWeyl.Dmass 3) ∧
      (ZigzagWeyl.D 0 = ZigzagWeyl.Dkin ∧
        ZigzagWeyl.gamma5 * ZigzagWeyl.Dnull = - (ZigzagWeyl.Dnull * ZigzagWeyl.gamma5) ∧
        ZigzagWeyl.KLnull * ZigzagWeyl.KRnull = 0 ∧ ZigzagWeyl.KRnull * ZigzagWeyl.KLnull = 0) ∧
      (ZigzagWeyl.KLnull ≠ 0 ∧ ZigzagWeyl.KRnull ≠ 0 ∧ ZigzagWeyl.KLnull ≠ ZigzagWeyl.KRnull) ∧
      ((3 : ℝ) ≠ 0 → ZigzagWeyl.Dmass 3 ≠ 0) ∧
      (ZigzagWeyl.D 3 * ZigzagWeyl.D 3 = (16 + (3 : ℝ) ^ 2) • (1 : ZigzagWeyl.M4)) ∧
      (ZigzagWeyl.D 3 * ZigzagWeyl.D 3 = (25 : ℝ) • (1 : ZigzagWeyl.M4))) ∧
    -- Zitterbewegung convex-averaging verdict on the 3-4-5 shell
    (ZitterbewegungAverage.wPlus 4 5 + ZitterbewegungAverage.wMinus 4 5 = 1 ∧
      (0 ≤ ZitterbewegungAverage.wPlus 4 5 ∧ ZitterbewegungAverage.wPlus 4 5 ≤ 1) ∧
      (0 ≤ ZitterbewegungAverage.wMinus 4 5 ∧ ZitterbewegungAverage.wMinus 4 5 ≤ 1) ∧
      ZitterbewegungAverage.meanVelocity 4 5 = 4 / 5 ∧
      ZitterbewegungAverage.meanVelocity 4 5 ^ 2 = 1 - (3 : ℚ) ^ 2 / 5 ^ 2) ∧
    -- the explicit (m,p,E)=(3,4,5) instance
    (ZitterbewegungAverage.wPlus 4 5 = 9 / 10 ∧ ZitterbewegungAverage.wMinus 4 5 = 1 / 10 ∧
      ZitterbewegungAverage.meanVelocity 4 5 = 4 / 5 ∧
      ZitterbewegungAverage.meanVelocity 4 5 ^ 2 = 16 / 25 ∧ (16 : ℚ) / 25 = 1 - 9 / 25 ∧
      (4 : ℚ) ^ 2 + 3 ^ 2 = 5 ^ 2) ∧
    -- CPT antiparticle verdict
    ((∀ v : Fin 4 → ℂ, CPTAntiparticleZigzag.Theta (CPTAntiparticleZigzag.Theta v) = v) ∧
      (∀ v : Fin 4 → ℂ, CPTAntiparticleZigzag.gamma5.mulVec (CPTAntiparticleZigzag.Theta v) =
          - CPTAntiparticleZigzag.Theta (CPTAntiparticleZigzag.gamma5.mulVec v)) ∧
      (∀ (m : ℝ) (v : Fin 4 → ℂ),
          CPTAntiparticleZigzag.Theta
              ((CPTAntiparticleZigzag.Dmat (m : ℂ)).mulVec (CPTAntiparticleZigzag.Theta v)) =
            (CPTAntiparticleZigzag.Dmat (m : ℂ)).mulVec v) ∧
      (∀ (m : ℝ) (lam : ℂ) (v : Fin 4 → ℂ), v ≠ 0 →
          (CPTAntiparticleZigzag.Dmat (m : ℂ)).mulVec v = lam • v →
          (CPTAntiparticleZigzag.Dmat (m : ℂ)).mulVec (CPTAntiparticleZigzag.Theta v) =
              (starRingEnd ℂ lam) • CPTAntiparticleZigzag.Theta v ∧
            CPTAntiparticleZigzag.Theta v ≠ 0) ∧
      ((CPTAntiparticleZigzag.Dmat 1).mulVec ![1, Complex.I, 1, Complex.I] =
          (1 + Complex.I) • ![1, Complex.I, 1, Complex.I] ∧
        CPTAntiparticleZigzag.Theta ![1, Complex.I, 1, Complex.I] =
          ![1, -Complex.I, 1, -Complex.I] ∧
        (![1, Complex.I, 1, Complex.I] : Fin 4 → ℂ) ≠ 0 ∧
        CPTAntiparticleZigzag.Theta ![1, Complex.I, 1, Complex.I] ≠ 0)) := by
  exact ⟨HiggsLongitudinalMode.higgs_counting_verdict,
    DiracVelocityOperator.velocity_spectrum,
    DiracVelocityOperator.massless_luminal,
    ZigzagWeyl.zigzag_verdict 3,
    ZitterbewegungAverage.zitterbewegung_verdict 4 5 3 (by norm_num) (by norm_num) (by norm_num),
    ZitterbewegungAverage.instance_345,
    CPTAntiparticleZigzag.antiparticle_verdict⟩

/-- **Vector-longitudinal + fermion-luminal explicit witnesses.**  The finite numerical cores
of the two avatars side by side: the massless/massive polarization counts `2` and `3` (with
`3 = 2 + 1`, the extra longitudinal mode), the fermion drift `vbar = 4/5` on the `3-4-5` shell,
the `α₁² = 1` luminal-speed relation, and the concrete CPT conjugate mirror pair. -/
theorem vector_longitudinal_plus_fermion_luminal_witnesses :
    HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null = 2
      ∧ HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time = 3
      ∧ HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time
          = HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null + 1
      ∧ ZitterbewegungAverage.meanVelocity 4 5 = 4 / 5
      ∧ DiracVelocityOperator.alpha1 * DiracVelocityOperator.alpha1 = 1
      ∧ ((CPTAntiparticleZigzag.Dmat 1).mulVec ![1, Complex.I, 1, Complex.I] =
            (1 + Complex.I) • ![1, Complex.I, 1, Complex.I] ∧
          (![1, Complex.I, 1, Complex.I] : Fin 4 → ℂ) ≠ 0 ∧
          CPTAntiparticleZigzag.Theta ![1, Complex.I, 1, Complex.I] =
            ![1, -Complex.I, 1, -Complex.I] ∧
          (CPTAntiparticleZigzag.Dmat 1).mulVec
              (CPTAntiparticleZigzag.Theta ![1, Complex.I, 1, Complex.I]) =
            (starRingEnd ℂ (1 + Complex.I)) •
              CPTAntiparticleZigzag.Theta ![1, Complex.I, 1, Complex.I] ∧
          CPTAntiparticleZigzag.Theta ![1, Complex.I, 1, Complex.I] ≠ 0) := by
  obtain ⟨h1, h2, h3, _, _⟩ := HiggsLongitudinalMode.higgs_counting_verdict
  exact ⟨h1, h2, h3, ZitterbewegungAverage.instance_345.2.2.1,
    DiracVelocityOperator.alpha1_sq, CPTAntiparticleZigzag.concrete_conjugate_pair⟩

/-- **The two avatars are honest and not confused.**  The vector avatar is a genuine
DOF-counting statement (`3` massive vs `2` massless polarizations); the fermion avatar is a
genuine finite CPT statement (CPT swaps the two null Weyl pieces and is an antiunitary
involution).  Keeping both explicit witnesses in one package makes clear these are two
*separate* finite avatars of "mass from massless", not a single overclaimed mechanism. -/
theorem two_honest_scopes_not_confused :
    -- massive vector: 3 polarizations (with the extra longitudinal mode)
    (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_time HiggsLongitudinalMode.k_time = 16 ∧
      Module.finrank ℚ (LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_time))
          = 3 ∧
      HiggsLongitudinalMode.epsT1 ∈
        LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_time) ∧
      HiggsLongitudinalMode.epsT2 ∈
        LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_time) ∧
      HiggsLongitudinalMode.epsL ∈
        LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_time) ∧
      LinearIndependent ℚ
        ![HiggsLongitudinalMode.epsT1, HiggsLongitudinalMode.epsT2, HiggsLongitudinalMode.epsL]) ∧
    -- massless vector: 2 polarizations (gauge direction quotiented out)
    (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_null HiggsLongitudinalMode.k_null = 0 ∧
      HiggsLongitudinalMode.k_null ≠ 0 ∧
      Module.finrank ℚ (↥(LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_null)) ⧸
        Submodule.span ℚ {(⟨HiggsLongitudinalMode.k_null, HiggsLongitudinalMode.null_mem_ker⟩ :
          ↥(LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_null)))}) = 2 ∧
      HiggsLongitudinalMode.epsT1 ∈
        LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_null) ∧
      HiggsLongitudinalMode.epsT2 ∈
        LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_null) ∧
      LinearIndependent ℚ ![HiggsLongitudinalMode.epsT1, HiggsLongitudinalMode.epsT2]) ∧
    -- CPT swaps the two null Weyl pieces (chirality-odd), with explicit witness
    ((∀ v : Fin 4 → ℂ, CPTAntiparticleZigzag.gamma5.mulVec (CPTAntiparticleZigzag.Theta v) =
          - CPTAntiparticleZigzag.Theta (CPTAntiparticleZigzag.gamma5.mulVec v)) ∧
      (CPTAntiparticleZigzag.Theta ![(1 : ℂ), 0, 0, 0] ≠ 0) ∧
      CPTAntiparticleZigzag.gamma5.mulVec ![(1 : ℂ), 0, 0, 0] = ![(1 : ℂ), 0, 0, 0] ∧
      CPTAntiparticleZigzag.Theta ![(1 : ℂ), 0, 0, 0] = ![(0 : ℂ), 0, 1, 0] ∧
      CPTAntiparticleZigzag.gamma5.mulVec (CPTAntiparticleZigzag.Theta ![(1 : ℂ), 0, 0, 0]) =
        - CPTAntiparticleZigzag.Theta ![(1 : ℂ), 0, 0, 0]) ∧
    -- CPT is an antiunitary involution
    ((∀ v w : Fin 4 → ℂ,
        CPTAntiparticleZigzag.Theta (v + w) =
          CPTAntiparticleZigzag.Theta v + CPTAntiparticleZigzag.Theta w) ∧
      (∀ (c : ℂ) (v : Fin 4 → ℂ),
        CPTAntiparticleZigzag.Theta (c • v) =
          (starRingEnd ℂ c) • CPTAntiparticleZigzag.Theta v) ∧
      (∀ v : Fin 4 → ℂ, CPTAntiparticleZigzag.Theta (CPTAntiparticleZigzag.Theta v) = v)) := by
  exact ⟨HiggsLongitudinalMode.massive_three_polarizations,
    HiggsLongitudinalMode.massless_two_polarizations,
    CPTAntiparticleZigzag.theta_swaps_weyl,
    CPTAntiparticleZigzag.theta_antiunitary⟩

/-! ## Axiom footprint: exactly `[propext, Classical.choice, Quot.sound]` -/

/-- info: 'HiggsCPTCapstone.mass_from_massless_channel_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_from_massless_channel_capstone

/-- info: 'HiggsCPTCapstone.vector_longitudinal_plus_fermion_luminal_witnesses' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms vector_longitudinal_plus_fermion_luminal_witnesses

/-- info: 'HiggsCPTCapstone.two_honest_scopes_not_confused' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms two_honest_scopes_not_confused

end HiggsCPTCapstone
