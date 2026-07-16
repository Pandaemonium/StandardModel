import Mathlib

/-!
# Variable pointwise isometries lift to vector-valued L2

This focused file isolates the representative-safe functional-analytic step
needed by the null-edge continuum program. A measurable family of complex
continuous-linear isometries acts pointwise on concrete representatives. The
target packages that action as a genuine complex-linear isometry of `Lp` while
respecting almost-everywhere equality.

The statement is intentionally independent of the Dirac multiplier. The live
specialization will use `ChangingCellFourierPDE.momMult_isometry` and continuity
of the exact multiplier family.
-/

noncomputable section

open MeasureTheory

namespace VariablePointwiseL2Isometry

variable {X E : Type*}
variable [MeasurableSpace X]
variable [NormedAddCommGroup E] [NormedSpace Complex E]
variable (mu : Measure X)

/-- Apply a variable continuous-linear operator to the canonical representative
of an `Lp` class. This function is used only under `MemLp.toLp`; no theorem
assigns physical point values to the quotient class. -/
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

/-- **Immutable target.** A measurable family of pointwise complex-linear
isometries induces a representative-safe complex-linear isometry on
vector-valued `L2`. -/
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

end VariablePointwiseL2Isometry
