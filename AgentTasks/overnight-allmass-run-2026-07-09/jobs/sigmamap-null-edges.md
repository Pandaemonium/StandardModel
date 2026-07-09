# claude-sigmamap-null-edges — the sigma-map P(p)=p.sigma IS a sum of two null-edge dyads (closing the "which P" loop)

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

Two representations of the little-group spinor matrix appear in the program: the sigma-map `P(p) =
p_mu sigma^mu` (from PhysLean's Pauli convention, `det P = m^2`) and the null-edge Gram `M M^H = sum_i
psi_i psi_i^H` (the manuscript's converse: every PSD `P` = a sum of rank-1 null dyads). An adversarial
audit stressed that "mass = det P" is frame-independent ONLY for this little-group spinor `P`. Close the
loop: show the sigma-map `P(p)` is EXACTLY a sum of two rank-1 null-edge dyads, and its determinant is
the null-edge disagreement `m^2` -- so the PhysLean-grounded object and the manuscript's null-edge
decomposition are the SAME `P`, not two different constructions.

## The model (explicit rational Hermitian 2x2)

For a massive 2-momentum with `p = (E, 0, 0, kz)` (restricting to the (t,z) plane keeps it REAL), the
Pauli sigma-map is `P = !![E + kz, 0; 0, E - kz]` (real diagonal, PSD when `E >= |kz|`), with `det P =
E^2 - kz^2 = m^2`. A rank-1 "null edge" is `edge v = !![v0^2, v0 v1; v0 v1, v1^2]` (`= v v^T`, det 0).
Decompose `P` into two null edges along the diagonal: `P = (E+kz) . edge e0 + (E-kz) . edge e1` where
`e0 = ![1,0], e1 = ![0,1]` (each `edge ei` is rank-1 null). [General complex off-diagonal is optional;
the real (t,z) case is sufficient and rational.]

## Targets (rational; Matrix.det_fin_two/mul + fin_cases/ring/norm_num; NO transcendental, NO nlinarith)

1. `P_closed`: `P E kz = !![E+kz, 0; 0, E-kz]` and `det (P E kz) = E^2 - kz^2` (`= m^2` on shell). By
   `Matrix.det_fin_two` + `ring`.
2. `edge_rank_one`: each `edge v` has `det = 0` (null/rank-1). By `Matrix.det_fin_two`; `ring`.
3. `P_eq_null_edge_sum` (payload): `P E kz = (E+kz) . edge ![1,0] + (E-kz) . edge ![0,1]` -- the sigma-
   map matrix is EXACTLY a nonneg combination of two rank-1 null-edge dyads (the two chirality/light-cone
   directions). `ext i j; fin_cases i <;> fin_cases j <;> simp [...]; ring`. So `P(p)` from PhysLean's
   Pauli convention IS a sum of null edges.
4. `det_is_disagreement` (payload): `det (P E kz) = (E+kz)*(E-kz) = E^2 - kz^2 = m^2`, and this equals
   the "disagreement" of the two null edges (the product of their weights) -- massless (`E = |kz|`, one
   weight 0) gives `det = 0` (rank-1, single null edge), massive gives `det = m^2 > 0` (two edges). State
   `det P = 0 <-> E^2 = kz^2` (one null edge / massless) and `det P > 0 <-> massive`.
5. `sigmamap_null_edge_verdict`: package -- the PhysLean-grounded sigma-map `P(p) = p.sigma` and the
   manuscript's null-edge Gram `M M^H` are the SAME little-group spinor matrix: `P` is a nonneg sum of two
   rank-1 null-edge dyads, its determinant is the null-edge disagreement `m^2`, and it collapses to a
   single null edge (rank 1, `det = 0`) exactly at masslessness. This closes the "which P" loop: the
   det-P mass is frame-independent because `P` is this spinor object, decomposable into null edges.
   Honest scope: the real (t,z)-restricted rational avatar; the general complex case is the same with
   Hermitian dyads.

MANDATORY non-degeneracy: massive witness `E=5, kz=3` (`m^2=16`, `P=!![8,0;0,2]`, two edges weights 8,2);
null witness `E=kz=1` (`P=!![2,0;0,0]`, one edge, det 0); the explicit `edge ![1,0] = !![1,0;0,0]`. All
in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Rational 2x2; Matrix.det_fin_two/mul + fin_cases/ring/norm_num; NO
Real.sqrt/cos/sin, NO Complex, NO nlinarith. Build under 3 min. Deliver RequestProject/Main.lean
(namespace SigmaMapNullEdges) + ARISTOTLE_SUMMARY.md.
