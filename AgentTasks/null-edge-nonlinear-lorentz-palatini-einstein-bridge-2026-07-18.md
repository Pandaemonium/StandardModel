# Null-edge nonlinear Palatini-to-Einstein bridge

Date: 2026-07-18
Work item: `GR-PALATINI-COFRAME-004`
Status: finite response gate closed; continuum program active

## Objective

Connect the ordinary coframe derivative of the concrete nonlinear Lorentz
plaquette action to the vacuum mixed Einstein equation without substituting a
separate metric action.

## Kernel-checked chain

`NonlinearLorentzPalatiniCurvatureExtraction` assigns each ordered exact
holonomy trace functional its unique six-component Krein-dual representative.
Antisymmetrizing this field leaves the full action unchanged and gives the
exact extracted-curvature Palatini action.

`NonlinearLorentzPalatiniCoframeVariation` proves that affine coframe lines
give the ordinary action derivative and sixteen local tetrad coefficients. Its
polarized complementary face is now also proved antisymmetric.

`NonlinearLorentzPalatiniEinsteinBridge` proves:

1. the extracted-curvature action is the sum of site-local Palatini densities;
2. every site-local tetrad Euler functional is the first response of that
   site's extracted-curvature density, and the ordinary global coframe
   response is their sum;
3. the exact project normalization at the identity coframe is
   `PalatiniDensity(1,F) = -ScalarCurvature(1,F)` for every ordered curvature
   field;
4. for every coframe with a supplied left inverse, the exact arbitrary-frame
   normalization is `PalatiniDensity(e,F) = -det(e) R(e^{-1},F)`, again with
   no curvature antisymmetry hypothesis;
5. the concrete nonlinear action is therefore exactly
   `-sum_x det(e_x) R_x` for a supplied pointwise left inverse;
6. contracting the proposed coframe-index coefficient with the coframe gives
   `2 Ric^d_c - delta^d_c R`;
7. for a supplied two-sided inverse, all sixteen coframe-index coefficients
   vanish iff all sixteen mixed vacuum combinations vanish.

These are finite identities. They do not identify the extracted curvature
with continuum Riemann curvature or select Levi-Civita transport.

`NonlinearLorentzPalatiniEinsteinResponse` now proves:

1. the arbitrary tetrad variation identity
   `delta PalatiniDensity = det(e) * sum E^d_c delta e^c_d` for curvature
   antisymmetric in its two face directions;
2. each of the sixteen local tetrad Euler coefficients of the concrete
   nonlinear action is `det(e)` times the corresponding mixed Einstein
   coframe coefficient;
3. coframe stationarity is equivalent to all sixteen finite mixed equations
   `2 Ric^d_c - delta^d_c R = 0`;
4. joint stationarity is exactly the six-component link Euler system together
   with those sixteen mixed equations.

These headline theorems carry build-enforced standard-three axiom guards.

## Response gate

The four-dimensional determinant/cofactor normalization is closed. The
minimal helper task completed with a kernel-checked auxiliary-matrix proof;
an equivalent left-inverse-only row-selector proof is integrated in the live
bridge, and the determinant/scalar-curvature density and action theorems now
carry standard-three axiom guards.

The first-response identity was completed independently in the live module.
The focused Aristotle job remains in progress as an audit-only comparison:

- first-response identity: project `40d89d02-7dc7-4a7d-97e5-aa053adc4112`,
  task `d31bb4e4-b619-483d-894b-b505fc1dcfe0`.

Neither Aristotle task is on the critical path. The response proof factors
through the exact exterior-square cofactor transformation under elementary
coframe column operations; determinant trace and the two curvature insertions
give the scalar and twice-Ricci terms with the project signs fixed.

## Convention lock

- metric signature: mostly minus;
- spacetime orientation: `0123`;
- bivector order: `(12,13,23,01,02,03)`;
- Krein signs: `(+,+,+,-,-,-)`;
- coframe indices: internal row, spacetime column;
- inverse-coframe indices: spacetime row, internal column;
- density sign: `PalatiniDensity = -det(e) ScalarCurvature`;
- curvature antisymmetry is not needed for the determinant identity; it is
  required only for the response-to-Einstein simplification.

## Verification so far

Passed:

```text
lake env lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCoframeVariation.lean
lake build PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
lake env lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEinsteinBridge.lean
lake build PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
lake env lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEinsteinResponse.lean
lake build PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinResponse
lake build PhysicsSM.Draft.NullEdge.GRFoundations
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEinsteinResponse.lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEinsteinBridge.lean PhysicsSM/Draft/NullEdge/GRFoundations.lean
pre-commit run --all-files
lake build
```

The response module's direct Lean check passed with no proof holes. Its
targeted build, the facade build, the strict source scan, every pre-commit
hook, and the full 8,319-job project build also passed after integration. The
response proof emits only localized nonfatal tactic-linter warnings in its
exhaustive elementary cofactor case split.

## Remaining work

1. harvest the Aristotle output as an independent audit when it finishes;
2. derive the metric dual-cell weight and test Levi-Civita selection;
3. identify extracted plaquette curvature with continuum Riemann curvature
   under an explicit refinement interface;
4. prove variation-limit interchange and normalize constants and matter
   coupling on the common limit geometry.
