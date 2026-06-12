# Execution Plan: PhysicsSM

## Current state (baseline through 2026-05-07; publication update 2026-05-31)

**Milestone 1, the Milestone 2 Cayley-Dickson foundation, Core Furey
Arithmetic, and the Milestone 8 coordinate/Jordan foundation are complete.**
The project has:

- Lean 4 `v4.28.0`, mathlib4 `v4.28.0`, full pre-built cache downloaded.
- A trusted octonion arithmetic core in `PhysicsSM/Algebra/Octonion/Basic.lean`:
  explicit XOR-basis multiplication, component simp lemmas, left and right
  alternativity, and imaginary-basis anticommutation.
- A trusted complexified-octonion arithmetic layer in
  `PhysicsSM/Algebra/Octonion/ComplexOctonion.lean`: pair representation,
  addition, multiplication, unit, scalar actions, and the modest additive
  monoid structure needed for finite Furey computations.
- Trusted Furey ladder operators in `PhysicsSM/Algebra/Furey/LadderOperators.lean`:
  `alpha1`, `alpha2`, `alpha3`, their daggers, six nilpotency theorems, and
  all 27 Cl(6) anticommutation relations.
- Trusted minimal-left-ideal arithmetic in
  `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`: omega, eight explicit states,
  Cl(6) action table, number-operator eigenvalue lemmas, charge-sum lemmas,
  nonzero witnesses, and **verified linear independence** of the 8-state basis.
- GitHub Actions CI: `lake build` + no-sorry gate on trusted dirs + `docgen-action`.
- Pre-commit hooks: UTF-8/LF/final-newline hygiene enforced on every commit.
- Exceptional foundations: D4 triality and Octonion symmetry dot/commutator facts integrated.
- Triality-companion foothold integrated:
  `PhysicsSM/Algebra/Octonion/TrialityCompanions.lean` proves the forward
  Conway-Smith/Yokota conjugation criterion for unit octonions with
  `cube a = 1` or `cube a = -1`, plus the order-three iteration result.
- MCP servers active: `scholarly` (OpenAlex/Semantic Scholar), `zotero_write`,
  `neo4j_graph`.
- Aristotle API key active and tested.
- Octonion XOR convention locked and validated (Fano + 512 Moufang checks).
- `ConventionBridge` stub isolating project convention from Baez/Furey.
- **Second Aristotle wave integrated** (jobs submitted and merged
  2026-05-06):
  - `PhysicsSM/Algebra/Furey/OperatorAlgebra.lean` now has the trusted finite
    operator algebra layer: `EqOnJ`, `opComm`, color-transition tables,
    SU(3)-style commutators, charge conservation, and sector submodules.
  - `PhysicsSM/Algebra/Jordan/H2OProduct.lean` and
    `PhysicsSM/Algebra/Jordan/H3OJordan*.lean` now package the trusted Jordan
    product identities. The largest new theorem is
    `jordanIdentity_H3O`, proving the Jordan identity for all `a b : H3O`.
  - `PhysicsSM/Algebra/Octonion/ComplexSplitting.lean` gives the trusted
    `O = C plus C^3` coordinate splitting around the chosen complex line.
  - `PhysicsSM/Algebra/Jordan/Automorphism.lean` and
    `PhysicsSM/Algebra/Jordan/ProjectiveGeometry.lean` move the projective
    geometry API, automorphism API, standard blocks, and standard line/plane
    scaffolding into trusted modules.
  - `PhysicsSM/Algebra/Division/CayleyDickson.lean` provides the trusted generic
    doubling construction through `CD1`, `CD2`, and `CD3`.
  - `PhysicsSM/Gauge/BlockEmbeddings.lean` adds the trusted block determinant,
    `Z6` phase, and quotient-scaffold facts behind the Standard Model gauge
    group presentation.
- **Gap-closure and publication-frontier Aristotle results integrated**
  (completed 2026-05-06, merged after targeted Lean checks):
  - `PhysicsSM/Algebra/Division/CayleyDicksonOctonionBridge.lean` gives the
    sign-corrected bridge from `CD3` to the project XOR-basis octonions.
  - `PhysicsSM/Algebra/Jordan/Derivation.lean` and
    `PhysicsSM/Algebra/Jordan/StabilizerDerivation.lean` give trusted
    derivation and standard-block derivation-stabilizer APIs.
  - `PhysicsSM/Algebra/Jordan/TraceForm.lean`,
    `PhysicsSM/Algebra/Jordan/Stabilizer.lean`, and
    `PhysicsSM/Algebra/Jordan/DVTAction.lean` add the trace-form splitting,
    trusted common-stabilizer group closure, and first DVT/Yokota action
    scaffold.
  - `PhysicsSM/Spinor/KrasnovComplexStructure.lean` packages the algebraic
    centralizer of `rightMulE111` on `O^2`; `PureSpinor10.lean` gives the
    Spin(10) pure-spinor predicate scaffold.
  - `PhysicsSM/StandardModel/OneGenerationTable.lean`,
    `PhysicsSM/Gauge/StandardModelSubgroup.lean`, and
    `PhysicsSM/Gauge/GUTSquare.lean` make the conventional one-generation
    table, concrete `S(U(2) x U(3))` block subgroup, and Baez-Huerta
    predicate intersection theorem explicit.
  - `PhysicsSM/Algebra/Jordan/BioctonionicPlane.lean`,
    `PhysicsSM/Algebra/Octonion/IntegralOctonion.lean`,
    `PhysicsSM/Coding/ConstructionA.lean`, and
    `PhysicsSM/Coding/HammingE8.lean` add publication-shaped theorem islands:
    a bioctonionic incidence counterexample, a 240-root E8 octonion seed, and
    the Construction A extended-Hamming-to-E8 minimum norm bridge.
- **Hamming -> Construction A -> E8 publication spine integrated**
  (completed 2026-05-07, targeted checks passed locally):
  - `PhysicsSM/Coding/HammingConstructionAE8Final.lean` is the
    citation-friendly theorem index for the paper. It aliases the completed
    chain from Type II extended Hamming code through full rank, scaled
    even/unimodular properties, minimum norm 2, the 240 short vectors, the
    short-vector/root-list bijection, Gram/Cartan bridge, and Weyl closure API.
  - `PhysicsSM/Coding/Hamming844Classification.lean` and
    `PhysicsSM/Draft/Hamming844Uniqueness.lean` now provide the uniqueness of
    the binary `[8,4,4]` code up to coordinate permutation. The proof uses a
    finite `native_decide` classification step and must be documented with the
    resulting `Lean.trustCompiler` boundary.
  - `PhysicsSM/Algebra/Division/CompositionClifford.lean` adds the trusted
    norm-form composition-algebra mixin, real/imaginary projections, and the
    pure-imaginary square relation. This advances the broader
    Hurwitz/Clifford route but is not a gate for the E8 paper.
  - `PhysicsSM/Coding/E8SpherePackingMatrixBridge.lean` reproduces SPL's E8
    basis matrix over `Q` without importing SPL, proves determinant/Gram facts,
    proves membership in the local half-integer E8 predicate, and proves the
    SPL-shaped Gram matrix and the scaled Construction A Gram matrix are both
    congruent to the local `e8Cartan` by unimodular transitions.
  - Remaining headline target: in an SPL-enabled branch, prove the imported
    hinge theorem `E8Matrix Q = splE8BasisQ`, use `span_E8Matrix` to identify
    the span with `Submodule.E8`, and then transport SPL's packing density or
    optimality theorem to the Hamming/Construction A model.
- **Exceptional Jordan and Baez 2021 targets integrated** (Aristotle jobs
  `17d42ab0` and `76df9a63`, completed 2026-05-05):
  - `PhysicsSM/Algebra/Octonion/ComplexLine.lean` — chosen complex line
    `C = span_R{1, e111}`, closure under all operations, complex structure
    `J² = -id` on complement. Trusted, sorry-free.
  - `PhysicsSM/Algebra/Jordan/Basic.lean` — minimal Jordan vocabulary
    (`IsJordanIdempotent`, `IsJordanTraceOneProjection`, etc.). Trusted.
  - `PhysicsSM/Algebra/Jordan/SpinFactor.lean` — spin factor `R ⊕ Rⁿ` with
    `det = t² - ‖x‖²`, trace, Euclidean norm, and trace-one projection
    characterization. Trusted.
  - `PhysicsSM/Algebra/Jordan/H2O.lean` — concrete `h₂(O)` in spin-factor
    coordinates: `det = t² - x² - normSq(y)`, standard projections. Trusted.
  - `PhysicsSM/Algebra/Jordan/H3O.lean` — trusted `H3O` coordinate model
    with explicit Jordan product, 24 kernel-checked theorems including Jordan
    product commutativity, identity lemmas, complex-line closure, standard block
    closure (`h₂(O)`, `h₃(C)`, `h₂(C)`), and `diag(1,1,0)` proved to be a
    trace-2 Jordan idempotent. Sorry-free.
  - `PhysicsSM/Gauge/StandardModelGroup.lean` — `S(U(2) × U(3))` scaffolding:
    ℤ₆ center, SU(4) block determinant, dimension 12. Trusted.
  - `PhysicsSM/Spinor/OctonionicQubit.lean` — Krasnov's `O² = Octonion × Octonion`
    with `rightMulE111_sq_neg` (J² = -id) verified. Trusted.
  - `PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean` — rich draft:
    `OP2Point`, `OP2Line`, `LiesOn`, bundled `JordanSubalgebra`, proved
    `standardA_isH2O`, `standardB_isH3C`, `standardAInterB_isH2C`, and
    `standardAInterB_is_intersection`. After the 2026-05-06 integration, four
    frontier sorries remain (F₄ transitivity, DVT stabilizer, and
    `S(U(2) × U(3))` isomorphism targets).
  - `PhysicsSM/Draft/BaezStandardModelFromOctonions.lean` — new draft with
    proved `h₃(O) = h₃(C) ⊕ h₃(C)^⊥` splitting, complex structure
    preservation, and J² = -id on complement. The old Jordan-product bundle
    placeholders now delegate to trusted H2O/H3O theorem modules.

**Important caveat.** The Lean kernel verifies the explicit algebraic
equalities, not any physical identification of states. The final stabilizer
theorems (F₄ transitivity, `Stab = S(U(2) × U(3))`) require compact Lie group
infrastructure not yet in Mathlib and remain frontier draft statements.

**Claim boundary.** Trusted modules currently prove finite coordinate algebra,
block-matrix determinant arithmetic, and explicitly stated subgroup/predicate
facts. They do not yet prove topological compact Lie group isomorphisms such
as `Aut(h_3(O)) ~= F4`, `Stab(h_2(O)) ~= Spin(9)`, or the full quotient
identification of the Standard Model gauge group. Such statements must stay in
`Draft` or source notes until the required manifold/Lie-group/quotient
infrastructure is formalized.

---

## Publication and research target update (2026-05-31)

This update incorporates the recent literature review and the additional target
list generated by Claude. The main conclusion is that most obvious targets are
formalizations of known algebraic claims. That is valuable, but the clearest
path to a genuinely new result is to abstract a common theorem behind the
triality and family-symmetry stories.

### Target triage

| Track | Target | Current priority | Rationale |
|-------|--------|------------------|-----------|
| Near-term formalization | `Z6` kernel and true SM gauge-group quotient scaffold | Highest | Already has `StandardModelZ6*` modules; useful to Baez, Furey, GUT, and conventional SM readers |
| Near-term formalization | Furey charge/weak/hypercharge table from number operators | Highest | Finite algebraic statement; connects the octonion ladder-operator layer to the one-generation SM table |
| New-result track | Family-symmetry naturality theorem | Highest | Potentially new theorem abstracting why triality/S3 family actions preserve gauge quantum numbers and anomaly cancellation |
| Companion formalization | Furey-Hughes triality three-generation scaffold | High | Recent and directly aligned with existing `Triality*` files |
| Foundation target | `O = C + C^3`, unitary/Hermitian API, and eventual `G2`/`SU(3)` bridge | High | Needed by Baez, Krasnov, and Furey, but the full stabilizer theorem remains heavier than the coordinate splitting |
| Expository/formal bridge | Quunit/qubit/qutrit dictionary for `U(1)`, `SU(2)`, `SU(3)`, and `S(U(2) x U(3))` | High | Gives the Baez public-lecture motivation a precise Lean target and ties the `Z6` quotient to `C^2 + C^3` block geometry |
| Medium-term formalization | Krasnov `Spin(9)`/`Spin(10)` centralizer theorem | Medium | Mathematically clean but requires serious Lie/Clifford infrastructure |
| Medium-term formalization | Furey `Z2^5`-graded superalgebra | Medium | Recent finite algebra target; should wait until the Furey table and operator packages are publication-clean |
| Medium-term comparison | Gresnigt/Gourlay `Cl(10)` with `S3` family symmetry | Medium | Very recent and promising; best treated as a second instance of the family-symmetry naturality theorem |
| Long-term theorem | Dubois-Violette/Todorov `F4` intersection theorem | Long-term | Central to the Baez/DVT route, but group/stabilizer infrastructure remains the gate |
| Watchlist | Baez-Schwahn projective-incidence reformulation | Watch | Very recent slide-level target; wait for stable statement/preprint before locking Lean theorem statements |

### Candidate new result

The most promising new theorem family is:

```text
Family-symmetry naturality for algebraic Standard Model tables.
```

Informal statement:

```text
Let a finite family group act by linear equivalences on a direct sum of
generation sectors. If the action commutes with the color, weak-isospin,
hypercharge, and electric-charge operators, then every sector in a family orbit
has the same gauge quantum numbers. Consequently, all polynomial anomaly sums
computed from those charges are constant on the orbit, and the finite Z6 kernel
of the Standard Model covering map is unchanged by adjoining family copies.
```

Why this is new enough to be interesting:

- Furey-Hughes use triality as a three-generation mechanism.
- Gresnigt/Gourlay use `S3`-style family symmetry in Clifford/sedenion models.
- The common naturality theorem appears to be a reusable algebraic fact rather
  than a statement specific to either paper.
- It is Lean-friendly: finite groups, linear equivalences, commuting operators,
  charge eigenvalue tables, and finite anomaly sums.

Proposed Lean landing zones:

- `PhysicsSM/StandardModel/FamilySymmetry.lean`
- `PhysicsSM/StandardModel/FamilyAnomalyNaturality.lean`
- `PhysicsSM/Algebra/Furey/TrialityFamilyNaturality.lean`

First theorem package:

1. Define a generic `FamilyAction` on a finite index type of sectors.
2. Define what it means for an operator/table entry to be invariant under the
   family action.
3. Prove eigenvalue transport across family-equivalent sectors.
4. Prove finite anomaly sums are unchanged by replacing a generation by a
   family-equivalent generation.
5. Instantiate the abstract theorem for the existing Furey-Hughes
   `TrialityTriple` permutation API.

Claim boundary: this theorem would not prove that any particular model is the
physical Standard Model. It would prove that once the one-generation gauge table
is correct and the family action commutes with the gauge operators, the family
copies inherit the same gauge and anomaly data.

---

## Design decisions already made

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Project philosophy | Mathematics-first | Algebra foundations must be stable before physics interpretation |
| Lean toolchain | `v4.28.0` (pinned) | Reproducibility; update deliberately |
| Primary dependency | mathlib4 (Apache-2.0) | Largest verified algebra library; same kernel |
| Octonion basis | XOR binary labels `e000`–`e111` | Computationally clean; XOR gives product index |
| Fano orientation | Anchored by `e011*e111=e100` | User-specified; validated against Moufang |
| Baez/Furey translation | Via `ConventionBridge` | Explicit mapping; status: Map derived via `validate_octonion.py` |
| License | Apache-2.0 (Lean source) | Matches mathlib/PhysLean ecosystem |
| Hypercharge | Q = T₃ + Y/2 | Weinberg convention |
| Metric signature | (+,-,-,-) | Peskin–Schroeder |
| Spinor notation | Van der Waerden two-component | Wess–Bagger |
| Cartan labelling | Bourbaki | Standard reference |

---

## Source prioritization

### Tier 1 — import and extend (no porting)
- **mathlib4**: `Mathlib.Algebra.Lie.*`, `Mathlib.LinearAlgebra.CliffordAlgebra.*`,
  `Mathlib.LinearAlgebra.RootSystem.*`, `Mathlib.RepresentationTheory.*`
- **PhysLean** (HEPLean/PhysLean): SM namespace, physics utilities — evaluate
  before implementing any SM-facing content

### Tier 2 — clean-room formalization from papers
- **Baez (2002)**: "The Octonions" — division algebras, octonion identities, G₂
- **Baez–Huerta (2010)**: arXiv:0909.0551 — division algebras and SUSY
- **Furey (2015)**: PhD thesis — SM representation structure from octonions
- **Furey (2018)**: "SU(3)_C × SU(2)_L × U(1)_Y (× U(1)_X) as a symmetry of division algebraic ladder operators" (EPJC 78)
- **Furey (2014)**: "Generations: Three prints, now in colour" (Phys. Rev. D 86)
- **Furey & Hughes (2024/2025)**: "Three Generations and a Trio of Trialities"
  (arXiv:2409.17948) - current triality-generation source.
- **Furey (2025)**: `Z2^5`-graded superalgebra paper (arXiv:2505.07923) -
  finite algebra target after the one-generation charge table is clean.
- **Krasnov (2018)**: "The Standard Model and Octonions" (arXiv:1804.05364)
- **Krasnov (2025)**: "Octonions, complex structures and Standard Model
  fermions" (arXiv:2504.16465) - recent complex-structure/Spin(10) route.
- **Baez (2021)**: "Can We Understand the Standard Model Using Octonions?"
  slides, copied locally as `Sources/John _Baez_standard_model_octonions.pdf`
- **Dubois-Violette & Todorov (2018)**: "Deducing the Standard Model from the Exceptional Jordan Algebra" (arXiv:1806.09450)
- **Baez & Schwahn (2026)**: "Projective Geometry and the Exceptional Jordan
  Algebra" slides, copied locally as `Sources/John_Baez_exceptional.pdf`
- **Krasnov (2021)**: "SO(9) characterization of the Standard Model gauge group"
- **Gresnigt, Gourlay, and Varma (2024-2026)**: `Cl(8)`, `Cl(10)`, and `S3`
  family-symmetry models; use as comparison targets, not as source code.
- **Landsberg & Manivel (2006)**: projective geometry over composition algebras
- **Dixon (1994)**: "Division Algebras: Octonions, Quaternions, Complex Numbers and the Algebraic Design of Physics"
- **Adams (1996)**: "Lectures on Exceptional Lie Groups" — E₈ and exceptional structure

### Tier 3 — oracle/fixture generation only (do not copy code)
- **LieART** (LGPL): E₈ roots, branching rules, tensor products
- **SageMath**: root systems, Weyl character rings, type-E data
- **OSCAR.jl**, **Lie.jl**, **ChevLie.jl**: Cartan matrices, weight lattices
- **SymPy**, **Octonions.jl**: cross-check arithmetic
- **FeynCalc** (GPL), **PyR@TE**: gamma matrices, RGEs — oracle only, never copy

### Tier 4 — design reference only
- **math-comp**, **AFP Lie_Groups**, **CoqQ**: organizational patterns, not syntax

**Licensing rule**: GPL/LGPL/AGPL code never enters trusted Lean source.
Oracle fixtures are numeric/symbolic results only.

---

## Milestones

### Milestone 0 — Foundation ✅ COMPLETE
- [x] Repo skeleton with full module structure
- [x] CI pipeline (build + no-sorry + docgen)
- [x] Text hygiene enforcement (editorconfig, gitattributes, pre-commit)
- [x] MCP servers (scholarly, zotero_write, neo4j_graph)
- [x] Aristotle API connected
- [x] Octonion XOR convention locked and validated
- [x] ConventionBridge stub
- [x] Glossary and Roadmap documents

---

### Milestone 1 — Octonion algebra
**Goal**: The `Octonion` type with all core identities proved. No `sorry` in
trusted files at completion.

**Lean targets** (`PhysicsSM/Algebra/Octonion/`):

| File | Content | Key theorems |
|------|---------|-------------|
| `Basic.lean` | `Octonion` structure, basis, multiplication | `fanoTriples`, `mul_def` |
| `Conjugation.lean` | `conj` involution | `conj_conj`, `conj_mul`, `mul_conj` |
| `Norm.lean` | `normSq` | `normSq_nonneg`, `normSq_eq_zero`, `normSq_mul` |
| `Alternativity.lean` | Alternative laws | `left_alternative`, `right_alternative` |
| `Moufang.lean` | Moufang identities | `moufang_left`, `moufang_right`, `moufang_middle` |
| `TrialityCompanions.lean` | Conjugation criterion foothold | `conjBy_mul_of_unit_cube_eq_one`, `conjBy_iter_three_of_unit_cube_eq_one` |

**Status**: Complete at the trusted coordinate-arithmetic layer. Aristotle
results now integrated:
- Basic arithmetic core: explicit multiplication, pointwise additive/scalar
  operations, left and right alternativity, and anticommutation of distinct
  imaginary basis elements.
- Job `fe5f83fd-885e-4f87-936f-9a8a4746ee7c`: conjugation, squared norm,
  norm multiplicativity, all three Moufang identities, and flexibility.
- Job `d76adda3-911d-43d2-ac78-6d122fcda89c`: `cube`, `conjBy`, unit
  cancellation through conjugates, the `cube = +/-1` forward automorphism
  theorems, and the corresponding order-three iteration theorems. Companion
  identities and the converse criterion remain open.

**Strategy**: Continue from the explicit eight-coordinate representation already
in `Basic.lean`. The current trusted proofs intentionally use component
expansion followed by real polynomial normalization. Introduce abstract
composition-algebra, normed-division-algebra, or Moufang-loop interfaces only
when a downstream theorem needs them.

**Deferred scope**: Hurwitz uniqueness/classification is not a Milestone 1 gate.
It belongs in a later division-algebra classification milestone after the
octonion norm and Cayley-Dickson bridge are stable.

**Classification boundary**: A failed sedenion composition law is evidence
about one Cayley-Dickson continuation, not a proof of Hurwitz's classification.
Do not claim that Lean has proved "only dimensions 1, 2, 4, and 8" until the
classification theorem itself is formalized with its hypotheses.

**Oracle backstop**: `Octonions.jl` and the Python validator for arithmetic checks.

**Risk**: Nonassociativity creates API friction with mathlib's algebra hierarchy.
Keep `Octonion` in its own namespace and do not attempt to fit it into `Algebra`
or `Ring` typeclasses prematurely.

---

### Milestone 2 — Cayley–Dickson construction
**Goal**: The generic doubling construction, connecting ℝ → ℂ → ℍ → 𝕆, with
norm identity inheritance proved.

**Lean targets** (`PhysicsSM/Algebra/Division/`):

| File | Content |
|------|---------|
| `Basic.lean` | Normed division algebra interface |
| `CayleyDickson.lean` | Generic `CD(A)` doubling; multiplication formula |
| `QuaternionBridge.lean` | Align `CD(ℂ)` with `Mathlib.Analysis.Quaternion` |

**Dependency**: Milestone 1 must be complete (octonions as `CD(ℍ)`).

**Status (2026-05-06)**: The trusted generic doubling foundation is integrated
in `PhysicsSM/Algebra/Division/CayleyDickson.lean`. It supplies the pair type,
star operation, multiplication, additive/group/module structure, conjugation,
distributivity lemmas, squared norm, and the concrete iterates `CD1`, `CD2`,
and `CD3`. The semantic bridge from `CD3` to the project's XOR-basis
`Octonion` is now trusted in
`PhysicsSM/Algebra/Division/CayleyDicksonOctonionBridge.lean`, including the
sign-corrected coordinate isomorphism and multiplication preservation. Norm
multiplicativity inheritance for the full tower remains a later trusted theorem
target.

---

### Milestone 3 — Clifford algebras and spinors
**Goal**: Gamma matrices, chirality operator, and all four spinor types in (3+1)
dimensions, built on top of `Mathlib.LinearAlgebra.CliffordAlgebra`.

**Lean targets**:

| File | Content |
|------|---------|
| `Clifford/Basic.lean` | Convention wrapper; parameterized by metric signature |
| `Clifford/GammaMatrices.lean` | Concrete γᵘ in Weyl and Dirac representations |
| `Clifford/Even.lean` | Even subalgebra; spinor decomposition |
| `Spinor/Weyl.lean` | Left/right-Weyl spinors under SL(2,ℂ) |
| `Spinor/Dirac.lean` | Dirac spinor as Weyl pair |
| `Spinor/Majorana.lean` | Majorana condition and dimension constraint |
| `Spinor/PureSpinor10.lean` | Predicate-level Spin(10) pure-spinor scaffold |

**Spin(10) scaffold status**: `PhysicsSM/Spinor/PureSpinor10.lean` is trusted
and deliberately predicate-level. It defines `WeylSpinor10`,
`IsPureSpinor10`, orthogonality, aligned pure-spinor pairs, and rescaling
lemmas, but it does not claim a Spin(10) group action or Standard Model
stabilizer theorem.

**Key theorem**: Clifford relation `{γᵘ, γᵛ} = 2ηᵘᵛ · 1` with explicit signature
parameter.

**Risk**: Metric signature and γ₅ sign conventions vary widely in the literature.
All conventions must be explicit parameters — never global choices.

---

### Milestone 4 — Exceptional Lie theory
**Goal**: E₈ root system with basic combinatorial theorems proved; G₂ as the
automorphism group of the octonions stated (full proof deferred).

**Lean targets** (`PhysicsSM/Lie/`):

| File | Content |
|------|---------|
| `Cartan.lean` | `CartanType` enumeration (already done) |
| `RootData.lean` | Wrappers over `Mathlib.LinearAlgebra.RootSystem` |
| `Weights.lean` | Weight lattice; Weyl character formula interface |
| `Branching.lean` | Branching rule data structures |
| `Exceptional/G2.lean` | G₂ root data; `Aut(𝕆) ≅ G₂` and `Der(𝕆) ≅ 𝔤₂` statements |
| `Exceptional/E8.lean` | E₈ root data; rank 8; 240 roots; det(Cartan) = 1 |
| `Exceptional/Triality.lean` | Trusted finite D4 Cartan-matrix triality cycle |
| `Exceptional/OctonionSymmetry.lean` | Dot product, imaginary octonions, and commutator primitives for the later G2/SO(8) bridge |

**Status**: First exceptional foothold integrated from Aristotle job
`aab25ea4-035f-45e0-8321-3408a1edfaaf`. The current trusted result is finite
and deliberately scoped: D4 triality is proved as Cartan-matrix preservation by
an order-three outer-node cycle, while group-level Spin(8) triality, `G2 =
Aut(O)`, and E8 decompositions remain future work.

**New E8 theorem islands**: The publication-frontier wave added two trusted
coordinate/combinatorial footholds that are deliberately below the full Lie
group level:
- `PhysicsSM/Algebra/Octonion/IntegralOctonion.lean` defines a 240-element E8
  root seed in doubled octonion coordinates and proves norm, negation, and
  dot-product pattern facts by kernel-checked finite computation.
- `PhysicsSM/Coding/ConstructionA.lean` and `PhysicsSM/Coding/HammingE8.lean`
  formalize Construction A for binary codes and prove the extended Hamming
  code gives an integer lattice with minimum nonzero squared norm `4`, i.e.
  the conventional E8 minimum `2` after scaling by `1/sqrt(2)`.

**Oracle protocol**: Every E₈ combinatorial claim must be cross-checked against
at least two of: LieART, SageMath `RootSystem(['E',8])`, OSCAR.jl.
**Key Theorem**: The 7D cross product defined via `Im(xy)` satisfies the Jacobi-like identities (Baez 2002).

**Risk**: E₈ is large. The 240-root count and Cartan determinant are easily
mis-stated. Use oracle fixtures before attempting Lean proofs.

---

### Milestone 5 — Standard Model gauge structure and representations
**Goal**: `G_SM = SU(3) × SU(2) × U(1)` gauge algebra assembled; one generation
of fermions with verified charge assignments.

**Lean targets** (`PhysicsSM/Gauge/`, `PhysicsSM/StandardModel/`):

| File | Content |
|------|---------|
| `Gauge/U1.lean` | u(1) Lie algebra |
| `Gauge/SU2.lean` | su(2) with generators |
| `Gauge/SU3.lean` | su(3) with Gell-Mann matrices |
| `Gauge/StandardModel.lean` | Direct sum `su(3) ⊕ su(2) ⊕ u(1)` |
| `StandardModel/QuantumNumbers.lean` | Isospin, hypercharge, color types |
| `StandardModel/Charges.lean` | `Q = T₃ + Y/2`; consistency lemmas |
| `StandardModel/Fermions.lean` | Three-generation fermion rep table | `generation : Fin 3` parameter |
| `StandardModel/Representations.lean` | Anomaly cancellation checks | Per-generation and total |

**Key theorems**: Electric charge of W± is ±1; anomaly cancellation conditions
`Σ Y³ = 0`, `Σ T₃² Y = 0` satisfied for one generation.

**Recent trusted gauge/fermion scaffolds**:
- `PhysicsSM/StandardModel/OneGenerationTable.lean` records the conventional
  physical chirality table and the all-left-handed charge-conjugate convention
  side by side, with Weyl counts and `Q = T3 + Y/2` checks.
- `PhysicsSM/Gauge/StandardModelSubgroup.lean` gives the determinant-one
  `S(U(2) x U(3))` block subgroup API and the six-phase kernel scaffold.
- `PhysicsSM/Gauge/GUTSquare.lean` proves the Baez-Huerta matrix-predicate
  intersection `G_SM = SU(5) cap (U(2) x U(3))` at the finite matrix predicate
  level, explicitly below compact Lie group topology.

**Milestone gate**: Human semantic review of every quantum number assignment
against at least one textbook source (Peskin–Schroeder or Weinberg Vol. 2)
before merge.

**Handedness boundary**: Modules that model only the Krasnov/Baez `O^2`
octonionic-qubit route must not be named or summarized as the full Standard
Model fermion sector. That route currently accounts for a left-handed
one-generation representation only; right-handed fermions and three
generations are explicit open defects. Conventional anomaly modules may use
the standard all-left-handed Weyl convention, where physical right-handed
fermions are represented by their left-handed charge-conjugate fields, but that
is a convention and must be documented at each bridge.

---

### Milestone 6 — Furey-style algebraic SM structure
**Goal**: **[ADVANCED]** Ladder operators derived from the complexified octonion algebra; key
representation-theoretic facts about the SM particle content recovered from
algebraic structure.

**Status**: Partially complete and kernel-checked. Aristotle results merged:

- `ComplexOctonion` pair arithmetic, multiplication, unit, scalar actions, and
  additive monoid support for repeated sums.
- Furey ladder operators and daggers in XOR convention.
- Six nilpotency theorems and all 27 Cl(6) anticommutation relations.
- Minimal-left-ideal finite arithmetic: omega, eight explicit states, action
  table, number-operator eigenvalues, charge-sum lemmas, and nonzero witnesses.
- Operator representation layer from Aristotle jobs
  `0bcaa9b0-9a92-48e0-a3a3-30969e8742aa` and
  `38b00d57-1e6d-4ace-aefc-d4e147739b4a`: `J`, `J_basis`, `Lmul`, operator
  Cl(6) relations on `J`, color-changing operator transitions, number
  operators, and the electric-charge operator `Q_op`.
- Finite operator algebra layer from Aristotle job
  `79238cf7-f9dd-429f-97ed-b2fe96c8d3e4`: `EqOnJ`, `opComm`, explicit color
  transition tables, SU(3)-style commutator identities, electric-charge
  conservation, and sector submodules in
  `PhysicsSM/Algebra/Furey/OperatorAlgebra.lean`.

**Status**: Advanced. Linear independence proved. Basis states matched to Furey's
particle table. Action table and finite operator algebra complete. The next
semantic bridge is to introduce weak isospin and hypercharge over the existing
table, then prove the convention `Q = T3 + Y/2` and connect it to the anomaly
package.

**Convention note**: The number-operator combination
`(-1/3) * (N1 + N2 + N3)` is the electric-charge operator `Q_op` on the current
Furey basis. Weak hypercharge should only be introduced in modules that also
specify weak isospin and use the convention `Q = T3 + Y/2`.

**Primary source**: Furey (2015) PhD thesis; Furey (2018) EPJC 78 375.
Paper-first
formalization — no public code repository exists for direct porting.

**Key constraint**: Every Furey formula that uses a product or basis element must
cite its `ConventionBridge` translation before appearing in trusted Lean code.

**Aristotle usage**: This milestone is the most Aristotle-intensive. The algebraic
identities for ladder operators and nilpotency are well-defined proof tasks
with clear statement/proof separation.

---

### Milestone 7 — Supersymmetry algebra scaffold
**Goal**: Super vector spaces, super Lie algebra definition, and the SUSY
anticommutator `{Q, Q̄} = 2σP` as a typed formal interface.

**Strategy**: Kinematics and algebra only — no phenomenology, no superfields,
no soft breaking. The goal is a clean algebraic interface that later work can
build on.

**Key theorem**: Graded Jacobi identity for the super Lie bracket.

**Connection to division algebras**: State (but defer proof of) the Baez–Huerta
result connecting SUSY in dimensions 3, 4, 6, 10 to normed division algebras.

### Milestone 8 — Exceptional Jordan geometry and the Baez-Schwahn conjecture
**Goal**: Formalize the mathematical content of
`Sources/John_Baez_exceptional.pdf`: the exceptional Jordan algebra `h_3(O)`,
its projective geometry `OP^2`, the standard subalgebras `h_2(O)`, `h_3(C)`,
and `h_2(C)`, and the projective-geometry stabilizer conjecture whose common
stabilizer is `S(U(2) x U(3))`.

**Motivation**: This is the cleanest current route from octonions and the
exceptional Jordan algebra to the Standard Model gauge group. It complements
the Furey minimal-left-ideal program: Furey gives explicit finite particle
arithmetic, while Baez-Schwahn/Dubois-Violette-Todorov give a geometric
stabilizer characterization of the gauge group.

**Primary local sources**:

| File | Purpose |
|------|---------|
| `Sources/John _Baez_standard_model_octonions.pdf` | Baez 2021 talk source for the octonionic qubit/qutrit, `Spin(9)`, `h_3(C)` splitting, and Krasnov fermion endpoint |
| `Sources/John_Baez_exceptional.pdf` | Main source to formalize: Baez-Schwahn projective-geometry presentation |
| `Sources/Baez_Octonions_Standard_Model_Talk_Notes.md` | Notes from related Baez talk material |
| `Sources/Baez_Standard_Model_Octonions_Lean_Proof_Plan.md` | Slide-by-slide Lean theorem inventory for the 2021 talk |
| Baez, `Standard Model - Part 3: Qubits` public lecture | Accessible source for the quunit/qubit/qutrit motivation behind `U(1)`, `SU(2)`, and `SU(3)` |
| `Sources/Exceptional_Jordan_Projective_Geometry_Lit_Search.md` | Literature search and formalization strategy |
| `AgentTasks/exceptional-jordan-projective-geometry-moonshot.md` | Aristotle handoff for the first large proof push |
| `AgentTasks/aristotle-next-wave-2-2026-05-06.md` | Next six aggressive Aristotle jobs after the 2026-05-06 integration |
| `AgentTasks/publication-frontier-aristotle-2026-05-06.md` | Publication-frontier Aristotle jobs for triality, bioctonions, E8/code lattices, GUT square, and Spin(10) pure-spinor scaffolds |
| `PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean` | Current typed draft scaffold |

**Aristotle status**:

- Job `17d42ab0-5795-4bcc-b387-d93e47bd976e` — **COMPLETE, integrated
  2026-05-05**. Delivered trusted `H3O.lean` (530 lines, 24 kernel-checked
  theorems) and the projective-geometry draft layer in
  `ExceptionalJordanProjectiveGeometry.lean`. Six frontier sorries remained
  before the 2026-05-06 second wave.
- Job `76df9a63-ef90-4aa4-b0cb-e82e2ba48b32` — **COMPLETE, integrated
  2026-05-05**. Delivered seven trusted modules (`ComplexLine`, `Jordan/Basic`,
  `SpinFactor`, `H2O`, `H3O`, `StandardModelGroup`, `OctonionicQubit`) and
  the `BaezStandardModelFromOctonions.lean` draft. Its two Jordan-product
  frontier sorries were closed by the 2026-05-06 second wave.
- Second wave, **COMPLETE, integrated 2026-05-06**:
  - `79238cf7-f9dd-429f-97ed-b2fe96c8d3e4`: Furey finite operator algebra.
  - `d2bc1249-49f7-4cdb-b06e-3971faaa5d5c`: H2O/H3O Jordan product bundle
    and trusted H3O Jordan identity.
  - `5287e902-67dc-4ff0-a569-b67f3b058d98`: chosen-complex-line splitting
    of the octonions.
  - `77b64073-54bc-4068-a625-5feea13ea523`: Jordan automorphism and
    projective-geometry API.
  - `c02ae3c0-1574-4847-8a7d-e5a91a20db20`: generic Cayley-Dickson
    foundation.
  - `55bb70e4-6992-4ff4-8a75-8e214500da9b`: Standard Model block embedding
    and `Z6` quotient scaffold.

The active draft frontier is now concentrated in
`PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean`, with four expected
`sorry`s: Baez-Schwahn pair transitivity, the standard-block DVT stabilizer
theorem, the general SM stabilizer theorem, and the projective common
stabilizer theorem. The common-stabilizer group closure itself has moved into
trusted code in `PhysicsSM/Algebra/Jordan/Stabilizer.lean`.

**Semantic target from the PDF**:

Formalize the chain:

```text
h_3(O) exceptional Jordan algebra
  -> projections of trace 1 and 2
  -> points and lines of OP^2
  -> subalgebras A ~= h_2(O), B ~= h_3(C), A cap B ~= h_2(C)
  -> projective version: X ~= CP^2, ell ~= OP^1, X cap ell ~= CP^1
  -> Stab(X) cap Stab(ell) ~= S(U(2) x U(3)).
```

The proof is expected to factor through the algebraic transitivity lemma from
the slides:

```text
F4 acts transitively on pairs (A, B) with
A ~= h_2(O), B ~= h_3(C), and A cap B ~= h_2(C).
```

Once this is available, the general stabilizer theorem reduces to the standard
Dubois-Violette-Todorov block example.

**Lean targets**:

| Layer | File target | Content | Status |
|-------|-------------|---------|--------|
| Coordinate Albert algebra | `PhysicsSM/Algebra/Jordan/H3O.lean` | Trusted `H3O` coordinate model, addition, negation, scalar multiplication, trace | ✅ trusted |
| Jordan product | `PhysicsSM/Algebra/Jordan/H3O.lean` | Explicit Jordan product `(a*b + b*a)/2`, commutativity, identity | ✅ trusted |
| Complex line in octonions | `PhysicsSM/Algebra/Octonion/ComplexLine.lean` | The chosen `C = span_R {1, e111}`, closure, complex structure J² = -id | ✅ trusted |
| Standard blocks | `PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean` | `standardA`, `standardB`, `standardAInterB`; closure; block isomorphism targets | ✅ proved in draft |
| Projections and projective geometry | `PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean` | `OP2Point`, `OP2Line`, `LiesOn`, standard octonionic line and complex projective plane | ✅ defined in draft |
| Spin factor and `h₂(O)` | `PhysicsSM/Algebra/Jordan/H2O.lean`, `SpinFactor.lean` | Spin factor, `det = t² - x² - normSq(y)`, projections | ✅ trusted |
| SM gauge group scaffold | `PhysicsSM/Gauge/StandardModelGroup.lean` | `S(U(2) × U(3))`, ℤ₆ center, SU(4) block | ✅ trusted |
| Quunit/qubit/qutrit dictionary | `PhysicsSM/Gauge/QunitQubitQutritDictionary.lean` | `C`, `C^2`, `C^3`, block `C^2 ⊕ C^3`, and `S(U(2) x U(3))` motivation | planned |
| Krasnov qubit | `PhysicsSM/Spinor/OctonionicQubit.lean` | `O²`, `rightMulE111_sq_neg` | ✅ trusted |
| Automorphisms | `PhysicsSM/Algebra/Jordan/Automorphism.lean` | Jordan automorphisms of `h_3(O)` as stand-in for F₄ | trusted |
| Stabilizers | `PhysicsSM/Algebra/Jordan/ProjectiveGeometry.lean`, `Stabilizer.lean`, plus draft frontier | Line/plane stabilizer predicates, standard-line subgroup facts, trusted common-stabilizer group closure | trusted subgroup API; isomorphism frontier remains draft |
| Frontier statements | `PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean` | F₄ transitivity and `S(U(2) × U(3))` isomorphism | 4 frontier sorries |

**Proof phases**:

1. **Trusted finite coordinate layer**:
   - define `H3O` as the six independent Hermitian coordinates
     `alpha beta gamma : R` and `x y z : O`;
   - prove extensionality and coordinate simp lemmas;
   - prove trace linearity;
   - document the matrix convention:

```text
[[alpha, z, conj y],
 [conj z, beta, x],
 [y, conj x, gamma]].
```

2. **Jordan product layer**:
   - implement explicit octonionic matrix multiplication only for the Hermitian
     3 by 3 pattern needed by `h_3(O)`;
   - define `a o b = (1/2) * (a*b + b*a)`;
   - prove commutativity of the Jordan product;
   - prove `diag(1,1,1)` is a unit;
   - prove `diag(1,1,0)` is a projection of trace two.

3. **Chosen complex subalgebra layer**:
   - define the project's chosen copy of `C` inside `O` as
     `span_R {1, e111}`;
   - prove closure under zero, addition, negation, scalar multiplication,
     conjugation, and octonion multiplication;
   - prove that the standard `h_3(C)` block is closed under the Jordan product.

4. **Standard subalgebra layer**:
   - construct the upper-left `h_2(O)` block `A`;
   - construct the chosen `h_3(C)` block `B`;
   - construct and characterize `A cap B` as the upper-left `h_2(C)` block;
   - prove membership iff lemmas for all three blocks;
   - state isomorphism targets to abstract `h_2(O)`, `h_3(C)`, and `h_2(C)`.

5. **Projective dictionary layer**:
   - define points as trace-one projections;
   - define lines as trace-two projections;
   - define incidence by the Jordan product;
   - prove the identity projection of a copy of `h_2(O)` gives an octonionic
     projective line;
   - prove trace-one projections in a copy of `h_3(C)` form a complex
     projective plane;
   - state the equivalence between the algebraic and projective versions of the
     Baez-Schwahn conjecture.

6. **Stabilizer and group layer**:
   - define Jordan automorphisms of `h_3(O)`;
   - prove automorphisms preserve projections, trace, points, lines, and
     incidence;
   - define the common stabilizer of a complex projective plane and an
     octonionic projective line;
   - define the Standard Model gauge group as the block group
     `S(U(2) x U(3))`, eventually aligned with the existing gauge modules.

7. **Dubois-Violette-Todorov block example**:
   - formalize the standard example from the slides;
   - state and eventually prove:

```text
Stab(standardA) ~= Spin(9)
Stab(standardB) ~= (SU(3) x SU(3))/Z3
Stab(standardA) cap Stab(standardB) ~= S(U(2) x U(3)).
```

8. **Baez-Schwahn transitivity frontier**:
   - formalize the conjectured lemma that `F4` acts transitively on all pairs
     `(A, B)` with `A ~= h_2(O)`, `B ~= h_3(C)`, and `A cap B ~= h_2(C)`;
   - reduce the projective geometry version to the standard block example;
   - keep this in `Draft` until the supporting `F4` and compact Lie group
     infrastructure is strong enough.

9. **Krasnov fallback path**:
   - formalize the more concrete `Spin(9)` route as an independent bridge:

```text
O = C + C^3
Spin(9)-stabilizer/centralizer of the chosen complex structure
  ~= SU(3) x SU(2) x U(1) / Z6.
```

   - use it as a cross-check and possible earlier theorem if full `F4`
     transitivity remains too large.

**Milestone gates**:

- No trusted file may contain `sorry`.
- Every source-derived statement must cite the PDF or paper and record the
  convention choices.
- The final stabilizer theorem must not be advertised as a derivation of the
  physical Standard Model. It is a mathematical stabilizer theorem identifying
  the Standard Model gauge group.
- Any use of Baez-style octonion signs must pass through
  `PhysicsSM.Algebra.Octonion.ConventionBridge`, because the project uses the
  XOR binary-label convention.

**Risks**:

- Mathlib does not currently appear to provide a ready-made exceptional Jordan
  algebra, Euclidean Jordan algebra hierarchy, `OP^2`, or `F4 = Aut(h_3(O))`.
- The final transitivity lemma is mathematically frontier-level and may remain
  a named conjecture for a long time.
- Stabilizer isomorphisms require careful distinction between compact groups,
  Lie algebras, matrix subgroups, quotient groups, and connected components.

**Short-term success criteria**:

- `PhysicsSM/Algebra/Jordan/H3O.lean` becomes a trusted, sorry-free coordinate
  file.
- The standard line projection `diag(1,1,0)` is proved to be a trace-two
  projection.
- The chosen `h_3(C)` and upper-left `h_2(O)` block predicates are proved closed
  under the Jordan product.
- The projective conjecture is stated in a typechecked draft form with a clear
  semantic-alignment note.

**Remaining pieces from Baez 2021, "Can We Understand the Standard Model Using
Octonions?"**:

1. **Chosen complex line in the project octonions**:
   - define `C = span_R {1, e111}` and its complement;
   - prove closure under addition, negation, scalar multiplication,
     conjugation, and octonion multiplication;
   - prove left/right multiplication by `e111` gives the needed complex
     structures on the complement and on `O^2`.

2. **Minimal Jordan vocabulary**:
   - add a small Jordan-product/projection interface;
   - keep the full Euclidean Jordan algebra classification as source context,
     not a near-term dependency.

3. **`h_2(O)` / octonionic qubit**:
   - define the concrete coordinates
     `[[t+x, y], [conj y, t-x]]`;
   - prove determinant `t^2 - x^2 - normSq(y)`;
   - prove trace and trace-square Euclidean form;
   - connect `h_2(O)` to the 10-dimensional spin factor and state
     `Aut(h_2(O)) ~= O(9)` as a later theorem.

4. **True Standard Model gauge group**:
   - define `S(U(2) x U(3))` as the block subgroup of `SU(5)`;
   - define the covering map from `U(1) x SU(2) x SU(3)`;
   - prove or draft the `Z6` kernel and quotient statement;
   - define the slide 18-21 block map into `SU(2) x SU(4)`.

5. **Quunit/qubit/qutrit dictionary**:
   - formalize the dictionary
     `quunit = C`, `qubit = C^2`, `qutrit = C^3`;
   - record that `U(1)` is the unitary symmetry of a complex line, `SU(2)`
     acts on the weak `C^2` doublet, and `SU(3)` acts on the color `C^3`
     triplet;
   - prove that the block split `C^5 = C^2 ⊕ C^3` gives the compact matrix
     target `S(U(2) x U(3))`;
   - connect the product cover
     `(U(1) x SU(2) x SU(3)) -> S(U(2) x U(3))` to the already-formalized
     `Z6` kernel;
   - relate the ordinary complex observables `h_2(C)` and `h_3(C)` to the
     octonionic observables `h_2(O)` and `h_3(O)` as the precise version of
     Baez's qubit/qutrit slogan;
   - keep the claim boundary explicit: this is representation geometry and
     Jordan-observable algebra, not a claim about quantum-computing hardware.

6. **`h_3(O)` / octonionic qutrit**:
   - promote the safe coordinate model from draft to trusted Lean;
   - implement the Jordan product with explicit nonassociative
     parenthesization;
   - prove the block decomposition
     `h_3(O) ~= R x h_2(O) x O^2` for a chosen `h_2(O)` block.

7. **`h_3(C)` splitting from a unit imaginary octonion**:
   - define the embedded `h_3(C)` using the chosen complex line;
   - define the trace-orthogonal complement;
   - prove the coordinate description of the complement;
   - prove the induced complex structure squares to `-1`;
   - define the vector-space model `h_3(O) ~= h_3(C) x M_3(C)`.

8. **Yokota/Dubois-Violette-Todorov stabilizer theorem**:
   - state the subgroup preserving the `h_3(C)` splitting and complex
     structure as `(SU(3) x SU(3)) / Z3`;
   - define the action `(g,h)(X,M) = (gXg*, hMg*)`;
   - prove easy central-kernel and vector-space facts first;
   - leave full Jordan-product preservation and compact-group isomorphism in
     draft until the supporting Lie group infrastructure exists.

9. **Intersection theorem**:
   - state the common stabilizer of the `h_3(C)` structure and chosen `h_2(O)`
     block;
   - prove, or keep as a sourced frontier theorem, that it is
     `S(U(2) x U(3))`;
   - keep this separate from the later Baez-Schwahn pair-transitivity
     conjecture.

10. **Krasnov octonionic-qubit endpoint**:
   - define `O^2` with right multiplication by `e111`;
   - prove the complex-structure facts;
   - state the centralizer theorem inside `Spin(9)`;
   - compare the resulting complex representation with the left-handed
     one-generation Standard Model fermions;
   - document that right-handed fermions and three generations remain open in
     this route.

---

### Milestone 9 — Multi-generational unification and Dixon algebra
**Goal**: Formalize the Dixon Algebra
`R tensor C tensor H tensor O` and connect it to the three-generation and
exceptional-Jordan directions once the `h_3(O)` layer is stable.

**Motivation**: Move from one generation to three and compare the Furey,
Dixon, Krasnov, and Baez-Schwahn routes to Standard Model structure.

**Strategy**: Reuse the Cayley-Dickson and `h_3(O)` infrastructure. Do not
start a large Dixon formalization until Milestones 2, 6, and the trusted parts
of Milestone 8 are stable enough to avoid duplicating algebra.

**2026-05-31 update**: The strongest publication-shaped path is not a direct
formalization of a single three-generation paper. It is an abstract
family-symmetry naturality theorem that can later be instantiated for
Furey-Hughes triality and compared with Gresnigt/Gourlay `S3` models.

**New Lean targets**:

| File | Content |
|------|---------|
| `PhysicsSM/StandardModel/FamilySymmetry.lean` | Finite family action on indexed generation sectors |
| `PhysicsSM/StandardModel/FamilyAnomalyNaturality.lean` | Eigenvalue and anomaly-sum transport under family-equivalent sectors |
| `PhysicsSM/Algebra/Furey/TrialityFamilyNaturality.lean` | Furey-Hughes triality instantiation using `TrialityTriple` permutations |

**First theorem ladder**:

1. Package finite sector tables abstractly: family index, state type, charge
   operators, and finite anomaly polynomials.
2. Define when a family action commutes with a gauge/charge operator.
3. Prove eigenvalue transport across a family orbit.
4. Prove anomaly-sum invariance across family-equivalent sectors.
5. Prove adjoining family-equivalent copies does not change the finite `Z6`
   kernel data already formalized in the gauge modules.
6. Instantiate the generic theorem for the existing Furey-Hughes
   `TrialityRole`/`TrialityTriple` linear permutation API.

**Claim boundary**: This would be a mathematical naturality theorem about
finite algebraic Standard Model tables. It would not claim that triality or
`S3` is the physical origin of generations.

---

## Agent workflow

### Standard proof task

```
1. Claude prepares:
   - Minimal Lean file: correct imports, theorem statement, sorry placeholder
   - Handoff note: informal proof sketch, failed attempts, relevant mathlib lemmas
   - AgentTasks/<name>.md: structured task record per AGENTS.md format

2. Aristotle runs:
   aristotle submit \
     --project-dir C:/Projects/StandardModel \
     --wait \
     --destination AgentTasks/aristotle-output/<name> \
     "<focused prompt>"

3. Review:
   - Semantic alignment check: do hypotheses and conventions match the source?
   - lake build: does the patch compile cleanly?
   - No sorry in trusted directories
   - Source citation present

4. Merge or iterate
```

### Standard oracle task

```
1. Identify the claim (root count, branching rule, gamma identity, charge, etc.)
2. Generate fixture in ≥2 independent CAS backends
3. Record in PhysicsSM/Oracle/<domain>Fixtures.lean with tool/version/command
4. Write Lean-side executable definition that reproduces the fixture
5. Oracle agreement ≠ proof; open an AgentTask for the formal proof
```

### Convention translation task (Baez/Furey → project)

```
1. Extract the formula from the source paper
2. Apply baezToXORIndex permutation from ConventionBridge
3. Determine sign corrections (to be worked out in Milestone 1 completion)
4. State the translated formula as a Lean theorem in ConventionBridge
5. Prove it (typically by explicit computation on Fin 8)
6. Only then use the formula in upstream physics modules
```

---

## Open questions

1. **PhysLean integration**: Before implementing any SM-facing content, audit
   HEPLean/PhysLean for existing formalized results. Some Milestone 5 content
   may already exist there.

2. **ConventionBridge sign corrections**: The label permutation `baezToXORIndex`
   is defined; the sign correction map needs to be worked out computationally
   (likely a Python script comparing the two multiplication tables) and then
   formalized. This is a prerequisite for Milestone 6.

3. **E₈ root system approach**: Build from the Mathlib root system framework
   (preferred, for composability) or from an explicit 240-vector description?
   Recommendation: use Mathlib framework, validate against explicit vectors as
   oracle fixture.

4. **Neo4j schema initialization**: The `neo4j_graph` MCP server is connected
   but the schema (node types `Module`, `Declaration`, `ExternalSource`, etc.)
   has not been initialized. Do this before Milestone 1 produces real declarations.

5. **Physlib dependency**: Should PhysLean be added as a Lake dependency
   alongside mathlib? Evaluate after the PhysLean audit.

6. **Minimal ideal as a linear object**: `MinimalLeftIdeal.lean` proves the
   explicit finite arithmetic of the eight states, but J is not yet packaged as
   a `Submodule`/basis over ℂ. The open task is
   `AgentTasks/furey-ideal-linear-independence.md`.

7. **Baez-Schwahn transitivity status**: Is the conjectured transitivity lemma
   in `Sources/John_Baez_exceptional.pdf` already known in the literature under
   a different homogeneous-space or incidence-geometry formulation, or is it
   genuinely new? This determines whether Milestone 8 is a formalization of an
   existing theorem or a formalized conjecture with partial supporting lemmas.

8. **Family-symmetry naturality abstraction**: What is the cleanest theorem
   statement that covers both Furey-Hughes triality and Gresnigt/Gourlay `S3`
   family symmetry without importing either model's full algebra? Start with
   finite indexed tables and commuting linear equivalences; instantiate later.

9. **Gresnigt/Gourlay dependency boundary**: The `Cl(10)`/`S3` papers are
   current and promising, but the repo does not yet have the Clifford
   infrastructure needed for a direct formalization. Treat them as comparison
   targets for the family-symmetry theorem until a clean `Cl(10)` model exists.

---

## Immediate next actions

### Completed since last update (2026-05-06)

- Integrated Aristotle jobs `17d42ab0` and `76df9a63`: eight trusted modules
  and two draft modules, all kernel-checked and sorry-free in trusted code.
- Integrated the second six-job Aristotle wave:
  `79238cf7`, `d2bc1249`, `5287e902`, `77b64073`, `c02ae3c0`, and `55bb70e4`.
  This moved Furey operator algebra, H2O/H3O Jordan product identities,
  complex splitting, Jordan automorphisms/projective geometry,
  Cayley-Dickson doubling, and the SM block embedding scaffold into trusted
  Lean modules.
- Delegated the old Baez 2021 Jordan-product draft placeholders to trusted
  theorem modules. `BaezStandardModelFromOctonions.lean` now typechecks without
  those two frontier `sorry`s.
- Prepared the publication-frontier Aristotle wave in
  `AgentTasks/publication-frontier-aristotle-2026-05-06.md`. This wave targets
  publishable theorem islands from the conjecture backlog: triality-shadow
  companion maps, bioctonionic incidence counterexamples, Construction A/E8,
  integral-octonion root seeds, the Baez-Huerta GUT square, and Krasnov
  Spin(10) pure-spinor scaffolding.
- Submitted the publication-frontier Aristotle wave:
  `17399d3d`, `99e37e66`, `d7114ee8`, `b1670106`, `cb7a929e`, and `e3a0b1d5`.
  Output directories are recorded in
  `AgentTasks/publication-frontier-aristotle-2026-05-06.md`.
- Integrated the completed gap-closure and publication-frontier jobs:
  `e89f71be`, `101775e5`, `0bd47cc5`, `cdb75897`, `d988fff7`,
  `813531a9`, `d07518dc`, `0ceb503d`, `88a46864`, `8073c1d9`,
  `cb7a929e`, `99e37e66`, `d7114ee8`, `b1670106`, and `e3a0b1d5`.
  These added the CD3-to-octonion bridge, Jordan trace/stabilizer/action
  scaffolds, derivation stabilizers, Krasnov centralizer API, conventional
  one-generation table, Furey-Hughes triality scaffold, GUT square,
  bioctonionic incidence counterexample, Construction A/Hamming-E8 bridge,
  integral-octonion E8 root seed, and Spin(10) pure-spinor scaffold.

### Active priorities

1. **Publication target A: true SM `Z6` kernel package** - polish the
   `StandardModelZ6*` modules into a self-contained theorem island: define the
   covering map, prove the six-element kernel, record the quotient claim
   boundary, and add a citation-friendly theorem index. This is the nearest
   ITP/formalization paper target.

2. **Publication target A2: quunit/qubit/qutrit bridge** - add
   `PhysicsSM/Gauge/QunitQubitQutritDictionary.lean` as an expository theorem
   island. It should formalize the complex vector spaces `C`, `C^2`, `C^3`,
   the block split `C^2 ⊕ C^3`, the `S(U(2) x U(3))` matrix target, and the
   connection to the existing `Z6` product-cover scaffold. This gives Baez's
   public quunit/qubit/qutrit slogan a precise Lean-facing statement without
   claiming new physics.

3. **Publication target B: Furey charge and electroweak table** - complete the
   bridge from Furey's ladder-operator/number-operator computations to the
   conventional one-generation table. Prove the exact charge eigenvalues,
   weak-isospin/hypercharge assignments, and `Q = T3 + Y/2` in the chosen
   convention.

4. **New-result target: family-symmetry naturality** - create the generic
   `FamilySymmetry` and `FamilyAnomalyNaturality` layer. Prove that a family
   action commuting with gauge/charge operators transports eigenvalues and
   preserves finite anomaly sums across family-equivalent sectors.

5. **Furey-Hughes triality instantiation** - instantiate the generic
   family-symmetry theorem for the existing `TrialityRole` and
   `TrialityTriple` permutation-linear API. Keep the claim to finite
   role-permutation linear algebra and inherited gauge tables, not the full
   `tri(C) + tri(H) + tri(O)` Lie algebra.

6. **Complex splitting and `SU(3)` bridge** - keep strengthening the
   `O = C + C^3` API, Hermitian/unitary coordinate facts, and `G2`-to-`C^3`
   action scaffolds. Do not claim the full `G2` stabilizer is `SU(3)` until
   the group-isomorphism statement is explicitly formalized.

7. **DVT/Yokota and Baez-Schwahn frontier** - continue sharpening the
   block-action and complement-action scaffolds below the compact Lie group
   isomorphism layer. Keep Baez-Schwahn transitivity marked as a frontier
   statement unless a published proof or equivalent homogeneous-space theorem
   is found.

8. **Krasnov/Spin(10) refinement** - largely done at the quadric level
   (2026-06-10): the concrete Fock model (`Spinor/SpinorTenfoldFock`), honest
   Cartan purity quadric and the Krasnov-collinearity equivalence
   (`Spinor/SpinorTenfoldPurity`), CAR/Clifford relation
   (`Spinor/SpinorTenfoldCAR`), symmetry of the gamma-bilinear and single-`q`
   Krasnov condition (`Spinor/SpinorTenfoldGammaSymm`), color-axis `d = 3`
   computation (`Spinor/SpinorTenfoldColorAxis`), Cayley-plane `D5` chart and
   rank-one collinearity (`Algebra/Jordan/CayleyPlaneD5Chart`), and the
   physical hypercharge table for the `16`
   (`StandardModel/SpinorFockHypercharge`) are all trusted and axiom-clean.
   The ten-dimensional Fierz identity and unconditional Proposition 1(b) are
   now also trusted and axiom-clean (`Spinor/SpinorTenfoldFierzKernel`,
   `Spinor/SpinorTenfoldFierz`; Aristotle job
   `93e29d35-37f8-4c3c-bad7-02b5fca82612` replaced the last `native_decide`
   by a closed-form reduction plus kernel `decide`; job
   `1bca1a38-8f7e-4e61-ad1a-13e5f7277d2d`, integrated 2026-06-10, cut the
   `cancel_all` clean-build cost from ~7 minutes to ~30 seconds via a `Nat`
   bit-mask mirror with `enc32`/`dec32` bridge decides). The Baez-Huerta
   octonionic program is complete through the bioctonionic stage: the
   trusted `Algebra/Octonion/SpinorFierz` proves the diagonal 3-psi rule and
   Clifford relation of the octonionic D=10 spinor model from alternativity,
   and the trusted `Algebra/Octonion/SpinorFierzPolarized` (job `04babfce`,
   integrated 2026-06-10) adds the polarized trilinear 3-Psi rule, the
   bioctonionic cancellation laws, and the bioctonionic Clifford + Fierz
   identities. The final stage is in flight: the explicit bioctonion <->
   Fock bridge is fully defined in the trusted
   `Spinor/SpinorTenfoldOctonionBridge` (oracle-generated `octImage` table,
   null-vector `iotaV`, both chirality inverses; all statements verified by
   `Scripts/oracle/validate_bioctonion_fock_bridge.py` in exact arithmetic),
   with the intertwining/inverse/quadric targets and the already-derived
   payoff theorems (`purity_iff_spinorSquareC`,
   `fierz_clifford_via_octonions`) as Aristotle job
   `4c2cd9ac-18bc-4e6a-8e49-4a8966da1890`
   (`Draft/SpinorTenfoldOctonionBridgeAristotle`, wave 5). The group-level
   program: the infinitesimal `so(10)` action
   (`Draft/SpinorTenfoldSO10ActionAristotle`; job `d5acb603` in progress) is
   joined by the physical hypercharge generator `Y = sum y_i rho(e_i ^ f_i)`
   (Prop S3 infinitesimal; `Draft/SpinorTenfoldHyperchargeOpAristotle`; job
   `ee0d7409-c8be-4707-860c-ebfc7969c984`) and the basis-pair annihilator
   trichotomy `dim(N_S cap N_T) = 5 - |S Delta T| in {1,3,5}` (Prop 3 normal
   forms; `Draft/SpinorTenfoldBasisTrichotomyAristotle`; job `5662f6a5`,
   COMPLETE and integrated 2026-06-10 - all seven targets proved, including
   the explicit `pairAnnihilatorEquivCoord` linear equivalence). The
   group-level program proper started 2026-06-10 (wave 6): `Spin(10)` is
   modeled algebraically as `evenCliffordGroup` - the subgroup of
   `(Module.End C FockSpinor)^x` generated by pair products of anisotropic
   Clifford units - in the trusted `Spinor/SpinorTenfoldCliffordGroup`
   (gamma units with explicit inverses, mode-flip units, scalar units,
   twisted reflection; no exponentials or analysis anywhere). Wave 6
   Aristotle jobs: `3408462a` (conjugation = twisted reflection, B10/Q10
   invariance, chirality preservation, conjugation stability of the vector
   image; `Draft/SpinorTenfoldCliffordConjAristotle`) and `701dda9e`
   (mode-flip action on basis spinors and MARKED orbit transitivity on the
   even basis, with the vacuum-to-weak Krasnov anchor derived;
   `Draft/SpinorTenfoldBasisOrbitAristotle`). Remaining after wave 6: the
   spinor Witt theorem (every pure spinor lies in the vacuum orbit), the
   vector representation `evenCliffordGroup -> SO(10, C)`, pair
   transitivity (Lemma S1), the stabilizer computation (Lemma S2), and the
   `S(U(2) x U(3))` Selector Theorem of `Sources/Spin10_stabilizer.txt`.
   Note: `evenCliffordGroup` is `GSpin` (contains all nonzero scalars);
   the spinor-norm-1 cut to `Spin(10)` proper comes later via the
   Chevalley-pairing adjoint and must be done before any theorem is
   advertised as a `Spin(10)` statement.

9. **E8/code-lattice alignment** - connect the integral-octonion 240-root seed
   and Construction A Hamming-E8 lattice to existing `Lie.Exceptional.E8` and,
   later, Sphere-Packing-Lean definitions.

10. **Generated-proof hygiene** - clean nonsemantic linter warnings in
   Aristotle-generated trusted files without changing theorem statements.
