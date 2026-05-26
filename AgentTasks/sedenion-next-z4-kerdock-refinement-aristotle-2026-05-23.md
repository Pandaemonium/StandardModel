# Aristotle N3: Z4 / Kerdock refinement moonshot

Create or modify:

```text
PhysicsSM/Draft/Sedenions/Z4KerdockRefinementMoonshot.lean
```

## Big Goal

Lift the signed sedenion plaquettes from `{+1,-1}` signs to `ZMod 4` quadratic
phase data and test whether they form a Kerdock/Barnes-Wall-style refinement.

Literature motivation:

- Stabilizer states can be described by affine supports and quadratic phases.
- Z4-valued Kerdock codewords exponentiate to stabilizer states.
- Barnes-Wall, Kerdock, Clifford, and stabilizer geometry are tightly linked.

## Existing Context

Use:

```text
PhysicsSM.Draft.Sedenions.CocycleQuadraticPhase
PhysicsSM.Draft.Sedenions.StabilizerMagicMoonshot
PhysicsSM.Draft.Sedenions.BarnesWallFirstShell
PhysicsSM.Draft.Sedenions.PSL27FlavorGeometry
```

## Desired Theorems

Try to prove:

1. Every signed zero-product plaquette phase pattern is the restriction of a
   `ZMod 4` quadratic phase on its affine 2-plane.
2. Classify the distinct quadratic phase patterns on the 42 supports.
3. Determine whether the 168 signed plaquettes are exactly the orbit of one
   quadratic phase under `GL(3,2)` plus gauge.
4. Define a candidate `Z4` lift of `C_ZD`, or prove that the local plaquette
   phases do not extend globally to such a lift.
5. If possible, compute an Arf-type invariant or a finite substitute that
   separates zero-product supports from the 21 sign-obstructed supports.

Suggested theorem names:

```lean
theorem plaquette_signs_are_Z4_quadratic_phases : ...
theorem signed_phase_patterns_classification : ...
theorem signed_plaquettes_single_quadratic_gauge_orbit : ...
theorem local_Z4_lift_extends_or_obstructed : ...
```

## Constraints

- Do not claim a Kerdock code unless a code or orbit predicate is explicitly
  defined and checked.
- A clean obstruction theorem is as useful as a positive lift theorem.
- No axioms, opaque constants, unsafe code, or admits.
