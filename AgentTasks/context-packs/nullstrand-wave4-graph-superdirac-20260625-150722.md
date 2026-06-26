# Aristotle semantic context pack

Generated: 2026-06-25T15:07:26
Query: `NullStrand graph super Dirac finite graph operator square support Bell current causal diamond holonomy`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Remaining high-value challenges]

Score: `0.845`

```text
anguage.

- **Unify Plucker mass, Higgs flips, and diamond curvature as blocks of one
  finite super-Dirac square.**
  The ambitious operator target is not merely \(D=d+\delta\), but a covariant
  graded operator \(D_{U,\Phi}=d_U+\delta_U+\Phi+\Phi^\dagger\) whose square
  contains the graph Laplacian, diamond curvature, Higgs/Yukawa mass block,
  and visible Plucker scalar. This should be treated as the master
  falsification criterion for the finite synthesis.

- **Turn the order-complex seed into a fermion operator.**
  The cochain \(d^2=0\) theorem is only the start. A Kähler-Dirac route needs
  a graded Hilbert structure, adjoint/codifferential, Hodge-star or metric
  data, and a careful treatment of doubling and chirality. The cleanest
  concrete targets are Bianconi's topological Dirac operator \(D=d+\delta\)
  with \(D^2\) the Hodge Laplacian, \(\{\gamma,D\}=0\), and gapped spectrum
  \(E=\pm\sqrt{\lambda^2+m^2}\); the causal poset's lack of translation
  symmetry voids the Nielsen-Ninomiya doubling obstruction.

- **Add observable-relative nullity diagnostics.**
  The graph-theory extraction is useful as a finite API: quotient-internal
  edges vanish under quotient incidence, exact Abelian 1-cochains have trivial
  cycle holonomy, tree-supported phases are gauge-removable, boundary chains
  are homology-null, and low-mode spectral nullity is measured by endpoint
  eigenfunction differences. This should remain a support layer for the main
  Plucker/diamond observables, not a replacement for them.

- **Keep gravity and quantum-measure claims conjectural.**
  The null-horizon entropy/flux route and Bell/decoherence-functional layer
  remain research directions. They need finite observables and falsifiable
  pilots before they should be elevated to theorem targets.
```

### 2. `Sources/Null_Edge_Key_Conjectures.md` [What the literature says]

Score: `0.826`

```text
### What the literature says

The shape is not invented from scratch. Quillen superconnections (`WNATKBT5`),
generalized Lichnerowicz formulas (`BQJAG9TR`), the
Chamseddine-Connes spectral action (`6WURA7MF`), and Lee's superconnection
gauge-Higgs work (`3Z543SD3`) all support the principle that a first-order
Dirac-type operator can square to Laplacian, curvature, and scalar/Higgs terms.
Bianconi's topological Dirac operator for networks (`8ITHD4PG`) gives a finite
network analogue of `D = d + delta` with a Hodge-Laplacian square.

The Lorentzian/Krein warning is also sourced. Van den Dungen (`5DURW8DU`)
frames Lorentzian spectral triples as reverse Wick rotations over Krein spaces.
Bizi-Brouder-Besnard (`PM83B8QI`) develop indefinite spectral triples over
Krein spaces and space/time dimension bookkeeping. Besnard-Bizi (`5VWPZ8BP`)
emphasize the role of time orientation and the Krein product. Devastato-
Farnsworth-Lizzi-Martinetti (`5RJUDATF`) and Martinetti-Singh (`Q6R3PCGJ`)
show how twisting Euclidean spectral triples is tied to Lorentzian signature
and fermionic actions. These sources make ordinary positive-definite
self-adjointness the wrong default target for the causal operator.

The null-edge addition is more specific. The kinetic symbol of the graph Dirac
block should be the Lean-checked Pluecker determinant of a bundle of null
spinors; the Yukawa block should equal it only as an on-shell constraint; and
the curvature block should be the causal-diamond holonomy defect rather than an
ordinary plaquette curvature. This is a sharper claim than merely saying that
`D^2` contains a Laplacian and a mass term, since those features are generic in
Dirac-type constructions.
```

### 3. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [Sequenced work plan (literature-grounded)]

Score: `0.811`

```text
anski constraint package.
20. `HopfLinkVolumeSimplicity`: define boundary-graph Hopf-link volume
   functionals and compare them with closure plus pairwise Pluecker
   simplicity. This is a spin-foam geometricity guardrail, not a claim of full
   Plebanski-sector isolation.
21. `KahlerDiracGraph`: build the finite topological Dirac operator from the
   cochain seed, then prove `D^2 = Laplacian` and the algebraic chiral
   mass-gap square under explicit adjoint/anticommutation hypotheses.
22. `CausalSuperDirac`: the abstract off-diagonal block-square algebra is now
   integrated in `PhysicsSM.Draft.NullEdgeSuperDiracBlockCore`, and the
   finite superconnection expansion is integrated in
   `PhysicsSM.Draft.NullEdgeSuperconnectionExpansionCore`; the scalar
   covariant-differential curvature seed is integrated in
   `PhysicsSM.Draft.NullEdgeCovariantDifferentialCore`. Next define a
   graph-native `D_{U,Phi}=d_U+delta_U+Phi+Phi^dagger` candidate and map its
   curvature/Higgs/mass blocks to existing null-edge observables.
23. `SpectralTripleAudit`: test the graph-native `D_{U,Phi}` against finite
   real-structure, first-order-condition, inner-fluctuation, and low-order
   spectral-action checks.
24. `LeftRightFlipOperator`: connect the Higgs/Yukawa legality predicates to
   an off-diagonal mass block on doubled \(L\oplus R\) visible/internal data.
25. `SwerveDiffusionPilot`: distinguish coherent/unitary flip dynamics from
   decohered stochastic flipping by measuring residual momentum diffusion.
26. `EdgeNeighborLocality`: define the energetic-causal-set
   `edgeNeighbor_N` relation and prove its finite/monotonicity properties
   before using it in action or propagation claims.
27. `ObservableNullity`: package the quotient, exact-cochain, tree-gauge,
   boundary-chain,
```

### 4. `AgentTasks/null-edge-super-dirac-block-design-prompt-20260622.md` [Context]

Score: `0.809`

```text
## Context

The null-edge program wants a finite odd self-adjoint block operator

```text
D_{U,Phi} = d_U + delta_U + Phi + Phi^dagger
```

on a finite-dimensional graded Hilbert space, with edge transport `U`, a
Higgs/Yukawa block `Phi`, and a curvature block. The existing draft
`PhysicsSM.Draft.NullEdgeSuperDiracBlockCore` and the static Dirac-slash cores
(`NullEdgeDiracSlashCore`, `NullEdgeBundleDiracPluckerCore`,
`NullEdgeDiracTwoSheetCore`) are the trusted-adjacent inputs. The flagship target
is the square decomposition

```text
superDirac_sq_eq_laplacian_plus_curvature_plus_higgs.
```
```

## Scoped paper hits

No paper hits returned.
