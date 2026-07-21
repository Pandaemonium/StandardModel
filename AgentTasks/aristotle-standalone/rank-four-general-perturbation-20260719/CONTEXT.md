# Aristotle semantic context pack

Generated: 2026-07-19T20:37:07
Query: `finite dimensional self adjoint operator spectral projector rank four stability operator norm perturbation Davis Kahan Riesz projection`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [53. Integrated Aristotle update: C228-C230 source, island, and analogy audits]

Score: `0.853`

```text
four obligations:

```text
O1 finite spectral-island persistence;
O2 Riesz projection existence/stability;
O3 Davis-Kahan quantitative subspace-rotation bound;
O4 branch-line chiral-index persistence.
```

Finite-first work:

```text
projector conjugation invariance;
trace-cyclicity;
integrality of chiral index;
integer-continuity / locally constant index on connected intervals.
```

Analytic/source-contract work:

```text
Kato/Riesz projector construction and continuity for isolated spectral
islands;
Davis-Kahan bounds for quantitative projector rotation;
homotopy survival of the target spectral island.
```

C229 found an important API warning:

```text
An IsRieszProjector fingerprint of "idempotent + commuting + equal rank" is
underdetermined. It does not prove uniqueness.
```

Therefore the future Riesz/projector API must include a real spectral/range
condition, not just rank and commutation data.

C230 audited Watterson's Dirac-Kahler chiral/flavour projection paper. Decision:

```text
PARK as analogy only.
```

Useful lesson:

```text
simultaneous chiral/flavour projection requires projector-commutation and
dual-complex bookkeeping care.
```

No-overclaim boundary:

```text
Dirac-Kahler projection does not supply the null-edge operator, does not replace
Wilson/Neuberger spacetime doubler resolution, does not provide a true
bad-sector inverse gap, and does not prove anomaly/determinant/Krein safety.
```

Status boundary:

```text
C228-C230 outputs are integrated as planning/source-contract guidance.
No C228-C230 Lean artifacts were promoted into the live repo in this pass.
No local Lean checks were run.
```
```

### 2. `AgentTasks/aristotle-prompts/gate-c1-riesz-projector-strengthening-c233.prompt.md`

Score: `0.846`

```text
Gate C1 strengthened Riesz-projector API, C233

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C229 found that a weak `IsRieszProjector` fingerprint:

```text
idempotent + commuting + equal rank
```

is underdetermined and cannot prove uniqueness. For example, a zero operator
can admit many rank-matched idempotents. Therefore the Gate C1 spectral-island
API must carry real spectral/range data.

Task:

Design the strengthened Riesz/spectral-projector API needed for the C175
branch-line lift.

Please answer:

1. What minimum finite-dimensional data makes a spectral projector unique?
2. Should the API use:
   range equals generalized eigenspace;
   polynomial spectral projector;
   contour/Riesz projector source contract;
   spectral set membership;
   or another condition?
3. What finite Lean theorem should be proved first before analytic Kato/Davis-
   Kahan source contracts?
4. How should this connect to `MaintainedIsland.persistence` and
   `OperatorFreeze.frozen_gappedHomotopic_of_budget`?
5. What theorem names and structures should Codex add next?
6. What overclaims must be blocked?

Claim boundaries:

```text
Riesz/projector persistence does not prove spacetime no-doubling.
It does not create chiral polarization from a balanced origin kernel.
It does not prove anomaly, determinant-line, Krein, gauge, or ghost safety.
```

Requested output:

- strengthened API proposal;
- exact finite-first theorem statements;
- analytic source-contract placeholders;
- connection theorem to C194/C202/C227;
- no-overclaim checklist.
```

### 3. `AgentTasks/aristotle-prompts/gate-c1-spectral-island-source-api-c229.prompt.md`

Score: `0.800`

```text
Gate C1 spectral-island stability source/API audit, C229

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Current architecture:

```text
Wilson/Neuberger overlap reference
  with CKM as an internal branch/flavor mass texture,
  not as the primary spacetime doubler-resolution operator.
```

The free Gate C1 stack has these current layers:

```text
C193/C201:
  Wilson+CKM mass window and sign stability with margin gamma_free.

C194:
  kappa < gap gives a gapped homotopy.

C202:
  maintained spectral island / projector persistence scaffold.

C175 target:
  branch-line lift using Riesz/Kato-style spectral projectors.
```

Task:

Build a source and API plan for the spectral-island/projector-persistence layer.

Please answer:

1. What exact theorem obligations should be separated between:
   finite-dimensional spectral-island persistence,
   Riesz projection stability,
   Davis-Kahan quantitative subspace bounds,
   and branch-line chiral-index persistence?
2. Which parts should be treated as purely finite Lean algebra first?
3. Which parts require analytic source contracts such as Kato perturbation
   theory or Davis-Kahan?
4. What Lean structures/predicates should Codex add after the current Draft
   leaves compile?
5. What theorem should connect the gapped homotopy result to a stable physical
   branch projector?
6. What must not be claimed from projector persistence alone?

Claim boundaries:

```text
Projector persistence does not prove spacetime no-doubling.
Projector persistence does not prove anomaly or determinant-line control.
Projector persistence does not by itself prove Krein positivity.
The bare null-edge branch kernel remains chirality-balanced unless a separate
polarizing projector is constructed.
```

Requested output:

- source-to-obli
```

### 4. `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [30. C231 and C233 update: live-port hygiene and stronger spectral projector data]

Score: `0.794`

```text
## 30. C231 and C233 update: live-port hygiene and stronger spectral projector data

Date: 2026-06-28
Source: completed Aristotle jobs C231 and C233.

C231 confirms the `OperatorFreeze` port is structurally right but still
unverified live:

```text
OperatorFreeze depends only on CKMWilsonWindow, GappedHomotopy, and
SignStability.
It does not need ProjectorPersistence.
Its namespace risk is low.
The live PhysicsSM.Draft.NullEdge.GateC1 import prefix remains to be verified
by a local Lean check.
```

Applied local fix:

```text
Demoted the stale duplicate doc comment before
chiralIndex_zero_of_rank_balanced in ProjectorPersistence.
```

C233 replaces the weak Riesz projector fingerprint:

```text
idempotent + commuting + equal rank
```

with the stronger uniqueness data:

```text
range equals the target generalized-eigenspace sum;
kernel equals the complementary generalized-eigenspace sum.
```

Do not port C233's standalone Lean artifact verbatim:

```text
it uses names under GateC1.OperatorFreeze that would collide with the C227
OperatorFreeze API.
```

Instead, future local work should create a deliberately named module:

```text
SpectralProjectorAPI.lean
```

with:

```text
eq_of_isIdempotent_range_ker;
weak_fingerprint_not_unique;
IsSpectralProjector with range/kernel spectral data;
IsSpectralProjector.unique.
```

Status:

```text
No live Lean checks were run.
The next verification request should check the Draft GateC1 leaves and
OperatorFreeze before adding an aggregator.
```
```

### 5. `AgentTasks/aristotle-prompts/gate-c1-spectralprojectorapi-live-port-c234.prompt.md`

Score: `0.792`

```text
Gate C1 live-safe SpectralProjectorAPI port, C234

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C233 produced a strong Riesz/spectral-projector API, but Codex did not port the
Lean file verbatim because it used names under `GateC1.OperatorFreeze`, which
would collide conceptually with the C227 `OperatorFreeze` API.

Task:

Design and, if feasible, rewrite the C233 artifact into a live-safe Draft module
with a non-colliding namespace:

```text
PhysicsSM/Draft/NullEdge/GateC1/SpectralProjectorAPI.lean
namespace GateC1.SpectralProjectorAPI
```

Included context:

```text
C233_RieszProjectorAPI_design.md;
RieszProjectorAPI.lean;
OperatorFreeze.lean;
ProjectorPersistence.lean.
```

Requirements:

1. Preserve the C233 finite-first theorem:

   ```text
   eq_of_isIdempotent_range_ker
   ```

2. Preserve the C233 regression guard:

   ```text
   weak_fingerprint_not_unique
   ```

3. Preserve the strengthened contract:

   ```text
   IsSpectralProjector A P S
   ```

   with range/kernel generalized-eigenspace data.

4. Preserve uniqueness:

   ```text
   IsSpectralProjector.unique
   ```

5. Do not define any theorem under `GateC1.OperatorFreeze`.

6. If connecting to `OperatorFreeze`, use a distinct theorem name or a source
   contract structure that imports `OperatorFreeze` safely.

7. Keep all claims Draft/local. Do not claim GateC1_NU.

Requested output:

- live-safe module text or patch plan;
- exact import list;
- namespace and theorem-name plan;
- any Lean risks;
- no-overclaim checklist.
```

### 6. `PhysicsSM/Draft/NullEdge/EquivariantProbeSectorSelector.lean` [RankFourProbeProjector]

Score: `0.791`

```text
structure RankFourProbeProjector
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) where
  project : carrierProbeSubspace A →ₗ[ℝ] carrierProbeSubspace A
  idempotent : project.comp project = project
  range_finrank_eq_four : Module.finrank ℝ (LinearMap.range project) = 4

/-- The range of a rank-four projector is a corrected carrier probe sector. -/
```

### 7. `AgentTasks/context-packs/hermitian-exp-lipschitz-20260712-172228.md` [Purpose]

Score: `0.785`

```text
## Purpose

Ask Aristotle to investigate the scoped `Matrix.Norms.L2Operator` route for
unitary stability of the checkerboard one-step symbol. This is independent of
the running L-infinity operator-norm jobs and may give the cleanest stability
fact: unitary one-step evolution should have operator norm `1`.
```
```

### 8. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [58. Integrated Aristotle update: C238 Null-Edge Overlap strategy audit]

Score: `0.781`

```text
s;
6. anomaly/source contract;
7. path-sum convergence.
```

Reuse priority:

```text
SpectralProjectorAPI:
  highest priority for sign/projector identities.

SignStability:
  sign stability under perturbations once a gap exists.

OperatorFreeze:
  parameter-window and budget language.

ProjectorPersistence and GappedHomotopy:
  persistence and homotopy support.

BranchKernelChiralIndexZero:
  negative control showing what the bare balanced branch cannot do.

CKMWilsonWindow:
  useful as a mass-window template only; keep CKM quarantined from spacetime
  doubler resolution.
```

Updated work queue:

```text
1. Prove the abstract Hermitian-kernel theorem.
2. Prove conditional sign/GW algebra under sign(H)^2 = 1.
3. Prove or refute the tetrahedral branch/gap claim.
4. Add M_br only if scalar Wilson leaves a residual light branch.
5. Keep the retarded/advanced dilation as a separate path-sum bridge, not as
   the first overlap kernel.
6. Wrap the result with SignStability/OperatorFreeze only after T1-T3.
```

Status boundary:

```text
C238 is strategy/audit integration only.
No live Lean verification was performed.
No GateC1_NU theorem is claimed.
```
```

## Scoped paper hits

### 1. The Abstract Hodge--Dirac Operator and Its Stable Discretization

Score: `0.730`
Zotero key: `X748RBM8`
DOI: `10.1137/15m1047684`
URL: https://www.zotero.org/19894138/items/X748RBM8

Abstract:

This paper adapts the techniques of finite element exterior calculus to study and discretize the abstract Hodge--Dirac operator, which is a square root of the abstract Hodge--Laplace operator considered by Arnold, Falk, and Winther [Bull. Amer. Math. Soc., 47 (2010), pp. 281--354]. Dirac-type operators are central to the field of Clifford analysis, where recently there has been considerable interest in their discretization. We prove a priori stability and convergence estimates, and show that several of the results in finite element exterior calculus can be recovered as corollaries of these new estimates. (A corrected version is attached.)

### 2. Discrete approximations to Dirac operators and norm resolvent convergence

Score: `0.718`
Zotero key: `JMGCEG8U`
arXiv: `2203.07826`
DOI: `10.4171/JST/438`
URL: http://arxiv.org/abs/2203.07826

Abstract:

We consider continuous Dirac operators defined on $\mathbf{R}^d$, $d\in\{1,2,3\}$, together with various discrete versions of them. Both forward-backward and symmetric finite differences are used as approximations to partial derivatives. We also allow a bounded, Hölder continuous, and self-adjoint matrix-valued potential, which in the discrete setting is evaluated on the mesh. Our main goal is to investigate whether the proposed discrete models converge in norm resolvent sense to their continuous counterparts, as the mesh size tends to zero and up to a natural embedding of the discrete space into the continuous one. In dimension one we show that forward-backward differences lead to norm resolvent convergence, while in dimension two and three they do not. The same negative result holds in all dimensions when symmetric differences are used. On the other hand, strong resolvent convergence holds in all these cases. Nevertheless, and quite remarkably, a rather simple but non-standard modification to the discrete models, involving the mass term, ensures norm resolvent convergence in general.

### 3. The Spectral Action Principle

Score: `0.717`
Zotero key: `6WURA7MF`
DOI: `10.1007/s002200050126`
URL: https://doi.org/10.1007/s002200050126

### 4. On Noncommutative and semi-Riemannian Geometry

Score: `0.715`
Zotero key: `F877GT5B`
arXiv: `math-ph/0110001`
DOI: `10.48550/arXiv.math-ph/0110001`
URL: https://arxiv.org/abs/math-ph/0110001

Abstract:

Introduces semi-Riemannian spectral triples using Krein spaces and Krein-selfadjoint Dirac operators, with recovery of signature data from spectral data.

### 5. Collapse in Noncommutative Geometry and Spectral Continuity

Score: `0.715`
Zotero key: `EGS9MMTM`
arXiv: `2404.00240`
URL: http://arxiv.org/abs/2404.00240

Abstract:

If two compact quantum metric spaces are close in the metric sense, then how similar are they, as noncommutative spaces? In the classical realm of Riemannian geometry, informally, if two manifolds are close in the Gromov-Hausdorff distance, and belong to a class of manifolds with bounded curvature and diameter, then the spectra of their Laplacian or Dirac operators are also close under many scenari. Of particular interest is the case where a sequence of manifolds converge for the Gromov-Hausdorff distance to a manifold of lower dimension, and the question of the continuity, in some sense, of the spectra of geometrically relevant operators. In this paper, we initiate the study of the continuity of spectra and other properties of metric spectral triples under collapse in the noncommutative realm. As a first step in this study, we work with collapse for the spectral propinquity, an analogue of the Gromov-Hausdorff distance for spectral triples introduced by the second author, i.e. a form of metric for differential structures. Inspired by results from collapse in Riemannian geometry, we begin with the study of spectral triples which decompose, in some sense, in a vertical and a horizontal direction, and we collapse these spectral triples along the vertical direction. We obtain convergence results, and by the work of the second author, we conclude continuity results for the spectra of the Dirac operators of these spectral triples. Examples include collapse of product of spectral triples with one Abelian factor, $U(1)$ principal bundles over Riemannian spin manifolds, and noncommutative principal bundles, including C*-crossed-products and other noncommutative bundles.
