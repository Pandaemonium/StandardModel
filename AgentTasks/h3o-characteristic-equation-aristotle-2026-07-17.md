<!--
aristotle_job:
  slug: h3o-characteristic-equation-20260717
  project_id: 0bb218ae-1765-4fb0-af19-0be22ccf8635
  submitted_at: 2026-07-17
  status: submitted
  target_file: PhysicsSM/Draft/H3OCharacteristicEquation.lean
  check_path: PhysicsSM/Draft/H3OCharacteristicEquation.lean
  expected_module: PhysicsSM.Draft.H3OCharacteristicEquation
  grade_target: "M [orig formalization; comp Baez/DVT; interp for the generation reading]"
  model: claude
  work_item: GRAV-ORDER-OPERATOR-001
-->

# Aristotle task: the cubic characteristic equation of `h₃(O)` (item 9 structure)

## Narrow build (FIRST)

```
lake build PhysicsSM.Draft.H3OCharacteristicEquation
```

Dependencies: the finite-algebra `PhysicsSM.Algebra.Jordan.H3O` +
`PhysicsSM.Algebra.Octonion.*` subtree + Mathlib. Do NOT build the whole repo.

## Goal

Close the one `s o r r y` in `PhysicsSM/Draft/H3OCharacteristicEquation.lean`:
prove `h3o_characteristic_equation` -

```
X ○ (X ○ X) = (trace X) • (X ○ X) - (sigmaH3O X) • X + (detH3O X) • oneH3O
```

for every `X : H3O` (the exceptional Jordan algebra `h₃(O)`, Jordan product
`H3O.jordanProduct`). This is the generic cubic minimal polynomial of a Euclidean
Jordan algebra - a TRUE theorem; the task is the intricate finite octonionic
coordinate computation.

## The determinant (may need repair)

`detH3O` is given as the Freudenthal cubic norm
`αβγ - αN(x) - βN(y) - γN(z) + 2 Re(x(yz))`. The triple-product Re-term is
parenthesization-independent (octonion associator is purely imaginary), but the
FACTOR ORDER (`x,y,z` vs a cyclic permutation) and sign are fixed by the actual
`3×3` cofactor expansion of the Hermitian matrix
`[[α,z,ȳ],[z̄,β,x],[y,x̄,γ]]`. If the identity does not close with the current
`detH3O`, REPAIR `detH3O` to the genuine cofactor determinant (keep its shape:
diagonal product minus the three `ξ·N` terms plus twice a real triple product) -
do NOT alter the shape of the characteristic equation to force a fit.

`sigmaH3O = ½((tr X)² - tr(X ○ X))` is the standard second invariant and should
not need changing.

## Pre-registered kill condition

If the identity provably FAILS at a specific coordinate for the genuine
determinant (a surviving associator obstruction in the real cubic form), STOP and
return a documented analysis: which coordinate/term fails, the associator
correction, and whether a modified cubic form holds. A rigorous obstruction
analysis is a valuable, acceptable return.

## Discipline note (do not violate)

This is a STRUCTURAL algebraic identity. Do NOT add any physical-mass numerics,
Yukawa values, or generation-mass assignments - the "three eigenvalues = three
generations" reading is a labeled interpretation only.

## Success criterion

`lake build PhysicsSM.Draft.H3OCharacteristicEquation` with no `s o r r y`.
