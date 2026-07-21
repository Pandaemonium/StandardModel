# Aristotle semantic context pack

Generated: 2026-07-21T02:41:07
Query: `finite fermionic QCA even local interaction CAR locality positive energy selected sector preservation obstruction`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/overnight-publication-run-2026-07-11/LIT_SEARCH_LOG.md` [Literature and Lean-reference search log]

Score: `0.829`

```text
ntable; Piroli--Turzillo--Shukla--Cirac `2007.11905` proves generic fermionic MPUs need not have a strict causal cone and characterizes a locality-preserving generalized class; the fermionic Lieb--Robinson literature confirms that disjoint even observables commute while odd observables require graded locality | State the Lean cone on the parity-even local observable algebra, or use graded commutators explicitly. Prove exact support propagation from the concrete brickwork rule rather than importing qudit QCA locality from unitarity. A generic fMPU representation is insufficient | Await Spark's theorem/section-level reference ranking; make an outside-cone exact-commutation control and a cone-saturating nonzero pair-phase witness mandatory.
2026-07-11 03:55 PDT | Spark/Pascal -> Codex | Paper E theorem-level fermionic locality scan | Neo4j paper/chunk search plus OpenAlex fallback | Ranked comparators: Mlodinow--Brun `2006.08927` higher-dimensional Jordan--Wigner/locality no-go; D'Ariano et al. `1601.04832` and Bisio et al. `1601.04842` finite-neighborhood QCA axioms; `2103.13150` explicit 1+1 Jordan--Wigner even/odd layers; Brun--Mlodinow `2503.05998` finite-range interacting locality constraints; Meyer `quant-ph/9604003`, Mlodinow--Brun `1802.03910`, and Bialynicki-Birula `hep-th/9304070` as historical finite-support comparators | Paper E must name dimension, interaction class, ordering, parity sector, and strict support rather than a norm tail. The strongest safe target is an exact parity-even support/commutator cone for the concrete finite brickwork pair update, with an outside-cone zero and a nonzero cone-saturating witness | Re-read the `Contradiction`/`Higher dimensions` sections of `2006.08927` and `Finite-Range Interactions` of `2503.05998` before final prose.
202
```

### 2. `AgentTasks/overnight-publication-run-2026-07-11/HELP_NEEDED_2026-07-11.md` [H6. Upgrade declared-set CAR support to geometric many-body causality and dynamics]

Score: `0.821`

```text
### H6. Upgrade declared-set CAR support to geometric many-body causality and dynamics

**Landed frontier.** The Pluecker pair kick is an even quartic CAR operation on
an embedded four-mode set. Disjoint embedded sets commute. Strong CAR support
propagates through a finite schedule, and a graph-metric successor now proves
that a sequential list of `BlockLocal` gates enlarges support only inside the
iterated neighborhood.  A contiguous block is a nontrivial witness and a far
block explicitly fails the locality premise.

**What remains open.** The exact cone counts sequential gates.  It does not yet
package pairwise-disjoint gates into parallel layers or bound radius by circuit
depth.  It also does not compose the interaction with the free spatial walk,
derive the gate from a local Hamiltonian/action, or produce scattering or
binding data.

**What we need.** An exact layer type with pairwise-disjoint finite-range
supports and a theorem bounding evolved support by one neighborhood expansion
per layer. The result must handle fermionic parity explicitly: ordinary
commutators are appropriate when one side is even; odd-odd observables require
graded locality or a controlled Jordan-Wigner map.

The next dynamical step is to derive the gate from a local quartic Hamiltonian
or action and compute a binding energy, scattering phase, or selection rule.

**What would close the next gate.** A proof-complete radius-versus-layer-depth
theorem with pairwise-disjoint layer supports and an outside-cone graded
commutation corollary.  Algebraic involutivity must not be relabeled as
Hilbert-space unitarity, and the existing nonzero boundary transfer must not be
relabeled as cone sharpness.

**Best-fit expertise.** CAR nets, fermionic QCAs, Lieb-Robinson methods, graded
tensor products, local
```

### 3. `AgentTasks/overnight-publication-run-2026-07-11/LIT_SEARCH_LOG.md` [Literature and Lean-reference search log]

Score: `0.816`

```text
tion/classification upgrades, not as the invention of the split walk | Read 1802.03910 chunks 7/20 and 1803.01015 chunk 3 when drafting the nearest-work table
2026-07-10 18:53 PDT | Codex | Fermionic QCA and second-quantized locality (Paper E) | Neo4j full-text chunk search: "quantum cellular automaton fermionic second quantization locality CAR functorial unitary many body" | Mlodinow-Brun 2006.08927 chunks 3/9; D'Ariano et al. 1601.04832 and 1601.04842; QED-QCA 2503.05998; Meyer hep-th/9304070 | Promoting one-particle walks to fermionic many-body QCAs is established; the paper must earn novelty from the spinor-derived Pluecker interaction and an exact phase-sensitive observable while proving the standard functorial/unitary/local lift cleanly | Use 2006.08927 as the nearest locality/no-go comparator and do not sell second quantization alone as novelty
2026-07-10 18:54 PDT | Codex | Strong changing-lattice Dirac limit (Paper D) | Neo4j full-text chunk search: "changing lattice Hilbert spaces sampling interpolation strong L2 convergence quantum walk Dirac equation Sobolev Fourier tail" | Arrighi-Di Molfetta 1803.01015 chunks 0/3; Mlodinow-Brun 1802.03910 chunks 0/7/20; Arrighi-Facchini-Forets 1505.07023; 1911.09791 | The local/long-wavelength continuum story is mature, but the returned chunks do not supply our desired explicit changing-Hilbert-space isometry plus Sobolev-tail strong-L2 theorem. That exact analytic bridge remains a defensible theorem target | Package explicit sampling/interpolation and DFT conjugacy; avoid claiming novelty until a broader rigorous-limit search confirms the gap
2026-07-10 21:00 PDT | Fable | EXCITEMENT SCAN (headline mandate) + Gupta-Short architecture audit (Papers A/B) | WebSearch "fermion doubling quantum walk Dirac QCA 2026" + WebFetch
```

### 4. `AgentTasks/null-edge-so-what-closure-2026-07-10/GOAL_PROMPT_CODEX.md` [Flagship D - second quantization and one interacting observable]

Score: `0.816`

```text
## Flagship D - second quantization and one interacting observable

Lift the one-particle update to a finite CAR/Fock-space automorphism.  Prove:

- preservation of the CAR;
- locality radius and number/parity conservation;
- compatibility of the one-particle sector with the landed walk;
- an exact positive/negative-energy or quasienergy convention;
- a nontrivial local interaction that preserves exact unitarity.

Then calculate and formalize at least one operational consequence:

- a two-particle bound-state energy;
- a scattering phase or finite S-matrix entry;
- an interaction threshold;
- a selection rule forced by the Pluecker phase;
- or a quantitative suppression/no-go for unwanted negative-energy production.

The observable must depend on the Pluecker structure in a way that cannot be
removed by replacing `z` with an unconstrained scalar mass.
```

### 5. `AgentTasks/overnight-publication-run-2026-07-11/LIT_SEARCH_LOG.md` [Literature and Lean-reference search log]

Score: `0.813`

```text
nd finite-selector no-gos remain elementary carrier-specific results. Before any citation or imported theorem shape, read the relevant full-text theorem/assumptions and audit compact-group, asymptotic-i.i.d., positivity, and representation hypotheses against the finite Krein carrier.
2026-07-10 23:24 PDT | Codex | Papers E/D/F boundary refresh | Neo4j full-text chunk searches over all projects for finite CAR adjointness/locality, exact finite-torus DFT Dirac walks, and natural Dirac-square decomposition selectors | Mlodinow--Brun arXiv:2006.08927 and QED-QCA arXiv:2503.05998 for standard fermionic QCA promotion; Arrighi--Di Molfetta arXiv:1803.01015 for Dirac walks (output encoding failed after the first ranked hit); Ackermann--Tolksdorf hep-th/9503153 for generalized Lichnerowicz decomposition | CAR adjointness/covariance is required infrastructure, not novelty. Exact finite spectral conjugacy remains below the scaled Shannon/PDE continuum standard. Paper F must claim carrier-specific refinement moduli and selector obstructions, not invention of Dirac-square decomposition, affine torsors, or simultaneous eigenspaces | Use the CAR lemma to close the many-body API; keep Paper D finite-spectral wording; pursue an intrinsic edge/degree selector or an exact residual-symmetry kill for Paper F
2026-07-11 00:00 PDT | Codex | Paper C half-winding/protection terminology audit | External web search for formal proof-assistant treatments of topological quantum walks, half-winding invariants, involutive compressions, and protected Floquet edge modes | Kitagawa et al. arXiv:1003.1729 and the Asboth/Cedzich symmetry-protected quantum-walk literature establish topological phases and protected 0/pi edge-state machinery; broad formal quantum libraries surfaced, but no directly comparable
```

### 6. `AgentTasks/overnight-publication-run-2026-07-11/HELP_NEEDED_2026-07-11.md` [H6. Upgrade declared-set CAR support to geometric many-body causality and dynamics]

Score: `0.808`

```text
unitarity, and the existing nonzero boundary transfer must not be
relabeled as cone sharpness.

**Best-fit expertise.** CAR nets, fermionic QCAs, Lieb-Robinson methods, graded
tensor products, local quantum circuits, and finite-volume interacting dynamics.

**Formal anchors.** `FiniteCARFockBasic.lean`,
`FiniteCARSecondQuantization.lean`, `PlueckerQuarticInteraction.lean`,
`PlueckerPairKickNonQuasiFree.lean`, `PlueckerQuarticNotOneBody.lean`,
`PlueckerCausalCone.lean`, and `PlueckerGeometricCone.lean`.
```

### 7. `AgentTasks/overnight-publication-run-2026-07-11/LEDGER.md` [Overnight publication run ledger]

Score: `0.808`

```text
U_ji Gamma(U)a_i`, creation/annihilation adjointness, relation-filtered support laws, and a nontrivial two-mode swap control. This is finite inherited one-particle support, not a Lieb-Robinson or interacting-QFT locality claim.
2026-07-10 20:46 PDT | Codex | Builder | Paper E annihilation/locality | Typechecked all six targets and submitted `codex-pub-car-annihilation-locality` project `7989d240`, with counterexample-first discipline if the matrix orientation is wrong.
2026-07-10 20:48 PDT | Codex | Oracle/Assassin | C/D literature boundary | Primary-source pass found Asboth--Obuse (arXiv:1303.1199) and Matsuzawa--Tanaka--Wada (arXiv:2111.12652) already establish protected `0/pi` chiral-walk edge-state/index frameworks; `ChiralFlipMode` novelty must be machine-checked finite determinant machinery plus live spinor-defect composition, not discovery of Floquet protection. Maeda--Suzuki (arXiv:1902.02017) already proves scaled-lattice-to-Dirac convergence via Shannon interpolation with uniform finite-time Sobolev control in 1D. Paper D's venue gate now explicitly requires scaled interpolation and a quantitative 3+1 rate, not merely unscaled `Z^3` exhaustion.
2026-07-10 20:40 PDT | Codex | Registrar | Expanded publication verifier | One-command formal/numerical verifier PASS in 102.6 s after adding `ChiralFlipMode`, `Finite3Plus1ProductDFTCore`, `ChangingModeEmbedding`, and the completed finite CAR unitary layer. Latest `summary.json` SHA-256 `CCD625A2...560B58`; deterministic dynamics JSON unchanged `79CFF2A9...17014`.
2026-07-10 20:43 PDT | Codex | Assassin | Paper E final Aristotle cross-check | Downloaded current `f90d69c7` snapshot: all requested theorems are now proof-complete with unchanged statements and no proof holes. Its direct Cauchy-Binet inner-product proof agr
```

### 8. `AgentTasks/overnight-publication-run-2026-07-11/MANUSCRIPT_CLAIM_MATRIX.md` [Manuscript claim matrix]

Score: `0.805`

```text
high-pair state acquires a nonzero low-pair amplitude; the quartic high-to-low amplitude is the nonzero unit phase | `Gamma_one` plus singleton agreement forces `U=1`; every one-body CAR generator has exactly zero matrix element between the disjoint pairs | Proves both evolution-level and generator-level separation from one-particle number-preserving constructions in the displayed finite model | PASS: exact matrix-element obstruction and standard-three guards; does not exclude general Bogoliubov, affine, or Gaussian maps. Spatial placement is a separate theorem in E-H2; exponential-flow, scattering, and continuum claims remain open | TODO |
| E-H2 | Exact placed interaction and circuit-layer graph cone | The same Pluecker pair kick can be placed on an embedded four-mode set as an even quartic CAR polynomial; under a reflexive graph neighborhood and finite-range hypotheses, a sequential gate list obeys its iterated cone, while each pairwise-disjoint gate layer costs only one neighborhood expansion and a schedule costs at most its layer depth | M/[orig/comp] | `PlueckerCausalCone.bKickL_CARSupported`, `heisenFoldBlocks_CARSupported`, `bKickL_commute_disjoint`, `bKickL_involutive`, `heisenFoldBlocks_geometric_cone`; `PlueckerLayerCone.reachCone_subset_ballStep_of_layerDisjoint`, `heisenLayer_geometric_cone`, `heisenLayers_geometric_cone` | Finite linearly ordered fermionic mode type; supplied reflexive neighborhood `N`; each block satisfies `BlockLocal N`; gates inside each counted layer are pairwise disjoint; unit phase gives involutive algebraic conjugation, not a separately proved Hilbert-space unitary; strong support is ordinary commutation with every creation and annihilation generator outside the region | A nonempty disjoint layer and any schedule satisfying the hypo
```

## Scoped paper hits

### 1. Quantum Electrodynamics from Quantum Cellular Automata, and the Tension Between Symmetry, Locality and Positive Energy

Score: `0.803`
Zotero key: `arxiv:2503.05998`
arXiv: `2503.05998`
DOI: `10.3390/e27050492`
URL: http://arxiv.org/abs/2503.05998

Abstract:

Derives free QED as a continuum limit of Fermi and Bose lattice quantum cellular automata from quantum-walk symmetry and unitarity conditions, highlighting locality/positive-energy tension.

### 2. Fermion Doubling in Quantum Cellular Automata

Score: `0.791`
Zotero key: `6XT3VQSE`
arXiv: `2505.07900`
URL: http://arxiv.org/abs/2505.07900

Abstract:

A Quantum Cellular Automaton (QCA) is essentially an operator driving the evolution of particles on a lattice, through local unitaries. Because $Δ_t=Δ_x = ε$, QCAs constitute a privileged framework to cast the digital quantum simulation of relativistic quantum particles and their interactions with gauge fields, e.g., $(3+1)$D Quantum Electrodynamics (QED). But before they can be adopted, simulation schemes for high-energy physics need prove themselves against specific numerical issues, of which the most infamous is Fermion Doubling (FD). FD is well understood in particular in the real-time, discrete-space \emph{but} continuous-time settings of Hamiltonian Lattice Gauge Theories (LGTs), as the appearance of spurious solutions for all $Δ_x=ε\neq 0$. We rigorously extend this analysis to the real-time, discrete-space \emph{and} discrete-time schemes that QCAs are. We demonstrate the existence of FD issues in QCAs for $Δ_t =Δ_x = ε\neq 0$. By applying a covering map on the Brillouin zone, we provide a flavor-staggering-only way of fixing FD that does not break the chiral symmetry of the massless scheme. We explain how this method coexists with the Nielsen-Ninomiya no-go theorem, and give an example of neutrino-like QCA showing that our model allows to put chiral fermions interacting via the weak interaction on a spacetime lattice, without running into any FD problem.

### 3. A perturbative approach to the solution of the Thirring quantum cellular automaton

Score: `0.783`
Zotero key: `F9QTMZW5`
arXiv: `2406.19917`
DOI: `10.3390/e27020198`
URL: http://arxiv.org/abs/2406.19917

Abstract:

The Thirring Quantum Cellular Automaton (QCA) describes the discrete time dynamics of local fermionic modes that evolve according to one step of the Dirac cellular automaton followed by the most general on-site number-preserving interaction, and serves as the QCA counterpart of the Thirring model in quantum field theory. In this work, we develop perturbative techniques for the QCA path-sum approach, expanding both the number of interaction vertices and the mass parameter of the Thirring QCA. By classifying paths within the regimes of very light and very heavy particles, we computed the transition matrices in the two- and three-particle sectors to the first few orders. Our investigation into the properties of the Thirring QCA, addressing the combinatorial complexity of the problem, yielded some useful results applicable to the many-particle sector of any on-site number-preserving interactions in one spatial dimension.

### 4. Quantum field theory from a quantum cellular automaton in one spatial dimension and a no-go theorem in higher dimensions

Score: `0.777`
Zotero key: `V6C5KDEF`
arXiv: `2006.08927`
DOI: `10.1103/PhysRevA.102.042211`
URL: https://www.zotero.org/19894138/items/V6C5KDEF

Abstract:

It has been shown that certain quantum walks give rise to relativistic wave equations, such as the Dirac and Weyl equations, in their long-wavelength limits. This intriguing result raises the question of whether something similar can happen in the multiparticle case. We construct a one-dimensional quantum cellular automaton (QCA) model, which matches the quantum walk in the single particle case and which approaches the quantum field theory of free fermions in the long-wavelength limit. However, we show that this class of constructions does not generalize to higher spatial dimensions in any straightforward way and that no construction with similar properties is possible in two or more spatial dimensions. This rules out the most common approaches based on QCAs. We suggest possible methods to overcome this barrier while retaining locality.

### 5. A discrete relativistic spacetime formalism for 1 + 1-QED with continuum limits

Score: `0.759`
Zotero key: `CZTK2MRM`
arXiv: `2103.13150`
DOI: `10.1038/s41598-022-06241-4`
URL: https://www.zotero.org/19894138/items/CZTK2MRM

Abstract:

We build a quantum cellular automaton (QCA) which coincides with $1+1$ QED on its known continuum limits. It consists in a circuit of unitary gates driving the evolution of particles on a one dimensional lattice, and having them interact with the gauge field on the links. The particles are massive fermions, and the evolution is exactly U(1) gauge-invariant. We show that, in the continuous-time discrete-space limit, the QCA converges to the Kogut–Susskind staggered version of $1+1$ QED. We also show that, in the continuous spacetime limit and in the free one particle sector, it converges to the Dirac equation—a strong indication that the model remains accurate in the relativistic regime.
