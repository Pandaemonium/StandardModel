# Aristotle semantic context pack

Generated: 2026-06-25T16:17:46
Query: `finite graph super Dirac operator support square Laplacian holonomy defect graded odd block causal adjacency`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/null-edge-super-dirac-block-core-aristotle-2026-06-21.md` [Why this matters]

Score: `0.849`

```text
## Why this matters

This isolates the algebraic skeleton of the proposed finite causal
super-Dirac operator.  The target proves that an odd first-order operator on
`L + R` squares to diagonal Laplacian/mass blocks, that chirality anticommutes
with the odd operator, and that a scalar Higgs/Yukawa flip block squares to
`m^2`.
```

### 2. `AgentTasks/null-edge-grand-strategy-v2-output.md` [Cluster F — Causal super-Dirac order-complex assembly `D_{U,Φ}`]

Score: `0.845`

```text
### Cluster F — Causal super-Dirac order-complex assembly `D_{U,Φ}`

**Module:** `PhysicsSM/Draft/NullEdgeRoadmap/CausalSuperDiracAssembly.lean`.

**Purpose.** All the *pieces* exist (block square, superconnection expansion,
covariant `d_U²=curvature`, Bianconi `D²=Laplacian`, order-complex `∂∂=0`). The
open job is the **assembly**: instantiate `D_{U,Φ} = d_U + δ_U + Φ + Φ†` on an
actual finite causal order complex and prove its square equals
`covariant graph Laplacian + diamond curvature + Higgs/Yukawa mass + visible
Pluecker scalar block`, under explicit anticommutation/covariance hypotheses.

**Definitions needed.** A concrete finite order complex (reuse
`OrderComplexCochain.Chain`), a transport-twisted coboundary `d_U`, its adjoint
`δ_U`, the chiral grading, and the `Φ` Higgs block from
`NullEdgeSuperDiracBlockCore`.

**Theorem statement (handoff — this is the program's master criterion).**

```lean
theorem superDirac_sq_eq_laplacian_plus_curvature_plus_higgs
    (D := d_U + δ_U + Φ + Φ.adjoint) :
    D * D
      = graphLaplacian + diamondCurvatureBlock + higgsMassBlock      -- block-diagonal
```

**Repo dependencies (all banked).** `NullEdgeSuperconnectionE
...[truncated]
```

### 3. `AgentTasks/null-edge-order-complex-design-prompt-20260622.md` [Context]

Score: `0.843`

```text
## Context

The null-edge program wants a finite order complex (poset of a finite causal
graph) carrying a discrete exterior calculus: cochain spaces by degree,
coboundary `d`, adjoint codifferential `delta`, grading/chirality, and the
Hodge-Dirac operator `D = d + delta`. The kernel-checked anchor already proved is
`laplacian_psd` (the graph Laplacian quadratic form is a sum of squares). The
successor target is the finite topological-Dirac square
`topological_dirac_sq_eq_laplacian` and a chiral mass term.
```

### 4. `AgentTasks/null-edge-super-dirac-block-design-prompt-20260622.md` [Context]

Score: `0.842`

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

### 5. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [Sequenced work plan (literature-grounded)]

Score: `0.841`

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
   real-structure, first-order-condition, inner-fluctuation, and lo
...[truncated]
```

## Scoped paper hits

No paper hits returned.
