import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative

noncomputable section

open scoped Matrix.Norms.Frobenius

/-!
# Quadratic curve expansions at the identity

This module packages a second-order expansion

`f(t) = base + t * linear + t^2 * quadratic + t^2 * remainder(t)`

with a remainder tending to zero at `t = 0`.  The data are propagated through
addition, scalar multiplication, continuous linear maps, finite sums, and
noncommutative `4 x 4` matrix multiplication.  The matrix product rule is the
analytic counterpart of the formal `MatrixSecondJet.mul` rule used by the
finite null-edge Palatini calculations.

The structure deliberately records expansion data rather than asserting that
every twice-differentiable curve has such data.  That standard Taylor bridge
can be supplied independently.  Downstream modules use these witnesses to
derive the second-order Palatini Euler coefficient from primitive link and
coframe curves, rather than assuming the scalar coefficient itself.

Claim label: finite-dimensional analytic infrastructure.  Originality tag:
`[comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion

open Filter Topology Asymptotics

/-- A normalized quadratic expansion at zero with an explicit `o(t^2)`
remainder.  This is data in `Type`, because the remainder is part of the
witness. -/
structure QuadraticExpansionAtZero
    {E : Type*} [AddCommGroup E] [TopologicalSpace E] [SMul Real E]
    (curve : Real -> E) (base linear quadratic : E) where
  remainder : Real -> E
  remainder_tendsto : Tendsto remainder (nhds 0) (nhds 0)
  expansion : forall t, curve t =
    base + t • linear + t ^ 2 • quadratic + t ^ 2 • remainder t

namespace QuadraticExpansionAtZero

/-- Package a little-o quadratic Taylor residual as an explicit normalized
remainder.  This is the standard bridge from asymptotic notation to the data
structure used by the finite plaquette product rules. -/
def ofIsLittleO
    {E : Type*} [NormedAddCommGroup E] [NormedSpace Real E]
    {curve : Real -> E} {base linear quadratic : E}
    (hZero : curve 0 = base)
    (hRemainder :
      (fun t => curve t -
        (base + t • linear + t ^ 2 • quadratic)) =o[nhds 0]
          (fun t : Real => t ^ 2)) :
    QuadraticExpansionAtZero curve base linear quadratic where
  remainder := fun t => (t ^ 2)⁻¹ •
    (curve t - (base + t • linear + t ^ 2 • quadratic))
  remainder_tendsto := hRemainder.tendsto_inv_smul_nhds_zero
  expansion := by
    intro t
    by_cases ht : t = 0
    · subst t
      simpa using hZero
    · have htSq : t ^ 2 ≠ 0 := pow_ne_zero 2 ht
      rw [smul_smul, mul_inv_cancel₀ htSq, one_smul]
      module

/-- The first three terms of Mathlib's matrix exponential power series. -/
theorem matrixExpSeriesPartialSum_three
    (matrix : Matrix (Fin 4) (Fin 4) Real) :
    (NormedSpace.expSeries Real (Matrix (Fin 4) (Fin 4) Real)).partialSum
        3 matrix =
      1 + matrix + (1 / 2 : Real) • (matrix * matrix) := by
  simp [FormalMultilinearSeries.partialSum, NormedSpace.expSeries_apply_eq,
    Finset.sum_range_succ, pow_two]

/-- The affine exponent `t A + (t^2 / 2) B` is order `t` at zero. -/
theorem affineMatrixExponent_isBigO
    (A B : Matrix (Fin 4) (Fin 4) Real) :
    (fun t : Real => t • A + ((t ^ 2) / 2) • B) =O[nhds 0]
      (fun t : Real => t) := by
  have hLinearScalar :
      (fun t : Real => t) =O[nhds 0] (fun t : Real => t) :=
    isBigO_refl _ _
  have hLinearConst :
      (fun _ : Real => A) =O[nhds 0] (fun _ : Real => (1 : Real)) :=
    isBigO_const_one Real A _
  have hLinear := hLinearScalar.smul hLinearConst
  have hQuadraticScalar :
      (fun t : Real => t ^ 2 / 2) =O[nhds 0] (fun t : Real => t) := by
    have hPow : (fun t : Real => t ^ 2) =O[nhds 0]
        (fun t : Real => t) := by
      simpa using (isLittleO_pow_pow
        (by norm_num : 1 < 2) : (fun t : Real => t ^ 2) =o[nhds 0]
          (fun t : Real => t ^ 1)).isBigO
    simpa [div_eq_inv_mul] using hPow.const_mul_left (2 : Real)⁻¹
  have hQuadraticConst :
      (fun _ : Real => B) =O[nhds 0] (fun _ : Real => (1 : Real)) :=
    isBigO_const_one Real B _
  have hQuadratic := hQuadraticScalar.smul hQuadraticConst
  simpa using hLinear.add hQuadratic

/-- The cross terms between the linear and quadratic pieces of the affine
exponent are little-o of `t^2`. -/
theorem affineMatrixExpPolynomialResidual_isLittleO
    (A B : Matrix (Fin 4) (Fin 4) Real) :
    (fun t : Real =>
      (1 + (t • A + ((t ^ 2) / 2) • B) +
        (1 / 2 : Real) •
          ((t • A + ((t ^ 2) / 2) • B) *
           (t • A + ((t ^ 2) / 2) • B))) -
      (1 + t • A + t ^ 2 • ((1 / 2 : Real) • (A * A + B)))) =o[nhds 0]
      (fun t : Real => t ^ 2) := by
  have h3 : (fun t : Real => t ^ 3) =o[nhds 0]
      (fun t : Real => t ^ 2) :=
    isLittleO_pow_pow (by norm_num)
  have h3Const :
      (fun _ : Real => (1 / 4 : Real) • (A * B + B * A)) =O[nhds 0]
        (fun _ : Real => (1 : Real)) :=
    isBigO_const_one Real ((1 / 4 : Real) • (A * B + B * A)) _
  have hTerm3 := h3.smul_isBigO h3Const
  have h4 : (fun t : Real => t ^ 4) =o[nhds 0]
      (fun t : Real => t ^ 2) :=
    isLittleO_pow_pow (by norm_num)
  have h4Const :
      (fun _ : Real => (1 / 8 : Real) • (B * B)) =O[nhds 0]
        (fun _ : Real => (1 : Real)) :=
    isBigO_const_one Real ((1 / 8 : Real) • (B * B)) _
  have hTerm4 := h4.smul_isBigO h4Const
  apply (hTerm3.add hTerm4).congr
  · intro t
    ext row column
    simp [Matrix.mul_apply, Fin.sum_univ_four]
    ring
  · intro t
    simp

/-- The exponential of an affine matrix exponent has the expected quadratic
Taylor polynomial, with a little-o `t^2` residual. -/
theorem affineMatrixExpResidual_isLittleO
    (A B : Matrix (Fin 4) (Fin 4) Real) :
    (fun t : Real =>
      NormedSpace.exp (t • A + ((t ^ 2) / 2) • B) -
        (1 + t • A + t ^ 2 • ((1 / 2 : Real) • (A * A + B)))) =o[nhds 0]
      (fun t : Real => t ^ 2) := by
  let exponent : Real -> Matrix (Fin 4) (Fin 4) Real :=
    fun t => t • A + ((t ^ 2) / 2) • B
  have hExp :
      (fun matrix : Matrix (Fin 4) (Fin 4) Real =>
        NormedSpace.exp matrix -
          (1 + matrix + (1 / 2 : Real) • (matrix * matrix))) =O[nhds 0]
        (fun matrix : Matrix (Fin 4) (Fin 4) Real => ‖matrix‖ ^ 3) := by
    have hPower := NormedSpace.exp_hasFPowerSeriesAt_zero
      (𝕂 := Real) (𝔸 := Matrix (Fin 4) (Fin 4) Real)
    have h := hPower.isBigO_sub_partialSum_pow 3
    simpa only [zero_add, matrixExpSeriesPartialSum_three] using h
  have hExponentZero : Tendsto exponent (nhds 0) (nhds 0) := by
    have h : ContinuousAt (fun t : Real =>
        t • A + ((t ^ 2) / 2) • B) 0 := by
      fun_prop
    simpa [exponent, ContinuousAt] using h
  have hTailComp := hExp.comp_tendsto hExponentZero
  have hExponentPow : (fun t : Real => ‖exponent t‖ ^ 3) =O[nhds 0]
      (fun t : Real => t ^ 3) := by
    simpa [exponent] using (affineMatrixExponent_isBigO A B).norm_left.pow 3
  have hTailBigO :
      (fun t : Real => NormedSpace.exp (exponent t) -
        (1 + exponent t +
          (1 / 2 : Real) • (exponent t * exponent t))) =O[nhds 0]
        (fun t : Real => t ^ 3) := by
    simpa [Function.comp_def] using hTailComp.trans hExponentPow
  have hTail :
      (fun t : Real => NormedSpace.exp (exponent t) -
        (1 + exponent t +
          (1 / 2 : Real) • (exponent t * exponent t))) =o[nhds 0]
        (fun t : Real => t ^ 2) :=
    hTailBigO.trans_isLittleO (isLittleO_pow_pow (by norm_num))
  have hPolynomial := affineMatrixExpPolynomialResidual_isLittleO A B
  apply (hTail.add hPolynomial).congr_left
  intro t
  simp only [exponent]
  abel

/-- Explicit quadratic expansion of
`exp(t A + (t^2 / 2) B)` in a real `4 x 4` matrix algebra. -/
def affineMatrixExpExpansion
    (A B : Matrix (Fin 4) (Fin 4) Real) :
    QuadraticExpansionAtZero
      (fun t : Real => NormedSpace.exp
        (t • A + ((t ^ 2) / 2) • B))
      1 A ((1 / 2 : Real) • (A * A + B)) :=
  ofIsLittleO (by simp) (affineMatrixExpResidual_isLittleO A B)

/-- The inverse affine exponential has first coefficient `-A` and affine
second correction `-B`. -/
def affineMatrixExpInverseExpansion
    (A B : Matrix (Fin 4) (Fin 4) Real) :
    QuadraticExpansionAtZero
      (fun t : Real => (NormedSpace.exp
        (t • A + ((t ^ 2) / 2) • B))⁻¹)
      1 (-A) ((1 / 2 : Real) • (A * A - B)) := by
  let expansion := affineMatrixExpExpansion (-A) (-B)
  refine {
    remainder := expansion.remainder
    remainder_tendsto := expansion.remainder_tendsto
    expansion := ?_ }
  intro t
  rw [← Matrix.exp_neg]
  have hArgument : -(t • A + ((t ^ 2) / 2) • B) =
      t • (-A) + ((t ^ 2) / 2) • (-B) := by
    module
  rw [hArgument]
  have hExpansion := expansion.expansion t
  dsimp [expansion] at hExpansion ⊢
  rw [hExpansion]
  congr 1
  noncomm_ring

/-- Transport an expansion across extensional equalities of its curve and
three coefficients. -/
def congr
    {E : Type*} [AddCommGroup E] [TopologicalSpace E] [SMul Real E]
    {f g : Real -> E} {fb fl fq gb gl gq : E}
    (h : QuadraticExpansionAtZero f fb fl fq)
    (hCurve : f = g) (hBase : fb = gb)
    (hLinear : fl = gl) (hQuadratic : fq = gq) :
    QuadraticExpansionAtZero g gb gl gq := by
  subst g
  subst gb
  subst gl
  subst gq
  exact h

/-- The value at zero is the base coefficient. -/
theorem value_zero
    {E : Type*} [AddCommGroup E] [TopologicalSpace E] [Module Real E]
    {curve : Real -> E} {base linear quadratic : E}
    (h : QuadraticExpansionAtZero curve base linear quadratic) :
    curve 0 = base := by
  simpa using h.expansion 0

/-- A normalized quadratic expansion supplies the ordinary first derivative
at zero.  This is the first-order projection of the stored second-order data. -/
theorem hasDerivAt
    {E : Type*} [NormedAddCommGroup E] [NormedSpace Real E]
    {curve : Real -> E} {base linear quadratic : E}
    (h : QuadraticExpansionAtZero curve base linear quadratic) :
    HasDerivAt curve linear 0 := by
  rw [hasDerivAt_iff_tendsto]
  have hQuadraticRemainder :
      Tendsto (fun t => quadratic + h.remainder t) (nhds 0)
        (nhds quadratic) := by
    simpa using tendsto_const_nhds.add h.remainder_tendsto
  have hNormRemainder :
      Tendsto (fun t => ‖quadratic + h.remainder t‖) (nhds 0)
        (nhds ‖quadratic‖) :=
    continuous_norm.continuousAt.tendsto.comp hQuadraticRemainder
  have hNormParameter :
      Tendsto (fun t : Real => ‖t‖) (nhds 0) (nhds 0) := by
    exact tendsto_norm_zero
  have hProduct :
      Tendsto (fun t : Real => ‖t‖ * ‖quadratic + h.remainder t‖)
        (nhds 0) (nhds 0) := by
    simpa using hNormParameter.mul hNormRemainder
  apply hProduct.congr'
  filter_upwards [] with t
  rw [h.expansion t, h.value_zero]
  simp only [sub_zero]
  rw [show
    base + t • linear + t ^ 2 • quadratic + t ^ 2 • h.remainder t -
          base - t • linear =
        t ^ 2 • (quadratic + h.remainder t) by module]
  by_cases ht : t = 0
  · subst t
    simp
  · rw [norm_smul, norm_pow]
    field_simp [ht]

/-- The identically zero curve has the zero quadratic expansion. -/
def zero
    {E : Type*} [AddCommGroup E] [TopologicalSpace E]
    [IsTopologicalAddGroup E] [Module Real E] :
    QuadraticExpansionAtZero (fun _ : Real => (0 : E)) 0 0 0 where
  remainder := fun _ => 0
  remainder_tendsto := tendsto_const_nhds
  expansion := by simp

/-- A constant curve has no linear or quadratic coefficient. -/
def constant
    {E : Type*} [AddCommGroup E] [TopologicalSpace E]
    [IsTopologicalAddGroup E] [Module Real E] (value : E) :
    QuadraticExpansionAtZero (fun _ : Real => value) value 0 0 where
  remainder := fun _ => 0
  remainder_tendsto := tendsto_const_nhds
  expansion := by simp

/-- Addition of two quadratic expansions. -/
def add
    {E : Type*} [AddCommGroup E] [TopologicalSpace E]
    [IsTopologicalAddGroup E] [Module Real E]
    {f g : Real -> E} {fb fl fq gb gl gq : E}
    (hf : QuadraticExpansionAtZero f fb fl fq)
    (hg : QuadraticExpansionAtZero g gb gl gq) :
    QuadraticExpansionAtZero (fun t => f t + g t)
      (fb + gb) (fl + gl) (fq + gq) where
  remainder := fun t => hf.remainder t + hg.remainder t
  remainder_tendsto := by
    simpa using hf.remainder_tendsto.add hg.remainder_tendsto
  expansion := by
    intro t
    rw [hf.expansion t, hg.expansion t]
    module

/-- Negation of a quadratic expansion. -/
def neg
    {E : Type*} [AddCommGroup E] [TopologicalSpace E]
    [IsTopologicalAddGroup E] [Module Real E]
    {f : Real -> E} {base linear quadratic : E}
    (hf : QuadraticExpansionAtZero f base linear quadratic) :
    QuadraticExpansionAtZero (fun t => -f t) (-base) (-linear) (-quadratic) where
  remainder := fun t => -hf.remainder t
  remainder_tendsto := by
    simpa using hf.remainder_tendsto.neg
  expansion := by
    intro t
    rw [hf.expansion t]
    module

/-- Subtraction of quadratic expansions. -/
def sub
    {E : Type*} [AddCommGroup E] [TopologicalSpace E]
    [IsTopologicalAddGroup E] [Module Real E]
    {f g : Real -> E} {fb fl fq gb gl gq : E}
    (hf : QuadraticExpansionAtZero f fb fl fq)
    (hg : QuadraticExpansionAtZero g gb gl gq) :
    QuadraticExpansionAtZero (fun t => f t - g t)
      (fb - gb) (fl - gl) (fq - gq) :=
  by simpa [sub_eq_add_neg] using add hf (neg hg)

/-- Constant real scaling of a quadratic expansion. -/
def constSMul
    {E : Type*} [AddCommGroup E] [TopologicalSpace E]
    [IsTopologicalAddGroup E] [Module Real E] [ContinuousSMul Real E]
    {f : Real -> E} {base linear quadratic : E}
    (scalar : Real)
    (hf : QuadraticExpansionAtZero f base linear quadratic) :
    QuadraticExpansionAtZero (fun t => scalar • f t)
      (scalar • base) (scalar • linear) (scalar • quadratic) where
  remainder := fun t => scalar • hf.remainder t
  remainder_tendsto := by
    simpa using hf.remainder_tendsto.const_smul scalar
  expansion := by
    intro t
    rw [hf.expansion t]
    module

/-- A continuous linear map preserves a quadratic expansion coefficient by
coefficient. -/
def continuousLinearMap
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace Real E]
    [NormedAddCommGroup F] [NormedSpace Real F]
    (map : E →L[Real] F)
    {f : Real -> E} {base linear quadratic : E}
    (hf : QuadraticExpansionAtZero f base linear quadratic) :
    QuadraticExpansionAtZero (fun t => map (f t))
      (map base) (map linear) (map quadratic) where
  remainder := fun t => map (hf.remainder t)
  remainder_tendsto := by
    simpa using map.continuous.continuousAt.tendsto.comp
      hf.remainder_tendsto
  expansion := by
    intro t
    rw [hf.expansion t, map.map_add, map.map_add, map.map_add,
      map.map_smul, map.map_smul, map.map_smul]

/-- Sums over a finite type preserve quadratic expansions. -/
def fintypeSum
    {I E : Type*} [Fintype I] [AddCommGroup E] [TopologicalSpace E]
    [IsTopologicalAddGroup E] [Module Real E]
    (curve : I -> Real -> E) (base linear quadratic : I -> E)
    (h : forall i,
      QuadraticExpansionAtZero (curve i) (base i) (linear i) (quadratic i)) :
    QuadraticExpansionAtZero
      (fun t => Finset.sum Finset.univ (fun i => curve i t))
      (Finset.sum Finset.univ base) (Finset.sum Finset.univ linear)
      (Finset.sum Finset.univ quadratic) where
  remainder := fun t => Finset.sum Finset.univ (fun i => (h i).remainder t)
  remainder_tendsto := by
    simpa using tendsto_finset_sum Finset.univ
      (fun i _ => (h i).remainder_tendsto)
  expansion := by
    classical
    intro t
    simp_rw [(h _).expansion t]
    simp only [Finset.sum_add_distrib, Finset.smul_sum]

/-- Product of two noncommutative `4 x 4` real-matrix expansions. -/
def matrixMul
    {f g : Real -> Matrix (Fin 4) (Fin 4) Real}
    {fb fl fq gb gl gq : Matrix (Fin 4) (Fin 4) Real}
    (hf : QuadraticExpansionAtZero f fb fl fq)
    (hg : QuadraticExpansionAtZero g gb gl gq) :
    QuadraticExpansionAtZero (fun t => f t * g t)
      (fb * gb) (fl * gb + fb * gl)
      (fq * gb + fl * gl + fb * gq) := by
  let remainder : Real -> Matrix (Fin 4) (Fin 4) Real := fun t =>
    hf.remainder t * gb + fb * hg.remainder t +
      t • (fl * (gq + hg.remainder t) +
        (fq + hf.remainder t) * gl) +
      t ^ 2 • ((fq + hf.remainder t) * (gq + hg.remainder t))
  refine ⟨remainder, ?_, ?_⟩
  · dsimp [remainder]
    have hFirst :=
      (hf.remainder_tendsto.mul_const gb).add
        (hg.remainder_tendsto.const_mul fb)
    have hMiddleInner :=
      ((hg.remainder_tendsto.const_add gq).const_mul fl).add
        ((hf.remainder_tendsto.const_add fq).mul_const gl)
    have hMiddle :=
      (show Tendsto (fun t : Real => t) (nhds 0) (nhds 0) by
        simpa using
          (tendsto_id : Tendsto (fun t : Real => t) (nhds 0) (nhds 0))).smul
        hMiddleInner
    have hLastInner :=
      (hf.remainder_tendsto.const_add fq).mul
        (hg.remainder_tendsto.const_add gq)
    have hLast :=
      (show Tendsto (fun t : Real => t ^ 2) (nhds 0) (nhds 0) by
        simpa using
          ((tendsto_id : Tendsto (fun t : Real => t)
            (nhds 0) (nhds 0)).pow 2)).smul hLastInner
    simpa using (hFirst.add hMiddle).add hLast
  · intro t
    rw [hf.expansion t, hg.expansion t]
    dsimp [remainder]
    simp only [add_mul, mul_add, smul_mul_assoc, mul_smul_comm,
      smul_add, smul_smul]
    module

/-- A scalar curve that vanishes near zero has zero quadratic coefficient.
The proof uses the punctured neighborhood only to divide by `t^2`; the stored
remainder itself converges on the full neighborhood. -/
theorem quadratic_eq_zero_of_eventually_eq_zero
    {curve : Real -> Real} {quadratic : Real}
    (hExpansion : QuadraticExpansionAtZero curve 0 0 quadratic)
    (hZero : Filter.Eventually (fun t => curve t = 0) (nhds 0)) :
    quadratic = 0 := by
  have hZeroWithin :
      Filter.Eventually (fun t => curve t = 0) (nhdsWithin 0 {0}ᶜ) :=
    hZero.filter_mono inf_le_left
  have hCoefficient : Filter.EventuallyEq (nhdsWithin 0 {0}ᶜ)
      (fun t => quadratic + hExpansion.remainder t) (fun _ => 0) := by
    filter_upwards [hZeroWithin, self_mem_nhdsWithin] with t hCurve ht
    have h := hExpansion.expansion t
    rw [hCurve] at h
    simp only [zero_add, smul_eq_mul] at h
    nlinarith [sq_pos_of_ne_zero (by simpa using ht)]
  have hRemainderWithin :
      Tendsto hExpansion.remainder (nhdsWithin 0 {0}ᶜ) (nhds 0) :=
    hExpansion.remainder_tendsto.mono_left inf_le_left
  have hToQuadratic :
      Tendsto (fun t => quadratic + hExpansion.remainder t)
        (nhdsWithin 0 {0}ᶜ) (nhds quadratic) := by
    simpa using tendsto_const_nhds.add hRemainderWithin
  have hToZero :
      Tendsto (fun t => quadratic + hExpansion.remainder t)
        (nhdsWithin 0 {0}ᶜ) (nhds 0) :=
    tendsto_const_nhds.congr' hCoefficient.symm
  exact tendsto_nhds_unique hToQuadratic hToZero

/-- A scalar curve that vanishes identically has zero quadratic coefficient.
The proof uses the punctured neighborhood only to divide by `t^2`; the stored
remainder itself converges on the full neighborhood. -/
theorem quadratic_eq_zero_of_eq_zero
    {curve : Real -> Real} {quadratic : Real}
    (hExpansion : QuadraticExpansionAtZero curve 0 0 quadratic)
    (hZero : forall t, curve t = 0) :
    quadratic = 0 := by
  have hCoefficient : forall t : Real, t ≠ 0 ->
      quadratic + hExpansion.remainder t = 0 := by
    intro t ht
    have h := hExpansion.expansion t
    rw [hZero t] at h
    simp only [zero_add, smul_eq_mul] at h
    nlinarith [sq_pos_of_ne_zero ht]
  have hRemainderWithin :
      Tendsto hExpansion.remainder (nhdsWithin 0 {0}ᶜ) (nhds 0) :=
    hExpansion.remainder_tendsto.mono_left inf_le_left
  have hToQuadratic :
      Tendsto (fun t => quadratic + hExpansion.remainder t)
        (nhdsWithin 0 {0}ᶜ) (nhds quadratic) := by
    simpa using tendsto_const_nhds.add hRemainderWithin
  have hEventuallyZero :
      (fun t => quadratic + hExpansion.remainder t) =ᶠ[nhdsWithin 0 {0}ᶜ]
        (fun _ => 0) := by
    filter_upwards [self_mem_nhdsWithin] with t ht
    exact hCoefficient t (by simpa using ht)
  have hToZero :
      Tendsto (fun t => quadratic + hExpansion.remainder t)
        (nhdsWithin 0 {0}ᶜ) (nhds 0) :=
    tendsto_const_nhds.congr' hEventuallyZero.symm
  exact tendsto_nhds_unique hToQuadratic hToZero

end QuadraticExpansionAtZero

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion.QuadraticExpansionAtZero.affineMatrixExpExpansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms QuadraticExpansionAtZero.affineMatrixExpExpansion

/-- info: 'PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion.QuadraticExpansionAtZero.affineMatrixExpInverseExpansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms QuadraticExpansionAtZero.affineMatrixExpInverseExpansion

/-- info: 'PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion.QuadraticExpansionAtZero.ofIsLittleO' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms QuadraticExpansionAtZero.ofIsLittleO

/-- info: 'PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion.QuadraticExpansionAtZero.hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms QuadraticExpansionAtZero.hasDerivAt

/-- info: 'PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion.QuadraticExpansionAtZero.matrixMul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms QuadraticExpansionAtZero.matrixMul

/-- info: 'PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion.QuadraticExpansionAtZero.quadratic_eq_zero_of_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms QuadraticExpansionAtZero.quadratic_eq_zero_of_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion.QuadraticExpansionAtZero.quadratic_eq_zero_of_eventually_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms QuadraticExpansionAtZero.quadratic_eq_zero_of_eventually_eq_zero

end PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion
