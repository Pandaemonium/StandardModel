# Null-edge causal graph theorem roadmap

Date: 2026-06-21

Status: literature-informed theorem roadmap after the SPL-free Aristotle
verification of `PhysicsSM.Draft.NullEdgeCoreAristotle`.

Related Lean anchors:

- `PhysicsSM.Draft.NullEdgeCoreAristotle`
- `PhysicsSM.Draft.SpinorHelicityRankOneAristotle`
- `PhysicsSM.Draft.SpinCoherentProjectorAristotle`
- `PhysicsSM.Draft.WeylCliffordBridgeAristotle`
- `PhysicsSM.StandardModel.OneGenerationTable`
- `PhysicsSM.StandardModel.SpinorFockHypercharge`

## Current kernel-checked core

Aristotle has now verified the first finite null-edge theorem island without
any Sphere-Packing-Lean dependency:

```lean
det_rankOneHermitian_eq_zero
two_edge_plucker_mass_identity
complexAbsSq_eq_zero_iff
two_edge_mass_zero_iff_wedge_zero
spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero
diamondDefect_gauge_invariant
chainBoundary_simplexBoundary_eq_zero
chainBoundary_comp_self_eq_zero
threeEdgeMomentum
three_edge_plucker_mass_identity
```

The most important new result is:

```lean
three_edge_plucker_mass_identity
```

It proves the first genuinely multi-edge visible-bundle mass formula:

```text
det(psi psi^dagger + phi phi^dagger + chi chi^dagger)
  =
|psi wedge phi|^2 + |psi wedge chi|^2 + |phi wedge chi|^2.
```

This moves the program past the two-edge toy case.  The next goal should be
the full finite bundle theorem.

## Literature anchors

The search pass reinforces five external anchor families.

1. **Checkerboard and null-step Dirac dynamics.**
   Earle's review treats the Feynman checkerboard as a path-integral approach
   to the `1+1` Dirac equation, while Foster and Jacobson give a `3+1`
   null-step Weyl/checkerboard construction where a Dirac mass introduces an
   `i epsilon m` chirality-flip amplitude.

   Sources:
   - Keith A. Earle, "Notes on The Feynman Checkerboard Problem",
     https://arxiv.org/abs/1012.1564
   - Brendan Z. Foster and Ted Jacobson, "Spin on a 4D Feynman Checkerboard",
     https://arxiv.org/abs/1610.01142

2. **Twistor mass and two-twistor massive particles.**
   The two-twistor literature supports the idea that massive particles are
   naturally represented by pairs of twistors.  The finite theorem target is
   not "invent two-twistor massive particles", but prove that the null-edge
   Pluecker mass functional matches the spinor part of the standard
   two-twistor mass invariant in a fixed convention.

   Sources:
   - J. A. de Azcarraga, S. Fedoruk, J. M. Izquierdo, J. Lukierski,
     "Two-twistor particle models and free massive higher spin fields",
     https://arxiv.org/abs/1409.7169
   - "From Twistor-Particle Models to Massive Amplitudes",
     https://arxiv.org/abs/2203.08087
   - L. P. Hughston and R. S. Ward, "Advances in Twistor Theory" and
     Penrose-Rindler are still the convention sources to consult before a
     trusted twistor module.

3. **Lorentz-invariant causal discreteness.**
   Bombelli, Henson, and Sorkin prove that Poisson sprinkling avoids preferred
   frames, but also that no finite-valency graph can be assigned to a
   sprinkling in a Lorentz-invariant way.  This is a hard constraint: finite
   null-edge paths should be effective histories, not a fundamental
   fixed-valency lattice.

   Source:
   - L. Bombelli, J. Henson, R. D. Sorkin,
     "Discreteness without symmetry breaking: a theorem",
     https://arxiv.org/abs/gr-qc/0605006

4. **Causal-set gauge and curvature observables.**
   Sverdlov's causal-set gauge-field work rewrites gauge data in terms of
   holonomies between pairs of points, causal relations, and interval volumes.
   Baez-Schreiber higher gauge theory supplies the categorical language for
   path and surface holonomy.  Together they suggest upgrading the current
   Abelian diamond defect to a finite 2-categorical path-comparison API before
   any continuum Stokes theorem is claimed.

   Sources:
   - Roman Sverdlov, "Gauge Fields in Causal Set Theory",
     https://arxiv.org/abs/0807.2066
   - John C. Baez and Urs Schreiber, "Higher Gauge Theory",
     https://arxiv.org/abs/math/0511710
   - John C. Baez and Urs Schreiber,
     "Higher Gauge Theory: 2-Connections on 2-Bundles",
     https://arxiv.org/abs/hep-th/0412325

5. **Order complexes, Kahler-Dirac fermions, and gravity.**
   Kahler-Dirac fermions motivate the order-complex branch because they use
   inhomogeneous differential forms, which have a natural simplicial/cochain
   discretization.  Jacobson and Benincasa-Dowker provide the gravity route:
   null-horizon thermodynamics and causal-set scalar curvature.

   Sources:
   - "Symmetric Mass Generation of Kahler-Dirac Fermions from Topological
     Phases", appendix review, https://arxiv.org/html/2306.17420v6
   - Ted Jacobson, "Thermodynamics of Spacetime: The Einstein Equation of
     State", https://arxiv.org/abs/gr-qc/9504004
   - Dionigi M. T. Benincasa and Fay Dowker,
     "The Scalar Curvature of a Causal Set",
     https://arxiv.org/abs/1001.2725

The internal-label branch is supported by the Furey-Hughes division-algebraic
program:

- N. Furey and M. J. Hughes, "Division algebraic symmetry breaking",
  https://arxiv.org/abs/2210.10126
- N. Furey and M. J. Hughes, "Three Generations and a Trio of Trialities",
  https://arxiv.org/abs/2409.17948
- John C. Baez and John Huerta, "Division Algebras and Supersymmetry I",
  https://arxiv.org/abs/0909.0551

## Highest-value theorem targets

### Target 1: full finite Pluecker bundle mass

This is the highest value next theorem.  It turns the two-edge and three-edge
identities into the general mass theorem.

Proposed Lean surface:

```lean
def finBundleMomentum {n : Nat} (psi : Fin n -> CSpinor) :
    Matrix (Fin 2) (Fin 2) C := ...

def finPairwisePluckerMass {n : Nat} (psi : Fin n -> CSpinor) : C := ...

theorem fin_bundle_plucker_mass_identity {n : Nat}
    (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = finPairwisePluckerMass psi := by
  ...
```

Mathematical route: Cauchy-Binet for a `2 x n` spinor matrix.  For a matrix
`A` whose columns are the spinors, the momentum matrix is `A A^dagger`, and:

```text
det(A A^dagger) = sum over two-column minors |det(A_ij)|^2.
```

This is the central theorem because it says:

```text
mass^2 = total pairwise Pluecker spread of all visible null edges.
```

### Target 2: massless iff projectively collinear

After Target 1, prove the geometric equality condition.

Proposed Lean surface:

```lean
def PairwiseWedgeZero {n : Nat} (psi : Fin n -> CSpinor) : Prop :=
  forall i j, spinorWedge (psi i) (psi j) = 0

theorem pairwise_wedge_zero_iff_common_direction
    {n : Nat} (psi : Fin n -> CSpinor)
    (i0 : Fin n) (hbase : psi i0 0 != 0 \/ psi i0 1 != 0) :
    PairwiseWedgeZero psi <->
      exists c : Fin n -> C, forall i, psi i = c i • psi i0 := by
  ...
```

This turns the Pluecker formula into the clean physical criterion:

```text
the finite bundle is massless exactly when it collapses to one projective
null direction.
```

The fully general determinant-zero version is harder because it needs a
sum-of-squared-complex-moduli zero lemma.  That should be a separate target:

```lean
theorem sum_complexAbsSq_eq_zero_iff ...
```

### Target 3: twistor-Pluecker mass matching

This should begin as a narrow spinor-chart theorem, not a full twistor
geometry module.

Proposed Lean surface:

```lean
structure SpinorChartTwistor where
  omega : CSpinor
  piBar : CSpinor

def infinityTwistorPairing (Z W : SpinorChartTwistor) : C :=
  spinorWedge Z.piBar W.piBar

theorem two_twistor_spinor_chart_mass_eq_plucker
    (Z W : SpinorChartTwistor) :
    complexAbsSq (infinityTwistorPairing Z W) =
      complexAbsSq (spinorWedge Z.piBar W.piBar) := by
  rfl
```

The first theorem is intentionally definitional.  The real value is the
convention table and the follow-up theorem connecting it to
`two_edge_plucker_mass_identity`.  Avoid a trusted claim about full
`SU(2,2)` covariance until the twistor conventions are reviewed.

### Target 4: Higgs legality of chirality flips

Use the existing Standard Model tables before touching dynamics.

Proposed Lean surface:

```lean
inductive YukawaVertex where
  | chargedLepton
  | downQuark
  | upQuark
  | neutrino

def leftHypercharge : YukawaVertex -> Q := ...
def rightHypercharge : YukawaVertex -> Q := ...
def higgsHyperchargeForFlip : YukawaVertex -> Q := ...

theorem yukawa_flip_hypercharge_neutral (v : YukawaVertex) :
    leftHypercharge v + higgsHyperchargeForFlip v - rightHypercharge v = 0 := by
  cases v <;> norm_num
```

This formalizes the slogan:

```text
the Higgs is the representation-theoretic permission for a left-right flip.
```

It should cite the repository's convention `Q = T3 + Y/2` and use exact
rational hypercharges.

### Target 5: diamond curvature API

The current theorem proves gauge invariance of one Abelian diamond defect.
The next layer should make it compositional.

Proposed Lean surface:

```lean
instance [One G] : One (DiamondLabels G) := ...
instance [Mul G] : Mul (DiamondLabels G) := ...
instance [Inv G] : Inv (DiamondLabels G) := ...

theorem diamondDefect_one [Group G] :
    diamondDefect (1 : DiamondLabels G) = 1 := by ...

theorem diamondDefect_mul [CommGroup G] (U V : DiamondLabels G) :
    diamondDefect (U * V) = diamondDefect U * diamondDefect V := by ...

theorem diamondDefect_pureGauge_eq_one [CommGroup G] (g : DiamondGauge G) :
    diamondDefect (gaugeTransformDiamond g 1) = 1 := by ...
```

This is a finite group-theoretic precursor to causal-diamond curvature and
higher gauge theory.

### Target 6: cochain coboundary from chain boundary

The order-complex boundary result already exists.  The next finite theorem is
the cochain dual.

Proposed Lean surface:

```lean
abbrev Cochain (V A : Type*) := Simplex V -> A

def cochainCoboundary ... := ...

theorem cochainCoboundary_comp_self_eq_zero ... := by
  -- dualize chainBoundary_comp_self_eq_zero
```

This is the entry point for a graph-native Kahler-Dirac branch.

## Aristotle strategy

Use SPL-free packages for all null-edge jobs unless an SPL theorem is directly
needed.  Do not include `PhysicsSMDraft.lean`, `PhysicsSMSPL.lean`, or an
active `SpherePacking` requirement.

Recommended project waves:

1. `NullEdgePluckerGeneralAristotle`: Target 1 plus Target 2 helper lemmas.
2. `NullEdgeYukawaFlipAristotle`: Target 4, using existing SM hypercharge
   tables.
3. `NullEdgeDiamondAPIAristotle`: Target 5.
4. `NullEdgeCochainAristotle`: Target 6.
5. `NullEdgeTwistorChartAristotle`: Target 3, after a convention note.

The most ambitious theorem is Target 1.  It is mathematically standard, but
formalizing it cleanly in Lean will make the null-edge mass mechanism much
more durable than any prose statement.

## Claim boundaries

- The current Lean file proves finite algebraic/combinatorial facts, not a
  continuum theory.
- The Pluecker mass identities do not by themselves prove a Dirac continuum
  limit.
- The Higgs target proves representation legality, not mass generation
  dynamics.
- The twistor target should be treated as a convention-checked chart theorem
  until full twistor geometry is formalized.
- The causal-diamond group theorems prove finite gauge-invariant defects, not
  a continuum Stokes theorem.
- The gravity route remains a research direction; near-term Lean targets
  should be finite observables and claim-boundary markers.
