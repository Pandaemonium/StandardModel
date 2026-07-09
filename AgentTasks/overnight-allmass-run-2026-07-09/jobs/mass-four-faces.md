# claude-mass-four-faces — the four faces of mass^2 are ONE invariant (anti-double-counting consolidation)

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

The program reads mass^2 of a two-null-edge state through several finite dictionaries, and honesty
requires proving they are the SAME invariant, not independent results. For a real symmetric PSD trace-1
`2x2` "density" `rho = !![p, x; x, 1-p]`, these coincide:
* the Plucker/determinant `det rho`;
* the linear entropy `Slin rho = 1 - tr(rho^2)`;
* the "Hlin" diagonal linear entropy `1 - (p^2 + (1-p)^2)` when `x = 0`;
* and (celestial 2-outcome readout) the total-variation distinguishability of the diagonal is `|2p-1|`,
  whose square relates to the same data.
Prove the exact algebraic identities that MAKE these one object, and honestly separate the one-register
entropies (which are literally equal) from the two-register TV distance (a related but distinct object).

## The model (real symmetric 2x2, rational)

`rho p x = !![p, x; x, 1-p]`. `detR p x = p*(1-p) - x^2`. `Slin p x = 1 - tr((rho p x)^2)`.
`Hlin p = 1 - (p^2 + (1-p)^2)`. For the DIAGONAL celestial readout `d p = ![p, 1-p]` (a prob vector),
`TVdiag p q = (1/2)(|p-q| + |(1-p)-(1-q)|) = |p-q|`.

## Targets (rational; ring/norm_num/decide/fin_cases; NO Real transcendental, NO Complex, NO nlinarith deg>=3)

1. `slin_eq_two_det`: `Slin p x = 2 * detR p x` (the linear entropy is exactly twice the determinant).
   By `Matrix.trace`, `Matrix.mul`, `Fin.sum_univ_two`, `ring`.
2. `hlin_eq_two_det_diag`: `Hlin p = 2 * detR p 0` (the diagonal linear entropy equals `2 det` at
   `x=0`), and `Hlin p = 2 * p * (1-p)`. By `ring`.
3. `faces_agree` (payload): assemble -- for any `p, x`, `Slin p x = 2 * detR p x`, and at `x=0`,
   `Slin p 0 = Hlin p = 2*detR p 0 = 2*p*(1-p)`. The det/linear-entropy/Hlin faces are ONE rational
   invariant (up to the fixed factor `2`). State as a conjunction of equalities.
4. `tv_is_plucker_distance` (payload, the honest separation): the two-register TV distinguishability of
   two diagonal readouts is `TVdiag p q = |p - q|`, which equals the magnitude of the `2x2` Plucker
   wedge `|p*(1-q) - (1-p)*q| = |p - q|` -- so TV is the PLUCKER DISTANCE between two edges, a distinct
   (two-argument) object from the one-register entropy, but built from the same wedge/determinant data;
   and `TVdiag p p = 0` (collinear/massless). Make explicit that TV is a distance, `Slin/Hlin/det` a
   single-state invariant -- they are NOT the same function, but both vanish exactly at masslessness and
   both are the wedge/determinant of the null data.
5. `four_faces_verdict`: package -- `det`, `Slin`, `Hlin` are one single-register mass^2 invariant
   (equal up to the factor 2); `TV` is the two-register Plucker distance of the null directions; all
   four vanish exactly at masslessness (`x=0, p in {0,1}` / `p=q`). Honest scope: this is the
   consolidation that the several mass^2 dictionaries are faces of one wedge/determinant invariant, NOT
   four independent results.

MANDATORY non-degeneracy: explicit rationals -- `rho (1/2)(1/2)` pure/massless (`Slin=0=Hlin=det`),
`rho (1/2) 0` mixed (`Slin=1/2=Hlin=2det`), `TVdiag (1/2) (1/2) = 0` vs `TVdiag 1 0 = 1`. All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL/rational 2x2 + prob vectors; Matrix.trace/mul + Fin.sum_univ_two +
ring/norm_num/decide/fin_cases + abs; NO Real.sqrt/cos/sin, NO Complex, NO nlinarith deg>=3. Build under
3 min. Deliver RequestProject/Main.lean (namespace MassFourFaces) + ARISTOTLE_SUMMARY.md.
