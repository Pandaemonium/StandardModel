# Aristotle semantic context pack

Generated: 2026-07-14T23:17:22
Query: `null edge refinement area normalized diamond holonomy curvature convergence differential Bianchi componentwise limit contracted Einstein divergence`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean`

Score: `0.910`

```text
import Mathlib
import PhysicsSM.Draft.NullEdge.FiniteContractedBianchi

/-!
# Curvature convergence interface for null-edge refinements

This module isolates two analytic obligations in the G4 curvature rung.

The holonomy half works in an arbitrary real normed vector space. A refinement
family has a first-order holonomy expansion when its loop area tends to zero,
the area is eventually nonzero, and

```text
holonomy n = base + area n * (target + residual n)
```

with residual tending to zero. Dividing the holonomy displacement by area then
converges to `target`. This is the exact normalization step needed after a
future diamond-holonomy expansion theorem. The expansion itself is an explicit
hypothesis here; it is not derived from graph transport.

The component half considers a sequence of real curvature-derivative tensors.
Componentwise convergence carries first-pair antisymmetry, last-pair
antisymmetry, and the differential Bianchi identity to the limiting tensor.
The existing finite-index contraction theorem then makes the limiting
Einstein combination divergence-free.

The module does not construct refinement maps, identify a diamond area, prove
the required holonomy expansion, justify differentiation of a curvature limit,
or derive the component tensors from null-edge operators. It gives a checked
interface: those geometric inputs are sufficient for curvature and contracted-
Bianchi convergence.
-/

open Filter Topology
```

### 2. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [curvatureDerivativeLimit_nonzero_witness]

Score: `0.860`

```text
theorem curvatureDerivativeLimit_nonzero_witness :
    witnessDRReal 0 0 1 0 1 = 1 ∧
      divEinstein witnessWeightReal witnessDRReal 0 = 0 := by
  refine ⟨?_, ?_⟩
  · norm_num [witnessDRReal,
      PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.witnessDR,
      PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.witnessQ,
      PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.witnessArea]
  · apply limiting_divEinstein_eq_zero witnessWeightReal
      (fun _ => witnessDRReal) witnessDRReal
    · intro i
      fin_cases i <;> norm_num [witnessWeightReal,
        PhysicsSM.Draft.NullEdge.FiniteContractedBianchi.witnessWeight]
    · intro e a b c d
      exact tendsto_const_nhds
    · intro n e a b c d
      exact witnessDRReal_first_antisymm e a b c d
    · intro n e a b c d
      exact witnessDRReal_last_antisymm e a b c d
    · intro n e a b c d
      exact witnessDRReal_bianchi e a b c d

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.firstOrderHolonomyLimit_converges' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.firstOrderHolonomyLimit_converges

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.normalizedHolonomy_nonzero_limit_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.normalizedHolonomy_nonzero_limit_witness

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.differential_bianchi_passes_to_limit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.
```

### 3. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [curvatureDerivativeLimit_nonzero_witness]

Score: `0.835`

```text
t.NullEdge.CurvatureConvergenceInterface.differential_bianchi_passes_to_limit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.differential_bianchi_passes_to_limit

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.limiting_divEinstein_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.limiting_divEinstein_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.curvatureDerivativeLimit_nonzero_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.curvatureDerivativeLimit_nonzero_witness

end PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface
```

### 4. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [FirstOrderHolonomyLimit]

Score: `0.821`

```text
structure FirstOrderHolonomyLimit
    (area : ℕ -> ℝ) (holonomy : ℕ -> E) (base target : E) where
  /-- Normalized first-order error. -/
  residual : ℕ -> E
  /-- Refined loop areas are eventually nonzero, so normalization is defined. -/
  area_ne_zero : ∀ᶠ n in atTop, area n ≠ 0
  /-- The loops shrink in the refinement limit. -/
  area_tendsto_zero : Tendsto area atTop (nhds 0)
  /-- Exact first-order expansion with the displayed residual. -/
  expansion : ∀ᶠ n in atTop,
    holonomy n = base + area n • (target + residual n)
  /-- The normalized first-order error vanishes. -/
  residual_tendsto_zero : Tendsto residual atTop (nhds 0)

/-- **Area-normalized holonomy convergence.** A shrinking-loop first-order
expansion with vanishing normalized residual converges to its curvature
coefficient. -/
```

### 5. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean`

Score: `0.818`

```text
section ContractedLimit

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- **Contracted-Bianchi limit interface.** Componentwise convergence of
curvature derivatives, together with the discrete curvature symmetries and
differential Bianchi identity at every refinement, gives a divergence-free
Einstein combination for the limiting tensor. -/
```

### 6. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [witnessFirstOrderHolonomyLimit]

Score: `0.817`

```text
def witnessFirstOrderHolonomyLimit :
    FirstOrderHolonomyLimit witnessArea witnessHolonomy (1 : ℝ) 3 := by
  refine ⟨witnessResidual, ?_, ?_, ?_, ?_⟩
  · exact Filter.Eventually.of_forall (fun n => by
      unfold witnessArea
      positivity)
  · change Tendsto (fun n : ℕ => (1 : ℝ) / ((n : ℝ) + 1))
      atTop (nhds 0)
    exact tendsto_one_div_add_atTop_nhds_zero_nat
  · exact Filter.Eventually.of_forall (fun n => rfl)
  · change Tendsto (fun n : ℕ => (1 : ℝ) / ((n : ℝ) + 1))
      atTop (nhds 0)
    exact tendsto_one_div_add_atTop_nhds_zero_nat

/-- The normalized curvature of the explicit nonzero target family converges
to three while its loop area tends to zero. -/
```

### 7. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean`

Score: `0.812`

```text
namespace PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface

open PhysicsSM.Draft.NullEdge.FiniteContractedBianchi

/-! ## Area-normalized holonomy convergence -/

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Area-normalized displacement of a loop holonomy from its zero-area base
value. In a matrix realization, `base` is normally the identity matrix. -/
```

### 8. `AgentTasks/null-edge-super-dirac-conjecture-attack-plan-2026-06-23.md` [Layer 4: diamond holonomy equals curvature block]

Score: `0.811`

```text
### Layer 4: diamond holonomy equals curvature block

Existing triangle curvature:

```text
kappa(i,j,k) = U_ij U_jk - U_ik.
```

For a minimal diamond with two paths `p -> a -> q` and `p -> b -> q`, plus a
direct comparison edge `p -> q`, target:

```text
diamond defect = kappa(p,a,q) - kappa(p,b,q)       -- Abelian/additive version
```

or multiplicatively:

```text
Delta = (U_pa U_aq U_pq^{-1}) * (U_pb U_bq U_pq^{-1})^{-1}.
```

Lean targets:

```lean
diamondDefect_eq_triangleCurvature_ratio
diamondHolonomy_linearized_eq_triangleCurvature_difference
covariantOrderDifferential_sq_eq_diamondCurvature
```

The first target should probably be a focused standalone Aristotle job in the
Abelian scalar transport setting.
```

## Scoped paper hits

### 1. Random Walks on Simplicial Complexes and the Normalized Hodge 1-Laplacian

Score: `0.735`
Zotero key: `N7T76U5H`
arXiv: `1807.05044`
DOI: `10.1137/18M1201019`
URL: https://doi.org/10.1137/18M1201019

### 2. Quantum-gravitational null Raychaudhuri equation

Score: `0.734`
Zotero key: `SIVSBCMC`
arXiv: `2312.17214`
DOI: `10.1007/JHEP07(2024)214`
URL: https://www.zotero.org/19894138/items/SIVSBCMC

Abstract:

We consider a congruence of null geodesics in the presence of a quantized spacetime metric. The coupling to a quantum metric induces fluctuations in the congruence; we calculate the change in the area of a pencil of geodesics induced by such fluctuations. For the gravitational field in its vacuum state, we find that quantum gravity contributes a correction to the null Raychaudhuri equation which is of the same sign as the classical terms. We thus derive a quantum-gravitational focusing theorem valid for linearized quantum gravity.

### 3. On the continuum limit of Benincasa–Dowker–Glaser causal set action

Score: `0.734`
Zotero key: `WCCDDR3H`
arXiv: `2007.13192`
DOI: `10.1088/1361-6382/abc274`
URL: https://www.zotero.org/19894138/items/WCCDDR3H

Abstract:

We study the continuum limit of the Benincasa–Dowker–Glaser causal set action on a causally convex compact region. In particular, we compute the action of a causal set randomly sprinkled on a small causal diamond in the presence of arbitrary curvature in various spacetime dimensions. In the continuum limit, we show that the action admits a finite limit. More importantly, the limit is composed by an Einstein–Hilbert bulk term as predicted by the Benincasa–Dowker–Glaser action, and a boundary term exactly proportional to the codimension-two joint volume. Our calculation provides strong evidence in support of the conjecture that the Benincasa–Dowker–Glaser action naturally includes codimension-two boundary terms when evaluated on causally convex regions.

### 4. Discrete Exterior Calculus

Score: `0.732`
Zotero key: `8XEX66QJ`
arXiv: `math/0508341`
URL: https://www.zotero.org/19894138/items/8XEX66QJ

### 5. Convergence of Discrete Exterior Calculus for the Hodge-Dirac Operator

Score: `0.731`
Zotero key: `N6MAVUJX`
arXiv: `2507.19405`
URL: http://arxiv.org/abs/2507.19405

Abstract:

A short proof of convergence for the discretization of the Hodge-Dirac operator in the framework of discrete exterior calculus (DEC) is provided using the techniques established in [Johnny Guzmán and Pratyush Potu, A Framework for Analysis of DEC Approximations to Hodge-Laplacian Problems using Generalized Whitney Forms, arXiv:2505.08934, 2025]
