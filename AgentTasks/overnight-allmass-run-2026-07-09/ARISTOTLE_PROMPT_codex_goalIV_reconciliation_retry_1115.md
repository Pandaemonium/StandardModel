# codex-goalIV-reconciliation-retry-1115-20260709

aristotle:
  project_id: 0de5b7d5-5164-4c40-a792-a3472566d8f7
  target_file: PhysicsSM/Draft/NullEdge/GoalIVReconciliationCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.GoalIVReconciliationCapstone
  submission_project: AgentTasks/aristotle-submit/codex-ambitious-wave-1115-20260709-project
  output_dir: pending
  status: submitted 2026-07-09

You are Aristotle, retrying the Goal IV reconciliation capstone after the
previous broad job stalled. Keep the target smaller: bundle the finite
variational route and the finite source/equation-of-state route, but do not
claim the routes are identical unless an imported theorem literally proves it.

Target file:

```text
PhysicsSM/Draft/NullEdge/GoalIVReconciliationCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.GravityUnificationCapstone
import PhysicsSM.Draft.NullEdge.UnifiedActionVariation
import PhysicsSM.Draft.NullEdge.UnifiedActionCapstone
import PhysicsSM.Draft.NullEdge.TeleparallelWEPCapstone
import PhysicsSM.Draft.NullEdge.HolographicResourceCapstone
import PhysicsSM.Draft.NullEdge.MinkowskiConvention
```

Mission:

1. `variational_route_capstone`: bundle
   `UnifiedActionVariation.one_action_verdict`, `action_closed_form`,
   `gravity_equation`, `matter_equation`, `coupled_stationary_point`, and
   `derivatives_distinct`.
2. `source_equation_route_capstone`: under explicit channel-blind and
   stationary hypotheses, bundle `GravityUnificationCapstone` plus
   `TeleparallelWEPCapstone.teleparallel_source_capstone`.
3. `s7_nonvacuity_and_boundary`: bundle nonzero gravity/matter witnesses,
   holographic boundary/resource nonvacuity, and Minkowski convention notes.
4. `finite_s7_reconciliation_verdict`: state the honest finite Section 7
   reconciliation boundary.

Preferred theorem names:

```lean
namespace GoalIVReconciliationCapstone

theorem variational_route_capstone : ...
theorem source_equation_route_capstone
    {n : Nat} {G K : Matrix (Fin n) (Fin n) C} {kappa : C}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hstat : WEPActionBridge.Stationary G K) : ...
theorem s7_nonvacuity_and_boundary : ...
theorem finite_s7_reconciliation_verdict
    {n : Nat} {G K : Matrix (Fin n) (Fin n) C} {kappa : C}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hstat : WEPActionBridge.Stationary G K) : ...

end GoalIVReconciliationCapstone
```

Inline exact imported propositions when theorem names are proof terms. Add
guard pins. Run:

```text
lake env lean PhysicsSM/Draft/NullEdge/GoalIVReconciliationCapstone.lean
lake build PhysicsSM.Draft.NullEdge.GoalIVReconciliationCapstone
```

Return theorem names, exact statement adaptations, axiom footprints, and the
semantic caveat.
