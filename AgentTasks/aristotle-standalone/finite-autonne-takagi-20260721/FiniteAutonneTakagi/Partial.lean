import Mathlib

/-!
# Finite Takagi mass semantics: proved partial spine

This module contains the hole-free part of an attempted finite
Autonne-Takagi formalization. For an arbitrary finite complex matrix it proves
the Hermitian spectral decomposition of `A^H A` with nonnegative square-root
data. It then isolates the exact additional phase-pairing equation sufficient
to assemble a Takagi congruence, proves the correctly oriented squared-mass
identity, and gives an exact counterexample to the tempting but false identity
that uses `star U` in the wrong position.

The full existence theorem for a symmetric matrix is not claimed here. The
remaining theorem must rotate the spectral basis inside zero and repeated
singular-value subspaces so that

`A * U.transpose^H = U * diagonal(sigma)`.

Ordinary Hermitian diagonalization of `A^H A` does not supply that compatible
phase choice by itself.

Provenance: Aristotle project `748c3102-79aa-4d7e-abec-a733b3c73b33`, task
`6e1d0e02-d137-4e94-a873-d281c7bb5798`, locally reviewed under the pinned
toolchain on 2026-07-21.

REPAIR NOTE (2026-07-21, Opus, after Codex reported a red root build,
`msg-20260721-081802-ec86258e`): the harvested artifact did NOT compile as
landed - two tactic steps failed at the pin. `grind` could not derive
eigenvalue nonnegativity (it has no route to positive-semidefiniteness of
`A^H A`), and the transposed-unitary cancellation was not closed by
`simp [Matrix.mul_apply, mul_comm]`. Both are now proved explicitly:
nonnegativity via `Matrix.posSemidef_conjTranspose_mul_self` plus
`Matrix.PosSemidef.eigenvalues_nonneg`, and the cancellation by transposing
`U * star U = 1` directly. No statement was changed - only the two proofs.
Process lesson: verify every harvested artifact by compiling it, not by
reading it.

The theorem shapes follow the Autonne-Takagi convention
`A = U * diagonal(sigma) * U.transpose`; see Dieci, Papini, and Pugliese,
arXiv:2110.15918. Claim grade M, [comp].
-/

open scoped Matrix ComplexConjugate

set_option autoImplicit false
set_option maxHeartbeats 8000000
set_option maxRecDepth 8000

namespace PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial

open scoped ComplexOrder in
/-- Eigenvalues of `A^H A` are nonnegative.

Isolated as its own lemma so that the `ComplexOrder` scope - required by
`Matrix.posSemidef_conjTranspose_mul_self`, which is stated for a
`StarOrderedRing` and therefore needs a `PartialOrder` on the scalars - is opened
for this fact alone and does not perturb `simp` elsewhere in the module. -/
theorem eigenvalues_conjTranspose_mul_self_nonneg (n : Nat)
    (A : Matrix (Fin n) (Fin n) Complex)
    (h : Matrix.IsHermitian (Aᴴ * A)) (i : Fin n) :
    0 <= h.eigenvalues i :=
  (Matrix.posSemidef_conjTranspose_mul_self A).eigenvalues_nonneg i

/-- The positive Hermitian squared-mass matrix `A^H A` has a unitary
eigenbasis with nonnegative square-root diagonal data. Zero and repeated
values are not excluded. -/
theorem exists_squared_singular_basis (n : Nat)
    (A : Matrix (Fin n) (Fin n) Complex) :
    Exists fun (U : Matrix.unitaryGroup (Fin n) Complex) =>
      Exists fun (sigma : Fin n -> Real) =>
        (forall i, 0 <= sigma i) /\
          star U.1 * (Aᴴ * A) * U.1 =
            Matrix.diagonal (fun i => ((sigma i) ^ 2 : Complex)) := by
  obtain ⟨U, V, h_diag⟩ :
      Exists fun U : Matrix.unitaryGroup (Fin n) Complex =>
        Exists fun V : Fin n -> Real =>
          (forall i, 0 <= V i) /\
            star U.val * (Aᴴ * A) * U.val =
              Matrix.diagonal (fun i => (V i : Complex)) := by
    obtain ⟨U, V, h_diag⟩ :
        Exists fun U : Matrix (Fin n) (Fin n) Complex =>
          Exists fun V : Fin n -> Real =>
            U * U.conjTranspose = 1 /\
              U.conjTranspose * U = 1 /\
              Aᴴ * A =
                U * Matrix.diagonal (fun i => (V i : Complex)) *
                  U.conjTranspose /\
              (forall i, 0 <= V i) := by
      have hspec := Matrix.IsHermitian.spectral_theorem
        (show Matrix.IsHermitian (Aᴴ * A) by
          norm_num [Matrix.IsHermitian, Matrix.mul_assoc])
      refine ⟨_, _, ?_, ?_, hspec, ?_⟩
      · simp [Matrix.IsHermitian.eigenvectorUnitary]
      · simp [Matrix.IsHermitian.eigenvectorUnitary]
      · intro i
        simpa using eigenvalues_conjTranspose_mul_self_nonneg n A _ i
    refine ⟨⟨U, ?_, ?_⟩, V, h_diag.2.2.2, ?_⟩ <;>
      simp_all [Matrix.mul_assoc]
    · convert h_diag.2.1 using 1
    · convert h_diag.1 using 1
    · simp_all [← Matrix.mul_assoc, Matrix.star_eq_conjTranspose]
  refine ⟨U, fun i => Real.sqrt (V i), ?_, ?_⟩ <;>
    simp_all [Real.sq_sqrt]
  exact fun i => by
    rw [← Complex.ofReal_pow, Real.sq_sqrt (h_diag.1 i)]

/-- Algebraic assembly of a Takagi factorization from a phase-compatible
singular basis. -/
theorem takagi_of_phase_paired_basis (n : Nat)
    (A U : Matrix (Fin n) (Fin n) Complex) (sigma : Fin n -> Real)
    (hU : U ∈ Matrix.unitaryGroup (Fin n) Complex)
    (hpair : A * U.transposeᴴ =
      U * Matrix.diagonal (fun i => (sigma i : Complex))) :
    A = U * Matrix.diagonal (fun i => (sigma i : Complex)) * U.transpose := by
  have h_apply :
      A * Uᵀᴴ * Uᵀ =
        (U * Matrix.diagonal (fun i => (sigma i : Complex))) * Uᵀ := by
    rw [hpair]
  have h_cancel : Uᵀᴴ * Uᵀ = 1 := by
    have h := congrArg Matrix.transpose hU.2
    rw [Matrix.transpose_mul, Matrix.transpose_one] at h
    simpa [Matrix.star_eq_conjTranspose] using h
  rw [← h_apply, Matrix.mul_assoc, h_cancel, Matrix.mul_one]

/-- A supplied nonnegative phase-paired basis is sufficient for the full
Autonne-Takagi congruence, including zero and repeated diagonal values. -/
theorem exists_autonneTakagi_of_phase_pairing (n : Nat)
    (A : Matrix (Fin n) (Fin n) Complex)
    (hpair : Exists fun (U : Matrix.unitaryGroup (Fin n) Complex) =>
      Exists fun (sigma : Fin n -> Real) =>
        (forall i, 0 <= sigma i) /\
          A * U.1.transposeᴴ =
            U.1 * Matrix.diagonal (fun i => (sigma i : Complex))) :
    Exists fun (U : Matrix.unitaryGroup (Fin n) Complex) =>
      Exists fun (sigma : Fin n -> Real) =>
        (forall i, 0 <= sigma i) /\
          A = U.1 * Matrix.diagonal (fun i => (sigma i : Complex)) *
            U.1.transpose := by
  obtain ⟨U, sigma, hsigma, hpair⟩ := hpair
  refine ⟨U, sigma, hsigma, ?_⟩
  exact takagi_of_phase_paired_basis n A U sigma U.2 hpair

/-- Correct squared-mass identity from a Takagi witness. The leftmost factor
is entrywise conjugation `U.transpose^H`, not matrix star `U^H`. -/
theorem takagi_squared_mass_identity_corrected (n : Nat)
    (A U : Matrix (Fin n) (Fin n) Complex) (sigma : Fin n -> Real)
    (hU : U ∈ Matrix.unitaryGroup (Fin n) Complex)
    (hA : A =
      U * Matrix.diagonal (fun i => (sigma i : Complex)) * U.transpose) :
    Aᴴ * A =
      U.transposeᴴ *
        Matrix.diagonal (fun i => ((sigma i) ^ 2 : Complex)) *
          U.transpose := by
  simp_all [← mul_assoc, sq]
  simp_all [show Uᴴ * U = 1 from hU.1, Matrix.mul_assoc]

/-- Exact `2 x 2` counterexample to the universally quantified identity with
the incorrectly oriented left factor `star U`. -/
theorem not_forall_takagi_squared_mass_identity :
    Not (forall (A U : Matrix (Fin 2) (Fin 2) Complex)
      (sigma : Fin 2 -> Real),
      U ∈ Matrix.unitaryGroup (Fin 2) Complex ->
      A = U * Matrix.diagonal (fun i => (sigma i : Complex)) * U.transpose ->
      Aᴴ * A =
        star U * Matrix.diagonal (fun i => ((sigma i) ^ 2 : Complex)) *
          U.transpose) := by
  simp +zetaDelta at *
  refine ⟨Matrix.of fun i j =>
    if i = 0 ∧ j = 1 then -1 else if i = 1 ∧ j = 0 then 1 else 0, ?_, ?_⟩
  · constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Matrix.adjugate_apply, Matrix.det_fin_two]
  · refine ⟨fun i => if i = 0 then 1 else 2, ?_⟩
    norm_num [← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply]

end PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial
