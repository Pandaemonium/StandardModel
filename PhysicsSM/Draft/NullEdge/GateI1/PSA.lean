import Mathlib

/-!
# Q12 PSA-1: finite per-sector supertrace identity

This module turns PSA-1 from the Q12 anomaly-gate audit into an exact finite
identity.  For a matrix `g : Matrix (Fin n) (Fin n) R` over a commutative ring,
the exterior-algebra supertrace is modeled as the alternating sum of principal
minors:

`superTrace g = sum_S (-1) ^ |S| * det(g[S,S])`.

The finite identity is `superTrace g = det(1 - g)`.  A second theorem proves
that a permutation matrix has `det(1 - g) = 0` because it fixes the all-ones
vector.

Claim boundary: this is a finite representation/accounting identity for one
sector.  It does not by itself prove anomaly cancellation, an equivariant
McKean-Singer theorem, charge-resolution additivity, or any physical chirality
claim.

Provenance: `AgentTasks/fable_parallel/Q12_answer.md`; Aristotle project
`bbcf12c6`, task `33f620c0`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.PSA

open Finset

variable {R : Type*} [CommRing R] {n : ℕ}

/-- Principal minor of `g` on index set `S`. -/
noncomputable def principalMinor
    (g : Matrix (Fin n) (Fin n) R) (S : Finset (Fin n)) : R :=
  (g.submatrix (fun i : S => (i : Fin n)) (fun j : S => (j : Fin n))).det

/--
The exterior-algebra supertrace, represented as the signed sum of principal
minors.
-/
noncomputable def superTrace (g : Matrix (Fin n) (Fin n) R) : R :=
  ∑ S : Finset (Fin n), (-1) ^ S.card * principalMinor g S

/-
PSA-1 finite identity: the exterior-algebra supertrace equals `det(1 - g)`.
The proof is a direct determinant expansion and needs an explicit heartbeat
budget.
-/
set_option maxHeartbeats 1600000 in
theorem superTrace_eq_det_one_sub (g : Matrix (Fin n) (Fin n) R) :
    superTrace g = (1 - g).det := by
  suffices h_char_poly :
      Matrix.det (1 - g) =
        ∑ S : Finset (Fin n), (-1 : R) ^ S.card *
          (Matrix.det (Matrix.submatrix g (fun i : S => i) (fun j : S => j))) by
    exact h_char_poly.symm
  simp +decide [Matrix.det_apply']
  simp +decide [Matrix.one_apply]
  have h_split :
      ∑ x : Equiv.Perm (Fin n),
          (Equiv.Perm.sign x : R) *
            ∏ i : Fin n, ((if x i = i then 1 else 0) - g (x i) i) =
        ∑ S : Finset (Fin n),
          (-1 : R) ^ S.card *
            ∑ x : Equiv.Perm (Fin n),
              (Equiv.Perm.sign x : R) *
                (∏ i ∈ S, g (x i) i) *
                  (∏ i ∈ Sᶜ, if x i = i then 1 else 0) := by
    have h_split :
        ∀ x : Equiv.Perm (Fin n),
          ∏ i : Fin n, ((if x i = i then 1 else 0) - g (x i) i) =
            ∑ S : Finset (Fin n),
              (-1 : R) ^ S.card *
                (∏ i ∈ S, g (x i) i) *
                  (∏ i ∈ Sᶜ, if x i = i then 1 else 0) := by
      intro x
      simp +decide [sub_eq_neg_add, Finset.prod_add]
      simp +decide [Finset.compl_eq_univ_sdiff, Finset.prod_ite]
      exact Finset.sum_congr rfl fun _ _ => by
        rw [Finset.prod_congr rfl fun _ _ => neg_eq_neg_one_mul _,
          Finset.prod_mul_distrib]
        simp +decide
    simp +decide only [h_split, mul_assoc, Finset.mul_sum _ _ _]
    exact Finset.sum_comm.trans
      (Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring)
  convert h_split using 2
  rw [← Finset.sum_subset
    (Finset.subset_univ
      (Finset.image
        (fun x : Equiv.Perm {x : Fin n // x ∈ ‹Finset (Fin n)›} =>
          Equiv.Perm.ofSubtype x) Finset.univ))]
  · refine' congr_arg _
      (Finset.sum_bij (fun x _ => Equiv.Perm.ofSubtype x) _ _ _ _) <;>
        simp +decide [Equiv.Perm.ofSubtype]
    · simp +decide [Equiv.Perm.extendDomain]
      simp +decide [Equiv.Perm.ext_iff, Equiv.Perm.subtypeCongr]
    · simp +decide [Equiv.Perm.extendDomain]
      intro a
      rw [Finset.prod_congr rfl fun x hx => if_pos <| by aesop]
      simp +decide
      refine' congr_arg _ (Finset.prod_bij (fun x _ => x) _ _ _ _) <;> simp +decide
  · intro x _ hx
    contrapose! hx
    simp_all +decide [Equiv.Perm.ofSubtype]
    refine' ⟨Equiv.Perm.subtypePerm x _, _⟩
    intro i
    exact ⟨fun hi => by
      exact Classical.not_not.1 fun hi' =>
        hx <| mul_eq_zero_of_right _ <|
          Finset.prod_eq_zero (Finset.mem_compl.2 hi') <| if_neg <| by aesop,
      fun hi => by
        exact Classical.not_not.1 fun hi' =>
          hx <| mul_eq_zero_of_right _ <|
            Finset.prod_eq_zero (Finset.mem_compl.2 hi') <| if_neg <| by aesop⟩
    all_goals
      generalize_proofs at *
      ext i
      by_cases hi : i ∈ ‹Finset (Fin n)› <;>
        simp_all +decide [Equiv.Perm.extendDomain]
      exact Classical.not_not.1 fun h =>
        hx <| mul_eq_zero_of_right _ <|
          Finset.prod_eq_zero (Finset.mem_compl.2 hi) <| if_neg <| by aesop

/--
Order-`m` vanishing for a permutation-matrix sector: any permutation matrix fixes
the all-ones vector, so `1 - g` has a nontrivial kernel.
-/
theorem det_one_sub_permMatrix_eq_zero {K : Type*} [Field K] {m : ℕ}
    (hm : 0 < m) (σ : Equiv.Perm (Fin m)) :
    (1 - (σ.toPEquiv.toMatrix : Matrix (Fin m) (Fin m) K)).det = 0 := by
  rw [← Matrix.exists_mulVec_eq_zero_iff]
  refine' ⟨fun _ => 1, _, _⟩ <;> simp +decide [funext_iff, Matrix.mulVec, dotProduct]
  · exact ⟨⟨0, hm⟩⟩
  · simp +decide [Matrix.one_apply]

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.PSA.superTrace_eq_det_one_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms superTrace_eq_det_one_sub

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.PSA.det_one_sub_permMatrix_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_one_sub_permMatrix_eq_zero

end PhysicsSM.Draft.NullEdge.GateI1.PSA
