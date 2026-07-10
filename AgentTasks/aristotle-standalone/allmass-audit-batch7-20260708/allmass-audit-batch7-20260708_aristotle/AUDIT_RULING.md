# S1-CC presentation-existence — semantic-alignment ruling (call-10)

Adversarial review of `src/S1CCPresentationExistence.lean` (+ its dependencies
`S1CCEigenbasis`, `S1CCGeneralReduction`, `S1CCBalancedInertia`). Build verified
kernel-clean; every listed theorem's `#print axioms` pins `[propext,
Classical.choice, Quot.sound]`; no `sorry`/`axiom`/`@[implemented_by]` in code.

## Overall verdict

**CLEAN**, after one trivial statement fix that has been applied.

The mathematics is genuinely non-degenerate and the dimension count is correct.
The *only* defect was presentation-level: the exported `physical_sector_balanced`
dropped the dimension clause and was therefore cheaply satisfiable on its own, so
citing it (rather than the pair of theorems) as the full-sector prize would have
been an over-claim. The dimension clause was already in scope in the proof; it has
now been added to the exported statement, closing the gap in a single theorem.

## Q1 — Is `physical_sector_b_eigenbasis_exists` genuinely non-degenerate? YES.

- **Hermiticity is gone.** Hypotheses are only: `d` a ±1 grading, `QG*QG=0`
  (nilpotent), `diagonal d * QG = QG * diagonal d` (commutes with grading). The
  old `QG.IsHermitian ∧ QG²=0 ⇒ QG=0` collapse cannot occur.
- **Hypotheses admit a nonzero `QG` (checked in Lean):** e.g. `d ≡ 1`,
  `QG = !![0,1;0,0]` gives `QG≠0`, `QG²=0`, and commutes with `diagonal d = 1`.
  So the "sector" is *not* forced to the whole carrier — the exact defect of the
  first two iterations is absent.
- **The conclusion genuinely pins `P` to `V'/N`.** It is not vacuous: it carries
  (i) `±1` eigen-intertwining `diagonal d * P = P * diagonal e`; (ii) `QG*P=0`
  (columns in `ker QG`); (iii) `card κ = card ι − 2·QG.rank`; (iv) a left inverse
  `L*P=1` (⇒ columns linearly independent); (v) complementarity `∀ v, QG*ᵥv=0 →
  ∃ w z, v = P*ᵥw + QG*ᵥz`. Clauses (ii)+(iv)+(v)+(iii) together force
  `span(cols P)` to be a genuine direct complement of `range QG` inside `ker QG`
  (the dimension count rules out any nonzero `span P ∩ range QG`). This *is* a
  presentation of the quotient `ker QG / range QG`.

No residual vacuity or hidden degeneracy.

## Q2 — Is `card κ = card ι − 2·rank QG` the right count for `dim(ker/range)`? YES.

Since `QG²=0` gives `range QG ⊆ ker QG`, and by rank–nullity
`dim(ker QG) = card ι − rank`:
`dim(ker/range) = dim ker − dim range = (card ι − rank) − rank = card ι − 2·rank`.

The Lean proof establishes it as the *additive* identity
`card κ + 2·finrank(range φ) = finrank V` (in `eigenbasis_core`) and only then
converts to ℕ-subtraction via `eq_tsub_of_add_eq`. Truncated `Nat` subtraction is
**not** a hazard here: `range ⊆ ker` gives `rank ≤ card ι − rank`, i.e.
`2·rank ≤ card ι`, so the subtraction is exact. `QG.rank` is `finrank` of the
range of `mulVecLin QG`, and `card ι = finrank (ι→ℂ)`, so the matrix-level
identity matches the linear-map-level one. **Confirmed.**

## Q3 — `physical_sector_balanced` scope: over-claim, now fixed.

- **Standalone, the OLD exported `∃` was cheaply satisfiable (checked in Lean).**
  An empty `κ` satisfies `QG*P=0`, `∃L, L*P=1` (the `0×0` identity), and the
  balance `0=0`. So, on its own, the old statement said only "*some* lin.-indep.
  `b`-adapted `P` in `ker QG` has balanced `PᴴMP`" — it did **not** guarantee the
  full sector. Citing it alone for the full-`V'/N` prize would have been an
  over-claim.
- The dimension pin lived only in `physical_sector_b_eigenbasis_exists`. The
  balance lemma's proof *builds the same full-dimensional `P`* from that lemma
  (the `card` clause was literally in scope, destructured and discarded as `_`),
  but the exported statement threw it away, so the "same `P`" link was not
  machine-guaranteed to a reader who used only `physical_sector_balanced`.
- **Remedy (applied):** the `card κ = card ι − 2·QG.rank` clause was added to
  `physical_sector_balanced`'s conclusion (captured from the already-available
  hypothesis; no new proof work, axiom pins unchanged, build clean). Now a
  *single* theorem certifies: there is a linearly independent, `b`-adapted `P` in
  `ker QG` of the **full** physical dimension whose closure-form compression
  `PᴴMP` is balanced. This removes the over-claim; the split-citation is no longer
  load-bearing.

## Q4 — Abstract argument (`S1CCEigenbasis`): sound.

`eigenbasis_core` is applied with `β = mulVecLin (diagonal d)`,
`φ = mulVecLin QG`. Involution `β∘β=id` from `(diagonal d)²=1`; nilpotency
`φ∘φ=0` from `QG*QG=0`; commutation from `hbQG` — all discharged via `mulVecLin`
being a ring/`ℂ`-algebra hom, which is faithful (`mulVec_injective_iff`,
`toLin'` injectivity are used to transport left-inverse/independence back to
matrices). `range φ ⊆ ker φ`, both `β`-invariant, and `β` splits a complement
along its ±1 eigenspaces (`involution_isCompl_eigenspaces`,
`invariant_eigen_sup`, `exists_relCompl`); the finrank bookkeeping reduces to
`finrank_range_add_finrank_ker`. No gap between the abstract lemma and the matrix
application.

## Q5 — Docstring vs kernel: aligned (after fix).

The existence lemma's docstring claims exactly what the statement proves ("`P`
genuinely presents `V'/N`"), matching clauses (i)–(v). The one place the prose
outran the kernel was `physical_sector_balanced` calling `PᴴMP` "the induced form
on the physical Gauss sector" while the statement omitted the dimension pin; the
added clause + updated docstring now make prose and kernel agree. (Minor, non-
semantic: several `simp` calls carry unused arguments — linter warnings only.)

## Bottom line

The crux is **honestly closable to M**. As originally exported there was a real
(minor) over-claim in `physical_sector_balanced`; with the dimension clause now
carried by that same theorem, the full-`V'/N` balanced-presentation result is
certified by a single kernel-checked statement with the correct, non-degenerate
content.
