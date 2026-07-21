import Mathlib

/-!
# Variable pointwise isometries on vector-valued L2

This module proves the representative-safe functional-analytic lift used by
the null-edge continuum program. An almost-everywhere strongly measurable
family of complex continuous-linear isometries acts pointwise on concrete
representatives and induces a complex-linear isometry of `Lp E 2 mu`.

No theorem assigns physical point values to an `Lp` equivalence class. The
construction uses `MemLp.toLp`; linearity and the controls are proved through
almost-everywhere representative equalities and `Lp.ext`.

Provenance: clean-room Mathlib formalization. The four foundational proof
bodies were returned by Aristotle project
`1271173b-0275-4250-9a34-56fd7977649c`, replayed under Lean 4.28, and accepted
by an independent Claude-family semantic audit on 2026-07-13.
The composition theorem and its controls were returned by Aristotle project
`63e6b14f-f7a1-4db8-a39d-a9c50971f5b9` and independently replayed.
-/

noncomputable section

open MeasureTheory

namespace PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry

variable {X E : Type*}
variable [MeasurableSpace X]
variable [NormedAddCommGroup E] [NormedSpace Complex E]
variable (mu : Measure X)

/-- Apply a variable continuous-linear operator to the canonical representative
of an `Lp` class. This function is used only under `MemLp.toLp`. -/
def appliedRepresentative (U : X -> E →L[Complex] E)
    (f : Lp E 2 mu) : X -> E :=
  fun x => U x (f x)

/-- Joint measurability follows from measurable operator and vector families
through the continuous bilinear evaluation map. -/
theorem appliedRepresentative_aestronglyMeasurable
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (f : Lp E 2 mu) :
    AEStronglyMeasurable (appliedRepresentative mu U f) mu := by
  exact (ContinuousLinearMap.flip
    (ContinuousLinearMap.apply Complex E)).aestronglyMeasurable_comp₂
      hU (Lp.aestronglyMeasurable f)

/-- Pointwise norm preservation makes the transformed representative an `L2`
function with exactly the same extended norm. -/
theorem appliedRepresentative_memLp
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hIso : forall x v, norm (U x v) = norm v)
    (f : Lp E 2 mu) :
    MemLp (appliedRepresentative mu U f) 2 mu := by
  refine ⟨appliedRepresentative_aestronglyMeasurable mu U hU f, ?_⟩
  change eLpNorm (fun x => U x (f x)) 2 mu < ⊤
  rw [eLpNorm_congr_norm_ae
    (Filter.Eventually.of_forall fun x => hIso x (f x))]
  exact (Lp.memLp f).2

/-- A measurable family of pointwise complex-linear isometries induces a
representative-safe complex-linear isometry on vector-valued `L2`. -/
noncomputable def variablePointwiseL2Isometry
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hIso : forall x v, norm (U x v) = norm v) :
    Lp E 2 mu →ₗᵢ[Complex] Lp E 2 mu where
  toFun f := (appliedRepresentative_memLp mu U hU hIso f).toLp
  map_add' f g := by
    refine Lp.ext ?_
    filter_upwards
      [(appliedRepresentative_memLp mu U hU hIso (f + g)).coeFn_toLp,
       Lp.coeFn_add ((appliedRepresentative_memLp mu U hU hIso f).toLp)
         ((appliedRepresentative_memLp mu U hU hIso g).toLp),
       (appliedRepresentative_memLp mu U hU hIso f).coeFn_toLp,
       (appliedRepresentative_memLp mu U hU hIso g).coeFn_toLp,
       Lp.coeFn_add f g] with x h1 h2 h3 h4 h5
    simp only [appliedRepresentative] at h1 h3 h4 ⊢
    simp only [h1, h2, h3, h4, h5, Pi.add_apply, map_add]
  map_smul' c f := by
    refine Lp.ext ?_
    filter_upwards
      [(appliedRepresentative_memLp mu U hU hIso (c • f)).coeFn_toLp,
       Lp.coeFn_smul c ((appliedRepresentative_memLp mu U hU hIso f).toLp),
       (appliedRepresentative_memLp mu U hU hIso f).coeFn_toLp,
       Lp.coeFn_smul c f] with x h1 h2 h3 h4
    simp only [appliedRepresentative, RingHom.id_apply] at h1 h3 ⊢
    simp only [h1, h2, h3, h4, Pi.smul_apply, map_smul]
  norm_map' f := by
    show ‖(appliedRepresentative_memLp mu U hU hIso f).toLp‖ = ‖f‖
    rw [Lp.norm_toLp, Lp.norm_def]
    congr 1
    exact eLpNorm_congr_norm_ae
      (Filter.Eventually.of_forall fun x => hIso x (f x))

/-- The lifted map is represented almost everywhere by pointwise application
of the supplied operator family. -/
theorem variablePointwiseL2Isometry_coeFn
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hIso : forall x v, norm (U x v) = norm v)
    (f : Lp E 2 mu) :
    variablePointwiseL2Isometry mu U hU hIso f =ᵐ[mu]
      appliedRepresentative mu U f :=
  (appliedRepresentative_memLp mu U hU hIso f).coeFn_toLp

/-! ## Composition -/

/-- Pointwise composition of two measurable operator families remains strongly
measurable. -/
theorem composedFamily_aestronglyMeasurable
    (U V : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hV : AEStronglyMeasurable V mu) :
    AEStronglyMeasurable (fun x => (U x).comp (V x)) mu := by
  exact (ContinuousLinearMap.compL Complex E E E).aestronglyMeasurable_comp₂
    hU hV

/-- Composition preserves the pointwise-isometry hypothesis. -/
theorem composedFamily_isometry
    (U V : X -> E →L[Complex] E)
    (hIsoU : forall x v, norm (U x v) = norm v)
    (hIsoV : forall x v, norm (V x v) = norm v) :
    forall x v, norm (((U x).comp (V x)) v) = norm v := by
  intro x v
  rw [ContinuousLinearMap.comp_apply, hIsoU, hIsoV]

/-- Lifting pointwise composition to `L2` agrees with composing the two
independently lifted isometries. -/
theorem variablePointwiseL2Isometry_comp
    (U V : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hV : AEStronglyMeasurable V mu)
    (hIsoU : forall x v, norm (U x v) = norm v)
    (hIsoV : forall x v, norm (V x v) = norm v)
    (f : Lp E 2 mu) :
    variablePointwiseL2Isometry mu (fun x => (U x).comp (V x))
        (composedFamily_aestronglyMeasurable mu U V hU hV)
        (composedFamily_isometry U V hIsoU hIsoV) f =
      variablePointwiseL2Isometry mu U hU hIsoU
        (variablePointwiseL2Isometry mu V hV hIsoV f) := by
  refine Lp.ext ?_
  have h1 := variablePointwiseL2Isometry_coeFn mu
    (fun x => (U x).comp (V x))
    (composedFamily_aestronglyMeasurable mu U V hU hV)
    (composedFamily_isometry U V hIsoU hIsoV) f
  have h2 := variablePointwiseL2Isometry_coeFn mu U hU hIsoU
    (variablePointwiseL2Isometry mu V hV hIsoV f)
  have h3 := variablePointwiseL2Isometry_coeFn mu V hV hIsoV f
  filter_upwards [h1, h2, h3] with x hx1 hx2 hx3
  simp only [appliedRepresentative, ContinuousLinearMap.comp_apply]
    at hx1 hx2 hx3 ⊢
  rw [hx1, hx2, hx3]

/-! ## Anti-vacuity controls -/

/-- The constant identity family is measurable. -/
theorem idFamily_aestronglyMeasurable :
    AEStronglyMeasurable
      (fun _ : X => ContinuousLinearMap.id Complex E) mu := by
  exact aestronglyMeasurable_const

/-- The identity-family lift is the identity on every `L2` class. -/
theorem variablePointwiseL2Isometry_id (f : Lp E 2 mu) :
    variablePointwiseL2Isometry mu
      (fun _ : X => ContinuousLinearMap.id Complex E)
      (idFamily_aestronglyMeasurable mu)
      (by intro x v; rfl) f = f := by
  refine Lp.ext ?_
  filter_upwards [variablePointwiseL2Isometry_coeFn mu
    (fun _ : X => ContinuousLinearMap.id Complex E)
    (idFamily_aestronglyMeasurable mu) (by intro x v; rfl) f] with x h
  rw [h]
  simp [appliedRepresentative]

/-- The constant negative-identity family is measurable. -/
theorem negIdFamily_aestronglyMeasurable :
    AEStronglyMeasurable
      (fun _ : X => -(ContinuousLinearMap.id Complex E)) mu := by
  exact aestronglyMeasurable_const

/-- Nontrivial control: the negative-identity family lifts to negation rather
than collapsing to the identity or zero map. -/
theorem variablePointwiseL2Isometry_neg (f : Lp E 2 mu) :
    variablePointwiseL2Isometry mu
      (fun _ : X => -(ContinuousLinearMap.id Complex E))
      (negIdFamily_aestronglyMeasurable mu)
      (by intro x v; simp) f = -f := by
  refine Lp.ext ?_
  filter_upwards [variablePointwiseL2Isometry_coeFn mu
    (fun _ : X => -(ContinuousLinearMap.id Complex E))
    (negIdFamily_aestronglyMeasurable mu) (by intro x v; simp) f,
    Lp.coeFn_neg f] with x h hneg
  rw [h, hneg]
  simp [appliedRepresentative]

/-- Two identity-family lifts compose to the identity. -/
theorem variablePointwiseL2Isometry_comp_id_control (f : Lp E 2 mu) :
    variablePointwiseL2Isometry mu
        (fun _ : X => (ContinuousLinearMap.id Complex E).comp
          (ContinuousLinearMap.id Complex E))
        (composedFamily_aestronglyMeasurable mu _ _
          (idFamily_aestronglyMeasurable mu)
          (idFamily_aestronglyMeasurable mu))
        (composedFamily_isometry _ _ (by intro x v; rfl)
          (by intro x v; rfl)) f = f := by
  refine Lp.ext ?_
  filter_upwards [variablePointwiseL2Isometry_coeFn mu _ _ _ f] with x hx
  simpa [appliedRepresentative] using hx

/-- Two negative-identity-family lifts compose to the identity. -/
theorem variablePointwiseL2Isometry_comp_neg_control (f : Lp E 2 mu) :
    variablePointwiseL2Isometry mu
        (fun _ : X => (-(ContinuousLinearMap.id Complex E)).comp
          (-(ContinuousLinearMap.id Complex E)))
        (composedFamily_aestronglyMeasurable mu _ _
          (negIdFamily_aestronglyMeasurable mu)
          (negIdFamily_aestronglyMeasurable mu))
        (composedFamily_isometry _ _ (by intro x v; simp)
          (by intro x v; simp)) f = f := by
  refine Lp.ext ?_
  filter_upwards [variablePointwiseL2Isometry_coeFn mu _ _ _ f] with x hx
  simpa [appliedRepresentative] using hx

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry.variablePointwiseL2Isometry_coeFn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms variablePointwiseL2Isometry_coeFn

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry.variablePointwiseL2Isometry_id' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms variablePointwiseL2Isometry_id

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry.variablePointwiseL2Isometry_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms variablePointwiseL2Isometry_neg

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry.variablePointwiseL2Isometry_comp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms variablePointwiseL2Isometry_comp

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry.variablePointwiseL2Isometry_comp_id_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms variablePointwiseL2Isometry_comp_id_control

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry.variablePointwiseL2Isometry_comp_neg_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms variablePointwiseL2Isometry_comp_neg_control

end PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry
