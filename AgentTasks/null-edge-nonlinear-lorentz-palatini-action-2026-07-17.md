# Nonlinear Lorentz Palatini response and action

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-008`
Status: landed

## Result

Two guarded draft modules advance the corrected group-valued link branch:

- `NonlinearLorentzPalatiniResponse.lean` recovers six-component coordinates
  of the exact right-trivialized plaquette tangent through the proved Lorentz
  Lie-algebra equivalence. Eta-Lorentz link hypotheses ensure this is exact
  coordinate recovery, not projection of an unconstrained matrix.
- `NonlinearLorentzPalatiniAction.lean` defines the scalar ordered holonomy
  functional `-1/2 tr(hat(B_ab)(H_ab-I))` with the complementary coframe face
  `B_ab`, and defines its formal product/inverse response.

The response module proves exact recovery of the oriented additive plaquette
curl and the existing coframe-derived Krein response at identity links. The
action module proves `H_ba=H_ab^(-1)`, so ordered face antisymmetry has the
standard `H-H^(-1)` architecture. It also proves that
`delta H = (delta H H^(-1)) H`; therefore the scalar-action response carries a
holonomy factor away from identity. At identity links the scalar action
vanishes and its formal response agrees exactly with the existing
Krein/additive Palatini response, including normalization.

Formal connection stationarity is now defined for the scalar action. On the
identity-link branch it is proved equivalent to vanishing Krein-covariant
backward divergence of the complementary coframe face. A site-constant coframe
with identity links is therefore an exact nonvacuous stationary control of the
nonlinear action response, not merely of a separately named linear model.

The representation bridge additionally proves
`F(L dot B)=L F(B)L^T` and the eta-Lorentz generator intertwiner. Consequently
the action module proves exact conjugation invariance of each ordered action
term and vertex-gauge invariance of the full action for any face field already
transforming by the exterior-square Lorentz representation. The remaining
coframe-specific covariance gate is precisely the Hodge-face transformation
law.

## Claim boundary

The pure right-logarithmic one-form is not silently identified with a scalar
action. The displayed scalar action has a holonomy-weighted formal response.
The live theorems establish exact finite algebra and identity-link matching,
but do not yet formalize differentiable curves in the matrix group, derive the
nonlinear Euler equation, prove proper local Lorentz covariance of the Hodge
face, include metric dual-cell volumes, or select Levi-Civita transport.

## Provenance and conventions

- mostly-minus metric `(+,-,-,-)`;
- bivector basis `(12,13,23,01,02,03)`;
- link variation `delta U = U hat(X)`;
- plaquette `H=A B^(-1)` and tangent `delta H H^(-1)`;
- curvature face `ab` receives
  `(1/2) sum_cd epsilon^(cdab) star(e_c wedge e_d)`;
- trace/Krein normalization
  `-1/2 tr(hat(B)hat(C)) = [B,C]_J`.

The ordered complementary-face discretization follows E. Kur and A. S.
Glasser, *Discrete Gravity with Local Lorentz Invariance*, arXiv:2202.02486,
especially Eqs. (15), (16), and (25). The exact tangent proof was harvested
from Aristotle project `f0bc30e8-90c8-4e67-b60f-191c92a95f54` and reviewed
against the live project definitions before composition.

## Verification

```text
lake env lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniResponse.lean
lake build PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniResponse
lake env lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniAction.lean
lake build PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
```

All commands passed. The two modules contain no proof placeholders or native
evaluator shortcuts and carry build-enforced axiom guards.

## Next gate

Close proper Lorentz covariance of the Hodge face, add the metric dual-cell
factor, formalize curve-level differentiation of the scalar action, extend the
flat-branch divergence theorem to the submitted explicit nonidentity link Euler
coefficient, and test that coefficient on a genuinely compatible discrete
Levi-Civita transport rather than the falsified pointwise forward-difference
candidate.
