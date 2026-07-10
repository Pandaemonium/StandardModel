# Adversarial over-claim audit — S1-CC witness→general reduction, batch 5

AUDIT job (no proof required). `src/` has verbatim Lean files from a finite
mathematical-physics program (mass = obstruction to null transport). The kernel
guarantees the proofs; it does NOT guarantee the statements/docstrings are the
intended mathematics, nor that a "general" theorem is genuinely general rather
than vacuous or hollow. You are blind to the wider repo — judge only what is here.

## Background claim being made (in the manuscript, which you cannot see)

The program's central crux is: the "closure Krein form" `M = J Q_C` is **not**
positive on the physical Gauss sector `V'/N = ker Q_G / range Q_G` — it is
*balanced* (equal positive/negative eigenvalue counts). This was first proved on
an explicit `6×6` Clifford⊗color witness. The manuscript now claims this has been
**upgraded from a witness result (grade M) + "general representative" prose
(grade MEMO) to a general kernel theorem (grade M)**, with the ONLY remaining gap
being the *existence* of a `b`-eigenbasis of the physical sector. Your job is to
decide whether that upgrade claim is honest.

## Files and what to probe

- `S1CCGeneralReduction.lean` — the core. Probe HARD:
  - `compression_balanced`: for any `r : κ → ι` and `±1` grading `d`
    anticonjugating `J`, `J.submatrix r r` is balanced. Is this **vacuous**? E.g.
    does the anticonjugation hypothesis `diagonal d * J * diagonal d = -J` force
    `J` (or the compression) to be so special that "balanced" is trivial? Is the
    conclusion `card(pos) = card(neg)` genuine, or satisfiable by a zero/empty
    matrix regardless? Is there any hidden dependence that makes `Q_G`
    "irrelevance" illusory?
  - `compression_balanced_eigbasis`: claims to DROP coordinate alignment —
    compression by ANY `b`-eigenvector family `P` (`diagonal d * P = P * diagonal e`).
    Is this a genuine strengthening of `compression_balanced`, or does the
    hypothesis `diagonal d * P = P * diagonal e` + `hB : (Pᴴ M P).IsHermitian`
    secretly restrict `P` back to (a relabelling of) coordinate injections? Does
    the proof actually use full generality of `P`, or would it only be sound for
    `P` a submatrix? Check the `diagonal_pm1_conjTranspose` helper and the
    `hLeft`/`hAnti` chain for a sign or transpose slip.
  - `compression_has_neg_eigenvalue`: nondegeneracy ⇒ a negative eigenvalue.
    Genuine, or does `IsUnit det` + balance make it circular?
- `S1CCWitnessAsInstance.lean` — `witness_balanced_via_general` claims the `6×6`
  witness `(2,2,·)` count is a literal INSTANCE of `compression_balanced`. Is it
  really the same theorem specialized (so the witness is genuinely not special to
  its coordinates), or is `bg_eq_diagonal`/`dWitness` quietly re-deriving the
  witness by hand? Does the instance actually feed the witness's own
  `bg_anticonj`?
- `S1CCPresentationExistence.lean` — the frontier. This has a documented `sorry`
  (`physical_sector_b_eigenbasis_exists`) and a `prize` theorem
  `physical_sector_balanced` proved MODULO it. **Two critical honesty checks:**
  1. Is `physical_sector_balanced`'s reduction to `compression_balanced_eigbasis`
     sound, or does the glue smuggle the conclusion?
  2. **The labeled gap.** The manuscript says "only the *existence* of the
     `b`-eigenbasis stays MEMO". But note `physical_sector_b_eigenbasis_exists`
     as stated only asks `P`'s columns lie in `ker Q_G` (`QG * P = 0`),
     orthonormal, `b`-eigenvectors — it does **not** pin `range P` to a
     *complement of `range Q_G`* in `ker Q_G`. So `physical_sector_balanced` as
     stated proves balance on (a `b`-eigen-subspace of) `ker Q_G`, NOT manifestly
     on the quotient `V'/N = ker Q_G / range Q_G`. **Is the manuscript's claim
     "the crux closes to general M once existence is transcribed" therefore an
     over-claim?** Specifically: is "balanced on `ker Q_G`" the same as "balanced
     on `V'/N`", or could `range Q_G` (the null/gauge directions) carry
     eigenvalues that change the count between `ker Q_G` and the quotient? State
     precisely what is and isn't captured, and whether the honest remaining gap is
     "existence on `ker Q_G`" (weaker) or "existence of a `V'/N`-complement basis"
     (stronger) — and whether the manuscript should say so.

## Output format

For each theorem: name, one-line quote of what it claims, classification
(vacuity / hollow-telescoping / docstring-outruns-kernel / false-shape / CLEAN),
verdict CLEAN / MINOR / LOAD-BEARING, and for anything not CLEAN the exact
mismatch + a concrete remedy. Then: THE single most load-bearing finding (if any).
The `ker Q_G` vs `V'/N` question above is the one I most want a sharp ruling on.
One correct load-bearing finding beats ten generic cautions. If it's all honest,
say so and state exactly what you verified.
