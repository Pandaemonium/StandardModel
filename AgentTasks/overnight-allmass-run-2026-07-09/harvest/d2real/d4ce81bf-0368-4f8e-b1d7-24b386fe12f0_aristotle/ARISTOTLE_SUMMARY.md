# Summary of changes for run d4ce81bf-0368-4f8e-b1d7-24b386fe12f0
Delivered the D2 re-derivation entirely over ℝ (real symmetric 2×2 matrices — no Complex, conj, or transcendentals) in `RequestProject/Main.lean`, namespace `SuiteD_EntropyMonotoneReal`, plus `ARISTOTLE_SUMMARY.md`. The module builds in-project in ~20 s, is `sorry`-free and kernel-checked.

Objects: `rhoM p x = !![p,x;x,1-p]` (validity `x² ≤ p(1-p)`, which itself forces `0 ≤ p ≤ 1`), pinch channel `Pinch t M`, `IsState := IsSymm ∧ trace = 1 ∧ PosSemidef`, rotation `Urot = !![3/5,-4/5;4/5,3/5]`, mass² = `det`.

Targets proved:
1. `pinch_is_state`: `Pinch t (rhoM p x)` is symmetric, trace-1, PSD for a valid state and `t ∈ [0,1]`.
2. `det_pinch`: `det (Pinch t (rhoM p x)) = det (rhoM p x) + (2t - t²)·x²` (closed form, by ring).
3. `mass_monotone_under_pinch`: the post-pinch determinant is `MonotoneOn (Set.Icc 0 1)` and `≥ det (rhoM p x)` on `[0,1]` — decohering coherence can only raise mass²/linear entropy.
4. `signed_closure_exception`: for explicit rational `rho = rhoM (1/2)(1/2)`, `t = 1`, `det (Pinch 1 (Urot·rho·Urotᵀ)) < det (Pinch 1 rho)` (49/2500 < 1/4) — congruence before pinching reorganizes coherence and lowers mass².

Non-degeneracy `massless_pinch_gains_mass`: `det (rhoM (1/2)(1/2)) = 0` while `det (Pinch 1 (rhoM (1/2)(1/2))) = 1/4 > 0`.

All proofs use only ring/norm_num/nlinarith over ℝ/ℚ. Every headline theorem carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` check confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`. The helper and headline lemmas assume only the sharp validity inequality `x² ≤ p(1-p)`, since the `0 ≤ p ≤ 1` bounds follow from it (noted in the docstrings). Work committed and pushed.

# Suite D — rung D2 (real re-derivation)

Re-derivation of the D2 entropy/mass² monotonicity content **entirely over `ℝ`** using real
symmetric `2×2` matrices. No `Complex`, no `conj`, no `Real.cos/sin/sqrt`, no nlinarith on
transcendentals. Everything is `ring`/`norm_num`/`nlinarith` over `ℝ`/`ℚ`.

File: `RequestProject/Main.lean`, namespace `SuiteD_EntropyMonotoneReal`.
Kernel-checked, `sorry`-free; module builds in-project in ~20 s.

## Objects

- `rhoM p x = !![p, x; x, 1-p]` — a mixed direction state (real symmetric, trace 1);
  valid when `x² ≤ p(1-p)` (which already forces `0 ≤ p ≤ 1`).
- `Pinch t M = !![M00, (1-t)·M01; (1-t)·M10, M11]` — decohering pinch channel.
- `IsState M := M.IsSymm ∧ M.trace = 1 ∧ M.PosSemidef`.
- `Urot = !![3/5,-4/5; 4/5,3/5]` — the real 3-4-5 rotation (det 1).
- mass² invariant = `det`.

## Targets proved

1. `pinch_is_state` — `Pinch t (rhoM p x)` is a state for a valid `rho` and `t ∈ [0,1]`.
2. `det_pinch` — `det (Pinch t (rhoM p x)) = det (rhoM p x) + (2t - t²)·x²` (closed form).
3. `mass_monotone_under_pinch` — `t ↦ det (Pinch t (rhoM p x))` is `MonotoneOn (Set.Icc 0 1)`
   and `det (rhoM p x) ≤ det (Pinch t (rhoM p x))` for `t ∈ [0,1]`: decohering coherence can
   only increase mass²/linear entropy.
4. `signed_closure_exception` — with the explicit rational `rho = rhoM (1/2) (1/2)` and `t = 1`,
   `det (Pinch 1 (Urot·rho·Urotᵀ)) < det (Pinch 1 rho)` (`49/2500 < 1/4`): closure applied by
   congruence before pinching can reorganize coherence and *lower* the post-pinch mass².

Mandatory non-degeneracy: `massless_pinch_gains_mass` — `det (rhoM (1/2) (1/2)) = 0` while
`det (Pinch 1 (rhoM (1/2) (1/2))) = 1/4 > 0`, so the monotonicity is non-vacuous.

Supporting lemmas: `pinch_rhoM`, `rhoM_posSemidef`, `isState_rhoM`, `Ucong_eval`.

## Axiom footprint

Each headline theorem carries an in-file
`#guard_msgs (whitespace := lax) in #print axioms <thm>` check confirming the footprint is
exactly `[propext, Classical.choice, Quot.sound]`.

Note: the helper/headline lemmas take only the sharp validity inequality `x² ≤ p(1-p)`; the
`0 ≤ p ≤ 1` bounds from the problem prose are implied by it and so are not assumed separately.
