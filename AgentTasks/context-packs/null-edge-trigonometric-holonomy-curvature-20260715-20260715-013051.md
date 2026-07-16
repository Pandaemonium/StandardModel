# Aristotle semantic context pack

Generated: 2026-07-15T01:31:16
Query: `trigonometric unitary group commutator iterated area-normalized holonomy limit mixed Frechet derivative Lie commutator joint diagonal limit uniformity curvature`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [normalizedHolonomy_nonzero_limit_witness]

Score: `0.824`

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

### 2. `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` [The $3+1$ high-symmetry verdict]

Score: `0.812`

```text
e quadratic
regulator $q(\mathbf k)R$, with $q(\mathbf k)=\sum_j k_j^2$ and an explicit
chirality-odd matrix $R$, vanishes at the Dirac point and has zero complete
Fr\'echet derivative there, yet equals a nonzero chirality-mixing matrix on a
unit-axis fixture.  This is \NewResult{} \Kernel{}.  It proves that higher-order
mixing can preserve the desired first jet; it does not yet make the regulator
an exact finite-range unitary or exclude every unwanted crossing.

The compatible exact-unitary primitive is a four-factor group commutator of
circle phase steps.  Kernel-checked, it is unitary, becomes the identity when
either angle vanishes, gives $+\id$ for commuting involutions and $-\id$ for
anticommuting involutions at a quarter turn, and admits an explicit rational
mixed pair whose result is not any scalar matrix.  Its algebraic Lie
coefficient $GA-AG$ is chirality-odd whenever $A$ is chirality-even and $G$ is
chirality-odd; for the live $(\alpha_1,\beta)$ pair that coefficient is
nonzero and equals its full odd projection.  The complete first Fr\'echet
derivative of the commutator vanishes at the origin, while its mixed second
derivative is exactly $GA-AG$.  These are \NewResult{} \Kernel{}.  The same
exact algebra also proves a sharp negative result.  A common sign flip of either
cosine/sine pair leaves the commutator unchanged because the corresponding
central signs occur twice and cancel.  Hence every integer-frequency phase
commutator, including one with affine phase offsets, takes the same value at
all cubic $0/\pi$ corners as at the origin; every finite product of zero-offset
loops is exactly invisible there.  A single phase step supplies the negative
control and does see the sign flip.  Thus the obstruction belongs to the
doubled commutator architecture, not to
```

### 3. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean` [holonomyDefect_swap_eq_zero_iff_commute]

Score: `0.809`

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

### 4. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [witnessFirstOrderHolonomyLimit]

Score: `0.807`

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

Score: `0.802`

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

### 6. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [curvatureDerivativeLimit_nonzero_witness]

Score: `0.802`

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

### 7. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean` [holonomyDefect_swap_eq_commutator]

Score: `0.801`

```text
theorem holonomyDefect_swap_eq_commutator {d : Type*} [Fintype d] [DecidableEq d]
    (A B : Matrix d d ℂ) :
    holonomyDefect [A, B] [B, A] = A * B - B * A := by
  simp [holonomyDefect, internalHolonomy]

/-- **Curvature defect detects commutativity.**

The elementary-square defect vanishes exactly when the two transports commute,
i.e. path independence around the square is equivalent to vanishing curvature. -/
```

### 8. `PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean` [curvatureDerivativeLimit_nonzero_witness]

Score: `0.800`

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

## Scoped paper hits

### 1. Connections on non-abelian Gerbes and their Holonomy

Score: `0.763`
URL: http://arxiv.org/abs/0808.1923

### 2. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.739`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.

### 3. Combinatorial and Hodge Laplacians: Similarities and Differences

Score: `0.738`
Zotero key: `9RE64BCV`
DOI: `10.1137/22M1482299`
URL: https://doi.org/10.1137/22M1482299

### 4. Random Walks on Simplicial Complexes and the Normalized Hodge 1-Laplacian

Score: `0.737`
Zotero key: `N7T76U5H`
arXiv: `1807.05044`
DOI: `10.1137/18M1201019`
URL: https://doi.org/10.1137/18M1201019

### 5. Temporal Lorentzian Spectral Triples

Score: `0.730`
Zotero key: `JKDD4KGC`
arXiv: `1210.6575`
DOI: `10.48550/arXiv.1210.6575`
URL: https://arxiv.org/abs/1210.6575

Abstract:

Introduces temporal Lorentzian spectral triples, corresponding to a 3+1 decomposition and global time structure for noncommutative Lorentzian spaces.
