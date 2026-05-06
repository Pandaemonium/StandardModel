# Gap-closure Aristotle jobs from web research - 2026-05-06

Status: submitted 2026-05-06.

Submission project:

```text
AgentTasks/aristotle-submit/gap-closure-20260506-project
```

Submitted jobs:

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| G1: Jordan derivations | `AgentTasks/aristotle-output/gap-jordan-derivations` | `813531a9-aeb5-4e38-85bd-b2fb3c73d027` | queued |
| G2: Standard-block derivation stabilizers | `AgentTasks/aristotle-output/gap-standard-block-derivation-stabilizers` | `d07518dc-8782-482e-b329-a41fd86cb1b2` | queued |
| G3: Krasnov complex-structure centralizer surrogate | `AgentTasks/aristotle-output/gap-krasnov-centralizer` | `0ceb503d-e1f9-4d43-b3b9-1676ef352964` | queued |
| G4: Full one-generation handedness table | `AgentTasks/aristotle-output/gap-sm-handedness-table` | `88a46864-8d1c-4ac9-8ebc-079bd67a22c5` | queued |
| G5: Furey-Hughes triality-triple scaffold | `AgentTasks/aristotle-output/gap-furey-hughes-triality-triple` | `8073c1d9-d34f-49c4-b025-39d95b45870e` | queued |
| G6: Hurwitz-Clifford precursor | `AgentTasks/aristotle-output/gap-hurwitz-clifford-precursor` | `a231c951-a861-4a12-a1dd-a3884a7da01f` | queued |

Purpose: turn the three skeptic gaps into concrete Lean proof jobs. These jobs
are deliberately ambitious, but each one attacks a mathematical prerequisite
instead of overclaiming a finished compact Lie group, full fermion-sector, or
Hurwitz-classification theorem.

## Web-research clues

### Compact Lie group and stabilizer gap

Krasnov's `SO(9)`/`Spin(9)` route is the most concrete near-term target. The
abstract says the older Dubois-Violette/Todorov/Drenska route characterizes the
SM gauge group as the subgroup of `SO(9)` preserving `O = C + C^3`, and gives a
new characterization as the subgroup of `Spin(9)` commuting with a complex
structure `J` on `O^2` spinors:

- https://arxiv.org/abs/1912.11282

Dubois-Violette and Todorov explicitly frame the exceptional-Jordan route via
known properties of `J_3^8` and Borel-de Siebenthal maximal connected subgroup
theory:

- https://arxiv.org/abs/1806.09450

Formal consequence: the Lean path should first formalize algebraic
derivations, stabilizer Lie subalgebras, and complex-structure centralizers.
The compact group isomorphisms remain later theorems.

### Right-handed fermion gap

The Krasnov/Baez `O^2` qubit route is still best treated as left-handed only.
For a right-handed/full-generation route, the newer Furey-Hughes work is more
promising. Their triality-triple paper identifies
`su(3) + su(2) + u(1)` inside
`tri(C) + tri(H) + tri(O)` and applies the action to
`(Psi_+, Psi_-, V)` in `C tensor H tensor O`; `Psi_+` and `Psi_-` supply two
generations and `V` supplies a third by Cartan factorization:

- https://arxiv.org/abs/2409.17948

Their symmetry-breaking paper gives a complementary route from complex
structures:

```text
Spin(10) -> Pati-Salam -> Left-Right symmetric -> SM + B-L
```

with the complex structures derived from `O`, then `H`, then `C`:

- https://arxiv.org/abs/2210.10126

Krasnov's 2025 article also reframes the Standard Model gauge group inside
`Spin(10)` using two suitably aligned commuting complex structures on `R^10`
encoded by pure spinors:

- https://arxiv.org/abs/2504.16465

Formal consequence: the immediate Lean job is to separate the conventional
full one-generation handedness table from the Krasnov `O^2` left-handed route,
then prepare a triality-triple scaffold rather than pretending `O^2` contains
the full sector.

### Hurwitz classification gap

Westbury's Hurwitz notes separate several results: normed division algebras,
complex composition algebras, and real composition algebras. They define the
composition-algebra axioms, show the Cayley-Dickson double `D(A)` is a
composition algebra iff `A` is associative, and explain the Clifford-algebra
route via vector-product algebras:

- https://math.ucr.edu/home/baez/Hurwitz.pdf
- https://arxiv.org/abs/1011.6197

Formal consequence: the right near-term theorem is not "sedenions fail, hence
Hurwitz". It is a reusable composition-algebra/vector-product interface plus
the first Clifford relation lemmas that explain why dimensions become
restricted.

## General constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Do not introduce axioms, `opaque`, `unsafe`, `admit`, or trusted `sorry`.
- Do not claim compact Lie group isomorphisms, full Standard Model derivations,
  or Hurwitz classification unless the exact theorem is kernel-checked.
- Draft statements may contain documented `sorry`; trusted modules may not.
- Prefer new files with disjoint write scopes.
- Run `lake env lean <file>` for every touched Lean file.

## Job G1: Jordan derivations as the infinitesimal F4 precursor

Write scope:

- `PhysicsSM/Algebra/Jordan/Derivation.lean`
- optional import addition in `PhysicsSM.lean` if the file is trusted and
  sorry-free.

Goal:

Define the Lie algebra of derivations of the trusted coordinate Jordan algebra
`H3O`. Prove the algebraic closure facts needed before any future comparison
with the compact group `F4`.

Target declarations:

- `H3ODerivation`
- coercion to `H3O -> H3O`
- zero derivation
- addition and negation of derivations
- commutator of derivations
- proof that the commutator satisfies the Jordan Leibniz rule
- if feasible, a `LieRing`/`LieAlgebra Real`-style instance compatible with
  mathlib's available API.

Stretch:

- Prove derivations preserve `0`, preserve the Jordan unit `oneH3O`, and
  preserve trace when sufficient hypotheses are available.

Source clue:

Westbury notes define derivations by the Leibniz rule and use them as the
infinitesimal algebra behind exceptional structures.

## Job G2: Standard-block derivation stabilizers

Write scope:

- `PhysicsSM/Algebra/Jordan/StabilizerDerivation.lean`
- optional imports from `Derivation.lean`, `H3O.lean`, and
  `ProjectiveGeometry.lean`.

Goal:

Define algebraic derivation stabilizers of the standard `h_2(O)` block and
standard `h_3(C)` block. Prove they are closed under zero, addition, negation,
and commutator.

Target declarations:

- `DerivationStabilizesSet`
- `standardA_derivationStabilizer`
- `standardB_derivationStabilizer`
- `standardAInterB_derivationStabilizer`
- commutator-closure theorems for each stabilizer.

Stretch:

- Define the common derivation stabilizer of `standardA` and `standardB`.
- Prove the common stabilizer acts on the quotient/complement predicates
  already available in the project.

Claim boundary:

This is only a Lie-algebraic/algebraic stabilizer precursor. Do not claim
`Spin(9)`, `F4`, or `S(U(2) x U(3))`.

## Job G3: Krasnov complex-structure centralizer surrogate

Write scope:

- `PhysicsSM/Spinor/KrasnovComplexStructure.lean`
- optional small additions to `PhysicsSM/Spinor/OctonionicQubit.lean`.

Goal:

Use the trusted `rightMulE111_sq_neg` theorem to define the algebraic
centralizer of the complex structure on `O^2`, then prove basic group/ring
closure facts for endomorphisms commuting with it.

Target declarations:

- `CommutesWithRightMulE111`
- identity commutes with `rightMulE111`
- composition closure
- inverse closure for equivalences
- additive closure for endomorphism-style maps, if represented linearly
- a type/subtype for the algebraic centralizer.

Stretch:

- Use `ComplexSplitting` to define the `O = C plus C^3` coordinate splitting
  on each component of `O^2`.
- Prove `rightMulE111` preserves the `C` and `C^3` summands.

Claim boundary:

This is not a `Spin(9)` centralizer theorem. It is the coordinate centralizer
API needed before such a theorem can be stated honestly.

## Job G4: Full one-generation handedness table

Write scope:

- `PhysicsSM/StandardModel/OneGenerationTable.lean`
- optional imports from `AnomalyPackage.lean`, `Charges.lean`, and
  `Fermions.lean`.

Goal:

Make the right-handed-fermion issue impossible to hide by defining both the
physical chirality table and the all-left-handed charge-conjugate convention.
Prove the two tables have matching degree counts and correct hypercharge sign
conversion.

Target declarations:

- an inductive type or finite list of physical one-generation multiplets:
  `Q_L`, `L_L`, `u_R`, `d_R`, `e_R`, optionally `nu_R`.
- a corresponding all-left-handed table:
  `Q_L`, `L_L`, `u_R^c`, `d_R^c`, `e_R^c`, optionally `nu_R^c`.
- hypercharge conversion lemma under charge conjugation.
- `Q = T3 + Y/2` checks for representative component charges.
- total Weyl-state counts: 15 without `nu_R`, 16 with `nu_R`.

Stretch:

- Connect the all-left-handed table to the existing
  `StandardModel.AnomalyPackage` and prove the local anomaly sums using the
  package's existing theorems.

Claim boundary:

This is conventional Standard Model bookkeeping. It does not claim the
Krasnov/Baez `O^2` construction explains the right-handed sector.

## Job G5: Furey-Hughes triality-triple scaffold

Write scope:

- `PhysicsSM/Algebra/Furey/TrialityTriple.lean`

Goal:

Prepare a typed, source-provenance-safe scaffold for the Furey-Hughes
`(Psi_+, Psi_-, V)` route so future work can attack right-handed/three
generation structure without overloading the Krasnov `O^2` module.

Target declarations:

- `TrialityTriple` with fields `psiPlus`, `psiMinus`, and `vector`, using a
  conservative placeholder coordinate type if `C tensor H tensor O` is not yet
  implemented.
- labels for the three roles: spinor-plus, spinor-minus, vector.
- a record of intended Standard Model action data with no fake action theorem.
- basic projection/accessor lemmas and extensionality.

Stretch:

- If the local `ComplexOctonion` and quaternion/mathlib APIs suffice, define a
  first coordinate type for `C tensor H tensor O`.
- State, in `Draft` only, the Cartan-factorization target from Furey-Hughes.

Claim boundary:

This is a scaffold for the right-handed/three-generation route. Do not present
it as an explanation of the full fermion spectrum.

## Job G6: Hurwitz-Clifford precursor

Write scope:

- `PhysicsSM/Algebra/Division/CompositionAlgebra.lean`
- optional import addition in `PhysicsSM.lean` only if trusted and sorry-free.

Goal:

Start the actual Hurwitz-classification route by defining a finite-dimensional
real composition-algebra interface and proving the first Clifford-relation
precursor for imaginary-vector multiplication.

Target declarations:

- `EuclideanCompositionAlgebra` or an equivalent record with:
  carrier/vector space, unit, multiplication, conjugation or inner product,
  and norm multiplicativity/polarized composition axiom.
- `ImaginaryPart` as the orthogonal complement of the unit, if feasible.
- `vectorProduct` on the imaginary part.
- a linear map `L(u)` on `Real x ImaginaryPart` in the style of Westbury's
  Hurwitz notes.
- prove `L(u)^2 = -inner u u * id` or at least state and prove the special
  unit-imaginary case.

Stretch:

- Prove the anticommutator relation
  `L(u) * L(v) + L(v) * L(u) = -2 * inner u v * id` under the chosen
  normalization.

Claim boundary:

This does not prove Hurwitz classification. It builds the Clifford-algebra
constraint that a real proof of Hurwitz uses.

## Recommended submission order

1. G4, because it directly closes the right-handed lie-of-omission risk.
2. G3, because Krasnov's centralizer route is the most concrete group-gap path.
3. G1, because derivations are the honest infinitesimal `F4` precursor.
4. G2, after or alongside G1 if write scopes stay disjoint.
5. G6, because it turns the Hurwitz gap into a real theorem path.
6. G5, as a scaffold for the Furey-Hughes route.
