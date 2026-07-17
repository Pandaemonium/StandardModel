# Aristotle semantic context pack

Generated: 2026-07-17T00:11:50
Query: `finite null-edge shell radial support rank-four injective sampling left inverse complex Higgs derivative recovery`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/DualFrameHiggsRecovery.lean` [identity_fourFrame_exact_recovery]

Score: `0.838`

```text
theorem identity_fourFrame_exact_recovery
    (derivative : Fin 4 -> Complex) :
    extractComponents (1 : Matrix (Fin 4) (Fin 4) Real)
        (synthesizeSamples (1 : Matrix (Fin 4) (Fin 4) Real) derivative) =
      derivative := by
  exact extract_synthesize_of_leftInverse
    (1 : Matrix (Fin 4) (Fin 4) Real)
    (1 : Matrix (Fin 4) (Fin 4) Real) (by simp) derivative

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.DualFrameHiggsRecovery.extract_synthesize_of_leftInverse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms extract_synthesize_of_leftInverse

/-- info: 'PhysicsSM.Draft.NullEdge.DualFrameHiggsRecovery.synthesizeSamples_injective_of_leftInverse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms synthesizeSamples_injective_of_leftInverse

/-- info: 'PhysicsSM.Draft.NullEdge.DualFrameHiggsRecovery.derivative_eq_zero_of_samples_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms derivative_eq_zero_of_samples_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.DualFrameHiggsRecovery.identity_fourFrame_exact_recovery' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms identity_fourFrame_exact_recovery

end PhysicsSM.Draft.NullEdge.DualFrameHiggsRecovery

end
```

### 2. `PhysicsSM/Draft/NullEdge/DualFrameHiggsRecovery.lean`

Score: `0.829`

```text
import Mathlib

/-!
# Exact complex derivative recovery from a real dual frame

This module isolates the finite linear algebra of a local derivative fit. A
real sample matrix maps complex derivative components to complex edge samples.
A supplied real left inverse recovers every complex component exactly and
makes the sample map injective.

The left inverse is a hypothesis. No graph selector, rank-availability
```

### 3. `PhysicsSM/Draft/NullEdge/DualFrameHiggsRecovery.lean` [synthesizeSamples_injective_of_leftInverse]

Score: `0.827`

```text
theorem synthesizeSamples_injective_of_leftInverse
    (sampleMatrix : Matrix Y I Real) (dualMatrix : Matrix I Y Real)
    (hLeft : dualMatrix * sampleMatrix = (1 : Matrix I I Real)) :
    Function.Injective (synthesizeSamples sampleMatrix) := by
  intro derivative₁ derivative₂ h
  rw [← extract_synthesize_of_leftInverse sampleMatrix dualMatrix hLeft derivative₁,
    ← extract_synthesize_of_leftInverse sampleMatrix dualMatrix hLeft derivative₂, h]

/-- Zero synthesized samples force every complex derivative component to
vanish when a real left inverse is supplied. -/
```

### 4. `PhysicsSM/Draft/NullEdge/DualFrameHiggsRecovery.lean` [extract_synthesize_of_leftInverse]

Score: `0.815`

```text
theorem extract_synthesize_of_leftInverse
    (sampleMatrix : Matrix Y I Real) (dualMatrix : Matrix I Y Real)
    (hLeft : dualMatrix * sampleMatrix = (1 : Matrix I I Real))
    (derivative : I -> Complex) :
    extractComponents dualMatrix (synthesizeSamples sampleMatrix derivative) =
      derivative := by
  ext i
  simp +decide [extractComponents, synthesizeSamples]
  convert congr_arg
    (fun m : Matrix I I ℝ => ∑ j, (m i j : ℂ) * derivative j) hLeft using 1
  · simp +decide [Matrix.mul_apply, Finset.mul_sum _ _ _]
    exact Finset.sum_comm.trans (Finset.sum_congr rfl fun _ _ => by
      rw [Finset.sum_mul]
      exact Finset.sum_congr rfl fun _ _ => by ring)
  · simp +decide [Matrix.one_apply]
    rw [Finset.sum_eq_single i] <;> aesop

/-- A sample matrix with a supplied real left inverse is injective even after
extension from real coefficients to complex derivative components. -/
```

### 5. `PhysicsSM/Draft/NullEdge/DualFrameHiggsRecovery.lean` [derivative_eq_zero_of_samples_eq_zero]

Score: `0.802`

```text
theorem derivative_eq_zero_of_samples_eq_zero
    (sampleMatrix : Matrix Y I Real) (dualMatrix : Matrix I Y Real)
    (hLeft : dualMatrix * sampleMatrix = (1 : Matrix I I Real))
    (derivative : I -> Complex)
    (hZero : synthesizeSamples sampleMatrix derivative = 0) :
    derivative = 0 := by
  apply synthesizeSamples_injective_of_leftInverse sampleMatrix dualMatrix hLeft
  calc
    synthesizeSamples sampleMatrix derivative = 0 := hZero
    _ = synthesizeSamples sampleMatrix 0 := by
      ext y
      simp [synthesizeSamples]

/-- Exact four-component control: the identity sample frame and identity dual
recover every complex derivative vector. -/
```

### 6. `PhysicsSM/Draft/NullEdge/DualFrameHiggsRecovery.lean` [extractComponents]

Score: `0.796`

```text
def extractComponents
    (dualMatrix : Matrix I Y Real) (samples : Y -> Complex) : I -> Complex :=
  fun i => ∑ y, (dualMatrix i y : Complex) * samples y

/-- A real left inverse recovers every complex derivative vector exactly. -/
```

### 7. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [7.1 The Higgs is an internal zero-form with edge-supported variation]

Score: `0.796`

```text
H(x),
  \qquad
  (D_iH)(x)=\sum_y c_i(x,y)\Delta_{xy}H.
\]

The real coefficients (c_i(x,y)) are the proposed dual-frame or local-fit
coefficients. Under endpoint gauge transformations every \(\Delta_{xy}H\), and
hence every (D_iH), transforms only by the anchor phase. This makes the
normalized mostly-minus contraction

\[
  K_H(x)=\mu_x\left(
    |D_0H|^2-|D_1H|^2-|D_2H|^2-|D_3H|^2\right)
\]

gauge invariant even though it is not positive.
`AnchoredHiggsDerivativeExtractor.lean` now proves this entire gauge-algebra
paragraph as **`M [comp]`** for arbitrary supplied real coefficients, including
zero derivative and zero signed kinetic contraction on a parallel section.
`DualFrameHiggsRecovery.lean` proves the complementary exact algebra: whenever
a supplied real sample matrix has a supplied real left inverse, that inverse
recovers every complex derivative vector, the sample map is injective, and the
four-component identity frame is an explicit nonvacuous control. These results
close the covariance and complexification subgates. They do not prove that an
order-native null fan supplies the required left inverse.
`HiggsCoframeFirstVariation.lean` also proves **`M [comp]`** the exact response
of the signed kinetic contraction when that supplied dual matrix follows an
affine perturbation. The formula retains its full quadratic remainder, and its
linear coefficient is invariant under the common anchor phase. This closes the
held-fixed-sample first-response algebra. It does not identify the matrix
perturbation with a coframe component, vary the samples or holonomies, or
construct a stress tensor. The physical construction remains the separate
**`C [orig/comp]`** gate:

1. derive (c_i(x,y)) equivariantly from the selected shell/probe frame and
   the reconstructed dual coframe;
```

### 8. `PhysicsSM/Draft/NullEdgeScalarKineticReconstruction.lean`

Score: `0.789`

```text
fies the name *inverse-Gram weights*.

* `inverse_gram_reconstruction` : the two facts combined, stated directly with the
  induced inverse metric `g^{-1}(ξ,η) = g(g♯ξ, g♯η)`.

* `higgs_kinetic_reconstruction` : the documented scalar/Higgs corollary
  (`ξ = η = dH`): the Lorentzian kinetic symbol `⟨DH, DH⟩_{g^{-1}}` is
  reconstructed from the null-edge derivatives `∇_a H := dH(ell_a)` and the
  inverse-Gram weights, `⟨DH,DH⟩ = ∑_{a,b} G^{ab} (∇_a H)(∇_b H)`.

* `euclidean_collapse_guardrail` : the **guardrail**.  The naive positive edge
  sum `∑_a (∇_a H)^2` is recovered *exactly* in the Euclidean special case
  `G^{ab} = δ^{ab}`.  For a genuine Lorentzian inverse-Gram matrix the
  off-diagonal weights survive, so the reconstruction is *not* ordinary
  graph/lattice Higgs theory with null labels.

The encoding of nondegeneracy: a symmetric bilinear form `g` is nondegenerate iff
the musical map `v ↦ g(v, ·)` is a linear isomorphism `V ≃ Module.Dual ℝ V`.  We
encode its inverse `g♯` as a linear map `sharp : Module.Dual ℝ V →ₗ[ℝ] V` with the
defining "raising" property `hsharp : g (sharp ξ) v = ξ v`.  This is exactly the
data of the inverse metric, and existence of such a `sharp` is equivalent to
nondegeneracy of `g`.
-/
```

## Scoped paper hits

### 1. Finite-Difference Approach to the Hodge Theory of Harmonic Forms

Score: `0.744`
Zotero key: `TSAQXS9N`
DOI: `10.2307/2373615`
URL: https://doi.org/10.2307/2373615

### 2. Hodgelets: Localized Spectral Representations of Flows on Simplicial Complexes

Score: `0.730`
Zotero key: `33X7ZETB`
arXiv: `2109.08728`
URL: http://arxiv.org/abs/2109.08728

### 3. Random Walks on Simplicial Complexes and the Normalized Hodge 1-Laplacian

Score: `0.728`
Zotero key: `N7T76U5H`
arXiv: `1807.05044`
DOI: `10.1137/18M1201019`
URL: https://doi.org/10.1137/18M1201019

### 4. Locality properties of Neuberger's lattice Dirac operator

Score: `0.726`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 5. Higher-order Laplacian renormalization

Score: `0.724`
Zotero key: `RA8QNNKW`
arXiv: `2401.11298`
DOI: `10.1038/s41567-025-02784-1`
URL: https://doi.org/10.1038/s41567-025-02784-1

### 6. Combinatorial and Hodge Laplacians: Similarities and Differences

Score: `0.723`
Zotero key: `9RE64BCV`
DOI: `10.1137/22M1482299`
URL: https://doi.org/10.1137/22M1482299
