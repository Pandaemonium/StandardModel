/-
# HNU π-face rank obstruction

A focused, live-compatible follow-up to the anomalous-Floquet 3+1 (HNU single-Weyl)
audit.  It works **only** with the uploaded live definitions in
`HNUExactCore.lean` (namespace `PhysicsSM.Draft.NullEdge.HNUExactCore`) — the exact
depth-eight `endpoint`, the boundary-pinning theorem `endpoint_pi`, and the exact
infrared tangent machinery in `HNUInfraredTangent.lean`.  No sign, order, or
statement of those definitions is changed; this file only imports and composes them.

## Scientific target: sharpen the π-sector geometry

The exact theorem `endpoint_pi` says `endpoint k = -1` whenever **any** coordinate
`k i = π`.  Consequently each coordinate-`π` set is a *full codimension-one nodal
face*, not an isolated codimension-three Weyl point.  This module proves the exact
ladder that turns that observation into a checked rank/kernel obstruction.

1. **Constancy along the face.** For fixed `i`, any base `k` with `k i = π`, and any
   tangential direction `q` with `q i = 0`, the curve `t ↦ endpoint (k + t·q)` is
   *identically* `-1` (`endpoint_pi_face_const`), hence its derivative is `0` at
   every `t` (`endpoint_pi_face_hasDerivAt`, `endpoint_pi_face_deriv_zero`).

2. **Explicit tangential null directions on the `i = 0` face.** The two standard
   basis directions `tanDir0a = e₁`, `tanDir0b = e₂` are tangential
   (`_tangential` lemmas) and have vanishing endpoint derivative at every base
   point of the face (`tanDir0a_deriv_zero`, `tanDir0b_deriv_zero`).

3. **Scoped rank obstruction.** For any linear map `L` that represents the
   directional derivative of `endpoint` at a face point (`hL`), `L` sends both
   tangential directions to `0`, so `L` is **not injective**
   (`pi_face0_deriv_not_injective`) and its kernel has dimension `≥ 2`
   (`pi_face0_ker_ge_two`).  This is the exact kernel-checked proxy for "the
   Fréchet derivative on the π face cannot have full rank `3`".

4. **Non-vacuity control.** The two directions are nonzero and linearly
   independent (`tanDir0a_ne_zero`, `tanDir0b_ne_zero`, `tanDir0_indep`).

5. **Normal derivative (non-vanishing, unsigned).** Transverse to the face, the
   derivative does *not* vanish: along the normal axis-0 direction at the face
   point `(π,0,0)`, `d/dt endpoint(π+t,0,0)|₀ = i·σ₁ ≠ 0`
   (`endpoint_normal_deriv_face0`, `endpoint_normal_deriv_face0_ne_zero`).  No
   signed topological charge is attached to this number.

## Scope / non-claims

This module makes **no** claim of a global topological charge, the
Nielsen–Ninomiya theorem, anomaly cancellation, continuum convergence, or an
isolated Weyl partner supplied by the π face.  The precise scientific conclusion
is exactly that `endpoint_pi` makes each coordinate-`π` set an *extended nodal
surface*, so an endpoint-value census alone cannot be read as an isolated 3D Weyl
charge without additional micromotion / boundary data.
-/
import PhysicsSM.Draft.NullEdge.HNUExactCore
import PhysicsSM.Draft.NullEdge.HNUInfraredTangent

open Matrix Complex
open scoped Matrix.Norms.Operator

namespace PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction

open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUInfraredTangent

noncomputable section

/-! ## 1. Constancy of `endpoint` along a tangential line inside a π face -/

/-- **Item 1 (all-`t`).**  If `k i = π` and the direction `q` is tangential to the
face (`q i = 0`), then the whole line `t ↦ endpoint (k + t·q)` stays on the π
node: it is identically `-1`. -/
theorem endpoint_pi_face_const (k q : Fin 3 → ℝ) (i : Fin 3)
    (hk : k i = Real.pi) (hq : q i = 0) (t : ℝ) :
    endpoint (fun j => k j + t * q j) = -1 := by
  refine endpoint_pi _ (i := i) ?_
  simp [hk, hq]

/-- **Item 1 (derivative).**  Since the tangential line is constant `-1`, the
endpoint has derivative `0` at every parameter value `t`. -/
theorem endpoint_pi_face_hasDerivAt (k q : Fin 3 → ℝ) (i : Fin 3)
    (hk : k i = Real.pi) (hq : q i = 0) (t : ℝ) :
    HasDerivAt (fun t : ℝ => endpoint (fun j => k j + t * q j)) 0 t := by
  have hconst : (fun t : ℝ => endpoint (fun j => k j + t * q j)) = fun _ => (-1 : M2) := by
    funext t; exact endpoint_pi_face_const k q i hk hq t
  rw [hconst]; exact hasDerivAt_const t (-1)

/-- **Item 1 (deriv value).**  The `deriv` of the tangential line is `0` everywhere. -/
theorem endpoint_pi_face_deriv_zero (k q : Fin 3 → ℝ) (i : Fin 3)
    (hk : k i = Real.pi) (hq : q i = 0) (t : ℝ) :
    deriv (fun t : ℝ => endpoint (fun j => k j + t * q j)) t = 0 :=
  (endpoint_pi_face_hasDerivAt k q i hk hq t).deriv

/-! ## 2. Explicit tangential null directions on the `i = 0` face -/

/-- First tangential direction on the `i = 0` face: the `e₁` basis vector. -/
def tanDir0a : Fin 3 → ℝ := ![0, 1, 0]

/-- Second tangential direction on the `i = 0` face: the `e₂` basis vector. -/
def tanDir0b : Fin 3 → ℝ := ![0, 0, 1]

lemma tanDir0a_tangential : tanDir0a 0 = 0 := rfl
lemma tanDir0b_tangential : tanDir0b 0 = 0 := rfl

/-- Endpoint derivative vanishes along `tanDir0a` at every base point of the
`i = 0` face. -/
theorem tanDir0a_deriv_zero (k : Fin 3 → ℝ) (hk : k 0 = Real.pi) (t : ℝ) :
    HasDerivAt (fun t : ℝ => endpoint (fun j => k j + t * tanDir0a j)) 0 t :=
  endpoint_pi_face_hasDerivAt k tanDir0a 0 hk tanDir0a_tangential t

/-- Endpoint derivative vanishes along `tanDir0b` at every base point of the
`i = 0` face. -/
theorem tanDir0b_deriv_zero (k : Fin 3 → ℝ) (hk : k 0 = Real.pi) (t : ℝ) :
    HasDerivAt (fun t : ℝ => endpoint (fun j => k j + t * tanDir0b j)) 0 t :=
  endpoint_pi_face_hasDerivAt k tanDir0b 0 hk tanDir0b_tangential t

/-! ## 4. Non-vacuity control: the directions are nonzero and independent -/

theorem tanDir0a_ne_zero : tanDir0a ≠ 0 := by
  intro h
  have : (tanDir0a 1 : ℝ) = 0 := by rw [h]; rfl
  simp [tanDir0a] at this

theorem tanDir0b_ne_zero : tanDir0b ≠ 0 := by
  intro h
  have : (tanDir0b 2 : ℝ) = 0 := by rw [h]; rfl
  simp [tanDir0b] at this

/-- The two tangential directions are linearly independent. -/
theorem tanDir0_indep : LinearIndependent ℝ ![tanDir0a, tanDir0b] := by
  rw [LinearIndependent.pair_iff]
  intro s t h
  have h1 : (s • tanDir0a + t • tanDir0b) 1 = 0 := by rw [h]; rfl
  have h2 : (s • tanDir0a + t • tanDir0b) 2 = 0 := by rw [h]; rfl
  simp [tanDir0a, tanDir0b] at h1 h2
  exact ⟨h1, h2⟩

/-! ## 3. Scoped rank / kernel obstruction on the `i = 0` face -/

/-- **Item 3 (non-injectivity).**  Let `L` be any linear map that represents the
directional derivative of `endpoint` at a face point `k` (`k 0 = π`), i.e.
`L q` is the `t = 0` derivative of `t ↦ endpoint (k + t·q)` for every `q`.  Then
`L` kills the two independent tangential directions, hence is **not injective** —
the Fréchet derivative on the π face cannot have full rank `3`. -/
theorem pi_face0_deriv_not_injective (k : Fin 3 → ℝ) (hk : k 0 = Real.pi)
    (L : (Fin 3 → ℝ) →ₗ[ℝ] M2)
    (hL : ∀ q, HasDerivAt (fun t : ℝ => endpoint (fun j => k j + t * q j)) (L q) 0) :
    ¬ Function.Injective L := by
  have ha : L tanDir0a = 0 :=
    (hL tanDir0a).unique (tanDir0a_deriv_zero k hk 0)
  have hb : L tanDir0b = 0 :=
    (hL tanDir0b).unique (tanDir0b_deriv_zero k hk 0)
  intro hinj
  have heq : tanDir0a = tanDir0b := hinj (by rw [ha, hb])
  have h1 : (tanDir0a 1 : ℝ) = tanDir0b 1 := by rw [heq]
  simp [tanDir0a, tanDir0b] at h1

/-- **Item 3 (kernel dimension ≥ 2).**  Under the same hypotheses, the kernel of
`L` has dimension at least `2`. -/
theorem pi_face0_ker_ge_two (k : Fin 3 → ℝ) (hk : k 0 = Real.pi)
    (L : (Fin 3 → ℝ) →ₗ[ℝ] M2)
    (hL : ∀ q, HasDerivAt (fun t : ℝ => endpoint (fun j => k j + t * q j)) (L q) 0) :
    2 ≤ Module.finrank ℝ (LinearMap.ker L) := by
  have ha : L tanDir0a = 0 := (hL tanDir0a).unique (tanDir0a_deriv_zero k hk 0)
  have hb : L tanDir0b = 0 := (hL tanDir0b).unique (tanDir0b_deriv_zero k hk 0)
  have hmem : ∀ i : Fin 2, (![tanDir0a, tanDir0b] i) ∈ LinearMap.ker L := by
    intro i; fin_cases i <;> simp [LinearMap.mem_ker, ha, hb]
  have hind := tanDir0_indep
  have hli : LinearIndependent ℝ
      (fun i : Fin 2 => (⟨![tanDir0a, tanDir0b] i, hmem i⟩ : LinearMap.ker L)) := by
    rw [linearIndependent_iff'] at hind ⊢
    intro s g hg i hi
    apply hind s g _ i hi
    have := congrArg (Submodule.subtype (LinearMap.ker L)) hg
    simpa using this
  simpa using hli.fintype_card_le_finrank

/-! ## 5. Normal (transverse) derivative on the `i = 0` face

Along the normal axis-0 direction the endpoint derivative does **not** vanish.
We evaluate it at the pure face point `(π, 0, 0)`; the transverse line collapses to
`t ↦ Uminus σ₁ (π+t) * Uplus σ₁ (π+t)`, whose derivative at `t = 0` is `i·σ₁`.
No signed topological charge is attached to this value. -/

/-- The transverse (normal) direction on the `i = 0` face: the `e₀` basis vector. -/
def normDir0 : Fin 3 → ℝ := ![1, 0, 0]

/-
On the axis-0 line the six off-axis substeps are trivial, so the endpoint
collapses to the two axis-0 factors.
-/
lemma endpoint_line0 (θ : ℝ) :
    endpoint (fun j => (![Real.pi, 0, 0] : Fin 3 → ℝ) j + θ * normDir0 j)
      = Uminus σ1 (Real.pi + θ) * Uplus σ1 (Real.pi + θ) := by
  unfold normDir0 endpoint; simp +decide [ Fin.sum_univ_succ, Fin.prod_univ_succ ] ; ring;
  norm_num [ Uminus_zero, Uplus_zero ]

/-
**Item 5.**  Normal derivative at the face point `(π,0,0)` along `e₀`:
`d/dt endpoint(π+t, 0, 0)|₀ = i·σ₁`.
-/
theorem endpoint_normal_deriv_face0 :
    HasDerivAt (fun t : ℝ => endpoint (fun j => (![Real.pi, 0, 0] : Fin 3 → ℝ) j + t * normDir0 j))
      (I • σ1) 0 := by
  -- Apply the product rule to find the derivative.
  have h_prod_rule : HasDerivAt (fun t => Uminus σ1 (Real.pi + t) * Uplus σ1 (Real.pi + t)) (I • σ1) 0 := by
    -- Apply the product rule to the derivative of the product of Uminus and Uplus.
    have h_prod_rule : HasDerivAt (fun t => Uminus σ1 (Real.pi + t)) (-I • Pminus σ1) 0 ∧ HasDerivAt (fun t => Uplus σ1 (Real.pi + t)) (I • Pplus σ1) 0 := by
      constructor <;> rw [ hasDerivAt_iff_tendsto_slope_zero ] <;> norm_num [ Uminus, Uplus ];
      · -- We'll use the fact that the derivative of $e^{i(\pi + t)}$ at $t = 0$ is $ie^{i\pi} = -i$.
        have h_deriv : HasDerivAt (fun t : ℝ => Complex.exp (I * (Real.pi + t))) (-I) 0 := by
          convert HasDerivAt.comp _ ( Complex.hasDerivAt_exp _ ) ( HasDerivAt.const_mul I ( HasDerivAt.add ( hasDerivAt_const _ _ ) ( hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) ) ) using 1 ; norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ];
        convert h_deriv.tendsto_slope_zero.smul_const ( Pminus σ1 ) using 2 ; norm_num ; ring;
        · ext i j ; norm_num ; ring;
        · norm_num [ Matrix.smul_eq_diagonal_mul ];
      · -- We'll use the fact that the derivative of $e^{-i(\pi + t)}$ at $t = 0$ is $-i e^{-i\pi} = i$.
        have h_deriv : HasDerivAt (fun t : ℝ => Complex.exp (-(I * (Real.pi + t))) • Pplus σ1) (I • Pplus σ1) 0 := by
          have h_deriv : HasDerivAt (fun t : ℝ => Complex.exp (-(I * (Real.pi + t)))) (I) 0 := by
            convert HasDerivAt.comp 0 ( Complex.hasDerivAt_exp _ ) ( HasDerivAt.neg ( HasDerivAt.const_mul I ( HasDerivAt.add ( hasDerivAt_const _ _ ) ( hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) ) ) ) using 1 ; norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ];
          convert h_deriv.smul_const ( Pplus σ1 ) using 1;
        simpa [ div_eq_inv_mul ] using h_deriv.tendsto_slope_zero;
    convert h_prod_rule.1.mul h_prod_rule.2 using 1 ; norm_num [ Pplus, Pminus, σ1 ] ; ring;
    unfold Uplus Uminus; norm_num [ Matrix.mul_apply, Complex.exp_re, Complex.exp_im, Pplus, Pminus ] ; ring;
    ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, Matrix.mul_apply ];
  convert h_prod_rule using 1;
  exact funext fun t => endpoint_line0 t

/-- The normal derivative is nonzero, in contrast with the vanishing tangential
derivatives — the π face is a genuine nodal surface with a transverse gradient. -/
theorem endpoint_normal_deriv_face0_ne_zero : (I • σ1 : M2) ≠ 0 := by
  intro h
  have h01 : (I • σ1 : M2) 0 1 = 0 := by rw [h]; rfl
  simp [σ1] at h01

end

end PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction

/-!
## Build-enforced axiom guards

Every headline theorem depends only on Lean/Mathlib's standard three principles
`propext`, `Classical.choice`, `Quot.sound`.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction.endpoint_pi_face_const' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction.endpoint_pi_face_const
/-- info: 'PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction.endpoint_pi_face_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction.endpoint_pi_face_hasDerivAt
/-- info: 'PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction.pi_face0_deriv_not_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction.pi_face0_deriv_not_injective
/-- info: 'PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction.pi_face0_ker_ge_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction.pi_face0_ker_ge_two
/-- info: 'PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction.tanDir0_indep' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction.tanDir0_indep
/-- info: 'PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction.endpoint_normal_deriv_face0' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUPiFaceRankObstruction.endpoint_normal_deriv_face0
