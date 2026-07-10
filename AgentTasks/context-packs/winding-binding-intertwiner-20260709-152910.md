# Aristotle semantic context pack

Generated: 2026-07-09T15:29:20
Query: `winding kernel explicit basis intertwiner bound eigenspace carrier two body structured holonomy N 3 w 1`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Spinor/PureSpinor10.lean` [WeylSpinor10]

Score: `0.760`

```text
abbrev WeylSpinor10 := Fin 16 → ℂ
```

### 2. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean` [vacuumSpinor]

Score: `0.755`

```text
def vacuumSpinor : FockSpinor := basisSpinor ∅

/-- The wedge monomial `e₃ ∧ e₄ ∈ Λ²`: the second spinor of the concrete
`d = 3` Krasnov pair (the `e^c` direction of the hypercharge table). -/
```

### 3. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Already proved or kernel-checked]

Score: `0.755`

```text
### Already proved or kernel-checked

- **Finite checkerboard skeleton.**
  `PhysicsSM.Spinor.Checkerboard` defines finite lightlike histories, corner
  weights, endpoints, terminal directions, finite path sums, and first-step
  decomposition. `PhysicsSM.Spinor.CheckerboardDynamics` adds trusted
  kernel-clean dynamics theorems: history counts, corner-weight powers,
  last-step recursion, evolution by iterated transfer operator, and a finite
  Klein-Gordon-style recurrence. The kernel-clean draft
  `PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle` proves endpoint
  closed forms for the right-starting right/right and right/left kernels.

- **Pluecker mass from null spinor bundles.**
  `PhysicsSM.Spinor.PluckerMass` is now the trusted algebraic keystone. It
  proves the two-edge determinant identity, the general finite bundle identity
  \(\det(\sum_i \psi_i\psi_i^\dagger)=\sum_{i<j}|\psi_i\wedge\psi_j|^2\),
  real nonnegativity, and the zero-mass/common-direction criterion.

- **Twistor/Pluecker matching wrapper.**
  `PhysicsSM.Spinor.TwistorPluckerMass` is now a trusted convention wrapper,
  promoted from the earlier draft. It shows that the spinor-chart two-twistor
  mass invariant reduces to the Pluecker wedge term, records the
  determinant-vs-trace normalization bridge, proves rescaling behavior, and
  extends the pairwise mass formula to finite multi-twistor charts. The draft
  module remains useful as provenance, but the theorem inventory should cite
  the trusted `PhysicsSM.Spinor` module.

- **Higgs/Yukawa permission for chirality flips.**
  `PhysicsSM.Draft.NullEdgeYukawaGaugeAristotle` proves the finite bookkeeping
  layer: the Higgs insertion carries the needed hypercharge, left and right
  multiplets have the expected chiralities, and the finite Yukawa
```

### 4. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Prior art and differentiation]

Score: `0.754`

```text
am simplicity constraint as one
finite statement; (iv) the Lean-formalized finite holonomy and Pluecker
theorems; (v) the rank-2/rank-3 Jordan split that keeps spacetime mass in
`H_2(C)` and generations in the internal `H_3(O)` layer; and (vi) the proposal
that Benincasa-Dowker curvature
and Jacobson Clausius balance are two traces of one diamond
\(\langle B, F\rangle\) pairing.
```

### 5. `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [P1: finite kinematic core]

Score: `0.753`

```text
### P1: finite kinematic core

Working role:

```text
finite Plucker/null-spinor bundle theorem plus claim-boundary paper.
```

Core theorem:

```text
det(sum_i psi_i psi_i^dagger)
  = sum_{i<j} |psi_i wedge psi_j|^2.
```

Interpretation:

```text
A finite bundle of null momenta has invariant mass exactly to the extent that
its null directions fail to remain projectively collinear.
```

P1 should not depend on Gate C, Furey, continuum convergence, QCD dynamics, or
Yukawa prediction.
```

### 6. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [Spinor-network closure as the source-visibility phase space]

Score: `0.753`

```text
ch the Fubini-Study/chordal mass spread, while the imaginary
  part should be tested through Bargmann/Berry phase identities. The spin
  interpretation remains conjectural until this commutes with the graph
  holonomy layer.
- AHH massive spinor-helicity already owns the two-spinor on-shell mass
  identity. Our trusted theorem is the finite `n`-edge Cauchy-Binet bundle
  identity and its graph interpretation.

---
```

### 7. `Sources/NullStrand_Lean_Roadmap.md` [14.3 Internal holonomy]

Score: `0.750`

```text
### 14.3 Internal holonomy

For a matrix-valued mass/Yukawa operator `M(x)`, define a discrete path-ordered product first:

```lean
def internalHolonomy (path : Fin (N+1) → X) : Matrix d d ℂ :=
  orderedProduct (fun i => exp (-I * Δs i • M (path i)))
```

READY finite theorems:

```lean
internalHolonomy_concat
internalHolonomy_unitary_of_hermitian
internalHolonomy_gaugeCovariant
commutingMass_internalHolonomy_eq_exp_sum
```

OPEN physical gate:

```lean
internalHolonomy_controls_directionOrChiralityTransition
```

A passive absolute phase is not promoted as an observable clock. Only relative holonomy or a demonstrated coupling to beable transitions counts as physical content.

---
```

### 8. `PhysicsSM/Spinor/SpinorTenfoldPurity.lean` [weakSpinor]

Score: `0.749`

```text
def weakSpinor : FockSpinor := basisSpinor ({3, 4} : Finset (Fin 5))
```

## Scoped paper hits

### 1. Spinors and Twistors in Loop Gravity and Spin Foams

Score: `0.745`
Zotero key: `TCC2N3U6`
arXiv: `1201.2120`
URL: http://arxiv.org/abs/1201.2120

Abstract:

Spinorial tools have recently come back to fashion in loop gravity and spin foams. They provide an elegant tool relating the standard holonomy-flux algebra to the twisted geometry picture of the classical phase space on a fixed graph, and to twistors. In these lectures we provide a brief and technical introduction to the formalism and some of its applications.

### 2. Twisted geometries: A geometric parametrisation of SU(2) phase space

Score: `0.739`
Zotero key: `63MQ6KC3`
arXiv: `1001.2748v3`
URL: http://arxiv.org/abs/1001.2748v3

Abstract:

Twisted-geometry parametrization of SU(2) loop-gravity phase space, including face areas, normals, extrinsic angle, gauge-invariant reduced phase space, and connection to closure/geometricity constraints.

### 3. Lorentz signature and twisted spectral triples

Score: `0.733`
Zotero key: `TBBD2TB4`
arXiv: `1710.04965`
DOI: `10.1007/JHEP03(2018)089`
URL: https://www.zotero.org/19894138/items/TBBD2TB4

Abstract:

We show how twisting the spectral triple of the Standard Model of elementary particles naturally yields the Krein space associated with the Lorentzian signature of spacetime. We discuss the associated spectral action, both for fermions and bosons. What emerges is a tight link between twist and Wick rotation.

### 4. Connections on non-abelian Gerbes and their Holonomy

Score: `0.732`
URL: http://arxiv.org/abs/0808.1923

### 5. Massive relativistic particle model with spin from free two-twistor dynamics and its quantization

Score: `0.730`
Zotero key: `zotero:2T3HC5NC`
arXiv: `hep-th/0510161`
DOI: `10.1103/PhysRevD.73.105011`
URL: https://doi.org/10.1103/PhysRevD.73.105011
