# codex-mass-phase-rg-capstone-0725-20260709

aristotle:
  project_id: 27c385c3-8f31-4418-b1f6-065d47f0c26d
  target_file: PhysicsSM/Draft/NullEdge/MassPhaseRGCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.MassPhaseRGCapstone
  submission_project: AgentTasks/aristotle-submit/codex-ambitious-proof-wave-0725-20260709-project
  output_dir: AgentTasks/aristotle-output/27c385c3-8f31-4418-b1f6-065d47f0c26d
  status: harvested + ported 2026-07-09 ~07:05

You are Aristotle, proving an ambitious finite mass-phase/RG capstone in Lean.

Target file to create:

```text
PhysicsSM/Draft/NullEdge/MassPhaseRGCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.MassPhase4Channel
import PhysicsSM.Draft.NullEdge.RGFixedPointStructure
import PhysicsSM.Draft.NullEdge.MassPhaseDiagram
import PhysicsSM.Draft.NullEdge.Goal3ExactRG
import PhysicsSM.Draft.NullEdge.Goal3ChannelRG4
```

Mission:
Compose the four-channel mass-phase surface with the exact RG/period-2 story.
The capstone should say: the finite block has an exhaustive massive/critical/
ghost phase diagram; the landed critical line is the `tau=E=0` slice of the
surface; and the RG critical line is a period-2 invariant rather than a false
fixed point.

Preferred theorem shapes, adapted to the current API:

```lean
namespace MassPhaseRGCapstone

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
      ∧ MassPhase4Channel.witness_massive
      ∧ MassPhase4Channel.witness_critical
      ∧ MassPhase4Channel.witness_ghost := ...

theorem landed_line_is_surface_slice (lam : ℝ) (h : 0 ≤ lam) :
    MassPhase4Channel.Critical lam lam 0 0 := ...

theorem positive_line_soldering_moves_to_massive (lam : ℝ) (h : 0 < lam) :
    MassPhase4Channel.Critical lam lam 0 0
      ∧ MassPhase4Channel.Massive lam lam 0 lam := ...

theorem rg_period_two_matches_critical_slice (lam : ℚ) (h : lam ≠ 0) :
    RGFixedPointStructure.R2 lam lam = (-lam, -lam)
      ∧ RGFixedPointStructure.R2 (-lam) (-lam) = (lam, lam) := ...

theorem phase_rg_verdict :
    MassPhase4Channel.soldering_shifts_mass
      ∧ MassPhase4Channel.aperture_generates_mass
      ∧ RGFixedPointStructure.basin_verdict := ...

end MassPhaseRGCapstone
```

If the Goal3 imports expose stronger exact RG theorems, add a final theorem that
imports them into this capstone. Keep wording honest: period-2 critical line,
not a strict fixed point unless the theorem actually states one. Add guard pins
for headline theorem a x i o m footprints.

Run first:

```text
lake env lean PhysicsSM/Draft/NullEdge/MassPhaseRGCapstone.lean
```

Return solved targets, any statement adjustments, and exact theorem names.
