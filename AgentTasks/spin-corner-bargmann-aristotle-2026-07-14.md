# Aristotle job: spin-corner Bargmann calculus (spiral-layer wave 1, job B)

Date: 2026-07-14
Requested by: user ("submit a round of Aristotle jobs" for the spiral-layer
targets from the 2026-07-14 zigzag-vs-spiral analysis session).

```yaml
aristotle:
  project_id: 48ee063f-9478-4817-beae-1eb531c5f520
  task_id: 677373f2-3641-4624-b3c5-2f00506d6db5
  target_file: AgentTasks/aristotle-standalone/spin-corner-bargmann-20260714/SpinCornerCore/SpinCornerBargmann.lean
  expected_module: SpinCornerCore.SpinCornerBargmann
  submission_project: AgentTasks/aristotle-submit/spin-corner-bargmann-20260714-project
  source_root: AgentTasks/aristotle-standalone/spin-corner-bargmann-20260714
  output_dir: AgentTasks/aristotle-output/48ee063f-9478-4817-beae-1eb531c5f520
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/SpinCornerBargmannAristotle.lean
```

## Goal

Pin down, at the polynomial level (no unit-norm hypotheses except where
stated), the orientation structure of the spin-coherent corner calculus:
the general Bargmann three-cycle
tr(P(a)P(b)P(c)) = (1 + a.b + b.c + c.a + i a.(b x c))/4, its imaginary
part = oriented triple product / 4 (the unique T-odd invariant), planar =>
real (zigzag histories are CP-inert), reversal = complex conjugation (CPT),
antipodal annihilation for unit directions (no same-chirality hairpins), the
two-channel corner split summing to 1, and the handed witness (1 pm i)/4 for
x -> y -> z and its mirror.

## Statements (11, all placeholder-proof targets, do not weaken)

`pauli_sq`, `pair_trace`, `bargmann_three_cycle`, `bargmann_im`,
`planar_cp_inert`, `reversal_conj`, `antipodal_annihilation`,
`corner_channel_sum`, `witness_handed`, `witness_mirror`.

## Preflight

- Statements typechecked 2026-07-14 via
  `lake env lean AgentTasks/aristotle-standalone/spin-corner-bargmann-20260714/SpinCornerCore/SpinCornerBargmann.lean`
  (only placeholder warnings).
- Focused standalone package (Mathlib-only imports); conventions declared in
  the module docstring (standard Pauli matrices; raw `Fin 3 -> R` triples).
- Hand-verified: three-cycle formula at the tetrahedral frame reproduces the
  parent repo's landed trace i*r/3 (r = 1/sqrt 3); witness x,y,z gives
  (1 + i)/4 (all dots 0, triple = 1).

## Semantic review checklist (for integration)

- The three-cycle and pair-trace identities must remain hypothesis-free
  (polynomial); only `antipodal_annihilation` carries `dot a a = 1`.
- `triple` must stay the standard right-handed a.(b x c); a sign flip here
  silently flips the CP-odd orientation convention.
- Reversal statement must use `star` (conjugation), not transpose.
- Axiom audit per theorem; no compiled-evaluator decision tactic.

## Integration plan

Copy proved file to `PhysicsSM/Draft/NullEdge/SpinCornerBargmannAristotle.lean`,
cross-reference `TetrahedralSpinProjectorPath.lean` (tetrahedral witness as a
special case) and `GateI1/MassCoinBridge.lean` (flip channel), run targeted
`lake env lean`, placeholder scan, axiom audit.

## Integration result

The returned file preserved every theorem signature and was copied to the
standalone target.  A project-namespaced version was promoted to
`PhysicsSM/Draft/NullEdge/SpinCornerBargmannAristotle.lean`; its targeted
`lake env lean` and `lake build` checks pass.  The placeholder scan is clean,
and every target depends only on `propext`, `Classical.choice`, and
`Quot.sound`.
