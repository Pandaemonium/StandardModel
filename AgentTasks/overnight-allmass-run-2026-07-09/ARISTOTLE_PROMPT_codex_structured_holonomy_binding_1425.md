# codex-structured-holonomy-binding-1425-20260709

aristotle:
  project_id: b58daffc-55cd-4ae7-ab85-84870d81f078
  target_file: PhysicsSM/Draft/NullEdge/StructuredHolonomyBindingCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone
  submission_project: AgentTasks/aristotle-submit/codex-frontier-wave-1425-20260709-project
  output_dir: AgentTasks/aristotle-output/b58daffc-55cd-4ae7-ab85-84870d81f078
  status: integrated from in-progress snapshot 2026-07-09 15:29 PDT

You are Aristotle. Follow the structured-closure direction with the strongest
finite theorem supported by the landed APIs: nonzero winding protects low modes,
while the carrier's own nontrivial closure plane produces singlet binding below
threshold and leaves the ground mode as a spectator.

Target file:

```text
PhysicsSM/Draft/NullEdge/StructuredHolonomyBindingCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.WindingLowModes
import PhysicsSM.Draft.NullEdge.IndexProtectionBridge
import PhysicsSM.Draft.NullEdge.Carrier.CarrierClosurePlane
import PhysicsSM.Draft.NullEdge.Goal1Confinement
import PhysicsSM.Draft.NullEdge.Goal1Hadron
```

Context pack:
`AgentTasks/context-packs/structured-holonomy-binding-20260709-20260709-142201.md`.

Required mathematical payload:

1. A general structured-holonomy packet: for `1 <= N` and `0 < w`, the relative
   finite index is exactly `w`, the protected kernel has dimension `w`, and at
   least one protected mode exists; include the `w = 0` negative control.
2. A closure-plane packet proving the carrier's `carrierK` is exactly the landed
   closure curvature, is nonzero/antisymmetric, and leaves mode `0` as a
   spectator while coupling the excited pair.
3. A binding packet using the actual landed carrier closure theorem, not an
   arbitrary inserted defect: under its displayed sorted-spectrum and positive
   coupling hypotheses, the least two-body energy lies strictly below the free
   threshold.
4. An exact nondegenerate witness at `N = 3`, `w = 1`, `d = dW`, `kappa = kW`
   combining: one protected mode, relative index one, carrier curvature
   nonzero, singlet ground energy `-1 < 1`, and the colored control bounded at or
   above threshold. Preserve exact rational/integer values.
5. If feasible, define a small `StructuredClosureBackground` record and state
   the final theorem over it. Otherwise a carefully documented conjunction is
   acceptable.

The key honesty requirement: the winding operator and binding Hamiltonian are
two finite sectors sharing a structured-background interpretation; unless you
construct an actual intertwiner, do not claim winding *causes* the binding. The
result should prove simultaneous protection and binding for an explicit
structured witness, not QCD confinement or continuum topology. Add guard pins
for every headline. No new assumptions or proof placeholders.

Run first:

```text
lake env lean PhysicsSM/Draft/NullEdge/StructuredHolonomyBindingCapstone.lean
```

## Harvest note, 2026-07-09 15:29 PDT

The one-hour snapshot passed pinned Lean unchanged. It preserves the requested
semantic boundary: the winding and binding operators occupy separate sectors
and no causal intertwiner is claimed. The new exact witness combines relative
index one, a protected mode, nonzero excited-plane carrier curvature, singlet
energy `-1 < 1` free threshold, and the colored threshold control. Integrated as
a structured-background packet, not as independent evidence that topology
causes binding; the remote job was canceled after local landing.
