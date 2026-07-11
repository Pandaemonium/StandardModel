import Mathlib

/-!
# Classification of commutator-blind linear matrix selectors

Focused Paper F target. The theorem turns the componentwise trace no-go into a
structural classification for scalar linear selectors on the live `4 x 4`
rational represented carrier.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace ChannelCommutatorSelector

abbrev N := Matrix (Fin 4) (Fin 4) ℚ

def matrixUnit (i j : Fin 4) : N := Matrix.single i j 1

def commutator (A B : N) : N := A * B - B * A

def CommutatorBlind (f : N →ₗ[ℚ] ℚ) : Prop :=
  ∀ A B : N, f (commutator A B) = 0

/-- Every off-diagonal matrix unit is itself a commutator. -/
theorem offDiag_is_commutator {i j : Fin 4} (hij : i ≠ j) :
    commutator (matrixUnit i i) (matrixUnit i j) = matrixUnit i j := by
  unfold commutator matrixUnit
  rw [Matrix.single_mul_single_same]
  rw [Matrix.single_mul_single_of_ne (c := (1 : ℚ)) i j i hij.symm (1 : ℚ)]
  simp

/-- Every difference of diagonal matrix units is a commutator. -/
theorem diagSub_is_commutator {i j : Fin 4} (hij : i ≠ j) :
    commutator (matrixUnit i j) (matrixUnit j i)
      = matrixUnit i i - matrixUnit j j := by
  simp [commutator, matrixUnit]

/-- A commutator-blind linear selector vanishes on off-diagonal matrix units. -/
theorem offDiag_selector_zero (f : N →ₗ[ℚ] ℚ)
    (hf : CommutatorBlind f) {i j : Fin 4} (hij : i ≠ j) :
    f (matrixUnit i j) = 0 := by
  rw [← offDiag_is_commutator hij]
  exact hf _ _

/-- A commutator-blind linear selector has the same value on every diagonal
matrix unit. -/
theorem diag_selector_equal (f : N →ₗ[ℚ] ℚ)
    (hf : CommutatorBlind f) (i j : Fin 4) :
    f (matrixUnit i i) = f (matrixUnit j j) := by
  by_cases hij : i = j
  · simpa [hij]
  · have hzero : f (matrixUnit i i - matrixUnit j j) = 0 := by
      rw [← diagSub_is_commutator hij]
      exact hf _ _
    apply sub_eq_zero.mp
    simpa using hzero

/-- Structural classification: every commutator-blind rational-linear scalar
selector on the live matrix space is a scalar multiple of trace. -/
theorem selector_factors_through_trace (f : N →ₗ[ℚ] ℚ)
    (hf : CommutatorBlind f) (X : N) :
    f X = (f 1 / 4) * Matrix.trace X := by
  have hdiag (i : Fin 4) : f (matrixUnit i i) = f 1 / 4 := by
    have hsum : f 1 = 4 * f (matrixUnit i i) := by
      calc
        f 1 = f (∑ j : Fin 4, Matrix.single j j (1 : ℚ)) := by
          rw [Matrix.sum_single_one]
        _ = ∑ j : Fin 4, f (matrixUnit j j) := by
          simp [matrixUnit]
        _ = ∑ _j : Fin 4, f (matrixUnit i i) := by
          apply Finset.sum_congr rfl
          intro j _hj
          exact diag_selector_equal f hf j i
        _ = 4 * f (matrixUnit i i) := by norm_num
    linarith
  induction X using Matrix.induction_on' with
  | h_zero => simp
  | h_add A B hA hB =>
    rw [map_add, hA, hB, Matrix.trace_add]
    ring
  | h_std_basis i j x =>
    have hsingle : Matrix.single i j x = x • matrixUnit i j := by
      simp [matrixUnit]
    rw [hsingle, map_smul]
    by_cases hij : i = j
    · subst j
      rw [hdiag]
      simp [matrixUnit]
      ring
    · rw [offDiag_selector_zero f hf hij]
      simp [matrixUnit, hij]

def traceZeroDirection : N :=
  !![1,0,0,0; 0,-1,0,0; 0,0,0,0; 0,0,0,0]

theorem traceZeroDirection_nonzero : traceZeroDirection ≠ 0 := by
  intro hzero
  have hentry := congrArg (fun X : N => X 0 0) hzero
  norm_num [traceZeroDirection] at hentry

theorem traceZeroDirection_trace : Matrix.trace traceZeroDirection = 0 := by
  norm_num [traceZeroDirection, Matrix.trace, Fin.sum_univ_succ]

/-- No commutator-blind rational-linear scalar selector can be injective on
the represented `4 x 4` carrier space. -/
theorem no_commutatorBlind_selector_injective
    (f : N →ₗ[ℚ] ℚ) (hf : CommutatorBlind f) :
    ¬ Function.Injective f := by
  intro hinj
  apply traceZeroDirection_nonzero
  apply hinj
  rw [selector_factors_through_trace f hf traceZeroDirection,
    traceZeroDirection_trace]
  simp

end ChannelCommutatorSelector
