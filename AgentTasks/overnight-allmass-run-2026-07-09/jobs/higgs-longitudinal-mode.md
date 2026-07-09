# claude-higgs-longitudinal-mode — a massive vector's third polarization IS the mass (the eaten null Goldstone)

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

Extends "mass from massless" to the GAUGE/Higgs sector. A MASSLESS vector (photon) has 2
transverse polarizations; a MASSIVE vector (W/Z) has 3 -- the extra LONGITUDINAL polarization is
the "eaten" Goldstone: `2 (massless) + 1 (Goldstone) = 3 (massive)`. So the vector-boson mass IS
the extra null/longitudinal mode. Prove the finite degree-of-freedom counting -- the turn/Higgs
channel's version of "mass = a null mode".

## The model (explicit finite linear algebra; polarization subspaces of R^4 momentum space)

Momentum `k` (a fixed rational 4-vector). The polarization space of a vector field is
`{ eps : eps . k = 0 }` (transversality) modulo gauge. Define:
- MASSLESS case (null `k`, `k.k = 0`): physical polarizations = `{eps : eps.k = 0} / {eps ~ eps +
  c k}` (gauge). Prove `dim = 2` (transverse).
- MASSIVE case (timelike `k`, `k.k = m^2 > 0`): physical polarizations = `{eps : eps.k = 0}` (no
  gauge quotient, since massive). Prove `dim = 3`.

## Targets (Mathlib finrank / subspace API, explicit rational k)

1. `massless_two_polarizations`: for a null `k` (`k.k=0`, `k != 0`), the transverse-mod-gauge
   space has dimension `2` (`dim ker(dot k) = 3`, minus the 1-dim gauge direction `k` itself which
   lies in the kernel for null `k`). Exhibit the 2 explicit transverse polarizations.
2. `massive_three_polarizations`: for a timelike `k` (`k.k = m^2 > 0`), the transverse space
   `{eps.k = 0}` has dimension `3` (no gauge quotient); exhibit 2 transverse + 1 LONGITUDINAL
   polarization (`eps_L ~ k` direction made transverse), the longitudinal being the extra one.
3. `longitudinal_is_mass` (payload): the extra (third) polarization exists IFF `m != 0`
   (`k.k > 0`) -- as `m -> 0` the longitudinal mode decouples (the gauge direction re-enters the
   kernel and the count drops `3 -> 2`). So the longitudinal polarization is the mass: `dim_phys =
   2 + [m != 0]`. State the exact count law.
4. `higgs_counting_verdict`: package -- `2 (transverse) + 1 (longitudinal/eaten Goldstone) = 3`
   for a massive vector, dropping to `2` when massless: the vector-boson mass is the extra
   longitudinal null mode. The gauge/Higgs-channel avatar of "mass from massless". Honest scope: a
   finite DOF-counting statement, not the dynamical Higgs mechanism.

MANDATORY non-degeneracy: explicit rational witnesses -- null `k = (1,1,0,0)` giving dim 2 (with
the 2 transverse polarizations exhibited), timelike `k = (5,3,0,0)` (`k.k = 25-9 = 16 = 4^2`)
giving dim 3 (with the longitudinal exhibited), both counts stated in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL rational vectors/subspaces; Mathlib finrank/Submodule API +
ring/norm_num/decide/fin_cases; use the Minkowski dot with an explicit `eta = diag(1,-1,-1,-1)`;
NO Complex, NO Real.sqrt/cos/sin, NO nlinarith deg>=3. Build under 3 min. Deliver
RequestProject/Main.lean (namespace HiggsLongitudinalMode) + ARISTOTLE_SUMMARY.md.
