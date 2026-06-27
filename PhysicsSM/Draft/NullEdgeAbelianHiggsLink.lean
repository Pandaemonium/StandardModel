import Mathlib

/-!
# Finite Abelian Higgs gauge-invariant link stiffness

Aristotle draft target for the null-edge unified mass first wave (proof-chain
entry **T8**; Working Plan Section 17.3 Theorem B; grand-strategy Sections D.3,
E.2, F).

## What this file proves

Let a finite directed graph be given by a finite edge type `E`, a vertex type
`V`, and source / target maps `s t : E -> V`.  A scalar ("Higgs") field is a map
`phi : V -> C`, and a `U(1)` gauge connection is a map `U : E -> Circle`, where
`Circle` is Mathlib's unit circle `{z : C // ‖z‖ = 1}` with its group structure.

The gauge-invariant link-stiffness action is

```text
S_H(phi, U) = sum_e |U_e * phi_{t(e)} - phi_{s(e)}|^2 .
```

We prove, all as kernel-checked finite identities:

* `linkStiffness_gauge_invariant` -- `S_H` is invariant under the gauge action
  `phi_v -> g_v phi_v`, `U_e -> g_{s(e)} U_e g_{t(e)}^{-1}`.
* `linkStiffness_frozen_modulus` -- with frozen modulus `phi_v = v * sigma_v`,
  `sigma_v in Circle`, the exact identity
  `S_H = v^2 * sum_e |w_e - 1|^2`, `w_e = sigma_{s(e)}^{-1} U_e sigma_{t(e)}`.
* `circle_normSq_sub_one_eq` / `small_holonomy_quadratic_bound` -- the
  small-holonomy ("Taylor") expansion `|w_e - 1|^2 = 2(1 - cos θ)` with
  `w_e = exp(i θ)`, and the quadratic-leading bound
  `|2(1 - cos θ) - θ^2| ≤ θ^4 * (5/48)` for `|θ| ≤ 1`.  This expansion is
  *interpretation* (the gauge-boson mass term `v^2 θ^2`), **not** the exact
  theorem.

## Conventions and guardrails

* The exact theorem is **gauge-invariant link stiffness**, not directly a mass
  theorem.  The gauge-boson mass term `v^2 epsilon^2 A_e^2` only emerges after
  the vacuum (frozen-modulus) and small-holonomy expansions, and is labelled as
  interpretation, not as the kernel-checked identity.
* No local-gauge-symmetry-"breaking" language is used: `S_H` and `|w_e - 1|^2`
  are gauge-invariant objects; the Higgs value supplies a covariant internal
  reference section, and holonomies that fail to preserve it acquire a quadratic
  edge cost while stabilizer directions remain gapless.
* **Scope caveat (grand-strategy E.2 / Working Plan 16.10):** on its own this is
  close to standard lattice gauge-Higgs theory.  The null-edge content requires
  the surrounding package (null-supported kinetic terms, dual-soldered symbol
  recovery, the super-Dirac square); this file is the finite link-stiffness
  identity only.

All declarations are `Draft` namespace.
-/

namespace PhysicsSM
namespace Draft

open scoped BigOperators

variable {V E : Type*} [Fintype E]

/-- The finite Abelian-Higgs **link-stiffness action**
`S_H(phi, U) = sum_e |U_e * phi_{t(e)} - phi_{s(e)}|^2`, for a `U(1)` connection
`U : E -> Circle` and a complex scalar field `phi : V -> C` on a finite directed
graph with source / target maps `s t : E -> V`.  `Complex.normSq z = |z|^2`. -/
def linkStiffness (s t : E → V) (phi : V → ℂ) (U : E → Circle) : ℝ :=
  ∑ e, Complex.normSq ((U e : ℂ) * phi (t e) - phi (s e))

/--
**Gauge invariance (T8).**  Under the local `U(1)` gauge transformation
`phi_v -> g_v phi_v` and `U_e -> g_{s(e)} U_e g_{t(e)}^{-1}`, the link-stiffness
action is unchanged.  This is the exact, kernel-checked statement; no symmetry is
"broken".
-/
theorem linkStiffness_gauge_invariant (s t : E → V) (phi : V → ℂ)
    (U : E → Circle) (g : V → Circle) :
    linkStiffness s t (fun v => (g v : ℂ) * phi v)
        (fun e => g (s e) * U e * (g (t e))⁻¹)
      = linkStiffness s t phi U := by
  unfold linkStiffness
  refine Finset.sum_congr rfl (fun e _ => ?_)
  simp only []
  have hg : Complex.normSq ((g (s e) : ℂ)) = 1 := by
    rw [Complex.normSq_eq_norm_sq, Circle.norm_coe]; norm_num
  have key : ((((g (s e) * U e * (g (t e))⁻¹ : Circle)) : ℂ) * ((g (t e) : ℂ) * phi (t e))
        - (g (s e) : ℂ) * phi (s e))
      = (g (s e) : ℂ) * ((U e : ℂ) * phi (t e) - phi (s e)) := by
    push_cast [Circle.coe_mul, Circle.coe_inv]
    field_simp
  rw [key, Complex.normSq_mul, hg, one_mul]

/--
**Frozen-modulus exact identity (T8).**  With `phi_v = v * sigma_v`,
`sigma_v in Circle` (so `|phi_v| = |v|`), the link stiffness is exactly
`S_H = v^2 * sum_e |w_e - 1|^2`, where the gauge-invariant link mismatch is
`w_e = sigma_{s(e)}^{-1} * U_e * sigma_{t(e)} in Circle`.  This is the exact
theorem; the gauge-boson mass interpretation appears only after the
small-holonomy expansion below.
-/
theorem linkStiffness_frozen_modulus (s t : E → V) (v : ℝ)
    (sigma : V → Circle) (U : E → Circle) :
    linkStiffness s t (fun x => (v : ℂ) * (sigma x : ℂ)) U
      = v ^ 2 * ∑ e, Complex.normSq
          ((((sigma (s e))⁻¹ * U e * sigma (t e) : Circle) : ℂ) - 1) := by
  unfold linkStiffness
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl (fun e _ => ?_)
  simp only []
  have hs : Complex.normSq ((sigma (s e) : ℂ)) = 1 := by
    rw [Complex.normSq_eq_norm_sq, Circle.norm_coe]; norm_num
  have key : ((((sigma (s e))⁻¹ * U e * sigma (t e) : Circle) : ℂ) - 1)
      = (sigma (s e) : ℂ)⁻¹ * ((U e : ℂ) * (sigma (t e) : ℂ) - (sigma (s e) : ℂ)) := by
    push_cast [Circle.coe_mul, Circle.coe_inv]
    field_simp
  have hlhs : ((U e : ℂ) * ((v : ℂ) * (sigma (t e) : ℂ)) - (v : ℂ) * (sigma (s e) : ℂ))
      = (v : ℂ) * ((U e : ℂ) * (sigma (t e) : ℂ) - (sigma (s e) : ℂ)) := by ring
  rw [key, hlhs, Complex.normSq_mul, Complex.normSq_mul, Complex.normSq_ofReal,
    Complex.normSq_inv, hs]
  ring

/--
**Small-holonomy exact identity.**  For a link mismatch written as a pure
holonomy `w = exp(i θ)`, the per-edge cost is `|w - 1|^2 = 2 (1 - cos θ)`.
-/
theorem circle_normSq_sub_one_eq (θ : ℝ) :
    Complex.normSq ((Circle.exp θ : ℂ) - 1) = 2 * (1 - Real.cos θ) := by
  norm_num [ Complex.normSq, Complex.exp_re, Complex.exp_im ];
  linarith [ Real.sin_sq_add_cos_sq θ ]

/--
**Small-holonomy quadratic expansion (interpretation, not the exact
theorem).**  The per-edge cost `2 (1 - cos θ)` agrees with the quadratic
gauge-boson mass term `θ^2` up to a controlled quartic remainder:
`|2 (1 - cos θ) - θ^2| ≤ θ^4 * (5/48)` for `|θ| ≤ 1`.  Writing `θ = epsilon A_e`
and reinstating the `v^2` prefactor of `linkStiffness_frozen_modulus` gives the
interpreted mass term `v^2 epsilon^2 A_e^2 + O(epsilon^4)`.
-/
theorem small_holonomy_quadratic_bound {θ : ℝ} (hθ : |θ| ≤ 1) :
    |2 * (1 - Real.cos θ) - θ ^ 2| ≤ θ ^ 4 * (5 / 48) := by
  have hb := Real.cos_bound hθ
  have key : 2 * (1 - Real.cos θ) - θ ^ 2 = (-2) * (Real.cos θ - (1 - θ ^ 2 / 2)) := by ring
  have hpow : |θ| ^ 4 = θ ^ 4 := by rw [← abs_pow]; exact abs_of_nonneg (by positivity)
  rw [key, abs_mul, show |(-2 : ℝ)| = 2 from by norm_num]
  nlinarith [hb, abs_nonneg (Real.cos θ - (1 - θ ^ 2 / 2)), hpow]

end Draft
end PhysicsSM
