# Aristotle target: classify interaction preservation of a finite sector

Work only on `SectorInteractionClassification.lean` and run:

```text
lake env lean SectorInteractionClassification.lean
```

The central target is `commutes_sectorProjector_iff`: a finite Hamiltonian
commutes with the diagonal selected-sector projector exactly when every matrix
entry crossing the selected/complement boundary vanishes.  Then prove that the
exact time exponential also commutes and discharge the explicit Hermitian
Pluecker pair-transfer witness.

You may add small helper lemmas and use existing Mathlib matrix-exponential
commutation APIs.  Preserve arbitrary finite `n`; do not replace the general
classification by only the `Fin 2` witness.  Keep the explicit `3+4i`
nondegenerate control.  Do not add assumptions or escape hatches.  Finish with
a concise report listing statement changes, proof holes, and axiom footprint.
