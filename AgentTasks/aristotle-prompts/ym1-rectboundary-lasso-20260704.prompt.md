# Aristotle proof job: YM1 rectangular boundary lasso identity

You are proving a Lean 4 theorem in a Mathlib-based project. Work in the
provided project directory. Do not weaken theorem statements, change
definitions, add new assumptions, or prove a different ordering. Return the
edited target file plus a concise report.

## Target file and command

Target file:

```text
PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryLasso.lean
```

Run this narrow check first and optimize for it:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryLasso.lean
```

If that succeeds, also run:

```text
lake build PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryLasso
```

## Exact proof targets

The main target is:

```lean
theorem rectBoundary_hol_eq_reversedRowMajorPlaquetteProd_of_treeSlice {Lx Ly : Nat}
    (U : (rectLattice Lx Ly).LinkField (G := G))
    (hTree : IsCombTreeSlice Lx Ly U) :
    OrientedLattice.hol U (rectBoundaryWalk Lx Ly)
      = reversedRowMajorPlaquetteProd Lx Ly U := by
```

The corollary should remain a direct consequence:

```lean
theorem apply_rectBoundary_hol_eq_reversedRowMajorPlaquetteProd_of_treeSlice
    {Lx Ly : Nat} (chi : G -> alpha)
    (U : (rectLattice Lx Ly).LinkField (G := G))
    (hTree : IsCombTreeSlice Lx Ly U) :
    chi (OrientedLattice.hol U (rectBoundaryWalk Lx Ly))
      = chi (reversedRowMajorPlaquetteProd Lx Ly U) := by
```

You may add small helper lemmas in the same namespace if useful. Keep the public
definitions and theorem statements semantically unchanged unless you explain a
type-correctness issue and give the smallest correction.

## Mathematical statement

The rectangle is the concrete open `Lx x Ly` lattice from
`RectTreeGauge.lean`:

- vertices: `Fin (Lx + 1) x Fin (Ly + 1)`;
- horizontal links `Sum.inl (i, j)` go from `(i, j)` to `(i+1, j)`;
- vertical links `Sum.inr (i, j)` go from `(i, j)` to `(i, j+1)`;
- plaquette `(i,j)` has counterclockwise holonomy
  right/up/left-reverse/down-reverse, pinned by
  `rectPlaquette_hol_formula`;
- comb tree links are all horizontal links plus the leftmost vertical column,
  embedded by `treeLink`.

`IsCombTreeSlice Lx Ly U` means all comb-tree links have value `1`.

`reversedRowMajorPlaquetteProd Lx Ly U` is the noncommutative ordered product:

```text
P(Lx-1,0) * ... * P(0,0) *
P(Lx-1,1) * ... * P(0,1) *
...
P(Lx-1,Ly-1) * ... * P(0,Ly-1)
```

where `P(i,j)` is `(rectPlaquette Lx Ly (i,j)).hol U`.

The boundary walk is bottom, right, inverse top, inverse left, pinned by
`rectBoundary_hol_formula`.

The intended proof is the finite tree-slice lasso/telescoping identity:

- under `hTree`, all horizontal links are `1` and the leftmost vertical column
  is `1`;
- each plaquette holonomy in row `j` reduces to
  `U (Sum.inr (i.succ, j)) * (U (Sum.inr (i.castSucc, j)))^-1`;
- multiplying a row in reversed `i` order telescopes to the right boundary
  vertical link at row `j`, because the left-column factor is a tree link;
- multiplying rows in increasing `j` gives the right-side boundary holonomy;
- the bottom, top, and left boundary factors are tree links, so the boundary
  holonomy reduces to the same right-side vertical product.

## Guardrails

- Do not attempt or claim the pointwise identity at general tree values; that is
  expected false.
- Do not reverse the row order in `j`.
- Do not replace `List.ofFn`/`List.prod` with a commutative `Finset.prod`.
- Do not weaken to an abelian or commutative gauge group.
- Do not use new assumptions, fake declarations, unsafe code, or escape-hatch
  tokens.

## Context artifacts

Use these files as context:

- `PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryLasso.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/RectTreeGauge.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/GaugeCoreGeneral.lean`
- `AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md`
- `AgentTasks/ym1-rectboundary-lasso-aristotle-2026-07-04.md`
- `AgentTasks/context-packs/ym1-rectboundary-lasso-20260704-20260704-121001.md`

Finish with a report containing:

- solved targets;
- any helper lemmas added;
- exact commands run and results;
- any remaining proof holes;
- whether any statement or definition changed.
