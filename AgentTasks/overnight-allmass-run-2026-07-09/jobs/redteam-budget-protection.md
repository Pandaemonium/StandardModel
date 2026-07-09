# claude-redteam-budget-protection — STRATEGY/AUDIT: red-team the mass-budget (§4) and protected-masslessness (§8) claims

## This is a STRATEGY / AUDIT job, not a proof job. Deliver an analysis document, no Lean required.

You are auditing a physics-formalization program (blind to its repo). Two prior red-teams already forced
honest corrections on the mass headline (det-P=mass is standard spinor-helicity [import]; rank-2 ceiling)
and on gravity+Lambda (finite tr(D^2)=Einstein-Hilbert is labeling not the Chamseddine-Connes theorem;
the "hyperuniform costs Lorentz" finite core proves only exchangeability, not Lorentz). Complete the
audit coverage: the TWO remaining bold claim-blocks.

## Claim block A — the mass-budget decomposition (§4)
The program claims a finite Dirac operator `D = sum_e c(alpha_e) nabla_e + Gamma phi` on a finite
2-complex whose square splits into a FOUR-CHANNEL budget `4 D^#D = Q_A + Q_C + 4 Q_T + 4 E_#` (aperture,
closure, transport, and a soldering/gravity term), with the four channels summing to one budget that
"answers to" the kernel-checked Plucker mass invariant `det P` (`totalBudget = c * det P`, both sides an
explicit integer in a witness). It also claims a within-carrier mass-spacing prediction (three squared-
mass levels equally spaced, ratio 1), a critical line `kappa = lambda` where a mode goes massless, and
that mass is a "resource" (free states = rank-one null Grams, mixing creates the Plucker amount).

## Claim block B — protected masslessness (§8)
The program claims a finite McKean-Singer index theorem: for a rank-symmetric carrier the chiral index
= graded dimension, and an unbalanced chiral count FORCES an exact massless mode immune to every
potential/transport ("topology forbids mass"). Plus a taxonomy of FOUR distinct masslessness mechanisms
(chiral-topological, critical-symmetry, gauge/Goldstone, kinematic-null), each kernel-checked.

## Your job: RED-TEAM both blocks. Address concretely:

1. **§4 budget: is the four-channel split canonical or a chosen basis?** `4 D^#D = Q_A+Q_C+4Q_T+4E_#`
   -- are the four channels forced by the operator, or is this one decomposition among many (a chosen
   projection of a Hermitian form)? Do the factors of 4 hide a normalization tuned to make the identity
   close? Is `totalBudget = c * det P` a theorem or a witness-fitted coincidence (one integer equal to
   another at one point)? What would distinguish "answers to det P" from "was normalized to match det P"?
2. **§4 mass-spacing prediction.** "Three squared-mass levels equally spaced, ratio exactly 1" -- is this
   a genuine spectral prediction or an artifact of a symmetric 3x3 ansatz (e.g. levels {L-K, L, L+K} are
   equally spaced BY CONSTRUCTION)? Does it predict anything a generic symmetric tridiagonal wouldn't?
   The program flags it is within-carrier, not the cross-generation ratio -- is even the within-carrier
   claim non-trivial?
3. **§8 index theorem: real content or finite linear algebra?** "Chiral index = graded dimension" for a
   finite graded module is the finite McKean-Singer/rank-nullity statement `dim ker - dim coker` of a
   graded map. Is the "protected massless mode" anything beyond `dim ker D != 0` forced by a dimension
   count (unequal chiral dimensions => nontrivial kernel)? Is "immune to every potential and transport"
   genuine (a topological protection) or just "the index is a dimension, and dimensions don't change
   under the specific finite perturbations considered"? Where is the analytic/topological content vs the
   linear-algebra triviality?
4. **§8 taxonomy: four mechanisms or one relabeled?** Chiral-topological, critical-symmetry, gauge-
   Goldstone, kinematic-null -- are these genuinely distinct protection mechanisms, or facets of "some
   quadratic form has a zero eigenvalue for a structural reason"? Which are [import] (Atiyah-Singer /
   't Hooft anomaly matching / Goldstone's theorem / masslessness of null momenta) vs [orig]?
5. **Strongest KILL-TEST for each block** (§4 and §8): one concrete decidable test that would falsify
   the budget-answers-det-P claim, and one for the topological-protection claim. Expected-if-true vs kills.
6. **Originality honesty.** Separate [import] (finite spectral triples / Krein spaces; McKean-Singer;
   anomaly inflow; Goldstone) from any genuine [orig]. Is the four-channel budget a real discovery or a
   bookkeeping of one Hermitian form?

## Output format
Structured markdown: per (1)-(6) a verdict (holds / partially / labeling / empty / canonical-vs-chosen)
with specific reasoning; then TOP 3 threats across both blocks and the single best kill-test for each,
spelled out. Cite standard index theory / anomaly / spectral-triple physics. Honesty over generosity --
find trivialities dressed as depth, chosen bases dressed as canonical, and imported theorems dressed as
finite discoveries, before reviewers do.
