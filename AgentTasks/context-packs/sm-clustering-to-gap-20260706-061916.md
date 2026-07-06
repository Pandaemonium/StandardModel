# Aristotle semantic context pack

Generated: 2026-07-06T06:19:33
Query: `finite transfer operator exponential clustering spectral radius gap OS reconstruction GateYM SlabTransferGap`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [The queue]

Score: `0.790`

```text
stance >= R  <= C_X exp(-m R)`.
  Statement freeze on top of `PolymerKPCriterion.lean` (which froze the
  CONDITION only). This is the single most reusable analysis asset in the
  program (Measure Problem shares it). The mined `2606.19362` source confirms
  this exact role: its strong-coupling base passes through small activities ->
  KP -> tree-graph/Ursell expansion -> distance-bridging clusters ->
  exponential clustering.
- **Q7 (strong-coupling polymer map; medium-hard; after Q6 freeze).** Map
  the finite-group character/plaquette expansion into the abstract polymer
  model and verify the KP condition for `beta < beta_0`, with
  volume-uniform constants. Kill condition (adopted): if the KP constants
  are not volume-uniform, YM4 does not give an infinite-volume gap -
  report, do not weaken.
- **Q8 (exponential clustering of local loop observables; after Q6+Q7).**
  Connected correlators of local gauge-invariant plaquette/loop operators
  decay exponentially at strong coupling. Observable-level FIRST (adopted
  sequencing); the spectral upgrade is Q9.
- **Q9 (YM4 finite strong-coupling gap; after Q1-Q3, Q8).** Combine the
  transfer Hilbert space, sector decomposition, and clustering into a
  finite-volume (target: volume-uniform) spectral gap in the
  trivial-flux/local sector. The cyclicity/density of the local algebra in
  the vacuum sector is a NAMED prerequisite lemma, not a footnote -
  another place a fake gap could slip in. Extract from `2606.19362` only the
  finite/abstract mechanism: temporal exponential clustering plus the transfer
  spectral representation bounds the non-vacuum spectral radius. Do not import
  any continuum or weak-coupling conclusion here.
- **Q10 (infinite-volume local state via cluster series; after Q6-Q8).**
  Adopted route: defin
```

### 2. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [77. Gamma5 transfer and abstract block-diagonal operator gap]

Score: `0.783`

```text
## 77. Gamma5 transfer and abstract block-diagonal operator gap

Date: 2026-06-28

Status: proof-lane update after Pro guidance on the route from symbol gap to
operator gap.

The `K` symbol gap has now been transferred to the Hermitian sign-kernel symbol
and the generic Fourier/Parseval bridge has been isolated:

- `H gamma5 D a r rho k = gamma5 * K D a r rho k`.
- `H_l2NormSq_eq_K_l2NormSq` proves that if
  `gamma5^* gamma5 = 1`, then finite L2 norm squared is preserved by left
  multiplication with `gamma5`.
- `H_symbol_l2NormSq_gap` transfers the checked scalar Wilson/free-symbol
  finite-L2 gap from `K` to `H = gamma5 K`.
- `FiniteBlockDiagonalGap.lean` introduces a thin
  `UnitaryBlockDiagonalization` interface with:
  `fieldL2NormSq`, a Fourier/block transform `F`, a free operator `Hfree`,
  block symbols `Hsym`, Parseval, and the block-diagonalization law.
- `operator_gap_of_unitary_block_diagonalization` proves that a pointwise
  finite-L2 symbol gap implies the corresponding free-operator finite-L2 gap.
- `operator_gap_exists_of_unitary_block_diagonalization` packages the same fact
  with an existential positive gap constant.

This completes the abstract proof lane from:

```text
tetrahedral Q square
  -> scalar Wilson coefficient gap
  -> K symbol finite-L2 gap
  -> H symbol finite-L2 gap
  -> abstract block-diagonal free-operator gap
```

The next concrete Lean target is no longer a hard inequality. It is the
construction of the finite rank-4 cyclic translation torus and its Fourier
diagonalization data:

```text
Site = ZMod N0 x ZMod N1 x ZMod N2 x ZMod N3
shift T_A increments the A-th coordinate
F is the finite Fourier transform
Hfree diagonalizes to Hsym(k)
```

Once that concrete diagonalization witness is provided, the existing abstract
operator-gap theo
```

### 3. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [The queue]

Score: `0.775`

```text
um).**
  Adopted target, superseding any naive Gauss-sector gap statement (the
  oracle's 2x2-torus discovery stands): define the flux-sector
  decomposition of the Gauss-invariant space, prove the transfer operator
  PRESERVES it, and prove the local plaquette algebra preserves the
  trivial-flux sector. Two named spectral quantities: flux gap vs
  glueball/local gap. `TransferGapDefinition.finiteMassGap` refers to the
  LOCAL gap only. Kill condition (adopted): if the lowest excitation is
  always a global flux sector, the finiteMassGap theorem target must be
  renamed and redefined - no silent substitution.
- **Q4 (finite-group unitarizability; OUT at Aristotle `d4a9bd1f`).**
  Every `FDRep C G` (finite `G`) has a unitary matrix model. Harvest
  checklist in `AgentTasks/ym-gap-unitarizability-aristotle-2026-07-04.md`;
  on integration, strip the matrix-model hypothesis from
  `WilsonVacuumDominance`.
- **Q5 (eigenvalue reality and ordering; medium; after Q4).** The Wilson
  fusion eigenvalues (`FusionTransferSpectrum`) are real for
  inversion-symmetric real weights (proof sketch: `chi(g^-1) =
  conj(chi(g))` from the unitary matrix model of Q4, then the `g -> g^-1`
  reindexing); combined with `|gamma| <= 1` this orders the spectrum below
  the vacuum eigenvalue and feeds the D12 gap definition.
- **Q6 (KP conclusion as an abstract polymer theorem; hard; Aristotle
  strategy job first).** Adopted scoping: do NOT start with full Ursell
  generality. Finite polymer set, finite cluster expansion, tree-graph
  bound, and the tail estimate
  `sum over clusters touching X, distance >= R  <= C_X exp(-m R)`.
  Statement freeze on top of `PolymerKPCriterion.lean` (which froze the
  CONDITION only). This is the single most reusable analysis asset in the
  program (Measure Pro
```

### 4. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [77. Gamma5 transfer and abstract block-diagonal operator gap]

Score: `0.773`

```text
T_A increments the A-th coordinate
F is the finite Fourier transform
Hfree diagonalizes to Hsym(k)
```

Once that concrete diagonalization witness is provided, the existing abstract
operator-gap theorem should produce the free Gate C1 sign-kernel gap.
```

### 5. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [71. Pro update: next decisive target is TetraFreeOperatorGap]

Score: `0.760`

```text
## 71. Pro update: next decisive target is TetraFreeOperatorGap

Date: 2026-06-28
Source:

```text
C:\Users\Owner\.codex\attachments\bd6f4d6f-96fc-4ef5-bef2-e76b9eaf9d0f\pasted-text.txt
```

Decision:

```text
Do not spend the next mainline cycle on D4, stay-move, E8, path-sum
interpretation, or more abstract API polish.

The active Gate C1 proof target is:

  TetraFreeOperatorGap

meaning:

  the checked tetrahedral scalar gap proxy must be lifted to an actual
  finite/free operator gap.
```

Immediate ranking:

```text
1. Direct tetrahedral finite/free operator gap.
2. Reference-import / gapped-homotopy certificate.
3. D4, stay-move, and path-sum lanes as side lanes only.
```

The short mainline is now:

```text
checked scalar gap expression
  -> symbol matrix gap
  -> finite/free operator gap
  -> overlap no-mirror theorem
  -> KappaCertificate / gapped homotopy
  -> gauge/anomaly/locality contracts
```

The first serious operator is:

```text
H_tet(k) =
  gamma5 [
    (i/a) sum_A B_A sin(k_A)
    + (1/a)(r sum_A(1 - cos(k_A)) - rho)
  ].
```

Use:

```text
Q(k) = sum_A B_A sin(k_A),
R(k) = sum_A (1 - cos(k_A)),
M(k) = r R(k) - rho.
```

The required bridge is:

```text
H_tet(k)^2 >= (c^2/a^2) I
```

or, at the first Lean stage:

```text
||H_tet(k) psi||^2
  >= [freeGapScalar_tet(k) / a^2] ||psi||^2.
```

Then prove a finite Fourier bridge:

```text
symbol gap on every k
  -> translation-invariant finite/free operator gap.
```

New Lean file started:

```text
PhysicsSM/Draft/NullEdge/GateC1/TetraFreeOperatorGap.lean
```

Current role of that file:

```text
1. Define the active branch-window predicate FundamentalTetraBZ.
2. Define the scalar square-gap coefficient tetraFreeGapSq.
3. Prove tetraFreeGapSq_pos from the checked C243 scalar gap theorem.
4. Define the symbo
```

### 6. `AgentTasks/hamming-e8-final-strengthening-2026-05-07.md` [L1: explicit SPL linear bridge / isometry]

Score: `0.759`

```text
inearEquiv` or isometry-shaped theorem
between the `Z`-span of the Construction A basis and the imported SPL row span.

Acceptable fallback endpoints, in order:

1. A checked matrix theorem giving the explicit composite transition matrix
   from the Construction A scaled Gram matrix to the imported SPL Gram matrix.
2. A checked theorem that each of the eight Construction A basis vectors maps
   to an element of `Submodule.E8 R` under the intended composite.
3. A checked theorem that the composite transition matrix is unimodular and has
   the correct Gram-congruence identity.
4. A precise draft theorem statement with all blockers documented, but only if
   the proof is genuinely blocked by missing API.

Constraints:

- Keep all SPL-dependent code in `PhysicsSM/Draft`.
- Do not claim full density transfer to the Construction A packing unless the
  map/equivalence and scaling statement are actually proved.
- Prefer explicit finite matrix identities over abstract classification of E8.
- Use existing matrices:
  `e8BasisChangeMatrix`, `splToCartanTransition`, `e8ScaledGramQ`,
  `splE8GramQ`, and theorem `spl_gram_congruent_to_scaled_constructionA`.

Minimum useful result:

- A handoff-free theorem that materially narrows the remaining linear bridge gap
  and can be cited in the manuscript.
```

### 7. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [Dynamics, Yang-Mills, and the mass gap: the confinement program ladder]

Score: `0.755`

```text
line
  `wilson_loop_expectation_area_law`:
  `<W_R> = chi_R(1) * wilsonNormalizedGamma^area` EXACTLY in the
  independent-plaquette ensemble, with norm/exponential-decay forms.
  `GateYM/TreeGaugeBridge.lean` proves the generic tree-gauge bridge: any
  `PlaquetteCoordinatization` (link fields ~ plaquette holonomies x tree
  residuals) collapses the LINK ensemble to that plaquette ensemble. The
  comb-gauge coordinatization of the CONCRETE 2D open rectangle was proved
  by Aristotle `1d9b5b19` (general `Lx x Ly` case, ~16 min; task note
  `AgentTasks/ym1-treegauge-rect-aristotle-2026-07-04.md`) and is integrated
  as `GateYM/RectTreeGauge.lean`, whose
  `rect_wilson_loop_expectation_area_law` puts the area law on a concrete
  lattice. The single remaining distance to the freeze Theorem 2 statement
  is the boundary-circuit lasso identification of the observable (next
  focused Aristotle job).
- **The YM mass-gap lane opened** (same session):
  `GateYM/FusionTransferSpectrum.lean` upgrades Lemma 2a to genuine
  `Module.End` spectral statements (vacuum eigenvector = constant function
  with eigenvalue the one-plaquette sum; simple-`FDRep` characters are
  eigenvectors of the fusion transfer operator), plus the string-tension
  form `|<W_R>| = |chi_R(1)| exp(-sigma * area)`;
  `GateYM/WilsonVacuumDominance.lean` proves `|gamma| <= 1` and
  `sigma >= 0` (vacuum dominance) under an explicit unitary matrix-model
  hypothesis - discharging it is finite-group unitarizability (Weyl
  averaging), the next gap-lane Aristotle target. NOT yet claimed: any
  identification with the D12 `finiteMassGap` (needs eigenvalue
  reality/ordering).

Where it sits: sibling to `Sources/Null_Edge_Measure_Problem.md` (the
program's central open problem) and `Sources/Null_Edge_Dynamics_Gate_D.md`
(
```

### 8. `Sources/NERD_2.md` [13. The theorem ladder, updated]

Score: `0.755`

```text
## 13. The theorem ladder, updated

**Gate C1 — unchanged, still the spine.** Finish `TetraFreeOperatorGap_equalN`: phase-to-trig adapters → full Fourier diagonalization of $H_{\rm free}$ → unitary block-diagonal gap instantiation → finite/free operator gap → self-adjointness → only then the sign/GW/release layer. Nothing in v2 touches this. Do not let the new framing pull effort off C1.

**Gate I1 — mass/concurrence (new; finite linear algebra; Lean-ready).** Soldering determinant; PSD rank-one factorization; Cauchy–Binet mass identity ≡ cross-term expansion; little-group stabilizer theorem; purification/marginal theorem with $\det P$ vs $\det\rho$ frame analysis; $(\gamma\cdot P)^2 = \det(P)\mathbb 1$ and the on-shell bridge. Estimated cost: low. Estimated value: the theory's central identity, certified.

**Gate I2 — modular clocks (new; finite-dimensional).** Constructive finite Tomita theory; boost-modular toy theorem for Gaussian node states; the three-J separation theorem. Controls F-M1.

**Gate Λ1 — cosmological constant (new; mostly finite linear algebra).** Discrete Hodge decomposition of the bookkeeping cochain; harmonic-identification and Betti-dimension theorem; Poisson fluctuation scaling (paper-level).

**Gate C2 — gauge backgrounds.** As v1, with one addition: (7) $J_K$-covariance audit of every statement (§8.1) and the two-grading discipline (§8.2).

**Gate C3 — path sums.** As v1 (rational/Chebyshev/domain-wall expansions; node-time phases; retarded/Hilbert dilation; Krein/positivity audit), plus: (6) the on-shell-diagram correspondence of §1.4 made precise on the scaffold — node coins vs. three-point amplitude data.

**Gate G1′ — emergent geometry and gravity (restructured).**
1. Sufficient-statistic theorem: transport correlations on slowly varying ba
```

## Scoped paper hits

### 1. Reflection-Positive Construction of a Four-Dimensional SU(N) Yang-Mills Theory with Mass Gap and Confinement

Score: `0.732`
Zotero key: `2606.19362`
arXiv: `2606.19362`
DOI: `10.1002/prop.70097`
URL: http://arxiv.org/abs/2606.19362

Abstract:

In the Euclidean view one must first require that positivity not be violated, and from this modest demand, together with locality, a great deal follows: starting from a reflection-positive lattice formulation of pure SU(N) Yang-Mills theory we obtain a transfer operator with a uniform gap, while large Wilson loops already show an area law by means of convergent character (polymer) expansions; a finite-range, gauge-covariant multiscale analysis then carries these features from one scale to the next with interlaced inequalities whose small defects can be summed, so that exponential clustering and a strictly positive string tension endure in the continuum; the Osterwalder-Schrader reconstruction turns these Euclidean facts into a Minkowski theory with a self-adjoint Hamiltonian, the spectral gap lying above the vacuum and the linear potential for static charges appearing, which gives a concrete picture of confinement; the construction depends on no special regulator, for a single-scale Lipschitz control and a telescoping argument bind all admissible reflection-positive slicings into a unique limiting measure and thus secure universality; moreover, the same framework admits entry from weak coupling, so that the continuum reached from strong coupling meets the one approached along an asymptotically free trajectory, yielding one and the same theory; in my view this is how mathematical clarity and physical insight cooperate: positivity, locality, and renormalization working together so that the mass gap and confinement are not marvels to be assumed, but natural properties of the non-Abelian vacuum.

### 2. Normalized Laplacians for gain graphs

Score: `0.725`
Zotero key: `S78BASEN`
DOI: `10.63151/amjc.v1i.3`
URL: https://doi.org/10.63151/amjc.v1i.3

### 3. Frustration index and Cheeger inequalities for discrete and continuous magnetic Laplacians

Score: `0.714`
Zotero key: `FNP9V3DT`
DOI: `10.1007/s00526-015-0935-x`
URL: https://doi.org/10.1007/s00526-015-0935-x

### 4. Matching number, Hamiltonian graphs and magnetic Laplacian matrices

Score: `0.713`
Zotero key: `GNEARI9Q`
arXiv: `2010.08828`
DOI: `10.1016/j.laa.2022.02.006`
URL: https://doi.org/10.1016/j.laa.2022.02.006

### 5. An analysis of completely-positive trace-preserving maps on M2

Score: `0.703`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`
