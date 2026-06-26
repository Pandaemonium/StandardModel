import PhysicsSM.NullStrand.NullFiber.Barycentric
import PhysicsSM.NullStrand.ZigZag.LatticeBeable
import PhysicsSM.NullStrand.Ergodic.IIDStrongLaw

/-!
# NullStrand.Master.FiniteModel

Finite-model capstone for the first complete NullStrand endpoint target
(MASTER-001).

This file now exposes two layers:

* `FiniteNullStrandModel` / `finiteNullStrand_master` — the original *abstract*
  endpoint package (kept for backward compatibility). Its three `Prop` fields are
  data naming the endpoint claims, with companion `_holds` witnesses; the master
  theorem simply projects those witnesses. This is honest but content-free: the
  model can be instantiated with any propositions. It is **candidate-level only**
  and should not be read as a mathematical theorem about null strands.

* `FiniteIIDNullStrandModel` / `finiteIIDNullStrand_master` — the *concrete*
  finite i.i.d. capstone. Every field is genuine data or a genuine hypothesis
  drawn from the banked finite ingredients, and every conjunct of the master
  conclusion is a real mathematical statement (nullity equations, a barycenter
  identity, a marginal identity, and an almost-sure limit), not a restated
  physical conclusion. The capstone connects:

  - the octahedral / barycentric **null fiber resolution**
    (`PhysicsSM.NullStrand.NullFiber.Barycentric.FiniteNullResolution`) — every
    microscopic step direction is Minkowski-null and the weighted resolution has
    barycenter `U`;
  - the lattice **Born transport** step
    (`PhysicsSM.NullStrand.ZigZag.coinBornTransport`) — the position marginal is
    preserved (Born rule bookkeeping);
  - the i.i.d. **strong law**
    (`PhysicsSM.NullStrand.Ergodic.iidNullSteps_empiricalMean_tendsto`) — the
    empirical mean velocity converges almost surely to the timelike base current
    `U`.

  The same vector `U` serves as the barycenter of the null resolution and as the
  almost-sure limit of the empirical mean, **and the i.i.d. increment process
  whose mean converges to `U` is itself constrained to take Minkowski-null
  values** (field `step_null`). This is the precise physical content: a single
  realized history is microscopically null (`step_null`) yet macroscopically
  timelike (it converges to `U`, the barycenter of the null cone resolution).

  `octaWitnessModel` / `finiteIIDNullStrandModel_nonempty` exhibit a concrete
  inhabitant (octahedral resolution, identity coin, and a genuine i.i.d.
  product-measure process whose increments are uniform over the six octahedral
  *null* directions and whose mean is the rest current `(1,0,0,0)`), so the
  capstone is provably non-vacuous *with the nullity constraint active*. The
  witness uses Mathlib's infinite product measure `Measure.infinitePi`, so the
  i.i.d. hypotheses are discharged from genuine independence/identical-law lemmas
  rather than from a degenerate constant process.
-/

noncomputable section

namespace PhysicsSM.NullStrand.Master

open MeasureTheory Filter ProbabilityTheory
open scoped Topology BigOperators

/-! ## Abstract endpoint package (legacy) -/

/-- Abstract finite model interface used as a clean endpoint statement package.

The three `Prop` fields name the endpoint claims; the corresponding `_holds`
fields carry their proofs, so a value of this structure is a finite model in which
all three endpoint properties actually hold. Without the witness fields the
conjunction is not derivable (a bare `Prop` field is data naming a proposition,
not evidence that it is true), so the earlier witness-free version was both
vacuous and ill-typed.

**Caveat (audit, 2026-06-25).** This package is content-free: the three `Prop`
fields can be instantiated by *any* propositions, so `finiteNullStrand_master`
proves nothing specific about null strands. Use `finiteIIDNullStrand_master`
below for the genuine finite claim. -/
structure FiniteNullStrandModel where
  Configuration : Type*
  [instFintype : Fintype Configuration]
  eachContinuousStepIsNull : Prop
  positionMarginalIsBorn : Prop
  empiricalVelocityConvergesToBaseCurrent : Prop
  eachContinuousStepIsNull_holds : eachContinuousStepIsNull
  positionMarginalIsBorn_holds : positionMarginalIsBorn
  empiricalVelocityConvergesToBaseCurrent_holds : empiricalVelocityConvergesToBaseCurrent

attribute [instance] FiniteNullStrandModel.instFintype

/-- Master finite model statement: project the bundled endpoint witnesses.

See the structure caveat: this is a content-free projection, kept for backward
compatibility only. -/
theorem finiteNullStrand_master
    (M : FiniteNullStrandModel) :
    M.eachContinuousStepIsNull ∧
      M.positionMarginalIsBorn ∧
      M.empiricalVelocityConvergesToBaseCurrent :=
  ⟨M.eachContinuousStepIsNull_holds,
    M.positionMarginalIsBorn_holds,
    M.empiricalVelocityConvergesToBaseCurrent_holds⟩

/-! ## Concrete finite i.i.d. capstone (MASTER-001) -/

open PhysicsSM.NullStrand.ZigZag PhysicsSM.NullStrand.Ergodic
open PhysicsSM.NullStrand.NullFiber.Barycentric
  (FiniteNullResolution octahedralResolution octaDir minkowskiInner)

/-- Concrete finite i.i.d. null-strand model.

Every field is actual data or a genuine probabilistic hypothesis; no field
restates a physical conclusion. The macroscopic base current `U` is shared
between the microscopic null resolution (its barycenter) and the i.i.d. step
process (its common mean), and the i.i.d. increments are required to be
Minkowski-null (`step_null`). -/
structure FiniteIIDNullStrandModel where
  /-- Index type of the finite null resolution. -/
  Ωdir : Type
  [instFintypeΩdir : Fintype Ωdir]
  /-- The macroscopic timelike base current (future rest direction). -/
  U : Fin 4 → ℝ
  /-- A finite probability law on future-null directions with barycenter `U`. -/
  resolution : FiniteNullResolution Ωdir U
  /-- Lattice site type for the Born transport step. -/
  L : Type
  [instFintypeL : Fintype L]
  /-- The one-step lattice beable (coin kernel + null shift). -/
  beable : LatticeBeable L
  /-- A density over lattice sites and chirality. -/
  density : LatticeDensity L
  /-- Sample space of a single realized history. -/
  Ω : Type
  [instMeas : MeasurableSpace Ω]
  /-- History law. -/
  μ : Measure Ω
  [instProb : IsProbabilityMeasure μ]
  /-- The i.i.d. null step process `step n ω : Fin 4 → ℝ`. -/
  step : ℕ → Ω → (Fin 4 → ℝ)
  step_integrable : Integrable (step 0) μ
  step_indep : Pairwise (fun i j => IndepFun (step i) (step j) μ)
  step_ident : ∀ i, IdentDistrib (step i) (step 0) μ μ
  /-- Each i.i.d. increment is Minkowski-null: the realized history is
  microscopically null. -/
  step_null : ∀ i ω, minkowskiInner (step i ω) (step i ω) = 0
  /-- The common mean of the step process equals the base current `U`. -/
  step_mean : (∫ ω, step 0 ω ∂μ) = U

attribute [instance] FiniteIIDNullStrandModel.instFintypeΩdir
  FiniteIIDNullStrandModel.instFintypeL FiniteIIDNullStrandModel.instMeas
  FiniteIIDNullStrandModel.instProb

/-- **MASTER-001.** The concrete finite i.i.d. null-strand capstone.

For any `FiniteIIDNullStrandModel`:

1. **Microscopic nullity (resolution).** Every step direction of the null
   resolution is Minkowski-null.
2. **Barycenter.** The weighted barycenter of the null resolution equals the
   base current `U`.
3. **Born position marginal.** The lattice coin step preserves the chirality
   marginal at every site.
4. **Microscopic nullity (process).** Every increment of the i.i.d. step process
   is Minkowski-null.
5. **Macroscopic timelike convergence.** The empirical mean velocity of the
   i.i.d. step process converges almost surely to the base current `U`.

Conjuncts (4) and (5) are about the *same* process `step`, so together they say a
single realized history is microscopically null yet macroscopically converges to
`U`, which (2) identifies with the barycenter of the null cone resolution. Each
conjunct is a genuine mathematical statement assembled from the banked finite
ingredients; none is a restated physical conclusion. -/
theorem finiteIIDNullStrand_master (M : FiniteIIDNullStrandModel) :
    (∀ w, minkowskiInner (M.resolution.dir w) (M.resolution.dir w) = 0) ∧
    (∑ w, M.resolution.weight w • M.resolution.dir w = M.U) ∧
    (∀ x, ∑ c : Chiral, coinBornTransport M.beable M.density x c
        = ∑ c : Chiral, M.density x c) ∧
    (∀ n ω, minkowskiInner (M.step n ω) (M.step n ω) = 0) ∧
    (∀ᵐ ω ∂M.μ, Tendsto (fun n : ℕ => (n : ℝ)⁻¹ • ∑ i ∈ Finset.range n, M.step i ω)
        atTop (𝓝 M.U)) := by
  refine ⟨M.resolution.null, M.resolution.barycenter,
    fun x => coinBornTransport_sourceMarginal M.beable M.density x, M.step_null, ?_⟩
  exact iidNullSteps_empiricalMean_tendsto M.μ M.step
    M.step_integrable M.step_indep M.step_ident M.U M.step_mean

/-! ### Concrete non-vacuity witness with genuine i.i.d. null increments

The witness uses the infinite product measure on histories `ℕ → Fin 6`, with each
coordinate uniform over the six octahedral null directions. This makes the i.i.d.
hypotheses real (independence and identical law come from product-measure lemmas),
and crucially the increments are genuinely Minkowski-null while their mean is the
timelike rest current `(1,0,0,0)`. -/

/-- Uniform law on the six octahedral null directions (carried as `Fin 6`). -/
def octaStepLaw : Measure (Fin 6) := (PMF.uniformOfFintype (Fin 6)).toMeasure

instance : IsProbabilityMeasure octaStepLaw := by unfold octaStepLaw; infer_instance

/-- Infinite-product history law: i.i.d. uniform octahedral steps. -/
def octaHistory : Measure (ℕ → Fin 6) := Measure.infinitePi (fun _ : ℕ => octaStepLaw)

instance : IsProbabilityMeasure octaHistory := by unfold octaHistory; infer_instance

/-- The octahedral increment process `octaDir (ω i)` is integrable. -/
theorem octaStep_integrable :
    Integrable (fun ω : ℕ → Fin 6 => octaDir (ω 0)) octaHistory := by
  refine Integrable.of_bound
    (by measurability : Measurable fun ω : ℕ → Fin 6 => octaDir (ω 0)).aestronglyMeasurable
    (Finset.univ.sup' (by simp) (fun k => ‖octaDir k‖)) ?_
  filter_upwards with ω
  exact Finset.le_sup' (fun k => ‖octaDir k‖) (Finset.mem_univ (ω 0))

/-- The octahedral increments are pairwise independent under the product law. -/
theorem octaStep_indep :
    Pairwise (fun i j => IndepFun (fun ω : ℕ → Fin 6 => octaDir (ω i))
      (fun ω : ℕ → Fin 6 => octaDir (ω j)) octaHistory) := by
  intro i j hij
  have h := iIndepFun_infinitePi (P := fun _ : ℕ => octaStepLaw)
    (X := fun _ : ℕ => octaDir) (fun _ => by measurability)
  exact h.indepFun hij

/-- The octahedral increments are identically distributed. -/
theorem octaStep_ident (i : ℕ) :
    IdentDistrib (fun ω : ℕ → Fin 6 => octaDir (ω i))
      (fun ω : ℕ → Fin 6 => octaDir (ω 0)) octaHistory octaHistory := by
  refine ⟨(by measurability : Measurable fun ω : ℕ → Fin 6 => octaDir (ω i)).aemeasurable,
    (by measurability : Measurable fun ω : ℕ → Fin 6 => octaDir (ω 0)).aemeasurable, ?_⟩
  have hi : Measure.map (fun ω : ℕ → Fin 6 => octaDir (ω i)) octaHistory
      = Measure.map octaDir octaStepLaw := by
    rw [show (fun ω : ℕ → Fin 6 => octaDir (ω i)) = octaDir ∘ (fun ω => ω i) from rfl,
      ← Measure.map_map (by measurability) (by measurability)]
    unfold octaHistory; rw [Measure.infinitePi_map_eval (fun _ : ℕ => octaStepLaw) i]
  have h0 : Measure.map (fun ω : ℕ → Fin 6 => octaDir (ω 0)) octaHistory
      = Measure.map octaDir octaStepLaw := by
    rw [show (fun ω : ℕ → Fin 6 => octaDir (ω 0)) = octaDir ∘ (fun ω => ω 0) from rfl,
      ← Measure.map_map (by measurability) (by measurability)]
    unfold octaHistory; rw [Measure.infinitePi_map_eval (fun _ : ℕ => octaStepLaw) 0]
  rw [hi, h0]

/-- The mean octahedral increment is the rest current `(1,0,0,0)`. -/
theorem octaStep_mean :
    (∫ ω, octaDir (ω 0) ∂octaHistory) = (![1, 0, 0, 0] : Fin 4 → ℝ) := by
  have hsum : (∫ ω, octaDir (ω 0) ∂octaHistory) = ∑ k : Fin 6, (6:ℝ)⁻¹ • octaDir k := by
    have hφ : Measurable (fun ω : ℕ → Fin 6 => ω 0) := by measurability
    have hmap : Measure.map (fun ω : ℕ → Fin 6 => ω 0) octaHistory = octaStepLaw := by
      unfold octaHistory; simpa using Measure.infinitePi_map_eval (fun _ : ℕ => octaStepLaw) 0
    calc ∫ ω, octaDir (ω 0) ∂octaHistory
        = ∫ y, octaDir y ∂(Measure.map (fun ω : ℕ → Fin 6 => ω 0) octaHistory) :=
          (integral_map hφ.aemeasurable (by measurability)).symm
      _ = ∫ y, octaDir y ∂octaStepLaw := by rw [hmap]
      _ = ∑ k : Fin 6, (6:ℝ)⁻¹ • octaDir k := by
          unfold octaStepLaw
          rw [PMF.integral_eq_sum]
          simp [PMF.uniformOfFintype_apply]
  rw [hsum]
  funext i
  fin_cases i
  all_goals simp [octaDir, Fin.sum_univ_six]
  all_goals norm_num

/-- Concrete non-vacuity witness for the i.i.d. capstone: octahedral null
resolution, identity coin kernel, and a genuine i.i.d. product-measure process
whose increments are uniform over the six octahedral **null** directions and whose
mean is the rest current `(1,0,0,0)`. -/
def octaWitnessModel : FiniteIIDNullStrandModel where
  Ωdir := Fin 6
  U := ![1, 0, 0, 0]
  resolution := octahedralResolution
  L := Fin 1
  beable :=
    { coin :=
        { kernel := 1
          nonneg := by
            intro c c'; by_cases h : c = c' <;> simp [Matrix.one_apply, h]
          rowSum := by
            intro c; simp [Matrix.one_apply] }
      shift :=
        -- Genuine null branches (`(+---)` convention): the two chiralities move
        -- at the speed of light along `±x`, so each shift is Minkowski-null while
        -- sharing the common time component `lightSpeed = 1`.
        { step := fun c => if c then ![1, 1, 0, 0] else ![1, -1, 0, 0]
          lightSpeed := 1
          timeComponent := by intro c; cases c <;> rfl
          null := by
            intro c
            cases c <;>
              simp [PhysicsSM.NullStrand.minkowskiSq,
                PhysicsSM.NullStrand.minkowskiInner] <;> norm_num } }
  density := fun _ _ => 0
  Ω := ℕ → Fin 6
  μ := octaHistory
  step := fun i ω => octaDir (ω i)
  step_integrable := octaStep_integrable
  step_indep := octaStep_indep
  step_ident := octaStep_ident
  step_null := fun i ω => octahedralResolution.null (ω i)
  step_mean := octaStep_mean

/-- The concrete i.i.d. capstone is non-vacuous (with the nullity constraint
`step_null` active). -/
theorem finiteIIDNullStrandModel_nonempty : Nonempty FiniteIIDNullStrandModel :=
  ⟨octaWitnessModel⟩

end PhysicsSM.NullStrand.Master
