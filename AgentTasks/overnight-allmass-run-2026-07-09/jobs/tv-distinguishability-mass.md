# claude-tv-distinguishability-mass — mass is the total-variation distinguishability of the null directions (testing-lower-bounds port)

## Context (blind to any repo; self-contained finite probability/algebra, Mathlib only)

Port the total-variation / data-processing core from the testing-lower-bounds package (github
RemyDegenne/testing-lower-bounds: KL/Renyi/f-divergence, total variation, DeGroot, DPI) --
reference/provenance, NOT an import (version-pinned). The mass of a two-null-edge state reads as the
DISTINGUISHABILITY of the two null directions: collinear (indistinguishable) = massless, orthogonal
(perfectly distinguishable) = maximal. Prove the finite TV/distinguishability version tied to the
Plücker mass, with the data-processing monotonicity (coarse-graining cannot increase
distinguishability).

## The model (finite, rational)

Two null-direction "distributions" as rational probability vectors `p, q : Fin n -> Q` (>=0, sum 1)
-- the visible readouts of the two null edges. Total variation `TV p q = (1/2) sum_i |p_i - q_i|`.
A coarse-graining (stochastic) map `K` (column-stochastic rational matrix) acts by `p |-> K p`.

## Targets (rational; no log -- TV is L1, rational)

1. `tv_bounds`: `0 <= TV p q <= 1`; `TV p q = 0 <-> p = q` (indistinguishable); `TV = 1 <-> disjoint
   support` (perfectly distinguishable). Basic properties by `ring`/`norm_num`/Finset.
2. `dpi_total_variation` (payload -- the testing-lower-bounds core): data processing --
   `TV (K p) (K q) <= TV p q` for any column-stochastic `K` (coarse-graining cannot INCREASE
   distinguishability). Prove via the triangle/contraction argument on the L1 norm (a landed-lemma-
   preferred route: if Mathlib has an L1-contraction-under-stochastic-map lemma, use it; else prove
   the finite `sum_i |sum_j K_ij (p_j - q_j)| <= sum_j |p_j - q_j|` by `Finset` triangle inequality
   + column-stochasticity). Reference: testing-lower-bounds' DPI for f-divergences.
3. `mass_is_distinguishability` (payload): tie to Plücker mass -- for two unit spinors with
   celestial-sphere readouts, `TV`-style distinguishability is 0 iff collinear (`det P = 0`,
   MASSLESS) and grows with the wedge `|psi ^ phi|` (MASSIVE). State the finite monotone: the
   distinguishability of the two null-direction readouts vanishes iff the edges are collinear iff
   mass is zero (using an explicit rational readout model, e.g. `p, q` built from the Bloch
   components so `TV = 0 <-> collinear`).
4. `distinguishability_verdict`: package -- mass = the (data-processing-monotone) distinguishability
   of the two null-direction messages: 0 for collinear (massless), positive and coarse-graining-
   monotone for disagreeing (massive). The testing-lower-bounds DPI, in the finite TV form the mass
   dictionary needs. Honest scope: total variation (not full f-divergence); a finite avatar;
   provenance = testing-lower-bounds.

MANDATORY non-degeneracy: collinear witness `p = q = (1,0)` (`TV = 0`, massless); distinguishable
`p = (1,0), q = (0,1)` (`TV = 1`, maximal); a coarse-graining `K` with `TV(Kp)(Kq) < TV(p)(q)`
strictly (explicit rationals) -- all in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (testing-lower-bounds is
a REFERENCE, not an import). Footprint exactly [propext, Classical.choice, Quot.sound]; in-file
`#guard_msgs (whitespace := lax) in #print axioms <thm>` on every headline. Rational + Finset.sum +
abs; ring/norm_num/decide/fin_cases + Finset triangle inequality; NO Real.log/sqrt, NO Complex, NO
nlinarith deg>=3. Build under 3 min. Deliver RequestProject/Main.lean (namespace
TVDistinguishabilityMass) + ARISTOTLE_SUMMARY.md WITH the testing-lower-bounds provenance line.
