# Aristotle task: structural octavian multiplication closure

Status: complete; fetched and integrated 2026-05-28.

Aristotle ID:

```text
98138111-f6ae-45c7-9bad-3816f8454edc
```

Purpose: finish the multiplicative closure theorem for the standalone
`CodeLatticeE8.Octonion` layer without a 240-by-240 short-shell enumeration.

## Submission project

To be created at:

```text
AgentTasks/aristotle-submit/code-lattice-e8-octavian-structural-closure-20260527-project
```

Output destination:

```text
AgentTasks/aristotle-output/code-lattice-e8-octavian-structural-closure-20260527
```

Fetched result:

```text
aristotle result 98138111-f6ae-45c7-9bad-3816f8454edc --destination AgentTasks/aristotle-output/code-lattice-e8-octavian-structural-closure-20260527
```

Integration note:

- Aristotle supplied the basis/span proof of order closure with no
  `native_decide`.
- A parallel Claude attempt introduced a useful self-duality/XOR parity module,
  but its large mod-two simplification triggered a Lean 4.28 linter panic in
  local builds. The integrated package therefore keeps the cleaner Aristotle
  basis/span closure route in `CodeLatticeE8/Octonion/Octavian.lean` and does
  not keep the separate parity module.
- The old 240-by-240 short-shell membership check was removed.

## Target

Modify:

```text
CodeLatticeE8/Octonion/Octavian.lean
```

Stay in namespace:

```lean
namespace CodeLatticeE8.Octonion
```

It is acceptable to add small helper lemmas to
`CodeLatticeE8/Octonion/Basic.lean` if needed, but prefer keeping the proof
package in `Octavian.lean`.

## Existing context

Relevant octonion code:

- `CodeLatticeE8.Octonion.Coords`
- `CodeLatticeE8.Octonion.mulInt`
- `CodeLatticeE8.Octonion.normSqInt`
- `CodeLatticeE8.Octonion.normSqInt_mulInt`
- `CodeLatticeE8.Octonion.octavianUnitMul`

Relevant E8 / Construction A code:

- `CodeLatticeE8.E8.hammingConstructionA`
- `CodeLatticeE8.E8.hammingE8ShortShell`
- `CodeLatticeE8.E8.hammingConstructionBasis`
- `CodeLatticeE8.E8.hammingConstructionBasis_mem`
- `CodeLatticeE8.E8.hammingConstructionASubmodule`
- `CodeLatticeE8.E8.hammingConstructionASubmodule_eq_span`
- `CodeLatticeE8.E8.shortShell_mem_shortShellVectorList`

You may add:

```lean
import CodeLatticeE8.E8.Span
```

if the spanning theorem is not already available through current imports.

## Main proof strategy

Do not prove the theorem by checking all pairs in `shortShellVectorList`.
Avoid a theorem of the form:

```lean
shortShellVectorList.Forall (fun x =>
  shortShellVectorList.Forall (fun y => ...))
```

The intended structural route is:

1. Prove helper bilinearity lemmas for `mulInt`, by coordinate extensionality,
   `fin_cases`, `simp [mulInt]`, and `ring`.
2. Prove the normalized product of the eight displayed Construction A basis
   vectors is back in the lattice. A finite check over the 8 by 8 basis pairs
   is acceptable and encouraged.
3. Use `hammingConstructionASubmodule_eq_span` to express arbitrary
   `hammingConstructionA` vectors as integer linear combinations of these
   eight basis vectors.
4. Use bilinearity to reduce arbitrary product closure to the 64 basis-pair
   closures.
5. Use `normSqInt_mulInt` to prove the unit-shell norm statement.

This proves closure of the octavian order first, then proves closure of the
240 norm-one units as a corollary. This is the desired mathematical structure.

## Desired theorem package

Please prove the following public theorem package, with exact names if
reasonable. If a different helper theorem name is cleaner, keep the final
short-shell theorem name unchanged.

```lean
/-- The normalized doubled-coordinate product of two Hamming Construction A
lattice vectors is again in the Hamming Construction A lattice. -/
theorem octavianUnitMul_mem_hammingConstructionA {x y : Coords Int}
    (hx : x in hammingConstructionA) (hy : y in hammingConstructionA) :
    octavianUnitMul x y in hammingConstructionA := by
  ...

/-- For lattice vectors, dividing `mulInt x y` by two is exact coordinatewise. -/
theorem two_mul_octavianUnitMul_eq_mulInt {x y : Coords Int}
    (hx : x in hammingConstructionA) (hy : y in hammingConstructionA)
    (k : Fin 8) :
    2 * octavianUnitMul x y k = mulInt x y k := by
  ...

/-- Product of two unit-shell vectors has unscaled squared norm four. -/
theorem octavianUnitMul_sqNorm {x y : Coords Int}
    (hx : x in hammingE8ShortShell) (hy : y in hammingE8ShortShell) :
    sqNorm (octavianUnitMul x y) = 4 := by
  ...

/-- The normalized Cayley-Dickson product closes on the 240 octavian units. -/
theorem octavianUnitMul_mem_shortShell {x y : Coords Int}
    (hx : x in hammingE8ShortShell) (hy : y in hammingE8ShortShell) :
    octavianUnitMul x y in hammingE8ShortShell := by
  ...
```

The snippets above use ASCII `in` only for readability in this task note.
Use actual Lean membership syntax in the implementation.

Optional compatibility theorem:

```lean
theorem two_dvd_mulInt_of_shortShell {x y : Coords Int}
    (hx : x in hammingE8ShortShell) (hy : y in hammingE8ShortShell)
    (k : Fin 8) :
    2 divides mulInt x y k := by
  ...
```

## Constraints

- No `sorry`, `admit`, new `axiom`, `opaque`, or `unsafe def` in trusted code.
- Do not weaken theorem statements to make the proof easier.
- Do not use `native_decide`.
- Avoid the 240-by-240 short-shell brute-force proof shape.
- A finite 8-by-8 basis multiplication certificate is acceptable.
- Keep the `CodeLatticeE8` package self-contained; do not import older
  `PhysicsSM.Algebra.Octonion` modules.
- Preserve the Cayley-Dickson convention in `CodeLatticeE8.Octonion.CayleyDickson`.

## Verification target

At minimum:

```text
lake build CodeLatticeE8.Octonion.Octavian
lake build CodeLatticeE8
```

Local pre-submission check:

```text
lake build CodeLatticeE8.Octonion.Octavian
```

passed on 2026-05-27 before submission.

Integrated verification:

```text
lake build CodeLatticeE8.Octonion.Octavian
lake build CodeLatticeE8
pre-commit run --all-files
pre-commit run --files CodeLatticeE8.lean CodeLatticeE8/Publication/TheoremIndex.lean CodeLatticeE8/Octonion/Basic.lean CodeLatticeE8/Octonion/CayleyDickson.lean CodeLatticeE8/Octonion/Octavian.lean AgentTasks/code-lattice-e8-octavian-closure-aristotle-2026-05-26.md AgentTasks/code-lattice-e8-octavian-structural-closure-aristotle-2026-05-27.md
lake build
```

passed on 2026-05-28 after integration. The full `lake build` emitted
pre-existing linter warnings in unrelated `PhysicsSM/*` files.
