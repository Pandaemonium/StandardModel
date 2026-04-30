# Future Directions: PhysicsSM

**Document purpose.** A strategic research map identifying eight underexplored
directions adjacent to the project's current work. For each direction the
document records the key mathematical content, the connection to what is already
formalized in this repository, a concrete experiment that tests the connection,
and the prerequisites for a Lean formalization campaign.

This document is **not** a proof-obligation list — that is `OPEN_QUESTIONS.md`.
It is a compass for deciding what to build next, and for recognizing which
formal targets will have the largest scientific payoff.

**Current project baseline.** As of April 2026 the repository has kernel-verified:
octonion arithmetic (multiplication, conjugation, norm multiplicativity, all
three Moufang identities), the Furey Cl(6) module (omega, 8 basis states,
48-entry action table, charge formula, linear independence), the complete
operator-algebra layer (Chevalley relations, colour-triplet invariant subspaces,
Q-eigenvalues), D4 triality (Cartan matrix, order-3 cycle, Cartan preservation),
triality companion maps (conjBy automorphism, cube criterion), and the Fano/
Hamming combinatorial skeleton. The E8 Cartan matrix formalization is in review.

---

## Direction 1 — Spectral Triples and Noncommutative Geometry

### The field

Connes' noncommutative geometry replaces a smooth manifold by the algebraic
data of a *spectral triple* `(A, H, D)`: a (possibly noncommutative) algebra A,
a Hilbert space H carrying a faithful representation of A, and a self-adjoint
operator D (the Dirac operator) satisfying certain boundedness and regularity
conditions. The *spectral action* principle (Chamseddine-Connes 1997) reconstructs
the full bosonic Lagrangian of the Standard Model coupled to gravity from the
heat-kernel expansion of `Tr(f(D²/Λ²))`.

The finite part of the Standard Model spectral triple uses the algebra:
```
A_F = C ⊕ H ⊕ M₃(C)
```
(complex numbers, quaternions, and 3×3 complex matrices) and a specific internal
Dirac operator built from Yukawa couplings, CKM mixing, and Majorana masses.
The particle content, gauge group `U(1) × SU(2) × SU(3)`, and Higgs mechanism
emerge from the interplay of A_F with the Majorana condition on the Hilbert space.

### Connection to this project

The algebra `C ⊕ H ⊕ M₃(C)` is strikingly close to the `C ⊗ H ⊗ O` Dixon
algebra underlying Furey's construction, and both recover the Standard Model gauge
group. The key difference: Furey derives the gauge group from *octonions*,
Connes-Chamseddine derive it from a *spectral condition* on a much more
constrained algebraic input. Understanding the precise relationship between
these two derivations is an open mathematical question.

More concretely: the Furey minimal left ideal J, already formalized, carries
an `su(3) ⊕ u(1)` action. A spectral-triple viewpoint would ask: what is the
Dirac operator `D : J → J` (or `D : ComplexOctonion → ComplexOctonion`) such
that `[|D|, a] ∈ B(H)` for each `a ∈ A_F`? Answering this would connect the
existing action-table theorems to a Lagrangian.

### Key references

- Connes (1994) "Noncommutative Geometry" — the foundational text
- Chamseddine-Connes (1997) "The Spectral Action Principle", *CMP* 186
- Connes-Marcolli (2007) "Noncommutative Geometry, Quantum Fields and Motives"
- Chamseddine-Connes-Mukhanov (2015) "Geometry and the Quantum: Basics", *JHEP*
- Barrett (2006) "A Lorentzian version of the non-commutative geometry of the
  standard model of particle physics", *J. Math. Phys.*
- Devastato-Farnsworth-Martinetti-Scardapane (2018) "Lorentz signature and
  twisted spectral triples", *JHEP*

### Concrete experiment

Construct the simplest possible octonionic spectral triple:
1. Take `A = C × C × C × C` (algebra acting on the 8 states of J by scalar
   multiplication, using the charge eigenvalues already proved).
2. Take `H = ComplexOctonion` (the 16-real-dimensional Hilbert space).
3. Define `D` as the operator with matrix entries `D_{ij} = alpha_i * alpha_j_dag`
   (the charge operator extended to off-diagonal entries).
4. Check whether `||[|D|, a]||` is bounded for `a` in the algebra.

This is fully within the current infrastructure. If `D` constructed this way
is bounded, it would be the first verified spectral triple arising directly
from the Furey minimal left ideal.

### Lean formalization prerequisites

- `Mathlib.Analysis.InnerProductSpace.Basic` — inner product on ComplexOctonion
- A definition of `SpectralTriple` in Lean (not yet in mathlib)
- The existing `Q_op`, `T_ij` operators from `OperatorAlgebra.lean`
- `Module ℂ ComplexOctonion` (already proved)

---

## Direction 2 — Exceptional Jordan Algebra and Freudenthal Systems

### The field

The *exceptional Jordan algebra* J₃(𝕆) is the 27-dimensional real algebra of
3×3 self-adjoint octonionic matrices under the Jordan product `X ∘ Y = (XY+YX)/2`.
Its automorphism group is the compact Lie group F₄ (52-dimensional), and the
automorphisms of its complexification give E₆.

A *Freudenthal triple system* is an algebraic structure built on a symplectic
space with a quartic form and a triple product; it underlies E₇. The Freudenthal
*magic square* organizes these into the chain:

```
G₂ ⊂ F₄ ⊂ E₆ ⊂ E₇ ⊂ E₈
```

Recent physics work (Todorov-Drenska 2018, Boyle 2020, Dubois-Violette–Todorov
2018) connects J₃(𝕆) to the Standard Model by observing that the intersection of
Borel–de Siebenthal subgroups of F₄ gives exactly `S(U(2) × U(3))`, the gauge
group of the Standard Model. Boyle's paper notes a related structure in the
complexification of J₃(𝕆), recovering representations of Spin(10) (the GUT group)
together with Standard Model representations, left-right extensions, and the
Higgs doublet.

### Connection to this project

The project already has:
- `Furey.MinimalLeftIdeal` with 8 explicit basis states
- The charge formula Q = -(1/3)(N₁+N₂+N₃)
- The `H3O.lean` stub for J₃(𝕆)

The connection is: the 8 basis states of the Furey ideal J are *not* elements
of J₃(𝕆) directly, but they can be *embedded* as rank-1 projectors. Concretely:
the state `omega = (1-i·e₁₁₁)/2` is an idempotent (already proved), and the
8 states of J are images of primitive idempotents under the Cl(6) action. In
Jordan-algebra language, `omega` and `omega_bar` are the two primitive idempotents
corresponding to the two "chiralities" in J₃(𝕆).

### Key references

- Jordan-von Neumann-Wigner (1934) — original exceptional Jordan algebra paper
- Günaydin-Gürsey (1973, 1974) — octonions and quark structure (early connection)
- Baez (2002) "The Octonions", Section 3 — J₃(𝕆) and F₄
- Todorov-Drenska (2018) arXiv:1805.06739 — F₄ and Standard Model gauge group
- Dubois-Violette–Todorov (2018) arXiv:1806.09450 — SM symmetry from J₃(𝕆)
- Boyle (2020) arXiv:2006.16265 — Standard Model, exceptional Jordan, triality
- Manogue-Dray-Wilson (2022) arXiv:2204.05310 — Octions and E₈ description of SM

### Concrete experiment

Re-express the Furey charge formula in Jordan-algebra language:
1. Define `JordanProjector : ComplexOctonion → H3O` mapping each of the 8 basis
   states to a rank-1 projector in J₃(𝕆).
2. Show that the trace of the projector (the diagonal entry) recovers the charge Q.
3. This would connect the `charge_sum_full_generation` theorems in
   `MinimalLeftIdeal.lean` to the trace form on J₃(𝕆).

### Lean formalization prerequisites

- Q2.5 (H₃(𝕆) Jordan identity, currently hard Tier 2)
- A definition of `JordanProjector` as a linear map
- The trace function `tr : H3O → ℝ`
- Connection between `omega_idempotent` (already proved) and the notion of
  primitive idempotent in Jordan-algebra language

---

## Direction 3 — Quantum Cellular Automata and Discrete Dirac Dynamics

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

### Connection to this project

The project has `SUSYAlgebra.lean` as a stub and the Furey basis states as
explicit elements. QCA provides a possible "tick rule":

Each of the 8 basis states of J could label a *node type* in a graph. The 6
off-diagonal color operators (T₁₂, T₁₃, ...) and the 3 number operators (N₁,
N₂, N₃) could label *edge types*. A QCA update would be: each node broadcasts its
state to neighbours; each edge applies the appropriate operator; new node states
are computed from the superposition.

The key question: does such a QCA produce, in the continuum limit, a Dirac
equation with internal symmetry group `SU(3) × U(1)`? If yes, this would
connect the algebraic computation already done to a dynamical model.

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

### Lean formalization prerequisites

- A definition of `QuantumWalkStep` as a linear operator on `Fin n → ComplexOctonion`
- The existing action-table theorems from `OperatorAlgebra.lean`
- Mathlib's `LinearMap.comp` for composing operators
- Eventually: Fourier analysis on ℤ/nℤ for the continuum limit

---

## Direction 4 — Anomaly Cancellation as Diophantine Constraints

### The field

The Standard Model anomaly cancellation conditions for a single generation of
left-handed Weyl fermions with hypercharges `Yᵢ` are:

```
[U(1)]³:             Σᵢ Yᵢ³ = 0
[SU(2)]²[U(1)]:      Σᵢ Y(doublets)/2 = 0
[SU(3)]²[U(1)]:      Σᵢ Y(colour triplets)/2 = 0
[grav]²[U(1)]:       Σᵢ Yᵢ = 0
[U(1)][grav]²:       Σᵢ Yᵢ = 0  (same as above for SM)
```

Davighi-Gripaios-Lohitsiri (2020) and subsequent work frame anomaly
cancellation as a system of *Diophantine equations* in the integer hypercharge
assignments. Their "method of chords" constructs infinitely many solutions to
`[U(1)]³ = 0` by treating the cubic equation as a curve and using rational
points. This gives a systematic enumeration of all "anomaly-free" charge
spectra — including exotic ones.

A separate line (Ibanez-Ross 1991, Binetruy-Girardi-Grimm 2000) shows that in
theories with an anomalous U(1), the Green-Schwarz term must cancel the anomaly,
constraining the charges further. The combination of Diophantine methods with
Green-Schwarz constraints gives a classifier for consistent extensions of the
Standard Model.

### Connection to this project

The project has already computed (in `MinimalLeftIdeal.lean`):
- Charge eigenvalues Q(omega) = -1, Q(v1,v2,v3) = -2/3, Q(v4,v5,v6) = -1/3, Q(nu) = 0
- The cubic charge sum over J alone: `Σ Q³ = -2`
- The combined J ⊕ J̄ anomaly: `Σ Q³ = 0`

The next step is to ask: does the Furey charge assignment satisfy ALL Standard
Model anomaly conditions, not just the cubic one? This requires also computing
the `[SU(2)]²[U(1)]` and `[SU(3)]²[U(1)]` conditions, which involve the SU(2)
and SU(3) quantum numbers of each state — data that `OperatorAlgebra.lean` has now
made available.

### Key references

- Ibanez-Ross (1991) "Discrete gauge symmetry anomalies" — original Diophantine
  framing, *Phys. Lett. B*
- Davighi-Gripaios-Lohitsiri (2020) arXiv:1910.11460 — "Anomaly cancellation
  in the Standard Model with an additional U(1)" — systematic Diophantine approach
- Allanach-Sherrat (2021) arXiv:2108.02227 — "Charge normalisation and anomaly
  cancellation" — recent systematic survey
- Green-Schwarz (1984) — original anomaly cancellation paper

### Concrete experiment

Using the existing charge and colour data from `OperatorAlgebra.lean`:
1. Assign SU(2) isospin T₃ eigenvalues to each of the 8 states of J (using
   the `Y_op` / `T3_op` operators from `hypercharge.md`).
2. Compute `Σ Y · T₃²` (the mixed `[SU(2)]²[U(1)]` anomaly).
3. Compute `Σ Y · (colour Casimir)` (the mixed `[SU(3)]²[U(1)]` anomaly).
4. Check whether all six conditions vanish over J ⊕ J̄.

If they do, this is the first machine-verified proof that the Furey charge
assignment is *fully anomaly-free* in the Standard Model sense — going beyond
what the existing charge-sum theorems already confirm.

### Lean formalization prerequisites

- `T3_op` and `Y_op` from `hypercharge.md` (task file exists)
- The six anomaly conditions stated as Lean theorems
- `norm_num` for the rational arithmetic
- A clear convention on the Standard Model isospin and colour assignments

---

## Direction 5 — Higher Gauge Theory and 2-Group Structure

### The field

*Higher gauge theory* generalizes ordinary gauge connections to higher categorical
structures. A 2-connection assigns not just a Lie-algebra-valued 1-form `A` to
each path, but also a 2-form `B` to each surface, with a compatibility condition.
The relevant algebraic structure is a *Lie 2-group* (a group object in the
category of groups, also known as a strict 2-group or crossed module `∂: G → H`).

The *Green-Schwarz mechanism* is intrinsically a higher-gauge structure: the
Kalb-Ramond B-field is a 2-form gauge field, and anomaly cancellation requires
a Chern-Simons modification of its field strength `H = dB + CS(A)`. This
modification is exactly a 2-connection on a string structure (a higher U(1)-bundle
classified by `p₁/2`).

Baez-Lauda (2004) and Baez-Schreiber (2007) developed the mathematical framework.
Schreiber-Waldorf (2009) showed that string structures are classified by 2-bundles
with structure 2-group String(G).

### Connection to this project

The octonion product is *not* associative, which means that "parallel transport
around a triangle" in an octonionic gauge theory is not determined solely by the
boundary path. The associator `[a, b, x]` measures the *failure* of left-to-right
parallel transport to commute — exactly what a 2-connection encodes as its
"curvature" on triangles.

More concretely: in `OperatorAlgebra.lean`, the composition identity
```
T12_op = (Lmul alpha1).comp (Lmul alpha2_dag)
```
is a 2-level structure: `alpha1` and `alpha2_dag` act on edges, and their
composition depends on *which path we take*. The Chevalley relation
`[T12, T21] = -H12` on J is the 2-group *fake-curvature* condition for this
corner of the gauge structure.

### Key references

- Baez-Lauda (2004) "Higher-dimensional algebra V: 2-Groups" — foundational
  theory of 2-groups, *TAC*
- Baez-Schreiber (2007) "Higher gauge theory", *Categories in Algebra, Geometry
  and Mathematical Physics*
- Schreiber-Waldorf (2009) "Smooth functors vs. differential forms", *HHA*
- Baez-Huerta (2010) arXiv:0909.0551 "Division Algebras and Supersymmetry" —
  direct connection between octonions and higher gauge theory
- Sati-Schreiber-Stasheff (2009) "L∞-algebra connections and applications to
  String- and Chern-Simons n-transport" — string structure formalization

### Concrete experiment

In Lean, define the "fake curvature" of the colour operator system:
1. For the 3 generators of su(3) defined by `H12_op`, `H23_op`, `H13_op`,
   verify the Jacobi identity `[H12, [H23, X]] + cyclic = 0` on J.
2. Define the "higher holonomy" of a triangle with edges labelled by
   `alpha1`, `alpha2`, `alpha3` as the associator of their left-multiplication
   operators acting on J.
3. Show this associator equals the commutator of two generators — the
   2-group *Pfeiffer identity*.

This would formally connect the associator antisymmetry proved in
`OctonionSymmetry.lean` to the 2-group structure of the octonion gauge theory.

### Lean formalization prerequisites

- A definition of `Lie2Group` or `CrossedModule` (not in mathlib)
- The existing commutator theorems from `OperatorAlgebra.lean`
- The associator antisymmetry from `OctonionSymmetry.lean`
- Mathlib's `LieAlgebra` infrastructure (available via mathlib4)

---

## Direction 6 — Causal Set Theory as a Stress Test

### The field

*Causal set theory* (Sorkin 1991, Bombelli-Lee-Meyer-Sorkin 1987) replaces
the manifold structure of spacetime with a locally finite partial order: a set
C of "events" with a relation `≺` (causal precedence) that is transitive,
acyclic, and locally finite (every interval `{z : x ≺ z ≺ y}` is finite).
The fundamental hypothesis is that this discrete order contains all the physical
information of spacetime, including metric and dimension.

The central problem of causal set theory is *dynamics*: most random causal sets
look nothing like a manifold. The *causal dynamical triangulation* (CDT) approach
and the *sequential growth model* (Rideout-Sorkin 1999) are attempts to define
a measure on causal sets that favours manifold-like histories.

The *manifold-likeness* of a causal set can be diagnosed by the *Myrheim-Meyer
dimension estimator* (ratio of longest antichain length to causal set size),
*causal set green functions* (the discrete Green function should approximate the
continuum one), and *interval size distributions*.

### Connection to this project

The project's COG ("Causal Oriented Graph") idea places causal structure as
primary, with octonionic state labels on nodes. Causal set theory is the
well-developed mathematical framework for discrete causal structure — it
immediately provides:

1. **A warning**: "having a causal graph" is insufficient. Constraints are needed
   to select histories that look like 3+1 dimensional Lorentzian spacetime.
2. **A dimension estimator**: if COG is run in simulations, the Myrheim-Meyer
   estimator immediately tells you whether the output looks like 4D spacetime
   or generic graph junk.
3. **A Lorentz-invariance test**: a causal set that is a fair sampling of
   Minkowski spacetime must have Lorentz-invariant distribution of intervals
   (by the Lorentz-invariant Poisson process construction, Bombelli 1987).

### Key references

- Bombelli-Lee-Meyer-Sorkin (1987) "Space-time as a causal set", *PRL* 59 —
  the foundational paper
- Sorkin (1991, 2003) "Space-time and causal sets" — program development
- Rideout-Sorkin (1999) "A classical sequential growth dynamics for causal sets"
  *PRD* 61 — the first consistent dynamics
- Benincasa-Dowker (2010) "The Scalar Curvature of a Causal Set" *PRL* —
  geometry from causal structure
- Henson (2006) "The causal set approach to quantum gravity" — comprehensive review
- Ambjorn-Jurkiewicz-Loll (2004) "Emergence of a 4D World from Causal Quantum
  Gravity" — CDT approach, *PRL*

### Concrete experiment

Implement a minimal "octonionic causal set" and run the dimension estimator:
1. Define a node as `(Fin 8, Time : ℕ)` — an octonionic state at a discrete time.
2. Define the causal precedence relation using the operator action: `x ≺ y` iff
   `y = T_ij x` for some colour operator T_ij (a single "causal step").
3. Run the causal set for `n = 100` steps. Compute the Myrheim-Meyer estimator.
4. Compare to the expected value for 2D (= 2.0), 3D (= 2.4), 4D (= 2.7).

This is purely numerical, not a Lean formalization target. But the result would
immediately tell you whether the octonionic update rule generates a manifold-like
causal structure.

### Lean formalization prerequisites

- None immediately — this is a simulation experiment first.
- Eventually: a formal definition of `CausalSet` as a `Finset` with a `Preorder`,
  dimension estimators as Lean functions, and a theorem that the continuum limit
  of the octonionic dynamics satisfies the Lorentz-invariant Poisson condition.

---

## Direction 7 — Tensor Networks and Holographic Error Correction

### The field

The *HaPPY code* (Pastawski-Yoshida-Harlow-Preskill 2015) builds a quantum
error-correcting code from a tiling of hyperbolic space: bulk qubits are encoded
into boundary qubits by a perfect-tensor network, and the encoding map is both
an error-correcting code (protecting the logical qubits against local erasures)
and a toy model of the AdS/CFT correspondence.

The key object is a *perfect tensor* `T : (C²)⊗6 → C`: every bipartition of its
six indices into two halves of size three gives an isometry. This is related to
*absolutely maximally entangled* (AME) states. Rains (2002) and Goyeneche et al.
(2015) classified AME states in low dimensions; they are closely related to
classical error-correcting codes.

The connection to the E₈ lattice: the Leech lattice and E₈ appear in the
classification of quantum error-correcting codes over ℤ₂, and the weight
enumerators of self-dual codes (already in `OPEN_QUESTIONS.md` as Q2.13) are
exactly the modular forms that appear in holographic partition functions.

### Connection to this project

The Furey minimal left ideal J is an 8-dimensional ℂ-module. The question:
*is J a quantum error-correcting code?* More precisely, does there exist a
subspace `J_logical ⊂ (ComplexOctonion)^⊗n` that is "logically encoded" in J
and protected against a natural noise model?

The operator-algebra layer already proved:
- `J_up_color` (3D) and `J_down_color` (3D) are invariant under all colour
  operators — these are "decoherence-free subspaces" in the quantum information sense.
- `J_singlet_low` and `J_singlet_high` are 1D and also invariant.

This decomposition `J = J_singlet ⊕ J_triplet ⊕ J_triplet ⊕ J_singlet` is
exactly the structure of a quantum error-correcting code with one logical qubit
(the singlet sector) encoded in a triplet-protected space (analogous to
the 3-qubit bit-flip code).

### Key references

- Pastawski-Yoshida-Harlow-Preskill (2015) arXiv:1503.06237 "Holographic quantum
  error-correcting codes" — the HaPPY code
- Rains (2002) "Quantum weight enumerators" *IEEE Trans. IT*
- Goyeneche et al. (2015) "Absolutely maximally entangled states, combinatorial
  designs, and multiunitary matrices" *PRA*
- Almheiri-Mahajan-Maldacena-Zhao (2015) arXiv:1411.7041 — black holes as mirrors
- Harlow (2017) arXiv:1608.02315 "Jerusalem lectures on black holes and quantum
  information" — accessible review

### Concrete experiment

Test whether J is a quantum error-correcting code:
1. Represent the 8 basis states as orthonormal vectors in ℂ⁸.
2. Define a noise model: a single-mode erasure (loss of one of the three
   colour modes N₁, N₂, or N₃).
3. Check whether the logical information in `J_singlet_low` (the "electron state"
   omega) can be recovered after erasure of any one mode.
4. The error-correction condition is: for any two states `ρ₁, ρ₂` in the code
   subspace and any single-mode erasure channel E, `Tr(E(ρ₁)) ≠ Tr(E(ρ₂))`.

If this holds, J is a *quantum error-correcting code with minimum distance 2*
— protecting 1 logical qubit against erasure of any 1 out of 3 modes.

### Lean formalization prerequisites

- A finite-dimensional quantum channel formalism (not in mathlib)
- The existing `J_singlet_low`, `J_up_color`, `J_down_color`, `J_singlet_high`
  from `OperatorAlgebra.lean`
- Matrix representation of the basis states as vectors in `Fin 8 → ℂ`

---

## Direction 8 — ZX-Calculus and Categorical Quantum Mechanics

### The field

The *ZX-calculus* (Coecke-Duncan 2008, 2011) is a graphical rewriting system
for quantum circuits. Its generators are Z-spiders (green nodes) and X-spiders
(red nodes) with any number of inputs and outputs, satisfying a small set of
rewriting rules (fusion, bialgebra, copy, Euler decomposition). ZX-calculus is
*complete* for stabilizer quantum mechanics (Backens 2014) and approximately
complete for Clifford+T circuits (Hadzihasanovic 2015, Jeandel et al. 2020).

The key insight of categorical quantum mechanics (Abramsky-Coecke 2004) is that
quantum protocols can be understood as morphisms in a *dagger compact category*
— a monoidal category with dagger (†) and compact closures. This gives a purely
diagrammatic language for protocols like teleportation, Bell measurement, and
quantum error correction.

ZX-calculus has been applied to lattice gauge theory (Hadzihasanovic-Kissinger
2018), quantum field theory (Cockett et al.), and quantum chemistry (Cowtan et al.
2020). A "COG calculus" based on ZX-style generators would give a graphical
language for the local update rules of a causal graph.

### Connection to this project

The project's operator layer uses compositions like:
```
T12_op = (Lmul alpha1).comp (Lmul alpha2_dag)
opComm T12_op T21_op = -H12_op  (on J)
```
These are exactly the kinds of relations that ZX-style rewriting handles:
- A "green spider" corresponds to the su(3) Cartan generators `H_ij`
- A "red spider" corresponds to the raising/lowering operators `T_ij`
- The Chevalley relations `[T12, T21] = -H12` become rewriting rules

A ZX-style calculus for the Furey algebra would:
1. Provide a graphical proof language for the `OperatorAlgebra.lean` theorems
2. Make the proofs independent of coordinates (useful for the direction 5 goal)
3. Enable automated rewriting for new operator identities

### Key references

- Coecke-Duncan (2008) "Interacting quantum observables" — original ZX-calculus
- Abramsky-Coecke (2004) "A categorical semantics of quantum protocols" — *LICS*
- Backens (2014) arXiv:1307.7025 "The ZX-calculus is complete for stabilizers"
- van de Wetering (2020) arXiv:2012.13966 "ZX-calculus for the working quantum
  computer scientist" — comprehensive recent review
- Hadzihasanovic-Kissinger (2018) — ZX for lattice gauge theory
- Penrose (1971) "Applications of negative dimensional tensors" — historical roots

### Concrete experiment

Define a minimal "Furey ZX-calculus" with four generators:
1. `⊕` node: alpha₁, alpha₂, alpha₃ (creation operators — "red spiders")
2. `⊗` node: alpha₁†, alpha₂†, alpha₃† (annihilation operators — "green spiders")
3. Wiring: the 8 basis states as wires
4. Rewriting rules: the Clifford anticommutation relations already proved

Then verify that the colour transition table (48 entries from Phase D of the
moonshot) follows from the rewriting rules alone, without coordinate expansion.

If this works, the 48-entry action table collapses to a handful of diagrammatic
identities — a dramatic simplification of the proof overhead.

### Lean formalization prerequisites

- A definition of `FureyDiagram` as an inductive type of generators and wirings
- A rewriting system on `FureyDiagram` with the anticommutation rules as axioms
- A soundness theorem: diagram equality → equality of the corresponding operators
- This is substantial new infrastructure; would benefit from existing Lean
  categorical-diagram libraries (e.g., `Mathlib.CategoryTheory`)

---

## Cross-Connections and Priority Map

The eight directions are not independent. The following dependency graph shows
which directions strengthen which:

```
QCA dynamics (3)
     ↑
     |  feeds tick rules into
     |
COG causal graph ──────→ Causal set theory (6) [stress test]
     ↑
     |  emergent from
     |
Furey J module ─────────→ Holographic codes (7) [protection structure]
     ↑
     |  charges from
     |
Operator algebra ────────→ Anomaly Diophantine (4) [full SM check]
     ↑
     |  automorphisms from
     |
G₂ / exceptional ────────→ Spectral triple (1) [Dirac operator]
     |                  ↗
     |  classified by
     ↓
Jordan H₃(𝕆) (2) ────────→ ZX-calculus (8) [proof language]
                         ↗
Higher gauge (5) ────────
```

**Priority recommendation.** Given the current project state, the three highest-
payoff near-term investments are:

1. **Direction 4 (Anomaly Diophantine)** — requires only what is already
   formalized; adding `T3_op` (from `hypercharge.md`) and checking all six
   SM anomaly conditions would be a complete, verifiable result within 1-2
   Aristotle jobs.

2. **Direction 2 (Exceptional Jordan)** — the `H3O.lean` stub already exists,
   and re-expressing the omega idempotent in Jordan-algebra language is a
   prerequisite for connecting to F₄ and the Todorov-Drenska Standard Model
   derivation. This is the most direct path toward the Tier 3 goals in
   `OPEN_QUESTIONS.md` (Q3.5).

3. **Direction 1 (Spectral Triple)** — the simplest concrete experiment (building
   a toy spectral triple from the charge operators) requires almost no new
   infrastructure. If it produces a bounded D operator, it would be the first
   formal connection between the Furey construction and the Connes-Chamseddine
   approach.

**The most dangerous trap** — as noted in the user's summary — is jumping from
"beautiful algebra" to "the Standard Model" without a pipeline. The recommended
pipeline is:

```
Octonion algebra (done)
     ↓
Furey J module (done)
     ↓
Full SM anomaly check (Direction 4, ~2 jobs)
     ↓
Toy spectral triple (Direction 1, ~1 job)
     ↓
Jordan re-expression (Direction 2, ~3 jobs)
     ↓
QCA dynamics test (Direction 3, simulation first)
     ↓
Continuum limit and Lorentz recovery (long horizon)
```

---

## Formalization Status Table

| Direction | Key Math | Formalized anywhere? | Prerequisites in this repo | Jobs estimate |
|-----------|----------|---------------------|---------------------------|---------------|
| 1. Spectral triple | SpectralTriple(A,H,D) | Not in Lean | Module ℂ, Q_op | 2–3 |
| 2. Exceptional Jordan | H₃(𝕆), F₄ | Not in Lean | H3O.lean stub, Q2.5 | 4–6 |
| 3. QCA dynamics | Bisio-D'Ariano local rule | Not in Lean | action table in MinimalLeftIdeal | simulation first |
| 4. Anomaly Diophantine | SM anomaly equations | Not in Lean | charge_sum, T3_op needed | 1–2 |
| 5. Higher gauge / 2-group | 2-connection, crossed module | Not in Lean | assoc_antisymm, Chevalley rels | 3–5 |
| 6. Causal set theory | Partial order, dimension | Not in Lean | none | simulation first |
| 7. Holographic codes | Perfect tensor, HaPPY | Not in Lean | invariant subspaces in OperatorAlgebra | 2–3 |
| 8. ZX-calculus | Graphical rewriting | PyZX (Python), not Lean | anticommutation table | 4–6 |

---

## References

- Abramsky-Coecke (2004) "A categorical semantics of quantum protocols", *LICS*
- Ambjorn-Jurkiewicz-Loll (2004) "Emergence of a 4D World from Causal Quantum Gravity", *PRL*
- Arrighi (2019) "An overview of quantum cellular automata", *Nat. Comp.*
- Backens (2014) arXiv:1307.7025 "The ZX-calculus is complete for stabilizers"
- Baez-Lauda (2004) "Higher-dimensional algebra V: 2-Groups", *TAC*
- Baez-Schreiber (2007) "Higher gauge theory", *Categories in Algebra...*
- Baez-Huerta (2010) arXiv:0909.0551 "Division Algebras and Supersymmetry I"
- Benincasa-Dowker (2010) "The Scalar Curvature of a Causal Set", *PRL*
- Bisio-D'Ariano-Mosco (2016) "Dirac quantum cellular automaton in one dimension", *PRA* 93
- Bombelli-Lee-Meyer-Sorkin (1987) "Space-time as a causal set", *PRL* 59
- Boyle (2020) arXiv:2006.16265 "Standard Model, exceptional Jordan algebra, triality"
- Chamseddine-Connes (1997) "The Spectral Action Principle", *Commun. Math. Phys.*
- Coecke-Duncan (2008, 2011) "Interacting quantum observables", *ICALP*, *NJP*
- Connes (1994) "Noncommutative Geometry", Academic Press
- Connes-Marcolli (2007) "Noncommutative Geometry, Quantum Fields and Motives"
- Davighi-Gripaios-Lohitsiri (2020) arXiv:1910.11460 "Anomaly cancellation and the SM"
- Dubois-Violette–Todorov (2018) arXiv:1806.09450 "SM symmetry from J₃(𝕆)"
- Goyeneche et al. (2015) "Absolutely maximally entangled states", *PRA*
- Günaydin-Gürsey (1973, 1974) "Quark structure and octonions", *J. Math. Phys.*
- Jordan-von Neumann-Wigner (1934) "On an algebraic generalization of the quantum
  mechanical formalism", *Ann. Math.*
- Manogue-Dray-Wilson (2022) arXiv:2204.05310 "Octions and an E₈ description of SM"
- Nielsen-Ninomiya (1981) "Absence of neutrinos on a lattice", *Nucl. Phys. B*
- Pastawski-Yoshida-Harlow-Preskill (2015) arXiv:1503.06237 "Holographic QEC codes"
- Rideout-Sorkin (1999) "A classical sequential growth dynamics for causal sets", *PRD*
- Sorkin (2003) "Causal sets: discrete gravity" (Les Houches lectures)
- Todorov-Drenska (2018) arXiv:1805.06739 "F₄ and SM gauge group"
- van de Wetering (2020) arXiv:2012.13966 "ZX-calculus for quantum computer scientists"
