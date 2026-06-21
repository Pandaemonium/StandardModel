import Mathlib
import PhysicsSM.Spinor.KrasnovComplexStructure

/-!
# Spinor.KrasnovQubitSplittingCoordinates

Coordinate-level behavior of the complex structure `J = R_{e111}` on the
`(ℂ ⊕ ℂ³)²` splitting of `𝕆²`.

## Mathematical context

The octonionic qubit `𝕆²` splits componentwise as `(ℂ ⊕ ℂ³)²` via the
chosen complex line determined by `e111`. Right multiplication by `e111` acts
on each piece:

- On the `ℂ` pieces: rotation by 90° (multiplication by `i`), i.e.,
  `(re, im) ↦ (-im, re)`.
- On the `ℂ³` pieces: the *conjugate* complex structure (`-J`), i.e.,
  `(Re, Im) ↦ (Im, -Re)` on each complex coordinate.

This module defines the induced rotations on `ChosenComplex` and
`ComplexTriple`, assembles them into the action on `OctonionicQubitSplitting`,
and proves:

1. `splitQubit_rightMulE111`: splitting commutes with `rightMulE111`.
2. `rightMulE111OnSplitting_sq_neg`: the split action squares to minus
   the identity.
3. `rightMulE111OnSplitting_toQubit`: reconstruction is compatible with
   the split action.

## Claim boundary

This is only the coordinate behavior of the complex structure on `𝕆²`.
No `Spin(9)` centralizer theorem or Standard Model representation matching
is claimed.

## Sources

- Krasnov, "SO(9) characterization of the Standard Model gauge group",
  J. Math. Phys. 62, 021703, 2021.
- Baez, "Can We Understand the Standard Model Using Octonions?", 2021.

Status: trusted — no `s o r r y`.
-/

namespace PhysicsSM.Spinor.KrasnovComplexStructure

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Spinor.OctonionicQubit

/-! ## Rotation definitions on coordinate pieces -/

/-- Rotation by 90° on the chosen complex line: `(re, im) ↦ (-im, re)`.
    This is multiplication by `i` in the chosen copy of `ℂ`. -/
def rotateChosenComplexRight (z : ChosenComplex) : ChosenComplex :=
  { re := -z.im, im := z.re }

/-- The conjugate complex structure on the complement triple:
    `(Re, Im) ↦ (Im, -Re)` on each complex coordinate.
    This is multiplication by `-i` in the complement `ℂ³`. -/
def rotateComplexTripleRight (w : ComplexTriple) : ComplexTriple :=
  { w1_re := w.w1_im,  w1_im := -w.w1_re,
    w2_re := w.w2_im,  w2_im := -w.w2_re,
    w3_re := w.w3_im,  w3_im := -w.w3_re }

/-- The induced action of `rightMulE111` on a split qubit. -/
def rightMulE111OnSplitting
    (s : OctonionicQubitSplitting) : OctonionicQubitSplitting :=
  { fst_line := rotateChosenComplexRight s.fst_line
    fst_complement := rotateComplexTripleRight s.fst_complement
    snd_line := rotateChosenComplexRight s.snd_line
    snd_complement := rotateComplexTripleRight s.snd_complement }

/-! ## Component simp lemmas -/

@[simp] theorem rotateChosenComplexRight_re (z : ChosenComplex) :
    (rotateChosenComplexRight z).re = -z.im := rfl

@[simp] theorem rotateChosenComplexRight_im (z : ChosenComplex) :
    (rotateChosenComplexRight z).im = z.re := rfl

@[simp] theorem rotateComplexTripleRight_w1_re (w : ComplexTriple) :
    (rotateComplexTripleRight w).w1_re = w.w1_im := rfl

@[simp] theorem rotateComplexTripleRight_w1_im (w : ComplexTriple) :
    (rotateComplexTripleRight w).w1_im = -w.w1_re := rfl

@[simp] theorem rotateComplexTripleRight_w2_re (w : ComplexTriple) :
    (rotateComplexTripleRight w).w2_re = w.w2_im := rfl

@[simp] theorem rotateComplexTripleRight_w2_im (w : ComplexTriple) :
    (rotateComplexTripleRight w).w2_im = -w.w2_re := rfl

@[simp] theorem rotateComplexTripleRight_w3_re (w : ComplexTriple) :
    (rotateComplexTripleRight w).w3_re = w.w3_im := rfl

@[simp] theorem rotateComplexTripleRight_w3_im (w : ComplexTriple) :
    (rotateComplexTripleRight w).w3_im = -w.w3_re := rfl

/-! ## Main theorems -/

/-- Splitting commutes with `rightMulE111`: applying `rightMulE111` and then
    splitting gives the same result as splitting first and then applying
    the coordinate-level rotation `rightMulE111OnSplitting`.

    This says that the diagram

    ```
    𝕆²  ──rightMulE111──▶  𝕆²
     │                       │
     │ splitQubit             │ splitQubit
     ▼                       ▼
    (ℂ⊕ℂ³)² ──rightMulE111OnSplitting──▶ (ℂ⊕ℂ³)²
    ```

    commutes.
-/
theorem splitQubit_rightMulE111
    (q : OctonionicQubit) :
    splitQubit (rightMulE111 q) =
      rightMulE111OnSplitting (splitQubit q) := by
  simp only [splitQubit, rightMulE111, rightMulE111OnSplitting,
    rotateChosenComplexRight, rotateComplexTripleRight]
  congr 1 <;> (try ext) <;>
    simp [e111, Octonion.toChosenComplex, Octonion.toComplexTriple]

/-- The split action squares to negation on each component.

    This is the coordinate form of `rightMulE111_sq_neg` from
    `OctonionicQubit.lean`, expressed in splitting coordinates. -/
theorem rightMulE111OnSplitting_sq_neg
    (s : OctonionicQubitSplitting) :
    rightMulE111OnSplitting (rightMulE111OnSplitting s) =
      { fst_line := -s.fst_line
        fst_complement := -s.fst_complement
        snd_line := -s.snd_line
        snd_complement := -s.snd_complement } := by
  simp only [rightMulE111OnSplitting, rotateChosenComplexRight,
    rotateComplexTripleRight]
  congr 1

/-- Reconstruction is compatible with the split action: reconstructing
    a rotated splitting gives the same qubit as rotating the reconstructed
    qubit.

    This says that the diagram

    ```
    (ℂ⊕ℂ³)² ──rightMulE111OnSplitting──▶ (ℂ⊕ℂ³)²
     │                                      │
     │ toQubit                               │ toQubit
     ▼                                      ▼
    𝕆²  ──────rightMulE111──────▶          𝕆²
    ```

    commutes.
-/
theorem rightMulE111OnSplitting_toQubit
    (s : OctonionicQubitSplitting) :
    (rightMulE111OnSplitting s).toQubit =
      rightMulE111 s.toQubit := by
  simp only [rightMulE111OnSplitting, OctonionicQubitSplitting.toQubit,
    rightMulE111, rotateChosenComplexRight, rotateComplexTripleRight]
  ext <;> simp [ChosenComplex.toOctonion, ComplexTriple.toOctonion, e111]

end PhysicsSM.Spinor.KrasnovComplexStructure
