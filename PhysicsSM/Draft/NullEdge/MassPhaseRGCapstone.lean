import Mathlib
import PhysicsSM.Draft.NullEdge.MassPhase4Channel
import PhysicsSM.Draft.NullEdge.RGFixedPointStructure
import PhysicsSM.Draft.NullEdge.MassPhaseDiagram
import PhysicsSM.Draft.NullEdge.Goal3ExactRG
import PhysicsSM.Draft.NullEdge.Goal3ChannelRG4

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 4000000

set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# Mass-phase / RG capstone for the finite null-edge block

This file **composes** two previously developed stories:

* the four-channel mass-phase surface `MassPhase4Channel`, whose block
  `Bc = [[lam+E, kap, tau],[kap, lam+E, 0],[tau, 0, lam+E]]` has an exhaustive
  massive / critical / ghost phase diagram cut out by the closed-form margin
  `(lam+E)^2 - (kap^2+tau^2)`; and
* the exact RG / period-2 story `RGFixedPointStructure` (with the exact Schur
  derivation in `Goal3ExactRG` and the four-channel RG spectrum in
  `Goal3ChannelRG4`), whose decimation map `R2` fixes only the free line
  `kap = 0`, while the critical line `kap = lam` is a genuine **period-2 orbit**
  (the sign flip `(lam,lam) ↔ (-lam,-lam)`), *not* a strict fixed point.

The capstone records:

1. `four_channel_phase_surface_capstone` — the phase predicates coincide with
   their closed-form arithmetic criteria on the whole four-parameter surface,
   together with the massive/critical/ghost non-degeneracy witnesses;
2. `landed_line_is_surface_slice` — the landed critical line `|kap| = lam`
   (`kap = lam`, `lam ≥ 0`) is exactly the `tau = E = 0` slice of the surface;
3. `positive_line_soldering_moves_to_massive` — a landed critical point on the
   positive line becomes massive once soldering `E = lam` is switched on;
4. `rg_period_two_matches_critical_slice` — the RG critical line is a period-2
   invariant (sign flip), matching the `kap = lam` critical slice;
5. `phase_rg_verdict` — the packaged verdict combining the concrete
   soldering/aperture mass-generation facts with the RG basin verdict;
6. `exact_rg_capstone` — an import of the stronger exact-RG headlines
   (massless-line invariance and non-degeneracy, the linearized mass eigenvalue
   `= 2` giving `ν = 1`, and the relevant soldering eigenvalue).

The wording is kept honest: the critical line is a **period-2** invariant, not a
strict fixed point.  Guard pins fix the axiom footprint of each headline.
-/

namespace MassPhaseRGCapstone

/-- **The four-channel phase surface capstone.**  On the entire four-parameter
surface the three geometric phase predicates coincide with their closed-form
arithmetic criteria, and each phase is populated by an explicit rational
witness. -/
theorem four_channel_phase_surface_capstone :
    (∀ lam kap tau E : ℝ,
        MassPhase4Channel.Massive lam kap tau E
          ↔ MassPhase4Channel.critMassive lam kap tau E)
      ∧ (∀ lam kap tau E : ℝ,
        MassPhase4Channel.Critical lam kap tau E
          ↔ MassPhase4Channel.critCritical lam kap tau E)
      ∧ (∀ lam kap tau E : ℝ,
        MassPhase4Channel.Ghost lam kap tau E
          ↔ MassPhase4Channel.critGhost lam kap tau E)
      ∧ MassPhase4Channel.Massive 1 0 0 0
      ∧ MassPhase4Channel.Critical 1 1 0 0
      ∧ MassPhase4Channel.Ghost 1 2 0 0 := by
  refine ⟨MassPhase4Channel.massive_iff, MassPhase4Channel.critical_iff,
    MassPhase4Channel.ghost_iff, ?_, ?_, ?_⟩
  · exact MassPhase4Channel.witness_massive.1
  · exact MassPhase4Channel.witness_critical.1
  · exact MassPhase4Channel.witness_ghost.1

/-- **The landed critical line is the `tau = E = 0` slice of the surface.**  For
`lam ≥ 0` the landed point `(lam, lam, 0, 0)` (i.e. `|kap| = lam`) lies exactly on
the critical surface `kap^2 + tau^2 = (lam+E)^2`. -/
theorem landed_line_is_surface_slice (lam : ℝ) (h : 0 ≤ lam) :
    MassPhase4Channel.Critical lam lam 0 0 := by
  refine (MassPhase4Channel.critical_iff lam lam 0 0).2 ?_
  constructor
  · simpa using h
  · ring

/-- **Positive-line soldering moves the critical point to the massive phase.**  A
landed critical point `(lam, lam, 0, 0)` on the positive line (`lam > 0`) becomes
massive once soldering `E = lam` is switched on. -/
theorem positive_line_soldering_moves_to_massive (lam : ℝ) (h : 0 < lam) :
    MassPhase4Channel.Critical lam lam 0 0
      ∧ MassPhase4Channel.Massive lam lam 0 lam := by
  refine ⟨landed_line_is_surface_slice lam h.le, ?_⟩
  refine (MassPhase4Channel.massive_iff lam lam 0 lam).2 ?_
  constructor
  · linarith
  · nlinarith

/-- **The RG critical line is a period-2 invariant, not a fixed point.**  On the
critical (massless) line `kap = lam` the decimation map `R2` acts as the sign flip
`(lam,lam) → (-lam,-lam)` and back, a genuine period-2 orbit. -/
theorem rg_period_two_matches_critical_slice (lam : ℚ) (h : lam ≠ 0) :
    RGFixedPointStructure.R2 lam lam = (-lam, -lam)
      ∧ RGFixedPointStructure.R2 (-lam) (-lam) = (lam, lam) := by
  obtain ⟨h1, h2, _⟩ := RGFixedPointStructure.critical_line_period2 h
  exact ⟨h1, h2⟩

/-- **The packaged phase / RG verdict.**  The concrete soldering and aperture
mass-generation facts combine with the RG basin verdict: the fixed-point set of
`R2` is the free line `kap = 0`, the critical line `kap = lam` is a period-2
invariant, and the massive region flows toward the free line. -/
theorem phase_rg_verdict :
    (MassPhase4Channel.Ghost 1 2 0 0 ∧ MassPhase4Channel.Massive 1 2 0 2)
      ∧ (MassPhase4Channel.Ghost 1 2 0 0 ∧ MassPhase4Channel.Massive 3 2 0 0)
      ∧ ((∀ lam kap : ℚ, lam ≠ 0 →
            (RGFixedPointStructure.R2 lam kap = (lam, kap) ↔ kap = 0))
        ∧ (∀ lam : ℚ, lam ≠ 0 →
            RGFixedPointStructure.R2 lam lam = (-lam, -lam)
              ∧ RGFixedPointStructure.R2 (-lam) (-lam) = (lam, lam)
              ∧ ((-lam, -lam) : ℚ × ℚ) ≠ (lam, lam))
        ∧ (∀ lam kap : ℚ, lam ≠ 0 → kap ≠ 0 → |kap| < |lam| →
            |(RGFixedPointStructure.R2 lam kap).2| = kap ^ 2 / |lam|
              ∧ |(RGFixedPointStructure.R2 lam kap).2| < |kap|)) :=
  ⟨MassPhase4Channel.soldering_shifts_mass,
    MassPhase4Channel.aperture_generates_mass,
    RGFixedPointStructure.basin_verdict⟩

/-- **Exact-RG capstone (import of the stronger headlines).**  Combines the exact
massless-line invariance and non-degeneracy from the Schur derivation, the
linearized RG mass eigenvalue `= 2` (giving `ν = 1`), and the relevant soldering
eigenvalue of the four-channel RG spectrum. -/
theorem exact_rg_capstone :
    ((∀ lam kap : ℚ, lam ≠ 0 → |kap| = |lam| →
        |Goal3ExactRG.Rkap lam kap| = |Goal3ExactRG.Rlam lam kap|
          ∧ Goal3ExactRG.R (lam, kap) = (-lam, -lam))
      ∧ Goal3ExactRG.R (1, 1 / 2) = (1 / 2, -1 / 4)
      ∧ Goal3ExactRG.R (1, 1 / 2) ≠ (1, 1 / 2))
      ∧ (Goal3ExactRG.Jac.mulVec ![4, 1] = (2 : ℝ) • ![4, 1]
          ∧ Goal3ExactRG.Jac.mulVec ![1, 1] = (-1 : ℝ) • ![1, 1]
          ∧ Goal3ExactRG.Jac.trace = 1
          ∧ Goal3ExactRG.Jac.det = -2
          ∧ Real.logb 2 2 = 1)
      ∧ (Goal3ChannelRG4.classify Goal3ChannelRG4.solderingEigenvalue
            = Goal3ChannelRG4.RGClass.relevant
          ∧ 1 < |Goal3ChannelRG4.solderingEigenvalue|) :=
  ⟨Goal3ExactRG.massless_line_invariant_and_nondegenerate,
    Goal3ExactRG.linearized_mass_eigenvalue_eq_two,
    Goal3ChannelRG4.soldering_verdict⟩

/-! ## Kernel-checked axiom footprint of every headline theorem -/

/-- info: 'MassPhaseRGCapstone.four_channel_phase_surface_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms four_channel_phase_surface_capstone

/-- info: 'MassPhaseRGCapstone.landed_line_is_surface_slice' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms landed_line_is_surface_slice

/-- info: 'MassPhaseRGCapstone.positive_line_soldering_moves_to_massive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positive_line_soldering_moves_to_massive

/-- info: 'MassPhaseRGCapstone.rg_period_two_matches_critical_slice' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rg_period_two_matches_critical_slice

/-- info: 'MassPhaseRGCapstone.phase_rg_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phase_rg_verdict

/-- info: 'MassPhaseRGCapstone.exact_rg_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exact_rg_capstone

end MassPhaseRGCapstone
