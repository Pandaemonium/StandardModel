# Aristotle proof task: finite CAR creation/annihilation adjointness

Prove both theorem holes in `CARAdjoint/Main.lean` without changing any
definition, theorem statement, or hypothesis.

The target is deliberately isolated from second quantization.  It asks for the
exact occupation-basis adjoint identities

```text
<create_i psi, phi> = <psi, annihilate_i phi>
<annihilate_i psi, phi> = <psi, create_i phi>
```

for every finite linearly ordered mode type with the displayed Koszul sign.

Requirements:

- retain the arbitrary finite linearly ordered type;
- retain the exact complex inner product and sign conventions;
- do not add unitarity, support, symmetry, or matrix hypotheses;
- do not use a compiler-trusting shortcut or add an assumption;
- if a statement is false, return a smallest exact counterexample rather than
  changing it;
- prefer a transparent reindexing proof that can be clean-room integrated into
  `FiniteCARSecondQuantization.lean`.

These lemmas are the intended bridge from landed creation covariance to
annihilation covariance and support locality.  They are finite algebra, not a
claim of interacting quantum-field locality.

```yaml
aristotle:
  project_id: 224621b8-d3ac-4a0b-be34-f4f32b09175e
  target_file: CARAdjoint/Main.lean
  expected_module: CARAdjoint.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-car-adjoint-20260710-project
  output_dir: AgentTasks/aristotle-output/224621b8-d3ac-4a0b-be34-f4f32b09175e
  status: landed
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Disposition

Both identities were proved unchanged, independently compiled in the live
namespace, and integrated into `CARAnnihilationLocality.lean` with axiom pins.
