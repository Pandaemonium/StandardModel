import Mathlib

/-!
# The fermion-doubling audit: gapless points of the exact walk dispersion
# across the full Brillouin zone

The first technical question the quantum-walk/QCA audience asks of any
lattice Dirac construction: what happens across the ENTIRE Brillouin zone —
doubling, extra cones, anomalous branches?  The landed exact dispersion is
`cos(omega) = cos(k) cos(mu)` (lattice units) for the split-step symbol
`U(k, mu) = e^{-ik sigma_z} e^{-i mu sigma_x}`.  This package proves the
honest doubling accounting for that walk:

* **The massless walk has exactly TWO gapless quasimomenta on the
  fundamental zone `(-pi, pi]`:** the Dirac cone at `k = 0` (bands touch at
  quasienergy `0`, `U = 1`) and the DOUBLER at `k = pi` (bands touch at
  quasienergy `pi`, `U = -1`).  The walk does not evade doubling; the
  doubler is relocated to quasienergy `pi` — the walk's `pi`-mode.
* **One mass gaps both cones simultaneously:** for `0 < mu < pi` the band
  discriminant `4 - tr^2 = 4(1 - cos^2 k cos^2 mu)` is bounded below by
  `4(1 - cos^2 mu) > 0` for every `k`: no gapless point anywhere in the
  zone.
* Both massless branches are exactly luminal (`omega = ±k` solves the
  dispersion identically).

Honest scope: this is the doubling AUDIT of the specific landed `1+1`
split-step walk — a finite trigonometric classification, not a general
Nielsen-Ninomiya theorem, and not a `3+1` statement.  The `pi`-mode is a
known structural feature of split-step walks; the contribution is the exact
kernel-checked classification tied to this program's dispersion.

## Targets

1. `zero_mode` — `U(0, 0) = 1`: the bands are degenerate at quasienergy `0`
   at the zone center.
2. `pi_mode_doubler` — `U(pi, 0) = -1`: the bands are degenerate at
   quasienergy `pi` at the zone edge — the doubler, exhibited exactly.
3. `massless_gapless_classification` — on `k ∈ (-pi, pi]`, the massless
   band-touching condition `(2 cos k)^2 = 4` holds exactly at `k = 0` and
   `k = pi`: the gapless set is `{0, pi}`, no more, no fewer.
4. `massive_no_band_touching` — for `0 < mu < pi` and EVERY real `k`,
   `(2 cos k * cos mu)^2 < 4`: one mass parameter opens both gaps across
   the whole zone (the trace criterion for distinct unimodular eigenvalues
   with unit determinant).
5. `luminal_branches` — `omega = k` and `omega = -k` solve the massless
   dispersion identically: both species move on the light cone.
6. `gap_uniform_bound` — the quantitative version of target 4: the
   discriminant is uniformly bounded below,
   `4 - (2 cos k cos mu)^2 ≥ 4 (1 - cos mu ^ 2) > 0`.

Do not weaken the statements.  Helper lemmas welcome.  Run
`lake env lean FermionDoublingAudit/BrillouinZone.lean` first.
-/

namespace FermionDoublingAudit

open Matrix

/-- The exact split-step walk symbol (closed form, as in the landed
dispersion module). -/
noncomputable def walkU (k m : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![Complex.exp (-(Complex.I * k)), 0; 0, Complex.exp (Complex.I * k)] *
    !![Complex.cos m, -(Complex.I * Complex.sin m);
       -(Complex.I * Complex.sin m), Complex.cos m]

/-- Target 1: the zone-center degeneracy at quasienergy `0`. -/
theorem zero_mode : walkU 0 0 = 1 := by
  unfold walkU
  norm_num [← Matrix.one_fin_two]

/-- Target 2: the doubler — the zone-edge degeneracy at quasienergy `pi`. -/
theorem pi_mode_doubler : walkU Real.pi 0 = -1 := by
  unfold walkU
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Complex.ext_iff, Complex.exp_re, Complex.exp_im]

/-- Target 3: the massless gapless set on the fundamental zone is exactly
`{0, pi}`. -/
theorem massless_gapless_classification (k : ℝ)
    (hk : k ∈ Set.Ioc (-Real.pi) Real.pi) :
    (2 * Real.cos k) ^ 2 = 4 ↔ k = 0 ∨ k = Real.pi := by
  constructor <;> intro h
  · have hpm : Real.cos k = 1 ∨ Real.cos k = -1 :=
      eq_or_eq_neg_of_sq_eq_sq _ _ <| by linarith
    have hsin : Real.sin k = 0 := by nlinarith [Real.sin_sq_add_cos_sq k]
    rcases hpm with h | h <;>
      obtain ⟨m, hm⟩ := Real.sin_eq_zero_iff.mp hsin <;> simp_all +decide
    · rcases m with ⟨_ | _ | m⟩ <;> norm_num at * <;>
        first | (left; nlinarith) | (right; nlinarith)
    · rcases m with ⟨_ | _ | m⟩ <;> norm_num at * <;>
        first | (left; nlinarith) | (right; nlinarith)
  · rcases h with rfl | rfl <;> norm_num

/-- Target 4: one mass gaps the entire zone — the band-touching criterion
fails for every quasimomentum. -/
theorem massive_no_band_touching (mu : ℝ) (h0 : 0 < mu) (hpi : mu < Real.pi)
    (k : ℝ) :
    (2 * Real.cos k * Real.cos mu) ^ 2 < 4 := by
  have hmu : Real.cos mu ^ 2 < 1 := by
    nlinarith [Real.sin_sq_add_cos_sq mu, Real.sin_pos_of_pos_of_lt_pi h0 hpi]
  nlinarith [hmu, Real.cos_sq_le_one k]

/-- Target 5: both massless branches are exactly luminal. -/
theorem luminal_branches (k : ℝ) :
    Real.cos k = Real.cos k * Real.cos 0 ∧
    Real.cos (-k) = Real.cos k * Real.cos 0 := by
  norm_num

/-- Target 6: the uniform gap bound across the zone. -/
theorem gap_uniform_bound (mu : ℝ) (h0 : 0 < mu) (hpi : mu < Real.pi)
    (k : ℝ) :
    4 - (2 * Real.cos k * Real.cos mu) ^ 2 ≥ 4 * (1 - Real.cos mu ^ 2) ∧
    0 < 4 * (1 - Real.cos mu ^ 2) := by
  have hmu : Real.cos mu ^ 2 < 1 := by
    nlinarith [Real.sin_sq_add_cos_sq mu, Real.sin_pos_of_pos_of_lt_pi h0 hpi]
  refine ⟨?_, by nlinarith [hmu]⟩
  nlinarith [Real.cos_sq_le_one k, Real.cos_sq_le_one mu]

end FermionDoublingAudit
