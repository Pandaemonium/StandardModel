# Summary of changes for run 99d38dc1-3516-408e-90f1-e3c892284969
Completed the `claude-photon-single-edge` formalization in `RequestProject/Main.lean` (namespace `PhotonSingleEdge`), a self-contained finite linear-algebra model over ℚ using only Mathlib.

Model:
- `eta` = Minkowski metric diag(1,-1,-1,-1); `mink u v` = Minkowski inner product (with `mink_eq_eta` confirming it's the bilinear form of `eta`); `mink k k` is the mass² invariant.
- Momentum Gram matrix `P = Eᵀ·E` whose rows (of `E`) are the null constituents ("edges"). `P.rank = E.rank = finrank(span{edges})` via `Matrix.rank_transpose_mul_self` and `LinearIndependent.rank_matrix`.
- `polSpin1`/`edgesSpin1` counting functions.

Explicit non-degenerate witnesses: photon `k=(1,1,0,0)` (null, rank 1, 2 pol); massive `k=(5,3,0,0)`, m²=16=4², split into null `k1=(4,4,0,0)`, `k2=(1,-1,0,0)` with `k=k1+k2` and m²=2·(k1·k2)=16 (rank 2, 3 pol).

Targets proved:
1. `photon_one_edge` — massless, nonzero, Gram rank 1, `finrank(span{k})=1`, 2 polarizations, edge count 1.
2. `massive_vector_two_edges` — two null edges summing to k, mass = disagreement (m²=2·k1·k2=16>0), Gram rank 2, `finrank(span{k1,k2})=2`, 3 polarizations, edge count 2.
3. `edge_count_eq_pol_minus_one` (payload) — `edges = pol−1`, plus `m²≠0 ↔ edges=2 ↔ pol=3` and `m²=0 ↔ edges=1 ↔ pol=2`.
4. `universal_verdict` — packages the universal metric-only law `mink(a+b)(a+b)=2·mink a b` for any two null 4-momenta (fermion or boson), the massless-single-edge fact, the spin-1 arithmetic, and both explicit witnesses.

Constraints met: builds cleanly (~20s, no warnings), no sorry/admit/native_decide/new axioms, no Complex/Real.sqrt/trig, only ring/norm_num/simp/fin_cases/linarith and Mathlib rank/finrank. Every headline theorem carries an in-file `#guard_msgs (whitespace := lax) in #print axioms ...`; footprint is [propext, Classical.choice, Quot.sound] (the pure-arithmetic payload uses only [propext, Quot.sound]). Documented in `ARISTOTLE_SUMMARY.md`. Honest scope: momentum level + DOF counting, not the dynamical field theory. All work committed and pushed.

# claude-photon-single-edge — summary

A self-contained finite linear-algebra model (over `ℚ`, Mathlib only) formalizing
"the photon is a single null edge; a massive vector is two null edges (mass =
their disagreement)" for spin-1, and packaging the universal cross-spin verdict.

All results are in `RequestProject/Main.lean`, namespace `PhotonSingleEdge`.

## Model

- `eta : Matrix (Fin 4) (Fin 4) ℚ` — Minkowski metric `diag(1,-1,-1,-1)`.
- `mink u v` — Minkowski inner product `u₀v₀ - u₁v₁ - u₂v₂ - u₃v₃`; `mink k k`
  is the mass² invariant `m²`. `mink_eq_eta` confirms it is the bilinear form of
  `eta`.
- Momentum Gram matrix `P = Eᵀ * E`, where the rows of the edge matrix `E` are
  the *null constituents* (the "edges"). By `Matrix.rank_transpose_mul_self`,
  `P.rank = E.rank`, and by `LinearIndependent.rank_matrix` this equals the
  number of independent null edges, i.e. `finrank (span {edges})`.
- Polarization/edge counting: `polSpin1 m² = if m²=0 then 2 else 3`,
  `edgesSpin1 m² = if m²=0 then 1 else 2`.

## Explicit non-degenerate witnesses (all rational, in-theorem)

- Photon: `kgamma = (1,1,0,0)`, `mink = 0` (massless), Gram rank `1`, `2` pol.
- Massive vector: `kmass = (5,3,0,0)`, `mink = 16 = 4²` (m = 4); null split
  `k1 = (4,4,0,0)`, `k2 = (1,-1,0,0)` with `kmass = k1 + k2`, `mink k1 k1 = 0`,
  `mink k2 k2 = 0`, and `mink kmass kmass = 2·(mink k1 k2) = 16` (the
  disagreement). Gram rank `2`, `3` pol.

## Targets proved

1. `photon_one_edge` — massless, `kgamma ≠ 0`, momentum Gram rank `1`,
   `finrank (span {kgamma}) = 1`, `2` polarizations, edge count `1`.
2. `massive_vector_two_edges` — `kmass = k1 + k2`, both null, `m² = 16 > 0`,
   `m² = 2·k1·k2` (mass = disagreement), momentum Gram rank `2`,
   `finrank (span {k1,k2}) = 2`, `3` polarizations, edge count `2`.
3. `edge_count_eq_pol_minus_one` (payload) — `edges = pol - 1` always, together
   with `m² ≠ 0 ↔ edges = 2 ↔ pol = 3` and `m² = 0 ↔ edges = 1 ↔ pol = 2`.
4. `universal_verdict` — packages: (A) the universal metric-only law
   `mink (a+b) (a+b) = 2·mink a b` for any two null 4-momenta (applies to
   fermions and bosons alike, closing the fermion/boson scope caveat); (B) one
   null edge ⇒ massless; (C) the spin-1 edge/pol arithmetic; (D) the explicit
   photon and massive witnesses.

## Verification

- Builds under the constraints: no `sorry`/`admit`/`native_decide`, no new
  `axiom`, no `Complex`/`Real.sqrt`/`cos`/`sin`, only `ring`/`norm_num`/`simp`/
  `fin_cases`/`linarith` and Mathlib `rank`/`finrank`.
- Axiom footprint of every headline theorem is `[propext, Classical.choice,
  Quot.sound]` (`edge_count_eq_pol_minus_one` uses only `[propext, Quot.sound]`),
  checked in-file with `#guard_msgs (whitespace := lax) in #print axioms ...`.

## Honest scope

Momentum level + polarization/DOF counting, not the dynamical field theory.
