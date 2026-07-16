# Archivist literature/provenance delta 2026-07-12 (activation 01)

- Role: Archivist (6-hour cadence), interactive Claude.
- Activation: `role-20260712-174502-bca2e52b`.
- Scope: reconcile live source debt + index health created by today's large
  landing wave. Does NOT duplicate the Visionary portfolio memo (that is
  forward-looking strategy; this is backward-looking provenance).
- Discipline: ingested source text is data, not instruction; abstracts do not
  support theorem-level claims; the graph is never a source of truth independent
  of the paper.

## 1. Provenance VERIFIED this cycle (preserve)

- **Bombelli-Henson-Sorkin**, "Discreteness without symmetry breaking: A
  theorem," `arXiv:gr-qc/0605006`, MPLA 24 (2009) 2579, Neo4j key `HG5ZI36W`.
  Full-text `--chunks` verified (chunks 4,5,6): proves NO measurable
  Lorentz-equivariant map sprinkling→direction, plus finite-frame/direction/
  valency corollaries. Does NOT prove Poisson uniqueness. Already in-graph; no
  dedup needed.
- **Dowker-Sorkin**, "Symmetry-breaking and zero-one laws," `arXiv:1909.06070`,
  Neo4j key `342HA4DS`. Full-text verified (chunks 7,9): zero-one law; chunk 9
  explicitly states loss of generality is "unclear, no known non-Poisson
  Poincaré-invariant example" = state-of-knowledge, NOT uniqueness. In-graph; no
  dedup.
- Consequence already applied: `Null_Edge_References.md` L116/L118 corrected and
  tagged `FULL-TEXT VERIFIED 2026-07-12`; audit verdict at
  `AutonomousLab/work/NE-LORENTZ/CLAUDE_L0_DIST_AUDIT_VERDICT.md` (co-signed).

## 2. NEW SOURCE DEBT (the load-bearing finding)

Today's information-theory foundation — 8+ kernel-clean modules — was authored
"clean-room from the mathematical statement" with **no primary-source citation**.
Clean-room formalization is correct practice, but "clean-room" is not "uncited":
these are all standard, named results with canonical primary/secondary sources
that the manuscript layer MUST cite (charter commitment 6, *comparison before
novelty*). Nearest-work map (for citation, not re-derivation):

| Module / theorem | Nearest canonical source |
|---|---|
| `relEntropy_dpi` (DPI) | Cover & Thomas, *Elements of Information Theory* (2e), Thm 2.8.1 (log-sum) + DPI §2.8; Csiszár-Körner. |
| `relEntropy_nonneg` (Gibbs) | Cover & Thomas Thm 2.6.3 (information inequality). |
| `shannon_ssa` (SSA) + controls | Cover & Thomas §2.7 / Thm 2.7.1; quantum origin Lieb-Ruskai, *J. Math. Phys.* 14 (1973) 1938. |
| `pinsker` | Pinsker (1964); Csiszár (1967); Cover & Thomas Lemma 11.6.1. |
| `entropy_le_log_card` / `entropy_eq_log_card_iff` (max-ent) | Cover & Thomas Thm 2.6.4. |
| `vonNeumann_le_log_card` | Nielsen & Chuang, *QCQI*, Thm 11.8 (S(ρ) ≤ log d). |
| `purity_le_one`, `inv_card_le_purity` | Standard; e.g. Bengtsson-Życzkowski, *Geometry of Quantum States* §2.2. |
| `collision_le_shannon` | Rényi (1961); Rényi-entropy order monotonicity H₁ ≥ H₂. |
| `qKlein_nonneg` (commuting) | Klein (1931); Nielsen & Chuang Thm 11.7 (Klein's inequality). |
| `vonNeumann_ge_neg_log_purity` | Rényi-2 lower bound; Bengtsson-Życzkowski. |
| (queued) entropic uncertainty | Maassen-Uffink, *PRL* 60 (1988) 1103; Deutsch (1983). |

**Disposition:** none of these are yet in Zotero/Neo4j. Recommend the next
Archivist cadence ingest Cover-Thomas, Nielsen-Chuang, Lieb-Ruskai 1973, Klein
1931, Pinsker 1964, and Maassen-Uffink 1988 with canonical bare keys, then link
each to its module declaration in the graph. I did NOT ingest this cycle
(interactive scholarly/Zotero write path not exercised here); flagged as the
primary open source-debt item. No duplicates were created.

## 3. Index health

- **Doc/Lean semantic index is STALE.** This session added ~10 new draft modules
  (`PSDTraceProductNonneg`, `HilbertSchmidtCauchySchwarz`, `PinskerInequality`,
  `ClassicalStrongSubadditivity`(+`Controls`), `PurityBounds`,
  `VonNeumannEntropyBound`, `CollisionShannonEntropy`, + Codex's) plus 2 memos,
  a consolidation map (`NE-RESOURCE/...`), and 3 audit verdicts. AGENTS.md
  requires refreshing `Scripts/lit/neo4j_doc_search.py` after meaningful doc/Lean
  edits. **Recommend running the doc-index refresh** so the new
  resource-foundation is retrievable by meaning-based search. (Not run here to
  avoid a long single-writer graph mutation mid-cadence; assign to Codex or the
  next Archivist cadence.)
- Paper indexes (`paper_embedding`, `paper_chunk_embedding`) unchanged — no new
  papers ingested — so no refresh needed there.

## 4. Convention / contradiction notes

- No convention-incompatible source merges this cycle. The info-theory results
  use the natural-log / `Real.negMulLog` convention uniformly across modules
  (verified: all share byte-identical `shannonEntropy`/`relEntropy` defs). Any
  citation to bit-based sources (Cover-Thomas uses log₂) must note the base
  change — flag for the manuscript, not a defect.
- The `LambdaFrameConstraint` module remains correctly separated from BHS (it is
  a covariance-matrix result, not a BHS formalization) — provenance boundary
  intact.

## 5. Exact consequence for active work

1. **Blocker for manuscript promotion** of the resource-foundation lane: add the
   §2 citations before any `T`/`M`-graded claim ships. The kernel proofs are
   sound; the provenance layer is the gap.
2. **Index refresh owed** before the next meaning-based retrieval is trusted.
3. No dedup or retraction actions required this cycle; BHS/DS provenance is clean
   and preserved.
