import Mathlib

/-!
# Suite D modular-generator audit anchor

This draft module isolates the algebraic core of a Suite D audit question:
whether a central normalization shift in a finite modular Hamiltonian changes
the modular generator.

The answer depends on which object is being compared. As an operator,
`z + B` need not equal `B`. As a commutator derivation, the central shift
cancels exactly. This file proves that guardrail, complementing the stronger
finite modular-flow results in `PhysicsSM.Draft.NullEdge.ModularSelection`.

Provenance: clean-room port of the Aristotle standalone seed returned by
`codex-D-kills-resource-audit-20260709`
(`68b768ce-9c0c-4fad-892d-a8eeaf4c5937`,
`RequestProject/SuiteD.lean`).
-/

namespace MassResourceModularAudit

/--
A central shift in the modular Hamiltonian does not change the commutator
derivation.
-/
theorem modular_generator_eq_adB
    {R : Type*} [Ring R] (B A z : R) (hz : ∀ x : R, z * x = x * z) :
    (z + B) * A - A * (z + B) = B * A - A * B := by
  have hcentral : z * A = A * z := hz A
  have expand : (z + B) * A - A * (z + B) = (z * A - A * z) + (B * A - A * B) := by
    noncomm_ring
  rw [expand, hcentral, sub_self, zero_add]

/--
Matrix specialization: a scalar multiple of the identity is central, so
`ad (c * 1 + B) = ad B`.
-/
theorem modular_generator_matrix
    {n : Type*} [Fintype n] [DecidableEq n] (B A : Matrix n n ℂ) (c : ℂ) :
    (c • (1 : Matrix n n ℂ) + B) * A - A * (c • (1 : Matrix n n ℂ) + B)
      = B * A - A * B := by
  apply modular_generator_eq_adB
  intro x
  rw [smul_mul_assoc, one_mul, mul_smul_comm, mul_one]

/--
False-shape guard: the operator equality itself is generally false. A nonzero
central shift changes the modular Hamiltonian even though it does not change
the commutator derivation.
-/
theorem modular_shift_operator_ne
    (c : ℂ) (hc : c ≠ 0) (B : Matrix (Fin 2) (Fin 2) ℂ) :
    c • (1 : Matrix (Fin 2) (Fin 2) ℂ) + B ≠ B := by
  intro h
  have h' :
      c • (1 : Matrix (Fin 2) (Fin 2) ℂ) + B =
        (0 : Matrix (Fin 2) (Fin 2) ℂ) + B := by
    simpa using h
  have hshift : c • (1 : Matrix (Fin 2) (Fin 2) ℂ) = 0 := add_right_cancel h'
  have h1 : (1 : Matrix (Fin 2) (Fin 2) ℂ) ≠ 0 := one_ne_zero
  exact (smul_ne_zero hc h1) hshift

end MassResourceModularAudit

/-! ## Axiom audit (build-enforced guard pin) -/

/-- info: 'MassResourceModularAudit.modular_generator_eq_adB' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MassResourceModularAudit.modular_generator_eq_adB

/-- info: 'MassResourceModularAudit.modular_generator_matrix' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MassResourceModularAudit.modular_generator_matrix

/-- info: 'MassResourceModularAudit.modular_shift_operator_ne' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MassResourceModularAudit.modular_shift_operator_ne
