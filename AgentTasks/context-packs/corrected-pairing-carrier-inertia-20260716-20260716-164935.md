# Aristotle semantic context pack

Generated: 2026-07-16T16:49:48
Query: `normalize five-event corrected pairing carrier basis HasLorentzianInertia equal scales unitsSMul`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/ProbeFrameLorentzGauge.lean` [IsLorentzNormalized]

Score: `0.806`

```text
def IsLorentzNormalized
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame A) : Prop :=
  carrierProbeGram A ell nonlocalityScale x b =
    (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ)

/-- Basis-free Lorentzian-inertia gate: some four-probe frame normalizes the
active carrier form to `(+---)`. -/
```

### 2. `AgentTasks/model-calls/claude/2026-07-16-102530-rank-four-probe-sector-semantic-audit-20260716.md` [Gauge-relative four-probe frames and Lorentzian carrier forms]

Score: `0.801`

```text
(carrierProbeBilinForm A ell nonlocalityScale x)

/-- A frame is Lorentz-normalized when the reconstructed pairing matrix is the
project's mostly-minus Minkowski matrix. -/
def IsLorentzNormalized
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame A) : Prop :=
  carrierProbeGram A ell nonlocalityScale x b =
    (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ)

/-- Basis-free Lorentzian-inertia gate: some four-probe frame normalizes the
active carrier form to `(+---)`. -/
def HasLorentzianInertia
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) : Prop :=
  ∃ b : CarrierProbeFrame A,
    IsLorentzNormalized A ell nonlocalityScale x b

/-- **Recovered local gauge group, conditional on the signature gate.** Once
one probe frame is Lorentz-normalized, another is Lorentz-normalized exactly
when their basis-change matrix is `eta`-orthogonal. -/
theorem isLorentzNormalized_change_iff
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b c : CarrierProbeFrame A)
    (hb : IsLorentzNormalized A ell nonlocalityScale x b) :
    IsLorentzNormalized A ell nonlocalityScale x c ↔
      (b.toMatrix c)ᵀ *
          (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ) *
          b.toMatrix c = MinkowskiConvention.eta := by
  unfold IsLorentzNormalized at hb ⊢
  rw [← carrierProbeGram_change A ell nonlocalityScale x b c, hb]

/-- Lorentzian inertia implies nondegeneracy of the reconstructed carrier
bilinear form. -/
theorem carrierProbeBilinForm_nondegenerate_of_lorentzian
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (hLorentz :
```

### 3. `PhysicsSM/Draft/NullEdge/ProbeFrameLorentzGauge.lean` [carrierProbeGram_change]

Score: `0.793`

```text
theorem carrierProbeGram_change
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b c : CarrierProbeFrame A) :
    (b.toMatrix c)ᵀ * carrierProbeGram A ell nonlocalityScale x b *
        b.toMatrix c =
      carrierProbeGram A ell nonlocalityScale x c := by
  exact LinearMap.BilinForm.toMatrix_mul_basis_toMatrix (b := b) c
    (carrierProbeBilinForm A ell nonlocalityScale x)

/-- A frame is Lorentz-normalized when the reconstructed pairing matrix is the
project's mostly-minus Minkowski matrix. -/
```

### 4. `PhysicsSM/Draft/NullEdge/ProbeFrameWeylScaleBridge.lean` [projectSmeared4DLinearMap_simultaneous_scale]

Score: `0.788`

```text
theorem projectSmeared4DLinearMap_simultaneous_scale
    (C : FiniteCausalOrder V) (lambda ell nonlocalityScale : Real)
    (hlambda : lambda ≠ 0) :
    projectSmeared4DLinearMap C (lambda * ell) (lambda * nonlocalityScale) =
      (lambda ^ 2)⁻¹ •
        projectSmeared4DLinearMap C ell nonlocalityScale := by
  ext phi x
  simp only [projectSmeared4DLinearMap_apply, LinearMap.smul_apply,
    Pi.smul_apply, smul_eq_mul]
  exact projectSmeared4DOperator_simultaneous_scale C lambda ell
    nonlocalityScale hlambda phi x

/-! ## Inverse-metric Weyl weight of the carrier pairing -/

/-- The basis-free corrected carrier pairing inherits inverse-square Weyl
weight from the active operator. -/
```

### 5. `PhysicsSM/Draft/NullEdge/ProbeFrameLorentzGauge.lean` [HasLorentzianInertia]

Score: `0.777`

```text
def HasLorentzianInertia
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) : Prop :=
  ∃ b : CarrierProbeFrame A,
    IsLorentzNormalized A ell nonlocalityScale x b

/-- **Recovered local gauge group, conditional on the signature gate.** Once
one probe frame is Lorentz-normalized, another is Lorentz-normalized exactly
when their basis-change matrix is `eta`-orthogonal. -/
```

### 6. `PhysicsSM/Draft/NullEdge/CorrectedPairingDifferenceCoordinates.lean` [fiveEventDifferenceBasis]

Score: `0.777`

```text
def fiveEventDifferenceBasis :
    Module.Basis (Fin 4) Real (zeroSumFieldSubspace (Fin 5)) :=
  basisOfLinearIndependentOfCardEqFinrank
    fiveEventDifferenceProbe_linearIndependent (by
      norm_num [finrank_fiveEvent_zeroSum])

/-- **Lorentzian nonvacuity control.** In the explicit difference basis, the
signed weighted-difference form has Gram matrix exactly `diag(1,-1,-1,-1)`. -/
```

### 7. `PhysicsSM/Draft/NullEdge/RankFourCarrierProbeSector.lean` [IsSectorLorentzNormalized]

Score: `0.773`

```text
def IsSectorLorentzNormalized
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : SectorFrame P) : Prop :=
  sectorGram A P ell nonlocalityScale x b =
    (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ)

/-- Corrected Lorentzian-inertia gate on a selected rank-four sector. -/
```

### 8. `PhysicsSM/Draft/NullEdge/ProbeFrameLorentzGauge.lean` [isLorentzNormalized_change_iff]

Score: `0.772`

```text
theorem isLorentzNormalized_change_iff
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b c : CarrierProbeFrame A)
    (hb : IsLorentzNormalized A ell nonlocalityScale x b) :
    IsLorentzNormalized A ell nonlocalityScale x c ↔
      (b.toMatrix c)ᵀ *
          (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ) *
          b.toMatrix c = MinkowskiConvention.eta := by
  unfold IsLorentzNormalized at hb ⊢
  rw [← carrierProbeGram_change A ell nonlocalityScale x b c, hb]

/-- Lorentzian inertia implies nondegeneracy of the reconstructed carrier
bilinear form. -/
```

## Scoped paper hits

### 1. Spacetime Entanglement Entropy in 1+1 Dimensions

Score: `0.713`
Zotero key: `8TA2W3MV`
arXiv: `1311.7146`
DOI: `10.1088/0264-9381/31/21/214006`
URL: http://arxiv.org/abs/1311.7146

Abstract:

Computes spacetime entanglement entropy from correlation data in regions of causal sets or continuum spacetimes.

### 2. Scattering Amplitudes For All Masses and Spins

Score: `0.703`
Zotero key: `5J5XDKMN`
arXiv: `1709.04891`
DOI: `10.1007/JHEP11(2021)070`
URL: https://www.zotero.org/19894138/items/5J5XDKMN

### 3. From Twistor-Particle Models to Massive Amplitudes

Score: `0.701`
Zotero key: `zotero:J5GA3CQ8`
arXiv: `2203.08087`
DOI: `10.3842/SIGMA.2022.045`
URL: http://arxiv.org/abs/2203.08087

### 4. Quantum Gravity Phenomenology, Lorentz Invariance and Discreteness

Score: `0.700`
Zotero key: `arxiv:gr-qc/0311055`
arXiv: `gr-qc/0311055`
DOI: `10.1142/S0217732304015026`
URL: http://arxiv.org/abs/gr-qc/0311055

Abstract:

Explains why causal-set discreteness need not break Lorentz invariance and discusses Lorentz-invariant diffusion of massive particles from an underlying causal set.

### 5. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.698`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039
