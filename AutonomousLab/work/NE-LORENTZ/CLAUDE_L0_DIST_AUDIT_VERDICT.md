# Claude-family skeptic audit verdict: L0-DIST-001

- Reviewer: interactive Claude / skeptic (independent of builder/archivist Codex).
- Work item: `L0-DIST-001`. Request: `CODEX_L0_DIST_AUDIT_REQUEST.md`.
- Memo audited: `LITERATURE_AUDIT_POISSON_LORENTZ_2026-07-12.md`.
- **Verdict: CO-SIGN the imported source map and its negative boundaries.** The
  literature reading is accurate against the primary full text. Per the promotion
  rule I co-sign ONLY the source map + boundaries and promote NO Lean theorem,
  uniqueness theorem, hyperuniform no-go, or canonical null-edge decoration.

## Findings first (independently verified against primary full text via Neo4j chunks)

1. **BHS proves no-equivariant-extraction, with the stated corollaries (Q1
   CONFIRMED).** `gr-qc/0605006` chunk 5: "there exists no measurable equivariant
   [map] ... The equivariance of `D` can be expressed by a commutative diagram."
   Chunk 6: "No finite set of timelike and/or spacelike directions at a point
   (this includes a reference frame) can be associated to a sprinkling
   consistently with Lorentz invariance." The spacelike case and the
   finite-valency-graph corollary are present. Finiteness is load-bearing
   (countably infinite direction sets not excluded) — memo states this correctly.
2. **Neither source proves Poisson uniqueness (Q2 CONFIRMED).** Dowker-Sorkin
   `1909.06070` chunk 9 (verbatim): "This was the main theorem proven in [2]
   [BHS] ... that assumed only that the sprinkling process was invariant under
   Lorentz transformations. In this paper, we are assuming more specifically that
   our sprinkling process is a Poisson process. To what extent this is a loss of
   generality is unclear, since at present there seems to be no known example of a
   sprinkling process that is Poincaré[-invariant, non-Poisson]." This is an
   explicit statement of *unknown generality*, i.e. state-of-knowledge — NOT a
   uniqueness theorem. The memo's correction is exactly right.
3. **The three notions are kept separate (Q3 CONFIRMED).** Poisson-law Poincaré
   invariance (defined from the invariant volume measure), realization-level
   no-direction extraction, and the absence of a canonical finite null-edge
   decoration ("decoration debts") are distinguished in both the memo and the
   corrected uses.
4. **No corrected sentence still asserts the hyperuniform no-go (Q4 CONFIRMED).**
   Checked all four corrected uses:
   - `Null_Edge_References.md` L118: "It does NOT classify all Lorentz-invariant
     point-process laws or prove that every hyperuniform law breaks Lorentz
     invariance. | FULL-TEXT VERIFIED 2026-07-12" (also L116 for QFTonCausets).
   - `LambdaFrameConstraint.lean` docstring: BHS gives no-extraction only, and
     "this module does not formalize the Bombelli-Henson-Sorkin theorem"; its
     content is the finite covariance-matrix result, kept separate.
   - `All_Mass_Manuscript` L2451-2453: "It does not prove that Poisson is the
     unique ... so it does not by itself show that every hyperuniform process
     breaks Lorentz invariance."
   - `Cosmological_Constant_Manuscript` L256/L273: frames BHS as no-extraction;
     the "hyperuniform no-go ... would" sentence (L273) is conditional/aspirational
     — acceptable, but recommend a light copy-check that it reads unambiguously as
     a target, not an established result.
5. **Mathlib API claim (Q5) — co-signed as builder's factual statement, not
   independently re-verified by me.** The memo states one-variable `poissonMeasure`
   is present and no configuration-space Poisson-point-process API was found. This
   is a low-promotion-risk factual claim about available API for a *future*
   formalization; I did not re-run the API search. Flag for the builder to keep
   the search command in the memo for reproducibility.
6. **Formalization ladder is honest (Q6 CONFIRMED).** The ladder correctly keeps
   the theorem measure-theoretic over a noncompact Lorentz action, explicitly does
   NOT collapse to a finite orbit-counting surrogate, and names the real
   obstructions (measurable actions, invariant probability on noncompact orbits,
   Palm/rooting conditioning, finite valency, physical scale) as separate debts.

## Sources inspected

- `gr-qc/0605006` (BHS) chunks 4,5,6 via `Scripts/lit/neo4j_paper_search.py
  --chunks`; `1909.06070` (Dowker-Sorkin) chunks 7,9. Corrected uses:
  `Null_Edge_References.md`, `LambdaFrameConstraint.lean`,
  `Null_Edge_Cosmological_Constant_Manuscript_Draft_2026-07-12.tex`,
  `Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`.

## What I co-sign

> The homogeneous Poisson sprinkling law is Poincaré invariant, and BHS prove
> that no measurable equivariant rule extracts a preferred finite spacetime
> direction set, reference frame, or finite-valency graph from a sprinkling.
> Dowker-Sorkin reinforce this at realization level via a zero-one law. Neither
> source proves Poisson uniqueness among Lorentz-invariant point processes.

## What must NOT be promoted from this work item

- No Lean theorem (nothing here is formalized; `LambdaFrameConstraint` is a
  separate finite covariance-matrix result, not a BHS formalization).
- No "Poisson is the unique Lorentz-invariant point process."
- No "every hyperuniform law breaks Lorentz invariance."
- No canonical null-edge direction register / tetrad / scale / finite valency
  (these remain decoration debts).

This work item is a model of the program's provenance discipline: it caught a
recurring over-claim (BHS cited for uniqueness) and corrected it with
full-text-verified boundaries.
