# Aristotle task: null-factorization spin fiber

Date: 2026-07-09
Owner: Codex
Hat: Builder / Assassin

## Objective

Prove the finite matrix theorem that an invertible complex `2 x 2` factor of a
fixed positive momentum matrix has a right `U(2)` fiber, and that fixing its
determinant reduces the fiber to `SU(2)`. Close every proof hole in:

`SpinFiber/Factorization.lean`

Run the narrow command first:

```text
lake env lean SpinFiber/Factorization.lean
```

The input file already typechecks modulo its executable proof holes. Preserve
all theorem statements. Small helper lemmas are welcome. Do not replace any
proof by an escape hatch or compiler-trusted finite decision procedure.

## Mathematical route

Given two-sided inverse `L0` for `M0`, set `U = L0 * M`. From

```text
M M^H = M0 M0^H
```

derive

```text
U U^H = L0 M M^H L0^H = (L0 M0)(L0 M0)^H = 1.
```

Use `Matrix.mem_unitaryGroup_iff` for membership. Recover `M = M0 U` with the
right-inverse hypothesis, and prove uniqueness by multiplying on the left by
`L0`. For the determinant-fixed theorem, combine determinant multiplicativity,
`det M = det M0`, and `det M0 != 0` to prove `det U = 1`, then use
`Matrix.mem_specialUnitaryGroup_iff`.

The explicit witness uses

```text
M0 = diag(2,1),  L0 = diag(1/2,1),  U = [[0,1],[-1,0]].
```

It must prove both equal momentum Gram and nontriviality; this is the mandatory
non-degeneracy fixture.

## Honest scientific scope

This theorem identifies the algebraic `U(2)`/`SU(2)` factorization fiber behind
the massive spinor-helicity little group. It does not yet construct irreducible
spin representations, Wigner rotations, exchange statistics, or a
spin-statistics theorem. Do not strengthen the prose beyond the kernel result.

## Context

- Semantic pack:
  `AgentTasks/context-packs/null-factorization-spin-fiber-20260709-20260709-212927.md`
- Reference API: Mathlib `Matrix.unitaryGroup`,
  `Matrix.specialUnitaryGroup`, `Matrix.mem_unitaryGroup_iff`, and
  `Matrix.mem_specialUnitaryGroup_iff`.
- Convention: matrices act on columns from the left and the hidden fiber acts
  from the right; `M^H` is conjugate transpose.

## Submission metadata

```yaml
aristotle:
  project_id: ccff7fc8-bba7-4260-a335-25597d622551
  task_id: 1c20c219-a27a-4d61-8d7d-248b74ba7623
  target_file: SpinFiber/Factorization.lean
  expected_module: SpinFiber.Factorization
  submission_project: AgentTasks/aristotle-submit/codex-null-factorization-spin-fiber-20260709-2130-project
  output_dir: AgentTasks/aristotle-output/ccff7fc8-bba7-4260-a335-25597d622551
  status: in_progress
```
