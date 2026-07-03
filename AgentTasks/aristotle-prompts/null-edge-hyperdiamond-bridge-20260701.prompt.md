# Aristotle prompt: hyperdiamond bridge and assumption ledger

You are working in a focused Lean 4 package extracted from the `PhysicsSM`
null-edge standalone package. Run the narrow checks first:

```text
lake env lean PhysicsSM/Draft/NullEdgeHyperdiamondNoGo.lean
lake env lean PhysicsSM/NullStrand/DualSolder/DualSolderSymbolKinetic.lean
```

## Context

The current finite Gate C result is a no-go for the bare high-momentum
tetrahedral Clifford symbol:

- `PhysicsSM.Draft.NullEdgeActualCliffordSymbol.no_full_symbol_single_chirality`
- `PhysicsSM.Draft.NullEdgeHyperdiamondNoGo.no_branch_single_sign`
- `PhysicsSM.Draft.NullEdgeHyperdiamondNoGo.highMomentum_branch_nogo`

The dual-soldered layer separately proves tetrahedral frame and covector
reconstruction facts, including:

- `PhysicsSM.NullStrand.DualSolder.Tetrahedron.ell_isNull`
- `PhysicsSM.NullStrand.DualSolder.Tetrahedron.alpha_ell_delta`
- `PhysicsSM.NullStrand.DualSolder.dualSymbol_reconstructs_covector`
- `PhysicsSM.NullStrand.DualSolder.dualSolder_commutator_exact`

The docs currently state that the exact bridge between the dual-soldered
difference-operator architecture and the Gate C high-momentum `cliffordSymbol`
is not proved. Do not claim Borici-Creutz or hyperdiamond equivalence unless
there is a concrete Lean definition and an explicit convention map.

## Goals

Please work on the highest-value bridge/audit content:

1. Determine whether a meaningful theorem can be proved now connecting the
   dual-soldered tetrahedral frame data to the Gate C `cliffordSymbol` data.
   If yes, add a small module such as
   `PhysicsSM/Draft/NullEdgeHyperdiamondBridge.lean` with exact theorem
   statements and proofs. If no, return a precise mismatch report naming the
   missing definitions or convention maps.

2. Propose exact Lean statements for:
   - `dualSolder_symbol_matches_gateC_symbol`
   - `hyperdiamond_crosswalk_exact`
   - `nielsenNinomiya_assumption_ledger`

3. If any statement is immediately provable without adding physical
   assumptions, prove it. Otherwise keep it as a report, not as unfinished Lean.

4. Audit `chiralProj` from `NullEdgeHyperdiamondNoGo`: state exactly what would
   be needed to upgrade it from a sufficient chirality projector to physical
   projected-operator data. Focus on locality/finite range, gauge covariance,
   Krein sign, and whether branch data are derived from an operator.

## Output requirements

- Return modified Lean files only if they compile.
- No placeholder proofs, new assumptions, or fake declarations.
- Keep no-go, reconstruction, conditional schema, and physical-release claims
  separate.
- Produce a concise report even if no Lean theorem is added.
