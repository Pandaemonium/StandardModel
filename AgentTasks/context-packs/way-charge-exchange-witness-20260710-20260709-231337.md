# Aristotle semantic context pack

Generated: 2026-07-09T23:13:44
Query: `WAY chirality turn conserved additive charge nontrivial ancilla swap charge exchange quantum reference resource`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean` [hyperchargeDefect]

Score: `0.790`

```text
def hyperchargeDefect (c : CandidateYukawaVertex) : ℚ :=
  -c.left.hypercharge + c.higgs.hypercharge + c.right.hypercharge

/-- The candidate is a chirality flip from a left-handed to a right-handed multiplet. -/
```

### 2. `PhysicsSM/StandardModel/YukawaGauge.lean` [hyperchargeDefect]

Score: `0.790`

```text
def hyperchargeDefect (c : CandidateYukawaVertex) : ℚ :=
  -c.left.hypercharge + c.higgs.hypercharge + c.right.hypercharge

/-- The candidate is a chirality flip from a left-handed to a right-handed multiplet. -/
```

### 3. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [Branch balance as a qubit]

Score: `0.785`

```text
### Branch balance as a qubit

The physical/mirror balance symmetry behaves like a two-state system. In this
language:

```text
balance-even selector:
  identity-like on the branch qubit;
  rejected by the C108 zero-trace theorem.

balance-odd selector:
  Pauli-like on the branch qubit;
  possible finite-origin polarizer.
```

This gives a clean interpretation of the current finite no-go:

```text
If a candidate acts trivially on the branch-balance qubit, it cannot release
chirality.
```
```

### 4. `PhysicsSM/Spinor/SpinorTenfoldCliffordGroup.lean` [reflectTwist]

Score: `0.777`

```text
def reflectTwist (v u : V10) : V10 := (B10 u v / Q10 v) • v - u

/-! ## Chirality preservation -/

/-- An endomorphism preserves chirality if it maps even spinors to even
spinors and odd spinors to odd spinors. Every element of
`evenCliffordGroup` does (conjugation draft module): each generator is a
product of two chirality-*flipping* Clifford operators. -/
```

### 5. `AgentTasks/aristotle-downloads-wave12-13-20260626/fur-h1-computed-internal-spectrum/fur-h1-computed-internal-spectrum_aristotle/AgentTasks/null-edge-furey-internal-spectrum-bridge.md` [8. Task 7 — follow-up Aristotle jobs]

Score: `0.770`

```text
eft convention + hypercharge sign flips against silent basis-conflation. | `AgentTasks/null-edge-internal-spectrum-two-basis-audit.md` |
| F5 | Proof / Strategy | Formalize the §5 **`chiral_realization`** target: define `netChiralContent`, state the no-doubling (determinant branch-count) clause, and either prove it for a chiral candidate or produce a vector-like counterexample with matching charge multiset. | This is the gate separating "reused the SM table" from "realizes chiral SM"; highest-value open theorem of the bridge. | `PhysicsSM/Draft/NullEdgeChiralRealization.lean` + `AgentTasks/null-edge-chiral-realization-gate.md` |

---
```

### 6. `PhysicsSM/Draft/SpinorTenfoldSO10ActionAristotle.lean` [chevalleyPairing_cliffordAction_swap_left]

Score: `0.768`

```text
theorem chevalleyPairing_cliffordAction_swap_left (u : V10) (ψ φ : FockSpinor) :
    chevalleyPairing (cliffordAction u ψ) φ
      = chevalleyPairing (cliffordAction u φ) ψ := by
        rw [ ← B10_gammaBilinear, ← B10_gammaBilinear, gammaBilinear_symm ]

set_option maxRecDepth 10000 in
set_option maxHeartbeats 4000000 in -- kernel `decide` over the 32×32 basis pairs
/-- Right-slot wedge swap on the integer mirror. -/
```

### 7. `PhysicsSM/Spinor/SpinorTenfoldSO10Action.lean` [chevalleyPairing_cliffordAction_swap_left]

Score: `0.768`

```text
theorem chevalleyPairing_cliffordAction_swap_left (u : V10) (ψ φ : FockSpinor) :
    chevalleyPairing (cliffordAction u ψ) φ
      = chevalleyPairing (cliffordAction u φ) ψ := by
  rw [← B10_gammaBilinear, ← B10_gammaBilinear, gammaBilinear_symm]

set_option maxRecDepth 10000 in
set_option maxHeartbeats 4000000 in -- kernel `decide` over the 32×32 basis pairs
/-- Right-slot wedge swap on the integer mirror. -/
```

### 8. `PhysicsSM/Draft/NullEdgeP2PartialDephasingRateBridge.lean` [chiralDet]

Score: `0.767`

```text
def chiralDet (q c : Real) : Real :=
  q * (1 - q) - c ^ 2

/-- Purity of the two-level real chiral proxy. -/
```

## Scoped paper hits

### 1. Quantum geometric tensor determines the pure-state i.i.d. conversion rate in the resource theory of asymmetry for any compact Lie group

Score: `0.745`
Zotero key: `45FTB5VF`
arXiv: `2411.04766`
URL: http://arxiv.org/abs/2411.04766

Abstract:

Shows that the quantum geometric tensor determines pure-state iid conversion rates in the resource theory of asymmetry for compact Lie groups.

### 2. Spin on a 4D Feynman Checkerboard

Score: `0.731`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 3. Bulk--Boundary Correspondence for Chiral Symmetric Quantum Walks

Score: `0.727`
Zotero key: `9QPIHJEW`
arXiv: `1303.1199`
DOI: `10.1103/PhysRevB.88.121406`
URL: http://arxiv.org/abs/1303.1199

Abstract:

Discrete-time quantum walks (DTQW) have topological phases that are richer than those of time-independent lattice Hamiltonians. Even the basic symmetries, on which the standard classification of topological insulators hinges, have not yet been properly defined for quantum walks. We introduce the key tool of timeframes, i.e., we describe a DTQW by the ensemble of time-shifted unitary timestep operators belonging to the walk. This gives us a way to consistently define chiral symmetry (CS) for DTQW's. We show that CS can be ensured by using an "inversion symmetric" pulse sequence. For one-dimensional DTQW's with CS, we identify the bulk ZxZ topological invariant that controls the number of topologically protected 0 and pi energy edge states at the interfaces between different domains, and give simple formulas for these invariants. We illustrate this bulk--boundary correspondence for DTQW's on the example of the "4-step quantum walk", where tuning CS and particle-hole symmetry realizes edge states in various symmetry classes.

### 4. Quantum simulation of quantum relativistic diffusion via quantum walks

Score: `0.722`
Zotero key: `I7G53I6T`
arXiv: `1911.09791v2`
URL: http://arxiv.org/abs/1911.09791v2

Abstract:

Discrete-time quantum walks with temporal noise on the coin admit a continuum limit described by a Lindblad equation with Dirac Hamiltonian part and chirality-flip / chirality-dependent phase-flip jumps. Useful prior art for the null-edge chirality-coherence and quantum-walk dynamics lane.

### 5. Momentum bispinor, two-qubit entanglement and twistor space

Score: `0.721`
Zotero key: `3VBEK82X`
arXiv: `1407.2492`
URL: http://arxiv.org/abs/1407.2492

Abstract:

Re-examines massive momentum bispinor symmetry and connects unit-energy future-lightcone geometry with two-qubit entanglement and twistor-space normalization. Important prior-art guardrail for observer-conditioned Pluecker mixedness.
