# Aristotle semantic context pack

Generated: 2026-07-10T18:33:29
Query: `finite CAR determinant minor second quantization Gamma functoriality unitarity creation covariance`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Future_Directions.md` [Round-9 (Pro, 2026-07-09 late evening): complete finite process theory]

Score: `0.776`

```text
ocal no-go against global commutativity | `two-region-tensor-microcausality` `13b40077` |
| Finite SSB degeneracy gate | a commuting unitary preserves the density matrix of a normalized simple eigenstate; a degenerate two-state ground space permits a moved representative | `finite-ssb-degeneracy-nogo` `af7eb850` |
| Dimensional-transmutation algebra | positivity, inverse-coupling RG cocycle, and exact invariant `mu exp[-1/(2 b g(mu)^2)] = Lambda`, with an exponential witness | `one-loop-dimensional-transmutation` `3ea09edf` |

These jobs sharpen four boundaries in the source analysis:

1. **No-signaling is operational, not yet geometric.** The Kraus theorem forbids
   changing a remote marginal under a local trace-preserving map; identifying
   the tensor factors with spacelike-separated graph regions remains a separate
   causal-factorization theorem.
2. **Microcausality needs a net.** The tensor-product witness supplies exact
   two-region locality while retaining noncommutative local physics. Extension
   to a region poset with gluing, covariance, and refinement is open.
3. **Finite symmetry breaking is a degeneracy statement.** A simple finite
   vacuum cannot break an exact commuting symmetry at the density-matrix level.
   Genuine spontaneous breaking therefore owes a degenerate/refinement limit;
   the theorem does not construct one.
4. **An absolute scale needs a running law.** The transmutation job proves the
   invariant once one-loop running is supplied. Deriving that flow from closure
   dynamics and matching physical units remain the real program.

The Born/Gleason route, contextuality cohomology, resonance poles, crossing and
analyticity, OPE compression, generalized/noninvertible symmetries, anomaly
inflow, thermodynamic-limit phases, quantum Darwinism, r
```

### 2. `Sources/NERD_2.md` [1.5 Gate I1 (new, finite-dimensional, Lean-tractable)]

Score: `0.776`

```text
### 1.5 Gate I1 (new, finite-dimensional, Lean-tractable)

1. $\det(p_\mu\sigma^\mu) = p^2$ (soldering determinant).
2. PSD rank-one factorization: future-null $\iff P = \lambda\lambda^\dagger$.
3. Cauchy–Binet mass identity $\det(LL^\dagger) = \sum_{i<j}|\langle ij\rangle|^2$ and its equality with the cross-term expansion.
4. Little-group theorem: stabilizer of $P$ under right action on $L$ is $\mathrm{U}(2)$ (with $\mathrm{SU}(2)$ as the spin part).

Every item is finite matrix algebra. This is the cheapest nontrivial formal target in the entire program and can run in parallel with C1 without touching it.

---
```

### 3. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P4-F. Luminal checkerboard dynamics, formalized]

Score: `0.776`

```text
rality flip,
dispersion relation, and proper-time ratio in one auditable finite model.

Sharpened P4 split. The publishable near-term claim should be the homogeneous
fixed-point theorem, not the full causal-set frontier. In the homogeneous
quantum-walk setting, the finite target is:

```text
null-step unitary symbol
-> L plus R doubling forced by no 2 x 2 mass term
-> scalar off-diagonal flip is the Dirac mass
-> small-momentum Dirac dispersion
-> unnormalized visible determinant det(P_vis) = m^2
-> normalized det(P_vis / Tr(P_vis)) gives the frame-relative m/E readout
```

The hard frontier is separate: a Lorentz-invariant spinor hop-stop propagator on
a Poisson-sprinkled causal set, extending Johnston's scalar propagator. That is
where the ontology would become genuinely new dynamics, but it should not be
folded into the banked P4 paper until the homogeneous fixed-point package and
single-cone/doubler accounting are under control.

New finite anchors. Two of the fixed-point package guardrails are now
kernel-checked draft modules. `PhysicsSM.Draft.NullEdgeP4PauliNo2x2Mass`
proves that a single `2 x 2` Weyl space cannot contain an invertible matrix
anticommuting with all Pauli matrices; the mass term therefore requires the
doubled `L plus R` Dirac space. `PhysicsSM.Draft.NullEdgeP4VisibleDetInvariant`
proves that determinant-one visible congruence preserves the unnormalized
visible determinant and records the trace-normalized determinant formulas that
turn it into the observer-conditioned readout.
`PhysicsSM.Draft.NullEdgeP4ScalarFlipIsotropy` proves that Pauli isotropy forces the flip
generator to be scalar, making vector flip components anisotropic couplings
rather than mass.

Lead venue. ITP or math-physics.

Literature anchors. Earle checkerboard notes; Foster-Jacob
```

### 4. `AgentTasks/null-edge-gram-weighted-operator-aristotle-2026-06-21.md` [Why this matters]

Score: `0.775`

```text
## Why this matters

This is the finite operator statement behind the hidden-channel physics: a
positive hidden Gram sector remains positive after taking the visible reduced
operator. It complements the existing determinant/Cauchy-Binet mass theorem.
```

### 5. `Sources/A_null-strand_Bohm–Bell_theory.md` [12. Finite Bell-type QFT]

Score: `0.773`

```text
## 12. Finite Bell-type QFT

At a finite Fock cutoff, take finite configuration projectors (P_q), self-adjoint (H), and state (\Psi). Define

[
J(q,q')
=======

2,\operatorname{Im}
\langle\Psi,P_qHP_{q'}\Psi\rangle.
]

Ready finite algebra:

```lean
quantumCurrent_antisymm
minimalBellRate_nonneg
minimalBellRate_masterEquation
operatorBlockZero_implies_currentZero
```

The derivative identification is conditional on the Schrödinger equation:

```lean
schrodingerBornDerivative_eq_currentSum
```

Then add finite creation/annihilation and destination-direction sampling:

```lean
creationLift_targetDirectionMarginal
annihilationLift_forgetsDirection
finiteFockNullLift_equivariant
```

Renormalized infinite-dimensional QFT belongs far beyond the first target.
```

### 6. `Sources/A_broader_physics_of_finite_null_information.md` [5. Anomaly-as-decoding-obstruction theorem]

Score: `0.770`

```text
### 5. Anomaly-as-decoding-obstruction theorem

Construct the determinant-line or phase cocycle of the finite chiral carrier and prove that anomaly cancellation is exactly the condition that the gauge quotient and amplitude functor compose consistently.
```

### 7. `PhysicsSM/Draft/NullEdgeP2DephasingDeterminant.lean`

Score: `0.769`

```text
import Mathlib.Tactic

/-!
# P2 dephasing and determinant growth

This module formalizes a small part of the refined Higgs/Yukawa story. The
off-diagonal mass coupling first creates left/right chirality coherence. If an
observer channel removes that off-diagonal coherence, the determinant increases
by exactly the squared coherence that was removed.
-/
```

### 8. `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md` [9a. A finite dynamics layer: action, evolution, RG, ensemble (**M** scaffolds)]

Score: `0.768`

```text
stone`,
  **M**) makes the bridge explicit: the *same* commutation hypothesis both
  transports every mass-shell eigenstate at fixed mass and conserves the real
  `A`-expectation along the symmetry orbit. Its capstone conjoins that link with
  the finite RG invariant/monotone and canonical-ensemble packets and the
  concrete carrier-block unitary flow. This is an auditable finite Noether
  analogue and composition surface, not a continuum Noether theorem.
- **D2/D3 — evolution and conservation.** `norm_conserved_orbit`,
  `energy_conserved_orbit` (`FiniteUnitaryEvolution`, **M**) prove that *any
  sector isometry* conserves norm and energy along its orbit — generic finite
  functional analysis (`LinearIsometryEquiv`). This was previously flagged with
  the honest caveat that the *instantiation* (the T2 carrier's step actually
  being such an isometry) was open. **That instantiation is now closed** and
  kernel-checked (`CarrierUnitaryFlow`, **M**, guard-pinned): the sector form is
  Hermitian (the mass-gap block `B`), so the flow it generates `exp(−i t H)` is
  **unitary** (`hermitian_flow_mem_unitaryGroup` / `B_flow_unitary`) and induces a
  genuine `LinearIsometryEquiv` on the sector (`hermitian_flow_isometry`). Wired
  through the generic scaffold, this gives single concrete theorems —
  `carrier_orbit_norm_conserved` and `carrier_orbit_energy_conserved` (both **M**,
  guard-pinned): the discrete time-evolution *orbit* of the carrier block flow
  conserves the sector norm and (for commuting observables) energy. So
  `FiniteUnitaryEvolution` fires on the block flow. Stated exactly (per the
  flagship audit): this is Euclidean-unitarity of `exp(−i t H)` for Hermitian `H`,
  instantiated at the mass block — a generic fact with `H := B`, *not* yet the
  carrier's Krein e
```

## Scoped paper hits

### 1. Von Neumann algebra automorphisms and time-thermodynamics relation in generally covariant quantum theories

Score: `0.758`
Zotero key: `I8XNBREW`
DOI: `10.1088/0264-9381/11/12/007`
URL: https://doi.org/10.1088/0264-9381/11/12/007

### 2. Quantum Field Theory On Causal Sets

Score: `0.745`
Zotero key: `arxiv:2306.04800`
arXiv: `2306.04800`
URL: http://arxiv.org/abs/2306.04800

Abstract:

Overview of matter QFT on fixed causal-set backgrounds, including Green functions, Sorkin-Johnston two-point functions, and fermion/interacting-theory directions.

### 3. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.745`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 4. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.732`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 5. Free quantum field theory from quantum cellular automata: derivation of Weyl, Dirac and Maxwell quantum cellular automata

Score: `0.732`
Zotero key: `BVJBTK8J`
arXiv: `1601.04832`
URL: http://arxiv.org/abs/1601.04832v1
