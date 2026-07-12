# Massless Weyl/Dirac DTQW Crossing Census (24h Publication Run)

Date: 2026-07-11 (Sunday)
Run: AgentTasks/24h-publication-run-2026-07-12
Scope: local Neo4j chunk-first search plus primary full text; focused on exact architecture `exp(-iqx σx) exp(-iqy σy) exp(-iqz σz)`, cube-corner and body-centered cube-crossings, quasienergy 0/π Jacobian-charge sums.

## Search and index status
- Neo4j DB used: `coglab` at `neo4j://127.0.0.1:7687`.
- `lit_fulltext` dry-run IDs: `2006.04204`, `1806.06868`, `1705.08552`, `1802.03910`.
- Full-text chunks were discoverable only for `1802.03910` via local Neo4j/`--chunks` path.
- For `2006.04204`, `1806.06868`, `1705.08552`, local Neo4j returned paper metadata/abstract-level search hits but no full-text chunk coverage.
- A full-text/keyword query for Weyl/Floquet crossing census (`"Weyl points Floquet quantum walk quasi-energy"`) returned mostly 1D/topological DTQW papers plus secondary adjacency around `1802.03910`; no high-confidence local chunk evidence for a full 0/π crossing census in the 2006/1806/1705 cohort.

## Paper-by-paper extraction

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

### 3) D’Ariano et al., arXiv:1705.08552
Primary source: `weyl-3d-rsta-16.tex` (arXiv mirror via ar5iv/local temp cache), and arXiv/ARXIV entry `arXiv:1705.08552`.
- Theorem/equation loci:
  - General body-centered cubic (BCC) Cayley graph walk: `W = Σ_{h∈S} T_h ⊗ A_h` (coin transition matrices). This is the core algebraic architecture used to classify discrete-time Weyl QWs in 3D with symmetries.
  - Path-sum/binary encoding formulas for amplitudes and transition compositions are explicit.
- Applicability to requested census:
  - Low for exact ordered Pauli-product match. This is structurally BCC/coin-Cayley, not an ordered continuous-variable Pauli exponential product.
  - Relevant to lattice-type census (BCC) and symmetry constraints, but not to direct 0/π Jacobian-charge sum formula in the requested closed ordered-product notation.
- Conventions of note:
  - Lattice-generator labeling and BCC edge conventions are explicit and distinct from cubic-corner momentum-parametrized Pauli product models.

### 4) Mlodinow-Brun (associated arXiv:1802.03910)
Primary source: `1802.03910.tex` and local Neo4j chunks.
- Theorem/equation loci:
  - Abstract states the walk as product of 1D-like coin operations on 3D links.
  - Eq. (22): explicit one-step operator decomposition into three directional sub-operators.
  - Eq. (23): equivalent reordered form with all coin factors moved to a canonical side.
  - Discussion identifies BCC lattice geometry and the Weyl/Dirac limiting regimes.
- Applicability to requested census:
  - Medium for ordered-product match (it is a factorized directional product, nearest in spirit to `exp(-iqx σx) exp(-iqy σy) exp(-iqz σz)` but written in coined-shift operator notation, with projectors/coins rather than literal Pauli exponentials).
  - Low for explicit 0/π split in Jacobian-charge sums.
- Conventions of note:
  - Uses BCC step ordering and 1D-inspired coin decomposition; crossing counting is derived geometrically from that factorization rather than the specific Floquet 0/π chiral census used by Bessho.

## Direct correspondence to requested architecture
- Exact `exp(-iqx σx) exp(-iqy σy) exp(-iqz σz)` match: none of the four primary sources expresses crossings exactly in that single normal form as the principal global theorem statement.
- Closest analog: Mlodinow-Brun gives the clearest directional ordered 1D-inspired product form; Bessho and Higashikawa give structurally related but conventionally different Floquet/split-step decompositions; D’Ariano is group/Cayley-based BCC with `Σ_h T_h ⊗ A_h` form.
- Implication: your requested “ordered Pauli exponential census” appears to be a narrower target not yet explicitly isolated in these exact papers; crosswalks likely require a convention-translation lemma from each paper’s step-gate basis.

## Cube-corner + body-center crossings and 16-crossing cancellation
- Confirmed local/primary evidence for BCC structure with directional factorization and Weyl-node discussion is strongest in Mlodinow-Brun and D’Ariano.
- 16-crossing cube-corner + BCC cancellation pattern: not explicitly presented as a canonical theorem in the sources above.
- Novelty assessment: no direct prior statement of a 16-crossing `0/π` Jacobian-charge census over the exact combined architecture was found; if your claim refers to this specific combined ordered-Pauli, cube-corner-plus-BCC, 0/π-differentiated charge census, it looks novel relative to these four anchors.
- What is already known/established:
  - Floquet Weyl-node counting and quasienergy branch splitting are established (notably in Bessho).
  - Ordered directional factorized 3D walk products on BCC and Weyl/Dirac limits are established (D’Ariano, Higashikawa, Mlodinow-Brun).
  - Their conventions do not coincide in gates, momentum parameterization, quasienergy branch choice, nor crossing-normal form.

## Exact applicability summary
- Established directly: Floquet 0/π quasienergy partition and chiral charge methodology (arXiv:2006.04204).
- Established directly: 3D single-/multi-Weyl crossing characterization in coined/split-step and BCC architectures (arXiv:1806.06868, arXiv:1705.08552, 1802.03910).
- Not directly established as requested: a single unified theorem giving a literal ordered Pauli-exponential cube-corner + body-center census with explicit separate 0/π Jacobian sums in the exact notation `exp(-iqx σx) exp(-iqy σy) exp(-iqz σz)`.
- Recommended next step for a rigorous citation chain: perform notation translation to a common Bloch-form convention and check whether the 16-node set can be mapped to the exact same branch choices as Bessho’s `C^+`/`C^-` contributions.
