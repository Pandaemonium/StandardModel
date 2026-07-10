# Strategy: the continuum reduction of the carrier's transfer step (one channel)

STRATEGY + DESIGN job (a landed kernel lemma is a bonus). Standalone - assume no
repo access; the relevant facts are stated below.

## Situation (finite mathematical-physics program: mass = obstruction to null transport)

The program is FINITE and first-quantized: the carrier is a finite Dirac-type
operator; "mass" is the least eigenvalue of a finite sector form. It imports ONE
continuum result as [import]: the 1+1D Feynman checkerboard's continuum limit to
the Dirac propagator (Gersch; Jacobson-Schulman), which closes the continuum gap
for the simplest null chain. The carrier's discrete time step is a quantum-walk /
transfer operator `U = exp(-i t H)` (H the Hermitian sector form, unitary flow
kernel-proved). The OPEN question (§9/§10): does the carrier's transfer step have a
genuine continuum limit to a Dirac-type PDE, beyond the imported 1+1D checkerboard,
for the actual multi-edge Cl(4) carrier?

## Your task

1. **State the continuum-limit claim precisely.** For the 1D Dirac quantum walk
   with mass coin `C(m) = exp(-i m dt sigma_x)` and spin-dependent shift `S`, the
   standard result is `U^{t/dt} -> exp(-t (sigma_z d_x + i m sigma_x))` (the 1+1D
   Dirac evolution) as `dt -> 0` in the small-mass-angle regime. State the exact
   finite-to-continuum scaling (lattice spacing, time step, mass) and the mode of
   convergence (strong resolvent? on wave packets?). What is the sharpest TRUE
   statement, and which is [import] (Gersch etc.) vs genuinely open for the
   multi-edge Cl(4) carrier?
2. **The obstruction to lifting from 1+1D to the Cl(4) carrier.** The multi-edge
   carrier is a `Cl(4)` (4-dim coin) walk; Mlodinow-Brun give the necessary
   conditions (4D coin + parity + noncorrelation) for a QW to yield the Dirac
   equation. Does the program's Cl(4) carrier satisfy them? Where is the gap
   between "1+1D checkerboard continuum limit (imported)" and "the Cl(4) carrier's
   continuum limit (open)"?
3. **A finite kernel target on the way.** Is there a finite, kernel-provable lemma
   that is a genuine step toward the continuum limit - e.g. the discrete symbol
   `U-hat(k) = exp(-i(sin k sigma_z + m sigma_x) + O(k^2,m^2))` matching the Dirac
   symbol to leading order (a finite Taylor/matrix identity), or the group-velocity
   `d omega/d k -> +-1` as `k,m -> 0`? Give the sharpest such finite statement and,
   if cheap, a Lean proof (Mathlib-only, small matrices).
4. **Feasibility + honest boundary.** What is genuinely provable finitely vs what
   needs functional-analytic continuum machinery (semigroup convergence) outside
   the finite kernel program? Is a full continuum theorem in scope, or is the
   honest position "imported for 1+1D, open for the carrier"?

Output: the precise continuum-limit statement (import vs open split); the Cl(4)
obstruction; a finite kernel target (+ Lean if cheap); feasibility + boundary.
Be specific; a correct finite symbol/group-velocity lemma beats a survey.
