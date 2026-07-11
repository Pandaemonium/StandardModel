import Mathlib

/-!
# Full-zone zero-set classification for the ordered split walk

Pure real-algebra target extracted from the kernel-checked determinant
polynomials.  The hypotheses are exactly the physical principal massive branch:
all momentum cosines lie in `[-1,1]`, and the mass-angle cosine has magnitude
strictly between zero and one.
-/

namespace FullBlochZeroClassification

/-- Common part of the `+1` and `-1` Floquet determinant polynomials. -/
def spectralBase (x y z c : Real) : Real :=
  4 * c^2 * x^2 * y^2 * z^2
    - 2 * c^2 * x^2 * y^2
    - 2 * c^2 * x^2 * z^2
    + c^2 * x^2
    - 2 * c^2 * y^2 * z^2
    + c^2 * y^2
    + c^2 * z^2
    - 2 * x^2 * y^2 * z^2
    + x^2 * y^2
    + x^2 * z^2
    + y^2 * z^2

def zeroPoly (x y z c : Real) : Real :=
  spectralBase x y z c - 2 * c * x * y * z

def piPoly (x y z c : Real) : Real :=
  spectralBase x y z c + 2 * c * x * y * z

/-- On the principal massive branch, the `+1` determinant vanishes only at
the simultaneous body-center cosine locus. -/
theorem zeroPoly_eq_zero_iff
    (x y z c : Real)
    (hx : |x| <= 1) (hy : |y| <= 1) (hz : |z| <= 1)
    (hc0 : 0 < |c|) (hc1 : |c| < 1) :
    zeroPoly x y z c = 0 <-> x = 0 ∧ y = 0 ∧ z = 0 := by
  sorry

/-- The same complete zero set controls the `-1` determinant. -/
theorem piPoly_eq_zero_iff
    (x y z c : Real)
    (hx : |x| <= 1) (hy : |y| <= 1) (hz : |z| <= 1)
    (hc0 : 0 < |c|) (hc1 : |c| < 1) :
    piPoly x y z c = 0 <-> x = 0 ∧ y = 0 ∧ z = 0 := by
  sorry

/-- Exact body-center witness, valid for every mass angle. -/
theorem body_center_control (c : Real) :
    zeroPoly 0 0 0 c = 0 ∧ piPoly 0 0 0 c = 0 := by
  constructor <;> norm_num [zeroPoly, piPoly, spectralBase]

/-- Nonzero principal-branch control away from body center. -/
theorem nonzero_control :
    zeroPoly 1 0 0 (3 / 5) = 9 / 25 ∧
      piPoly 1 0 0 (3 / 5) = 9 / 25 := by
  constructor <;> norm_num [zeroPoly, piPoly, spectralBase]

end FullBlochZeroClassification
