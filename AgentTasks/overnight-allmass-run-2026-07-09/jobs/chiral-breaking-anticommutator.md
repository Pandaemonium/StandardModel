# claude-chiral-breaking-anticommutator — mass = the obstruction to gamma5 anticommuting with the Dirac operator ({g5,D}=-2m g5)

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

This unifies the two projector sets already grounded in the program -- the chiral (Weyl) projectors
`P_L,R = (1 -/+ g5)/2` and the energy projectors `Lambda± = (pslash±m)/2m` -- into the single cleanest
algebraic statement of "mass from massless" at the Dirac-operator level.

The Dirac operator is `D = pslash - m.1`. Its KINETIC part `pslash` is chirality-ODD (anticommutes with
`g5`: `pslash` maps each chirality eigenspace to the OTHER), while its MASS part `m.1` is chirality-EVEN
(commutes with `g5`). Consequently the ANTICOMMUTATOR of `g5` with the whole Dirac operator is
proportional to the mass:

  `{g5, D} = g5 D + D g5 = -2 m . g5`.

At `m = 0` this VANISHES: `g5` anticommutes with the massless Dirac operator `pslash` -- this is exactly
CHIRAL SYMMETRY (left and right decouple). For `m != 0` it is `-2m.g5 != 0`: the mass is precisely the
chiral-symmetry breaking. So `mass = the obstruction to g5 anticommuting with D`, measured by `{g5,D}`.
This is the algebraic core of the whole "mass comes from massless edges" thesis.

A companion, Lagrangian-level fact: the Dirac mass bilinear `psibar psi = psi^dag g0 psi` couples the two
chiralities precisely because `g0` anticommutes with `g5` (so `g0` maps L <-> R): `P_L g0 P_R = P_L g0`
(nonzero). Both facts trace to `{g5, gamma^mu} = 0`.

## The model (real Dirac-rep gammas, (t,z) plane -> rational 4x4; matches the two landed projector modules)

All REAL, so rational 4x4 (no Complex):
* `g5 = !![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]`  (Dirac-rep gamma5, block off-diagonal identity)
* `g0 = !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]`  (= diag(1,1,-1,-1))
* `g3 = !![0,0,1,0; 0,0,0,-1; -1,0,0,0; 0,1,0,0]`
* `pslash E kz = E . g0 - kz . g3`   (Feynman slash in the (t,z) plane)
* `D E kz m = pslash E kz - m . (1 : Matrix (Fin 4) (Fin 4) Q)`   (the Dirac operator)
* `PL = (1/2).(1 - g5)`, `PR = (1/2).(1 + g5)`   (chiral projectors, for the companion facts)

## Targets (rational; ext/fin_cases/simp/norm_num/ring, and `module` for the scalar-smul identity; NO Complex, NO transcendental, NO nlinarith)

1. `g5_anticommutes_g0`: `g5 * g0 + g0 * g5 = 0`. `ext; fin_cases; simp [g5,g0,Matrix.mul_apply,Fin.sum_univ_four]`.
2. `g5_anticommutes_g3`: `g5 * g3 + g3 * g5 = 0`. Likewise.
3. `g5_anticommutes_pslash`: `g5 * pslash E kz + pslash E kz * g5 = 0` (the kinetic term flips chirality).
   From 1,2 by linearity, or entrywise.
4. `g5_commutes_mass`: `g5 * (m . (1:Matrix (Fin 4) (Fin 4) Q)) - (m . 1) * g5 = 0` (mass is chirality-even).
5. `chiral_breaking` (PAYLOAD): `g5 * D E kz m + D E kz m * g5 = (-2 * m) . g5`, where `D E kz m =
   pslash E kz - m.1`. Prove via `{g5,D} = {g5,pslash} - {g5, m.1} = 0 - 2m.g5 = -2m.g5`: expand `D`,
   use target 3 for the `pslash` part and `g5*(m.1)+(m.1)*g5 = 2m.g5` for the mass part, close the
   scalar-smul bookkeeping with `module` (or entrywise `ext; fin_cases; simp; ring`).
6. `massless_chiral_symmetry` (PAYLOAD): at `m = 0`, `g5 * D E kz 0 + D E kz 0 * g5 = 0` -- g5 anticommutes
   with the massless Dirac operator `D(m=0) = pslash` (chiral symmetry). A direct corollary of 5 (RHS
   `-2*0.g5 = 0`) or of 3.
7. `mass_bilinear_couples_chirality` (companion): `PL * g0 * PR = PL * g0` and (nonvanishing) `PL * g0 * PR
   != 0` -- `g0` intertwines the two chiralities, so the mass bilinear `psibar psi` couples L and R.
   (`g0 * PR = PL * g0` from `{g5,g0}=0`.)
8. `chiral_breaking_verdict` (VERDICT): package -- for all `E kz m`, `{g5, D} = -2m.g5`; it vanishes at
   `m=0` (chiral symmetry, g5 anticommutes with the massless Dirac operator) and is `!= 0` for `m != 0`
   (mass = chiral-symmetry breaking). Include the mandatory explicit witness `E=5,kz=3,m=4`:
   `{g5, D 5 3 4} = -8.g5`, and `-8.g5 != 0` (so the breaking is genuinely nonzero); and the massless
   witness `{g5, D 5 3 0} = 0`. State the honest reading: mass is the obstruction to g5 anticommuting
   with the Dirac operator -- the algebraic core of mass-from-massless.

MANDATORY non-degeneracy: the explicit witnesses `{g5, D 5 3 4} = (-8).g5` (massive, nonzero breaking)
and `{g5, D 5 3 0} = 0` (massless, chiral symmetry), plus `g5 != 0` (so `(-2m).g5 != 0` for `m != 0`),
all in-theorem. Show `-2*m != 0` route or exhibit a nonzero entry of `(-8).g5` (e.g. entry `(0,2) = -8`).

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (PhysLean is a REFERENCE for
the gamma convention, NOT an import). Footprint exactly [propext, Classical.choice, Quot.sound]; in-file
`#guard_msgs (whitespace := lax) in #print axioms <thm>` on EVERY headline. Rational 4x4 (real gammas ->
no Complex); Matrix.mul/trace + fin_cases/simp/norm_num/ring, and `module` for scalar-smul matrix
identities; NO Real.sqrt/cos/sin, NO Complex, NO nlinarith. Build under 4 min. Deliver
RequestProject/Main.lean (namespace `ChiralBreakingAnticommutator`) + ARISTOTLE_SUMMARY.md WITH the
PhysLean gamma-provenance line and the honest reading (mass = chiral-symmetry breaking, real (t,z) avatar,
the physics is [import] Dirac theory realized as finite kernel-checked matrix algebra).
