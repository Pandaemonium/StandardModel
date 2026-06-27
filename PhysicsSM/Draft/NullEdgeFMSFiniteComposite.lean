import Mathlib
import PhysicsSM.Draft.NullEdgeElectroweakStabilizer

/-!
# Finite FMS gauge-invariant link composite and the W/Z leading-term theorem (Gate E)

Null-edge unified-mass Wave-10 target (Working Plan §25.5 / §26.6, Gate E).

This module upgrades the abelian link-stiffness file
`PhysicsSM/Draft/NullEdgeAbelianHiggsLink.lean` and the electroweak stabilizer
file `PhysicsSM/Draft/NullEdgeElectroweakStabilizer.lean` to a **non-abelian,
electroweak, Fröhlich–Morchio–Strocchi (FMS)-compatible** finite composite, at
*theorem level*, not just in prose.

The whole story is told in **gauge-invariant / stabilizer / orbit-stiffness**
language.  No literal local-gauge-symmetry-"breaking" wording is used: a local
gauge symmetry is a redundancy and is not an observable that breaks.  The Higgs
vacuum value supplies a *covariant internal reference section*; holonomies that
preserve it cost nothing, holonomies that move it acquire positive quadratic
cost, and the physical W/Z fields appear as gauge-invariant composites.

## What this file contains

### Part A — finite non-abelian (electroweak) link stiffness

* `cnorm2`, `cinner` — the Hermitian norm² / inner product on `ℂ²`.
* `linkStiffnessEW` — `S_H = ∑_e ‖U_e H_{t(e)} - H_{s(e)}‖²` for a matrix-valued
  (`U(2)`/`SU(2)`) connection `U : E → Matrix (Fin 2) (Fin 2) ℂ` and a doublet
  field `H : V → ℂ²`.
* `cnorm2_mulVec_of_unitary` — unitary matrices preserve `cnorm2`.
* `linkStiffnessEW_gauge_invariant` — exact gauge invariance under
  `H_v ↦ g_v H_v`, `U_e ↦ g_{s(e)} U_e g_{t(e)}⁻¹` for unitary `g_v`.

### Part B — orbit stiffness (zero vs positive quadratic cost)

* `holonomyCost`, `holonomyCost_eq_zero_iff_stabilizer`,
  `holonomyCost_pos_of_not_stabilizer` — the finite, holonomy-level orbit
  stiffness: an edge holonomy costs zero **iff** it stabilises the Higgs
  reference section, and strictly positive otherwise.
* `massForm`, `massForm_eq`, `massForm_kernel` — the infinitesimal
  (Lie-algebra) orbit-stiffness mass form `‖ρ(X) H₀‖²`, its closed form
  `(v²/8)(x₀²+x₁²+(x₂-x₃)²)`, and its kernel `span ℝ {Q} = u(1)_em` (the massless
  photon direction).  This is the **structural** rank/orbit-stiffness content,
  deliberately kept free of coupling-constant normalisation.

### Part C — the FMS composite observable and the W/Z leading term

* `cinner`-based `fmsComposite` — `O_e^a = H_{s(e)}^† τ^a U_e H_{t(e)}`.
* `fmsSinglet_gauge_invariant` — the singlet variant (`τ = 1`),
  `O_e = H_s^† U_e H_t`, is exactly gauge invariant.
* `fms_leading_W`, `fms_leading_Z` — the **leading fluctuation** theorem:
  for a linearised holonomy `U = 1 + iε ρ(X)` the `ε`-linear coefficient of the
  composite is exactly `(v²/4)(x₀ - i x₁)` in the `τ¹` channel (the `W^∓` field
  combination `A¹ ∓ i A²`) and `(v²/4)(x₂ - x₃)` in the `τ³` channel (the `Z`
  field combination `A³ - B`).  The orthogonal `x₂ + x₃` (photon) combination is
  absent — consistent with `massForm_kernel`.
* `fms_linear_expansion_W` — the assembled linear expansion with the constant
  (vacuum) term made explicit.

### Part D — coefficient normalisation (kept separate)

Per the guardrail of §25.5 / §26.6, the mass *coefficients* `m_W`, `m_Z` depend
on generator and kinetic conventions and are stated **separately** from the
structural theorems:

* `massForm_coupling_form` — purely algebraic rewriting of the mass form after
  inserting couplings `x = (g A¹, g A², g A³, g' B)`.
* `mW`, `mZ`, `mW_sq`, `mZ_sq` — the convention-dependent mass formulas
  `m_W = g v/2`, `m_Z = √(g²+g'²) v/2`.
* `massForm_physical_normalization` — the bridge identifying the mass form with
  the canonical `½ m_W²(A¹²+A²²) + ½ m_Z² Z²` mass term.

## Conventions

* Generators `T₁,T₂,T₃ = σ_a/2`, `Y/2 = (1/2)I`, charge `Q = T₃ + Y/2`,
  vacuum `H₀ = (0, v/√2)`, coordinates `(x₀,x₁,x₂,x₃)` along
  `(T₁,T₂,T₃,Y/2)` — all imported from
  `PhysicsSM.Draft.NullEdgeElectroweakStabilizer`.
* `τ¹,τ²,τ³` below are the *full* Pauli matrices (not halved), the standard FMS
  isospin projectors in the composite `H^† τ^a U H`.
* `Matrix` `star` is the conjugate transpose; "unitary" means `star M * M = 1`.

## Scope caveat

This is a finite gauge-invariant orbit-stiffness reconstruction with an explicit
W/Z leading-fluctuation theorem.  It is **not** a completed physical
composite-spectrum theorem (no two-point function / pole analysis).  W/Z claims
elsewhere should keep the label "gauge-invariant orbit-stiffness reconstruction".

All declarations live in the `Draft` namespace.
-/

namespace PhysicsSM
namespace Draft

open Matrix Module
open scoped BigOperators

/-! ### Part A — Hermitian inner product and the non-abelian link stiffness -/

/-- Hermitian squared norm on `ℂ²` (indeed any `Fin k → ℂ`): `∑ i |w i|²`. -/
noncomputable def cnorm2 {k : ℕ} (w : Fin k → ℂ) : ℝ := ∑ i, Complex.normSq (w i)

/-- Hermitian inner product on `ℂ²`: `⟪x, w⟫ = ∑ i conj(x i) · w i`. -/
noncomputable def cinner {k : ℕ} (x w : Fin k → ℂ) : ℂ := ∑ i, (starRingEnd ℂ) (x i) * w i

lemma cinner_dot {k : ℕ} (x w : Fin k → ℂ) : cinner x w = star x ⬝ᵥ w := rfl

lemma cinner_add {k : ℕ} (x a b : Fin k → ℂ) :
    cinner x (a + b) = cinner x a + cinner x b := by
  unfold cinner
  rw [← Finset.sum_add_distrib]
  exact Finset.sum_congr rfl fun i _ => by simp [mul_add]

lemma cinner_smul {k : ℕ} (x w : Fin k → ℂ) (c : ℂ) :
    cinner x (c • w) = c * cinner x w := by
  unfold cinner
  rw [Finset.mul_sum]
  exact Finset.sum_congr rfl fun _ _ => by simp [Pi.smul_apply]; ring

lemma cnorm2_nonneg {k : ℕ} (w : Fin k → ℂ) : 0 ≤ cnorm2 w :=
  Finset.sum_nonneg fun _ _ => Complex.normSq_nonneg _

lemma cnorm2_eq_zero_iff {k : ℕ} (w : Fin k → ℂ) : cnorm2 w = 0 ↔ w = 0 := by
  unfold cnorm2
  rw [Finset.sum_eq_zero_iff_of_nonneg (fun i _ => Complex.normSq_nonneg _)]
  constructor
  · intro h; funext i
    have := h i (Finset.mem_univ i)
    simpa [Complex.normSq_eq_zero] using this
  · intro h i _; rw [h]; simp

/-- `cnorm2 w = ⟪w, w⟫` (as a complex number). -/
lemma cnorm2_eq_cinner {k : ℕ} (w : Fin k → ℂ) : (cnorm2 w : ℂ) = cinner w w := by
  unfold cnorm2 cinner
  push_cast
  exact Finset.sum_congr rfl fun i _ => by rw [Complex.normSq_eq_conj_mul_self]

/-- A unitary matrix preserves the Hermitian inner product. -/
lemma cinner_mulVec_of_unitary {k : ℕ} (M : Matrix (Fin k) (Fin k) ℂ)
    (hM : star M * M = 1) (x w : Fin k → ℂ) :
    cinner (M *ᵥ x) (M *ᵥ w) = cinner x w := by
  rw [cinner_dot, cinner_dot, Matrix.star_mulVec, ← Matrix.dotProduct_mulVec,
      Matrix.mulVec_mulVec]
  have : Mᴴ * M = 1 := hM
  rw [this, Matrix.one_mulVec]

/-- A unitary matrix preserves the Hermitian squared norm. -/
lemma cnorm2_mulVec_of_unitary {k : ℕ} (M : Matrix (Fin k) (Fin k) ℂ)
    (hM : star M * M = 1) (w : Fin k → ℂ) :
    cnorm2 (M *ᵥ w) = cnorm2 w := by
  have h : (cnorm2 (M *ᵥ w) : ℂ) = (cnorm2 w : ℂ) := by
    rw [cnorm2_eq_cinner, cnorm2_eq_cinner, cinner_mulVec_of_unitary M hM]
  exact_mod_cast h

variable {V E : Type*} [Fintype E]

/-- The finite **electroweak link-stiffness action**
`S_H(H, U) = ∑_e ‖U_e H_{t(e)} - H_{s(e)}‖²` for a matrix-valued connection
`U : E → Matrix (Fin 2) (Fin 2) ℂ` (e.g. `SU(2)_L × U(1)_Y`) and a Higgs doublet
field `H : V → ℂ²` on a finite directed graph with source/target `s t : E → V`. -/
noncomputable def linkStiffnessEW (s t : E → V) (H : V → (Fin 2 → ℂ))
    (U : E → Matrix (Fin 2) (Fin 2) ℂ) : ℝ :=
  ∑ e, cnorm2 ((U e) *ᵥ (H (t e)) - H (s e))

/--
**Gauge invariance.**  Under the local gauge transformation `H_v ↦ g_v H_v`,
`U_e ↦ g_{s(e)} U_e g_{t(e)}⁻¹` with unitary `g_v` (`star (g_v) * g_v = 1`), the
electroweak link-stiffness action is unchanged.  Exact, kernel-checked; no
symmetry is "broken".
-/
theorem linkStiffnessEW_gauge_invariant (s t : E → V) (H : V → (Fin 2 → ℂ))
    (U : E → Matrix (Fin 2) (Fin 2) ℂ) (g : V → Matrix (Fin 2) (Fin 2) ℂ)
    (hg : ∀ v, star (g v) * g v = 1) :
    linkStiffnessEW s t (fun v => (g v) *ᵥ (H v))
        (fun e => g (s e) * U e * star (g (t e)))
      = linkStiffnessEW s t H U := by
  unfold linkStiffnessEW
  refine Finset.sum_congr rfl fun e _ => ?_
  simp only []
  have hcollapse : star (g (t e)) *ᵥ (g (t e) *ᵥ H (t e)) = H (t e) := by
    rw [Matrix.mulVec_mulVec, hg (t e), Matrix.one_mulVec]
  have key : (g (s e) * U e * star (g (t e))) *ᵥ ((g (t e)) *ᵥ H (t e)) - (g (s e)) *ᵥ H (s e)
      = (g (s e)) *ᵥ ((U e) *ᵥ H (t e) - H (s e)) := by
    rw [Matrix.mulVec_sub]
    congr 1
    rw [← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec, hcollapse, Matrix.mulVec_mulVec]
  rw [key, cnorm2_mulVec_of_unitary _ (hg (s e))]

/-! ### Part B — orbit stiffness -/

/-- The per-edge quadratic cost of an edge holonomy `U` at the Higgs reference
section `H₀ = (0, v/√2)`: `cost(U) = ‖U H₀ - H₀‖²`. -/
noncomputable def holonomyCost (v : ℝ) (U : Matrix (Fin 2) (Fin 2) ℂ) : ℝ :=
  cnorm2 (U *ᵥ (H0 v) - H0 v)

/-- The cost is always nonnegative. -/
lemma holonomyCost_nonneg (v : ℝ) (U : Matrix (Fin 2) (Fin 2) ℂ) :
    0 ≤ holonomyCost v U := cnorm2_nonneg _

/--
**Orbit stiffness (stabilizer ⇒ zero cost).**  An edge holonomy has zero
quadratic cost iff it stabilises the Higgs reference section.
-/
theorem holonomyCost_eq_zero_iff_stabilizer (v : ℝ) (U : Matrix (Fin 2) (Fin 2) ℂ) :
    holonomyCost v U = 0 ↔ U *ᵥ (H0 v) = H0 v := by
  unfold holonomyCost
  rw [cnorm2_eq_zero_iff, sub_eq_zero]

/--
**Orbit stiffness (non-stabilizer ⇒ positive cost).**  A holonomy that moves
the Higgs reference section acquires strictly positive quadratic cost.
-/
theorem holonomyCost_pos_of_not_stabilizer (v : ℝ) (U : Matrix (Fin 2) (Fin 2) ℂ)
    (h : U *ᵥ (H0 v) ≠ H0 v) : 0 < holonomyCost v U := by
  refine lt_of_le_of_ne (holonomyCost_nonneg v U) (Ne.symm ?_)
  intro hz
  exact h ((holonomyCost_eq_zero_iff_stabilizer v U).mp hz)

/-- The infinitesimal (Lie-algebra) **orbit-stiffness mass form**
`q(X) = ‖ρ(X) H₀‖²` (Euclidean Hermitian norm). -/
noncomputable def massForm (v : ℝ) (x : Fin 4 → ℝ) : ℝ :=
  cnorm2 ((rho x) *ᵥ (H0 v))

/-- **Closed form of the mass form.**  `q(X) = (v²/8)(x₀² + x₁² + (x₂-x₃)²)`. -/
theorem massForm_eq (v : ℝ) (x : Fin 4 → ℝ) :
    massForm v x = (v ^ 2 / 8) * ((x 0) ^ 2 + (x 1) ^ 2 + (x 2 - x 3) ^ 2) := by
  have hsq : (Real.sqrt 2 : ℝ) ^ 2 = 2 := Real.sq_sqrt (by norm_num)
  have hs : (Real.sqrt 2 : ℝ) ≠ 0 := Real.sqrt_ne_zero'.mpr (by norm_num)
  rw [massForm, ← B_EW_eq_matrix, B_EW_apply]
  simp only [cnorm2, kappa, Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one,
    Complex.normSq_mul, Complex.normSq_div]
  rw [Complex.normSq_sub, Complex.normSq_mul]
  simp [Complex.normSq]
  field_simp
  ring

/--
**Structural orbit-stiffness kernel.**  The infinitesimal mass form vanishes
exactly on `span ℝ {Q}`, the electromagnetic `u(1)_em` direction: the photon is
the (unique) massless gauge direction.  No coupling-constant normalisation is
used.
-/
theorem massForm_kernel {v : ℝ} (hv : v ≠ 0) :
    {x : Fin 4 → ℝ | massForm v x = 0} = (Submodule.span ℝ {Qgen} : Set (Fin 4 → ℝ)) := by
  ext x
  rw [Set.mem_setOf_eq, massForm, cnorm2_eq_zero_iff, ← B_EW_eq_matrix, ← LinearMap.mem_ker,
    ew_stabilizer_kernel hv, SetLike.mem_coe]

/-! ### Part C — the FMS composite observable and the W/Z leading term -/

/-- Full Pauli matrix `τ¹`. -/
def tau1 : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]
/-- Full Pauli matrix `τ²`. -/
def tau2 : Matrix (Fin 2) (Fin 2) ℂ := !![0, -Complex.I; Complex.I, 0]
/-- Full Pauli matrix `τ³`. -/
def tau3 : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- The finite **FMS composite observable**
`O_e^a = H_{s(e)}^† τ^a U_e H_{t(e)}`. -/
noncomputable def fmsComposite (Hs Ht : Fin 2 → ℂ) (tau U : Matrix (Fin 2) (Fin 2) ℂ) : ℂ :=
  cinner Hs (tau *ᵥ (U *ᵥ Ht))

/--
**Gauge invariance of the singlet composite.**  With `τ = 1`, the composite
`O_e = H_s^† U_e H_t` is exactly invariant under the gauge action
`H_v ↦ g_v H_v`, `U_e ↦ g_s U_e g_t⁻¹` for unitary `g_v`.
-/
theorem fmsSinglet_gauge_invariant (Hs Ht : Fin 2 → ℂ)
    (U gs gt : Matrix (Fin 2) (Fin 2) ℂ)
    (hgs : star gs * gs = 1) (hgt : star gt * gt = 1) :
    fmsComposite (gs *ᵥ Hs) (gt *ᵥ Ht) 1 (gs * U * star gt)
      = fmsComposite Hs Ht 1 U := by
  unfold fmsComposite
  rw [Matrix.one_mulVec, Matrix.one_mulVec]
  have hcollapse : star gt *ᵥ (gt *ᵥ Ht) = Ht := by
    rw [Matrix.mulVec_mulVec, hgt, Matrix.one_mulVec]
  have key : (gs * U * star gt) *ᵥ (gt *ᵥ Ht) = gs *ᵥ (U *ᵥ Ht) := by
    rw [← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec, hcollapse, Matrix.mulVec_mulVec]
  rw [key, cinner_mulVec_of_unitary _ hgs]

/--
**FMS leading term, `W` channel.**  The `τ¹`-composite matrix element of the
linearised holonomy `U = 1 + iε ρ(X)` has value
`⟪H₀, τ¹ ρ(X) H₀⟫ = (v²/4)(x₀ - i x₁)`, exactly the `W^∓` field combination
`A¹ ∓ i A² = x₀ - i x₁` (up to the `v²/4` vacuum factor).
-/
theorem fms_leading_W (v : ℝ) (x : Fin 4 → ℝ) :
    cinner (H0 v) (tau1 *ᵥ ((rho x) *ᵥ (H0 v)))
      = (v ^ 2 / 4 : ℂ) * ((x 0 : ℂ) - Complex.I * (x 1 : ℂ)) := by
  have hsq : (Real.sqrt 2 : ℂ) ^ 2 = 2 := by
    rw [show ((Real.sqrt 2 : ℝ) : ℂ) ^ 2 = (((Real.sqrt 2) ^ 2 : ℝ) : ℂ) by push_cast; ring,
      Real.sq_sqrt (by norm_num : (2 : ℝ) ≥ 0)]; norm_num
  have hs : (Real.sqrt 2 : ℂ) ≠ 0 := by exact_mod_cast Real.sqrt_ne_zero'.mpr (by norm_num)
  rw [← B_EW_eq_matrix, B_EW_apply]
  simp [cinner, tau1, kappa, H0, Matrix.mulVec, dotProduct, Fin.sum_univ_two, mul_comm]
  field_simp
  rw [hsq]; ring

/--
**FMS leading term, `Z` channel.**  The `τ³`-composite matrix element is the
`Z` field combination `A³ - B = x₂ - x₃` (up to the `v²/4` vacuum factor).  The
orthogonal `x₂ + x₃` (photon) combination does not appear — consistent with
`massForm_kernel`.
-/
theorem fms_leading_Z (v : ℝ) (x : Fin 4 → ℝ) :
    cinner (H0 v) (tau3 *ᵥ ((rho x) *ᵥ (H0 v)))
      = (v ^ 2 / 4 : ℂ) * ((x 2 : ℂ) - (x 3 : ℂ)) := by
  have hsq : (Real.sqrt 2 : ℂ) ^ 2 = 2 := by
    rw [show ((Real.sqrt 2 : ℝ) : ℂ) ^ 2 = (((Real.sqrt 2) ^ 2 : ℝ) : ℂ) by push_cast; ring,
      Real.sq_sqrt (by norm_num : (2 : ℝ) ≥ 0)]; norm_num
  have hs : (Real.sqrt 2 : ℂ) ≠ 0 := by exact_mod_cast Real.sqrt_ne_zero'.mpr (by norm_num)
  rw [← B_EW_eq_matrix, B_EW_apply]
  simp [cinner, tau3, kappa, H0, Matrix.mulVec, dotProduct, Fin.sum_univ_two, mul_comm]
  field_simp
  rw [hsq]; ring

/--
**Assembled linear expansion (`W` channel).**  For the linearised holonomy
`U(ε) = 1 + (iε)·ρ(X)`, the FMS `τ¹`-composite expands as
`O¹(ε) = ⟪H₀, τ¹ H₀⟫ + iε (v²/4)(x₀ - i x₁)`, exhibiting the W field as the
leading fluctuation.
-/
theorem fms_linear_expansion_W (v ε : ℝ) (x : Fin 4 → ℝ) :
    fmsComposite (H0 v) (H0 v) tau1 (1 + (Complex.I * (ε : ℂ)) • (rho x))
      = cinner (H0 v) (tau1 *ᵥ (H0 v))
        + (Complex.I * (ε : ℂ)) * ((v ^ 2 / 4 : ℂ) * ((x 0 : ℂ) - Complex.I * (x 1 : ℂ))) := by
  unfold fmsComposite
  have hstep : (1 + (Complex.I * (ε : ℂ)) • rho x) *ᵥ H0 v
      = H0 v + (Complex.I * (ε : ℂ)) • ((rho x) *ᵥ H0 v) := by
    rw [Matrix.add_mulVec, Matrix.one_mulVec, smul_mulVec]
  rw [hstep, Matrix.mulVec_add, Matrix.mulVec_smul, cinner_add, cinner_smul, fms_leading_W]

/-! ### Part D — coefficient normalisation (kept separate from structure) -/

/--
**Coupling-rescaled mass form.**  Inserting the physical couplings
`x = (g A¹, g A², g A³, g' B)` gives
`q = (v²/8)(g²(A¹² + A²²) + (g A³ - g' B)²)`.  Purely algebraic; the coupling
dependence enters only here.
-/
theorem massForm_coupling_form (v g g' A1 A2 A3 B : ℝ) :
    massForm v ![g * A1, g * A2, g * A3, g' * B]
      = (v ^ 2 / 8) * (g ^ 2 * (A1 ^ 2 + A2 ^ 2) + (g * A3 - g' * B) ^ 2) := by
  rw [massForm_eq]
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    Matrix.cons_val_two, Matrix.cons_val_three, Matrix.tail_cons]
  ring

/-- The convention-dependent `W` mass `m_W = g v / 2`. -/
noncomputable def mW (v g : ℝ) : ℝ := g * v / 2
/-- The convention-dependent `Z` mass `m_Z = √(g² + g'²) v / 2`. -/
noncomputable def mZ (v g g' : ℝ) : ℝ := Real.sqrt (g ^ 2 + g' ^ 2) * v / 2

@[simp] lemma mW_sq (v g : ℝ) : (mW v g) ^ 2 = g ^ 2 * v ^ 2 / 4 := by
  unfold mW; ring

@[simp] lemma mZ_sq (v g g' : ℝ) : (mZ v g g') ^ 2 = (g ^ 2 + g' ^ 2) * v ^ 2 / 4 := by
  unfold mZ
  rw [div_pow, mul_pow, Real.sq_sqrt (by positivity)]; ring

/--
**Normalisation bridge (separate from structure).**  With couplings inserted and
the canonically normalised `Z` field `Z = (g A³ - g' B)/√(g²+g'²)`, the mass form
is the canonical electroweak mass term
`½ m_W² (A¹² + A²²) + ½ m_Z² Z²`, with `m_W = g v/2`, `m_Z = √(g²+g'²) v/2`.
The two `W` real components are mass-degenerate and the orthogonal photon
combination is massless (`massForm_kernel`).
-/
theorem massForm_physical_normalization (v g g' A1 A2 A3 B : ℝ)
    (h : 0 < g ^ 2 + g' ^ 2) :
    massForm v ![g * A1, g * A2, g * A3, g' * B]
      = (1 / 2) * (mW v g) ^ 2 * (A1 ^ 2 + A2 ^ 2)
        + (1 / 2) * (mZ v g g') ^ 2
            * ((g * A3 - g' * B) / Real.sqrt (g ^ 2 + g' ^ 2)) ^ 2 := by
  rw [massForm_coupling_form, mW_sq, mZ_sq, div_pow, Real.sq_sqrt h.le]
  have hne : g ^ 2 + g' ^ 2 ≠ 0 := ne_of_gt h
  field_simp
  ring

end Draft
end PhysicsSM
