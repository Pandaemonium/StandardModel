import PhysicsSM.Draft.NullEdge.NullEdgeSpinorSolderingAristotle
import PhysicsSM.Draft.NullEdge.NullEdgeSolderingPluckerBridge
import PhysicsSM.Draft.NullEdge.SchadenProperTimeBridge
import PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator
import PhysicsSM.Draft.NullEdge.CausalOperatorWeakGeometry
import PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction
import PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction
import PhysicsSM.Draft.NullEdge.ProbeFrameWeylScaleBridge
import PhysicsSM.Draft.NullEdge.RankFourCarrierProbeSector
import PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator
import PhysicsSM.Draft.NullEdge.CorrectedPairingSelectedSectorWitness
import PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia
import PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle
import PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup
import PhysicsSM.Draft.NullEdge.LorentzAtlasSpinLiftBoundary
import PhysicsSM.Draft.NullEdge.CausalMetricFirstJet
import PhysicsSM.Draft.NullEdge.CausalLeviCivita
import PhysicsSM.Draft.NullEdge.FiniteConnectionGeometry
import PhysicsSM.Draft.NullEdge.FiniteCartanBianchi
import PhysicsSM.Draft.NullEdge.FiniteContractedBianchi
import PhysicsSM.Draft.NullEdge.EinsteinEquationVariation
import PhysicsSM.Draft.NullEdge.DiscreteCausalActionVariationNoGo
import PhysicsSM.Draft.NullEdge.RelaxedCausalMetricVariationBridge
import PhysicsSM.Draft.NullEdge.LayerWeightMetricRankNoGo
import PhysicsSM.Draft.NullEdge.WeightedIntervalActionVariation
import PhysicsSM.Draft.NullEdge.LocalizedIntervalActionMetric
import PhysicsSM.Draft.NullEdge.LocalEinsteinEquationVariation
import PhysicsSM.Draft.NullEdge.LocalizedIntervalAffineActionNoGo
import PhysicsSM.Draft.NullEdge.FiniteEinsteinHilbertActionResponse
import PhysicsSM.Draft.NullEdge.CoframeVolumeMetricVariation
import PhysicsSM.Draft.NullEdge.FinitePalatiniEinsteinHilbertVariation
import PhysicsSM.Draft.NullEdge.FinitePalatiniBoundaryCancellation
import PhysicsSM.Draft.NullEdge.FinitePalatiniCoframeChartAction
import PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge
import PhysicsSM.Draft.NullEdge.SchadenNullFrameAdmissibility
import PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein
import PhysicsSM.Draft.NullEdge.NullEdgeAggregateCoframeEinstein
import PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation
import PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation
import PhysicsSM.Draft.NullEdge.NullEdgePalatiniJointAction
import PhysicsSM.Gauge.CausalDiamondHolonomy
import PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
import PhysicsSM.Draft.NullEdge.FinitePeriodicLinkPalatiniVariation
import PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
import PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
import PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
import PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
import PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
import PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
import PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
import PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
import PhysicsSM.Draft.NullEdge.ProperLorentzExponential
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniWeakEinsteinLimit
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerChangingCarrierTorsion
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerSampledCoframeTorsion
import PhysicsSM.Draft.NullEdge.VacuumWeylPeriodicRefinementAristotle
import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveJointNoGo
import PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface
import PhysicsSM.Draft.NullEdge.GraphPlaquetteCurvatureLimit
import PhysicsSM.Draft.NullEdge.FiniteGravityConservation
import PhysicsSM.Draft.NullEdge.HiggsHilbertStress
import PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation
import PhysicsSM.Draft.NullEdge.DiagonalScalarGradientStressVariation
import PhysicsSM.Draft.NullEdge.ADMShiftScalarFluxVariation
import PhysicsSM.Draft.NullEdge.FlatFLRWFriedmannControl
import PhysicsSM.Draft.NullEdge.FlatFLRWAccelerationControl

/-!
# Null-edge general-relativity foundations facade

This module is the canonical Lean entry point for the load-bearing finite
identities in the null-edge general-relativity program. It deliberately
imports one representative route through each established layer:

1. spinor-to-null soldering, null-to-timelike aggregation, and the six-length
   forward/backward null-simplex admissibility boundary;
2. finite causal order, the scalar causal operator, and its corrected
   principal-symbol pairing;
3. scale identifiability, relative Weyl scaling, rank-four probe sectors,
   and the current conditional mostly-minus witness;
4. coframe gauge, Lorentz-atlas, and spin-lift boundaries;
5. metric first jets, the finite Levi-Civita construction, curvature, and
   Bianchi;
6. Hilbert/coframe matter variation, discrete graph-variation no-go,
   graph-native weighted interval derivative, relaxed metric pullback,
   the ten-per-site global-weight rank obstructions in four dimensions,
   an event-local action/operator-metric construction with a rank-ten and
   fiber-descent witness, the exact affine-action nonstationarity obstruction,
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
    link Euler coefficients and stationarity equation, its realization as the
    ordinary derivative along canonical exponential link curves, exact
    preservation of the proper eta-Lorentz subgroup along those curves, the
    exact coframe derivative and sixteen local tetrad coefficients of the same
    action, their joint stationarity with the six link coefficients, and an
    exact Palatini rewrite using the extracted antisymmetric six-component
    plaquette curvature, together with exact arbitrary-coframe determinant
    and coframe-response Einstein normalizations, an exact continuous
    action-visible curvature extractor, a nonzero proper eta-Lorentz periodic
    plaquette refinement, its exact identity-coframe Einstein classification
    and static joint-stationarity no-go, a concrete nonzero algebraic
    vacuum-Weyl target satisfying metric-lowered pair exchange and first
    Bianchi, the exact periodic zero-mean and discrete-Bianchi obstructions to
    realizing it as a site-independent or scalar-checkerboard additive curl,
    and a two-site periodically exact null-wave curvature that mixes bivector
    planes, lifts to exact proper eta-Lorentz links, satisfies all
    identity-coframe vacuum-Riemann and coframe-stationarity tests, has a
    complete rank-six coframe response with a ten-parameter Einstein kernel,
    and admits no invertible jointly stationary coframe at nonzero area while
    those exact links are held fixed,
    and a conditional passage from finite coframe
    stationarity with convergent varying tetrads to the limiting mixed vacuum
    Einstein equation, exact finite weak-test equivalents of those pointwise
    equations, a conditional changing-carrier weak endpoint, and exact
    arbitrary-invertible-tetrad linearized torsion selection at identity link
    transport with its finite quadratic spacing defect, followed by affine
    connection-dependent Cartan torsion selection, its exact cubic finite
    spacing defect, shrinking endpoint, and explicit nonvacuity family,
    followed by the actual exponential-link Euler first-jet equivalence to
    Cartan torsion for site-uniform connection jets, the exact general
    Cartan-plus-neighbor-defect decomposition, its constant-mode invariance,
    exact homogeneity, nonzero period-two witness, and conditional
    shrinking-neighbor torsion-selection endpoint, followed by local-stencil
    defect convergence on changing carriers, a sampled continuous-connection
    Cartan endpoint, and a differentiable sampled-tetrad endpoint on affine
    predecessor rays in a supplied pointed chart, and
    the full Krein-paired link/face Euler chain with a coframe-derived
    Lorentz-Hodge face field,
   causal-diamond path-comparison holonomy, and an exact shrinking-plaquette
   curvature limit,
   the exact sitewise stationarity-to-Einstein-equation implication,
   conditional source conservation, and imported FLRW controls.

The facade adds no umbrella theorem. In particular, importing it does not
assert manifoldlikeness, dimension selection, stochastic concentration, a
graph-derived refinement family, the required convergence hypotheses,
equivalence of forward-difference and plaquette curvature, identification of
the limiting target with Levi-Civita Riemann curvature, or unconditional
recovery of the continuum Einstein equation. It imports the
exact finite action derivative and conditional pullback and stationarity
implications, together with a necessary ten-parameter lower
bound at one site and a ten-per-site local-field lower bound. It also imports
an event-local construction whose derivative and same-operator metric are
exact and whose eleven-event chain has full rank and trivial metric fibers.
That interval action is nevertheless affine: a guarded theorem proves that neither it
nor its descended metric action has a stationary point in the nonzero chain
witness. The Palatini route now derives the coframe determinant volume
response, proves exact finite incidence summation by parts, and shows that a
local Ricci-plus-divergence curvature response produces the volume-weighted
Einstein tensor. An actual nonlinear coframe-chart action has the resulting
Einstein equation as its stationary equation at the chart origin. The newest
bridge derives its coframe, Gram metric, inverse metric, volume, forward
metric differences, Levi-Civita coefficients, coordinate curvature, symmetric
Ricci response, and scalar contraction from four independent spinor null
edges and their directed targets at every site. This remains a decorated-chart
finite theorem. Null-column-preserving tangents are proved insufficient for
full ten-component metric reach. The aggregate successor resolves that finite
coverage problem: every coframe is uniquely `E A` for the nondegenerate null
frame `E`, the metric-active generator for any symmetric variation is
explicit, skew frame generators are metric-invisible, and stationarity at
identity aggregate weights is equivalent to the finite Einstein equation.
The connection is now independently variable in the same displayed two-field
action: its partial derivative is the exact finite
`Delta H + Gamma H + H Gamma` response, and the canonical periodic flat chart
is a nonvacuous stationary control. On arbitrary periodic carriers the local
ordered-component coefficient is now derived exactly, and torsion-free
stationarity is equivalent to vanishing of its symmetric projection. The
current pointwise forward-difference architecture does not select the
null-edge Levi-Civita connection: an exact three-site conformal chart has local
coefficient `-95` and fails even torsion-free stationarity. The link-curvature
successor therefore has a separate exact
substrate: group-valued directed links, gauge-covariant two-step transport,
conjugation-covariant plaquette holonomy, gauge-invariant class observables,
an exact basepoint/orientation bridge to trusted causal-diamond holonomy, and
a nonzero shrinking-plaquette curvature control. Its additive tangent control
now pairs ordered face weights with vertex-gauge-invariant plaquette curls,
derives the exact local link Euler coefficient by periodic summation by parts,
and reduces the antisymmetric-face equation to vanishing backward discrete
divergence. The transported successor proves the same adjoint equation for an
arbitrary finite real fiber: the predecessor link enters through its matrix
transpose, and component probes make the equation pointwise in every fiber
component. The abstract Krein successor now
proves the exact predecessor formula `U^sharp = J U^T J` and its periodic
summation-by-parts identity for any finite fundamental symmetry `J`, and gives
an explicit diagonal `(3,3)` six-component control. The Lorentz-bivector
successor derives that control from the mostly-minus spacetime metric in the
ordered spatial-rotation then time-space-boost basis. It proves that every
eta-Lorentz four-vector matrix, including the concrete null-edge `SL(2,C)`
action, induces a six-component transport preserving `J`; its Krein adjoint
is an actual inverse action. The same six-component fiber is now proved
equivalent to the matrix Lorentz Lie algebra, with its Krein pairing exactly
the normalized matrix-trace pairing. The nonlinear plaquette successor proves
that the exact product/inverse tangent is a four-corner adjoint sum, remains in
that Lorentz Lie algebra for eta-Lorentz links, and reduces at identity
transport to the oriented additive plaquette curl. The Lorentz-Hodge successor
constructs
the internal bivector `star(e_a wedge e_b)` and then the complementary
curvature-face coefficient `(1/2) epsilon^(cdab) star(e_c wedge e_d)` from the
coframe, proves its antisymmetry, and inserts it into the full Krein-paired
successor. The latter
derives the ordered face-action Euler pairing, proves componentwise
stationarity, and reduces stationarity to vanishing Krein-covariant backward
divergence of this concrete coframe field. A nonlinear ordered holonomy action
is now displayed as
`-1/2 tr(hat(B_ab)(H_ab-I))`; its formal product/inverse response has the
required holonomy weight and agrees exactly with the Krein/additive response
at identity links. The generator intertwiner and trace cyclicity also prove
vertex-gauge invariance for every face field obeying the exterior-square
Lorentz transformation law. On identity links, formal connection stationarity
is exactly the complementary-face Krein divergence equation, with the constant
coframe as a nonvacuous flat solution. At arbitrary links, the exact formal
response is now the sum of four local link families, and formal stationarity
is equivalent to vanishing of all six local Lorentz-generator coefficients.
The proper-Lorentz Hodge commutation theorem now proves that both the internal
and complementary concrete coframe faces obey the required local law; combined
with holonomy conjugation, this gives exact gauge invariance of the displayed
concrete scalar action. Canonical link curves
`U exp(t hat(delta A))` now realize every six-component variation, and the
ordinary action derivative is exactly the nonlinear response; derivative
stationarity is therefore equivalent to the guarded local Euler coefficients.
These curves are proved to remain in the proper eta-Lorentz subgroup whenever
the base connection does; the separate orthochronous sign condition is still
open. Affine coframe lines now give an exact quadratic action expansion, so
the same scalar action has an ordinary coframe derivative, sixteen local
tetrad coefficients, and a guarded joint `6 + 16` stationarity theorem. Every
ordered holonomy trace functional is represented by an explicit
six-component Krein-dual curvature vector. Antisymmetrizing those vectors in
the plaquette directions leaves the complete action unchanged, yielding an
exact finite Palatini pairing with an antisymmetric curvature field. The
project Hodge, Krein, and bivector conventions further give the exact
identity-coframe normalization `PalatiniDensity(1,F) = -R(1,F)` for every
ordered curvature field. More generally, the bridge now proves
`PalatiniDensity(e,F) = -det(e) R(e^{-1},F)` from a supplied left inverse,
without face antisymmetry, and rewrites the concrete nonlinear action as the
corresponding determinant-weighted scalar-curvature sum. Its ordinary
coframe response is also exactly the sum of the extracted-curvature
Palatini-density responses. The response successor proves that each of its
sixteen local tetrad Euler coefficients is `det(e)` times the corresponding
coframe-index Einstein coefficient. Consequently, formal coframe stationarity
is exactly the finite mixed system `2 Ric^d_c - delta^d_c R = 0`, and joint
stationarity is the six-component link Euler system together with those
sixteen Einstein equations. The curvature-limit successor packages the six
trace probes as a continuous linear map on arbitrary plaquette matrix
increments and proves exact identity on Lorentz-generator coordinates. A
shrinking-area first-order group-holonomy expansion therefore gives
componentwise convergence of the same antisymmetrized curvature field used by
the action. For a fixed invertible coframe, if every refinement is coframe
stationary, the limiting target satisfies all mixed vacuum Einstein
equations. The varying-coframe successor proves joint continuity of the mixed
Einstein polynomial, shows that exact finite inverse coframes remain inverse
at the limit, and reaches the same endpoint when both tetrads and curvature
vary componentwise with refinement. The weak-limit successor proves that
finite delta tests recover every pointwise mixed equation, including with
explicit nonzero site-volume weights, and composes this with coframe
stationarity. It then permits the finite carrier to change with the refinement
level: convergence of the weighted pairings on a supplied test space forces
the limiting functional to vanish. This does not construct the test sampler,
volume weights, weak topology, or convergence proof. The linearized
torsion-selection successor addresses the other Palatini Euler sector. In the
project's exact 24-component conventions, the identity-tetrad connection
equation is equivalent to vanishing Cartan torsion. Its general-tetrad
successor conjugates the exterior-square action by the Lorentz Hodge matrix
and reduces every coframe with a supplied inverse to that identity theorem.
The finite face increment is the spacing times this linear equation plus an
explicit quadratic defect, so identity-link stationarity along shrinking
nonzero spacings with a fixed invertible center coframe and fixed first jet
forces that jet to be torsion-free, even when the finite carrier changes.
The exact exponential-transport successor realizes the affine transport
tangent by a proper eta-Lorentz matrix curve. The actual-action successor then
differentiates every corner of the concrete nonlinear link Euler coefficient.
At the identity coframe and connection, a general site-dependent connection
jet gives the center Cartan residual plus an explicitly expanded term made
only from neighboring-minus-center connection values. That defect is
invariant under adding a site-independent connection mode, vanishes for
uniform jets, scales exactly with the nonuniform amplitude, and equals `2` in
a sparse period-two null-wave-carrier witness. Consequently, stationarity
along any displayed family whose centered neighbor mode is scaled to zero
forces the fixed center data to be torsion-free. The changing-carrier successor
controls only the forward, predecessor, and translated-predecessor stencil
sites actually read by the Euler coefficient. When those sites approach one
supplied chart point, continuity of a sampled Lorentz connection proves defect
convergence rather than assuming it. A successor now also samples a
differentiable tetrad on displayed affine predecessor rays and derives
convergence of the scaled backward differences to its Frechet derivative.
Asymptotic vanishing of the identity-background first variations then forces
the point connection and sampled tetrad derivative to obey the linearized
Cartan equation. The graph still does not construct the pointed chart embedding,
inverse-spacing sequence, predecessor rays, or tangent frame; no quantitative
spacing rate is proved, and the background remains the identity. Nonidentity-
background Levi-Civita selection and graph-derived chart convergence remain
open. The physical-link
successor proves that
`exp(A_n hat(F))` has exactly this first-order limit and constructs a nonzero
`2 x 2` periodic-square refinement with commuting shifts and proper
eta-Lorentz links. Its two columns carry exact opposite exponential
plaquettes, so no truncated group expansion is assumed. This closes the
supplied physical-link/coframe/curvature-limit composition. The audit
successor then evaluates both Euler sectors on this family. At the identity
coframe, the mixed Einstein equation kills five target components and leaves
only the internal `23` rotation on the spacetime `01` face. That mode violates
metric-lowered curvature pair exchange, and one exact link Euler coefficient divided by area
tends to twice its amplitude. Consequently no nonzero square target can be
jointly stationary at every shrinking refinement level with the coframe held
at the identity. This rules out the static square ansatz. The vacuum-Weyl
target successor supplies the replacement algebraic curvature specification:
the two-parameter diagonal bivector pattern
`(-x-y,y,x,x,y,-x-y)` is face-antisymmetric, pair-symmetric after lowering
both internal indices with eta, satisfies algebraic first Bianchi, and has
zero mixed Ricci, scalar, and Einstein tensors. Its unit member is explicitly
nonzero. This closes the existence of a convention-correct local vacuum
Riemann target, but does not yet realize it by plaquettes or stationarity. The
periodic mean-obstruction successor proves that every component of a globally
periodic additive link curl has zero site sum, so no fixed nonempty finite
carrier can realize, or converge sitewise to, the same nonzero Weyl tensor at
every site. It also proves the exact additive discrete Bianchi identity. A
common scalar decoration of the unit Weyl tensor would therefore have to be
invariant under every carrier shift. More strongly, both parameters of the
full diagonal Weyl family are separately shift invariant in any additive
realization; the explicit zero-mean `2 x 2` checkerboard fails this test. Thus
the next escape must use genuinely site-dependent frame/component mixing,
boundary data, a twisted bundle sector, or nonlinear leading-order curvature,
rather than scalar signs alone. The null-wave successor realizes the first of
these escapes on a two-site carrier. Its time and
longitudinal shifts toggle the same null coordinate, and two transverse link
potentials carry null-rotation bivectors. Their exact additive curl is nonzero
at both sites with opposite amplitudes, obeys both Bianchi identities and
metric-lowered pair exchange, and has zero mixed Ricci, scalar, and Einstein
entries pointwise at the identity coframe. Because the two generators commute,
exponentiating the links gives exact proper eta-Lorentz plaquettes with no BCH
correction, and the action extractor returns exactly area times this curvature.
The identity coframe is therefore exactly stationary in the finite Einstein
sector. One link Euler coefficient is exactly `-2 * area`, so the static
coframe fails connection and joint stationarity whenever area is nonzero. The
full-coframe successor strengthens this decisively: the sixteen coframe Euler
equations have rank six, their complete kernel is an explicit ten-parameter
matrix family, its determinant factors exactly, and two connection equations
force one of those determinant factors to vanish. Thus no invertible coframe,
including arbitrary off-diagonal shear, is jointly stationary with these
fixed links at nonzero area. Genuine bivector-plane mixing is sufficient for
a periodically exact finite vacuum-Riemann field, but the next constructive
step must deform links and coframe together, enlarge the carrier, or alter the
finite dual-cell weighting. Levi-Civita compatibility and graph refinement
remain open.
The combined result does not
derive the refinement or convergence data from a bare graph, prove the
orthochronous sign, identify the link equation with Levi-Civita selection, or
identify the limiting target with continuum Riemann curvature. The program also
owes metric dual-cell volume factors and a uniqueness
theorem selecting Levi-Civita transport. It also still owes
derivation of the weights
and frame synchronization from order/operator data, local Lorentz covariance
of the difference curvature, equivalence to graph holonomy curvature,
physical boundary variation, and refinement/continuum hypotheses. The open
gates are recorded in
`Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md`.

The spectral, thermodynamic, and teleparallel avatars are intentionally not
imported here. They remain comparison routes until they are proved equivalent
to the metric/operator route on the same reconstructed continuum geometry.
-/
