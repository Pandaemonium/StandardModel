# Null-Edge GR Foundations Spine

**Status:** canonical architecture and literature audit, 2026-07-17  
**Scope:** the minimum complete dependency chain from finite causal data to
general relativity, with exact repository status and no competing foundational
routes

## Executive verdict

The repo contains nearly every *kind* of object needed for a GR reconstruction:
causal order, count volume, scalar causal operators, metric pairings, coframes,
Lorentz and spin transitions, connections, curvature, Bianchi identities,
matter variations, and controlled Einstein-equation reductions. The main
problem is not a missing finite analogue. It is that the ingredients are spread
across many capstones and experimental stages, while the genuinely open
continuum and dynamical bridges can be hard to distinguish from exact finite
algebra.

The program should therefore have one foundations spine:

\[
 (C,\mu)
 \longrightarrow B_L
 \longrightarrow \Gamma_{B_L}
 \longrightarrow g^{-1}
 \longrightarrow (e,\nabla,R)
 \longrightarrow (S_{\rm grav}+S_{\rm matter},T)
 \longrightarrow G+\Lambda g=8\pi G_NT.
\]

Here `C` is a locally finite causal order, `mu` is count measure, `B_L` is one
count-normalized mesoscopic scalar operator, and

\[
 \Gamma_B(f,h)=\frac12\bigl(B(fh)-fBh-hBf+fhB1\bigr)
\]

is its potential-canceling principal-symbol pairing. The physical metric is
the unique metric reconstructed from this pairing and count volume. A coframe
is a local Lorentz-gauge factorization of that metric, not a second metric.
Connection, holonomy, Dirac-square curvature, matter variation, and the action
must all converge on that same geometry.

The deepest missing fundamental is a probability/dynamics statement:

> The theory must distinguish reconstruction on causal sets already known to
> approximate a manifold from a dynamics that actually selects such
> manifoldlike causal sets.

No amount of additional finite GR-shaped algebra closes that gap.

Claim grades follow the project calculus: `T [import]` for source-verified
continuum results, `M` for kernel-checked finite identities, `T|H` for results
conditional on displayed reconstruction hypotheses, and `C` for open bridges
with success and kill conditions. No `M` result in this note is thereby a
continuum GR theorem.

## 1. Minimal ontology

Only four layers are fundamental.

### Layer A: order and number

The bare covariant datum is a finite or locally finite order/count pair

\[
 (C,\prec,\mu_C).
\]

Relabeling is gauge. Open intervals and their cardinalities are intrinsic.
Counting is the candidate volume datum. A causal-set covering relation is
causal support; it is not automatically an exact continuum-null tangent.

This last distinction matters for the name "null edge." Exact null vectors,
spin frames, or soldering forms must be either decorations with transformation
laws or outputs of a reconstruction theorem. The literature also rules out an
intrinsic finite preferred direction set for a Poisson sprinkling if Lorentz
equivariance is retained.

### Layer B: reconstructed geometry

At mesoscopic scale `L`, one order/count construction must select:

\[
 (\mathcal A_L,\mu_L,B_L,\prec),
\]

where `A_L` is a gauge-relative scalar probe algebra. The corrected pairing of
`B_L` reconstructs the inverse metric on a stable four-dimensional image. The
count measure fixes the missing Weyl factor. Coordinates are local generators
of `A_L`, not primitive labels.

The coframe, spin frame, Levi-Civita connection, and curvature are lifts or
derivatives of this one metric:

\[
 g_{\mu\nu}=\eta_{IJ}e^I{}_{\mu}e^J{}_{\nu},
 \qquad \nabla=\nabla^{\rm LC}(g),
 \qquad R=R(\nabla).
\]

### Layer C: spin and matter

The same coframe solders the Dirac principal symbol. The same metric and count
measure enter the matter action. Stress-energy is the localized metric or
coframe variation of that action, not an energy scalar or trace budget.

Spin structure is a global lift condition on the reconstructed oriented
Lorentz atlas. It is not supplied by a local `SL(2,C)` formula alone.

### Layer D: dynamics and continuum selection

The model needs a covariant measure, quantum measure, or effective weighting on
causal histories. Two independent results are required:

1. **Manifold-conditioned reconstruction:** given a faithful approximation to
   a suitable Lorentzian manifold, all estimators converge to its geometry.
2. **Dynamical selection:** the model's own measure concentrates on the sector
   where those reconstruction hypotheses hold.

Only after both steps may an interval-count action be said to produce a GR
infrared phase.

## 2. The canonical gates

| Gate | Required result | Present in the repo | Exact open debt |
|---|---|---|---|
| F0: finite kinematics | Strict causal order, count measure, relabeling covariance | Exact open intervals, layers, equivariant causal operators, null-spinor soldering controls | A single agreed primitive data type linking order/count data to optional decorations |
| F1: manifold-conditioned limit | Faithful embeddings or an equivalent intrinsic convergence interface | Extensive sprinkled-manifold controls and a two-scale reconstruction protocol | One theorem family with explicit probability space, regulator schedule, topology, and uniform error bounds |
| F2: dynamical manifold selection | The theory suppresses nonmanifoldlike orders and selects a four-dimensional Lorentzian phase | Candidate actions and finite experiments only | A covariant ensemble/quantum measure and concentration on the F1 domain |
| F3: dimension, topology, conformal class | Recover dimension, topology, and causal conformal geometry | Continuum Malament/HKM result is imported; finite topology and dimension literature is catalogued | Intrinsic dimension/topology convergence for the selected ensemble |
| F4: metric and scale | `Gamma_B` converges to rank-four `(+---)` inverse metric and count volume fixes scale | Potential cancellation, relabeling covariance, scale laws, rank-four interfaces, no-go results, and finite witnesses are exact | Canonical selector, four-mode gap, product closure, overlap/refinement persistence, concentration, and absolute calibration |
| F5: coframe and spin | Gauge-relative coframe and a compatible spin lift of the metric atlas | Exact coframe covariance, Lorentz transitions, central sign, and finite obstruction interfaces | Derive the atlas and identify the stable finite class with the continuum spin obstruction |
| F6: one curvature | Levi-Civita, holonomy, operator, and Dirac-square curvature agree | Exact finite connection/Bianchi algebra, a gauge-covariant periodic link/plaquette substrate, a continuous action-visible curvature extractor, conditional shrinking-loop and antisymmetrized-curvature limits, a nonzero proper eta-Lorentz periodic-square refinement with exact exponential plaquettes, an exact audit showing its lone identity-coframe Ricci-flat mode violates metric-lowered pair exchange, a separate nonzero algebraic vacuum-Weyl target satisfying pair exchange and first Bianchi, and an exact proper-Lorentz two-site null-wave lift whose finite extracted curvature is vacuum Einstein and coframe-stationary; its full coframe response has rank six and a complete ten-parameter kernel, but no invertible coframe in that kernel is jointly stationary with the fixed links at nonzero area | A simultaneously link-and-coframe-deformed jointly stationary lift and convergence of all routes to the same Riemann/Ricci/scalar curvature with the correct `R/4` coefficient |
| F7: one matter source | Localized variation of one matter action gives symmetric conserved `T` | Higgs/scalar controls, full symmetric-probe uniqueness, and the explicit Bianchi-to-source-conservation composition are exact | Derive the arbitrary local variation and matter Noether identity on the common reconstructed geometry |
| F8: one gravity action | One graph action converges to Einstein-Hilbert plus boundary and controlled corrections | Exact affine-action no-go, coframe determinant variation, Palatini-to-Einstein composition, incidence cancellation, nonlinear and joint two-field chart actions, spinor-null coframe and directed Levi-Civita/Ricci reconstruction, aggregate-weight coframe coverage, an exact independent pointwise-connection variation, its local periodic Euler coefficient and torsion-free Levi-Civita no-go, a group-valued link-curvature substrate, scalar, Euclidean finite-fiber, and full Krein-paired link/face Euler chains, plus a spacetime-derived six-component Lorentz-bivector representation preserved by the concrete null-edge `SL(2,C)` action and exactly equivalent to the matrix Lorentz Lie algebra with normalized trace pairing, the exact right-trivialized nonlinear Lorentz-plaquette tangent with its four-corner adjoint formula and additive identity-link limit, a displayed scalar ordered holonomy action with matching product/inverse derivative along canonical exponential link curves, its exact four-family nonidentity local link Euler coefficients, ordinary coframe derivative, joint `6 + 16` stationarity, exact antisymmetric-curvature Palatini rewrite, arbitrary-coframe identity `PalatiniDensity(e,F) = -det(e) R(e^{-1},F)`, exact coframe-response identity and stationarity-to-mixed-Einstein equivalence, conditional passage of stationary refinements with jointly convergent varying coframes and curvature to a limiting mixed vacuum Einstein equation, the static square and full fixed-null-wave-connection joint-stationarity no-go theorems, determinant-weighted nonlinear action, and the complementary coframe-derived curvature-face coefficient `(1/2) epsilon^(cdab) star(e_c wedge e_d)` with exact divergence, proper-Lorentz covariance, and concrete action gauge invariance | Derive the aggregate weights and synchronized frame from the operator sector, identify the Gram and operator metrics, derive a graph refinement and prove the supplied coframe convergence hypotheses, construct a nonflat jointly stationary refinement with simultaneous link/coframe backreaction, supply metric dual-cell weighting of the Hodge face field, then test and prove Levi-Civita selection, identify the action-visible target with common Riemann curvature, establish physical boundaries, `G_N`/`Lambda`, global descent, and global variation-limit interchange |
| F9: physical recovery | Newtonian, redshift, geodesic, wave, horizon, black-hole, and cosmological controls | Poisson normalization and FLRW equations under imported actions | Full independent controls, including tensor modes and curved local observables |

In F8, the canonical exponential variation curves are now proved to remain in
the proper eta-Lorentz subgroup when the base links do. The table's remaining
Lorentz-component debt is specifically the separate orthochronous sign.

The program is strongest at F0 and in the exact algebraic interfaces inside
F4-F7. Its decisive bottleneck remains F4, but F1 and F2 are logically prior
to any claim that the continuum theory is selected rather than supplied.

The theorem `DiscreteCausalActionVariationNoGo.everyGraphAction_continuouslyStationary`
shows that direct continuous variation of an unweighted finite graph is
vacuous: every action is stationary at every graph. The replacement begins in
`WeightedIntervalActionVariation`, where affine interval-layer weights give a
genuine finite derivative, order-isomorphism covariance, and a two-event
derivative equal to one. This is graph-native action calculus, not yet an
Einstein-Hilbert derivative.

`RelaxedCausalMetricVariationBridge` then proves the exact rank boundary.
Stationarity of relaxed causal parameters kills the Einstein-matter response
only on metric variations reached by the metric derivative. It becomes the
full tensor equation only when that derivative has symmetric image and reaches
every symmetric variation. In four dimensions this requires ten independent
local metric directions, plus fiber independence so the action descends to the
one operator-derived metric.

`LayerWeightMetricRankNoGo` now makes the dimension count exact. It constructs
ten linearly independent symmetric `4 x 4` directions and proves that any full
metric derivative has parameter-space dimension at least ten. In particular,
an affine interval action with fewer than ten independently variable layer
weights cannot produce the unrestricted four-dimensional Einstein equation.
The local-field theorem is stronger: on `N` finite sites, full local symmetric
metric reach requires at least `10N` parameter directions. Therefore a fixed
finite list of globally shared interval-layer coefficients cannot retain full
local reach along an unbounded refinement sequence. A viable successor must
localize the operator variables, add enough edge/kernel directions, or prove
that a smaller explicitly constrained quotient is the correct variational
target. Even `10N` parameters can still have a deficient image or a
fiber-dependent action.

`LocalizedIntervalActionMetric` now implements the first positive successor.
Each event receives its own finite row of interval-layer coefficients. The
same localized causal operator defines both the bulk action, by evaluation on
the constant field, and the metric Jacobian, by its corrected pairing on four
probes. The action derivative and relabeling covariance are exact. An
eleven-event chain has one predecessor in each of ten layers; with ten
displayed supplied moment probes, its metric Jacobian is explicitly
surjective onto and injective over the symmetric `4 x 4` tensors. The action
therefore factors exactly through that operator metric in the witness. A
general composition theorem upgrades full row reach at distinct selected bulk
centers to full sitewise reach.

`LocalizedIntervalAffineActionNoGo` now prevents overreading that positive
control. With fixed event measure, boundary constant, and cosmological
constant, the localized action is affine in its coefficients, so stationarity
is equivalent to vanishing of the entire bulk-response functional. In the
rank-ten chain, the all-ones symmetric direction has response `10`. Therefore
neither the coefficient action nor its exactly descended metric action has a
stationary point at any base. Full rank and trivial fibers solve kinematic
tests; they do not supply Einstein dynamics.

`FiniteEinsteinHilbertActionResponse` records the minimal nonlinear target for
the bulk term. For supplied local volume and scalar curvature, the derivative
of `sum_x volume_x (R_x - 2 Lambda)` splits exactly into volume and curvature
response channels, with the expected quadratic cross term along simultaneous
affine perturbations. The graph still has to derive both responses and the
boundary cancellation; the interface does not name an interval sum as
curvature.

`CoframeVolumeMetricVariation` now derives the first response channel. For the
multiplicative coframe path `e(t)=e(1+tX)`, polynomial determinant calculus
gives `delta det(e)=det(e) trace(X)`. The induced inverse-metric variation
`h=-(X gInv+gInv X^T)` satisfies
`<g,h>=-2 trace(X)`, so the volume response is exactly
`-(det(e)/2)<g,h>`. For symmetric two-sided inverse metrics, these coframe
generators reach every symmetric inverse-metric variation.

`FinitePalatiniEinsteinHilbertVariation` derives the Einstein coefficient from
that volume identity and the narrower finite Palatini premise
`sum volume delta R = sum volume <Ric,h> + boundary`. The result is the
volume-weighted pairing with `Ric-(R/2)g+Lambda g`, plus the displayed boundary
response. Nonzero local volumes cancel from the Euler-Lagrange equations.
`FinitePalatiniBoundaryCancellation` further proves exact incidence summation
by parts: if the local Palatini residual is an edge divergence, its total
vanishes on a closed finite carrier. A two-vertex unit-flux witness has local
residuals `-1` and `+1`, so this cancellation is nonvacuous.

`FinitePalatiniCoframeChartAction` supplies an actual nonlinear action control.
Its action is defined from `det(e(1+X))`, a fixed-connection Ricci contraction,
the cosmological term, and the matter pairing. Its derivative is calculated
from that formula, and stationarity at the chart origin is equivalent to the
pointwise finite Einstein equation. The control still supplies the coframe,
Ricci tensor, stress tensor, orientation, and common graph origin; it is not a
completed null-edge derivation.

`NullEdgeCoframeEinsteinBridge` removes four of those supplied inputs. Four
Weyl-spinor null edges at each site are soldered to future-null vectors and
assembled as the columns of a coframe. Nonzero determinant constructs the
inverse coframe, while the same edge data determine the mostly-minus Gram
metric, inverse metric, determinant volume, and scalar-curvature contraction.
Every diagonal Gram component is exactly zero. The canonical four-spinor
witness has determinant `1/2`, so the construction is nonvacuous. The
resulting nonlinear action is stationary exactly when the finite Einstein
equation holds for this null-edge-derived base geometry under unrestricted
coframe-generator variations. A companion no-go proves that any variation
which keeps all four coframe columns null has zero Gram diagonal and therefore
cannot reach all ten symmetric metric variations. Full stationarity is not yet
a null-edge-only variational statement. A complementary six-plus-four theorem
proves that reach of every symmetric zero-diagonal variation together with
reach of all four diagonal variations is sufficient for full metric reach;
this is now the exact gauge/aggregate completion target.

`DirectedNullEdgeLeviCivitaEinstein` also removes independently supplied Ricci
data. A directed chart records the target of each of the four selected null
edges. Forward differences of the null-edge Gram metric determine a symmetric
metric first jet, its Levi-Civita Christoffel coefficients, coordinate Riemann
curvature, raw Ricci contraction, and the symmetric Ricci response seen by
metric variation. Symmetric projection is proved to leave every pairing with
a symmetric metric variation unchanged. The final action theorem therefore
takes only the directed null-edge chart, stress, and couplings as inputs; its
coframe, metric, inverse, volume, connection, curvature, Ricci, and scalar
curvature are derived from that chart. A constant canonical chart is an exact
zero-connection and zero-curvature control.

`NullEdgeAggregateCoframeEinstein` supplies the exact escape from the
null-column tangent no-go. If `E` is the nondegenerate primitive null-edge
coframe and `A` is a matrix of aggregate weights, each physical coframe is
`e(A)=EA`. The map `A -> EA` is proved bijective: every real coframe has the
unique weights `A=E^{-1}e`. The existing action path `E(1+tX)` is therefore
literally an aggregate-weight path. The explicit generator
`X=-(1/2) h g` realizes every symmetric inverse-metric variation, while
generators `K g` with `K` skew are metric-invisible frame directions.
Stationarity of the absolute action at identity aggregate weights is
equivalent to the finite Einstein equation. Primitive propagation edges stay
null; their aggregates carry the unrestricted coframe variation. A one-metric
bridge further proves that if the operator sector supplies a coframe factor
`e` of its metric, the unique weights `A=E^{-1}e` reproduce that operator metric
exactly. The remaining Contract 1 debt is the factorization/reconstruction
theorem, not a choice between two metrics.

`FiniteDirectedPalatiniConnectionVariation` now separates the coordinate
curvature formula from the derived Levi-Civita substitution. For an arbitrary
directed connection `Gamma` and variation `H`, direct differentiation proves
the exact finite response `Delta H + Gamma H + H Gamma`, then contracts it to
Ricci and to a weighted connection action. Connection stationarity is
equivalent to vanishing of that derived response for every `H`; it is no
longer an assumed Palatini premise. On a periodic finite carrier, directed
differences cancel globally, and the zero connection is stationary for
constant volume and inverse metric. The canonical null-edge chart realizes
that control with its own reconstructed volume `1/2`, inverse metric, and
zero Levi-Civita connection.

`FinitePeriodicPalatiniEulerEquation` localizes the same response without a
continuum assumption. Ordered component probes give an exact six-term Euler
coefficient: two backward differences of the densitized inverse metric and
four connection cross terms. Vanishing of every coefficient is equivalent to
the unrestricted connection equation; for torsion-free variations, vanishing
of the symmetric coefficient pair is equivalent to stationarity. This audit
does not produce the hoped-for Levi-Civita theorem. On an exact three-site
conformal null-edge chart, the forward-difference Christoffel candidate has
coefficient `-95` and fails even torsion-free stationarity. Thus the pointwise
architecture has been falsified as the general finite Palatini bridge; it is a
controlled flat-limit model, not the connection dynamics to refine.

`NullEdgePalatiniJointAction` composes the aggregate coframe and independent
connection channels in one displayed two-field action. At the null-edge
Levi-Civita base, its aggregate-weight partial equation is exactly the finite
Einstein equation, while its connection partial equation is exactly the
finite connection Euler-Lagrange functional above. This removes the prior
bookkeeping gap between two separately named actions. The local no-go shows
that its present pointwise connection channel does not generally select the
null-edge Levi-Civita connection and must be replaced, not merely completed.

`FinitePeriodicLinkConnection` starts the corrected curvature branch without
silently changing that result. Transport is group-valued and attached to
directed links; the two elementary paths across a plaquette have a
group-valued comparison holonomy. For commuting periodic shifts, the holonomy
transforms by conjugation at the base site, every class-function observable is
gauge invariant, and flatness is exactly elementary path independence. The
periodic loop is also proved to be the conjugated inverse of the trusted
causal-diamond defect, accounting exactly for orientation and basepoint.
`GraphPlaquetteCurvatureLimit` supplies a complementary exact nonzero matrix
witness whose identity-subtracted holonomy divided by plaquette area converges
to a commutator curvature.

`FinitePeriodicLinkPalatiniVariation` now supplies the missing additive
tangent control. A real connection variation lives on directed links,
curvature is the oriented plaquette curl, and an ordered face field supplies
the abstract bivector/dual-volume weight. Commuting shifts make both the curl
and action invariant under additive vertex-gauge shifts. Exact periodic
summation by parts
rewrites the full first response as a sum of local link Euler coefficients.
For an antisymmetric face field, connection stationarity is equivalent to
vanishing of its backward discrete divergence, the finite adjoint shape of
`D(e wedge e) = 0`. Site-constant face fields give a nonvacuous stationary
control. This is a linearized consistency theorem, not yet the nonlinear
Lorentz-group action: the face field and its metric dual-cell factor must be
derived from the null coframe geometry, and its divergence equation must be
proved to select the corresponding Levi-Civita link transport.

`FinitePeriodicCovariantLinkPalatiniVariation` lifts this statement to an
arbitrary finite real fiber with an unconstrained real transport matrix on
each directed link. The predecessor matrix enters the exact backward operator
through its algebraic transpose. Finite component probes prove that
stationarity is equivalent to vanishing of every transported local Euler
component, and antisymmetric face weights again reduce the equation to
vanishing covariant backward divergence. Identity transport with
site-constant fiber-valued face data is an explicit stationary control. This
closes the finite transported-adjoint algebra without assuming orthogonality;
the physical Lorentzian successor must replace transpose by the selected
Krein adjoint and verify the bivector representation convention.

`FinitePeriodicKreinLinkAdjoint` supplies that adjoint algebra abstractly. A
finite fundamental symmetry `J` defines `[u,v]_J = <J u,v>` and
`U^sharp = J U^T J`. The module proves symmetry of the pairing, the exact
transport-adjoint identity, and periodic summation by parts with `U^sharp` on
the predecessor link, without assuming that `U` is orthogonal. It also proves
that `J = I` recovers the Euclidean transpose theorem. What remains is no
longer the adjoint formula itself. The module includes an explicit diagonal
`(3,3)` six-component control.

`LorentzBivectorKreinBridge` now derives that control from spacetime rather
than naming its signs by hand. In the ordered basis
`(e1 wedge e2, e1 wedge e3, e2 wedge e3, e0 wedge e1,
e0 wedge e2, e0 wedge e3)`, the determinant pairing induced by the
mostly-minus metric is exactly `diag(+,+,+,-,-,-)`: spatial rotation planes
are positive and time-space boost planes are negative. The exterior-square
matrix of every eta-Lorentz four-vector transport preserves this pairing.
In particular, the concrete `SL(2,C)` action already soldered to the null
edges supplies an admissible six-component transport, and `J U^T J` acts as
its inverse. The physical convention and representation gate is therefore
closed.

`LorentzBivectorLieAlgebraBridge` closes the next representation mismatch.
The same ordered six-component fiber is proved equivalent to the matrix
Lorentz Lie algebra through `hat(B)=F(B) eta`, with exact two-sided coordinate
recovery. Its indefinite bivector pairing is exactly
`-1/2 tr(hat(B)hat(C))`. A nonlinear plaquette tangent can therefore be paired
with the coframe bivector only after it is proved to lie in this six-dimensional
Lorentz image; pairing a six-vector directly with an unconstrained matrix
holonomy would be the wrong mathematical shape.

`LorentzPlaquetteTangent` closes that nonlinear representation gate. For
right-trivialized link insertions `delta U = U hat(X)`, the exact formal
product/inverse response `delta H H^(-1)` of the group plaquette is proved to
equal a four-corner sum of adjoint-transported Lorentz generators. Eta-Lorentz
links keep the result inside the Lorentz Lie algebra, so the existing
six-coordinate equivalence applies without projecting an unconstrained
matrix. At identity transport the formula reduces exactly to the oriented
additive plaquette curl. This is an exact response one-form, not yet a theorem
that it integrates globally to the desired scalar holonomy action.

`NonlinearLorentzPalatiniAction` supplies the corresponding scalar ordered
holonomy functional
`-1/2 tr(hat(B_ab)(H_ab-I))`. Its formal product/inverse response is
`-1/2 tr(hat(B_ab) delta H_ab)`; equivalently, the right-trivialized tangent is
multiplied by the exact plaquette holonomy away from identity. The module proves
`H_ba=H_ab^(-1)`, so ordered face antisymmetry has the expected
`H-H^(-1)` architecture, and proves that both the action and response have the
correct flat controls. At identity links the formal response agrees exactly
with the existing coframe-derived Krein/additive response, including its
normalization. The bivector-generator intertwiner and trace cyclicity further
prove vertex-gauge invariance of the full action for any face field already
transforming by the exterior-square Lorentz representation. Proper-Lorentz
Hodge commutation now proves that the concrete complementary coframe face has
this transformation law, so the displayed coframe action is exactly invariant
under pointwise proper Lorentz gauge transformations. On identity links,
formal stationarity is exactly the complementary-face Krein divergence
equation, and the constant coframe is a nonvacuous stationary flat control. A
canonical matrix-exponential link curve now realizes every six-component
variation, and the ordinary derivative of the action is exactly the displayed
formal response. The exponential factor is eta-Lorentz with determinant
`+1`, so the full curve remains in the proper eta-Lorentz subgroup whenever
the base connection does. The orthochronous sign remains a separate gate.

`NonlinearLorentzPalatiniEuler` now closes the finite nonidentity Euler
bookkeeping. It reorganizes the exact global formal response into four local
families for each varied directed link: two insertions based at that link and
two predecessor-site insertions reindexed by the periodic shifts. Each local
functional is a real linear map on the six Lorentz-generator coordinates.
Supported site/direction/component probes extract its six ordinary
coefficients, and formal connection stationarity is equivalent to vanishing
of every coefficient. This is the exact nonlinear finite link equation for
the displayed action derivative, but not yet a Levi-Civita-selection result.

`NonlinearLorentzPalatiniCoframeVariation` differentiates the same displayed
scalar action in its coframe argument. The exact affine-line expansion is
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
is a decorated nonflat refinement witness, not a proof that null-edge graph
dynamics selects it or that it is stationary.

`PhysicalLorentzPlaquetteEinsteinAudit` now resolves that stationarity question
for the static identity-coframe square. The mixed vacuum Einstein equations
annihilate five of the six target coordinates and leave only an internal `23`
rotation on the spacetime `01` plaquette. The survivor is Ricci-invisible but
fails metric-lowered curvature pair exchange because `F_01^23` has no
`F_23^01` partner. An
exact nonlinear link Euler coefficient supplies the missing test: after
division by plaquette area it converges to twice the surviving amplitude.
Thus every nonzero target is incompatible with joint stationarity at all
levels of a shrinking refinement when the coframe is fixed to the identity.
The physical square remains a valid nonflat curvature-refinement witness, but
it is not a static vacuum solution. A successful nonflat branch must carry a
varying coframe and a richer face pattern; the theorem does not yet select or
construct that branch.

`VacuumWeylCurvatureTarget` closes the algebraic target side of that next
branch. In the ordered bivector basis `(12,13,23,01,02,03)`, it constructs the
two-parameter diagonal curvature pattern
`(-x-y,y,x,x,y,-x-y)`. The complete local tensor is face-antisymmetric,
exchange-symmetric after both internal indices are lowered with eta, and obeys
the algebraic first Bianchi identity. Its mixed Ricci tensor and scalar vanish
at the identity coframe, so all mixed vacuum Einstein entries vanish. The unit
choice `(x,y)=(1,0)` is kernel-checked nonzero. This is a convention-correct
vacuum-Riemann target, not yet a proper-Lorentz plaquette realization or a
stationary varying-coframe solution.

`PeriodicVacuumWeylMeanObstruction` closes two tempting but invalid periodic
realizations. Every internal component of every additive plaquette curl has
exactly zero site sum on a finite periodic carrier. Hence a fixed nonempty
carrier cannot realize, or converge componentwise at every site to, one
site-independent nonzero Weyl tensor. Zero mean alone is not enough: the
module also proves the exact three-direction discrete Bianchi identity. If
either parameter of the full diagonal Weyl family varies by site while its
bivector eigenplanes remain fixed, Bianchi forces both parameters to be
invariant under all four shifts. The scalar unit-amplitude specialization and
explicit `2 x 2` zero-mean checkerboard are therefore not periodic additive
link curvatures. A viable varying-coframe branch must mix local
frames/components nontrivially, use boundary or twisted-bundle data, or prove
a nonlinear scaling whose leading curvature is not a global additive curl.

`PeriodicVacuumWeylNullWave` supplies the first constructive realization of
the required frame/component mixing. On a two-site carrier, the time and
longitudinal shifts toggle the same period-two null coordinate while the two
transverse shifts are trivial. Two transverse link potentials valued in
null-rotation bivectors have an exact additive curl with opposite nonzero
amplitudes at the two sites. The resulting plus-polarized null-wave curvature
is face-antisymmetric, symmetric under metric-lowered pair exchange, obeys
algebraic and discrete Bianchi, and has zero mixed Ricci, scalar, and Einstein
entries pointwise at the identity coframe.

`PeriodicVacuumWeylNullWaveProperLift` exponentiates this potential exactly.
The two nilpotent null-rotation generators commute, so every group plaquette is
the exponential of the additive curl without a BCH correction. Every link is
proper eta-Lorentz, the trace extractor returns exactly area times the
null-wave curvature, and the identity coframe is exactly stationary in the
finite Einstein sector. The independent connection equation does not vanish:
one displayed link Euler coefficient is exactly `-2 * area`. Thus at every
nonzero area the identity coframe is not connection-stationary or jointly
stationary.

The conformal, axial, diagonal, and full-coframe successors classify the
remaining fixed-link possibility. Nonzero global conformal rescaling leaves
both Euler solution sets unchanged. The null-wave coframe equations have rank
six at each site and their complete kernel is a ten-parameter matrix family.
Its determinant is
`-(a+i)(e^2-fh)(i-j)`, while two exact link equations force
`area (a+i)(i-j)=0`. Therefore at nonzero area every jointly stationary member
is singular: no invertible varying coframe, even with arbitrary off-diagonal
shear, repairs these fixed links. A viable witness must now include
simultaneous connection/coframe backreaction, a larger carrier, or modified
finite dual-cell weights. Levi-Civita compatibility and graph-derived
refinement remain open.

`LorentzCoframePalatiniFace` now separates two face notions that the four-form
must not conflate. With orientation `0123`, it defines the Lorentz Hodge star,
proves `star^2=-1`, and constructs the internal bivector building block
`star(e_a wedge e_b)`. If `(a,b)` label the actual curvature plaquette, its
coefficient is instead the complementary contraction
`(1/2) sum_cd epsilon^(cdab) star(e_c wedge e_d)`. All six canonical
complement signs are checked; in particular, curvature face `01` receives the
coframe plane `23`. This matches the permutation architecture of Kur and
Glasser, arXiv:2202.02486, Eqs. (15), (16), and (25).
`FinitePeriodicCoframeKreinPalatiniVariation` inserts the complementary field
into the full Krein link response: stationarity is exactly vanishing
Krein-covariant backward divergence of that curvature-face coefficient, with a
constant-coframe identity-link control. Proper local Lorentz covariance is
exact; a metric dual-cell volume factor remains a separate gate.

The internal sign is now pinned as well: in the ordered six-vector convention,
the Krein pairing of `star(B)` with `C` is minus
`(1/4) epsilon_IJKL B^IJ C^KL`. This global sign does not alter the vacuum
connection equation, but the eventual joint gravity-matter action must absorb
it in the gravitational prefactor or curvature-orientation convention before
matching the repo's positive-sign Einstein equation.

`FinitePeriodicKreinLinkPalatiniVariation` completes the linearized assembly.
It pairs the ordered face response with the derived indefinite product,
derives the exact local `J U^T J` Euler coefficient, and uses `J`-raised
component probes to prove that stationarity is equivalent to ordinary
componentwise coefficient vanishing. For antisymmetric faces this is exactly
vanishing Krein covariant backward divergence. Its Lorentz-bivector
specialization and identity-transport/site-constant control are explicit.

This is a meaningful finite reconstruction, but it does not yet close F8.
The four edge labels and their synchronization are decorated chart data, and
the null-edge Gram metric has not been identified with the independently
recovered causal-operator metric required by Contract 1. The forward-difference
curvature is not yet proved locally Lorentz covariant or equivalent to
plaquette/Dirac-square curvature. The joint action now derives both partial
equations, but its pointwise connection equation is now proved incompatible
with the forward Levi-Civita candidate on a conformal null-edge witness. The
replacement now has exact scalar and finite-fiber link/face Palatini
divergences, including predecessor transport through the finite-fiber
transpose adjoint, an abstract exact Krein predecessor adjoint, a derived
Lorentz-bivector `J` preserved by the null-edge `SL(2,C)` action, and the full
Krein-paired face Euler/divergence theorem. The six-component bivector fiber
is now also exactly identified with the matrix Lorentz Lie algebra, including
its normalized trace pairing. The local curvature-face coefficient is now
derived with the complementary spacetime alternating-symbol contraction and
inserted into the divergence equation. The exact group-plaquette tangent is
now proved to return to this Lie algebra and to recover the additive curl at
identity transport. A scalar ordered holonomy action and matching formal
response are also explicit, and canonical invertible exponential link curves
realize it as the ordinary derivative. They remain in the proper eta-Lorentz
subgroup when based there; the orthochronous sign is not yet proved. The same
action now has an ordinary coframe derivative, sixteen local tetrad equations,
joint `6 + 16` stationarity, and an exact rewrite as a Palatini pairing with an
extracted antisymmetric curvature field. Its arbitrary-coframe
determinant/scalar-curvature contraction and determinant-weighted action are
now exact. The coframe-response successor further identifies every local
tetrad Euler coefficient with `det(e)` times the mixed Einstein coefficient,
so the finite coframe stationarity equation is now exact. The program must
now construct a graph-derived refinement satisfying the action-visible
curvature and varying-coframe convergence interfaces, identify its target with common
Levi-Civita Riemann curvature, derive the metric dual-cell factor, rerun the
conformal witness on the nonlinear link Euler coefficients, and test whether
that separate connection equation selects Levi-Civita transport rather than
reinterpret the failed pointwise coefficient.
Aggregate weights solve finite
metric coverage, but their selection and transformation law must still be
derived from the order/operator sector rather than simply decorated by hand.

Finally, `EinsteinEquationVariation` and
`LocalEinsteinEquationVariation.parameterStationary_iff_localFiniteEinsteinEquation`
make the final finite variational implication exact, including arbitrary
site-supported symmetric variations. For nonzero coupling, vanishing response
at every selected site is equivalent to the pointwise equations
`G(x) + Lambda g(x) = kappa T(x)`; if an actual parameter action has that
pulled-back first variation and full local metric reach, ordinary stationarity
is equivalent to the same local field equation. The companion conservation
theorem composes a differentiated field equation with the explicit finite
contracted Bianchi identity. This advances the F7/F8 interface, but does not
close F8: the graph must identify its operator metric with the null-edge Gram
metric, derive the selected synchronized frame and connection equation, prove
the local curvature-variation residual is the displayed incidence divergence,
match the curvature routes, handle physical boundaries, and establish
variation-limit interchange.

## 3. Five consistency contracts

These contracts prevent the repo from accumulating mutually incompatible
finite gravities.

### Contract 1: one metric

The causal-operator pairing and count volume define the physical metric. Every
coframe theorem must prove that its Gram metric is this metric. A separate
coframe fit is only a control until that equality is established.

### Contract 2: one curvature

At refinement, the following must agree after convention and index conversion:

\[
 R_{\rm LC}=R_{\rm holonomy}=R_{\rm operator}=R_{D^2}.
\]

Finite Bianchi identities do not prove this agreement. Persistent disagreement
kills a common geometric interpretation. Torsion and nonmetricity must either
converge to zero on the Levi-Civita route or enter a separately proved
equivalent formulation; they cannot be silently absorbed into curvature.

### Contract 3: one matter geometry

Scalar, Higgs, fermion, and gauge actions must use the same measure, inverse
metric, coframe, and connection. Channel-dependent metric estimators or
gravitational couplings violate the intended equivalence-principle reading.

### Contract 4: one primary action

The order/operator action is the primary dynamics candidate. Spectral,
thermodynamic, and teleparallel constructions are comparisons until an
equivalence theorem identifies them with the same action including boundary
terms and constants.

### Contract 5: one refinement law

Every local object needs a common refinement interface: carriers, probe
algebras, projectors, metric, orientation, spin lifts, connection, curvature,
matter fields, and action. Pointwise witnesses without overlap and refinement
compatibility are finite models, not continuum reconstruction.

## 4. What the literature changes

### Order plus number is the right kinematical split

Hawking-King-McCarthy and Malament show, under explicit causality hypotheses,
that causal data determine continuum topology/differentiable/conformal
structure. They do not recover the conformal factor. The causal-set proposal
adds local finiteness/counting as the volume input. This supports the repo's
order-versus-scale split, but only after a manifoldlike correspondence is
proved.

### Lorentz invariance is statistical, not a finite frame

Poisson sprinkling can preserve Lorentz symmetry in distribution. The
Bombelli-Henson-Sorkin theorem excludes a measurable Lorentz-equivariant map
from a sprinkling to a preferred direction, and in particular blocks a
canonical intrinsic finite-valency frame. The repo's move from preferred
vectors to natural subspaces and gauge-relative frames is therefore not merely
convenient; it matches the known obstruction.

### Reconstruction and dynamics are separate research programs

Faithful embedding, thickened-antichain topology, dimension estimators, and
operator convergence concern reconstruction on manifoldlike inputs. The fact
that most large finite orders are not manifoldlike creates a separate entropy
and dynamics problem. Results suppressing one class of nonmanifoldlike orders
under a causal-set action are encouraging but not a general selection theorem.

### The scalar operator is the highest-leverage bridge

Benincasa-Dowker operators recover `Box - R/2` in an appropriate mean
continuum limit. Their principal symbol therefore carries the inverse metric,
while their constant response carries scalar curvature. The repo's corrected
pairing is the right algebraic device because it cancels the curvature
potential exactly before taking a limit.

The recent local causal-set d'Alembertian offers a serious alternate estimator.
It proves a Minkowski continuum result using intrinsic timelike and spacelike
neighborhoods, but it does not remove the repo's dimension, scale, curved-limit,
and dynamical-selection debts. The local and compact-nonlocal branches should
share the same F1 benchmark rather than become two foundations.

### The action route must include boundaries

The Benincasa-Dowker-Glaser action has a studied continuum limit on causal
diamonds with an Einstein-Hilbert bulk term and a codimension-two joint term.
This strengthens the interval-count action route and shows why the boundary
sector cannot be postponed until after the bulk field equation.

### Finite first-order gravity needs link and face data

First-order Regge and simplicial Palatini formulations place finite connection
variables on links, faces, or codimension-one simplices and build curvature
from holonomy around codimension-two faces. Discrete exterior calculus obtains
the adjoint derivative through a primal/dual complex and a Hodge star. These
constructions do not prove the null-edge action, but they identify what a
credible successor must contain: group-valued transport, an oriented
face/dual-cell measure, and a variational pairing that respects the discrete
adjoint. A pointwise forward Christoffel formula supplies none of those by
itself. The exact `-95` conformal witness now turns that structural warning
into a finite no-go for the current pointwise action.

## 5. Repository simplification

The documents now have distinct jobs:

| Artifact | Canonical role |
|---|---|
| `Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md` | Stable architecture, completeness checklist, and literature-grounded claim boundary |
| `PhysicsSM/Draft/NullEdge/GRFoundations.lean` | Lean import facade for the load-bearing finite theorem modules |
| `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` | Detailed theorem ledger, experimental history, negative results, and conditional continuum theorem |
| `AutonomousLab/work/DIRECTOR_REVIEW_PACKET_2026-07-16.md` | Time-local experimental and governance status |
| `Sources/Null_Edge_Derivation_Map_SM_GR_2026-07-17.md` | Cross-program SM/GR dependency map |

Future GR work should attach to exactly one F-gate and name which consistency
contract it advances. A capstone that only imports several avatars does not
advance a gate. A new estimator should replace or compare with the canonical
one on a preregistered common benchmark; it should not silently create another
metric, curvature, or action.

## 6. Immediate program

1. **Finish the F4 selector theorem.** Derive a canonical rank-four selected
   sector with a nonzero four-mode gap, mostly-minus inertia, overlap transport,
   and refinement persistence. The marked Alexandrov 1+3 construction is a
   conditional witness, not yet the selector.
2. **Split G0 permanently into F1 and F2.** First prove convergence on known
   sprinklings. Then test whether the chosen dynamics concentrates on the
   preregistered manifoldlike domain. Never use success at F1 as evidence for
   F2.
3. **Close the curvature triangle before adding dynamics avatars.** Compare
   Levi-Civita, holonomy, and operator curvature on the same reconstructed
   metric and refinement schedule. Use the periodic link/plaquette substrate
   for the holonomy corner, and only then test the Dirac `R/4` term.
4. **Complete the nonlinear Palatini-to-Einstein bridge.** The additive
   link tangent, oriented plaquette curl, scalar and transported finite-fiber
   face pairings, exact transpose adjoint, and flat/site-constant controls are
   now proved, together with the abstract `J U^T J` Krein predecessor adjoint
   and the spacetime-derived rotation/boost basis preserved by the null-edge
   `SL(2,C)` action, followed by the full Krein-paired face Euler and
   antisymmetric-divergence theorem. The exact Lorentz-group plaquette response
   and its additive limit are now available, together with a scalar ordered
   holonomy action whose formal response has the correct nonlinear holonomy
   weight, and the exact four-family nonidentity local Euler coefficients are
   now available, and canonical proper eta-Lorentz exponential curves realize
   the response as an ordinary derivative. The same action now also has an
   ordinary coframe derivative, sixteen tetrad equations, joint stationarity,
   an exact antisymmetric-curvature Palatini rewrite, and the exact
   determinant-weighted scalar-curvature action. The exact coframe response
   and stationarity-to-mixed-Einstein identity are now closed. The continuous
   action-visible extractor and fixed-coframe refinement theorem also pass
   stationary finite equations to the limiting mixed vacuum equation under a
   supplied first-order holonomy expansion. Derive that expansion and coframe
   convergence from the graph, prove the separate orthochronous sign, derive
   the remaining dual-volume weight, rerun the conformal witness, and test
   Levi-Civita selection. The
   nonlinear replacement must avoid the proved
   `-95` pointwise obstruction and select Levi-Civita transport before any
   continuum claim.
5. **Localize one matter action.** Generalize the existing scalar/Higgs
   variations to arbitrary symmetric local metric or coframe probes and prove
   the finite Noether interface. The coefficient-identification and
   Bianchi-to-conservation endpoints are now exact; the missing step is to
   derive their variation and differentiated-field-equation premises from the
   same local action.
6. **Promote one interval-count action.** Include bulk, boundary, constants,
   matter coupling, and variation-limit interchange in one statement, using
   the exact stationarity theorem as its endpoint. The affine layer-weight
   derivative is now exact, but a globally shared list needs at least ten
   directions per site and therefore cannot remain fixed under refinement.
   The event-local replacement now passes those tests on an explicit
   supplied-probe chain and conditionally composes across selected bulk sites.
   Next derive the probe frames and row-rank certificate from the physical
   operator/atlas, then identify the resulting response with curvature. Keep
   thermodynamic, spectral, and teleparallel routes as checks.
7. **Run independent physical controls last.** Newtonian gravity, redshift,
   geodesic motion, tensor waves, FLRW, and horizon behavior should test the
   derived continuum package rather than define it piecemeal.

## 7. Primary literature

1. S. W. Hawking, A. R. King, and P. J. McCarthy, "A new topology for curved
   space-time which incorporates the causal, differential, and conformal
   structures," [doi:10.1063/1.522874](https://doi.org/10.1063/1.522874).
2. D. B. Malament, "The class of continuous timelike curves determines the
   topology of spacetime,"
   [doi:10.1063/1.523436](https://doi.org/10.1063/1.523436).
3. L. Bombelli, J. Lee, D. Meyer, and R. D. Sorkin, "Space-time as a causal
   set," [doi:10.1103/PhysRevLett.59.521](https://doi.org/10.1103/PhysRevLett.59.521).
4. L. Bombelli, J. Henson, and R. D. Sorkin, "Discreteness without symmetry
   breaking: a theorem,"
   [arXiv:gr-qc/0605006](https://arxiv.org/abs/gr-qc/0605006).
5. S. Major, D. Rideout, and S. Surya, "On recovering continuum topology from
   a causal set,"
   [arXiv:gr-qc/0604124](https://arxiv.org/abs/gr-qc/0604124).
6. D. P. Rideout and R. D. Sorkin, "A classical sequential growth dynamics
   for causal sets,"
   [arXiv:gr-qc/9904062](https://arxiv.org/abs/gr-qc/9904062).
7. D. M. T. Benincasa and F. Dowker, "The scalar curvature of a causal set,"
   [arXiv:1001.2725](https://arxiv.org/abs/1001.2725).
8. A. Belenchia, D. M. T. Benincasa, and F. Dowker, "The continuum limit of a
   4-dimensional causal set scalar d'Alembertian,"
   [arXiv:1510.04656](https://arxiv.org/abs/1510.04656).
9. L. Machet and J. Wang, "On the continuum limit of Benincasa-Dowker-Glaser
   causal set action,"
   [arXiv:2007.13192](https://arxiv.org/abs/2007.13192).
10. S. P. Loomis and S. Carlip, "Suppression of non-manifold-like sets in the
    causal set path integral,"
    [arXiv:1709.00064](https://arxiv.org/abs/1709.00064).
11. S. Surya, "The causal set approach to quantum gravity,"
    [arXiv:1903.11544](https://arxiv.org/abs/1903.11544).
12. M. Boguna and D. Krioukov, "Local d'Alembertian for causal sets,"
    [arXiv:2506.18745](https://arxiv.org/abs/2506.18745).
13. J. W. Barrett, "First order Regge calculus,"
    [arXiv:hep-th/9404124](https://arxiv.org/abs/hep-th/9404124).
14. S. Gionti, "Discrete gravity as a local theory of the Poincare group in
    the first order formalism,"
    [arXiv:gr-qc/0501082](https://arxiv.org/abs/gr-qc/0501082).
15. V. M. Khatsymovsky, "Affine connection form of Regge calculus,"
    [arXiv:1509.04974](https://arxiv.org/abs/1509.04974).
16. V. M. Khatsymovsky, "Simplicial Palatini action,"
    [arXiv:1705.06654](https://arxiv.org/abs/1705.06654).
17. M. Desbrun, A. N. Hirani, M. Leok, and J. E. Marsden, "Discrete exterior
    calculus," [arXiv:math/0508341](https://arxiv.org/abs/math/0508341).
18. E. Kur and A. S. Glasser, "Discrete gravity with local Lorentz
    invariance," [arXiv:2202.02486](https://arxiv.org/abs/2202.02486).

## Bottom line

The fundamentals are conceptually present, but not yet complete as theorems.
The correct unification is not to merge every finite gravity avatar. It is to
enforce one order/count core, one operator-derived metric, one gauge-relative
coframe, one curvature in several equivalent representations, one matter
variation, and one primary action, all on one refinement and probability
space.

The resulting honest claim remains:

> A finite null-edge Lorentzian and Dirac geometry with a precise,
> literature-grounded reconstruction program for general relativity.

The missing theorem is the passage from the model's own causal histories to a
selected manifoldlike continuum satisfying the entire spine.
