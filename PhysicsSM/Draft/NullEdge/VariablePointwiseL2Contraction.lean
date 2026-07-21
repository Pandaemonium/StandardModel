import PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry

/-!
# Variable pointwise contractions on vector-valued L2

This module extends the representative-safe pointwise `L2` construction from
isometries to contractions. An almost-everywhere strongly measurable family of
complex continuous-linear maps satisfying `norm (U x v) <= norm v` induces a
bounded complex-linear operator on `Lp E 2 mu` with operator norm at most one.

The construction never assigns point values to an `Lp` equivalence class. It
acts on the canonical representative only underneath `MemLp.toLp`, and all
linearity and norm statements are discharged by almost-everywhere equalities.

This is the reusable functional-analytic bridge needed to lift the explicit
massive HNU fibre resolvents to bounded global `L2` resolvents.

Provenance: clean-room composition of Mathlib's `MemLp.mono`, `MemLp.toLp`, and
`Lp.norm_le_norm_of_ae_le`, following the representative discipline of
`VariablePointwiseL2Isometry`. Claim grade `M`, `[comp]`.
-/

noncomputable section

open MeasureTheory

set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.VariablePointwiseL2Contraction

open VariablePointwiseL2Isometry

variable {X E : Type*}
variable [MeasurableSpace X]
variable [NormedAddCommGroup E] [NormedSpace Complex E]
variable (mu : Measure X)

/-- A measurable pointwise contraction sends every `L2` representative to an
`L2` representative. -/
theorem appliedRepresentative_memLp
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hContr : forall x v, norm (U x v) <= norm v)
    (f : Lp E 2 mu) :
    MemLp (appliedRepresentative mu U f) 2 mu := by
  refine MemLp.mono (Lp.memLp f)
    (appliedRepresentative_aestronglyMeasurable mu U hU f) ?_
  exact Filter.Eventually.of_forall fun x => hContr x (f x)

/-- The packaged transformed `L2` class. -/
noncomputable def transformed
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hContr : forall x v, norm (U x v) <= norm v)
    (f : Lp E 2 mu) : Lp E 2 mu :=
  (appliedRepresentative_memLp mu U hU hContr f).toLp

/-- The packaged class is represented almost everywhere by pointwise
application of the supplied family. -/
theorem transformed_coeFn
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hContr : forall x v, norm (U x v) <= norm v)
    (f : Lp E 2 mu) :
    transformed mu U hU hContr f =ᵐ[mu] appliedRepresentative mu U f :=
  (appliedRepresentative_memLp mu U hU hContr f).coeFn_toLp

/-- Pointwise application, packaged as a complex-linear map on `L2`. -/
noncomputable def variablePointwiseL2ContractionLinearMap
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hContr : forall x v, norm (U x v) <= norm v) :
    Lp E 2 mu →ₗ[Complex] Lp E 2 mu where
  toFun := transformed mu U hU hContr
  map_add' f g := by
    change transformed mu U hU hContr (f + g) =
      transformed mu U hU hContr f + transformed mu U hU hContr g
    refine Lp.ext ?_
    filter_upwards
      [transformed_coeFn mu U hU hContr (f + g),
       transformed_coeFn mu U hU hContr f,
       transformed_coeFn mu U hU hContr g,
       Lp.coeFn_add f g,
       Lp.coeFn_add (transformed mu U hU hContr f)
         (transformed mu U hU hContr g)] with x hfg hf hg hadd hsum
    rw [hfg, hsum]
    simp only [Pi.add_apply]
    rw [hf, hg]
    simp only [appliedRepresentative]
    rw [hadd, Pi.add_apply, map_add]
  map_smul' c f := by
    change transformed mu U hU hContr (c • f) =
      c • transformed mu U hU hContr f
    refine Lp.ext ?_
    filter_upwards
      [transformed_coeFn mu U hU hContr (c • f),
       transformed_coeFn mu U hU hContr f,
       Lp.coeFn_smul c f,
       Lp.coeFn_smul c (transformed mu U hU hContr f)]
      with x hcf hf hsmul hresult
    rw [hcf, hresult]
    simp only [Pi.smul_apply]
    rw [hf]
    simp only [appliedRepresentative]
    rw [hsmul, Pi.smul_apply, map_smul]

/-- The induced linear map is a contraction. -/
theorem variablePointwiseL2ContractionLinearMap_norm_le
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hContr : forall x v, norm (U x v) <= norm v)
    (f : Lp E 2 mu) :
    norm (variablePointwiseL2ContractionLinearMap mu U hU hContr f) <= norm f := by
  change norm (transformed mu U hU hContr f) <= norm f
  apply Lp.norm_le_norm_of_ae_le
  filter_upwards [transformed_coeFn mu U hU hContr f] with x hx
  rw [hx]
  exact hContr x (f x)

/-- A measurable family of fibre contractions induces a bounded contraction
on vector-valued `L2`. -/
noncomputable def variablePointwiseL2Contraction
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hContr : forall x v, norm (U x v) <= norm v) :
    Lp E 2 mu →L[Complex] Lp E 2 mu :=
  (variablePointwiseL2ContractionLinearMap mu U hU hContr).mkContinuous 1
    (fun f => by
      simpa using variablePointwiseL2ContractionLinearMap_norm_le
        mu U hU hContr f)

/-- The global pointwise contraction has operator norm at most one. -/
theorem variablePointwiseL2Contraction_norm_le_one
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hContr : forall x v, norm (U x v) <= norm v) :
    norm (variablePointwiseL2Contraction mu U hU hContr) <= 1 := by
  unfold variablePointwiseL2Contraction
  exact LinearMap.mkContinuous_norm_le _ (by norm_num) _

/-- The continuous-linear lift has the expected pointwise representative. -/
theorem variablePointwiseL2Contraction_coeFn
    (U : X -> E →L[Complex] E)
    (hU : AEStronglyMeasurable U mu)
    (hContr : forall x v, norm (U x v) <= norm v)
    (f : Lp E 2 mu) :
    variablePointwiseL2Contraction mu U hU hContr f =ᵐ[mu]
      appliedRepresentative mu U f :=
  transformed_coeFn mu U hU hContr f

end PhysicsSM.Draft.NullEdge.VariablePointwiseL2Contraction

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePointwiseL2Contraction.variablePointwiseL2Contraction_norm_le_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.VariablePointwiseL2Contraction.variablePointwiseL2Contraction_norm_le_one

/-- info: 'PhysicsSM.Draft.NullEdge.VariablePointwiseL2Contraction.variablePointwiseL2Contraction_coeFn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.VariablePointwiseL2Contraction.variablePointwiseL2Contraction_coeFn
