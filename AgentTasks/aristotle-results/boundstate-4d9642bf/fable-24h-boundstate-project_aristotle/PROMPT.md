# Proof job: exact interacting two-particle spectrum of the composed automaton (E lane fixture)

Lean 4 + Mathlib (+ context module for provenance references; no need to
import it unless useful). Namespace
PhysicsSM.Draft.NullEdge.PairSpectrumFixture. All constants below were
computed exactly in sympy this morning (24h run); re-verify, do not
trust.

## The objects

One-particle: the L=4 complex-coin ring walk U1 = S*C, coin
[[4/5, -3i/5], [-3i/5, 4/5]] per site, shifts as in the landed modules.
Two-particle: U2 = the 28x28 determinant-minor lift of U1 over pair
index (i<j, i,j in Fin 8): U2[(r1,r2),(c1,c2)] = U1[r1,c1]*U1[r2,c2] -
U1[r1,c2]*U1[r2,c1]. Kick: K2 = identity except the 2x2 block on pair
indices (0,1) and (2,3): [[4/5, -3i/5], [-3i/5, 4/5]] (the exact
rational 3-4-5 rotation - the quarter... NOT quarter: the (c,s) =
(4/5,3/5) member of the exact gate family). Composed step V = U2 * K2.

## Verified mathematics to formalize (ranked)

T1 (pure polynomial algebra over Q, ring-closable): the explicit
factorization identity in Q[lam]:
  3125*lam^28 - ... (the full charpoly; you will compute/verify it) =
  (lam + 1)^2 * (lam - 1)^4 * (25*lam^2 + 14*lam + 25)
  * (5*lam^2 - 6*lam + 5)^2 * (5*lam^2 + 6*lam + 5)^2 * p12(lam),
  p12(lam) = 3125*lam^12 - 2300*lam^10 + 3219*lam^8 - 6040*lam^6
             + 3219*lam^4 - 2300*lam^2 + 3125.
  State it as: the product of the displayed factors equals the
  explicitly written degree-28 polynomial (compute the coefficients
  exactly first; every coefficient must be verified, none copied
  blindly).
T2 (pure algebra): the palindromic reduction: for lam != 0,
  p12(lam)/lam^6 = 3125*w^3 - 2300*w^2 - 6156*w - 1440 evaluated at
  w = lam^2 + lam^{-2}. State as a polynomial identity:
  p12(lam) = lam^6 * (3125*(lam^2+lam^{-2})^3 - ...) cleared of
  denominators: p12(lam) = 3125*(lam^4+1)^3/... - work out the exact
  cleared form and prove by ring.
T3 (the matrix bridge, draft trust acceptable and DISCLOSED): the
  charpoly of the explicit 28x28 rational-complex matrix V equals the
  degree-28 polynomial of T1. If kernel-only is infeasible at this
  size, native_decide with a loud docstring is acceptable for THIS
  step only; T1/T2 must stay kernel-only.
T4 (exact pinned modes, kernel): exhibit explicit eigenvectors of V for
  +1 (four independent) and -1 (two independent) if extractable with
  exact rational entries (compute their nullspace bases exactly first);
  each verified by mulVec. If the vectors are large, two witnesses per
  sign suffice with the full multiplicities left to T3's charpoly.

## Physics framing (memo only) and boundaries

The composed interacting automaton at the exact 3-4-5 kick: the free
two-particle levels that remain (the low-degree factors are exactly the
free lift's levels) and TWELVE interaction-shifted quasienergies given
by the explicit rational cubic in w = 2cos(2*eps) - the discrete
bound-state/threshold structure of the supplied interaction, exact.
Numerics: the shifted family includes near-gap isolated pairs
(+-0.1586, +-2.9830 at this kick). BOUNDARIES: single-kick spectra are
exactly phase-independent (the kick phase conjugates away - verified at
1e-16); the phase-SENSITIVE quantity remains the landed two-kick
interference; the interaction is supplied, not derived; L=4 fixture
only, no thermodynamic claims.
