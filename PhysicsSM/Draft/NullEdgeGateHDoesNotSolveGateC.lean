import PhysicsSM.Draft.NullEdgeGateCSplit

/-!
# Gate H does not solve Gate C by factorization

This draft module records the core guardrail returned by the Wave 20 / C87
audit:

If the null-edge branch problem lives on an external factor `H_N`, while the
Furey/Baez/internal chirality data live on an internal factor `H_F`, then the
internal sector cannot repair a zero external chiral index by itself.

The model here is deliberately minimal. We represent the external chiral index
and internal multiplicity as integers, with a factorized total index

```text
totalIndex = externalIndex * internalMultiplicity.
```

Thus an origin-balanced external sector (`externalIndex = 0`) forces
`totalIndex = 0`, no matter how interesting the internal representation is.
This is a claim-discipline theorem, not a full analytic index theorem.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdgeGateHDoesNotSolveGateC

open NullEdgeGateCSplit

/-- Abstract factorized chiral-index data for a product Hilbert space. -/
structure FactorizedChiralIndexData where
  externalIndex : ℤ
  internalMultiplicity : ℤ

namespace FactorizedChiralIndexData

/-- The factorized total index. -/
def totalIndex (D : FactorizedChiralIndexData) : ℤ :=
  D.externalIndex * D.internalMultiplicity

/--
If the external chiral index is zero, the factorized total index is zero.

This is the compact algebraic reason Gate H cannot, by itself, repair a
balanced external branch sector.
-/
theorem totalIndex_zero_of_external_zero (D : FactorizedChiralIndexData)
    (h : D.externalIndex = 0) :
    D.totalIndex = 0 := by
  simp [totalIndex, h]

/--
If the total index is nonzero, then the external index must already be nonzero.

Equivalently: a nonzero Standard-Model-facing chiral index cannot arise from a
purely internal multiplicity factor when the external seed has index zero.
-/
theorem external_nonzero_of_total_nonzero (D : FactorizedChiralIndexData)
    (h : D.totalIndex ≠ 0) :
    D.externalIndex ≠ 0 := by
  intro hz
  exact h (D.totalIndex_zero_of_external_zero hz)

end FactorizedChiralIndexData

/--
Claim-discipline guardrail: Gate H compatibility plus a zero external index
does not imply full staged Gate C release if the C1 layer demands a nonzero
total chiral index.
-/
theorem gateH_cannot_supply_nonzero_index_from_zero_external
    (D : FactorizedChiralIndexData)
    (hExt : D.externalIndex = 0)
    (hWanted : D.totalIndex ≠ 0) :
    False :=
  hWanted (D.totalIndex_zero_of_external_zero hExt)

/--
Gate H compatibility alone cannot replace the C1 chiral-release layer in the
staged Gate C API.
-/
theorem gateH_compatible_not_chiral_release {D : StagedGateCData}
    (_hH : GateHCompatible D.h)
    (hnot : ¬ GateC1ChiralPhysicalRelease D.c1) :
    ¬ StagedGateCReleased D := by
  intro hrel
  exact hnot hrel.c1

end NullEdgeGateHDoesNotSolveGateC
end Draft
end PhysicsSM
