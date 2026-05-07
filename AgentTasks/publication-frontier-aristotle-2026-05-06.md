# Publication-frontier Aristotle jobs - 2026-05-06

Status: submitted 2026-05-06.

Purpose: convert the conjecture/frontier backlog in
`Sources/Publishable_Results_Literature_Search.md` into ambitious Aristotle
jobs with publication-shaped Lean outputs. These jobs deliberately avoid
claiming finished physics derivations or compact Lie group isomorphisms. The
goal is to produce kernel-checked theorem islands that can become paper
sections.

## Submission project

```text
AgentTasks/aristotle-submit/publication-frontier-20260506-project
```

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| P1: Conway-Smith/Yokota triality-shadow companion maps | `AgentTasks/aristotle-output/pub-triality-shadow` | `17399d3d-bff5-4abb-a864-b29f2e661cef` | failed: Aristotle internal error |
| P2: Bioctonionic incidence counterexample | `AgentTasks/aristotle-output/pub-bioctonionic-incidence` | `99e37e66-f42e-4079-a1f0-dbf5765fbf91` | complete; fetched, extracted, integrated |
| P3: Construction A Hamming-to-E8 bridge | `AgentTasks/aristotle-output/pub-construction-a-hamming-e8` | `d7114ee8-6070-488d-bfd3-6d9b3fdcdf87` | complete; fetched, extracted, integrated |
| P4: Integral octonion E8 root seed | `AgentTasks/aristotle-output/pub-integral-octonion-e8-root-seed` | `b1670106-28f5-4cc1-a79f-ba937cad74c8` | complete; fetched, extracted, integrated |
| P5: Baez-Huerta GUT square | `AgentTasks/aristotle-output/pub-gut-square` | `cb7a929e-9125-417b-a20b-27139dca2310` | complete; fetched, extracted, integrated |
| P6: Spin(10) pure-spinor scaffold | `AgentTasks/aristotle-output/pub-spin10-pure-spinor-scaffold` | `e3a0b1d5-2e1a-4c4d-b588-3f64785274bc` | complete; fetched, extracted, integrated |

Result check, 2026-05-06:

- P5 returned `PhysicsSM/Gauge/GUTSquare.lean`, a trusted predicate-level
  Baez-Huerta intersection theorem for block matrices. Integrated into the
  root import after a targeted Lean check.
- P2 returned `PhysicsSM/Algebra/Jordan/BioctonionicPlane.lean`, including a
  concrete zero-divisor-driven counterexample to projective-plane uniqueness
  in a bioctonionic affine model. Integrated into the root import.
- P3 returned `PhysicsSM/Coding/ConstructionA.lean` and
  `PhysicsSM/Coding/HammingE8.lean`, proving Construction A infrastructure and
  the extended-Hamming-to-E8 minimum norm theorem. Integrated into the root
  import.
- P4 returned `PhysicsSM/Algebra/Octonion/IntegralOctonion.lean`, a trusted
  240-root E8 seed in doubled octonion coordinates. Integrated into the root
  import.
- P6 returned `PhysicsSM/Spinor/PureSpinor10.lean`, a trusted predicate-level
  scaffold for Krasnov's Spin(10) two-pure-spinor route. Integrated into the
  root import.
- P1 failed before returning Lean output. Retry as narrower companion-map
  lemmas if the publication-frontier queue still wants this target.

## General constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Do not introduce axioms, `opaque`, `unsafe`, `admit`, or trusted `sorry`.
- New trusted modules must be sorry-free.
- Draft statements may contain documented `sorry` only if the write scope says
  `Draft`.
- Keep octonion multiplication parenthesized.
- Respect the project XOR octonion convention and do not copy Baez/Furey signs
  without an explicit convention bridge.
- Every module must include a source/provenance note.
- Run `lake env lean <file>` for every touched Lean file.

## Job P1: Conway-Smith/Yokota triality-shadow companion maps

Publication target:

- Target 2 in the frontier backlog.

Write scope:

- `PhysicsSM/Algebra/Octonion/TrialityShadow.lean`
- optional tiny additions to `PhysicsSM/Algebra/Octonion/TrialityCompanions.lean`
  only for reusable lemmas.

Goal:

Push the existing forward `cube = +/-1` automorphism theorem toward the
Conway-Smith/Yokota criterion by formalizing companion-map identities for left
and right multiplication.

Target declarations:

- `leftCompanionIdentity`
- `rightCompanionIdentity`
- a theorem expressing that left multiplication by a unit `c` has companions
  `c` and `c^{-2}` in the source's sense, adapted to the project's `conj`
  inverse convention.
- the analogous theorem for right multiplication.
- a theorem that the conjugation map `conjBy c` has companions `cube c` and
  the inverse cube, if feasible.

Stretch:

- Prove a scalar-cube reduction lemma for the converse direction.
- Improve the existing `conjBy` theorem from the special `cube = +/-1` cases
  to a real-scalar cube hypothesis.

Sources:

- Baez, "A Shadow of Triality?", n-Category Cafe, September 2025:
  <https://golem.ph.utexas.edu/category/2025/09/a_shadow_of_triality.html>
- Baez, "The Octonions":
  <https://math.ucr.edu/home/baez/octonions/octonions.html>

## Job P2: Bioctonionic incidence counterexample

Publication target:

- Target 6 in the frontier backlog.

Write scope:

- `PhysicsSM/Algebra/Jordan/BioctonionicPlane.lean`

Goal:

Define a small coordinate model of the bioctonionic point/line incidence
relation and prove an explicit counterexample to at least one ordinary
projective-plane uniqueness axiom.

Target declarations:

- a conservative `Bioctonion` abbreviation or wrapper using the existing
  `ComplexOctonion`.
- a small point/line predicate sufficient for a finite counterexample.
- `two_distinct_lines_more_than_one_intersection_point`, or the dual theorem
  for two points lying on more than one line.

Stretch:

- Relate the counterexample to zero divisors in `C tensor O`.
- State a draft comparison map to the existing `OP2Point`/`OP2Line` API.

Sources:

- Baez, "Octonions and the Standard Model (Part 12)", linked from:
  <https://math.ucr.edu/home/baez/standard/>

## Job P3: Construction A bridge from the extended Hamming code to E8

Publication target:

- Target 8 in the frontier backlog.

Write scope:

- `PhysicsSM/Coding/ConstructionA.lean`
- `PhysicsSM/Coding/HammingE8.lean`

Goal:

Build a Lean-accessible Construction A bridge for the extended binary Hamming
code and the E8 lattice. Prefer a finite coordinate theorem that can later be
aligned with Sphere-Packing-Lean.

Target declarations:

- a definition of a binary code as a set/submodule of `Fin n -> ZMod 2`, unless
  mathlib already has the right structure.
- `extendedHamming8`
- `constructionA`
- membership criterion for the Construction A lattice.
- a theorem that the minimal nonzero squared norm is `2` for the constructed
  E8 candidate, or that the 240 roots are exactly the expected coordinate
  vectors, if feasible.

Stretch:

- Define an explicit local `E8CodeLattice` and prove equality with the
  Construction A lattice.
- Prepare a draft bridge to Sphere-Packing-Lean's E8 definition.

Sources:

- Mizoguchi-Oikawa, arXiv:2602.16269:
  <https://arxiv.org/abs/2602.16269>
- Baek-Kim, arXiv:2604.08485:
  <https://arxiv.org/abs/2604.08485>
- Error Correction Zoo E8 entry:
  <https://errorcorrectionzoo.org/c/eeight>
- Sphere-Packing-Lean blueprint:
  <https://thefundamentaltheor3m.github.io/Sphere-Packing-Lean/blueprint/index.html>

## Job P4: Integral octonion E8 root seed

Publication target:

- Target 7 in the frontier backlog.

Write scope:

- `PhysicsSM/Algebra/Octonion/IntegralOctonion.lean`

Goal:

Create a finite, convention-safe integral-octonion seed module that can support
the E8 and Leech-lattice program. Start with the 240-root-level theorem rather
than the full Leech lattice.

Target declarations:

- a coordinate predicate for the relevant integral octonion lattice or a
  conservative first sublattice.
- a finite root candidate set of 240 elements, if feasible.
- norm-squared facts for the root candidates.
- closure under negation.
- enough dot-product facts to recognize the E8 root-system pattern.

Stretch:

- Define the off-diagonal embedding into `H3O`.
- Prove one product-compatibility lemma for a small explicit compatible
  embedding.

Sources:

- Baez-Egan, integral octonions series:
  <https://math.ucr.edu/home/baez/octonions/integers/>
- Integral Octonions Part 9:
  <https://golem.ph.utexas.edu/category/2014/11/integral_octonions_part_9.html>
- Integral Octonions Part 10:
  <https://golem.ph.utexas.edu/category/2014/12/integral_octonions_part_10.html>

## Job P5: Baez-Huerta GUT square at matrix-predicate level

Publication target:

- Target 5 in the frontier backlog.

Write scope:

- `PhysicsSM/Gauge/GUTSquare.lean`

Goal:

Formalize a matrix-predicate version of the Baez-Huerta grand-unification
intersection square before attempting compact Lie group topology.

Target declarations:

- predicates for block `SU(5)`-style, Pati-Salam-style, and Standard
  Model-style matrices inside a shared finite matrix type.
- inclusion lemmas from the Standard Model block predicate into the two larger
  predicates.
- an intersection theorem:
  `SMBlockPredicate M <-> SU5Predicate M ∧ PatiSalamPredicate M`
  under the chosen block-coordinate representation.

Stretch:

- Add determinant compatibility lemmas reusing `BlockEmbeddings`.
- State a draft theorem explaining how this predicate result should lift to the
  Baez-Huerta compact group intersection theorem.

Sources:

- Baez-Huerta, "The Algebra of Grand Unified Theories":
  <https://math.ucr.edu/home/baez/guts.pdf>
- AMS article page:
  <https://www.ams.org/bull/2010-47-03/S0273-0979-10-01294-2/>

## Job P6: Spin(10) pure-spinor condition scaffold

Publication target:

- Target 3 in the frontier backlog.

Write scope:

- `PhysicsSM/Spinor/PureSpinor10.lean`

Goal:

Create a precise scaffold for Krasnov's `Spin(10)` two-pure-spinor
characterization of the Standard Model subgroup. This should be a typed
mathematical interface, not a fake group theorem.

Target declarations:

- a placeholder or finite exterior-algebra model for complex spinors in
  dimension 10, using mathlib APIs if available.
- `IsPureSpinor10`
- `PureSpinorOrthogonal`
- `PureSpinorAlignedPair`, representing orthogonal pure spinors whose sum is
  pure.
- a structure/predicate for the induced commuting complex structures, if
  feasible.

Stretch:

- Prove basic symmetry facts: orthogonality is symmetric, aligned-pair
  projections recover pure spinors, and the pair predicate is stable under
  simultaneous nonzero scalar rescaling.

Sources:

- Krasnov, arXiv:2209.05088:
  <https://arxiv.org/abs/2209.05088>
- Krasnov, arXiv:2504.16465:
  <https://arxiv.org/abs/2504.16465>

## Submission notes

These jobs intentionally avoid write scopes currently owned by in-progress
Aristotle jobs:

- no edits to `StandardModelSubgroup.lean`;
- no edits to `KrasnovComplexStructure.lean`;
- no edits to `Derivation.lean` or `StabilizerDerivation.lean`;
- no edits to `TraceForm.lean`, `H3OSplitting.lean`, or `DVTAction.lean`.
