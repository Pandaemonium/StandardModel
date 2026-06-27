# Null-edge SM one-generation anomaly audit (task T18, anomaly-sum part)

## Summary

Created `PhysicsSM/Draft/StandardModelAnomalyAudit.lean` (imports `Mathlib`)
containing kernel-clean, exact rational-arithmetic checks of Standard Model
gauge / gauge-gravitational anomaly cancellation for **one** generation.

## Conventions

Fields are recorded as **left-handed Weyl multiplets**; right-handed fields
appear as their left-handed charge conjugates with sign-flipped hypercharge.
Hypercharge convention is `Q = T_3 + Y/2`, so `Y(Q_L) = 1/6`.

| Field   | colour (`SU(3)`) | weak (`SU(2)`) | `Y`   |
|---------|------------------|----------------|-------|
| `Q_L`   | 3                | 2              | 1/6   |
| `L_L`   | 1                | 2              | -1/2  |
| `u_R^c` | 3                | 1              | -2/3  |
| `d_R^c` | 3                | 1              | 1/3   |
| `e_R^c` | 1                | 1              | 1     |

Total multiplicity is `mult = colour · weak`.

**Right-handed neutrino:** not included in the base spectrum. As stated in the
prompt, a right-handed neutrino enters as a left-handed conjugate `ν_R^c` with
colour 1, weak 1, and `Y = 0`, so it contributes `0` to every sum. This is
proved explicitly (`sm_anomaly_cancellation_with_nu`), showing the audit is
unchanged whether or not a right-handed neutrino is present.

## Statements proved (all `sorry`-free)

In namespace `PhysicsSM.Draft.SMAnomaly`:

- `grav_anomaly_zero` — `U(1)` gravitational anomaly: `∑ mult · Y = 0`.
- `cube_anomaly_zero` — `U(1)^3` anomaly: `∑ mult · Y^3 = 0`.
- `su2_anomaly_zero` — mixed `SU(2)^2 U(1)`: over weak doublets weighted by
  colour, `3·(1/6) + (-1/2) = 0`.
- `su3_anomaly_zero` — mixed `SU(3)^2 U(1)`: over colour triplets weighted by
  weak multiplicity, `2·(1/6) + (-2/3) + (1/3) = 0`.
- `sm_anomaly_cancellation` — the conjunction of all four.
- `sm_anomaly_cancellation_with_nu` — same four sums with an added `ν_R^c`
  (`Y = 0`), still all zero.

Numeric checks behind the two required sums:

```text
∑ mult·Y   = 6·(1/6) + 2·(-1/2) + 3·(-2/3) + 3·(1/3) + 1·1            = 0
∑ mult·Y^3 = 6·(1/6)^3 + 2·(-1/2)^3 + 3·(-2/3)^3 + 3·(1/3)^3 + 1·1^3  = 0
```

## Commands run

- `lake build PhysicsSM.Draft.StandardModelAnomalyAudit` — succeeds.
- Axiom check on `sm_anomaly_cancellation`: only `propext`, `Classical.choice`,
  `Quot.sound` (standard Mathlib axioms; kernel-clean, no `sorry`).
- Source grep confirms no `sorry`.

(The repo `defaultTargets = ["PhysicsSM"]` has no `PhysicsSM.lean` root module,
so a bare `lake build` fails repo-wide; the file is built directly by module
name, as above.)

## Guardrails / what remains for full chirality

- This proves **only** the standard one-generation anomaly arithmetic. It does
  **not** show the null-edge construction realises the chiral Standard Model.
- The doubling / Nielsen–Ninomiya-evasion argument (T18 audit part, relating to
  T16) is **not** addressed here and remains an open audit job.
- File kept under `PhysicsSM/Draft/` pending semantic review, per the prompt.
