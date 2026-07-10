# Summary of changes for run 415a6a8a-d18c-4b78-85f5-f34f0a2365be
Delivered `RequestProject/Main.lean` (namespace `SuiteD_EntropyMonotone`) and `ARISTOTLE_SUMMARY.md`. The module builds in-project (≈20 s), kernel-checked, with no `sorry`/`admit`/`native_decide` and no new axioms; every headline theorem is verified in-file with `#guard_msgs (whitespace := lax) in #print axioms …` reporting exactly `[propext, Classical.choice, Quot.sound]`. All arithmetic is exact rational (`ring`/`norm_num`/`nlinarith`), no transcendentals.

Setup: `rhoM p z = !![p, z; conj z, 1-p]`, the pinching channel `Pinch t M = (1-t)•M + t•diag M`, the helper `pinch_rhoM` (pinching damps `z ↦ (1-t)z`), and a reusable 2×2 PSD criterion `psd_two` (Hermitian `!![a,b;conj b,d]` with `0≤a`, `0≤d`, `‖b‖²≤a·d` is PSD, via a sum-of-squares identity).

Targets proved:
1. `pinch_is_state` — for a valid state (`0≤p≤1`, `‖z‖²≤p(1-p)`) and `t∈[0,1]`, `Pinch t ρ` is Hermitian, PSD, and trace 1.
2. `det_pinch` — closed form `det (Pinch t ρ) = det ρ + (2t−t²)·‖z‖²` (with supporting exact casts `det_pinch_cast`, `det_rhoM_cast`).
3. `mass_monotone_under_pinch` — the mass² invariant `massSq p z t = (det (Pinch t ρ)).re = p(1-p)−(1-t)²‖z‖²` is `MonotoneOn (Set.Icc 0 1)` and `≥` its `t=0` value; decohering coherence can only increase mass²/linear entropy.
4. `signed_closure_exception` — with `ρ=!![1/2,1/2;1/2,1/2]`, rational 3-4-5 rotation `Urot=!![3/5,-4/5;4/5,3/5]` applied by congruence, and `t=1`: `det(Pinch 1 (U ρ Uᴴ)).re = 49/2500 < 1/4 = det(Pinch 1 ρ).re`, showing a coherent closure move can lower post-pinch mass.

Mandatory non-degeneracy fixture `nondegeneracy`: for `p=1/2, z=1/2`, `massSq 0 = 0` (massless) while `massSq 1 = 1/4 > 0`, so the monotonicity is non-vacuous.

# Suite D · rung D2 — entropy monotonicity under decoherence / compression

All results live in `RequestProject/Main.lean`, namespace `SuiteD_EntropyMonotone`.
Everything is exact rational / `ring` / `norm_num` / `nlinarith` arithmetic — no
transcendentals (`Real.cos/sin/sqrt` are never used). The module builds in-project in
well under 3 minutes (≈20 s for `RequestProject.Main`), kernel-checked, with no
`sorry`/`admit`/`native_decide` and no new axioms.

## Setup

* `rhoM p z : Matrix (Fin 2) (Fin 2) ℂ := !![p, z; conj z, 1-p]` — the 2×2 Hermitian
  direction state.
* `Pinch t M := (1-t)•M + t•diag M` — the pinching (decoherence/compression) channel;
  `t = 0` is the identity, `t = 1` is full decoherence.
* `pinch_rhoM` : `Pinch t (rhoM p z) = !![p, (1-t)z; (1-t) conj z, 1-p]`, i.e. pinching
  damps the off-diagonal coherence `z ↦ (1-t) z`.
* `psd_two` : a reusable criterion — a 2×2 Hermitian matrix `!![a, b; conj b, d]` with
  `0 ≤ a`, `0 ≤ d`, `‖b‖² ≤ a·d` is positive semidefinite (proved via the quadratic-form
  characterization and an explicit sum-of-squares identity `a·Q = |a·x₀+b·x₁|² + (ad-|b|²)|x₁|²`).

## Headline theorems

1. **`pinch_is_state`** — for a valid state (`0 ≤ p ≤ 1`, `‖z‖² ≤ p(1-p)`) and `t ∈ [0,1]`,
   `Pinch t (rhoM p z)` is Hermitian, positive semidefinite, and has trace `1`: a valid
   density operator.
2. **`det_pinch`** — the closed form
   `det (Pinch t ρ) = det ρ + (2t - t²)·‖z‖²`.
   (Supporting exact casts: `det_pinch_cast`: `det (Pinch t ρ) = p(1-p) - (1-t)²‖z‖²`;
   `det_rhoM_cast`: `det ρ = p(1-p) - ‖z‖²`.)
3. **`mass_monotone_under_pinch`** — the mass² invariant `massSq p z t = (det (Pinch t ρ)).re`
   is `MonotoneOn (Set.Icc 0 1)` and satisfies `massSq p z 0 ≤ massSq p z t` for all
   `t ∈ [0,1]`: decohering hidden coherence can only **increase** the mass² / linear entropy
   (recall `S_lin = 2·det` for a trace-1 state, so they move together).
   Closed form: `massSq_eq` : `massSq p z t = p(1-p) - (1-t)²‖z‖²`.
4. **`signed_closure_exception`** — the signed refinement. A coherent (closure) rotation `U`
   applied *before* pinching can *lower* the post-pinch determinant. With the explicit
   rational witness `ρ = !![1/2, 1/2; 1/2, 1/2]`, the rational 3-4-5 rotation
   `Urot = !![3/5, -4/5; 4/5, 3/5]` (acting by congruence `U ρ Uᴴ`), and `t = 1`:
   `det (Pinch 1 (U ρ Uᴴ)).re = 49/2500 < 1/4 = det (Pinch 1 ρ).re`.
   Closure is not noise — it can reorganize coherence and reduce mass.

## Mandatory non-degeneracy fixture

**`nondegeneracy`** — for `p = 1/2`, `z = 1/2` (so `‖z‖² = 1/4`):
`massSq (1/2) (1/2) 0 = 0` (massless: `det ρ = 1/4 - 1/4 = 0`) while
`massSq (1/2) (1/2) 1 = 1/4 > 0` (full decoherence exposes real mass). This concrete
nonzero rational witnesses that the monotonicity is genuinely non-vacuous: coherence hides
real mass.

## Axiom footprint

Each headline theorem is verified in-file with
`#guard_msgs (whitespace := lax) in #print axioms <thm>`, and every one reports exactly
`[propext, Classical.choice, Quot.sound]`.
