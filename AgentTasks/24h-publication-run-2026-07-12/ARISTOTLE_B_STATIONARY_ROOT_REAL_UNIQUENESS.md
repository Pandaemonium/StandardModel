# Aristotle: exact real-root uniqueness for stationary elimination

Fill all eight proof holes in `StationaryRootReal/Core.lean` without changing
any statement. This pure-Mathlib package proves that the stationary-Weyl
quintic has exactly one real root and that the companion sextic has none.

Suggested certificate for the hard left-tail theorem: use degree-five
Bernstein expansions on the rational intervals `[0,3/4]`, `[3/4,5/4]`, and
`[5/4,149/100]`. The coefficient lists are:

```text
[0,3/4]:
-575, -359, -16057/80, -8011/80, -119887/1280, -35879/256

[3/4,5/4]:
-35879/256, -219067/1280, -288871/1280,
-373207/1280, -87375/256, -81175/256

[5/4,149/100]:
-81175/256, -78199/256, -221439683/800000,
-179760419/800000, -2823297803/20000000,
-8099334899/500000000
```

For `t <= 0`, every original quintic term is nonpositive and the constant is
strictly negative.  For `t >= 3/2`, write `t=3/2+u`; the coefficients are

```text
480, 3025, 7350, 14823/2, 5499/2, 169/16.
```

On the isolating interval, strict monotonicity can be proved from the shifted
divided difference around `149/100`, whose nonconstant power coefficients are
all positive.  For the sextic, use a rational SOS/positive-interval
decomposition if direct normalization does not close.

```yaml
aristotle:
  project_id: ba38840e-6ab1-4a5a-acaa-8a47dcb12a15
  task_id: 58784513-73a6-4969-a86c-962210601dfd
  target_file: StationaryRootReal/Core.lean
  expected_module: StationaryRootReal
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-stationary-root-real-uniqueness-20260712-project
  output_dir: AgentTasks/aristotle-output/ba38840e-6ab1-4a5a-acaa-8a47dcb12a15
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

## Harvest and integration

Aristotle completed all eight statements without changing their types. The
returned proof gives exact global sign regions for the quintic, strict
monotonicity on `[149/100,3/2]`, IVT existence and uniqueness, and an exact
sum-of-squares positivity certificate for the sextic.

Downloaded archive:
`AgentTasks/aristotle-output/ba38840e-6ab1-4a5a-acaa-8a47dcb12a15/result.zip`.
The candidate was independently checked with the repository toolchain before
adaptation into
`PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylRootClassification.lean`.

Scope boundary: the real polynomial census is kernel checked. The derivation
of the displayed factors from the full stationary matrix equations remains an
external exact-CAS step, and the tangent chart omits phase `-1` boundaries.
