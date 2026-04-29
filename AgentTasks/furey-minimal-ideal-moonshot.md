# Task: Furey Minimal Left Ideal — Complete Cl(6) Module Structure

**Agent**: Aristotle
**Status**: Complete — merged
**Priority**: MOONSHOT
**Job ID**: `e5879893-b521-4c75-bdc2-28504b0ad797`
**Submitted**: 2026-04-27
**Output**: `AgentTasks/aristotle-output/furey-minimal-ideal-moonshot`

---

## Overview

Complete the formalization of the minimal left ideal J ⊂ ℂ⊗𝕆 as a Cl(6)-module
carrying one generation of Standard Model fermions. This is the mathematical core
of Furey's Standard Model construction (arXiv:1806.00612).

**Every single theorem in this task is a FINITE ARITHMETIC COMPUTATION.**
No abstract algebra, no axiom of choice, no sorry. The proof template for nearly
every theorem is:

```lean
ext <;> simp [relevant_defs] <;> ring
```

or just `ext <;> simp [relevant_defs]` when ring is not needed.
The non-associativity of ℂ⊗𝕆 is irrelevant because `simp` unfolds everything
to ℝ-valued component equations, which ARE associative/commutative.
The `ring` tactic closes all remaining polynomial goals over ℝ.

**Source**: Furey, "SU(3)_C × SU(2)_L × U(1)_Y (×U(1)_X) as a symmetry of
division algebraic ladder operators", EPJC 78 (2018) 375. arXiv:1806.00612.
All results oracle-validated by Scripts/oracle/validate_convention_bridge.py.

---

## File to modify

`PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`

Do NOT re-define any operators that exist in `LadderOperators.lean`.
Add the following import and open at the top of the file:

```lean
import PhysicsSM.Algebra.Furey.LadderOperators

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Furey.LadderOperators
```

The following are ALREADY DEFINED and PROVED in LadderOperators.lean.
Use them directly; do not restate them:
- `alpha1`, `alpha2`, `alpha3` (ladder operators)
- `alpha1_dag`, `alpha2_dag`, `alpha3_dag` (Clifford adjoints)
- All nilpotency theorems (`alpha1_nilpotent`, etc.)
- All 27 anticommutation theorems (`anticomm_1_1dag`, etc.)
- `ComplexOctonion` instances: `Neg`, `Add`, `Zero`, `One`, `Mul`
- All `@[simp]` lemmas: `mul_re`, `mul_im`, `add_re`, `add_im`, `zero_re`,
  `zero_im`, `one_re`, `one_im`, and all `Octonion.mul_c0`–`mul_c7`,
  `Octonion.add_c0`–`add_c7`, `Octonion.sub_c0`–`sub_c7`, etc.

---

## Part A — The primitive idempotent ω

### A1. Definition

```lean
/-- The primitive idempotent omega = (1 - i·e111)/2 in the project XOR convention.
    This is the algebraic vacuum: the starting point for the minimal left ideal J.
    In the Fock-space picture, omega is the FULLY-OCCUPIED state (all 3 modes active).
    Source: Furey arXiv:1806.00612, beginning of Section 2.
    Convention: XOR basis; e111 corresponds to Baez's e7 via ConventionBridge. -/
noncomputable def omega : ComplexOctonion :=
  { re := { c0:=1/2, c1:=0, c2:=0, c3:=0, c4:=0, c5:=0, c6:=0, c7:=0 }
    im := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=0, c5:=0, c6:=0, c7:=-1/2 } }
-- re part: (1/2)*e000  (scalar 1/2)
-- im part: -(1/2)*e111 (pure imaginary octonion)
```

### A2. Key theorems about omega

```lean
/-- omega is idempotent: omega * omega = omega.
    Proof: (1/4)(1 - ie111)^2 = (1/4)(1 - 2ie111 + (ie111)^2)
           = (1/4)(1 - 2ie111 + i^2 * e111^2)
           = (1/4)(1 - 2ie111 + (-1)(-1)) = (1/2)(1 - ie111) = omega. -/
theorem omega_idempotent : omega * omega = omega := by
  ext <;> simp [omega] <;> ring

/-- omega is the right identity on elements of J.
    For the four simple elements x = g * omega, we have (g * omega) * omega = g * omega
    by the right alternative law. These are proved directly by computation. -/

/-- The three dagger operators annihilate omega from the left.
    This means omega is the FILLED state: applying any annihilation operator
    (alpha_k_dag) to it gives zero.
    Proof: direct component computation. -/
theorem alpha1_dag_kills_omega : alpha1_dag * omega = 0 := by
  ext <;> simp [alpha1_dag, omega] <;> ring

theorem alpha2_dag_kills_omega : alpha2_dag * omega = 0 := by
  ext <;> simp [alpha2_dag, omega] <;> ring

theorem alpha3_dag_kills_omega : alpha3_dag * omega = 0 := by
  ext <;> simp [alpha3_dag, omega] <;> ring
```

---

## Part B — The eight basis states of J

The minimal left ideal J = (ℂ⊗𝕆)·omega has ℂ-dimension 8. Its basis consists of
omega together with the states obtained by applying the THREE CREATION operators
(alpha1, alpha2, alpha3) to omega in all combinations.

**Critical note on parenthesization**: ℂ⊗𝕆 is NOT associative. All nested
products must be right-associated: `alpha1 * (alpha2 * omega)`, NOT
`(alpha1 * alpha2) * omega` (the latter is zero in several cases).

The eight states with their EXPLICIT COORDINATES (oracle-validated):

| State | Lean def | re coords | im coords |
|-------|----------|-----------|-----------|
| omega | v0 | c0=+1/2 | c7=-1/2 |
| alpha1*omega | v1 | c4=+1/2 | c3=+1/2 |
| alpha2*omega | v2 | c6=-1/2 | c1=+1/2 |
| alpha3*omega | v3 | c5=-1/2 | c2=+1/2 |
| alpha1*(alpha2*omega) | v4 | c2=-1/2 | c5=+1/2 |
| alpha1*(alpha3*omega) | v5 | c1=+1/2 | c6=-1/2 |
| alpha2*(alpha3*omega) | v6 | c3=-1/2 | c4=-1/2 |
| alpha1*(alpha2*(alpha3*omega)) | nu | c7=-1/2 | c0=+1/2 |

**Important observation**: v1 = alpha1*omega = alpha1 exactly (same coordinates).
Similarly v2 = alpha2 and v3 = alpha3. This is because alpha_k * omega = alpha_k
in this algebra. You may verify this and define v1, v2, v3 accordingly, or define
them independently with explicit coordinates; either approach is valid.

### B1. Definitions

```lean
-- v0 = omega (already defined above)

-- v1: alpha1 * omega — same coordinates as alpha1
noncomputable def v1 : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=1/2, c5:=0, c6:=0, c7:=0 }
    im := { c0:=0, c1:=0, c2:=0, c3:=1/2, c4:=0, c5:=0, c6:=0, c7:=0 } }
-- = alpha1 in coordinates; corresponds to anti-up quark, colour r

-- v2: alpha2 * omega
noncomputable def v2 : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=0, c5:=0, c6:=-1/2, c7:=0 }
    im := { c0:=0, c1:=1/2, c2:=0, c3:=0, c4:=0, c5:=0, c6:=0, c7:=0 } }
-- = alpha2 in coordinates; anti-up quark, colour g

-- v3: alpha3 * omega
noncomputable def v3 : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=0, c5:=-1/2, c6:=0, c7:=0 }
    im := { c0:=0, c1:=0, c2:=1/2, c3:=0, c4:=0, c5:=0, c6:=0, c7:=0 } }
-- = alpha3 in coordinates; anti-up quark, colour b

-- v4: alpha1 * (alpha2 * omega)
noncomputable def v4 : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=-1/2, c3:=0, c4:=0, c5:=0, c6:=0, c7:=0 }
    im := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=0, c5:=1/2, c6:=0, c7:=0 } }
-- anti-down quark, colour rg

-- v5: alpha1 * (alpha3 * omega)
noncomputable def v5 : ComplexOctonion :=
  { re := { c0:=0, c1:=1/2, c2:=0, c3:=0, c4:=0, c5:=0, c6:=0, c7:=0 }
    im := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=0, c5:=0, c6:=-1/2, c7:=0 } }
-- anti-down quark, colour rb

-- v6: alpha2 * (alpha3 * omega)
noncomputable def v6 : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=-1/2, c4:=0, c5:=0, c6:=0, c7:=0 }
    im := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=-1/2, c5:=0, c6:=0, c7:=0 } }
-- anti-down quark, colour gb

/-- nu: the neutrino state = alpha1*(alpha2*(alpha3*omega)).
    This is the EMPTY state in the Fock-space picture (all modes removed).
    In the particle picture: the neutrino (Q=0, colour singlet). -/
noncomputable def nu : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=0, c5:=0, c6:=0, c7:=-1/2 }
    im := { c0:=1/2, c1:=0, c2:=0, c3:=0, c4:=0, c5:=0, c6:=0, c7:=0 } }
-- Neutrino: Q=0, colour singlet
```

### B2. Verify basis states match their definitions by product

```lean
-- Prove each state equals its product formula (right-associated)
theorem v1_eq : alpha1 * omega = v1 := by ext <;> simp [alpha1, omega, v1] <;> ring
theorem v2_eq : alpha2 * omega = v2 := by ext <;> simp [alpha2, omega, v2] <;> ring
theorem v3_eq : alpha3 * omega = v3 := by ext <;> simp [alpha3, omega, v3] <;> ring
theorem v4_eq : alpha1 * (alpha2 * omega) = v4 := by
  ext <;> simp [alpha1, alpha2, omega, v4] <;> ring
theorem v5_eq : alpha1 * (alpha3 * omega) = v5 := by
  ext <;> simp [alpha1, alpha3, omega, v5] <;> ring
theorem v6_eq : alpha2 * (alpha3 * omega) = v6 := by
  ext <;> simp [alpha2, alpha3, omega, v6] <;> ring
theorem nu_eq : alpha1 * (alpha2 * (alpha3 * omega)) = nu := by
  ext <;> simp [alpha1, alpha2, alpha3, omega, nu] <;> ring
```

### B3. Simple ideal membership: first 4 states satisfy j * omega = j

This holds for v0, v1, v2, v3 by a direct computation using right-alternativity.
The remaining states v4, v5, v6, nu belong to J in the operator sense
(produced by the Clifford algebra action) but NOT via the naive j*omega=j test
due to non-associativity of the nested products.

```lean
theorem omega_in_J : omega * omega = omega := omega_idempotent

theorem v1_in_J : v1 * omega = v1 := by ext <;> simp [v1, omega] <;> ring
theorem v2_in_J : v2 * omega = v2 := by ext <;> simp [v2, omega] <;> ring
theorem v3_in_J : v3 * omega = v3 := by ext <;> simp [v3, omega] <;> ring
```

---

## Part C — The creation operators kill nu (the neutrino)

nu is the EMPTY state. Applying any creation operator (alpha_k) to nu gives zero:

```lean
/-- The three creation operators annihilate nu.
    This is the hallmark of the Fock vacuum: no more particles can be added. -/
theorem alpha1_kills_nu : alpha1 * nu = 0 := by ext <;> simp [alpha1, nu] <;> ring
theorem alpha2_kills_nu : alpha2 * nu = 0 := by ext <;> simp [alpha2, nu] <;> ring
theorem alpha3_kills_nu : alpha3 * nu = 0 := by ext <;> simp [alpha3, nu] <;> ring
```

---

## Part D — The complete Cl(6) action table on J

**This is the core of the module structure proof.**

The six Clifford generators act on the 8 basis states as follows.
All 48 theorems are proved by `ext <;> simp [g, vk] <;> ring`.
The action table was computed and validated by numerical oracle.

### D1. Action of alpha1 (creation, mode 1)

```lean
-- alpha1 acts as a creation operator raising the mode-1 occupation number
theorem act_a1_omega : alpha1 * omega = v1 := v1_eq
theorem act_a1_v1 : alpha1 * v1 = 0 := by ext <;> simp [alpha1, v1] <;> ring
theorem act_a1_v2 : alpha1 * v2 = v4 := by ext <;> simp [alpha1, v2, v4] <;> ring
theorem act_a1_v3 : alpha1 * v3 = v5 := by ext <;> simp [alpha1, v3, v5] <;> ring
theorem act_a1_v4 : alpha1 * v4 = 0 := by ext <;> simp [alpha1, v4] <;> ring
theorem act_a1_v5 : alpha1 * v5 = 0 := by ext <;> simp [alpha1, v5] <;> ring
theorem act_a1_v6 : alpha1 * v6 = nu := by ext <;> simp [alpha1, v6, nu] <;> ring
theorem act_a1_nu : alpha1 * nu = 0 := alpha1_kills_nu
```

### D2. Action of alpha2 (creation, mode 2)

```lean
theorem act_a2_omega : alpha2 * omega = v2 := v2_eq
theorem act_a2_v1 : alpha2 * v1 = -v4 := by ext <;> simp [alpha2, v1, v4] <;> ring
theorem act_a2_v2 : alpha2 * v2 = 0 := by ext <;> simp [alpha2, v2] <;> ring
theorem act_a2_v3 : alpha2 * v3 = v6 := by ext <;> simp [alpha2, v3, v6] <;> ring
theorem act_a2_v4 : alpha2 * v4 = 0 := by ext <;> simp [alpha2, v4] <;> ring
theorem act_a2_v5 : alpha2 * v5 = -nu := by ext <;> simp [alpha2, v5, nu] <;> ring
theorem act_a2_v6 : alpha2 * v6 = 0 := by ext <;> simp [alpha2, v6] <;> ring
theorem act_a2_nu : alpha2 * nu = 0 := alpha2_kills_nu
```

### D3. Action of alpha3 (creation, mode 3)

```lean
theorem act_a3_omega : alpha3 * omega = v3 := v3_eq
theorem act_a3_v1 : alpha3 * v1 = -v5 := by ext <;> simp [alpha3, v1, v5] <;> ring
theorem act_a3_v2 : alpha3 * v2 = -v6 := by ext <;> simp [alpha3, v2, v6] <;> ring
theorem act_a3_v3 : alpha3 * v3 = 0 := by ext <;> simp [alpha3, v3] <;> ring
theorem act_a3_v4 : alpha3 * v4 = nu := by ext <;> simp [alpha3, v4, nu] <;> ring
theorem act_a3_v5 : alpha3 * v5 = 0 := by ext <;> simp [alpha3, v5] <;> ring
theorem act_a3_v6 : alpha3 * v6 = 0 := by ext <;> simp [alpha3, v6] <;> ring
theorem act_a3_nu : alpha3 * nu = 0 := alpha3_kills_nu
```

### D4. Action of alpha1_dag (annihilation, mode 1)

```lean
-- alpha1_dag acts as annihilation: removes mode-1 occupation
theorem act_a1d_omega : alpha1_dag * omega = 0 := alpha1_dag_kills_omega
theorem act_a1d_v1 : alpha1_dag * v1 = omega := by
  ext <;> simp [alpha1_dag, v1, omega] <;> ring
theorem act_a1d_v2 : alpha1_dag * v2 = 0 := by ext <;> simp [alpha1_dag, v2] <;> ring
theorem act_a1d_v3 : alpha1_dag * v3 = 0 := by ext <;> simp [alpha1_dag, v3] <;> ring
theorem act_a1d_v4 : alpha1_dag * v4 = v2 := by
  ext <;> simp [alpha1_dag, v4, v2] <;> ring
theorem act_a1d_v5 : alpha1_dag * v5 = v3 := by
  ext <;> simp [alpha1_dag, v5, v3] <;> ring
theorem act_a1d_v6 : alpha1_dag * v6 = 0 := by ext <;> simp [alpha1_dag, v6] <;> ring
theorem act_a1d_nu : alpha1_dag * nu = v6 := by
  ext <;> simp [alpha1_dag, nu, v6] <;> ring
```

### D5. Action of alpha2_dag (annihilation, mode 2)

```lean
theorem act_a2d_omega : alpha2_dag * omega = 0 := alpha2_dag_kills_omega
theorem act_a2d_v1 : alpha2_dag * v1 = 0 := by ext <;> simp [alpha2_dag, v1] <;> ring
theorem act_a2d_v2 : alpha2_dag * v2 = omega := by
  ext <;> simp [alpha2_dag, v2, omega] <;> ring
theorem act_a2d_v3 : alpha2_dag * v3 = 0 := by ext <;> simp [alpha2_dag, v3] <;> ring
theorem act_a2d_v4 : alpha2_dag * v4 = -v1 := by
  ext <;> simp [alpha2_dag, v4, v1] <;> ring
theorem act_a2d_v5 : alpha2_dag * v5 = 0 := by ext <;> simp [alpha2_dag, v5] <;> ring
theorem act_a2d_v6 : alpha2_dag * v6 = v3 := by
  ext <;> simp [alpha2_dag, v6, v3] <;> ring
theorem act_a2d_nu : alpha2_dag * nu = -v5 := by
  ext <;> simp [alpha2_dag, nu, v5] <;> ring
```

### D6. Action of alpha3_dag (annihilation, mode 3)

```lean
theorem act_a3d_omega : alpha3_dag * omega = 0 := alpha3_dag_kills_omega
theorem act_a3d_v1 : alpha3_dag * v1 = 0 := by ext <;> simp [alpha3_dag, v1] <;> ring
theorem act_a3d_v2 : alpha3_dag * v2 = 0 := by ext <;> simp [alpha3_dag, v2] <;> ring
theorem act_a3d_v3 : alpha3_dag * v3 = omega := by
  ext <;> simp [alpha3_dag, v3, omega] <;> ring
theorem act_a3d_v4 : alpha3_dag * v4 = 0 := by ext <;> simp [alpha3_dag, v4] <;> ring
theorem act_a3d_v5 : alpha3_dag * v5 = -v1 := by
  ext <;> simp [alpha3_dag, v5, v1] <;> ring
theorem act_a3d_v6 : alpha3_dag * v6 = -v2 := by
  ext <;> simp [alpha3_dag, v6, v2] <;> ring
theorem act_a3d_nu : alpha3_dag * nu = v4 := by
  ext <;> simp [alpha3_dag, nu, v4] <;> ring
```

---

## Part E — Number operators and their eigenvalues

The number operator for mode k is N_k(x) = alpha_k_dag * (alpha_k * x).
Because ℂ⊗𝕆 is non-associative, this is evaluated as alpha_k_dag * (alpha_k * x)
(right-to-left), NOT as (alpha_k_dag * alpha_k) * x.

The eigenvalues were computed numerically by the oracle:
  N1: omega=1, v1=0, v2=1, v3=1, v4=0, v5=0, v6=1, nu=0
  N2: omega=1, v1=1, v2=0, v3=1, v4=0, v5=1, v6=0, nu=0
  N3: omega=1, v1=1, v2=1, v3=0, v4=1, v5=0, v6=0, nu=0

**Proof strategy**: Each N_k(v) theorem is proved by chaining two of the
action-table theorems already proved above. For example:
  N1(v1) = alpha1_dag * (alpha1 * v1) = alpha1_dag * 0 = 0

```lean
-- Number operator theorems: N_k(basis_state) = eigenvalue * basis_state
-- Proof: unfold as two-step left multiplication using action table results.

-- N1 eigenvalues (mode 1 occupation)
theorem N1_omega : alpha1_dag * (alpha1 * omega) = omega := by
  rw [act_a1_omega, act_a1d_v1]
theorem N1_v1 : alpha1_dag * (alpha1 * v1) = 0 := by
  rw [act_a1_v1]; simp
theorem N1_v2 : alpha1_dag * (alpha1 * v2) = v2 := by
  rw [act_a1_v2, act_a1d_v4]
theorem N1_v3 : alpha1_dag * (alpha1 * v3) = v3 := by
  rw [act_a1_v3, act_a1d_v5]
theorem N1_v4 : alpha1_dag * (alpha1 * v4) = 0 := by
  rw [act_a1_v4]; simp
theorem N1_v5 : alpha1_dag * (alpha1 * v5) = 0 := by
  rw [act_a1_v5]; simp
theorem N1_v6 : alpha1_dag * (alpha1 * v6) = v6 := by
  rw [act_a1_v6, act_a1d_nu]
theorem N1_nu : alpha1_dag * (alpha1 * nu) = 0 := by
  rw [act_a1_nu]; simp

-- N2 eigenvalues (mode 2 occupation)
theorem N2_omega : alpha2_dag * (alpha2 * omega) = omega := by
  rw [act_a2_omega, act_a2d_v2]
theorem N2_v1 : alpha2_dag * (alpha2 * v1) = v1 := by
  rw [act_a2_v1]; simp [act_a2d_v4]; ring
-- (Note: act_a2_v1 gives -v4, and act_a2d applied to -v4 gives -(-v1) = v1)
theorem N2_v2 : alpha2_dag * (alpha2 * v2) = 0 := by rw [act_a2_v2]; simp
theorem N2_v3 : alpha2_dag * (alpha2 * v3) = v3 := by
  rw [act_a2_v3, act_a2d_v6]
theorem N2_v4 : alpha2_dag * (alpha2 * v4) = 0 := by rw [act_a2_v4]; simp
theorem N2_v5 : alpha2_dag * (alpha2 * v5) = v5 := by
  rw [act_a2_v5]; simp [act_a2d_nu]; ring
theorem N2_v6 : alpha2_dag * (alpha2 * v6) = 0 := by rw [act_a2_v6]; simp
theorem N2_nu : alpha2_dag * (alpha2 * nu) = 0 := by rw [act_a2_nu]; simp

-- N3 eigenvalues (mode 3 occupation)
theorem N3_omega : alpha3_dag * (alpha3 * omega) = omega := by
  rw [act_a3_omega, act_a3d_v3]
theorem N3_v1 : alpha3_dag * (alpha3 * v1) = v1 := by
  rw [act_a3_v1]; simp [act_a3d_v5]; ring
theorem N3_v2 : alpha3_dag * (alpha3 * v2) = v2 := by
  rw [act_a3_v2]; simp [act_a3d_v6]; ring
theorem N3_v3 : alpha3_dag * (alpha3 * v3) = 0 := by rw [act_a3_v3]; simp
theorem N3_v4 : alpha3_dag * (alpha3 * v4) = v4 := by
  rw [act_a3_v4, act_a3d_nu]
theorem N3_v5 : alpha3_dag * (alpha3 * v5) = 0 := by rw [act_a3_v5]; simp
theorem N3_v6 : alpha3_dag * (alpha3 * v6) = 0 := by rw [act_a3_v6]; simp
theorem N3_nu : alpha3_dag * (alpha3 * nu) = 0 := by rw [act_a3_nu]; simp
```

**If the rw-based proofs above fail due to non-associativity preventing
rewriting under the outer left multiplication**, fall back to:
```lean
ext <;> simp [alpha1_dag, alpha1, omega] <;> ring
```
This always works because it reduces to ℝ arithmetic directly.

---

## Part F — Electric charge formula and SM particle identification

The electric charge operator in Furey's construction is:
  Q = -(1/3)(N1 + N2 + N3)

The charge eigenvalues on the 8 basis states (oracle-verified) are:
  omega: Q = -(1/3)(1+1+1) = -1       → electron
  v1:    Q = -(1/3)(0+1+1) = -2/3     → anti-up quark, colour r
  v2:    Q = -(1/3)(1+0+1) = -2/3     → anti-up quark, colour g
  v3:    Q = -(1/3)(1+1+0) = -2/3     → anti-up quark, colour b
  v4:    Q = -(1/3)(0+0+1) = -1/3     → anti-down quark, colour rg
  v5:    Q = -(1/3)(0+1+0) = -1/3     → anti-down quark, colour rb
  v6:    Q = -(1/3)(1+0+0) = -1/3     → anti-down quark, colour gb
  nu:    Q = -(1/3)(0+0+0) = 0        → neutrino

The charge is expressed using real-number arithmetic (no division needed in the
theorem statement; use 3 * Q = -(N1+N2+N3) to avoid ℝ division).

```lean
/-- Electric charge formula: 3*Q = -(N1 + N2 + N3).
    We use 3*Q to keep the statement over ℤ-valued quantities.
    The 8 basis states have charges: electron(-1), anti-up×3(-2/3),
    anti-down×3(-1/3), neutrino(0). -/

-- Charge -1: electron (3*Q = -3, so 3*|Q| = 3*1 = 3)
theorem charge_omega : -- 3Q(omega) = -3
    alpha1_dag * (alpha1 * omega) + alpha2_dag * (alpha2 * omega)
    + alpha3_dag * (alpha3 * omega) = 3 • omega := by
  simp [N1_omega, N2_omega, N3_omega]
  -- LHS = omega + omega + omega = 3*omega
  ext <;> simp [omega] <;> ring

-- Charge -2/3: anti-up triplet (3*Q = -2, sum of N_k = 2)
theorem charge_v1 :
    alpha1_dag * (alpha1 * v1) + alpha2_dag * (alpha2 * v1)
    + alpha3_dag * (alpha3 * v1) = 2 • v1 := by
  simp [N1_v1, N2_v1, N3_v1]
  ext <;> simp [v1] <;> ring

theorem charge_v2 :
    alpha1_dag * (alpha1 * v2) + alpha2_dag * (alpha2 * v2)
    + alpha3_dag * (alpha3 * v2) = 2 • v2 := by
  simp [N1_v2, N2_v2, N3_v2]
  ext <;> simp [v2] <;> ring

theorem charge_v3 :
    alpha1_dag * (alpha1 * v3) + alpha2_dag * (alpha2 * v3)
    + alpha3_dag * (alpha3 * v3) = 2 • v3 := by
  simp [N1_v3, N2_v3, N3_v3]
  ext <;> simp [v3] <;> ring

-- Charge -1/3: anti-down triplet (sum of N_k = 1)
theorem charge_v4 :
    alpha1_dag * (alpha1 * v4) + alpha2_dag * (alpha2 * v4)
    + alpha3_dag * (alpha3 * v4) = 1 • v4 := by
  simp [N1_v4, N2_v4, N3_v4]
  ext <;> simp [v4] <;> ring

theorem charge_v5 :
    alpha1_dag * (alpha1 * v5) + alpha2_dag * (alpha2 * v5)
    + alpha3_dag * (alpha3 * v5) = 1 • v5 := by
  simp [N1_v5, N2_v5, N3_v5]
  ext <;> simp [v5] <;> ring

theorem charge_v6 :
    alpha1_dag * (alpha1 * v6) + alpha2_dag * (alpha2 * v6)
    + alpha3_dag * (alpha3 * v6) = 1 • v6 := by
  simp [N1_v6, N2_v6, N3_v6]
  ext <;> simp [v6] <;> ring

-- Charge 0: neutrino (sum of N_k = 0)
theorem charge_nu :
    alpha1_dag * (alpha1 * nu) + alpha2_dag * (alpha2 * nu)
    + alpha3_dag * (alpha3 * nu) = 0 := by
  simp [N1_nu, N2_nu, N3_nu]
```

---

## Part G — SU(3) colour symmetry generators

The SU(3) colour generators act within the triplet sectors. Define them as:

```lean
-- SU(3) generators (Gell-Mann style, from ladder bilinears)
-- These act on the anti-up triplet {v1, v2, v3} and anti-down triplet {v4, v5, v6}

/-- T12: raises colour g->r (mode 2 → mode 1 generator)
    Acts as: v2 ↦ v1, v1 ↦ 0 on the triplet sector. -/
noncomputable def T12 : ComplexOctonion := alpha1 * alpha2_dag

/-- T21: raises colour r->g -/
noncomputable def T21 : ComplexOctonion := alpha2 * alpha1_dag

/-- T13: raises colour b->r -/
noncomputable def T13 : ComplexOctonion := alpha1 * alpha3_dag

/-- T31: raises colour r->b -/
noncomputable def T31 : ComplexOctonion := alpha3 * alpha1_dag

/-- T23: raises colour b->g -/
noncomputable def T23 : ComplexOctonion := alpha2 * alpha3_dag

/-- T32: raises colour g->b -/
noncomputable def T32 : ComplexOctonion := alpha3 * alpha2_dag

-- SU(3) action on anti-up triplet {v1, v2, v3}:
-- Prove T12 maps v2 -> v1, T21 maps v1 -> v2, etc.
-- These follow from the action table: alpha1*(alpha2_dag*v2) = alpha1*omega = v1
-- Note: in non-associative algebra, (alpha1 * alpha2_dag) * v2
--       is NOT the same as alpha1 * (alpha2_dag * v2) in general!
-- Use the explicit coordinate proofs:
theorem T12_on_v2 : T12 * v2 = 0 := by  -- T12*v2 acts in operator sense
  unfold T12; ext <;> simp [alpha1, alpha2_dag, v2] <;> ring
-- (The actual SU(3) action is via OPERATOR composition, not algebra product.)

-- Note to Aristotle: The SU(3) symmetry in Furey's sense is the symmetry of
-- the OPERATORS L_{alpha_k}, not of products in ℂ⊗𝕆. Computing T12*v_k as
-- a product in ℂ⊗𝕆 may give different results than the operator composition
-- L_{T12}(v_k) = T12*(v_k). Include whatever can be proved.
```

---

## Part H — Non-zero status of all 8 states

```lean
-- Prove each basis state is non-zero (required for linear independence)
theorem omega_ne_zero : omega ≠ 0 := by
  intro h; have := congr_arg ComplexOctonion.re h
  simp [omega] at this

theorem v1_ne_zero : v1 ≠ 0 := by
  intro h; have := congr_arg (fun x => x.re) h; simp [v1] at this
-- (Similar for v2, v3, v4, v5, v6, nu)
theorem v2_ne_zero : v2 ≠ 0 := by intro h; have := congr_arg (fun x => x.re) h; simp [v2] at this
theorem v3_ne_zero : v3 ≠ 0 := by intro h; have := congr_arg (fun x => x.re) h; simp [v3] at this
theorem v4_ne_zero : v4 ≠ 0 := by intro h; have := congr_arg (fun x => x.re) h; simp [v4] at this
theorem v5_ne_zero : v5 ≠ 0 := by intro h; have := congr_arg (fun x => x.re) h; simp [v5] at this
theorem v6_ne_zero : v6 ≠ 0 := by intro h; have := congr_arg (fun x => x.re) h; simp [v6] at this
theorem nu_ne_zero : nu ≠ 0 := by intro h; have := congr_arg (fun x => x.re) h; simp [nu] at this
```

---

## Part I — Update the module docstring

Replace the current "## Status" and "## Basis of J" sections with the correct
picture:

```
## Basis of J

A ℂ-basis of J consists of 8 explicitly computed states (oracle-validated):
  omega = (1/2)(1 - i·e111)          anti-electron / electron (Q=-1)
  v1 = alpha1 * omega                 anti-up quark, colour r  (Q=-2/3)
  v2 = alpha2 * omega                 anti-up quark, colour g  (Q=-2/3)
  v3 = alpha3 * omega                 anti-up quark, colour b  (Q=-2/3)
  v4 = alpha1 * (alpha2 * omega)      anti-down quark, colours rg  (Q=-1/3)
  v5 = alpha1 * (alpha3 * omega)      anti-down quark, colours rb  (Q=-1/3)
  v6 = alpha2 * (alpha3 * omega)      anti-down quark, colours gb  (Q=-1/3)
  nu  = alpha1*(alpha2*(alpha3*omega)) neutrino (Q=0)

Note: ALL products are RIGHT-associated. (alpha1*alpha2)*omega ≠ alpha1*(alpha2*omega)
in the non-associative algebra ℂ⊗𝕆.

Key structural facts:
- alpha_k * omega = alpha_k  (creation operators reproduce themselves on omega)
- alpha_k_dag * omega = 0    (annihilation operators kill the filled state)
- alpha_k * nu = 0           (creation operators kill the empty state)
- N_k eigenvalues encode the charge: Q = -(1/3)(N1+N2+N3)

## Status

Milestone 6 (Furey-style algebraic SM structure) — In progress.
omega, 8 basis states, complete Cl(6) action table, number operators,
and charge assignments proved.
```

---

## Constraints

1. **No sorry.** No admit. No new axioms. All 48+ theorems must be fully proved.
2. **Do not re-define** alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag
   or any existing theorem from LadderOperators.lean.
3. All defs using ℝ division (1/2) must be `noncomputable`.
4. For any theorem where `ext <;> simp [...] <;> ring` fails: try
   `ext <;> simp [...] <;> norm_num` or `ext <;> simp (config := {decide:=true}) [...]`.
5. For the N_k theorems: if the rw-chain proof fails, use the fallback
   `ext <;> simp [alpha1_dag, alpha1, vk] <;> ring` directly.
6. Keep all definitions and theorems inside `namespace PhysicsSM.Algebra.Furey.MinimalLeftIdeal`.

---

## Verification

```bash
lake env lean PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean
```

No errors, no sorry permitted. Report all proved theorems and any that required
substituting a different proof strategy.
