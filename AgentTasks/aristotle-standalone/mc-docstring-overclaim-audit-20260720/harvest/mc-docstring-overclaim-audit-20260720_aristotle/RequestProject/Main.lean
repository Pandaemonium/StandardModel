import Mathlib

open scoped BigOperators
open Matrix

set_option autoImplicit false

namespace MCAudit

/-! This file gives concrete witnesses and corrected hypotheses for an adversarial
    audit of five prose claims. -/

section VaryingBasis

abbrev RMat2 := Matrix (Fin 2) (Fin 2) ℝ

def basisA : RMat2 := !![1, 0; 0, -1]
def basisI : RMat2 := 1
def basisSwap : RMat2 := !![0, 1; 1, 0]
def orthogonal2 (U : RMat2) : Prop := U.transpose * U = 1
def conjugate2 (U A : RMat2) : RMat2 := U * A * U.transpose

def matrixSqDist2 (A B : RMat2) : ℝ := ∑ i, ∑ j, (A i j - B i j) ^ 2

/-
Both basis changes in the counterexample are orthogonal (real unitary).
-/
theorem basisI_orthogonal : orthogonal2 basisI := by
  -- Since `basisI` is the identity matrix, its transpose is also the identity matrix.
  simp [orthogonal2, basisI]

theorem basisSwap_orthogonal : orthogonal2 basisSwap := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, basisSwap ]

/-
A varying unitary can turn a zero input difference into a nonzero output
    difference. Thus the estimate valid for one fixed conjugating unitary does not
    extend to independently varying unitaries.
-/
theorem varying_unitary_counterexample :
    matrixSqDist2 (conjugate2 basisI basisA) (conjugate2 basisSwap basisA) = 8 ∧
      matrixSqDist2 basisA basisA = 0 := by
        unfold matrixSqDist2 conjugate2 basisI basisA basisSwap; norm_num [ Fin.sum_univ_succ ] ;
        norm_num [ vecHead, vecTail ]

/-
The fixed-basis version really does preserve the entrywise Euclidean distance.
-/
theorem fixed_orthogonal_conjugation_isometry (U A B : RMat2)
    (hU : orthogonal2 U) :
    matrixSqDist2 (conjugate2 U A) (conjugate2 U B) = matrixSqDist2 A B := by
      unfold matrixSqDist2 conjugate2;
      unfold orthogonal2 at hU; have := congr_fun ( congr_fun hU 0 ) 0; have := congr_fun ( congr_fun hU 1 ) 0; have := congr_fun ( congr_fun hU 0 ) 1; have := congr_fun ( congr_fun hU 1 ) 1; norm_num [ Matrix.mul_apply ] at *;
      grind +ring

end VaryingBasis

section OffDiagonalBlocks

abbrev RVec2 := Fin 2 → ℝ

def matVec2 (A : RMat2) (x : RVec2) : RVec2 := fun i => ∑ j, A i j * x j
def vecSq2 (x : RVec2) : ℝ := ∑ i, (x i) ^ 2
def pairSq2 (x y : RVec2) : ℝ := vecSq2 x + vecSq2 y

def blockApply (A B C D : RMat2) (x y : RVec2) : RVec2 × RVec2 :=
  (fun i => matVec2 A x i + matVec2 B y i,
   fun i => matVec2 C x i + matVec2 D y i)

def e0 : RVec2 := ![1, 0]

/-
Every individual block in the example has squared operator constant one.
-/
theorem identity_block_constant_one (x : RVec2) : vecSq2 (matVec2 basisI x) = vecSq2 x := by
  unfold matVec2 vecSq2; norm_num [ Fin.sum_univ_succ ] ;
  unfold basisI; norm_num;

/-
Four norm-one blocks, including off-diagonal blocks, can assemble to an
    operator whose norm constant is two (squared ratio four).
-/
theorem offDiagonal_blocks_accumulate :
    let z := blockApply basisI basisI basisI basisI e0 e0
    pairSq2 z.1 z.2 = 8 ∧ pairSq2 e0 e0 = 2 := by
      norm_num [ pairSq2, vecSq2, matVec2, blockApply ];
      norm_num [ basisI, e0 ]

end OffDiagonalBlocks

section TailDependence

/-- A mass-dependent tail set in a one-point finite model. -/
def tailSet : Bool → Finset (Fin 1)
  | false => ∅
  | true => {0}

/-- The field is unchanged by the parameter, modeling an identity unitary. -/
def tailField (_mass : Bool) (_i : Fin 1) : ℝ := 1

def tailEnergy (mass : Bool) : ℝ := ∑ i ∈ tailSet mass, (tailField mass i) ^ 2

/-
Unitarity alone does not make a tail integral mass-independent when its domain
    is allowed to depend on mass.
-/
theorem mass_dependent_tail_counterexample :
    (∀ mass i, |tailField mass i| = 1) ∧
      tailEnergy false = 0 ∧ tailEnergy true = 1 := by
        norm_num [ tailEnergy, tailField ];
        rfl

end TailDependence

section WalkSkeleton

/-- A corrected many-step skeleton. A uniform one-step displacement plus the
    composition law is enough; isometry/unitarity is not logically needed once the
    one-step estimate is already uniform in the starting point. -/
theorem walk_many_step
    {E : Type*} [PseudoMetricSpace E]
    (W : ℕ → E → E) (C : ℝ)
    (hzero : ∀ x, W 0 x = x)
    (hadd : ∀ n m x, W (n + m) x = W n (W m x))
    (hone : ∀ x, dist (W 1 x) x ≤ C) :
    ∀ n x, dist (W n x) x ≤ n * C := by
      intro n x;
      induction' n with n ih generalizing x <;> simp_all +decide [ add_mul ];
      exact le_trans ( dist_triangle _ _ _ ) ( add_le_add ( ih _ ) ( hone _ ) )

/-
One-step information alone cannot control later values without a propagation
    hypothesis such as a composition law or direct bounds on every increment.
-/
theorem one_step_alone_counterexample :
    let W : ℕ → ℝ → ℝ := fun n x => if n = 2 then x + 1 else x
    (∀ x, dist (W 1 x) x = 0) ∧ dist (W 2 0) 0 = 1 := by
      norm_num [ dist_eq_norm ]

end WalkSkeleton

section ComponentMeasurability

inductive TwoPoint where
  | a | b
  deriving DecidableEq

instance : Nonempty TwoPoint := ⟨TwoPoint.a⟩

/-- Domain with only `∅` and `univ` measurable. -/
def coarseTwoPoint : MeasurableSpace TwoPoint := ⊥
/-- Codomain with every set measurable. -/
def discreteTwoPoint : MeasurableSpace TwoPoint := ⊤

def constantComponent (_ : TwoPoint) : TwoPoint := TwoPoint.a
def varyingComponent (x : TwoPoint) : TwoPoint := x

/-
One component may be measurable while another component of the same assembly
    is not; componentwise reuse therefore does not discharge measurability for free.
-/
theorem component_measurability_counterexample :
    @Measurable TwoPoint TwoPoint coarseTwoPoint discreteTwoPoint constantComponent ∧
    ¬ @Measurable TwoPoint TwoPoint coarseTwoPoint discreteTwoPoint varyingComponent := by
      refine' ⟨ measurable_const, _ ⟩;
      -- The varying component is not measurable because it is not constant.
      simp [Measurable];
      refine' ⟨ { TwoPoint.a }, _ ⟩ ; simp +decide [ MeasurableSpace.measurableSet_bot_iff ];
      exact ⟨ Set.Nonempty.ne_empty ⟨ TwoPoint.a, rfl ⟩, TwoPoint.b, by simp +decide ⟩

end ComponentMeasurability

end MCAudit
