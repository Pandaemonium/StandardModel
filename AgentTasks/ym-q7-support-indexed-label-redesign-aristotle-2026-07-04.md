# Aristotle harvest: Q7 support-indexed label redesign

```yaml
aristotle:
  project_id: 788f83b4-6ef3-4909-b069-3193fb29bf9d
  task_id: 0f6fbb63-a787-462f-b613-1e333b1886d6
  target_file: PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean
  output_dir: AgentTasks/aristotle-output/ym-q7-support-indexed-label-redesign-20260704
  status: harvested-integrated
```

## Result

Aristotle returned a complete support-indexed carrier redesign for
`PlaquettePolymer`.  The live Q7 file now uses
`label : {p : P // p ∈ support} -> Rlab`, so off-support label values no
longer exist and cannot create extra Lean values for one physical polymer.

Integrated additions:

- `PlaquettePolymer` changed from a total-label subtype abbreviation to a
  structure with support, nonempty/connected witnesses, support-indexed label,
  and support-label nontriviality.
- `PlaquettePolymer.ext_of_support_label` records physical extensionality:
  equal support plus equal labels on that support implies equal polymers.
- `PlaquettePolymer.coeffProduct` now folds over `support.attach`.
- Decidability instances were added for `SupportsOverlap`, `SupportsTouch`,
  and `SupportsOverlapOrTouch` under a decidable touch relation.
- The existing plaquette-system wrappers and Z2 weight/energy theorems remain
  in place, with proofs adapted to the support-indexed carrier.

I did not add Aristotle's broad `import Mathlib`; the existing project import
chain was sufficient for the integrated proof.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateYM.StrongCouplingPolymerMap`
- `lake env lean PhysicsSM/Draft/NullEdge/GateYM.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateYM`
- Placeholder/escape-hatch scan on `StrongCouplingPolymerMap.lean`: no hits.
- Dependency audit:
  - `PlaquettePolymer.ext_of_support_label`: `[propext, Quot.sound]`
  - `PlaquettePolymer.coeffProduct_nonneg`: `[propext, Classical.choice, Quot.sound]`
  - `plaquettePolymerSystem_weight_nonneg`: `[propext, Classical.choice, Quot.sound]`
  - Z2 weight identities: `[propext, Classical.choice, Quot.sound]`

The aggregate GateYM build still replays the known existing warnings in other
draft modules, including the documented Q6 handoff warnings.

## Remaining Q7/Q8 blockers

No volume-uniform `KPCondition` theorem is claimed.  The next Q7/Q8 step must
carry an explicit finite KP sum bound, choose a concrete plaquette connectedness
API, and decide whether the eventual comparison layer needs a separately named
overlap-only polymer system.
