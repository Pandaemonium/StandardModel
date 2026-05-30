import Mathlib
import PhysicsSM.Spinor.KrasnovQubitSplittingCoordinates
import PhysicsSM.Algebra.Octonion.ChosenComplexAlgebra
import PhysicsSM.Algebra.Octonion.ComplexTripleModule

/-!
# Spinor.KrasnovQubitComplexCoordinates

Complex-coordinate API for the octonionic qubit `𝕆² = (ℂ ⊕ ℂ³)²`.

## Mathematical context

The splitting `𝕆 = ℂ ⊕ ℂ³` determined by the chosen imaginary unit `e111`
lifts componentwise to `𝕆² = (ℂ ⊕ ℂ³)²`. Each component of `𝕆²` contributes
one `ℂ` (from the chosen complex line) and three `ℂ` (from the complement
triple), giving a total of `1 + 3 + 1 + 3 = 8` complex coordinates.

This module packages these coordinates into a clean `QubitComplexCoordinates`
record and proves that `rightMulE111` acts on these coordinates as:

- multiplication by `Complex.I` on the line coordinates,
- multiplication by `-Complex.I` on the complement coordinates.

## Claim boundary

This is only coordinate bookkeeping for `𝕆²`. No `Spin(9)` centralizer
theorem or Standard Model representation matching is claimed.

## Sources

- Krasnov, "SO(9) characterization of the Standard Model gauge group",
  J. Math. Phys. 62, 021703, 2021.
- Baez, "Can We Understand the Standard Model Using Octonions?", 2021.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Spinor.KrasnovComplexStructure

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Spinor.OctonionicQubit

/-! ## Complex-coordinate record -/

/-- The eight complex coordinates of an octonionic qubit `𝕆² = (ℂ ⊕ ℂ³)²`.

    - `fstLine` : the chosen-complex-line coordinate of the first 𝕆 component.
    - `fstComplement` : the three complement coordinates of the first 𝕆 component.
    - `sndLine` : the chosen-complex-line coordinate of the second 𝕆 component.
    - `sndComplement` : the three complement coordinates of the second 𝕆 component. -/
structure QubitComplexCoordinates where
  /-- Complex-line coordinate of the first component. -/
  fstLine : ℂ
  /-- Complement `ℂ³` coordinates of the first component. -/
  fstComplement : Fin 3 → ℂ
  /-- Complex-line coordinate of the second component. -/
  sndLine : ℂ
  /-- Complement `ℂ³` coordinates of the second component. -/
  sndComplement : Fin 3 → ℂ

/-! ## Extensionality for QubitComplexCoordinates -/

/-- Two `QubitComplexCoordinates` are equal iff all their fields agree. -/
@[ext]
theorem QubitComplexCoordinates.ext {a b : QubitComplexCoordinates}
    (h1 : a.fstLine = b.fstLine)
    (h2 : a.fstComplement = b.fstComplement)
    (h3 : a.sndLine = b.sndLine)
    (h4 : a.sndComplement = b.sndComplement) :
    a = b := by
  cases a; cases b; simp_all

/-! ## Conversion from splitting to complex coordinates -/

/-- Convert an `OctonionicQubitSplitting` to complex coordinates using
    `ChosenComplex.toComplex` and `ComplexTriple.toComplexVec`. -/
noncomputable def OctonionicQubitSplitting.toComplexCoordinates
    (s : OctonionicQubitSplitting) : QubitComplexCoordinates :=
  { fstLine := s.fst_line.toComplex
    fstComplement := s.fst_complement.toComplexVec
    sndLine := s.snd_line.toComplex
    sndComplement := s.snd_complement.toComplexVec }

/-- Convert an octonionic qubit directly to complex coordinates by
    splitting first. -/
noncomputable def toComplexCoordinates
    (q : OctonionicQubit) : QubitComplexCoordinates :=
  (splitQubit q).toComplexCoordinates

/-! ## Coordinate action of rightMulE111 -/

/-- The action of `rightMulE111` expressed in complex coordinates:
    multiplication by `Complex.I` on the line coordinates and
    multiplication by `-Complex.I` on the complement coordinates. -/
noncomputable def rightMulE111OnComplexCoordinates
    (c : QubitComplexCoordinates) : QubitComplexCoordinates :=
  { fstLine := Complex.I * c.fstLine
    fstComplement := fun k => -Complex.I * c.fstComplement k
    sndLine := Complex.I * c.sndLine
    sndComplement := fun k => -Complex.I * c.sndComplement k }

/-! ## Key lemmas: rotation maps to multiplication by I -/

/-- `rotateChosenComplexRight` maps to multiplication by `Complex.I`
    in the `toComplex` coordinates. -/
theorem rotateChosenComplexRight_toComplex (z : ChosenComplex) :
    (rotateChosenComplexRight z).toComplex = Complex.I * z.toComplex := by
  apply Complex.ext <;>
    simp [ChosenComplex.toComplex, Complex.I, Complex.mul_re, Complex.mul_im]

/-- `rotateComplexTripleRight` maps to multiplication by `-Complex.I`
    in the `toComplexVec` coordinates. -/
theorem rotateComplexTripleRight_toComplexVec (w : ComplexTriple) :
    (rotateComplexTripleRight w).toComplexVec =
      fun k => -Complex.I * w.toComplexVec k := by
  ext k
  fin_cases k <;>
    simp [ComplexTriple.toComplexVec, rotateComplexTripleRight,
          Complex.ext_iff, Complex.I, Complex.mul_re, Complex.mul_im,
          Complex.neg_re, Complex.neg_im]

/-! ## Main theorems -/

/-- The split-coordinate version: applying `rightMulE111OnSplitting` and
    then converting to complex coordinates is the same as converting first
    and then applying `rightMulE111OnComplexCoordinates`. -/
theorem splitting_toComplexCoordinates_rightMulE111OnSplitting
    (s : OctonionicQubitSplitting) :
    (rightMulE111OnSplitting s).toComplexCoordinates =
      rightMulE111OnComplexCoordinates s.toComplexCoordinates := by
  simp only [OctonionicQubitSplitting.toComplexCoordinates,
    rightMulE111OnSplitting, rightMulE111OnComplexCoordinates]
  exact QubitComplexCoordinates.ext
    (rotateChosenComplexRight_toComplex s.fst_line)
    (rotateComplexTripleRight_toComplexVec s.fst_complement)
    (rotateChosenComplexRight_toComplex s.snd_line)
    (rotateComplexTripleRight_toComplexVec s.snd_complement)

/-- Converting to complex coordinates commutes with `rightMulE111`:
    applying `rightMulE111` on `𝕆²` and then converting gives the same
    result as converting first and then applying the complex-coordinate
    action.

    ```
    𝕆²  ──rightMulE111──▶  𝕆²
     │                       │
     │ toComplexCoordinates  │ toComplexCoordinates
     ▼                       ▼
    ℂ⁸  ──rightMulE111OnComplexCoordinates──▶  ℂ⁸
    ```
-/
theorem toComplexCoordinates_rightMulE111
    (q : OctonionicQubit) :
    toComplexCoordinates (rightMulE111 q) =
      rightMulE111OnComplexCoordinates (toComplexCoordinates q) := by
  simp only [toComplexCoordinates]
  rw [splitQubit_rightMulE111]
  exact splitting_toComplexCoordinates_rightMulE111OnSplitting (splitQubit q)

/-! ## Dimension count -/

/-- The total number of complex coordinates: `1 + 3 + 1 + 3 = 8`.
    This reflects the fact that `𝕆²` has `2 × 8 = 16` real dimensions,
    which organize into `8` complex coordinates under the chosen
    complex structure. -/
theorem qubit_complex_coordinate_count :
    (1 : ℕ) + 3 + 1 + 3 = 8 := by norm_num

/-! ## Squared action: rightMulE111 squared is negation -/

/-- The complex-coordinate action of `rightMulE111` squares to negation
    on all coordinates. This is the complex-coordinate form of
    `rightMulE111_sq_neg`. -/
theorem rightMulE111OnComplexCoordinates_sq_neg
    (c : QubitComplexCoordinates) :
    rightMulE111OnComplexCoordinates
      (rightMulE111OnComplexCoordinates c) =
    { fstLine := -c.fstLine
      fstComplement := fun k => -c.fstComplement k
      sndLine := -c.sndLine
      sndComplement := fun k => -c.sndComplement k } := by
  simp only [rightMulE111OnComplexCoordinates]
  apply QubitComplexCoordinates.ext <;>
    (first | rfl | (try ext k)) <;>
    simp only [← mul_assoc, neg_mul, mul_neg, Complex.I_mul_I, neg_neg, one_mul]

end PhysicsSM.Spinor.KrasnovComplexStructure
