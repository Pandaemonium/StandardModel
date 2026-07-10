# Summary of changes for run 71114b63-e075-4e1d-a4f1-388ee5f8f592
Delivered `RequestProject/Main.lean` (namespace `DetPUniqueness`) plus `ARISTOTLE_SUMMARY.md`, proving that on real symmetric 2×2 matrices the determinant is (up to scale) the unique quadratic form that vanishes on all rank-≤1 "null edge" matrices and is SL(2,ℝ)-congruence invariant — establishing that `mass² = det P` is canonical, not conventional.

Model: `sym a b c = !![a,b;b,c]`, `edge v = v vᵀ`, and a 6-coefficient quadratic form `Qform co P = c₀a²+c₁b²+c₂c²+c₃ab+c₄ac+c₅bc`. Results proved (kernel-checked, no sorry/admit/native_decide/new axioms):

1. `det_vanishes_on_edges` — det(edge v)=0.
2. `det_congruence_relative_invariant` — det(AᵀPA)=(det A)²·det P, plus the SL(2) corollary `det_congruence_SL2_invariant`.
3. `edge_span` (support) — vanishing on all edges forces c₀=c₂=c₃=c₅=0 and c₁+c₄=0 (five test vectors kill the quartic).
4. `detP_unique` (payload) — such a form equals k·det (k=c₄). The null-vanishing condition alone already forces this; the requested SL(2)-invariance hypothesis is kept for faithfulness (documented as unused in the docstring).
5. Non-degeneracy (mandatory): `acCoeff_not_null` shows the trace-like form Q'=ac vanishes on edge(1,0), edge(0,1) but equals 1 on edge(1,1); `acCoeff_not_invariant` shows Q' is not SL(2)-invariant via the unit shear.
6. `uniqueness_verdict` — packages the whole story.

The module builds cleanly with no warnings; every headline theorem has an in-file `#guard_msgs (whitespace := lax) in #print axioms …` and the axiom footprint is exactly [propext, Classical.choice, Quot.sound]. Work committed and pushed.

# `mass² = det P` is the canonical invariant

**File:** `RequestProject/Main.lean` — namespace `DetPUniqueness`.

This development proves that on real symmetric `2×2` matrices the determinant is, up to scale, the
**unique** quadratic form that both (i) vanishes on every rank-`≤1` ("null edge") matrix and (ii) is
invariant under the `SL(2,ℝ)` congruence action `P ↦ Aᵀ P A` (`det A = 1`). Hence the mass
invariant `mass² = det P` is *forced*, not a conventional choice.

## Model

* `sym a b c = !![a,b;b,c]` — a symmetric `2×2` matrix from coordinates `(a,b,c) ∈ ℝ³`.
* `edge v = v vᵀ` — the rank-`≤1` PSD "null edge" matrices.
* `Qform co P = c₀a² + c₁b² + c₂c² + c₃ab + c₄ac + c₅bc` — a general quadratic form (6 real
  coefficients `co : Fin 6 → ℝ`) reading the entries `a = P 0 0`, `b = P 0 1`, `c = P 1 1`.
* `detCoeff` (`c₁=-1, c₄=1`) gives the determinant `ac - b²`; `acCoeff` (`c₄=1`) gives the
  trace-like product `ac`.

## Results (all kernel-checked, no `sorry`/`admit`/`native_decide`/new axioms)

1. `det_vanishes_on_edges` — `det (edge v) = 0` for every `v` (via `Matrix.det_fin_two` + `ring`).
2. `det_congruence_relative_invariant` — `det (Aᵀ P A) = (det A)² · det P`; corollary
   `det_congruence_SL2_invariant` gives congruence invariance when `det A = 1`.
3. `edge_span` (support lemma) — if `Qform co` vanishes on **all** null edges, then
   `c₀ = c₂ = c₃ = c₅ = 0` and `c₁ + c₄ = 0` (five vectors `(1,0),(0,1),(1,1),(1,-1),(2,1)` force
   the quartic `Qform co (edge (x,y))` to be identically zero).
4. `detP_unique` (payload) — a quadratic form vanishing on every null edge and `SL(2,ℝ)`-congruence
   invariant equals `k · det` for some `k ∈ ℝ` (here `k = c₄`). Note: the null-vanishing condition
   alone already forces the conclusion, so the `SL(2)`-invariance hypothesis is kept for
   faithfulness to the specification but is not needed in the proof (documented in the docstring).
5. Non-degeneracy (mandatory):
   * `acCoeff_not_null` — the trace-like form `Q'(P) = ac` vanishes on `edge (1,0)` and `edge (0,1)`
     but equals `1 ≠ 0` on `edge (1,1)`, so the null-vanishing condition is a genuine constraint
     that `det` uniquely satisfies.
   * `acCoeff_not_invariant` — `Q'` is not `SL(2,ℝ)`-invariant: the unit shear `A = !![1,1;0,1]`
     maps `!![1,0;0,0]` to `!![1,1;1,1]`, changing `Q'` from `0` to `1`.
6. `uniqueness_verdict` — packaging theorem bundling: the determinant form vanishes on all edges,
   is `SL(2)`-invariant, is the unique such quadratic form up to scale, and the non-degeneracy
   witness.

## Verification

`RequestProject.Main` builds cleanly (no warnings). Every headline theorem carries an in-file
`#guard_msgs (whitespace := lax) in #print axioms …`; the axiom footprint is exactly
`[propext, Classical.choice, Quot.sound]`.

## Scope

Real symmetric `2×2` (one null-edge pair / one momentum); uniqueness is among quadratic forms.
Provenance: classical invariant theory — the determinant as the `SL(2)` relative invariant.
