import Mathlib

/-!
# Finite-volume Poisson configuration invariance

Mathlib supplies the Poisson count law but no point-process abstraction. This
file builds the finite-volume configuration law explicitly: draw a Poisson
count and, conditional on that count, draw finitely many independent positions.
The target proves invariance under a measurable map preserving the position
law. It is a distributional theorem, not a claim that an individual finite
configuration is fixed.
-/

open MeasureTheory ProbabilityTheory

namespace PoissonConfigInvariant

/-- A finite labelled point configuration. -/
abbrev Config (X : Type*) [MeasurableSpace X] := Σ n : ℕ, (Fin n → X)

variable {X : Type*} [MeasurableSpace X]

/-- Conditional law of `n` independent positions. -/
noncomputable def posLaw (P : Measure X) (n : ℕ) : Measure (Fin n → X) :=
  Measure.pi (fun _ : Fin n => P)

/-- Mixed-Poisson finite configuration law. -/
noncomputable def configLaw (r : NNReal) (P : Measure X) : Measure (Config X) :=
  (poissonMeasure r).bind (fun n => (posLaw P n).map (Sigma.mk n))

/-- Pointwise action of a map on a finite configuration. -/
def configMap (T : X → X) : Config X → Config X :=
  fun c => ⟨c.1, fun i => T (c.2 i)⟩

/-- A function into a sigma type is measurable as soon as each preimage of
`Sigma.mk` component is. Local helper: Mathlib has no ready lemma for the
measurability of `Sigma.mk`. -/
lemma measurable_sigmaMk {ι : Type*} {β : ι → Type*} [∀ i, MeasurableSpace (β i)] (i : ι) :
    Measurable (Sigma.mk i : β i → Σ i, β i) := by
  intro s hs
  rw [Sigma.instMeasurableSpace] at hs
  exact (MeasurableSpace.measurableSet_iInf.mp hs) i

/-- A map out of a sigma type is measurable iff each fibrewise restriction is.
Local helper reconstructing the universal property of the sigma sigma-algebra. -/
lemma measurable_sigma_of {ι : Type*} {β : ι → Type*} [∀ i, MeasurableSpace (β i)]
    {γ : Type*} [MeasurableSpace γ] {f : (Σ i, β i) → γ}
    (hf : ∀ i, Measurable (fun x => f ⟨i, x⟩)) : Measurable f := by
  intro s hs
  rw [Sigma.instMeasurableSpace]
  exact MeasurableSpace.measurableSet_iInf.mpr (fun i => hf i hs)

/-- Pushing a measurable map through a monadic bind. Local helper: `bind` is
defined as `join` after `map`, so this follows from `Measure.join_map_map`. -/
lemma map_bind_of_measurable {α β γ : Type*} [MeasurableSpace α] [MeasurableSpace β]
    [MeasurableSpace γ] {g : β → γ} (hg : Measurable g) {m : Measure α}
    {f : α → Measure β} (hf : Measurable f) :
    (m.bind f).map g = m.bind (fun a => (f a).map g) := by
  simp only [Measure.bind]
  rw [← Measure.join_map_map hg, Measure.map_map (Measure.measurable_map g hg) hf]
  rfl

/-- A measurable base map induces a measurable configuration map. -/
theorem measurable_configMap (T : X → X) (hT : Measurable T) :
    Measurable (configMap T) := by
  apply measurable_sigma_of
  intro n
  exact (measurable_sigmaMk n).comp
    (measurable_pi_lambda _ (fun i => hT.comp (measurable_pi_apply i)))

/-- A position-law-preserving map preserves the complete finite-volume Poisson
configuration law. This is invariance *in distribution*: the pushforward of the
mixed-Poisson configuration law under `configMap T` equals the law itself. It
does not assert that any individual finite configuration is fixed. -/
theorem configLaw_invariant (r : NNReal) (P : Measure X)
    [IsProbabilityMeasure P] (T : X → X)
    (hT : MeasurePreserving T P P) :
    Measure.map (configMap T) (configLaw r P) = configLaw r P := by
  have hTm : Measurable T := hT.measurable
  unfold configLaw
  -- Push the configuration map through the Poisson mixing bind.
  rw [map_bind_of_measurable (measurable_configMap T hTm) measurable_from_nat]
  congr 1
  funext n
  -- Fibrewise: `configMap T` acts through `Sigma.mk n` on the position law.
  rw [Measure.map_map (measurable_configMap T hTm) (measurable_sigmaMk n)]
  have hcomp : (configMap T) ∘ (Sigma.mk n)
      = (Sigma.mk n) ∘ (fun g : Fin n → X => fun i => T (g i)) := rfl
  rw [hcomp, ← Measure.map_map (measurable_sigmaMk n)
      (measurable_pi_lambda _ (fun i => hTm.comp (measurable_pi_apply i)))]
  congr 1
  -- The product position law is preserved because `T` preserves `P` factorwise.
  exact (measurePreserving_pi (fun _ : Fin n => P) (fun _ : Fin n => P) (fun _ => hT)).map_eq

/-- Identity-map control. -/
theorem configLaw_invariant_id (r : NNReal) (P : Measure X)
    [IsProbabilityMeasure P] :
    Measure.map (configMap id) (configLaw r P) = configLaw r P := by
  simpa using configLaw_invariant r P id (MeasurePreserving.id P)

end PoissonConfigInvariant
