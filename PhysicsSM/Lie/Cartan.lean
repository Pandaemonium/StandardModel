/-!
# Lie.Cartan

Cartan type data and notation for semisimple Lie algebras.

The simple Lie algebras are classified by Dynkin diagrams of types:
  A_n (n ≥ 1), B_n (n ≥ 2), C_n (n ≥ 3), D_n (n ≥ 4),
  E_6, E_7, E_8, F_4, G_2

This module provides type-safe notation and data for Cartan types as used
throughout the project.

Mathlib provides root system infrastructure in:
  `Mathlib.LinearAlgebra.RootSystem.Basic`
  `Mathlib.LinearAlgebra.RootSystem.Finite.Lemmas`

Source: Humphreys, "Introduction to Lie Algebras" (1972).
Convention: Bourbaki labelling of Dynkin diagrams.

Status: stub — Cartan type enumeration and basic data to be added.
-/

namespace PhysicsSM.Lie

/-- Cartan type of a simple Lie algebra. -/
inductive CartanType
  | A (n : ℕ) : CartanType  -- sl(n+1), n ≥ 1
  | B (n : ℕ) : CartanType  -- so(2n+1), n ≥ 2
  | C (n : ℕ) : CartanType  -- sp(2n), n ≥ 3
  | D (n : ℕ) : CartanType  -- so(2n), n ≥ 4
  | E6 : CartanType
  | E7 : CartanType
  | E8 : CartanType
  | F4 : CartanType
  | G2 : CartanType

end PhysicsSM.Lie
