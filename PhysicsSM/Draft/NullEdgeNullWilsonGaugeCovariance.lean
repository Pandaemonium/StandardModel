import Mathlib

/-!
# C73: Gauge-covariant link-dressed null-Wilson regulator

This module is the Aristotle deliverable for proof-chain task **C73** of the
null-edge unified-mass program (context pack
`AgentTasks/context-packs/null-edge-gate-c-null-wilson-20260627-063900.md`).

## The target object

The null-Wilson regulator is the link-dressed analogue of the lattice Wilson
term.  In direction `a` it pairs the **retarded** dressed null-edge transport
`Tₐᴬ` with its Hilbert adjoint `(Tₐᴬ)♯` (the **advanced** dressed transport) and
subtracts both from twice the identity:

```text
R_W^A = (r / (2h)) · ∑_a (2 − Tₐᴬ − (Tₐᴬ)♯).
```

It is the gauge-covariant momentum filter that lifts the doublers in the
positive / Euclidean Hodge–Dirac sector.

## What is proved here (no `sorry`, axiom-clean)

We realise the regulator on a genuine finite Hilbert space of fields
`Ψ = V → (Fin n → ℂ)` over a finite vertex set `V`, with:

* a per-direction displacement bijection `e a : Equiv.Perm V` (the null-edge
  shift `v ↦ v + ê_a`), and
* a link / parallel-transport field `U a v : Matrix (Fin n) (Fin n) ℂ` dressing
  the shift across that edge.

The **forward dressed transport** `Tₐ` and its **sharp** `Tₐ♯` are

```text
(Tₐ ψ) v = (U a v) *ᵥ ψ (e a v),
(Tₐ♯ ψ) v = (U a (e a).symm v)ᴴ *ᵥ ψ ((e a).symm v),
```

and `Tₐ♯` is the genuine Hilbert adjoint of `Tₐ` for the Hermitian inner product
`⟪x, ψ⟫ = ∑_v ∑_i conj (x v i) · (ψ v i)` (`nullWilson_shift_adjoint`).

1. **`nullWilson_gaugeCovariant`.**  Under the usual *source/target* gauge action
   — fields `ψ v ↦ g v *ᵥ ψ v` and links `U a v ↦ g v · U a v · (g (e a v))⁻¹`
   (`gaugeLink`) — the regulator is gauge covariant: its output at every vertex
   transforms by the single base-point factor `g v`,
   `R_W^{Aᵍ} ψᵍ = g · (R_W^A ψ)` pointwise.  Only the unitarity
   `star (g v) * g v = 1` of the gauge transformation is used.

2. **`nullWilson_selfAdjoint`.**  The regulator is **Hilbert self-adjoint**:
   `⟪x, R_W^A ψ⟫ = ⟪R_W^A x, ψ⟫`.  This is the *answer to the adjointness
   question*: the symmetric combination `2 − Tₐ − Tₐ♯` with one common real
   coefficient `r/(2h)` pairs each retarded transport with its own advanced
   adjoint, so the operator is genuinely Hermitian on the positive-definite
   Hilbert space — **not** merely Krein self-adjoint and **not** a
   retarded/advanced pair that is only adjoint *across* a doubled space.  (The
   asymmetric causal-update branch projectors of C61 are the Krein-paired
   objects; the Wilson regulator is the symmetric Hilbert one.)

3. **`nullWilson_flat_symbol` / `wilsonFlatSymbol_eq`.**  In the trivial flat
   gauge the dressed transports become pure shifts that diagonalise on a plane
   wave with `Tₐ ψ = e^{i qₐ} ψ`, `Tₐ♯ ψ = e^{-i qₐ} ψ`.  The regulator then acts
   as the scalar **flat Wilson symbol**

   ```text
   (r/(2h)) · ∑_a (2 − e^{i qₐ} − e^{-i qₐ}) = (r/h) · ∑_a (1 − cos qₐ),
   ```

   recovering the standard Wilson dispersion.

## Honesty discipline

The model is an *exact* finite Hilbert-space realisation; every theorem is a
proven matrix/inner-product identity, not a postulated contract.  The dynamical
inputs of Gate C (the actual Clifford symbol after gauge coupling, ghost-zero
safety, the weak-coupling deformation) are **not** addressed here and remain the
open obligations of `NullEdgeGateCGhostZeroSafety` /
`NullEdgeGaugeCovariantBranchProjectors`.  Gauge covariance and Hilbert
self-adjointness are necessary, not sufficient, for physical safety.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeNullWilsonGaugeCovariance

open Matrix
open scoped BigOperators

/-! ## 0. Hermitian fibre inner product and the field inner product -/

variable {n : ℕ} {V : Type*} {ι : Type*}

/-- Hermitian inner product on the gauge fibre `Fin n → ℂ`:
`⟪x, w⟫ = ∑ i conj (x i) · w i = star x ⬝ᵥ w`. -/
def cinner (x w : Fin n → ℂ) : ℂ := star x ⬝ᵥ w

/-- **Fibre adjoint identity.**  Moving a matrix across the Hermitian fibre inner
product replaces it by its conjugate transpose: `⟪x, M *ᵥ w⟫ = ⟪Mᴴ *ᵥ x, w⟫`. -/
theorem cinner_mulVec_right (M : Matrix (Fin n) (Fin n) ℂ) (x w : Fin n → ℂ) :
    cinner x (M *ᵥ w) = cinner (Mᴴ *ᵥ x) w := by
  unfold cinner
  rw [Matrix.dotProduct_mulVec, Matrix.star_mulVec]
  simp [Matrix.conjTranspose_conjTranspose]

/-- The Hermitian inner product on the finite field space `Ψ = V → (Fin n → ℂ)`:
`⟪x, ψ⟫ = ∑_v ⟪x v, ψ v⟫`. -/
def innerΨ [Fintype V] (x ψ : V → (Fin n → ℂ)) : ℂ := ∑ v, cinner (x v) (ψ v)

/-! ### Sesquilinearity helpers for `innerΨ` -/

/-- `innerΨ` is linear in its second argument under fibrewise scaling. -/
lemma innerΨ_smul_right [Fintype V] (c : ℂ) (x φ : V → Fin n → ℂ) :
    innerΨ x (fun v => c • φ v) = c * innerΨ x φ := by
  unfold innerΨ cinner
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl; intro v _
  simp [dotProduct_smul, smul_eq_mul]

/-- `innerΨ` is conjugate-linear in its first argument under fibrewise scaling. -/
lemma innerΨ_smul_left [Fintype V] (c : ℂ) (x φ : V → Fin n → ℂ) :
    innerΨ (fun v => c • x v) φ = (starRingEnd ℂ) c * innerΨ x φ := by
  unfold innerΨ cinner
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl; intro v _
  simp [star_smul, smul_dotProduct, smul_eq_mul]

/-- `innerΨ` is additive (subtractive) in its second argument. -/
lemma innerΨ_sub_right [Fintype V] (x a b : V → Fin n → ℂ) :
    innerΨ x (fun v => a v - b v) = innerΨ x a - innerΨ x b := by
  unfold innerΨ cinner
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl; intro v _
  simp [dotProduct_sub]

/-- `innerΨ` is additive (subtractive) in its first argument. -/
lemma innerΨ_sub_left [Fintype V] (a b φ : V → Fin n → ℂ) :
    innerΨ (fun v => a v - b v) φ = innerΨ a φ - innerΨ b φ := by
  unfold innerΨ cinner
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl; intro v _
  simp [star_sub, sub_dotProduct]

/-- `innerΨ` commutes with finite sums in its second argument. -/
lemma innerΨ_sum_right [Fintype V] [Fintype ι] (x : V → Fin n → ℂ)
    (φ : ι → V → Fin n → ℂ) :
    innerΨ x (fun v => ∑ a, φ a v) = ∑ a, innerΨ x (φ a) := by
  unfold innerΨ cinner
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl; intro v _
  simp [dotProduct_sum]

/-- `innerΨ` commutes with finite sums in its first argument. -/
lemma innerΨ_sum_left [Fintype V] [Fintype ι] (φ : ι → V → Fin n → ℂ)
    (ψ : V → Fin n → ℂ) :
    innerΨ (fun v => ∑ a, φ a v) ψ = ∑ a, innerΨ (φ a) ψ := by
  unfold innerΨ cinner
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl; intro v _
  simp [star_sum, sum_dotProduct]

/-! ## 1. The link / parallel-transport gauge action (source/target) -/

/-- The source/target gauge transform of a link `U` running from vertex `a` to
vertex `b`: `gaugeLink g U a b = g a · U · (g b)⁻¹ = g a · U · star (g b)`. -/
def gaugeLink (g : V → Matrix (Fin n) (Fin n) ℂ)
    (U : Matrix (Fin n) (Fin n) ℂ) (a b : V) : Matrix (Fin n) (Fin n) ℂ :=
  g a * U * star (g b)

/-! ## 2. The dressed null-edge transport `Tₐ` and its sharp `Tₐ♯` -/

/-- The **forward dressed null-edge transport** in direction with displacement
`ea : Equiv.Perm V` and link field `Ua : V → Matrix`:
`(T ψ) v = (Ua v) *ᵥ ψ (ea v)`. -/
def fwdShift (Ua : V → Matrix (Fin n) (Fin n) ℂ) (ea : Equiv.Perm V)
    (ψ : V → (Fin n → ℂ)) : V → (Fin n → ℂ) :=
  fun v => (Ua v) *ᵥ ψ (ea v)

/-- The **sharp / advanced dressed transport** `T♯`, defined as the Hilbert
adjoint of `fwdShift`:
`(T♯ ψ) v = (Ua (ea.symm v))ᴴ *ᵥ ψ (ea.symm v)`. -/
def sharpShift (Ua : V → Matrix (Fin n) (Fin n) ℂ) (ea : Equiv.Perm V)
    (ψ : V → (Fin n → ℂ)) : V → (Fin n → ℂ) :=
  fun v => (Ua (ea.symm v))ᴴ *ᵥ ψ (ea.symm v)

/-- **Adjointness of the dressed transport.**  `sharpShift` is the genuine
Hilbert adjoint of `fwdShift`: `⟪x, T ψ⟫ = ⟪T♯ x, ψ⟫`. -/
theorem nullWilson_shift_adjoint [Fintype V] (Ua : V → Matrix (Fin n) (Fin n) ℂ)
    (ea : Equiv.Perm V) (x ψ : V → (Fin n → ℂ)) :
    innerΨ x (fwdShift Ua ea ψ) = innerΨ (sharpShift Ua ea x) ψ := by
  unfold innerΨ fwdShift sharpShift
  rw [← Equiv.sum_comp ea (fun w => cinner ((Ua (ea.symm w))ᴴ *ᵥ x (ea.symm w)) (ψ w))]
  apply Finset.sum_congr rfl
  intro v _
  rw [cinner_mulVec_right]
  simp [Equiv.symm_apply_apply]

/-- The reverse adjoint relation: `⟪x, T♯ ψ⟫ = ⟪T x, ψ⟫`. -/
theorem nullWilson_sharp_adjoint [Fintype V] (Ua : V → Matrix (Fin n) (Fin n) ℂ)
    (ea : Equiv.Perm V) (x ψ : V → (Fin n → ℂ)) :
    innerΨ x (sharpShift Ua ea ψ) = innerΨ (fwdShift Ua ea x) ψ := by
  unfold innerΨ fwdShift sharpShift
  rw [← Equiv.sum_comp ea.symm (fun w => cinner ((Ua w) *ᵥ x (ea w)) (ψ w))]
  apply Finset.sum_congr rfl
  intro v _
  rw [cinner_mulVec_right]
  simp [Equiv.apply_symm_apply, Matrix.conjTranspose_conjTranspose]

/-! ## 3. The null-Wilson regulator -/

/-- The **null-Wilson regulator**
`R_W^A = (r/(2h)) · ∑_a (2 − Tₐ − Tₐ♯)`, evaluated as a field. -/
def nullWilson [Fintype ι] (r h : ℝ) (U : ι → V → Matrix (Fin n) (Fin n) ℂ)
    (e : ι → Equiv.Perm V) (ψ : V → (Fin n → ℂ)) : V → (Fin n → ℂ) :=
  fun v => ((r / (2 * h) : ℝ) : ℂ) •
    (∑ a, ((2 : ℂ) • ψ v - fwdShift (U a) (e a) ψ v - sharpShift (U a) (e a) ψ v))

/-! ## 4. Gauge covariance (source/target action) -/

/-- The gauge-transformed link field: `Uᵍ a v = gaugeLink g (U a v) v (e a v)`. -/
def gaugedLinks (g : V → Matrix (Fin n) (Fin n) ℂ)
    (U : ι → V → Matrix (Fin n) (Fin n) ℂ) (e : ι → Equiv.Perm V) :
    ι → V → Matrix (Fin n) (Fin n) ℂ :=
  fun a v => gaugeLink g (U a v) v (e a v)

/-- The gauge-transformed field: `ψᵍ v = g v *ᵥ ψ v`. -/
def gaugedField (g : V → Matrix (Fin n) (Fin n) ℂ) (ψ : V → (Fin n → ℂ)) :
    V → (Fin n → ℂ) :=
  fun v => g v *ᵥ ψ v

/-- **Covariance of one forward dressed transport** (`dressedHop_gauge` form):
`(Tₐᵍ ψᵍ) v = g v *ᵥ (Tₐ ψ) v`. -/
theorem fwdShift_gauge_covariant (g : V → Matrix (Fin n) (Fin n) ℂ)
    (Ua : V → Matrix (Fin n) (Fin n) ℂ) (ea : Equiv.Perm V)
    (ψ : V → (Fin n → ℂ)) (hg : ∀ v, star (g v) * g v = 1) (v : V) :
    fwdShift (fun w => gaugeLink g (Ua w) w (ea w)) ea (gaugedField g ψ) v
      = g v *ᵥ (fwdShift Ua ea ψ v) := by
  unfold fwdShift gaugeLink gaugedField
  rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec]
  congr 1
  rw [mul_assoc, hg (ea v), mul_one]

/-- **Covariance of one sharp dressed transport**:
`(Tₐ♯ᵍ ψᵍ) v = g v *ᵥ (Tₐ♯ ψ) v`. -/
theorem sharpShift_gauge_covariant (g : V → Matrix (Fin n) (Fin n) ℂ)
    (Ua : V → Matrix (Fin n) (Fin n) ℂ) (ea : Equiv.Perm V)
    (ψ : V → (Fin n → ℂ)) (hg : ∀ v, star (g v) * g v = 1) (v : V) :
    sharpShift (fun w => gaugeLink g (Ua w) w (ea w)) ea (gaugedField g ψ) v
      = g v *ᵥ (sharpShift Ua ea ψ v) := by
  unfold sharpShift gaugeLink gaugedField
  simp only [Equiv.apply_symm_apply, Matrix.conjTranspose_mul,
    Matrix.conjTranspose_conjTranspose, Matrix.star_eq_conjTranspose]
  rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec]
  congr 1
  simp only [← Matrix.star_eq_conjTranspose, mul_assoc, hg (ea.symm v), mul_one]

/-- **Gauge covariance of the null-Wilson regulator.**  Under the source/target
gauge action the regulator transforms covariantly: at every vertex its output is
the base-point gauge image of the ungauged output,
`R_W^{Aᵍ} ψᵍ = g · (R_W^A ψ)`. -/
theorem nullWilson_gaugeCovariant [Fintype ι] (r h : ℝ)
    (g : V → Matrix (Fin n) (Fin n) ℂ) (U : ι → V → Matrix (Fin n) (Fin n) ℂ)
    (e : ι → Equiv.Perm V) (ψ : V → (Fin n → ℂ))
    (hg : ∀ v, star (g v) * g v = 1) (v : V) :
    nullWilson r h (gaugedLinks g U e) e (gaugedField g ψ) v
      = g v *ᵥ (nullWilson r h U e ψ v) := by
  unfold nullWilson gaugedLinks
  rw [Matrix.mulVec_smul, Matrix.mulVec_sum]
  congr 1
  apply Finset.sum_congr rfl
  intro a _
  rw [fwdShift_gauge_covariant g (U a) (e a) ψ hg v,
      sharpShift_gauge_covariant g (U a) (e a) ψ hg v]
  simp only [gaugedField, Matrix.mulVec_sub, Matrix.mulVec_smul]

/-! ## 5. Hilbert self-adjointness -/

/-- **The null-Wilson regulator is Hilbert self-adjoint.**
`⟪x, R_W^A ψ⟫ = ⟪R_W^A x, ψ⟫`.  This is the precise adjointness statement: with a
single real coefficient `r/(2h)` and the symmetric pairing `Tₐ + Tₐ♯`, the
operator is genuinely Hermitian on the positive-definite Hilbert space (Hilbert
self-adjoint, not merely Krein self-adjoint). -/
theorem nullWilson_selfAdjoint [Fintype V] [Fintype ι] (r h : ℝ)
    (U : ι → V → Matrix (Fin n) (Fin n) ℂ) (e : ι → Equiv.Perm V)
    (x ψ : V → (Fin n → ℂ)) :
    innerΨ x (nullWilson r h U e ψ) = innerΨ (nullWilson r h U e x) ψ := by
  unfold nullWilson
  rw [innerΨ_smul_right, innerΨ_smul_left, innerΨ_sum_right, innerΨ_sum_left,
      Complex.conj_ofReal]
  congr 1
  apply Finset.sum_congr rfl
  intro a _
  rw [innerΨ_sub_right, innerΨ_sub_right, innerΨ_smul_right,
      nullWilson_shift_adjoint, nullWilson_sharp_adjoint,
      innerΨ_sub_left, innerΨ_sub_left, innerΨ_smul_left]
  simp only [map_ofNat]
  ring

/-! ## 6. The flat symbol -/

/-- The **flat Wilson symbol**: the scalar eigenvalue of the regulator on a flat
plane wave with momentum components `q : ι → ℝ`,
`(r/(2h)) · ∑_a (2 − e^{i qₐ} − e^{-i qₐ})`. -/
def wilsonFlatSymbol [Fintype ι] (r h : ℝ) (q : ι → ℝ) : ℂ :=
  ((r / (2 * h) : ℝ) : ℂ) *
    ∑ a, (2 - Complex.exp ((q a : ℂ) * Complex.I)
            - Complex.exp (-((q a : ℂ) * Complex.I)))

/-- **The flat symbol is the standard Wilson dispersion.**
`(r/(2h)) ∑_a (2 − e^{i qₐ} − e^{-i qₐ}) = (r/h) ∑_a (1 − cos qₐ)`. -/
theorem wilsonFlatSymbol_eq [Fintype ι] (r h : ℝ) (q : ι → ℝ) :
    wilsonFlatSymbol r h q
      = (((r / h) * ∑ a, (1 - Real.cos (q a)) : ℝ) : ℂ) := by
  unfold wilsonFlatSymbol
  have key : ∀ a : ι, (2 - Complex.exp ((q a : ℂ) * Complex.I)
        - Complex.exp (-((q a : ℂ) * Complex.I)))
      = ((2 * (1 - Real.cos (q a)) : ℝ) : ℂ) := by
    intro a
    have h1 : Complex.exp ((q a : ℂ) * Complex.I)
        = Complex.cos (q a) + Complex.sin (q a) * Complex.I := Complex.exp_mul_I _
    have h2 : Complex.exp (-((q a : ℂ) * Complex.I))
        = Complex.cos (q a) - Complex.sin (q a) * Complex.I := by
      rw [show -((q a : ℂ) * Complex.I) = ((-(q a) : ℝ) : ℂ) * Complex.I by push_cast; ring,
          Complex.exp_mul_I]
      push_cast; simp [Complex.cos_neg, Complex.sin_neg]; ring
    rw [h1, h2, ← Complex.ofReal_cos]; push_cast; ring
  rw [Finset.sum_congr rfl (fun a _ => key a)]
  push_cast
  rw [← Finset.mul_sum]
  ring

/-- **Recovery of the flat symbol from the operator.**  If a field `ψ` is a flat
plane-wave eigenmode of every dressed transport, `fwdShift (U a) (e a) ψ = e^{i
qₐ} ψ` and `sharpShift (U a) (e a) ψ = e^{-i qₐ} ψ`, then the null-Wilson
regulator acts on it as multiplication by the flat Wilson symbol, equal to
`(r/h) ∑_a (1 − cos qₐ)`. -/
theorem nullWilson_flat_symbol [Fintype ι] (r h : ℝ)
    (U : ι → V → Matrix (Fin n) (Fin n) ℂ) (e : ι → Equiv.Perm V)
    (ψ : V → (Fin n → ℂ)) (q : ι → ℝ)
    (hf : ∀ a, fwdShift (U a) (e a) ψ
            = fun v => Complex.exp ((q a : ℂ) * Complex.I) • ψ v)
    (hs : ∀ a, sharpShift (U a) (e a) ψ
            = fun v => Complex.exp (-((q a : ℂ) * Complex.I)) • ψ v) (v : V) :
    nullWilson r h U e ψ v
      = (((r / h) * ∑ a, (1 - Real.cos (q a)) : ℝ) : ℂ) • ψ v := by
  have e1 : ∀ a, fwdShift (U a) (e a) ψ v = Complex.exp ((q a : ℂ) * Complex.I) • ψ v :=
    fun a => congrFun (hf a) v
  have e2 : ∀ a, sharpShift (U a) (e a) ψ v = Complex.exp (-((q a : ℂ) * Complex.I)) • ψ v :=
    fun a => congrFun (hs a) v
  unfold nullWilson
  simp only [e1, e2]
  have hterm : ∀ a : ι, (2 : ℂ) • ψ v - Complex.exp ((q a : ℂ) * Complex.I) • ψ v
        - Complex.exp (-((q a : ℂ) * Complex.I)) • ψ v
      = ((2 : ℂ) - Complex.exp ((q a : ℂ) * Complex.I)
          - Complex.exp (-((q a : ℂ) * Complex.I))) • ψ v := by
    intro a; module
  simp only [hterm, ← Finset.sum_smul, smul_smul]
  rw [show (((r / (2 * h) : ℝ) : ℂ) * ∑ a, ((2 : ℂ) - Complex.exp ((q a : ℂ) * Complex.I)
        - Complex.exp (-((q a : ℂ) * Complex.I)))) = wilsonFlatSymbol r h q from rfl,
      wilsonFlatSymbol_eq]

end PhysicsSM.Draft.NullEdgeNullWilsonGaugeCovariance
