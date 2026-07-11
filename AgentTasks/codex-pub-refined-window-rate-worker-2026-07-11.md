# Worker note: codex-pub-refined-window-rate-worker-2026-07-11

## Status
Completed on `2026-07-11`.

The module `PhysicsSM/Draft/NullEdge/Compact3Plus1RefinedWindowRate.lean` now typechecks with all four theorems in this lane proven:

1. `splitStep_sub_lin_bound_refined`
2. `exactFlow_sub_lin_bound_refined`
3. `one_step_to_exact_flow_bound_refined`
4. `fixed_time_many_step_bound_refined`

### Exact work done in this file
- Reworked the split-step telescoping to keep the factor `exp(|eps| * B4 ...)` dependence.
- Fixed linearizer-coefficient conversion to the `H` expansion via entrywise normalization (`ext` + `simp`) and explicit `hmul` rewrite.
- Kept all theorem scopes local to `PhysicsSM/Draft/NullEdge/Compact3Plus1RefinedWindowRate.lean`.
- Added no `s o r r y` terms and no escapes in theorems.

### Lean checks run
- `lake env lean PhysicsSM/Draft/NullEdge/Compact3Plus1RefinedWindowRate.lean` (pass)

### Integration note
No parent module was integrated in this step (requested lane scope is only `Compact3Plus1RefinedWindowRate.lean` in the local branch).

### Remaining items
- None for this lane.
