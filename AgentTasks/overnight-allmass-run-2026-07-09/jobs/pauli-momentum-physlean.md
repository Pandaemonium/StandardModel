# claude-pauli-momentum-physlean — the sigma-map p_mu -> p.sigma with det(p.sigma)=m^2, grounded in PhysLean's Pauli convention

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

Clean-room port grounding the spinor-helicity foundation of the mass mechanism in PhysLean's Pauli-matrix
convention (github HEPLean/PhysLean, `PauliMatrix.pauliBasis` / `pauliContrDown` "Pauli matrices as a
Lorentz tensor") -- reference/provenance, NOT an import (version-pinned OFF v4.28.0). The whole "mass =
det P" story rests on the map from a 4-momentum to a Hermitian 2x2 matrix `P(p) = p_mu sigma^mu`, whose
DETERMINANT is the invariant mass squared and whose rank drops to 1 exactly on the null cone. This is the
little-group SPINOR matrix (the correct `P` the audit flagged -- not the 4-vector Gram). Port it against
PhysLean's Pauli convention.

## The model (PhysLean's standard Pauli matrices, complex 2x2 explicit constants)

Standard self-adjoint Pauli basis (as in PhysLean `PauliMatrix`):
```
s0 = !![1,0; 0,1]        s1 = !![0,1; 1,0]
s2 = !![0,-Complex.I; Complex.I,0]        s3 = !![1,0; 0,-1]
```
The four-momentum map (real components `p0 p1 p2 p3 : Q`, coerced to C):
`P p0 p1 p2 p3 = p0 . s0 + p1 . s1 + p2 . s2 + p3 . s3` (a Hermitian 2x2). Mostly-plus determinant note:
`det P = p0^2 - p1^2 - p2^2 - p3^2` (the `(+,-,-,-)` mass-squared).

## Targets (explicit-constant complex; fin_cases/simp/norm_num + Complex.I_sq; NO nlinarith, NO symbolic Complex)

1. `P_closed`: `P p0 p1 p2 p3 = !![p0+p3, p1-Complex.I*p2; p1+Complex.I*p2, p0-p3]` (the explicit Hermitian
   form). By `ext i j; fin_cases i <;> fin_cases j <;> simp [P, s0,s1,s2,s3]`.
2. `P_selfAdjoint`: `(P p0 p1 p2 p3).conjTranspose = P p0 p1 p2 p3` for real `p_i` (Hermitian). By the
   closed form + `conj` on reals.
3. `det_P_eq_massSq` (payload): `(P p0 p1 p2 p3).det = (p0^2 - p1^2 - p2^2 - p3^2 : C)` -- the
   determinant is the invariant mass squared `m^2` in `(+,-,-,-)`. By `Matrix.det_fin_two` on the closed
   form + `Complex.I_sq` + `ring` (the off-diagonal product `(p1-I p2)(p1+I p2) = p1^2 + p2^2`).
4. `null_iff_massless` (payload): `(P p0 p1 p2 p3).det = 0 <-> p0^2 = p1^2 + p2^2 + p3^2` (the null cone
   = massless), and a massive witness `p=(1,0,0,0)`: `det = 1 != 0`; a null witness `p=(1,0,0,1)`:
   `det = 0`. Explicit. This is exactly the `det P = 0 <-> null` of the mass mechanism, at the sigma-map
   level.
5. `pauli_momentum_verdict`: package -- the PhysLean Pauli matrices give the four-momentum -> Hermitian
   2x2 map `P(p) = p_mu sigma^mu` whose determinant is `m^2 = p0^2-p1^2-p2^2-p3^2`, self-adjoint, with
   `det = 0` exactly on the null cone. This is the little-group spinor matrix grounding the "mass = det P"
   invariant (s3) in PhysLean's convention. Honest scope: the finite sigma-map + determinant identity
   only (not the full Lorentz rep / spinor decomposition); provenance = PhysLean PauliMatrix, clean-room.

MANDATORY non-degeneracy: massive witness `p=(1,0,0,0)` (`det=1`); null witness `p=(1,0,0,1)` (`det=0`);
a spacelike `p=(0,1,0,0)` (`det=-1`); self-adjointness at an explicit `p`; the off-diagonal `s2` entry
`-Complex.I != 0`. All in-theorem.

## Constraints (HARD -- buildable-proof rule v3, complex-constant exception)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (PhysLean is a REFERENCE, not
an import). Footprint exactly [propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace
:= lax) in #print axioms <thm>` on every headline. EXPLICIT-CONSTANT complex 2x2 (entries built from
real `p_i` and `Complex.I`); Matrix.det_fin_two + fin_cases + simp + norm_num + Complex.I_sq + ring; NO
symbolic Complex analysis, NO Real.sqrt/cos/sin, NO nlinarith. Build under 3 min. Deliver
RequestProject/Main.lean (namespace PauliMomentumPhysLean) + ARISTOTLE_SUMMARY.md WITH the PhysLean
provenance line (package HEPLean/PhysLean, decl PauliMatrix / pauliContrDown, version gap: pinned off
v4.28.0, not imported).
