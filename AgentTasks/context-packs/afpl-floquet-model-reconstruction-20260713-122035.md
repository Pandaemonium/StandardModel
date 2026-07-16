# Aristotle semantic context pack

Generated: 2026-07-13T12:20:59
Query: `Higashikawa Nakagawa Ueda single Weyl Floquet explicit unitary three-dimensional finite local substeps winding quasienergy`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/24h-publication-run-2026-07-12/SPARK_LIT_MASSLESS_CROSSING_CENSUS_2026-07-11.md` [2) Higashikawa et al., arXiv:1806.06868]

Score: `0.835`

```text
### 2) Higashikawa et al., arXiv:1806.06868
Primary source: `FCME_v2_6_combined.tex` (arXiv mirror via ar5iv/local temp cache), and arXiv/ARXIV entry `arXiv:1806.06868`.
- Theorem/equation loci:
  - 3D Weyl walk constructions are written through operator strings of the form `U_1^- U_{h,3}^- U_2^- U_{h,3}^+ ...` and `U_1^- U_{h,3}^- U_2^+ U_{h,3}^+`, with a Floquet unitary decomposition `V^{wh}(k)`.
  - The construction proves that a generic 3D split-step-like protocol gives a single Weyl fermion and evaluates the 3D winding number via a 3-form integral (not in literal Pauli-ordered exponential notation).
- Applicability to requested census:
  - Low for exact ordered Pauli-product match; their gate-level decomposition is not the plain `exp(-iqx σx) exp(-iqy σy) exp(-qz σz)` chain but a symmetry-structured product of conditional/projector steps.
  - Moderate for crossing census: explicit Weyl-node topological characterization is present, but explicit separate `0/π` quasienergy Jacobian-charge sums are not framed as a central formula in the same explicit census style.
- Conventions of note:
  - Projector-conditioned shifts and momentum-dependent sign conventions differ from plain Pauli exponential architecture.
```

### 2. `AgentTasks/24h-publication-run-2026-07-12/SPARK_LIT_MASSLESS_CROSSING_CENSUS_2026-07-11.md` [1) Bessho-Sato et al., arXiv:2006.04204]

Score: `0.817`

```text
### 1) Bessho-Sato et al., arXiv:2006.04204
Primary source: `NNtheorem_resubmission3.tex` (arXiv mirror via ar5iv/local temp cache), and arXiv/ARXIV entry `arXiv:2006.04204`.
- Theorem/equation loci:
  - Thm 1 and Thm 1′ establish the 3D discrete-time unitary map from a 3D nontrivial walk to a Floquet matrix block form and symmetry constraints on branch quasienergies.
  - Thm 2 and Thm 3′ (Floquet extension) give the explicit chiral winding/charge relation for 3D DTQW, including decomposition into 0/π sectors.
  - Ordered-exponential Pauli architecture is not given as literal `exp(-iqx σx) exp(-iqy σy) exp(-iqz σz)` factors in the main theorem statements; decomposition is written in split-step/floquet effective-form variables with sign- and branch-dependent blocks.
  - The paper explicitly provides the 3D “Weyl crossings” list in the main text/figure narrative (8 point list), and uses the 0/π split in quasienergy for charge accounting.
- Applicability to requested census:
  - High for quasienergy sector splitting and Floquet Jacobian-type invariants.
  - Moderate/low for exact ordered Pauli-product architecture match: it proves crossing/count formulas for its own architecture family, not verbatim `exp(-iqx σx) exp(-iqy σy) exp(-iqz σz)`.
- Conventions of note:
  - Uses Floquet branch conventions with explicit quasienergy periodicity; sector partition by `E = 0` and `E = π` requires consistent branch handling.
  - Crossing signs are orientation/Jacobian based on local band-touching structure in the chosen effective Hamiltonian gauge.
```

### 3. `AgentTasks/24h-publication-run-2026-07-12/LIT_SEARCH_LOG.md` [2026-07-11 16:05 PDT - changing-spacing R3 interpolation after D-R3-1]

Score: `0.785`

```text
higher-dimensional strong component; notation warning, Read's `R_1` is complex and `R_3` quaternionic. Bessho-Sato arXiv:2006.04204 supplement ties local Floquet charges to bulk topology with a dimension-dependent pi-gap sign. Higashikawa et al. arXiv:1806.06868 and Gupta-Short arXiv:2601.15885v2 retained as positive/escape controls. Composition, finite-rank stabilization, and sign conventions remain VERIFY. Full audit: `B_STRICT_LAURENT_SOURCE_AUDIT_2026-07-11.md`.
2026-07-11 17:04 PDT | Spark/Codex | Global chiral Floquet composition | Bessho-Sato arXiv:2006.04204v3 Theorems 2 and 3' are the closest primary-source loci for three-dimensional local Weyl charge and zero/pi Floquet bookkeeping; Read arXiv:1608.04696v3 remains the separate strict-Laurent stable obstruction. No single finite-rank theorem composes them. Spark report is a locator, not authority: its Read Eq. (64) `K0` discussion does not replace the direct `K1` audit. Full report: `SPARK_LIT_GLOBAL_CHIRAL_FLOQUET_2026-07-11.md`.

[2026-07-11] LIT sidecar: scanned local Neo4j+chunks + primary sources for 2006.04204, 1806.06868, 1705.08552, 1802.03910. Full-text chunks present only for 1802.03910. 0/pi sector split explicitly detailed in 2006.04204; ordered Pauli-product census match found only partially via directional factorized constructions (closest in 1802.03910), not exact theorem form. 16-crossing BCC+cube-corner cancellation appears novel at this architecture level.
2026-07-11 20:12 PDT | Codex direct fallback (Spark context failure) | reciprocal conditional shifts / paraunitary factorization / strict 3+1 successors | Cedzich-Geib-Werner Thm 2.1 makes shift-coin words complete for 1D banded walks; Gupta-Short 3+1 stationary-amplitude family still leaves two extraneous low-energy solutions; Arrighi-Nesme
```

### 4. `Sources/Null_Edge_Publication_Portfolio_2026-07-10.md` [Working title]

Score: `0.785`

```text
### Working title

**Winding Is Not Enough: Involutive Compression and Exact Defect Modes in a
Spinor-Derived Unitary Quantum Walk**
```

### 5. `AgentTasks/overnight-publication-run-2026-07-11/LIT_SEARCH_LOG.md` [Literature and Lean-reference search log]

Score: `0.780`

```text
n scholarly search during C design; ingest the canonical set if C closes

2026-07-10 19:42 PDT | Fable | DTQW topology external check (Paper C) | scholarly search-arxiv: "topological phases quantum walks bound states winding" | 1910.02949 (Panahiyan-Fritzsche: step-dependent coin, winding +-1 phases, 0/pi bound states at phase boundaries); 2301.08225 (Mumford: double kicked top, large winding, 0/pi boundary modes, multi-step QW connection) | Confirms: winding-number phases and 0/pi boundary-localized modes in chiral DTQWs are ESTABLISHED (Kitagawa 2010 / Asboth 2012 tradition; rigorous classification Cedzich et al.). Paper C novelty must be the derivation layer: link data derived from local null-spinor Pluecker field, collinearity zeros as geometric defect loci, kernel-checked finite index chain. Winding-implies-mode by itself is NOT novel | Position C intro as "derived connection + verified finite index," import the classification; cite Kitagawa/Asboth/Cedzich when C manuscript is drafted
2026-07-10 18:52 PDT | Codex | Successive-axis and all-zone quantum-walk prior art (Papers A/B/D) | Neo4j full-text chunk search: "successive-axis discrete-time quantum walk exact unitary Dirac continuum limit Fourier symbol convergence full Brillouin zone" | Mlodinow-Brun 1802.03910 chunks 1, 2, 16; Arrighi-Di Molfetta 1803.01015 chunks 0, 1; Arrighi-Facchini-Forets 1505.07023 | Successive one-dimensional substeps, emergent Dirac equations, and rotational/coin constraints are established. Our exact all-zone determinant formulas and changing-space convergence must be presented as verification/classification upgrades, not as the invention of the split walk | Read 1802.03910 chunks 7/20 and 1803.01015 chunk 3 when drafting the nearest-work table
2026-07-10 18:53 PDT | Codex | Fermionic
```

### 6. `AgentTasks/24h-publication-run-2026-07-12/GRAND_STRATEGY7_REPORT.md` [P3 — Exactly-unitary strict-local Wilson walk (`d = 4`) — the physics-standard cure]

Score: `0.778`

```text
### P3 — Exactly-unitary strict-local Wilson walk (`d = 4`) — the physics-standard cure

Add a Cayley-unitarized Wilson term that vanishes quadratically at the origin
and grows to the corners:
```
W(q) = r · Σ_j (1 − c_j) · β,                    (Hermitian, Ξ-odd via β)
U₃(q) = (I − i W(q))(I + i W(q))⁻¹ · splitStep(q,0)   [Cayley]
     or  U₃(q) = splitStep(qx,qy,qz, θ_W(q))  with cos θ_W = f(Σ(1−c_j)).
```
* Laurent-finite in the *symbol* sense: `1 − c_j = 1 − (z_j+z_j⁻¹)/2` is
  Laurent; the Cayley transform is a finite Laurent *unit* iff the denominator
  is a Laurent unit (needs `det(I + iW)` a monomial — check via
  `LaurentUnitResource.qca_det_is_unique_monomial`; if not, use the
  mass-angle form `θ_W(q)`, which is manifestly Laurent per factor but makes the
  Wilson profile a bounded-range trigonometric mass).
* Symmetry / roots: retains the **full cubic point group** (`W` is symmetric in
  `c_j`); particle-hole is broken by `W` — which is exactly permitted, since P3
  deliberately leaves the global-chiral class. Predicted root set: **unique cone
  at the origin, all seven doublers gapped** (textbook Wilson). Lowest novelty
  (it is the Wilson mechanism), but a strict-local *exactly unitary discrete-time*
  Wilson walk with a **kernel-certified** unique cone is still a clean, true,
  citable theorem and the safest positive result.
```

### 7. `docs/DOCUMENT_MAP.md` [The null-edge program: core documents]

Score: `0.776`

```text
et.lean`, `Finite3Plus1BrillouinAudit.lean`,
  `ContinuumL2MultiplierBridge.lean`, `CompactSupportL2WalkBridge.lean`,
  `FiniteWalkOnsiteEquivalenceObstruction.lean`, `LocalQCAProperties.lean`,
  `StationaryAmplitudeNoGo.lean`, `StationaryAmplitudeLiveAxisNoGo.lean`,
  `WilsonDiracRegulator.lean`, `FloquetDeterminantCriterion.lean`, and
  `CountableL2WavepacketConvergence.lean` -
  exact finite local `3+1` norm preservation, ordered x/y/z/mass symbol,
  compact-box `O(1/n)` rate and a refined `3+1` many-step bound retaining
  `exp(|t| B4/n)` rather than `exp(B4)`, finite Fourier-kernel lifts in `1+1`
  and `3+1`,
  exact vector-valued one-axis and product-three-torus
  Plancherel/wave-packet bounds, exact
  finite-character blocks on every product plane wave, the finite-to-analytic
  negative-momentum conversion with a quarter-zone sign control, an explicit
  two-sided local-cycle inverse and strict causal cone, the exact eight-corner
  parity/alias classification, explicit massive body-center `+1` and `-1`
  eigenmodes for every mass angle, an onsite-equivalence obstruction, the
  degree-one Laurent no-go forcing a stationary amplitude to vanish under
  origin normalization, exact all-momentum unitarity, and a full involutory
  tangent, its three direct
  specializations to the live axis generators, the Wilson--Dirac scalar square,
  uniform massive Hamiltonian gap, and massless zero-set theorem removing all
  non-origin cubic corners at the local-Hamiltonian level, generic exact
  determinant-zero criteria for nonzero `+1` and `-1` Floquet modes, and a
  countable Tannery `L2` theorem, plus the measure-theoretic theorem that a
  vanishing uniform relative multiplier bound forces `L2` convergence, and its
  walk-specific compact-support specialization with explicit `O(
```

### 8. `AgentTasks/twoday-carrier-run-2026-07-07/TSOLDER_KAPPA_ANALYSIS.md` [4b. ZERO-MODE LOCUS SCAN (2026-07-07, follow-up; numeric oracle)]

Score: `0.775`

```text
). Even-V half-winding
   is the properly "topological" corner of the abstract parameter space.
4. Prior art now in the paper graph for the eventual writeup: protected
   0- and pi-quasienergy modes in discrete-time quantum walks (Kitagawa,
   arXiv:1112.1882 [3TAWUGB4]; Tarasinski-Asboth-Dahlhaus,
   arXiv:1401.2673 [DEK4EJME]). Novelty must be claimed ONLY for the
   decoration/celestial-geometry origin and the self-locking (finding 2),
   not for 0/pi-mode protection as such.

**Theorem targets handed to the HOLONOMY-ZERO-MODE thread (in order):**

- T1 (REDIRECTED 2026-07-08 by the K6 probe): the forcing symmetry is
  NOT the cyclic shift (abstract winding-1 data is unpinned) but a CHIRAL
  involution Gamma with Gamma W Gamma = W^dagger (= orientation-swap =
  edge-reversal grading), present for the even-V half-winding case, which
  pins BOTH +-1 for all |t|. Kernel core LANDED in
  `PhysicsSM/Draft/NullEdge/Carrier/ChiralZeroModeParity.lean`
  (det W = +-1 dichotomy); the |t|-independent double pinning needs the
  chiral winding invariant (Asboth-Obuse, 1303.1199), oracle-grade.
- T2 (tetrahedral rationality): the V = 3 tetrahedral transfer has
  spectrum pi/6 * {-6, -2, -1, 0, 4, 5} exactly (entries live in a
  cyclotomic field; exact linear algebra is feasible).
- T3 (abstract locus): for V = 3, w = 1 uniform data, 1 in spec(W) iff a
  closed-form relation p(|t|, h) = 0 (evaluate the characteristic
  polynomial at 1); then finding 2 becomes "spinor chaining implies p = 0".

Claim boundary: all numeric-oracle grade; T1-T3 are pre-registered
targets, not results; "masslessness" here means zero quasi-energy of the
finite leg transfer, with no continuum claim.
```

## Scoped paper hits

### 1. Complete homotopy invariants for translation invariant symmetric quantum walks on a chain

Score: `0.754`
Zotero key: `RS6P7CBT`
arXiv: `1804.04520`
DOI: `10.22331/q-2018-09-24-95`
URL: http://arxiv.org/abs/1804.04520

Abstract:

We provide a classification of translation invariant one-dimensional quantum walks with respect to continuous deformations preserving unitarity, locality, translation invariance, a gap condition, and some symmetry of the tenfold way. The classification largely matches the one recently obtained (arXiv:1611.04439) for a similar setting leaving out translation invariance. However, the translation invariant case has some finer distinctions, because some walks may be connected only by breaking translation invariance along the way, retaining only invariance by an even number of sites. Similarly, if walks are considered equivalent when they differ only by adding a trivial walk, i.e., one that allows no jumps between cells, then the classification collapses also to the general one. The indices of the general classification can be computed in practice only for walks closely related to some translation invariant ones. We prove a completed collection of simple formulas in terms of winding numbers of band structures covering all symmetry types. Furthermore, we determine the strength of the locality conditions, and show that the continuity of the band structure, which is a minimal requirement for topological classifications in terms of winding numbers to make sense, implies the compactness of the commutator of the walk with a half-space projection, a condition which was also the basis of the general theory. In order to apply the theory to the joining of large but finite bulk pieces, one needs to determine the asymptotic behaviour of a stationary Schrödinger equation. We show exponential behaviour, and give a practical method for computing the decay constants.

### 2. Quantum Electrodynamics from Quantum Cellular Automata, and the Tension Between Symmetry, Locality and Positive Energy

Score: `0.740`
Zotero key: `arxiv:2503.05998`
arXiv: `2503.05998`
DOI: `10.3390/e27050492`
URL: http://arxiv.org/abs/2503.05998

Abstract:

Derives free QED as a continuum limit of Fermi and Bose lattice quantum cellular automata from quantum-walk symmetry and unitarity conditions, highlighting locality/positive-energy tension.

### 3. Dirac equation as a quantum walk over the honeycomb and triangular lattices

Score: `0.740`
Zotero key: `BMFTJTIS`
arXiv: `1803.01015`
DOI: `10.1103/PhysRevA.97.062111`
URL: https://www.zotero.org/19894138/items/BMFTJTIS

Abstract:

A discrete-time quantum walk (QW) is essentially an operator driving the evolution of a single particle on the lattice, through local unitaries. Some QWs admit a continuum limit, leading to well-known physics partial differential equations, such as the Dirac equation. We show that these simulation results need not rely on the grid: the Dirac equation in (2+1) dimensions can also be simulated, through local unitaries, on the honeycomb or the triangular lattice, both of interest in the study of quantum propagation on the nonrectangular grids, as in graphene-like materials. The latter, in particular, we argue, opens the door for a generalization of the Dirac equation to arbitrary discrete surfaces.

### 4. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.739`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 5. Dirac quantum walk on tetrahedra

Score: `0.738`
Zotero key: `8RZQA73D`
arXiv: `2404.09840`
DOI: `10.1103/physreva.110.042418`
URL: http://arxiv.org/abs/2404.09840
