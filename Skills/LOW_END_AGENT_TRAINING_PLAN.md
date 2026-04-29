# Low-End Agent Training Plan

This document is a curriculum and documentation plan for using lower-capability
models on the PhysicsSM Lean project. It assumes the reader is unfamiliar with
the mathematics, unfamiliar with Lean, and likely to make mistakes if a task is
underspecified.

The goal is not to turn every model into a mathematician. The goal is to make
small, safe tasks possible by giving agents:

- a clear learning order,
- basic mathematical vocabulary,
- Lean-reading and Lean-writing habits,
- task boundaries,
- examples of safe work,
- examples of work that must be escalated to a stronger model or Aristotle.

The Lean kernel remains the source of truth. A low-end model may draft, search,
summarize, annotate, or perform simple coordinate proofs, but it must not make
semantic decisions about conventions, weaken theorem statements, or claim a
proof is complete without running the relevant Lean check.

## Intended Use

Use this plan in three ways:

1. As an onboarding path for low-end models.
2. As a checklist for writing future tutorial files under `Skills/`.
3. As a delegation guide for deciding which tasks are safe to give to weaker
   agents.

The recommended pattern is:

1. Give the model one tutorial file or section.
2. Give it one narrow task.
3. Require it to name the files it read.
4. Require it to explain the theorem statement in plain English.
5. Require it to run the smallest Lean check if it edits Lean.
6. Review its output before merging.

## Safety Rules For Low-End Agents

Low-end agents should repeat these rules before starting a task:

- The Lean kernel proves formal statements, not informal intent.
- Never change a convention silently.
- Never introduce `axiom`, `opaque`, `unsafe def`, `admit`, or trusted `sorry`.
- Never weaken a theorem statement to make a proof easier.
- Never assume octonion multiplication is associative.
- Never copy GPL, LGPL, AGPL, or unclear-license code into trusted Lean source.
- Never claim a source supports a theorem unless the statement and convention
  have been checked.
- Never claim a command passed unless it was actually run.
- Prefer small edits and targeted checks.
- If a proof stalls, record a handoff note instead of churning.

Safe low-end tasks usually involve:

- reading and summarizing local files,
- adding docstrings or comments,
- creating task files from a template,
- writing source metadata,
- adding coordinate projection simp lemmas,
- proving simple coordinate equalities with `ext`, `simp`, `norm_num`, or `ring`,
- running targeted Lean checks,
- comparing Aristotle output against existing files.

Unsafe low-end tasks include:

- designing new mathematical definitions,
- choosing signs, bases, normalizations, or representation conventions,
- proving hard abstract algebra statements,
- translating physics claims from a paper without a convention bridge,
- refactoring shared algebra APIs,
- editing trusted code that already has delicate proofs,
- resolving conflicting source conventions,
- adding new dependencies.

## Curriculum Overview

The curriculum is divided into levels. Each level should become one or more
tutorial files in `Skills/`. A low-end model should not skip levels unless the
task is purely mechanical.

| Level | Theme | Main outcome |
|------:|-------|--------------|
| 0 | Repository survival | Can inspect files, follow hygiene rules, and run checks. |
| 1 | Lean basics | Can read definitions, theorems, namespaces, imports, and errors. |
| 2 | Proof basics | Can use simple tactics and understand proof states. |
| 3 | Mathematical language | Can recognize sets, functions, structures, algebra, and linear algebra. |
| 4 | Project octonions | Understands coordinates, XOR basis, nonassociativity, conjugation, norm. |
| 5 | Complex octonions and Furey layer | Understands pair representation, ladder operators, and finite arithmetic. |
| 6 | Source and convention discipline | Can record provenance and avoid sign/normalization mistakes. |
| 7 | Linear algebra packaging | Can help package spans, submodules, bases, and finite coordinate maps. |
| 8 | Clifford, spinor, and gauge basics | Can read task files in these areas without inventing physics. |
| 9 | Lie theory and exceptional structures | Can prepare data and summaries, but escalates hard proofs. |
| 10 | Oracle and CAS workflows | Can run and document validators without treating them as proofs. |
| 11 | Aristotle handoff skills | Can prepare focused proof tasks for Aristotle. |

## Planned Tutorial Files

Create these files incrementally. The order matters.

### Level 0: Repository Survival

Planned file: `Skills/00_REPOSITORY_SURVIVAL.md`

Teach:

- What this repository is trying to prove.
- Why `AGENTS.md` is mandatory reading.
- Trusted code vs draft code.
- Where files live: `PhysicsSM/`, `AgentTasks/`, `Sources/`, `Scripts/`,
  `Index/`, `Skills/`.
- How to inspect with `rg`, `Get-Content`, and `git status`.
- How to avoid overwriting user changes.
- How to preserve UTF-8, LF endings, final newline, and no trailing whitespace.
- How to run a targeted Lean check on Windows:

```powershell
$env:ELAN_HOME='c:\Projects\StandardModel\.elan_sandbox'
$env:PATH="$env:ELAN_HOME\bin;$env:PATH"
lake env lean PhysicsSM\Path\To\File.lean
```

- Why `lake build <module>` can hit the Windows ProofWidgets issue.
- How to report commands run.

Practice tasks:

- List files under `PhysicsSM/Algebra/Octonion`.
- Find all declarations named `normSq`.
- Explain why `AgentTasks/` files are not trusted proofs.
- Run `lake env lean` on one file without editing it.

### Level 1: Lean Reading Basics

Planned file: `Skills/01_LEAN_READING_BASICS.md`

Teach:

- What a Lean file contains.
- `import`, `namespace`, `def`, `theorem`, `lemma`, `example`.
- Term syntax vs tactic syntax.
- The meaning of `:` in declarations.
- The meaning of `:=`.
- The difference between a type and a term.
- How to read:

```lean
theorem conj_conj (x : Octonion) : conj (conj x) = x := by
  ext <;> simp [conj]
```

Plain-English reading:

- `conj_conj` is the theorem name.
- `x : Octonion` means `x` is an arbitrary octonion.
- The statement after the second colon is the proposition to prove.
- `:= by` starts a tactic proof.
- `ext` reduces equality of octonions to equality of coordinates.
- `simp [conj]` unfolds conjugation and simplifies real arithmetic.

Practice tasks:

- Pick five theorems and translate their statements into plain English.
- Identify every import used by a file.
- Explain what namespace a theorem lives in.
- Find the exact theorem name needed for a downstream import.

### Level 2: Lean Writing Basics

Planned file: `Skills/02_LEAN_WRITING_BASICS.md`

Teach:

- How to add a docstring.
- How to add a small definition.
- How to add a theorem with a simple proof.
- How to write a local `have`.
- How to use `rfl`.
- How to use `by`.
- How to use `simp`, `rw`, `change`, `ext`, `norm_num`, `ring`, `nlinarith`,
  and `positivity`.
- How to avoid broad imports.
- How to write readable theorem names.

Safe proof patterns:

```lean
theorem zero_add_example (x : SomeType) : 0 + x = x := by
  simp
```

```lean
theorem coordinate_example (x y : Octonion) :
    (x + y).c0 = x.c0 + y.c0 := by
  rfl
```

```lean
theorem octonion_ext_example (x : Octonion) : x + 0 = x := by
  ext <;> simp
```

Practice tasks:

- Add a harmless example theorem in a draft file.
- Prove a component projection lemma.
- Repair a proof that fails because a definition needs to be unfolded.
- Explain why a proof using `ring` is only valid after the goal is a real
  polynomial equality.

### Level 3: Reading Lean Errors

Planned file: `Skills/03_READING_LEAN_ERRORS.md`

Teach:

- How to read line and column numbers.
- Unknown identifier.
- Type mismatch.
- Failed to synthesize instance.
- Tactic failed.
- Goals after an incomplete proof.
- Missing imports.
- Stale `.olean` files.
- Windows ProofWidgets failures.

Response pattern:

1. Quote the exact error.
2. Name the file and line.
3. Say whether it is syntax, import, typeclass, theorem statement, or proof.
4. Try one focused fix.
5. Run the targeted check again.

Practice tasks:

- Given an error log, classify the error.
- Find the missing import.
- Explain why `simp` did not close a goal.
- Turn a failed proof into a useful handoff note.

### Level 4: Basic Mathematical Language

Planned file: `Skills/04_MATH_LANGUAGE_PRIMER.md`

Teach:

- Variables, functions, and equality.
- Implication, iff, forall, exists.
- Sets, membership, subsets.
- Structures and operations.
- Closure, identity, inverse.
- Associative, commutative, distributive.
- Rings, fields, modules, vector spaces.
- Basis, span, linear independence.
- Matrices as coordinate bookkeeping.

Important translation table:

| Math phrase | Lean shape |
|-------------|------------|
| for all x | `(x : A)` or a universal quantifier statement |
| there exists x | an existential statement |
| if P then Q | `P -> Q` |
| P iff Q | `P <-> Q` in ASCII explanation, often printed with an iff symbol |
| x is in S | membership statement |
| f maps x to y | `f x = y` |
| vectors are linearly independent | `LinearIndependent K v` |

Practice tasks:

- Translate theorem statements from English to Lean-shaped pseudocode.
- Identify hypotheses and conclusions.
- Explain why a theorem about groups is not automatically a theorem about Lie
  algebras.

### Level 5: Project Octonion Primer

Planned file: `Skills/05_OCTONION_PRIMER.md`

Teach:

- Octonions are eight-dimensional over `R`.
- The basis is `e000`, `e001`, ..., `e111`.
- `e000` is the unit.
- Imaginary basis elements square to `-e000`.
- The project uses XOR labels for product indices.
- The sign comes from the Fano orientation in `Basic.lean`.
- Octonions are not associative.
- Parentheses are part of the theorem statement.
- Conjugation negates imaginary coordinates.
- `normSq` is the sum of eight coordinate squares.
- Moufang identities replace some uses of associativity.

Core warning:

Do not rewrite `(x * y) * z` to `x * (y * z)` unless a theorem explicitly
allows that exact reassociation.

Files to study:

- `PhysicsSM/Algebra/Octonion/Basic.lean`
- `PhysicsSM/Algebra/Octonion/Conjugation.lean`
- `PhysicsSM/Algebra/Octonion/Norm.lean`
- `PhysicsSM/Algebra/Octonion/Alternativity.lean`
- `PhysicsSM/Algebra/Octonion/Moufang.lean`
- `Scripts/oracle/validate_octonion.py`

Practice tasks:

- Explain the product index rule for basis elements.
- Find the anchor product `e011 * e111 = e100`.
- Prove a simple coordinate identity with `ext <;> simp`.
- Explain why `ring` can prove `normSq_mul` only after multiplication is
  expanded to real coordinates.

### Level 6: ConventionBridge Primer

Planned file: `Skills/06_CONVENTION_BRIDGE_PRIMER.md`

Teach:

- Sources may use different octonion basis labels.
- Baez and Furey formulas must not be copied directly.
- The project XOR convention is authoritative.
- `ConventionBridge` records relabeling and signs.
- Every imported formula needs a source convention and project convention.

Safe task types:

- Record source convention notes.
- Compare source notation with project notation.
- Add comments pointing to `ConventionBridge`.

Unsafe task types:

- Invent a sign correction.
- Move a formula from source to trusted Lean without validation.
- Change basis order to make a proof easier.

Practice tasks:

- Read a source formula and identify every basis symbol.
- Write a provenance note.
- Explain why a formula involving `e7` must name the project basis element it
  maps to.

### Level 7: Complex Octonions And Furey Layer

Planned file: `Skills/07_COMPLEX_OCTONION_FUREY_PRIMER.md`

Teach:

- `ComplexOctonion` is represented as a pair of real octonions: real part and
  imaginary part.
- Multiplication is complexified multiplication, not a new arbitrary product.
- Furey ladder operators are explicit elements of `C tensor O`.
- Nilpotency and anticommutation are finite coordinate facts in this project.
- The minimal left ideal file contains explicit states and action-table facts.
- Physical names like electron or neutrino require semantic review; Lean only
  checks the algebraic equations.

Files to study:

- `PhysicsSM/Algebra/Octonion/ComplexOctonion.lean`
- `PhysicsSM/Algebra/Furey/LadderOperators.lean`
- `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`
- `AgentTasks/furey-minimal-ideal-moonshot.md`
- `Sources/README.md`

Practice tasks:

- Explain `ComplexOctonion` as `re + i im`.
- Find the definition of `alpha1`.
- Translate an action-table theorem into plain English.
- Add a comment explaining why a theorem is finite coordinate arithmetic.

### Level 8: Linear Algebra Packaging

Planned file: `Skills/08_LINEAR_ALGEBRA_PACKAGING.md`

Teach:

- Vector spaces and modules.
- Scalars: `R` vs `C`.
- Linear maps.
- Span and submodule.
- Basis and linear independence.
- Coordinate maps.
- Why explicit finite coordinates can justify linear independence.

Relevant Lean concepts:

- `Module`
- `Submodule`
- `LinearMap`
- `LinearIndependent`
- `Basis`
- `Fin n`
- finite sums

Low-end safe work:

- Find existing definitions and theorem names.
- Write documentation for the intended packaging.
- Prepare a task file for a stronger agent.
- Prove simple coordinate lemmas needed by a basis proof.

Escalate:

- New `Basis` construction.
- Typeclass-heavy module instances.
- Hard finite-sum proofs.

Practice tasks:

- Explain the statement of `basis_linear_independent`.
- Identify the scalar field in a theorem.
- Write a draft task for packaging the minimal ideal as a submodule.

### Level 9: Clifford And Spinor Basics

Planned file: `Skills/09_CLIFFORD_SPINOR_PRIMER.md`

Teach:

- Quadratic forms.
- Clifford algebra as generated by vectors with relation `v * v = Q v`.
- Even and odd parts.
- Spin group as units in the Clifford algebra satisfying conditions.
- Spinors as modules for Clifford algebras.
- Gamma matrices as concrete representations.
- Chirality and handedness are conventions.

Low-end safe work:

- Source summaries.
- Convention tables.
- File maps.
- Basic theorem-statement reading.

Escalate:

- Any new Clifford algebra construction.
- Gamma matrix sign choices.
- Chirality convention decisions.

Practice tasks:

- Identify the metric signature in a source.
- Explain what a gamma matrix identity says.
- Write a provenance note for a Clifford convention.

### Level 10: Standard Model Physics Primer

Planned file: `Skills/10_STANDARD_MODEL_PRIMER.md`

Teach:

- Gauge group: `SU(3) x SU(2) x U(1)`.
- Color, weak isospin, hypercharge.
- Electric charge convention `Q = T3 + Y/2`.
- Fermion generations.
- Particles vs antiparticles.
- Representations and conjugate representations.
- Anomaly cancellation as a representation-theoretic check.

Low-end safe work:

- Build tables from source metadata.
- Check that a file states its convention.
- Compare names in code to names in source notes.

Escalate:

- Hypercharge normalization decisions.
- Particle identification from algebraic states.
- Any theorem claiming physical interpretation.

Practice tasks:

- Read a table and identify scalar fields, representations, and charge
  conventions.
- Write a source note for a particle table.
- Explain why charge normalization must be documented.

### Level 11: Lie Theory And Exceptional Structures

Planned file: `Skills/11_LIE_EXCEPTIONAL_PRIMER.md`

Teach:

- Groups vs Lie algebras.
- Bracket operation.
- Representation.
- Cartan subalgebra.
- Roots and weights.
- Dynkin diagrams.
- G2 as related to octonion automorphisms.
- E8 as a large exceptional root system.
- Why root counts and Cartan matrices need oracle checks.

Low-end safe work:

- Source summaries.
- Fixture documentation.
- Root-data table transcription with review.
- Comparing oracle outputs.

Escalate:

- New root-system formalizations.
- Branching rules.
- E8 theorem statements.
- Any proof using sophisticated mathlib root-system APIs.

Practice tasks:

- Explain the difference between a group representation and Lie algebra
  representation.
- Find a Cartan matrix source and record its basis order.
- Write an oracle fixture metadata block.

### Level 12: Supersymmetry Primer

Planned file: `Skills/12_SUPERSYMMETRY_PRIMER.md`

Teach:

- Z/2-graded vector spaces.
- Even and odd elements.
- Supercommutator signs.
- Super Lie algebra.
- SUSY algebra anticommutators.
- Why metric signature and spinor convention matter.

Low-end safe work:

- Glossary writing.
- Source metadata.
- Reading theorem statements.

Escalate:

- Super sign rules.
- Spinor representation choices.
- Any theorem involving physical dimension or signature.

Practice tasks:

- Write a convention checklist for a SUSY file.
- Explain why signs depend on parity.

### Level 13: Sources, Provenance, And Licensing

Planned file: `Skills/13_SOURCES_PROVENANCE_LICENSING.md`

Teach:

- What counts as provenance.
- How to write source notes.
- Difference between a specification source, oracle source, and implementation
  source.
- License categories.
- Why GPL-family code cannot be copied into trusted Lean source.
- How to cite Aristotle results.
- How to cite CAS outputs.

Practice tasks:

- Add a source metadata entry.
- Write a convention note for a theorem.
- Classify a source by role and license.

### Level 14: Oracle And CAS Workflow

Planned file: `Skills/14_ORACLE_AND_CAS_WORKFLOW.md`

Teach:

- CAS output is evidence, not proof.
- Oracles can validate multiplication tables, root counts, branching rules, and
  matrix identities.
- Required metadata: tool, version, command, input convention, output format,
  license, CI status.
- How Lean-side executable definitions can be compared against fixtures.

Practice tasks:

- Run a validator script.
- Record output.
- Add a fixture metadata block.
- Explain why the fixture does not prove a trusted theorem.

### Level 15: Aristotle Handoff Preparation

Planned file: `Skills/15_ARISTOTLE_HANDOFFS.md`

Teach:

- When to use Aristotle.
- How to prepare a minimal focused theorem.
- How to include imports, namespace, local lemmas, and failed attempts.
- How to phrase convention constraints.
- How to download and extract results.
- How to review Aristotle output before merging.

Practice tasks:

- Write a task file from a failed theorem.
- Extract an Aristotle result and summarize changed files.
- Compare Aristotle output against current repo code.

## Delegation Matrix

Use this matrix when assigning tasks to weaker models.

| Task | Low-end model | Strong model | Aristotle |
|------|---------------|--------------|-----------|
| Summarize a local file | Good | Good | Not needed |
| Add docstrings | Good with review | Good | Not needed |
| Create source metadata | Good with review | Good | Not needed |
| Run targeted Lean checks | Good | Good | Not needed |
| Simple coordinate simp proof | Sometimes | Good | Sometimes |
| `ring` proof after full expansion | Sometimes | Good | Sometimes |
| Typeclass-heavy module work | No | Good | Sometimes |
| New theorem statement from paper | No | Good | Maybe after prep |
| Convention/sign decision | No | Strong review required | No |
| Hard Lean proof search | No | Prepare handoff | Good |
| Physics interpretation | No | Strong review required | No |
| E8/root-system theorem | No | Strong review required | Maybe |

## Standard Low-End Agent Task Template

Use this template when assigning a task.

```markdown
# Task

You are a low-end assistant working in the PhysicsSM Lean repository.

## Read first

- `AGENTS.md`
- `<specific tutorial file>`
- `<specific target file>`

## Goal

<One narrow goal.>

## Allowed files

- `<file 1>`
- `<file 2>`

## Not allowed

- Do not edit any other file.
- Do not introduce `axiom`, `opaque`, `unsafe def`, `admit`, or trusted `sorry`.
- Do not change theorem statements unless explicitly asked.
- Do not change conventions.

## Verification

Run:

```powershell
lake env lean <target-file>
```

## Final report

Report:

- Files read.
- Files changed.
- Plain-English meaning of any theorem touched.
- Commands run.
- Any remaining errors.
```

## Standard Handoff Note Template

Use this when a low-end model gets stuck.

```text
Handoff:
- Target file:
- Target declaration:
- Intended statement:
- Current Lean error:
- What I tried:
- Why I stopped:
- Suspected missing lemma or import:
- Convention concerns:
- Recommended next step:
```

## Skill Dependencies

The following dependency graph should guide tutorial ordering:

```text
00 repository survival
  -> 01 Lean reading
  -> 02 Lean writing
  -> 03 Lean errors
  -> 04 math language
      -> 05 octonions
          -> 06 ConventionBridge
          -> 07 complex octonions and Furey
              -> 08 linear algebra packaging
      -> 09 Clifford and spinors
          -> 12 supersymmetry
      -> 10 Standard Model
      -> 11 Lie and exceptional structures
  -> 13 sources and licensing
  -> 14 oracle workflow
  -> 15 Aristotle handoffs
```

## First Batch Of Documents To Write

Write these first because they unlock safe delegation quickly:

1. `Skills/00_REPOSITORY_SURVIVAL.md`
2. `Skills/01_LEAN_READING_BASICS.md`
3. `Skills/02_LEAN_WRITING_BASICS.md`
4. `Skills/03_READING_LEAN_ERRORS.md`
5. `Skills/05_OCTONION_PRIMER.md`
6. `Skills/13_SOURCES_PROVENANCE_LICENSING.md`
7. `Skills/15_ARISTOTLE_HANDOFFS.md`

Each tutorial should include:

- a one-paragraph purpose,
- prerequisites,
- key vocabulary,
- local files to read,
- examples from this repository,
- safe tasks,
- unsafe tasks,
- practice exercises,
- a final checklist.

## Second Batch Of Documents To Write

Write these after low-end agents can safely read Lean and understand the
octonion core:

1. `Skills/04_MATH_LANGUAGE_PRIMER.md`
2. `Skills/06_CONVENTION_BRIDGE_PRIMER.md`
3. `Skills/07_COMPLEX_OCTONION_FUREY_PRIMER.md`
4. `Skills/08_LINEAR_ALGEBRA_PACKAGING.md`
5. `Skills/14_ORACLE_AND_CAS_WORKFLOW.md`

## Third Batch Of Documents To Write

Write these before delegating physics-facing or advanced algebra tasks:

1. `Skills/09_CLIFFORD_SPINOR_PRIMER.md`
2. `Skills/10_STANDARD_MODEL_PRIMER.md`
3. `Skills/11_LIE_EXCEPTIONAL_PRIMER.md`
4. `Skills/12_SUPERSYMMETRY_PRIMER.md`

## Example Low-End Assignments

Good first assignments:

- Read `PhysicsSM/Algebra/Octonion/Conjugation.lean` and summarize each theorem
  in one sentence.
- Add a source note to a task file, without touching Lean code.
- Find all uses of `normSq_mul` and report them.
- Explain why `moufang_left` has its exact parentheses.
- Run `lake env lean PhysicsSM/Algebra/Octonion/Norm.lean` and report whether
  it passes.

Good second assignments:

- Add verbose comments to a draft file.
- Create an `AgentTasks/` file for a focused theorem.
- Add a simple coordinate projection lemma in a draft or trusted file after a
  stronger model approves the statement.
- Compare two Aristotle summaries and report overlapping theorem names.

Bad assignments:

- "Formalize this paper."
- "Make the proof pass however you can."
- "Fix all errors in this directory."
- "Choose the right hypercharge convention."
- "Port the Furey formulas."
- "Prove E8 root count."

## Minimal Mathematical Glossary

Use this glossary in future tutorials.

- Algebra: a set or type with operations such as addition and multiplication.
- Associative: parentheses do not matter, e.g. `(x * y) * z = x * (y * z)`.
- Basis: a list of vectors that uniquely describes every vector by coordinates.
- Bilinear: linear in each of two inputs separately.
- Clifford algebra: an algebra generated by vectors with relations from a
  quadratic form.
- Coordinate proof: a proof that expands a structured equality into scalar
  coordinate equalities.
- Field: a number system with addition, subtraction, multiplication, and
  division by nonzero elements.
- Fano plane: a seven-point incidence diagram encoding octonion multiplication
  signs.
- Ideal: a subspace stable under multiplication by elements from one or both
  sides, depending on the definition.
- Linear independent: no nontrivial linear combination gives zero.
- Module: a vector-space-like object where scalars come from a ring.
- Moufang identity: an identity that holds in octonions despite
  nonassociativity.
- Norm: a size function; in this project `normSq` is the squared Euclidean norm.
- Octonion: an eight-dimensional real algebra that is nonassociative but
  alternative and normed.
- Representation: a way for an algebra or group to act on a vector space.
- Ring tactic: a Lean tactic that proves polynomial identities in commutative
  semirings/rings after expressions have been reduced to that setting.
- Scalar: a coefficient from a base number system such as `R` or `C`.
- Span: all linear combinations of a collection of vectors.
- Theorem statement: the exact formal proposition Lean checks.
- Typeclass: Lean's mechanism for finding structure such as addition,
  multiplication, modules, and rings.

## Lean Mini-Primer For Agents

### What To Read First In A Lean File

1. Imports.
2. Module docstring.
3. Namespace.
4. Definitions.
5. Theorem statements.
6. Proof scripts.
7. End namespace.

### Common Lean Shapes

Definition:

```lean
def normSq (x : Octonion) : R := ...
```

Theorem:

```lean
theorem normSq_one : normSq (1 : Octonion) = 1 := by
  simp [normSq]
```

Universal statement:

```lean
theorem conj_conj (x : Octonion) : conj (conj x) = x := by
  ...
```

Local fact:

```lean
have h0 : x.c0 = 0 := by
  nlinarith
```

Extensionality:

```lean
ext <;> simp
```

This usually means:

- split an equality of structures into coordinate equalities,
- run `simp` on every resulting coordinate goal.

### Common Tactics

- `rfl`: close a goal true by definition.
- `simp`: simplify using rewrite rules and definitions.
- `simp [foo]`: simplify and unfold `foo`.
- `rw [h]`: rewrite using theorem or hypothesis `h`.
- `ext`: prove structure equality by proving field equality.
- `norm_num`: solve numeric goals.
- `ring`: solve polynomial identities in commutative rings.
- `nlinarith`: solve nonlinear arithmetic inequalities/equalities over ordered
  rings/fields.
- `positivity`: prove nonnegativity or positivity goals.

### When A Tactic Is Suspicious

Be careful if:

- `simp` changes a theorem in an unexpected direction.
- `ring` is used before octonion multiplication is expanded to real
  coordinates.
- a proof uses associativity-like rewriting on octonions.
- a theorem passes only after hypotheses are removed or weakened.
- a proof requires adding an axiom.

## Review Checklist For Low-End Agent Output

A reviewer should check:

- Did the agent read the required files?
- Did it edit only allowed files?
- Did it preserve conventions?
- Did it preserve theorem statements?
- Are comments accurate and not overclaiming?
- Is every source claim backed by a source note?
- Did it avoid forbidden tokens in trusted Lean code?
- Did it run the requested command?
- Did it report command failures honestly?
- Does the Lean statement match the intended math?

## Long-Term Documentation Goal

The mature `Skills/` directory should become a training library for agents. A
future low-end model should be able to:

1. Read `00_REPOSITORY_SURVIVAL.md`.
2. Read the topic primer for its task.
3. Work from a narrow `AgentTasks/` file.
4. Produce a small, reviewable patch.
5. Stop with a useful handoff note when the task becomes mathematical proof
   search.

This is how we make weaker agents useful without letting them turn convention
mistakes into trusted theorems.
