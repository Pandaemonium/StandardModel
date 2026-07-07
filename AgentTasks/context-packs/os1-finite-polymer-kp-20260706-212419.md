# Aristotle semantic context pack

Generated: 2026-07-06T21:24:48
Query: `finite group character expansion polymer KP one plaquette Z2 tanh beta explicit strong coupling threshold volume uniform finite gauge mass gap`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [The queue]

Score: `0.829`

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

### 2. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [4. Track A: the gate ladder]

Score: `0.769`

```text
ructural fact in constructive
QFT and has never been formalized by anyone. Deliverable: "formalized
reflection positivity for lattice Yang-Mills" - flagship-grade, of interest
to constructive QFT, probability, AND the lattice community (Round 8's
adversary-acquisition strategy: this is the paper that buys the program its
lattice-community referees). Kill: none (known mathematics).

**YM4 (strong-coupling confinement and mass gap; 6-18 months; second
flagship).** Formalize a convergent polymer/cluster expansion (the
Kotecky-Preiss criterion - clean inductive combinatorics, verified absent
from Mathlib, and REUSABLE for the Measure Problem's quantum-growth
estimates) and with it, for `beta < beta_0` (strong coupling), UNIFORMLY in
volume: the Wilson-loop area law, exponential clustering, and a transfer-
matrix mass gap - the Osterwalder-Seiler regime, kernel-checked, in 3D and
4D. **KEY REFERENCES (in the Neo4j graph as of 2026-07-06):** the modern
treatment of the KP criterion is Fernandez-Procacci `math-ph/0605041`
(tree-graph bound via the Penrose identity - this IS the shape of the Q6 crux
`pairSum_le_expBound`); the INDUCTIVE proof `2001.00652` may sidestep the
labeled-tree injection the Q6 crux is currently stuck on (see
`AgentTasks/overnight-mass-run-2026-07-06/CRUX_PARKED_STATUS.md`); Scott-Sokal
`cond-mat/0309352` for the tree-bound / independent-set-polynomial view. For
the end-to-end audit roadmap, `2606.19362` (2026; mined in
`AgentTasks/paper-units/faizal-shabir-2606-19362-mining.md`) is the closest
recent reflection-positive blueprint: Wilson lattice RP -> positive transfer
operator -> strong-coupling character/polymer expansion -> temporal clustering
and finite-a gap -> gauge-covariant FRD/locality -> interlacing with summable
defects -> OS reconstruction/u
```

### 3. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [4. Track A: the gate ladder]

Score: `0.763`

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

### 4. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [The queue]

Score: `0.762`

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

### 5. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [Dynamics, Yang-Mills, and the mass gap: the confinement program ladder]

Score: `0.761`

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
  standard axiom footprint): `GateYM/IndependentPlaquetteEnsemble.lean`
  proves Lemma 2b (ordered plaquette-tuple sums ARE the iterated fusion
  convolution; out-of-region plaquettes integrate out) and the headline
  `wilson_loop_expectation_area_law`:
  `<W_R> = chi_R(1) * wilsonNormalizedGamma^area` EXACTLY in the
  independent-plaquette ensemble, with norm/exponential-decay forms.
  `GateYM/TreeGaugeBrid
```

### 6. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [14. Live formalization work queue (frozen 2026-07-04; for agents and Aristotle)]

Score: `0.760`

```text
n the skeleton where applicable - see
`AgentTasks/ym1-treegauge-rect-aristotle-2026-07-04.md` for the pattern
that produced a 16-minute general-case success); task note with the yaml
metadata block per `docs/ARISTOTLE.md`.

**Status snapshot (2026-07-04).** Kernel-checked and integrated, standard
axiom footprint: Lemma 2a fusion (Aristotle `3435c7a3`), Lemma 2b +
independent-plaquette area law (`IndependentPlaquetteEnsemble`), generic
tree-gauge bridge (`TreeGaugeBridge`), concrete 2D comb-gauge
coordinatization + concrete-lattice area law (Aristotle `1d9b5b19`,
`RectTreeGauge`), fusion transfer spectrum + string tension
(`FusionTransferSpectrum`), conditional vacuum dominance
(`WilsonVacuumDominance`), real/complex ensemble connector
(`EnsembleComplexBridge`), and RP-KER - the master finite
reflection-positivity kernel theorem (`ReflectionPositivityKernel`:
per-cut PSD kernels imply OS positivity; factorized and mixture weight
classes closed end-to-end). Active Aristotle: `d4a9bd1f`
(unitarizability, item Q4).

**The attack graph** (adopted 2026-07-04 from a second external model
review, screened against repo state; its "Job 1" and "Job 6" were already
done/submitted at adoption time):

```text
RP-KER (DONE)
  -> Q1 Wilson cut factorization -> Q2 transfer Hilbert space
  -> Q3 D12 sector-correct transfer matrix
  -> Q4 unitarizability (OUT: d4a9bd1f) -> Q5 eigenvalue ordering
  -> Q6 KP abstract polymer conclusion -> Q7 strong-coupling polymer map
  -> Q8 exponential clustering -> Q9 finite strong-coupling gap (YM4)
  -> Q10 infinite-volume state by cluster series
  -> (later) Peter-Weyl / compact extension; Balaban compression; YM6.
```
```

### 7. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [4. Track A: the gate ladder]

Score: `0.759`

```text
ive transfer
operator -> strong-coupling character/polymer expansion -> temporal clustering
and finite-a gap -> gauge-covariant FRD/locality -> interlacing with summable
defects -> OS reconstruction/universality, with a claimed weak-coupling
identification. Use it as a theorem-dependency map and audit checklist, not as
settled prior art. Immediate imports for YM4 are the finite strong-coupling
base, exponential-clustering-to-gap, and abstract summable-defect transport;
the gauge-covariant FRD and weak-coupling entry claims belong to YM5/YM6 audit
territory. Deliverable: **formalized confinement and mass gap at strong coupling**
- the strongest statement anyone could certify today about 4D lattice YM,
and the ladder's central medium-horizon prize-adjacent milestone. Honest
scope guard: strong coupling is the WRONG side of the continuum limit
(continuum requires `beta -> infinity`); this rung certifies known physics
in a known regime and claims nothing more. Kill: none (known mathematics);
pace applies.

**YM5 (RG scaffolding + the Balaban audit; years, open-ended;
the novel contribution).** Two sub-efforts: (a) formalize block-spin/RG
maps for lattice gauge fields and small clean lemmas of the RG toolkit;
(b) THE AUDIT: begin machine-verification of the Balaban UV-stability chain
for 4D lattice YM (or of the modern re-derivations of parts of it - debt
register), explicitly framed as an audit that succeeds by EITHER confirming
OR locating gaps. No completion promise; value accrues per verified paper.
Deliverable: rolling audit reports; any confirmed-or-refuted milestone in
that chain is a significant publication. Kill/exit: if after a pilot audit
of one paper the effort-per-page is prohibitive (F-YM-PACE at this rung),
downgrade to (a)-only and file the audit as infeasibl
```

### 8. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [The queue]

Score: `0.757`

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

## Scoped paper hits

### 1. Free energy and quark potential in Ising lattice gauge theory via cluster expansion

Score: `0.755`
Zotero key: `P8TPZEHK`
arXiv: `2304.08286`
URL: http://arxiv.org/abs/2304.08286

Abstract:

We revisit the cluster expansion for Ising lattice gauge theory on $\mathbb{Z}^m, \, m \ge 3,$ with Wilson action, at a fixed inverse temperature \( β\) in the low-temperature regime. We prove existence and analyticity of the infinite volume limit of the free energy and compute the first few terms in its expansion in powers of $e^{-β}$. We further analyze Wilson loop expectations and derive an estimate that shows how the lattice scale geometry of a loop is reflected in the large $β$ asymptotic expansion. Specializing to axis parallel rectangular loops $γ_{T,R}$ with side-lengths $T$ and $R$, we consider the limiting function $$ V_β(R) := \lim_{T \to \infty} - \frac{1}{T} \log \, \langle W_{γ_{T,R}} \rangle_β, $$ known as the static quark potential in the physics literature. We verify existence of the limit (with an estimate on the convergence rate) and compute the first few terms in the expansion in powers of $e^{-β}$. As a consequence, a strong version of the perimeter law follows. We also treat $- \log \, \langle W_{γ_{T,R}} \rangle_β/ (T+R)$ as $T, R$ tend to infinity simultaneously and give analogous estimates.

### 2. An invitation to higher gauge theory

Score: `0.740`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9

### 3. Generalizing the Tomboulis-Yaffe Inequality to SU(N) Lattice Gauge Theories and General Classical Spin Systems

Score: `0.740`
Zotero key: `K9FIBTZC`
arXiv: `0808.3442`
DOI: `10.1016/j.aop.2009.04.002`
URL: http://arxiv.org/abs/0808.3442

Abstract:

We extend the inequality of Tomboulis and Yaffe in SU(2) lattice gauge theory (LGT) to SU(N) LGT and to general classical spin systems, by use of reflection positivity. Basically the inequalities guarantee that a system in a box that is sufficiently insensitive to boundary conditions has a non-zero mass gap. We explicitly illustrate the theorem in some solvable models. Strong coupling expansion is then utilized to discuss some aspects of the theorem. Finally a conjecture for exact expression to the off-axis mass gap of the triangular Ising model is presented. The validity of the conjecture is tested in multiple ways.

### 4. Wilson loops in Ising lattice gauge theory

Score: `0.740`
Zotero key: `T2Z3STSB`
arXiv: `1811.09770`
URL: http://arxiv.org/abs/1811.09770

Abstract:

Wilson loop expectation in 4D $\mathbb{Z}_2$ lattice gauge theory is computed to leading order in the weak coupling regime. This is the first example of a rigorous theoretical calculation of Wilson loop expectation in the weak coupling regime of a 4D lattice gauge theory. All prior results are either inequalities or strong coupling expansions.

### 5. Laplacian renormalization group: an introduction to heterogeneous coarse-graining

Score: `0.738`
Zotero key: `AN5RZGJZ`
DOI: `10.1088/1742-5468/ad57b1`
URL: https://doi.org/10.1088/1742-5468/ad57b1
