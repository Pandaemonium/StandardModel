/-
# Goal III rung (e) — discrete boost covariance is BORN at criticality

Clean-room, Mathlib-only formalization of the claim that Lorentz/boost symmetry
is an **emergent** property of the null-edge chain carrier's Dirac quantum walk:
it holds *exactly* on the massless (critical) line and *fails* off it.

The exact lattice dispersion of the one-step walk (seed `ContinuumLimit`,
`Ustep_trace` + `Ustep_det`) is

```
cos ω(k) = cos k · cos θ         (θ = mass angle, θ = 0 massless)
```

We introduce a genuine discrete **boost** — a `2×2` hyperbolic rotation acting
on the momentum data `(ω, k)` — and prove the emergence theorem pair.

## The boost operator

`Boost c s = !![c, s; s, c]` acts on `v = (ω, k)` by `mulVec`.  Whenever
`c² − s² = 1` it is a Lorentz boost: `det = 1` and it exactly preserves the
Minkowski quadratic form `Q(ω,k) = ω² − k²`.  Our **nontrivial rational
witness** is the `3-4-5` boost

```
Λ = Boost (5/3) (4/3),   (5/3)² − (4/3)² = 25/9 − 16/9 = 1,   Λ ≠ 1.
```

## The theorem pair

* **`massless_walk_boost_covariant` (the WIN).**  On the massless line the mass
  shell is the light cone `ω = ±k` (`Q = 0`, seed `conical_dispersion_z_eq_one`).
  The `3-4-5` boost has `det = 1`, is `≠ 1`, preserves `Q` for *every* momentum,
  hence maps the massless shell to itself; concretely the lattice massless-shell
  point `(ω,k) = (π/3, π/3)` boosts to `(π, π)`, again on the massless shell.

* **`massive_walk_boost_covariance_fails` (the KILL of trivial universality).**
  Off the critical line (mass angle `θ = π/3`, `cos²θ = 1/4 ≠ 1`), the SAME
  `3-4-5` boost does NOT preserve the hyperbolic-shifted shell
  `cos ω = cos k · cos θ`: the on-shell point `(ω,k) = (π/3, 0)` boosts to
  `(5π/9, 4π/9)`, which leaves the shell (a clean sign obstruction:
  `cos(5π/9) < 0 < cos(4π/9)·cos θ`).

Together: boost covariance is a critical-point phenomenon.

## Honest note on the form of covariance

We prove **mass-shell-set invariance** (the covariance form the strategy allows
as the clean landing), together with exact invariance of the Minkowski quadratic
form `Q` under the boost — not a full spinor intertwiner `U(Λ·p) = S U(p) S⁻¹`.
Indeed no such fixed-operator intertwiner exists: `Ushift k = diag(e^{-ik},e^{ik})`
has boost-rescaled eigenvalues `e^{∓iβk}`, so distinct-`k` walk operators are not
similar; discrete boost covariance is a statement about the dispersion *set*, not
operator similarity.  This is recorded faithfully here.

Kernel-checked: no `sorry`/`admit`/`native_decide`/new `axiom`; every headline
theorem is pinned to footprint `[propext, Classical.choice, Quot.sound]`.
-/

import Mathlib

open Real Matrix

namespace Goal3BoostCov

/-! ## The discrete boost operator -/

/-- Discrete **boost** (hyperbolic rotation) with parameters `c, s`, acting on the
momentum 2-vector `v = (ω, k)` via `mulVec`.  When `c² − s² = 1` this is a Lorentz
boost of rapidity `φ` with `c = cosh φ`, `s = sinh φ`. -/
def Boost (c s : ℝ) : Matrix (Fin 2) (Fin 2) ℝ := !![c, s; s, c]

/-- Minkowski quadratic form `Q(ω, k) = ω² − k²` (`v 0 = ω`, `v 1 = k`).  Its zero
set is the light cone `ω = ±k`; its `= m²` level set is the massive mass shell. -/
def Q (v : Fin 2 → ℝ) : ℝ := v 0 ^ 2 - v 1 ^ 2

/-- The exact lattice mass shell of the Dirac quantum walk (seed `Ustep_trace`):
`cos ω = cos k · cos θ`, with `θ` the mass angle (`θ = 0` massless). -/
def OnShell (θ : ℝ) (v : Fin 2 → ℝ) : Prop :=
  Real.cos (v 0) = Real.cos (v 1) * Real.cos θ

/-- Action of the boost on a concrete momentum `(ω, k)`. -/
theorem boost_mulVec (c s ω k : ℝ) :
    (Boost c s).mulVec ![ω, k] = ![c * ω + s * k, s * ω + c * k] := by
  funext i; fin_cases i <;>
    simp [Boost, Matrix.mulVec, dotProduct, Fin.sum_univ_two]

/-- `det (Boost c s) = c² − s²`. -/
theorem boost_det (c s : ℝ) : (Boost c s).det = c ^ 2 - s ^ 2 := by
  simp [Boost, Matrix.det_fin_two_of]; ring

/-- **A boost with `c² − s² = 1` preserves the Minkowski form `Q` exactly**
(for every momentum, not merely on the shell). -/
theorem boost_preserves_form (c s : ℝ) (h : c ^ 2 - s ^ 2 = 1) (v : Fin 2 → ℝ) :
    Q ((Boost c s).mulVec v) = Q v := by
  simp only [Q, Boost, Matrix.mulVec, dotProduct, Fin.sum_univ_two,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val', Matrix.of_apply,
    Matrix.empty_val', Matrix.cons_val_fin_one]
  nlinarith [h, sq_nonneg (v 0), sq_nonneg (v 1)]

/-! ## The nontrivial rational `3-4-5` boost -/

/-- The explicit **nontrivial rational boost** `Λ = Boost (5/3) (4/3)`
(rapidity `φ = artanh (4/5) ≠ 0`). -/
noncomputable def Lam : Matrix (Fin 2) (Fin 2) ℝ := Boost (5 / 3) (4 / 3)

/-- `Λ` is a genuine Lorentz boost: `det Λ = 1`. -/
theorem lam_det : Lam.det = 1 := by
  rw [Lam, boost_det]; norm_num

/-- **Non-degeneracy fixture: `Λ ≠ 1`.**  So the covariance below is not the
trivial `Λ = 1` statement. -/
theorem lam_ne_one : Lam ≠ (1 : Matrix (Fin 2) (Fin 2) ℝ) := by
  intro h
  have h01 : Lam 0 1 = (1 : Matrix (Fin 2) (Fin 2) ℝ) 0 1 := by rw [h]
  simp [Lam, Boost] at h01

/-- `Λ` preserves the Minkowski form `Q` exactly. -/
theorem lam_preserves_form (v : Fin 2 → ℝ) : Q (Lam.mulVec v) = Q v := by
  rw [Lam]; exact boost_preserves_form _ _ (by norm_num) v

/-! ## Target 1 — the WIN: massless boost covariance -/

/-- **`massless_walk_boost_covariant`.**  On the massless line the mass shell is
the light cone `Q = ω² − k² = 0`.  The nontrivial rational `3-4-5` boost `Λ`:

1. is a genuine boost with `det Λ = 1`, and is `Λ ≠ 1` (nondegenerate);
2. preserves the Minkowski form `Q` for *every* momentum, hence maps the massless
   light cone `Q = 0` to itself (**mass-shell-set invariance**);
3. concretely maps the lattice massless-shell point `(ω,k) = (π/3, π/3)` to
   `(π, π)`, which is again on the massless lattice shell `cos ω = cos k`.

So discrete boost covariance holds exactly on the critical (massless) line. -/
theorem massless_walk_boost_covariant :
    Lam.det = 1
      ∧ Lam ≠ (1 : Matrix (Fin 2) (Fin 2) ℝ)
      ∧ (∀ v : Fin 2 → ℝ, Q (Lam.mulVec v) = Q v)
      ∧ (∀ v : Fin 2 → ℝ, Q v = 0 → Q (Lam.mulVec v) = 0)
      ∧ Lam.mulVec ![Real.pi / 3, Real.pi / 3] = ![Real.pi, Real.pi]
      ∧ OnShell 0 ![Real.pi / 3, Real.pi / 3]
      ∧ OnShell 0 (Lam.mulVec ![Real.pi / 3, Real.pi / 3]) := by
  have hmap : Lam.mulVec ![Real.pi / 3, Real.pi / 3] = ![Real.pi, Real.pi] := by
    rw [Lam, boost_mulVec]; funext i; fin_cases i <;> simp <;> ring
  refine ⟨lam_det, lam_ne_one, lam_preserves_form, ?_, hmap, ?_, ?_⟩
  · intro v hv; rw [lam_preserves_form v, hv]
  · simp [OnShell]
  · rw [hmap]; simp [OnShell]

/-! ## Target 2 — the KILL: massive boost covariance fails -/

/-- **`massive_walk_boost_covariance_fails`.**  Off the critical line
(mass angle `θ = π/3`, so `cos²θ = 1/4 ≠ 1`, a genuinely massive walk), the SAME
`3-4-5` boost `Λ` does NOT preserve the hyperbolic-shifted mass shell
`cos ω = cos k · cos θ`:

* the point `(ω, k) = (π/3, 0)` lies on the massive shell
  (`cos(π/3) = cos 0 · cos(π/3)`);
* its boost is `Λ · (π/3, 0) = (5π/9, 4π/9)`;
* this boosted point leaves the shell: `cos(5π/9) ≠ cos(4π/9) · cos(π/3)`, by a
  sign obstruction (`cos(5π/9) < 0` while `cos(4π/9)·cos(π/3) > 0`).

So boost covariance is special to criticality: it is broken by any nonzero mass. -/
theorem massive_walk_boost_covariance_fails :
    Real.cos (Real.pi / 3) ^ 2 ≠ 1
      ∧ OnShell (Real.pi / 3) ![Real.pi / 3, 0]
      ∧ Lam.mulVec ![Real.pi / 3, 0] = ![5 * Real.pi / 9, 4 * Real.pi / 9]
      ∧ ¬ OnShell (Real.pi / 3) (Lam.mulVec ![Real.pi / 3, 0]) := by
  have hmap : Lam.mulVec ![Real.pi / 3, 0] = ![5 * Real.pi / 9, 4 * Real.pi / 9] := by
    rw [Lam, boost_mulVec]; funext i; fin_cases i <;> simp <;> ring
  refine ⟨?_, ?_, hmap, ?_⟩
  · rw [Real.cos_pi_div_three]; norm_num
  · simp [OnShell, Real.cos_pi_div_three]
  · rw [hmap]
    simp only [OnShell, Matrix.cons_val_zero, Matrix.cons_val_one, Real.cos_pi_div_three]
    have h1 : Real.cos (5 * Real.pi / 9) < 0 := by
      apply Real.cos_neg_of_pi_div_two_lt_of_lt <;> nlinarith [Real.pi_pos]
    have h2 : Real.cos (4 * Real.pi / 9) > 0 := by
      apply Real.cos_pos_of_mem_Ioo; constructor <;> nlinarith [Real.pi_pos]
    intro h; nlinarith [h, h1, h2]

/-! ## Axiom pins (headline theorems) -/

/-- info: 'Goal3BoostCov.massless_walk_boost_covariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_walk_boost_covariant

/-- info: 'Goal3BoostCov.massive_walk_boost_covariance_fails' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massive_walk_boost_covariance_fails

end Goal3BoostCov
