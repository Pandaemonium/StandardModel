# C65: Canonical physical-species selector — report

**Status:** complete, kernel-checked (Lean 4 / Mathlib, toolchain v4.28.0).
**Module:** `PhysicsSM/Draft/NullEdgeCanonicalSpeciesSelector.lean`
(namespace `PhysicsSM.Draft.NullEdgeCanonicalSpeciesSelector`).
**Imported into:** `PhysicsSMDraft.lean`.
**Axioms of the bundled verdict `c65_verdict`:** `propext`, `Classical.choice`,
`Quot.sound` (no `sorry`, no extra axioms, no `native_decide`).

## Question

`NullEdgeKreinPositiveReleaseCriterion` (K2) retains the modeled physical sector
`{0, 2}` as the Krein-positive pair. `NullEdgeSymmetryForcedSpeciesSplit`
(C45/C46) shows the `2+2` species split is a *modulus* under the currently
formalized bare tetrahedral symmetry `S₄`. Is the retained sector `{0, 2}`
**canonical** (forced by the locked structures) or **conventional** (a choice)?

## Answer (one line)

`{0, 2}` is **conditionally canonical**: it is the unique, rigid, maximal
Krein-positive selector **relative to the locked Krein-sign data**, but it is
**not** determined by chirality / taste / energy / grading alone — only the Krein
sign breaks the branch degeneracy that fixes it. Since C45/C46 shows the
Krein/species-sign *assignment itself* is a modulus under the bare symmetry,
`{0, 2}` is canonical iff the Krein sign is declared as locked input.

## Candidate selector data formalized

`SelectorData` records the five candidate per-branch attributes named in the
task: branch chirality, Krein sign, orientation/taste, energy sign, internal
grading. The modeled instance `modeledData` uses the kernel-checked C22 values:

| branch `a` | chirality `g5` | Krein sign | taste | energy | grading |
|:----------:|:--------------:|:----------:|:-----:|:------:|:-------:|
|     0      |      `+1`      |    `+1`    | `+1`  |  `+1`  |  `+1`   |
|     1      |      `+1`      |    `−1`    | `+1`  |  `+1`  |  `+1`   |
|     2      |      `−1`      |    `+1`    | `−1`  |  `+1`  |  `−1`   |
|     3      |      `−1`      |    `−1`    | `−1`  |  `+1`  |  `−1`   |

The modeled `taste`, `energy`, `grading` are deliberately **chirality-determined**
(or globally constant): they carry no branch information beyond the chirality.
Only the Krein sign further splits each chirality class. (Branch chirality and
Krein sign are reused verbatim from `NullEdgeBranchKreinSignatures`:
`branchChirality`, `branchKreinSig`.)

## What is proved

1. **Uniqueness given Krein** — `kreinSelector_unique`: the selector retaining
   exactly the Krein-positive branches is the unique such selector. On the
   modeled data it is *definitionally* the K2 selector `physSel`
   (`modeledSelector_eq_physSel`) and equals `![true, false, true, false]` =
   `{0, 2}` (`modeledSelector_eq`). It is the **maximal** Krein-positive sector
   (`maximal_kreinPositive`, reusing K2 `kreinPositive_sector_subset_phys`).

2. **Rigidity under the full locked data** — `combined_label_injective`,
   `locked_rigid`: the combined `(chirality, Krein)` label of the four branches
   is injective, so the only branch permutation preserving *both* the chirality
   pattern and the Krein pattern is the identity. Hence the selector is
   symmetry-invariant — canonical relative to the locked Krein data
   (`selector_canonical_given_krein`).

3. **No-go under chirality-only data** — `chirality_only_no_go`: the
   transposition `(0 1)` (`chiralitySym`) preserves the chirality pattern
   **and** the modeled taste, energy, and grading
   (`chiralitySym_preserves_{chir,taste,energy,grading}`), yet it moves the
   Krein pattern (`chiralitySym_moves_krein`) and hence the induced selector from
   `{0, 2}` to `{1, 2}` (`chiralitySym_selector_eq`). So chirality, taste,
   energy, and grading **together do not determine** the physical pair.

4. **Verdict** — `c65_verdict`: bundles (1)–(3) plus the API alignment below.

## Alignment with the C59 projected Gate C release API

Target shape: `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean`
(`ProjData`, `ProjectedGateCRelease`, seven clauses, `releasedData`). The
species selector is exactly the `ProjData.retained` field.

- `canonical_selector_eq_released_retained`: the Krein-canonical selector equals
  the `retained` field of the released witness `releasedData`.
- `canonical_selector_releases`: `releasedData` satisfies the full
  `ProjectedGateCRelease` certificate (re-exporting C59 `releasedData_releases`).

**No release clause is blocked.** The selector consumed by the clauses
`BranchProjectorsControlled`, `ProjectedKernelOneDim`,
`ProjectedChiralityAligned`, and `ProjectedKreinPositive` is canonical relative
to the locked Krein data those very clauses already consume. The C65 result
*certifies* that the `retained` choice in C59 is non-arbitrary given the Krein
lock, rather than instantiating a new clause or leaving one open.

## Gate impact

- **Gate C release (C59):** unaffected. Every clause is stated for a given
  `ProjData` whose `retained` is the Krein-positive selector, which is
  unique/rigid/maximal relative to the Krein data the gate uses.
- **Gate F prediction language:** any prediction that *names the specific
  physical pair* without declaring the Krein sign as locked input inherits the
  C45/C46 species-labeling modulus (the no-go). Predictions phrased structurally
  ("the retained sector is the maximal Krein-positive pair") are safe; predictions
  phrased by literal branch labels are conventional.
- **Interpretation:** the `{0, 2}` label is a representative of a `Z₃`-type orbit
  of `2+2` splits; the Krein lock is the structure that selects the representative.

## Conventions

- Branches indexed by `Fin 4`; chirality pattern `g5 = (+,+,-,-)`; Krein pattern
  `(+,-,+,-)`; both reused from `NullEdgeBranchKreinSignatures` (C22).
- `S₄` action by precomposition `permAct σ s = s ∘ σ`, reused from C45/C46.
- The selector is the maximal Krein-positive sector, reusing K2.

## What remains conditional

The canonicity of `{0, 2}` is conditional on the Krein-sign assignment being
treated as locked data. The independent question of whether the Krein-sign
*assignment* is itself forced is the C45/C46 modulus result and is **not**
resolved here (and is not resolvable from the bare tetrahedral symmetry alone, by
C45/C46). An external `C`/reflection + preferred-covector structure that
canonically fixes the Krein assignment would upgrade conditional canonicity to
absolute canonicity; no such structure is currently formalized.
