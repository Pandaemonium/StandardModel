# Aristotle semantic context pack

Generated: 2026-07-14T21:03:06
Query: `null-edge finite Cartan torsion first Bianchi covariant derivative curvature coframe fixed labels torsion-free cyclic curvature`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/null-edge-finite-tetrad-postulate-report.md` [Remaining defect-classification work (out of scope here)]

Score: `0.780`

```text
## Remaining defect-classification work (out of scope here)

The audit branch of T15 — when the tetrad postulate *fails*, classifying the
surviving `Tframe` as nonmetricity / curvature-holonomy / torsion-like /
smooth-limit contamination (per `docs/NULLSTRAND.md`) — is a separate
modeling/audit task. It would require additional structure (metric, explicit
edge-transport maps, an `h`-scaling parameter) beyond the bare ring used here.
A natural next step is a concrete non-vanishing witness: an explicit small
ring (e.g. `2×2` matrices) with `[∇_a, C_b] ≠ 0` and `Tframe ≠ 0`, to
demonstrate the hypothesis is load-bearing.
```

### 2. `Sources/NullStrand_Open_Questions_For_Frontier_Models.md` [6.13.5 Frame term, tetrad postulate, and defect classification]

Score: `0.779`

```text
### 6.13.5 Frame term, tetrad postulate, and defect classification

The finite square decomposes as

```text
D_N^2 = Box_null + C_diamond + T_frame,
```

where

```text
Box_null  = 1/4 sum_{a,b} {C_a, C_b} {nabla_a, nabla_b},
C_diamond = 1/4 sum_{a,b} [C_a, C_b] [nabla_a, nabla_b],
T_frame   = sum_{a,b} C_a [nabla_a, C_b] nabla_b.
```

Thus

```text
D^2 = -Box_null - C_diamond - T_frame
      + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi].
```

The clean finite tetrad postulate is

```text
[nabla_a, C_b] = 0,
```

or, edgewise,

```text
U_a(x) C_b(y) U_a(x)^{-1} = C_b(x)
```

when labels are globally fixed. If local labels rotate, allow a rotation matrix among the `C_c`. Metric compatibility should be audited by `nabla_a {C_b, C_c} = 0`.

Failure modes split cleanly:

- If metric compatibility fails, the defect is nonmetricity or bad soldering.
- If metric compatibility holds but curvature commutators survive, the defect is curvature or holonomy.
- If edge parallelograms fail to close or antisymmetric displacement defects appear, the defect is torsion-like.
- If `C_b` jumps by order one across `h`-edges, then `T_frame` can contaminate the smooth limit at order `1/h`.
```

### 3. `AgentTasks/null-edge-finite-tetrad-postulate-report.md` [Setting (finite algebra, not continuum)]

Score: `0.778`

```text
## Setting (finite algebra, not continuum)

Operators are modeled as elements of an arbitrary, possibly non-commutative,
`Ring R`, indexed by a finite type `ι` (`[Fintype ι]`):

- `C : ι → R`  — finite Clifford / dual-soldered frame symbols `C_a = c(α^a)`;
- `nab : ι → R` — finite transports / connections `∇_a`.

Definitions follow the sign / decomposition convention fixed in
`docs/NULLSTRAND.md` (§ "Frame term and tetrad compatibility") and
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` §15.10, §17.4:

- `frameComm C nab a b = ∇_a C_b − C_b ∇_a`  ( the finite commutator `[∇_a, C_b]` );
- `Tframe   = ∑_{a,b} C_a [∇_a, C_b] ∇_b`;
- `Kplus    = ∑_{a,b} C_a C_b ∇_a ∇_b`  (combined kinetic + curvature block);
- `DN       = ∑_a C_a ∇_a`  (finite null Dirac operator `D_N`);
- `Boxnull  = ¼ ∑_{a,b} {C_a, C_b} {∇_a, ∇_b}`  (needs `[Invertible (4 : R)]`);
- `Cdiamond = ¼ ∑_{a,b} [C_a, C_b] [∇_a, ∇_b]`  (needs `[Invertible (4 : R)]`).

The **finite tetrad postulate** is `∀ a b, frameComm C nab a b = 0`, i.e.
`[∇_a, C_b] = 0` (edge-transport / frame compatibility).
```

### 4. `PhysicsSM/Draft/NullEdge/GoalIVReconciliationCapstone.lean` [source_equation_route_capstone]

Score: `0.778`

```text
HilbertTerm.D E) =
          Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dkin) + EinsteinHilbertTerm.Rfin E) ∧
      (∀ E : ℚ, EinsteinHilbertTerm.Rfin E = 4 * E + 2 * E ^ 2) ∧
      HasDerivAt (fun x : ℚ => Matrix.trace (EinsteinHilbertTerm.D x * EinsteinHilbertTerm.D x)) 0
        EinsteinHilbertTerm.Estar ∧
      EinsteinHilbertTerm.Estar =
        -Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dsold) /
          Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold) ∧
      0 < Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold)) ∧
    (TeleparallelSoldering.curvatureLoop = 1 ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
      (∀ g : TeleparallelSoldering.M,
        g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
      (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
        TeleparallelSoldering.nonmetricity TeleparallelSoldering.gGrav ≠ 0) ∧
      TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0) ∧
    ((TeleparallelSoldering.curvatureLoop = 1 ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
        (∀ g : TeleparallelSoldering.M,
          g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
        (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gPu
```

### 5. `PhysicsSM/Draft/NullEdge/SolderingLocalFrameCovariance.lean`

Score: `0.777`

```text
import Mathlib

/-!
# Finite soldering local-frame covariance

DRAFT (kernel-clean). This module closes the first finite geometric kill test on
the null-edge soldering interpretation. A rational vector-valued coframe avatar
has a transport defect that transforms covariantly under independent endpoint
frame changes, composes under refinement, and has an invariant quadratic action
for orthogonal frames. Closed-loop holonomy transforms by conjugation.

This is not yet a nondegenerate tetrad field, a continuum local-Lorentz theorem,
or a gravitational field equation. It validates only the displayed finite
transformation law and refinement algebra.

Provenance: clean-room finite linear-algebra formalization, with the coframe and
teleparallel transformation pattern checked against Baez--Wise,
arXiv:1204.4339. Aristotle job
`f34795b7-2aaa-4a5d-8932-9e43f7e7c81c` supplied the proof.
-/

open Matrix
```

### 6. `PhysicsSM/Draft/NullEdge/LambdaGravityCosmologyBridge.lean` [gravityUnificationStmt]

Score: `0.776`

```text
nHilbertTerm.Rfin E = 4 * E + 2 * E ^ 2) ∧
      HasDerivAt (fun x : ℚ => Matrix.trace (EinsteinHilbertTerm.D x * EinsteinHilbertTerm.D x)) 0
        EinsteinHilbertTerm.Estar ∧
      EinsteinHilbertTerm.Estar =
        -Matrix.trace (EinsteinHilbertTerm.Dkin * EinsteinHilbertTerm.Dsold) /
          Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold) ∧
      0 < Matrix.trace (EinsteinHilbertTerm.Dsold * EinsteinHilbertTerm.Dsold)) ∧
    (TeleparallelSoldering.curvatureLoop = 1 ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
      (∀ g : TeleparallelSoldering.M,
        g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
      (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
        TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
      (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
        TeleparallelSoldering.nonmetricity TeleparallelSoldering.gGrav ≠ 0) ∧
      TeleparallelSoldering.torsion TeleparallelSoldering.gFlat = 0) ∧
    ((TeleparallelSoldering.curvatureLoop = 1 ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav = !![0, 1 / 2; -1 / 2, 0] ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0) ∧
        (∀ g : TeleparallelSoldering.M,
          g = TeleparallelSoldering.torsion g + TeleparallelSoldering.nonmetricity g) ∧
        (TeleparallelSoldering.nonmetricity TeleparallelSoldering.gPure = 0 ∧
          TeleparallelSoldering.torsion TeleparallelSoldering.gPure ≠ 0) ∧
        (TeleparallelSoldering.torsion TeleparallelSoldering.gGrav ≠ 0 ∧
          TeleparallelSoldering.nonmetricity TeleparallelSoldering.g
```

### 7. `AgentTasks/null-edge-unified-mass-proof-chain.md` [T15. Frame/tetrad postulate and frame-term audit]

Score: `0.775`

```text
## T15. Frame/tetrad postulate and frame-term audit

- Informal: `T_frame = sum_{a,b} C_a [nabla_a, C_b] nabla_b` vanishes under the
  finite tetrad postulate `[nabla_a, C_b] = 0`; if it fails, classify the defect
  (nonmetricity, curvature/holonomy, torsion-like, or smooth-limit
  contamination).
- Formal shape:
  `theorem frame_term_vanishes (htetrad : forall a b, [nabla_a, C_b] = 0) :`
  `T_frame = 0`, plus a classification note (each branch as a separate lemma or
  documented case).
- Hypotheses: the finite tetrad postulate / edge-transport compatibility.
- Difficulty: medium.
- Dependencies: T14.
- Failure modes: hiding a surviving `O(h^{-1})` frame term in the continuum
  limit (the key contamination mode); claiming the postulate when the frame
  varies but transport does not carry it.
- Type: consistency check / audit (S).
- Aristotle: **Lean proof job** for the vanishing lemma (L, medium) + an
  **audit job** for the defect classification (Au).
```

### 8. `AgentTasks/context-packs/soldering-local-frame-covariance-20260709-1600-20260709-160142.md` [Frame term and tetrad compatibility]

Score: `0.774`

```text
## Frame term and tetrad compatibility

The finite square should be decomposed as:

```text
D_N^2 = Box_null + C_diamond + T_frame
```

with:

```text
Box_null  = 1/4 sum_{a,b} {C_a, C_b} {nabla_a, nabla_b}
C_diamond = 1/4 sum_{a,b} [C_a, C_b] [nabla_a, nabla_b]
T_frame   = sum_{a,b} C_a [nabla_a, C_b] nabla_b
```

The finite tetrad postulate is:

```text
[nabla_a, C_b] = 0
```

or the corresponding edge-transport compatibility equation. If this fails,
classify the defect rather than hiding it:

- Nonmetricity or bad soldering if metric compatibility fails.
- Curvature or holonomy if metric compatibility holds but connection
  commutators survive.
- Torsion-like defect if edge parallelograms fail to close or antisymmetric
  displacement defects appear.
- Smooth-limit contamination if `C_b` jumps by order one across `h`-edges.
```
```

## Scoped paper hits

### 1. Torsion Degrees of Freedom in the Regge Calculus as Dislocations on the Simplicial Lattice

Score: `0.729`
Zotero key: `IJ2MZ3FH`
arXiv: `gr-qc/0103111`
DOI: `10.1023/A:1013031402382`
URL: http://arxiv.org/abs/gr-qc/0103111

Abstract:

Using the notion of a general conical defect, the Regge Calculus is generalized by allowing for dislocations on the simplicial lattice in addition to the usual disclinations. Since disclinations and dislocations correspond to curvature and torsion singularities, respectively, the method we propose provides a natural way of discretizing gravitational theories with torsion degrees of freedom like the Einstein-Cartan theory. A discrete version of the Einstein-Cartan action is given and field equations are derived, demanding stationarity of the action with respect to the discrete variables of the theory.

### 2. Null twisted geometries

Score: `0.714`
Zotero key: `BC9Q4QNG`
arXiv: `1311.3279v2`
URL: http://arxiv.org/abs/1311.3279v2

Abstract:

Extends twisted-geometry/spin-network ideas to null hypersurfaces using twistors and ISO(2) little-group structure. Useful prior art for the null-edge P9 closure and null-horizon geometry lane.

### 3. Connections on non-abelian Gerbes and their Holonomy

Score: `0.700`
URL: http://arxiv.org/abs/0808.1923

### 4. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.700`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.

### 5. Discrete Exterior Calculus

Score: `0.697`
Zotero key: `8XEX66QJ`
arXiv: `math/0508341`
URL: https://www.zotero.org/19894138/items/8XEX66QJ
