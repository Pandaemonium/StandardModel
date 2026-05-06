# Task: Octonion Derivation Closure Facts

**Agent**: Aristotle
**Status**: Submitted
**Priority**: Medium-high
**Job ID**: `c8b9c03a-b34e-423f-a362-ffe278b99fc8`
**Output**: `AgentTasks/aristotle-output/octonion-derivation-closure`

## Goal

Strengthen the derivation infrastructure in:

```text
PhysicsSM/Lie/Exceptional/OctonionSymmetry.lean
```

The file already defines:

```lean
def IsOctonionDerivation (D : Octonion -> Octonion) : Prop := ...

theorem octonionDerivation_kills_one {D : Octonion -> Octonion}
    (hD : IsOctonionDerivation D) :
    D 1 = 0 := ...
```

Add closure facts showing that derivations form a real vector space/submodule
inside the function space `Octonion -> Octonion`.

## Suggested Lean declarations

Use descriptive names. The exact theorem names may be adjusted if needed, but
keep the mathematical content.

```lean
/-- The zero map is an octonion derivation. -/
theorem zero_isOctonionDerivation :
    IsOctonionDerivation (fun _ : Octonion => 0) := by ...

/-- The sum of two octonion derivations is an octonion derivation. -/
theorem add_isOctonionDerivation {D E : Octonion -> Octonion}
    (hD : IsOctonionDerivation D) (hE : IsOctonionDerivation E) :
    IsOctonionDerivation (D + E) := by ...

/-- The negation of an octonion derivation is an octonion derivation. -/
theorem neg_isOctonionDerivation {D : Octonion -> Octonion}
    (hD : IsOctonionDerivation D) :
    IsOctonionDerivation (-D) := by ...

/-- A real scalar multiple of an octonion derivation is an octonion derivation. -/
theorem smul_isOctonionDerivation (r : Real) {D : Octonion -> Octonion}
    (hD : IsOctonionDerivation D) :
    IsOctonionDerivation (r • D) := by ...

/--
The real submodule of all octonion derivations.

This is only the linear closure infrastructure. It does not assert that the
space has dimension 14 or that it is the Lie algebra `g2`.
-/
def octonionDerivationSubmodule : Submodule Real (Octonion -> Octonion) := ...
```

If `Submodule Real (Octonion -> Octonion)` requires an import or runs into
instance issues, add the closure theorems first and include a clear note in the
result. Do not weaken the existing `IsOctonionDerivation` predicate.

## Proof hints

- The scalar/additive parts are function extensionality plus the corresponding
  hypotheses from `hD` and `hE`.
- The Leibniz rule for sums should reduce to distributivity:

```text
(D + E) (x * y)
= D (x * y) + E (x * y)
= (D x * y + x * D y) + (E x * y + x * E y)
= (D x + E x) * y + x * (D y + E y)
```

- The scalar case similarly uses distributivity of scalar multiplication over
  octonion addition and compatibility of real scalar multiplication with the
  concrete octonion multiplication.

## Constraints

- Modify only `PhysicsSM/Lie/Exceptional/OctonionSymmetry.lean`.
- Do not introduce `sorry`, `admit`, `axiom`, `opaque`, or `unsafe def`.
- Do not claim `Der(O)` has dimension 14.
- Do not claim `Der(O) = g2`.
- Run:

```bash
lake env lean PhysicsSM/Lie/Exceptional/OctonionSymmetry.lean
```

## Expected result

The project has a reusable derivation submodule, giving future G2 work a clean
linear-algebra object to study.
