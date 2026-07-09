# Summary of changes for run a247aa39-cf50-45ee-bc49-6a03c929ae75
Delivered `RequestProject/Main.lean` (namespace `SigmaMapNullEdges`) plus `ARISTOTLE_SUMMARY.md`, closing the "which P" loop. The whole file builds cleanly with Mathlib only, no `sorry`/`admit`/`native_decide`/new axioms; every headline theorem carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` pinning the footprint to exactly `[propext, Classical.choice, Quot.sound]`, and all guards pass.

Model (real (t,z)-restricted rational avatar): `P E kz = !![E+kz,0;0,E-kz]` (the Pauli sigma-map `P(p)=p_μσ^μ` for `p=(E,0,0,kz)`), `edge v = v vᵀ` a rank-1 null dyad, and directions `e0=![1,0]`, `e1=![0,1]`.

Results proved:
1. `P_closed` — `P` is the stated matrix and `det P = E²−kz² = m²`.
2. `edge_rank_one` — each `edge v` has `det = 0`; with explicit `edge_e0`, `edge_e1`.
3. `P_eq_null_edge_sum` (payload) — `P E kz = (E+kz)•edge e0 + (E−kz)•edge e1`: the sigma-map IS a nonnegative sum of two rank-1 null-edge dyads.
4. `det_is_disagreement` (payload) — `det P = (E+kz)(E−kz) = E²−kz²` (product of edge weights); plus `det_zero_iff_massless : det P = 0 ↔ E²=kz²` and `det_pos_iff_massive : 0 < det P ↔ kz²<E²`.
5. `sigmamap_null_edge_verdict` — packages all of the above: the PhysLean-grounded sigma-map `P(p)=p.σ` and the manuscript's null-edge Gram `M Mᴴ` are the same little-group spinor matrix.

Mandatory non-degeneracy witnesses included in-theorem: massive `E=5,kz=3` (`P=!![8,0;0,2]`, `det=16`, edges weights 8 and 2), massless `E=kz=1` (`P=!![2,0;0,0]`, `det=0`, single edge), and the explicit `edge ![1,0]=!![1,0;0,0]`.

Proofs use only `Matrix.det_fin_two`/`fin_cases`/`ring`/`norm_num`/`simp` — no transcendental functions, no `Complex`, no `nlinarith`. All work is committed and pushed.

# claude-sigmamap-null-edges — closing the "which P" loop

All targets are formalized and proved in `RequestProject/Main.lean`
(namespace `SigmaMapNullEdges`), Mathlib only, kernel-checked, no
`sorry`/`admit`/`native_decide`/new axiom. Every headline carries an in-file
`#guard_msgs (whitespace := lax) in #print axioms <thm>` pinning the footprint to
exactly `[propext, Classical.choice, Quot.sound]`. Builds in well under 3 min.

## Model (real `(t,z)`-restricted rational avatar)

- `P E kz = !![E+kz, 0; 0, E-kz]` — the Pauli sigma-map `P(p)=p_μσ^μ` for
  `p = (E,0,0,kz)`; real diagonal Hermitian, PSD when `E ≥ |kz|`.
- `edge v = !![v0·v0, v0·v1; v1·v0, v1·v1]` — a rank-1 null dyad `v vᵀ`.
- `e0 = ![1,0]`, `e1 = ![0,1]` — the two chirality / light-cone directions.

## Results

1. `P_closed` — `P E kz` is the stated matrix and `det (P E kz) = E² - kz² = m²`.
2. `edge_rank_one` — every `edge v` has `det = 0` (rank ≤ 1, null); plus
   `edge_e0 : edge ![1,0] = !![1,0;0,0]` and `edge_e1 : edge ![0,1] = !![0,0;0,1]`.
3. `P_eq_null_edge_sum` (payload) — `P E kz = (E+kz)•edge e0 + (E-kz)•edge e1`:
   the sigma-map IS a nonnegative sum of two rank-1 null-edge dyads.
4. `det_is_disagreement` (payload) — `det (P E kz) = (E+kz)(E-kz) = E²-kz²`, the
   product of the two edge weights (the null-edge "disagreement"); with
   `det_zero_iff_massless : det P = 0 ↔ E² = kz²` (single edge / massless) and
   `det_pos_iff_massive : 0 < det P ↔ kz² < E²` (two genuine edges / massive).
5. `sigmamap_null_edge_verdict` — packages 1–4: the PhysLean-grounded sigma-map
   `P(p)=p.σ` and the manuscript's null-edge Gram `M Mᴴ = Σ ψᵢψᵢᴴ` are the SAME
   little-group spinor matrix. `det P` mass is frame-independent because `P` is
   this spinor object, decomposable into null edges.

## Non-degeneracy witnesses (in-theorem)

- Massive `E=5, kz=3`: `witness_massive_P : P 5 3 = !![8,0;0,2]`;
  `witness_massive_det : (P 5 3).det = 16 ∧ P 5 3 = 8•edge e0 + 2•edge e1`
  (two edges, weights 8 and 2, `m²=16`).
- Massless `E=kz=1`: `witness_massless : P 1 1 = !![2,0;0,0] ∧ (P 1 1).det = 0`
  (single null edge).

## Honest scope

Real `(t,z)`-restricted rational avatar; the general complex case is identical
with Hermitian dyads. Proofs use only `Matrix.det_fin_two`, `fin_cases`, `ring`,
`norm_num`, `simp` — no `Real.sqrt/cos/sin`, no `Complex`, no `nlinarith`.
