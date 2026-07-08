# T2 finding: a multi-edge carrier escapes the aperture-balancing obstruction

**Date:** 2026-07-08 (all-mass overnight run). **Status:** numeric-oracle
proof-of-concept + structural argument (MEMO). **Probe:**
`Scripts/oracle/probe_multiedge_positive_sector.py`. **Roadmap item:** T2, the
critical-path linchpin (`STRENGTHENING_ROADMAP.md`).

## The result (a positive strengthening, not a caveat)

The aperture-balancing obstruction that killed the positivity escape on the
single-doublet witness (`S1CC_APERTURE_GRADING_FINDING.md`) is **specific to
the 2-dimensional Clifford factor, not fundamental**. A genuine two-edge
carrier (4-dimensional Clifford factor Cl(4)) escapes it and supplies exactly
the definite positive sector `sector_ground_mass` requires.

## Why the single-doublet was trapped, and Cl(4) is not

To balance the closure Krein form `J Q_C` by a grading `b`, one needs `b` to
anticommute with the closure bivector `omega`. The aperture is Clifford-scalar
(`Q_A = I (x) A`), so `J Q_A` is `b`-fixed iff `b` commutes with the Krein
metric `J_s`. The obstruction on the single-doublet is that its 2-dimensional
Clifford factor is too small: there `omega`, `J_s`, and `b` are all built from
`{sigma_x, sigma_z}`, and the only `b` that anticommutes `omega` also
anticommutes `J_s` - so balancing closure forces balancing the aperture.

In **Cl(4)** (two edges) there is room. With Hermitian gammas
`gamma_1..gamma_4`, the closure bivector `omega = gamma_1 gamma_2`, the grading
`b = gamma_1`, and the Krein metric `J_s = i gamma_3 gamma_4`:

```text
b ANTICOMMUTES omega  (=> J Q_C is b-odd => closure BALANCED)   : True
b COMMUTES     J_s    (=> J Q_A is b-even => aperture FIXED)     : True
b H_A b = +H_A  (aperture fixed, NOT balanced)                  : True
b H_C b = -H_C  (closure balanced)                              : True
```

Both conditions hold simultaneously - impossible in the single-doublet.

## The decisive check: a J-positive sector with a positive total form

`J` has inertia `(6,6,0)` (Krein/Lorentzian, indefinite - as it must be), so
positivity can only live on a sector. On the 6-dimensional `J`-positive
subspace, the total Krein form `J(Q_A + Q_C)` was computed as a function of
aperture strength `lambda`:

```text
lambda | inertia on J-positive sector | positive-definite sector?
  0.5  |        (4, 2, 0)             | no
  1.0  |        (4, 0, 2)             | no
  2.0  |        (6, 0, 0)            | YES
  4.0  |        (6, 0, 0)            | YES
  8.0  |        (6, 0, 0)            | YES
```

For `lambda >= 2` (aperture dominance) the total is **positive-definite on the
sector**. This is exactly `sector_ground_mass`'s hypothesis, now satisfiable:
a definite sector on which `D^#D` is ordinary-self-adjoint with a `c > 0` form
bound. Contrast (in the probe): a single-doublet-style grading that
anticommutes `J` *would* balance the aperture - the trap Cl(4) lets us avoid.

## What this establishes, and what it does not

- **Establishes (the strengthening):** the positivity program is **not dead**.
  The obstruction is not forced by the single-doublet algebra alone; a two-edge
  carrier admits a genuine `J`-positive sector on which aperture dominance makes
  the total mass form positive-definite, numerically instantiating the
  keystone's positive-sector hypothesis. Crux 0a is de-risked from
  "obstructed" to "escape mechanism validated numerically at MEMO grade."
- **Does not yet establish (honest scope):** this is a numeric oracle on a
  structural proof-of-concept (explicit Cl(4) rep, PD aperture `A = lambda I`,
  skew curvature `K`). It shows the mechanism and the existence of a positive
  sector; it is **not** yet (a) a full null-soldered carrier with `c(alpha)^2=0`
  and the actual Gauss constraint, nor (b) a Lean witness. The J-positive
  sector here is the abstract `J`-positive eigenspace; identifying it with a
  physical (gauge-invariant) sector is the remaining modelling step.

## Next M-target (the Lean witness)

Transcribe this to Lean: an explicit finite carrier + a `J`-positive sector `P`
with `Matrix.PosDef` for the compressed `D^#D|_P` and a `c > 0` form bound,
then feed T1 (sector-compression) + `sector_ground_mass` to conclude a genuine
positive squared-mass eigenvalue on a concrete two-edge model. That chain
(carrier witness -> compression -> keystone) turns the budget into a mass **in
a model**, discharging crux 0a end-to-end. Then T3 (the `det P` bridge) can be
probed on the same witness.
