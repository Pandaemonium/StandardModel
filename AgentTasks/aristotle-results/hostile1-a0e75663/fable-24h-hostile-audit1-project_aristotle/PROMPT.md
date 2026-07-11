# Hostile referee audit: Paper C manuscript vs its Lean anchors (24h run)

ADVERSARIAL REVIEW ONLY - no proofs, no edits. You are a hostile referee
for a rigorous mathematical-physics venue (Quantum / SciPost-level), with
formalization expertise. The packet contains the CURRENT Paper C
manuscript (Null_Edge_HalfWinding_Defect_Paper_Draft_2026-07-11.tex) and
four of its newest Lean anchors.

Deliverable: HOSTILE_REVIEW.md with numbered findings, each graded
FATAL / MAJOR / MINOR / NITPICK, quoting the exact manuscript sentence
and the exact Lean statement (or its absence).

Attack surfaces, in order:
1. CLAIM-ANCHOR MISMATCH: every theorem environment and every
   Kernel/Kernel+Eval marker in the manuscript - does the named Lean
   declaration exist in the packet (or is it plausibly in the landed
   modules referenced) and does it state what the prose says? Flag any
   prose exceeding the statement (especially: any "iff"/"exactly
   when"/"classifies" phrasing where the Lean gives only sufficiency;
   any all-theta phrasing anchored to fixed-angle native_decide
   fixtures; any "every index" phrasing beyond translation-invariant
   functions).
2. TRUST-LABEL ACCURACY: Kernel vs Kernel+Eval markers vs the actual
   axiom footprints and my provenance notes; the census and
   splitting-law sentences must be visibly oracle-grade.
3. NOVELTY HONESTY: the imported-vs-claimed split (chiral-walk
   classification imported; what exactly is claimed as new) - would a
   Cedzich-school referee accept the framing? Is the strictly-finer
   framing (translation-invariant quantification + parenthetical about
   CGGSVWZ) airtight?
4. INTERNAL CONSISTENCY: abstract vs body vs appendix module list;
   theorem numbering; every module named in the appendix actually
   cited in the body.
5. THE FIVE WORST SENTENCES: list them verbatim with a one-line fix
   each.
Also: sanity-check the four Lean files for statement-level red flags a
referee could find (vacuous hypotheses, trivial corollaries presented
as content, witnesses reused as controls).
