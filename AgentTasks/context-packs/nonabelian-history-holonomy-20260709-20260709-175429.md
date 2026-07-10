# Aristotle semantic context pack

Generated: 2026-07-09T17:54:37
Query: `nonabelian finite path holonomy gauge covariance closed loop conjugacy Wilson trace`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/null-edge-physics-audit-report-aristotle-20260622.md` [PhysicsSM/Gauge/CausalDiamondHolonomy.lean (trusted)]

Score: `0.832`

```text
### PhysicsSM/Gauge/CausalDiamondHolonomy.lean (trusted)
| Declaration | Score | Note |
|---|---|---|
| `DiamondLabels`, `PathPair`, `diamondDefect`, `pathPairDefect` | 9 | Wilson-line branch comparison; honest that it is not a continuum field strength. |
| `diamondDefect_gauge_covariant` (non-Abelian) | 10 | Conjugation at the top endpoint; correct. |
| `diamondDefect_gauge_invariant` (Abelian) | 10 | Correct commutative specialization. |
| `pathPairDefect_verticalCompose` / `_comm` / `_horizontalCompose` | 9 | Correct gluing laws incl. the non-Abelian transport correction. |
| `diamondDefect_classFunction_gauge_invariant` | 9 | Finite analog of trace of a plaquette holonomy; correct. |
```

### 2. `Sources/Null_Edge_Causal_Graph_Proof_Advances_2026-06-21.md` [Proof H: non-Abelian causal-diamond covariance]

Score: `0.831`

```text
## Proof H: non-Abelian causal-diamond covariance

The existing core proves Abelian diamond defect invariance.  The stronger and
more physical non-Abelian statement is covariance by endpoint conjugation.

Let a path holonomy transform as

```text
U_gamma |-> g_bottom^{-1} U_gamma g_top.
```

For a diamond with two paths from `bottom` to `top`, define

```text
Delta = U_left^{-1} U_right.
```

Then under gauge transformation:

```text
Delta |-> g_top^{-1} Delta g_top.
```

Proof:

```text
(g_bottom^{-1} U_left g_top)^{-1}
  (g_bottom^{-1} U_right g_top)
= g_top^{-1} U_left^{-1} g_bottom
  g_bottom^{-1} U_right g_top
= g_top^{-1} Delta g_top.
```

So in a non-Abelian theory the raw defect is not gauge invariant; its
conjugacy class is.  Any class function, such as trace in a representation, is
gauge invariant.  This is the correct finite graph replacement for plaquette
curvature.

Recommended theorem:

```lean
theorem diamondDefect_gauge_covariant [Group G]
    (g : DiamondGauge G) (U : DiamondLabels G) :
    diamondDefect (gaugeTransformDiamond g U) =
      g.top^-1 * diamondDefect U * g.top
```

The Abelian theorem is recovered because conjugation is trivial in a
commutative group.
```

### 3. `Sources/Null_Edge_Causal_Graph_Proof_Advances_2026-06-21.md` [Wave 3: non-Abelian diamonds]

Score: `0.824`

```text
### Wave 3: non-Abelian diamonds

New target file:

- `PhysicsSM/Draft/NullEdgeDiamondNonabelian.lean`

Targets:

- left and right path holonomy gauge-transformation formulas;
- `diamondDefect_gauge_covariant`;
- Abelian invariance as a corollary;
- class-function invariance in matrix representations.
```

### 4. `AgentTasks/aristotle-downloads-wave12-13-20260626/c61-gauge-covariant-link-dressed-projectors/c61-gauge-covariant-link-dressed-projectors_aristotle/AgentTasks/null-edge-gauge-covariant-branch-projectors-plan.md` [2.3 Closed composite — **gauge invariance** (`loopComposite_gauge_invariant`)]

Score: `0.813`

```text
### 2.3 Closed composite — **gauge invariance** (`loopComposite_gauge_invariant`)

For a transport `W` that returns to the base vertex (a closed Wilson loop /
length-balanced path), contracted into a Hermitian singlet with the base field,

```text
loopComposite a W ψ  =  cinner (ψ a) (W *ᵥ ψ a),
cinner (g a *ᵥ ψ a) ((gaugeLink g W a a) *ᵥ (g a *ᵥ ψ a)) = cinner (ψ a) (W *ᵥ ψ a).
```

The `g a` of the field and the `g a` of its conjugate cancel: the closed
composite is **exactly gauge invariant**.

---
```

### 5. `AgentTasks/model-calls/claude/2026-06-24-round-012-adversarial-next-job.md` [Adversarial critique  ## Verdict: **No** — not as a single Aristotle job in its current framing.  The proposal jumps two rungs at once. We just finished a deliberately conservative finite-combinatoria]

Score: `0.799`

```text
nsist on touching phase, pick the cleanest finite phase theorem we can actually state without new metrics:  ```lean namespace NullEdge.P1  /-- Phase accumulated along a closed finite null polygon     (returning to the starting vertex) is the identity on the fiber. -/ theorem closed_null_polygon_holonomy_trivial     (γ : NullPolygon) (hγ : γ.isClosed) :     transport γ = (1 : SU2) := by   sorry ```  This is a single, finite, convention-free statement (uses only SU(2) det-invariance from existing P1), it forecloses gauge inconsistencies before any "phase ∝ proper time" job can land, and it does not commit to a proportionality constant.  ---  ## Recommendation  Take **Candidate A** as the next Aristotle job. It is the smallest result that is both (i) genuinely new and (ii) cleanly downstream of yesterday's merge. Defer the Gemini "proper time from two null steps" proposal until after either P4 (mass readout) lands or Candidate B (closed-loop holonomy) lands — both are prerequisites it is currently borrowing without naming.
```

### 6. `Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md` [Layer 4: gauge curvature]

Score: `0.798`

```text
## Layer 4: gauge curvature

Gauge fields are holonomy defects over causal diamonds:

[
U_{\gamma_1}^{-1}U_{\gamma_2}
\sim
\exp\left(i\int_\Diamond F\right).
]

Non-Abelian fields likely require a basepointed/parallel-transported version; the higher-gauge version uses diamond 2-holonomies.
```

### 7. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Paper 3: causal diamonds as gauge-curvature carriers]

Score: `0.798`

```text
### Paper 3: causal diamonds as gauge-curvature carriers

Core contribution:

- trusted finite diamond holonomy model;
- Abelian gauge invariance of path-comparison defects;
- non-Abelian endpoint covariance and class-function invariance;
- vertical and horizontal composition laws for path-pair defects;
- continuum interpretation as a causal replacement for plaquettes;
- roadmap to higher-gauge versions.

Novelty:

- a clean graph-native gauge-curvature target compatible with causal DAGs.
```

### 8. `PhysicsSM/Draft/NullEdgeDiamondNonabelian.lean`

Score: `0.797`

```text
namespace PhysicsSM.Draft.NullEdgeDiamondNonabelian

open PhysicsSM.Draft.NullEdgeCore

variable {G : Type*}

/--
Under a vertex gauge transformation, the left branch holonomy is conjugated by
the bottom and top endpoint gauges.
-/
```

## Scoped paper hits

### 1. Connections on non-abelian Gerbes and their Holonomy

Score: `0.791`
URL: http://arxiv.org/abs/0808.1923

### 2. Twisted geometries: A geometric parametrisation of SU(2) phase space

Score: `0.754`
Zotero key: `63MQ6KC3`
arXiv: `1001.2748v3`
URL: http://arxiv.org/abs/1001.2748v3

Abstract:

Twisted-geometry parametrization of SU(2) loop-gravity phase space, including face areas, normals, extrinsic angle, gauge-invariant reduced phase space, and connection to closure/geometricity constraints.

### 3. Wilson loops in Ising lattice gauge theory

Score: `0.745`
Zotero key: `T2Z3STSB`
arXiv: `1811.09770`
URL: http://arxiv.org/abs/1811.09770

Abstract:

Wilson loop expectation in 4D $\mathbb{Z}_2$ lattice gauge theory is computed to leading order in the weak coupling regime. This is the first example of a rigorous theoretical calculation of Wilson loop expectation in the weak coupling regime of a 4D lattice gauge theory. All prior results are either inequalities or strong coupling expansions.

### 4. An invitation to higher gauge theory

Score: `0.742`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9

### 5. Spinors and Twistors in Loop Gravity and Spin Foams

Score: `0.741`
Zotero key: `TCC2N3U6`
arXiv: `1201.2120`
URL: http://arxiv.org/abs/1201.2120

Abstract:

Spinorial tools have recently come back to fashion in loop gravity and spin foams. They provide an elegant tool relating the standard holonomy-flux algebra to the twisted geometry picture of the classical phase space on a fixed graph, and to twistors. In these lectures we provide a brief and technical introduction to the formalism and some of its applications.
