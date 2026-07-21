# Task: kernel-only certificates for the four-site winding discriminant (Paper C gate)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, Paper C (winding
insufficiency / involutive compression) lane. Self-contained package
(18 modules; the decisive classification file and its chain are included
and PROVEN - some of its family decisions via compiled evaluation, which is
exactly what this job removes).

## Target

`PhysicsSM/Draft/NullEdge/HalfWindingKernelCertificates.lean` - six
theorems ending in a hole. Goal: kernel-only (`decide`/`norm_num`-grade)
replacements for the compiled family decisions of
`HalfWindingFieldPositionClassification`:

1. `mofZ_bridge` - the integer-twin scaling bridge. `Mof n` entries are
   rationals with denominator a power of 5 (fields are +-3/5); the stated
   twin uses `25 * entry` with `Int.floor`. If the true clearing power is
   not 25, CORRECT the exponent in `MofZ` and the bridge statement (that
   correction is pre-registered as in-scope), keep everything else exact.
2. `discriminant_kernel`, `selfadj_iff_involution_kernel`,
   `corrected_bridge_kernel` - kernel twins of the three compiled
   family-wide decisions.
3. `witness_pair_kernel`, `counterexample_sector_kernel` - kernel twins of
   the displayed witnesses and determinant controls.

## Route (repo-proven pattern)

Transfer every decision through the integer twin, then close with plain
kernel `decide` on 4x4 INTEGER matrix arithmetic: self-adjointness of
`Mof n` iff of `MofZ n`; `Mof n * Mof n = 1` iff
`MofZ n * MofZ n = (scale^2) • 1`; determinant nonvanishing scales by
`scale^4`. If one `decide` over all 16 cases is too heavy for the kernel,
split into 16 per-case lemmas (`Fin.cases` or explicit numerals) and
assemble - report which granularity worked. `Finset`/`Matrix` decidability
instances for `Fin 4` matrices over `ℤ` are available; avoid `ℚ`-valued
`decide` (that is the blowup the twin avoids).

## Hard constraint (the point of the job)

The six theorems' axiom footprint must be EXACTLY
`[propext, Classical.choice, Quot.sound]` - verify with `#print axioms`
before finishing. NO `n a t i v e _ d e c i d e`, no `Lean.ofReduceBool`,
no `Lean.trustCompiler` anywhere in the new file. Do not modify the
included classification file (its compiled originals stay as historical
comparison).

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`.
- Verify with
  `lake env lean PhysicsSM/Draft/NullEdge/HalfWindingKernelCertificates.lean`
  first; avoid a full `lake build` until the holes are closed.

## Success criteria

All six theorems proven with the kernel-only footprint confirmed by
`#print axioms` output quoted in the completion report, plus the report:
scaling exponent used, decide granularity that worked, axioms.
