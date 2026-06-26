# Aristotle semantic context pack

Generated: 2026-06-25T16:17:20
Query: `NullStrand audit automation manifest declaration inventory duplicate names draft import firewall capstone assumption whitelist`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/null-edge-grand-strategy-audit-report-2026-06-23.md` [Null-edge grand strategy and physics-alignment audit]

Score: `0.732`

```text
# Null-edge grand strategy and physics-alignment audit

Date: 2026-06-23

Source: Aristotle project `4153d0e4-480f-4002-9ebb-64461384197a`, requested as a
no-build strategy/audit job over the strengthened program, publication plan,
interaction ontology, overnight plan, and integration notes.
```

### 2. `AgentTasks/null-edge-grand-strategy-v2-output.md` [Cluster H — Definition-consolidation semantic audit (`NullEdge/Core`)]

Score: `0.731`

```text
### Cluster H — Definition-consolidation semantic audit (`NullEdge/Core`)

**Module:** design note + `PhysicsSM/Draft/NullEdgeRoadmap/NullEdgeCoreAudit.lean`
(API proposal only, no landed retypes).

**Purpose.** `CSpinor`, `rankOneHermitian`, `spinorWedge`, `complexAbsSq`,
`blochDensity`/`blochVector`, `visibleReducedDensity` are **duplicated** across
`Spinor.PluckerMass`, `NullEdgeCoreAristotle`, `NullEdgeCelestialMixedness`,
`NullEdgeCelestialMomentWrapper`, `NullEdgeDecoherenceChannel`, and the Gram
modules. Before more algebra, propose one canonical home (re-exporting the
trusted `Spinor.PluckerMass` names) and a dependency graph, so later jobs do not
re-type banked decls. Per the loop plan's "net rule": never submit a proof job
whose target decl will be renamed by a pending consolidation.

**Deliverable.** Module API + dep graph note, **no code rewrite**. Adopt the
canonical names in a single later refactor once Clusters A/E pin their shapes.

**Risk.** Low (design only). The trap is doing it *too early* and forcing reproofs
— scope it to `SuperDirac`/`OrderComplex`/`BivectorB`/`DiamondSource`
structures that have no trusted home yet, and treat the spinor/density names as
a documented proposal.
```

### 3. `AgentTasks/null-edge-parallel-loop-execution-2026-06-22.md` [Ranked next targets from the audit]

Score: `0.712`

```text
### Ranked next targets from the audit

```text
uniformSuppression_vs_everpresentLambda_tension
visiblePluckerMass_nonzero_of_noncollinear
boundaryExact_iff_invisible_to_curvatureDefects
diamondResidualVariance_scales_with_cellArea
bfClosed_source_is_exactly_image
recoverabilityGap_controls_sourceVisibility
```
```

### 4. `AgentTasks/null-edge-autonomous-aristotle-loop-plan-2026-06-21.md` [Job ledger]

Score: `0.712`

```text
| - |
| strategy-v2 | complete strengthened-program proof scaffold | strategy/scaffold output | `ba66d47f-68d3-4752-b6a0-ac1f10830f5d` | STRATEGY-ONLY | current plan docs | roadmap output copied; no Lean trust claim |
| physics-audit | semantic confidence scoring and comment/docstring suggestions | audit/comment output | `51bf086e-37da-441c-9657-75f15f6036c7` | INTEGRATED | current plan docs, null-edge theorem surface | audit report copied; comment-only patches locally checked |

Keep the table current: every status change updates the matching row in the same
edit that updates the task note. Independent rows (no shared `deps`) may run as
concurrent Aristotle jobs up to the pipeline cap; dependent rows wait for their
`deps` to reach `INTEGRATED`.
```

### 5. `AgentTasks/hamming-e8-aristotle-bridge-next-wave-2026-05-13.md` [A10: Root import hygiene and draft split]

Score: `0.711`

```text
## A10: Root import hygiene and draft split

Profile: core, engineering-heavy but useful for Aristotle if it can repair
imports automatically.

Write scope:

```text
PhysicsSM.lean
```

Optional new root:

```text
PhysicsSMDraft.lean
```

Goal: the root `PhysicsSM.lean` currently imports some `PhysicsSM.Draft`
modules, including draft files with intentional `sorry`s. For publication,
the default root should either:

- import only trusted modules, or
- explicitly be documented as a development root rather than a trusted root.

Tasks:

1. Move draft imports to `PhysicsSMDraft.lean`, if that is compatible with CI.
2. Keep `PhysicsSM.lean` as the trusted no-sorry root.
3. Make sure default target behavior matches the repository's intended CI.

Minimum useful result:

- A clean separation between trusted theorem imports and draft frontier imports.

This is not a proof-search job, so it should be lower priority than A1-A9.
```

### 6. `AgentTasks/null-edge-parallel-loop-execution-2026-06-22.md` [Next action]

Score: `0.710`

```text
### Next action

- After a spacing interval, check project
  `bd449f16-805c-411d-af73-e8c21e374308`; integrate the returned no-go cluster
  into `PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore` (or a new module)
  if statement identity is preserved, then refill from the audit's next ranked
  target.
```

### 7. `AgentTasks/null-edge-autonomous-run-postmortem-2026-06-23.md` [Next Theorem Targets]

Score: `0.707`

```text
### Next Theorem Targets

The next high-value proof jobs should come from the audit list:

1. `visiblePluckerMass_nonzero_of_noncollinear`
2. `boundaryExact_iff_invisible_to_curvatureDefects`
3. `diamondResidualVariance_scales_with_cellArea`
4. `uniformSuppression_vs_everpresentLambda_tension`
5. `recoverabilityGap_controls_sourceVisibility`

The first is already partially represented by the out-of-scope Cycle 19 job and
should be reconciled before resubmitting anything nearby.
```

### 8. `AgentTasks/null-edge-bundle-dirac-plucker-core-aristotle-2026-06-21.md` [Integration]

Score: `0.707`

```text
## Integration

Aristotle reported the task as `COMPLETE_WITH_ERRORS`, but the extracted
`ARISTOTLE_SUMMARY.md` states that all eight target holes were closed and that
the standalone target file validated. Local verification confirmed:

```text
lake env lean AgentTasks\aristotle-output\7bb9ddb0-2798-45ac-83fb-c94aa224243d\extracted\project-files.tar\null-edge-bundle-dirac-plucker-core-20260621-project_aristotle\NullEdgeBundleDiracPluckerCore\Finite.lean
```

Integrated 2026-06-21 as:

```text
PhysicsSM/Draft/NullEdgeBundleDiracPluckerCore.lean
```

The repo-native module imports the trusted
`PhysicsSM.Spinor.PluckerMass.fin_bundle_plucker_mass_identity` and the draft
Dirac slash core, then proves the Weyl-coordinate extraction and the composed
bridge theorem:

```text
chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass
```

Verification:

```text
lake env lean PhysicsSM\Draft\NullEdgeBundleDiracPluckerCore.lean
lake build PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore
lake env lean PhysicsSMDraft.lean
python Scripts\check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM\Draft\NullEdgeBundleDiracPluckerCore.lean
git diff --check -- PhysicsSM\Draft\NullEdgeBundleDiracPluckerCore.lean PhysicsSM\Draft\NullEdgeDiracMassShellProjectorsCore.lean PhysicsSMDraft.lean AgentTasks\null-edge-dirac-mass-shell-projectors-core-aristotle-2026-06-21.md
```
```

## Scoped paper hits

No paper hits returned.
