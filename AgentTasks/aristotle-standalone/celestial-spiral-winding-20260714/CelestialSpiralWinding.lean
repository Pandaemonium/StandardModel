import Mathlib

/-!
# Celestial spiral handedness and cubic winding density

Focused Aristotle handoff for the exact bridge between an oriented triple of
celestial directions and the noncommuting antisymmetrized cubic trace used as
the pointwise three-dimensional winding-density integrand.

The target coefficient is fixed by the Pauli control: for the coordinate axes
the cubic trace must be `12 * I`.  The spin-projector version must be
`(3/2) * I` times the scalar triple product, agreeing with six times the
imaginary part of the Bargmann triple.

This standalone draft is Mathlib-only.  Proof placeholders are intentional
Aristotle handoff targets; theorem statements must not be weakened.
-/

noncomputable section

open Matrix Complex

namespace CelestialSpiralWinding

abbrev V3 := Fin 3 -> Real
abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

def pauliX : M2 := !![0, 1; 1, 0]
def pauliY : M2 := !![0, -I; I, 0]
def pauliZ : M2 := !![1, 0; 0, -1]

def dot3 (a b : V3) : Real :=
  a 0 * b 0 + a 1 * b 1 + a 2 * b 2

def cross3 (a b : V3) : V3 :=
  ![a 1 * b 2 - a 2 * b 1,
    a 2 * b 0 - a 0 * b 2,
    a 0 * b 1 - a 1 * b 0]

def pauliVec (a : V3) : M2 :=
  (a 0 : Complex) • pauliX +
    (a 1 : Complex) • pauliY +
    (a 2 : Complex) • pauliZ

def spinProjector (a : V3) : M2 :=
  (2 : Complex)⁻¹ • ((1 : M2) + pauliVec a)

noncomputable def antisymCubic (R : Fin 3 -> M2) : M2 :=
  R 0 * R 1 * R 2 - R 0 * R 2 * R 1 - R 1 * R 0 * R 2 +
    R 1 * R 2 * R 0 + R 2 * R 0 * R 1 - R 2 * R 1 * R 0

def pauliDirectionTriple (a b c : V3) : Fin 3 -> M2
  | 0 => pauliVec a
  | 1 => pauliVec b
  | 2 => pauliVec c

def projectorDirectionTriple (a b c : V3) : Fin 3 -> M2
  | 0 => spinProjector a
  | 1 => spinProjector b
  | 2 => spinProjector c

def tripleHolonomy (a b c : V3) : Complex :=
  Matrix.trace (spinProjector a * spinProjector b * spinProjector c)

/-
Matrix-level Pauli identity: the alternating cubic is central with
coefficient six times the oriented scalar triple product.
-/
theorem antisymCubic_pauliDirectionTriple (a b c : V3) :
    antisymCubic (pauliDirectionTriple a b c) =
      (6 * I * ((dot3 a (cross3 b c) : Real) : Complex)) • (1 : M2) := by
  ext i j;
  unfold antisymCubic pauliDirectionTriple dot3 cross3; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply, pauliX, pauliY, pauliZ ] <;> ring;
  · simp +decide [ pauliVec ] ; ring!;
    simp +decide [ pauliX, pauliY, pauliZ ] ; ring;
  · unfold pauliVec; ring;
    simp +decide [ pauliX, pauliY, pauliZ ] ; ring;
  · unfold pauliVec; norm_num [ pauliX, pauliY, pauliZ ] ; ring;
  · unfold pauliVec; norm_num [ pauliX, pauliY, pauliZ ] ; ring;
    erw [ Matrix.cons_val_succ' ] ; norm_num ; ring

/-
Trace-level Pauli identity, normalized so the coordinate axes give
`12 * I`.
-/
theorem trace_antisymCubic_pauliDirectionTriple (a b c : V3) :
    Matrix.trace (antisymCubic (pauliDirectionTriple a b c)) =
      12 * I * ((dot3 a (cross3 b c) : Real) : Complex) := by
  rw [ antisymCubic_pauliDirectionTriple ] ; norm_num [ Matrix.trace ] ; ring;

/-
Projector-level winding density.  Identity components cancel under full
antisymmetrization, leaving one eighth of the Pauli cubic.
-/
theorem trace_antisymCubic_projectorDirectionTriple (a b c : V3) :
    Matrix.trace (antisymCubic (projectorDirectionTriple a b c)) =
      ((3 / 2 : Real) : Complex) * I *
        ((dot3 a (cross3 b c) : Real) : Complex) := by
  convert congr_arg ( fun x : Complex => ( 1 / 8 : Complex ) * x ) ( trace_antisymCubic_pauliDirectionTriple a b c ) using 1;
  · unfold projectorDirectionTriple pauliDirectionTriple antisymCubic;
    unfold spinProjector;
    norm_num [ Matrix.trace, Matrix.mul_apply ] ; ring;
  · push_cast; ring;

/-- Exact bridge to the Bargmann phase: the cubic winding density is six
times `I` times the imaginary component of the ordered triple holonomy. -/
theorem windingDensity_eq_six_I_mul_holonomy_im (a b c : V3) :
    Matrix.trace (antisymCubic (projectorDirectionTriple a b c)) =
      6 * I * (((tripleHolonomy a b c).im : Real) : Complex) := by
  rw [ trace_antisymCubic_projectorDirectionTriple ];
  unfold tripleHolonomy spinProjector pauliVec;
  norm_num [ Matrix.trace, Matrix.mul_apply, pauliX, pauliY, pauliZ ];
  unfold dot3 cross3; norm_num [ Complex.ext_iff ] ; ring;
  erw [ Matrix.cons_val_succ' ] ; norm_num ; ring

def ex : V3 := ![1, 0, 0]
def ey : V3 := ![0, 1, 0]
def ez : V3 := ![0, 0, 1]

/-- Nondegenerate coordinate-axis control for both normalizations. -/
theorem coordinate_winding_witness :
    Matrix.trace (antisymCubic (pauliDirectionTriple ex ey ez)) = 12 * I ∧
      Matrix.trace (antisymCubic (projectorDirectionTriple ex ey ez)) =
        ((3 / 2 : Real) : Complex) * I := by
  convert And.intro ( trace_antisymCubic_pauliDirectionTriple ex ey ez ) ( trace_antisymCubic_projectorDirectionTriple ex ey ez ) using 1;
  · unfold ex ey ez dot3 cross3 ;
    aesop;
  · unfold ex ey ez dot3 cross3 ;
    simp +zetaDelta at *

/-- A nonzero scalar triple product forces a nonzero projector winding
density. -/
theorem projector_winding_nonzero_of_oriented (a b c : V3)
    (h : dot3 a (cross3 b c) ≠ 0) :
    Matrix.trace (antisymCubic (projectorDirectionTriple a b c)) ≠ 0 := by
  rw [ trace_antisymCubic_projectorDirectionTriple ];
  norm_num [ Complex.ext_iff, h ]

end CelestialSpiralWinding
