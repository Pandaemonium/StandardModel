# Aristotle semantic context pack

Generated: 2026-07-18T05:30:16
Query: `proper eta-Lorentz periodic plaquette refinement varying coframe vacuum Weyl Riemann pair exchange first Bianchi nonlinear Palatini link Euler joint stationarity`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md` [2. The canonical gates]

Score: `0.865`

```text
mits on the
two columns, while all other ordered faces are flat. Every link preserves eta
and has determinant `+1`, and a nonzero `F` gives a nonzero target field. This
is a decorated nonflat refinement witness, not a proof that null-edge graph
dynamics selects it or that it is stationary.

`PhysicalLorentzPlaquetteEinsteinAudit` now resolves that stationarity question
for the static identity-coframe square. The mixed vacuum Einstein equations
annihilate five of the six target coordinates and leave only an internal `23`
rotation on the spacetime `01` plaquette. The survivor is Ricci-invisible but
fails curvature pair exchange because `F_01^23` has no `F_23^01` partner. An
exact nonlinear link Euler coefficient supplies the missing test: after
division by plaquette area it converges to twice the surviving amplitude.
Thus every nonzero target is incompatible with joint stationarity at all
levels of a shrinking refinement when the coframe is fixed to the identity.
The physical square remains a valid nonflat curvature-refinement witness, but
it is not a static vacuum solution. A successful nonflat branch must carry a
varying coframe and a richer face pattern; the theorem does not yet select or
construct that branch.

`LorentzCoframePalatiniFace` now separates two face notions that the four-form
must not conflate. With orientation `0123`, it defines the Lorentz Hodge star,
proves `star^2=-1`, and constructs the internal bivector building block
`star(e_a wedge e_b)`. If `(a,b)` label the actual curvature plaquette, its
coefficient is instead the complementary contraction
`(1/2) sum_cd epsilon^(cdab) star(e_c wedge e_d)`. All six canonical
complement signs are checked; in particular, curvature face `01` receives the
coframe plane `23`. This matches the permutation architecture
```

### 2. `Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md` [2. The canonical gates]

Score: `0.863`

```text
riation, its local periodic Euler coefficient and torsion-free Levi-Civita no-go, a group-valued link-curvature substrate, scalar, Euclidean finite-fiber, and full Krein-paired link/face Euler chains, plus a spacetime-derived six-component Lorentz-bivector representation preserved by the concrete null-edge `SL(2,C)` action and exactly equivalent to the matrix Lorentz Lie algebra with normalized trace pairing, the exact right-trivialized nonlinear Lorentz-plaquette tangent with its four-corner adjoint formula and additive identity-link limit, a displayed scalar ordered holonomy action with matching product/inverse derivative along canonical exponential link curves, its exact four-family nonidentity local link Euler coefficients, ordinary coframe derivative, joint `6 + 16` stationarity, exact antisymmetric-curvature Palatini rewrite, arbitrary-coframe identity `PalatiniDensity(e,F) = -det(e) R(e^{-1},F)`, exact coframe-response identity and stationarity-to-mixed-Einstein equivalence, conditional passage of stationary refinements with jointly convergent varying coframes and curvature to a limiting mixed vacuum Einstein equation, the static identity-coframe physical-square joint-stationarity no-go, determinant-weighted nonlinear action, and the complementary coframe-derived curvature-face coefficient `(1/2) epsilon^(cdab) star(e_c wedge e_d)` with exact divergence, proper-Lorentz covariance, and concrete action gauge invariance | Derive the aggregate weights and synchronized frame from the operator sector, identify the Gram and operator metrics, derive a graph refinement and prove the supplied coframe convergence hypotheses, construct a nonflat stationary varying-coframe refinement, supply metric dual-cell weighting of the Hodge face field, then test and prove Levi-Civita s
```

### 3. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [12.3 Selected Einstein dynamics]

Score: `0.862`

```text
uations
`2 Ric^d_c(F) - delta^d_c R(F) = 0` at the limiting tetrad.

`PhysicalLorentzPlaquetteRefinement` proves that the physical group sector is
nonempty and nonflat. For every six-component target `F`, the exact holonomy
`exp(A_n hat(F))` is proper eta-Lorentz and has action-visible first-order
limit `F`. A concrete commuting-shift `2 x 2` periodic square realizes this
without a formal plaquette ansatz: horizontal links are identities, the
vertical link is an exponential on one column, and the two columns have exact
opposite plaquettes. All links preserve eta and have determinant `+1`; a
nonzero input gives a nonzero target face field. The construction is not
claimed to be dynamically stationary or graph-selected.

`PhysicalLorentzPlaquetteEinsteinAudit` performs the missing dynamics test for
this concrete ansatz. With the coframe fixed at the identity, the mixed vacuum
Einstein system forces target components `0`, `1`, `3`, `4`, and `5` to vanish.
The remaining component `2` is the internal `23` rotation on the spacetime
`01` face. It is algebraically Ricci-invisible, but it violates curvature pair
exchange: the square has `F_01^23` without the corresponding `F_23^01` entry.
The exact link equation removes even that loophole. A displayed local nonlinear
Euler coefficient, divided by area, converges to twice the component-`2`
amplitude. Therefore no nonzero target in this square family can be jointly
stationary at every shrinking refinement level with a static identity
coframe. This is a useful ansatz no-go rather than a failure of the Palatini
route: nonflat vacuum dynamics must vary the coframe and distribute curvature
over enough faces to enter the Riemann sector.

This closes a conditional action-visible variation/curvature-limit theorem,
not the continuum GR der
```

### 4. `Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md` [2. The canonical gates]

Score: `0.860`

```text
uivalent to the mixed
vacuum equations. The continuum Riemann interpretation remains a separate
gate.

`NonlinearLorentzPalatiniCurvatureLimit` now closes the next conditional
composition. It packages the six action trace probes as a continuous linear
map on arbitrary `4 x 4` plaquette increments and proves exact calibration on
the Lorentz-generator image. A shrinking-area first-order group-holonomy
expansion therefore gives convergence of the exact antisymmetrized curvature
field used by the action. At a fixed invertible coframe, coframe stationarity
at every refinement passes to the mixed vacuum Einstein equation for the
limiting target. `NonlinearLorentzPalatiniVaryingCoframeLimit` removes the
fixed-tetrad restriction: the mixed Einstein entries are jointly continuous
finite polynomials in inverse-coframe and curvature components, exact finite
left inverses remain left inverses under simultaneous componentwise
convergence, and stationary varying coframes therefore obey the limiting
mixed vacuum equations. This does not derive a refinement or convergence,
require eta-Lorentz links, or identify the target with Levi-Civita Riemann
curvature.

`PhysicalLorentzPlaquetteRefinement` closes the eta-Lorentz existence side of
that interface. For arbitrary six-component `F`, it proves that the exact
proper eta-Lorentz holonomy `exp(A_n hat(F))` has action-visible first-order
limit `F`. It then realizes these holonomies as genuine plaquettes of a
commuting-shift `2 x 2` periodic square: identity horizontal links and a
column-dependent vertical exponential give exact `+F` and `-F` limits on the
two columns, while all other ordered faces are flat. Every link preserves eta
and has determinant `+1`, and a nonzero `F` gives a nonzero target field. This
is a decorated nonflat refineme
```

### 5. `PhysicsSM/Draft/NullEdge/GRFoundations.lean`

Score: `0.842`

```text
the determinant coframe-volume derivative, a finite Palatini-to-Einstein
   composition with incidence boundary cancellation, an explicit nonlinear
   coframe-chart action control, a spinor-null-edge coframe reconstruction,
   a directed-carrier Levi-Civita/Ricci reconstruction, and an exact
   aggregate-null-edge weight parameterization of arbitrary coframes,
   an independently varied directed connection with an exact curvature and
   action derivative, its exact periodic local Euler coefficients and finite
   Levi-Civita obstruction, and a joint aggregate-coframe/connection Palatini action,
   a gauge-covariant group-valued periodic link connection, linearized scalar
   and transported finite-fiber link/face Palatini actions with exact
    backward-divergence equations, a convention-explicit Krein predecessor
    adjoint, a spacetime-derived Lorentz-bivector representation, its exact
    six-coordinate Lorentz Lie-algebra realization and trace pairing, the exact
    nonlinear right-trivialized Lorentz-plaquette tangent and its additive
    identity-link limit, a scalar ordered holonomy action with the matching
    formal product/inverse response, its exact four-family nonidentity local
    link Euler coefficients and stationarity equation, and the full
    Krein-paired link/face Euler chain with a coframe-derived Lorentz-Hodge face field,
   causal-diamond path-comparison holonomy, and an exact shrinking-plaquette
   curvature limit,
   the exact sitewise stationarity-to-Einstein-equation implication,
   conditional source conservation, and imported FLRW controls.

The facade adds no umbrella theorem. In particular, importing it does not
assert manifoldlikeness, dimension selection, stochastic concentration,
continuum convergence, equivalence of forward-difference a
```

### 6. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [12.3 Selected Einstein dynamics]

Score: `0.839`

```text
erminant nonzero,
coframe stationarity is equivalent to all sixteen finite mixed vacuum Einstein
equations. Joint stationarity is therefore exactly the six-component link
Euler system together with those sixteen equations. No metric action or
separately supplied Einstein functional is substituted into this result.

The next variation/limit composition is also now explicit in
`NonlinearLorentzPalatiniCurvatureLimit`. The six trace probes are packaged as
a continuous linear map from arbitrary plaquette matrix increments to the
ordered curvature fiber, and that map is exactly the identity on generated
Lorentz-algebra coordinates. Thus an exact first-order expansion
`H_n = I + A_n (hat(F) + r_n)` with `A_n -> 0` and `r_n -> 0` gives convergence
of the area-normalized curvature used by the action to `F`; ordered-face
antisymmetrization preserves the same limit. For a fixed invertible coframe,
if every member of such a refinement is coframe stationary, continuity and
homogeneity pass the finite equations to
`2 Ric^d_c(F) - delta^d_c R(F) = 0`. A flat identity-holonomy family witnesses
consistency of the first-order interface.

`NonlinearLorentzPalatiniVaryingCoframeLimit` removes the fixed-coframe
restriction from that endpoint. It proves joint continuity of each mixed
Einstein entry as a finite polynomial in inverse-coframe and curvature
components. A refinement may therefore carry varying finite coframes and
exact left inverses, provided both converge componentwise. The left-inverse
relation itself survives the limit, and finite coframe stationarity then
implies all limiting equations
`2 Ric^d_c(F) - delta^d_c R(F) = 0` at the limiting tetrad.

`PhysicalLorentzPlaquetteRefinement` proves that the physical group sector is
nonempty and nonflat. For every six-component target
```

### 7. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [12.3 Selected Einstein dynamics]

Score: `0.837`

```text
Antisymmetrizing these representatives
in the two plaquette directions leaves the complete ordered action unchanged,
because the complementary coframe face is antisymmetric. Thus the nonlinear
holonomy action is now exactly a finite tetradic Palatini pairing with an
antisymmetric extracted curvature field. This does not yet identify that field
with continuum Riemann curvature.

The normalization-sensitive determinant bridge is now kernel-checked in
`NonlinearLorentzPalatiniEinsteinBridge`. With the actual project Hodge
matrix, Krein signs, ordered bivector basis, and a supplied left inverse,
every ordered curvature field satisfies
`PalatiniDensity(e,F) = -det(e) ScalarCurvature(e^{-1},F)`. No curvature
antisymmetry is needed. Consequently the concrete nonlinear plaquette action
itself is exactly `-sum_x det(e_x) R_x` for a supplied pointwise left inverse;
this is not a replacement metric action. The previous identity-coframe result
is now a sign-control corollary of the arbitrary-coframe normalization.

The response bridge is now exact in
`NonlinearLorentzPalatiniEinsteinResponse`. For every supplied left inverse
and every curvature field antisymmetric in its two face directions, the
ordinary first coframe response of the extracted-curvature Palatini density is
`det(e)` times the mixed Einstein coframe coefficient paired with the arbitrary
tetrad variation. Consequently each of the sixteen local tetrad Euler
coefficients of the concrete nonlinear holonomy action is exactly
`det(e) E^d_c`, where contraction gives
`2 Ric^d_c - delta^d_c R`. Since a left inverse makes the determinant nonzero,
coframe stationarity is equivalent to all sixteen finite mixed vacuum Einstein
equations. Joint stationarity is therefore exactly the six-component link
Euler system together with th
```

### 8. `Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md` [2. The canonical gates]

Score: `0.835`

```text
ion is
quadratic, so its linear coefficient is an ordinary derivative rather than a
renamed response functional. Site-supported matrix-entry probes give sixteen
local tetrad coefficients, and joint stationarity is exactly the combined six
link and sixteen coframe equations. `NonlinearLorentzPalatiniCurvatureExtraction`
then constructs the six-component Krein-dual representative of every ordered
holonomy trace functional. Its antisymmetrization in the plaquette directions
is an exact curvature face, and pairing it with the antisymmetric complementary
coframe leaves the full action unchanged. The result is an exact finite
Palatini-density rewrite of the nonlinear action. The determinant/scalar-
curvature bridge is now kernel-checked:
`NonlinearLorentzPalatiniEinsteinBridge` proves
`PalatiniDensity(e,F) = -det(e) ScalarCurvature(e^{-1},F)` for every ordered
curvature field and a supplied left inverse, using the project Hodge, Krein,
and bivector conventions. Thus the concrete nonlinear action itself is the
corresponding determinant-weighted scalar-curvature sum. The ordinary coframe
response is exactly the sum of the corresponding extracted-curvature density
responses. A separate exact contraction theorem shows that the
sixteen proposed coframe-index coefficients vanish iff all mixed combinations
`2 Ric^d_c - delta^d_c R` vanish for a supplied two-sided inverse. The response
successor now proves the full first-variation identity: each concrete tetrad
Euler coefficient is `det(e)` times the corresponding mixed Einstein coframe
coefficient. Thus finite coframe stationarity is equivalent to the mixed
vacuum equations. The continuum Riemann interpretation remains a separate
gate.

`NonlinearLorentzPalatiniCurvatureLimit` now closes the next conditional
composition. It packages
```

## Scoped paper hits

### 1. Aspects of Everpresent Lambda (I): A Fluctuating Cosmological Constant from Spacetime Discreteness

Score: `0.740`
Zotero key: `K5CFI3HI`
arXiv: `2304.03819`
DOI: `10.1088/1475-7516/2023/10/047`
URL: http://arxiv.org/abs/2304.03819

### 2. Regge Calculus in Teleparallel Gravity

Score: `0.738`
Zotero key: `T5ZH4WC8`
arXiv: `gr-qc/0208036`
DOI: `10.1088/0264-9381/19/19/301`
URL: http://arxiv.org/abs/gr-qc/0208036

Abstract:

In the context of the teleparallel equivalent of general relativity, the Weitzenbock manifold is considered as the limit of a suitable sequence of discrete lattices composed of an increasing number of smaller an smaller simplices, where the interior of each simplex (Delaunay lattice) is assumed to be flat. The link lengths between any pair of vertices serve as independent variables, so that torsion turns out to be localized in the two dimensional hypersurfaces (dislocation triangle, or hinge) of the lattice. Assuming that a vector undergoes a dislocation in relation to its initial position as it is parallel transported along the perimeter of the dual lattice (Voronoi polygon), we obtain the discrete analogue of the teleparallel action, as well as the corresponding simplicial vacuum field equations.

### 3. Higher-order Laplacian renormalization

Score: `0.734`
Zotero key: `RA8QNNKW`
arXiv: `2401.11298`
DOI: `10.1038/s41567-025-02784-1`
URL: https://doi.org/10.1038/s41567-025-02784-1

### 4. Aspects of Everpresent Lambda (II): Cosmological Tests of Current Models

Score: `0.730`
Zotero key: `IHVSDGUC`
arXiv: `2307.13743`
DOI: `10.1088/1475-7516/2024/10/076`
URL: http://arxiv.org/abs/2307.13743

### 5. Higher gauge theory

Score: `0.728`
DOI: `10.1090/conm/431/08264`
URL: https://doi.org/10.1090/conm/431/08264
