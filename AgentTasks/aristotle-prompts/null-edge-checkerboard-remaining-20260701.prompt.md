# Aristotle prompt: checkerboard remaining finite targets

You are working in a focused Lean 4 package extracted from the `PhysicsSM`
null-edge standalone package. The target file is:

```text
PhysicsSM/Draft/Checkerboard1D.lean
```

Run the narrow check first:

```text
lake env lean PhysicsSM/Draft/Checkerboard1D.lean
```

## Context

The module formalizes the 1+1D finite Feynman-checkerboard seed. It already
contains:

- `Direction := Fin 2`
- `checkerStep r l mu`
- list path amplitude `pathAmp`
- list turn count `turnCount`
- tuple path amplitude `pathAmpVec`
- tuple turn count `turnCountVec`
- `pathAmp_factor`
- `pathAmpVec_factor`
- `checkerStep_pow_apply`
- `checkerStep_pow_apply_factored`
- `checkerStep_pow_apply_turnGrouped`
- `checkerStep_pow_apply_isotropic`
- `checkerboard_recurrence`

The physical reading is finite algebra only: `mu` is the null-direction reversal
amplitude. Do not claim a continuum limit.

## Goals

Please prove as many of the following as possible, adding small helper lemmas
with clear names. Do not weaken existing statements.

### Goal 1: reverse-path turn invariance

Prove a theorem equivalent to:

```lean
theorem turnCount_reverse :
    forall path : List Direction, turnCount path.reverse = turnCount path
```

If the exact statement needs a helper for append/snoc, add it.

### Goal 2: tuple/list bridge

Prove tuple/list bridge lemmas, preferably with these statements or close
equivalents:

```lean
theorem pathAmpVec_eq_pathAmp_ofFn (r l mu : Complex) :
    forall {n : Nat} (v : Fin (n + 1) -> Direction),
      pathAmpVec r l mu v = pathAmp r l mu (List.ofFn v)

theorem turnCountVec_eq_turnCount_ofFn :
    forall {n : Nat} (v : Fin (n + 1) -> Direction),
      turnCountVec v = turnCount (List.ofFn v)
```

If `List.ofFn` is inconvenient, use the best mathlib tuple-to-list API and
state the bridge clearly.

### Goal 3: unitarity / normalization audit

Try to prove a finite consistency theorem for the isotropic transfer. A useful
target is that

```text
checkerStep (Real.cos theta) (Real.cos theta)
  (Complex.I * (Real.sin theta : Complex))
```

is unitary, in the sense that its conjugate transpose times itself is the
identity. If this statement is not the right Lean formulation, return the exact
recommended theorem statement and any blockers.

## Output requirements

- Return the modified target file and a short report.
- No placeholder proofs, new assumptions, or fake declarations.
- If a theorem is not proved, leave it out and explain the blocker in the
  report rather than adding unfinished trusted code.
- Keep theorem statements finite. Do not claim the 1+1D Dirac continuum limit.
