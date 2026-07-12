# Aristotle semantic context pack

Generated: 2026-07-12T08:10:29
Query: `second quantization finite range unitary CAR support causal cone pairwise disjoint local quartic gate layer composition`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md` [2a. Related work: where this sits, and what is new]

Score: `0.794`

```text
| Connes–Chamseddine (NCG-SM) | fin. internal | Euclidean | ✓ (KO-6) | — | — | — |
| Foster–Jacobson (4D checkerboard) | ✓ | — | ✓ | — | — | — |
| QCA / quantum-walk Dirac | ✓ | — | ✓ | — | — | — |
| Finster (causal fermion systems) | ✓ | Lorentzian | — | variational | — | — |
| HepLean / PhysLean | ✓ | — | — | — | — | ✓ (formalized) |

The novelty is the bottom-right block read together — a finite *Krein* carrier
whose square is a four-channel budget *answering to the kernel-checked Plücker
mass*, under a pre-registered kill-discipline — not any single ✓.

---
```

### 2. `Sources/Underexplored_Angles_Lit_Review.md` [3. Quantum Cellular Automata (QCA) / Quantum Walks as the Dynamics Layer]

Score: `0.793`

```text
## 3. Quantum Cellular Automata (QCA) / Quantum Walks as the Dynamics Layer
The COG idea needs a local tick rule. Quantum cellular automata and discrete-time quantum walks are close cousins: local, discrete-space/discrete-time update rules that can approximate relativistic particles. Recent work directly studies fermion doubling in QCA/quantum-walk models and how it relates to Nielsen–Ninomiya-style constraints.

* **Why it matters:** This provides an existing mathematical language for "Planck-tick local evolution" without immediately reinventing all of lattice QFT. It also highlights known traps: locality, unitarity, Lorentz recovery, and fermion doubling.
* **Concrete experiment:** Implement a tiny QCA-like COG rule for a 1D or 2D Dirac particle, then ask whether adding octonionic internal state labels naturally creates generations, doublers, or gauge-like phases.
* **Reference:** [Fermion Doubling in Quantum Cellular Automaton Models (arXiv:2505.07900)](https://arxiv.org/abs/2505.07900)
```

### 3. `FUTURE_DIRECTIONS.md` [Concrete experiment]

Score: `0.792`

```text
### Concrete experiment

Build the simplest possible "octonionic QCA":
1. Take a 1D lattice with 8-state nodes (corresponding to the 8 basis states
   of J: omega, v1, v2, v3, v4, v5, v6, nu).
2. Use the colour operator `T12_op` as the "hop" rule: a node in state v2 hops
   to state v1 (from the action table `T12_op v2 = v1`).
3. Verify unitarity (the full hop/no-hop superposition should preserve norm).
4. Ask: does the resulting dynamics in the thermodynamic limit look like a Dirac
   equation on the colour-singlet sector?

This is a computational experiment, not a Lean target. But confirming or
refuting it would decide whether QCA is a useful language for this project.
```

### 4. `AgentTasks/null-edge-qubit-concurrence-aristotle-2026-06-21.md` [Aristotle task: qubit concurrence wrapper]

Score: `0.789`

```text
# Aristotle task: qubit concurrence wrapper

Date: 2026-06-21
```

### 5. `AgentTasks/null-edge-codex-overnight-run-ledger-2026-06-23.md` [Literature cadence: P4 null-step/QCA frontier]

Score: `0.787`

```text
## Literature cadence: P4 null-step/QCA frontier

Ran a P4 literature pass after integrating the six-job tranche. Semantic
Scholar was rate-limited, so the search used arXiv/OpenAlex/Crossref and exact
Zotero/Neo4j duplicate checks.

Added to Zotero and linked in Neo4j to
`null-edge-p2p4-null-step-qw-dirac-bridge`:

- `964TN6X7`: Terry Farrelly, *A review of Quantum Cellular Automata*,
  Quantum 4, 368 (2020), DOI `10.22331/q-2020-11-30-368`.
  Role: broad QCA prior-art guardrail for locality, bounded-speed unitary
  dynamics, continuum limits, and classification context.
- `VIAIBSRI`: Nathanael Eon, Giuseppe Di Molfetta, Giuseppe Magnifico, Pablo
  Arrighi, *A relativistic discrete spacetime formulation of 3+1 QED*,
  Quantum 7, 1179 (2023), DOI `10.22331/q-2023-11-08-1179`.
  Role: high-relevance P4 source because it uses lightlike circuit wires,
  starts from the Dirac quantum walk, and extends to gauge-invariant
  multi-particle QED dynamics.

Search result:

- The causal-set spinor-propagator frontier remains less sourced in the local
  library. ArXiv/OpenAlex searches for "causal set Dirac/fermion propagator"
  did not reveal a clean Johnston-style spinor extension, which supports
  keeping that target as a hard frontier rather than a near-term theorem claim.
```

### 6. `FUTURE_DIRECTIONS.md` [The field]

Score: `0.787`

```text
### The field

A *quantum cellular automaton* (QCA) is a discrete-time, discrete-space unitary
evolution rule that is local (each cell depends only on a finite neighbourhood)
and translation-invariant. The Bisio-D'Ariano-Mosco (2016) programme derives
the Dirac, Weyl, and Majorana equations as continuum limits of the simplest
possible QCA rules.

In (1+1) dimensions, the 2-component Dirac QCA has update rule:
```
Ψ(x, t+1) = ξ · Ψ(x-1, t)
where ξ = [[cos θ, i sin θ], [i sin θ, cos θ]]
```
and the mass parameter `m = sin θ` appears as a mixing angle. In the continuum
limit this gives the 1+1D Dirac equation. The 3+1D case requires 4-component
spinors and produces the full Dirac equation, but with a "fermion doubling"
problem analogous to the lattice-QCD Nielsen-Ninomiya theorem.

The recent Arrighi (2019) review frames QCA as a general foundation for discrete
physics. Perez-Garcia et al. (2006) showed that QCA are equivalent to quantum
circuits with local gates, giving a second operational characterization.
```

### 7. `PhysicsSM/Gauge/QunitQubitQutritDictionary.lean` [Qunit]

Score: `0.786`

```text
abbrev Qunit := Fin 1 → ℂ

/-- A **qubit** is a state in ℂ². The special unitary group SU(2) acting
on this space is the weak isospin gauge factor of the Standard Model. -/
```

### 8. `PhysicsSM/Draft/NullEdgeQubitConcurrence.lean` [qubitConcurrence_sq_eq_four_det]

Score: `0.786`

```text
theorem qubitConcurrence_sq_eq_four_det
    (d : Real) (hd : 0 <= d) :
    qubitConcurrenceFromDet d ^ 2 = 4 * d := by
  unfold qubitConcurrenceFromDet
  nlinarith [Real.mul_self_sqrt hd]

end PhysicsSM.Draft.NullEdgeQubitConcurrence

end
```

## Scoped paper hits

### 1. Evolution in Quantum Causal Histories

Score: `0.785`
Zotero key: `KDEECE8M`
arXiv: `hep-th/0302111`
URL: http://arxiv.org/abs/hep-th/0302111

Abstract:

Defines quantum causal histories as locally finite causal pre-spacetime with matrix algebras at events and completely positive maps between causally related algebras. Important prior art for finite causal quantum processes.

### 2. Entanglement Entropy in Causal Set Theory

Score: `0.781`
Zotero key: `G2JGSV9B`
arXiv: `1611.10281`
DOI: `10.1088/1361-6382/aab06f`
URL: http://arxiv.org/abs/1611.10281

Abstract:

Studies causal-set entanglement entropy for causal diamonds and the role of Pauli-Jordan spectral truncation in obtaining area-law behavior.

### 3. Free quantum field theory from quantum cellular automata: derivation of Weyl, Dirac and Maxwell quantum cellular automata

Score: `0.777`
Zotero key: `BVJBTK8J`
arXiv: `1601.04832`
URL: http://arxiv.org/abs/1601.04832v1

### 4. A perturbative approach to the solution of the Thirring quantum cellular automaton

Score: `0.770`
Zotero key: `F9QTMZW5`
arXiv: `2406.19917`
DOI: `10.3390/e27020198`
URL: http://arxiv.org/abs/2406.19917

Abstract:

The Thirring Quantum Cellular Automaton (QCA) describes the discrete time dynamics of local fermionic modes that evolve according to one step of the Dirac cellular automaton followed by the most general on-site number-preserving interaction, and serves as the QCA counterpart of the Thirring model in quantum field theory. In this work, we develop perturbative techniques for the QCA path-sum approach, expanding both the number of interaction vertices and the mass parameter of the Thirring QCA. By classifying paths within the regimes of very light and very heavy particles, we computed the transition matrices in the two- and three-particle sectors to the first few orders. Our investigation into the properties of the Thirring QCA, addressing the combinatorial complexity of the problem, yielded some useful results applicable to the many-particle sector of any on-site number-preserving interactions in one spatial dimension.

### 5. From quantum cellular automata to quantum lattice gases

Score: `0.766`
Zotero key: `65IM39PT`
arXiv: `quant-ph/9604003`
DOI: `10.1007/BF02199356`
URL: https://www.zotero.org/19894138/items/65IM39PT

Abstract:

A natural architecture for nanoscale quantum computation is that of a quantum cellular automaton. Motivated by this observation, in this paper we begin an investigation of exactly unitary cellular automata. After proving that there can be no nontrivial, homogeneous, local, unitary, scalar cellular automaton in one dimension, we weaken the homogeneity condition and show that there are nontrivial, exactly unitary, partitioning cellular automata. We find a one parameter family of evolution rules which are best interpreted as those for a one particle quantum automaton. This model is naturally reformulated as a two component cellular automaton which we demonstrate to limit to the Dirac equation. We describe two generalizations of this automaton, the second of which, to multiple interacting particles, is the correct definition of a quantum lattice gas.
