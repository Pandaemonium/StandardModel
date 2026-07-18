<!--
aristotle_job:
  slug: cayley-dickson-quaternion-20260717
  project_id: e9d9ebbf-3083-4308-bcb7-72574cc114a8
  submitted_at: 2026-07-17
  status: submitted
  target_file: CDQuat/CDQuat.lean
  root_module: CDQuat
  expected_module: CDQuat
  grade_target: "M [orig formalization; comp Cayley-Dickson/Hurwitz theory]"
  model: claude
  work_item: GRAV-ORDER-OPERATOR-001
-->

# Aristotle task: Cayley-Dickson doubling of the quaternions preserves composition

## Goal

Close the single `s o r r y` in `CDQuat/CDQuat.lean`: prove `cd_norm_multiplicative`,
that the Cayley-Dickson double of the quaternions has a MULTIPLICATIVE norm,
`cdNormSq (cdMul p q) = cdNormSq p * cdNormSq q`.

Self-contained, Mathlib only (`Quaternion R`). `cdMul (a,b)(c,d) =
(a*c - star d * b, d*a + b * star c)`; `cdNormSq (a,b) = normSq a + normSq b`.

## Why it is true (proof sketch)

`Quaternion.normSq : H ->*0 R` is multiplicative (`map_mul`), `star` is a ring
anti-automorphism with `star q * q = normSq q` (`Quaternion.star_mul_self`), and
`H` is ASSOCIATIVE. Expand `normSq` of each component via the polar identity
`normSq (u + v) = normSq u + normSq v + <cross>` (the cross term is a real trace /
`re (u * star v)` type quantity). The associativity of `H` makes the two cross
terms (from the two `Octo` components) CANCEL, leaving `normSq(a)normSq(c) +
normSq(b)normSq(d) + normSq(d)normSq(b) + normSq(a)... ` collapsing to
`(normSq a + normSq b)(normSq c + normSq d)`. Useful Mathlib lemmas:
`map_mul Quaternion.normSq`, `Quaternion.star_mul_self`, `Quaternion.normSq_add`
(or the `coe_normSq_add` polar form), `star_mul`, `star_star`, and quaternion
`mul_assoc`. If a different (still genuine Cayley-Dickson) sign/conjugate
placement in `cdMul` is needed to make the cross terms cancel, adjust `cdMul`
minimally and note it - composition preservation holds for a genuine convention
over an associative base.

## Context

This is the FORWARD complement of the landed
`PhysicsSM/Draft/SedenionZeroDivisors.sedenion_composition_fails` (doubling the
NON-associative octonions LOSES composition). Together: the tower's
division/composition property is preserved by doubling exactly while the base is
associative, so it stops at O (the first non-associative member). No physics
numerics; pure algebra.

## Success criterion

`lake build CDQuat` with no `s o r r y`.
