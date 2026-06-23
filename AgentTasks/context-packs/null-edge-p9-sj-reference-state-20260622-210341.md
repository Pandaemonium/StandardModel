# Aristotle semantic context pack

Generated: 2026-06-22T21:03:48
Query: `Define a finite Sorkin-Johnston reference state for a causal diamond`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [Pillar 8 — Causal-set foundations and discrete fields]

Score: `0.796`

```text
## Pillar 8 — Causal-set foundations and discrete fields

**Literature (tag `causal-set`).** Foundations: Bombelli-Lee-Meyer-Sorkin
(`10.1103/PhysRevLett.59.521`), the Surya Living Review (`1903.11544`), Henson review
(`gr-qc/0601121`), Bombelli *Discreteness without symmetry breaking* (`gr-qc/0605006`),
Rideout-Sorkin sequential growth (`gr-qc/9904062`), Sorkin *Light, Links and Causal Sets*
(`0910.0673`). Fields/curvature: Benincasa-Dowker scalar curvature (`1001.2725`), Johnston
propagators (`0909.0944`, `1010.5514`), BDG continuum limit (`2007.13192`), spectral
dimension (Eichhorn `1311.2530`). The reviewed harness added Johnston's finite-density
correction paper `1411.2614` (`SBHC9STK`), the causal-set QFT review `2306.04800`
(`DFRSS56K`), and Dowker-Henson-Sorkin on Lorentz-invariant discreteness
`gr-qc/0311055` (`P9HI8CI4`).

**Role.** This is the ambient discrete-causal setting. The near-term, repo-faithful
contribution is the *finite* order-complex and diamond-holonomy machinery (Pillars 5, 7);
causal-set Dirac propagators and the d'Alembertian are Stage-4 continuum targets.

**Energetic-causal-set locality refinement.** The useful Gemini extraction is
an edge-neighborhood definition, not a claim that Lorentz-invariant causal
sets have naive finite point valency. Define `edgeNeighbor_N(a,b)` for causal
links `a` and `b` when the causal diamond between the relevant endpoints has
at most `N` intermediate events. In finite causal sets this gives an explicit
locality cutoff for link-based action sums and propagation kernels while
keeping the underlying incidence structure Lorentz-compatible in spirit.

**Lean/prose targets.**

- `edgeNeighborN_finite`: in a finite causal set, each edge has finitely many
  `N`-neighbors.
- `edgeNeighborN_subdiamond_mono`: the relati
```

### 2. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [Pillar 8 — Causal-set foundations and discrete fields]

Score: `0.768`

```text
ure Lorentz-compatible in spirit.

**Lean/prose targets.**

- `edgeNeighborN_finite`: in a finite causal set, each edge has finitely many
  `N`-neighbors.
- `edgeNeighborN_subdiamond_mono`: the relation is stable under induced
  sub-diamonds or monotone in the cutoff parameter.
- `edgeLocalAction_depends_only_on_edgeNeighbors`: a design target for later
  finite action sums; do not use it as a physics theorem until the definition
  survives simulations.

**Falsification.** The cutoff becomes frame-dependent, unstable under the
coarse-grainings used by the program, or fails to localize the finite action
and propagation sums.

---
```

### 3. `Sources/Null_Edge_Big_Physics_Inquiry_Development.md` [3.2 Finite observable package]

Score: `0.768`

```text
### 3.2 Finite observable package

For a finite causal diamond `D`, define:

```text
Screen(D)          finite set of cut/crossing edges
Flux(D)            sum of screen-crossing null energy/momentum weights
Entropy(D)         edge-count, log-rank, or visible-density entropy proxy
CurvatureDefect(D) path-pair/diamond holonomy defect
B_D                finite bivector or area cochain on the screen
Pairing(D)         <B_D, CurvatureDefect(D)>
```

Then define a finite diagnostic

```text
ClausiusDefect(D)
  =
DeltaEntropy(D) - beta_D * Flux(D) - alpha * Pairing(D).
```

This is not yet Jacobson's theorem.  It is a graph observable whose continuum
limit can later be compared with Clausius/Raychaudhuri behavior.
```

### 4. `Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md` [7. Gravity: use Jacobson first, not canonical quantization]

Score: `0.755`

```text
ci scalar/action construction. ([arXiv][7])

So the gravity program should try to unify:

[
\text{causal-set curvature}
]

with

[
\text{null-horizon thermodynamics}.
]

A concrete conjecture:

[
\boxed{
\text{The Benincasa-Dowker scalar curvature is the coarse-grained equation-of-state defect of causal-diamond entropy flow.}
}
]

That is a very good research target.
```

### 5. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Stage 4: long-horizon continuum theory]

Score: `0.752`

```text
### Stage 4: long-horizon continuum theory

Only after the finite layer is stable:

1. causal-set Dirac propagator or spinor hop-stop construction;
2. continuum limit of diamond holonomy;
3. higher-gauge 2-connection over causal diamonds;
4. null-horizon thermodynamic derivation of Einstein equations;
5. decoherence functional over graph histories and Bell/Tsirelson analysis.
```

### 6. `FUTURE_DIRECTIONS.md` [The field]

Score: `0.752`

```text
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
```

### 7. `FUTURE_DIRECTIONS.md` [Key references]

Score: `0.751`

```text
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
```

### 8. `PhysicsSM/Draft/NullEdgeQuantumMeasureFiniteAristotle.lean`

Score: `0.749`

```text
namespace PhysicsSM.Draft.NullEdgeQuantumMeasureFinite

open BigOperators
open Complex
open PhysicsSM.Spinor.PluckerMass

variable {Omega Lambda : Type*}

/-- A finite event is represented by a finite set of outcomes. -/
```

## Scoped paper hits

### 1. Quantum Field Theory On Causal Sets

Score: `0.770`
Zotero key: `arxiv:2306.04800`
arXiv: `2306.04800`
URL: http://arxiv.org/abs/2306.04800

Abstract:

Overview of matter QFT on fixed causal-set backgrounds, including Green functions, Sorkin-Johnston two-point functions, and fermion/interacting-theory directions.

### 2. Is the cosmological constant a nonlocal quantum residue of discreteness of the causal set type?

Score: `0.754`
Zotero key: `G3FT8BXC`
arXiv: `0710.1675`
URL: http://arxiv.org/abs/0710.1675v1

### 3. Space-time as a causal set

Score: `0.749`
Zotero key: `I8DJ26QC`
DOI: `10.1103/PhysRevLett.59.521`
URL: https://www.zotero.org/19894138/items/I8DJ26QC

### 4. Implementing causality in the spin foam quantum geometry

Score: `0.740`
Zotero key: `UHBZSNE2`
arXiv: `gr-qc/0210064`
DOI: `10.1016/S0550-3213(03)00378-X`
URL: https://www.zotero.org/19894138/items/UHBZSNE2

Abstract:

We analyze the classical and quantum geometry of the Barrett–Crane spin foam model for four-dimensional quantum gravity, explaining why it has to be considering as a covariant realization of the projector operator onto physical quantum gravity states. We discuss how causality requirements can be consistently implemented in this framework, and construct causal transition amplitudes between quantum gravity states, i.e., realizing in the spin foam context the Feynman propagator between states. The resulting causal spin foam model can be seen as a path integral quantization of Lorentzian first order Regge calculus, and represents a link between several approaches to quantum gravity as canonical loop quantum gravity, sum-over-histories formulations, dynamical triangulations and causal sets. In particular, we show how the resulting model can be rephrased within the framework of quantum causal sets (or histories).

### 5. Directions in Causal Set Quantum Gravity

Score: `0.740`
Zotero key: `ZCN6Q6IB`
arXiv: `1103.6272`
URL: https://www.zotero.org/19894138/items/ZCN6Q6IB

Abstract:

In the causal set approach to quantum gravity the spacetime continuum arises as an approximation to a fundamentally discrete substructure, the causal set, which is a locally finite partially ordered set. The causal set paradigm was elucidated in a classic paper by Bombelli, Lee, Meyer and Sorkin in 1987. While early kinematical results already showed promise, the program received a substantial impetus about a decade ago with the work of Rideout and Sorkin on a classical stochastic growth dynamics for causal sets. Considerable progress has been made ever since in our understanding of causal set theory while leaving undisturbed the basic paradigm. Recent highlights include a causal set expression for the Einstein-Hilbert action and the construction of a scalar field Feynman propagator on a fixed causal set. The aim of the present article is to give a broad overview of the results in causal set theory while pointing out directions for future investigations.
