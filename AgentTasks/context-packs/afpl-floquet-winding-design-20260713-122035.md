# Aristotle semantic context pack

Generated: 2026-07-13T12:20:59
Query: `finite combinatorial four-dimensional unitary loop winding triangulation gauge invariant second Chern Floquet Weyl charge`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/24h-publication-run-2026-07-12/LIT_SEARCH_LOG.md` [2026-07-11 16:05 PDT - changing-spacing R3 interpolation after D-R3-1]

Score: `0.815`

```text
higher-dimensional strong component; notation warning, Read's `R_1` is complex and `R_3` quaternionic. Bessho-Sato arXiv:2006.04204 supplement ties local Floquet charges to bulk topology with a dimension-dependent pi-gap sign. Higashikawa et al. arXiv:1806.06868 and Gupta-Short arXiv:2601.15885v2 retained as positive/escape controls. Composition, finite-rank stabilization, and sign conventions remain VERIFY. Full audit: `B_STRICT_LAURENT_SOURCE_AUDIT_2026-07-11.md`.
2026-07-11 17:04 PDT | Spark/Codex | Global chiral Floquet composition | Bessho-Sato arXiv:2006.04204v3 Theorems 2 and 3' are the closest primary-source loci for three-dimensional local Weyl charge and zero/pi Floquet bookkeeping; Read arXiv:1608.04696v3 remains the separate strict-Laurent stable obstruction. No single finite-rank theorem composes them. Spark report is a locator, not authority: its Read Eq. (64) `K0` discussion does not replace the direct `K1` audit. Full report: `SPARK_LIT_GLOBAL_CHIRAL_FLOQUET_2026-07-11.md`.

[2026-07-11] LIT sidecar: scanned local Neo4j+chunks + primary sources for 2006.04204, 1806.06868, 1705.08552, 1802.03910. Full-text chunks present only for 1802.03910. 0/pi sector split explicitly detailed in 2006.04204; ordered Pauli-product census match found only partially via directional factorized constructions (closest in 1802.03910), not exact theorem form. 16-crossing BCC+cube-corner cancellation appears novel at this architecture level.
2026-07-11 20:12 PDT | Codex direct fallback (Spark context failure) | reciprocal conditional shifts / paraunitary factorization / strict 3+1 successors | Cedzich-Geib-Werner Thm 2.1 makes shift-coin words complete for 1D banded walks; Gupta-Short 3+1 stationary-amplitude family still leaves two extraneous low-energy solutions; Arrighi-Nesme
```

### 2. `AgentTasks/24h-publication-run-2026-07-12/SPARK_LIT_GLOBAL_CHIRAL_FLOQUET_2026-07-11.md` [Literature sidecar — Global chirality-split Floquet/Unitary Bloch symbol, Weyl charge at 0/π, and total-charge sum rule]

Score: `0.814`

```text
# Literature sidecar — Global chirality-split Floquet/Unitary Bloch symbol, Weyl charge at 0/π, and total-charge sum rule

Scope
- Target: active 24h null-edge publication run (2026-07-11)
- Query: local Neo4j `Scripts/lit/neo4j_paper_search.py --chunks` plus arXiv full-text sources
- Constraint: no Lean/manuscript edits; preserve exact theorem/equation locations

Primary sources checked
1. arXiv:2006.04204v3 (Bessho-Sato), title: `Nielsen-Ninomiya Theorem with Bulk Topology: Duality in Floquet and Non-Hermitian Systems`
2. arXiv:1608.04696v3, title: `Compactly-supported Wannier functions and algebraic K-theory`

Local Neo4j + chunk search status
- `neo4j_paper_search.py --chunks --query 1608.04696v3` and `--chunks --query 2006.04204` returned `No full-text chunks for ...`.
- `python Scripts/lit/lit_ingest.py 2006.04204 1608.04696 --dry-run` indicates both IDs are not present in local index (would-add), so theorem/equation-level search cannot currently be satisfied from graph metadata.
- `neo4j_paper_search.py` results around related terms returned nearby graph artifacts (quantum walks/minimal doubling), but no direct chunk hits for these IDs.
```

### 3. `AgentTasks/24h-publication-run-2026-07-12/GRAND_STRATEGY6_REPORT.md` [R4 — external composition]

Score: `0.814`

```text
### R4 — external composition

- **Partial (source memo).** "Read's algebraic `K₁` calculation excludes a
  strong stable `K¹(T³)` component for complex Laurent automorphisms; composing
  it with the symmetry-resolved Floquet crossing-charge bookkeeping is the
  remaining mathematical gate. Source-supported; finite-rank stabilization and
  the 0/π sign convention are VERIFY, not kernel-checked here."
- **Full (only after full-text verification).** "For finite-range exactly
  unitary translation-invariant symbols admitting a constant Hermitian
  involution `Ξ` with `[U,Ξ]=0` everywhere, the total Weyl-sector charge
  vanishes in each quasienergy sector; no isolated single crossing exists — a
  discrete-time Nielsen–Ninomiya no-go for the globally chiral class. The
  escape class with quadratic `Ξ`-odd mixing is not covered."
- **Never write.** "Read + Bessho–Sato give a doubling theorem" (route to, not
  theorem), Read's `R_3` as "three-variable" (it is quaternionic), or any
  omission of the bulk dynamical invariant (refuted by the single-Weyl Floquet
  control), or the composite as a Lean assumption.

---
```

### 4. `AgentTasks/24h-publication-run-2026-07-12/SPARK_LIT_GLOBAL_CHIRAL_FLOQUET_2026-07-11.md` [(B) Core theorem/equation extraction: arXiv:1608.04696v3]

Score: `0.812`

```text
tion choices before downstream integration.

Applicability verdict
- Strongest direct source for (i)+(ii)+(iii): arXiv:2006.04204v3 Theorem 3' (+ eq:Thm2-1, eq:Thm2-2).
- Strongest support for strict finite-range polynomial assumption: arXiv:1608.04696v3 Eq. (64) decomposition theorem.
- Therefore the requested connection is presently split across two primary sources and not available as one theorem in one paper.

Smallest missing composition theorem (for null-edge write-up)
- A bridging theorem is missing that states, in one line: for finite-range chiral 3D Floquet Bloch symbols (Laurent polynomial/unitary map), the local Weyl crossing charges at quasienergy 0 and π obey the same signed zero-sum rule as the corresponding non-Floquet class from Bessho-Sato, with explicit conventions for chirality/orientation and strict finite-rank/finite-range hypotheses.
- In practical terms: compose `1608.04696v3` finite-range K-theoretic obstruction with `2006.04204v3` Theorem 2 / 3' hypotheses and convert the abstract winding/charge statements into chirality-resolved Bloch-Wannier invariants.

Recommended next actions
1. Ingest both arXiv IDs into Neo4j for chunk-backed theorem verification and reproducibility:
   `python Scripts/lit/lit_ingest.py 2006.04204 1608.04696`
2. Re-run targeted chunk search:
   `Scripts/lit/neo4j_paper_search.py --chunks --query "Theorem 3' eq:Thm2-1 eq:Thm2-2 2006.04204"`
3. Capture exact page/line locations for Eq. tags from the source files to allow theorem-level `applicable` metadata in task notes.

GeneratedBy: Codex literature sidecar (2026-07-11)
Status: completed; no Lean/manuscript edits.
```

### 5. `AgentTasks/24h-publication-run-2026-07-12/SPARK_LIT_MASSLESS_CROSSING_CENSUS_2026-07-11.md` [1) Bessho-Sato et al., arXiv:2006.04204]

Score: `0.810`

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

### 6. `AgentTasks/24h-publication-run-2026-07-12/GRAND_STRATEGY6_REPORT.md` [5.3 Floquet side — hypotheses (Bessho–Sato, arXiv:2006.04204, PRL 127, 196404)]

Score: `0.806`

```text
### 5.3 Floquet side — hypotheses (Bessho–Sato, arXiv:2006.04204, PRL 127, 196404)

- **Charge–bulk duality.** The sum of local gapless-mode charges equals a bulk
  dynamical topological invariant.
- **0/π branch convention (load-bearing).** A **dimension-dependent sign** is
  recorded for the quasienergy-`π` contribution; the exact `0` vs `π` sign
  convention must be copied verbatim from the displayed theorem before use.
- **Symmetry class (load-bearing).** The **class-A vs symmetry-protected** case
  must be fixed. R4 uses the `Ξ`-graded (chiral) case; the class-A neutral
  massive tangent (§0) is *outside* the charged sectors and must not be double
  counted.
- **Positive control.** Higashikawa–Nakagawa–Ueda (arXiv:1806.06868) realize a
  single Weyl fermion with a topologically nontrivial *Floquet* unitary — proof
  that the bulk invariant cannot simply be omitted (a naive
  "sum-of-local-charges = 0" without the bulk term is false).
- **Adversarial control.** Gupta–Short (arXiv:2601.15885v2) remove conventional
  doublers/pseudo-doublers but **retain residual low-energy solutions**; the
  census must determine whether their tangent (non-involutory, per
  `StationaryAmplitudeNoGo`), global chirality, or residual modes supply the
  compensating structure.
```

### 7. `AgentTasks/24h-publication-run-2026-07-12/GRAND_STRATEGY6_REPORT.md` [5.5 Nondegenerate fixture and killer counterexample]

Score: `0.803`

```text
### 5.5 Nondegenerate fixture and killer counterexample

- **Nondegenerate fixture.** The global-chirality gate is exact and kernel-true:
  `splitStep_commutes_iff_sin_theta_zero` — at `sin θ = 0` the ordered step
  satisfies `[U(q),Ξ]=0` at every momentum, with the commutator's matrix factor
  determinant-one everywhere (no momentum exception). This is a genuine instance
  of R4's global-chirality hypothesis, and R1 discharges its conclusion by
  enumeration for this instance.
- **Killer counterexample.** A **single Weyl fermion realized by a nontrivial
  Floquet unitary** (Higashikawa 1806.06868): if one *drops the bulk dynamical
  invariant* from the charge sum, R4's conclusion appears violated — this is the
  standing proof that the bulk term is mandatory and that "local charges sum to
  zero" cannot be asserted without it. Any R4 write-up omitting the bulk
  invariant is refuted by this construction.

---
```

### 8. `AgentTasks/24h-publication-run-2026-07-12/B_STRICT_LAURENT_SOURCE_AUDIT_2026-07-11.md` [Floquet charge bookkeeping]

Score: `0.803`

```text
## Floquet charge bookkeeping

Primary source: T. Bessho and M. Sato, "Nielsen-Ninomiya Theorem with Bulk
Topology: Duality in Floquet and Non-Hermitian Systems," arXiv:2006.04204,
Phys. Rev. Lett. 127, 196404 (2021), including the supplement.

The paper relates sums of local gapless-mode charges to a bulk dynamical
topological invariant and records a dimension-dependent sign for the
quasienergy-pi contribution. This supports the charge-sum architecture, but the
exact class-A versus symmetry-protected case and the zero/pi sign convention
must be copied from the displayed theorem before use in Paper B.

Controls:

- Higashikawa, Nakagawa, and Ueda, arXiv:1806.06868, explicitly realize a
  single Weyl fermion with a topologically nontrivial Floquet unitary. This is
  the positive control showing why the bulk invariant cannot simply be omitted.
- Gupta and Short, arXiv:2601.15885v2, explicitly report removal of conventional
  doublers and pseudo-doublers but retain additional low-energy solutions. The
  exact census must determine whether their tangent, global chirality, or
  residual modes supply the compensating structure.
```

## Scoped paper hits

### 1. Spin on a 4D Feynman Checkerboard

Score: `0.776`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 2. Bulk--Boundary Correspondence for Chiral Symmetric Quantum Walks

Score: `0.769`
Zotero key: `9QPIHJEW`
arXiv: `1303.1199`
DOI: `10.1103/PhysRevB.88.121406`
URL: http://arxiv.org/abs/1303.1199

Abstract:

Discrete-time quantum walks (DTQW) have topological phases that are richer than those of time-independent lattice Hamiltonians. Even the basic symmetries, on which the standard classification of topological insulators hinges, have not yet been properly defined for quantum walks. We introduce the key tool of timeframes, i.e., we describe a DTQW by the ensemble of time-shifted unitary timestep operators belonging to the walk. This gives us a way to consistently define chiral symmetry (CS) for DTQW's. We show that CS can be ensured by using an "inversion symmetric" pulse sequence. For one-dimensional DTQW's with CS, we identify the bulk ZxZ topological invariant that controls the number of topologically protected 0 and pi energy edge states at the interfaces between different domains, and give simple formulas for these invariants. We illustrate this bulk--boundary correspondence for DTQW's on the example of the "4-step quantum walk", where tuning CS and particle-hole symmetry realizes edge states in various symmetry classes.

### 3. Wilson loops in Ising lattice gauge theory

Score: `0.765`
Zotero key: `T2Z3STSB`
arXiv: `1811.09770`
URL: http://arxiv.org/abs/1811.09770

Abstract:

Wilson loop expectation in 4D $\mathbb{Z}_2$ lattice gauge theory is computed to leading order in the weak coupling regime. This is the first example of a rigorous theoretical calculation of Wilson loop expectation in the weak coupling regime of a 4D lattice gauge theory. All prior results are either inequalities or strong coupling expansions.

### 4. Eigenspectra of Minimally Doubled Fermions

Score: `0.765`
Zotero key: `W76MZM66`
arXiv: `2501.10336`
DOI: `10.22323/1.466.0355`
URL: http://arxiv.org/abs/2501.10336

Abstract:

In this work, we explored the eigenspectra of minimally doubled fermions, in both Karsten-Wilczek and Borici-Creutz realizations. We generated 4-dim $SU(3)$ gauge fields with a definite topological charge and calculated the chiralities of the eigenmodes for KW and BC fermions. We used the spectral flow of the eigenvalues for this purpose and demonstrated the Index theorem.

### 5. Index theorem with Minimally Doubled Fermions in four space-time dimensions

Score: `0.762`
Zotero key: `RCFWIVSS`
arXiv: `2602.19767`
URL: https://arxiv.org/abs/2602.19767

Abstract:

Determines the zero-eigenmode spectrum of minimally doubled fermions in Karsten-Wilczek and Borici-Creutz formulations on four-dimensional spacetime lattices with background gauge fields of integer topological charge. Uses flavored mass terms and modified chirality operators to detect topology and zero-mode chirality.
