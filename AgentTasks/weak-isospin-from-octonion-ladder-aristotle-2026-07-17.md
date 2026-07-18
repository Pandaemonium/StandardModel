<!--
aristotle_job:
  slug: weak-isospin-from-octonion-ladder-20260717
  project_id: 661e5230-4a4b-46cd-95f4-713dadadd576
  submitted_at: 2026-07-17
  status: submitted
  target_file: PhysicsSM/Algebra/Furey/WeakIsospinFromLadder.lean
  check_path: PhysicsSM/Algebra/Furey/WeakIsospinFromLadder.lean
  expected_module: PhysicsSM.Algebra.Furey.WeakIsospinFromLadder
  grade_target: "M [orig formalization; comp Furey 1806.00612]"
  model: claude
  work_item: GRAV-ORDER-OPERATOR-001
-->

# Aristotle task: derive weak isospin `W⁺` from the octonionic ladder substrate

## Narrow build (do this FIRST)

Build only the target and its dependencies - do NOT build the whole project:

```
lake build PhysicsSM.Algebra.Furey.WeakIsospinFromLadder
```

Its transitive dependencies are the finite-algebra `PhysicsSM.Algebra.Furey.*`
and `PhysicsSM.Algebra.Octonion.*` subtree plus Mathlib - NOT the heavy
`PhysicsSM.Draft.NullEdge.*` tree. Do not `lake build` the full repo.

## Goal

Close the two `s o r r y`s in `PhysicsSM/Algebra/Furey/WeakIsospinFromLadder.lean`:

1. `TPlusLadder : JbarWavefunction →L[ℂ] JbarWavefunction` - construct the weak
   raising operator from the DIVISION-ALGEBRA ladder substrate.
2. `TPlusLadder_eq_TPlusEnd : TPlusLadder = TPlusEnd`.

## The uniqueness-anchored reduction (already in the file docstring)

`WeakIsospinLadderDerived.TPlusEnd_unique` reduces (2) to proving that
`TPlusLadder` satisfies six properties: `[T₃, T]=T`, `[Y, T]=0`, and the four
basis actions `7↦0, 1↦4, 2↦5, 3↦6` on `JbarBasisState`. Any operator satisfying
these EQUALS `TPlusEnd`, so you do not need to match the ket-bra definition
entry-by-entry - just verify the six hypotheses.

## The construction (Furey 1806.00612 eq. 37/42; faithful design note)

See `AgentTasks/null-edge-S2b-weak-isospin-from-ladder-design-2026-07-17.md`.
The weak `SU(2)_L` is NOT inside `Cl(6)` (the `alpha_i` generate only
`su(3)_c ⊕ u(1)`); it comes from the quaternionic `ℂ⊗ℍ` factor:
`B_j = i e₇ | β_j`, `T_+ = B_1^† B_2` on the minimal left ideal, transported by
`MinimalLeftIdeal.JbarSubmoduleLinearEquivWavefunction`. Available raw material:
`LadderOperators` (the `alpha_i`, `e₇ = e111` in XOR), `JbarActionTable.
alpha_mul_JbarBasisState'_eq_action` (full `alpha_k · v̄_j` table with signs),
`JbarCoordinateEquiv`.

## Hard constraint (semantic - do NOT violate)

`TPlusLadder` must be a GENUINE octonionic-substrate operator (a `ComplexOctonion`
left-action built from the ladder operators / `e₇` twist / quaternionic `β`,
transported through the coordinate equivalence). Do NOT define it as an ad-hoc
`M(8,ℂ)` matrix / raw ket-bra sum and then verify - that defeats the purpose
(exhibiting `W⁺` as arising from division-algebra structure) and would be a
false-shape result. The convention guard: XOR-basis octonions (not Baez/Furey
verbatim); pass any product formula through the established `alpha_i` definitions
in `LadderOperators`.

## Acceptable alternative return

If the natural `β/e₇` construction genuinely cannot satisfy the six hypotheses,
return a documented NO-GO analysis: which hypothesis fails, the obstruction, and
whether a different (still substrate-natural) operator could work. A rigorous
no-go is a valuable result, not a failure.

## Success criterion

`lake build PhysicsSM.Algebra.Furey.WeakIsospinFromLadder` succeeds with no
`s o r r y` and `TPlusLadder` manifestly built from the ladder substrate.
