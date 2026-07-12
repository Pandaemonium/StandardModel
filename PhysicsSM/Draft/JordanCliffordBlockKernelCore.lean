import Mathlib

/-!
# Product-cover block kernel core

This module isolates the pure matrix-algebra hinge in the exact kernel proof
for the even exterior action. Suppose a `2 x 2` block `A` and a `3 x 3` block
`B` have identity Kronecker product entrywise. If both come from one nonzero
phase with the Standard Model product-cover powers and determinant-one unit
blocks, then both `A` and `B` are identity.

The reciprocal-scalar control shows why the determinant/common-phase
hypotheses are necessary: identity of the Kronecker product alone permits a
continuous scalar ambiguity.

Claim boundary: this is pure finite matrix algebra. It does not establish the
reduction from the exterior action, the exact `Z6` kernel of that action, a
topological quotient, or any Jordan/Furey identification.

Provenance: theorem statements were isolated locally from the partial snapshot
of Aristotle project `ca0e21e7-0b55-4694-9552-79c423742b78`. Proofs were
returned by focused Aristotle project `9775ac99-270a-4f19-99ed-b9236b715491`
and independently compiled in the live pinned toolchain. No compiled evaluator
is used.
-/

namespace PhysicsSM.Draft.JordanCliffordBlockKernelCore

open Matrix

/-- If the two product-cover blocks have identity Kronecker product, their
common phase scaling and determinant-one constraints force both blocks to be
identity. -/
theorem blocks_are_identity
    (p : ℂ) (hp : p ≠ 0)
    (A : Matrix (Fin 2) (Fin 2) ℂ) (B : Matrix (Fin 3) (Fin 3) ℂ)
    (su2 : Matrix (Fin 2) (Fin 2) ℂ) (su3 : Matrix (Fin 3) (Fin 3) ℂ)
    (hA : A = p ^ 3 • su2) (hB : B = (p⁻¹) ^ 2 • su3)
    (hdet2 : su2.det = 1) (hdet3 : su3.det = 1)
    (hstar : ∀ (i i' : Fin 2) (j j' : Fin 3),
      A i' i * B j' j = (if i' = i then (1 : ℂ) else 0) *
        (if j' = j then 1 else 0)) :
    A = 1 ∧ B = 1 := by
  have h_diag_A : ∃ a : ℂ, A = a • 1 := by
    norm_num [← Matrix.ext_iff, Fin.forall_fin_succ] at *
    grind +ring
  have h_diag_B : ∃ b : ℂ, B = b • 1 := by
    simp_all +decide [Fin.forall_fin_succ]
    simp_all +decide [← Matrix.ext_iff, Fin.forall_fin_succ]
    grind
  rcases h_diag_A with ⟨a, rfl⟩
  rcases h_diag_B with ⟨b, rfl⟩
  have hab := hstar 0 0 0 0
  simp_all +decide
  have ha_one : a = 1 := by
    apply_fun Matrix.det at hA hB
    simp_all +decide
    grind
  have hb_one : b = 1 := by
    simpa [ha_one] using hab
  aesop

/-- The determinant hypotheses are substantive: without them a nontrivial
reciprocal scalar pair has identity Kronecker product. -/
theorem reciprocal_scalar_control :
    let A : Matrix (Fin 2) (Fin 2) ℂ := (2 : ℂ) • 1
    let B : Matrix (Fin 3) (Fin 3) ℂ := ((2 : ℂ)⁻¹) • 1
    (∀ (i i' : Fin 2) (j j' : Fin 3),
      A i' i * B j' j = (if i' = i then (1 : ℂ) else 0) *
        (if j' = j then 1 else 0)) ∧ A ≠ 1 := by
  norm_num [Fin.forall_fin_succ, ← Matrix.ext_iff]
  simp +decide

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.JordanCliffordBlockKernelCore.blocks_are_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms blocks_are_identity

/-- info: 'PhysicsSM.Draft.JordanCliffordBlockKernelCore.reciprocal_scalar_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms reciprocal_scalar_control

end PhysicsSM.Draft.JordanCliffordBlockKernelCore
