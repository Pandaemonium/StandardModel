# Summary of changes for run 5642afae-f82b-4711-bd86-101ba446d786
I formalized and fully proved the Gate C1 CKM-style 4D corner mass table as a standalone, proof-placeholder-free Lean package in `RequestProject/CKMTable.lean` (namespace `GateC1.CKM`). The build is clean and the table theorems depend only on the standard kernel dependencies (`propext`, `Classical.choice`, `Quot.sound`).

**The table is TRUE under the standard CKM convention** — no correction or weakening was needed. The convention is the only one that works, and I state it explicitly: the four components must be the genuine elementary symmetric functions e_1..e_4 of the signs.

Definitions over `c : Fin 4 → ℤ` with each `c μ ∈ {+1,-1}`:
- `Mp c = c0·c1·c2·c3` (product/parity, e_4)
- `Mv c = c0+c1+c2+c3` (vector, e_1, the 4 singles)
- `Mt c = Σ_{μ<ν} cμ·cν` (tensor, e_2, the 6 pairs)
- `Ma c = Σ_{μ<ν<ρ} cμ·cν·cρ` (axial, e_3, the 4 triples)
- `Mckm c = Mp + Mv + Mt + Ma`
- `level c` = number of `-1` signs.

Key results (all proved):
- `one_add_Mckm`: the generating-function kernel `1 + Mckm c = (1+c0)(1+c1)(1+c2)(1+c3)`, i.e. `M_CKM = ∏(1+cμ) − 1`. This is the algebraic engine.
- Helper lemmas `all_one_of_level_zero` and `exists_neg_of_level_pos`.
- `Mckm_level_zero`: at level 0, `M_CKM = 15` (= 2⁴ − 1).
- `Mckm_level_pos`: at level > 0, `M_CKM = -1`.
- `Mckm_table`: the combined dichotomy `(level 0 → 15) ∧ (level > 0 → -1)`.

I sanity-checked all 16 corners computationally before formalizing; the level→mass map is exactly `(0 ↦ 15)` and `(everything else ↦ -1)`.

Why the convention matters (documented in the file): the identity `Σ_{k=0}^4 e_k = ∏(1+cμ)` with `e_0 = 1` forces `(15, -1)`; no other component weighting reproduces both values simultaneously, so the one-sector table is preserved exactly, not rescaled.

The file also includes a note on how this feeds `ShiftedCKM_OneSector_Window`: the level-0 corner is the single split-off heavy corner (15) pushed to the cutoff; the remaining 15 corners form a flat one-sector plateau at -1, making the window well-defined (one sector, one mass). `Mckm_level_zero`, `Mckm_level_pos`, and the reusable kernel `one_add_Mckm` are the exact hooks the window consumes.
