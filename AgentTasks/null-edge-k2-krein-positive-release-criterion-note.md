# K2 Krein-positive physical-sector release criterion -- returned summary

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run 190713c9-97bf-4dbe-a8dc-2922fc87fc39
The focused package did not ship the standalone report file; this is the
returned summary, preserved verbatim as the integration record.

---

## K2: Krein-positive physical-sector release criterion after C22

I delivered a precise *conditional* Krein-positivity release criterion, with no false positivity claim, and fixed the project so it builds end-to-end.

### Build repair (prerequisite)
The delivered tree did not compile: the C22/Gate C files imported two modules that were absent (`PhysicsSM.Draft.TetrahedralHighMomentumNullBranch` and `PhysicsSM.Draft.KreinDoubleAndCounterexamples`). I reconstructed faithful, fully-proved (no `sorry`, no new axioms) minimal versions of both, exactly matching the black-box interfaces the existing files use:
- `PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean`: `cornerCount`, `cornerU`, the Lorentzian form `qform` (signature `(1,3)`), and the classification `threePi_null` (every three-π corner is nonzero and null) plus `count_highMomentumNull = 4`.
- `PhysicsSM/Draft/KreinDoubleAndCounterexamples.lean`: the fundamental symmetry `J2`, the Krein adjoint `sharp`, and `jselfadj_not_stable` — a `J`-self-adjoint matrix with eigenvalue `1+i` (Re > 0), i.e. Krein self-adjointness ≠ stability.

The full project now builds (8032 jobs) and the existing C22 modules compile unchanged.

### The K2 module: `PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean`
Since C22 already proves the modeled branch Krein pattern is `(+,−,+,−)` (so not all branches are Krein-positive), the criterion is built around a **physical-sector projection**, not a blanket positivity claim:

- `sectorProj sel` — projector onto the branches retained by a selector; `KreinPositiveSector P := kreinJ * P = P` (the modeled Krein metric restricts to `+1`, i.e. positive-definite, on the range of `P`).
- `kreinJ_Pbranch`: the Krein metric acts on branch `a` by its signature `branchKreinSig a`.
- **General sufficient condition** `sectorProj_kreinPositive`: any sector whose retained branches all have Krein signature `+1` is Krein-positive.
- **Canonical physical sector** `physSel`/`Pphys = Pbranch 0 + Pbranch 2`: retains exactly the Krein-positive branches. Proved idempotent, symmetric, rank 2; `Pphys_kreinPositive` and `Pphys_krein_form` (`Pphys·J·Pphys = Pphys`).
- **Species splitting made explicit**: `retained_dirac_pair` shows the retained pair `{0,2}` is one left-chiral + one right-chiral mode, both Krein-positive (a healthy Dirac pair); `discarded_krein_negative`/`discarded_ghost_pair` show the projected-out pair `{1,3}` is *exactly* the Krein-negative ghost sector — the negative branches are explicitly excluded, not hidden.
- **The deliverable release theorem** `physical_sector_releases`: the physical sector satisfies the sector-restricted predicate `ReleasesKreinPositiveOnSector` (aligned chirality and Krein-positive on every retained branch), with `releasesOnSector_imp_kreinPositive` bridging to the matrix-level positivity.
- **Sharpness**: `Pnull_krein_indefinite` (full sector is indefinite), `releasesKreinPositive_iff_full` (C22's `ReleasesKreinPositive` is exactly the unsatisfiable "retain-everything" instance), `full_sector_not_releases` (re-derives C22's negative result), and `kreinPositive_sector_subset_phys` (`physSel` is the maximal Krein-positive sector).
- `k2_physical_sector_release_summary` bundles the result.

All new theorems are proved with no `sorry` and use only standard axioms (`propext`, `Classical.choice`, `Quot.sound`). Everything is for the modeled Wave-8 gradings, consistent with C22's honest scope: the upstream `OperatorForcesAlignment` obligation (identifying actual operator branch chirality with `g5`) remains the only residual, now cleanly separated from the positivity question this module resolves.
