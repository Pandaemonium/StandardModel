# Zotero source map: Hamming -> Construction A -> E8 manuscript

Last checked: 2026-05-07.

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

## Zotero query log

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

These were found by web search on 2026-05-07 and should either be added to
Zotero or used to update existing Zotero metadata.

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

## Canonical sources to add to Zotero

These should be imported before submission so the bibliography has the right
primary sources rather than relying on memory or public web pages.

### Must add for the minimal paper

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

### Should add for a strong or sequel paper

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

Still needed:

- Hamming 1950 for historical code family.
- MacWilliams-Sloane and Huffman-Pless for self-dual/Type II coding theory and
  weight enumerator background.

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
- `6CDBTJW4` and `V34P5RP9` as sequel context for E8 Weyl/Jacobi-form work.

Still needed:

- A standard Lie/root-system reference if the manuscript leans heavily on Weyl
  terminology beyond finite root-list verification.

### Sphere-packing endpoint

Lean files:

- `PhysicsSM/Draft/E8SpherePackingBridge.lean`

Current Zotero support:

- `V7WNUP3P` for classical lattice/sphere-packing context.

Still needed:

- Viazovska 2017.
- Cohn-Elkies 2003.
- Sphere-Packing-Lean blueprint/repository/formalization report.

### Physics motivation

Lean files:

- No trusted physics theorem in the Hamming/E8 manuscript depends on this.

Current Zotero support:

- `B8FWVQDC` for code-lattice-CFT motivation.
- `CEQ6URHZ` as a caution against overclaiming E8 physics.

Still needed:

- Mizoguchi-Oikawa or other specific heterotic/code-lattice references if the
  manuscript keeps a Narain/heterotic motivation paragraph.

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
