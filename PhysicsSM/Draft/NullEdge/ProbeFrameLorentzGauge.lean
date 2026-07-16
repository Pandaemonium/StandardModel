import PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace
import PhysicsSM.Draft.NullEdge.MinkowskiConvention

/-!
# Gauge-relative four-probe frames and Lorentzian carrier forms

`IntrinsicProbeSubspace.lean` shows that a scalar-probe subspace can be natural
under every finite-order isomorphism even when no ordered list of nonzero
probes can be selected pointwise naturally. This module supplies the next
finite tetrad bridge.

The active smeared causal operator is first bundled as a real-linear map. Its
corrected principal-symbol pairing therefore becomes a genuine symmetric
bilinear form on each closed Alexandrov carrier's zero-sum probe subspace. A
four-probe frame is a basis of that subspace indexed by `Fin 4`, and its Gram
matrix is the matrix of the corrected bilinear form in that basis.

Mathlib's change-of-basis theorem then gives the exact congruence law

`G_c = M^T G_b M`.

Consequently, if one frame normalizes the pairing to the project convention
`eta = diag(1,-1,-1,-1)`, a second frame has the same normalization exactly
when its transition matrix is `eta`-orthogonal. Thus a successful four-mode
operator reconstruction determines a Lorentz gauge class of probe frames,
not a preferred tetrad. The existence of such a normalized frame is also
preserved and reflected by every ambient causal-order isomorphism.

This is a finite conditional reconstruction theorem. It does not prove that a
four-probe frame exists on physical refinement carriers, that the corrected
form has Lorentzian inertia there, or that either object converges to a smooth
cotangent frame and metric.

Claim grade: `M [orig]` for the finite linearity, congruence, gauge, and
order-covariance statements. Provenance: program-internal composition of the
active Benincasa-Dowker operator, the intrinsic probe-subspace bridge,
Mathlib's bilinear-form change-of-basis theorem, and the project's
`MinkowskiConvention` grounded in Mathlib's `indefiniteDiagonal`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge

open scoped BigOperators

open AlexandrovAlgebraGerm
open AlexandrovGermPacking
open AlexandrovGermInternalOperator
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace
open Matrix

variable {V W : Type} [Fintype V] [Fintype W]

/-! ## The active operator as a linear map -/

/-- The layered past sum is additive in its scalar field. -/
theorem layeredPastSum_add_real
    (C : FiniteCausalOrder V) (coefficient : Nat → ℝ)
    (f h : V → ℝ) (x : V) :
    C.layeredPastSum coefficient (f + h) x =
      C.layeredPastSum coefficient f x +
        C.layeredPastSum coefficient h x := by
  unfold FiniteCausalOrder.layeredPastSum
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro y _
  by_cases hbefore : C.before y x <;> simp [hbefore, mul_add]

/-- The layered past sum is homogeneous in its scalar field. -/
theorem layeredPastSum_smul_real
    (C : FiniteCausalOrder V) (coefficient : Nat → ℝ)
    (c : ℝ) (f : V → ℝ) (x : V) :
    C.layeredPastSum coefficient (c • f) x =
      c * C.layeredPastSum coefficient f x := by
  unfold FiniteCausalOrder.layeredPastSum
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro y _
  by_cases hbefore : C.before y x <;> simp [hbefore]
  ring

/-- Every real layered operator is a linear map on finite scalar fields. -/
def layeredOperatorLinearMap
    (C : FiniteCausalOrder V) (prefactor diagonal : ℝ)
    (coefficient : Nat → ℝ) : (V → ℝ) →ₗ[ℝ] (V → ℝ) where
  toFun := C.layeredOperator prefactor diagonal coefficient
  map_add' f h := by
    funext x
    unfold FiniteCausalOrder.layeredOperator
    rw [layeredPastSum_add_real]
    simp only [Pi.add_apply]
    ring
  map_smul' c f := by
    funext x
    change C.layeredOperator prefactor diagonal coefficient (c • f) x =
      c * C.layeredOperator prefactor diagonal coefficient f x
    unfold FiniteCausalOrder.layeredOperator
    rw [layeredPastSum_smul_real]
    simp only [Pi.smul_apply, smul_eq_mul]
    ring

/-- Linear-map packaging of the source-native local four-dimensional
operator. -/
def sourceLocal4DLinearMap (C : FiniteCausalOrder V) (ell : ℝ) :
    (V → ℝ) →ₗ[ℝ] (V → ℝ) :=
  layeredOperatorLinearMap C (sourceLocal4DPrefactor ell) (-1)
    sourceLocal4DCoefficient

/-- Linear-map packaging of the source-native smeared four-dimensional
operator, including its equal-scale branch. -/
def sourceSmeared4DLinearMap
    (C : FiniteCausalOrder V) (ell nonlocalityScale : ℝ) :
    (V → ℝ) →ₗ[ℝ] (V → ℝ) :=
  if smearingEpsilon ell nonlocalityScale = 1 then
    sourceLocal4DLinearMap C ell
  else
    layeredOperatorLinearMap C
      (4 / (Real.sqrt 6 * nonlocalityScale ^ 2)) (-1)
      (sourceSmeared4DCoefficient
        (smearingEpsilon ell nonlocalityScale))

/-- Linear-map packaging of the active project-sign smeared operator. -/
def projectSmeared4DLinearMap
    (C : FiniteCausalOrder V) (ell nonlocalityScale : ℝ) :
    (V → ℝ) →ₗ[ℝ] (V → ℝ) :=
  -sourceSmeared4DLinearMap C ell nonlocalityScale

/-- The bundled linear map has exactly the previously defined active operator
as its underlying function. -/
@[simp] theorem projectSmeared4DLinearMap_apply
    (C : FiniteCausalOrder V) (ell nonlocalityScale : ℝ) (f : V → ℝ) :
    projectSmeared4DLinearMap C ell nonlocalityScale f =
      projectSmeared4DOperator C ell nonlocalityScale f := by
  ext x
  simp only [projectSmeared4DLinearMap, sourceSmeared4DLinearMap,
    sourceLocal4DLinearMap, layeredOperatorLinearMap,
    projectSmeared4DOperator, sourceSmeared4DOperator,
    LinearMap.neg_apply, Pi.neg_apply]
  split_ifs <;> rfl

/-! ## Corrected pairing as a symmetric bilinear form -/

/-- A linear finite-field operator produces a bilinear corrected pairing at
each event. -/
def correctedPairingBilinFormAt
    (B : (V → ℝ) →ₗ[ℝ] (V → ℝ)) (x : V) :
    LinearMap.BilinForm ℝ (V → ℝ) :=
  LinearMap.mk₂ ℝ (fun f h => correctedPairingAt B x f h)
    (by
      intro f g h
      simp [correctedPairingAt, add_mul]
      ring)
    (by
      intro c f h
      simp [correctedPairingAt]
      ring)
    (by
      intro f h k
      simp [correctedPairingAt, mul_add]
      ring)
    (by
      intro c f h
      simp [correctedPairingAt]
      ring)

omit [Fintype V] in
/-- The bilinear packaging evaluates to the original corrected pairing. -/
@[simp] theorem correctedPairingBilinFormAt_apply
    (B : (V → ℝ) →ₗ[ℝ] (V → ℝ)) (x : V) (f h : V → ℝ) :
    correctedPairingBilinFormAt B x f h = correctedPairingAt B x f h :=
  rfl

/-- The active corrected pairing restricted to one carrier's natural probe
subspace, as a genuine bilinear form. -/
def carrierProbeBilinForm
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) :
    LinearMap.BilinForm ℝ (carrierProbeSubspace A) :=
  (correctedPairingBilinFormAt
      (projectSmeared4DLinearMap (inducedOrder A) ell nonlocalityScale) x).comp
    (carrierProbeSubspace A).subtype (carrierProbeSubspace A).subtype

/-- The carrier bilinear form is definitionally the existing basis-free
carrier pairing. -/
@[simp] theorem carrierProbeBilinForm_apply
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : carrierProbeSubspace A) :
    carrierProbeBilinForm A ell nonlocalityScale x f h =
      carrierProbePairing A ell nonlocalityScale x f h := by
  change correctedPairingAt
      (⇑(projectSmeared4DLinearMap (inducedOrder A) ell nonlocalityScale))
      x f.1 h.1 =
    correctedPairingAt
      (projectSmeared4DOperator (inducedOrder A) ell nonlocalityScale)
      x f.1 h.1
  congr 1
  funext u
  exact projectSmeared4DLinearMap_apply
    (inducedOrder A) ell nonlocalityScale u

/-- The active carrier form is symmetric. -/
theorem carrierProbeBilinForm_isSymm
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) :
    (carrierProbeBilinForm A ell nonlocalityScale x).IsSymm := by
  refine LinearMap.BilinForm.isSymm_def.mpr (fun f h => ?_)
  simp only [carrierProbeBilinForm_apply]
  exact carrierProbePairing_comm A ell nonlocalityScale x f h

/-! ## Four-probe frames, Gram congruence, and Lorentz gauge -/

/-- A four-probe carrier frame is a basis of the natural probe subspace. Its
existence is a substantive rank-four condition. -/
abbrev CarrierProbeFrame
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) :=
  Module.Basis (Fin 4) ℝ (carrierProbeSubspace A)

/-- Matrix of the active corrected pairing in a four-probe frame. -/
def carrierProbeGram
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame A) : Matrix (Fin 4) (Fin 4) ℝ :=
  LinearMap.BilinForm.toMatrix b
    (carrierProbeBilinForm A ell nonlocalityScale x)

/-- Entries of the frame Gram matrix are the corrected pairings of its probe
vectors. -/
theorem carrierProbeGram_apply
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame A) (i j : Fin 4) :
    carrierProbeGram A ell nonlocalityScale x b i j =
      carrierProbePairing A ell nonlocalityScale x (b i) (b j) := by
  simp [carrierProbeGram]

/-- **Exact tetrad change law.** Corrected-pairing matrices in any two
four-probe frames are related by matrix congruence. -/
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
    (hLorentz : HasLorentzianInertia A ell nonlocalityScale x) :
    (carrierProbeBilinForm A ell nonlocalityScale x).Nondegenerate := by
  rcases hLorentz with ⟨b, hb⟩
  apply (LinearMap.BilinForm.nondegenerate_iff_det_ne_zero b).2
  change (carrierProbeGram A ell nonlocalityScale x b).det ≠ 0
  rw [hb, MinkowskiConvention.eta_det]
  norm_num

/-! ## Exact transport under causal-order isomorphism -/

/-- Push a four-probe frame along the intrinsic carrier equivalence. -/
def mapCarrierProbeFrame
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (b : CarrierProbeFrame A) : CarrierProbeFrame (A.map e) :=
  b.map (carrierProbeLinearEquiv e A)

/-- Pull a four-probe frame back along the intrinsic carrier equivalence. -/
def pullCarrierProbeFrame
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (b : CarrierProbeFrame (A.map e)) : CarrierProbeFrame A :=
  b.map (carrierProbeLinearEquiv e A).symm

/-- Pushing a frame along an order isomorphism leaves its corrected-pairing
matrix exactly unchanged. -/
theorem carrierProbeGram_mapOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame A) :
    carrierProbeGram (A.map e) ell nonlocalityScale
        (closedCarrierEquiv e A x) (mapCarrierProbeFrame e A b) =
      carrierProbeGram A ell nonlocalityScale x b := by
  ext i j
  rw [carrierProbeGram_apply, carrierProbeGram_apply]
  change carrierProbePairing (A.map e) ell nonlocalityScale
      (closedCarrierEquiv e A x)
      (carrierProbeLinearEquiv e A (b i))
      (carrierProbeLinearEquiv e A (b j)) =
    carrierProbePairing A ell nonlocalityScale x (b i) (b j)
  exact carrierProbePairing_equivariant e A ell nonlocalityScale x (b i) (b j)

/-- Pulling a target frame back along an order isomorphism also leaves its Gram
matrix exactly unchanged. -/
theorem carrierProbeGram_pullOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame (A.map e)) :
    carrierProbeGram A ell nonlocalityScale x
        (pullCarrierProbeFrame e A b) =
      carrierProbeGram (A.map e) ell nonlocalityScale
        (closedCarrierEquiv e A x) b := by
  ext i j
  rw [carrierProbeGram_apply, carrierProbeGram_apply]
  change carrierProbePairing A ell nonlocalityScale x
      ((carrierProbeLinearEquiv e A).symm (b i))
      ((carrierProbeLinearEquiv e A).symm (b j)) =
    carrierProbePairing (A.map e) ell nonlocalityScale
      (closedCarrierEquiv e A x) (b i) (b j)
  symm
  simpa using carrierProbePairing_equivariant e A ell nonlocalityScale x
    ((carrierProbeLinearEquiv e A).symm (b i))
    ((carrierProbeLinearEquiv e A).symm (b j))

/-- The basis-free Lorentzian-inertia gate is exactly invariant under every
ambient causal-order isomorphism. -/
theorem hasLorentzianInertia_orderIso_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) :
    HasLorentzianInertia (A.map e) ell nonlocalityScale
        (closedCarrierEquiv e A x) ↔
      HasLorentzianInertia A ell nonlocalityScale x := by
  constructor
  · rintro ⟨b, hb⟩
    refine ⟨pullCarrierProbeFrame e A b, ?_⟩
    unfold IsLorentzNormalized at hb ⊢
    rw [carrierProbeGram_pullOrderIso]
    exact hb
  · rintro ⟨b, hb⟩
    refine ⟨mapCarrierProbeFrame e A b, ?_⟩
    unfold IsLorentzNormalized at hb ⊢
    rw [carrierProbeGram_mapOrderIso]
    exact hb

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.carrierProbeGram_change' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.carrierProbeGram_change

/-- info: 'PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.isLorentzNormalized_change_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.isLorentzNormalized_change_iff

/-- info: 'PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.hasLorentzianInertia_orderIso_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.hasLorentzianInertia_orderIso_iff

end PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge
