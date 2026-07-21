# Aristotle task: exact two-component HNU Weyl Schwartz generator

Date: 2026-07-20
Owner: Codex / `CONT-FOURIER-001` and `QCA-3PLUS1-001`
Priority: continuum/PDE flagship successor

## Objective

Prove every declaration in `HNUWeylSchwartzPDE/Basic.lean` without changing
the definitions or weakening the theorem statements. The target is the exact
two-component position-to-momentum Weyl generator identity on Schwartz data
under Mathlib's Fourier convention.

The source deliberately contains six executable proof holes. Replace all six
with kernel-checked proofs. Do not add assumptions, compiler-evaluation trust,
or escape hatches.

## Mathematical target

The position expression is

```text
(-I/(2*pi)) * sum_j sigma_j * partial_j g.
```

Mathlib's forward Fourier kernel is normalized by `-2*pi*I`, so the derivative
factor must cancel exactly and produce

```text
H_W(w) * Fourier(g)(w),
H_W(w) = w_0 sigma_1 + w_1 sigma_2 + w_2 sigma_3.
```

Required results:

1. the convention-sensitive coordinate-derivative Fourier identity;
2. commutation of Fourier transform with fixed bounded matrix action;
3. integrability of the position-Weyl expression;
4. the full three-axis Fourier/Weyl theorem;
5. an explicit nonzero axis-symbol witness;
6. the zero-state boundary control.

## Context and proof patterns

- Semantic context pack:
  `AgentTasks/context-packs/hnu-weyl-schwartz-pde-20260720-20260720-092949.md`.
- Repository proof patterns, described in the context pack:
  `FourierPartialCorrespondence.lean` and
  `FourierDiracSchwartzCapstone.lean`.
- The submitted file is Mathlib-only and independently typechecks before proof
  search.

## Claim boundary

This theorem identifies the exact continuum Weyl generator on a displayed
Schwartz domain. It does not prove changing-lattice convergence, a full
unbounded-operator domain theorem, a massive Dirac field, an interacting QFT,
or a primitive-null microscopic realization.

## Verification

Run:

```text
lake env lean HNUWeylSchwartzPDE/Basic.lean
lake build HNUWeylSchwartzPDE
```

Return the complete proof-hole-free file and report any statement or API issue
verbatim rather than weakening it.

## Aristotle metadata

```yaml
aristotle:
  project_id: f1971541-94f0-4450-b62e-872fd583badd
  task_id: 179b191d-dca8-4cf0-b772-1308f52fdefb
  target_file: HNUWeylSchwartzPDE/Basic.lean
  expected_module: HNUWeylSchwartzPDE.Basic
  submission_project: AgentTasks/aristotle-submit/hnu-weyl-schwartz-pde-20260720-project
  output_dir: AgentTasks/aristotle-output/f1971541-94f0-4450-b62e-872fd583badd
  status: integrated
```
