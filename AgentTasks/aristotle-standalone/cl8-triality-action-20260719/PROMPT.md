# Task: the triality action on the Cl(8) colour generators (P5 stage C)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, P5 (three
generations) lane. Self-contained package (16 modules). TWO fresh landed
modules anchor it: `CompositionCl8Generation` (tonight: six sparse colour
generators `c1..c6` with `c1 = e3, c2 = e1, c3 = e2, c4 = e4, c5 = -e6,
c6 = -e5`, operators `C1..C6`/`colourGen`, the 64-case Cl(8) table) and
`OctonionTrialitySeed` (the order-3 index-doubling automorphism `rho3c`,
`e_i -> e_{2i mod 7}`, with `rho3c_mul`).

## Target

`PhysicsSM/Draft/NullEdge/Cl8TrialityAction.lean` - nine theorems ending
in a hole:

1. `rho3c_c1 .. rho3c_c6` - the images of the six sparse forms under
   index doubling, hand-computed with signs:
   `c1 -> -c5, c2 -> c3, c3 -> c4, c4 -> c2, c5 -> c6, c6 -> -c1`.
   Each is a small kernel computation on explicit coordinates (`rho3c` is
   coordinate re-indexing; the signs come from `c5, c6` carrying `-1`
   entries).
2. `rho3_conj_C1`, `rho3_conj_C2` - operator conjugation samples: from
   `rho3c_mul` (automorphism) plus the image equations,
   `rho3c (C_a z) = (sign) C_{perm a} (rho3c z)`.
3. `rho3_conj_colourGen` - the indexed packaging with
   `trialityPerm = ![4, 2, 3, 1, 5, 0]` and
   `trialitySign = ![-1, 1, 1, 1, 1, -1]`: the colour Clifford system is
   triality-stable as a SET (the generator-level content of the S3
   family-symmetry invariance of the colour sector).

## Pre-registered honesty license

The six image equations were hand-computed from the seed's index-doubling
table; if any SIGN differs at the kernel, prove the true value, rename,
record prominently, and propagate the corrected sign through
`trialitySign` and the packaging theorem (adjusting the two `![...]`
tables is in-scope; the PERMUTATION structure `(c2 c3 c4)(c1 c5 c6)`
should survive any sign correction). Also verify `colourGen`'s index
order matches `C1..C6` before assembling; re-index the tables honestly if
not.

## Constraints

- Do not modify the included modules.
- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with `lake env lean PhysicsSM/Draft/NullEdge/Cl8TrialityAction.lean`
  first.

## Success criteria

All nine theorems (with honestly-corrected signs if needed) proven, zero
holes, and a completion report: solved targets, any sign/index
corrections, axioms used.
