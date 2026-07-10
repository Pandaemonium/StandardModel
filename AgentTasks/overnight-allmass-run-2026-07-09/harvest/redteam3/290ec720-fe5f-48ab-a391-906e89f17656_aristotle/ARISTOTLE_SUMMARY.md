# Summary of changes for run 290ec720-fe5f-48ab-a391-906e89f17656
Delivered the requested strategy/audit as `AUDIT_budget_and_protection.md` (no Lean; the repo is an empty scaffold, as expected for a blind audit). It red-teams both remaining claim-blocks point-by-point with explicit verdicts.

Findings, per your (1)–(6):

1. **§4 four-channel split — CHOSEN (labeling), not canonical.** `D†D` is one Hermitian form; A/C/T/E is a projection onto operator-type subspaces, unlike the canonical Lichnerowicz `∇*∇+R/4` (no order-grading exists on a finite complex to make it invariant). The stray factors of 4 read as cleared denominators (LCD) tuned so witness integers close. `totalBudget = c·det P` is a **sum-of-squares (Frobenius) set equal to a Gram/Plücker determinant** — different, opposite-sign invariants — so it can only match at a fitted point via a free `c`; verdict **witness-fitted / empty** unless a family identity with a universal `c` is exhibited (essentially impossible off a degenerate locus).

2. **§4 mass-spacing — EMPTY (artifact).** "Ratio exactly 1" = spectrum symmetric about its mean = the 3×3 ansatz is centrosymmetric; the equal gaps are the imposed reflection symmetry restated, not a prediction. Critical line κ=λ is an unprotected tuned (codim-1) degeneracy; "mass as resource" is the Gram-determinant-as-volume fact `[import]`.

3. **§8 index theorem — PARTIALLY.** "Index = graded dimension" is finite McKean–Singer = rank-nullity; the protected mode is `dim ker ≥ |dim H₊−dim H₋|`, a dimension count. The invariance (finite spectral flow, algebraic half of Atiyah–Singer) is real, but there is **no topological-index side** (no characteristic class), so "topology forbids mass" borrows the word. "Immune to every potential/transport" is **false as stated** — protection holds only for grading-preserving (odd) perturbations; an even mass term gaps the mode (SSH/BdG-type conditional protection, `[import]`).

4. **§8 taxonomy — PARTIALLY; two mechanisms, not four.** Chiral-topological (index, `[import]`) and Goldstone (`[import]`) are genuine, distinct protections; critical-symmetry (tuned level crossing) and kinematic-null (`p²=0` tautology) are **not protections**. All share "a Hermitian form has a zero eigenvalue"; presenting four as co-equal conflates protection with degeneracy.

5. **Kill-tests (decidable).** §4: perturb one soldering entry `c→c+ε`; Frobenius `+|c|²` vs Gram `−|c|²` forces `c(ε)` to be re-solved ⇒ kills the identity claim. §8: add an even grading-diagonal mass; if the zero mode lifts, protection is chiral-conditional, not topological. Expected-if-true vs kills are spelled out for each.

6. **Originality.** `[import]`: finite spectral triples/Krein, Lichnerowicz template, McKean–Singer, Atiyah–Singer (algebraic half only), Goldstone, spinor-helicity det P, Plücker/Gram. `[orig]`: only an original *labeling* of one Hermitian form plus one *fitted* numeric coincidence — bookkeeping, not discovery.

The document ends with the TOP 3 threats across both blocks (fitted `det P` match; rank-nullity-with-missing-topological-half + false "every potential" scope; imposed symmetries/chosen bases sold as predictions), each with its single best kill-test. Work committed and pushed.
