# Aristotle semantic context pack

Generated: 2026-07-15T02:56:21
Query: `uniform joint two-variable trigonometric group commutator holonomy area normalized curvature limit punctured product`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]

Score: `0.830`

```text
nvergence |
| Finite commutator curvature obeys cyclic adjoint Bianchi | M [orig] | Exact Jacobi identity | Geometric and contracted Bianchi limits |
| Fixed-label Cartan torsion obeys the torsionful first-Bianchi shape and fixed-sandwich covariance | M [orig] | Exact cyclic derivative/curvature-action identity, torsion-free corollary, and covariance of both sides | Graded cochains, site-dependent local labels, anholonomy, and 3-cell content |
| Finite-index Riemann derivative symmetries plus differential Bianchi imply divergence-free Einstein combination | M [comp] | Explicit double contraction with a nonzero (1+1) Lorentz witness | Derive the component premises from null-edge transport |
| First-order shrinking-loop holonomy expansion or a raw `area * epsilon` remainder bound implies area-normalized curvature convergence | M [orig] | Exact normed-space normalization, quantitative error bound, and a nonzero shrinking-area witness | Derive the area and raw remainder estimate for null-edge diamonds |
| Explicit near-identity links on a decorated finite torus have an exact nonzero plaquette-curvature limit | M [orig] | Ordered path difference is exactly `h^2[A,B]`; explicit nilpotent generators give invertible links and genuine closed-square holonomy whose area-normalized identity displacement converges to the signed nonzero commutator | General graph-derived transports and areas, refinement maps, continuum tensor identification, and curvature-derivative convergence |
| The exact trigonometric group commutator has a nonzero unitary iterated curvature limit | M [comp] | Hermitian involutions give unitary finite regulators and identity axis closure; first the normalized `p` displacement converges to its edge jet, then the normalized `q` jet converges to `G*A-A*G`, with a no
```

### 2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G4. Connection and curvature convergence]

Score: `0.829`

```text
### G4. Connection and curvature convergence

Show that edge transports approximate a metric-compatible connection and that
area-normalized diamond holonomies converge to curvature.

A checked sufficient-condition interface is now available. A shrinking-loop
first-order expansion with an eventually nonzero area and vanishing normalized
residual implies convergence of area-normalized holonomy displacement to its
curvature coefficient. More operationally, a raw remainder bounded by
`area * epsilon` with positive area and `epsilon -> 0` gives an explicit
normalized error bound and the same convergence.

That interface now has one constructed, nonzero test family. On the decorated
`ZMod 2 x ZMod 2` torus, constant near-identity matrix links make the difference
of the two ordered plaquette paths exactly `h^2[A,B]`. For explicit upper and
lower nilpotent generators, the links are units with exact reverse links, and
transport around a genuine four-edge closed square has an exact
identity-plus-area expansion. Its normalized residual is componentwise
`(0,-h;h,h^2)` and tends to zero, so the area-normalized displacement from the
identity converges to the orientation-selected nonzero commutator. This is a
finite consistency witness for the holonomy-curvature mechanism, not a
reconstruction theorem for arbitrary graph transports.

There is now also a generator-level analytic bridge beyond that one nilpotent
square. The exact trigonometric group commutator already had identity value,
zero full first Frechet derivative, and mixed derivative `G*A-A*G` at the
origin. The difference-quotient theorem upgrades that jet statement to an
iterated limit. For Hermitian involutions all finite regulators are unitary and
the `p=0` axis is exactly the identity. At each fixed `q`, the normalized
`p
```

### 3. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [normalizedHolonomy_nonzero_limit_witness]

Score: `0.827`

```text
theorem normalizedHolonomy_nonzero_limit_witness :
    Tendsto witnessArea atTop (nhds 0) ∧
      Tendsto
        (normalizedHolonomyCurvature witnessArea witnessHolonomy (1 : ℝ))
        atTop (nhds 3) :=
  firstOrderHolonomyLimit_converges witnessArea witnessHolonomy 1 3
    witnessFirstOrderHolonomyLimit

/-! ## Curvature-component identities pass to the limit -/
```

### 4. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [witnessFirstOrderHolonomyLimit]

Score: `0.822`

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

### 5. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [firstOrderHolonomyLimit_converges]

Score: `0.800`

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

### 6. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [normalizedHolonomyCurvature]

Score: `0.799`

```text
def normalizedHolonomyCurvature
    (area : ℕ -> ℝ) (holonomy : ℕ -> E) (base : E) (n : ℕ) : E :=
  (area n)⁻¹ • (holonomy n - base)

/-- Data certifying a shrinking-loop first-order holonomy expansion. -/
```

### 7. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean` [holonomyDefect_swap_eq_zero_iff_commute]

Score: `0.797`

```text
theorem holonomyDefect_swap_eq_zero_iff_commute {d : Type*} [Fintype d] [DecidableEq d]
    (A B : Matrix d d ℂ) :
    holonomyDefect [A, B] [B, A] = 0 ↔ Commute A B := by
  rw [holonomyDefect_swap_eq_commutator, sub_eq_zero]
  exact Iff.rfl

/-- **Failure of path independence from nonvanishing curvature.**

If the matrix commutator (curvature defect) is nonzero, then the two ways around
the elementary square give genuinely different holonomies: synchronization is
path dependent. This is the contrapositive direction of the defect/flatness
correspondence. -/
```

### 8. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G4. Connection and curvature convergence]

Score: `0.795`

```text
t theorem upgrades that jet statement to an
iterated limit. For Hermitian involutions all finite regulators are unitary and
the `p=0` axis is exactly the identity. At each fixed `q`, the normalized
`p`-displacement converges to the `p`-edge jet; dividing that jet by `q` and
then taking `q -> 0` converges to the Lie coefficient. The live
`alpha_1,beta` Clifford pair supplies a nonzero unitary witness. The order of
limits is explicit: this is not yet a joint or diagonal area limit and does not
supply the uniform estimate needed to exchange or synchronize the limits.

Separately, componentwise convergence carries both curvature-pair
antisymmetries and the differential Bianchi identity to the limit; the
explicit finite contraction theorem then yields zero divergence of the
limiting Einstein combination.

**Success:** the correct curvature symmetries and Bianchi identity emerge.  
**Kill:** path-dependent continuum transport, wrong tensor symmetries, or
surviving nonmetricity.

G4 still owes the substantive geometric work: derive transports, areas, and
refinement maps from the graph rather than choosing them; extend the fixed
nilpotent square and iterated trigonometric calculations to a uniform joint or
diagonal limit for the relevant connection class; identify the matrix
coefficient with continuum curvature components; construct curvature
derivatives; and prove their componentwise or stronger convergence. The
constructed torus and unitary regulator families prove that the normalization,
orientation, and Lie coefficient can work nontrivially. They do not manufacture
the missing geometric inputs.
```

## Scoped paper hits

### 1. Connections on non-abelian Gerbes and their Holonomy

Score: `0.771`
URL: http://arxiv.org/abs/0808.1923

### 2. Twisted geometries: A geometric parametrisation of SU(2) phase space

Score: `0.750`
Zotero key: `63MQ6KC3`
arXiv: `1001.2748v3`
URL: http://arxiv.org/abs/1001.2748v3

Abstract:

Twisted-geometry parametrization of SU(2) loop-gravity phase space, including face areas, normals, extrinsic angle, gauge-invariant reduced phase space, and connection to closure/geometricity constraints.

### 3. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.745`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.

### 4. Random Walks on Simplicial Complexes and the Normalized Hodge 1-Laplacian

Score: `0.741`
Zotero key: `N7T76U5H`
arXiv: `1807.05044`
DOI: `10.1137/18M1201019`
URL: https://doi.org/10.1137/18M1201019

### 5. Combinatorial and Hodge Laplacians: Similarities and Differences

Score: `0.728`
Zotero key: `9RE64BCV`
DOI: `10.1137/22M1482299`
URL: https://doi.org/10.1137/22M1482299
