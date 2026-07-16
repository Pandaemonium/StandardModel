import Mathlib

/-!
# Finite-volume Poisson configuration invariance

Mathlib supplies the Poisson count law but no point-process abstraction. This
module builds a finite-volume configuration law explicitly: draw a Poisson
count and, conditional on that count, draw finitely many independent positions.
It proves that a measurable transformation preserving the one-point law also
preserves the complete mixed-Poisson configuration law.

This is an invariance-in-distribution theorem. It does not say that an
individual configuration is pointwise fixed, construct an infinite-volume
point process, or establish Lorentz invariance for a decorated physical model.

The proof was returned by Aristotle project
`0ab450fa-de04-4ae9-bb79-eb186f5172da`, independently replayed under the pinned
Lean 4.28 toolchain, and then adapted into the repository namespace without
changing the theorem statements.
-/

open MeasureTheory ProbabilityTheory

namespace PhysicsSM.Draft.NullEdge.FinitePoissonConfigurationInvariance

/-- A finite labelled point configuration. -/
abbrev Config (X : Type*) [MeasurableSpace X] := Sigma fun n : Nat => Fin n -> X

variable {X : Type*} [MeasurableSpace X]

/-- Conditional law of `n` independent positions. -/
noncomputable def posLaw (P : Measure X) (n : Nat) : Measure (Fin n -> X) :=
  Measure.pi fun _ : Fin n => P

/-- Mixed-Poisson finite configuration law. -/
noncomputable def configLaw (r : NNReal) (P : Measure X) : Measure (Config X) :=
  (poissonMeasure r).bind fun n => (posLaw P n).map (Sigma.mk n)

/-- Pointwise action of a map on a finite configuration. -/
def configMap (T : X -> X) : Config X -> Config X :=
  fun c => ⟨c.1, fun i => T (c.2 i)⟩

/-- Measurability of a sigma injection. This local helper fills a missing
packaged Mathlib API for the sigma measurable space. -/
lemma measurable_sigmaMk {ι : Type*} {β : ι -> Type*}
    [∀ i, MeasurableSpace (β i)] (i : ι) :
    Measurable (Sigma.mk i : β i -> Sigma β) := by
  intro s hs
  rw [Sigma.instMeasurableSpace] at hs
  exact (MeasurableSpace.measurableSet_iInf.mp hs) i

/-- A map out of a sigma type is measurable when every fibre restriction is
measurable. -/
lemma measurable_sigma_of {ι : Type*} {β : ι -> Type*}
    [∀ i, MeasurableSpace (β i)] {γ : Type*} [MeasurableSpace γ]
    {f : Sigma β -> γ} (hf : ∀ i, Measurable fun x => f ⟨i, x⟩) :
    Measurable f := by
  intro s hs
  rw [Sigma.instMeasurableSpace]
  exact MeasurableSpace.measurableSet_iInf.mpr fun i => hf i hs

/-- A measurable map can be pushed through a measure bind. -/
lemma map_bind_of_measurable {α β γ : Type*} [MeasurableSpace α]
    [MeasurableSpace β] [MeasurableSpace γ] {g : β -> γ}
    (hg : Measurable g) {m : Measure α} {f : α -> Measure β}
    (hf : Measurable f) :
    (m.bind f).map g = m.bind fun a => (f a).map g := by
  simp only [Measure.bind]
  rw [← Measure.join_map_map hg, Measure.map_map (Measure.measurable_map g hg) hf]
  rfl

/-- A measurable base map induces a measurable configuration map. -/
theorem measurable_configMap (T : X -> X) (hT : Measurable T) :
    Measurable (configMap T) := by
  apply measurable_sigma_of
  intro n
  exact (measurable_sigmaMk n).comp
    (measurable_pi_lambda _ fun i => hT.comp (measurable_pi_apply i))

/-- A position-law-preserving map preserves the complete finite-volume Poisson
configuration law in distribution. -/
theorem configLaw_invariant (r : NNReal) (P : Measure X)
    [IsProbabilityMeasure P] (T : X -> X)
    (hT : MeasurePreserving T P P) :
    Measure.map (configMap T) (configLaw r P) = configLaw r P := by
  have hTm : Measurable T := hT.measurable
  unfold configLaw
  rw [map_bind_of_measurable (measurable_configMap T hTm) measurable_from_nat]
  congr 1
  funext n
  rw [Measure.map_map (measurable_configMap T hTm) (measurable_sigmaMk n)]
  have hcomp : (configMap T) ∘ (Sigma.mk n) =
      (Sigma.mk n) ∘ (fun g : Fin n -> X => fun i => T (g i)) := rfl
  rw [hcomp, ← Measure.map_map (measurable_sigmaMk n)
      (measurable_pi_lambda _ fun i => hTm.comp (measurable_pi_apply i))]
  congr 1
  exact
    (measurePreserving_pi (fun _ : Fin n => P) (fun _ : Fin n => P)
      fun _ => hT).map_eq

/-- Identity-map control. -/
theorem configLaw_invariant_id (r : NNReal) (P : Measure X)
    [IsProbabilityMeasure P] :
    Measure.map (configMap id) (configLaw r P) = configLaw r P := by
  simpa using configLaw_invariant r P id (MeasurePreserving.id P)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePoissonConfigurationInvariance.measurable_configMap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms measurable_configMap

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePoissonConfigurationInvariance.configLaw_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms configLaw_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePoissonConfigurationInvariance.configLaw_invariant_id' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms configLaw_invariant_id

end PhysicsSM.Draft.NullEdge.FinitePoissonConfigurationInvariance
