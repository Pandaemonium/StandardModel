/-
# HNU infrared Weyl tangent (Bridge B1)

Exact first-derivative ("infrared tangent") theorems connecting the corrected
depth-eight HNU endpoint (`endpoint`, from the uploaded live `HNUExactCore.lean`,
namespace `PhysicsSM.Draft.NullEdge.HNUExactCore`) to a continuum Weyl generator
at the origin `k = 0`.

The uploaded HNU definitions, signs, and rightmost-first ordering convention are
used **without modification** (this file only imports them).

All derivatives are genuine `HasDerivAt` statements in the finite-dimensional
matrix normed space `M2 = Matrix (Fin 2) (Fin 2) Complex`. We use the matrix
infinity-operator norm (`open scoped Matrix.Norms.Operator`), which is a genuine
`NormedRing`/`NormedAlgebra Real`, so matrix multiplication is differentiable and
`HasDerivAt.mul`/`HasDerivAt.smul_const` apply.

## Exact coefficients (proved, matching the task target exactly)

* `endpoint_axis0_hasDerivAt`: derivative `= -i * sigma1` at zero.
* `endpoint_axis1_hasDerivAt`: derivative `= -i * sigma2` at zero.
* `endpoint_axis2_hasDerivAt`: derivative `= -i * sigma3` at zero.
* `endpoint_ray_hasDerivAt`: for any real three-vector `q`, the derivative is
  `-i * (q0*sigma1 + q1*sigma2 + q2*sigma3)` at zero.

No convention mismatch was found: the exact tangent coefficient is `-i`
(i.e. `(-I) •`) paired with the matching Pauli matrix, exactly as targeted.

## Controls / guards

* `endpoint_zero_ray_hasDerivAt` : along the constant zero ray the derivative is `0`.
* `endpoint_axis1_deriv_ne_zero`: the axis-one tangent is a nonzero witness.
* Build-enforced standard-three guards for every headline theorem.

Provenance: clean-room integration of Aristotle project
`c626cb61-f1db-49ff-aa41-a9d96e9152ad`, task
`5a562c93-6cb7-4a5a-bc40-bb54aeab1a3a`, independently reviewed by interactive
Claude/Opus on 2026-07-13. The imported HNU definitions and ordering were
checked against the live module without modification.
-/
import PhysicsSM.Draft.NullEdge.HNUExactCore

open Matrix Complex
open scoped Matrix.Norms.Operator

namespace PhysicsSM.Draft.NullEdge.HNUInfraredTangent

open PhysicsSM.Draft.NullEdge.HNUExactCore

noncomputable section

/-- The coordinate ray along axis `j`: `axisRay j t` is the point whose `j`-th
coordinate is `t` and whose other coordinates vanish. -/
def axisRay (j : Fin 3) (t : ℝ) : Fin 3 → ℝ :=
  fun i => if i = j then t else 0

/-! ## Substep values at parameter zero -/

lemma Uplus_zero (s : M2) : Uplus s 0 = 1 := by
  simp [Uplus, Pplus_add_Pminus]

lemma Uminus_zero (s : M2) : Uminus s 0 = 1 := by
  simp only [Uminus, Complex.ofReal_zero, mul_zero, Complex.exp_zero, one_smul]
  rw [add_comm]; exact Pplus_add_Pminus s

/-! ## A general exponential–smul derivative helper -/

/-- Derivative at `0` of `t ↦ exp(g t) • P + Q` when `g` is differentiable at `0`
with `g 0 = 0`. -/
lemma hasDerivAt_expsmul (g : ℝ → ℂ) (g' : ℂ) (hg : HasDerivAt g g' 0)
    (hg0 : g 0 = 0) (P Q : M2) :
    HasDerivAt (fun t : ℝ => Complex.exp (g t) • P + Q) (g' • P) 0 := by
  have hexp : HasDerivAt (fun t : ℝ => Complex.exp (g t))
      (Complex.exp (g 0) * g') 0 := hg.cexp
  rw [hg0, Complex.exp_zero, one_mul] at hexp
  simpa using (hexp.smul_const P).add_const Q

/-! ## Per-factor derivatives at `0`

Each substep, along an arbitrary scalar reparametrisation `φ` of its angle
(needed because the axis-three half-steps divide that coordinate by two). -/

/-- Derivative at `0` of `t ↦ Uplus s (φ t)` for a scalar reparametrisation `φ`
vanishing at `0`. -/
lemma hasDerivAt_Uplus (s : M2) (φ : ℝ → ℝ) (φ' : ℝ)
    (hφ : HasDerivAt φ φ' 0) (hφ0 : φ 0 = 0) :
    HasDerivAt (fun t : ℝ => Uplus s (φ t)) (((-I) * (φ' : ℂ)) • Pplus s) 0 := by
  have hg : HasDerivAt (fun t : ℝ => -(I * ((φ t : ℝ) : ℂ))) (-(I * (φ' : ℂ))) 0 :=
    ((hφ.ofReal_comp).const_mul I).neg
  have hg0 : (fun t : ℝ => -(I * ((φ t : ℝ) : ℂ))) 0 = 0 := by simp [hφ0]
  have := hasDerivAt_expsmul _ _ hg hg0 (Pplus s) (Pminus s)
  simpa [Uplus, neg_mul] using this

/-- Derivative at `0` of `t ↦ Uminus s (φ t)`. -/
lemma hasDerivAt_Uminus (s : M2) (φ : ℝ → ℝ) (φ' : ℝ)
    (hφ : HasDerivAt φ φ' 0) (hφ0 : φ 0 = 0) :
    HasDerivAt (fun t : ℝ => Uminus s (φ t)) ((I * (φ' : ℂ)) • Pminus s) 0 := by
  have hg : HasDerivAt (fun t : ℝ => I * ((φ t : ℝ) : ℂ)) (I * (φ' : ℂ)) 0 :=
    (hφ.ofReal_comp).const_mul I
  have hg0 : (fun t : ℝ => I * ((φ t : ℝ) : ℂ)) 0 = 0 := by simp [hφ0]
  have := hasDerivAt_expsmul _ _ hg hg0 (Pminus s) (Pplus s)
  simpa [Uminus] using this

/-! ## Product rule at the identity -/

/-- Product rule specialised at a point where both factors are the identity: the
derivative of the product is the sum of the derivatives, and the product is `1`
there (so it can be folded left-to-right). -/
lemma hasDerivAt_mul_at_one (f g : ℝ → M2) (f' g' : M2)
    (hf : HasDerivAt f f' 0) (hg : HasDerivAt g g' 0) (hf0 : f 0 = 1) (hg0 : g 0 = 1) :
    HasDerivAt (fun t => f t * g t) (f' + g') 0 ∧ (fun t => f t * g t) 0 = 1 := by
  refine ⟨?_, by simp [hf0, hg0]⟩
  have := hf.mul hg
  rw [hf0, hg0] at this
  simpa using this

/-! ## Key algebraic identity: `Pplus s - Pminus s = s` -/

lemma Pplus_sub_Pminus (s : M2) : Pplus s - Pminus s = s := by
  simp only [Pplus, Pminus]; module

/-! ## Combined ray theorem -/

/-- **Exact HNU infrared tangent (combined ray).** For every `q : Fin 3 → ℝ`,
The derivative at zero is `-i * (q0*sigma1 + q1*sigma2 + q2*sigma3)`. -/
theorem endpoint_ray_hasDerivAt (q : Fin 3 → ℝ) :
    HasDerivAt (fun t : ℝ => endpoint (fun i => t * q i))
      ((-I) • (((q 0 : ℝ) : ℂ) • σ1 + ((q 1 : ℝ) : ℂ) • σ2 + ((q 2 : ℝ) : ℂ) • σ3)) 0 := by
  -- The eight factor derivatives.
  have hd0 : HasDerivAt (fun t : ℝ => t * q 0) (q 0) 0 := by
    simpa using (hasDerivAt_id (0:ℝ)).mul_const (q 0)
  have hd1 : HasDerivAt (fun t : ℝ => t * q 1) (q 1) 0 := by
    simpa using (hasDerivAt_id (0:ℝ)).mul_const (q 1)
  have hd2 : HasDerivAt (fun t : ℝ => t * q 2 / 2) (q 2 / 2) 0 := by
    simpa using ((hasDerivAt_id (0:ℝ)).mul_const (q 2)).div_const 2
  have h1 : HasDerivAt (fun t : ℝ => Uminus σ1 (t * q 0)) ((I * (q 0 : ℂ)) • Pminus σ1) 0 :=
    hasDerivAt_Uminus σ1 (fun t => t * q 0) (q 0) hd0 (by simp)
  have h2 : HasDerivAt (fun t : ℝ => Uminus σ3 (t * q 2 / 2)) ((I * ((q 2 : ℂ) / 2)) • Pminus σ3) 0 := by
    have := hasDerivAt_Uminus σ3 (fun t => t * q 2 / 2) (q 2 / 2) hd2 (by simp)
    push_cast at this ⊢; convert this using 2
  have h3 : HasDerivAt (fun t : ℝ => Uminus σ2 (t * q 1)) ((I * (q 1 : ℂ)) • Pminus σ2) 0 :=
    hasDerivAt_Uminus σ2 (fun t => t * q 1) (q 1) hd1 (by simp)
  have h4 : HasDerivAt (fun t : ℝ => Uplus σ3 (t * q 2 / 2)) (((-I) * ((q 2 : ℂ) / 2)) • Pplus σ3) 0 := by
    have := hasDerivAt_Uplus σ3 (fun t => t * q 2 / 2) (q 2 / 2) hd2 (by simp)
    push_cast at this ⊢; convert this using 2
  have h5 : HasDerivAt (fun t : ℝ => Uplus σ1 (t * q 0)) (((-I) * (q 0 : ℂ)) • Pplus σ1) 0 :=
    hasDerivAt_Uplus σ1 (fun t => t * q 0) (q 0) hd0 (by simp)
  have h6 : HasDerivAt (fun t : ℝ => Uminus σ3 (t * q 2 / 2)) ((I * ((q 2 : ℂ) / 2)) • Pminus σ3) 0 := h2
  have h7 : HasDerivAt (fun t : ℝ => Uplus σ2 (t * q 1)) (((-I) * (q 1 : ℂ)) • Pplus σ2) 0 :=
    hasDerivAt_Uplus σ2 (fun t => t * q 1) (q 1) hd1 (by simp)
  have h8 : HasDerivAt (fun t : ℝ => Uplus σ3 (t * q 2 / 2)) (((-I) * ((q 2 : ℂ) / 2)) • Pplus σ3) 0 := h4
  -- Factor values at 0.
  have v1 : (fun t : ℝ => Uminus σ1 (t * q 0)) 0 = 1 := by simp [Uminus_zero]
  have v2 : (fun t : ℝ => Uminus σ3 (t * q 2 / 2)) 0 = 1 := by simp [Uminus_zero]
  have v3 : (fun t : ℝ => Uminus σ2 (t * q 1)) 0 = 1 := by simp [Uminus_zero]
  have v4 : (fun t : ℝ => Uplus σ3 (t * q 2 / 2)) 0 = 1 := by simp [Uplus_zero]
  have v5 : (fun t : ℝ => Uplus σ1 (t * q 0)) 0 = 1 := by simp [Uplus_zero]
  have v7 : (fun t : ℝ => Uplus σ2 (t * q 1)) 0 = 1 := by simp [Uplus_zero]
  -- Fold the product rule left-to-right.
  obtain ⟨p12, q12⟩ := hasDerivAt_mul_at_one _ _ _ _ h1 h2 v1 v2
  obtain ⟨p123, q123⟩ := hasDerivAt_mul_at_one _ _ _ _ p12 h3 q12 v3
  obtain ⟨p1234, q1234⟩ := hasDerivAt_mul_at_one _ _ _ _ p123 h4 q123 v4
  obtain ⟨p12345, q12345⟩ := hasDerivAt_mul_at_one _ _ _ _ p1234 h5 q1234 v5
  obtain ⟨p123456, q123456⟩ := hasDerivAt_mul_at_one _ _ _ _ p12345 h6 q12345 v2
  obtain ⟨p1234567, q1234567⟩ := hasDerivAt_mul_at_one _ _ _ _ p123456 h7 q123456 v7
  obtain ⟨p12345678, _⟩ := hasDerivAt_mul_at_one _ _ _ _ p1234567 h8 q1234567 v4
  -- Identify the function with `endpoint (t*q)` and the derivative with the target.
  have hfun : (fun t : ℝ =>
      Uminus σ1 (t * q 0) * Uminus σ3 (t * q 2 / 2) * Uminus σ2 (t * q 1) *
        Uplus σ3 (t * q 2 / 2) * Uplus σ1 (t * q 0) * Uminus σ3 (t * q 2 / 2) *
        Uplus σ2 (t * q 1) * Uplus σ3 (t * q 2 / 2))
      = (fun t : ℝ => endpoint (fun i => t * q i)) := by
    funext t; rw [endpoint]
  rw [hfun] at p12345678
  convert p12345678 using 1
  -- Collect the derivative sum into the target Pauli combination.
  rw [← Pplus_sub_Pminus σ1, ← Pplus_sub_Pminus σ2, ← Pplus_sub_Pminus σ3]
  simp only [Pplus, Pminus]
  match_scalars <;> ring

/-! ## Axis specialisations (exact coefficients) -/

/-- The axis-zero endpoint derivative at zero is `-i * sigma1`. -/
theorem endpoint_axis0_hasDerivAt :
    HasDerivAt (fun t : ℝ => endpoint (axisRay 0 t)) ((-I) • σ1) 0 := by
  have h := endpoint_ray_hasDerivAt ![1, 0, 0]
  have hfun : (fun t : ℝ => endpoint (fun i => t * (![1, 0, 0] : Fin 3 → ℝ) i))
      = (fun t : ℝ => endpoint (axisRay 0 t)) := by
    funext t; congr 1; funext i; fin_cases i <;> simp [axisRay]
  rw [hfun] at h
  convert h using 1
  simp [σ1, σ2, σ3]

/-- The axis-one endpoint derivative at zero is `-i * sigma2`. -/
theorem endpoint_axis1_hasDerivAt :
    HasDerivAt (fun t : ℝ => endpoint (axisRay 1 t)) ((-I) • σ2) 0 := by
  have h := endpoint_ray_hasDerivAt ![0, 1, 0]
  have hfun : (fun t : ℝ => endpoint (fun i => t * (![0, 1, 0] : Fin 3 → ℝ) i))
      = (fun t : ℝ => endpoint (axisRay 1 t)) := by
    funext t; congr 1; funext i; fin_cases i <;> simp [axisRay]
  rw [hfun] at h
  convert h using 1
  simp [σ1, σ2, σ3]

/-- The axis-two endpoint derivative at zero is `-i * sigma3`. -/
theorem endpoint_axis2_hasDerivAt :
    HasDerivAt (fun t : ℝ => endpoint (axisRay 2 t)) ((-I) • σ3) 0 := by
  have h := endpoint_ray_hasDerivAt ![0, 0, 1]
  have hfun : (fun t : ℝ => endpoint (fun i => t * (![0, 0, 1] : Fin 3 → ℝ) i))
      = (fun t : ℝ => endpoint (axisRay 2 t)) := by
    funext t; congr 1; funext i; fin_cases i <;> simp [axisRay]
  rw [hfun] at h
  convert h using 1
  simp [σ1, σ2, σ3]

/-! ## Controls -/

/-- Boundary control: along the constant zero ray the derivative vanishes. -/
theorem endpoint_zero_ray_hasDerivAt :
    HasDerivAt (fun t : ℝ => endpoint (fun _ : Fin 3 => t * (0 : ℝ))) 0 0 := by
  have h := endpoint_ray_hasDerivAt (fun _ : Fin 3 => (0 : ℝ))
  simpa using h

/-- Nonzero axis witness: the axis-one tangent is not zero. -/
theorem endpoint_axis1_deriv_ne_zero : ((-I) • σ2 : M2) ≠ 0 := by
  intro h
  have h01 : ((-I) • σ2 : M2) 0 1 = 0 := by rw [h]; rfl
  simp [σ2] at h01

end

end PhysicsSM.Draft.NullEdge.HNUInfraredTangent

/-!
## Build-enforced assumption-footprint guards

Every headline theorem depends only on Lean/Mathlib's standard three principles
`propext`, `Classical.choice`, `Quot.sound`.  The `#guard_msgs` wrapper makes
each check build-enforced.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredTangent.endpoint_ray_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUInfraredTangent.endpoint_ray_hasDerivAt
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredTangent.endpoint_axis0_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUInfraredTangent.endpoint_axis0_hasDerivAt
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredTangent.endpoint_axis1_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUInfraredTangent.endpoint_axis1_hasDerivAt
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredTangent.endpoint_axis2_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUInfraredTangent.endpoint_axis2_hasDerivAt
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredTangent.endpoint_zero_ray_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUInfraredTangent.endpoint_zero_ray_hasDerivAt
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredTangent.endpoint_axis1_deriv_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUInfraredTangent.endpoint_axis1_deriv_ne_zero
