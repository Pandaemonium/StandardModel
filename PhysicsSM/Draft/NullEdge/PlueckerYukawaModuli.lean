import Mathlib

/-!
# Pluecker-to-Yukawa is a moduli gate, not a uniqueness gate

Independent Opus classification result for the origin-of-mass legality/selection
gate (AFPL gate A2). The admissible gauge-equivariant Yukawa couplings form the
intertwiner space `Hom_G(V_R, V_L)` (Schur dimension `Σ_λ m_{L,λ} m_{R,λ}`); the
displayed norm and determinant data do NOT uniquely select a literal point in
it. This module lands a kernel counterexample: two distinct gauge-equivariant
couplings have equal Frobenius norm and equal determinant. A stronger audit
also checks equality of their unordered singular-value multisets. This does not
show that every finer Pluecker datum fails to select a coupling or that the two
couplings are inequivalent under an intended physical equivalence relation.

Model: the `C₂` representation `diag(1,-1)` on `ℂ²` (trivial ⊕ sign character).
Equivariant endomorphisms are exactly the diagonal matrices; `diag(1,0)` and
`diag(0,1)` are distinct admissible couplings with the same squared Frobenius
norm (`1`) and the same determinant (`0`).

SCOPE CORRECTION (docstring audit `364a29ac`): the witnesses share not only Frobenius
norm and determinant but the FULL SINGULAR-VALUE MULTISET (checked via the squared
Gram spectrum) - stronger than originally claimed. But this defeats selection by
THOSE invariants only, NOT by every conceivable finer Pluecker datum, and the
intended equivalence relation on couplings must be specified before any no-go is
stated in general form.

Consequence for A2: state A2 as a moduli/classification theorem
(`Adm = Hom_G(V_R,V_L)`) plus a Pluecker level-set/stratum description - NOT a
uniqueness theorem. A genuine uniqueness statement needs additional explicit
hypotheses (a one-dimensional intertwiner space still leaves phase freedom; the
Standard Model Yukawa additionally requires the Higgs representation, not a bare
intertwiner). Full analysis in the job's `ANALYSIS.md`.

Provenance: verified independently at the pinned toolchain from the Aristotle
strategy return `37f6c2ac-9433-4cc1-88b4-1999430566b7` (task `a39c576e`).
Clean-room Mathlib port; standard three axioms. Claim grade `M`, `[comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.PlueckerYukawaModuli

abbrev M2 := Matrix (Fin 2) (Fin 2) ℂ

/-- Generator of the `C₂` rep = trivial ⊕ sign character. -/
def signGenerator : M2 := !![(1 : ℂ), 0; 0, -1]

/-- One admissible coupling, on the trivial character. -/
def coupling₀ : M2 := !![(1 : ℂ), 0; 0, 0]

/-- A second admissible coupling, on the sign character. -/
def coupling₁ : M2 := !![(0 : ℂ), 0; 0, 1]

/-- Equivariant endomorphisms of the `C₂` rep are exactly the diagonal
matrices. -/
theorem intertwines_sign_iff_diagonal (Y : M2) :
    signGenerator * Y = Y * signGenerator ↔ Y 0 1 = 0 ∧ Y 1 0 = 0 := by
  simp_all +decide [← Matrix.ext_iff, Fin.forall_fin_two, signGenerator]
  simp_all +decide [Matrix.vecMul, Matrix.vecHead, Matrix.vecTail, Matrix.mul_apply]
  grind

theorem coupling₀_intertwines :
    signGenerator * coupling₀ = coupling₀ * signGenerator := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [signGenerator, coupling₀]

theorem coupling₁_intertwines :
    signGenerator * coupling₁ = coupling₁ * signGenerator := by
  unfold signGenerator coupling₁; ext i j; fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply]

theorem couplings_ne : coupling₀ ≠ coupling₁ :=
  ne_of_apply_ne (fun m => m 0 0) (by norm_num [coupling₀, coupling₁])

/-- **Norm does not select the literal coupling.** Both admissible witnesses
have the same squared Frobenius norm. -/
theorem couplings_same_frobenius_sq :
    (∑ i : Fin 2, ∑ j : Fin 2, Complex.normSq (coupling₀ i j)) =
      ∑ i : Fin 2, ∑ j : Fin 2, Complex.normSq (coupling₁ i j) := by
  norm_num [Fin.sum_univ_succ, coupling₀, coupling₁]

/-- **Determinant does not select the literal coupling.** Both admissible
witnesses have the same determinant. -/
theorem couplings_same_det : coupling₀.det = coupling₁.det := by
  norm_num [Matrix.det_fin_two, coupling₀, coupling₁]

/-- The one-dimensional Schur principle: distinct characters have only the zero
intertwiner. -/
theorem scalar_intertwiner_zero {a b y : ℂ} (hab : a ≠ b) (hy : a * y = y * b) :
    y = 0 :=
  mul_left_cancel₀ (sub_ne_zero.mpr hab) (by linear_combination hy)

end PhysicsSM.Draft.NullEdge.PlueckerYukawaModuli
