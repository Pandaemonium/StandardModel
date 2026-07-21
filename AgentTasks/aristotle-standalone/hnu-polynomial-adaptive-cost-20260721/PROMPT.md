# Proof job: sharp unitary product bound and polynomial HNU continuum schedule

Work in Lean 4.28 with Mathlib. The source snapshots in this package record the
live HNU definitions and the already verified generic two-factor commutator
bound. They are reference context; because their original imports are not in
this small package, create a self-contained Mathlib-only output module named
`HNUPolynomialAdaptiveCost.lean`.

The current live massive continuum theorem is mathematically valid but uses a
Taylor envelope containing `exp (R + M)`. At the changing momentum window
`R_N = 3 (N+1)`, its certified microscopic step count is therefore
exponential in `N`. This appears to be a proof artifact. Every HNU rotation
substep and the Pluecker mass coin is an exact exponential of a
skew-Hermitian finite matrix, so all intervening propagator norms are exactly
one. Modern commutator-scaled product-formula bounds suggest a polynomial
certificate.

Prove as much of this ladder as possible without weakening it into an assumed
one-step estimate:

1. For complex finite matrices, prove a two-factor skew-Hermitian estimate
   with no exponential norm penalty:

   ```text
   ||exp(eps A) exp(eps B) - exp(eps (A+B))||
     <= eps^2 / 2 * ||A*B - B*A||
   ```

   for `0 <= eps`, `A^H = -A`, and `B^H = -B`. You may reuse or cleanly
   specialize the variation-of-constants argument in
   `LieTrotterCommutatorBound.lean`.

2. Extend this to a finite ordered product of skew-Hermitian generators. A
   list, `Fin n`, or an explicit nine-factor theorem is acceptable, but the
   final bound must be expressed through actual commutators or imply

   ```text
   ||prod_j exp(eps A_j) - exp(eps * sum_j A_j)||
     <= eps^2 / 2 * (sum_j ||A_j||)^2.
   ```

   Do not insert an `exp(eps * sum norms)` factor. Preserve factor order.

3. Build the exact two-component HNU exponential word. Use Pauli matrices and
   the rotation factorization from the snapshots: one HNU endpoint is the
   square of the four-factor word with coefficients

   ```text
   q0/2, q2/4, q1/2, q2/4.
   ```

   Prove that the eight skew-Hermitian generators sum to
   `-I * (q0 sigma1 + q1 sigma2 + q2 sigma3)` and that their norms sum to at
   most `qAbs q = |q0| + |q1| + |q2|`. Prove the exact exponential-word
   equality, not only equality of derivatives at zero.

4. Lift through the doubled chiral block and fixed unitary Dirac-basis change,
   then prepend one exact Pluecker mass exponential whose generator norm is
   `norm z`. Prove a one-step estimate of the target shape

   ```text
   ||massiveWend z q eps - massiveEflow z q eps||
     <= eps^2 / 2 * (qAbs q + norm z)^2
   ```

   or return the sharpest explicit polynomial constant you can prove. If the
   displayed constant is false because of a factor count or block norm, keep
   the theorem polynomial and explain the exact correction. The finite witness
   `q = (1,0,0)`, `z = 3+4I` must leave both kinetic and mass generators
   nonzero.

5. Telescope exact unitaries for `n` steps and prove a compact-ball estimate
   polynomial in `R+M`, then define a common schedule guaranteeing error at
   most `1/(N+1)`. For `R_N = 3(N+1)`, prove an explicit polynomial upper
   bound on that schedule (cubic in `N` is the expected first-order scaling).

6. State the semantic boundary in the module docstring: this is approximation
   cost for a fixed continuum time, not a physical hierarchy of microscopic
   clocks and not an interacting QFT continuum theorem.

Prioritize the general skew-Hermitian product theorem and the exact HNU
factorization if the final project-specific composition is too large. Return
all Lean source plus a short report listing proved targets, any changed
constants, exact blockers, and all assumptions. No proof placeholders,
compiler-trusted evaluation, fake assumptions, or statement weakening.

Relevant files in this package:

- `LieTrotterCommutatorBound.lean`
- `HNUExactCore.lean`
- `HNUManyStepContinuumLive.lean`
- `HNUPlueckerMassiveStay.lean`
- `HNUMassiveContinuumReduction.lean`
- `HNUMassiveCompactMomentumContinuum.lean`
- `hnu-polynomial-adaptive-cost-20260721-20260721-033953.md`
