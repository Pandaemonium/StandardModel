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

The dagger α† is the C*-algebra involution on ℂ⊗𝕆. For an element (a + ib)
where a, b are pure imaginary octonions, the involution is:

  (a + ib)† = (−a) + i·b

That is: negate the real octonionic part; the imaginary part is unchanged.

This combines complex conjugation (i → −i) and octonion conjugation
(eₖ → −eₖ for imaginary units), acting as (a+ib)† = ā_oct + (−i)·b̄_oct
= (−a) + (−i)(−b) = −a + ib.

WARNING: The naive "replace i → −i" formula (a + ib) ↦ (a − ib) does NOT
give the correct Clifford adjoint. That formula yields {αₖ, αₖ†} = −1, not +1.
Only the negate-re formula gives the correct canonical anticommutation relation.
Verified by oracle computation in Scripts/oracle/validate_convention_bridge.py.

Project XOR dagger formulas (re negated, im unchanged):
  alpha1_dag (XOR) = (−e100 + i·e011) / 2
  alpha2_dag (XOR) = (+e110 + i·e001) / 2
  alpha3_dag (XOR) = (+e101 + i·e010) / 2

Note the sign difference from alpha1/2/3:
  alpha1     = (+e100 + i·e011) / 2   [c4=+1/2]
  alpha1_dag = (−e100 + i·e011) / 2   [c4=−1/2]
  alpha2     = (−e110 + i·e001) / 2   [c6=−1/2]
  alpha2_dag = (+e110 + i·e001) / 2   [c6=+1/2]
  alpha3     = (−e101 + i·e010) / 2   [c5=−1/2]
  alpha3_dag = (+e101 + i·e010) / 2   [c5=+1/2]

## Sources

Source: Furey, arXiv:1806.00612, eqs. after (2.2); translated to XOR convention
via `Scripts/oracle/validate_convention_bridge.py`.
Provenance: clean-room formalization, no external code copied.

## Prerequisites

- `PhysicsSM.Algebra.Octonion.Basic`       (Octonion type, basisElem)
- `PhysicsSM.Algebra.Octonion.ComplexOctonion`
- `PhysicsSM.Algebra.Octonion.ConventionBridge` (sign correction verification)

## Status

Ladder operators and their daggers defined. Nilpotency (6 theorems) and all 27
Clifford algebra Cl(6) anticommutation relations proved.
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

/-- Clifford adjoint of alpha_1 in the project XOR convention.
    Adjoint rule: negate the real octonionic part, keep the imaginary part.
    alpha1_dag (XOR) = (−e100 + i·e011) / 2.
    Note: NOT the complex conjugate (+e100 − i·e011)/2; that formula fails
    the canonical anticommutation relation. See docstring for derivation. -/
noncomputable def alpha1_dag : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=-1/2, c5:=0, c6:=0, c7:=0 }
    im := { c0:=0, c1:=0, c2:=0, c3:=1/2,  c4:=0,  c5:=0, c6:=0, c7:=0 } }

/-- Clifford adjoint of alpha_2 in the project XOR convention.
    alpha2_dag (XOR) = (+e110 + i·e001) / 2.
    Note: re.c6 flips sign from alpha2 (−1/2 → +1/2). -/
noncomputable def alpha2_dag : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=0, c5:=0, c6:=1/2,  c7:=0 }
    im := { c0:=0, c1:=1/2, c2:=0, c3:=0, c4:=0, c5:=0, c6:=0, c7:=0 } }

/-- Clifford adjoint of alpha_3 in the project XOR convention.
    alpha3_dag (XOR) = (+e101 + i·e010) / 2.
    Note: re.c5 flips sign from alpha3 (−1/2 → +1/2). -/
noncomputable def alpha3_dag : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=0, c5:=1/2,  c6:=0, c7:=0 }
    im := { c0:=0, c1:=0, c2:=1/2, c3:=0, c4:=0, c5:=0, c6:=0, c7:=0 } }

-- ============================================================================
-- Nilpotency
-- ============================================================================

theorem alpha1_nilpotent : alpha1 * alpha1 = 0 := by
  ext <;> simp [alpha1]

theorem alpha2_nilpotent : alpha2 * alpha2 = 0 := by
  ext <;> simp [alpha2] <;> ring

theorem alpha3_nilpotent : alpha3 * alpha3 = 0 := by
  ext <;> simp [alpha3] <;> ring

/-- The adjoint alpha1_dag is itself nilpotent. -/
theorem alpha1_dag_nilpotent : alpha1_dag * alpha1_dag = 0 := by
  ext <;> simp [alpha1_dag] <;> ring

theorem alpha2_dag_nilpotent : alpha2_dag * alpha2_dag = 0 := by
  ext <;> simp [alpha2_dag] <;> ring

theorem alpha3_dag_nilpotent : alpha3_dag * alpha3_dag = 0 := by
  ext <;> simp [alpha3_dag] <;> ring

-- ============================================================================
-- Group A — canonical anticommutation: {αᵢ, αⱼ†} = δᵢⱼ · 1
-- ============================================================================

/-- Canonical anticommutation: {α₁, α₁†} = 1. -/
theorem anticomm_1_1dag :
    alpha1 * alpha1_dag + alpha1_dag * alpha1 = 1 := by
  ext <;> simp [alpha1, alpha1_dag] <;> ring

theorem anticomm_2_2dag :
    alpha2 * alpha2_dag + alpha2_dag * alpha2 = 1 := by
  ext <;> simp [alpha2, alpha2_dag] <;> ring

theorem anticomm_3_3dag :
    alpha3 * alpha3_dag + alpha3_dag * alpha3 = 1 := by
  ext <;> simp [alpha3, alpha3_dag] <;> ring

/-- Off-diagonal canonical anticommutation: {α₁, α₂†} = 0. -/
theorem anticomm_1_2dag :
    alpha1 * alpha2_dag + alpha2_dag * alpha1 = 0 := by
  ext <;> simp [alpha1, alpha2_dag] <;> ring

theorem anticomm_2_1dag :
    alpha2 * alpha1_dag + alpha1_dag * alpha2 = 0 := by
  ext <;> simp [alpha2, alpha1_dag] <;> ring

theorem anticomm_1_3dag :
    alpha1 * alpha3_dag + alpha3_dag * alpha1 = 0 := by
  ext <;> simp [alpha1, alpha3_dag] <;> ring

theorem anticomm_3_1dag :
    alpha3 * alpha1_dag + alpha1_dag * alpha3 = 0 := by
  ext <;> simp [alpha3, alpha1_dag] <;> ring

theorem anticomm_2_3dag :
    alpha2 * alpha3_dag + alpha3_dag * alpha2 = 0 := by
  ext <;> simp [alpha2, alpha3_dag] <;> ring

theorem anticomm_3_2dag :
    alpha3 * alpha2_dag + alpha2_dag * alpha3 = 0 := by
  ext <;> simp [alpha3, alpha2_dag] <;> ring

-- ============================================================================
-- Group B — ladder-ladder anticommutation: {αᵢ, αⱼ} = 0
-- ============================================================================

/-- Ladder-ladder anticommutation: {α₁, α₁} = 2·α₁² = 0. -/
theorem anticomm_1_1 :
    alpha1 * alpha1 + alpha1 * alpha1 = 0 := by
  simp [alpha1_nilpotent]

theorem anticomm_2_2 :
    alpha2 * alpha2 + alpha2 * alpha2 = 0 := by
  simp [alpha2_nilpotent]

theorem anticomm_3_3 :
    alpha3 * alpha3 + alpha3 * alpha3 = 0 := by
  simp [alpha3_nilpotent]

/-- Off-diagonal ladder-ladder: {α₁, α₂} = 0. -/
theorem anticomm_1_2 :
    alpha1 * alpha2 + alpha2 * alpha1 = 0 := by
  ext <;> simp [alpha1, alpha2] <;> ring

theorem anticomm_2_1 :
    alpha2 * alpha1 + alpha1 * alpha2 = 0 := by
  ext <;> simp [alpha1, alpha2] <;> ring

theorem anticomm_1_3 :
    alpha1 * alpha3 + alpha3 * alpha1 = 0 := by
  ext <;> simp [alpha1, alpha3] <;> ring

theorem anticomm_3_1 :
    alpha3 * alpha1 + alpha1 * alpha3 = 0 := by
  ext <;> simp [alpha1, alpha3] <;> ring

theorem anticomm_2_3 :
    alpha2 * alpha3 + alpha3 * alpha2 = 0 := by
  ext <;> simp [alpha2, alpha3] <;> ring

theorem anticomm_3_2 :
    alpha3 * alpha2 + alpha2 * alpha3 = 0 := by
  ext <;> simp [alpha2, alpha3] <;> ring

-- ============================================================================
-- Group C — dagger-dagger anticommutation: {αᵢ†, αⱼ†} = 0
-- ============================================================================

theorem anticomm_1dag_1dag :
    alpha1_dag * alpha1_dag + alpha1_dag * alpha1_dag = 0 := by
  simp [alpha1_dag_nilpotent]

theorem anticomm_2dag_2dag :
    alpha2_dag * alpha2_dag + alpha2_dag * alpha2_dag = 0 := by
  simp [alpha2_dag_nilpotent]

theorem anticomm_3dag_3dag :
    alpha3_dag * alpha3_dag + alpha3_dag * alpha3_dag = 0 := by
  simp [alpha3_dag_nilpotent]

theorem anticomm_1dag_2dag :
    alpha1_dag * alpha2_dag + alpha2_dag * alpha1_dag = 0 := by
  ext <;> simp [alpha1_dag, alpha2_dag] <;> ring

theorem anticomm_2dag_1dag :
    alpha2_dag * alpha1_dag + alpha1_dag * alpha2_dag = 0 := by
  ext <;> simp [alpha1_dag, alpha2_dag] <;> ring

theorem anticomm_1dag_3dag :
    alpha1_dag * alpha3_dag + alpha3_dag * alpha1_dag = 0 := by
  ext <;> simp [alpha1_dag, alpha3_dag] <;> ring

theorem anticomm_3dag_1dag :
    alpha3_dag * alpha1_dag + alpha1_dag * alpha3_dag = 0 := by
  ext <;> simp [alpha1_dag, alpha3_dag] <;> ring

theorem anticomm_2dag_3dag :
    alpha2_dag * alpha3_dag + alpha3_dag * alpha2_dag = 0 := by
  ext <;> simp [alpha2_dag, alpha3_dag] <;> ring

theorem anticomm_3dag_2dag :
    alpha3_dag * alpha2_dag + alpha2_dag * alpha3_dag = 0 := by
  ext <;> simp [alpha2_dag, alpha3_dag] <;> ring

end PhysicsSM.Algebra.Furey.LadderOperators
