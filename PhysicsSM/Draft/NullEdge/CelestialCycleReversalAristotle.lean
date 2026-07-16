import Mathlib

/-!
# Celestial cycle reversal

This draft module proves that reversing any finite ordered history of
Hermitian two-by-two matrices conjugates its traced holonomy.  It then
specializes the result to Pauli spin-coherent projectors, making the real
part reversal-even and the imaginary part reversal-odd for an arbitrary
finite celestial direction history.

This is an ordered-holonomy theorem, not a claim that the history has a
nonzero phase or that its phase produces mass.

## Conventions and provenance

The Pauli matrices use the standard right-handed convention, with real
three-vectors represented by `Fin 3 -> Real`.  Aristotle project
`af713970-d97a-413c-979f-cdb47f1e15ad` supplied the proof bodies.  The
returned declarations preserved every submitted signature and were checked
with the pinned Lean toolchain on 2026-07-14.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.CelestialCycleReversal

abbrev V3 := Fin 3 -> Real
abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

/-- Hermiticity for the fixed two-by-two complex matrix space. -/
def IsHermitian (A : M2) : Prop := Matrix.conjTranspose A = A

/-- Trace of the ordered product of a finite matrix history. -/
def holonomyTrace (xs : List M2) : Complex :=
  Matrix.trace xs.prod

/-- Conjugate transpose reverses a finite ordered matrix product. -/
theorem conjTranspose_list_prod (xs : List M2) :
    Matrix.conjTranspose xs.prod =
      (xs.reverse.map Matrix.conjTranspose).prod := by
  induction xs <;> aesop

/-- Trace of a conjugate transpose is the conjugate trace. -/
theorem trace_conjTranspose (A : M2) :
    Matrix.trace (Matrix.conjTranspose A) = star (Matrix.trace A) := by
  simp +decide [Matrix.trace]

/-- Reversing Hermitian factors gives the conjugate-transposed product. -/
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

/-- Reversal conjugates the traced holonomy of any Hermitian history. -/
theorem holonomyTrace_reverse_of_hermitian (xs : List M2)
    (hxs : ∀ A ∈ xs, IsHermitian A) :
    holonomyTrace xs.reverse = star (holonomyTrace xs) := by
  convert trace_conjTranspose _
  exact congr_arg Matrix.trace (reverse_prod_of_hermitian xs hxs)

/-- First Pauli matrix. -/
def pauliX : M2 := !![0, 1; 1, 0]

/-- Second Pauli matrix. -/
def pauliY : M2 := !![0, -I; I, 0]

/-- Third Pauli matrix. -/
def pauliZ : M2 := !![1, 0; 0, -1]

/-- Pauli contraction with a real three-vector. -/
def pauliVec (a : V3) : M2 :=
  (a 0 : Complex) • pauliX +
    (a 1 : Complex) • pauliY +
    (a 2 : Complex) • pauliZ

/-- Spin-coherent matrix `(1 + sigma.a)/2`. -/
def spinProjector (a : V3) : M2 :=
  (2 : Complex)⁻¹ • ((1 : M2) + pauliVec a)

/-- Every real-direction spin-coherent matrix is Hermitian. -/
theorem spinProjector_hermitian (a : V3) :
    IsHermitian (spinProjector a) := by
  unfold IsHermitian spinProjector pauliVec pauliX pauliY pauliZ
  norm_num [Complex.ext_iff, Matrix.mul_apply]
  ring_nf
  norm_num
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [Complex.ext_iff]

/-- Reversing any finite celestial projector history conjugates its trace. -/
theorem spin_cycle_holonomy_reverse (directions : List V3) :
    holonomyTrace ((directions.reverse).map spinProjector) =
      star (holonomyTrace (directions.map spinProjector)) := by
  convert holonomyTrace_reverse_of_hermitian (List.map spinProjector directions) _ using 1
  · rw [List.map_reverse]
  · exact fun A hA => by
      obtain ⟨a, _ha, rfl⟩ := List.mem_map.mp hA
      exact spinProjector_hermitian a

/-- Reversal preserves the real part and negates the imaginary part. -/
theorem spin_cycle_real_even_im_odd (directions : List V3) :
    (holonomyTrace ((directions.reverse).map spinProjector)).re =
        (holonomyTrace (directions.map spinProjector)).re ∧
      (holonomyTrace ((directions.reverse).map spinProjector)).im =
        -(holonomyTrace (directions.map spinProjector)).im := by
  convert spin_cycle_holonomy_reverse directions using 1
  simp +decide [Complex.ext_iff]

end PhysicsSM.Draft.NullEdge.CelestialCycleReversal

end
