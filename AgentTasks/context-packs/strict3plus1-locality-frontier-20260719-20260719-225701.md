# Aristotle semantic context pack

Generated: 2026-07-19T22:57:10
Query: `strict local 3+1 quantum cellular automaton finite Laurent support torus doubling chiral charge`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/24h-publication-run-2026-07-12/DIRECT_LIT_MINIMAL_DOUBLING_RECIPROCAL_2026-07-11.md` [Ranked primary sources]

Score: `0.816`

```text
## Ranked primary sources

1. [Bakircioglu, Arnault, Arrighi, *Fermion Doubling in Quantum Cellular
   Automaton Models*](https://arxiv.org/abs/2505.07900), especially Sections
   4-6 and Appendix C/D.  The paper gives a discrete-time determinant-level
   doubling analysis and removes spurious neighborhoods by an eight-sheeted
   Brillouin-zone covering in `3+1`, interpreted as an eight-flavour QCA.  It
   preserves linearity and chiral symmetry by changing the lattice/translation
   representation rather than finding a single-cone four-component symbol.
   This is the most concrete successor to our failed direct reciprocal P1:
   enlarge the register and prove a covering equivalence, not another
   four-component corner perturbation.

2. [Gupta and Short, *Fermion Doubling in Dirac Quantum
   Walks*](https://arxiv.org/abs/2601.15885), Sections III and the doubling
   appendices.  Their stationary-amplitude projector family removes conventional
   doublers and pseudo-doublers for suitable parameters, but in `3+1` retains
   exactly two extraneous low-energy solutions `+/-q(theta)` because the
   construction combines one-dimensional walks axis by axis.  This supports
   our exact alias result and identifies the next theorem: derive and classify
   those two non-corner roots in the live rational fixture.

3. [Nzongani et al., *Dirac quantum walk on
   tetrahedra*](https://arxiv.org/abs/2404.09840), Sections II-IV and Appendix
   B.  The walk uses an ordered tetrahedral/cell register and strictly local
   shift, basis, and mass operations to obtain the `3+1` Dirac equation in the
   continuum.  The robust boundary construction doubles the internal degrees
   of freedom.  It is a construction precedent for enlarging directional
   memory, but it does not provide an all-zon
```

### 2. `Sources/Null_Edge_Publication_Portfolio_2026-07-10.md` [Working title]

Score: `0.816`

```text
### Working title

**Locality, Doubling, and Onsite Mass in Three-Dimensional Dirac Quantum
Cellular Automata**
```

### 3. `AgentTasks/24h-publication-run-2026-07-12/SPARK_LIT_FLAVOURED_MINIMAL_DOUBLING_2026-07-11.md` [Primary sources]

Score: `0.814`

```text
## Primary sources

1. Bakircioglu, Arnault, Arrighi, *Fermion Doubling in Quantum Cellular
   Automaton Models*, arXiv:2505.07900.
   <https://arxiv.org/abs/2505.07900>

   The paper treats doubling directly in discrete-space, discrete-time QCA and
   resolves it by a covering map of the Brillouin zone. In `3+1`, the direct
   space is decomposed into translated sublattices/flavour sheets and the time
   translation carries an explicit tensor product of three flavour flips. This
   is not a unique-cone walk on the original cell. It is a precise enlarged-cell
   or covering construction that reinterprets the copies as flavours without
   breaking linearity or chiral symmetry. Sections 4.2 and 5, especially the
   sublattice construction near equations/figures 4.2-6, are the relevant
   clean-room template.

2. Gupta, Short, *Fermion Doubling in Dirac Quantum Walks*,
   arXiv:2601.15885v2.
   <https://arxiv.org/abs/2601.15885>

   Their exact local unitary permits a nonzero stationary amplitude
   `gamma_0`, with one-dimensional factor
   `T = gamma_+ S + gamma_0 + gamma_- S^dagger` and projector identities that
   prove unitarity. In `3+1`, the construction removes conventional doublers
   and pseudo-doublers but retains two additional low-energy Weyl-like
   solutions at explicitly described momenta. The authors report numerical
   exclusion of further solutions rather than an exact global classification.
   This is a strong template for a minimally doubled or stationary-amplitude
   hedge, not evidence for a unique cone.
```

### 4. `AgentTasks/context-packs/afpl-gap-balance-20260713-20260713-125509.md` [6. `AgentTasks/24h-publication-run-2026-07-12/MANUSCRIPT_CLAIM_DELTA.md` [Manuscript claim delta]]

Score: `0.806`

```text
### 6. `AgentTasks/24h-publication-run-2026-07-12/MANUSCRIPT_CLAIM_DELTA.md` [Manuscript claim delta]

Score: `0.800`

```text
iral-doubling | Under global chirality, strict Laurent locality is expected to force zero strong three-dimensional winding in each sector, so one nonzero Weyl-sector crossing charge requires compensation. | source-supported imported-T composition candidate | Read arXiv:1608.04696v3 explicitly computes complex Laurent `K1 = C^* + d Z` and excludes nonzero `SK1` in the change-of-rings image; Bessho-Sato arXiv:2006.04204 supplies extended Floquet charge bookkeeping | stable Laurent unit; exact involution/unitarity; global constant chirality; isolated nondegenerate zero/pi crossings; determinant delays separated | cubic-walk sector charge census required | globally chirality-mixing symbols lie outside scope; finite-rank stabilization and exact zero/pi sign convention remain VERIFY; never encode the imported theorem as a Lean assumption | primary-source audit recorded in `B_STRICT_LAURENT_SOURCE_AUDIT_2026-07-11.md`; composition pending |
| JC-finite-cover-kernel | In the five-mode exterior-degree model with `6Y = 3 N_W - 2 N_V`, the central elements of `SU(3) x SU(2) x U(1)` acting trivially on all six even weak/color bidegrees are exactly the six standard powers `(m mod 3, m mod 2, m)`. | M/comp | `JordanCliffordFermionKernel.fermionCentralKernel_eq_standardPowers` | supplied weak/color split; supplied cover-center phase formula; six even bidegrees; fixed hypercharge normalization | `standard_generator_mem` | `pure_su2_control_not_mem`, `pure_su3_control_not_mem`, `pure_u1_control_not_mem`; not yet an actual group-action kernel theorem or a Jordan-derived split | direct Lean PASS; targeted build PASS (8,026 jobs); aggregate guard PASS; draft-scoped
```

### 5. `AutonomousLab/work/NE-3PLUS1/CLAUDE_SKEPTIC_QUBITIZED_WILSON_NOGO_AUDIT_2026-07-13.md` [Decisive prior art (already in `Sources/Null_Edge_References.md`)]

Score: `0.804`

```text
## Decisive prior art (already in `Sources/Null_Edge_References.md`)

- **Bakircioglu, Arnault, Arrighi, "Fermion Doubling in Quantum Cellular
  Automata," arXiv:2505.07900v3 (2025)** (`TBD-BakirciogluArnaultArrighi2025`,
  currently ID-ONLY). A qubitized Szegedy walk IS a discrete-time local-unitary
  QCA (`Delta_t = Delta_x = eps`). BAA25 abstract: "We demonstrate the existence
  of FD issues in QCAs for `Delta_t = Delta_x = eps != 0`." So making the
  evolution an exact unitary walk does NOT remove fermion doubling. Their fix is
  a **flavor-staggering + Brillouin-zone covering map** that, in their words,
  "coexists with the Nielsen-Ninomiya no-go theorem" - it does NOT evade NN.
  ACTION: promote this reference to CONTENT-CHECKED (full text) before any
  manuscript claim; the exact FD-in-QCA theorem and the covering-map fix are the
  load-bearing content.
- **Nielsen-Ninomiya (1981)** (`CP84QBM4`, content-checked 2026-07-13): a local,
  translation-invariant, Hermitian lattice Dirac operator with the right
  continuum limit and EXACT chiral symmetry must have doublers. Wilson's `r`
  term evades it by dropping the chiral-symmetry hypothesis.
- QCA Dirac constructions: Bisio-D'Ariano-Perinotti-Tosini (`1601.04842`),
  Arrighi et al.; our own `GateYM.GinspargWilson` and `GateYM.OverlapDirac` are
  the standard "maximal lattice chirality" machinery (Ginsparg-Wilson / overlap),
  which take the Wilson operator as INPUT.
```

### 6. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/CLAUDE_SKEPTIC_QUBITIZED_WILSON_NOGO_AUDIT_2026-07-13.md` [Decisive prior art (already in `Sources/Null_Edge_References.md`)]

Score: `0.804`

```text
## Decisive prior art (already in `Sources/Null_Edge_References.md`)

- **Bakircioglu, Arnault, Arrighi, "Fermion Doubling in Quantum Cellular
  Automata," arXiv:2505.07900v3 (2025)** (`TBD-BakirciogluArnaultArrighi2025`,
  currently ID-ONLY). A qubitized Szegedy walk IS a discrete-time local-unitary
  QCA (`Delta_t = Delta_x = eps`). BAA25 abstract: "We demonstrate the existence
  of FD issues in QCAs for `Delta_t = Delta_x = eps != 0`." So making the
  evolution an exact unitary walk does NOT remove fermion doubling. Their fix is
  a **flavor-staggering + Brillouin-zone covering map** that, in their words,
  "coexists with the Nielsen-Ninomiya no-go theorem" - it does NOT evade NN.
  ACTION: promote this reference to CONTENT-CHECKED (full text) before any
  manuscript claim; the exact FD-in-QCA theorem and the covering-map fix are the
  load-bearing content.
- **Nielsen-Ninomiya (1981)** (`CP84QBM4`, content-checked 2026-07-13): a local,
  translation-invariant, Hermitian lattice Dirac operator with the right
  continuum limit and EXACT chiral symmetry must have doublers. Wilson's `r`
  term evades it by dropping the chiral-symmetry hypothesis.
- QCA Dirac constructions: Bisio-D'Ariano-Perinotti-Tosini (`1601.04842`),
  Arrighi et al.; our own `GateYM.GinspargWilson` and `GateYM.OverlapDirac` are
  the standard "maximal lattice chirality" machinery (Ginsparg-Wilson / overlap),
  which take the Wilson operator as INPUT.
```

### 7. `AgentTasks/overnight-publication-run-2026-07-11/HELP_NEEDED_2026-07-11.md` [H3. Find the minimal strict-local `3+1` Dirac walk, or prove the resource lower bound]

Score: `0.800`

```text
aic precursor is now landed. Every unit of the finite Laurent-
polynomial ring over a field is a nonzero coefficient times a unique monomial,
a genuine two-term polynomial is not a unit, and the determinant of every
invertible finite Laurent matrix is a unique monomial. This isolates the exact
one-dimensional ring-level flow resource. It is not a three-dimensional
no-doubling theorem. The physical corollary must separately show which
index-preserving local deformations can or cannot remove aliases.
The unique determinant exponent is also now packaged as an additive algebraic
invariant: composition adds exponents, identity has exponent zero, pure shift
`T^n` has exponent `n`, and a one-channel two-shift symbol is not invertible.
The remaining bridge is explicitly physical/representational, not ring algebra.

**Best-fit expertise.** Quantum cellular automata, discrete-time quantum walks,
fermion doubling, Clifford QCAs, filter banks, and algebraic topology of
unitary matrix Laurent polynomials.

**Formal anchors.** `FullBlochZeroClassification.lean`,
`StrictQCAMinimalArchitecture.lean`,
`CommutatorWilsonStrictnessKill.lean`, `LaurentUnitResource.lean`, and the D4
walk modules, with `LaurentFlowIndex.lean` for the additive precursor.
```

### 8. `FUTURE_DIRECTIONS.md` [Key references]

Score: `0.799`

```text
### Key references

- Nielsen-Ninomiya (1981) "Absence of neutrinos on a lattice" — the original
  fermion doubling theorem, *Nucl. Phys. B*
- Bisio-D'Ariano-Mosco (2016) "Dirac quantum cellular automaton in one dimension"
  *Phys. Rev. A* 93
- Arrighi (2019) "An overview of quantum cellular automata" *Nat. Comp.*
- D'Ariano-Mosco-Perinotti (2017) "Quantum walks, Weyl equation and the Lorentz
  group", *J. Phys. A*
- Perez-Garcia et al. (2006) "Matrix product state representations"
- Susskind (1977) — original lattice fermion doubling analysis
```

## Scoped paper hits

### 1. Fermion Doubling in Quantum Cellular Automata

Score: `0.797`
Zotero key: `6XT3VQSE`
arXiv: `2505.07900`
URL: http://arxiv.org/abs/2505.07900

Abstract:

A Quantum Cellular Automaton (QCA) is essentially an operator driving the evolution of particles on a lattice, through local unitaries. Because $Δ_t=Δ_x = ε$, QCAs constitute a privileged framework to cast the digital quantum simulation of relativistic quantum particles and their interactions with gauge fields, e.g., $(3+1)$D Quantum Electrodynamics (QED). But before they can be adopted, simulation schemes for high-energy physics need prove themselves against specific numerical issues, of which the most infamous is Fermion Doubling (FD). FD is well understood in particular in the real-time, discrete-space \emph{but} continuous-time settings of Hamiltonian Lattice Gauge Theories (LGTs), as the appearance of spurious solutions for all $Δ_x=ε\neq 0$. We rigorously extend this analysis to the real-time, discrete-space \emph{and} discrete-time schemes that QCAs are. We demonstrate the existence of FD issues in QCAs for $Δ_t =Δ_x = ε\neq 0$. By applying a covering map on the Brillouin zone, we provide a flavor-staggering-only way of fixing FD that does not break the chiral symmetry of the massless scheme. We explain how this method coexists with the Nielsen-Ninomiya no-go theorem, and give an example of neutrino-like QCA showing that our model allows to put chiral fermions interacting via the weak interaction on a spacetime lattice, without running into any FD problem.

### 2. Free quantum field theory from quantum cellular automata: derivation of Weyl, Dirac and Maxwell quantum cellular automata

Score: `0.780`
Zotero key: `BVJBTK8J`
arXiv: `1601.04832`
URL: http://arxiv.org/abs/1601.04832v1

### 3. A perturbative approach to the solution of the Thirring quantum cellular automaton

Score: `0.774`
Zotero key: `F9QTMZW5`
arXiv: `2406.19917`
DOI: `10.3390/e27020198`
URL: http://arxiv.org/abs/2406.19917

Abstract:

The Thirring Quantum Cellular Automaton (QCA) describes the discrete time dynamics of local fermionic modes that evolve according to one step of the Dirac cellular automaton followed by the most general on-site number-preserving interaction, and serves as the QCA counterpart of the Thirring model in quantum field theory. In this work, we develop perturbative techniques for the QCA path-sum approach, expanding both the number of interaction vertices and the mass parameter of the Thirring QCA. By classifying paths within the regimes of very light and very heavy particles, we computed the transition matrices in the two- and three-particle sectors to the first few orders. Our investigation into the properties of the Thirring QCA, addressing the combinatorial complexity of the problem, yielded some useful results applicable to the many-particle sector of any on-site number-preserving interactions in one spatial dimension.

### 4. Weyl, Dirac and Maxwell Quantum Cellular Automata: analytical solutions and phenomenological predictions of the Quantum Cellular Automata Theory of Free Fields

Score: `0.773`
Zotero key: `KCQGEDJE`
arXiv: `1601.04842`
URL: http://arxiv.org/abs/1601.04842v1

### 5. Naive Lattice Fermion without Doublers

Score: `0.769`
Zotero key: `X2P68FKS`
arXiv: `2105.10977`
DOI: `10.1103/PhysRevD.104.094505`
URL: http://arxiv.org/abs/2105.10977

Abstract:

We discuss the naive lattice fermion without the issue of doublers. A local lattice massless fermion action with chiral symmetry and hermiticity cannot avoid the doubling problem from the Nielsen-Ninomiya theorem. Here we adopt the forward finite-difference deforming the $γ_5$-hermiticity but preserving the continuum chiral-symmetry. The lattice momentum is not hermitian without the continuum limit now. We demonstrate that there is no doubling issue from an exact solution. The propagator only has one pole in the first-order accuracy. Therefore, it is hard to know the avoiding due to the non-hermiticity. For the second-order, the lattice propagator has two poles as before. This case also does not suffer from the doubling problem. Hence separating the forward derivative from the backward one evades the doublers under the field theory limit. Simultaneously, it is equivalent to breaking the hermiticity. In the end, we discuss the topological charge and also demonstrate the numerical implementation of the Hybrid Monte Carlo.
