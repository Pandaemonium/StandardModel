# Aristotle semantic context pack

Generated: 2026-07-09T13:57:36
Query: `Constructive finite WAY theorem: explicit nontrivial charge-coherent ancilla implements chirality flip while conserving additive total isospin`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Spinor/SpinorTenfoldFock.lean` [contract_contract_self]

Score: `0.817`

```text
theorem contract_contract_self (i : Fin 5) (ψ : FockSpinor) :
    contract i (contract i ψ) = 0 := by
  funext S
  simp only [contract, Pi.zero_apply]
  split
  · rfl
  · rw [if_pos (Finset.mem_insert_self i S), mul_zero]

/-! ### Parity: creation and annihilation flip chirality -/
```

### 2. `PhysicsSM/StandardModel/YukawaGauge.lean` [hyperchargeDefect]

Score: `0.814`

```text
def hyperchargeDefect (c : CandidateYukawaVertex) : ℚ :=
  -c.left.hypercharge + c.higgs.hypercharge + c.right.hypercharge

/-- The candidate is a chirality flip from a left-handed to a right-handed multiplet. -/
```

### 3. `PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean` [hyperchargeDefect]

Score: `0.814`

```text
def hyperchargeDefect (c : CandidateYukawaVertex) : ℚ :=
  -c.left.hypercharge + c.higgs.hypercharge + c.right.hypercharge

/-- The candidate is a chirality flip from a left-handed to a right-handed multiplet. -/
```

### 4. `PhysicsSM/StandardModel/OneGenerationTable.lean`

Score: `0.801`

```text
namespace PhysicsSM.StandardModel.OneGenerationTable

/-! ## Chirality -/

/-- The chirality (handedness) of a fermion field. -/
```

### 5. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [2. Chirality flips generate non-collinearity]

Score: `0.800`

```text
### 2. Chirality flips generate non-collinearity

The current draft sometimes says that each chirality flip contributes mass.
The sharper statement is:

> Chirality flips locally generate non-collinearity; mass measures the
> accumulated two-point Pluecker spread of the whole null-edge bundle.

The exact mass formula is pairwise over the bundle:

\[
m^2 = \sum_{i<j} |\psi_i \wedge \psi_j|^2.
\]

Adjacent bends or flips may generate the spread, but the mass is not simply a
sum over adjacent bends unless additional assumptions are imposed.

The reduced-state version is sharper still. Higgs-permitted chirality flips
should be modeled as a unitary dilation of a visible mass channel: the full
visible-plus-internal state may remain pure, while the visible celestial qubit
becomes mixed after the internal/chiral/Higgs label is ignored. In that
language, the Yukawa coupling controls the entangling amplitude of the
internal transition, and the observed determinant mass is a reduced visible
mixedness, not a dissipative loss of probability.

Neutrinos are the sharpest elementary-particle stress test for this language.
The weak-visible channel sees neutrinos almost entirely as left-handed,
nearly-null propagation, while oscillations prove that at least two mass
eigenstates are not exactly massless. In this program's terms, a massive
neutrino should be modeled as an almost pure weak-visible null mode with a tiny
hidden chirality, sterile, or Majorana-sector coupling. This is a motivation for
the observer-channel formalism, not a solved theorem: the program does not yet
decide Dirac versus Majorana mass, PMNS mixing, mass ordering, sterile-sector
content, or the absolute mass scale. Current direct KATRIN bounds and
cosmological mass-sum constraints should be used only as experimental
```

### 6. `AgentTasks/null-edge-physics-bridge-aristotle-2026-06-21.md` [3. Higgs/Yukawa permission for chirality flips]

Score: `0.800`

```text
### 3. Higgs/Yukawa permission for chirality flips

```lean
permittedChiralityFlip_iff_yukawa_channel
```

Guidance:

- Use `candidateGaugeLegal_iff_exists_yukawaFlip`.
- Forward direction: unpack the Higgs insertion witness, apply the classifier,
  and read off the left/right multiplets.
- Reverse direction: use the candidate associated to the Yukawa flip and the
  existing `candidateOfYukawaFlip_gaugeLegal`.
```

### 7. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [Branch balance as a qubit]

Score: `0.799`

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

### 8. `AgentTasks/aristotle-downloads-wave12-13-20260626/fur-h1-computed-internal-spectrum/fur-h1-computed-internal-spectrum_aristotle/AgentTasks/null-edge-furey-internal-spectrum-bridge.md` [8. Task 7 — follow-up Aristotle jobs]

Score: `0.799`

```text
eft convention + hypercharge sign flips against silent basis-conflation. | `AgentTasks/null-edge-internal-spectrum-two-basis-audit.md` |
| F5 | Proof / Strategy | Formalize the §5 **`chiral_realization`** target: define `netChiralContent`, state the no-doubling (determinant branch-count) clause, and either prove it for a chiral candidate or produce a vector-like counterexample with matching charge multiset. | This is the gate separating "reused the SM table" from "realizes chiral SM"; highest-value open theorem of the bridge. | `PhysicsSM/Draft/NullEdgeChiralRealization.lean` + `AgentTasks/null-edge-chiral-realization-gate.md` |

---
```

## Scoped paper hits

### 1. Spin on a 4D Feynman Checkerboard

Score: `0.770`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 2. The Chiral and flavour projection of Dirac-Kahler fermions in the geometric discretization

Score: `0.746`
Zotero key: `WENPW6UZ`
arXiv: `0706.4385`
DOI: `10.1142/S0219887808002825`
URL: https://www.zotero.org/19894138/items/WENPW6UZ

Abstract:

It is shown that an exact chiral symmetry can be described for Dirac-Kahler fermions using the two complexes of the geometric discretization. This principle is extended to describe exact flavour projection and it is shown that this necessitates the introduction of a new operator and two new structures of complex. To describe simultaneous chiral and flavour projection, eight complexes are needed in all and it is shown that projection leaves a single flavour of chiral field on each.

### 3. Extension of the Nielsen-Ninomiya theorem

Score: `0.745`
Zotero key: `arxiv:hep-lat/9803002`
arXiv: `hep-lat/9803002`
DOI: `10.1103/PhysRevD.58.057505`
URL: http://arxiv.org/abs/hep-lat/9803002

Abstract:

Extends the Nielsen-Ninomiya no-go theorem for lattice chiral Dirac fermions using the index theorem, including translation non-invariant and non-local formulations.

### 4. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.744`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 5. Exact chiral symmetry on the lattice and the Ginsparg-Wilson relation

Score: `0.744`
Zotero key: `N68MN4ET`
arXiv: `hep-lat/9802011`
DOI: `10.1016/S0370-2693(98)00423-7`
URL: https://arxiv.org/abs/hep-lat/9802011

Abstract:

It is shown that the Ginsparg-Wilson relation implies an exact symmetry of the fermion action, which may be regarded as a lattice form of an infinitesimal chiral rotation. Using this result it is straightforward to construct lattice Yukawa models with unbroken flavour and chiral symmetries and no doubling of the fermion spectrum. A contradiction with the Nielsen-Ninomiya theorem is avoided, because the chiral symmetry is realized in a different way than has been assumed when proving the theorem.
