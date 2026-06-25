import Mathlib

/-!
# NullStrand.Probability.Trajectory

Manifest node TRAJ-001 (i.i.d. form): the infinite product of a probability law is
a probability measure on the trajectory space `ℕ → Ω`. This makes an "actual
history" a genuine random variable (improved roadmap W6 tier 1) and, with ERG-001
(the strong law) and the octahedral null resolution, supplies the probability
space for the finite i.i.d. capstone `finiteIIDNullStrand_master` (MASTER-001).

The general state-dependent finite-Markov-kernel form uses
`ProbabilityTheory.Kernel.trajMeasure`; this i.i.d. product form is the one the
first capstone needs.

Provenance: clean-room statement; proof from Aristotle project
`2ccba4dc-906b-43d2-b1e9-bd51760c1499`, verified `sorry`/`axiom`-free and
statement-identical, integrated 2026-06-25.
-/

open MeasureTheory

namespace PhysicsSM.NullStrand.Probability

/-- TRAJ-001 (i.i.d. form). The infinite product of a probability law is a
probability measure on the trajectory space `ℕ → Ω`. -/
theorem iidTrajMeasure_isProbability
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ] :
    IsProbabilityMeasure (Measure.infinitePi (fun _ : ℕ => μ)) :=
  inferInstance

end PhysicsSM.NullStrand.Probability
