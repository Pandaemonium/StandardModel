import PhysicsSM.Algebra.Octonion.ComplexOctonion

/-!
# Algebra.Furey.LadderOperators

The three ladder operators alpha_1, alpha_2, alpha_3 in the project XOR convention.

## Definition

In Furey (arXiv:1806.00612), working in Baez convention, the ladder operators are:
  alpha_1 = (-e_5 + i·e_4) / 2
  alpha_2 = (-e_3 + i·e_1) / 2
  alpha_3 = (-e_6 + i·e_2) / 2

Translating via `PhysicsSM.Algebra.Octonion.ConventionBridge` (permutation + sign):
  alpha_1 (XOR) = (+e100 + i·e011) / 2
  alpha_2 (XOR) = (-e110 + i·e001) / 2
  alpha_3 (XOR) = (-e101 + i·e010) / 2

The sign change in alpha_1 comes from Baez e_5 mapping to **-e100** in XOR
(the sole sign flip in the convention bridge).

## Key algebraic properties

The ladder operators satisfy (by left multiplication in ℂ⊗𝕆):

- **Nilpotency**: alpha_k * alpha_k = 0  (for k = 1, 2, 3)
- **Anticommutation**:
    alpha_i * alpha_j†  +  alpha_j† * alpha_i  =  delta_ij  (identity in ℂ⊗𝕆)
    alpha_i * alpha_j   +  alpha_j  * alpha_i  =  0
- **Clifford generation**: alpha_1, ..., alpha_3, alpha_1†, ..., alpha_3† generate Cl(6)

These properties are the algebraic backbone of the SM particle classification.
The nilpotency and anticommutation are finite computations in the explicit
basis; they are natural Aristotle targets.

## Dagger (Clifford adjoint)

The "dagger" here is the Clifford adjoint under complex conjugation of ℂ⊗𝕆,
NOT the octonion conjugation. In coordinates:
  alpha_k† = complex conjugate of alpha_k (replace i -> -i, keep octonion part)

  alpha_1† (XOR) = (+e100 - i·e011) / 2
  alpha_2† (XOR) = (-e110 - i·e001) / 2
  alpha_3† (XOR) = (-e101 - i·e010) / 2

## Sources

Source: Furey, arXiv:1806.00612, eqs. after (2.2); translated to XOR convention
via `Scripts/oracle/validate_convention_bridge.py`.
Provenance: clean-room formalization, no external code copied.

## Prerequisites

- `PhysicsSM.Algebra.Octonion.Basic`       (Octonion type, basisElem)
- `PhysicsSM.Algebra.Octonion.ComplexOctonion`
- `PhysicsSM.Algebra.Octonion.ConventionBridge` (sign correction verification)

## Status

Ladder operators defined and nilpotency proved.
-/

namespace PhysicsSM.Algebra.Furey.LadderOperators

open PhysicsSM.Algebra.Octonion.ComplexOctonion PhysicsSM.Algebra.Octonion

/-- Ladder operator alpha_1 in the project XOR convention.
    Furey (Baez): (-e5 + i*e4)/2.
    XOR (this project): (+e100 + i*e011)/2. -/
noncomputable def alpha1 : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=1/2, c5:=0, c6:=0, c7:=0 }
    im := { c0:=0, c1:=0, c2:=0, c3:=1/2, c4:=0, c5:=0, c6:=0, c7:=0 } }

/-- Ladder operator alpha_2 in the project XOR convention.
    Furey (Baez): (-e3 + i*e1)/2.
    XOR (this project): (-e110 + i*e001)/2. -/
noncomputable def alpha2 : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=0, c5:=0, c6:=-1/2, c7:=0 }
    im := { c0:=0, c1:=1/2, c2:=0, c3:=0, c4:=0, c5:=0, c6:=0, c7:=0 } }

/-- Ladder operator alpha_3 in the project XOR convention.
    Furey (Baez): (-e6 + i*e2)/2.
    XOR (this project): (-e101 + i*e010)/2. -/
noncomputable def alpha3 : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=0, c5:=-1/2, c6:=0, c7:=0 }
    im := { c0:=0, c1:=0, c2:=1/2, c3:=0, c4:=0, c5:=0, c6:=0, c7:=0 } }

-- simp closes all goals for alpha1 directly
theorem alpha1_nilpotent : alpha1 * alpha1 = 0 := by
  ext <;> simp [alpha1]

-- simp reduces to numeric goals; ring closes the remainders
theorem alpha2_nilpotent : alpha2 * alpha2 = 0 := by
  ext <;> simp [alpha2] <;> ring

theorem alpha3_nilpotent : alpha3 * alpha3 = 0 := by
  ext <;> simp [alpha3] <;> ring

end PhysicsSM.Algebra.Furey.LadderOperators
