# claude-dirac-gamma-physlean — the Dirac gamma algebra grounded in PhysLean's convention (Clifford relation {γ^μ,γ^ν}=2η^μν)

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

Clean-room port grounding our Dirac gamma matrices in the PhysLean convention (github HEPLean/PhysLean,
`spaceTime.gamma`, the Dirac representation) -- reference/provenance, NOT an import (version-pinned OFF
our v4.28.0). This is the Dirac-representation companion to the chiral-representation zigzag work: it
verifies that PhysLean's explicit Dirac-rep gamma matrices satisfy the Clifford algebra
`{gamma^mu, gamma^nu} = 2 eta^{mu nu} . I` with the mostly-minus metric `eta = diag(1,-1,-1,-1)` (the
same convention as our Minkowski grounding). This anchors the Dirac operator layer of the mass mechanism
to a machine-verified external convention.

## The model (PhysLean's EXACT Dirac-representation gamma matrices, complex 4x4 explicit constants)

Reproduce PhysLean `spaceTime.gamma` verbatim (Dirac representation):
```
g0 = !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]
g1 = !![0,0,0,1; 0,0,1,0; 0,-1,0,0; -1,0,0,0]
g2 = !![0,0,0,-Complex.I; 0,0,Complex.I,0; 0,Complex.I,0,0; -Complex.I,0,0,0]
g3 = !![0,0,1,0; 0,0,0,-1; -1,0,0,0; 0,1,0,0]
```
The metric `eta : Fin 4 -> Fin 4 -> Q` (or the diagonal signs `s = ![1,-1,-1,-1]`), `(+,-,-,-)`.
Everything is EXPLICIT constant complex (entries in {0, 1, -1, I, -I}); keep it finite -- fin_cases +
Matrix.mul_apply + Fin.sum_univ_four + norm_num (with Complex.I_sq / `I^2 = -1`). NO symbolic Complex
analysis, NO Real transcendentals.

## Targets (explicit-constant complex; fin_cases/decide/simp/norm_num + Complex.I_sq; NO nlinarith)

1. `gamma_sq`: `g0*g0 = 1`, `g1*g1 = -1`, `g2*g2 = -1`, `g3*g3 = -1` (the diagonal Clifford relations:
   `(gamma^mu)^2 = eta^{mu mu} . I`). By `ext i j; fin_cases i <;> fin_cases j <;> simp [...]; norm_num`.
2. `gamma_anticomm` (payload): for every distinct pair, `g_mu * g_nu = - (g_nu * g_mu)` -- the off-
   diagonal Clifford anticommutation (matching PhysLean's `gamma1_mul_gamma0` etc.). State all six
   distinct pairs (or the symmetric set). Explicit matrix computation.
3. `clifford_relation` (payload): package the Clifford algebra `g_mu * g_nu + g_nu * g_mu =
   (2 * eta mu nu) . (1 : Matrix (Fin 4) (Fin 4) C)` for ALL mu, nu in Fin 4, where `eta mu nu` is the
   diagonal metric (`1` at (0,0), `-1` at (i,i), `0` off-diagonal). This is the single statement
   `{gamma^mu,gamma^nu} = 2 eta^{mu nu} I`. Prove by `fin_cases` on mu, nu (16 cases) reducing to
   `gamma_sq` and `gamma_anticomm`.
4. `dirac_gamma_verdict`: package -- the PhysLean Dirac-representation gamma matrices satisfy the
   Clifford algebra of the mostly-minus metric `(+,-,-,-)`; `(gamma^0)^2 = I`, `(gamma^i)^2 = -I`,
   distinct gammas anticommute. This grounds our Dirac operator convention in PhysLean's machine-verified
   one. Honest scope: the finite Clifford ALGEBRA (anticommutation) only -- not the Lorentz covariance,
   the spinor rep, or the mass term; provenance = PhysLean spaceTime.gamma (Dirac rep), clean-room port.

MANDATORY non-degeneracy: an explicit witness that the gammas are nonzero and distinct (e.g. `g0 != g3`,
`g0 0 0 = 1`, `g2 0 3 = -Complex.I != 0`); and a check that `eta` is genuinely indefinite
(`eta 0 0 = 1`, `eta 1 1 = -1`), so `clifford_relation` is not the trivial all-`+1` (Euclidean) case.
All in-theorem.

## Constraints (HARD -- buildable-proof rule v3, complex-constant exception)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (PhysLean is a REFERENCE, not
an import). Footprint exactly [propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace
:= lax) in #print axioms <thm>` on every headline. EXPLICIT-CONSTANT complex 4x4 ONLY (entries in
{0,+-1,+-I}); fin_cases + Matrix.mul_apply + Fin.sum_univ_four + simp + norm_num + Complex.I_sq; NO
symbolic Complex analysis, NO Real.sqrt/cos/sin, NO nlinarith. Build under 4 min (complex 4x4 is heavier
-- set maxHeartbeats if needed, keep it explicit). Deliver RequestProject/Main.lean (namespace
DiracGammaPhysLean) + ARISTOTLE_SUMMARY.md WITH the PhysLean provenance line (package HEPLean/PhysLean,
decl spaceTime.gamma, version gap: pinned off v4.28.0, not imported).
