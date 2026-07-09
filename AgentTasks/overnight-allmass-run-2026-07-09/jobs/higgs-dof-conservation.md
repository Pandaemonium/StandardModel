# claude-higgs-dof-conservation — the Higgs mechanism is exact dof conservation: the Goldstone is eaten (2+2 = 3+1)

## Context (blind to any repo; self-contained finite counting, Mathlib only)

Sharpen the gauge/Higgs side of "mass from massless": the Higgs mechanism does not create or destroy
degrees of freedom -- it REARRANGES them. Before symmetry breaking: a massless gauge boson (2 transverse
polarizations) + a complex scalar (2 real dof). After: a massive gauge boson (3 polarizations, the extra
longitudinal one being the eaten would-be-Goldstone) + 1 physical Higgs scalar. The count is conserved:
2 + 2 = 3 + 1 = 4. The longitudinal mode of the massive vector IS the Goldstone dof, transferred. Prove
this as a finite conservation identity, tied to the polarization count `pol(m) = 2 + [m != 0]` and the
scalar split `complex scalar (2) -> Goldstone (1, eaten) + Higgs (1, physical)`.

## The model (finite; explicit dof counting)

Polarizations of a vector: `polV (massive : Bool) : Nat := if massive then 3 else 2`. Real dof of a
complex scalar `= 2`. Goldstone dof eaten `= 1` (per broken generator). Physical Higgs `= 1`.
`dofBefore := polV false + 2` (massless gauge + complex scalar). `dofAfter := polV true + 1` (massive
gauge + physical Higgs). Generalize to `n` broken generators: `n` massless gauge (2n) + a scalar
multiplet supplying `n` Goldstones + physical Higgses.

## Targets (Nat/rational arithmetic; decide/norm_num/ring; NO Real, NO Complex, NO nlinarith deg>=3)

1. `dof_conserved_abelian`: `dofBefore = dofAfter` (`2 + 2 = 3 + 1 = 4`) -- the abelian Higgs dof count
   is conserved. By `decide`/`norm_num`.
2. `goldstone_is_longitudinal`: the extra polarization gained by the vector equals the Goldstone dof
   eaten: `polV true - polV false = 1` and this `= goldstoneEaten` (`= 1`). The longitudinal mode is
   exactly the eaten Goldstone. Explicit.
3. `dof_conserved_general` (payload): for `n` broken generators with a scalar sector of `s` real dof,
   before `= 2*n + s`, after `= 3*n + (s - n)` (n Goldstones eaten, `s - n` physical scalars remain),
   and `before = after = 2*n + s` for all `n <= s`. Prove the identity `2*n + s = 3*n + (s - n)` for
   `n <= s` (Nat subtraction; carry `n <= s`). The mechanism conserves dof for any multiplet.
4. `higgs_mechanism_verdict`: package -- the Higgs mechanism is a dof-preserving rearrangement: each
   broken generator moves one scalar (Goldstone) dof into the longitudinal polarization of a gauge
   boson that thereby becomes massive; total dof `2n + s` before and after. "Mass from massless" on the
   gauge side is exactly this transfer -- the gauge boson eats a massless scalar mode to gain mass.
   Honest scope: a finite dof-COUNTING identity (the bookkeeping of the mechanism), NOT a dynamical
   derivation of the VEV or the masses.

MANDATORY non-degeneracy: the abelian witness (`2+2=3+1=4`); a non-abelian witness e.g. `n=3, s=4`
(SU(2): before `2*3+4=10`, after `3*3+(4-3)=10`); a control where `n > s` is excluded (the hypothesis
`n <= s` is real -- you cannot eat more Goldstones than the scalar sector has). All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Nat/rational arithmetic; decide/norm_num/omega/ring (mind Nat subtraction,
carry `n <= s`); NO Real.sqrt/cos/sin, NO Complex, NO nlinarith deg>=3. Build under 3 min. Deliver
RequestProject/Main.lean (namespace HiggsDofConservation) + ARISTOTLE_SUMMARY.md.
