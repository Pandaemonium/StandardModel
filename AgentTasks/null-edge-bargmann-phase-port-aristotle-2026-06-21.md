# Aristotle task: Bargmann phase port

Date: 2026-06-21

## Objective

Port the finite Bargmann/Pancharatnam phase algebra to the canonical trusted
Pluecker primitives in `PhysicsSM.Spinor.PluckerMass`.

Target file:

```text
NullEdgeBargmannPhasePort/Finite.lean
```

Expected module:

```text
NullEdgeBargmannPhasePort.Finite
```

Context pack:

```text
AgentTasks/context-packs/null-edge-bargmann-phase-port-20260621-181804.md
```

## Theorem targets

```lean
rankOneHermitian_eq_rankOneKetBra_self
plucker_lagrange_identity
trace_rankOneKetBra
rankOneKetBra_mul
rankOneProjector_mul
bargmannTripleTrace_rankOne
normalized_plucker_eq_one_sub_overlap
```

## Why this matters

The phase draft currently has local copies of the Pluecker primitives. The
core-definition consolidation roadmap says to move phase algebra onto the
trusted `complexAbsSq`, `spinorWedge`, and `rankOneHermitian` definitions
before developing closed-loop Pancharatnam phase invariance.

## Constraints

- Keep this package focused: it may import the copied trusted
  `PhysicsSM.Spinor.PluckerMass` file, but no broader `PhysicsSM` tree.
- Do not weaken theorem statements silently.
- Preserve the canonical Pluecker wedge and squared-modulus definitions.
- Final target file should contain no proof holes or escape-hatch declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-bargmann-phase-port-20260621/NullEdgeBargmannPhasePort/Finite.lean
```

Result before submission: passed with exactly seven intended proof-hole
warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: d3afe42b-4efc-47bc-beb5-bec045c00cc8
  task_id: c1ae7bb0-1320-453a-a094-a864fba1152e
  target_file: NullEdgeBargmannPhasePort/Finite.lean
  expected_module: NullEdgeBargmannPhasePort.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-bargmann-phase-port-20260621-project
  output_dir: AgentTasks/aristotle-output/d3afe42b-4efc-47bc-beb5-bec045c00cc8
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`d3afe42b-4efc-47bc-beb5-bec045c00cc8`; `aristotle tasks` reported task
`c1ae7bb0-1320-453a-a094-a864fba1152e` as `QUEUED`.

## Result analysis

Fetched and integrated 2026-06-21. Aristotle completed all seven theorem
targets without changing the intended statements:

- `rankOneHermitian_eq_rankOneKetBra_self`
- `plucker_lagrange_identity`
- `trace_rankOneKetBra`
- `rankOneKetBra_mul`
- `rankOneProjector_mul`
- `bargmannTripleTrace_rankOne`
- `normalized_plucker_eq_one_sub_overlap`

The integrated draft module is:

```text
PhysicsSM/Draft/NullEdgeBargmannPhasePort.lean
```

The main mathematical gain is a canonical phase companion layer over the
trusted Pluecker API: Hermitian overlap, rank-one ket-bra/projector algebra,
the two-spinor Lagrange identity, the Bargmann/Pancharatnam triple trace, and
the normalized complement relation between Pluecker spread and Hermitian
overlap.

Local verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeBargmannPhasePort.lean
lake build PhysicsSM.Draft.NullEdgeBargmannPhasePort
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft PhysicsSM/Draft/NullEdgeBargmannPhasePort.lean
```

All passed. A separate `rg` scan of the integrated file found no placeholder or
escape-hatch tokens.
