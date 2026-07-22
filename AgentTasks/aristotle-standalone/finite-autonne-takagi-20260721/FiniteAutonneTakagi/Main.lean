import FiniteAutonneTakagi.Partial

/-!
# Finite Autonne-Takagi factorization

This module isolates the remaining arbitrary-generation Majorana mass theorem.
For a complex symmetric finite matrix `A`, the target constructs a unitary
basis and nonnegative singular masses satisfying the phase-compatible equation

`A * U.transpose^H = U * diagonal(sigma)`.

The existing theorem
`FiniteTakagiMajoranaPartial.exists_autonneTakagi_of_phase_pairing` then turns
that equation into the Autonne-Takagi congruence

`A = U * diagonal(sigma) * U.transpose`.

Zero and repeated singular values are deliberately allowed. Excluding them
would remove exactly the eigenspaces in which the compatible phase choice is
subtle, and would not prove the physical arbitrary-generation statement.

Provenance: the theorem shape and convention follow Dieci, Papini, and
Pugliese, "Takagi factorization of matrices depending on parameters and
locating degeneracies of singular values", arXiv:2110.15918. This is a
clean-room Lean formalization target in the repository convention.

Draft status: the phase-pairing theorem is a documented proof handoff. The
second theorem is only its algebraic composition with the existing hole-free
partial spine. No physical flavor coefficients, mass scales, or pole masses
are selected by this factorization theorem.
-/

open scoped Matrix ComplexConjugate

set_option autoImplicit false
set_option maxHeartbeats 12000000
set_option maxRecDepth 10000

namespace PhysicsSM.Draft.NullEdge.FiniteAutonneTakagi

open PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial

/-- The phase-compatible singular basis for an arbitrary finite complex
symmetric matrix. This is the mathematical crux of the full Takagi theorem;
the statement includes zero and repeated singular values. -/
theorem exists_phase_paired_basis_of_symmetric (n : Nat)
    (A : Matrix (Fin n) (Fin n) Complex) (hsymm : A.transpose = A) :
    Exists fun (U : Matrix.unitaryGroup (Fin n) Complex) =>
      Exists fun (sigma : Fin n -> Real) =>
        (forall i, 0 <= sigma i) /\
          A * U.1.transposeᴴ =
            U.1 * Matrix.diagonal (fun i => (sigma i : Complex)) := by
  sorry

/-- **Finite Autonne-Takagi factorization.** Every finite complex symmetric
matrix is unitarily congruent to a nonnegative real diagonal matrix, without a
simple-spectrum or invertibility assumption. -/
theorem exists_autonneTakagi (n : Nat)
    (A : Matrix (Fin n) (Fin n) Complex) (hsymm : A.transpose = A) :
    Exists fun (U : Matrix.unitaryGroup (Fin n) Complex) =>
      Exists fun (sigma : Fin n -> Real) =>
        (forall i, 0 <= sigma i) /\
          A = U.1 * Matrix.diagonal (fun i => (sigma i : Complex)) *
            U.1.transpose := by
  exact exists_autonneTakagi_of_phase_pairing n A
    (exists_phase_paired_basis_of_symmetric n A hsymm)

end PhysicsSM.Draft.NullEdge.FiniteAutonneTakagi
