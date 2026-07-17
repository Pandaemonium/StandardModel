# Aristotle job: gauge-invariant radial FMS observable

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: integrated and verified

Semantic context pack:
`AgentTasks/context-packs/higgs-fms-radial-observable-20260717-20260717-022801.md`
(SHA-256 `07AC27F3D401AB6C12689F16806DFC24D2D1BCE1D5C4FA572E8C2246ED726326`).

## Objective

Formalize the finite algebraic content needed to distinguish the physical,
gauge-invariant radial Higgs observable from a gauge-dependent multiplet
component:

- exact internal-unitary invariance of the radial norm observable;
- the exact FMS expansion into linear and quadratic fluctuations;
- the full four-term weighted connected-form decomposition, which becomes a
  connected correlator when the weights are normalized;
- the nonzero leading radial residue for a nonzero vacuum; and
- support and resolvent transfer from an elementary radial response kernel to
  its leading gauge-invariant composite kernel.

## Scope boundary

This is finite algebra. It does not prove a continuum limit, spectral measure,
pole existence, perturbative suppression of the higher FMS terms, or the
observed Higgs mass. The kernel-transfer result may be described only as a
finite leading-response bridge, not as a physical pole theorem.

## Target

`AgentTasks/aristotle-standalone/higgs-fms-radial-observable-20260717/HiggsFMSRadialObservable/Core.lean`

Preserve every public definition and theorem statement. The returned source
must contain no proof holes or new assumptions.

Preflight: `lake env lean` accepts the focused source with exactly eleven
intended proof-hole warnings and no errors. Source SHA-256:
`20802FA129BBEA6DC5316EF06F60B7F42BB2CA1F7F001FEF2A76193F48335AF6`.

## Provenance

Clean-room finite formalization of the FMS radial-observable expansion. Physics
orientation: Axel Maas, "Observables in Higgsed Theories," arXiv:1410.2740,
and Axel Maas and Rene Sondenheimer, "Gauge-invariant description of the Higgs
resonance and its phenomenological implications," arXiv:2009.06671. No source
implementation or proof text was copied.

## Submission metadata

```yaml
aristotle:
  project_id: 15b4e8fd-452d-4609-b90e-2b03c9f44b07
  task_id: a5cdc344-451e-4683-b3eb-1b06d4abe39a
  target_file: HiggsFMSRadialObservable/Core.lean
  expected_module: HiggsFMSRadialObservable.Core
  source_root: AgentTasks/aristotle-standalone/higgs-fms-radial-observable-20260717
  submission_project: AgentTasks/aristotle-submit/higgs-fms-radial-observable-20260717-project
  integration_target: PhysicsSM/Draft/NullEdge/HiggsFMSRadialObservable.lean
  output_dir: AgentTasks/aristotle-output/15b4e8fd-452d-4609-b90e-2b03c9f44b07
  status: integrated
```

Submitted as a focused, cached Mathlib package at 2026-07-17 02:36 PDT. The
exact submission directory passed
`lake env lean HiggsFMSRadialObservable/Core.lean` with exactly the eleven
intended proof-hole warnings. Aristotle reported task
`a5cdc344-451e-4683-b3eb-1b06d4abe39a` as `QUEUED`; no wait loop was started.

At 2026-07-17 03:11 PDT, a nonredirecting `continue --mode ask --wait`
requested solved targets, exact blockers, statement changes, and whether to
keep waiting or split. The local command timed out after 120 seconds without a
response. The original task remained active; no instruction, split, or
statement change was issued.

## Integration result

Aristotle completed all eleven proof bodies without changing the submitted
public declarations. Integration then found a semantic defect in the prepared
statement: the two intended nonzero-vacuum hypotheses used Boolean `!=` rather
than proposition-level inequality. The production theorem statements were
corrected to `Ne`; both returned proof bodies replayed unchanged under the
stronger intended contracts. The unused `DecidableEq V` assumption was also
removed from `fmsLeadingKernel_resolvent`.

The result was ported to
`PhysicsSM/Draft/NullEdge/HiggsFMSRadialObservable.lean` under the project
namespace. The module docstring records that its radial coordinate is
unnormalized, so `fmsRadialResidue` is a coordinate coefficient rather than an
LSZ or convention-independent physical residue.

Verification:

- `lake env lean PhysicsSM/Draft/NullEdge/HiggsFMSRadialObservable.lean`
- `lake build PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable` (8,026 jobs)
- Lean LSP error diagnostics: empty
- `lean_verify` on `fmsRadialResidue_pos` and
  `fmsLeadingKernel_resolvent`: only `propext`, `Classical.choice`, and
  `Quot.sound`; no source-scan warnings
- targeted pre-commit and `git diff --check`: passed
