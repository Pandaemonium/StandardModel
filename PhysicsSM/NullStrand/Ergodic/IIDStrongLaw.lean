import Mathlib

/-!
# NullStrand.Ergodic.IIDStrongLaw

Manifest node ERG-001: for i.i.d. integrable null increments with mean `U`, the
empirical mean converges almost surely to `U`. This is the first PATHWISE
(almost-sure, single-history) theorem in the program — the ontology ingredient of
the finite capstone `finiteIIDNullStrand_master` (MASTER-001): one realized
history is microscopically null and macroscopically timelike. It is a thin wrapper
around Mathlib's Banach-valued strong law `MeasureTheory.strong_law_ae`.

Provenance: clean-room statement; proof from Aristotle project
`98f0236c-0d16-40de-97ba-937e997ca26c`, verified `sorry`/`axiom`-free and
statement-identical, integrated 2026-06-25.
-/

open MeasureTheory Filter ProbabilityTheory
open scoped Topology BigOperators

namespace PhysicsSM.NullStrand.Ergodic

/-- ERG-001. Empirical mean of i.i.d. integrable increments tends a.s. to the
common mean `U`. -/
theorem iidNullSteps_empiricalMean_tendsto
    {Ω : Type*} {m : MeasurableSpace Ω} (μ : Measure Ω) [IsProbabilityMeasure μ]
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [MeasurableSpace E]
    [BorelSpace E] [CompleteSpace E] [SecondCountableTopology E]
    (X : ℕ → Ω → E) (hint : Integrable (X 0) μ)
    (hindep : Pairwise (fun i j => IndepFun (X i) (X j) μ))
    (hident : ∀ i, IdentDistrib (X i) (X 0) μ μ)
    (U : E) (hmean : (∫ ω, X 0 ω ∂μ) = U) :
    ∀ᵐ ω ∂μ, Tendsto (fun n : ℕ => (n : ℝ)⁻¹ • ∑ i ∈ Finset.range n, X i ω) atTop (𝓝 U) := by
  filter_upwards [strong_law_ae X hint hindep hident] with ω hω
  rwa [hmean] at hω

end PhysicsSM.NullStrand.Ergodic
