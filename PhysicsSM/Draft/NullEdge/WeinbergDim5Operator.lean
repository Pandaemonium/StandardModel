import Mathlib

/-!
# Weinberg dimension-5 operator -> Majorana mass (Opus, verified Aristotle 9100799d)

Explicit effective-operator origin of the A5 Majorana branch: the identity
U^T eps U = det(U) eps for every complex 2x2 (so SU(2) preserves eps), invariance of
L^T eps H and of O5 under the SU(2) action, and the exact breaking reduction
O5 L (0,v) = v^2 (L 0)^2 - with Wilson coefficient c and scale Lambda giving
(c v^2 / Lambda)(L 0)^2, the standard seesaw-scale Majorana mass.

Namespace kept as the prover's (verbatim, preserving proofs). Provenance:
verified at the pinned toolchain from Aristotle project 9100799d.
Clean-room Mathlib port; standard three axioms. Claim grade M, [comp]. -/

open scoped BigOperators ComplexConjugate

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace WeinbergOperator

abbrev Doublet := Fin 2 → ℂ
abbrev Matrix2 := Matrix (Fin 2) (Fin 2) ℂ

/-- The antisymmetric invariant tensor of the defining representation of `SU(2)`. -/
def eps : Matrix2 := !![0, 1; -1, 0]

/-- The bilinear (not Hermitian) `Lᵀ ε H`. -/
noncomputable def contraction (L H : Doublet) : ℂ := dotProduct L (Matrix.mulVec eps H)

/-- The explicit dimension-five Weinberg operator `(Lᵀ ε H)²`. -/
noncomputable def O5 (L H : Doublet) : ℂ := contraction L H * contraction L H

/-- A concrete predicate saying that a two-by-two complex matrix is in `SU(2)`. -/
def IsSU2 (U : Matrix2) : Prop :=
  Matrix.conjTranspose U * U = 1 ∧ Matrix.det U = 1

/-- The defining action of a matrix on a weak doublet. -/
noncomputable def act (U : Matrix2) (x : Doublet) : Doublet := Matrix.mulVec U x

/-
Every two-by-two matrix satisfies `Uᵀ ε U = det(U) ε`.
-/
theorem transpose_eps_mul (U : Matrix2) :
    U.transpose * eps * U = Matrix.det U • eps := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Matrix.transpose_apply, Matrix.det_fin_two ] <;> ring!;
  · unfold eps; norm_num;
  · unfold eps; norm_num; ring;
  · simp +decide [ eps ];
  · simp +decide [ eps ]

/-
The contraction is invariant under simultaneous `SU(2)` transformations.
-/
theorem contraction_su2_invariant {U : Matrix2} (hU : IsSU2 U) (L H : Doublet) :
    contraction (act U L) (act U H) = contraction L H := by
  unfold contraction act;
  have h_contraction : Matrix.mulVec U L ⬝ᵥ Matrix.mulVec eps (Matrix.mulVec U H) = L ⬝ᵥ Matrix.mulVec (U.transpose * eps * U) H := by
    simp +decide [ Matrix.mul_assoc, Matrix.dotProduct_mulVec, Matrix.vecMul_mulVec ];
  rw [ h_contraction, transpose_eps_mul U, hU.2 ] ; norm_num

/-
The Weinberg operator is invariant under simultaneous `SU(2)` transformations.
-/
theorem O5_su2_invariant {U : Matrix2} (hU : IsSU2 U) (L H : Doublet) :
    O5 (act U L) (act U H) = O5 L H := by
  unfold O5; rw [ contraction_su2_invariant ] ;
  assumption

/-- The symmetry-breaking Higgs configuration `(0,v)`. -/
def higgsVEV (v : ℂ) : Doublet := ![0, v]

/-
On `H = (0,v)`, the antisymmetric contraction is exactly `v L₀`.
-/
theorem contraction_higgsVEV (L : Doublet) (v : ℂ) :
    contraction L (higgsVEV v) = v * L 0 := by
  unfold contraction higgsVEV;
  simp +decide [ Matrix.mulVec, dotProduct, eps ] ; ring!

/-
After symmetry breaking, the exact coefficient is one:
`O₅(L,(0,v)) = v² (L₀)²`.
-/
theorem O5_higgsVEV (L : Doublet) (v : ℂ) :
    O5 L (higgsVEV v) = v ^ 2 * (L 0) ^ 2 := by
  rw [ show O5 L ( higgsVEV v ) = ( contraction L ( higgsVEV v ) ) * ( contraction L ( higgsVEV v ) ) by rfl, contraction_higgsVEV ] ; ring;

/-- The Weinberg interaction with Wilson coefficient `c` and heavy scale `Λ`. -/
noncomputable def effectiveO5 (c Λ : ℂ) (L H : Doublet) : ℂ :=
  (c / Λ) * O5 L H

/-
After symmetry breaking, the exact mass coefficient is `c v² / Λ`.
-/
theorem effectiveO5_higgsVEV (c Λ : ℂ) (L : Doublet) (v : ℂ) :
    effectiveO5 c Λ L (higgsVEV v) =
      (c * v ^ 2 / Λ) * (L 0) ^ 2 := by
  convert congr_arg ( fun x : ℂ => ( c / Λ ) * x ) ( O5_higgsVEV L v ) using 1 ; ring

/-- A global lepton-number phase rotation of the lepton doublet. -/
noncomputable def leptonPhase (a : ℝ) (L : Doublet) : Doublet :=
  fun i => Complex.exp (Complex.I * (a : ℂ)) * L i

/-
Since `O₅` contains two copies of `L`, its phase is `exp(2 i a)`.

The exponent `4 i a` in the requested statement would correspond to four copies
of `L` and is false for the displayed operator `(Lᵀ ε H)(Lᵀ ε H)`.
-/
theorem O5_leptonPhase (a : ℝ) (L H : Doublet) :
    O5 (leptonPhase a L) H =
      Complex.exp (2 * Complex.I * (a : ℂ)) * O5 L H := by
  unfold leptonPhase O5 contraction;
  simp +decide [ Matrix.mulVec, dotProduct ] ; ring;
  rw [ ← Complex.exp_nat_mul ] ; ring;

/-- A simple conjugate-linear Dirac-type bilinear, included to contrast its
phase invariance with the charge-two Weinberg operator. -/
noncomputable def diracBilinear (L K : Doublet) : ℂ :=
  ∑ i, conj (L i) * K i

/-
A Dirac bilinear is invariant when both fields receive the same phase.
-/
theorem diracBilinear_leptonPhase (a : ℝ) (L K : Doublet) :
    diracBilinear (leptonPhase a L) (leptonPhase a K) = diracBilinear L K := by
  unfold diracBilinear leptonPhase;
  norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ];
  constructor <;> ring_nf <;> rw [ Real.sin_sq, Real.cos_sq ] <;> ring

/-
The charge-two phase is genuinely nontrivial: at `a = π/2`, an explicit
field configuration changes the value of `O₅` from `1` to `-1`.
-/
theorem O5_not_lepton_invariant :
    let L : Doublet := ![1, 0]
    let H : Doublet := ![0, 1]
    O5 (leptonPhase (Real.pi / 2) L) H ≠ O5 L H := by
  unfold O5 leptonPhase;
  unfold contraction; norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ];
  norm_num [ Matrix.mulVec, Matrix.vecHead, Matrix.vecTail, eps ]

/-
In particular, the proposed charge-four transformation law is false for
this operator.
-/
theorem not_O5_charge_four :
    ¬ ∀ (a : ℝ) (L H : Doublet),
      O5 (leptonPhase a L) H =
        Complex.exp (4 * Complex.I * (a : ℂ)) * O5 L H := by
  push_neg;
  use Real.pi / 2, ![1, 0], ![0, 1];
  unfold O5 leptonPhase;
  unfold contraction; norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ] ;
  norm_num [ show 4 * ( Real.pi / 2 ) = 2 * Real.pi by ring, Matrix.mulVec, Matrix.vecHead, Matrix.vecTail, eps ]

#print axioms transpose_eps_mul
#print axioms O5_su2_invariant
#print axioms O5_higgsVEV
#print axioms effectiveO5_higgsVEV
#print axioms O5_leptonPhase
#print axioms diracBilinear_leptonPhase
#print axioms O5_not_lepton_invariant
#print axioms not_O5_charge_four

end WeinbergOperator
