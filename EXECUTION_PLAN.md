# Execution Plan: PhysicsSM

## Current state (2026-04-29)

**Milestone 1 and Core Furey Arithmetic are complete.** The project has:

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

**Important caveat.** Several modules remain documented stubs, and the Furey
particle interpretation still needs semantic review against sources.  The Lean
kernel verifies the explicit algebraic equalities, not the physical
identification of those states.

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
- **Krasnov (2018)**: "The Standard Model and Octonions" (arXiv:1804.05364)
- **Dubois-Violette & Todorov (2018)**: "Deducing the Standard Model from the Exceptional Jordan Algebra" (arXiv:1806.09450)
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

**Milestone gate**: Human semantic review of every quantum number assignment
against at least one textbook source (Peskin–Schroeder or Weinberg Vol. 2)
before merge.

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

**Status**: Advanced. Linear independence proved. Basis states matched to Furey's
particle table. Action table complete.

**Semantic review note**: The two Aristotle jobs described
`(-1/3) * (N1 + N2 + N3)` as hypercharge.  The formal eigenvalues match the
electric-charge convention already in `MinimalLeftIdeal.lean`, so the integrated
operator is named `Q_op`.  Conventional weak hypercharge remains a future task
requiring explicit weak-isospin and particle/antiparticle conventions.

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

### Milestone 8 — Multi-generational Unification (Expansion)
**Goal**: Formalize the Albert Algebra $\mathfrak{h}_3(\mathbb{O})$ and the Dixon Algebra $\mathbb{R} \otimes \mathbb{C} \otimes \mathbb{H} \otimes \mathbb{O}$.
**Motivation**: Move from one generation to three; derive the full $SU(3) \times SU(2) \times U(1)$ gauge group from division algebraic automorphisms.
**Strategy**: Use the doubling construction from Milestone 2 to define the Jordan product on $3 \times 3$ octonionic matrices.

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

---

## Immediate next actions

1. **Formalize the SM Gauge Operators** — prove that the bilinears in ladder
   operators satisfy the SU(3) x SU(2) x U(1) Lie algebra relations when acting
   on the submodule J.

2. **Cayley-Dickson Doubling** — formalize Milestone 2 to provide the path
   to the Albert Algebra (Milestone 8) and three generations.

4. **PhysLean audit** — use `scholarly` MCP to find recent PhysLean papers and
   check HEPLean/PhysLean for anything overlapping Milestones 1–5.

5. **ConventionBridge sign map** — extend `validate_octonion.py` to compare the
   project multiplication table against the Baez table and output the full sign
   correction vector. Then formalize it in `ConventionBridge.lean`.
