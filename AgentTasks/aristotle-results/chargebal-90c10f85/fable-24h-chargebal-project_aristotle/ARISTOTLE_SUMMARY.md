# Summary of changes for run 05cab44f-1722-4889-8d9a-f12e1f9f4f1f
All four `sorry` theorems in `SplitStepChargeBalance.lean` are now proved, kernel-only (no `native_decide`); the file builds cleanly with no remaining `sorry`, and each theorem's `#print axioms` shows only `propext`, `Classical.choice`, `Quot.sound`.

Results (no arithmetic mismatch — every stated identity holds exactly as written):
- **T1a `Jplus_det_charge`**: `Jplus.det = 64/125` and `chargeOf Jplus = 1`. Proved by `Matrix.det_fin_three` + `norm_num` on the explicit 3×3 matrix `(4/5)·diag(-1,1,-1)`, then evaluating the sign definition.
- **T1b `Jminus_det_charge`**: `Jminus.det = -(64/125)` and `chargeOf Jminus = -1`, analogously (`Jminus = -Jplus`).
- **T2 `census_floquet_opposition`**: for every node `n`, `chargeOf (census n false) = -(chargeOf (census n true))` — proved by case-splitting on `nodeParity n` and reducing to the two Jacobian charges.
- **T3 `census_sum_zero`**: for each gap `g`, the sum over all eight nodes (the full `Fin 2 × Fin 2 × Fin 2` census) of `chargeOf (census n g)` equals `0`. The statement is unchanged (genuine 8-node `Finset.univ` sum); proved by rewriting each node charge to its parity-selected ±1 sign (helper `chargeOf_census`) and discharging with kernel `decide`.

Two small reusable helper lemmas were added (`chargeOf_Jplus`, `chargeOf_Jminus`, `chargeOf_census`) to support T2/T3. All work is committed and pushed.
