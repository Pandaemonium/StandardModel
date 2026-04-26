# North Star: PhysicsSM

## What this project is

PhysicsSM is a Lean 4 library whose goal is to produce **machine-verified proofs
of the mathematics underlying the Standard Model of particle physics**.

The target is not a simulation, not a symbolic computation, and not documentation.
It is formal mathematics: definitions and theorems accepted by the Lean kernel,
with every convention choice recorded and every source cited.

## Why it matters

The mathematics connecting division algebras, exceptional Lie theory, and the
Standard Model representation theory is deep, convention-laden, and scattered
across decades of literature. Results exist in papers, CAS scripts, and informal
notes, but nowhere as a single coherent verified codebase.

A formal library changes that. It makes every step checkable, every convention
explicit, and every claim traceable to a proof — not a calculation, not an
assertion, a proof. It also makes the structure navigable by AI agents in a way
that informal repositories are not.

## Core philosophy: mathematics first

This project is deliberately **mathematics-first**. Physics interpretation is
added only after the algebraic foundations are stable.

The ordering is:

```
division algebras (ℝ, ℂ, ℍ, 𝕆)
    ↓
octonion identities (alternativity, Moufang, norm multiplicativity)
    ↓
Clifford algebras and spinors
    ↓
exceptional Lie theory (G₂, F₄, E₆, E₇, E₈)
    ↓
gauge algebra and representation theory
    ↓
Standard Model quantum numbers and particle content
    ↓
Furey-style algebraic SM structure
    ↓
supersymmetry algebra
```

Each layer depends on the one above it being stable. Attempting to formalize
"the Standard Model" before octonion alternativity is proved is how projects
accumulate wrong foundations.

## What the Lean kernel guarantees — and what it does not

A theorem accepted by the Lean kernel is **formally correct given its stated
hypotheses and definitions**. The kernel does not check that:

- the definition matches the intended mathematical object,
- the conventions match the literature,
- the physics interpretation is correct.

Those checks are the responsibility of human mathematical review. Every
non-trivial definition and theorem therefore carries a source citation and a
convention declaration. A kernel-checked result with an unchecked convention
is not trusted.

## The agent pipeline

No single agent builds this library. The workflow is:

| Agent | Role |
|-------|------|
| Claude Code | Long-context coordination, code review, task preparation |
| Codex | Repository-wide scaffolding, refactors, import cleanup |
| Gemini | Paper ingestion, RAG over sources and notes |
| Aristotle | Targeted Lean theorem proving and proof repair |

Every agent output is provisional until `lake build` passes on the pinned
toolchain. The Lean kernel is the only verifier.

## What success looks like

A complete first version of the library would contain:

- The octonion algebra, fully proved: conjugation, norm, alternativity, Moufang.
- The Cayley–Dickson construction connecting ℝ → ℂ → ℍ → 𝕆.
- Clifford algebras and the four spinor types in (3+1) dimensions.
- The E₈ root system with rank, root count, and Cartan matrix determinant proved.
- The G₂ ↔ Aut(𝕆) connection stated as a theorem.
- The Standard Model gauge algebra SU(3) × SU(2) × U(1) with one generation
  of fermion representations and verified charge assignments.
- Furey-style ladder operators derived from the complexified octonion algebra,
  with nilpotency and anticommutation relations proved.
- A minimal supersymmetry algebra with the {Q, Q̄} = 2σP anticommutator as a
  typed formal interface.

Each item has a kernel-checked proof, a source citation, and a convention record.

## What this project is not

- It is not a physics simulator or numerical code.
- It is not a CAS wrapper.
- It is not a claim that the Standard Model is derivable from octonions. It is
  a formalization of the *mathematical structures* and *representation-theoretic
  results* that are relevant to that program.
- It is not a finished library. It is a long-horizon research project where
  every proved lemma is a durable contribution.
