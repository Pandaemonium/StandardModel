# Aristotle semantic context pack

Generated: 2026-07-07T00:50:04
Query: `QCCarrierBridge LeadingQCCarrierContract concrete Carrier torus curvature mZero_iff_commute leading Q_C attachment no expectation theorem`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/nullstrand-sync-holonomy-pathindependence-aristotle-2026-06-25.md` [Objective]

Score: `0.771`

```text
## Objective

Push the synchronization-curvature lane beyond commuting-kernel algebra toward
the honest SYNC-003 path-independence theorem. The goal is a finite theorem
parameterized by an explicit hidden transport rule, not an unconditional
entanglement-curvature equivalence.
```

### 2. `Sources/NullStrand_Lean_Roadmap.md` [Important non-theorem]

Score: `0.753`

```text
### Important non-theorem

Do **not** initially state

```lean
separabilityObstruction_iff_synchCurvatureNonzero
```

It is not yet well-posed. Curvature depends on the selected hidden connection, and a nonzero defect can occur for reasons unrelated to entanglement. The safe research questions are:

1. Under which locality, positivity, covariance, and state-dependence axioms does flatness imply a product-null representation?
2. Under those same axioms, does entanglement force nonzero curvature?
3. Can a positive, flat, explicitly nonlocal connection exist?

Only after these axioms are fixed should an equivalence theorem be proposed.

---
```

### 3. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean` [holonomyDefect_swap_eq_commutator]

Score: `0.753`

```text
theorem holonomyDefect_swap_eq_commutator {d : Type*} [Fintype d] [DecidableEq d]
    (A B : Matrix d d ℂ) :
    holonomyDefect [A, B] [B, A] = A * B - B * A := by
  simp [holonomyDefect, internalHolonomy]

/-- **Curvature defect detects commutativity.**

The elementary-square defect vanishes exactly when the two transports commute,
i.e. path independence around the square is equivalent to vanishing curvature. -/
```

### 4. `PhysicsSM/Draft/NullEdgeDiamondTwoTriangleCurvature.lean` [diamondDefect_eq_triangleCurvature_difference]

Score: `0.748`

```text
theorem diamondDefect_eq_triangleCurvature_difference
    (U : V -> V -> Complex) (p a b q : V) :
    additiveDiamondDefect U p a b q =
      twoTriangleCurvatureDifference U p a b q := by
  unfold additiveDiamondDefect twoTriangleCurvatureDifference triangleCurvature
  ring

/--
Equivalent orientation: the linearized holonomy around the diamond is the first
triangle curvature minus the second.
-/
```

### 5. `AgentTasks/null-edge-super-dirac-conjecture-attack-plan-2026-06-23.md` [Layer 4: diamond holonomy equals curvature block]

Score: `0.748`

```text
### Layer 4: diamond holonomy equals curvature block

Existing triangle curvature:

```text
kappa(i,j,k) = U_ij U_jk - U_ik.
```

For a minimal diamond with two paths `p -> a -> q` and `p -> b -> q`, plus a
direct comparison edge `p -> q`, target:

```text
diamond defect = kappa(p,a,q) - kappa(p,b,q)       -- Abelian/additive version
```

or multiplicatively:

```text
Delta = (U_pa U_aq U_pq^{-1}) * (U_pb U_bq U_pq^{-1})^{-1}.
```

Lean targets:

```lean
diamondDefect_eq_triangleCurvature_ratio
diamondHolonomy_linearized_eq_triangleCurvature_difference
covariantOrderDifferential_sq_eq_diamondCurvature
```

The first target should probably be a focused standalone Aristotle job in the
Abelian scalar transport setting.
```

### 6. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean` [holonomyDefect_swap_eq_zero_iff_commute]

Score: `0.748`

```text
theorem holonomyDefect_swap_eq_zero_iff_commute {d : Type*} [Fintype d] [DecidableEq d]
    (A B : Matrix d d ℂ) :
    holonomyDefect [A, B] [B, A] = 0 ↔ Commute A B := by
  rw [holonomyDefect_swap_eq_commutator, sub_eq_zero]
  exact Iff.rfl

/-- **Failure of path independence from nonvanishing curvature.**

If the matrix commutator (curvature defect) is nonzero, then the two ways around
the elementary square give genuinely different holonomies: synchronization is
path dependent. This is the contrapositive direction of the defect/flatness
correspondence. -/
```

### 7. `AgentTasks/context-packs/nullstrand-wave4-sync-holonomy-20260625-150653.md` [Layer 4: diamond holonomy equals curvature block]

Score: `0.746`

```text
### Layer 4: diamond holonomy equals curvature block

Existing triangle curvature:

```text
kappa(i,j,k) = U_ij U_jk - U_ik.
```

For a minimal diamond with two paths `p -> a -> q` and `p -> b -> q`, plus a
direct comparison edge `p -> q`, target:

```text
diamond defect = kappa(p,a,q) - kappa(p,b,q)       -- Abelian/additive version
```

or multiplicatively:

```text
Delta = (U_pa U_aq U_pq^{-1}) * (U_pb U_bq U_pq^{-1})^{-1}.
```

Lean targets:

```lean
diamondDefect_eq_triangleCurvature_ratio
diamondHolonomy_linearized_eq_triangleCurvature_difference
covariantOrderDifferential_sq_eq_diamondCurvature
```

The first target should probably be a focused standalone Aristotle job in the
Abelian scalar transport setting.
```
```

### 8. `AgentTasks/nullstrand-wave4-sync-holonomy-aristotle-2026-06-25.md` [Requested output]

Score: `0.744`

```text
## Requested output

- Patchable Lean for `Clock/InternalHolonomy.lean` or the most appropriate
  synchronization module.
- A finite theorem relating commuting local transports to path-independence.
- A theorem or precise scaffold relating failure of path-independence to a
  holonomy/curvature defect.
- A completion report with proof state, statement changes, and next proof cuts.
```

## Scoped paper hits

### 1. An analysis of completely-positive trace-preserving maps on M2

Score: `0.712`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 2. Superconnections and the Chern character

Score: `0.710`
Zotero key: `WNATKBT5`
DOI: `10.1016/0040-9383(85)90047-3`
URL: https://doi.org/10.1016/0040-9383(85)90047-3

### 3. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.702`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 4. Tri-partitions and Bases of an Ordered Complex

Score: `0.701`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x

### 5. Connections on non-abelian Gerbes and their Holonomy

Score: `0.701`
URL: http://arxiv.org/abs/0808.1923
