# CodeLatticeE8 native-decide replacement Aristotle wave - 2026-05-20

Status: completed and integrated.

Purpose: reduce the documented `Lean.trustCompiler` surface in the clean
`CodeLatticeE8` package by replacing selected bounded `native_decide` proofs
with structural Lean proofs.

## Submission project

```text
AgentTasks/aristotle-submit/code-lattice-e8-native-replacement-20260520-project
```

This is a minimal project copy containing only:

- `CodeLatticeE8/`
- `CodeLatticeE8.lean`
- `CodeLatticeE8Draft.lean`
- `lakefile.toml`
- `lake-manifest.json`
- `lean-toolchain`

It deliberately omits `.lake`, `.git`, old `AgentTasks/aristotle-output`
extracts, and the optional Sphere-Packing-Lean dependency.  A local targeted
build of `CodeLatticeE8.E8.WeylReflections` passed before submission.

## Candidate ranking

The remaining clean-package `native_decide` uses fall into three groups:

1. **Good structural targets now**
   - Cartan cofactor minors in `E8/CartanBridge.lean`;
   - short-vector weight-0 and weight-4 counts in `E8/ShortVectors.lean`;
   - Weyl reflection closure/involutivity in `E8/WeylReflections.lean`.

2. **Possible, but should be decomposed after the first wave**
   - root-list type-1/type-2 lengths and no-duplicate proofs;
   - semantic completeness of `Roots.rootList`.

3. **Least suitable as a first job**
   - the full `RootBridge.shortShell_perm_rootList` permutation proof over two
     explicit 240-element lists.  This should be attacked only after root-list
     and short-shell classifications are more structural.

## Submitted jobs

| Job | Target | Aristotle ID | Status |
|-----|--------|--------------|--------|
| C1 | Cartan minor determinants without `native_decide` | `fea98294-7465-4f77-a5b8-8350c5cd5989` | integrated |
| S1 | Short-vector weight class counts without `native_decide` | `38b65cb5-a5aa-4c46-a12a-ee3416e4f9a2` | integrated |
| W1 | Semantic Weyl reflection preservation | `7b80b55e-6a6b-4cf8-a147-2d3ee1c0bed5` | integrated |

Downloaded result packages:

```text
AgentTasks/aristotle-output/code-lattice-e8-C1-cartan-minors-20260520
AgentTasks/aristotle-output/code-lattice-e8-S1-short-vector-counts-20260520
AgentTasks/aristotle-output/code-lattice-e8-W1-weyl-semantic-20260520
```

Extracted review copies:

```text
AgentTasks/aristotle-output/code-lattice-e8-C1-cartan-minors-20260520-extracted
AgentTasks/aristotle-output/code-lattice-e8-S1-short-vector-counts-20260520-extracted
AgentTasks/aristotle-output/code-lattice-e8-W1-weyl-semantic-20260520-extracted
```

Integration notes:

- C1 replaced the two Cartan 7-by-7 `native_decide` determinant proofs with
  nested cofactor expansions to four 6-by-6 kernel `decide` checks.
- S1 replaced the short-vector weight-0 and weight-4 cardinality proofs with
  private finite parametrizations.
- W1 added semantic Weyl reflection theorems over `Roots.IsE8Root` and rewired
  the public root-list closure/involutivity API through those semantic proofs.

Targeted checks after integration:

```text
lake build CodeLatticeE8.E8.CartanBridge
lake build CodeLatticeE8.E8.ShortVectors
lake build CodeLatticeE8.E8.WeylReflections
```

## Job C1: Cartan cofactor minors

Target file:

```text
CodeLatticeE8/E8/CartanBridge.lean
```

Goal: replace the two private proofs

```lean
private theorem e8CartanMinor00_det : Matrix.det e8CartanMinor00 = 4 := by native_decide
private theorem e8CartanMinor02_det : Matrix.det e8CartanMinor02 = 7 := by native_decide
```

with structural Lean proofs.  It is acceptable to add private helper lemmas,
for example small tridiagonal determinant recurrences or cofactor expansions.

Constraints:

- no `sorry`, `admit`, `axiom`, `unsafe`, or new opaque placeholders;
- do not weaken public statements;
- do not use `native_decide`;
- do not ask Lean to evaluate the full 8-by-8 determinant directly;
- keep changes local to `CodeLatticeE8/E8/CartanBridge.lean` unless a tiny
  import is truly necessary.

## Job S1: Short-vector class counts

Target file:

```text
CodeLatticeE8/E8/ShortVectors.lean
```

Goal: replace the private finite counts

```lean
private theorem shortShellByWeight0_card :
    (shortShellByWeight 0).card = 16 := by native_decide

private theorem shortShellByWeight4_card :
    (shortShellByWeight 4).card = 224 := by native_decide
```

with structural proofs.

Suggested proof route:

- weight 0: all coordinates are even and `sqNorm = 4`; exactly one coordinate
  is `+2` or `-2`, so the count is `8 * 2 = 16`;
- weight 4: choose one of the 14 weight-four Hamming codewords, and then choose
  signs on its four odd coordinates, giving `14 * 2^4 = 224`;
- weight 8 is already structurally empty by `not_short_of_weight8`;
- reuse promoted Hamming weight distribution results where possible.

Constraints:

- no `native_decide` in the replacement proofs;
- no changes to the public theorem
  `hammingConstructionA_short_vector_count`;
- helper definitions are welcome if they make the counting argument clearer.

## Job W1: Weyl reflection semantic preservation

Target file:

```text
CodeLatticeE8/E8/WeylReflections.lean
```

Optional supporting file:

```text
CodeLatticeE8/E8/Roots.lean
```

Goal: add structural semantic theorems that can replace or reduce these
root-list enumerations:

```lean
private theorem dot_mod_four_eq_zero_all : ...
private theorem reflect_mem_rootList_all : ...
private theorem reflect_involutive_all : ...
```

Preferred new theorem:

```lean
theorem reflect_preserves_IsE8Root {r v : Fin 8 -> Int}
    (hr : IsE8Root r) (hv : IsE8Root v) :
    IsE8Root (reflect r v)
```

If possible, also prove an algebraic involutivity theorem from the semantic
root hypotheses and exact divisibility of `dot v r` by 4.

Constraints:

- no `native_decide` in the new semantic theorem;
- do not remove the existing finite checks unless the structural proof fully
  replaces them;
- keep all declarations in namespace `CodeLatticeE8.E8.WeylReflections`;
- preserve doubled-coordinate conventions.
