# claude-chiral-projectors-dirac — the chiral projectors P_L, P_R ground the Weyl decomposition (rational, Dirac rep)

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

Clean-room grounding of the chiral (Weyl) decomposition of a Dirac spinor, in the Dirac representation,
tying the gamma-matrix algebra to the left/right Weyl split (PhysLean `Fermion.LeftHandedWeyl` /
`RightHandedWeyl` and its `gamma5`, reference/provenance, NOT an import). In the Dirac representation
`gamma5 = i gamma0 gamma1 gamma2 gamma3` is the REAL matrix `!![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]`
(block off-diagonal identity), so the chiral projectors `P_L = (1 - gamma5)/2`, `P_R = (1 + gamma5)/2`
are RATIONAL. Prove they are a complete pair of orthogonal projectors splitting the 4-spinor into two
2-dimensional chirality sectors -- the Weyl decomposition, kernel-checked.

## The model (rational 4x4, Dirac representation)

`g5 = !![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]` (real, the Dirac-rep gamma5). `PL = (1 - g5)/2`, `PR =
(1 + g5)/2` (rational 4x4, entries in {0, 1/2, -1/2}). [Optionally reuse the DiracGammaPhysLean g0..g3 to
DEFINE g5 = -Complex.I * g0*g1*g2*g3 and check it equals this real matrix -- but the real form above is
sufficient and keeps it rational.]

## Targets (rational; fin_cases/simp/norm_num/ring; NO Real transcendental, NO Complex if using the real g5, NO nlinarith)

1. `g5_involutive`: `g5 * g5 = 1` (gamma5 squares to the identity). `ext; fin_cases; simp; norm_num`.
2. `g5_traceless`: `Matrix.trace g5 = 0` (equal left/right chirality dimensions). `simp [Matrix.trace]`.
3. `projectors_complete`: `PL + PR = 1` (the two chiralities exhaust the spinor). `ext; fin_cases; ...; ring`.
4. `projectors_idempotent` (payload): `PL * PL = PL` and `PR * PR = PR` (each is a projector), using
   `g5^2 = 1`: `(1-g5)/2 * (1-g5)/2 = (1 - 2 g5 + g5^2)/4 = (2 - 2 g5)/4 = (1-g5)/2`. By explicit matrix
   mul + `norm_num`, OR abstractly from `g5_involutive`.
5. `projectors_orthogonal` (payload): `PL * PR = 0` and `PR * PL = 0` (the chiralities are disjoint):
   `(1-g5)(1+g5)/4 = (1 - g5^2)/4 = 0`. Explicit.
6. `chirality_eigenvalues`: `g5 * PL = - PL` (left = -1 eigenspace of gamma5) and `g5 * PR = PR`
   (right = +1). So `PL`, `PR` project onto the chirality eigenspaces.
7. `projector_ranks`: `Matrix.trace PL = 2` and `Matrix.trace PR = 2` -- each chirality sector is
   2-dimensional (a 2-component Weyl spinor), so the Dirac 4-spinor = left Weyl (2) (+) right Weyl (2).
8. `weyl_decomposition_verdict`: package -- `gamma5` (Dirac rep) is a traceless involution; `PL, PR =
   (1 -/+ gamma5)/2` are a complete pair of orthogonal idempotents projecting the Dirac spinor onto its
   two 2-dimensional chirality (Weyl) sectors, the `-1`/`+1` eigenspaces of `gamma5`. This grounds the
   chiral decomposition (the massless Weyl pieces of the zigzag) in the PhysLean Weyl-spinor convention.
   Honest scope: the finite projector algebra only (not the Lorentz rep or the mass coupling);
   provenance = PhysLean Fermion.Left/RightHandedWeyl + gamma5, clean-room.

MANDATORY non-degeneracy: `g5 != 1` and `g5 != -1` (nontrivial involution); `PL != 0`, `PR != 0`,
`PL != PR`; explicit entry `PL 0 2 = -1/2`; `trace PL = 2` (not 0 or 4). All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (PhysLean is a REFERENCE,
not an import). Footprint exactly [propext, Classical.choice, Quot.sound]; in-file `#guard_msgs
(whitespace := lax) in #print axioms <thm>` on every headline. Rational 4x4 (real g5 form -> no
Complex); Matrix.mul/trace + fin_cases/simp/norm_num/ring; NO Real.sqrt/cos/sin, NO Complex, NO
nlinarith. Build under 3 min. Deliver RequestProject/Main.lean (namespace ChiralProjectorsDirac) +
ARISTOTLE_SUMMARY.md WITH the PhysLean provenance line.
