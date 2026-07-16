import Mathlib

/-!
# Celestial spiral triple

Focused Aristotle handoff for the finite algebraic distinction between mass
spread and ordered handedness.  The mass functional uses only pairwise dot
products, while the cyclic spin-projector trace also retains the oriented
scalar triple product.

Mathematical intent: reversing an ordered triple of celestial null directions
must preserve its scalar mass spread and complex-conjugate its Bargmann
holonomy.  The explicit coordinate-axis witness must have equal nonzero mass
and opposite nonzero handedness in the two orientations.

This standalone draft is Mathlib-only.  Proof placeholders are intentional
Aristotle handoff targets; theorem statements must not be weakened.
-/

noncomputable section

open Matrix Complex

namespace CelestialSpiralTriple

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

/-- Equal-weight three-direction angular mass spread. -/
def massSpread3 (a b c : V3) : Real :=
  2 * ((1 - dot3 a b) + (1 - dot3 b c) + (1 - dot3 c a))

/-- Ordered three-projector Bargmann holonomy. -/
def tripleHolonomy (a b c : V3) : Complex :=
  Matrix.trace (spinProjector a * spinProjector b * spinProjector c)

/-- Exact metric-plus-orientation decomposition of the triple holonomy. -/
theorem tripleHolonomy_formula (a b c : V3) :
    tripleHolonomy a b c =
      (((1 + dot3 a b + dot3 b c + dot3 c a) / 4 : Real) : Complex) +
        (I / 4) * ((dot3 a (cross3 b c) : Real) : Complex) := by
  unfold tripleHolonomy;
  unfold spinProjector pauliVec dot3 cross3;
  simp +decide [ Matrix.trace, Matrix.mul_apply, pauliX, pauliY, pauliZ ] ; ring;
  norm_num ; ring

/-- Reversing the ordered triple preserves the parity-even mass spread. -/
theorem massSpread3_reverse (a b c : V3) :
    massSpread3 a b c = massSpread3 a c b := by
  unfold massSpread3; ring;
  unfold dot3; ring;

/-- Reversing the ordered triple complex-conjugates its holonomy. -/
theorem tripleHolonomy_reverse (a b c : V3) :
    tripleHolonomy a c b = star (tripleHolonomy a b c) := by
  rw [tripleHolonomy_formula, tripleHolonomy_formula];
  simp +decide [ dot3, cross3, Complex.ext_iff ] ; ring;
  norm_num

/-- The imaginary component is exactly one quarter of the oriented scalar
triple product. -/
theorem tripleHolonomy_im (a b c : V3) :
    (tripleHolonomy a b c).im = dot3 a (cross3 b c) / 4 := by
  rw [tripleHolonomy_formula] ; norm_num ; ring;

def ex : V3 := ![1, 0, 0]
def ey : V3 := ![0, 1, 0]
def ez : V3 := ![0, 0, 1]

/-- Nondegenerate control: coordinate-axis order reversal keeps mass `6` and
changes `(1+i)/4` to `(1-i)/4`. -/
theorem coordinate_spiral_witness :
    massSpread3 ex ey ez = 6 ∧
      massSpread3 ex ez ey = 6 ∧
      tripleHolonomy ex ey ez = (1 + I) / 4 ∧
      tripleHolonomy ex ez ey = (1 - I) / 4 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · unfold massSpread3 dot3 ex ey ez; norm_num;
    erw [ Matrix.cons_val_succ' ] ; norm_num;
  · unfold ex ez ey massSpread3 dot3; norm_num;
    simp +zetaDelta at *;
    norm_num;
  · convert tripleHolonomy_formula ex ey ez using 1 ; norm_num [ ex, ey, ez, dot3, cross3 ];
    simp +zetaDelta at *;
    ring;
  · convert tripleHolonomy_formula ex ez ey using 1 ; ring;
    unfold dot3 cross3 ex ey ez; norm_num [ Complex.ext_iff ] ;
    simp +zetaDelta at *

/-- Packaged finite verdict: a pair of mirror celestial triples can have the
same nonzero mass spread and opposite nonzero handedness. -/
theorem exists_same_mass_opposite_handedness :
    ∃ a b c : V3,
      massSpread3 a b c = massSpread3 a c b ∧
      massSpread3 a b c ≠ 0 ∧
      (tripleHolonomy a b c).im = -(tripleHolonomy a c b).im ∧
      (tripleHolonomy a b c).im ≠ 0 := by
  use ex, ey, ez
  obtain ⟨h₁, h₂, h₃, h₄⟩ := coordinate_spiral_witness
  norm_num [ h₁, h₂, h₃, h₄ ]

end CelestialSpiralTriple
