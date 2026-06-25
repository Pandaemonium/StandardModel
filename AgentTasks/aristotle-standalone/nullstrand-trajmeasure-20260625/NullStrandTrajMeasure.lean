import Mathlib

/-!
# NullStrand i.i.d. trajectory measure (manifest node TRAJ-001, i.i.d. form)

`iidTrajMeasure_isProbability`: the infinite product of a probability law is a
probability measure on the trajectory space `ℕ → Ω`. This is the wrapper that makes
an "actual history" a genuine random variable (improved roadmap W6 tier 1) and,
together with ERG-001 (the strong law) and the octahedral null resolution, supplies
the probability space for the finite i.i.d. capstone `finiteIIDNullStrand_master`
(MASTER-001).

(The general state-dependent finite-Markov-kernel form uses
`ProbabilityTheory.Kernel.trajMeasure`; this i.i.d. product form is the one the
first capstone needs.)

Mathlib-only; focused Aristotle target.
-/

open MeasureTheory

namespace NullStrand.Probability

/-- TRAJ-001 (i.i.d. form). The infinite product of a probability law is a
probability measure on the trajectory space `ℕ → Ω`. -/
theorem iidTrajMeasure_isProbability
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ] :
    IsProbabilityMeasure (Measure.infinitePi (fun _ : ℕ => μ)) := by
  sorry

end NullStrand.Probability
