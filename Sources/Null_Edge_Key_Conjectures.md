# Key conjectures for the null-edge causal graph program

**Status:** conjecture-selection and proof-roadmap note, 2026-06-23.

**Related documents:**
`Sources/Null_Edge_Causal_Graph_Publication_Plan.md`,
`Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`,
`Sources/Null_Edge_Interaction_Ontology.md`, and
`AgentTasks/null-edge-codex-overnight-run-ledger-2026-06-23.md`.

## Executive summary

The program is now mature enough to name a small number of conjectures that
would be genuinely meaningful if true and genuinely focusing if false. These
are not slogans. Each one has a finite theorem spine, a literature collision,
and a clear failure mode.

The four best conjectures are:

1. **Finite super-Dirac conjecture.** The Pluecker mass, Higgs/Yukawa flip
   block, causal-diamond curvature, and graph Laplacian are compatible pieces
   of the square of one natural first-order finite operator.
2. **Observer-channel mass conjecture.** In a fixed observer channel, the
   normalized visible celestial mixedness gives `m / E_u`, while Higgs/Yukawa
   coupling first appears as left/right chirality coherence before tracing or
   dephasing makes it visible as determinant mass.
3. **P9 source-visibility/noise conjecture.** Hidden or boundary-exact
   bookkeeping can have zero bulk mean response, but the remaining stochastic
   source is a finite noise kernel; visible Pluecker or closure defects source
   finite diamond observables.
4. **Null-step Dirac universality conjecture.** A broad but specified class of
   local unitary null-step walks has a Dirac scaling limit, with the
   chirality-flip/coherence parameter controlling the effective mass and the
   Pluecker/mixedness theorem as its static shadow.

The first conjecture is the deepest unification target. The second is the
cleanest origin-of-mass story. The third is the high-risk/high-value
cosmological-constant route. The fourth is the dynamics bridge that decides how
far the ontology "all elementary movement is lightlike" can be pushed.

## 1. Finite super-Dirac conjecture

### What we think

Quadratic observables should not be primitive. The program currently has many
square-level facts:

```text
det(P)                                  -- invariant mass square
sum |psi_i wedge psi_j|^2               -- pairwise Pluecker spread
4 det(rho)                              -- normalized celestial mixedness
D^2                                     -- graph/order-complex Laplacian
diamond path-pair defect                -- curvature-like obstruction
Phi^dagger Phi                          -- Higgs/Yukawa mass block
```

The conjecture is that these are not merely analogous. They should arise as
compatible blocks in the square of one finite first-order operator on a causal
order complex with visible spinor fibers and internal left/right labels:

```text
D_{U,Phi} = d_U + delta_U + Phi + Phi^dagger.
```

Here `d_U + delta_U` is a transported order-complex Dirac/Hodge operator and
`Phi` is the odd Higgs/Yukawa finite Dirac block. The crucial correction is
that the Pluecker determinant should not be added as a second mass block. It is
the principal symbol or momentum-eigenvalue of the kinetic block, while
`Phi^dagger Phi` is the internal/Yukawa mass block. On shell these two numbers
must agree:

```text
kinetic symbol on bundle momentum P = det(P)
Yukawa mass block                    = Phi^dagger Phi
mass shell constraint                = det(P) = Phi^dagger Phi.
```

Thus the desired square is not "Laplacian plus curvature plus Pluecker mass
plus Yukawa mass." That would double-count the same physical mass. The honest
decomposition is:

```text
D_{U,Phi}^2 =
  covariant graph Laplacian          -- symbol evaluates to det(P)
  + diamond curvature block
  + Higgs/Yukawa mass block
  + gauged Higgs kinetic cross term.
```

The non-tautological content is the consistency claim: the same finite operator
surface should make the kinetic Pluecker determinant, the Yukawa mass block, and
the diamond curvature live on one causal order complex without double-counting.

### What the literature says

The shape is not invented from scratch. Quillen superconnections (`WNATKBT5`),
generalized Lichnerowicz formulas (`BQJAG9TR`), the
Chamseddine-Connes spectral action (`6WURA7MF`), and Lee's superconnection
gauge-Higgs work (`3Z543SD3`) all support the principle that a first-order
Dirac-type operator can square to Laplacian, curvature, and scalar/Higgs terms.
Bianconi's topological Dirac operator for networks (`8ITHD4PG`) gives a finite
network analogue of `D = d + delta` with a Hodge-Laplacian square.

The Lorentzian/Krein warning is also sourced. Van den Dungen (`5DURW8DU`)
frames Lorentzian spectral triples as reverse Wick rotations over Krein spaces.
Bizi-Brouder-Besnard (`PM83B8QI`) develop indefinite spectral triples over
Krein spaces and space/time dimension bookkeeping. Besnard-Bizi (`5VWPZ8BP`)
emphasize the role of time orientation and the Krein product. Devastato-
Farnsworth-Lizzi-Martinetti (`5RJUDATF`) and Martinetti-Singh (`Q6R3PCGJ`)
show how twisting Euclidean spectral triples is tied to Lorentzian signature
and fermionic actions. These sources make ordinary positive-definite
self-adjointness the wrong default target for the causal operator.

The null-edge addition is more specific. The kinetic symbol of the graph Dirac
block should be the Lean-checked Pluecker determinant of a bundle of null
spinors; the Yukawa block should equal it only as an on-shell constraint; and
the curvature block should be the causal-diamond holonomy defect rather than an
ordinary plaquette curvature. This is a sharper claim than merely saying that
`D^2` contains a Laplacian and a mass term, since those features are generic in
Dirac-type constructions.

### What we have formally proven

The pieces are mostly banked separately:

- `PhysicsSM.Spinor.PluckerMass` proves the determinant/Pluecker mass identity
  and zero-mass common-direction criterion.
- `PhysicsSM.Draft.NullEdgeDiracSlashCore` and
  `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore` prove the finite static
  Dirac slash square root of the Pluecker mass.
- `PhysicsSM.Draft.NullEdgeSuperDiracBlockCore` and
  `PhysicsSM.Draft.NullEdgeSuperconnectionExpansionCore` prove abstract
  block-square algebra for odd operators and `d + delta + Phi + Phi^dagger`.
- `PhysicsSM.Draft.NullEdgeCovariantDifferentialCore` proves a finite
  transported differential-square/curvature seed on triangles.
- `PhysicsSM.Gauge.CausalDiamondHolonomy` proves diamond defect invariance and
  vertical/horizontal composition.
- `PhysicsSM.Draft.NullEdgeYukawaMassOperator` proves a finite off-diagonal
  scalar mass operator that anticommutes with chirality and squares to the
  expected mass-square block.
- `PhysicsSM.Draft.NullEdgeSuperDiracKreinCore` now gives the Lorentzian/Krein
  finite algebra: `J`-self-adjointness, the mass-shell branch symmetry
  `J = (1 / m) D`, the involution theorem `J^2 = 1` when `D^2 = m^2 I`, the
  equality with plus-minus branch projectors, and an explicit
  `MassShellConstraint` predicate recording equality rather than addition of
  kinetic and Yukawa mass squares.

### Why it matters

This is the strongest possible answer to the Dirac critique: if the square root
exists naturally, the program is not just collecting beautiful quadratic
identities. It has a candidate operator. That would let us write the Pluecker
mass theorem, the Higgs flip rule, and the diamond curvature theorem as pieces
of one finite Lichnerowicz-style formula, with the Pluecker determinant as the
kinetic symbol and the Yukawa block as the on-shell mass constraint.

If the conjecture fails, that is also valuable. It would mean the finite mass,
curvature, and Higgs results are useful theorem islands but do not yet form a
unified finite theory.

### What we would like to show

Near-term theorem targets:

```lean
superDirac_productGrading_def
superDirac_kreinForm_def
superDirac_is_odd
superDirac_is_KreinSelfAdjoint
superDirac_J_grading_eq_twoSheet
covariantOrderDifferential_sq_eq_diamondCurvature
diamondHolonomy_eq_curvatureBlock_linearized
higgsBlock_sq_eq_yukawaMassMatrix
superDiracSq_kineticSymbol_eq_pluckerDet
massShell_kinetic_eq_yukawa
superDiracSq_crossTerm_eq_gaugedHiggsKinetic
superDirac_sq_eq_laplacian_plus_curvature_plus_higgs
```

Publication-level statement:

> In a finite causal order complex with transported visible spinor data and
> internal left/right labels, the natural odd operator
> `D_{U,Phi}=d_U+delta_U+Phi+Phi^dagger` has a square whose kinetic symbol,
> curvature, Higgs kinetic cross term, and chirality-flip mass block reproduce
> the already formalized null-edge mass, causal-diamond holonomy, and
> Higgs/Yukawa bookkeeping theorems. The Pluecker determinant is not an
> additional additive mass term; it is the kinetic symbol that equals the
> Yukawa mass block on shell.

### What might be missing

The missing pieces are structural rather than computational:

- a canonical finite Hilbert space for the causal order complex;
- a Lorentzian inner product or Krein form, not merely a positive-definite
  Euclidean Hilbert product;
- a robust notion of transported coboundary `d_U` on higher simplices;
- a precise relation between diamond holonomy and the curvature block in
  `d_U^2`;
- a proof that the Pluecker determinant is the kinetic symbol/eigenvalue, not a
  second additive mass block;
- an on-shell mass-shell constraint equating the kinetic Pluecker determinant
  with the Higgs/Yukawa block;
- a product grading combining simplicial degree and chirality;
- a proof that the cross term is the gauged Higgs kinetic term rather than an
  unwanted error term;
- a two-triangle decomposition relating diamond holonomy to `d_U^2` curvature;
- convention audits for signature, chirality, grading, and normalization.

Failure mode: no natural odd Krein/J-self-adjoint first-order operator can be
defined without adding arbitrary structure; the only self-adjoint version is
positive-definite and therefore Wick-rotated rather than Lorentzian; the kinetic
Pluecker determinant and the Yukawa block cannot be related by an on-shell
constraint without double-counting; or the diamond curvature and Higgs kinetic
cross term fail to fit the same graded operator surface.

## 2. Observer-channel mass conjecture

### What we think

The invariant mass statement is:

```text
det(P) = m^2,
P = sum_i psi_i psi_i^dagger.
```

There are two observer operations, and keeping them separate is now part of
the conjecture.

The **resolution observer** chooses which internal/chiral/Higgs labels are
unresolved and traces them out. If a visible boost acts as `A tensor I_int`,
then this resolution step commutes with the boost:

```text
Tr_int[(A tensor I) |Psi><Psi| (A^dagger tensor I)]
  = A (Tr_int |Psi><Psi|) A^dagger.
```

Thus the unnormalized visible block transforms by congruence,

```text
P_vis |-> A P_vis A^dagger,
det(A P_vis A^dagger) = det(P_vis)
```

for `A in SL(2,C)`. This is the invariant mass statement:

```text
det(P_vis) = m^2.
```

The **kinematic observer** then chooses a timelike frame/energy normalization.
Only after this step do we form a normalized celestial qubit:

```text
rho_{p|u} = P_vis / Tr_u(P_vis),
2 sqrt(det(rho_{p|u})) = m / E_u.
```

This normalized density is not a Lorentz scalar. Under a change of frame it is
filtered and renormalized, in the same SLOCC-like sense familiar from
relativistic quantum information. The invariant object is `P_vis` and its
determinant; the frame-relative object is `rho_{p|u}` and its mixedness.

The conjecture is that this two-observer interface is the correct finite
origin-of-mass interface: massive visible particles are not single massive
elementary edges, but resolution-channel reductions of internally structured
null processes, followed by a chosen kinematic normalization. The Higgs does
not simply "add mass" as a scalar after the fact. It makes left/right chirality
transitions legal and creates chirality coherence; observer tracing or
dephasing can then convert that coherence into the visible
determinant/mixedness signal.

### What the literature says

The mass/concurrence connection has prior art. Chin and Lee (`3VBEK82X`) relate
momentum bispinors, two-qubit entanglement, and twistor space, so our paper
must not present "mass as concurrence" as a completely new idea. Massive
spinor-helicity already treats massive momentum as a two-spinor structure, with
the two-spinor case sitting inside the Pluecker determinant story.

There are also important guardrails. Peres-Scudo-Terno (`QDUD2CDE`) and
Gingrich-Adami (`Z2MFSJJU`) show that spin/entanglement quantities can be
frame-sensitive under Lorentz transformations. Ruskai-Szarek-Werner
(`M6HR9WD6`) is relevant for the finite qubit-channel geometry. Petz recovery,
Fawzi-Renner recoverability (`BHNTND4W`), and related relative-entropy
monotonicity sources constrain what may be claimed about observer channels.

### What we have formally proven

The invariant algebra is strong:

- `PhysicsSM.Spinor.PluckerMass` proves the bundle determinant identity.
- `PhysicsSM.Draft.NullEdgeP1SL2Frame` proves determinant invariance under
  `SL(2,C)` congruence.
- `PhysicsSM.Draft.NullEdgeP1CelestialMoment` proves the scalar monopole/dipole
  identity.
- `PhysicsSM.Draft.NullEdgeP1RestFrameBloch`,
  `NullEdgeP1NormalizedBlochDet`, `NullEdgeP1NormalizedDetNonneg`,
  `NullEdgeP1NormalizedDetPositive`, `NullEdgeP1NormalizedDetSign`, and
  `NullEdgeP1MassRatioBounds` formalize the Bloch-ball and normalized
  determinant guardrails.
- `PhysicsSM.Draft.NullEdgeP1ObserverConditioned` proves the scalar relation
  `2 sqrt(det rho_{p|u}) = m / E_u` under the stated conventions.
- `PhysicsSM.Draft.NullEdgeP1TwoNullSplit`,
  `NullEdgeP1TwoNullMassProduct`, `NullEdgeP1TwoNullMasslessIff`,
  `NullEdgeP1TwoNullMassRatioVelocity`, and related modules give a controlled
  two-null observer-axis testbed.

The channel/chirality side has a growing finite core:

- `PhysicsSM.Draft.NullEdgeP2ChiralityCoherence` proves that the left/right
  chirality coherence parameter equals `m / E` in the two-level scalar model.
- `PhysicsSM.Draft.NullEdgeP2DephasingDeterminant`,
  `NullEdgeP2DephasingDetMonotone`, `NullEdgeP2DephasingEqualityIff`,
  `NullEdgeP2DephasingPurity`, `NullEdgeP2DephasingGap`, and
  `NullEdgeP2ProjectorDephasedDetMassRatio` show how dephasing removes
  coherence and changes determinant/purity observables.
- `PhysicsSM.Draft.NullEdgeP6Concurrence` covers finite concurrence algebra.
- `PhysicsSM.Draft.NullEdgeObserverChannelCore` packages the sharpened
  observer-channel interface: unnormalized visible boost congruence,
  `SL(2,C)` determinant invariance, scalar kinematic filtering, the two-label
  Gram determinant factorization, dephasing monotonicity, unital visible
  mass-ratio monotonicity, and a scalar counterexample to overbroad hidden
  monotonicity claims.
- `PhysicsSM.Draft.NullEdgeSchmidtDeterminantCore` proves the finite pure-state
  Schmidt determinant bridge: the visible and chirality reduced determinants
  agree, and both equal the square of the `2 x 2` coefficient determinant.

The concrete observer-channel algebra is also now sharp. If visible spinors are
the columns of a `2 x n` matrix `V` and unresolved internal labels have Gram
matrix `G`, then the resolution observer produces

```text
P_vis = V G V^dagger,
det(P_vis) = w^dagger (Lambda^2 G) w,
w_ij = v_i wedge v_j.
```

For two labels this becomes

```text
det(P_vis) = |v_1 wedge v_2|^2 det(G).
```

This makes the physical content vivid: orthogonal/decohered internal labels
recover the Plucker sum, rank-one coherent internal labels collapse the
exterior square and give zero visible mass, and dephasing increases the
visible determinant toward the orthogonal Plucker value.

### Why it matters

This conjecture gives the paper an accessible but precise claim:

> A fine-scale null process can remain pure and lightlike, while an observer who
> does not resolve internal or chirality bookkeeping sees a mixed celestial
> qubit. The mixedness is exactly the frame-relative mass ratio `m/E_u`.

That is the cleanest way to say "mass is emergent from coarse-grained
lightlike pieces" without confusing invariant mass with observer-dependent
normalization.

If the conjecture fails, it will pinpoint the failure: either the observer
split is wrong, the physical internal labels are not modeled by a finite Gram
family, the Higgs/chirality channel is not the right purification, or the
concurrence language is only an analogy.

### What we would like to show

Near-term theorem targets:

```lean
visibleReduced_boost_eq_congruence
det_visibleReduced_boost_invariant
normalizedVisible_boost_is_filtering
normalizedVisible_det_eq_massRatio_sq
visibleDensity_from_internal_purification
det_visibleReduced_eq_gramWeighted_plucker
det_visibleReduced_twoLabel_eq_wedge_times_detGram  -- banked in ObserverChannelCore
dephasing_internalGram_mass_monotone                -- banked in ObserverChannelCore
rankOne_internalGram_iff_massless
normalized_mass_ratio_eq_concurrence
visibleMixedness_eq_chiralityCoherence_schmidt       -- determinant bridge banked
chiralityPopulations_balanced_iff_coherence_eq_massRatio
dephasing_visibleMixedness_eq_lostChiralityCoherence
massRatioSq_eq_linearEntropy_visible
unital_visibleChannel_massRatio_monotone
entangling_hiddenChannel_massRatio_nonmonotone
internalCoherenceLoss_eq_relativeEntropyDeficit
```

Publication-level statement:

> The invariant mass is `det(P)`. The observer-normalized visible state
> `rho_{p|u}` has determinant `(m/2E_u)^2`. In the finite null-edge model,
> Higgs/Yukawa-permitted chirality coherence is the first-order source of this
> ratio, and observer channels determine which coherence becomes visible
> determinant mixedness.

### What might be missing

The core risk is physical interpretation. The algebra is finite and strong, but
we still need:

- the two-observer split: resolution partial trace versus kinematic
  normalization;
- a clean unitary dilation from visible spinor plus internal/chirality labels;
- a precise distinction between invariant mass and frame-relative `m/E_u`;
- an internal Gram model that is physically motivated rather than assigned
  post hoc;
- a proof that physically relevant Higgs/Yukawa dynamics create exactly the
  coherence parameter used in the finite model;
- monotonicity statements restricted to actual channel classes, with unital
  visible channels as the safe positive case and entangling hidden channels as
  the expected failure case.

Failure mode: the normalized determinant remains true but does not arise from a
natural observer/Higgs channel; boosts do not commute with the actual
resolution map; internal coherence is not recoverable or operationally
detectable; or the proper-time/purity statement is only a static rewrite of
time dilation rather than a dynamical constraint.

## 3. P9 source-visibility/noise conjecture

### What we think

The cosmological-constant branch should not claim that hidden vacuum
bookkeeping is simply invisible. That is too easy and probably false in the
wrong models. The sharper conjecture is:

```text
boundary-exact or closure-satisfying hidden bookkeeping
  -> zero bulk mean response to the relevant closed tests

visible Pluecker or closure defect
  -> nonzero finite diamond source

residual hidden bookkeeping
  -> noise kernel, not mean cosmological source
```

So P9 is not "vacuum energy disappears." It is a source/noise separation
conjecture. The finite question is whether the graph observables can distinguish
mean source, boundary-exact bookkeeping, closure defect, and stochastic
fluctuation in a way that survives contact with stochastic gravity and causal
set cosmology.

The newest sharpening is to treat these regimes as pieces of a finite
Hodge-Helmholtz decomposition of diamond bookkeeping cochains, with the inner
product fixed by a Sorkin-Johnston-style correlation metric. In that language,
boundary-exact bookkeeping lives in `im d`, closure defects are detected by the
codifferential/source map, and the only plausible cosmological-constant channel
is the harmonic sector `ker d cap ker delta`. This is not yet a proved physics
claim; it is a sharper conjectural interface:

```text
exact sector       -> gauge or boundary bookkeeping, invisible to closed tests
coexact/defect     -> visible matter or closure source
harmonic sector    -> candidate Lambda-channel
harmonic covariance -> stochastic noise kernel
```

This moves the hard question from "why is vacuum bookkeeping invisible?" to
"what is the harmonic cohomology and noise trace of finite causal diamonds under
the chosen SJ metric?" That is a computable finite problem. The branch wins only
if the harmonic dimension or harmonic-noise trace is sub-volume, ideally
constant or area-law; it loses if the harmonic sector scales like volume or if
the response law turns even area-law source noise into the usual
everpresent-Lambda amplitude problem.

### What the literature says

This branch collides directly with causal-set and stochastic-gravity prior art.
Sorkin's everpresent-Lambda direction (`ZP7E648U`) and the Das-Nasiri-Yazdi
papers (`K5CFI3HI`, `IHVSDGUC`) already explore fluctuating cosmological
constant ideas. Hu-Verdaguer stochastic gravity (`PRCWRMFC`, `TXN5JSZ5`),
the Martin-Verdaguer Einstein-Langevin derivation (`4KXZ8IJE`), Phillips-Hu
noise-kernel work (`5T5BQ6PT`), Hu-Matacz (`PW8MXJ8I`), and Campos-Verdaguer
(`K8SI5KZ9`) make clear that stress fluctuations are not a side issue: a zero
mean with nonzero noise is still gravitationally meaningful.

Jacobson's entanglement-equilibrium route (`7V9FV86B`) is the gravity
thermodynamics guardrail. The causal-set Sorkin-Johnston entropy papers
(`PU8Q5WKT`, `P8PE3SZ9`) warn that area-law behavior often requires spectral
truncation/windowing. Twisted and null twisted geometries (`63MQ6KC3`,
`BC9Q4QNG`) give the closure/flux language closest to spin-network and null
horizon geometry.

The Hodge/projector version should also cite finite and computational Hodge
theory directly: finite element exterior calculus (`DM6NREPA`) for stable
commuting-complex discretization, the Arnold-Falk-Winther stability review
(`8JFSI9CS`) for the cochain-projection criterion, Hansen-Ghrist cellular sheaf
Laplacians (`CWXAFIF4`) for spectral cohomology language on cell data, Dodziuk
finite-difference Hodge theory (`TSAQXS9N`) for finite harmonic-form
approximation, Edelsbrunner-Olsbock tri-partitions (`D7352JCI`) for constructive
cell decompositions and harmonic bases, and Ribando-Gros et al. (`9RE64BCV`) for
the warning that combinatorial graph Laplacians and metric-compatible Hodge
Laplacians are not interchangeable.
The discrete-first coarse-graining guardrail is now sourced by higher-order
Laplacian renormalization (`RA8QNNKW`), heterogeneous Laplacian RG
(`AN5RZGJZ`), Laplacian coarse graining in complex networks (`UR5ADCBP`), and
Loukas' graph reduction with spectral and cut guarantees (`PTU4XM4U`).
Eichhorn-Mack-Le-Wagner's causal-set observable survey (`RC5XF8RD`) sharpens
the intrinsic-observable side: link-degree distributions, symmetrized-Hasse
graph Laplacian spectra, and causal-interval abundance distinguish causal-set
classes with smaller fluctuations than many continuum-inspired curvature
observables. These are natural candidate coarse-map diagnostics for P9.
The finite-Hodge stability guardrail is sourced by FEEC (`DM6NREPA`,
`8JFSI9CS`) and the DEC/FEEC stability bridge `WB8WBSBX`.
These make it legitimate to seek stable large-scale P9 observables without
requiring continuum-like behavior at the microscopic graph scale. The intended
test is emergence under a named coarse channel, not manifold-likeness of the
primitive incidence structure.
The causal-response guardrail is now sharpened by Aslanbeigi-Saravani-Sorkin
(`DQ9CF6I2`), which gives Lorentz-invariant retarded nonlocal causal-set
d'Alembertian operators, infrared recovery conditions, and stability caveats.
This is the right comparison class for any finite P9 kernel that claims causal
support or response-law content.
Boguna-Krioukov's local causal-set d'Alembertian (`I72KXVQA`) is the
counterweight: it argues that a local operator can converge using intrinsic
causal-set distance data. This makes `edgeNeighbor_N` more than a convenience;
it is a finite locality hypothesis to test against both nonlocal and local
causal-set d'Alembertian programs.

### What we have formally proven

The P9 theorem spine is now sizable, though still toy-level:

- `PhysicsSM.Draft.NullEdgeP9ClosureDefect` proves closure-defect square
  vanishes exactly when all closure components vanish.
- `PhysicsSM.Draft.NullEdgeP9ClosureVisibleSource` and
  `NullEdgeP9ClosureVisibleAny` show that nonzero closure components produce
  nonzero source observables in the finite API.
- `PhysicsSM.Draft.NullEdgeP9VisiblePluckerSourceAPI` links nonzero Pluecker
  spread to a visible scalar source in the toy observable.
- `PhysicsSM.Draft.NullEdgeP9BoundaryExact`,
  `NullEdgeP9BoundaryExactNoiseInvisible`, and
  `NullEdgeP9BoundaryExactPerturbationInvariant` formalize boundary-exact
  invisibility/invariance under closed tests.
- `PhysicsSM.Draft.NullEdgeP9AntisymmetricMeanZero`,
  `NullEdgeP9WeightedAntisymmetricMeanZero`,
  `NullEdgeP9PairedCancellation`, and `NullEdgeP9MeanFluctuation` show how
  paired or antisymmetric hidden bookkeeping can have zero mean while carrying
  nonzero second moment.
- `PhysicsSM.Draft.NullEdgeP9NoiseResponseNonneg`,
  `NullEdgeP9NoiseCauchySchwarz`, `NullEdgeP9PositiveWeightNoiseZero`,
  `NullEdgeP9NoiseKernelEntryRecovery`,
  `NullEdgeP9NoiseKernelDeterminedByTests`, and
  `NullEdgeP9ResponseCharacterization` formalize the finite noise-response
  and test-recovery guardrails.
- `PhysicsSM.Draft.NullEdgeP9WeightedSuppressionThreshold`,
  `NullEdgeP9ResidualVarianceCellArea`, `NullEdgeP9MaxWeightResidualBound`,
  and `NullEdgeP9WeightedBenchmarkBound` give finite residual-suppression
  estimates.
- `PhysicsSM.Draft.NullEdgeP9ClosedWitness` and
  `NullEdgeP9BoundaryVisibleDecomp` prove the first Hodge-style witness
  direction: boundary-exact sources are invisible to closed bulk tests, while a
  closed test with nonzero source pairing certifies a visible residual source.
- `PhysicsSM.Draft.NullEdgeP9WeightedNoiseBound` gives a finite diagonal
  response bound for weighted cells and bounded observer tests.
- `PhysicsSM.Draft.NullEdgeP9HarmonicProjectorResponse` and
  `NullEdgeP9ProjectedNoiseKernel` add an abstract finite projector layer:
  harmonic/projected tests see only the projected source, boundary sources
  vanish if the projector annihilates them, and positive-semidefinite noise
  response is preserved by projection.
- `PhysicsSM.Draft.NullEdgeP9OrthogonalProjectorCore` proves the complementary
  orthogonal-projector algebra: a self-adjoint idempotent projector makes
  harmonic tests see only the projected source, and the residual
  `source - Pi source` is orthogonal to harmonic tests.
- `PhysicsSM.Draft.NullEdgeP9WeightedProjectorResidualOrthogonal` upgrades this
  projector algebra to weighted observer-channel tests: a weighted
  self-adjoint idempotent projector makes projected tests see only the projected
  source, and the weighted residual is orthogonal to all projected tests.
- `PhysicsSM.Draft.NullEdgeP9WeightedProjectorPythagorean` adds the norm
  companion: the weighted source energy splits exactly into projected/coarse
  energy plus weighted residual energy.
- `PhysicsSM.Draft.NullEdgeP9StrictProjectedKernel` proves the strict projected
  noise-kernel guardrail: under a positive-definite finite kernel, projected
  response is strictly positive exactly when the projected test is nonzero.
- `PhysicsSM.Draft.NullEdgeP9ConditionedResponseBound` proves the finite
  condition-number style readout: a two-sided response bound rules out hidden
  projected zero modes and bounds the response-to-projected-norm ratio between
  the stated constants.
- `PhysicsSM.Draft.NullEdgeP9CoarseResidualVariance` proves that summing
  fine-cell variances over a block map preserves total residual variance at the
  coarse level, giving the corrected coarse-graining gate a small formal spine.
- `PhysicsSM.Draft.NullEdgeP9IntrinsicOrderObservables` proves the first
  intrinsic causal-set observable invariance facts: interval abundance and
  out-degree histograms are invariant under finite relabeling, so they are not
  artifacts of a chosen vertex labeling.
- `PhysicsSM.Draft.NullEdgeP9CoarseKernelPSD` proves the core C4
  well-definedness package: coarse response equals fine response against the
  pulled-back test, PSD kernels stay PSD under a fixed coarse map, and the
  coarse trace is nonnegative.
- `PhysicsSM.Draft.NullEdgeP9RankOneHarmonicTrace` proves the simplest
  harmonic-channel trace toy theorem: the mean projector has trace `1`, so its
  trace density is `1/n`.
- `PhysicsSM.Draft.NullEdgeP9WeightedAdjointCore` proves the first explicit
  weighted finite-Hodge ingredient: the `codiff` convention is the weighted
  adjoint of the coboundary for diagonal metrics.
- `PhysicsSM.Draft.NullEdgeP9WeightedLaplacianEnergy` proves the weighted
  finite 1-Laplacian energy identity and nonnegativity: the Laplacian pairing
  splits into down-energy and up-energy square terms.
- `PhysicsSM.Draft.NullEdgeP9WeightedLap1SelfAdjoint` proves the bilinear
  companion and self-adjointness of the explicit weighted 1-Laplacian, giving
  the spectral-coarse-mode route a finite operator-theoretic spine.
- `PhysicsSM.Draft.NullEdgeP9HarmonicKernelCore` proves the current keystone of
  the finite Hodge route: with positive diagonal weights, the kernel of the
  weighted finite 1-Laplacian is exactly `closed and coclosed`.
- `PhysicsSM.Draft.NullEdgeP9HodgeProjectorInstantiation` proves the finite
  Hodge/source-visibility bridge: a self-adjoint idempotent projector whose
  range lies in the harmonic sector annihilates exact boundary bookkeeping, so
  projected pairings and quadratic responses are boundary-invariant.
- `PhysicsSM.Draft.NullEdgeP9CoarseBoundaryInvariance` proves that a fixed
  coarse-graining map makes both the coarse source and quadratic response
  invariant under perturbations that the map annihilates.
- `PhysicsSM.Draft.NullEdgeP9TwoCellTraceSeparation` proves a small
  non-vacuity result: an explicit two-cell coarse trace can distinguish
  diagonal kernels and is monotone in their total diagonal weight.
- `PhysicsSM.Draft.NullEdgeP9CausalSupportBound` proves the finite
  domain-of-dependence guardrail: a kernel supported inside a chosen causal
  relation cannot send a localized source outside that source's discrete causal
  reach, and causally separated source/target supports have zero response.
- `PhysicsSM.Draft.NullEdgeP9RetardedNilpotentReach` proves the finite
  acyclic-retarded horizon theorem: if a response support relation strictly
  decreases a rank on a finite diamond, exact reach is empty beyond the rank
  height and the iterated response kernel vanishes.
- `PhysicsSM.Draft.NullEdgeP9EdgeNeighborReach` proves the finite
  `edgeNeighbor_N` scaffold: the bounded endpoint-diamond relation is a
  subrelation, remains valid under induced subdiamonds, converts neighborhood
  support into causal support, and keeps iterated responses inside exact
  finite step reach.
- `PhysicsSM.Draft.NullEdgeP9RetardedGreenSeries` proves the finite
  terminating response identity: if a retarded kernel is nilpotent on a vector
  after `H` steps, then the finite series `sum_{m < H} K^m x` is a right
  inverse for `I - K` on that vector.
- `PhysicsSM.Draft.NullEdgeP9SelectedSectorTraceDensity` proves the finite
  area-vs-volume trace-density scaffold: a Boolean-selected sector with `k`
  visible coordinate modes in an `n`-cell readout has trace density `k/n`, and
  any boundary-size bound on `k` gives the corresponding density bound.
- `PhysicsSM.Draft.NullEdgeP9BlockAliasingGuardrail` proves the finite
  coarse-map artifact warning: a size-4 block average annihilates any rank-one
  mode with zero within-block sum, so a zero coarse trace can be caused by
  alignment rather than physical source invisibility.
- `PhysicsSM.Draft.NullEdgeP9OffsetWindowGuardrail` strengthens that negative
  control: a single aligned block-window zero need not be offset-invariant, and
  even all shifted four-cell window traces can annihilate a nonzero
  high-frequency mode. Block-average invisibility is therefore not evidence
  unless the coarse map is intrinsic or observer-forced.
- `PhysicsSM.Draft.NullEdgeP9BoundaryVolumeScaling` proves the toy
  area-vs-volume scaffold: in a four-dimensional scaling model,
  boundary-over-volume density is `C / L`, falls below any positive threshold
  after a scale bound, and halves when the linear scale doubles.
- `PhysicsSM.Draft.NullEdgeP9DefectSensitivityBenchmark` proves the minimal
  two-triangle defect-sensitivity benchmark: common-mode curvature bookkeeping
  is invisible to the linearized diamond-defect readout, while differential
  curvature perturbations are visible and create nonzero defect from a flat
  baseline.
- `PhysicsSM.Draft.NullEdgeP9IsohistogramSeparation` proves the cheap
  sanity witness that separate in-degree, out-degree, and interval-abundance
  histograms do not determine a frozen joint readout.
- `PhysicsSM.Draft.NullEdgeP9DiamondLocalSeparation` proves the stronger T1
  guardrail: matched joint in/out-degree and global interval-abundance
  signatures can still differ on a same-size diamond-local interval readout.
- `PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail` proves the negative T2
  control: a natural critical-collapse coarse map erases that T1 separator.
- `PhysicsSM.Draft.NullEdgeP9DiamondLocalityNoiseInvariance` proves the T3
  locality/noise guardrail: once the closed diamond and all relation entries
  internal to it agree, external relation noise cannot change the local
  interval-size readout.
- `PhysicsSM.Draft.NullEdgeP7RecoverabilityInvisibilitySeparation` supplies an
  important warning: recoverability is not source invisibility.

The Hodge version now has an abstract projector algebra, but it has not yet been
grounded in a geometry-dependent finite diamond metric. It should reuse the
existing finite cochain seed, boundary-exact results, and noise-kernel modules,
then add an explicit metric/adjoint layer before any statement about harmonic
bookkeeping is advertised as cosmological physics.

The adversarial gate is now sharper. Boundary-exact invisibility and
zero-mean/nonzero-variance residuals are generic finite algebra unless they are
attached to a causal-diamond metric, a harmonic projector, and a response law.
The next decisive finite object is therefore an explicit projector
`Pi_H = I - d G^{-1} d^* - d^* H^{-1} d` or an equivalent Gram-matrix
construction on the chosen finite diamond complex. P9 earns physics content
only when the harmonic/noise subspace has computable dimension, spectrum, and
conditioning that depend on the causal diamond geometry rather than only on an
arbitrary finite complex.

The latest strategy/audit gate is sharper still. P9 becomes more than generic
finite Hodge algebra only after it exhibits an iso-histogram separation: two
finite causal sets with the same out-degree and interval-abundance histograms,
separated by a frozen projected observer readout, with the separation stable
under a pre-specified Alexandrov or spectral coarse map and with an explicit
scale-uniform bound. If the readout is just a degree, interval-histogram,
boundary, weight-normalization, or block-alignment artifact, the
cosmological-constant branch should be demoted.

Claude's adversarial critique sharpens this into a ladder. The cheap
marginals-vs-joint sanity witness is now banked in
`PhysicsSM.Draft.NullEdgeP9IsohistogramSeparation`: two strict five-point
relations have matching separate in-degree, out-degree, and interval-abundance
signatures while a frozen joint readout separates them. This is useful as a
guardrail, but it mainly proves that marginal histograms do not determine a
joint distribution. The serious T1 target is now banked in
`PhysicsSM.Draft.NullEdgeP9DiamondLocalSeparation`: two strict six-point
relations have matched joint in/out-degree and global interval-abundance
signatures, and the chosen diamond has the same cardinality, but a local
interval-size signature inside that diamond differs. T2 adds a pre-specified
coarse map and proves the separator is stable or equivariant under it; the
erasure side is now banked in
`PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail`, which proves that a
natural critical-collapse map can erase the T1 signal. T3 adds a
geometry-blind noise class and proves the diamond-local readout is unchanged
when the measured diamond data are unchanged. Aristotle's positive-T2 strategy
selected Alexandrov endpoint-preserving subdiamond restriction as the best
positive preservation theorem, and this Class A spine is now banked in
`PhysicsSM.Draft.NullEdgeP9SubdiamondRestrictionPreservesLocalReadout`.
Interval-rank threshold filtration and spectral/Laplacian no-go routes remain
backups. The next refinement is a finite witness corollary contrasting
subdiamond preservation with critical-collapse erasure.

### Why it matters

This is the branch with the biggest upside and the highest danger. If true, it
would give the program a real angle on the cosmological-constant problem:
coherent hidden bookkeeping does not contribute a bulk mean source, while
visible mass/closure defects do. If false, we should demote the branch instead
of trying to win by rhetoric.

The finite noise-kernel results are especially important because they prevent a
too-strong claim. A zero mean is not enough. The program must either control the
noise response or explain why its correlations/amplitude differ from the usual
everpresent-Lambda and stochastic-gravity concerns.

### What we would like to show

Near-term theorem targets:

```lean
sjMetric_def
diamondBookkeeping_hodge_decomposition
gaugeSector_invisible_to_closed_tests
defectSector_sources_diamond
harmonic_dim_eq_diamond_cohomology
noiseKernel_positive_semidefinite
sourceVisibility_recoverability_coincide_iff_subspaces_align
closedTest_boundaryExact_meanResponse_zero
closureSatisfying_hiddenBookkeeping_bulkMean_zero
visiblePluckerDefect_bulkResponse_nonzero
noiseKernel_recovered_by_delta_pair_tests
noiseResponse_positive_semidefinite
sourceVisibility_implies_not_pure_recoverability
sjWindowedScreenEntropy_area_law_finite_model
diamondSource_response_conservation_identity
hodgeProjector_annihilates_boundaryExact
hodgeProjector_is_idempotent_selfAdjoint
harmonicNoiseKernel_restricts_to_projected_source
harmonicNoiseKernel_positiveDefinite_iff_no_hidden_null_modes
harmonicNoiseKernel_conditionNumber_refinement_bound
```

The finite Ward/conservation seed behind `eventConservation_kills_defect_source`
is now explicitly banked in
`PhysicsSM.Draft.NullEdgeP9BoundarySource.eventConservation_kills_defect_source`.
The same module also keeps the older theorem name
`boundaryExact_source_eq_zero`, and
`PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore.boundaryExact_invisible_to_closed_tests`
packages the statement as invisibility to all closed bulk tests. The open work
is therefore not another proof of this identity, but a geometry-dependent
diamond source functional, metric/codifferential convention, and response law
that specialize the finite Ward identity.

The speculative, high-value targets are deliberately separated from the
one-line finite algebra:

```lean
lambdaChannel_eq_harmonic_projection
acyclicDiamond_lambdaChannel_vanishes
cellLocalPairing_implies_areaLaw_noiseTrace
sjWindow_unifies_entropy_and_noise
diamondSource_response_law
```

Numerical pilots should be treated as first-class research work:

```text
betti_scaling_of_sprinkled_diamond_order_complex
noiseTrace_scaling_under_cellLocal_vs_independent_residuals
sjWindow_entropy_and_noise_areaLaw_jointly
flat_vs_deSitter_diamond_harmonic_spectrum_pilot
closedTest_boundaryPerturbation_floatingPoint_regression
```

The flat-vs-de Sitter pilot needs a quantitative pass/fail rule. A candidate
statistic such as harmonic dimension, projected-noise trace, smallest positive
projected eigenvalue, or projected condition number should separate the two
diamond families by more than the within-family sprinkling spread; a useful
working threshold is a separation larger than ten times that spread, with a
monotone response as the expansion parameter is varied. It must also survive
boundary-exact perturbations and either refinement or a named coarse-graining /
renormalization step. Fine-scale ill-conditioning is allowed in a fundamentally
discrete model if a stable large-scale statistic survives. If every such
statistic is geometry-blind, unstable after the stated coarse-graining,
boundary-artifactual, dependent on hand-tuned metric weights, or unconnected to
a source/curvature response law, then P9 should be demoted to finite Hodge
theory on causal diamonds rather than advertised as cosmological-constant
leverage.

The recommended first publishable route is the coarse-grained noise-kernel
variance, not the full Green-function response. Fix a coarse-graining map `R`
before seeing the data, push the positive noise kernel to `R K R^T`, and track
`tr(R K R^T)` across the same coarse-graining ladder for flat and de
Sitter-like finite diamonds. This reuses the existing PSD and
Cauchy-Schwarz/noise-kernel spine and turns the open P9 question into a crisp
test: does the variance plateau remain boundary-invariant and geometry-moving?
The stronger source-response susceptibility should be the flagship follow-up
once finite visible-subspace invertibility and Green-operator stability are in
place.

The first matched ensemble pilot is now deliberately modest. The aggregate
output `AgentTasks/p9-pilot-matched-diamond-ensemble-2026-06-23.json` keeps the
boundary and PSD checks green, but the main fine trace-density statistic does
not clear the proposed `10 * within-family spread` threshold for the larger
tested sizes. A coarse block-size `4` statistic does clear that threshold, but
it is currently better read as a possible coarse-map alignment artifact than as
a physical signal. The next theorem and numerical work should therefore explain
which selected or coarse modes are geometrically forced, rather than tuning
`R` after seeing the output.
The follow-up offset sweep
`AgentTasks/p9-pilot-matched-diamond-offset-sweep-2026-06-23.json` supports the
artifact reading: the offset-0 block map nearly annihilates the flat readout,
while other offsets make the flat trace density large and can erase the
separation. This makes "offset invariance or intrinsic coarse map" a hard
pilot gate.
The new strategy/audit result
`AgentTasks/null-edge-p9-intrinsic-coarse-map-strategy-aristotle-2026-06-23.md`
recommends spectral Hodge coarse modes as the first publishable route, with
Alexandrov/interval abundance and Sorkin-Johnston screen/window channels as
alternatives. This matches the new causal-set observable source `RC5XF8RD`.

Publication-level statement:

> In a finite causal diamond model, boundary-exact and closure-satisfying hidden
> bookkeeping has zero response to closed bulk source tests. Visible closure or
> Pluecker defects produce nonzero finite source observables. Mean-zero hidden
> residuals are not discarded; they define a positive noise kernel whose
> response must be bounded or measured.

### What might be missing

The missing ingredients are the hard ones:

- a physically motivated diamond source observable, not just a toy scalar API;
- a response law connecting finite source tests to curvature or expansion;
- a conservation identity or Ward-like constraint;
- a finite spectral/windowing rule for SJ-style screen entropy;
- a finite Hodge metric and codifferential convention for the diamond
  bookkeeping cochains;
- evidence for Betti-number or harmonic-noise scaling in sprinkled diamonds;
- a proof that cell-local antisymmetric pairings telescope to area-law noise
  rather than volume-law noise;
- a scaling theorem for residual noise amplitude;
- a comparison to cosmological bounds rather than only finite algebra;
- a proof that the hidden sector is boundary-exact or closure-satisfying for
  physical reasons, not by definition.

Failure mode: hidden bookkeeping contributes a bulk volume-scaling mean source,
or the residual noise inherits the usual stochastic-gravity/causal-set amplitude
problems without a new suppression or correlation mechanism.

## 4. Null-step Dirac universality conjecture

### What we think

The ontology says elementary propagation is lightlike or null-step at the
finest level. The theorem version must be narrower:

> A specified class of finite, local, unitary null-step walks has a continuum
> or scaling limit governed by the massive Dirac equation, with mass controlled
> by chirality-flip/coherence parameters.

This would connect the static P1/P2 mass algebra to actual dynamics. The
checkerboard is the one-dimensional base case. The higher-dimensional target is
not "any random null-edge process becomes Dirac"; it is a universality class of
walks with the right locality, unitarity, isotropy/covariance, and chirality
structure.

The sharper version should use "universality" in its RG sense. The Dirac
Hamiltonian should be treated as the fixed point of a null-step walk
coarse-graining flow, with one relevant scalar coupling: the chirality-flip
mass. An anisotropic vector part of the flip generator is not a mass; it is a
Lorentz-violating coupling. Thus the near-term finite theorem package is not
"Dirac from quantum walks", which the literature already owns, but:

```text
null-step walk fixed point
-> L plus R doubling forced by the absence of a 2 x 2 mass term
-> scalar flip generator gives the mass
-> invariant det(P_vis) = mass^2
-> normalized det(rho_vis) is only the frame-relative m/E readout
```

The homogeneous theorem and the causal-set theorem should be separated. The
homogeneous lattice/QW setting can be attacked by finite symbol algebra and
known convergence theorems. The causal-set version, a Lorentz-invariant spinor
hop-stop propagator on a Poisson sprinkling extending Johnston's scalar
propagator, is the real open frontier.

### What the literature says

The relevant prior art is strong. Feynman's checkerboard is the historical
base case. D'Ariano-Mosco-Perinotti-Tosini (`JZEJ4VXA`) treat a 3+1
discrete-time Dirac quantum walk. Bisio-D'Ariano-Perinotti-Tosini
(`BVJBTK8J`, `KCQGEDJE`) connect quantum cellular automata with free-field and
Dirac dynamics. Arrighi-Nesme-Forets (`4F87TGCN`) derive the Dirac equation as
a quantum walk. Arnault-Perez-Arrighi-Farrelly (`PTHQB2RM`) connect
discrete-time walks to fermions in lattice gauge theory. Arrighi-Facchini-Forets
(`VHPN6G7D`) analyze discrete Lorentz covariance. Sato-Katori (`G7NXEZBU`)
provide a Dirac quantum-walk ultraviolet-cutoff guardrail. Arnault et al.
(`I7G53I6T`) give a relativistic quantum diffusion route. Strauch (`XK9ZRDNJ`,
`QSB24VR9`) is useful for early discrete-time quantum walk Dirac limits.

So the novelty cannot be "Dirac from quantum walks." The novelty must be the
null-edge interface: Pluecker mass, observer-conditioned mixedness,
chirality-coherence mass ratio, and formalized finite theorem packaging.
The dynamic mass should be matched to the unnormalized determinant `det P_vis`,
not to `det rho_vis` except after an observer/frame normalization. This keeps
the P1 frame audit intact.

### What we have formally proven

The dynamics side has several anchors:

- `PhysicsSM.Spinor.Checkerboard` and
  `PhysicsSM.Spinor.CheckerboardDynamics` give trusted finite checkerboard
  combinatorics and recurrence/dynamics theorems.
- `PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle` adds draft
  endpoint closed forms.
- `PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore` proves a finite
  null-step walk core: traces/determinants, quasienergy relation, and a
  continuum coherence expression matching `m/E` in the small-parameter limit.
- `PhysicsSM.Draft.NullEdgeQWUnitarity` proves the relevant Pauli-rotation
  gates and one-step walk are unitary.
- `PhysicsSM.Draft.NullEdgeQWExpProvenance` proves the Euler closed-form gates
  match exponential provenance for `Rz` and `Rx`.
- `PhysicsSM.Draft.NullEdgeP2WalkProjectorCoherenceBridge` connects the walk
  coherence ratio to the P2 mass-ratio/coherence theorem.
- `PhysicsSM.Draft.NullEdgeObserverPartialTrace` proves that finite hidden
  partial trace commutes with visible congruence and that determinant-one
  visible congruence preserves the unnormalized determinant.
- `PhysicsSM.Draft.NullEdgeP4VisibleDetInvariant` isolates the same P4
  invariant at the `2 x 2` visible-matrix level: determinant-one visible
  congruence preserves `det(P_vis)`, while trace normalization turns the
  determinant into the frame-relative squared readout.
- `PhysicsSM.Draft.NullEdgeP4PauliNo2x2Mass` proves the single-Weyl no-go: a
  `2 x 2` complex matrix anticommuting with all three Pauli matrices is zero,
  so an invertible Clifford mass term forces an `L plus R` doubling.
- `PhysicsSM.Draft.NullEdgeP4ScalarFlipIsotropy` proves the isotropy half of
  the fixed-point package: a flip generator commuting with all Pauli directions
  has no vector part, while a pure scalar flip commutes with all Pauli
  directions.

### Why it matters

This conjecture decides how seriously we can take the ontology. P1 and P2 show
that mass can be represented as a finite static invariant of null data. P4 must
show that such null data can actually propagate like massive fermions in a
robust way.

If true, the story becomes:

```text
null-step unitary propagation
-> chirality flip/coherence parameter
-> Dirac scaling limit
-> invariant visible determinant mass
-> observer-conditioned mass ratio
-> Pluecker static mass theorem
```

If false, the paper should retreat to a more modest claim: checkerboard and
some quantum-walk models realize the idea, but the ontology is not universal.

### What we would like to show

Near-term theorem targets:

```lean
no_2x2_anticommutant_of_all_pauli
mass_term_forces_LR_doubling
isotropicFlip_iff_scalar
flipGenerator_scalarPart_eq_diracMass
flipGenerator_l1_vectorPart_breaks_isotropy
celestialBoost_acts_by_sl2_on_coin
scalarFlip_is_sl2_invariant
walkVisibleMomentum_det_eq_massSq
walkVisibleMomentum_det_sl2_invariant
walkNormalizedCoin_det_eq_massRatioSq
nullStepWalk_unitary_for_all_momenta
nullStepWalk_dispersion_expansion_dirac
quasienergy_smallMomentum_eq_sqrt_m2_plus_p2
walkProjectorCoherence_eq_massRatio
checkerboardTransfer_sq_eq_kgRecurrence
qwContinuumLimit_matches_diracHamiltonian
universality_under_small_unitary_perturbations
```

Analysis-level and frontier targets:

```lean
nullStepWalk_scalingLimit_eq_diracPropagator
nullStepWalk_doublerBranches_at_BZ_fixedPoints
decoheredFlip_static_variance_eq_integrated_autocorr
causalSetNullWalk_propagator_lorentzInvariant
kahlerDirac_doublers_vs_generations_disjoint
```

Publication-level statement:

> In a sourced class of finite null-step quantum walks, the chirality-flip
> parameter determines the Dirac mass in the continuum scaling limit. The
> finite Pluecker/observer-channel mass identities are the static invariant
> readouts of the same null-step dynamics.

### What might be missing

The hardest missing piece is not another scalar identity. It is a real
universality theorem:

- a class of allowed walks with precise locality/unitarity/covariance
  hypotheses;
- a scaling limit theorem rather than a Taylor expansion in one toy model;
- a connection between the walk spinor/chirality space and the visible/internal
  observer-channel space;
- an invariant `det P_vis = m^2` bridge, separate from the frame-relative
  normalized `det rho_vis`;
- a single-cone or honest species/doubler accounting;
- a proof that Kähler-Dirac multiplicity, left/right chirality doubling, and
  internal generations are not being double-counted;
- a robust treatment of gauge fields and position dependence;
- a way to handle higher-dimensional isotropy and fermion doubling concerns;
- numerical pilots showing the expected dispersion and stability beyond the
  exactly solvable model.

Failure mode: the null-step walk reproduces Dirac behavior only after fragile
fine-tuning, or the mass parameter in the walk cannot be tied to the Pluecker
and observer-channel invariants without extra assumptions.
Another failure mode is that the walk mass can only be matched to the
frame-normalized `det rho_vis`, with no invariant unnormalized determinant
statement. That would weaken the claimed bridge to P1.

## Cross-conjecture dependencies

These four conjectures should be tested in a deliberate order.

1. The observer-channel mass conjecture is the cleanest publication unit because
   it already has the strongest finite proof support.
2. The null-step Dirac universality conjecture is the dynamics gate for the
   ontology. It should become the second paper if the current quantum-walk
   theorem cluster continues to behave well.
3. The finite super-Dirac conjecture is the master synthesis. It should absorb
   P1/P2/P4 only after the operator surface is natural enough to survive review.
4. The P9 source-visibility/noise conjecture should continue, but only under
   the strict rule that zero mean is not enough. It needs source response,
   noise-kernel control, and comparison with stochastic gravity.

The best sign that the program is becoming real physics is not that all four
conjectures become true. It is that each conjecture becomes sharp enough that a
negative result would actually teach us what to abandon.
