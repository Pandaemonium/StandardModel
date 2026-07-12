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

## (A) Core theorem/equation extraction: arXiv:2006.04204v3
- Most directly applicable primary source for the 0/π and chiral-split Floquet counting target.
- Extracted theorem blocks and equation tags:
  - Theorem 1 (1D non-Hermitian): Eq. tag `eq:1dENN`
  - Theorem 1' (1D Floquet): Eq. tag `eq:1dNNFloquet`
  - Theorem 2 (3D non-Hermitian Weyl case, winding form): Eq. tag `eq:w3`
  - Theorem 3 (point-gapped non-Hermitian classes): Eq. tags around `eq:Thm1`
  - Theorem 3' (periodically driven counterpart): Eq. tags `eq:Thm2-1`, `eq:Thm2-2`
  - Supplemental parity forms: `Theorem'` with `eq:SThm1'even`, `eq:SThm1'odd`, and Corollary `eq:SCorollary`
- Relevance:
  - `Theorem 3'` gives the explicit Floquet branch-sum relation with 0/π sectors separated by periodic-drive structure and parity/sign structure (`-(-1)^d` appears in the text), matching criterion (iii) most directly.
  - `Theorem 2` is the 3D Weyl-type case tying local chiral charge data to a bulk invariant, relevant to criterion (ii).
  - `Theorem 1'/Theorem 3'` are the main 0/π split references for chiral-Floquet context.

## (B) Core theorem/equation extraction: arXiv:1608.04696v3
- Relevant strict-finite-range statement at Eq. (64) (compactly-supported/Wannier/algebraic bundle context):
  - `K0(ϕ(d)_p) ≃ K0(ϕ(0)_p) ⊕_d [K0(ϕ(1)_p) / K0(ϕ(0)_p)]`
- Relevance:
  - This gives the stable-vs-finite-rank distinction for Laurent-polynomial symbol models versus continuous map formulations.
  - Supports separating strict finite-range/unitary-polynomial symbols from continuous maps in your requested mapping (criterion i).

Distinctions requested by user
- continuous maps vs strict Laurent polynomial unitaries:
  - 2006.04204v3 works in driven/operator/topological framework with periodic unitaries and chiral sectors but does not itself provide the same strict polynomial-module obstruction structure.
  - 1608.04696v3 provides the strict-module/K-theory obstruction needed to formalize this distinction.
- stable vs finite-rank:
  - 1608.04696v3 is explicit on stable equivalence classes and finite-rank realizability obstructions.
  - 2006.04204v3 mainly gives homotopy/topological index statements in the dynamical/point-gap setting (strongly suggestive but not itself a finite-support finiteness theorem).
- class A vs chiral symmetry:
  - 2006.04204 includes non-chiral/chiral distinctions across theorem variants (e.g., 3' and parity forms), with chiral split language entering through mode counting and branch-point parity.
- 0-vs-π sign conventions:
  - In 2006.04204, 0/π split appears through the Floquet-periodic theorem set and the explicit sign/(-1)^d factor in Theorem 3', which is the place to pin convention choices before downstream integration.

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
