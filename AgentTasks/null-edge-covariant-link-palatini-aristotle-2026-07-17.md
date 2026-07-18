# Aristotle job: covariant link/face Palatini adjoint

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-002`

```yaml
aristotle:
  project_id: b27a3040-c4d7-4fb3-95b9-a73c0e7f1c68
  task_id: 84e00c85-49eb-493a-abfd-f197d84ae0ab
  target_file: CovariantLinkPalatini/Target.lean
  expected_module: CovariantLinkPalatini.Target
  submission_project: AgentTasks/aristotle-submit/null-edge-covariant-link-palatini-20260717-project
  output_dir: AgentTasks/aristotle-output/b27a3040-c4d7-4fb3-95b9-a73c0e7f1c68
  status: complete; local proof integrated; Aristotle comparison harvested
```

## Target

Generalize the scalar additive link/face Palatini variation to a finite real
fiber with arbitrary link transport. The exact predecessor operator is the
transpose adjoint of the transport matrix. Prove periodic covariant summation
by parts and the full local Euler pairing.

## Inputs and constraints

- `AgentTasks/aristotle-standalone/null-edge-covariant-link-palatini-20260717/CovariantLinkPalatini/Target.lean`
- `AgentTasks/aristotle-standalone/null-edge-covariant-link-palatini-20260717/ARISTOTLE_PROMPT.md`
- `AgentTasks/context-packs/null-edge-periodic-palatini-euler-20260717-140845.md`
- `PhysicsSM/Draft/NullEdge/FinitePeriodicLinkPalatiniVariation.lean`

The theorem statements use an ordinary Euclidean real fiber pairing. No
orthogonality assumption is needed because the backward operator explicitly
uses the algebraic transpose. A later Lorentzian bridge must replace this with
the selected Krein adjoint and document that convention separately.

## Submission

The focused package passed the pinned-toolchain preflight with exactly the two
intended proof handoffs. It was submitted as project
`b27a3040-c4d7-4fb3-95b9-a73c0e7f1c68`, task
`84e00c85-49eb-493a-abfd-f197d84ae0ab`; initial task status was `QUEUED` and
the first follow-up check reported `IN_PROGRESS`.

## Local completion

While Aristotle remained in progress, both submitted target statements were
proved locally without changing any definition or theorem statement. The
proof factors through the finite transpose-adjoint pairing, periodic site
reindexing, two ordered curl branches, and finite sum rotation. The standalone
target was then strengthened with:

- site/direction/fiber-component probes;
- stationarity if and only if every transported Euler component vanishes;
- reduction of antisymmetric face weights to covariant backward divergence;
- identity transport with site-constant fiber face data as a stationary
  control.

The completed source was integrated as
`PhysicsSM/Draft/NullEdge/FinitePeriodicCovariantLinkPalatiniVariation.lean`
with build-enforced axiom guards. No Aristotle-generated proof was used in the
live integration; the running job will be harvested as an independent
comparison.

## Verification

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-covariant-link-palatini-20260717/CovariantLinkPalatini/Target.lean
lake env lean PhysicsSM/Draft/NullEdge/FinitePeriodicCovariantLinkPalatiniVariation.lean
lake build PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
```

All three commands passed with no proof handoffs in either completed source.

After local completion, an `instruct` message asked Aristotle to stop proof
search, preserve any independent helper lemmas, report unresolved targets, and
package the project for comparison.

## Aristotle harvest

Task `84e00c85-49eb-493a-abfd-f197d84ae0ab` completed after approximately
42 minutes. The downloaded package is stored under
`AgentTasks/aristotle-output/b27a3040-c4d7-4fb3-95b9-a73c0e7f1c68/`.
Aristotle proved both submitted targets without changing their statements and
returned two compact helper lemmas for fiber-pair subtraction and pairing
against finite sums. Its proof is independent of the locally integrated proof:
the periodic adjoint is discharged by a direct `Finset.sum_bij`, and the full
Euler pairing by explicit product-sum reindexing.

The returned `Target.lean` has no proof handoff or executable trust shortcut.
It passed this repository's pinned toolchain directly:

```text
lake env lean AgentTasks/aristotle-output/b27a3040-c4d7-4fb3-95b9-a73c0e7f1c68/extracted/null-edge-covariant-link-palatini-20260717-project_aristotle/CovariantLinkPalatini/Target.lean
```

The only diagnostic was an unused `DecidableEq Site` section variable. No
Aristotle source was copied into the live module because the local proof was
already complete, clearer in the project API, and strengthened by the
stationarity and nonvacuity theorem chain.
