# Aristotle semantic context pack

Generated: 2026-07-06T22:39:06
Query: `post-flatness Q_C leading carrier bridge contract QCLeading leadingClosureFluxCoeff torus plaquetteCurvature nabla_commute_of_plaquetteCurvature_zero`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdgeP3SurfaceHolonomy.lean` [Curv]

Score: `0.794`

```text
abbrev Curv (m n : Nat) := Fin m -> Fin n -> Real

/-- Surface holonomy = sum of plaquette curvatures. -/
```

### 2. `AgentTasks/model-calls/claude/2026-06-24-round-021-constructive-next-target.md` [Round 021 Recommendation: Pivot to P2/P3 Super-Dirac Bridge (Candidate 2)  ## Top-line call  **Stop extending the generic P2 reflection-product ladder.** The 4-reflection counterexample (`trace(AAAA)=]

Score: `0.789`

```text
product equals 1*, i.e. iff the two branch legs match on the (helicity-momentum, mass) bilinear at the diamond corners. That is the finite analogue of "flat parallel transport around a null plaquette" without invoking a continuum connection.  ### Failure / demotion mode  - **Primary failure**: the existing `diamondRight` (or whatever it is named in `NullEdgeSuperDiracDiamondCurvature`) is parameterized in variables that do *not* algebraically match `(h1 h2 p1 p2 + m1 m2)/(E1 E2)` without an additional substitution. **Demotion**: turn the job into an audit/design job that produces the explicit substitution map (one Lean `def` + one `example` showing the substitution lands in the right normal form). That alone unblocks a future round. - **Secondary failure**: the bridge holds only up to a sign tied to reflection-count parity (we already know parity is the only determinant invariant). **Demotion**: state the bridge for *even* reflection count and record the odd case as a separate one-line corollary.  ### Source / literature check  Cross-check against **Kauffman & Noyes / Bialynicki-Birula-style discrete checkerboard-Dirac literature**, specifically the formulation where a 2x2 step matrix's trace over a closed null plaquette gives the discrete curvature/holonomy phase (see also Arrighi–Nesme–Forets, *Discrete Lorentz covariance for quantum walks*, J. Phys. A, for the trace-as-holonomy framing on null plaquettes). The check we need: confirm that in that literature the *normalized* plaquette trace, not the raw product, is what plays the role of holonomy. If yes, our normalization-by-2 is the right one and the bridge lemma is the standard finite-walk fact in our API; if the literature uses a determinant-normalized version instead, we should adjust the bridge to `trace / (2 *
```

### 3. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [0a. Spinor irrep table and Bivector/BF wrapper]

Score: `0.776`

```text
i^dagger)`. The diamond theorem
says the curvature carrier composes correctly under vertical and horizontal
gluing. The next target is to put these in one finite API only after the
representation labels above are attached, and then prove that the
`B`-weighted diamond pairing respects those gluing laws.

The Plebanski/BF interpretation is valuable motivation: continuum gravity can
be phrased using a two-form `B` paired with curvature, with simplicity
constraints and Urbantke metric reconstruction. But in this project that
belongs behind an explicit claim boundary, especially because Lorentzian
self-dual two-forms require complexification and reality conditions (the
area-metric reality constraint, Maran, arXiv:gr-qc/0504091).

The Klein quadric is the honest geometric meeting point. In
`Lambda^2 C^4`, a bivector is decomposable exactly when its Pluecker
coordinates obey the quadratic Klein relation. In twistor language this is the
quadric of 2-planes; in spin-foam language the nearby condition is simplicity;
in the two-edge null-spinor chart the discriminant/repeated-principal-spinor
condition reduces to the same scalar Pluecker invariant that controls
`det(P)`. Thus the finite slogan should be:

```text
decomposable bivector <-> Pluecker relation <-> Klein quadric <-> simplicity
```

This is strongest as a pairwise theorem. For a bundle with more than two null
edges, `P = sum_i psi_i psi_i^dagger` is a sum of rank-one momenta, not one
simple bivector. The multi-edge reconciliation should therefore pass through a
closure/Gauss-law statement such as `sum_f B_f = 0`, plus simplicity of the
individual faces, rather than pretending the whole bundle is one simple
bivector.

A clean finite target sits inside this picture: a 2-form `B` is simple (a
single wedge `u wedge v`) iff
```

### 4. `PhysicsSM/Draft/NullEdgeP3SurfaceHolonomy.lean`

Score: `0.773`

```text
import Mathlib.Tactic

/-!
# P3 higher-gauge: abelian surface holonomy, interchange, and fake-flatness

The finite abelian shadow of the trusted non-abelian path-pair interchange law
(`PhysicsSM.Gauge.CausalDiamondHolonomy`). On a grid of 2-cells with `Real`
(abelian 2-group) curvature labels, the surface holonomy is the sum of plaquette
curvatures; it is independent of the composition order (interchange), additive
under 2-cell composition, and trivial for a fake-flat (flat 2-)connection.

Source grounding (Neo4j null-edge collection): Baez, "Higher Yang-Mills theory"
(`hep-th/0206130`); higher-gauge / crossed-module 2-connections.

Standalone (Mathlib only).
-/
```

### 5. `AgentTasks/null-edge-grand-strategy-v2-output.md` [4. Do-not-submit-yet list (attractive but underspecified)]

Score: `0.770`

```text
clearly conditional.
7. **Full twistor incidence / Penrose transform.** Current twistor results are
   chart-level wrappers; projective incidence, reality structures, and
   cohomology are not in scope and not in mathlib. Do not open as a proof job.
8. **Continuum / universality Dirac limit.** "Random null-edge flip ensembles
   flow to a Dirac operator with effective mass" is the central open *physics*
   conjecture and an analytic limit; it is a Stage-3/4 pilot, not a finite
   Aristotle theorem.
9. **`Sym²S` self-dual curvature reused as the Pluecker bracket.** A convention
   trap flagged by the irrep table: keep `Λ²S` (scalar bracket) and `Sym²S`
   (curvature) apart; conflating them produces statements that change under a
   convention audit.
10. **Surface-label interchange in D before checking it.** Prove (or refute) the
    crossed-module surface equality; if it fails, bank the obstruction. Do not
    pre-assume a 2-group structure.

---
```

### 6. `PhysicsSM/Draft/Sedenions/AnomalyCancellationAnalogue.lean` [totalCubicAnomaly]

Score: `0.768`

```text
def totalCubicAnomaly (q : Nat → Int) : Int :=
  zeroProductSupportWords.foldl (fun acc w => acc + cubicAnomaly q w) 0

/-- The "balanced" charge assignment: +1 for low indices 1–7,
    −1 for high indices 9–15, 0 for the forced-zero coordinates 0 and 8.
    This is the simplest charge assignment that respects the low/high
    symmetry of the plaquette system. -/
```

### 7. `AgentTasks/aristotle-downloads-wave12-13-20260626/c58-projected-branch-weyl-projector/c58-projected-branch-weyl-projector_aristotle/AgentTasks/null-edge-aristotle-ambitious-job-backlog-2026-06-26.md` [Gate D: continuum symbol, square limit, curvature, and scalar/gauge kinetics]

Score: `0.767`

```text
## Gate D: continuum symbol, square limit, curvature, and scalar/gauge kinetics

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| D1 | Next | Proof | Smooth local symbol asymptotic `[D_h, M_f] = c(df) + O(h)` in a simplified finite-difference model. | First true continuum estimate beyond affine algebra. | `PhysicsSM/Draft/NullEdgeSmoothSymbolAsymptotic.lean` |
| D2 | Next | Strategy | Estimate framework selection: filters, asymptotic notation, or normed finite-difference API. | Prevents continuum jobs from drowning in analysis infrastructure. | `AgentTasks/null-edge-continuum-estimate-framework.md` |
| D3 | Future | Proof | Curvature diamond coefficient theorem in a flat-to-curved perturbative model. | Tests whether `C_diamond` has the right Pauli/curvature normalization. | `PhysicsSM/Draft/NullEdgeCurvatureDiamond.lean` |
| D4 | Future | Proof | Finite holonomy around null diamonds gives gauge curvature to leading order. | Bridges graph holonomy to continuum field strength. | `PhysicsSM/Draft/NullDiamondHolonomyCurvature.lean` |
| D5 | Future | Proof | Frame-term classification theorem under controlled frame variation. | Distinguishes tetrad defect, torsion-like term, and bad continuum contamination. | `PhysicsSM/Draft/NullEdgeFrameDefectClassification.lean` |
| D6 | Future | Audit | Lichnerowicz comparison audit: exact target formula and convention map. | Prevents false continuum claims and fixes signs before proof work. | `AgentTasks/null-edge-lichnerowicz-comparison-audit.md` |
| D7 | Future | Proof | Commuting-square theorem in the flat scalar case. | First prototype for `D_h^2 -> D_cont^2`. | `PhysicsSM/Draft/FlatContinuumSquareLimit.lean` |
| D8 | Future | Proof | Scalar/gauge kinetic continuum limit from
```

### 8. `PhysicsSM/Draft/NullEdgeP3SurfaceHolonomy.lean` [surfaceHolonomy_add]

Score: `0.763`

```text
theorem surfaceHolonomy_add {m n : Nat} (F G : Curv m n) :
    surfaceHolonomy (fun i j => F i j + G i j)
      = surfaceHolonomy F + surfaceHolonomy G := by
  simp only [surfaceHolonomy, Finset.sum_add_distrib]

/-- Fake-flatness: a flat 2-connection has trivial surface holonomy. -/
```

## Scoped paper hits

### 1. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.738`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 2. Higher gauge theory

Score: `0.736`
DOI: `10.1090/conm/431/08264`
URL: https://doi.org/10.1090/conm/431/08264

### 3. Connections on non-abelian Gerbes and their Holonomy

Score: `0.727`
URL: http://arxiv.org/abs/0808.1923

### 4. Discrete Exterior Calculus

Score: `0.727`
Zotero key: `8XEX66QJ`
arXiv: `math/0508341`
URL: https://www.zotero.org/19894138/items/8XEX66QJ

### 5. An invitation to higher gauge theory

Score: `0.724`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9
