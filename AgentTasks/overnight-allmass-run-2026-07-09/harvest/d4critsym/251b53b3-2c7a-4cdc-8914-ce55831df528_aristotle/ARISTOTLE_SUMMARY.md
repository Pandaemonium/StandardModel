# Summary of changes for run 251b53b3-2c7a-4cdc-8914-ce55831df528
Delivered `RequestProject/Main.lean` (namespace `SuiteD_CriticalSymmetry`) plus `ARISTOTLE_SUMMARY.md`, proving that critical lightness of the mass block is symmetry-protected. All results are over ℚ with explicit 3×3 rational matrices; proofs use only `ring`/`norm_num`/`fin_cases`/`simp`/`linarith`. No `sorry`/`admit`/`native_decide`/new axioms; every headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`. The project builds cleanly (well under 3 minutes, no warnings).

Definitions: `B lam kap = !![lam,kap,0; kap,lam,0; 0,0,lam]`, involution `T = diag(1,-1,1)`, zero mode `v = (1,-1,0)`, heavy-mode `w = (1,1,0)`.

Theorems:
- `zero_mode_at_criticality`: `B lam lam *ᵥ v = 0 ∧ v ≠ 0`.
- `T_involution`, `T_ne_one`, `T_ne_negOne`: T is a nontrivial involution.
- `enhanced_symmetry_at_criticality` (payload): `T * B lam kap * T = B lam (-kap)` — the Z₂ action flipping the closure coupling.
- `symmetry_iff_kap_zero`: `T` commutes with `B` iff `kap = 0`.
- `eigen_light`/`eigen_heavy`: `B *ᵥ v = (lam-kap)•v`, `B *ᵥ w = (lam+kap)•w`; `T_swaps_eigenvectors`: `T *ᵥ v = w` (Z₂ exchanges the pair).
- `mass_is_symmetry_breaking`: `lam-kap = 0 ↔ kap = lam`, and `kap ↦ -kap` exchanges `{lam-kap, lam+kap}`.
- `naturalness_verdict_finetuning`: control `B(1,1/2)` has det `3/4 ≠ 0`, light level `1/2 ≠ 0`, and no zero mode (injective).
- `naturalness_verdict_protected`: with `kap = lam`, the zero mode `(1,-1,0)` is forced.

Note on the `T` choice: the prompt's suggested `!![0,-1,0;-1,0,0;0,0,1]` actually commutes with `B` for all `kap` (its two `-1` signs cancel), so it does not implement the coupling flip; I used the diagonal reflection `diag(1,-1,1)`, the cleanest involution giving `T·B(lam,kap)·T = B(lam,-kap)`. This is documented in the file docstring and summary.

# Suite D rung D4 — Critical lightness is symmetry-protected

All results live in `RequestProject/Main.lean`, namespace `SuiteD_CriticalSymmetry`.
Everything is over `ℚ` with explicit `3×3` rational matrices; proofs use only
`ring` / `norm_num` / `fin_cases` / `simp` / `linarith`. No `sorry`, `admit`,
`native_decide`, or new axioms. Kernel footprint on every headline is exactly
`[propext, Classical.choice, Quot.sound]`, checked in-file with
`#guard_msgs (whitespace := lax) in #print axioms <thm>`.

## Definitions

* `B lam kap := !![lam, kap, 0; kap, lam, 0; 0, 0, lam]` — the real symmetric mass block
  (spectrum `{lam - kap, lam, lam + kap}`).
* `T := !![1, 0, 0; 0, -1, 0; 0, 0, 1]` — the explicit `Z₂` involution flipping the
  closure coupling.
* `v := ![1, -1, 0]` — the critical zero mode; `w := ![1, 1, 0]` — the heavy-level
  eigenvector.

### Choice of `T`

The prompt suggested `!![0,-1,0; -1,0,0; 0,0,1]`, but that matrix carries two `-1`
signs that cancel under conjugation, so it commutes with `B(lam,kap)` for *all* `kap`
and does not implement the coupling flip. The cleanest involution with the required
content `T · B(lam,kap) · T = B(lam,-kap)` is the diagonal reflection
`T = diag(1,-1,1)`, which is what we use.

## Targets

1. `zero_mode_at_criticality (lam)` — on the critical line, `B(lam,lam) *ᵥ v = 0` and
   `v ≠ 0`: the explicit nonzero zero mode `(1,-1,0)` for any rational `lam`.

2. Enhanced symmetry (payload):
   * `T_involution : T * T = 1`, `T_ne_one`, `T_ne_negOne` — `T` is a nontrivial involution.
   * `enhanced_symmetry_at_criticality : T * B lam kap * T = B lam (-kap)` — the `Z₂`
     action `kap ↦ -kap` (T flips the sign of the closure coupling).
   * `symmetry_iff_kap_zero : T * B lam kap * T = B lam kap ↔ kap = 0` — `T` is an exact
     symmetry of `B` iff the coupling vanishes.
   * `eigen_light : B lam kap *ᵥ v = (lam - kap) • v` and
     `eigen_heavy : B lam kap *ᵥ w = (lam + kap) • w` — the light/heavy eigenpairs.
   * `T_swaps_eigenvectors : T *ᵥ v = w` — the `Z₂` swaps the light and heavy
     eigenvectors, consistent with exchanging the eigenvalues `lam-kap ↔ lam+kap`.

3. `mass_is_symmetry_breaking (lam kap)` — packaged: `lam - kap = 0 ↔ kap = lam`, and
   under `kap ↦ -kap` the pair `{lam-kap, lam+kap}` is exchanged
   (`lam-(-kap) = lam+kap` and `lam+(-kap) = lam-kap`). The light eigenvalue is the
   `Z₂`-symmetry-breaking parameter.

4. Naturalness verdict (both halves):
   * `naturalness_verdict_finetuning` — WITHOUT the `Z₂`, criticality is a codimension-1
     tuning: the control block `B(1, 1/2)` has determinant `3/4 ≠ 0`, light level
     `1 - 1/2 = 1/2 ≠ 0`, and its map is injective (no zero mode).
   * `naturalness_verdict_protected (lam)` — WITH the `Z₂`/critical pinning `kap = lam`,
     the zero mode `(1,-1,0)` is forced for every `lam`.

## Build

`lake build RequestProject.Main` completes in well under 3 minutes with no warnings or
errors.
