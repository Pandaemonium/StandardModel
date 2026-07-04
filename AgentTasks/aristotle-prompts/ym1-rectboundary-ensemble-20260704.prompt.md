# Aristotle proof job: YM1 boundary-circuit expectation bridge

You are proving the final Q11/YM1 bridge theorem in a Lean 4 draft
Yang-Mills formalization.  Work in the provided focused project.  Do not weaken
the target theorem, add physical assumptions, require an abelian/commutative
gauge group, or prove the known-false pointwise identity at arbitrary tree
coordinate values.

Formatting: ASCII only, LF line endings.  In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Target

Target file:

```text
PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean
```

Run this narrow check first:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean
```

If it succeeds, also run:

```text
lake build PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryExpectation
```

## Exact theorem to prove

```lean
theorem rect_boundary_wilson_loop_expectation_area_law {n : Nat} [Fintype G]
    (Lx Ly : Nat) (beta : Real)
    (rho : G -> Matrix (Fin n) (Fin n) Complex)
    (hmul : forall g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (hunit : forall g : G, Matrix.conjTranspose (rho g) * rho g = 1)
    (R : FDRep Complex G) [Simple R] :
    TreeGaugeBridge.linkExpectation (rectPlaquette Lx Ly)
        (Theorem2AreaLaw.wilsonLocalWeightC beta rho)
        (fun U => R.character
          (OrientedLattice.hol U (rectBoundaryWalk Lx Ly)))
      = R.character 1
        * Theorem2AreaLaw.wilsonNormalizedGamma beta rho R ^ (Lx * Ly) := by
```

You may add helper lemmas in the same file or, if clearly better, in
`RectBoundaryLasso.lean` / `RectTreeGauge.lean`.  Keep existing public
definitions and theorem statements semantically unchanged.

## Existing context and APIs

The focused package includes:

```text
PhysicsSM/Draft/NullEdge/GateYM/GaugeCoreGeneral.lean
PhysicsSM/Draft/NullEdge/GateYM/PlaquetteCore.lean
PhysicsSM/Draft/NullEdge/GateYM/LatticeEnsemble.lean
PhysicsSM/Draft/NullEdge/GateYM/PlaquetteEnsemble.lean
PhysicsSM/Draft/NullEdge/GateYM/WilsonWeightPositivity.lean
PhysicsSM/Draft/NullEdge/GateYM/WilsonLocalWeight.lean
PhysicsSM/Draft/NullEdge/GateYM/FusionConvolution.lean
PhysicsSM/Draft/NullEdge/GateYM/Theorem2AreaLaw.lean
PhysicsSM/Draft/NullEdge/GateYM/IndependentPlaquetteEnsemble.lean
PhysicsSM/Draft/NullEdge/GateYM/TreeGaugeBridge.lean
PhysicsSM/Draft/NullEdge/GateYM/RectTreeGauge.lean
PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryLasso.lean
PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean
```

Important existing theorems:

- `RectTreeGauge.rect_wilson_loop_expectation_area_law`: exact area law for
  the link-ensemble observable
  `R.character (IndependentPlaquetteEnsemble.orderedProd fun k =>
  (rectPlaquette Lx Ly (e k)).hol U)`.
- `RectBoundaryLasso.rectBoundary_hol_eq_reversedRowMajorPlaquetteProd_of_treeSlice`:
  on the comb tree slice, the full boundary holonomy equals the
  reversed-row-major product of all plaquette holonomies.
- `RectBoundaryLasso.apply_rectBoundary_hol_eq_reversedRowMajorPlaquetteProd_of_treeSlice`:
  function-applied form of the tree-slice lasso theorem.
- `GaugeCoreGeneral.hol_gauge_closed` and
  `GaugeCoreGeneral.classFunction_hol_gauge_closed`: closed-walk holonomy is
  conjugated by a gauge transform, and class functions of it are gauge
  invariant.
- `TreeGaugeBridge.linkExpectation`: numerator divided by partition over link
  fields with Wilson product weight.
- `TreeGaugeBridge.linkExpectation_eq_loopExpectation` and
  `TreeGaugeBridge.wilson_link_loop_expectation_area_law`: generic
  plaquette-coordinate expectation bridge.

Semantic preflight context pack:

```text
AgentTasks/context-packs/ym1-rectboundary-ensemble-20260704-20260704-145108.md
```

Use it as context only; verify all statements against the Lean files.

## Mathematical intent

This is the final finite-rectangle form of freeze Theorem 2 for the open
`Lx x Ly` rectangle:

1. The existing `RectTreeGauge` theorem gives the area law for the
   comb-ordered product of all plaquette holonomies.
2. The existing `RectBoundaryLasso` theorem identifies that product with the
   full boundary holonomy only on the comb tree slice.
3. The missing bridge is expectation-level, not the false pointwise group
   identity at arbitrary tree values.  Acceptable routes include:
   - prove an observable-congruence lemma for `linkExpectation`;
   - use `rectCoordinatization` to reindex link fields by plaquette and tree
     coordinates, reducing the boundary observable to the tree slice or to a
     conjugate of the reversed-row-major plaquette product;
   - use `GaugeCoreGeneral.hol_gauge_closed` plus character/class-function
     invariance to remove the conjugation introduced by tree coordinates.

The final statement should remain for arbitrary finite group `G`, no
commutativity assumptions, and area exponent exactly `Lx * Ly`.

## Guardrails

- Do not claim or prove the expected-false identity
  `hol boundary = reversedRowMajorPlaquetteProd` for arbitrary tree values.
- Do not replace `List.ofFn` / `List.prod` order-sensitive products by
  commutative `Finset.prod`.
- Do not reverse the row order in `j`, and do not silently change the
  `i.rev` within-row order.
- Do not introduce new assumptions about nonzero partition functions; the
  existing Wilson area-law theorem already carries the needed positivity
  plumbing.
- Do not add fake declarations, u n s a f e code, or escape-hatch tokens.

## Output format

Preferred:

1. An edited Lean file proving
   `rect_boundary_wilson_loop_expectation_area_law`.
2. Any helper lemmas with short comments explaining the observable
   reindexing/conjugation step.
3. Exact commands run and results.
4. A concise note on whether any public statement changed.

Acceptable negative/design output:

1. Explain precisely why the target theorem is malformed or false.
2. Give the corrected theorem surface and the smallest counterexample or
   blocker.
3. Include any partial Lean that typechecks.
