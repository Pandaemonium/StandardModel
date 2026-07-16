import Mathlib

/-!
# Composition of variable pointwise L2 isometries

This focused Mathlib-only file packages the representative-safe composition
law needed to lift the null-edge exact multiplier time-group law from each
momentum fibre to vector-valued `L2`.

The foundational lift is included here with its completed proof so Aristotle
can spend its budget only on the new composition theorem. No pointwise value is
assigned to an `Lp` equivalence class: all comparisons use almost-everywhere
representatives and `Lp.ext`.
-/

noncomputable section

open MeasureTheory

namespace VariablePointwiseL2Composition

variable {X E : Type*}
variable [MeasurableSpace X]
variable [NormedAddCommGroup E] [NormedSpace Complex E]
variable (mu : Measure X)

/-- Apply a variable continuous-linear operator to the canonical representative
of an `Lp` class. -/
def appliedRepresentative (U : X -> E →L[Complex] E)
    (f : Lp E 2 mu) : X -> E :=
  fun x => U x (f x)

theorem appliedRepresentative_aestronglyMeasurable
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (f : Lp E 2 mu) :
    AEStronglyMeasurable (appliedRepresentative mu U f) mu := by
  exact (ContinuousLinearMap.flip
    (ContinuousLinearMap.apply Complex E)).aestronglyMeasurable_comp₂
      hU (Lp.aestronglyMeasurable f)

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

theorem variablePointwiseL2Isometry_coeFn
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hIso : forall x v, norm (U x v) = norm v)
    (f : Lp E 2 mu) :
    variablePointwiseL2Isometry mu U hU hIso f =ᵐ[mu]
      appliedRepresentative mu U f :=
  (appliedRepresentative_memLp mu U hU hIso f).coeFn_toLp

/-- Pointwise composition of two measurable operator families remains strongly
measurable. -/
theorem composedFamily_aestronglyMeasurable
    (U V : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hV : AEStronglyMeasurable V mu) :
    AEStronglyMeasurable (fun x => (U x).comp (V x)) mu := by
  exact (ContinuousLinearMap.compL Complex E E E).aestronglyMeasurable_comp₂ hU hV

/-- Composition preserves the pointwise-isometry hypothesis. -/
theorem composedFamily_isometry
    (U V : X -> E →L[Complex] E)
    (hIsoU : forall x v, norm (U x v) = norm v)
    (hIsoV : forall x v, norm (V x v) = norm v) :
    forall x v, norm (((U x).comp (V x)) v) = norm v := by
  intro x v
  rw [ContinuousLinearMap.comp_apply, hIsoU, hIsoV]

/-- **Immutable target.** Lifting pointwise composition to `L2` agrees with
composing the two independently lifted isometries. -/
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

theorem idFamily_aestronglyMeasurable :
    AEStronglyMeasurable
      (fun _ : X => ContinuousLinearMap.id Complex E) mu := by
  exact aestronglyMeasurable_const

theorem negIdFamily_aestronglyMeasurable :
    AEStronglyMeasurable
      (fun _ : X => -(ContinuousLinearMap.id Complex E)) mu := by
  exact aestronglyMeasurable_const

/-- The composition theorem specializes to identity after two identity lifts. -/
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

/-- Two negative-identity pointwise operations compose to identity on `L2`. -/
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

end VariablePointwiseL2Composition
