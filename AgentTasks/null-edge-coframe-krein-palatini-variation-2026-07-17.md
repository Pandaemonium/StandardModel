# Null-edge coframe-derived Krein Palatini variation

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-006C`
Status: landed

## Result

Two guarded draft modules remove the arbitrary local face-vector input from
the finite Krein link equation:

- `LorentzCoframePalatiniFace.lean` defines the explicit Lorentz Hodge star in
  orientation `0123`, constructs the internal bivector
  `star(e_a wedge e_b)`, and derives the complementary curvature-face
  coefficient `(1/2) epsilon^(cdab) star(e_c wedge e_d)`;
- `FinitePeriodicCoframeKreinPalatiniVariation.lean` inserts the complementary
  field into the full six-component Krein link response.

The exact results prove `star^2=-1`, exterior-square covariance of the raw
coframe wedge, all six canonical spacetime complement signs, ordered face
antisymmetry, repeated-face vanishing, the local Krein Euler pairing, and
equivalence between link stationarity and vanishing Krein-covariant backward
divergence of the complementary Palatini field. A constant coframe with
identity transport supplies a nonvacuous stationary control.

The module also pins the exact convention identity
`[star(B), C]_J = -(1/4) epsilon_IJKL B^IJ C^KL`. This overall minus does not
change the vacuum connection stationarity equation, but the gravitational
prefactor or curvature orientation must compensate for it when the joint
Einstein-matter normalization is fixed.

## Face-label correction

The first version inserted `star(e_a wedge e_b)` directly against curvature
on plaquette `(a,b)`. A convention audit found that this is not the tetradic
Palatini four-form when `(a,b)` are actual link/plaquette directions. The
continuum coefficient of `F_ab` is complementary in spacetime indices. The
live module now uses the corrected half-sum above and proves, for example,
that curvature face `01` receives coframe plane `23`.

This correction follows Kur and Glasser, *Discrete Gravity with Local Lorentz
Invariance*, arXiv:2202.02486, Eqs. (15), (16), and (25), where the cell
permutation supplies two edge/coframe directions and the complementary two
curvature-face directions. Barrett, arXiv:hep-th/9404124, and Gionti,
arXiv:gr-qc/0501082, independently support the area/bivector and metric-dual
face architecture but do not fix this cubical basis convention by themselves.

## Verification

```text
lake env lean PhysicsSM/Draft/NullEdge/LorentzCoframePalatiniFace.lean
lake build PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
lake env lean PhysicsSM/Draft/NullEdge/FinitePeriodicCoframeKreinPalatiniVariation.lean
```

All commands passed. Both live modules contain no proof placeholders or native
evaluator shortcuts and carry build-enforced axiom guards.

## Remaining gates

- prove proper Lorentz covariance of the Hodge-dual face field;
- derive metric dual-cell volume factors from the null-edge complex;
- replace the linearized curvature with the exact right-logarithmic plaquette
  tangent;
- prove the resulting connection equation selects Levi-Civita transport.

The covariance proof is Aristotle task
`86835503-7179-4eb4-86bd-9c1fa7480b75`; the nonlinear tangent is task
`b96861ca-12ff-460e-b123-f06995cf2750`.
