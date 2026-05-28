# Aristotle task: octavian unit closure for CodeLatticeE8

Status: out of budget; superseded by structural closure job
`98138111-f6ae-45c7-9bad-3816f8454edc`.

Submission project:

```text
AgentTasks/aristotle-submit/code-lattice-e8-octavian-closure-20260526-project
```

Aristotle ID:

```text
9f0a1921-b6a6-4ebd-8a19-b00373215006
```

Purpose: finish the multiplicative closure theorem for the new standalone
`CodeLatticeE8.Octonion` layer.

## Context

The clean package now contains:

- `CodeLatticeE8.Octonion.CayleyDickson`
  - `fanoTriples`
  - `xorIndex`
  - `sign`
- `CodeLatticeE8.Octonion.Basic`
  - `Coords`
  - `mulInt`
  - `normSqInt`
  - `normSqInt_mulInt`
- `CodeLatticeE8.Octonion.Octavian`
  - `octavianUnitMul`
  - a checked coordinate-unit subcase:
    `octavianUnitMul_mem_shortShell_of_mem_coordinateShortVectorList`

The convention is the Cayley-Dickson convention stated in
`CodeLatticeE8.Octonion.CayleyDickson`.  Please keep the `CodeLatticeE8`
package self-contained and do not refer to or import any older octonion
development from elsewhere in the repository.

## Desired theorem package

Please prove, in `CodeLatticeE8/Octonion/Octavian.lean`, the full closure
theorem for the 240 Hamming Construction A short-shell vectors:

```lean
theorem two_dvd_mulInt_of_shortShell {x y : Coords Z}
    (hx : x in hammingE8ShortShell) (hy : y in hammingE8ShortShell)
    (k : Fin 8) :
    2 ∣ mulInt x y k := by
  ...

theorem octavianUnitMul_mem_hammingConstructionA {x y : Coords Z}
    (hx : x in hammingE8ShortShell) (hy : y in hammingE8ShortShell) :
    octavianUnitMul x y in hammingConstructionA := by
  ...

theorem octavianUnitMul_sqNorm {x y : Coords Z}
    (hx : x in hammingE8ShortShell) (hy : y in hammingE8ShortShell) :
    sqNorm (octavianUnitMul x y) = 4 := by
  ...

theorem octavianUnitMul_mem_shortShell {x y : Coords Z}
    (hx : x in hammingE8ShortShell) (hy : y in hammingE8ShortShell) :
    octavianUnitMul x y in hammingE8ShortShell := by
  ...
```

Use actual Lean syntax (`∈`, `ℤ`) in the implementation; the snippets above use
ASCII words only to keep this task note plain-text friendly.

## Proof guidance

The naive proof

```lean
shortShellVectorList.Forall (fun x =>
  shortShellVectorList.Forall (fun y => ...))
```

with a monolithic `decide` over all 240 by 240 pairs timed out locally after
ten minutes.  Please avoid that shape.

Promising proof route:

1. Prove the integrality/parity part by using the structure of
   `hammingE8ShortShell`:
   - coordinate-unit part: already checked by the current file;
   - weight-four part: use the Hamming code support/sign parametrization from
     `ShortVectors.lean` or split `shortShellVectorList` into
     `coordinateShortVectorList` and `weightFourShortVectorList`.
2. Once `2 ∣ mulInt x y k` is known for all coordinates, prove
   `mulInt x y = fun k => 2 * octavianUnitMul x y k`.
3. Use `normSqInt_mulInt` plus `hx.2` and `hy.2` to derive the norm-four result.
4. Combine parity membership and norm-four membership to prove
   `octavianUnitMul_mem_shortShell`.

It is acceptable to add small helper lemmas to
`CodeLatticeE8.Octonion.Octavian` or `CodeLatticeE8.Octonion.Basic`.  Please
do not use `native_decide`, `axiom`, `unsafe`, `admit`, or `sorry` in files that
will be imported by `CodeLatticeE8`.

## Verification target

At minimum:

```text
lake build CodeLatticeE8.Octonion.Octavian
lake build CodeLatticeE8
```

The current `CodeLatticeE8` root builds before this follow-up.
