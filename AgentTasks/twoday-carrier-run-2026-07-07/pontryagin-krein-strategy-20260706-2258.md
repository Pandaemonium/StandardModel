# Aristotle focused strategy prompt: finite Pontryagin route for Krein positivity

```yaml
aristotle:
  project_id: ce99501a-1587-46be-a245-a03496e24a8c
  task_id: 3078e24d-595d-4ef7-a242-e4f5efdd8fcc
  target_file: strategy-report
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/tc-pontryagin-krein-strategy-20260706
  output_dir: AgentTasks/aristotle-output/ce99501a-1587-46be-a245-a03496e24a8c
  status: submitted
```

You are a skeptical mathematical strategist for the `C:\Projects\StandardModel`
Lean 4 project. This is a strategy/audit job, not a proof integration job.

## Current project need

The carrier program uses a finite Krein form for Lorentzian signature. The
minimal API used in the project is:

```text
J = J^dagger = J^{-1}
[u, v]_J = <u, J v>
A^# = J A^dagger J
J-self-adjoint means A^# = A
```

The mass-form target is eventually `D^#D`, but the project is careful not to
claim positivity from Krein self-adjointness alone.

User-provided Fable guidance says the highest-leverage near target is finite
Pontryagin linear algebra:

```text
In finite dimension, treat the carrier space as a Pontryagin space. A classical
Pontryagin/Krein-Langer style theorem should guarantee an invariant maximal
nonnegative subspace for a J-self-adjoint operator. If true, the project can
separate "a positive sector exists" from the sharper physical question "is the
guaranteed sector natural/gauge-invariant/local/grading-compatible?"
```

## Relevant local context

- `docs/NULLSTRAND.md` records the finite Krein guardrail above and explicitly
  warns that Krein self-adjointness alone does not imply positivity, real
  spectrum, stability, or a physical Hilbert sector.
- `PhysicsSM/Draft/NullEdgeSuperDiracKreinCore.lean` contains an older finite
  matrix `J`-self-adjointness predicate for the super-Dirac program.
- Context pack generated for this job:
  `AgentTasks/context-packs/pontryagin-krein-positivity-20260706-224615.md`.
  Use it only as context; verify every claim yourself.
- The live run has added two board threads:
  `KPON - Krein/Pontryagin physical-sector theorem` and
  `G-TP - teleparallel gravity slot`.

## What I need from you

Please deliver a Markdown strategy report, not code, with:

1. Mathematical truth audit: is the Fable claim true as stated for finite
   Pontryagin spaces and `J`-self-adjoint operators? If not, give the smallest
   missing hypotheses or a concrete counterexample shape.
2. The sharpest first formal theorem statement that is actually true and worth
   proving in Lean. Prefer a finite-dimensional statement over `Matrix` or
   `LinearMap` with explicit `J`, `J = J^*`, `J^2 = 1`, and a nonnegative
   subspace predicate.
3. A decomposition into 3-5 Lean lemmas/proof jobs, with names, hypotheses,
   and likely Mathlib APIs. Identify which are standalone Mathlib-adjacent and
   which are project-specific.
4. How this should connect to `D^#D` without overclaiming. Explicitly list
   the non-claims: no naturality, gauge invariance, locality, stability, real
   spectrum, or spectral mass unless separately proved.
5. A recommendation: submit a proof job now, ask Fable to ratify first, or park
   because the theorem is not true/formalizable at this scale.

Be adversarial about hidden assumptions. The useful answer may be "Fable's
statement needs hypothesis X" or "prove only this finite shadow first."
