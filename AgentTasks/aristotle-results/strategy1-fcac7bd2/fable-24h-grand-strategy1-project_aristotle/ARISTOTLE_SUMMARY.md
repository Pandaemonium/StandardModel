# Summary of changes for run abd04faf-1518-4774-bfee-4e1faf0f9336
Delivered `STRATEGY_MEMO.md` at the project root (committed and pushed). This was a review-only strategy job — no proofs, no source edits — so the sole artifact is the memo.

Key contents:

- **§0 caveat (a finding):** the working tree contains only a stub `RequestProject/Main.lean` and none of the "landed" C/one-particle/sea-level/E artifacts. The memo therefore reasons from the run report at face value and flags, as the highest-leverage 30-minute task, pointing the audit at real sources and running `#print axioms` on every headline theorem.

- **Ranked target board** (value-per-effort) across lanes C and E, with a verdict per target.

- **Q1 (C stability):** ranked (a) ≫ (c) > (b). Recommends the exact-algebra route: prove the coin-angle involution family `W(θ)²=1` symbolically (only nonlinear fact `sin²+cos²=1`; no analytic API), which pins ±1 modes for all θ. Splitting law (c) is gated on a sympy oracle turning the empirical 0.6 into an exact constant (likely rational × 2^{-sep}, matching the exact {1/2,2} transfer eigenvalues); only then formalize a 2×2 eigenvalue law. The continuity/rank argument (b) is advised against as stated — it's a symmetry (commutant) fact, not a continuity fact, and Mathlib lacks usable eigenvalue-perturbation API (no Weyl/Bauer–Fike). Each with exact Lean statement shapes, named API, gates, kill conditions.

- **Q2 (CGGSVWZ, arXiv:1611.04439):** honest answer is a *dictionary*, not a finite-volume Fredholm claim (finite ring ⇒ trivial index). Gives a referee-acceptable verbatim sentence and a numeric-coincidence theorem shape (`discriminator B = closed-form sᵢ of the infinite periodic extension`), gated on a blocking source check of their index formula/sign convention.

- **Q3 (E dynamics):** minimal derivation via the cubic relation `K³ = |z|²·K` (K is not nilpotent — corrected) ⇒ closed-form 2-level pair gate; exact (Trotter-free) layer composition by reusing the disjoint-cone result with `exp_add_of_commute` (kill the Trotter/BCH error-bound line); one phase-sensitive quantity = two-particle bound-state energy on a small ring. All with statement shapes and sympy-oracle precompute steps.

- **Q4:** the three top over-claim risks (finite-vs-infinite topology conflation; "interaction derived" when supplied; fixture/oracle vs kernel-checked) each with a verbatim prophylactic sentence, plus an axiom-audit action.

- Also includes Paper A abstract-billing flags, a source-check checklist (blocking items marked), and a one-paragraph bottom line: concentrate fleet time on finite symbolic algebra where the kernel is decisive; refuse analytic targets Mathlib can't support in the window.
