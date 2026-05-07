import Mathlib
import PhysicsSM.Gauge.BlockEmbeddings

/-!
# Gauge.StandardModelSubgroup

Concrete subgroup API for the Standard Model gauge group
`S(U(2) × U(3))`, the block-diagonal subgroup of `U(5)` with determinant one.

## Mathematical context

The Standard Model gauge group is
  `G_SM ≅ S(U(2) × U(3)) ⊂ U(5)`

consisting of block-diagonal pairs `(g, h)` with `g ∈ U(2)`, `h ∈ U(3)`,
and `det(g) · det(h) = 1`.

This module provides:
1. A carrier predicate `InSU2U3` for the determinant-one condition on
   `U(2) × U(3)` block pairs.
2. Proofs that the identity, multiplication, and inverse preserve this
   predicate — establishing the subgroup structure.
3. An explicit map from `U(1) × SU(2) × SU(3)` into the block subgroup
   via the covering homomorphism.
4. Kernel-membership facts showing that the six phases from
   `BlockEmbeddings.kernelPhases` map to the identity pair.

The quotient isomorphism `(U(1) × SU(2) × SU(3)) / ℤ₆ ≅ S(U(2) × U(3))`
is NOT claimed here — it requires quotient group infrastructure beyond
the current scope.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021,
slides 17–21.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.BlockEmbeddings

/-! ## S(U(2) × U(3)) carrier predicate -/

/--
A pair `(g, h)` of matrices belongs to the Standard Model block subgroup
`S(U(2) × U(3))` when `det(g) * det(h) = 1`.

This is the determinant-one condition for block-diagonal matrices in `U(5)`.
Unitarity conditions on `g` and `h` individually are tracked separately
when needed; here we focus on the algebraic subgroup structure given by
the determinant constraint.
-/
def InSU2U3 (g : Matrix (Fin 2) (Fin 2) ℂ) (h : Matrix (Fin 3) (Fin 3) ℂ) : Prop :=
  g.det * h.det = 1

/-! ## Subgroup closure properties -/

/--
The identity pair `(I₂, I₃)` satisfies the `S(U(2) × U(3))` condition.
-/
theorem inSU2U3_one :
    InSU2U3 (1 : Matrix (Fin 2) (Fin 2) ℂ) (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
  unfold InSU2U3
  simp [det_one]

/--
The `S(U(2) × U(3))` condition is closed under multiplication:
if `(g₁, h₁)` and `(g₂, h₂)` satisfy the condition, so does
`(g₁ * g₂, h₁ * h₂)`.
-/
theorem inSU2U3_mul
    {g₁ g₂ : Matrix (Fin 2) (Fin 2) ℂ} {h₁ h₂ : Matrix (Fin 3) (Fin 3) ℂ}
    (p₁ : InSU2U3 g₁ h₁) (p₂ : InSU2U3 g₂ h₂) :
    InSU2U3 (g₁ * g₂) (h₁ * h₂) := by
  unfold InSU2U3 at *
  rw [det_mul, det_mul]
  calc g₁.det * g₂.det * (h₁.det * h₂.det)
      = (g₁.det * h₁.det) * (g₂.det * h₂.det) := by ring
    _ = 1 * 1 := by rw [p₁, p₂]
    _ = 1 := by ring

/--
The `S(U(2) × U(3))` condition is closed under inversion:
if `(g, h)` satisfies the condition, so does `(g⁻¹, h⁻¹)`.

Note: invertibility of the determinants follows from `det(g) * det(h) = 1`.
-/
theorem inSU2U3_inv
    {g : Matrix (Fin 2) (Fin 2) ℂ} {h : Matrix (Fin 3) (Fin 3) ℂ}
    (p : InSU2U3 g h) :
    InSU2U3 g⁻¹ h⁻¹ := by
  unfold InSU2U3 at *
  simp_all +decide only [det_nonsing_inv, Ring.inverse_eq_inv']
  rw [← mul_inv, p, inv_one]

/-! ## Covering map from U(1) × SU(2) × SU(3)

The covering homomorphism sends `(α, g, h)` to `(α³ • g, α⁻² • h)` in the
`U(2) × U(3)` picture. The determinant condition holds:

  `det(α³ • g) · det(α⁻² • h) = α⁶ · det(g) · α⁻⁶ · det(h) = 1`

when `det(g) = 1` and `det(h) = 1`.
-/

/--
The covering map `ι : U(1) × SU(2) × SU(3) → U(2) × U(3)` defined by
  `ι(α, g, h) = (α³ • g, α⁻² • h)`

The `α³` and `α⁻²` exponents ensure `det(α³ g) · det(α⁻² h) = 1`
whenever `det(g) = 1` and `det(h) = 1`.
-/
noncomputable def coveringMap (α : ℂ)
    (g : Matrix (Fin 2) (Fin 2) ℂ) (h : Matrix (Fin 3) (Fin 3) ℂ) :
    Matrix (Fin 2) (Fin 2) ℂ × Matrix (Fin 3) (Fin 3) ℂ :=
  ((α ^ 3) • g, (α⁻¹ ^ 2) • h)

/--
The determinant of the U(2) component:
  `det(α³ • g) = α⁶ · det(g)`
-/
theorem det_coveringMap_fst (α : ℂ) (g : Matrix (Fin 2) (Fin 2) ℂ)
    (h : Matrix (Fin 3) (Fin 3) ℂ) :
    (coveringMap α g h).1.det = (α ^ 3) ^ 2 * g.det := by
  simp [coveringMap, Fintype.card_fin]

/--
The determinant of the U(3) component:
  `det(α⁻² • h) = α⁻⁶ · det(h)`
-/
theorem det_coveringMap_snd (α : ℂ) (g : Matrix (Fin 2) (Fin 2) ℂ)
    (h : Matrix (Fin 3) (Fin 3) ℂ) :
    (coveringMap α g h).2.det = (α⁻¹ ^ 2) ^ 3 * h.det := by
  simp [coveringMap, Fintype.card_fin]

/-
**Key theorem**: the covering map lands in `S(U(2) × U(3))` when the
inputs satisfy `α ≠ 0`, `det(g) = 1` (g ∈ SU(2)), and `det(h) = 1` (h ∈ SU(3)).
-/
theorem coveringMap_inSU2U3 (α : ℂ) (hα : α ≠ 0)
    (g : Matrix (Fin 2) (Fin 2) ℂ) (h : Matrix (Fin 3) (Fin 3) ℂ)
    (hg : g.det = 1) (hh : h.det = 1) :
    InSU2U3 (coveringMap α g h).1 (coveringMap α g h).2 := by
  unfold InSU2U3
  rw [det_coveringMap_fst, det_coveringMap_snd, hg, hh]
  simp [inv_pow]
  field_simp

/-! ## Kernel membership

An element `(α, g, h)` is in the kernel of the covering map when the
image `(α³ • g, α⁻² • h) = (I₂, I₃)`.

This forces `g = α⁻³ • I₂` and `h = α² • I₃`. For `g` to be in SU(2),
we need `det(α⁻³ I₂) = α⁻⁶ = 1`, i.e., `α⁶ = 1`.

The six kernel elements correspond to `α = kernelPhases k` for `k : Fin 6`.
-/

/--
A kernel element for the covering map: a triple `(α, α⁻³ · I₂, α² · I₃)`
where `α⁶ = 1`.
-/
structure CoveringKernelElt where
  /-- The U(1) phase -/
  phase : ℂ
  /-- The phase is a sixth root of unity -/
  phase_pow_six : phase ^ 6 = 1

/--
The SU(2) component of a kernel element: `α⁻³ • I₂`.
-/
noncomputable def CoveringKernelElt.su2Part (k : CoveringKernelElt) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  (k.phase⁻¹ ^ 3) • (1 : Matrix (Fin 2) (Fin 2) ℂ)

/--
The SU(3) component of a kernel element: `α² • I₃`.
-/
noncomputable def CoveringKernelElt.su3Part (k : CoveringKernelElt) :
    Matrix (Fin 3) (Fin 3) ℂ :=
  (k.phase ^ 2) • (1 : Matrix (Fin 3) (Fin 3) ℂ)

/-
The covering map sends a kernel element to the identity pair `(I₂, I₃)`.

Proof: `α³ • (α⁻³ • I₂) = (α³ · α⁻³) • I₂ = I₂` and
       `α⁻² • (α² • I₃) = (α⁻² · α²) • I₃ = I₃`.
-/
theorem coveringKernel_maps_to_one (k : CoveringKernelElt) (hk : k.phase ≠ 0) :
    coveringMap k.phase k.su2Part k.su3Part = (1, 1) := by
  ext i j;
  · fin_cases i <;> fin_cases j <;> simp +decide [ hk, coveringMap, CoveringKernelElt.su2Part ];
  · fin_cases i <;> fin_cases j <;>
      simp +decide [hk, coveringMap, CoveringKernelElt.su2Part,
        CoveringKernelElt.su3Part]

/--
Each of the six phases from `kernelPhases` gives a kernel element.
-/
noncomputable def sixCoveringKernelElts : Fin 6 → CoveringKernelElt :=
  fun k => ⟨kernelPhases k, kernelPhases_pow_six k⟩

/--
The six kernel elements are distinct (inheriting from `kernelPhases_injective`).
-/
theorem sixCoveringKernelElts_injective :
    Function.Injective sixCoveringKernelElts := by
  intro i j h
  exact kernelPhases_injective (congr_arg CoveringKernelElt.phase h)

/-
The SU(2) component of a kernel element has determinant 1.
This shows the kernel element genuinely lies in SU(2).
-/
theorem coveringKernelElt_su2_det (k : CoveringKernelElt) :
    k.su2Part.det = 1 := by
  unfold CoveringKernelElt.su2Part;
  norm_num [ Matrix.det_smul ];
  exact eq_or_eq_neg_of_sq_eq_sq _ _ <| by linear_combination' k.phase_pow_six;

/-
The SU(3) component of a kernel element has determinant 1.
This shows the kernel element genuinely lies in SU(3).
-/
theorem coveringKernelElt_su3_det (k : CoveringKernelElt) :
    k.su3Part.det = 1 := by
  convert det_smul_three ( k.phase ^ 2 ) 1 using 1;
  norm_num [ ← pow_mul, k.phase_pow_six ]

/--
The pair `(su2Part, su3Part)` of a kernel element satisfies the
`S(U(2) × U(3))` condition (trivially, since it maps to `(I₂, I₃)`).
-/
theorem coveringKernelElt_inSU2U3 (k : CoveringKernelElt) :
    InSU2U3 k.su2Part k.su3Part := by
  unfold InSU2U3
  rw [coveringKernelElt_su2_det, coveringKernelElt_su3_det]
  simp

/-! ## Convention note

### Hypercharge convention: `Q = T₃ + Y/2`

The covering map exponents (`α³` on U(2), `α⁻²` on U(3)) are determined
by the hypercharge normalization `Q = T₃ + Y/2`. Under a different
convention (e.g., `Q = T₃ + Y`), the exponents would change but the
quotient group `S(U(2) × U(3))` remains the same.

The ℤ₆ kernel is convention-independent: it depends only on the centers
of SU(2) (which is ℤ₂) and SU(3) (which is ℤ₃), and their lcm is 6.
-/

end PhysicsSM.Gauge.StandardModelSubgroup
