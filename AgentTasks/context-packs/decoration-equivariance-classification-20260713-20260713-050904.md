# Aristotle semantic context pack

Generated: 2026-07-13T05:09:09
Query: `probability mass function deterministic decoration invariant joint law iff equivariant full support symmetry product action`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/NullStrand/Probability/Trajectory.lean`

Score: `0.787`

```text
namespace PhysicsSM.NullStrand.Probability

/-- TRAJ-001 (i.i.d. form). The infinite product of a probability law is a
probability measure on the trajectory space `ℕ → Ω`. -/
```

### 2. `PhysicsSM/Draft/NullEdge/Carrier/CarrierDynamicsCapstone.lean` [finite_rg_ensemble_packet]

Score: `0.786`

```text
p
invariants while finite canonical probabilities normalize (D4/D5).

This is a composition theorem, not new mathematics. See the module docstring for
the standing semantic caveat: this is a *finite* dynamics layer, not a continuum
field theory. -/
```

### 3. `PhysicsSM/Draft/NullEdge/QMF/ProductHaarConfig.lean` [productHaar_isMulLeftInvariant]

Score: `0.780`

```text
instance productHaar_isMulLeftInvariant : (productHaar (ι := ι) μ).IsMulLeftInvariant :=
  inferInstanceAs (Measure.pi (fun _ : ι => μ)).IsMulLeftInvariant

/-! ### Part 2: per-link and endpoint gauge invariance

The engine is `factorwise_integral_invariant`: if every link is transformed by a
measure-preserving self-map of the gauge group, the product-Haar expectation is
unchanged. This is the multi-link Fubini lift of the single-link statement, using
`MeasureTheory.measurePreserving_pi` on the product measure. -/

omit [IsTopologicalGroup G] [BorelSpace G] [MeasurableMul G] [MeasurableInv G] in
/-- **Factorwise measure invariance of the product-Haar expectation.** If each link
`e` is transformed by a measure-preserving measurable equivalence `ef e` of the
gauge group, then integrating any observable over `Config` is unchanged. Proved
by assembling the per-factor maps with `MeasurableEquiv.piCongrRight`, whose
measure-preservation is `measurePreserving_pi`, then `integral_comp'`. -/
```

### 4. `PhysicsSM/Draft/NullEdge/GateD/FiniteBernoulliMaxEntropy.lean` [productOfMarginals_pos]

Score: `0.778`

```text
theorem productOfMarginals_pos (p : α × β -> ℝ)
    (hleft : ∀ a, 0 < marginalLeft p a)
    (hright : ∀ b, 0 < marginalRight p b) :
    ∀ ab, 0 < productOfMarginals p ab := by
  intro ab
  exact mul_pos (hleft ab.1) (hright ab.2)

/-- A normalized joint distribution has a normalized product-marginal reference. -/
```

### 5. `PhysicsSM/Draft/NullEdge/QMF/ProductHaarConfig.lean`

Score: `0.775`

```text
namespace PhysicsSM.Draft.NullEdge.QMF.ProductHaarConfig

open MeasureTheory MeasureTheory.Measure
open PhysicsSM.Draft.NullEdge.QMF.CompactHaarInvariance

/-! ## Abstract disjoint-block independence positivity

A self-contained probabilistic fact used to close the reflection-positivity of
the BARE product measure (no interaction/Boltzmann weight): on a finite product
of finite nonzero measures, if a "positive-side" observable `P` depends only on
the coordinates in the block `p` and a "reflected" observable `Q` depends only on
the complementary block `¬p`, then the two are independent, so the diagonal form
`∫ Q·P` factorizes as `(∫P/·)(∫Q/·)`; using `∫P = ∫Q` it becomes a nonnegative
constant times a square, hence `0 ≤ ∫ Q·P`. This is the elementary product-measure
content - it does NOT use Peter-Weyl and does NOT involve any lattice action. -/

/-- **Product-measure factorization across a coordinate cut.** For the product
measure `Measure.pi ν`, integrating `f` of the `p`-coordinates times `g` of the
complementary `¬p`-coordinates factors as the product of the two block integrals
(Fubini on the `piEquivPiSubtypeProd` splitting). -/
```

### 6. `PhysicsSM/Draft/NullEdge/QMF/ProductHaarConfig.lean` [productHaar_isFiniteMeasure]

Score: `0.774`

```text
instance productHaar_isFiniteMeasure : IsFiniteMeasure (productHaar (ι := ι) μ) :=
  inferInstanceAs (IsFiniteMeasure (Measure.pi (fun _ : ι => μ)))

/-- The product Haar measure is **left-invariant** under the pointwise gauge-group
action on the configuration space. -/
```

## Scoped paper hits

### 1. Symmetry-breaking and zero-one laws

Score: `0.721`
Zotero key: `342HA4DS`
arXiv: `1909.06070`
DOI: `10.1088/1361-6382/ab81cd`
URL: http://arxiv.org/abs/1909.06070

Abstract:

We offer further evidence that discreteness of the sort inherent in a causal set cannot, in and of itself, serve to break Poincar{é} invariance. In particular we prove that a Poisson sprinkling of Minkowski spacetime cannot endow spacetime with a distinguished spatial or temporal orientation, or with a distinguished lattice of spacetime points, or with a distinguished lattice of timelike directions (corresponding respectively to breakings of reflection-invariance, translation-invariance, and Lorentz invariance). Along the way we provide a proof from first principles of the zero-one law on which our new arguments are based.

### 2. An analysis of completely-positive trace-preserving maps on M2

Score: `0.719`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 3. The Spectral Action Principle

Score: `0.711`
Zotero key: `6WURA7MF`
DOI: `10.1007/s002200050126`
URL: https://doi.org/10.1007/s002200050126

### 4. Local d'Alembertian for causal sets

Score: `0.710`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`
