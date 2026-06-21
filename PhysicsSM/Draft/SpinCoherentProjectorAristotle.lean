import Mathlib

/-!
# Draft.SpinCoherentProjectorAristotle

Aristotle handoff: the exact algebraic identities for spin-1/2 coherent-state
projectors `P(a) = (1 + sigma . a) / 2` on `Matrix (Fin 2) (Fin 2) C`.

## Mathematical intent

WP3 of `Sources/Luminal_Motion_Checkerboard_Research_Program.md`: in the
null-polygon expansion of the 3+1D Dirac propagator, the numerator of the
massless chiral propagator along a null step of direction `a` is the
rank-one projector `P(a)`, and the spin transport along a polygon is a
product of such projectors.  The two structural facts are:

- the **sandwich collapse** `P(a) P(b) P(a) = ((1 + a.b)/2) P(a)`, whose
  scalar is the squared modulus of the spin-coherent overlap (the "bending
  suppression" of Foster--Jacobson, arXiv:1610.01142), and
- the **Bargmann invariant** `tr (P(a) P(b) P(c))
  = (1 + a.b + b.c + c.a + i a.(b x c)) / 4`, whose argument is half the
  signed solid angle of the geodesic triangle `(a, b, c)` on the direction
  sphere -- the discrete Berry/Pancharatnam phase.  The identity itself is a
  *polynomial* identity in the components, requiring no unit-norm
  hypotheses (oracle-checked with non-unit vectors).

These are finite-dimensional matrix algebra, independent of any analysis,
and are the reusable Berry-phase layer for the checkerboard program.
All statements were validated numerically in
`Scripts/oracle/validate_checkerboard.py` (section "Pauli projector
identities"); the oracle justifies the statements, not the proofs.

## Conventions

- Pauli matrices in the standard basis:
  `pauliX = !![0, 1; 1, 0]`, `pauliY = !![0, -I; I, 0]`,
  `pauliZ = !![1, 0; 0, -1]`.
- Real 3-vectors are `Fin 3 -> R`; `dot3` and `cross3` are the Euclidean
  dot and cross products with the right-handed orientation
  (`cross3 a b 0 = a 1 * b 2 - a 2 * b 1`, etc.).
- `spinProjector a = (1/2) (1 + sigma . a)`; it is an idempotent only when
  `dot3 a a = 1`, and the norm hypotheses below are exactly the needed ones
  (the trace and Bargmann identities are hypothesis-free).

## Proof guidance

- Everything should reduce to entrywise computation: `ext i j`,
  `fin_cases i <;> fin_cases j`, then `simp [Matrix.mul_apply, Fin.sum_univ_succ, ...]`
  followed by `Complex.ext` + `ring` (or `push_cast` and `ring`).  The
  hypotheses `dot3 a a = 1` enter through `nlinarith`-free linear
  substitution: rewrite `a 0 * a 0 = 1 - a 1 * a 1 - a 2 * a 2` style facts
  with `linear_combination` if plain `ring` does not close the goal.
- `pauliVec_mul_pauliVec` (`sigma.a sigma.b = (a.b) 1 + i sigma.(a x b)`) is
  the master identity; the sandwich and Bargmann targets follow from it by
  ring algebra in the (commutative) scalar coefficients, but a direct
  entrywise computation is also acceptable.
- For the determinant target use the explicit 2x2 formula
  (`Matrix.det_fin_two`).

Helper lemmas are welcome. The final state should contain no placeholder
proof commands, no new assumptions, and no forbidden declarations.

This draft file now contains kernel-checked proofs of the submitted targets.
-/

noncomputable section

namespace PhysicsSM.Draft.SpinCoherentProjector

open Matrix Complex

/-! ## Pauli matrices and real 3-vector algebra -/

/-- First Pauli matrix. -/
def pauliX : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- Second Pauli matrix. -/
def pauliY : Matrix (Fin 2) (Fin 2) ℂ := !![0, -I; I, 0]

/-- Third Pauli matrix. -/
def pauliZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- The Pauli vector `sigma . a` of a real 3-vector `a`. -/
def pauliVec (a : Fin 3 → ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (a 0 : ℂ) • pauliX + (a 1 : ℂ) • pauliY + (a 2 : ℂ) • pauliZ

/-- Euclidean dot product on real 3-vectors. -/
def dot3 (a b : Fin 3 → ℝ) : ℝ := a 0 * b 0 + a 1 * b 1 + a 2 * b 2

/-- Right-handed cross product on real 3-vectors. -/
def cross3 (a b : Fin 3 → ℝ) : Fin 3 → ℝ :=
  ![a 1 * b 2 - a 2 * b 1, a 2 * b 0 - a 0 * b 2, a 0 * b 1 - a 1 * b 0]

/-- The spin-1/2 coherent-state projector onto direction `a`:
`P(a) = (1 + sigma . a) / 2`.  A projector when `dot3 a a = 1`. -/
def spinProjector (a : Fin 3 → ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  ((1 : ℂ) / 2) • (1 + pauliVec a)

/-! ## Target 1: the Pauli product master identity -/

/-- **Pauli product identity**: `sigma.a sigma.b = (a.b) 1 + i sigma.(a x b)`.
A polynomial identity, no norm hypotheses. -/
theorem pauliVec_mul_pauliVec (a b : Fin 3 → ℝ) :
    pauliVec a * pauliVec b
      = (dot3 a b : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ)
        + I • pauliVec (cross3 a b) := by
  unfold pauliVec cross3 dot3
  norm_num [ Fin.sum_univ_succ, Matrix.mul_apply, Matrix.add_apply, Matrix.smul_apply ] ; ring
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [ Matrix.mul_apply, pauliX, pauliY, pauliZ ] <;> ring
  · erw [ Matrix.cons_val_succ' ] ; norm_num ; ring!;
  · norm_num ; ring;
  · norm_num ; ring;
  · erw [ Matrix.cons_val_succ' ] ; norm_num ; ring

/-- The Pauli vector of a real vector is Hermitian. -/
theorem pauliVec_conjTranspose (a : Fin 3 → ℝ) :
    (pauliVec a)ᴴ = pauliVec a := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ pauliVec, pauliX, pauliY, pauliZ ] ;

/-! ## Target 2: projector structure -/

/-- The coherent-state projector is Hermitian. -/
theorem spinProjector_conjTranspose (a : Fin 3 → ℝ) :
    (spinProjector a)ᴴ = spinProjector a := by
  -- The conjugate transpose of the projector is the projector itself.
  simp [spinProjector, pauliVec_conjTranspose]

/-- The coherent-state projector has trace `1` (no norm hypothesis). -/
theorem trace_spinProjector (a : Fin 3 → ℝ) :
    Matrix.trace (spinProjector a) = 1 := by
  unfold spinProjector pauliVec pauliX pauliY pauliZ;
  norm_num [ Matrix.trace ];
  ring

/-- On the unit sphere, `P(a)` is idempotent. -/
theorem spinProjector_mul_self (a : Fin 3 → ℝ) (ha : dot3 a a = 1) :
    spinProjector a * spinProjector a = spinProjector a := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [ Complex.ext_iff, Matrix.mul_apply, spinProjector, pauliVec, pauliX, pauliY,
      pauliZ, dot3 ];
  · exact ⟨ by rw [ dot3 ] at ha; linarith, by ring ⟩;
  · constructor <;> ring;
  · constructor <;> ring;
  · exact ⟨ by rw [ dot3 ] at ha; linarith, by ring ⟩

/-- On the unit sphere, `P(a)` is singular (rank one). -/
theorem det_spinProjector (a : Fin 3 → ℝ) (ha : dot3 a a = 1) :
    (spinProjector a).det = 0 := by
  unfold spinProjector pauliVec dot3 at *;
  norm_num [ Matrix.det_fin_two, pauliX, pauliY, pauliZ ];
  ring ; norm_num [ Complex.ext_iff, sq ] ; linarith

/-! ## Target 3: the sandwich collapse (overlap modulus) -/

/-- **Sandwich collapse**: `P(a) P(b) P(a) = ((1 + a.b)/2) P(a)` whenever
`a` is a unit vector (`b` need not be).  The scalar `(1 + a.b)/2` is the
squared modulus of the spin-coherent overlap; iterating this identity along
a null polygon produces the bending-suppression factors of the
Foster--Jacobson checkerboard. -/
theorem spinProjector_sandwich (a b : Fin 3 → ℝ) (ha : dot3 a a = 1) :
    spinProjector a * spinProjector b * spinProjector a
      = (((1 + dot3 a b) / 2 : ℝ) : ℂ) • spinProjector a := by
  have ha' : a 0 * a 0 + a 1 * a 1 + a 2 * a 2 = 1 := ha
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp only [spinProjector, Matrix.mul_apply, Fin.sum_univ_two, Matrix.smul_apply,
      Matrix.add_apply, Matrix.one_apply, pauliVec, pauliX, pauliY, pauliZ, dot3,
      smul_eq_mul, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.of_apply,
      Matrix.cons_val', Matrix.empty_val', Matrix.cons_val_fin_one] <;>
    (apply Complex.ext <;> simp <;> ring_nf) <;>
    (first
      | linear_combination ((1 - b 2) / 8) * ha'
      | linear_combination ((1 + b 0 + b 2) / 8) * ha'
      | linear_combination (-b 0 / 8) * ha'
      | linear_combination (b 1 / 8) * ha'
      | linear_combination (-b 1 / 8) * ha'
      | linear_combination ((1 + b 2) / 8) * ha')

/-! ## Target 4: the Bargmann invariant (discrete Berry phase) -/

/-- **Bargmann invariant.**  The trace of a cyclic triple product of
coherent-state projectors:

`tr (P(a) P(b) P(c)) = (1 + a.b + b.c + c.a + i a.(b x c)) / 4`.

This is a polynomial identity (no norm hypotheses).  For unit vectors its
argument is minus half the signed solid angle of the spherical triangle
`(a, b, c)`: the discrete Berry/Pancharatnam holonomy that constitutes the
spin factor of the 3+1D checkerboard. -/
theorem trace_spinProjector_triple (a b c : Fin 3 → ℝ) :
    Matrix.trace (spinProjector a * spinProjector b * spinProjector c)
      = (((1 + dot3 a b + dot3 b c + dot3 c a) / 4 : ℝ) : ℂ)
        + (I / 4) * ((dot3 a (cross3 b c) : ℝ) : ℂ) := by
  simp only [spinProjector, Matrix.trace, Matrix.diag, Matrix.mul_apply, Fin.sum_univ_two,
    Matrix.smul_apply, Matrix.add_apply, Matrix.one_apply, pauliVec, pauliX, pauliY, pauliZ,
    dot3, cross3, smul_eq_mul, Matrix.cons_val_zero, Matrix.cons_val_one]
  apply Complex.ext <;> simp <;> ring

end PhysicsSM.Draft.SpinCoherentProjector

end
