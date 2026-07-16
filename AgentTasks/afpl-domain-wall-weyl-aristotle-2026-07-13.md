# Aristotle task: exact finite domain-wall lift of a 3+1 Weyl sector

## Lateral objective

Do not seek an isolated Weyl node in a closed three-dimensional finite lattice.
Construct it as a boundary/kernel sector of one additional finite transverse
direction.  Use a local Hermitian SSH/domain-wall/Wilson-type chain whose
boundary zero mode can be proved exactly, then tensor or couple that mode to a
three-dimensional Pauli Weyl symbol.

## Required theorem ladder

1. Define an explicit finite nearest-neighbor Hermitian transverse matrix with
   rational coefficients and a nonzero boundary-localized kernel vector.
2. Prove the vector is nonzero, is in the exact kernel, and has a quantitative
   localization formula or monotone bound.  Include a parameter witness that
   is genuinely localized, not a basis vector inserted by a disconnected zero
   row.
3. Prove kernel dimension one, or give the exact kernel classification.  Audit
   the inevitable opposite-boundary/mirror mode and finite-size effects.
4. Prove a positive spectral lower bound on the orthogonal complement, using
   an exact characteristic polynomial, sum-of-squares certificate, or singular
   value computation.  Do not assume the spectrum.
5. Define the tangential three-momentum Pauli symbol and a full finite operator
   whose restriction to the boundary kernel is exactly the Weyl Hamiltonian.
   Prove the restriction/intertwining theorem and the determinant-sign
   chirality witness.
6. State precisely how the extra direction evades the closed-3D doubling
   obstruction and where the compensating degree of freedom lives.
7. Separate finite exact results from locality in physical 3-space, a unitary
   discrete-time implementation, primitive-null support, gauge coupling,
   thermodynamic limits, and anomaly cancellation.  Those are not automatic.
8. No proof placeholders, compiled evaluation, fake assumptions, or
   disconnected-row vacuity.  Add standard-axiom guards.

Return the strongest exact finite theorem available.  If exact one-dimensional
kernel plus a uniform complement gap is impossible for the chosen boundary
conditions, prove the obstruction and switch to the smallest valid chain.

Run first:

```text
lake env lean DomainWallWeyl/Core.lean
```
