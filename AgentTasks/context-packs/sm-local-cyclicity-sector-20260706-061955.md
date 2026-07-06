# Aristotle semantic context pack

Generated: 2026-07-06T06:20:04
Query: `finite slab local algebra cyclicity vacuum orthogonal sector local gap GateYM SlabTransferGap sector spanning`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [The queue]

Score: `0.804`

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

### 2. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [25. Integrated Aristotle update: finite native mechanism now has a viable core]

Score: `0.776`

```text
y. This is the right interface for importing standard overlap/domain-wall physics. Its one analytic handoff is the continuity estimate for the sign matrix under a uniform gap, which remains theorem-design rather than fully trusted Lean.

Updated interpretation: Gate C1 is no longer blocked at the level of finite algebraic existence. The finite seed exists, the gauge-safe odd channel exists under a clear assumption, and the bad-sector gap audit has a clean finite theorem. The remaining work is to lift this from a finite algebraic witness to a physically honest regulator: prove or import uniform gap/homotopy, locality/path-sum control, anomaly/index behavior, and Standard Model representation compatibility.

Trust note: the C141 lifted finite witness uses draft-trust computational reduction (`Lean.ofReduceBool` / `Lean.trustCompiler`) in its Aristotle artifact. Treat it as a successful finite computational witness, not as trusted repo Lean, until the finite checks are replaced by kernel-only proofs.
```

### 3. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [Dynamics, Yang-Mills, and the mass gap: the confinement program ladder]

Score: `0.775`

```text
pinning
  conventions C-1..C-8 for the YM0-YM3 freezes.
- **YM1-YM4 + QCD1 statements are FROZEN** with complete finite-level
  proofs for Elitzur (quantitative, volume-uniform), the 2D exact solutions
  (incl. nonabelian S3, oracle-pinned to 1e-10), and the character-
  positivity engine behind reflection positivity. Two strategic findings:
  (i) the finite-G YM3 flagship is now finite mathematics END TO END (the
  RP engine is the same Gram move as `GateMP.SCGGramPositivity` - the
  shared-toolbox claim of section 0 is a lemma-level identity); (ii) the
  finite-lattice mass-gap definition D12 needs 't Hooft-flux quantum
  numbers (oracle-discovered on the 2x2 torus, where the naive Gauss-sector
  gap is a winding flux line, not a glueball).
- **PKG-YM1-A submitted** (Aristotle f501f8c8, the ladder's one active job
  per the budget rule) **and harvested**; **PKG-YM1-lattice is now CLOSED
  too** (2026-07-04, in-repo assembly, no Aristotle job needed):
  `GateYM/ElitzurLattice.lean` instantiates the abstract pairing bound at
  the one-site Z2 gauge flip, recovering the full quantitative,
  volume-uniform Elitzur theorem end to end (freeze document section 14).
  PKG-YM3-A is next, pending a Mathlib character-theory API session.
- **YM1 Theorem 2 is now a true expectation-value area law modulo one
  geometric layer** (2026-07-04 day session, all kernel-checked draft,
  standard assumption footprint): `GateYM/IndependentPlaquetteEnsemble.lean`
  proves Lemma 2b (ordered plaquette-tuple sums ARE the iterated fusion
  convolution; out-of-region plaquettes integrate out) and the headline
  `wilson_loop_expectation_area_law`:
  `<W_R> = chi_R(1) * wilsonNormalizedGamma^area` EXACTLY in the
  independent-plaquette ensemble, with norm/exponential-decay forms.
  `GateYM/TreeGaugeBrid
```

### 4. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [The queue]

Score: `0.774`

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

### 5. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [4. Track A: the gate ladder]

Score: `0.774`

```text
e groups (Z2 first): Elitzur's theorem (local gauge symmetry
cannot break spontaneously - clean, finite, the right first nontrivial
theorem); the exact 2D solution by character expansion (finite abelian
case); Wegner's Z2 dualities (2D gauge <-> 1D Ising-type; 3D gauge <-> 3D
Ising). Everything here is finite combinatorics + finite character theory,
squarely in the program's demonstrated wheelhouse. Deliverable: "the first
formalized lattice gauge theory theorems" - a genuine publication, with the
QEC community as a second audience (Z2 LGT = toric code). Kill: none
(known mathematics); only F-YM-PACE applies.

**YM2 (2D Yang-Mills exact confinement; months).** The exact 2D area law:
`<W(C)> = f(area)` from the character/heat-kernel expansion. Do `U(1)`
first (circle Fourier analysis exists in Mathlib), finite groups already
covered by YM1. For compact NONABELIAN `G`: gated on **YM2-PW: formalize
Peter-Weyl** (verified absent from Mathlib today) - itself a headline
Mathlib contribution independent of physics. Deliverable: formalized exact
confinement in 2D + (via YM2-PW) a major Mathlib theorem. Kill: none;
YM2-PW may be handed to the Mathlib community rather than done in-house.

**YM3 (transfer matrix + reflection positivity; 3-9 months; first
flagship).** Formalize: the lattice transfer matrix; Osterwalder-Seiler
reflection positivity of the Wilson action; positivity of the transfer
operator; the reconstructed Hilbert space and Hamiltonian; the DEFINITION of
the finite-lattice mass gap as the transfer spectral ratio. Reflection
positivity is the single most load-bearing structural fact in constructive
QFT and has never been formalized by anyone. Deliverable: "formalized
reflection positivity for lattice Yang-Mills" - flagship-grade, of interest
to constructive QFT, pro
```

### 6. `Sources/NullStrand_Lean_Roadmap_Improved.md` [Gate G3 — selected finite dynamics and finite QFT interfaces]

Score: `0.773`

```text
### Gate G3 — selected finite dynamics and finite QFT interfaces

Adds:

- minimum-energy angular current;
- finite refresh-chain mixing diagnostics;
- finite Fock-sector Bell forward equation;
- flatness/path-independence theorem on a finite cut complex;
- reviewed super-Dirac block algebra.
```

### 7. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [Dynamics, Yang-Mills, and the mass gap: the confinement program ladder]

Score: `0.773`

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

### 8. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [The queue]

Score: `0.772`

```text
n bounds the non-vacuum spectral radius. Do not import
  any continuum or weak-coupling conclusion here.
- **Q10 (infinite-volume local state via cluster series; after Q6-Q8).**
  Adopted route: define infinite-volume expectations of local observables
  DIRECTLY by the absolutely convergent cluster series and prove
  finite-volume expectations converge to them. Deliberately bypasses
  general Gibbs-state/weak-* infrastructure at first pass.
- **Q11 (boundary-circuit lasso identification; medium; independent of
  Q1-Q10).** The last YM1 Theorem 2 layer: on `RectTreeGauge`'s lattice,
  `chi(hol of the rectangle boundary) = chi(orderedProd of ALL plaquette
  holonomies)` in the ensemble, with the ordering already derived
  (row-major, `i` REVERSED within each row; at tree-links = 1 the per-row
  products telescope to the right column, and the general case reduces to
  the tree-gauge slice by a rooted gauge transformation whose plaquette
  coordinates are componentwise conjugates - class function kills them).
  Statement freeze + focused Aristotle package; the naive pointwise
  identity at general tree values is expected FALSE - do not attempt it.
- **Q12 (Peter-Weyl / compact extension; LATER, do not block).** Adopted
  posture: finite groups first, then `U(1)`, then hand-built `SU(2)` if
  needed, then general Peter-Weyl as its own Mathlib-facing project. Kill
  condition (adopted, advertising rule): until then, all results are
  advertised as finite-group lattice gauge theorems, never as compact
  Yang-Mills.

**Deferred (registered, not queued):** Balaban by "dependency
compression" (dependency graph -> smallest representative kernel estimate
-> source contract -> red-team one implication; fits the existing YM5
audit posture); YMG1-UNIV/YMG2-RG universality bridges (Tie
```

## Scoped paper hits

### 1. Reflection-Positive Construction of a Four-Dimensional SU(N) Yang-Mills Theory with Mass Gap and Confinement

Score: `0.738`
Zotero key: `2606.19362`
arXiv: `2606.19362`
DOI: `10.1002/prop.70097`
URL: http://arxiv.org/abs/2606.19362

Abstract:

In the Euclidean view one must first require that positivity not be violated, and from this modest demand, together with locality, a great deal follows: starting from a reflection-positive lattice formulation of pure SU(N) Yang-Mills theory we obtain a transfer operator with a uniform gap, while large Wilson loops already show an area law by means of convergent character (polymer) expansions; a finite-range, gauge-covariant multiscale analysis then carries these features from one scale to the next with interlaced inequalities whose small defects can be summed, so that exponential clustering and a strictly positive string tension endure in the continuum; the Osterwalder-Schrader reconstruction turns these Euclidean facts into a Minkowski theory with a self-adjoint Hamiltonian, the spectral gap lying above the vacuum and the linear potential for static charges appearing, which gives a concrete picture of confinement; the construction depends on no special regulator, for a single-scale Lipschitz control and a telescoping argument bind all admissible reflection-positive slicings into a unique limiting measure and thus secure universality; moreover, the same framework admits entry from weak coupling, so that the continuum reached from strong coupling meets the one approached along an asymptotically free trajectory, yielding one and the same theory; in my view this is how mathematical clarity and physical insight cooperate: positivity, locality, and renormalization working together so that the mass gap and confinement are not marvels to be assumed, but natural properties of the non-Abelian vacuum.

### 2. Extension of the Nielsen-Ninomiya theorem

Score: `0.734`
Zotero key: `arxiv:hep-lat/9803002`
arXiv: `hep-lat/9803002`
DOI: `10.1103/PhysRevD.58.057505`
URL: http://arxiv.org/abs/hep-lat/9803002

Abstract:

Extends the Nielsen-Ninomiya no-go theorem for lattice chiral Dirac fermions using the index theorem, including translation non-invariant and non-local formulations.

### 3. Locality properties of Neuberger's lattice Dirac operator

Score: `0.719`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 4. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.713`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 5. Quantum Many-Body Lattice C-R-T Symmetry: Fractionalization, Anomaly, and Symmetric Mass Generation

Score: `0.713`
Zotero key: `9FFS4GFC`
arXiv: `2412.19691`
URL: http://arxiv.org/abs/2412.19691

Abstract:

Charge conjugation (C), mirror reflection (R), and time reversal (T) symmetries, along with internal symmetries, are essential for massless Majorana and Dirac fermions. These symmetries are sufficient to rule out potential fermion bilinear mass terms, thereby establishing a gapless free fermion fixed point phase, pivotal for symmetric mass generation (SMG) transition. In this work, we systematically study the anomaly of C-R-T-internal symmetry in all spacetime dimensions by analyzing the projective representation (i.e. the fractionalization) of the C-R-T-internal symmetry group in the quantum many-body Hilbert space on the lattice. By discovering the fermion-flavor-number-dependent C-R-T-internal symmetry's anomaly structure, we demonstrate an alternative way to derive the minimal flavor number for SMG, which shows consistency with known results from Kahler-Dirac fermion or cobordism classification. Our findings reveal that, in general spatial dimensions, either 8 copies of staggered Majorana fermions or 4 copies of staggered Dirac fermions support SMG.
