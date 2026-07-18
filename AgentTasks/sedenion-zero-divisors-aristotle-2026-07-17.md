<!--
aristotle_job:
  slug: sedenion-zero-divisors-20260717
  project_id: 6af39d1c-45ae-44f8-ae70-1ea85cce52e0
  submitted_at: 2026-07-17
  status: submitted
  target_file: PhysicsSM/Draft/SedenionZeroDivisors.lean
  check_path: PhysicsSM/Draft/SedenionZeroDivisors.lean
  expected_module: PhysicsSM.Draft.SedenionZeroDivisors
  grade_target: "M [orig formalization; comp Cayley-Dickson/Hurwitz theory]"
  model: claude
  work_item: GRAV-ORDER-OPERATOR-001
-->

# Aristotle task: the sedenions have zero divisors (item 5, why `O` is maximal)

## Narrow build (FIRST)

```
lake build PhysicsSM.Draft.SedenionZeroDivisors
```

Deps: `PhysicsSM.Algebra.Octonion.*` + Mathlib only. Do NOT build the whole repo.

## Goal

Close the single `s o r r y` in `PhysicsSM/Draft/SedenionZeroDivisors.lean`:
prove `sedenions_have_zero_divisors` - exhibit two NONZERO sedenions
`a b : Octonion × Octonion` with `sedenionMul a b = 0`.

`sedenionMul` is the Cayley-Dickson double product
`(a,b)(c,d) = (a c - conj d · b, d a + b · conj c)`. The octonion product `*`,
`conj`, and coordinate lemmas (`Octonion.mul_c0..c7`, `Octonion.conj`, the
`Octonion.ext` structure) are available.

## Notes

- The theorem is TRUE: doubling the non-associative octonions yields the
  sedenions, which are well-known to have zero divisors.
- FIND a valid witness pair for THIS project's XOR octonion convention and
  `Octonion.conj` - do NOT assume a literature basis (e.g. the standard
  `(e_3+e_{10})(e_6-e_{15})=0`) matches; verify by computing `sedenionMul` on the
  candidate (a finite octonion-coordinate computation, e.g. `Prod.ext` then the
  `mul_c*` simp lemmas, then `ring`/`norm_num`).
- If the exact `sedenionMul` sign/conjugate placement in the skeleton is not a
  genuine Cayley-Dickson double, adjust it minimally to a genuine one and note
  the change; existence of a zero divisor holds for every genuine convention.
- Nonzeroness (`a ≠ 0`, `b ≠ 0`) of a `Prod` witness: show a component is nonzero
  via a nonzero coordinate.

## Success criterion

`lake build PhysicsSM.Draft.SedenionZeroDivisors` with no `s o r r y`.
