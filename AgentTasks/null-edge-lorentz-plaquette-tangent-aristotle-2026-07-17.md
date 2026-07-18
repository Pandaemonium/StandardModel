# Aristotle job: exact Lorentz plaquette tangent

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-007`

```yaml
aristotle:
  project_id: f0bc30e8-90c8-4e67-b60f-191c92a95f54
  task_id: b96861ca-12ff-460e-b123-f06995cf2750
  target_file: LorentzPlaquetteTangent/Target.lean
  expected_module: LorentzPlaquetteTangent.Target
  submission_project: AgentTasks/aristotle-submit/null-edge-lorentz-plaquette-tangent-20260717-project
  output_dir: AgentTasks/aristotle-output/f0bc30e8-90c8-4e67-b60f-191c92a95f54
  status: integrated
```

## Target

Derive the exact right-logarithmic tangent of a group-valued Lorentz
plaquette, prove that it remains in the six-dimensional Lorentz Lie algebra,
and recover the existing additive plaquette curl at identity transport.

## Convention lock

- metric: mostly-minus `(+,-,-,-)`;
- bivector basis: `(12,13,23,01,02,03)`;
- link tangent: right-trivialized, `delta U = U hat(X)`;
- plaquette: `H=A B^{-1}`;
- curvature tangent: `delta H H^{-1}`.

The matrix-valued tangent must pass through the exact six-coordinate Lorentz
Lie-algebra bridge before it is paired with a Palatini face bivector.

## Inputs

- `AgentTasks/aristotle-standalone/null-edge-lorentz-plaquette-tangent-20260717/LorentzPlaquetteTangent/Target.lean`
- `AgentTasks/aristotle-standalone/null-edge-lorentz-plaquette-tangent-20260717/ARISTOTLE_PROMPT.md`
- `AgentTasks/context-packs/lorentz-plaquette-tangent-20260717-20260717-183054.md`
- `PhysicsSM/Draft/NullEdge/LorentzBivectorLieAlgebraBridge.lean`
- `PhysicsSM/Draft/NullEdge/FinitePeriodicLinkConnection.lean`

## Preflight status

The standalone source passed under the main repository's pinned Mathlib
toolchain with exactly four intended proof-hole warnings and no other
diagnostics:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-lorentz-plaquette-tangent-20260717/LorentzPlaquetteTangent/Target.lean
```

The focused source contains no admission, assumption-declaration, or unsafe
tokens. A semantic context pack was generated against the existing local
document and paper indexes at the path listed above.

## Submission

Submitted on 2026-07-17 as project
`f0bc30e8-90c8-4e67-b60f-191c92a95f54`, task
`b96861ca-12ff-460e-b123-f06995cf2750`. Initial state was project `RUNNING`,
task `QUEUED`.

The preparation helper reported four proof-hole lines, zero admission tokens,
zero assumption-declaration tokens, and zero unsafe tokens. Aristotle was told
to preserve the exact product order and signs and to report a counterexample
or corrected formula rather than silently modifying a false target.

## Harvest and integration

Aristotle completed all four targets without changing any statement:

- `rightTrivializedPlaquetteVariation_eq_adjointSum`;
- `lorentzAdjoint_mem`;
- `rightTrivializedPlaquetteVariation_mem`;
- `rightTrivializedPlaquetteVariation_identity`.

The final project archive is
`AgentTasks/aristotle-output/f0bc30e8-90c8-4e67-b60f-191c92a95f54/result.zip`.
The proof was reviewed against the live link ordering, mostly-minus metric,
bivector basis, and right-trivialized variation convention, then integrated as
`PhysicsSM/Draft/NullEdge/LorentzPlaquetteTangent.lean`. The live module reuses
the existing generic link/plaquette substrate and Lorentz-generator bridge,
contains no proof placeholders or native evaluator shortcuts, and has
build-enforced axiom guards.

The result is an exact nonlinear response identity, not yet a proof that the
right-logarithmic response integrates globally to the desired scalar Palatini
action. That action/integrability question and Levi-Civita selection are the
next gates.

## Verification

```text
lake env lean PhysicsSM/Draft/NullEdge/LorentzPlaquetteTangent.lean
lake build PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
```

Both commands passed.
