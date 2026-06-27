import PhysicsSM.Algebra.Furey.LadderOperators

/-!
# Algebra.Furey.CliffordConnection

The connection between the complexified octonion algebra ℂ⊗𝕆 and Cl(6).

## The main result

Left multiplication by the six elements
  alpha_1, alpha_2, alpha_3, alpha_1†, alpha_2†, alpha_3†  ∈  ℂ⊗𝕆
generates a Clifford algebra Cl(6) acting on the minimal left ideal J.

More precisely, the maps
  L_{alpha_k} : J -> J   (left multiplication by alpha_k)
  L_{alpha_k†}: J -> J
satisfy the Cl(6) Clifford relations:
  L_{alpha_k} L_{alpha_l†} + L_{alpha_l†} L_{alpha_k} = delta_{kl} * Id_J
  L_{alpha_k} L_{alpha_l}  + L_{alpha_l}  L_{alpha_k} = 0

This is the algebraic source of spin-1/2 for SM fermions.

## Relation to mathlib Clifford algebras

Mathlib provides `CliffordAlgebra` in `Mathlib.LinearAlgebra.CliffordAlgebra.Basic`.
The identification of L_{alpha_k}, L_{alpha_k†} with Clifford generators should
use that infrastructure.

## Sources

Source: Furey, arXiv:1806.00612, Section 2, and
        Furey, arXiv:1805.06631, Section 3.
Mathlib: `Mathlib.LinearAlgebra.CliffordAlgebra.Basic`.

## Status

Stub — requires `ComplexOctonion.Mul`, active ladder operator definitions,
and the minimal left ideal. This module is a medium-term target.
-/

namespace PhysicsSM.Algebra.Furey.CliffordConnection

end PhysicsSM.Algebra.Furey.CliffordConnection
