# Aristotle semantic context pack

Generated: 2026-07-20T22:08:40
Query: `finite reflection positivity Hankel kernel spectral transfer energy Kallen Lehmann mass gap`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/aristotle-prompts/ym-q2-transfer-hilbert-block-instantiation-20260704.prompt.md` [Project context]

Score: `0.839`

```text
## Project context

This is Q2 of a four-day Yang-Mills / mass-gap run.  The generic finite
OS/GNS transfer-Hilbert statement layer has just landed in
`TransferHilbert.lean`:

- `reflectionPairing (K : Matrix I I C) (f g : I -> C) : C`
- `rpHilbertSpace K = range (CFC.sqrt K)`
- `KernelCommutesShifts`, `kernelCommutesShifts_iff`
- shift/`CFC.sqrt` commutation and OS range preservation
- OS-form transfer symmetry/positivity
- auxiliary `compressedTransfer` facts

`ReflectionPositivityKernel.lean` supplies the RP kernel API:

```lean
def reflectionForm (W : A -> C -> A -> Complex) (f : A -> C -> Complex) : Complex
def cutKernel (W : A -> C -> A -> Complex) (c : C) : Matrix A A Complex
def IsReflectionPositive (W : A -> C -> A -> Complex) : Prop

theorem cutKernel_posSemidef_of_reflectionPositive [DecidableEq C]
    (W : A -> C -> A -> Complex) (hW : IsReflectionPositive W) (c : C) :
    (cutKernel W c).PosSemidef
```

The next Q2 blocker is to instantiate the generic matrix layer from the
family of cut kernels.  Keep this finite and algebraic.  Do not claim a
physical transfer matrix, Hamiltonian, continuum Hilbert space, or spectral
gap.
```

### 2. `AgentTasks/fourday-ym-run-2026-07-05/GRAND_STRATEGY_AUDIT_ym_codex_89ae2c3b.md` [Top 10 next targets (ranked by expected value / proof effort)]

Score: `0.822`

```text
nsemble.reflectionPositive_of_hol_factorization`.
6. **Feed that lattice into `rpBlockMatrix` for a first physical positive
   transfer operator**, then instantiate `TransferGapDefinition.finiteMassGap`
   on it. This is the first non-toy consumer of the gap API.
7. **`kp_tail_bound`** with the explicit coercivity hypothesis kept external.
   Rides on (2); statement is already honest about the extra geometry layer.
8. **QMF3 Berezin / Matthews–Salam finite identity** (fermionic Gaussian
   integral = determinant on 1–4 modes). Independent of the mountains, fully
   finite/kernel-checkable, oracle-testable first, publishable standalone.
9. **`FermionicReflection` concrete `A` instantiation** for the Wilson boundary
   coupling with the stated reflection-hermiticity hypothesis, routed through
   the existing lifted-projector PSD lemmas. Only after M1 geometry is pinned.
10. **NE-U1 aperture keystone consolidation** (`compositeMassSq_eq_zero_iff_
    collinear` + Plücker bridge as a named, docstring-clean corollary). Cheap,
    it is the honest core of the unification narrative and worth stating
    crisply so the paper has a defensible spine.

---
```

### 3. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [QMF ladder]

Score: `0.806`

```text
o-style Wilson-fermion reflection positivity are
  source targets, subject to the provenance checks in section 11 and the
  LINK-vs-SITE reflection-plane distinction already logged by T12.
- **QMF6 - QCD transfer and quantum-number sectors.** Build the fermionic
  transfer operator on the QMF5 OS/GNS space and define sector projectors
  for flavor, parity, charge conjugation, baryon/meson content, and pure
  gauge center-flux data. This generalizes the Q3 sector machinery.
- **QMF7 - finite-volume hadron mass formalism.** At fixed lattice,
  finite volume, and fixed coupling, define hadron spectral masses as
  sector-restricted spectral gaps/data of the positive self-adjoint
  transfer operator. Meson and baryon interpolating operators live in the
  positive-side algebra. The taxonomy becomes theorem-level structure:
  `quarkMassParameter`, `hadronSpectralMass`, `regulatorMass`, and the
  pure-gauge Yang-Mills local-sector mass gap are distinct named objects,
  and any conversion theorem must state its hypotheses explicitly.
- **QMF8 - named frontier, not a claim.** Continuum limit,
  renormalization, and volume-uniform QCD mass-gap statements remain
  outside this ladder until separately formalized. Any prose that treats
  QMF7's finite-volume spectral data as a continuum Clay-level mass gap
  violates the section 13 taxonomy and F-YM-CONFLATE.

**Run protocol.** QMF work is a saturation lane during the four-day YM
run. It must not displace harvest/build work on the three pure-gauge
mountains: cut-plaquette RP, KP combinatorics, and the concrete Wilson
transfer instance. Statement files and Aristotle jobs are encouraged when
the mountain queue is waiting, but final claims must keep the finite
lattice, fixed-volume, fixed-coupling boundary visible in the theorem
name, d
```

### 4. `AgentTasks/fourday-ym-run-2026-07-05/RUN_PLAN.md` [Mission (in priority order)]

Score: `0.801`

```text
## Mission (in priority order)

1. **Close RP-LINK** (Q1): instantiate the proved master theorem
   `ReflectionPositivityKernel` for the Wilson weight on a link-reflection
   lattice. First formalized reflection positivity for an interacting
   lattice gauge ensemble anywhere.
2. **Transfer Hilbert space** (Q2) and the **sector-correct D12 transfer
   matrix** (Q3): turn RP into a positive self-adjoint transfer operator
   on a genuine inner-product space, with the flux-vs-glueball sector
   decomposition proved, feeding `TransferGapDefinition.finiteMassGap`.
3. **Unconditional gap-lane spectrum** (Q4+Q5): harvest the running
   unitarizability job `d4a9bd1f`, strip the matrix-model hypothesis from
   `WilsonVacuumDominance`, prove eigenvalue reality/ordering.
4. **KP lane** (Q6-Q8): freeze the finite polymer-conclusion statement,
   push the tree-graph/tail-bound theorem (Aristotle-heavy), map the
   strong-coupling character expansion into it, and go for exponential
   clustering of local loop observables.
5. **Finish YM1 Theorem 2** (Q11): the boundary-circuit lasso
   identification on `RectTreeGauge` (ordering already derived).
6. **YM-LIT + paper units**: source-verify the RP and KP attribution debt
   (Osterwalder-Seiler, Menotti-style RP sources, Kotecky-Preiss);
   maintain novelty checks; outline the two nearest paper units (YM1
   finite-G exact solutions; RP-LINK).
7. **Aristotle-as-partner jobs**: a KP statement-shape strategy job; a
   semantic red-team of the transfer-Hilbert-space layer once built.

Q9 (finite strong-coupling gap assembly) and Q10 (infinite-volume state)
are STRETCH: attempt only after Q1-Q3 and Q6-Q8 have landed; reaching
their named-prerequisite lemmas (the local-algebra cyclicity statement)
already counts as strong progress. Q12 (Pete
```

### 5. `AgentTasks/context-packs/ym-finite-gap-frontier-20260705-20260705-142650.md` [3. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [QMF ladder]]

Score: `0.800`

```text
### 3. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [QMF ladder]

Score: `0.761`

```text
o-style Wilson-fermion reflection positivity are
  source targets, subject to the provenance checks in section 11 and the
  LINK-vs-SITE reflection-plane distinction already logged by T12.
- **QMF6 - QCD transfer and quantum-number sectors.** Build the fermionic
  transfer operator on the QMF5 OS/GNS space and define sector projectors
  for flavor, parity, charge conjugation, baryon/meson content, and pure
  gauge center-flux data. This generalizes the Q3 sector machinery.
- **QMF7 - finite-volume hadron mass formalism.** At fixed lattice,
  finite volume, and fixed coupling, define hadron spectral masses as
  sector-restricted spectral gaps/data of the positive self-adjoint
  transfer operator. Meson and baryon interpolating operators live in the
  positive-side algebra. The taxonomy becomes theorem-level structure:
  `quarkMassParameter`, `hadronSpectralMass`, `regulatorMass`, and the
  pure-gauge Yang-Mills local-sector mass gap are distinct named objects,
  and any conversion theorem must state its hypotheses explicitly.
- **QMF8 - named frontier, not a claim.** Continuum limit,
  renormalization, and volume-uniform QCD mass-gap statements remain
  outside this ladder until separately formalized. Any prose that treats
  QMF7's finite-volume spectral data as a continuum Clay-level mass gap
  violates the section 13 taxonomy and F-YM-CONFLATE.

**Run protocol.** QMF work is a saturation lane during the four-day YM
run. It must not displace harvest/build work on the three pure-gauge
mountains: cut-plaquette RP, KP combinatorics, and the concrete Wilson
transfer instance. Statement files and Aristotle jobs are encouraged when
the mountain queue is waiting, but final claims mu
```

### 6. `AgentTasks/overnight-mass-run-2026-07-06/prompt_A5_transfer_gap_design.md`

Score: `0.796`

```text
Design + statement-freeze the bridge from the EXISTING reflection-positive
Wilson cut-plaquette ensemble to a PHYSICAL transfer operator with a
sector-restricted finite mass gap - the NE-U4 rung ("the mass gap as closure
cost"). This is a DESIGN / statement-layer job: compiling theorem signatures and
a lemma DAG, proofs optional where heavy.

Existing pieces (reuse; do not redefine):
- `WilsonCutPlaquetteEnsemble.reflectionPositive_of_hol_factorization` : gives
  `ReflectionPositivityKernel.IsReflectionPositive` for a factorizing Wilson
  ensemble.
- `ReflectionPositivityKernel.rpBlockMatrix` + `rpBlockMatrix_posSemidef_of_
  reflectionPositive` : the PSD Gram matrix from an RP kernel.
- `TransferHilbertBlock` / `TransferGapDefinition.finiteMassGap` /
  `FiniteGapAssembly` / `TwoStateTransferZ2L1` : the transfer-Hilbert-space and
  finite-gap API (currently instantiated only on the 2x2 toy).
- `FluxSectorZ2` and `TwoStateTransferZ2Sector` (the honest CENTER-sector
  bridge: `FluxSectorZ2.fluxGap`, sector membership/disjointness fields).

Create a NEW module `PhysicsSM/Draft/NullEdge/GateYM/TransferGapFromRP.lean`.
Check with `lake env lean`. If broader `lake build` stalls, SKIP and return
source.
```

### 7. `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` [The queue]

Score: `0.795`

```text
### The queue

- **Q1 (Wilson cut factorization; in-repo agent + possible Aristotle
  finisher; medium).** Instantiate `ReflectionPositivityKernel` for the
  Wilson ensemble on a link-reflection lattice: produce the mirror
  coordinates `(A, C, A)` from the T3 `Reflection` structure
  (`ReflectionCore` link classification + `WilsonReflectionCompatibility`),
  show the no-cut-plaquette part of the weight is factorized
  (`cutKernel_posSemidef_of_factorized`), and reduce the cut-plaquette
  couplings to the mixture corollary via a spectral decomposition of the
  one-plaquette kernel: `wilsonKernel_posSemidef` +
  `hadamard_posSemidef` (Schur products) give the PSD input; any PSD
  kernel is a nonnegative mixture of rank-one squares. Deliverable:
  `wilson_reflectionForm_nonneg` on a concrete reflection lattice
  (the `ReflectionCutExample` two-layer model is the minimal instance).
  This CLOSES RP-LINK at the finite level.
- **Q2 (transfer Hilbert space from RP; medium-hard; design first).**
  From `IsReflectionPositive W`: the sesquilinear form
  `<f, g> := reflectionForm`-polarized, quotient by the null space,
  finite-dimensional inner-product space, and the transfer operator as a
  positive self-adjoint operator on it. Mathlib has the quadratic-form
  and quotient machinery; the design note should fix the polarization
  convention first. Kill condition (adopted): if the null-edge/Wilson
  weight cannot be given a PSD cut kernel (Q1 fails), the transfer route
  is blocked and this item is renamed, not fudged.
- **Q3 (D12 sector-correct transfer matrix; design theorem; medium).**
  Adopted target, superseding any naive Gauss-sector gap statement (the
  oracle's 2x2-torus discovery stands): define the flux-sector
  decomposition of the Gauss-invariant space, prove the tr
```

### 8. `AgentTasks/context-packs/sm-cm-projector-audit-20260706-061916.md` [The queue]

Score: `0.795`

```text
### The queue

- **Q1 (Wilson cut factorization; in-repo agent + possible Aristotle
  finisher; medium).** Instantiate `ReflectionPositivityKernel` for the
  Wilson ensemble on a link-reflection lattice: produce the mirror
  coordinates `(A, C, A)` from the T3 `Reflection` structure
  (`ReflectionCore` link classification + `WilsonReflectionCompatibility`),
  show the no-cut-plaquette part of the weight is factorized
  (`cutKernel_posSemidef_of_factorized`), and reduce the cut-plaquette
  couplings to the mixture corollary via a spectral decomposition of the
  one-plaquette kernel: `wilsonKernel_posSemidef` +
  `hadamard_posSemidef` (Schur products) give the PSD input; any PSD
  kernel is a nonnegative mixture of rank-one squares. Deliverable:
  `wilson_reflectionForm_nonneg` on a concrete reflection lattice
  (the `ReflectionCutExample` two-layer model is the minimal instance).
  This CLOSES RP-LINK at the finite level.
- **Q2 (transfer Hilbert space from RP; medium-hard; design first).**
  From `IsReflectionPositive W`: the sesquilinear form
  `<f, g> := reflectionForm`-polarized, quotient by the null space,
  finite-dimensional inner-product space, and the transfer operator as a
  positive self-adjoint operator on it. Mathlib has the quadratic-form
  and quotient machinery; the design note should fix the polarization
  convention first. Kill condition (adopted): if the null-edge/Wilson
  weight cannot be given a PSD cut kernel (Q1 fails), the transfer route
  is blocked and this item is renamed, not fudged.
- **Q3 (D12 sector-correct transfer matrix; design theorem; medium).**
  Adopted target, superseding any naive Gauss-sector gap statement (the
  oracle's 2x2-torus discovery stands): define the flux-sector
  decomposition of the Gauss-invariant space, prove the tr
```

## Scoped paper hits

### 1. Kallen-Lehmann Spectral Representation of the Scalar SU(2) Glueball

Score: `0.764`
Zotero key: `DPJ6N6WS`
arXiv: `2103.11846`
DOI: `10.1140/epjc/s10052-022-10213-3`
URL: http://arxiv.org/abs/2103.11846

Abstract:

The Kallen-Lehmann spectral density is estimated from gauge-invariant lattice two-point functions in the scalar SU(2) glueball channel. The extracted ground-state mass agrees with the standard large-time exponential method and the spectral density contains indications of excited states.

### 2. Reflection-Positive Construction of a Four-Dimensional SU(N) Yang-Mills Theory with Mass Gap and Confinement

Score: `0.759`
Zotero key: `BH39WBRV`
arXiv: `2606.19362`
DOI: `10.1002/prop.70097`
URL: http://arxiv.org/abs/2606.19362

Abstract:

In the Euclidean view one must first require that positivity not be violated, and from this modest demand, together with locality, a great deal follows: starting from a reflection-positive lattice formulation of pure SU(N) Yang-Mills theory we obtain a transfer operator with a uniform gap, while large Wilson loops already show an area law by means of convergent character (polymer) expansions; a finite-range, gauge-covariant multiscale analysis then carries these features from one scale to the next with interlaced inequalities whose small defects can be summed, so that exponential clustering and a strictly positive string tension endure in the continuum; the Osterwalder-Schrader reconstruction turns these Euclidean facts into a Minkowski theory with a self-adjoint Hamiltonian, the spectral gap lying above the vacuum and the linear potential for static charges appearing, which gives a concrete picture of confinement; the construction depends on no special regulator, for a single-scale Lipschitz control and a telescoping argument bind all admissible reflection-positive slicings into a unique limiting measure and thus secure universality; moreover, the same framework admits entry from weak coupling, so that the continuum reached from strong coupling meets the one approached along an asymptotically free trajectory, yielding one and the same theory; in my view this is how mathematical clarity and physical insight cooperate: positivity, locality, and renormalization working together so that the mass gap and confinement are not marvels to be assumed, but natural properties of the non-Abelian vacuum.

### 3. A Note on Reflection Positivity and the Umezawa-Kamefuchi-Kallen-Lehmann Representation of Two Point Correlation Functions

Score: `0.755`
Zotero key: `R3JICUIK`
arXiv: `1201.3415`
URL: http://arxiv.org/abs/1201.3415

Abstract:

It will be proved that a model of lattice field theories which satisfies (A1) Hermiticity, (A2) translational invariance, (A3) reflection positivity, and (A4) polynomial boundedness of correlations, permits the Umezaa-Kamefuchi-Kallen-Lehmann representation of two point correlation functions with positive spectral density function. Then, we will also argue that positivity of spectral density functions is necessary for a lattice theory to satisfy conditions (A1) - (A4). As an example, a lattice overlap scalar boson model will be discussed. We will find that the overlap scalar boson violates the reflection positivity.

### 4. Scattering Amplitudes For All Masses and Spins

Score: `0.727`
Zotero key: `5J5XDKMN`
arXiv: `1709.04891`
DOI: `10.1007/JHEP11(2021)070`
URL: https://www.zotero.org/19894138/items/5J5XDKMN

### 5. Construction of a selfadjoint, strictly positive transfer matrix for Euclidean lattice gauge theories

Score: `0.725`
Zotero key: `99FVMMKD`
DOI: `10.1007/bf01614090`
URL: https://doi.org/10.1007/bf01614090

Abstract:

Wilson lattice gauge theories admit a self-adjoint strictly positive transfer matrix, supplying a physical Hilbert-space and Hamiltonian route for finite lattice gauge dynamics.

### 6. Characterization of Reflection Positivity: Majoranas and Spins

Score: `0.718`
Zotero key: `JHCV9IB4`
arXiv: `1506.04197`
DOI: `10.1007/s00220-015-2545-z`
URL: http://arxiv.org/abs/1506.04197

Abstract:

We study linear functionals on a Clifford algebra (algebra of Ma- joranas) equipped with a reflection automorphism. For Hamiltonians that are functions of Majoranas or of spins, we find necessary and sufficient conditions on the coupling constants for reflection positivity to hold. One can easily check these conditions in concrete models. We illustrate this by discussing a number of spin systems with nearest-neighbor and long-range interactions.

### 7. Weyl-van der Waerden formalism for helicity amplitudes of massive particles

Score: `0.717`
Zotero key: `986CC8CS`
arXiv: `hep-ph/9805445`
DOI: `10.1103/PhysRevD.59.016007`
URL: https://www.zotero.org/19894138/items/986CC8CS

Abstract:

The Weyl-van-der-Waerden spinor technique for calculating helicity amplitudes of massive and massless particles is presented in a form that is particularly well suited to a direct implementation in computer algebra. Moreover, we explain how to exploit discrete symmetries and how to avoid unphysical poles in amplitudes in practice. The efficiency of the formalism is demonstrated by giving explicit compact results for the helicity amplitudes of the processes gamma gamma -&gt; f fbar, f fbar -&gt; gamma gamma gamma, mu^- mu^+ -&gt; f fbar gamma.

### 8. Massive Helicity-Chirality Spinor Formalism from Massless Amplitudes with On-shell Mass Insertion

Score: `0.712`
Zotero key: `UVEFM4UK`
arXiv: `2501.09062`
URL: https://www.zotero.org/19894138/items/UVEFM4UK

Abstract:

We introduce a helicity-chirality spinor formalism to describe scattering amplitudes for particles of any masses and spins. The massive spin-spinors introduced by Arkani-hamed-Huang-Huang have been extended to the spin/helicity-transversality spinors, in which a new quantum number transversality, closely related to chirality, is introduced by extending the Poincare symmetry. The massive helicity-chirality amplitudes can be written by the large and small components of massless spinors $\lambda$ and $\eta$ following the $\lambda \sim \sqrt{E}, \eta \sim \mathbf{m}/\sqrt{E}$ expansion order by order, which formulate the power counting rules of a large energy effective theory. Diagrammatically the mass expansion in amplitudes originates from the on-shell mass insertion: the helicity flip and chirality flip, which completely determines the three-point massive amplitudes. From the chirality-helicity unification at the UV, any massive helicity-chirality amplitude can be one-to-one corresponded to massless helicity amplitudes with (without) additional Higgs insertion. This UV-IR correspondence explains the mass enhancement in the weak decay processes $\pi^+ \to \mu^+ \nu$ and $t \to W^+ b$, and isolates the correct UV of the three-point massive QED $F\bar{F}\gamma$ amplitudes in Arkani-hamed-Huang-Huang formalism. From massless-massive correspondence, the massless on-shell techniques can be utilized to construct higher-point massive amplitudes.
