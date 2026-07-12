# Ring-holonomy free-spectrum target

## Objective

Prove the exact first reduced transport-sector statement suggested by Fable's
review on the smallest nondegenerate cycle. Site-local diagonal phases
conjugate the three-site free Hamiltonian and preserve its oriented link
product. The cubic trace reads the real part of that product, and an explicit
fixture has trace `+6` at holonomy `+1` and `-6` at holonomy `-1`.

The all-`N` classification is a named successor. This first rung is deliberately
narrower than the unrestricted two-channel Pluecker ring.
The existing `GaugeClassification` theorem shows that the general connection
also retains local current invariants, so a one-holonomy-only theorem would be
false without an additional homogeneous or reduced-sector hypothesis.

Target:
`AgentTasks/aristotle-standalone/codex-24h-ring-holonomy-spectrum-20260712/RingHolonomySpectrum/Target.lean`.

```yaml
aristotle:
  project_id: deed60d0-1436-43d1-99ca-3fb4aca5ed0c
  task_id: f02f93fb-cb32-4fa4-896d-3c9b0f51c9c0
  target_file: RingHolonomySpectrum/Target.lean
  expected_module: RingHolonomySpectrum.Target
  submission_project: AgentTasks/aristotle-submit/codex-24h-ring-holonomy-spectrum-20260712-project
  output_dir: AgentTasks/aristotle-output/deed60d0-1436-43d1-99ca-3fb4aca5ed0c
  status: landed-and-guarded
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Preflight: the focused target typechecks under the pinned toolchain with exactly
five documented proof holes. The semantic context-pack attempt was made, but
Neo4j at `127.0.0.1:7687` refused the connection; the target is self-contained
and its scope correction is recorded above.

Harvest: all five statements were preserved and proved with the standard
axiom footprint only. `RingHolonomySpectrum` and the successor
`PlueckerRingHolonomyBridge` now build locally. The latter derives holonomy
`-1`, cubic trace `-6`, and non-unitary-equivalence to the trivial sector from
an explicit winding-one primitive-spinor field.
