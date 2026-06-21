import Mathlib
import PhysicsSM.Draft.SpinCoherentProjectorAristotle
import PhysicsSM.Draft.SpinorHelicityRankOneAristotle

/-!
# Draft.WeylCliffordBridgeAristotle

Aristotle handoff (wave 2): the bridge between the spin coherent projector
layer (`PhysicsSM.Draft.SpinCoherentProjectorAristotle`) and the
spinor-helicity layer (`PhysicsSM.Draft.SpinorHelicityRankOneAristotle`),
both proved in wave 1 and available s o r r y-free.

## Mathematical intent

WP2b of `Sources/Luminal_Motion_Checkerboard_Research_Program.md`: the 2x2
Weyl form of the Clifford algebra and the null-step/projector dictionary.

- `minkHerm p = sigma . p` and the second chirality
  `minkHermBar p = sigmabar . p = p0 - sigma . p`;
- the **Clifford relation** `(sigma.p)(sigmabar.p) = (p,p) 1` with `(p,p)`
  the Minkowski norm: the algebraic seed of the chirality-alternating
  Neumann series (each `S_0` numerator alternates `sigma`/`sigmabar`, and
  squaring along a ray reproduces the norm);
- the **trace pairing** `tr ((sigma.p)(sigmabar.k)) = 2 (p,k)`: the
  Minkowski inner product recovered from the spinor algebra;
- the **null-step factorization** `sigma.(r, r a) = 2r P(a)`: the numerator
  of the massless chiral propagator along a null step of direction `a` is
  the coherent projector -- the exact statement "spin transport along a
  null polygon is a product of coherent projectors" at the single-step
  level.  This is a polynomial identity: no unit-norm hypothesis is needed
  (the radius `r` simply scales).

## Conventions

Signature `(+,-,-,-)`; `minkHerm p = !![p0 + p3, p1 - i p2; p1 + i p2,
p0 - p3]` (from the spinor-helicity file); Pauli matrices and
`pauliVec`/`dot3` from the projector file; `minkHermBar` is defined below as
`sigmabar . p`, i.e. `!![p0 - p3, -(p1 - i p2); -(p1 + i p2), p0 + p3]`.

## Proof guidance

- Available s o r r y-free from the imports: `pauliVec_mul_pauliVec`,
  `spinProjector` lemmas (projector file); `minkHerm_conjTranspose`,
  `det_minkHerm`, `trace_minkHerm`, `minkHerm_rankOne_iff` and friends
  (helicity file).  Note the two files have *independent* Pauli-style
  definitions; the first target below is exactly the dictionary between
  them, and the later targets may be proved either entrywise or through it.
- Everything is entrywise 2x2 complex matrix algebra: `ext`, `fin_cases`,
  `simp [Matrix.mul_apply, minkHerm, ...]`, `push_cast`, `ring`.

Do not change any definition or statement of the imported wave-1 files.
Helper lemmas are welcome.  The final state should contain no placeholder
proof commands, no new assumptions, and no forbidden declarations.

This is draft code: the statements below contain documented handoff holes
and must not be imported from trusted code until they are eliminated.
-/

noncomputable section

namespace PhysicsSM.Draft.WeylCliffordBridge

open Matrix Complex
open PhysicsSM.Draft.SpinCoherentProjector
open PhysicsSM.Draft.SpinorHelicityRankOne

/-- The opposite-chirality Hermitian matrix `sigmabar . p = p0 - sigma . p`
of a real 4-vector (signature `(+,-,-,-)`). -/
def minkHermBar (p : Fin 4 → ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![((p 0 - p 3 : ℝ) : ℂ), -(((p 1 : ℝ) : ℂ) - ((p 2 : ℝ) : ℂ) * I);
     -(((p 1 : ℝ) : ℂ) + ((p 2 : ℝ) : ℂ) * I), ((p 0 + p 3 : ℝ) : ℂ)]

/-! ## Target 1: the dictionary between the two wave-1 files -/

/-- `minkHerm` (helicity file) decomposes as time component plus Pauli
vector (projector file): the convention bridge between the two layers. -/
theorem minkHerm_eq_smul_one_add_pauliVec (p : Fin 4 → ℝ) :
    minkHerm p
      = ((p 0 : ℝ) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ)
        + pauliVec ![p 1, p 2, p 3] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [minkHerm, pauliVec, pauliX, pauliY, pauliZ] <;> ring!

/-- The barred matrix is time component minus Pauli vector. -/
theorem minkHermBar_eq_smul_one_sub_pauliVec (p : Fin 4 → ℝ) :
    minkHermBar p
      = ((p 0 : ℝ) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ)
        - pauliVec ![p 1, p 2, p 3] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [minkHermBar, pauliVec, pauliX, pauliY, pauliZ, Matrix.sub_apply,
      Matrix.smul_apply, Complex.ext_iff]

/-! ## Target 2: the Clifford relation -/

/-- **Clifford relation**, first order: `(sigma.p)(sigmabar.p) = (p,p) 1`
with `(p,p)` the Minkowski norm.  The square of a chirality-alternating
two-step is the norm -- the seed of the zigzag Neumann series. -/
theorem minkHerm_mul_minkHermBar (p : Fin 4 → ℝ) :
    minkHerm p * minkHermBar p
      = (((p 0) ^ 2 - (p 1) ^ 2 - (p 2) ^ 2 - (p 3) ^ 2 : ℝ) : ℂ)
          • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [minkHerm, minkHermBar, Matrix.mul_apply] <;> ring
  · norm_num
    ring
  · norm_num
    ring

/-- **Clifford relation**, reversed order. -/
theorem minkHermBar_mul_minkHerm (p : Fin 4 → ℝ) :
    minkHermBar p * minkHerm p
      = (((p 0) ^ 2 - (p 1) ^ 2 - (p 2) ^ 2 - (p 3) ^ 2 : ℝ) : ℂ)
          • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [minkHerm, minkHermBar, Matrix.mul_apply] <;> ring!
  · norm_num [Complex.ext_iff, sq]
  · norm_num [Complex.ext_iff, sq]

/-! ## Target 3: the Minkowski trace pairing -/

/-- **Trace pairing.**  The Minkowski inner product is recovered from the
spinor algebra: `tr ((sigma.p)(sigmabar.k)) = 2 (p,k)`. -/
theorem trace_minkHerm_mul_minkHermBar (p k : Fin 4 → ℝ) :
    Matrix.trace (minkHerm p * minkHermBar k)
      = ((2 * (p 0 * k 0 - p 1 * k 1 - p 2 * k 2 - p 3 * k 3) : ℝ) : ℂ) := by
  simp only [minkHerm, minkHermBar, Matrix.trace, Matrix.diag, Matrix.mul_apply,
    Fin.sum_univ_two, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.of_apply, Matrix.empty_val', Matrix.cons_val_fin_one]
  apply Complex.ext <;> simp <;> ring

/-! ## Target 4: the null-step factorization -/

/-- **Null-step factorization.**  Along a null step of radius `r` and
direction `a`, the chiral numerator is `2r` times the coherent projector:
`sigma . (r, r a) = 2r P(a)`.  A polynomial identity -- no unit-norm
hypothesis (the projector interpretation of the right side of course
requires unit `a`, but the matrix identity does not). -/
theorem minkHerm_null_step (r : ℝ) (a : Fin 3 → ℝ) :
    minkHerm ![r, r * a 0, r * a 1, r * a 2]
      = ((2 * r : ℝ) : ℂ) • spinProjector a := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [minkHerm, spinProjector, pauliVec, pauliX, pauliY, pauliZ,
      Matrix.smul_apply, Matrix.add_apply] <;> ring!

end PhysicsSM.Draft.WeylCliffordBridge

end
