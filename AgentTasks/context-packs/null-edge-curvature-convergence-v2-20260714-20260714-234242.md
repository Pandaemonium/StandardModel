# Aristotle semantic context pack

Generated: 2026-07-14T23:42:50
Query: `quantitative null edge diamond holonomy raw remainder area epsilon curvature convergence component derivative differential Bianchi contracted Einstein`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean`

Score: `0.885`

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

### 2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G4. Connection and curvature convergence]

Score: `0.869`

```text
### G4. Connection and curvature convergence

Show that edge transports approximate a metric-compatible connection and that
area-normalized diamond holonomies converge to curvature.

A checked sufficient-condition interface is now available. A shrinking-loop
first-order expansion with an eventually nonzero area and vanishing normalized
residual implies convergence of area-normalized holonomy displacement to its
curvature coefficient. Separately, componentwise convergence carries both
curvature-pair antisymmetries and the differential Bianchi identity to the
limit; the explicit finite contraction theorem then yields zero divergence of
the limiting Einstein combination.

**Success:** the correct curvature symmetries and Bianchi identity emerge.  
**Kill:** path-dependent continuum transport, wrong tensor symmetries, or
surviving nonmetricity.

G4 still owes the substantive geometric work: derive the small-diamond
first-order expansion and error bound from null-edge transport, identify its
matrix coefficient with curvature components, construct curvature derivatives,
and prove their componentwise or stronger convergence. The interface shows
that these inputs are sufficient; it does not manufacture them.
```

### 3. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [curvatureDerivativeLimit_nonzero_witness]

Score: `0.861`

```text
t.NullEdge.CurvatureConvergenceInterface.normalizedHolonomy_error_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.normalizedHolonomy_error_le

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.normalizedHolonomy_tendsto_of_error_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.normalizedHolonomy_tendsto_of_error_bound

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.differential_bianchi_passes_to_limit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
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

### 4. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [curvatureDerivativeLimit_nonzero_witness]

Score: `0.851`

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

/-- info: 'PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface.normalizedHolonomy_error_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.Nul
```

### 5. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]

Score: `0.848`

```text
| Exact Jacobi identity | Geometric and contracted Bianchi limits |
| Fixed-label Cartan torsion obeys the torsionful first-Bianchi shape and fixed-sandwich covariance | M [orig] | Exact cyclic derivative/curvature-action identity, torsion-free corollary, and covariance of both sides | Graded cochains, site-dependent local labels, anholonomy, and 3-cell content |
| Finite-index Riemann derivative symmetries plus differential Bianchi imply divergence-free Einstein combination | M [comp] | Explicit double contraction with a nonzero (1+1) Lorentz witness | Derive the component premises from null-edge transport |
| First-order shrinking-loop holonomy expansion implies area-normalized curvature convergence | M [orig] | Exact normed-space normalization theorem with a nonzero shrinking-area witness | Derive the expansion, area, and residual estimate for null-edge diamonds |
| Componentwise refinement convergence carries curvature antisymmetries and differential Bianchi to a divergence-free limiting Einstein combination | M [orig] | Limiting identities follow by uniqueness of limits and explicit contraction, with a nonzero component witness | Connect matrix holonomy to curvature-derivative components and justify derivative convergence |
| Null-soldered Dirac square splits into Gram and commutator sectors | M [orig] | Exact finite Weitzenbock-shaped identity | Continuum Lichnerowicz identification |
| Finite connection identities compose with the tetrad-specialized Lichnerowicz square | M [orig] | One guarded G3/G4/G5 theorem chain | Principal-symbol and curvature-coefficient convergence |
| Finite stationarity, source, and Clausius avatars | M [orig] | Nonvacuous finite equations | Einstein tensor and conserved stress tensor |
| One finite symmetry hypothesis transports mass-s
```

### 6. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [normalizedHolonomy_error_le]

Score: `0.831`

```text
theorem normalizedHolonomy_error_le
    (area : ℕ -> ℝ) (holonomy : ℕ -> E) (base target : E)
    (epsilon : ℕ -> ℝ)
    (harea : ∀ᶠ n in atTop, 0 < area n)
    (herror : ∀ᶠ n in atTop,
      ‖holonomy n - base - area n • target‖ ≤ area n * epsilon n) :
    ∀ᶠ n in atTop,
      ‖normalizedHolonomyCurvature area holonomy base n - target‖ ≤
        epsilon n := by
  filter_upwards [harea, herror] with n ha herr
  have hne : area n ≠ 0 := ha.ne'
  have htarget : (area n)⁻¹ • (area n • target) = target := by
    simp [hne, smul_smul]
  have hid :
      normalizedHolonomyCurvature area holonomy base n - target =
        (area n)⁻¹ • (holonomy n - base - area n • target) := by
    unfold normalizedHolonomyCurvature
    calc
      (area n)⁻¹ • (holonomy n - base) - target =
          (area n)⁻¹ • (holonomy n - base) -
            (area n)⁻¹ • (area n • target) := by rw [htarget]
      _ = (area n)⁻¹ • (holonomy n - base - area n • target) :=
        (smul_sub (area n)⁻¹ (holonomy n - base) (area n • target)).symm
  rw [hid, norm_smul, Real.norm_eq_abs, abs_inv, abs_of_pos ha]
  calc
    (area n)⁻¹ * ‖holonomy n - base - area n • target‖
        ≤ (area n)⁻¹ * (area n * epsilon n) :=
      mul_le_mul_of_nonneg_left herr (le_of_lt (inv_pos.mpr ha))
    _ = epsilon n := by field_simp

/-- **Quantitative holonomy convergence interface.** If the raw first-order
remainder is bounded by `area * epsilon` and `epsilon` tends to zero, then the
area-normalized holonomy displacement converges to the target curvature. -/
```

### 7. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [firstOrderHolonomyLimit_converges]

Score: `0.826`

```text
theorem firstOrderHolonomyLimit_converges
    (area : ℕ -> ℝ) (holonomy : ℕ -> E) (base target : E)
    (h : FirstOrderHolonomyLimit area holonomy base target) :
    Tendsto area atTop (nhds 0) ∧
      Tendsto (normalizedHolonomyCurvature area holonomy base)
        atTop (nhds target) := by
  refine ⟨h.area_tendsto_zero, ?_⟩
  have hpoint : ∀ᶠ n in atTop,
      normalizedHolonomyCurvature area holonomy base n =
        target + h.residual n := by
    filter_upwards [h.area_ne_zero, h.expansion] with n hne hexp
    unfold normalizedHolonomyCurvature
    rw [hexp, add_sub_cancel_left]
    simp [hne, smul_smul]
  have hsum :
      Tendsto (fun n => target + h.residual n) atTop (nhds target) := by
    simpa using tendsto_const_nhds.add h.residual_tendsto_zero
  exact hsum.congr' (Filter.EventuallyEq.symm hpoint)

/-- A raw first-order remainder bound yields the corresponding normalized
curvature-error bound. This is the quantitative form a future diamond-holonomy
estimate can discharge directly. -/
```

### 8. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean`

Score: `0.807`

```text
section ContractedLimit

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- **Contracted-Bianchi limit interface.** Componentwise convergence of
curvature derivatives, together with the discrete curvature symmetries and
differential Bianchi identity at every refinement, gives a divergence-free
Einstein combination for the limiting tensor. -/
```

## Scoped paper hits

### 1. Quantum-gravitational null Raychaudhuri equation

Score: `0.770`
Zotero key: `SIVSBCMC`
arXiv: `2312.17214`
DOI: `10.1007/JHEP07(2024)214`
URL: https://www.zotero.org/19894138/items/SIVSBCMC

Abstract:

We consider a congruence of null geodesics in the presence of a quantized spacetime metric. The coupling to a quantum metric induces fluctuations in the congruence; we calculate the change in the area of a pencil of geodesics induced by such fluctuations. For the gravitational field in its vacuum state, we find that quantum gravity contributes a correction to the null Raychaudhuri equation which is of the same sign as the classical terms. We thus derive a quantum-gravitational focusing theorem valid for linearized quantum gravity.

### 2. Noise kernel in stochastic gravity and stress energy bitensor of quantum fields in curved spacetimes

Score: `0.762`
Zotero key: `5T5BQ6PT`
DOI: `10.1103/physrevd.63.104001`

### 3. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.752`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.

### 4. Discrete Exterior Calculus

Score: `0.751`
Zotero key: `8XEX66QJ`
arXiv: `math/0508341`
URL: https://www.zotero.org/19894138/items/8XEX66QJ

### 5. Gravitational Thermodynamics of Causal Diamonds in (A)dS

Score: `0.750`
Zotero key: `2ZZTQS43`
arXiv: `1812.01596`
URL: http://arxiv.org/abs/1812.01596v3
