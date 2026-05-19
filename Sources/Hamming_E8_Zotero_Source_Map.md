# Zotero source map: Hamming -> Construction A -> E8 manuscript

Last checked: 2026-05-16.

Purpose: record which Zotero items currently support the manuscript, which Lean
theorem clusters they support, and which canonical references still need to be
added to Zotero before submission. This is a provenance aid, not a substitute
for checking exact chapter, theorem, or page references while drafting.

## Zotero items currently found

| Zotero key | Source | Role in manuscript | Lean theorem clusters |
|------------|--------|--------------------|-----------------------|
| `V7WNUP3P` | J. H. Conway and N. J. A. Sloane, *Sphere Packings, Lattices and Groups*, 1999. DOI: `10.1007/978-1-4757-6568-7`. | Primary classical source for Construction A, E8 lattice presentations, code-lattice background, and sphere-packing/lattice terminology. | `ConstructionA.lean`, `HammingE8.lean`, `HammingSelfDual.lean`, `HammingWeightEnumerator.lean`, `E8Scaled.lean`, `E8Basis.lean`, `E8BasisSpanning.lean`, `E8ShortVectors.lean`, `HammingConstructionAE8.lean`. |
| `B8FWVQDC` | Anatoly Dymarsky and Alfred Shapere, "Quantum stabilizer codes, lattices, and CFTs", *Journal of High Energy Physics* 2021, no. 3. DOI: `10.1007/jhep03(2021)160`. | Physics motivation for code-lattice-CFT relationships. Use as context only; it should not be cited as the source for the classical Hamming-to-E8 theorem unless the exact statement is checked. | Motivation around `E8HalfIntegerBridge.lean`, possible future Narain/code-CFT formalization, not current kernel claims. |
| `E6EUZ5M9` | Noam D. Elkies, "Yet another proof of the uniqueness of the E8 lattice", 2004. URL: `https://people.math.harvard.edu/~elkies/Misc/E8.pdf`. | Background for the uniqueness of E8 among rank-8 even unimodular lattices. Useful for discussion and future theorem planning; current Lean route is explicit basis/root-list comparison rather than abstract classification. | Future target only: possible uniqueness discussion after `HammingConstructionAE8Properties.lean`; do not use to claim a Lean uniqueness theorem yet. |
| `Z87TPERU` | Maryna Viazovska, "The sphere packing problem in dimension 8", arXiv: `1603.04246`. Published version: *Annals of Mathematics* 185 (2017), 991-1015, DOI `10.4007/annals.2017.185.3.7`. | The analytic endpoint for E8 optimal sphere packing. Use to explain what Sphere-Packing-Lean formalizes; do not claim this repo reproves it. | `PhysicsSM/Draft/E8SpherePackingBridge.lean` motivation and future imported endpoint only. |
| `PSC2PZ4C` | Henry Cohn, Abhinav Kumar, Stephen D. Miller, Danylo Radchenko, and Maryna Viazovska, "Universal optimality of the E8 and Leech lattices and interpolation formulas", arXiv: `1902.05438`. Published version: *Annals of Mathematics* 196 (2022), no. 3, DOI `10.4007/annals.2022.196.3.3`. | Strong sequel context: E8 and Leech universal optimality, beyond sphere packing. | Long-range theta/interpolation target; not needed for the minimal Construction A bridge paper. |
| `CEQ6URHZ` | Jacques Distler and Skip Garibaldi, "There is no \"Theory of Everything\" inside E8", 2009. arXiv: `0905.2658v3`. | Cautionary source for physics overclaims around E8 and the Standard Model. Useful for the broader project philosophy, not for the Hamming/E8 lattice theorem. | Background only; relevant to keeping Standard Model/E8 claims separate from the code-lattice manuscript. |
| `6CDBTJW4` | Kazuhiro Sakai, "Algebraic construction of Weyl invariant E8 Jacobi forms", *Journal of Number Theory* 244 (2023), 42-62. DOI: `10.1016/j.jnt.2022.09.014`. | Long-range theta/Jacobi-form sequel context. Not needed for the minimal Construction A paper. | Possible future theta-series/Jacobi-form targets after root-list and Weyl-orbit formalization. |
| `V34P5RP9` | Kaiwen Sun and Haowu Wang, "Weyl invariant E8 Jacobi forms and E-strings", *Communications in Number Theory and Physics* 17 (2023), no. 3, 553-582. DOI: `10.4310/cntp.2023.v17.n3.a1`. | Long-range Weyl/Jacobi-form and physics-motivated sequel context. Not needed for the minimal paper. | Possible future work near `E8WeylBasic.lean` and planned `E8WeylOrbit.lean`. |

## 2026-05-15 Zotero update

The following items were added or updated through the Zotero Web API and tagged
`Hamming-E8`. This resolves the earlier "canonical sources to add" checklist
at the metadata level; exact page, theorem, and chapter citations still need a
final manuscript pass.

| Zotero key | Citation key | Action | Note |
|------------|--------------|--------|------|
| `UBEA7SR4` | `Hamming1950` | Added | Original error-detecting/error-correcting-codes source. |
| `8WZCIEFK` | `MacWilliamsSloane1977` | Added | Classical coding-theory reference. |
| `SAS8R9WZ` | `HuffmanPless2003` | Added | Coding-theory textbook. |
| `XJTVTJGZ` | `Pless1998` | Added | Introductory coding-theory textbook. |
| `C6DI7ISQ` | `RainsSloane1998` | Added | Self-dual-codes handbook chapter. |
| `ENDH3C4K` | `NebeRainsSloane2006` | Added | Self-dual codes and invariant theory. |
| `EECPD7D4` | `LeechSloane1971` | Added | Code-lattice/sphere-packing paper. |
| `TX4HTFPJ` | `Ebeling2013` | Added | Lattices-and-codes reference. |
| `8ZKHE2F7` | `BourbakiLie456` | Added | Root-system and Weyl-group reference. |
| `KDFEC9HE` | `Thompson1983` | Added | Expository code-to-sphere-packing source. |
| `5S7UWHPT` | `CohnElkies2003` | Added | Linear-programming bounds for sphere packing. |
| `Z87TPERU` | `Viazovska2017` | Updated | Added published DOI and `Hamming-E8` tags. |
| `8PRA87FG` | `CKMRV2017Dimension24` | Added | Dimension-24 Leech-lattice optimality. |
| `PSC2PZ4C` | `CKMRV2022UniversalOptimality` | Updated | Added published DOI and `Hamming-E8` tags. |
| `FH27NZHC` | `SpherePackingLeanMilestone2026` | Added | 2026 formalization report, arXiv:2604.23468. |
| `EXC32G57` | `SpherePackingLeanBlueprint` | Added | Sphere-Packing-Lean blueprint site. |
| `6BW5UXSN` | `BaekKim2026` | Added | Adjacent Lean formalization of self-dual codes. |
| `I69Z25RA` | `TCSlib` | Added | Lean formalization library with coding-theory material. |
| `ZDWZR96C` | `ErrorCorrectionZooHamming844` | Added | Public cross-check for the extended `[8,4,4]` code. |
| `W2RJFI59` | `NebeSloaneE8Catalogue` | Added | Public cross-check for the E8 code-lattice construction. |
| `5FVGNNV4` | `MizoguchiOikawa2026` | Added | Physics-motivation source on code-lattice Narain CFTs. |
| `WTWHDPPX` | `DolanGoddardMontague1996` | Added | Older code-lattice-CFT reference. |
| `V7WNUP3P` | `ConwaySloane1999` | Updated | Added `Hamming-E8` tags and citation key. |

## Zotero query log

### 2026-05-16 theta coefficient pass

This pass was triggered by Aristotle job
`9215f082-2baa-4e13-837c-9335ddf88aad`, which proved the SPL/Eisenstein
q-expansion side but left the all-coefficient Hamming Construction A formula
open.

Web and public-code checks:

- Error Correction Zoo, extended `[8,4,4]` Hamming code: supports the
  Construction A link from the code to the E8 Gosset lattice.
  URL: `https://errorcorrectionzoo.org/c/eeight`.
- Nebe-Sloane E8 code catalogue: public cross-check for the E8 code-lattice
  model. URL:
  `https://www.math.rwth-aachen.de/~Gabriele.Nebe/LATTICES/E8_code.html`.
- OEIS A004009: public cross-check for the coefficient sequence
  `1, 240, 2160, ...`, the `E4` q-expansion, and the formula
  `a(n) = 240 * sigma_3(n)` for positive `n`.
  URL: `https://oeis.org/A004009`.
- Sphere-Packing-Lean source and blueprint: confirm that SPL already has the
  theta constants and the modular-form identity used by the local bridge.
  URL: `https://thefundamentaltheor3m.github.io/Sphere-Packing-Lean/blueprint.pdf`.
- Mathlib modular-form q-expansion docs: confirm useful q-expansion algebra is
  present, but no direct Hamming Construction A coefficient theorem was found.
  URL:
  `https://leanprover-community.github.io/mathlib4_docs/Mathlib/NumberTheory/ModularForms/EisensteinSeries/QExpansion.html`.

Zotero searches run:

- `Conway Sloane Sphere Packings Lattices Groups E8 theta series`
- `Ebeling Lattices Codes E8 theta series`
- `Serre Course Arithmetic Eisenstein E4 theta E8`
- `Jacobi eight squares theorem E8 sigma_3`

No new Zotero items were found by these searches. The canonical references
already present in this source map remain the right bibliography base; the
remaining work is to pin exact page/theorem references for the theta-series
coefficient formula before manuscript submission.

The negative searches below were run before the 2026-05-15 import and are
retained as provenance for why the update was needed.

Successful or partially successful searches:

- `Conway Sloane Sphere Packings Lattices Groups` -> `V7WNUP3P`.
- `E8 lattice` -> `V7WNUP3P`, `E6EUZ5M9`, `B8FWVQDC`, and other less central E8-lattice items.
- `error correcting codes lattices CFT Construction A` -> `B8FWVQDC`.
- `Jacobi forms E8 Weyl group` -> `6CDBTJW4`, `V34P5RP9`.
- `1603.04246` -> `Z87TPERU`.
- `1902.05438` -> `PSC2PZ4C`.
- `E8` -> also found Distler-Garibaldi and other E8/physics items.

Searches that did not find the expected canonical items:

- `MacWilliams Sloane Theory Error-Correcting Codes`
- `Hamming Error Detecting Correcting Codes 1950`
- `Sphere-Packing-Lean Viazovska Lean`
- `self-dual code Lean`
- `Heterotic Narain codes`
- `Mizoguchi Oikawa code lattice Narain`
- `Odlyzko Sloane sphere packing`
- `2602.16269`
- `2604.08485`
- `math/0110009`
- `10.1002/j.1538-7305.1950.tb00463.x`
- `10.4007/annals.2003.157.689`

## Additional web-discovered references

These were found by web search on 2026-05-07 and were used for the 2026-05-15
Zotero update. The notes remain here as source provenance.

### Core coding-theory sources

- Richard W. Hamming, "Error Detecting and Error Correcting Codes", *Bell
  System Technical Journal* 29 (1950), no. 2, 147-160. DOI:
  `10.1002/j.1538-7305.1950.tb00463.x`.
- F. J. MacWilliams and N. J. A. Sloane, *The Theory of Error-Correcting
  Codes*, North-Holland, 1977. Library/OpenLibrary metadata found; add ISBN
  metadata from a reliable library record when importing.
- W. Cary Huffman and Vera Pless, *Fundamentals of Error-Correcting Codes*,
  Cambridge University Press, 2003. Print ISBN `9780521131704`; electronic
  ISBN `9780511074684`.

### Code-to-lattice public cross-checks

- Error Correction Zoo, `([8,4,4]) extended Hamming code`, URL:
  `https://errorcorrectionzoo.org/c/hamming844`. The page records the code as
  the smallest doubly even self-dual code, the unique Type II code of length
  eight, and says it yields the E8 Gosset lattice by Construction A.
- Nebe-Sloane Catalogue of Lattices, `The Lattice E8 (coding theory version)`,
  URL: `https://www.math.rwth-aachen.de/~Gabriele.Nebe/LATTICES/E8_code.html`.
  The entry explicitly says to apply Construction A to the `[8,4,4]` Hamming
  code.

### Sphere-packing endpoint and sequels

- Henry Cohn and Noam Elkies, "New upper bounds on sphere packings I", *Annals
  of Mathematics* 157 (2003), 689-714. DOI:
  `10.4007/annals.2003.157.689`; arXiv `math/0110009`.
- Maryna Viazovska, "The sphere packing problem in dimension 8", *Annals of
  Mathematics* 185 (2017), 991-1015. DOI:
  `10.4007/annals.2017.185.3.7`; arXiv `1603.04246`. Zotero currently has the
  arXiv item `Z87TPERU`; update it with the published DOI metadata.
- Henry Cohn, Abhinav Kumar, Stephen D. Miller, Danylo Radchenko, and Maryna
  Viazovska, "The sphere packing problem in dimension 24", *Annals of
  Mathematics* 185 (2017), 1017-1033. DOI:
  `10.4007/annals.2017.185.3.8`; arXiv `1603.06518`.
- Henry Cohn, Abhinav Kumar, Stephen D. Miller, Danylo Radchenko, and Maryna
  Viazovska, "Universal optimality of the E8 and Leech lattices and
  interpolation formulas", *Annals of Mathematics* 196 (2022), no. 3. DOI:
  `10.4007/annals.2022.196.3.3`; arXiv `1902.05438`. Zotero currently has the
  arXiv item `PSC2PZ4C`; update it with the published DOI metadata.
- Sphere-Packing-Lean blueprint/repository, URL:
  `https://thefundamentaltheor3m.github.io/Sphere-Packing-Lean/`. This is the
  local formalization endpoint. Add the associated 2026 formalization paper
  once its canonical bibliographic record is available.

### Formalization and physics-adjacent context

- Jae-Hyun Baek and Jon-Lark Kim, "Formalizing building-up constructions of
  self-dual codes through isotropic lines in Lean", arXiv `2604.08485`.
  Adjacent formalization-landscape source; not a source for our Construction A
  theorem.
- Shun'ya Mizoguchi and Takumi Oikawa, "Error correcting codes and heterotic
  Narain CFTs", arXiv `2602.16269`. Motivation source for code-lattice
  heterotic/Narain language; not a source for the Lean E8 lattice theorem.

## Canonical source status

The sources in this section were imported or updated in Zotero on 2026-05-15.
The remaining bibliography work is to attach exact page, theorem, chapter, and
edition references in the manuscript.

### Minimal-paper sources now in Zotero

- Richard W. Hamming, "Error Detecting and Error Correcting Codes", *Bell
  System Technical Journal* 29 (1950), 147-160. DOI:
  `10.1002/j.1538-7305.1950.tb00463.x`.
- F. J. MacWilliams and N. J. A. Sloane, *The Theory of Error-Correcting
  Codes*, North-Holland, 1977.
- W. Cary Huffman and Vera Pless, *Fundamentals of Error-Correcting Codes*,
  Cambridge University Press, 2003. ISBN `9780521131704`.
- Maryna S. Viazovska, "The sphere packing problem in dimension 8", *Annals of
  Mathematics* 185 (2017), 991-1015. Already present as Zotero arXiv item
  `Z87TPERU`; update with DOI `10.4007/annals.2017.185.3.7`.
- Henry Cohn and Noam Elkies, "New upper bounds on sphere packings I", *Annals
  of Mathematics* 157 (2003), 689-714. DOI:
  `10.4007/annals.2003.157.689`.
- The Sphere-Packing-Lean repository/blueprint and the associated 2026
  formalization report or preprint, once the exact bibliographic item is known.

### Strong/sequel-paper sources now in Zotero or intentionally deferred

- Cohn, Kumar, Miller, Radchenko, and Viazovska, dimension-24 Leech lattice
  optimality paper. DOI `10.4007/annals.2017.185.3.8`.
- Cohn, Kumar, Miller, Radchenko, and Viazovska, universal optimality of E8 and
  the Leech lattice. Already present as Zotero arXiv item `PSC2PZ4C`; update
  with DOI `10.4007/annals.2022.196.3.3`.
- Odlyzko and Sloane, kissing-number bounds.
- Nebe-Sloane Catalogue of Lattices E8 code entry.
- Error Correction Zoo extended Hamming/E8 entries.
- Baek and Kim 2026 Lean formalization of self-dual code building-up
  constructions, arXiv `2604.08485`, if it will be discussed in the
  formalization landscape.
- Mizoguchi and Oikawa on error-correcting codes and heterotic Narain CFTs, if
  the physics motivation paragraph remains; current target is arXiv
  `2602.16269`.

## Source-to-theorem map

### Extended Hamming code and Type II properties

Lean files:

- `PhysicsSM/Coding/HammingE8.lean`
- `PhysicsSM/Coding/HammingSelfDual.lean`
- `PhysicsSM/Coding/HammingWeightEnumerator.lean`

Current Zotero support:

- `V7WNUP3P` supports the code-lattice background at a high level.
- `UBEA7SR4`, `8WZCIEFK`, `SAS8R9WZ`, `XJTVTJGZ`, `C6DI7ISQ`, and
  `ENDH3C4K` now cover the core Hamming-code, self-dual-code, and
  weight-enumerator background.

Still needed:

- Exact page, theorem, and chapter references for the final citation pass.

### Construction A and normalized E8 lattice

Lean files:

- `PhysicsSM/Coding/ConstructionA.lean`
- `PhysicsSM/Coding/ConstructionALatticeProperties.lean`
- `PhysicsSM/Coding/E8Scaled.lean`
- `PhysicsSM/Coding/E8Basis.lean`
- `PhysicsSM/Coding/E8BasisSpanning.lean`
- `PhysicsSM/Coding/HammingConstructionAE8.lean`

Current Zotero support:

- `V7WNUP3P` is the main support.
- `EECPD7D4`, `TX4HTFPJ`, `ZDWZR96C`, and `W2RJFI59` give additional
  code-lattice and public cross-check support.

Still needed:

- Exact chapter/page notes from Conway-Sloane for Construction A, E8, and the
  `[8,4,4]` code route.

### Short vectors, roots, and Weyl action

Lean files:

- `PhysicsSM/Coding/E8ShortVectors.lean`
- `PhysicsSM/Algebra/Octonion/IntegralOctonion.lean`
- `PhysicsSM/Algebra/Octonion/E8RootCompleteness.lean`
- `PhysicsSM/Algebra/Octonion/E8WeylBasic.lean`

Current Zotero support:

- `V7WNUP3P` for E8 roots/lattice background.
- `8ZKHE2F7` for root-system, Coxeter-group, and Weyl-group conventions.
- `6CDBTJW4` and `V34P5RP9` as sequel context for E8 Weyl/Jacobi-form work.

Still needed:

- Exact Bourbaki chapter/table/page references if the manuscript leans heavily
  on Weyl terminology beyond finite root-list verification.

### Sphere-packing endpoint

Lean files:

- `PhysicsSM/Draft/E8SpherePackingBridge.lean`

Current Zotero support:

- `V7WNUP3P` for classical lattice/sphere-packing context.
- `5S7UWHPT`, `Z87TPERU`, `8PRA87FG`, `PSC2PZ4C`, `FH27NZHC`, and
  `EXC32G57` cover the Cohn-Elkies bound, Viazovska endpoint, dimension-24
  sequel, universal-optimality sequel, and Sphere-Packing-Lean sources.

Still needed:

- Decide which sphere-packing sources are core references versus sequel/context
  references, then add exact citation keys in the manuscript.

### Physics motivation

Lean files:

- No trusted physics theorem in the Hamming/E8 manuscript depends on this.

Current Zotero support:

- `B8FWVQDC` for code-lattice-CFT motivation.
- `CEQ6URHZ` as a caution against overclaiming E8 physics.
- `WTWHDPPX` and `5FVGNNV4` now cover older lattice-CFT context and recent
  heterotic/Narain code-lattice motivation.

Still needed:

- Decide whether the manuscript keeps the physics motivation paragraph.

## Drafting guidance

- Cite `V7WNUP3P` for the classical Construction A and E8 lattice route, but
  add exact chapter/page references before final submission.
- Do not cite `B8FWVQDC` as evidence that the extended Hamming code gives E8;
  use it only for broader code-lattice-CFT motivation.
- Do not cite `E6EUZ5M9` as if the Lean code proves abstract uniqueness of E8.
  The current formal route is explicit: basis, determinant, short-vector count,
  and model bridges.
- Keep Distler-Garibaldi (`CEQ6URHZ`) out of the core lattice paper unless
  there is a short "not a Standard Model embedding claim" paragraph.
