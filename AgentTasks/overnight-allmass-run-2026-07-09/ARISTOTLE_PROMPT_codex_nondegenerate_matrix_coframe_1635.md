# Codex nondegenerate matrix coframe geometry, 2026-07-09 16:35

aristotle:
  project_id: 96135427-97fc-4cce-86bd-43bbc0aedf55
  target_file: MatrixCoframe/NondegenerateSolderingGeometry.lean
  expected_module: MatrixCoframe.NondegenerateSolderingGeometry
  submission_project: AgentTasks/aristotle-submit/codex-nondegenerate-matrix-coframe-20260709-1635-project
  output_dir: AgentTasks/aristotle-output/96135427-97fc-4cce-86bd-43bbc0aedf55
  status: submitted 2026-07-09 16:36 PDT

You are Aristotle. The vector-valued finite soldering defect has passed its
first covariance and refinement gate. Prove the attached Mathlib-only upgrade
to an actual square, nondegenerate matrix coframe.

Target:

```text
MatrixCoframe/NondegenerateSolderingGeometry.lean
```

Context pack:

```text
AgentTasks/context-packs/nondegenerate-matrix-coframe-20260709-1630-20260709-163241.md
```

## Required payload

1. Prove that invertible internal frame changes preserve and reflect
   nondegeneracy of the coframe determinant.
2. Prove induced-metric invariance under `g^T eta g = eta` and coframe-volume
   invariance under `det g = 1`.
3. Prove matrix-coframe defect covariance and exact two-edge refinement.
4. Prove invariance of `trace(T^T eta T)` and of the transported edge action
   under an `eta`-orthogonal target frame.
5. Prove the exact rational `1+1` witness: the `3-4-5` boost is nonidentity,
   determinant one, and Lorentz; both endpoint coframes are nondegenerate;
   the defect is nonzero; and its action before and after the boost is one.
6. Strengthen the final verdict to expose the generic covariance/refinement
   theorems as well as the fixture, and add build-enforced axiom-footprint
   guard pins to every headline result.

Use determinant multiplicativity, transpose multiplication, trace cyclicity,
matrix extensionality, and finite `simp`/`norm_num` for the fixture. Preserve
every valid statement; report and repair malformed statements explicitly.

## Scientific boundary and provenance

Baez-Wise, arXiv:1204.4339, states that a nondegenerate coframe pulls back the
internal metric and anchors the teleparallel theorem shape. Full-text Neo4j
search located the relevant coframe/nondegeneracy and torsion sections. This
target is still finite rational linear algebra: it does not construct a
continuum tetrad bundle, identify the carrier E-slot with torsion, or derive a
gravitational field equation. Translate mathematics only; no external code is
imported.

Run first:

```text
lake env lean MatrixCoframe/NondegenerateSolderingGeometry.lean
```
