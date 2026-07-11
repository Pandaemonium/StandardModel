import PhysicsSM.Draft.NullEdge.CarrierRigidity

/-!
# Classification of commutator-blind scalar selectors

This module classifies rational-linear scalar selectors on the live concrete
`4 x 4` represented carrier that vanish on every matrix commutator. Every such
selector factors through matrix trace, so none can distinguish the complete
represented operator space.

The result is a structural Paper F obstruction. It rules out scalar linear
selectors whose proposed intrinsicity is strong enough to make them blind to
all commutators. It does not classify nonlinear, vector-valued, spectral,
locality-sensitive, positive-sector, or information-theoretic selectors.
Conjugation invariance and commutator blindness should not be silently
identified outside this exact linear setting.

Provenance: elementary matrix-unit argument, developed in the overnight Paper
F classification lane. Lean 4.28.0.
-/

namespace PhysicsSM.Draft.NullEdge.ChannelCommutatorSelectorClassification

open CarrierRigidity.Concrete

/-- The standard matrix unit in the represented rational carrier. -/
def matrixUnit (i j : Fin 4) : N := Matrix.single i j 1

/-- The matrix commutator. -/
def commutator (A B : N) : N := A * B - B * A

/-- A scalar linear selector is commutator-blind when it annihilates every
represented commutator. -/
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
theorem diagSub_is_commutator (i j : Fin 4) :
    commutator (matrixUnit i j) (matrixUnit j i) =
      matrixUnit i i - matrixUnit j j := by
  simp [commutator, matrixUnit]

/-- A commutator-blind selector vanishes on off-diagonal matrix units. -/
theorem offDiag_selector_zero (f : N →ₗ[ℚ] ℚ)
    (hf : CommutatorBlind f) {i j : Fin 4} (hij : i ≠ j) :
    f (matrixUnit i j) = 0 := by
  rw [← offDiag_is_commutator hij]
  exact hf _ _

/-- A commutator-blind selector has the same value on every diagonal matrix
unit. -/
theorem diag_selector_equal (f : N →ₗ[ℚ] ℚ)
    (hf : CommutatorBlind f) (i j : Fin 4) :
    f (matrixUnit i i) = f (matrixUnit j j) := by
  have hzero : f (matrixUnit i i - matrixUnit j j) = 0 := by
    rw [← diagSub_is_commutator i j]
    exact hf _ _
  apply sub_eq_zero.mp
  simpa using hzero

/-- Structural classification: every commutator-blind rational-linear scalar
selector on the live represented carrier is a scalar multiple of trace. -/
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

/-- A concrete nonzero direction in the kernel of trace. -/
def traceZeroDirection : N :=
  !![1,0,0,0; 0,-1,0,0; 0,0,0,0; 0,0,0,0]

theorem traceZeroDirection_nonzero : traceZeroDirection ≠ 0 := by
  intro hzero
  have hentry := congrArg (fun X : N => X 0 0) hzero
  norm_num [traceZeroDirection] at hentry

theorem traceZeroDirection_trace : Matrix.trace traceZeroDirection = 0 := by
  norm_num [traceZeroDirection, Matrix.trace, Fin.sum_univ_succ]

/-- No commutator-blind rational-linear scalar selector is injective on the
represented carrier space. -/
theorem no_commutatorBlind_selector_injective
    (f : N →ₗ[ℚ] ℚ) (hf : CommutatorBlind f) :
    ¬ Function.Injective f := by
  intro hinj
  apply traceZeroDirection_nonzero
  apply hinj
  rw [selector_factors_through_trace f hf traceZeroDirection,
    traceZeroDirection_trace]
  simp

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelCommutatorSelectorClassification.selector_factors_through_trace' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms selector_factors_through_trace

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelCommutatorSelectorClassification.no_commutatorBlind_selector_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_commutatorBlind_selector_injective

end PhysicsSM.Draft.NullEdge.ChannelCommutatorSelectorClassification
