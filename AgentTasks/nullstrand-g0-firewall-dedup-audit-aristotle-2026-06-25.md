# Aristotle task: G0 firewall, de-duplication, and audit scaffold

Date: 2026-06-25

## Objective

Harden G0 so later capstones can be trusted. This is an engineering/proof-audit
job: identify and, where feasible, patch duplicate core APIs and add lightweight
audit modules that make public declaration drift visible.

## Requested output

- A proposed canonicalization patch or patch plan for duplicate
  `FiniteNullResolution`, `minkowskiInner`, and
  `uniformComponent_bounds_meanNorm`.
- Lightweight audit modules, preferably under `PhysicsSM/NullStrand/Audit/`,
  that `#check` the real public declarations used by G0/G1.
- A transitive import/firewall strategy for the four `PhysicsSM.Draft.*` cores
  imported by trusted NullStrand files.
- If direct patching is too invasive, return exact Lean references, dependency
  risks, and a staged migration plan with smallest safe commits.

## Files to inspect first

- `PhysicsSM/NullStrand/Conventions.lean`
- `PhysicsSM/NullStrand/FiniteCore.lean`
- `PhysicsSM/NullStrand/NullFiber/Barycentric.lean`
- `PhysicsSM/NullStrand/NullLift/FiniteResidualCurrent.lean`
- `PhysicsSM/NullStrand/NullFiber/RegulatorMeanNorm.lean`
- `PhysicsSM/NullStrand/NullFiber/RegulatorNoGo.lean`
- `PhysicsSM/NullStrand/ZigZag/ChiralCurrent.lean`
- `PhysicsSM/NullStrand/ZigZag/QuantumWalk.lean`
- `AgentTasks/null-strand-roadmap-hardening-report-aristotle-2026-06-25.md`

## Constraints

- Do not silently change signs, metric conventions, basis order, or theorem
  meaning.
- Prefer aliases and staged migration if deleting a duplicate would be too
  disruptive.
- Do not introduce new trusted dependencies on draft code without an explicit
  audit guard.

## Aristotle metadata

```yaml
aristotle:
  project_id: f105c00d-a222-4e7a-ab4e-00f242c4d624
  task_id: 067b5d23-5584-433f-abcd-a04bce25ac05
  target_file: PhysicsSM/NullStrand/Audit/Inventory.lean
  expected_module: PhysicsSM.NullStrand.Audit.Inventory
  submission_project: AgentTasks/aristotle-submit/nullstrand-g0-firewall-dedup-audit-20260625-project
  output_dir: AgentTasks/aristotle-output/f105c00d-a222-4e7a-ab4e-00f242c4d624
  status: integrated
```

## 2026-06-25 integration

Integrated the lightweight audit scaffold:

- `PhysicsSM/NullStrand/Audit.lean`
- `PhysicsSM/NullStrand/Audit/Inventory.lean`
- `PhysicsSM/NullStrand/Audit/DraftFirewall.lean`

Also integrated the duplicate public theorem rename in
`PhysicsSM/NullStrand/NullFiber/RegulatorNoGo.lean`:
`expectation_uniformComponent_bounds_meanNorm`.

Copied report:
`AgentTasks/nullstrand-g0-firewall-dedup-audit-report-aristotle-2026-06-25.md`.
