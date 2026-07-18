# Null-edge link/face Palatini variation

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-001`
Status: kernel-checked linearized control

## Result

`PhysicsSM/Draft/NullEdge/FinitePeriodicLinkPalatiniVariation.lean` replaces
the falsified pointwise connection channel at the additive tangent level.
It defines a real connection potential on periodic directed links, oriented
plaquette curl, an ordered face-weighted action, and arbitrary link probes.

The module proves:

- exact periodic summation by parts for scalar link components;
- vertex-gauge invariance of plaquette curvature and the action when shifts
  commute;
- exact expansion of the action under an arbitrary link variation;
- pairing of the full first variation with a local ordered-link Euler
  coefficient;
- stationarity if and only if every local coefficient vanishes;
- for antisymmetric face weights, equivalence with vanishing backward face
  divergence;
- site-constant face weights as stationary controls;
- an explicit nonzero antisymmetric `01` face field on every nonempty carrier.

The headline results carry build-enforced standard-three axiom guards. No
proof placeholder or compiled-evaluator shortcut is used.

## Interpretation boundary

This is a finite identity and linearized consistency check. It does not yet
derive the ordered face weight from null-coframe bivectors and dual-cell
volumes, vary nonlinear Lorentz-group holonomy, or prove that the divergence
equation uniquely selects compatible Levi-Civita link transport.

## Next target

Define the coframe-derived, Lie-algebra-indexed face bivector on the same
periodic carrier. Prove its linearized covariant divergence vanishes for the
candidate compatible link connection, then lift the calculation to the
group-valued plaquette action and rerun the three-site conformal witness.

## Verification

```text
lake env lean PhysicsSM/Draft/NullEdge/FinitePeriodicLinkPalatiniVariation.lean
lake build PhysicsSM.Draft.NullEdge.FinitePeriodicLinkPalatiniVariation
lake build PhysicsSM.Draft.NullEdge.GRFoundations
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide <four GR files>
pre-commit run --all-files
lake build
```

All commands passed on 2026-07-17. The strict source scan covered the periodic
pointwise Euler audit, group-valued link substrate, linearized link/face
variation, and GR facade; it found no forbidden Lean-code tokens.
