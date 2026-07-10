# Proof: close the V'/N Gauss-sector construction in the kernel (Q_G ker/range)

PROOF job. Context `src/S1CCPhysicalSectorWitness.lean` (+ its import
`S1CCBalancedInertia.lean`). This file proves the §6 S1-CC central-crux witness:
on a 6-dim Clifford⊗color carrier `Fin 2 × Fin 3`, the closure form `J Q_C` has
balanced inertia (2,2,0) on the physical sector `V'/N`. An external audit found ONE
by-inspection gap: `Q_G = c₁⊗Gc` is used to define `V' = ker Q_G`, `N = range Q_G`,
and the coset reps `r = ![(0,0),(0,1),(1,0),(1,1)]`, but NO theorem certifies the
`ker`/`range` of `Q_G` — `N_in_radical` hard-codes the axis `(0,2)` without
mentioning `Q_G`. Close this.

## Targets (prove kernel-clean, no `sorry`; add to the file's namespace)

`Q_G = c₁⊗Gc` with `c₁ = !![0,1;0,0]`, `Gc = diag(0,0,1)`, so `Q_G` is the single
matrix unit `E_{(0,2),(1,2)}`. Prove (whichever formulations are cleanest in
Mathlib; deliver at least the first three):

1. **`QG_apply`**: `QG p q = if p = ((0:Fin 2),(2:Fin 3)) ∧ q = ((1:Fin 2),(2:Fin 3))
   then 1 else 0` — `Q_G` is that explicit matrix unit. (fin_cases on both indices.)
2. **`QG_reps_mem_ker`**: for each `k : Fin 4`, `QG.mulVec (Pi.single (r k) 1) = 0`
   — every coset representative lies in `V' = ker Q_G`.
3. **`QG_excluded_to_N`**: `QG.mulVec (Pi.single ((1:Fin 2),(2:Fin 3)) 1)
   = Pi.single ((0:Fin 2),(2:Fin 3)) 1` — `Q_G` maps the excluded axis to the
   `N`-generator `(0,2)`, so `range Q_G` is exactly the line `span e_{(0,2)}`.
4. **(stretch) `QG_ker_eq` / `QG_range_eq`**: as submodule equalities —
   `LinearMap.ker (Matrix.mulVecLin QG) = Submodule.span {e_p : p ≠ (1,2)}` and
   `LinearMap.range (Matrix.mulVecLin QG) = Submodule.span {e_{(0,2)}}`; and/or
   that `r` together with `(0,2)` is a basis of `ker Q_G` (so `r` enumerates the
   `V'/N` coset representatives). Deliver as far as Mathlib's submodule/quotient
   API cleanly allows.

Targets 1-3 are elementary (`fin_cases`/`decide`/`Matrix.mulVec_single`); they make
"the `V'` construction is kernel-checked" literally true at the vector level. The
stretch (4) upgrades it to the full submodule/coset-basis statement. Report semantic
alignment: the content is "`Q_G`'s kernel is the physical sector `V'` spanned by the
reps, and its range is the null direction `N` — so the balanced-inertia witness is
about the genuine Gauss-constraint quotient."

Run `lake env lean` on the modified file; keep everything else intact; commit + push.
Provenance: all-mass solo run 2026-07-08 [orig]; closes the call-08 audit's V'
by-inspection gap.
