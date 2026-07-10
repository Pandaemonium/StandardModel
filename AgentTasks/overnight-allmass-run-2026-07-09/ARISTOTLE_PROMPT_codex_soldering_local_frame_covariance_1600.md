# Codex soldering local-frame covariance, 2026-07-09 16:00

aristotle:
  project_id: f34795b7-2aaa-4a5d-8932-9e43f7e7c81c
  target_file: SolderingCovariance/SolderingLocalFrameCovariance.lean
  expected_module: SolderingCovariance.SolderingLocalFrameCovariance
  submission_project: AgentTasks/aristotle-submit/soldering-local-frame-covariance-20260709-1600-project
  output_dir: AgentTasks/aristotle-output/f34795b7-2aaa-4a5d-8932-9e43f7e7c81c
  status: integrated 2026-07-09 16:25 PDT

Harvest note: Aristotle completed the placeholder-free covariance target. The
snapshot passed pinned Lean and was integrated as
`PhysicsSM/Draft/NullEdge/SolderingLocalFrameCovariance.lean`, imported by
`PhysicsSMDraft.lean`, and verified by targeted `lake build`. Local review
removed an unnecessary inverse hypothesis from trace invariance and strengthened
the verdict to expose covariance, refinement, invariant action, holonomy, and
the nonzero witness. The result remains a rational vector-coframe avatar, not a
continuum tetrad or gravity equation.

You are Aristotle. Pro's third-ranked direction proposes soldering as the route
to emergent gravity, with a brutal first kill test: the soldering-gradient defect
must transform as a legitimate geometric object under local frame changes.
Prove the attached focused Mathlib-only finite covariance target.

Target:

```text
SolderingCovariance/SolderingLocalFrameCovariance.lean
```

Context pack:

```text
AgentTasks/context-packs/soldering-local-frame-covariance-20260709-1600-20260709-160142.md
```

## Required payload

1. Prove `edgeDefect_covariant` under independent endpoint frames and the zero
   iff under invertibility.
2. Prove the exact two-edge refinement/composition law.
3. Prove orthogonal defect-norm and soldering-action invariance.
4. Prove closed-loop holonomy-defect covariance and trace invariance under
   conjugation.
5. Prove the explicit rational `2x2` fixture: nonzero defect, nonidentity
   orthogonal frame change, transformed defect, and action exactly one.
6. Add local axiom-footprint guards to every headline theorem.

Use `Matrix.mulVec_mulVec`, `Matrix.mulVec_sub`, `Matrix.mulVec_add`,
`Matrix.dotProduct_mulVec`, trace cyclicity, and finite extensionality lemmas as
appropriate. Preserve statements unless malformed or false; report any repair
explicitly rather than silently weakening it.

## Claim boundary

This is a finite rational coframe/transport covariance theorem. It validates the
first geometric transformation-law gate only. It is not a teleparallel field
equation, Einstein limit, local Lorentz theorem in a continuum manifold, or
physical gravity derivation.

Literature/provenance: Baez-Wise, `Teleparallel Gravity as a Higher Gauge
Theory`, arXiv:1204.4339, was consulted for the coframe/transport/torsion theorem
shape. Translate mathematics only; no external code is imported.

Run first:

```text
lake env lean SolderingCovariance/SolderingLocalFrameCovariance.lean
```
