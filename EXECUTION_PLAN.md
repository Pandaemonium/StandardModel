# Execution Plan: PhysicsSM

## Current state (2026-04-26)

**Infrastructure complete.** The project has:

- Lean 4 `v4.30.0-rc2`, mathlib4 `v4.30.0-rc2`, full pre-built cache downloaded.
- 35 stub modules across all planned areas, compiling cleanly with zero `sorry`.
- GitHub Actions CI: `lake build` + no-sorry gate on trusted dirs + `docgen-action`.
- Pre-commit hooks: UTF-8/LF/final-newline hygiene enforced on every commit.
- MCP servers active: `scholarly` (OpenAlex/Semantic Scholar), `zotero_write`,
  `neo4j_graph`.
- Aristotle API key active and tested.
- Octonion XOR convention locked and validated (Fano + 512 Moufang checks).
- `ConventionBridge` stub isolating project convention from Baez/Furey.

**Nothing proved yet.** All Lean modules are documented stubs.

---

## Design decisions already made

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Project philosophy | Mathematics-first | Algebra foundations must be stable before physics interpretation |
| Lean toolchain | `v4.30.0-rc2` (pinned) | Reproducibility; update deliberately |
| Primary dependency | mathlib4 (Apache-2.0) | Largest verified algebra library; same kernel |
| Octonion basis | XOR binary labels `e000`–`e111` | Computationally clean; XOR gives product index |
| Fano orientation | Anchored by `e011*e111=e100` | User-specified; validated against Moufang |
| Baez/Furey translation | Via `ConventionBridge` only | Prevents silent sign errors |
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
| `Norm.lean` | `normSq`, `norm` | `normSq_nonneg`, `normSq_eq_zero`, `normSq_mul` |
| `Alternativity.lean` | Alternative laws | `left_alternative`, `right_alternative` |
| `Moufang.lean` | Moufang identities | `moufang_left`, `moufang_right`, `moufang_middle` |

**Strategy**: Define `Octonion` as `Fin 8 → ℝ` with multiplication given by the
sign table from `validate_octonion.py`. Prove identities by component expansion
or by appeals to alternativity. Use Aristotle for `normSq_mul` and the Moufang
proofs — these are the hardest.

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
| `Exceptional/G2.lean` | G₂ root data; `Aut(𝕆) ≅ G₂` theorem statement |
| `Exceptional/E8.lean` | E₈ root data; rank 8; 240 roots; det(Cartan) = 1 |

**Oracle protocol**: Every E₈ combinatorial claim must be cross-checked against
at least two of: LieART, SageMath `RootSystem(['E',8])`, OSCAR.jl.

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
| `StandardModel/Fermions.lean` | One-generation fermion rep table |
| `StandardModel/Representations.lean` | Anomaly cancellation checks |

**Key theorems**: Electric charge of W± is ±1; anomaly cancellation conditions
`Σ Y³ = 0`, `Σ T₃² Y = 0` satisfied for one generation.

**Milestone gate**: Human semantic review of every quantum number assignment
against at least one textbook source (Peskin–Schroeder or Weinberg Vol. 2)
before merge.

---

### Milestone 6 — Furey-style algebraic SM structure
**Goal**: Ladder operators derived from the complexified octonion algebra; key
representation-theoretic facts about the SM particle content recovered from
algebraic structure.

**Prerequisites**: Milestones 1, 2, 5 complete; `ConventionBridge` fully worked out.

**Primary source**: Furey (2015) PhD thesis + follow-on papers. Paper-first
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

6. **Aristotle job management**: As the project grows, structured AgentTask
   files become essential. Establish the `AgentTasks/` filing convention before
   running the first real Aristotle job.

---

## Immediate next actions

1. **Write the first Aristotle task file** — `AgentTasks/octonion-basic.md` for
   the `Octonion` structure definition (Milestone 1 entry point).

2. **Initialize Neo4j schema** — write the Cypher initialization script for the
   knowledge graph node and edge types.

3. **PhysLean audit** — use `scholarly` MCP to find recent PhysLean papers and
   check HEPLean/PhysLean for anything overlapping Milestones 1–5.

4. **ConventionBridge sign map** — extend `validate_octonion.py` to compare the
   project multiplication table against the Baez table and output the full sign
   correction vector. Then formalize it in `ConventionBridge.lean`.

5. **Run the first Aristotle job** — `Octonion.normSq_mul` is the natural first
   target: well-defined statement, nontrivial proof, good calibration benchmark.
