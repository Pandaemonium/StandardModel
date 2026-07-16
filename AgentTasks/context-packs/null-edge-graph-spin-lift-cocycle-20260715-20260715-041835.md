# Aristotle semantic context pack

Generated: 2026-07-15T04:19:01
Query: `null edge graph spin structure central sign SL2C double cover edge lifts vertex gauge Z2 cycle parity square face cocycle Stiefel Whitney tetrad Lorentz`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/PhotonSingleEdge.lean` [edgesSpin1]

Score: `0.787`

```text
def edgesSpin1 (m2 : ℚ) : ℕ := if m2 = 0 then 1 else 2

/-! ## The photon: a single null edge -/

/-- Photon momentum `k = (1,1,0,0)`: null and nonzero. -/
```

### 2. `PhysicsSM/Draft/NullEdge/NonabelianHistoryClosureHolonomy.lean` [squareEdgeField]

Score: `0.779`

```text
def squareEdgeField : EdgeField (Fin 4) (Matrix (Fin 2) (Fin 2) ℚ)ˣ :=
  fun x y =>
    if x = 0 ∧ y = 1 then shearUp
    else if x = 1 ∧ y = 2 then shearDown
    else 1

/-- A nonidentity gauge change concentrated at the loop basepoint. -/
```

### 3. `PhysicsSM/Draft/NullEdge/HermitianSpinLiftBoundary.lean`

Score: `0.779`

```text
import PhysicsSM.NullStrand.Conventions
import PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary

/-!
# Hermitian local spin-lift boundary

This module closes the interpretation gap identified in the first local sign
witness. The trusted `PhysicsSM.NullStrand.Conventions` module already supplies
the `(+---)` Pauli/Hermitian lift, its determinant/Minkowski-norm identity, and
determinant preservation under `SL(2, C)` congruence.

Here the actual Hermitian action is

```text
X |-> A X A^dagger.
```

It preserves Hermitian matrices. The matrices `A` and `-A` have the same action,
and in dimension two they have the same determinant. On spinors their actions
differ by a sign, hence differ whenever the transformed spinor is nonzero.

This is the local algebra underlying the kernel `{+1,-1}` of the standard
spin-to-Lorentz map. It does not prove that every proper orthochronous Lorentz
transformation has a lift, identify the full kernel as a group theorem,
construct compatible lifts on graph edges and faces, or establish a global spin
```

### 4. `PhysicsSM/Draft/NullEdgeCoreAristotle.lean` [targets]

Score: `0.777`

```text
import Mathlib

/-!
# Draft.NullEdgeCoreAristotle

Aristotle handoff for the highest-leverage finite theorem targets in the
null-edge causal graph program.

Source notes:
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md`
- `Sources/Luminal_Motion_Checkerboard_Research_Program.md`

The goal is not to formalize a full continuum theory.  This file isolates
three finite, kernel-checkable theorem islands that directly support the
program:

1. Pluecker mass: a two-edge bundle of complex null spinors has determinant
   mass equal to the squared spinor wedge.
2. Causal-diamond holonomy: the Abelian path-comparison defect is invariant
   under vertex gauge transformations.
3. Order-complex seed: the alternating boundary on formal simplices squares
   to zero, the combinatorial start of a graph-native Kahler-Dirac branch.

All statements below are draft targets for Aristotle.  They may contain
documented `s o r r y`s here, and should not be moved to trusted code until the
proofs are reviewed, placeholder-free, and the convention choices are checked.
-/
```

### 5. `AgentTasks/context-packs/history-u1-closure-holonomy-20260709-1630-20260709-163241.md` [1. `PhysicsSM/Draft/NullEdgePhysicsBridgeAristotle.lean` [exactEdgePhase]]

Score: `0.775`

```text
### 1. `PhysicsSM/Draft/NullEdgePhysicsBridgeAristotle.lean` [exactEdgePhase]

Score: `0.806`

```text
def exactEdgePhase {V G : Type*} [Group G]
    (a : V -> G) (e : OrientedEdge V) : G :=
  (a e.source)⁻¹ * a e.target

/--
The smallest closed exact path has trivial holonomy.  This is the finite
seed of "exact 1-cochains are gauge-null on cycles".
-/
```
```

### 6. `AgentTasks/null-edge-furey-gauge-integration-strategy-aristotle-2026-06-26.md` [Relevant files and modules]

Score: `0.774`

```text
.lean
PhysicsSM/Gauge/StandardModelProductCoveringTrueQuotientSMBlock.lean
PhysicsSM/Gauge/StandardModelCoverageImageSMBlock.lean
PhysicsSM/Gauge/QunitQubitQutritQuotientRepresentation.lean
```

Null-edge / Furey bridge side:

```text
PhysicsSM/Draft/NullEdgeInternalSpectrum.lean
PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean
PhysicsSM/Draft/NullEdgeFureyChiE.lean
PhysicsSM/Draft/NullEdgeFureyOccupationParityChiE.lean
PhysicsSM/Draft/NullEdgeFureyPhiH.lean
PhysicsSM/Draft/NullEdgeFureyAlmostCommutativeProduct.lean
PhysicsSM/Draft/NullEdgeFureyEWStabilizerComparison.lean
PhysicsSM/Draft/NullEdgeSuperDiracSignBridge.lean
PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean
PhysicsSM/Draft/NullEdgeFMSFiniteComposite.lean
PhysicsSM/Draft/NullEdgeFMSCompositeObservableNext.lean
```

Null-edge Gate C / branch safety side:

```text
PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean
PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean
PhysicsSM/Draft/NullEdgeProjectedBranchChirality.lean
PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean
PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean
PhysicsSM/Draft/NullEdgeCanonicalSpeciesSelector.lean
PhysicsSM/Draft/NullEdgeKreinLockOrigin.lean
PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean
PhysicsSM/Draft/NullEdgeProjectedGhostSafety.lean
PhysicsSM/Draft/NullEdgeSpectralGraphNodalSet.lean
PhysicsSM/Draft/NullEdgeNodalSetExhaustion.lean
```

Planning docs:

```text
Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md
Sources/NullStrand_Lean_Roadmap_Improved.md
AgentTasks/null-edge-aristotle-ambitious-job-backlog-2026-06-26.md
```
```

### 7. `PhysicsSM/Draft/NullEdgePhysicsBridgeAristotle.lean` [exactEdgePhase]

Score: `0.773`

```text
def exactEdgePhase {V G : Type*} [Group G]
    (a : V -> G) (e : OrientedEdge V) : G :=
  (a e.source)⁻¹ * a e.target

/--
The smallest closed exact path has trivial holonomy.  This is the finite
seed of "exact 1-cochains are gauge-null on cycles".
-/
```

### 8. `AgentTasks/aristotle-wave10-20260626/c21-actual-clifford-symbol-branch-chirality/PROMPT.md` [Null-edge Aristotle Wave 10 common context]

Score: `0.770`

```text
# Null-edge Aristotle Wave 10 common context

Date: 2026-06-26.

Repository: C:\Projects\StandardModel, Lean 4 / Mathlib project. Follow AGENTS.md and docs/ARISTOTLE.md. The Lean kernel is the source of truth. Do not weaken theorem statements to get a proof. If a statement is false, underspecified, or convention-mismatched, return a precise blocker and proposed corrected statement.

Wave 8 and Wave 9 status supplied by Claude/user:
- Gate A bridge exists and has now been used in `PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean`.
- The finite super-Dirac square is assembled: `D^2 = -K_null - C_diamond - T_frame + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi]`, plus named Gate-A hypothesis and tetrad-postulate specializations.
- Scalar/gauge/Higgs null quadrature is assembled in `PhysicsSM/Draft/NullEdgeScalarGaugeNullQuadrature.lean`, including the guardrail that the naive positive edge-sum appears only in the doubly diagonal Euclidean/orthonormal case.
- Trusted Plucker Spinor files now carry convention/provenance banners and should be treated as promotion-ready, subject to normal integration review.
- `PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean` is useful but its own adversarial verdict says it is consistency/reconstruction, not a prediction.
- `PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean` proves Gate C is PENDING, not RELEASED. It isolates the remaining obligation as `OperatorForcesAlignment`: the actual flat tetrahedral Clifford symbol must assign the aligned chirality sign to each branch zero mode.
- The current branch files contain scalar quadratic-form data, but the actual 4x4 Clifford symbol and per-branch kernel/chirality computation are not yet formalized.
- c20 massive branch lifting is still running. Avoid duplicating c20; use its eventu
```

## Scoped paper hits

### 1. Spinors and Twistors in Loop Gravity and Spin Foams

Score: `0.743`
Zotero key: `TCC2N3U6`
arXiv: `1201.2120`
URL: http://arxiv.org/abs/1201.2120

Abstract:

Spinorial tools have recently come back to fashion in loop gravity and spin foams. They provide an elegant tool relating the standard holonomy-flux algebra to the twisted geometry picture of the classical phase space on a fixed graph, and to twistors. In these lectures we provide a brief and technical introduction to the formalism and some of its applications.

### 2. Null twisted geometries

Score: `0.737`
Zotero key: `BC9Q4QNG`
arXiv: `1311.3279v2`
URL: http://arxiv.org/abs/1311.3279v2

Abstract:

Extends twisted-geometry/spin-network ideas to null hypersurfaces using twistors and ISO(2) little-group structure. Useful prior art for the null-edge P9 closure and null-horizon geometry lane.

### 3. Twisted geometries: A geometric parametrisation of SU(2) phase space

Score: `0.730`
Zotero key: `63MQ6KC3`
arXiv: `1001.2748v3`
URL: http://arxiv.org/abs/1001.2748v3

Abstract:

Twisted-geometry parametrization of SU(2) loop-gravity phase space, including face areas, normals, extrinsic angle, gauge-invariant reduced phase space, and connection to closure/geometricity constraints.

### 4. Two-twistor particle models and free massive higher spin fields

Score: `0.726`
Zotero key: `zotero:MFUJKFEA`
arXiv: `1409.7169`
DOI: `10.1007/JHEP04(2015)010`
URL: https://doi.org/10.1007/JHEP04(2015)010

### 5. Massive twistor particle with spin generated by Souriau-Wess-Zumino term and its quantization

Score: `0.722`
Zotero key: `arxiv:1403.4127`
arXiv: `1403.4127`
DOI: `10.1016/j.physletb.2014.04.059`
URL: http://arxiv.org/abs/1403.4127

Abstract:

Two-twistor action for a massive spinning particle with Souriau-Wess-Zumino spin term; includes spin-dependent twistor shift modifying standard Penrose incidence relations.
