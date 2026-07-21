# Strategy/audit: independent scrutiny of the shared-Higgs composition claim

Mathlib-only analysis. The AFPL A1 gate builds a shared-Higgs-data theorem
composing gauge Gram (Fin 2 vacuum), radial Hessian (2 lam v^2), and fermion turn
(Y (x) 1) from one vacuum datum. Independently stress-test the CONSTRUCTIVE claim
(the Opus no-go showed the fermion sector shares only the scalar v). Prove or
refute, Mathlib-only on concrete small models:
1. the gauge Gram `G_ab = <T_a phi0, T_b phi0>` is PSD and its kernel is exactly
   the stabilizer of phi0 (the photon direction) - verify with an explicit
   su(2)-like pair;
2. the radial Hessian `2 lam v^2` is the unique quadratic coefficient of the
   doublet potential at the vacuum - verify by Taylor expansion;
3. THE CROSS-CHECK: exhibit that fixing (v, generators, lam) leaves the gauge and
   radial sectors DETERMINED but the fermion sector FREE (Y arbitrary), confirming
   the shared datum determines exactly the boson sectors and not the fermion one.
Deliverable: the three verifications + a precise statement of what "one Higgs
datum, three sectors" legitimately means (two determined, one scalar-shared). No
new axioms/native_decide; standard axioms; report axioms.
