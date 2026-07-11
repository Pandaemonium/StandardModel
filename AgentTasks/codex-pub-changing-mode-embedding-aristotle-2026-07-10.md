# Aristotle task: explicit changing-space Fourier-mode embeddings

## Publication role

Paper D currently has fixed-symbol many-step bounds, finite Plancherel, and an
abstract bulk/tail theorem, but no explicit maps between the changing finite
coefficient spaces and one common Hilbert space. This target fills that gap
with expanding integer momentum boxes.

## Target

Prove every theorem in:

`ChangingModeEmbedding/Main.lean`

Run first:

```text
lake env lean ChangingModeEmbedding/Main.lean
```

## Required semantic constraints

- Do not change any theorem statement or replace the cubic box by an abstract
  exhaustion.
- Keep `sample` as restriction and `interpolate` as literal zero padding.
- Preserve the exact energy identity and the strong square-summable tail
  theorem.
- Preserve both explicit controls: zero momentum survives every cutoff and the
  first mode outside the positive x face is killed.
- No compiler-trusting shortcuts, extra assumptions, or proof placeholders in
  the returned file.
- Small helper lemmas are welcome.
- If the convergence theorem blocks, return the largest proof-complete prefix
  and the exact remaining Lean goal without weakening it.

## Composition boundary

Success closes the explicit changing-Hilbert-space coefficient-map rung. It
does not yet prove continuum `R^3` sampling, live-walk Fourier conjugacy, a
Sobolev rate, or Dirac-flow convergence. Those require composition with the
separate live DFT job and an analytic sampling theorem.

## Context

- `AgentTasks/context-packs/codex-pub-changing-lattice-20260710-183330.md`
- `PhysicsSM/Draft/NullEdge/ChangingLatticePDECore.lean`
- `PhysicsSM/Draft/NullEdge/FiniteTorus3Plancherel.lean`
- `PhysicsSM/Draft/NullEdge/CompactSupportL2WalkBridge.lean`

## Metadata

```yaml
aristotle:
  project_id: bad1dc90-38a3-4653-b950-56a432f3a59f
  task_id: pending
  target_file: ChangingModeEmbedding/Main.lean
  expected_module: ChangingModeEmbedding.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-changing-mode-embedding-20260710-project
  output_dir: AgentTasks/aristotle-output/bad1dc90-38a3-4653-b950-56a432f3a59f
  status: integrated
```
