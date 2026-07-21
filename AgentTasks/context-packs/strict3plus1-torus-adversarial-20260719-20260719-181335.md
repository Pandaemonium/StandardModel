# Aristotle semantic context pack

Generated: 2026-07-19T18:13:44
Query: `three dimensional local unitary quantum walk fermion doubling torus degree winding zero pi crossings`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AutonomousLab/work/NE-3PLUS1/CLAUDE_SKEPTIC_QUBITIZED_WILSON_NOGO_AUDIT_2026-07-13.md` [Theorem-ready statements]

Score: `0.826`

```text
## Theorem-ready statements

- **T1 (true, = Wilson, not new).** `H_W(k) = sum_j sin(k_j) alpha_j +
  r sum_j (1 - cos k_j) beta` is strictly local, Hermitian, translation-
  invariant, has a single zero at `k = 0` with tangent `sum_j k_j alpha_j`, and
  its would-be corner doublers at `k_j in {0, pi}` are gapped with masses
  `2 r * (#{j : k_j = pi})`. Its qubitized Szegedy walk is exactly unitary and
  (under site-independent PREPARE) strictly local and translation-invariant.
- **T2 (the obstruction).** `H_W` is NOT chirally symmetric:
  `{Gamma_5, D_W} propto r (1 - cos k) != 0`. Therefore no chiral-symmetric,
  doubler-free, local lattice Dirac operator is produced; NN's hypothesis is
  dropped, not evaded. Qubitization preserves `{Gamma_5, .}`-anticommutation
  structure and cannot restore chiral symmetry.
- **T3 (QCA obstruction, BAA25).** The discrete-time local-unitary walk is a QCA;
  by BAA25 fermion doubling occurs in QCAs at finite `eps`, so exact unitarity is
  not a doubling loophole. Removing FD requires their flavor-staggering +
  covering-map construction, which coexists with (does not evade) NN.
```

### 2. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/CLAUDE_SKEPTIC_QUBITIZED_WILSON_NOGO_AUDIT_2026-07-13.md` [Theorem-ready statements]

Score: `0.826`

```text
## Theorem-ready statements

- **T1 (true, = Wilson, not new).** `H_W(k) = sum_j sin(k_j) alpha_j +
  r sum_j (1 - cos k_j) beta` is strictly local, Hermitian, translation-
  invariant, has a single zero at `k = 0` with tangent `sum_j k_j alpha_j`, and
  its would-be corner doublers at `k_j in {0, pi}` are gapped with masses
  `2 r * (#{j : k_j = pi})`. Its qubitized Szegedy walk is exactly unitary and
  (under site-independent PREPARE) strictly local and translation-invariant.
- **T2 (the obstruction).** `H_W` is NOT chirally symmetric:
  `{Gamma_5, D_W} propto r (1 - cos k) != 0`. Therefore no chiral-symmetric,
  doubler-free, local lattice Dirac operator is produced; NN's hypothesis is
  dropped, not evaded. Qubitization preserves `{Gamma_5, .}`-anticommutation
  structure and cannot restore chiral symmetry.
- **T3 (QCA obstruction, BAA25).** The discrete-time local-unitary walk is a QCA;
  by BAA25 fermion doubling occurs in QCAs at finite `eps`, so exact unitarity is
  not a doubling loophole. Removing FD requires their flavor-staggering +
  covering-map construction, which coexists with (does not evade) NN.
```

### 3. `AgentTasks/24h-publication-run-2026-07-12/SPARK_LIT_MASSLESS_CROSSING_CENSUS_2026-07-11.md` [1) Bessho-Sato et al., arXiv:2006.04204]

Score: `0.826`

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
  - Moderate/low for exact ordered Pauli-product architecture match: it proves crossing/count formulas for its ow
...[truncated]
```

### 4. `AgentTasks/context-packs/afpl-floquet-model-reconstruction-20260713-122035.md` [1) Bessho-Sato et al., arXiv:2006.04204]

Score: `0.824`

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
  - Moderate/low for exact ordered Pauli-product architecture match: it proves crossing/count formulas for its ow
...[truncated]
```

## Scoped paper hits

### 1. Dirac quantum walk on tetrahedra

Score: `0.805`
Zotero key: `8RZQA73D`
arXiv: `2404.09840`
DOI: `10.1103/physreva.110.042418`
URL: http://arxiv.org/abs/2404.09840

### 2. Fermion Doubling in Dirac Quantum Walks

Score: `0.791`
Zotero key: `U58ZFXGR`
arXiv: `2601.15885`
URL: http://arxiv.org/abs/2601.15885v2

Abstract:

We consider discrete spacetime models known as quantum walks, which can be used to simulate Dirac particles. In particular we look at fermion doubling in these models, in which high momentum states yield additional low energy solutions which behave like Dirac particles. The presence of doublers carries over to the `second quantised' version of the walks represented by quantum cellular automata, which may lead to spurious solutions when introducing interactions. Moreover, we also consider pseudo-doublers, which have high energy but behave like low energy Dirac particles, and cause potential problems regarding the stability of the vacuum. To address these issues, we propose a family of quantum walks, that are free of these doublers and pseudo-doublers, but still simulate the Dirac equation in the continuum limit. However, there remain a small number of additional low energy solutions which do not directly correspond to Dirac particles. While the conventional Dirac walk always has a zero probability for the walker staying at the same point, we obtain the family of walks by allowing this probability to be non-zero.

### 3. Complete homotopy invariants for translation invariant symmetric quantum walks on a chain

Score: `0.785`
Zotero key: `RS6P7CBT`
arXiv: `1804.04520`
DOI: `10.22331/q-2018-09-24-95`
URL: http://arxiv.org/abs/1804.04520

Abstract:

We provide a classification of translation invariant one-dimensional quantum walks with respect to continuous deformations preserving unitarity, locality, translation invariance, a gap condition, and some symmetry of the tenfold way. The classification largely matches the one recently obtained (arXiv:1611.04439) for a similar setting leaving out translation invariance. However, the translation invariant case has some finer distinctions, because some walks may be connected only by breaking translation invariance along the way, retaining only invariance by an even number of sites. Similarly, if walks are considered equivalent when they differ only by adding a trivial walk, i.e., one that allows no jumps between cells, then the classification collapses also to the general one. The indices of the general classification can be computed in practice only for walks closely related to some translation invariant ones. We prove a completed collection of simple formulas in terms of winding numbers of band structures covering all symmetry types. Furthermore, we determine the strength of the locality conditions, and show that the continuity of the band structure, which is a m
...[truncated]
