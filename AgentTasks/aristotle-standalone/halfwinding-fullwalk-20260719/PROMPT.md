# Task: full-walk mode census for the same-winding counterexample (Paper C gate)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, Paper C lane.
Self-contained package (18 modules). Companion to the in-flight
kernel-certificates job; same carrier, same kernel-only requirement.

## Target

`PhysicsSM/Draft/NullEdge/HalfWindingFullWalkStatus.lean` - four
determinant census rows on the UNCOMPRESSED `8 x 8` rational walks:

- `fullwalk_witness_pos/neg`: expected - the two-wall witness field 11's
  full walk carries both a `+1` and a `-1` mode.
- `fullwalk_cex_pos/neg`: STRAWMAN sign - whether the same-winding field
  2's full walk carries the modes is precisely the open question (the
  compressed sector provably has neither, but modes may live outside it).

## Census license (pre-registered; the TABLE is the deliverable)

For each false statement, flip the (in)equality to the kernel truth,
rename honestly, and record the final four-row table prominently in the
module docstring. Any outcome is success: witness-has/cex-lacks would
lift the compressed distinction to the full walk; cex-has would prove the
compression LOSES modes - both are publishable rows for the Paper C
claim matrix.

## Route (kernel-only, mandatory)

Entries of `Wof n = Bfixᵀ * walkQ cW (signField n) * Bfix`... note: `Wof`
here is the FULL walk `walkQ cW (signField n)` on `V8` - clear the
power-of-5 denominators into an integer twin, transfer the determinant
(non)vanishing through the scale factor (`det` scales by `5^(8k)`), and
close with plain kernel `decide`/`norm_num` on integer arithmetic. NO
`n a t i v e _ d e c i d e` - the final footprint must be exactly
`[propext, Classical.choice, Quot.sound]`, quoted via `#print axioms` in
the completion report.

## Constraints

- Do not modify included modules. No new axioms/escapes.
- Verify with
  `lake env lean PhysicsSM/Draft/NullEdge/HalfWindingFullWalkStatus.lean`.

## Success criteria

All four rows resolved with kernel-only proofs (flipped where the truth
requires), the four-row table in the docstring, and the footprint quote.

## RESTART ADDENDUM (2026-07-19 08:25)

First harvest applied: integral-twin layer + witness-11 determinants are
draft-proven; the module docstring now states the TRUE partial status.
Remaining holes are the job: `walkZ_cast`, `walkZ_cex_pos_det`,
`walkZ_cex_neg_det`, `det_eq_zero_of_scaled_det_eq_zero`, and the four
main census theorems. PREFER kernel `decide` on the integer twin over
`n a t i v e _ d e c i d e` wherever feasible (the repo pattern:
`HalfWindingKernelCertificates` closed fully kernel-only); replacing the
six existing native occurrences is a bonus, not required.
