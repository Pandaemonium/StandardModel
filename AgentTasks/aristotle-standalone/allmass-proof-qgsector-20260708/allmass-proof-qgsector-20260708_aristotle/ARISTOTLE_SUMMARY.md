# Summary of changes for run 0c7833a2-2ed9-4664-b246-cda479918d3a
Closed the by-inspection gap in the `V'/N` Gauss-sector construction in `src/S1CCPhysicalSectorWitness.lean`. Everything compiles with `lake env lean` with no `sorry`/`admit` and only the standard axioms (`propext`, `Classical.choice`, `Quot.sound`).

Two preliminary fixes were needed so the file elaborates in this repackaged layout:
- The import `PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia` did not resolve (the module is `src.S1CCBalancedInertia` here); I corrected it to `import src.S1CCBalancedInertia`. Nothing else was changed in the pre-existing content.

New theorems added to the file's namespace (right after `def r`), all proved kernel-clean:

1. `QG_apply` — `Q_G p q = if p = (0,2) ∧ q = (1,2) then 1 else 0`: `Q_G = c₁⊗Gc` is the single matrix unit `E_{(0,2),(1,2)}`.
2. `QG_reps_mem_ker` — for every `k : Fin 4`, `Q_G *ᵥ e_{r k} = 0`: each coset representative lies in `V' = ker Q_G`.
3. `QG_excluded_to_N` — `Q_G *ᵥ e_{(1,2)} = e_{(0,2)}`: the excluded axis maps to the `N`-generator, so `range Q_G` is the line `span e_{(0,2)}`.
4. Stretch (submodule/coset-basis form), all delivered:
   - `QG_col_eq`, `QG_mulVec_eq` — helper characterizations (`Q_G v = v_{(1,2)}·e_{(0,2)}`).
   - `QG_range_eq` — `range (mulVecLin Q_G) = span {e_{(0,2)}}` (the null direction `N`).
   - `QG_ker_eq` — `ker (mulVecLin Q_G) = span {e_p : p ≠ (1,2)}` (the physical sector `V'`, a 5-dim hyperplane).
   - `QG_ker_reps_basis` — `ker Q_G = span (insert e_{(0,2)} {e_{r k}})`: the four coset representatives `r` together with the null axis `(0,2)` span `V'`, so `r` genuinely enumerates the `V'/N` coset representatives.

Semantic alignment: these lemmas make "the `V'` construction is kernel-checked" literally true. `Q_G`'s kernel is exactly the physical sector `V'` spanned by the representatives `r` (plus the null axis), and its range is exactly the null direction `N = span e_{(0,2)}`. Combined with the existing `N_in_radical` (which shows `(0,2)` pairs trivially under `J Q_C`), the balanced-inertia `(2,2,0)` witness is thereby confirmed to be about the genuine Gauss-constraint quotient `V'/N`, not a hard-coded axis choice.

All changes committed and pushed to `origin/main`.
