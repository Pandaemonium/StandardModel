# claude-masslessedge-closer — close the two witness sorries in the edge-count classification

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

A prior delivery proved that for a real symmetric PSD `2x2` matrix `P`, massless <=> rank 1 <=> one
null edge, massive <=> rank 2 <=> two edges (`m^2 = det P` = squared disagreement), with these MAIN
theorems ALREADY PROVED (reproduce them, they are the spec):
- `edge (v : Fin 2 -> R) : Matrix (Fin 2) (Fin 2) R := Matrix.vecMulVec v v`
- `massless_iff_one_edge (hP : P.PosSemidef) (hne : P != 0) : (P.det = 0 <-> P.rank = 1) AND (P.rank = 1 <-> exists v != 0, P = edge v)`
- `massive_iff_two_edges (hP : P.PosSemidef) : (0 < P.det <-> P.rank = 2) AND ... AND (P.rank = 2 <-> P.PosDef)`
- `edge_count_eq_rank`, `mass_from_edges`.

The two mandatory non-degeneracy WITNESSES were left as `sorry` and must be CLOSED (this is the
whole job): prove them fully, kernel-checked.

## Targets (close both, no sorry)

1. `massless_witness`: `P0 = !![1,0;0,0]` satisfies `P0.PosSemidef AND P0.det = 0 AND P0.rank = 1
   AND P0 = edge ![1,0]`.
2. `massive_witness`: `P1 = !![34/25, 12/25; 12/25, 16/25]` satisfies `P1.PosSemidef AND P1.det =
   16/25 AND 0 < P1.det AND P1.rank = 2 AND P1 = edge ![1,0] + edge ![3/5,4/5]`.

## Proof guidance (use the module's OWN theorems + the edge decomposition — do NOT hand-compute rank)

- Prove the edge-DECOMPOSITION equality first (`P0 = edge ![1,0]`, `P1 = edge ![1,0] + edge
  ![3/5,4/5]`) by `ext i j; fin_cases i <;> fin_cases j <;> simp [edge, Matrix.vecMulVec] <;>
  norm_num`.
- Get `PosSemidef` FROM the decomposition: `edge v = vecMulVec v v` is PSD (`Matrix.posSemidef_...`
  outer-product lemma, or `(Matrix.posSemidef_conjTranspose_mul_self _)`-style via `edge v = (col v)
  * (col v)^T`; find the landed Mathlib lemma for `vecMulVec`/outer-product PSD -- prefer it over
  reinventing); a sum of PSD is PSD (`Matrix.PosSemidef.add`).
- Get `det` by `norm_num [Matrix.det_fin_two_of]`; `0 < det` by `norm_num`.
- Get `rank` FROM `det` via the MAIN theorems: `P0.rank = 1` is
  `((massless_iff_one_edge hP0 hne0).1).mp hdet0`; `P1.rank = 2` is
  `((massive_iff_two_edges hP1).1).mp hdetpos`. `hne0 : P0 != 0` from the `(0,0)` entry `= 1 != 0`.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: NO sorry/admit/native_decide/new axiom (closing the sorries IS the point).
Mathlib only. Footprint exactly [propext, Classical.choice, Quot.sound]; add an in-file
`#guard_msgs (whitespace := lax) in #print axioms <thm>` block on BOTH witnesses AND the four main
theorems (the delivery had none -- add them). REAL rational 2x2; ring/norm_num/decide/fin_cases +
the Mathlib PosSemidef/rank lemmas; NO Complex, NO Real.sqrt/cos/sin, NO nlinarith deg>=3. Build
under 3 min. Deliver the FULL module RequestProject/Main.lean (namespace MasslessEdgeCount, main
theorems + closed witnesses + guard pins) + ARISTOTLE_SUMMARY.md.
