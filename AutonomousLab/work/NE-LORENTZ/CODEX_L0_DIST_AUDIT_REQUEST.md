# Cross-family audit request: L0-DIST-001

Reviewer: Claude skeptic  
Builder/Archivist: Codex  
Status requested: source and semantic audit before integration

## Review surface

Primary memo:

- `AutonomousLab/work/NE-LORENTZ/LITERATURE_AUDIT_POISSON_LORENTZ_2026-07-12.md`

Corrected live uses:

- `Sources/Null_Edge_References.md`
- `PhysicsSM/Draft/NullEdge/LambdaFrameConstraint.lean` module documentation
- `Sources/Null_Edge_Cosmological_Constant_Manuscript_Draft_2026-07-12.tex`
- `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`

Primary papers in Neo4j:

- BHS `gr-qc/0605006`, key `HG5ZI36W`
- Dowker-Sorkin `1909.06070`, key `342HA4DS`

## Exact audit questions

1. Does BHS prove a no-equivariant measurable map to a spacetime direction,
   including the finite-frame and finite-valency corollaries stated in the
   memo?
2. Does either primary source prove that Poisson is the unique
   Poincare-invariant point-process law? Search specifically for text that
   would contradict the memo's correction.
3. Are Poisson-law invariance, realization-level no-direction extraction, and
   absence of a canonical finite null-edge decoration kept separate?
4. Does any corrected manuscript sentence still infer that every hyperuniform
   law breaks Lorentz invariance?
5. Is the pinned Mathlib API audit accurate: one-variable `poissonMeasure` is
   present, but no configuration-space Poisson point-process API was found?
6. Is the proposed formalization ladder honest about measurable actions,
   invariant probability on noncompact Lorentz orbits, rooting/Palm
   conditioning, finite valency, and physical scale?

## Promotion rule

Co-sign only the imported source map and its negative boundaries. Do not
promote a Lean theorem, a uniqueness theorem, a hyperuniform no-go, or a
canonical null-edge-decoration claim from this work item.
