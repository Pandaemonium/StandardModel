# Aristotle prompt: 1+1D checkerboard path-sum next step

You are Aristotle working on the PhysicsSM null-edge project.

This is a focused standalone Lean package, not the full repository. Start with:

```text
lake build CheckerboardPathsum
```

## Context

Codex added a new finite 1+1D checkerboard seed:

```text
PhysicsSM/Draft/Checkerboard1D.lean
```

The package also includes:

```text
NullEdgeStandalone/docs/CHECKERBOARD_1D.md
NullEdgeStandalone/docs/PHYSICS_CONTEXT.md
NullEdgeStandalone/docs/ARISTOTLE_EVALUATION.md
```

The scientific aim is to make the slogan

```text
mass = obstruction to staying one null mode
```

dynamical in 1+1D before returning to the 3+1D branch problem.

## Current checked seed

The module defines:

```text
Direction := Fin 2
rightState
leftState
directionGrade
reversal
nullTransport r l
massFlip mu
checkerStep r l mu
edgeAmp r l mu
pathAmp r l mu
HasTurn
```

Already proved:

```text
checkerStep_eq
checkerStep_zero_mass
checkerStep_right_to_left
checkerStep_left_to_right
massless_step_right
massless_step_left
massFlip_right
massFlip_left
nullTransport_commutes_directionGrade
massFlip_anticommutes_directionGrade
checkerStep_sq
checkerStep_sq_zero_mass
edgeAmp_eq_checkerStep_entry
edgeAmp_zero_mass_of_turn
pathAmp_zero_mass_of_hasTurn
```

## Requested work

Please do as much of the following as possible, without weakening existing
statements.

1. Add finite path combinatorics to `PhysicsSM/Draft/Checkerboard1D.lean`.
   Good targets:

   - `turnCount : List Direction -> Nat`
   - theorem: `HasTurn path` iff `0 < turnCount path`
   - theorem: if `turnCount path = 0`, then all consecutive directions agree
   - theorem: `pathAmp r l mu path` factors as a direction-preserving product
     times `mu ^ turnCount path`, or a clean weaker version that is easy to
     maintain.

2. Add a matrix-power/path-sum theorem if tractable. A useful shape is:

   ```text
   (checkerStep r l mu ^ n) outgoing incoming
   =
   sum over paths of length n from incoming to outgoing of pathAmp r l mu path
   ```

   It is acceptable to introduce a clean finite path type if that makes the
   theorem more natural.

3. If the power theorem is too large, produce a theorem-statement plan with
   precise Lean definitions and intermediate lemmas.

4. Write a short `CHECKERBOARD_ARISTOTLE_REPORT.md` explaining:

   - what was proved;
   - what theorem statements should be attempted next;
   - what analytic assumptions are needed for a future continuum Dirac limit;
   - what remains outside finite Lean algebra.

## Rules

- Do not introduce placeholder or escape-hatch declarations.
- Do not change the physical reading: `mu` is the reversal/mass amplitude.
- Do not claim a continuum limit unless it is actually formalized.
- Prefer small helper lemmas over a brittle monolithic proof.
