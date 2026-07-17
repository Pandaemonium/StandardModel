# Aristotle job: shell-angular dual recovery

Date: 2026-07-17  
Work item: `GRAV-ORDER-OPERATOR-001`  
Status: integrated and verified

Semantic context pack:
`AgentTasks/context-packs/shell-angular-dual-recovery-20260717-20260717-001106.md`
(SHA-256 `0B21995F070EDA4A099FC01AB68E6003DE9F408F263829B171EB510B2427FE66`).

## Objective

Close the exact linear-algebra bridge from the marked-shell `1+3` support
architecture to a four-component Higgs derivative extractor:

- prove injectivity of the time-plus-three-space real sample map;
- express injectivity as a trivial-kernel theorem;
- obtain a real linear left inverse without adding assumptions;
- prove exact recovery of arbitrary complex derivative components by applying
  that real recovery to real and imaginary parts.

## Exact target

`AgentTasks/aristotle-standalone/shell-angular-dual-recovery-20260717/ShellAngularDualRecovery/Core.lean`

Preserve every public definition and theorem statement. Small private helper
lemmas are welcome. The final source must contain no proof holes or new
assumptions.

## Scope boundary

The finite support sets, anchor, and probe functions are supplied. This job
does not construct a causal-order shell selector, prove conditioning or
stability, produce continuum coordinates, identify a metric or coframe, or
derive stress-energy. It proves only that the displayed support separation and
nondegeneracy hypotheses suffice for exact four-component sampling and complex
recovery.

## Preflight

`lake env lean` accepts the focused source under the pinned toolchain with
exactly six intended proof-hole warnings and no errors. Source SHA-256:
`262D515CCD9B6F0A87C56E00A157E27A3D212F3927B7200D82CD33EC5267765E`.

## Submission metadata

```yaml
aristotle:
  project_id: 1b345541-a6c3-4ac1-b007-8d1bd9bf37ca
  task_id: dc627235-56c5-4b45-acd6-1275ace3c829
  target_file: ShellAngularDualRecovery/Core.lean
  expected_module: ShellAngularDualRecovery.Core
  source_root: AgentTasks/aristotle-standalone/shell-angular-dual-recovery-20260717
  submission_project: AgentTasks/aristotle-submit/shell-angular-dual-recovery-20260717-project
  output_dir: AgentTasks/aristotle-output/1b345541-a6c3-4ac1-b007-8d1bd9bf37ca
  integration_target: PhysicsSM/Draft/NullEdge/ShellAngularDualRecovery.lean
  status: integrated
```

Submitted as a focused Mathlib package at 2026-07-17 00:14 PDT. Aristotle
reported the task as `QUEUED`; no wait loop was started.

At 00:47 PDT the task reported all six targets complete. The returned diff
changed only the six intended proof bodies (28 insertions, 6 proof-hole
removals), preserved every public definition and theorem statement, and added
no assumptions. The candidate and namespaced production port both replayed
under the pinned toolchain. The production module has build-enforced
assumption-footprint guards on injectivity, left-inverse existence, and real/
imaginary complex recovery.

The production module additionally proves a five-point nonvacuity control:
one anchor, one radial time witness, and three shell basis points satisfy all
rank hypotheses and recover every complex `1+3` derivative vector. This
control was added locally after the statement-preserved Aristotle port.

## Verification

- `lake env lean` on the returned candidate
- `lake env lean PhysicsSM/Draft/NullEdge/ShellAngularDualRecovery.lean`
- `lake build PhysicsSM.Draft.NullEdge.ShellAngularDualRecovery` (8026 jobs)
- strict forbidden-token scan on both candidate and production source
