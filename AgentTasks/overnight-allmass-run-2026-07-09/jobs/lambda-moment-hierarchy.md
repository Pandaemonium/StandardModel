# claude-lambda-moment-hierarchy — Lambda/gravity/matter are the 0/2/4 moments of one functional; Lambda is channel-blind

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

Rung L5: unify the three loci into one moment hierarchy of a single finite spectral functional, and
prove the structural theorem-let that makes the magnitude problem dissolve: the order-0 (Lambda)
term is INVARIANT under every deformation of the operator, so no channel physics can touch Lambda.
Composes `SpectralActionAvatar` (the order split) + `LambdaUnimodular` (the blindness core).

## The model (explicit rational; one carrier D, deformations D + P)

One finite rational Dirac operator `D` with the graded split into soldering (gravity) and matter
parts. The spectral action `S(D) = a0 tr(1) + a2 tr(D^2) + a4 tr(D^4)`. A "deformation" is any
`D -> D + Pert` (gauge move, channel coupling, soldering decoration) with `Pert` an arbitrary
rational matrix.

## Targets

1. `moment_hierarchy`: state the three-level assignment as one theorem -- order-0 `a0 tr(1)` =
   Lambda (the count/volume term), order-2 `a2 tr(D^2)` = gravity (curvature/soldering), order-4
   `a4 tr(D^4)` = matter (Yang-Mills/Higgs) -- with the order-2 and order-4 terms carrying the
   soldering and matter couplings respectively (exhibit each order's dependence), and order-0
   carrying NEITHER.
2. `order0_deformation_invariant` (payload -- the structural magnitude lemma): for ALL rational
   `Pert`, the order-0 term is unchanged: `a0 * tr (1 : Matrix n n R) = a0 * n` regardless of
   `D -> D + Pert`. There is NO pathway from any operator deformation into the order-0 coefficient
   -- Lambda is blind to all dynamics. (Trivial arithmetic, load-bearing reading: `tr(1)` sees
   only the dimension/count, never the operator.)
3. `only_count_touches_lambda`: contrast -- the order-2 and order-4 terms DO change under
   deformation (exhibit a `Pert` that changes `tr(D^2)` and `tr(D^4)` but not `tr(1)`), so gravity
   and matter are deformation-sensitive while Lambda is not. Only the DIMENSION/count (`tr(1) = n`,
   which grows with the edge count) can move Lambda -- consistent with the everpresent count
   mechanism.
4. `hierarchy_verdict`: package -- one functional, three moments: Lambda (order 0, count-only,
   channel-blind) / gravity (order 2, soldering) / matter (order 4, channels); the magnitude
   problem's finite dissolution is that Lambda has no channel pathway (order-0 invariance), so its
   only physics is count statistics (the everpresent fluctuation). Honest scope: a finite
   polynomial-moment avatar; identifications stay [C].

MANDATORY non-degeneracy: fully explicit rational `D` (dim n = 4, gravity + matter parts both
nonzero); an explicit `Pert` changing `tr(D^2)` from one specific rational to another while
`tr(1) = 4` is fixed; all values in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL rational matrices (small); ring/norm_num/decide/fin_cases + Matrix
trace API; NO Complex, NO Real.sqrt/cos/sin, NO nlinarith deg>=3. Build under 3 min. Deliver
RequestProject/Main.lean (namespace LambdaMomentHierarchy) + ARISTOTLE_SUMMARY.md.
