/-!
# Docs.Roadmap

Formalization roadmap and open questions.

## Milestone 1 — Foundation (current)
- [x] Project skeleton and module structure
- [x] CI with no-s o r r y gate and doc generation
- [x] Prelude documenting available mathlib infrastructure
- [ ] Octonion type and multiplication table
- [ ] Conjugation involution
- [ ] Norm and norm multiplicativity

## Milestone 2 — Division algebra pass
- [ ] Cayley–Dickson construction
- [ ] Quaternion bridge to Mathlib
- [ ] Octonion alternativity
- [ ] Octonion Moufang identities
- [ ] Norm multiplicativity proof (kernel-checked, no s o r r y)

## Milestone 3 — Clifford and spinor pass
- [ ] Clifford algebra conventions wrapper
- [ ] Gamma matrices in Weyl and Dirac representations
- [ ] Even subalgebra and spinor types
- [ ] Weyl, Dirac, Majorana spinor definitions

## Milestone 4 — Exceptional Lie pass
- [ ] CartanType enumeration
- [ ] G₂ root data (using Mathlib.LinearAlgebra.RootSystem.Finite.G2)
- [ ] G₂ as Aut(𝕆) theorem statement
- [ ] E₈ root data: rank 8, 240 roots, Cartan determinant 1
- [ ] E₈ oracle cross-check (LieART + SageMath)

## Milestone 5 — Standard Model pass
- [ ] Gauge algebra assembly SU(3)×SU(2)×U(1)
- [ ] Quantum numbers and electric charge formula
- [ ] One-generation fermion representation table
- [ ] Anomaly cancellation checks

## Milestone 6 — Furey / division algebra SM pass
- [ ] Ladder operators over complexified octonions
- [ ] Nilpotency and anticommutation relations
- [ ] Recovery of SM quantum numbers from division algebra structure
- Source: Furey, "Standard model physics from an algebra?", PhD thesis (2015)
          and subsequent papers.

## Milestone 7 — SUSY scaffold
- [ ] Super vector spaces
- [ ] Super Lie algebra definition and Jacobi identity
- [ ] SUSY anticommutator {Q, Q̄} = 2σP
- [ ] Division-algebra/SUSY dimension ladder (Baez–Huerta)

## Open questions

1. How much of the octonion infrastructure can be pulled from Physlib/HEPLean?
   → Check HEPLean/PhysLean on GitHub for current state before implementing.

2. Should E₈ root data be built from the Mathlib root system framework or
   from an explicit matrix description?
   → Prefer Mathlib framework for composability; use explicit data as oracle check.

3. Which hypercharge convention should be canonical?
   → Decision: Q = T₃ + Y/2 (Weinberg convention). Recorded in Glossary.

4. Is there a clean Lean 4 formalization of the Fano plane that we can import?
   → Search mathlib and arXiv before implementing from scratch.

5. What is the best way to interface with Aristotle for hard proofs?
   → Use task files in AgentTasks/ with the format specified in AGENTS.md.
-/

namespace PhysicsSM.Docs.Roadmap

end PhysicsSM.Docs.Roadmap
