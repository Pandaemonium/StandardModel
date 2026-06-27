import Mathlib
import PhysicsSM.Draft.NullEdgeFMSFiniteComposite

/-!
# Next FMS step: the gauge-invariant composite second-order expansion and the
custodial (SU(2)_L-covariant) W interpolating operator (Gate E, E13)

Null-edge unified-mass Wave-10 follow-up to E12
(`PhysicsSM/Draft/NullEdgeFMSFiniteComposite.lean`; Working Plan §25.5 / §26.6).

## What E12 proved (recap)

E12 established, at theorem level, a finite gauge-invariant electroweak orbit
stiffness:

* `linkStiffnessEW_gauge_invariant` — exact gauge invariance of
  `S_H = ∑_e ‖U_e H_t − H_s‖²`.
* `holonomyCost_eq_zero_iff_stabilizer` / `holonomyCost_pos_of_not_stabilizer`
  — finite orbit stiffness: zero cost iff the holonomy stabilises the Higgs
  reference section, positive otherwise.
* `massForm_eq`, `massForm_kernel` — the infinitesimal orbit-stiffness mass form
  `q(X) = ‖ρ(X) H₀‖² = (v²/8)(x₀²+x₁²+(x₂−x₃)²)` with kernel `span ℝ {Q} =
  u(1)_em`.
* `fmsSinglet_gauge_invariant` — exact gauge invariance of the *singlet*
  composite `O_e = H_s^† U_e H_t`.
* `fms_leading_W`, `fms_leading_Z` — the `ε`-linear coefficients of the `τ¹` /
  `τ³` composites at the vacuum.

## What E12 did *not* prove (the honest gap)

1. E12's W/Z leading terms `fms_leading_W`, `fms_leading_Z` are matrix elements
   of the *non-gauge-invariant* `τ¹`, `τ³` composites `H₀^† τ^a ρ H₀`.  Only the
   `τ = 1` singlet was shown gauge invariant; the `τ¹` (W) channel had **no**
   gauge-invariant carrier.
2. E12 keeps the mass form (Part B) and the composite (Part C) as **separate**
   objects.  Nothing tied the gauge-invariant composite's higher-order content
   to the orbit-stiffness mass.
3. No statement about poles, two-point functions, scattering states, or continuum
   spectra — and this file makes **no** such claim either.

## What this file (E13) adds

### Part A — adjoint algebra of the composite inner product

* `cinner_mulVec_left` — `⟪x, M w⟫ = ⟪Mᴴ x, w⟫`.
* `rho_isHermitian` — the Lie-algebra representation `ρ(X)` is Hermitian.

### Part B — the gauge-invariant composite second-order expansion (main result)

* `cinner_H0_rho_sq_H0` — `⟪H₀, ρ(X)² H₀⟫ = q(X)` (the mass form), the key
  bridge identifying the composite's curvature with the orbit-stiffness mass.
* `cinner_H0_rho_H0`, `cnorm2_H0` — the linear (Z) coefficient and the vacuum
  value.
* `fms_singlet_second_order` — for the second-order holonomy
  `U(ε) = 1 + iε ρ(X) − (ε²/2) ρ(X)²` the **exactly gauge-invariant** singlet
  composite expands as
  `O(ε) = v²/2 + iε (v²/4)(x₃−x₂) − (ε²/2) q(X)`,
  i.e. its `ε`-linear term is the gauge-invariant `Z` field and its `ε²` term is
  exactly minus one half the orbit-stiffness mass form.  This unifies E12's
  Part B and Part C inside a single gauge-invariant observable.
* `fms_singlet_no_quadratic_cost_iff` — the composite has vanishing quadratic
  (`ε²`) cost exactly along `u(1)_em` (the photon direction).

### Part C — the custodial W interpolating operator (SU(2)_L-covariant)

E12 had no gauge-invariant W carrier.  Using the conjugate Higgs doublet
`H̃ = iσ² H*`, we build `O_e^W = H̃_s^† U_e H_t` and prove:

* `Htilde_su2_covariant` — `H̃(g H) = g H̃(H)` for any SU(2)-type `g`
  (entries `g₁₁ = conj g₀₀`, `g₁₀ = −conj g₀₁`).
* `su2_entries_of_unitary_det_one` — those entry identities follow from
  `g` unitary with `det g = 1`.
* `fmsW_su2L_invariant` — `O^W` is invariant under SU(2)_L gauge transformations
  at the source (`gs ∈ SU(2)`) together with a unitary `gt` at the target.
* `fmsW_leading` — `⟪H̃(H₀), ρ(X) H₀⟫ = (v²/4)(x₀ − i x₁)`, the `W^∓` field
  combination `A¹ ∓ i A²`, now carried by a genuinely SU(2)_L-covariant operator.

### Scope caveat (manuscript-safe wording for Gate E)

`O^W` is **not** a fully gauge-invariant scalar: under the residual `U(1)_em`
it picks up a phase (the electric charge `±1` of the `W`).  This is physically
correct — the W boson is electrically charged, so its interpolating operator is
custodial-covariant, not invariant.  The honest label remains:

> *gauge-invariant orbit-stiffness reconstruction with an SU(2)_L-covariant
> (custodial) W/Z composite whose vacuum expansion has the W/Z field as the
> leading fluctuation and the orbit-stiffness mass as the quadratic term — not a
> completed physical composite-spectrum (pole / two-point) theorem.*

All declarations live in the `Draft` namespace.
-/

namespace PhysicsSM
namespace Draft

open Matrix Module
open scoped BigOperators

/-! ### Part A — adjoint algebra of the Hermitian composite inner product -/

/-- `cinner` is additive in the second slot under subtraction. -/
lemma cinner_sub {k : ℕ} (x a b : Fin k → ℂ) :
    cinner x (a - b) = cinner x a - cinner x b := by
  unfold cinner
  rw [← Finset.sum_sub_distrib]
  exact Finset.sum_congr rfl fun i _ => by simp [mul_sub]

/-- **Adjoint move.**  `⟪x, M w⟫ = ⟪Mᴴ x, w⟫` for the Hermitian composite inner
product. -/
lemma cinner_mulVec_left {k : ℕ} (M : Matrix (Fin k) (Fin k) ℂ) (x w : Fin k → ℂ) :
    cinner x (M *ᵥ w) = cinner (Mᴴ *ᵥ x) w := by
  rw [cinner_dot, cinner_dot, Matrix.star_mulVec, conjTranspose_conjTranspose,
      Matrix.dotProduct_mulVec]

/-- The Lie-algebra representation `ρ(X)` is Hermitian (self-adjoint). -/
lemma rho_isHermitian (x : Fin 4 → ℝ) : (rho x)ᴴ = rho x := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rho, T1, T2, T3, Yhalf, Matrix.conjTranspose_apply, Complex.conj_ofReal]

/-! ### Part B — the gauge-invariant composite second-order expansion -/

/-- The vacuum value of the singlet composite: `⟪H₀, H₀⟫ = v²/2`. -/
lemma cnorm2_H0 (v : ℝ) : cnorm2 (H0 v) = v ^ 2 / 2 := by
  have hsq : (Real.sqrt 2 : ℝ) ^ 2 = 2 := Real.sq_sqrt (by norm_num)
  simp only [cnorm2, H0, Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one,
    Complex.normSq_div]
  simp [Complex.normSq]
  rw [show ((Real.sqrt 2 : ℝ) : ℝ) ^ 2 = 2 from hsq] at *
  field_simp

/-- The vacuum value of the singlet composite as a complex number. -/
lemma cinner_H0_H0 (v : ℝ) : cinner (H0 v) (H0 v) = (v ^ 2 / 2 : ℂ) := by
  rw [← cnorm2_eq_cinner, cnorm2_H0]; push_cast; ring

/-- **Linear (Z) coefficient.**  `⟪H₀, ρ(X) H₀⟫ = (v²/4)(x₃ − x₂)`, the
gauge-invariant `Z` field combination `B − A³` carried by the singlet composite. -/
lemma cinner_H0_rho_H0 (v : ℝ) (x : Fin 4 → ℝ) :
    cinner (H0 v) (rho x *ᵥ H0 v) = (v ^ 2 / 4 : ℂ) * ((x 3 : ℂ) - (x 2 : ℂ)) := by
  have hsq : (Real.sqrt 2 : ℂ) ^ 2 = 2 := by
    rw [show ((Real.sqrt 2 : ℝ) : ℂ) ^ 2 = (((Real.sqrt 2) ^ 2 : ℝ) : ℂ) by push_cast; ring,
      Real.sq_sqrt (by norm_num : (2 : ℝ) ≥ 0)]; norm_num
  have hs : (Real.sqrt 2 : ℂ) ≠ 0 := by exact_mod_cast Real.sqrt_ne_zero'.mpr (by norm_num)
  rw [← B_EW_eq_matrix, B_EW_apply]
  simp [cinner, kappa, H0, Fin.sum_univ_two, mul_comm]
  field_simp
  rw [hsq]; ring

/-- **The bridge.**  `⟪H₀, ρ(X)² H₀⟫ = q(X)`, the orbit-stiffness mass form.
Because `ρ(X)` is Hermitian, the composite's quadratic curvature is exactly the
mass form `‖ρ(X) H₀‖²`. -/
lemma cinner_H0_rho_sq_H0 (v : ℝ) (x : Fin 4 → ℝ) :
    cinner (H0 v) (rho x *ᵥ (rho x *ᵥ H0 v)) = (massForm v x : ℂ) := by
  rw [cinner_mulVec_left, rho_isHermitian, massForm, cnorm2_eq_cinner]

/--
**Gauge-invariant composite, exact second-order expansion (main theorem).**
For the second-order holonomy `U(ε) = 1 + iε ρ(X) − (ε²/2) ρ(X)²` the exactly
gauge-invariant singlet composite `O = H₀^† U H₀` expands as
`O(ε) = v²/2 + iε (v²/4)(x₃ − x₂) − (ε²/2) q(X)`:
the `ε`-linear term is the gauge-invariant `Z` field and the `ε²` term is exactly
minus one half the orbit-stiffness mass form `q(X)` (`massForm`).  This unifies
the orbit-stiffness mass (E12 Part B) and the FMS composite (E12 Part C) inside a
single gauge-invariant observable.
-/
theorem fms_singlet_second_order (v ε : ℝ) (x : Fin 4 → ℝ) :
    fmsComposite (H0 v) (H0 v) 1
        (1 + (Complex.I * (ε : ℂ)) • rho x - ((ε : ℂ) ^ 2 / 2) • (rho x * rho x))
      = (v ^ 2 / 2 : ℂ)
        + (Complex.I * (ε : ℂ)) * ((v ^ 2 / 4 : ℂ) * ((x 3 : ℂ) - (x 2 : ℂ)))
        - ((ε : ℂ) ^ 2 / 2) * (massForm v x) := by
  unfold fmsComposite
  rw [Matrix.one_mulVec]
  have hstep :
      (1 + (Complex.I * (ε : ℂ)) • rho x - ((ε : ℂ) ^ 2 / 2) • (rho x * rho x)) *ᵥ H0 v
        = H0 v + (Complex.I * (ε : ℂ)) • (rho x *ᵥ H0 v)
            - ((ε : ℂ) ^ 2 / 2) • (rho x *ᵥ (rho x *ᵥ H0 v)) := by
    rw [Matrix.sub_mulVec, Matrix.add_mulVec, Matrix.one_mulVec, smul_mulVec,
        smul_mulVec, Matrix.mulVec_mulVec]
  rw [hstep, cinner_sub, cinner_add, cinner_smul, cinner_smul,
      cinner_H0_H0, cinner_H0_rho_H0, cinner_H0_rho_sq_H0]

/--
**No quadratic cost iff photon direction.**  The gauge-invariant composite's
quadratic (`ε²`) coefficient `q(X)` vanishes exactly on `span ℝ {Q} = u(1)_em`:
to second order the composite is purely vacuum + linear `Z` exactly along the
electromagnetic direction.
-/
theorem fms_singlet_no_quadratic_cost_iff {v : ℝ} (hv : v ≠ 0) (x : Fin 4 → ℝ) :
    massForm v x = 0 ↔ x ∈ Submodule.span ℝ {Qgen} := by
  rw [← SetLike.mem_coe, ← massForm_kernel hv, Set.mem_setOf_eq]

/-! ### Part C — the custodial (SU(2)_L-covariant) W interpolating operator -/

/-- The conjugate Higgs doublet `H̃ = iσ² H* = (H₁*, −H₀*)`. -/
noncomputable def Htilde (H : Fin 2 → ℂ) : Fin 2 → ℂ := ![star (H 1), - star (H 0)]

/--
**Custodial covariance of the conjugate doublet.**  For any SU(2)-type matrix
`g` (entries `g₁₁ = conj g₀₀`, `g₁₀ = −conj g₀₁`), the conjugate doublet
transforms covariantly: `H̃(g H) = g H̃(H)`.
-/
lemma Htilde_su2_covariant (g : Matrix (Fin 2) (Fin 2) ℂ) (H : Fin 2 → ℂ)
    (h1 : g 1 1 = star (g 0 0)) (h2 : g 1 0 = - star (g 0 1)) :
    Htilde (g *ᵥ H) = g *ᵥ (Htilde H) := by
  funext i
  fin_cases i <;>
    (simp [Htilde, Matrix.mulVec, dotProduct, Fin.sum_univ_two, h1, h2, star_mul',
      mul_comm]; try ring)

/-
The SU(2) entry identities follow from `g` unitary with `det g = 1`.
-/
lemma su2_entries_of_unitary_det_one (g : Matrix (Fin 2) (Fin 2) ℂ)
    (hu : star g * g = 1) (hd : g.det = 1) :
    g 1 1 = star (g 0 0) ∧ g 1 0 = - star (g 0 1) := by
  simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply, Matrix.det_fin_two ];
  grind

/-- The finite **custodial W interpolating operator**
`O_e^W = H̃_{s(e)}^† U_e H_{t(e)}` built from the conjugate Higgs doublet. -/
noncomputable def fmsW (Hs Ht : Fin 2 → ℂ) (U : Matrix (Fin 2) (Fin 2) ℂ) : ℂ :=
  cinner (Htilde Hs) (U *ᵥ Ht)

/--
**SU(2)_L invariance of the custodial W operator.**  Under a source gauge
transformation `gs ∈ SU(2)` (unitary with the SU(2) entry identities) and a
unitary target transformation `gt`, the custodial W operator
`O^W = H̃_s^† U_e H_t` is invariant:
`O^W(gs Hs, gt Ht, gs U gt^{-1}) = O^W(Hs, Ht, U)`.

Under the residual `U(1)_em` the operator instead acquires a phase (the electric
charge `±1` of the W); this is the charged W interpolating operator, custodial-
covariant rather than fully invariant.
-/
theorem fmsW_su2L_invariant (Hs Ht : Fin 2 → ℂ)
    (U gs gt : Matrix (Fin 2) (Fin 2) ℂ)
    (hgs : star gs * gs = 1) (hgt : star gt * gt = 1)
    (hgs1 : gs 1 1 = star (gs 0 0)) (hgs2 : gs 1 0 = - star (gs 0 1)) :
    fmsW (gs *ᵥ Hs) (gt *ᵥ Ht) (gs * U * star gt) = fmsW Hs Ht U := by
  unfold fmsW
  rw [Htilde_su2_covariant gs Hs hgs1 hgs2]
  have hcollapse : star gt *ᵥ (gt *ᵥ Ht) = Ht := by
    rw [Matrix.mulVec_mulVec, hgt, Matrix.one_mulVec]
  have key : (gs * U * star gt) *ᵥ (gt *ᵥ Ht) = gs *ᵥ (U *ᵥ Ht) := by
    rw [← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec, hcollapse, Matrix.mulVec_mulVec]
  rw [key, cinner_mulVec_of_unitary _ hgs]

/--
**Custodial W leading term.**  At the vacuum the custodial W operator's linear
fluctuation is `⟪H̃(H₀), ρ(X) H₀⟫ = (v²/4)(x₀ − i x₁)`, exactly the `W^∓` field
combination `A¹ ∓ i A²`.  Unlike E12's `fms_leading_W` (a matrix element of the
non-covariant `τ¹` composite), this leading term is carried by the genuinely
SU(2)_L-covariant operator `fmsW`.
-/
theorem fmsW_leading (v : ℝ) (x : Fin 4 → ℝ) :
    cinner (Htilde (H0 v)) (rho x *ᵥ H0 v)
      = (v ^ 2 / 4 : ℂ) * ((x 0 : ℂ) - Complex.I * (x 1 : ℂ)) := by
  have hsq : (Real.sqrt 2 : ℂ) ^ 2 = 2 := by
    rw [show ((Real.sqrt 2 : ℝ) : ℂ) ^ 2 = (((Real.sqrt 2) ^ 2 : ℝ) : ℂ) by push_cast; ring,
      Real.sq_sqrt (by norm_num : (2 : ℝ) ≥ 0)]; norm_num
  have hs : (Real.sqrt 2 : ℂ) ≠ 0 := by exact_mod_cast Real.sqrt_ne_zero'.mpr (by norm_num)
  rw [← B_EW_eq_matrix, B_EW_apply]
  simp [cinner, Htilde, kappa, H0, Fin.sum_univ_two, mul_comm]
  field_simp
  rw [hsq]; ring

end Draft
end PhysicsSM
