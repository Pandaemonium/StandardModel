# Aristotle job: generic finite unitary Higgs link algebra

Date: 2026-07-16
Work item: `GRAV-ORDER-OPERATOR-001`
Status: integrated

Semantic context pack:
`AgentTasks/context-packs/unitary-higgs-link-20260716-20260716-235059.md`
(SHA-256 `D46218184EE04D0CCB3C7380DE20406494A4C171EEF452544A99E6AAF4FA0AB0`).

## Objective

Generalize the existing one-component Abelian Higgs edge control to a finite
complex multiplet acted on by a `Matrix.unitaryGroup N Complex` connection:

- prove exact preservation of the component norm squared;
- prove endpoint covariance of the transported edge difference;
- prove gauge invariance for arbitrary supplied real edge weights;
- prove zero kinetic cost for every parallel section;
- prove the explicit group-generated parallel-vacuum control.

## Exact target

`AgentTasks/aristotle-standalone/unitary-higgs-link-20260716/UnitaryHiggsLink/Core.lean`

Preserve every public definition and theorem statement. Small private helper
lemmas are welcome. Keep the connection and local gauge fields in
`Matrix.unitaryGroup N Complex`; do not replace them by arbitrary matrices
with detached assumptions or specialize the result back to one component.

## Scope boundary

This is a generic finite `U(n)` link algebra. It does not construct the
physical `SU(2) x U(1)` Higgs representation, hypercharge normalization,
quartic potential, electroweak vacuum, gauge-boson mass matrix, Yukawa
spectrum, coframe response, stress tensor, or continuum Higgs propagator. It
supplies no geometric weights and makes no positivity claim for signed
weights.

## Preflight

`lake env lean` accepts the focused source under the pinned toolchain with
exactly five intended proof-hole warnings and no errors. Source SHA-256:
`B64B840DA5B11299651F21FB20AE4566A7EEB0998C51A3B230C19D3639918D1E`.

## Submission metadata

```yaml
aristotle:
  project_id: 49e42dc1-40d2-44e2-8183-760dc7d62b61
  task_id: d6ee9042-235b-43ca-be43-b501e077e5e4
  target_file: UnitaryHiggsLink/Core.lean
  expected_module: UnitaryHiggsLink.Core
  source_root: AgentTasks/aristotle-standalone/unitary-higgs-link-20260716
  submission_project: AgentTasks/aristotle-submit/unitary-higgs-link-20260716-project
  integration_target: PhysicsSM/Draft/NullEdge/UnitaryHiggsLink.lean
  output_dir: AgentTasks/aristotle-output/49e42dc1-40d2-44e2-8183-760dc7d62b61
  status: integrated
```

Submitted as a focused Mathlib package. Aristotle completed all five targets
without changing their statements. The returned candidate contained no proof
holes or suspicious declarations; its proof-only diff was reviewed and replayed
before porting it to the production namespace.

## Integration and verification

- selected extraction:
  `AgentTasks/aristotle-output/49e42dc1-40d2-44e2-8183-760dc7d62b61/extracted/project-files.tar/unitary-higgs-link-20260716-project_aristotle/UnitaryHiggsLink/Core.lean`
- production module:
  `PhysicsSM/Draft/NullEdge/UnitaryHiggsLink.lean`
- returned candidate replay: passed
- `lake env lean PhysicsSM/Draft/NullEdge/UnitaryHiggsLink.lean`: passed
- `lake build PhysicsSM.Draft.NullEdge.UnitaryHiggsLink`: passed (8026 jobs)
- Lean MCP diagnostics: clean
- all five Lean MCP axiom/source audits: standard three axioms and no warnings
