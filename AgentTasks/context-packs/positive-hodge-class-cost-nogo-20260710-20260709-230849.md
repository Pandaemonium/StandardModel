# Aristotle semantic context pack

Generated: 2026-07-09T23:08:56
Query: `nilpotent Kugo-Ojima radical exact directions decoder commutes cohomology variational spectral mass representative invariant`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Algebra/Furey/LadderOperators.lean` [alpha3_dag]

Score: `0.750`

```text
noncomputable def alpha3_dag : ComplexOctonion :=
  { re := { c0:=0, c1:=0, c2:=0, c3:=0, c4:=0, c5:=1/2,  c6:=0, c7:=0 }
    im := { c0:=0, c1:=0, c2:=1/2, c3:=0, c4:=0, c5:=0, c6:=0, c7:=0 } }

-- ============================================================================
-- Nilpotency
-- ============================================================================
```

### 2. `PhysicsSM/Draft/NullEdgeP7CoherenceNotDeterminedByDet.lean` [rhoCoh]

Score: `0.749`

```text
def rhoCoh : RealSym2 :=
  { a := (1 : Real) / 2, b := (1 : Real) / 2, c := (1 : Real) / 4 }

/-- Rational off-diagonal readout separating the two same-det witnesses. -/
```

### 3. `PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean` [innerDerivationIndex]

Score: `0.748`

```text
noncomputable def innerDerivationIndex : InnerDerivationIndex where
  antisymm := innerDerivation_antisymm
  self_zero := innerDerivation_self
  add_left := innerDerivation_add_left
  smul_left := innerDerivation_smul_left
  leibniz := innerDerivation_jordanProduct

/-! ## Krasnov complex module index -/

/-- Bundled index of the Krasnov complex module structure on octonionic qubits,
    plus the centralizer characterization: real-linear maps commuting with
    `J = rightMulE111` are exactly the complex-linear maps. -/
```

### 4. `PhysicsSM/Publication/FureyBaezDVTMainTheorem.lean` [FureyBaezDVTMainTheorem]

Score: `0.748`

```text
tions. -/
  inner_deriv_jacobi_lie : InnerDerivationJacobiLiePackage
  /-- Inner derivations are antisymmetric with respect to the trace form. -/
  derivation_trace_antisymm : DerivationTraceAntisymmetryPackage
  /-- The faithful DVT quotient action of `(SU(3) x SU(3)^op) / Z3`
      on the complement scaffold. -/
  dvt_two_sided_stabilizer : DVTTwoSidedStabilizerPackage
  /-- The complete weak-isospin ladder algebra with commutation relations. -/
  weak_isospin : FureyWeakIsospinLadderPackage
  /-- The G2 stabilizer of the chosen octonion complex line as a group
      equivalence with SU(3). -/
  g2_su3_group_equiv : G2FixingE111GroupEquivPackage
  /-- Proper octonion automorphisms fixing `e111` act through SU(3)
      determinant-one unitary C3 matrices. -/
  g2_automorphism_su3_action : G2AutomorphismSU3ActionPackage
  /-- The older unit-level Z6 quotient equivalence:
      `(U(1) x SU(2) x SU(3)) / Z6 ≃* S(U(2) x U(3))`. -/
  z6_isomorphism : SMCoveringQuotient ≃* SMBlockUnitsSubgroup
  /-- The true product-covering quotient package for
      `U(1) x SU(2) x SU(3) -> S(U(2) x U(3))`. -/
  true_product_quotient_smblock : StandardModelTrueProductCoveringQuotientSMBlockPackage
  /-- The Krasnov centralizer package: real-linear maps commuting with J
      are complex-linear. -/
  krasnov_complex_centralizer : KrasnovComplexCentralizerPackage
  /-- The Krasnov complex structure: right multiplication by `e111` is
      multiplication by `Complex.I` in the complex module structure on `O^2`. -/
  krasnov_J_eq_I : ∀ q : OctonionicQubit, rightMulE111 q = Complex.I • q
  /-- The DVT quotient-to-image equivalence package. -/
  dvt_image_equiv : DVTTwoSidedImageEquivPackage
  /-- The DVT quotient-to-block-action bridge package. -/
  dvt_block_action_bridge : DVTQuotientBlockActi
```

### 5. `FUTURE_DIRECTIONS.md` [Direction 1 — Spectral Triples and Noncommutative Geometry]

Score: `0.748`

```text
## Direction 1 — Spectral Triples and Noncommutative Geometry
```

### 6. `PhysicsSM/Draft/StandardModelAnomalyPackage.lean` [HasRationalEigenvalue]

Score: `0.747`

```text
def HasRationalEigenvalue
    (A : ComplexOctonion →ₗ[Complex] ComplexOctonion)
    (q : Rat) (x : ComplexOctonion) : Prop :=
  A x = (q : Complex) • x

/-- The eight candidate states generated from the complementary idempotent. -/
```

### 7. `PROGRESS.md` [3. Furey-Style Minimal Left Ideal Computations]

Score: `0.746`

```text
## 3. Furey-Style Minimal Left Ideal Computations

The complexified-octonion and Furey layers now include trusted ladder
operators, their daggers, nilpotency statements, and all 27 Cl(6)
anticommutation relations. The primitive idempotent `omega`, the 8-state
minimal left ideal basis, the full action table, number-operator eigenvalues,
electric-charge arithmetic, nonzero witnesses, and linear independence of the
8-state basis are kernel-checked.

This gives the project a concrete, verified algebraic representation space for
future Standard Model convention work.
```

### 8. `PhysicsSM/NullStrand/ZigZag/QuantumWalk.lean` [quantumWalk_sinOmegaSq]

Score: `0.746`

```text
def quantumWalk_sinOmegaSq (a k μ : ℝ) : ℝ :=
  PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.sinOmegaSq a k μ

/-- Coherence identity as a direct rewrite of the draft definition. -/
```

## Scoped paper hits

### 1. Combinatorial and Hodge Laplacians: Similarities and Differences

Score: `0.748`
Zotero key: `9RE64BCV`
DOI: `10.1137/22M1482299`
URL: https://doi.org/10.1137/22M1482299

### 2. Locality properties of Neuberger's lattice Dirac operator

Score: `0.743`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 3. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.742`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 4. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.737`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 5. Toward a spectral theory of cellular sheaves

Score: `0.735`
Zotero key: `CWXAFIF4`
DOI: `10.1007/s41468-019-00038-7`
URL: https://doi.org/10.1007/s41468-019-00038-7
