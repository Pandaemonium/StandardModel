# claude-vacuum-sequestering — local vacuum shifts do not touch the physical Lambda (the finite magnitude theorem)

## Context (blind to any repo; self-contained finite rational algebra, Mathlib only)

The hard half of the cosmological-constant problem: WHY doesn't the huge local vacuum energy
gravitate? Build the finite avatar of "vacuum sequestering": a uniform shift of the Dirac square
`D#D -> D#D + c*1` (any local vacuum/zero-point contribution) is ABSORBED by the volume/unimodular
constraint and does NOT change the physical, count-fluctuation Lambda. Extends `LambdaUnimodular`.

## The model (explicit rational; n = 3)

State space `R^n`. Dynamical operator `A` (rational symmetric). "Vacuum shift": `A -> A + c*1` for
arbitrary rational `c` (the local zero-point contribution — order-0, proportional to identity).
Volume/count constraint `Vol(x) = <x,x> = v0`. Physical Lambda := the count-FLUCTUATION residue
`Lambda_fluc` (from `LambdaEdgeCount`: `deltaN/N`), independent of `A`.

## Targets

1. `shift_absorbed_by_multiplier`: on the constraint surface, `A -> A + c*1` maps the constrained
   stationary point to itself with multiplier `Lambda -> Lambda + c` (the shift is absorbed into
   the integration constant). Explicit solution map (extends LambdaUnimodular's gauge lemma).
2. `physical_lambda_shift_invariant` (payload): the physical fluctuation residue `Lambda_fluc =
   deltaN/N` is a function of the COUNT statistics only (edge count `N`, fluctuation `deltaN`) and
   is literally INDEPENDENT of `A` and `c` — prove `Lambda_fluc` does not mention the operator:
   for all `A, c`, `Lambda_fluc(N, deltaN)` is unchanged. So no local vacuum shift can change the
   observable Lambda; only count statistics can.
3. `sequestering_gap` (honest boundary as a theorem): the MEAN order-0 coefficient (`a0`, absorbing
   `c`) is gauge/unobservable on the constraint surface (`a0` shifts the action by the constant
   `a0*v0` — restate LambdaUnimodular's `vacuum_shift_is_gauge`), while the observable is the
   fluctuation. So: the vacuum MEAN is sequestered (gauged away by the constraint); the observable
   residue is the count fluctuation. State both halves.
4. `sequestering_verdict`: package -- local vacuum energy (any `c*1` shift) is sequestered by the
   volume constraint and does not gravitate as a mean; the physical Lambda is the count-fluctuation
   residue, blind to the operator. This is the finite magnitude-problem theorem: not a cancellation
   of 10^120 terms, but a structural blindness of the observable to local vacuum shifts. Honest
   scope: a finite n-dim avatar; it does NOT derive the value or prove the full continuum
   sequestering (Kaloper-Padilla).

MANDATORY non-degeneracy: explicit rational `A = diag(1,2,3)`, `v0 = 1`, shift `c = 10^6` mapping
`Lambda -> Lambda + 10^6` while `Lambda_fluc` (e.g. `N=100, deltaN^2=100 => 1/10`) is UNCHANGED --
the huge vacuum shift leaves the physical Lambda at `1/10`. All stated in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL rational matrices/vectors; ring/norm_num/decide/fin_cases +
HasDerivAt; NO Complex, NO Real.cos/sin (Real.sqrt at most one line); NO nlinarith deg>=3. Build
under 3 min. Deliver RequestProject/Main.lean (namespace VacuumSequestering) + ARISTOTLE_SUMMARY.md.
