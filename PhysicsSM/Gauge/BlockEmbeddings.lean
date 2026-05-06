import Mathlib

/-!
# Gauge.BlockEmbeddings

Concrete block-matrix maps for the Standard Model gauge group embedding
scaffold.

## Mathematical context

The Standard Model gauge group is the quotient
  `G_SM = (U(1) × SU(2) × SU(3)) / ℤ₆ ≅ S(U(2) × U(3))`

The covering homomorphism `U(1) × SU(2) × SU(3) → SU(2) × SU(4)` is:
  `(α, g, h) ↦ (g, block_diag(α · h, α⁻³))`

where `block_diag(α · h, α⁻³)` is the 4×4 block-diagonal matrix with
upper-left 3×3 block `α · h` and lower-right 1×1 block `α⁻³`.

The determinant of this 4×4 block is:
  `det(α · h) · α⁻³ = α³ · det(h) · α⁻³ = 1`  (when `det(h) = 1`)

The kernel of this map consists of elements `(α, α · I₂, α⁻³ · I₃)` where
`α⁶ = 1`, giving the six elements:
  `α ∈ {1, ω, ω², -1, -ω, -ω²}`  where `ω = exp(2πi/6)`

This six-element kernel is the expected finite kernel that must be quotiented
out to obtain the usual Standard Model gauge group presentation.

Claim boundary: the trusted Lean in this file proves explicit matrix
determinant and phase facts. It does not prove the first isomorphism theorem
for the quotient, the topology of the compact groups, or any Spin(9)
stabilizer identification.

### Convention compatibility

The hypercharge convention is `Q = T₃ + Y/2` throughout, matching the project's
`AnomalyPackage.lean` and the Baez 2021 slides.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021,
slides 17–21.

Status: trusted block determinant arithmetic and kernel elements;
quotient isomorphism stated as draft theorem.
-/

namespace PhysicsSM.Gauge.BlockEmbeddings

open Complex Matrix

/-! ## Block determinant lemmas -/

/--
The SU(4) block `block_diag(α · h, α⁻³)` is a 4×4 matrix built from a
3×3 block `α · h` and a 1×1 block `α⁻³`.

This is the explicit `fromBlocks` construction.
-/
noncomputable def su4Block (α : ℂ) (h : Matrix (Fin 3) (Fin 3) ℂ) :
    Matrix (Fin 3 ⊕ Fin 1) (Fin 3 ⊕ Fin 1) ℂ :=
  Matrix.fromBlocks (α • h) 0 0 (Matrix.diagonal fun _ => α⁻¹ ^ 3)

/--
The determinant of a scalar multiple `α • h` of a 3×3 matrix is `α³ · det(h)`.
-/
theorem det_smul_three (α : ℂ) (h : Matrix (Fin 3) (Fin 3) ℂ) :
    (α • h).det = α ^ 3 * h.det := by
  rw [Matrix.det_smul]
  simp [Fintype.card_fin]

/--
The determinant of the 1×1 diagonal block `diag(α⁻³)` is `α⁻³`.
-/
theorem det_inv_block (α : ℂ) :
    (Matrix.diagonal (fun (_ : Fin 1) => α⁻¹ ^ 3)).det = α⁻¹ ^ 3 := by
  simp

/--
**Key determinant lemma**: the SU(4) block `block_diag(α · h, α⁻³)` has
determinant `α³ · det(h) · α⁻³`.

When `det(h) = 1` (i.e., `h ∈ SU(3)`), this equals `1`.
-/
theorem det_su4Block (α : ℂ) (h : Matrix (Fin 3) (Fin 3) ℂ) :
    (su4Block α h).det = α ^ 3 * h.det * (α⁻¹ ^ 3) := by
  unfold su4Block
  rw [Matrix.det_fromBlocks_zero₁₂, det_smul_three, det_inv_block]

/--
When `h ∈ SU(3)` (so `det(h) = 1`) and `α ≠ 0`, the SU(4) block has
determinant 1.

This is the core calculation showing the block embedding lands in SU(4).
-/
theorem det_su4Block_eq_one (α : ℂ) (hα : α ≠ 0)
    (h : Matrix (Fin 3) (Fin 3) ℂ) (hdet : h.det = 1) :
    (su4Block α h).det = 1 := by
  rw [det_su4Block, hdet, mul_one, inv_pow, mul_inv_cancel₀ (pow_ne_zero 3 hα)]

/-! ## The six kernel elements

The kernel of the covering map `U(1) × SU(2) × SU(3) → S(U(2) × U(3))`
consists of elements `(α, α · I₂, α⁻³ · I₃)` where `α⁶ = 1`.

An element `(α, α · I₂, α⁻³ · I₃)` acts trivially on all Standard Model
representations precisely when `α` is a sixth root of unity.

We enumerate the six phases as concrete complex numbers using `exp(2πik/6)`.
-/

/-- The primitive sixth root of unity `ω = exp(2πi/6)`. -/
noncomputable def omega : ℂ := Complex.exp (2 * Real.pi * I / 6)

/-
`ω` satisfies `ω⁶ = 1`.
-/
theorem omega_pow_six : omega ^ 6 = 1 := by
  unfold omega;
  rw [ ← Complex.exp_nat_mul, mul_comm, Complex.exp_eq_one_iff ] ; use 1 ; ring

/-
`ω³ = -1`.
-/
theorem omega_pow_three : omega ^ 3 = -1 := by
  -- By definition of omega, we have omega^3 = exp(2πi / 2) = exp(πi) = -1.
  simp [omega];
  rw [ ← Complex.exp_nat_mul, mul_comm, Complex.exp_eq_exp_re_mul_sin_add_cos ] ; norm_num;
  ring_nf; norm_num [ mul_div ] ;

/-
`ω` is nonzero.
-/
theorem omega_ne_zero : omega ≠ 0 := by
  exact Complex.exp_ne_zero _

/-
`ω` is a primitive sixth root of unity.
-/
theorem omega_isPrimitiveRoot : IsPrimitiveRoot omega 6 := by
  exact Complex.isPrimitiveRoot_exp _ ( by norm_num )

/-- The six kernel phases, listed explicitly. -/
noncomputable def kernelPhases : Fin 6 → ℂ
  | ⟨0, _⟩ => 1
  | ⟨1, _⟩ => omega
  | ⟨2, _⟩ => omega ^ 2
  | ⟨3, _⟩ => omega ^ 3    -- = -1
  | ⟨4, _⟩ => omega ^ 4    -- = -ω²
  | ⟨5, _⟩ => omega ^ 5

/-
= -ω

Each kernel phase is a sixth root of unity.
-/
theorem kernelPhases_pow_six (k : Fin 6) :
    (kernelPhases k) ^ 6 = 1 := by
  fin_cases k <;> simp +decide [ kernelPhases ];
  · exact?;
  · linear_combination' omega_pow_six * omega_pow_six;
  · rw [ omega_pow_three ] ; norm_num;
  · rw [ ← pow_mul, mul_comm, pow_mul, omega_pow_six, one_pow ];
  · linear_combination' omega_pow_six * omega_pow_six * omega_pow_six * omega_pow_six * omega_pow_six

/-
Each kernel phase is nonzero.
-/
theorem kernelPhases_ne_zero (k : Fin 6) :
    kernelPhases k ≠ 0 := by
  fin_cases k <;> simp +decide [ kernelPhases, omega_ne_zero ]

/-
The kernel phases are distinct.
-/
theorem kernelPhases_injective : Function.Injective kernelPhases := by
  intro i j h_eq
  have h_exp : omega ^ (i : ℕ) = omega ^ (j : ℕ) := by
    fin_cases i <;> fin_cases j <;> simp +decide [ kernelPhases ] at h_eq ⊢;
    all_goals assumption;
  have := omega_isPrimitiveRoot;
  exact Fin.ext ( Nat.mod_eq_of_lt i.2 ▸ Nat.mod_eq_of_lt j.2 ▸ by have := this.pow_inj ( show i.val < 6 from i.2 ) ( show j.val < 6 from j.2 ) ; aesop )

/-! ## The kernel triple

A kernel element of the covering map `U(1) × SU(2) × SU(3) → G_SM` is a
triple `(α, α · I₂, α⁻³ · I₃)` where `α⁶ = 1`.
-/

/--
A kernel element: the triple `(α, α · I₂, α⁻³ · I₃)` for a phase `α`
with `α⁶ = 1`.

The first component is the U(1) phase.
The second is the SU(2) scalar matrix `α · I₂`.
The third is the SU(3) scalar matrix `α⁻³ · I₃`.
-/
structure KernelElement where
  phase : ℂ
  phase_pow_six : phase ^ 6 = 1

/-- The SU(2) component of a kernel element: `α · I₂`. -/
noncomputable def KernelElement.su2Component (k : KernelElement) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  k.phase • (1 : Matrix (Fin 2) (Fin 2) ℂ)

/-- The SU(3) component of a kernel element: `α⁻³ · I₃`. -/
noncomputable def KernelElement.su3Component (k : KernelElement) :
    Matrix (Fin 3) (Fin 3) ℂ :=
  (k.phase⁻¹ ^ 3) • (1 : Matrix (Fin 3) (Fin 3) ℂ)

/-- The determinant of the SU(2) component is `α²`. -/
theorem KernelElement.det_su2 (k : KernelElement) :
    k.su2Component.det = k.phase ^ 2 := by
  simp [KernelElement.su2Component, Fintype.card_fin]

/-- The determinant of the SU(3) component is `(α⁻¹)⁹`. -/
theorem KernelElement.det_su3 (k : KernelElement) :
    k.su3Component.det = (k.phase⁻¹ ^ 3) ^ 3 := by
  simp [KernelElement.su3Component, Fintype.card_fin]

/-- The six kernel elements. -/
noncomputable def sixKernelElements : Fin 6 → KernelElement :=
  fun k => ⟨kernelPhases k, kernelPhases_pow_six k⟩

/-! ## Block embedding as the covering map -/

/--
The covering homomorphism `U(1) × SU(2) × SU(3) → SU(2) × SU(4)`:
  `(α, g, h) ↦ (g, block_diag(α · h, α⁻³))`

The SU(2) factor passes through unchanged; the SU(4) factor is the
block-diagonal matrix with upper-left block `α · h` and lower-right
entry `α⁻³`.
-/
noncomputable def slideMap (α : ℂ) (g : Matrix (Fin 2) (Fin 2) ℂ)
    (h : Matrix (Fin 3) (Fin 3) ℂ) :
    Matrix (Fin 2) (Fin 2) ℂ × Matrix (Fin 3 ⊕ Fin 1) (Fin 3 ⊕ Fin 1) ℂ :=
  (g, su4Block α h)

/--
The SU(4) component of the slide map has determinant 1 when `det(h) = 1`
and `α ≠ 0`.
-/
theorem slideMap_su4_det_one (α : ℂ) (hα : α ≠ 0)
    (g : Matrix (Fin 2) (Fin 2) ℂ)
    (h : Matrix (Fin 3) (Fin 3) ℂ) (hdet : h.det = 1) :
    (slideMap α g h).2.det = 1 :=
  det_su4Block_eq_one α hα h hdet

/-! ## ℤ₆ kernel statement -/

/--
A triple `(α, g, h)` is a kernel triple when `g = α · I₂`, `h = α⁻³ · I₃`,
and `α⁶ = 1`.
-/
def IsKernelTriple (α : ℂ) (g : Matrix (Fin 2) (Fin 2) ℂ)
    (h : Matrix (Fin 3) (Fin 3) ℂ) : Prop :=
  g = α • 1 ∧ h = (α⁻¹ ^ 3) • 1 ∧ α ^ 6 = 1

/-
**Trusted**: The number of sixth roots of unity is 6.
-/
theorem z6_kernel_card : Fintype.card (rootsOfUnity 6 ℂ) = 6 := by
  rw [ Fintype.card_eq_nat_card ];
  rw [ Nat.card_congr ( show rootsOfUnity 6 ℂ ≃ { x : ℂ | x ^ 6 = 1 } from ?_ ) ];
  · rw [ show { x : ℂ | x ^ 6 = 1 } = ( Finset.image ( fun k : Fin 6 => Complex.exp ( 2 * Real.pi * Complex.I * k / 6 ) ) Finset.univ ) from ?_ ];
    · rw [ Nat.card_eq_fintype_card ] ; norm_num;
      rw [ Finset.card_image_of_injective ] <;> norm_num [ Function.Injective ];
      intros a₁ a₂ h; rw [ Complex.exp_eq_exp_iff_exists_int ] at h; obtain ⟨ k, hk ⟩ := h; replace hk := congr_arg Complex.im hk; norm_num [ Complex.exp_im ] at hk;
      exact PLift.down_injective ( Fin.ext <| by rw [ ← @Nat.cast_inj ℝ ] ; nlinarith [ Real.pi_pos, show ( k : ℝ ) = 0 by rcases k with ⟨ _ | _ | k ⟩ <;> norm_num at * <;> nlinarith [ Real.pi_pos, show ( a₁.down : ℝ ) < 6 by exact_mod_cast Fin.is_lt a₁.down, show ( a₂.down : ℝ ) < 6 by exact_mod_cast Fin.is_lt a₂.down ] ] );
    · ext x;
      constructor;
      · intro hx
        obtain ⟨k, hk⟩ : ∃ k : ℤ, x = Complex.exp (2 * Real.pi * Complex.I * k / 6) := by
          -- Since $x^6 = 1$, we can write $x$ as $e^{i\theta}$ for some $\theta$.
          obtain ⟨θ, hθ⟩ : ∃ θ : ℝ, x = Complex.exp (θ * Complex.I) := by
            have h_abs : ‖x‖ = 1 := by
              simpa [ pow_eq_one_iff_of_nonneg ] using congr_arg Norm.norm hx;
            rw [ Complex.norm_eq_one_iff ] at h_abs ; tauto;
          simp_all +decide [ ← Complex.exp_nat_mul ];
          rw [ Complex.exp_eq_one_iff ] at hx; obtain ⟨ k, hk ⟩ := hx; exact ⟨ k, congr_arg Complex.exp <| by linear_combination hk / 6 ⟩ ;
        -- Since $k$ is an integer, we can write it as $k = 6m + r$ for some integer $m$ and $r \in \{0, 1, 2, 3, 4, 5\}$.
        obtain ⟨m, r, hr⟩ : ∃ m : ℤ, ∃ r : Fin 6, k = 6 * m + r := by
          exact ⟨ k / 6, ⟨ Int.toNat ( k % 6 ), by linarith [ Int.emod_nonneg k ( by decide : ( 6 : ℤ ) ≠ 0 ), Int.emod_lt_of_pos k ( by decide : ( 6 : ℤ ) > 0 ), Int.toNat_of_nonneg ( Int.emod_nonneg k ( by decide : ( 6 : ℤ ) ≠ 0 ) ) ] ⟩, by linarith [ Int.emod_add_mul_ediv k 6, Int.toNat_of_nonneg ( Int.emod_nonneg k ( by decide : ( 6 : ℤ ) ≠ 0 ) ) ] ⟩;
        simp_all +decide [ Complex.exp_eq_exp_iff_exists_int ];
        exact ⟨ r, -m, by push_cast; ring ⟩;
      · simp +zetaDelta at *;
        rintro i rfl; rw [ ← Complex.exp_nat_mul, mul_comm, Complex.exp_eq_one_iff ] ; use i; push_cast; ring;
  · refine' Equiv.ofBijective _ ⟨ fun x y h => _, fun x => _ ⟩;
    refine' fun x => ⟨ x.val, _ ⟩;
    exact congr_arg ( fun x : ℂˣ => ( x : ℂ ) ) x.2;
    · aesop;
    · refine' ⟨ ⟨ Units.mk0 x.val _, _ ⟩, _ ⟩ <;> aesop

/--
**Draft theorem**: The Standard Model gauge group is the quotient
`(U(1) × SU(2) × SU(3)) / ℤ₆`.

This is the precise mathematical statement. Its full formalization requires:
- A concrete definition of the quotient group action
- Proof that the kernel is exactly the six elements above
- The first isomorphism theorem to conclude the quotient is `S(U(2) × U(3))`

For now, we state it as a well-typed Prop so that downstream modules can
reference it as a hypothesis.
-/
def SM_is_quotient_by_Z6 : Prop :=
  ∃ (φ : ℂ × Matrix (Fin 2) (Fin 2) ℂ × Matrix (Fin 3) (Fin 3) ℂ →
       Matrix (Fin 2) (Fin 2) ℂ × Matrix (Fin 3 ⊕ Fin 1) (Fin 3 ⊕ Fin 1) ℂ),
    (∀ α g h, φ (α, g, h) = slideMap α g h) ∧
    (∀ α g h, α ≠ 0 → h.det = 1 → (φ (α, g, h)).2.det = 1)

/-- The slide map witnesses the `SM_is_quotient_by_Z6` statement. -/
theorem sm_quotient_witness : SM_is_quotient_by_Z6 :=
  ⟨fun ⟨α, g, h⟩ => slideMap α g h,
   fun _ _ _ => rfl,
   fun α _ h hα hdet => slideMap_su4_det_one α hα _ h hdet⟩

/-! ## Convention compatibility

### Hypercharge convention: `Q = T₃ + Y/2`

The ℤ₆ kernel depends on the hypercharge normalization. Under the project
convention `Q = T₃ + Y/2` (matching Weinberg 1967, Peskin-Schroeder, and
`PhysicsSM.StandardModel.AnomalyPackage`), the hypercharge assignments are:

| Multiplet | SU(3)_c | SU(2)_L | Y    |
|-----------|---------|---------|------|
| Q_L       | 3       | 2       | 1/3  |
| L_L       | 1       | 2       | -1   |
| u_R       | 3       | 1       | 4/3  |
| d_R       | 3       | 1       | -2/3 |
| e_R       | 1       | 1       | -2   |

The U(1) phase `α` acts on a field with hypercharge `Y` as multiplication
by `α^(3Y)`. The exponent `3Y` is always an integer for the SM multiplets:
`Q_L: 1`, `L_L: -3`, `u_R: 4`, `d_R: -2`, `e_R: -6`.

The ℤ₆ arises because `lcm(2, 3) = 6`: the SU(2) center is ℤ₂ and the
SU(3) center is ℤ₃, and their overlap in U(1) gives ℤ₆.

For the covering map `(α, g, h) ↦ (g, block_diag(α·h, α⁻³))`:
- The SU(2) factor `g` is unchanged.
- The SU(3) factor `h` is scaled by `α`.
- The U(1) phase `α⁻³` fills the remaining 1×1 slot.
- `det(α·h) · α⁻³ = α³ · 1 · α⁻³ = 1` ✓
-/

end PhysicsSM.Gauge.BlockEmbeddings
