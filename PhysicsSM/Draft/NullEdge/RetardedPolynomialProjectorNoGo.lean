import Mathlib

/-!
# Retarded polynomial-projector no-go

This module proves the algebraic half of a no-go test for selecting a
four-dimensional probe sector directly from a finite retarded causal operator.
An idempotent polynomial filter of a scalar-plus-nilpotent endomorphism is
necessarily zero or the identity.

The result does not by itself identify any project causal operator as scalar
plus nilpotent. That graph-specific bridge is a separate target. It also does
not exclude normal or Hermitian operators, retarded/advanced pairs,
non-polynomial functional calculus, or richer probe representations.

Provenance: the two public statements were prepared in the project and proved
unchanged by Aristotle project `1c4479b1-3215-4d68-a5f1-6bfd9fb13aae`, task
`4c91507a-68ae-4387-b52b-05925c300907`. The returned proof was checked under
the pinned toolchain before integration.

Claim grade: `M [orig/comp]`, abstract real-linear algebra only.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RetardedPolynomialProjectorNoGo

open Polynomial

variable {M : Type*}
  [AddCommGroup M] [Module Real M] [Nontrivial M]

set_option maxHeartbeats 800000

/-- An idempotent endomorphism lying in one scalar-plus-nilpotent generalized
eigenspace is trivial. -/
theorem idempotent_eq_zero_or_id_of_sub_scalar_nilpotent
    (P : Module.End Real M) (c : Real) (k : Nat) (hk : 0 < k)
    (hidempotent : P.comp P = P)
    (hnilpotent : (P - c • LinearMap.id) ^ k = 0) :
    P = 0 ∨ P = LinearMap.id := by
  by_cases h : c * (c - 1) = 0 <;>
    simp_all +decide [sub_eq_iff_eq_add]
  · cases h <;> simp_all +decide [sub_eq_iff_eq_add]
    · cases k <;> simp_all +decide [pow_succ, LinearMap.ext_iff]
      induction ‹Nat› <;> simp_all +decide [pow_succ, LinearMap.ext_iff]
    · have hP_minus_I_sq :
          (P - LinearMap.id) ^ 2 = LinearMap.id - P := by
        simp_all +decide [sq, sub_mul, mul_sub, LinearMap.ext_iff]
      have hP_minus_I_pow : ∀ m : Nat, 0 < m ->
          (P - LinearMap.id) ^ (2 * m) = LinearMap.id - P := by
        intro m hm
        induction hm <;> simp_all +decide [pow_succ, pow_mul]
        simp_all +decide [mul_sub, sub_mul, LinearMap.ext_iff]
      have hP_minus_I_2k : (P - LinearMap.id) ^ (2 * k) = 0 := by
        rw [pow_mul', hnilpotent, zero_pow (by positivity)]
      simp_all +decide [sub_eq_iff_eq_add]
  · obtain ⟨Q, hQ⟩ : ∃ Q : Module.End Real M,
        (P - c • LinearMap.id) * Q = LinearMap.id := by
      have h_eq :
          (P - c • LinearMap.id) ^ 2 +
              (2 * c - 1) • (P - c • LinearMap.id) +
              (c * (c - 1)) • LinearMap.id = 0 := by
        ext x
        simp +decide [sq, sub_mul, mul_sub, <- mul_assoc,
          <- LinearMap.comp_apply, hidempotent]
        ring
        module
      have h_rearrange :
          (P - c • LinearMap.id) *
              ((P - c • LinearMap.id) + (2 * c - 1) • LinearMap.id) =
            -(c * (c - 1)) • LinearMap.id := by
        convert eq_neg_of_add_eq_zero_left h_eq using 1
        simp +decide [mul_add, pow_two]
        abel_nf
        · simp +decide [LinearMap.ext_iff]
        · rw [neg_smul]
      refine ⟨(-(c * (c - 1)))⁻¹ •
          (P - c • LinearMap.id + (2 * c - 1) • LinearMap.id), ?_⟩
      convert congrArg (fun x => (-(c * (c - 1)))⁻¹ • x) h_rearrange
          using 1 <;> norm_num [h]
      · simp +decide [mul_add, add_mul, mul_assoc, mul_left_comm, smul_smul]
        abel1
      · simp +decide [<- mul_assoc, <- smul_assoc, h, sub_ne_zero]
    replace hnilpotent := congrArg (fun f => f * Q) hnilpotent
    simp_all +decide [pow_succ, mul_assoc]
    induction hk <;> simp_all +decide [pow_succ, mul_assoc]
    · exact absurd
        (congrArg (fun f => f (Classical.choose (exists_ne (0 : M))))
          hnilpotent)
        (by simp +decide [Classical.choose_spec (exists_ne (0 : M))])
    · simp_all +decide [LinearMap.ext_iff]

private lemma polynomial_eval_sub_scalar_nilpotent
    (a : Real) (N : Module.End Real M) (k : Nat) (hN : N ^ k = 0)
    (p : Real[X]) :
    (aeval (a • LinearMap.id + N) p - (p.eval a) • LinearMap.id) ^ k = 0 := by
  revert N
  intro N hN
  obtain ⟨q, hq⟩ : ∃ q : Polynomial Real,
      p - Polynomial.C (p.eval a) =
        (Polynomial.X - Polynomial.C a) * q := by
    exact Polynomial.dvd_iff_isRoot.mpr (by simp +decide)
  have h_eval_nilpotent :
      aeval (a • LinearMap.id + N) (Polynomial.X - Polynomial.C a) = N := by
    ext
    simp +decide [sub_smul]
  have h_comm : Commute (aeval (a • LinearMap.id + N) q) N := by
    simp +decide [Commute, Polynomial.aeval_def]
    simp +decide [SemiconjBy, Polynomial.eval₂_eq_sum_range]
    simp +decide [Finset.mul_sum _ _ _, Finset.sum_mul, mul_assoc,
      mul_left_comm, Algebra.algebraMap_eq_smul_one]
    refine Finset.sum_congr rfl fun x hx => ?_
    refine congrArg _ (Nat.recOn x ?_ ?_) <;>
      simp_all +decide [pow_succ', mul_assoc, add_mul, mul_add]
    simp +decide [mul_assoc, LinearMap.ext_iff]
  replace hq := congrArg (aeval (a • LinearMap.id + N)) hq
  simp_all +decide [sub_eq_iff_eq_add]
  convert congrArg (fun x => x ^ k)
      (show N * (aeval (N + (algebraMap Real (Module.End Real M)) a)) q =
          (aeval (N + (algebraMap Real (Module.End Real M)) a)) q * N from
        h_comm.symm.eq) using 1
  · exact congrArg (· ^ k) (by ext; simp +decide [Algebra.smul_def])
  · rw [h_comm.mul_pow, hN, MulZeroClass.mul_zero]

/-- Every idempotent polynomial filter of a scalar plus a nilpotent
endomorphism is zero or the identity. -/
theorem polynomial_idempotent_of_scalar_add_nilpotent_trivial
    (a : Real) (N : Module.End Real M) (k : Nat) (hk : 0 < k)
    (hN : N ^ k = 0) (p : Real[X])
    (hidempotent :
      let P : Module.End Real M := aeval (a • LinearMap.id + N) p
      P.comp P = P) :
    let P : Module.End Real M := aeval (a • LinearMap.id + N) p
    P = 0 ∨ P = LinearMap.id := by
  apply idempotent_eq_zero_or_id_of_sub_scalar_nilpotent
  exact hk
  convert hidempotent
  convert polynomial_eval_sub_scalar_nilpotent a N k hN p

end PhysicsSM.Draft.NullEdge.RetardedPolynomialProjectorNoGo

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedPolynomialProjectorNoGo.idempotent_eq_zero_or_id_of_sub_scalar_nilpotent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedPolynomialProjectorNoGo.idempotent_eq_zero_or_id_of_sub_scalar_nilpotent

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedPolynomialProjectorNoGo.polynomial_idempotent_of_scalar_add_nilpotent_trivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedPolynomialProjectorNoGo.polynomial_idempotent_of_scalar_add_nilpotent_trivial
