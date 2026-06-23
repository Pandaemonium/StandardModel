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

The observer-conditioned statement is:

```text
rho_{p|u} = P / Tr_u(P),
2 sqrt(det(rho_{p|u})) = m / E_u.
```

The conjecture is that this is the correct finite origin-of-mass interface:
massive visible particles are not single massive elementary edges, but
observer-channel reductions of internally structured null processes. The Higgs
does not simply "add mass" as a scalar after the fact. It makes left/right
chirality transitions legal and creates chirality coherence of size `m / E_u`;
observer tracing or dephasing can then convert that coherence into the visible
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

### Why it matters

This conjecture gives the paper an accessible but precise claim:

> A fine-scale null process can remain pure and lightlike, while an observer who
> does not resolve internal or chirality bookkeeping sees a mixed celestial
> qubit. The mixedness is exactly the frame-relative mass ratio `m/E_u`.

That is the cleanest way to say "mass is emergent from coarse-grained
lightlike pieces" without confusing invariant mass with observer-dependent
normalization.

If the conjecture fails, it will pinpoint the failure: either the observer
state is the wrong normalization, the Higgs/chirality channel is not the right
purification, or the concurrence language is only an analogy.

### What we would like to show

Near-term theorem targets:

```lean
observerConditionedDensity_covariant_under_frame_change
visibleDensity_from_internal_purification
normalized_mass_ratio_eq_concurrence
chiralityCoherence_unitaryDilation_eq_massRatio
dephasing_visibleMixedness_eq_lostChiralityCoherence
loCC_or_local_channel_massRatio_monotone
frameChange_transforms_rho_p_given_u_without_changing_detP
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

- a justified observer channel, not only a scalar normalization;
- a clean unitary dilation from visible spinor plus internal/chirality labels;
- a precise distinction between invariant mass and frame-relative `m/E_u`;
- a proof that physically relevant Higgs/Yukawa dynamics create exactly the
  coherence parameter used in the finite model;
- monotonicity statements limited to actual local or LOCC-like channel classes.

Failure mode: the normalized determinant remains true but does not arise from a
natural observer/Higgs channel, making "mass as mixedness" a useful analogy
rather than a physical mechanism.

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

### What the literature says

This branch collides directly with causal-set and stochastic-gravity prior art.
Sorkin's everpresent-Lambda direction (`ZP7E648U`) and the Das-Nasiri-Yazdi
papers (`K5CFI3HI`, `IHVSDGUC`) already explore fluctuating cosmological
constant ideas. Hu-Verdaguer stochastic gravity (`PRCWRMFC`, `TXN5JSZ5`),
Phillips-Hu noise-kernel work (`5T5BQ6PT`), Hu-Matacz (`PW8MXJ8I`), and
Campos-Verdaguer (`K8SI5KZ9`) make clear that stress fluctuations are not a
side issue: a zero mean with nonzero noise is still gravitationally meaningful.

Jacobson's entanglement-equilibrium route (`7V9FV86B`) is the gravity
thermodynamics guardrail. The causal-set Sorkin-Johnston entropy papers
(`PU8Q5WKT`, `P8PE3SZ9`) warn that area-law behavior often requires spectral
truncation/windowing. Twisted and null twisted geometries (`63MQ6KC3`,
`BC9Q4QNG`) give the closure/flux language closest to spin-network and null
horizon geometry.

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
- `PhysicsSM.Draft.NullEdgeP7RecoverabilityInvisibilitySeparation` supplies an
  important warning: recoverability is not source invisibility.

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
closedTest_boundaryExact_meanResponse_zero
closureSatisfying_hiddenBookkeeping_bulkMean_zero
visiblePluckerDefect_bulkResponse_nonzero
noiseKernel_recovered_by_delta_pair_tests
noiseResponse_positive_semidefinite
sourceVisibility_implies_not_pure_recoverability
sjWindowedScreenEntropy_area_law_finite_model
diamondSource_response_conservation_identity
```

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
- a scaling theorem for residual noise amplitude;
- a comparison to cosmological bounds rather than only finite algebra;
- a proof that the hidden sector is boundary-exact or closure-satisfying for
  physical reasons, not by definition.

Failure mode: hidden bookkeeping contributes a bulk volume-scaling mean source,
or the residual noise inherits the usual stochastic-gravity/casual-set amplitude
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
-> observer-conditioned mass ratio
-> Pluecker static mass theorem
```

If false, the paper should retreat to a more modest claim: checkerboard and
some quantum-walk models realize the idea, but the ontology is not universal.

### What we would like to show

Near-term theorem targets:

```lean
nullStepWalk_unitary_for_all_momenta
nullStepWalk_dispersion_expansion_dirac
quasienergy_smallMomentum_eq_sqrt_m2_plus_p2
walkProjectorCoherence_eq_massRatio
checkerboardTransfer_sq_eq_kgRecurrence
qwContinuumLimit_matches_diracHamiltonian
universality_under_small_unitary_perturbations
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
- a robust treatment of gauge fields and position dependence;
- a way to handle higher-dimensional isotropy and fermion doubling concerns;
- numerical pilots showing the expected dispersion and stability beyond the
  exactly solvable model.

Failure mode: the null-step walk reproduces Dirac behavior only after fragile
fine-tuning, or the mass parameter in the walk cannot be tied to the Pluecker
and observer-channel invariants without extra assumptions.

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
