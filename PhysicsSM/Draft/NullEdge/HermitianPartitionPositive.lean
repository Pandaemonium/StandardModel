import Mathlib

/-!
# Nonzero partition function for a Hermitian generator (successor S0)

Isolatable (Mathlib-only) target certifying the Gibbs-state reading of
`PairModularSelection.balanced_gibbs_modular_flow`: for a Hermitian matrix `H`
and real `β`, the finite partition `tr exp(-β H)` is nonzero. Combined with
`ModularSelection.gibbs_modHam_exp` (which needs exactly `partition ≠ 0`), this
upgrades the balanced modular-Hamiltonian flow to a certified Gibbs-state
modular flow.

Mathematical content: writing `B = exp(-(β/2) H)` (Hermitian, since `-(β/2) H`
is Hermitian), the semigroup law gives `exp(-β H) = B * B = Bᴴ * B`, which is
positive semidefinite (`Matrix.posSemidef_conjTranspose_mul_self`) and nonzero
(`exp` is a unit), so its trace is nonzero
(`Matrix.PosSemidef.trace_eq_zero_iff`). This route avoids the matrix Loewner
order entirely.

Provenance: AFPL DYN-MODULAR-001 successor S0, interactive Claude (Fable),
2026-07-12.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HermitianPartitionPositive

open Matrix
open scoped ComplexOrder

/-- A real scalar multiple of a Hermitian matrix is Hermitian. -/
theorem real_smul_isHermitian {n : Type*} [Fintype n] [DecidableEq n]
    (H : Matrix n n ℂ) (hH : H.IsHermitian) (c : ℝ) :
    (((c : ℂ)) • H).IsHermitian := by
  show ((c : ℂ) • H)ᴴ = (c : ℂ) • H
  rw [conjTranspose_smul, hH.eq]
  simp [Complex.conj_ofReal]

/-- **Successor S0: nonzero Hermitian partition.**  For a Hermitian `H` and real
`β` over a nonempty index type, `tr exp(-β H) ≠ 0`.

The proof uses the dedicated matrix-exponential API. With
`B = exp((1/2)(-β H))`, Hermiticity gives `B = Bᴴ`, while `Matrix.exp_nsmul`
gives `exp(-β H) = B^2 = Bᴴ B`. The latter is positive semidefinite. Matrix
exponentials are units, so this matrix is nonzero, and a positive-semidefinite
matrix has zero trace exactly when it is zero.

Provenance: proof supplied by Aristotle task
`7b561cc8-f289-44bd-bd1c-7debc09b9325` and independently checked in the pinned
repository, 2026-07-12. -/
theorem hermitian_partition_ne_zero {n : Type*} [Fintype n] [DecidableEq n]
    [Nonempty n] (H : Matrix n n ℂ) (hH : H.IsHermitian) (β : ℝ) :
    (NormedSpace.exp ((-(β : ℂ)) • H)).trace ≠ 0 := by
  have hAH : ((-(β : ℂ)) • H).IsHermitian := by
    have := real_smul_isHermitian H hH (-β)
    simpa using this
  have hpsd : (NormedSpace.exp ((-(β : ℂ)) • H)).PosSemidef := by
    set A := ((-(β : ℂ)) • H) with hA
    have hhalf : (((1 : ℝ) / 2 : ℂ) • A).IsHermitian := by
      change (((1 : ℝ) / 2 : ℂ) • A)ᴴ = ((1 : ℝ) / 2 : ℂ) • A
      rw [conjTranspose_smul, hAH.eq]
      simp
    have hBh : (NormedSpace.exp (((1 : ℝ) / 2 : ℂ) • A)).IsHermitian := hhalf.exp
    have hA2 : A = (2 : ℕ) • (((1 : ℝ) / 2 : ℂ) • A) := by
      rw [two_nsmul, ← add_smul]
      norm_num
    have key :=
      posSemidef_conjTranspose_mul_self (NormedSpace.exp (((1 : ℝ) / 2 : ℂ) • A))
    rw [hBh.eq] at key
    have hexp : NormedSpace.exp A = (NormedSpace.exp (((1 : ℝ) / 2 : ℂ) • A)) ^ 2 := by
      conv_lhs => rw [hA2]
      exact Matrix.exp_nsmul 2 (((1 : ℝ) / 2 : ℂ) • A)
    rw [hexp, pow_two]
    exact key
  have hne : NormedSpace.exp ((-(β : ℂ)) • H) ≠ 0 := by
    have hu := Matrix.isUnit_exp ((-(β : ℂ)) • H)
    intro h
    rw [h] at hu
    exact not_isUnit_zero hu
  rw [Ne, hpsd.trace_eq_zero_iff]
  exact hne

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.HermitianPartitionPositive.hermitian_partition_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hermitian_partition_ne_zero

end PhysicsSM.Draft.NullEdge.HermitianPartitionPositive
