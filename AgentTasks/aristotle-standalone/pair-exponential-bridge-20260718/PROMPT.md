# Task: Paper E gate - canonical pair evolution as an exact operator exponential

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, Paper E (finite CAR
dynamics) lane. Self-contained package (15 modules; the trusted Pluecker
mass layer and the CAR/Fock layer are included).

## Target

`PhysicsSM/Draft/NullEdge/PairExponentialCanonicalBridge.lean` - three
theorems ending in a hole:

1. `kopMatrix_mulVec_eq_Kop` - the local 16x16 generator matrix of
   `FullFockPairExponential` acts by `mulVec` exactly as the canonical
   quartic pair generator `PlueckerPairGenerator.Kop`.  Both sides are
   explicit finite sums over occupation subsets; compare coordinatewise
   (`funext S`, then case analysis or `Finset` computation).  Use
   `PlueckerPairGenerator.Kop_apply` for the canonical side.
2. `uop_local_eq_canonical` - the local closed-form evolution equals the
   canonical `Uop` pointwise (both are explicit coefficient formulas).
3. `canonical_pair_evolution_is_exponential` - compose 1-2 with the PROVEN
   local theorem `FullFockPairExponential.exp_mulVec_eq_Uop` to conclude
   the canonical statement.  Once 1 and 2 hold definitionally this is a
   rewrite chain.

Why this matters: `FullFockPairExponential`'s own scope note records
"structural similarity is not an API bridge" - the manuscript may not cite
the exponential theorem for the canonical objects until these bridges are
kernel facts.

## Pre-registered honesty license

If a bridge fails because the local and canonical definitions genuinely
differ (sign, ordering, normalization, or the `m`-parameter convention),
prove the corrected relation with the exact mismatch factor, rename the
theorem, and record the mismatch PROMINENTLY - an exact mismatch report is
a success outcome and a manuscript-relevant finding.  Do not modify the
included modules.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with
  `lake env lean PhysicsSM/Draft/NullEdge/PairExponentialCanonicalBridge.lean`
  first; avoid a full `lake build` until the holes are closed.

## Success criteria

All three theorems (or honestly-corrected mismatch versions) proven, zero
holes, and a completion report: solved targets, any mismatch factors found,
axioms used.
