# Summary of changes for run 526ab0ce-2616-47dd-8844-00222f894f2c
Adversarial semantic-alignment audit of the S1-CC presentation-existence crux. Verified the project builds kernel-clean, contains no `sorry`/`axiom`/`@[implemented_by]`, and that all cited theorems pin axioms `[propext, Classical.choice, Quot.sound]`. Full write-up in `AUDIT_RULING.md`.

RULING: CLEAN — after one trivial, applied statement fix. Details:

Q1 (non-degeneracy): GENUINE. Hermiticity is dropped; hypotheses are only ±1 grading `d`, `QG*QG=0`, and `[diagonal d, QG]=0`. I confirmed in Lean that these admit a nonzero nilpotent `QG` (e.g. `d≡1`, `QG=!![0,1;0,0]`), so the old `Hermitian∧nilpotent ⇒ QG=0` collapse (the defect of the first two iterations) cannot recur. The conclusion is non-vacuous: `QG*P=0` + left-inverse (independence) + complementarity + the `card κ` count together force `span(cols P)` to be a genuine direct complement of `range QG` in `ker QG`, i.e. a real presentation of `V'/N`.

Q2 (dimension count): CORRECT. With `range QG ⊆ ker QG` (from `QG²=0`), `dim(ker/range) = (card ι − rank) − rank = card ι − 2·rank`. The proof derives this as an additive identity `card κ + 2·finrank(range) = finrank V` before converting to ℕ-subtraction; since `2·rank ≤ card ι` the truncated subtraction is exact (no hazard).

Q3 (physical_sector_balanced scope): this was the ONE real defect — a minor over-claim. As originally exported it dropped the dimension clause, so its ∃ was cheaply satisfiable by an empty κ (I verified this in Lean: `QG*P=0`, `∃L,L*P=1`, and `0=0` balance all hold for `κ` empty). Thus it did NOT by itself guarantee the full sector, and its proof's full-dimensional `P` (the `card` clause was in scope but discarded as `_`) was not machine-linked to the exported claim. REMEDY APPLIED: added the `Fintype.card κ = Fintype.card ι − 2 * QG.rank` clause to `physical_sector_balanced`'s conclusion (captured from the already-available hypothesis; no new proof, axiom pins unchanged, build still clean) and updated its docstring. Now a single theorem certifies "full-dimensional b-adapted `P` in `ker QG` whose closure-form compression `PᴴMP` is balanced", eliminating the split-citation over-claim.

Q4 (abstract argument): SOUND. `eigenbasis_core` is applied via faithful `mulVecLin`; involution/nilpotency/commutation transport correctly and the finrank bookkeeping is standard.

Q5 (docstring vs kernel): the only prose-outruns-kernel issue was exactly the Q3 gap, now closed. Remaining warnings are cosmetic (unused simp arguments).

Bottom line: the crux is honestly closed to M; the corrected `physical_sector_balanced` now carries the dimension pin so the full-`V'/N` balanced-presentation result is a single kernel-checked statement with correct, non-degenerate content. Changes committed and pushed.
