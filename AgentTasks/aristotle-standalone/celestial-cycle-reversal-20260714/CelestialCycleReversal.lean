import Mathlib

/-!
# General celestial-cycle reversal

Focused Aristotle handoff for an arbitrary finite ordered history of Hermitian
spin projectors.  Reversal of the history should take the ordered product to
its conjugate transpose and therefore complex-conjugate the traced holonomy.

The result is deliberately stated first for arbitrary Hermitian `2 x 2`
matrices and then specialized to Pauli coherent-state projectors.  This keeps
the reusable matrix lemma separate from the null-direction interpretation.

This standalone draft is Mathlib-only.  Proof placeholders are intentional
Aristotle handoff targets; theorem statements must not be weakened.
-/

noncomputable section

open Matrix Complex

namespace CelestialCycleReversal

abbrev V3 := Fin 3 -> Real
abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

def IsHermitian (A : M2) : Prop := Matrix.conjTranspose A = A

def holonomyTrace (xs : List M2) : Complex :=
  Matrix.trace xs.prod

/-- Conjugate transpose reverses a finite ordered matrix product. -/
theorem conjTranspose_list_prod (xs : List M2) :
    Matrix.conjTranspose xs.prod =
      (xs.reverse.map Matrix.conjTranspose).prod := by
  induction xs <;> aesop

/-- Trace commutes with conjugate transpose by complex conjugation. -/
theorem trace_conjTranspose (A : M2) :
    Matrix.trace (Matrix.conjTranspose A) = star (Matrix.trace A) := by
  simp +decide [ Matrix.trace ]

/-- For a list of Hermitian factors, reversing the list gives the conjugate
transpose of the original ordered product. -/
theorem reverse_prod_of_hermitian (xs : List M2)
    (hxs : ∀ A ∈ xs, IsHermitian A) :
    xs.reverse.prod = Matrix.conjTranspose xs.prod := by
  induction xs with
  | nil => simp
  | cons A xs ih =>
      have hA : IsHermitian A := hxs A (by simp)
      have htail : ∀ B ∈ xs, IsHermitian B := by
        intro B hB
        exact hxs B (by simp [hB])
      simp only [List.reverse_cons, List.prod_append, List.prod_cons,
        List.prod_nil, mul_one, Matrix.conjTranspose_mul]
      rw [ih htail, hA]

/-- Main arbitrary-cycle theorem: reversal complex-conjugates the traced
holonomy of any finite Hermitian history. -/
theorem holonomyTrace_reverse_of_hermitian (xs : List M2)
    (hxs : ∀ A ∈ xs, IsHermitian A) :
    holonomyTrace xs.reverse = star (holonomyTrace xs) := by
  convert trace_conjTranspose _;
  exact congr_arg Matrix.trace (reverse_prod_of_hermitian xs hxs)

def pauliX : M2 := !![0, 1; 1, 0]
def pauliY : M2 := !![0, -I; I, 0]
def pauliZ : M2 := !![1, 0; 0, -1]

def pauliVec (a : V3) : M2 :=
  (a 0 : Complex) • pauliX +
    (a 1 : Complex) • pauliY +
    (a 2 : Complex) • pauliZ

def spinProjector (a : V3) : M2 :=
  (2 : Complex)⁻¹ • ((1 : M2) + pauliVec a)

theorem spinProjector_hermitian (a : V3) :
    IsHermitian (spinProjector a) := by
  unfold IsHermitian spinProjector pauliVec pauliX pauliY pauliZ
  norm_num [Complex.ext_iff, Matrix.mul_apply]
  ring_nf
  norm_num
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [Complex.ext_iff]

/-- Specialization to any finite celestial direction history. -/
theorem spin_cycle_holonomy_reverse (directions : List V3) :
    holonomyTrace ((directions.reverse).map spinProjector) =
      star (holonomyTrace (directions.map spinProjector)) := by
  convert holonomyTrace_reverse_of_hermitian (List.map spinProjector directions) _ using 1
  · rw [List.map_reverse]
  · exact fun A hA => by
      obtain ⟨a, _ha, rfl⟩ := List.mem_map.mp hA
      exact spinProjector_hermitian a

/-- Consequently the real component is reversal-even and the imaginary
component is reversal-odd. -/
theorem spin_cycle_real_even_im_odd (directions : List V3) :
    (holonomyTrace ((directions.reverse).map spinProjector)).re =
        (holonomyTrace (directions.map spinProjector)).re ∧
      (holonomyTrace ((directions.reverse).map spinProjector)).im =
        -(holonomyTrace (directions.map spinProjector)).im := by
  convert spin_cycle_holonomy_reverse directions using 1
  simp +decide [Complex.ext_iff]

end CelestialCycleReversal
