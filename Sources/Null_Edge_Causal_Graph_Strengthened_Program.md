# Strengthened null-edge causal graph research program

**Status:** clean research-program note, 2026-06-20.
**Related drafts:**
`Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md`,
`Sources/Luminal_Motion_Checkerboard_Research_Program.md`, and
`Sources/Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md`.
**Lean anchors:**
`PhysicsSM.Spinor.Checkerboard`,
`PhysicsSM.Draft.SpinCoherentProjectorAristotle`,
`PhysicsSM.Draft.WeylCliffordBridgeAristotle`,
`PhysicsSM.Draft.SpinorHelicityRankOneAristotle`, and
`PhysicsSM.Draft.SpinorHelicityQuaternionAristotle`.

## Executive conclusion

The null-edge causal graph idea is strongest when it is framed as a
theorem-driven research program, not as a finished replacement for quantum
field theory or general relativity.

The clean version is:

> Fundamental histories are quantum amplitudes or decoherence functionals over
> causal incidence structures. Their visible edges carry null spinor/twistor
> data. Massive particles are coarse-grained bundles of non-collinear null
> momenta. Fermion masses arise from Higgs-permitted chirality flips. Gauge
> curvature is measured by holonomy defects across causal diamonds. Gravity is
> approached through null-horizon entropy and momentum flux. Octonionic and
> exceptional structures belong primarily to the internal transition algebra,
> not to observed spacetime coordinates.

The most valuable extension is to make the program more algebraic and more
falsifiable:

1. prove the complex Pluecker mass identity in Lean;
2. match that identity to the two-twistor mass invariant;
3. formalize the Higgs as the representation-theoretic permission for
   chirality flips;
4. define an Abelian causal-diamond holonomy toy model before attempting
   non-Abelian or higher-gauge theory;
5. add an order-complex/Kahler-Dirac branch for fermions on causal graphs;
6. maintain a falsification ledger for every major conjecture.

## Main corrections

### Do not lead with ontology

"All motion is luminal" is a powerful slogan, but the trusted content should
be stated at the level of propagators, finite path sums, spinor identities,
and graph amplitudes. The ontology can be discussed, but it should not carry
the proof burden.

The safe claim is:

> Certain relativistic propagators and finite path sums admit exact
> descriptions in terms of null or lightlike microscopic steps, with mass
> appearing as a chirality-mixing or corner amplitude.

This is supported by the 1+1-dimensional Feynman checkerboard, by
projector-weighted 3+1-dimensional checkerboard constructions, and by
Dirac/Weyl quantum walks. It is not yet a universal theorem for arbitrary
random null-edge ensembles.

### Drop the octonionic equality-gap selection principle

The long draft contains an earlier conjecture that the octonionic case might
break the equivalence:

```text
sum of future null momenta is null iff all summands are parallel
```

The later correction is the one to keep. In Lorentzian geometry, for future
null momenta \(p_i\),

\[
\left(\sum_i p_i\right)^2 = 2 \sum_{i<j} p_i \cdot p_j,
\]

and \(p_i \cdot p_j \ge 0\), with equality only for parallel future null
vectors. Therefore a sum of future null momenta is null exactly when the
summands are all parallel. This argument is independent of octonionic
associativity.

The reason to use complex spinors for visible spacetime should instead be:

- observed spacetime is 3+1-dimensional;
- ordinary Weyl spinors are complex two-spinors;
- twistor theory is naturally complex;
- octonions are better suited to internal/triality/gauge data.

So the strengthened program should not try to prove an octonionic equality
gap. It should prove the mass-collinearity theorem cleanly, then place the
octonionic layer in the internal transition sector.

### Separate visible geometry from internal labels

The most stable two-layer architecture is:

```text
visible null geometry: complex spinors / twistors
internal transition algebra: octonions, triality, E8-like labels
```

An edge has visible null momentum

\[
p_e^{AA'} = \psi_e^A \bar\psi_e^{A'}
\]

with \(\psi_e \in \mathbb C^2\). It may also carry an internal label
\(\lambda_e\) from an octonionic, Furey-Hughes, Spin(10), or E8-adjacent
structure. The visible spinor says how the edge contributes to spacetime
momentum. The internal label says which particle/gauge/Higgs transition is
allowed at vertices.

This avoids forcing octonions to do the wrong job.

### Treat finite valency as effective, not fundamental

Lorentz-invariant causal discreteness is not compatible with a fundamental
fixed finite-valency graph in the naive lattice sense. The program should
therefore distinguish:

```text
fundamental structure: Lorentz/conformal invariant incidence measure,
                       generally infinite-valency or nonlocal;
effective histories: finite particle-like paths after coarse-graining,
                     decoherence, or conditioning on boundary data.
```

This is not a retreat. It is the natural form of the theory if the basic data
are null rays or projective twistors rather than sites on a rigid lattice.

## Core mathematical spine

### 1. Mass as Pluecker spread of null spinors

In 3+1 dimensions, represent a future null momentum by a rank-one Hermitian
spinor matrix:

\[
p_i^{AA'} = \psi_i^A \bar\psi_i^{A'}.
\]

For a coarse-grained bundle of null edges,

\[
P^{AA'} = \sum_i \psi_i^A \bar\psi_i^{A'},
\qquad
m^2 = \det P.
\]

The key complex identity is:

\[
\det\left(\sum_i \psi_i\psi_i^\dagger\right)
=
\sum_{i<j} |\psi_i \wedge \psi_j|^2.
\]

Thus mass is not a property of a single edge. It is a second-order invariant
of a bundle of null edges: the total pairwise angular spread of their null
directions. A single edge, or any collinear family of edges, is massless.
Non-collinear bundles are timelike.

This is the best keystone theorem for the program because it converts the
central intuition into a finite-dimensional algebraic statement.

#### Repo-native Lean extension

Create a trusted module, eventually:

```text
PhysicsSM/Spinor/PluckerMass.lean
```

Target declarations:

```lean
-- possible names, not final API
complex_plucker_mass_identity
complex_plucker_mass_nonneg
complex_plucker_mass_eq_zero_iff_collinear
```

This should build on the existing complex spinor-helicity draft:

```text
PhysicsSM/Draft/SpinorHelicityRankOneAristotle.lean
```

The statement is finite-dimensional linear algebra. It does not require
analysis, quantum field theory, causal sets, or continuum limits.

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

This suggests a strong conjecture:

> An isotropic ensemble of null-edge histories with chirality-flip intensity
> \(\nu\) has a continuum limit governed by a Dirac operator with effective
> mass \(m_{\rm eff} = C\nu\), where \(C\) depends only on dimension and
> normalization, not on higher details of the flip distribution.

This is the right way to state the higher-dimensional checkerboard
universality problem. It is still conjectural.

### 3. The Higgs as permission for chirality flips

In the Standard Model, a bare left-right fermion flip is not gauge invariant.
Left-handed and right-handed fermions transform differently under the
electroweak group. The Higgs/Yukawa insertion is exactly what makes the flip
legal.

Graph interpretation:

\[
\Psi_L \otimes H \to \Psi_R,
\qquad
\Psi_R \otimes H^\dagger \to \Psi_L.
\]

After electroweak symmetry breaking,

\[
m_f = y_f \frac{v}{\sqrt 2}.
\]

In null-edge language, \(y_f\) is the species-dependent amplitude for a
Higgs-permitted chirality-flip vertex, and the observed fermion mass is the
coarse-grained flip rate.

#### Repo-native Lean extension

Start with representation bookkeeping, not continuum dynamics. A first target
can be a hypercharge-neutrality theorem for a Yukawa vertex using existing
Standard Model and Furey modules.

Possible theorem form:

```lean
-- possible names, not final API
yukawa_vertex_hypercharge_neutral
higgs_permits_left_right_flip
```

This connects the null-edge program to existing files such as
`PhysicsSM.StandardModel.Representations`,
`PhysicsSM.StandardModel.Bosons`, and the Furey electroweak packages.

### 4. Twistor incidence as the continuum target

If the basic visible objects are null rays, then twistor geometry is a more
natural continuum home than a spacetime lattice.

Instead of:

```text
sum over embeddings into spacetime
```

use:

```text
sum over compatible null-twistor incidence structures
```

A spacetime event is then reconstructed from coherent incidence among null
rays. A massless edge is native. A massive particle is represented by a
multi-twistor or multi-null-spinor configuration whose summed momentum is
timelike.

The highest-value finite calculation is:

> Show that the two-twistor mass invariant reduces, in the relevant spinor
> chart, to \(|\psi_1 \wedge \psi_2|^2\).

This would make the Pluecker mass functional not merely a spinor identity,
but a twistor-invariant mass functional.

#### Repo-native extension

Add a source note or Lean draft for:

```text
TwistorPluckerMass
```

Scope it narrowly:

- define only the spinor part needed for the two-twistor invariant;
- record conventions for \(SL(2,\mathbb C)\), dotted/undotted spinors, and
  metric signature;
- avoid a full Penrose transform or twistor cohomology layer at first.

### 5. Causal-diamond holonomy instead of plaquettes

A causal DAG has no ordinary directed plaquette loops, but gauge curvature in
lattice gauge theory is usually detected by loop holonomy. The replacement
object is a causal diamond.

For two alternative histories \(\gamma_1,\gamma_2:p\to q\), define a holonomy
defect:

\[
\Delta U(p,q;\gamma_1,\gamma_2)
= U_{\gamma_1}^{-1} U_{\gamma_2}.
\]

In the Abelian case,

\[
\arg(\Delta U) = \int_\Sigma F
\]

for a surface \(\Sigma\) spanning the two paths. In a small diamond this
recovers \(F_{\mu\nu}\Sigma^{\mu\nu}\) to leading order.

The key idea:

> Gauge field strength is the obstruction to agreement among competing
> causal/null histories across a causal diamond.

#### Repo-native Lean extension

Start finite and Abelian:

```text
PhysicsSM/Draft/CausalDiamondHolonomy.lean
```

Target only group algebra first:

- a finite directed acyclic diamond;
- two paths from bottom to top;
- edge labels in a commutative group such as `UnitCircle` or an abstract
  Abelian group;
- path holonomy as product of edge labels;
- gauge transformations at vertices;
- proof that the path-comparison defect is gauge invariant when endpoints are
  fixed.

The continuum Stokes statement should remain a documented interpretation, not
a trusted Lean theorem at this stage.

### 6. Gravity through null-horizon thermodynamics

The gravity route should begin with Jacobson-style null thermodynamics, not
canonical quantization.

Graph dictionary:

```text
horizon entropy  = count or weighted count of null edges crossing a screen
heat flux        = null momentum flux across the same screen
Einstein equation = continuum equation of state
```

The strongest conjectural bridge is:

> The Benincasa-Dowker causal-set scalar curvature and Jacobson
> null-horizon Clausius balance are two continuum shadows of the same
> causal-diamond entropy-flow identity.

This is not a near-term Lean target. It is a long-horizon research direction.
The near-term work should instead define the finite graph observables:

- edge-crossing count for a cut or screen;
- null momentum flux through that cut;
- coarse-graining rules for nested diamonds.

### 7. Fermions through order complexes and Kahler-Dirac structure

Bare causal order does not produce fermions or spin-statistics. One must add
graded structure, spin structure, or a substitute.

An underdeveloped but promising extension is:

> Build a Kahler-Dirac operator on the order complex of a finite causal graph.

A finite causal poset has an order complex. Its simplices give a natural
cochain complex. The combinatorial exterior derivative \(d\), together with a
choice of adjoint \(\delta\), gives a discrete analogue of \(d+\delta\).

Why this matters:

- it gives a graph-native home for graded fermionic data;
- it does not require a fundamental spin structure at the first step;
- it connects naturally to staggered/Kahler-Dirac fermion ideas;
- it may later explain how the Foster-Jacobson null-step Weyl operator arises
  as a chiral projection.

#### Repo-native Lean extension

Add a finite combinatorics target:

```text
PhysicsSM/Draft/OrderComplex.lean
PhysicsSM/Draft/KahlerDiracGraph.lean
```

First theorem layer:

- define chains in a finite poset;
- define the boundary or coboundary operator;
- prove \(d^2 = 0\);
- only then discuss a Dirac-type operator.

This is a good companion to the checkerboard work because it is finite,
kernel-checkable, and independent of continuum analysis.

## Existing Lean footholds

The repo already contains several theorem islands that should be integrated
before new speculative modules multiply.

### Trusted checkerboard core

`PhysicsSM.Spinor.Checkerboard` already formalizes the finite 1+1-dimensional
checkerboard skeleton:

- directions and lightlike steps;
- corner weights;
- endpoints and terminal directions;
- finite histories;
- finite path sums;
- first-step decomposition of the path sum.

This is the seed of a publication-grade "finite core of Feynman's
checkerboard" result.

### Spin coherent projector layer

`PhysicsSM.Draft.SpinCoherentProjectorAristotle` contains kernel-checked
projector identities:

- Pauli product identity;
- projector Hermiticity and trace;
- idempotence and determinant on the unit sphere;
- sandwich collapse;
- Bargmann triple trace.

This is the algebraic spin-factor layer for 3+1-dimensional null polygons.
It should be reviewed and promoted out of `Draft` once naming, comments, and
imports are cleaned.

### Weyl/null-step bridge

`PhysicsSM.Draft.WeylCliffordBridgeAristotle` connects the spin coherent
projector layer to the spinor-helicity layer:

- \(\sigma \cdot p\) and \(\bar\sigma \cdot p\);
- Clifford relation;
- Minkowski trace pairing;
- null-step factorization \(\sigma\cdot(r,ra)=2rP(a)\).

This is one of the best bridges between the prose program and actual Lean.

### Spinor-helicity rank-one factorization

`PhysicsSM.Draft.SpinorHelicityRankOneAristotle` proves the complex
rank-one factorization of future null 4-momenta.

`PhysicsSM.Draft.SpinorHelicityQuaternionAristotle` extends the analogous
idea to the quaternionic 6-dimensional case.

These modules are the right base for the Pluecker mass theorem.

## Proposed clean work plan

### Stage 0: source and convention cleanup

Deliverable:

- a convention table for metric signature, Pauli matrices, spinor indices,
  twistor incidence, checkerboard corner weight, and Higgs hypercharge;
- a source table distinguishing primary sources, secondary reviews, and
  AI-generated synthesis.

Do not make any new trusted physics claim until this is done.

### Stage 1: finite Lean theorems

Priority:

1. finish and promote checkerboard finite combinatorics;
2. promote spin coherent projector identities;
3. promote Weyl/null-step bridge;
4. prove complex Pluecker mass identity;
5. prove hypercharge neutrality of Yukawa flip vertices;
6. define Abelian causal-diamond holonomy and prove finite gauge invariance;
7. define finite order complex and prove \(d^2=0\).

This stage is kernel-checkable and does not depend on analytic limits.

### Stage 2: finite-dimensional synthesis

Priority:

1. prove the two-twistor/Pluecker mass matching;
2. package the null-step projector theorem with the Pluecker mass theorem;
3. state the chirality-flip universality conjecture as a precise renewal or
   random-history statement;
4. write a short expository paper tying the Lean results to the known
   checkerboard and Foster-Jacobson literature.

### Stage 3: numerical and probabilistic pilots

Priority:

1. simulate isotropic null-edge flip ensembles and measure the dispersion
   relation;
2. test whether an effective Dirac mass depends only on flip intensity or on
   higher distributional data;
3. simulate Abelian diamond holonomy on random null-like diamonds;
4. compare graph observables with expected continuum curvature or flux
   approximations.

Oracle scripts can justify tests and conjectures, not trusted theorems.

### Stage 4: long-horizon continuum theory

Only after the finite layer is stable:

1. causal-set Dirac propagator or spinor hop-stop construction;
2. continuum limit of diamond holonomy;
3. higher-gauge 2-connection over causal diamonds;
4. null-horizon thermodynamic derivation of Einstein equations;
5. decoherence functional over graph histories and Bell/Tsirelson analysis.

## Falsification ledger

Every major conjecture should have a stated failure mode.

| Claim | What would weaken or kill it |
|---|---|
| Mass is Pluecker spread of null edges | Failure of the complex determinant identity or mismatch with physical invariant mass conventions |
| Chirality-flip rate gives effective mass | Random isotropic flip ensembles do not flow to a Dirac dispersion, or the mass depends non-universally on microscopic details |
| Higgs permits graph chirality flips | Representation bookkeeping does not match Standard Model Yukawa quantum numbers |
| Twistor incidence is the right continuum target | Two-twistor mass invariant does not match the Pluecker mass term, or incidence reconstruction requires extra non-null structure |
| Causal diamonds replace plaquettes | Path-comparison defects are not gauge invariant, or their continuum limit fails to reproduce field strength |
| Kahler-Dirac order-complex route gives fermions | The graph cochain operator cannot reproduce a Weyl/Dirac continuum sector without reintroducing hidden lattice structure |
| Null-horizon thermodynamics gives gravity | Edge-count entropy and momentum flux do not yield Raychaudhuri/Clausius behavior under coarse-graining |
| Quantum histories avoid Bell hidden-variable failure | The decoherence functional cannot produce quantum correlations while preserving operational no-signalling and strong positivity |

This ledger is important. It keeps the program scientific and prevents the
ontology from becoming unfalsifiable prose.

## Proposed publication path

### Paper 1: finite checkerboard and spin-projector algebra

Core contribution:

- Lean-checked finite checkerboard recursion;
- Lean-checked coherent projector identities;
- Lean-checked null-step factorization;
- prose connection to Feynman checkerboard and Foster-Jacobson.

Novelty:

- formal verification and convention-clean theorem packaging, not a claim of
  discovering the checkerboard.

### Paper 2: Pluecker mass from null spinor bundles

Core contribution:

- complex Pluecker mass theorem;
- equality iff collinearity;
- relation to future null momentum sums;
- optional quaternionic analogue;
- twistor mass matching if completed.

Novelty:

- the mass mechanism as a precise organizing theorem for null-edge graph
  programs.

### Paper 3: causal diamonds as gauge-curvature carriers

Core contribution:

- finite Abelian diamond holonomy model;
- gauge invariance of path-comparison defects;
- continuum interpretation as a causal replacement for plaquettes;
- roadmap to non-Abelian and higher-gauge versions.

Novelty:

- a clean graph-native gauge-curvature target compatible with causal DAGs.

## Short canonical thesis

The strongest version of the program is:

> A null-edge causal graph theory should be built as a quantum measure over
> causal/twistor incidence histories. Visible edges carry complex null spinors,
> whose non-collinear bundles have invariant mass equal to a Pluecker
> determinant. Fermion masses arise when Higgs/Yukawa insertions permit
> chirality-changing null continuations. Octonionic and exceptional algebraic
> structures label internal transition rules rather than observed spacetime
> coordinates. Gauge curvature is measured by causal-diamond holonomy defects.
> Gravity is approached as the continuum equation of state of null-edge
> entropy and momentum flux. The first trusted outputs should be finite
> Lean-checked algebraic and combinatorial theorems, with continuum physics
> treated as a later, explicitly conjectural layer.

That is ambitious, but it is disciplined. It keeps the beautiful synthesis
while giving the Lean kernel small, durable mathematical targets.
