# Strategy: close or bound the LAST MEMO piece of S1-CC (general-representative reduction)

STRATEGY + NO-GO job (a landed lemma is a bonus). Context in `src/`.

## Situation (finite mathematical-physics program: mass = obstruction to null transport)

The §6 closure-positivity crux (S1-CC) is now KERNEL-checked on an explicit `6×6`
Clifford⊗color witness (`src/S1CCPhysicalSectorWitness.lean`): the induced closure
form `J Q_C|V'/N` is balanced `(2,2,0)` (not positive), with the full Gauss-sector
construction (`ker`/`range` of `Q_G`, coset reps) kernel-checked. Exactly ONE piece
stays MEMO: the claim that *every* scalar-metric physical Gauss sector reduces to
this witness shape (the "general representative"). This is the last gap between
"no-go on the witness" and "no-go in general".

## Your task — close it or bound it precisely

1. **State the general reduction precisely.** For an arbitrary scalar-metric
   single-edge carrier with a Gauss constraint `Q_G` (nilpotent, `[G,K]=0`), the
   physical sector is `V'/N = ker Q_G / range Q_G`, and the induced closure form is
   the compression of `J Q_C = (skew)⊗K`. The witness took a *specific* `Q_G = c₁⊗G`
   with `G = diag(0,0,1)`. The general claim: for ANY such `Q_G` in the scalar-metric
   class, the compressed `J Q_C|V'/N` is *still balanced* (`n₊ = n₋`), by the same
   `b`-anticonjugation mechanism (`b` preserves the gauge sectors and anticonjugates
   `J Q_C`). State the exact hypotheses under which this holds.
2. **Prove it or give the sharpest partial.** Is the balance a GENERAL theorem for
   the scalar-metric class (because `b`-anticonjugation is structural, independent of
   which `Q_G`), or does it depend on the witness's specific coordinate alignment?
   The abstract engine `hermitian_balanced_count_of_neg_charpoly` needs only
   `b(JQc)b = -JQc` on the sector + nondegeneracy. So the real question is: does
   `b`-anticonjugation SURVIVE the compression to `V'/N` for a general `Q_G`, given
   `b` preserves `ker Q_G` and `range Q_G`? If yes, deliver the general lemma (the
   compression inherits anticonjugation ⇒ balanced) - this would upgrade the WHOLE
   crux from "witness M" to "general M". If it depends on specifics, give the exact
   dependency.
3. **No-go honesty.** Could positivity SURVIVE for some scalar-metric `Q_G` not of
   the witness form (breaking the general no-go)? Give the strongest argument either
   way. If the general reduction is genuinely open/false, say exactly why and what
   the honest boundary is.

Output: the general reduction statement; a proof/sharpest-partial (Lean if cheap -
e.g. "b preserves ker/range Q_G ⇒ compression inherits b-anticonjugation ⇒
balanced", abstractly); the no-go honesty. Upgrading witness→general is the prize;
a precise boundary is also high-value.
