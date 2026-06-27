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

The current priority order is slightly different from the numbering. The
highest-leverage near-term target is the interface between the
observer-channel mass conjecture and the null-step dynamics conjecture: a
proper-time/purity rate law that turns the static determinant identity into a
dynamical statement. The second priority is P9 as a finite source-visibility
and noise-channel paper, with cosmological-constant claims gated by an explicit
amplitude/correlation comparison. The finite super-Dirac conjecture remains the
deepest unification target, but it should be gated by the one-diamond `D^2`
calculation before broad formalization continues.

Relative entropy and recoverability should now be treated as shared
infrastructure across these conjectures, not as a side analogy. The question
"what does an observer channel forget, preserve, or make recoverable?" appears
in observer-channel mass, P9 source visibility, stable particle sectors, and
the manuscript's broader measurement/coarse-graining claims.

Every conjecture should now be split into four evidence layers:

```text
exact finite identity       -- theorem-level algebra we can bank now
existence/naturality claim  -- whether the finite object is canonical
scaling/dynamical theorem   -- whether it survives limits or evolution
physical interpretation     -- what the finite result means in physics
```

Most current progress is in the first layer. The danger is accidentally using a
proved finite identity as if it had already supplied the naturality, scaling,
and interpretation layers. The useful publication discipline is therefore:
promote finite identities aggressively, but label existence, scaling, and
physics claims separately.

The current fast-falsifier table is:

| Conjecture | Promote now | Genuine open claim | Fastest falsifier |
| --- | --- | --- | --- |
| Super-Dirac | product-graded square formula | canonical Lorentzian operator with the right symbol | flat-space sign test and one-diamond classification |
| Observer channel | covariant determinant, Schmidt, and exterior-square identities | physical Yukawa dilation and privileged observer channel | three-label channel counterexamples and covariance failure |
| P9 | finite Hodge, Ward, PSD, and coarse-map identities | geometry-sensitive sub-volume gravitational response | topology audit and preregistered coarse-map tests |
| Null-step walk | band-limited convergence for a specified walk | stability/universality and invariant mass bridge | full Brillouin-zone cone census |

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

The geometry must be specified before this slogan is formalized. The full order
complex of a poset contains transitive edges `x < z` whenever `x < y < z`; these
diagonal edges need not represent elementary null propagation. The cleaner
null-edge operator should therefore start from the Hasse graph of elementary
null edges and attach explicit 2-cells to causal diamonds. The alternative is
to use the full order complex while marking the Hasse edges as physical and
proving independence from transitive diagonals, but that is a harder claim.

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

The product grading should be built into the candidate operator. On finite
cochains with simplicial grading `Gamma_K`, the cleaner model is

```text
D_U = d_U + d_U^x
M_Phi = offDiagonal(Phi)
D_{U,Phi} = D_U + Gamma_K M_Phi.
```

The factor `Gamma_K` matters: without it, even a constant internal mass block
can produce the wrong cross terms. The exact finite square identity should be
treated as a theorem-level algebra target:

```text
D_{U,Phi}^2 =
  d_U d_U^x + d_U^x d_U
  + d_U^2 + (d_U^x)^2
  + M_Phi^2
  - Gamma_K [D_U, M_Phi].
```

In this decomposition, the first line is the covariant Hodge Laplacian, the
second line is the additive curvature defect, `M_Phi^2` is the Yukawa mass
block, and the commutator is the finite gauged Higgs derivative. This identity
is not by itself the deep conjecture; the deep parts are Lorentzian sign,
diamond-holonomy identification, symbol definition, and naturality.

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

The closest direct prior art is Marcolli-van Suijlekom gauge networks
(arXiv:1301.3480). They already build graph/quiver Dirac operators in the
category of finite spectral triples and obtain lattice gauge plus Higgs terms
from a spectral action. This is a major sharpening of the novelty claim: a
generic graph spectral triple with a Higgs block is not new. The null-edge
contribution has to live in the conjunction of three extra constraints:

```text
causal directed order/dag complex
+ Lorentzian/Krein rather than Riemannian Hilbert structure
+ Pluecker-null kinetic symbol rather than generic graph momentum.
```

Perez-Sanchez's comment on gauge networks (arXiv:2508.17338) is an important
guardrail: in the naive gauge-network lattice model, the continuum limit loses
the Higgs scalar and becomes pure Yang-Mills. Therefore the causal/directed
`Phi` block must survive coarse-graining as a genuine dynamical or covariantly
transported field; otherwise the super-Dirac Higgs term is only a finite
bookkeeping block.

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

The decisive near-term gate is deliberately small: build the natural `D` on one
causal diamond, or equivalently one oriented two-simplex with two competing
paths, and compute `D^2` coefficient by coefficient. The conjecture earns
content only if the curvature block is the independently defined diamond
path-pair defect, not merely some curvature term in the generic superconnection
sense. If the one-diamond square does not recover the diamond holonomy defect
with fixed conventions, the super-Dirac conjecture should be weakened before
further Lean investment.

On a diamond with two path transports `T1` and `T2`, the additive curvature
defect and multiplicative holonomy should be related exactly:

```text
H_diamond = T1 * T2^{-1}
F_diamond = T1 - T2 = (H_diamond - I) * T2.
```

Only a comparison with `log H_diamond` requires a small-curvature approximation
and a branch choice. Thus the best finite target is additive, not logarithmic:
the `d_U^2` matrix on the diamond 2-cell equals `T1 - T2`, hence equals
`(H_diamond - I) * T2`.

The Krein part has the same discipline. Existence of an indefinite form is not
enough, since many finite operators can be made self-adjoint for some chosen
indefinite form. The target is a causally forced split signature and time
orientation compatible with the causal order and the plus/minus branch
projectors.

The mass-shell statement also needs correct typing. Since `Phi^dagger Phi` is
generally a flavor/internal matrix, the honest condition is statewise or
spectral:

```text
(det(P) I_F - M_Phi^2) Psi = 0
```

or, on a mass eigenchannel `f_r`,

```text
M_Phi^2 f_r = m_r^2 f_r
det(P_r) = m_r^2.
```

The word "symbol" should also be restricted. An irregular finite graph has no
canonical momentum-space principal symbol. The claim should be one of:

```text
exact Bloch symbol on a periodic diamond complex
frozen-coefficient local symbol
asymptotic symbol for a refining family
```

Without one of these, "the kinetic symbol equals the Pluecker determinant" is
undefined rather than merely unproved.

The latest sharpening makes the symbol/soldering theorem the flagship target.
The already banked static theorem

```text
(gamma . P)^2 = det(P) I
```

is not enough unless the causal order-complex operator has a first-order
commutator whose local symbol is exactly the slash of the weighted null-edge
momentum bundle. For an edge-weighted local covector `xi`, the desired finite
statement is:

```text
sigma_x(xi) = sum_{e incident x} a_e xi_e gamma.p_e
sigma_x(xi)^2 =
  (sum_{e<f} a_e a_f xi_e xi_f |psi_e wedge psi_f|^2) I.
```

With nonnegative active weights, the scalar is nonnegative and vanishes exactly
when all active null directions are collinear. This would identify the graph
operator's characteristic variety with the null cone, turning the Lorentzian
non-ellipticity of a Krein Dirac operator into a feature rather than a defect.

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
  finite algebra: a self-adjointness wrapper, the mass-shell branch symmetry
  currently written as `(1 / m) D`, the involution theorem when
  `D^2 = m^2 I`, the equality with plus-minus branch projectors, and an explicit
  `MassShellConstraint` predicate recording equality rather than addition of
  kinetic and Yukawa mass squares.

The notation in that cluster should be audited before promotion. In the
Lorentzian spectral-triple literature, three structures must not all be called
`J`:

```text
eta        -- linear fundamental symmetry defining the Krein product
C or JReal -- antilinear real structure / charge conjugation
Sigma_m    -- mass-shell sheet involution D / m
```

The branch-projector theorem concerns `Sigma_m`, not the fundamental symmetry
`eta` and not the antilinear real structure. The adjoint used to state
Lorentzian self-adjointness must be defined from `eta` before `D / m` is formed.

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

Status: proposed target names. They are not current Lean theorem inventory
unless the surrounding text names an implemented module explicitly.

```lean
superDirac_productGrading_def
superDirac_kreinForm_def
superDirac_is_odd
superDirac_total_grading_def
dU_deltaU_odd_form_grading
phi_odd_chirality_grading
superDirac_etaKreinAdjoint_def
superDirac_is_etaSelfAdjoint_or_antiSelfAdjoint
realStructure_chargeConjugation_def
massShellSign_def
massShellSign_eq_plusProjector_sub_minusProjector
productGradedSuperDirac_sq
covariantOrderDifferential_sq_eq_diamondCurvature
superDirac_oneDiamond_curvatureBlock_eq_holonomyDefect
diamondAdditiveDefect_eq_holonomyMinusId
diamond_pathDefect_eq_holonomySubOne_mul_reference
higgsBlock_sq_eq_yukawaMassMatrix
nullGraphDirac_commutator_eq_localSymbol
localNullSymbol_eq_slash_weightedBundleMomentum
localNullSymbol_sq_eq_weightedPluckerMass
localNullSymbol_sq_zero_iff_activeDirections_collinear
massShellConstraint_iff_kernel_on_bundleMode
massShell_statewise_kinetic_eq_yukawa
flatSuperDiracSymbol_has_lorentzianMassShell
oneDiamond_naturalOperator_classification
superDiracSq_crossTerm_eq_gaugedHiggsKinetic
superDirac_sq_eq_laplacian_plus_curvature_plus_higgs
superDirac_kreinForm_signature_eq_causal
spectralAction_TrDsq_eq_plucker_yukawa_diamond
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
- a one-diamond symbolic computation proving that the curvature block is the
  existing diamond path-pair defect, not merely a generic transported
  differential curvature;
- a choice between a Hasse-graph-with-diamond-2-cells model and a full-order-
  complex model with transitive-diagonal independence;
- a proof that the Pluecker determinant is the kinetic symbol/eigenvalue, not a
  second additive mass block;
- a soldering/symbol theorem identifying the first-order graph commutator with
  the Dirac slash of the weighted null-edge momentum bundle;
- an on-shell mass-shell theorem, preferably
  `massShellConstraint_iff_kernel_on_bundleMode`, showing that equality between
  the kinetic Pluecker determinant and the Higgs/Yukawa block is forced by the
  first-order equation under flat/covariantly-constant hypotheses rather than
  imposed as a definition;
- a statewise or spectral mass-shell statement rather than an equality between
  a scalar determinant and a flavor-space matrix;
- a restricted definition of symbol: Bloch, frozen-coefficient local, or
  asymptotic over a refining family;
- a finite classification of natural operators on a single edge, one diamond,
  vertically glued diamonds, and horizontally glued diamonds;
- a product grading combining simplicial degree and chirality;
- a disambiguation of `eta`, `JReal`, and `Sigma_m = D / m`;
- a proof that the cross term is the gauged Higgs kinetic term rather than an
  unwanted error term;
- a two-triangle decomposition relating diamond holonomy to `d_U^2` curvature;
- a finite low-order spectral-action statement such as
  `Tr(D^2) = graph kinetic + Yukawa + diamond curvature` before attempting
  heat-kernel or continuum claims;
- convention audits for signature, chirality, grading, and normalization.

Failure mode: no natural odd Krein/J-self-adjoint first-order operator can be
defined without adding arbitrary structure; the only self-adjoint version is
positive-definite and therefore Wick-rotated rather than Lorentzian; the kinetic
Pluecker determinant and the Yukawa block cannot be related by an on-shell
kernel condition without double-counting; the graph operator has no Pluecker
symbol; the Higgs/Yukawa block disappears or becomes constant under the relevant
coarse-graining; or the diamond curvature and Higgs kinetic cross term fail to
fit the same graded operator surface.

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

This makes the determinant only the first invariant, not the whole content. If
the only observable is `det(P_vis) = m^2`, then the Gram factorization into
visible Pluecker spread and internal coherence is underdetermined: many
different spread/coherence pairs can produce the same mass. The load-bearing
observable is therefore a relative-entropy or recoverability deficit between
coherent and dephased resolution channels, and it must not collapse to a
function of `m` alone. A priority literature check is whether recent
relativistic-quantum-information observer-channel frameworks already make the
invariant-versus-frame-relative split; if so, the novelty here narrows to the
Gram/Higgs-source mechanism.

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

The general masslessness criterion is not "the internal Gram matrix has rank
one." The correct exterior-square statement is:

```text
P_vis = V G V^dagger
det(P_vis) = (Lambda^2 V) (Lambda^2 G) (Lambda^2 V)^dagger
det(P_vis) = 0 iff rank(V G^{1/2}) <= 1.
```

Thus `rankOne_internalGram_iff_massless` is false without hypotheses on the
visible columns. If all visible spinors are collinear, then `G = I` can have
full rank while the visible determinant is zero. For two labels with
`v_1 wedge v_2 != 0`, the reduced formula above does make masslessness
equivalent to `det(G) = 0`.

There is also a useful negative result for dephasing. The two-label monotonicity
can hold under its hypotheses, but unrestricted `n`-label dephasing
monotonicity is false. A concrete three-label counterexample is:

```text
V = [[1, 0, 1],
     [0, 1, 1]]

G = [[1,   1/5, 1/5],
     [1/5, 1,   1/5],
     [1/5, 1/5, 1  ]]
```

The Gram matrix is positive semidefinite, but `det(V G V^dagger) = 16 / 5`,
while complete hidden-label dephasing sends `G` to `I` and gives
`det(V V^dagger) = 3`. Thus dephasing decreases the determinant in this
example. Any positive theorem for more than two labels needs phase-alignment,
orthogonality, channel, or visible-column hypotheses.

The manuscript should also separate three notions that have been bundled under
"coherence":

```text
hidden-label overlaps       -- entries of G
left/right chirality term   -- off-diagonal Yukawa coherence
visible mixedness/Schmidt   -- reduced observer state impurity
```

They can move in opposite directions, so claims about one should not be used as
evidence about another without an explicit channel theorem.

A clean first-order bridge is the helicity-reduced Dirac/Yukawa two-level
model:

```text
H_h(p) = h |p| sigma_z + m sigma_x
E = sqrt(|p|^2 + |m|^2).
```

The positive-energy projector has off-diagonal left/right coherence
`|m| / (2 E)`. After copying the chirality record to an unresolved environment,
or equivalently dephasing in the chirality basis, the dephased state has

```text
2 sqrt(det(rho_h^dephased)) = |m| / E.
```

This is a precise finite theorem target connecting first-order Yukawa
coherence to determinant mixedness. The physical conjecture is that the actual
Yukawa dynamics and detector algebra select this dilation rather than an
arbitrarily assigned purification.

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
gramWeightedPlucker_eq_exteriorSquare
massless_iff_rank_VGsqrt_le_one
det_visibleReduced_twoLabel_eq_wedge_times_detGram  -- banked in ObserverChannelCore
dephasing_internalGram_mass_monotone                -- banked in ObserverChannelCore
threeLabel_dephasing_not_monotone
twoLabel_noncollinear_massless_iff_detGram_zero
normalized_mass_ratio_eq_concurrence
visibleMixedness_eq_chiralityCoherence_schmidt       -- determinant bridge banked
chiralityPopulations_balanced_iff_coherence_eq_massRatio
dephasing_visibleMixedness_eq_lostChiralityCoherence
twoLevelYukawa_coherence_to_dephasedDet
massRatioSq_eq_linearEntropy_visible
unital_visibleChannel_massRatio_monotone
entangling_hiddenChannel_massRatio_nonmonotone
internalCoherenceLoss_eq_relativeEntropyDeficit
coherenceDeficit_not_determined_by_mass_alone
linearEntropyRate_visible_eq_flipFrequency
```

Publication-level statement:

> The invariant mass is `det(P)`. The observer-normalized visible state
> `rho_{p|u}` has determinant `(m/2E_u)^2`. In the finite null-edge model,
> Higgs/Yukawa-permitted chirality coherence is the first-order source of this
> ratio, and observer channels determine which coherence becomes visible
> determinant mixedness.

The dynamical upgrade is a proper-time/purity rate law. The static identity
`2 sqrt(det rho) = m / E` is too close to time dilation to carry the
origin-of-mass story by itself. A non-tautological theorem would prove that the
linear-entropy production or coherence-decay rate along a null-step/chirality-
flip walk is controlled by the flip frequency, with the static determinant
identity arising only after integration and observer normalization.

A first finite channel step has now been banked in
`PhysicsSM.Draft.NullEdgeP2PartialDephasingRateBridge`. In the real two-level
chiral proxy `[[q,c],[c,1-q]]`, partial dephasing `c |-> a*c` changes the
determinant, purity, and normalized mass-ratio-square by exact algebraic gaps:

```text
det gap              = (1 - a^2)c^2
purity loss          = 2(1 - a^2)c^2
mass-ratio-square gap = 4(1 - a^2)c^2.
```

The same module also banks the iterated version:

```text
n-step mass-ratio-square gap = 4(1 - (a^n)^2)c^2.
```

This is the right kind of result for the observer-channel conjecture: it names
the channel and identifies the precise coherence loss that becomes visible as
mass-ratio/proper-time-square. It should still be advertised as a finite
dephasing-channel scaffold, not as a continuum flip-rate theorem.

### What might be missing

The core risk is physical interpretation. The algebra is finite and strong, but
we still need:

- the two-observer split: resolution partial trace versus kinematic
  normalization;
- a clean unitary dilation from visible spinor plus internal/chirality labels;
- a precise distinction between invariant mass and frame-relative `m/E_u`;
- an internal Gram model that is physically motivated rather than assigned
  post hoc;
- an operational coherence deficit, preferably relative-entropy or
  recoverability based, that distinguishes coherent from dephased internal
  labels without being determined by `m` alone;
- the finite counterexample now banked in
  `PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet` shows that even among
  trace-one real symmetric two-state density proxies, determinant mass does not
  determine squared off-diagonal chirality coherence. The same module now
  packages the witness inside a conservative positive-semidefinite proxy class
  via `determinant_does_not_determine_coherenceSq_in_densityClass`, and names an
  explicit off-diagonal trace-pairing readout in
  `determinant_does_not_determine_operationalReadout_in_densityClass`. It also
  banks the stronger bounded-effect witness
  `determinant_does_not_determine_positiveEffectReadout_in_densityClass`, using
  an X-basis-style positive effect. The same file also proves
  `determinant_does_not_determine_twoOutcomeReadout_in_densityClass`, where the
  effect and its complement sum to the trace-one total. The next strengthening
  is to move from these finite operational separators to a
  relative-entropy or recoverability deficit;
- a covariance test showing that the physical representation acts as
  `A tensor V_int`, with `V_int` unitary on unresolved labels, so partial trace
  commutes with visible transformations;
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

The hard comparison is not just volume versus area. Sorkin-style everpresent
Lambda already predicts a `1 / sqrt(V)` amplitude from number-volume
fluctuations, so P9 advances the physics only if its response law produces a
parametrically different amplitude, correlation structure, or suppression
mechanism. If the finite Hodge/noise channel simply reproduces the
everpresent-Lambda scaling in new notation, the branch should be demoted to a
finite causal-diamond Hodge theory result.

There is also an opposite trap. If the finite observer channel suppresses local
vacuum residuals from volume scaling down to a screen law, that may be excellent
vacuum filtering but too suppressed to explain the observed nonzero dark energy.
In four spacetime dimensions, a codimension-two screen gives

```text
sqrt(A) / V ~ L^(-3) = V^(-3/4),
```

while the everpresent-Lambda order is

```text
sqrt(V) / V ~ L^(-2) = V^(-1/2).
```

Thus the sharp P9 model should be two-component:

```text
local UV vacuum bookkeeping -> exact/projected/screen-supported sector
observed Lambda-scale residual -> surviving global/harmonic/unimodular sector
```

This makes the win condition more precise. P9 can explain why local vacuum
bookkeeping does not gravitate as a bulk source. It explains the observed
Lambda-scale only if the harmonic/global quotient has a quantitative
`L^(-2)`-scale residual, or if another sourced dark-energy sector is named.

Before another harmonic-sector push, P9 needs a topology audit. The full order
complex of a closed finite causal interval `[a,b]` is typically contractible
because chains can be coned by the minimum or maximum endpoint. With a positive
definite finite Hodge metric, exact positive-degree harmonic cohomology may
therefore vanish:

```text
H^k(K) = 0, ker Delta_k = 0 for k > 0
```

on the full closed interval. P9 must explicitly choose among:

```text
proper interval with endpoints removed
relative cohomology H(K, boundary K)
constant H^0 mode
top-degree relative mode
low-lying near-harmonic spectral modes rather than exact cohomology
```

A metric cannot create nontrivial cohomology if it is positive definite. If the
SJ-style form is semidefinite or indefinite, the ordinary finite Hodge
conclusions must be replaced by a quotient or Krein-style formulation.

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
- `PhysicsSM.Draft.NullEdgeP9EverpresentLambdaScaling` and
  `NullEdgeP9EverpresentLambdaTension` formalize the comparison target: the
  everpresent-Lambda RMS scale is `1 / sqrt(V)`, and any uniform or weighted
  suppression mechanism must beat that benchmark rather than merely rename it.
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
- `PhysicsSM.Draft.NullEdgeP9SubdiamondRestrictionPreservesLocalReadout` proves
  the first positive T2 control: under a transitive causal relation,
  Alexandrov/subdiamond restriction preserves the relevant local interval
  readout inside the chosen subdiamond.
- `PhysicsSM.Draft.NullEdgeP9OperationalGap` packages the T1 readout difference
  as an explicit finite observer-channel gap. This is the right publication
  language for "visible to the observer" at the finite-witness layer, while the
  scaling and cosmological interpretation layers remain unproved.
- `PhysicsSM.Draft.NullEdgeP9OperationalGapCoarseMap` packages the negative T2
  control in the same language: the named critical coarse map erases the
  bucket-level operational gap, so visibility is not automatic under
  coarse-graining.
- `PhysicsSM.Draft.NullEdgeP9SubdiamondNonvacuity` answers a vacuity concern:
  the proper subdiamond `(0,3)` still separates the two histories by local
  signature, so the subdiamond-preservation theorem is not merely a
  whole-diamond tautology.
- `PhysicsSM.Draft.NullEdgeP9NoncriticalCoarseErasure` proves an important
  negative guardrail: a surjective coarse map can keep the critical swapped pair
  distinct and still erase the bucket-one local signature. Thus P9 cannot claim
  unrestricted coarse-map universality; it must specify an admissible observer
  or coarse-map class.
- `PhysicsSM.Draft.NullEdgeP9ExactRecoveryAdmissibleCoarseMap` supplies the
  first positive information-theoretic admissibility certificate: if a common
  exact recovery map reconstructs both fine source signals from their coarse
  outputs, then every selected fine distinguishing test pulls back to a coarse
  observer test. This is a sufficient guardrail, not a characterization of all
  physically admissible coarse maps and not an approximate-recovery theorem.
- `PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback`
  strengthens that guardrail with finite probability structure: normalized
  source distributions, column-stochastic observer channels, and observable
  expectations. Under common exact stochastic recovery, every fine observable
  that separates the two source distributions has a pulled-back coarse
  observable that separates their coarse observer outputs.
- `PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryGap` sharpens the same
  statement quantitatively: the pulled-back coarse observable preserves the
  exact expectation gap of the fine observable on the selected source pair.
- `PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryComposition` proves the
  corresponding closure law: exact stochastic recovery is stable under
  composition of observer channels on the selected source pair. This is what
  makes exact recovery a usable sufficient class of admissible P9 channels,
  rather than a single isolated certificate.
  The prior-art frame is comparison of experiments and stochastic sufficiency:
  Le Cam `QAQA2SRN`, Torgersen `QJGJ6KA7`, and the Markov-category formulation
  `9SN4VCVJ` are now the guardrails for this interpretation.
- `PhysicsSM.Draft.NullEdgeP9StochasticErasureNotRecoverable` proves the no-go
  counterpart: if a stochastic observer channel sends two genuinely distinct
  source distributions to the same coarse output, then it cannot be exactly
  recoverable for that pair. This fences the admissible-channel class against
  the known erasing-map counterexamples.
- `PhysicsSM.Draft.NullEdgeP9DiamondLocalityNoiseInvariance` proves the T3
  locality/noise guardrail: once the closed diamond and all relation entries
  internal to it agree, external relation noise cannot change the local
  interval-size readout.
- `PhysicsSM.Draft.NullEdgeP7RecoverabilityInvisibilitySeparation` supplies an
  important warning: recoverability is not source invisibility.
- `PhysicsSM.Draft.NullEdgeP7ProperTimePurityBridge` supplies the scalar
  normalized-qubit bridge: squared proper-time ratio equals twice visible
  linear entropy, and unital Bloch-radius contractions monotonically increase
  that proper-time-square. This is still a static observer-channel theorem, not
  a flip-rate dynamics theorem.

The Hodge version now has an abstract projector algebra, but it has not yet been
grounded in a geometry-dependent finite diamond metric. It should reuse the
existing finite cochain seed, boundary-exact results, and noise-kernel modules,
then add an explicit metric/adjoint layer before any statement about harmonic
bookkeeping is advertised as cosmological physics.

The adversarial gate is now sharper. Boundary-exact invisibility and
zero-mean/nonzero-variance residuals are generic finite algebra unless they are
attached to a causal-diamond metric, a harmonic projector, and a response law.
The next decisive finite object is therefore an explicit weighted Hodge
projector on the chosen finite diamond complex. The robust version is

```text
Delta_k = d_{k-1} d_{k-1}^* + d_k^* d_k
Pi_H = I - Delta_k^+ Delta_k,
```

with the Moore-Penrose inverse taken in the stated weighted metric. Formulas
using ordinary inverses of the up and down Laplacians require invertibility on
their ranges and fail precisely where harmonic modes occur. P9 earns physics
content only when the harmonic/noise subspace has computable dimension,
spectrum, and conditioning that depend on the causal diamond geometry rather
than only on an arbitrary finite complex.

The source and response law must also be derived rather than defined by
annihilation. A finite Stokes theorem says exact sources are invisible to closed
tests, but the physics needs independently specified geometry variables and an
action or transfer law:

```text
S_geom(q_N), S_matter(psi, q_N)
J_N = - partial S_matter / partial q_N
L_N = partial^2 S_geom / partial q_N^2
L_N h_N = J_N + xi_N
E[xi_N] = 0
Cov(xi_N) = K_N.
```

On a gauge-fixed visible subspace with Green operator `G_N`, the
gravitationally relevant residual is `G_N K_N G_N^*`, not merely `tr(K_N)`.
Ward-type identities such as `B_N J_N = 0` and
`B_N K_N = K_N B_N^* = 0` should come from gauge, boundary, action, or transfer
symmetry rather than from the definition of invisibility.

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

The top-line falsification test is therefore
`predicted_deltaLambda_amplitude_vs_everpresent`: compute the amplitude and
correlation structure implied by the finite response law, compare it with the
everpresent-Lambda `1 / sqrt(V)` benchmark, and demote the branch if the result
is only a reformulation without a new suppression or correlation handle.

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
closedIntervalOrderComplex_contractible
weightedHodgeProjector_eq_pseudoinverseProjector
harmonicNoiseKernel_restricts_to_projected_source
harmonicNoiseKernel_positiveDefinite_iff_no_hidden_null_modes
harmonicNoiseKernel_conditionNumber_refinement_bound
predicted_deltaLambda_amplitude_vs_everpresent
sjWindow_rule_is_intrinsic_and_preSpecified
areaLaw_noiseTrace_not_window_alignment_artifact
propagatedNoiseCovariance_eq_GKGadjoint
coarseMap_is_intrinsic_normalized_stable
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

Every coarse map should be intrinsic and normalized before the data are
inspected. For a coarse map `R_N`, require relabeling invariance, stated
weighted normalization such as `R_N R_N^* = I`, stability under small relation
or weight perturbations, and refinement equivariance where applicable. For
spectral coarse modes, use projectors onto whole eigenvalue bands rather than
individual eigenvectors, since degenerate eigenspaces have no canonical basis.
Require a spectral gap and perturbation bound.

Scaling exponents should be named rather than grouped under one "area" label.
If `N ~ L^d`, then:

```text
bulk                      N
codimension-1 boundary    N^((d-1)/d)
codimension-2 screen      N^((d-2)/d)
topological               N^0
```

In four dimensions, `N^(3/4)` and `N^(1/2)` are different claims. A
Sorkin-Johnston window or selected-sector trace should specify which exponent
it predicts and why the window was fixed independently of the desired result.
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
- an intrinsic, pre-specified window rule; hand-tuned spectral windows are the
  same epistemic failure mode as a coarse map selected after seeing the data;
- a finite Hodge metric and codifferential convention for the diamond
  bookkeeping cochains;
- a topology audit deciding whether the full closed interval has trivial
  positive-degree harmonic sector, and if so whether P9 uses a proper interval,
  relative cohomology, constant mode, top relative mode, or near-harmonic
  spectral band;
- a pseudoinverse-based harmonic projector in the chosen weighted metric;
- evidence for Betti-number or harmonic-noise scaling in sprinkled diamonds;
- a proof that cell-local antisymmetric pairings telescope to area-law noise
  rather than volume-law noise;
- a scaling theorem for residual noise amplitude;
- a comparison to the everpresent-Lambda amplitude and to cosmological bounds
  rather than only finite algebra;
- a propagated-noise estimate for `G_N K_N G_N^*`, not only a trace estimate for
  the source noise kernel;
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

For the near-term paper, "fixed-point stability" is the safer phrase than full
"universality." A genuine universality theorem needs an explicit RG or
coarse-graining map on walk space. Before that exists, the publishable target is
to classify stable translation-invariant null-step fixed points, show that the
scalar flip is the unique mass-like isotropic direction, and bound
isotropy-preserving perturbations to leading order.

The specified walk class should be explicit. A clean homogeneous target uses a
translation-invariant, finite-range unitary `U_a` on
`l2(a Z^d) tensor C^r`, with unit-speed shifts, an analytic Bloch matrix
`U_a(k)` near `k = 0`, an isolated quasienergy band, stated isotropy/parity/time
reversal assumptions, and an interchirality coupling `m a + O(a^2)`. Choose the
logarithm on the isolated low-energy band:

```text
H_a(k) = (i / a) Log U_a(k).
```

The rigorous stability theorem should be a band-limited estimate:

```text
sup_{|k| <= Lambda}
  || H_a(k) - (alpha . k + beta m) ||
  <= C a (Lambda^2 + m^2),
```

and Duhamel's formula should then compare `U_a^{floor(t/a)}` with Dirac
evolution on band-limited states for bounded times. This is a real scaling
limit theorem; a low-order Taylor expansion of one walk is not enough.

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
Bisio-D'Ariano-Tosini (`arXiv:1212.2839`) is especially relevant because it
sets the QCA/Dirac comparison as an operational convergence problem. The 2025
QCA fermion-doubling analysis (`arXiv:2505.07900`) makes full Brillouin-zone
species accounting a theorem obligation for this program.

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
diracFixedPoint_stable_under_isotropyPreserving_perturbations
properTimePurityRate_eq_flipFrequency
```

Analysis-level and frontier targets:

```lean
nullStepWalk_scalingLimit_eq_diracPropagator
bandLimitedNullWalk_convergesToDirac
nullStepWalk_doublerBranches_at_BZ_fixedPoints
brillouinZone_coneCensus
decoheredFlip_static_variance_eq_integrated_autocorr
causalSetNullWalk_propagator_lorentzInvariant
kahlerDirac_doublers_vs_generations_disjoint
```

The doubler/generation bookkeeping is a gate, not a side note. Lattice and walk
models can produce Brillouin-zone or staggered/Kahler-Dirac multiplicities,
while the internal `H_3(O)` story supplies a separate candidate family
multiplicity. Before dynamics and generation claims are presented together, the
program must show that these multiplicities are disjoint, or else state a no-go
explaining which apparent generations are discretization artifacts.

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
- a band-limited convergence estimate using an isolated quasienergy branch and
  a controlled logarithm;
- a full Brillouin-zone census of gap closings, cone locations, chiralities,
  multiplicities, and effective masses;
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

The invariant mass bridge should be derived independently from the walk
dispersion. Starting from a quasienergy `epsilon_a(k)`, prove either an exact
deformed shell

```text
epsilon_a(k)^2 - |q_a(k)|^2 = m^2
```

for a naturally derived lattice momentum `q_a(k)`, or an asymptotic shell

```text
epsilon_a(k)^2 - |k|^2 = m^2 + O(a (|k|^3 + m^3)).
```

Only after that should one form `P_a(k) = epsilon_a(k) I + q_a(k) . sigma` and
prove `det P_a(k) = m^2` up to the stated error.

## Cross-conjecture dependencies

These four conjectures should be tested in a deliberate order.

1. The observer-channel mass and null-step dynamics conjectures should now be
   developed together through the proper-time/purity rate target. That is the
   cheapest way to turn the static determinant identity into a dynamical claim.
2. The finite super-Dirac conjecture should be gated by the one-diamond `D^2`
   computation before broad operator formalization continues.
3. The P9 source-visibility/noise conjecture should continue, but only under
   the strict rule that zero mean is not enough. It needs source response,
   noise-kernel control, and an amplitude/correlation comparison with
   everpresent Lambda and stochastic gravity.
4. The generation/dynamics interface should wait until doubler, chirality, and
   internal-family multiplicities are proven disjoint or explicitly identified.

The best sign that the program is becoming real physics is not that all four
conjectures become true. It is that each conjecture becomes sharp enough that a
negative result would actually teach us what to abandon.

## Two further conjectures from the 2026-06-27 lateral read

These extend the list above. Each has a finite theorem spine close to the
trusted P1 core, a literature collision, and a clear failure mode.

5. **Pluecker hierarchy conjecture.** The current mass identity is the `k = 2`
   member of a Cauchy-Binet ladder `e_k(Psi Psi^dagger) = sum_{|S|=k}
   |wedge_{i in S} psi_i|^2`. For Weyl two-spinors only `k <= 2` survives, but in
   enlarged spaces (twistor, internal/branch, form-degree) the higher exterior
   powers should classify how many independent beams/branches/internal modes a
   bundle carries: the `k`-th obstruction is the failure to reduce to fewer than
   `k` canonical modes.
   - Spine: define `e_k` on `Psi Psi^dagger` and prove the elementary-symmetric /
     squared-minor identity finitely (`k = 2` is already trusted).
   - Collision: collider energy-correlator hierarchies (Larkoski-Salam-Thaler
     energy-correlation functions and higher-point energy correlators) are built
     from energies and pairwise angles; the `k = 2` Pluecker obstruction may be
     the two-point member of a null-edge event-shape ladder. See the bibliography
     energy-correlator additions.
   - Failure mode: if no enlarged space gives `k > 2` a clean physical reading,
     the ladder is a curiosity and the program stays at `k = 2`.

6. **Obstruction-stiffness unification conjecture.** Every mass mechanism in the
   program's dictionary is the quadratic normal stiffness of a canonical zero
   locus: a pair `(M, s)` of a moduli/orbit/stabilizer locus `M` and a section
   or Hessian, with `m^2 ~ |s|^2` or `Hessian_perp`. Massless modes are tangent
   to `M`; massive modes are normal directions with nonzero squared section norm
   or radial Hessian.

   | Sector       | Zero locus                    | Obstruction                |
   | ------------ | ----------------------------- | -------------------------- |
   | Null bundle  | rank-one projective beam locus| Pluecker section           |
   | Yukawa       | kernel / chiral split locus   | mass map `M : E_R -> E_L`  |
   | Electroweak  | Higgs stabilizer orbit        | `X |-> X H_0`              |
   | Higgs scalar | vacuum manifold               | radial Hessian             |
   | Gate C       | physical branch line          | failure of chiral line selection |

   - Spine: make "canonical obstruction datum" (already in `docs/CONVENTIONS.md`)
     the Morse-Bott pair `(M, s)` and check each row reduces to it.
   - Failure mode: if the rows do not share one normal-stiffness schema, the
     dictionary stays a list of analogies, not one geometry.

The strongest meta-claim attached to conjecture 6 (the program may be a general
theory of when a one-beam/one-orbit description fails) belongs in
`Sources/Null_Edge_Interaction_Ontology.md`, not here, until conjecture 6 has a
finite spine.
