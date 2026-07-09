# claude-zigzag-weyl — the massive Dirac operator is two null Weyl components coupled by mass (Penrose zigzag)

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

Penrose's "zigzag": a massive Dirac fermion is a LEFT-handed and a RIGHT-handed MASSLESS
Weyl fermion, each propagating at c, coupled by the mass. Prove the finite decomposition in
the chiral basis: the Dirac operator is block-off-diagonal in the mass and block-diagonal
(two decoupled null Weyl operators) when massless.

## The model (explicit 2x2 blocks -> 4x4; real or explicit-complex)

Chiral (Weyl) basis. Weyl "kinetic symbol" at a chosen null momentum: use explicit 2x2
matrices KL, KR (left/right Weyl operators, e.g. sigma . p specialized to a concrete
null p so that KL KR = p^2 = 0 on the light cone). The Dirac operator
D(m) = [[0, KR],[KL, 0]] + m * [[0, I],[I, 0]]-shape -- i.e. kinetic part is
block-off-diagonal connecting L<->R via the Weyl symbols, and the MASS m is the extra
chirality-flipping coupling. Chirality gamma5 = [[I, 0],[0, -I]].

## Targets

1. `chiral_grading`: gamma5^2 = 1, trace gamma5 = 0; the kinetic part Dkin and the mass
   part Dmass = m * (chirality flip) have definite grading: gamma5 Dmass gamma5 = -Dmass
   (mass is chiral-ODD) -- the Weyl components have opposite chirality and the mass couples them.
2. `massless_decouples` (payload): at m = 0, in the eigenbasis of gamma5 the operator
   splits into two INDEPENDENT Weyl blocks KL (left) and KR (right) with NO coupling --
   Dkin maps the +1 chirality subspace to the -1 and vice versa via KL, KR separately,
   and each Weyl symbol is NULL: KL KR = 0 at the chosen null momentum (state the exact
   null relation you use). So massless = two decoupled null Weyl.
3. `mass_couples`: for m != 0, Dmass provides the term connecting the two Weyl
   components (the zigzag coupling); exhibit that D(m)^2 = (kinetic^2) + m^2 * I on the
   relevant subspace (the mass-shell square), so the mass is exactly what lifts the null
   (massless) shell to the massive one.
4. `zigzag_verdict`: package 1-3 -- massive Dirac = two null Weyl (each moving at c) + a
   mass coupling that flips chirality; massless => they decouple into free null particles.

MANDATORY non-degeneracy: concrete rational null momentum + explicit matrices; instantiate
D(m)^2 at a 3-4-5-type shell (e.g. kinetic scale 4, m = 3 => D^2 = 25 on the subspace),
stated in-theorem; exhibit the two Weyl blocks are genuinely nonzero and distinct.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print
axioms <thm>` on every headline. Explicit 2x2/4x4 matrices, REAL entries preferred (else
explicit complex constants); ring/norm_num/decide/fin_cases; NO symbolic Complex analysis, NO
Real.cos/sin/sqrt, NO nlinarith deg>=3. Build in-project under 3 min. Deliver
RequestProject/Main.lean (namespace ZigzagWeyl) + ARISTOTLE_SUMMARY.md with honest scope
(fermions; a finite one-momentum decomposition, not the full field theory).
