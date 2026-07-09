# claude-gravity-source-matter — the finite field equation: soldering geometry is sourced by the MATTER channels

## Context (blind to any repo; self-contained finite rational algebra, Mathlib only)

The unification coupling: in `G = 8 pi T` gravity's geometry is sourced by matter's
stress-energy. Build the FINITE avatar tying the null-edge SOLDERING (gravity) channel to the
MATTER channels (aperture/closure/turn) of the SAME Dirac square: the finite field equation
should read (soldering curvature) = (sum of the matter-channel budgets), with the coupling
CHANNEL-BLIND (universal = the weak equivalence principle). Distinct from a bare stationarity
statement: here the SOURCE is exhibited as the matter channels specifically.

## The model (explicit rational matrices)

The carrier Dirac square decomposes as `4 D#D = Q_A + Q_C + Q_T + E_sold` (aperture, closure,
turn matter channels + soldering geometry), all explicit rational symmetric matrices built
from a fixed rational state/frame. Define:
- `matterBudget psi = <psi, (Q_A + Q_C + Q_T) psi>` (the total matter-channel expectation).
- `solderingCurv gamma = <(E_sold gamma), (E_sold gamma)>`-type geometric response of the
  soldering channel to the decoration `gamma` (an explicit rational function).

## Targets

1. `matter_stress_decomp`: the source `M(psi)` of the soldering field equation equals the sum
   of the matter-channel budgets: `M(psi) = Q_A(psi) + Q_C(psi) + Q_T(psi)` (an explicit
   matrix/scalar identity by `ring`). The gravitational source IS the matter channels.
2. `field_equation_sourced` (payload): soldering stationarity `<=>` the finite field equation
   `solderingCurv gamma = kappa * matterBudget psi` for a fixed rational coupling `kappa` --
   geometry (LHS, soldering) equals matter (RHS, channels). Prove the equivalence (both
   directions) via HasDerivAt, with an explicit nonzero-`kappa`, nonzero-both-sides witness.
3. `channel_blind_universal` (WEP): the coupling depends on the matter channels only through
   their SUM (the total budget), not on any single channel separately: for two states with the
   same total `matterBudget` but different channel splits, the sourced geometry coincides. So
   all matter gravitates identically -- the weak equivalence principle, finite.
4. `unification_verdict`: package -- one finite equation couples the soldering (gravity)
   channel to the matter channels of the same Dirac square, channel-blind. Gravity is sourced
   by (and only by the total of) the matter mass-budget. Honest scope: a finite one-edge/
   one-frame avatar of `G = kappa T`, not continuum Einstein equations.

MANDATORY non-degeneracy: explicit rational witness -- `psi*, gamma*` with `matterBudget != 0`,
`solderingCurv != 0`, `kappa != 0`, both sides equal to a specific nonzero rational; plus a
control where the equation FAILS (geometry not sourced) so it is not `0=0`; plus the two-state
same-total-different-split WEP witness.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print
axioms <thm>` on every headline. REAL rational matrices; ring/norm_num/decide/fin_cases +
HasDerivAt; NO Complex, NO Real.cos/sin/sqrt, NO nlinarith deg>=3. Build under 3 min. Deliver
RequestProject/Main.lean (namespace GravitySourceMatter) + ARISTOTLE_SUMMARY.md. NOTE: this
extends the Goal-IV field-equation line in the UNIFICATION direction (source = matter
channels); keep it self-contained and flag the overlap for reconciliation.
