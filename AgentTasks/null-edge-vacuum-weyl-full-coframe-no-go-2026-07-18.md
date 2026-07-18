# Null-edge vacuum-Weyl full-coframe no-go

## Objective

Determine whether an arbitrary invertible varying coframe can repair the
connection Euler obstruction of the exact two-site proper-Lorentz null-wave
links while retaining all sixteen coframe/Einstein equations.

## Result

The fixed-link repair is impossible at nonzero area.

`PeriodicVacuumWeylNullWaveFullNoGo.lean` proves the exact sixteen-entry
coframe Euler response. Its rank is six and its complete kernel at each site
is the ten-parameter matrix

```text
[[a, b,  c,  a+i-j],
 [d, e,  f,  d],
 [g, h,  e,  g],
 [i, -b, -c, j]].
```

The determinant factors exactly as
`-(a+i)(e^2-fh)(i-j)`. The successor
`PeriodicVacuumWeylNullWaveJointNoGo.lean` proves two exact connection Euler
coefficients. Connection stationarity forces
`area (a+i)(i-j)=0`. Thus, at nonzero area, every jointly stationary coframe
in the complete Einstein kernel is singular. The final theorem assumes only
invertibility at site `1`; it makes no diagonal, conformal, or no-shear
hypothesis.

## Scope

This is a finite no-go for the exact fixed two-site links and current
Palatini face weighting. It does not rule out simultaneous link/coframe
deformation, a larger carrier, twisted or boundary data, or modified
metric/dual-cell weights. It does not derive Levi-Civita selection or a
continuum limit.

## External cross-check

The four SymPy scripts under `Scripts/oracle/null_wave_*` independently
compute the conformal, diagonal, general-coframe, and joint stationary
reductions. They are exploratory evidence only; the headline identities and
no-go are kernel-checked in Lean.

## Verification

Passed on 2026-07-18:

- `lake build PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveJointNoGo`
- `lake build PhysicsSM.Draft.NullEdge.GRFoundations`
- all four `Scripts/oracle/null_wave_*` symbolic audits
- `pre-commit run --all-files`
- `lake build` with 8,319 jobs
- build-enforced standard-three assumption guards on the headline theorems

The semantic document-index refresh was also attempted after the Lean and
documentation edits, but its wrapper timed out after five minutes without
returning an error or completion report.

## Next gate

Construct or rule out the smallest simultaneous link/coframe deformation
whose links remain proper eta-Lorentz, whose coframe is invertible, and whose
joint Euler equations hold at each nonzero refinement area. Metric dual-cell
weighting and Levi-Civita selection should be tested as explicit alternatives,
not silently folded into the fixed ansatz.
