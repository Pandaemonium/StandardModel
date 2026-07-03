import Mathlib

/-!
# Krein double self-adjointness and stability counterexamples

This file is the Aristotle deliverable for the null-edge Krein / Lorentzian
adjointness audit (PROMPT.md; `AgentTasks/null-edge-krein-stability-audit.md`;
`docs/CONVENTIONS.md`, section "Krein / Lorentzian adjointness"; C5+C7 pairing in
`AgentTasks/null-edge-job-dependency-dag.md`).

## Conventions

Work over a finite-dimensional complex inner-product space `Cⁿ` with the
conjugate-transpose `Aᴴ`.  A *fundamental symmetry* `J` satisfies

```text
J = Jᴴ = J⁻¹        (Hermitian and involutive, equivalently J * J = 1)
```

The **Krein (sharp) adjoint** of `A` is `A♯ := J Aᴴ J`.  An operator is
*Krein (J-)self-adjoint* iff `A♯ = A`.

The **retarded/advanced double** of a retarded symbol `D₊` is

```text
D₋    := D₊♯ = J D₊ᴴ J
D_dbl := [[0, D₋], [D₊, 0]]
J_dbl := [[J, 0], [0, J]]
```

## Results

* `Ddbl_kreinSelfAdjoint`: with `J = Jᴴ = J⁻¹` and `D₋ = D₊♯`, the doubled
  operator `D_dbl` is `J_dbl`-self-adjoint (Layer A, the algebraic hygiene
  identity).  Holds for **every** `D₊`.
* Companion algebra: `Jdbl_isFundamental`, `sharp_sharp`, `sharp_mul`.

## Counterexamples (Layer B is NOT implied by Layer A)

Using `J = diag(1, -1)` of signature `(1,1)` we exhibit, by concrete `2 × 2`
matrices, that Krein `J`-self-adjointness implies **none** of the physical
stability conclusions:

* `jselfadj_not_real_spectrum`: a `J`-self-adjoint matrix with a nonreal
  eigenvalue.
* `jselfadj_not_stable`: a `J`-self-adjoint matrix with an eigenvalue of
  positive real part (a growing / unstable mode under `exp(t A)`).
* `doubling_not_positive`: a perfectly Hermitian retarded block `D₊` whose
  Krein double has `D₋ D₊ = -I` (energy not positive definite) and
  `D_dbl² = -I` (purely imaginary spectrum), even though `D_dbl` is
  `J_dbl`-self-adjoint.

## Guardrails

This is Lorentzian-adjointness hygiene, **not** a stability theorem.  Krein
`J`-self-adjointness does not imply real spectrum, positivity, unitarity, or
physical stability, and Krein doubling is **not** claimed to solve chirality or
no-doubling.  Cf. Chernodub `arXiv:1701.07426` as a standing hazard warning.
-/

namespace PhysicsSM
namespace Draft

open Matrix

section General

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Krein adjoint ("sharp") for a fundamental symmetry `J`: `A♯ := J Aᴴ J`. -/
noncomputable def sharp (J A : Matrix n n ℂ) : Matrix n n ℂ := J * Aᴴ * J

/-- Doubled operator `D_dbl = [[0, D₋], [D₊, 0]]`. -/
def Ddbl (Dp Dm : Matrix n n ℂ) : Matrix (n ⊕ n) (n ⊕ n) ℂ :=
  Matrix.fromBlocks 0 Dm Dp 0

/-- Doubled fundamental symmetry `J_dbl = diag(J, J)`. -/
def Jdbl (J : Matrix n n ℂ) : Matrix (n ⊕ n) (n ⊕ n) ℂ :=
  Matrix.fromBlocks J 0 0 J

/-- The doubled symmetry is again a fundamental symmetry: Hermitian and
involutive whenever `J` is. -/
theorem Jdbl_isFundamental (J : Matrix n n ℂ) (hHerm : Jᴴ = J) (hInv : J * J = 1) :
    (Jdbl J)ᴴ = Jdbl J ∧ (Jdbl J) * (Jdbl J) = 1 := by
  refine ⟨?_, ?_⟩
  · simp [Jdbl, Matrix.fromBlocks_conjTranspose, hHerm]
  · simp [Jdbl, Matrix.fromBlocks_multiply, hInv]

/-- Sharp is involutive: `(A♯)♯ = A` when `J` is Hermitian and involutive. -/
theorem sharp_sharp (J A : Matrix n n ℂ) (hHerm : Jᴴ = J) (hInv : J * J = 1) :
    sharp J (sharp J A) = A := by
  unfold sharp;
  simp +decide [ ← mul_assoc, hHerm, hInv ];
  rw [ mul_assoc, hInv, mul_one ]

/-- Sharp is antimultiplicative: `(A B)♯ = B♯ A♯`. -/
theorem sharp_mul (J A B : Matrix n n ℂ) (hInv : J * J = 1) :
    sharp J (A * B) = sharp J B * sharp J A := by
  simp [sharp, Matrix.mul_assoc, Matrix.conjTranspose_mul];
  simp +decide [ ← mul_assoc, hInv ]

/-- **Finite Krein double (Layer A, hygiene).**  With `J = Jᴴ = J⁻¹` and
`D₋ = D₊♯`, the doubled operator `D_dbl` is `J_dbl`-self-adjoint:
`J_dbl D_dblᴴ J_dbl = D_dbl`.  Holds for every `D₊`. -/
theorem Ddbl_kreinSelfAdjoint
    (J Dp : Matrix n n ℂ) (hHerm : Jᴴ = J) (hInv : J * J = 1) :
    sharp (Jdbl J) (Ddbl Dp (sharp J Dp)) = Ddbl Dp (sharp J Dp) := by
  unfold Ddbl Jdbl;
  simp +decide [ Matrix.mul_assoc, sharp ];
  simp_all +decide [ ← Matrix.mul_assoc, Matrix.fromBlocks_conjTranspose ];
  simp +decide [ Matrix.fromBlocks_multiply, hInv, mul_assoc ];
  rw [ ← Matrix.mul_assoc, hInv, Matrix.one_mul ]

end General

section Counterexamples

/-- The fundamental symmetry `J = diag(1, -1)`, signature `(1, 1)`. -/
def J2 : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- `J2` is a genuine fundamental symmetry: Hermitian and involutive. -/
theorem J2_isFundamental : J2ᴴ = J2 ∧ J2 * J2 = 1 := by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;> norm_num [ J2 ]

/-- A marginal `J`-self-adjoint matrix `A₁ = [[0,1],[-1,0]]`. -/
def A1 : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; -1, 0]

/-- An unstable `J`-self-adjoint matrix `A₂ = [[1,2],[-2,1]]`. -/
def A2 : Matrix (Fin 2) (Fin 2) ℂ := !![1, 2; -2, 1]

/-- A Hermitian retarded block `D₊ = [[0,1],[1,0]]`. -/
def Dp0 : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- **`J`-self-adjoint does not imply real spectrum.**  `A₁` is `J`-self-adjoint
yet has the nonreal eigenvalue `i` (eigenvector `(1, i)`). -/
theorem jselfadj_not_real_spectrum :
    sharp J2 A1 = A1 ∧
      ∃ (μ : ℂ) (v : Fin 2 → ℂ), v ≠ 0 ∧ A1.mulVec v = μ • v ∧ μ.im ≠ 0 := by
  constructor;
  · unfold sharp J2 A1; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Matrix.conjTranspose ] ;
    · norm_num [ Matrix.vecMul ];
      norm_num [ vecHead, vecTail ];
    · norm_num [ Matrix.vecMul, dotProduct ];
    · norm_num [ Matrix.vecMul ];
      norm_num [ vecHead, vecTail ];
    · norm_num [ Matrix.vecMul, dotProduct ];
  · use Complex.I;
    -- Let's choose the eigenvector $v = ![1, Complex.I]$.
    use ![1, Complex.I];
    norm_num [ ← List.ofFn_inj, A1 ]

/-- **`J`-self-adjoint does not imply physical stability.**  `A₂` is
`J`-self-adjoint yet has an eigenvalue (`1 + 2i`, eigenvector `(1, i)`) of
positive real part, i.e. a growing mode under `exp(t A₂)`. -/
theorem jselfadj_not_stable :
    sharp J2 A2 = A2 ∧
      ∃ (μ : ℂ) (v : Fin 2 → ℂ), v ≠ 0 ∧ A2.mulVec v = μ • v ∧ 0 < μ.re := by
  constructor;
  · simp +decide [ sharp, J2, A2 ];
    norm_num [ ← List.ofFn_inj, Matrix.vecMul, Matrix.mul_apply ];
    norm_num [ vecHead, vecTail ];
    norm_num [ Complex.ext_iff ];
  · use 1 + 2 * Complex.I, ![1, Complex.I];
    norm_num [ ← List.ofFn_inj, Complex.ext_iff, Matrix.mulVec ];
    norm_num [ vecHead, vecTail, A2 ]

/-- **`J`-self-adjoint doubling does not imply positive-definite energy or real
spectrum.**  `D₊` is Hermitian (innocent, real spectrum), yet its Krein double
has `D₋ D₊ = -I` (energy not positive definite) and `D_dbl² = -I` (purely
imaginary spectrum), while `D_dbl` is `J_dbl`-self-adjoint by
`Ddbl_kreinSelfAdjoint`. -/
theorem doubling_not_positive :
    Dp0ᴴ = Dp0 ∧
      (sharp J2 Dp0) * Dp0 = -1 ∧
      (Ddbl Dp0 (sharp J2 Dp0)) * (Ddbl Dp0 (sharp J2 Dp0)) = -1 := by
  unfold Ddbl sharp;
  norm_num [ ← Matrix.ext_iff, Fin.forall_fin_two, J2, Dp0 ];
  simp +decide [ Matrix.mul_apply, Matrix.vecMul ];
  norm_num [ vecHead, vecTail ]

end Counterexamples

end Draft
end PhysicsSM
