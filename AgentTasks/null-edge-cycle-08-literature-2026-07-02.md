# Null-edge cycle 08 literature/tooling notes

Date: 2026-07-02

Focus: while the exponential/stability Aristotle jobs continue running, check
whether Mathlib's scoped L2 operator norm gives a cleaner unitary-stability
route than the L-infinity operator norm.

## Sources checked

1. Mathlib documentation/source,
   `Mathlib.Analysis.CStarAlgebra.Matrix`.
   Source:
   https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/CStarAlgebra/Matrix.html

   Relevance: this file transports the Hilbert-space operator norm on
   Euclidean-space continuous linear maps to finite matrices through the scoped
   `Matrix.Norms.L2Operator` namespace. It also records C-star structure and
   entrywise bounds for unitary matrices. This is likely the semantically best
   norm for quantum-walk unitarity and long-product stability.

2. Mathlib documentation/source,
   `Mathlib.LinearAlgebra.UnitaryGroup`.
   Source:
   https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/UnitaryGroup.html

   Relevance: defines `Matrix.unitaryGroup` and basic star/unitary facts. This
   is the likely API for proving that `nullShiftSymbol`, `isotropicStep`, and
   hence `momentumStepSymbolRaw` are unitary one-step factors.

3. Mathlib documentation/source,
   `Mathlib.Analysis.Matrix.Normed`.
   Source:
   https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Matrix/Normed.html

   Relevance: remains useful for the scoped L-infinity operator norm and for
   comparison with entrywise error estimates.

## Cycle-08 conclusion

The L-infinity route is already useful and lightweight, but the scoped L2
operator norm may be more physically faithful: unitary evolution should have
operator norm `1`, which is exactly the stability behavior wanted for long
products. The next Aristotle job asks for L2 operator-norm bridge facts and, if
feasible, a proof that `momentumStepSymbolRaw` is unitary.
