import PhysicsSM.Algebra.Furey.SMStates

/-!
# Algebra.Furey.QuantumNumbers

Recovering U(1) and SU(3) generators from the division algebraic ladder operators.

## U(1) — hypercharge / electric charge

The number operators N_k = alpha_k† * alpha_k (k=1,2,3) are simultaneously
diagonalizable on J. Their eigenvalues on the basis states give the
electric charge via the Gell-Mann–Nishijima-type formula:
  Q = -(1/3)(N_1 + N_2 + N_3) + (constant depending on idempotent)

The specific charges recovered (see `SMStates`) match the Standard Model
assignments for one generation.

## SU(3) — strong colour charge

The group of unitary transformations of the three modes (alpha_1, alpha_2, alpha_3)
that preserve the Clifford anticommutation relations is U(3). The subgroup that
additionally preserves the idempotent omega is SU(3). This SU(3) acts as the
colour gauge group, and under it the states in J transform correctly as
colour singlets and colour triplets.

In Furey's formulation:
  SU(3)_c = { U ∈ U(3) | det(U) = 1 and U preserves omega }

## SU(2)_L — weak isospin

SU(2)_L does not emerge directly from the single-ideal ℂ⊗𝕆 construction.
It appears when the quaternionic structure (the second division algebra factor
in the Dixon algebra ℝ⊗ℂ⊗ℍ⊗𝕆) is incorporated, or from the interplay of
the two minimal left ideals J and J'. This is a longer-term target.

## Key theorems to formalize

1. Number operator eigenvalues on J basis states match the charge table in SMStates.
2. The SU(3) action on J is irreducible on the triplet sectors.
3. Anomaly cancellation: sum of charges over one generation vanishes.

## Sources

Source: Furey, arXiv:1806.00612, Sections 3–4.
        Furey, arXiv:1603.04783 (charge quantization from number operator).
Provenance: clean-room formalization.

## Status

Stub — generator definitions and eigenvalue theorems to be added after
SMStates and ladder operators are active.
-/

namespace PhysicsSM.Algebra.Furey.QuantumNumbers

end PhysicsSM.Algebra.Furey.QuantumNumbers
