import Mathlib

open scoped BigOperators
open scoped Classical
open Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# The finite unimodular trade

A finite, purely rational avatar of the unimodular-gravity "trade": the cosmological
constant `Λ` is not a coupling but a Lagrange multiplier conjugate to the volume/count
constraint, the vacuum mean is gauge on the constraint surface, and the order-`0`
(`tr 1`) coefficient of the finite spectral action is blind to all dynamics.

State space `ℚ^n` (`n = 3`).  Action `S c x = ⟪x, (A + c•1) x⟫` with `A` a rational
symmetric matrix (the dynamical part) and `c` the vacuum/order-`0` coefficient.
Volume/count constraint `Vol x = ⟪x,x⟫ = v0`.

Honest scope: a finite `n`-dimensional avatar, not continuum unimodular gravity.
-/

namespace LambdaUnimodular

abbrev n : ℕ := 3
abbrev Vec := Fin n → ℚ
abbrev Mat := Matrix (Fin n) (Fin n) ℚ

/-- The explicit dynamical operator `A = diag(1,2,3)`. -/
def A : Mat := !![1, 0, 0; 0, 2, 0; 0, 0, 3]

/-- The full operator `A + c•1`: dynamics plus the order-`0` vacuum term. -/
def Mc (Aop : Mat) (c : ℚ) : Mat := Aop + c • (1 : Mat)

/-- The action `S c x = ⟪x, (A + c•1) x⟫`. -/
def S (Aop : Mat) (c : ℚ) (x : Vec) : ℚ := x ⬝ᵥ (Mc Aop c) *ᵥ x

/-- The volume/count functional `Vol x = ⟪x,x⟫`. -/
def Vol (x : Vec) : ℚ := x ⬝ᵥ x

/-- Constrained stationarity: along every tangent direction `h` to the constraint
surface at `x` (i.e. `⟪x,h⟫ = 0`), the directional derivative of `S` vanishes. -/
def Stationary (Aop : Mat) (c : ℚ) (x : Vec) : Prop :=
  ∀ h : Vec, x ⬝ᵥ h = 0 → HasDerivAt (fun t : ℚ => S Aop c (x + t • h)) 0 0

/-- The order-`0` term of the finite spectral action `a0 * tr(1)`. -/
def order0Term (a0 : ℚ) (_D : Mat) : ℚ := a0 * Matrix.trace (1 : Mat)

/-- The full finite spectral action `a0 * tr(1) + a2 * tr(D²)`. -/
def spectralAction (a0 a2 : ℚ) (D : Mat) : ℚ :=
  a0 * Matrix.trace (1 : Mat) + a2 * Matrix.trace (D * D)

/-! ## Algebraic helpers -/

lemma Mc_mulVec (Aop : Mat) (c : ℚ) (x : Vec) :
    (Mc Aop c) *ᵥ x = Aop *ᵥ x + c • x := by
  simp [Mc, add_mulVec, smul_mulVec, one_mulVec]

lemma Mc_isSymm (Aop : Mat) (hA : Aop.IsSymm) (c : ℚ) : (Mc Aop c).IsSymm := by
  unfold Matrix.IsSymm Mc
  rw [Matrix.transpose_add, Matrix.transpose_smul, Matrix.transpose_one, hA]

/-- For a symmetric operator the associated bilinear form is symmetric. -/
lemma dot_mulVec_symm (M : Mat) (hM : M.IsSymm) (x y : Vec) :
    x ⬝ᵥ M *ᵥ y = y ⬝ᵥ M *ᵥ x := by
  rw [dotProduct_mulVec, dotProduct_comm]
  congr 1
  rw [← Matrix.mulVec_transpose, hM.eq]

/-- The action along a straight path `t ↦ x + t•h` is an explicit quadratic in `t`
with linear coefficient `2⟪h, (A+c•1) x⟫` (using symmetry of the operator). -/
lemma S_path_eq (Aop : Mat) (hA : Aop.IsSymm) (c : ℚ) (x h : Vec) (t : ℚ) :
    S Aop c (x + t • h)
      = S Aop c x + (2 * (h ⬝ᵥ (Mc Aop c) *ᵥ x)) * t
          + (h ⬝ᵥ (Mc Aop c) *ᵥ h) * t ^ 2 := by
  have hsymm : (Mc Aop c).IsSymm := Mc_isSymm Aop hA c
  simp only [S, mulVec_add, mulVec_smul, dotProduct_add, add_dotProduct,
    dotProduct_smul, smul_dotProduct, smul_eq_mul]
  have hxh : x ⬝ᵥ (Mc Aop c) *ᵥ h = h ⬝ᵥ (Mc Aop c) *ᵥ x := dot_mulVec_symm _ hsymm x h
  rw [hxh]; ring

/-- The directional derivative of the action along `t ↦ x + t•h` at `t = 0`
equals `2⟪h, (A+c•1) x⟫`. -/
lemma hasDerivAt_S_path (Aop : Mat) (hA : Aop.IsSymm) (c : ℚ) (x h : Vec) :
    HasDerivAt (fun t : ℚ => S Aop c (x + t • h))
      (2 * (h ⬝ᵥ (Mc Aop c) *ᵥ x)) 0 := by
  have hfun : (fun t : ℚ => S Aop c (x + t • h))
      = (fun t : ℚ => S Aop c x + (2 * (h ⬝ᵥ (Mc Aop c) *ᵥ x)) * t
          + (h ⬝ᵥ (Mc Aop c) *ᵥ h) * t ^ 2) := by
    funext t; exact S_path_eq Aop hA c x h t
  rw [hfun]
  have h1 : HasDerivAt (fun t : ℚ => S Aop c x + (2 * (h ⬝ᵥ (Mc Aop c) *ᵥ x)) * t
      + (h ⬝ᵥ (Mc Aop c) *ᵥ h) * t ^ 2)
      (0 + 2 * (h ⬝ᵥ (Mc Aop c) *ᵥ x) * 1 + (h ⬝ᵥ (Mc Aop c) *ᵥ h) * (2 * 0 ^ 1)) 0 := by
    apply HasDerivAt.add
    apply HasDerivAt.add
    · exact hasDerivAt_const _ _
    · exact (hasDerivAt_id 0).const_mul _
    · exact (hasDerivAt_pow 2 0).const_mul _
  simpa using h1

/-- Geometric core: if `M x` is orthogonal to every vector orthogonal to `x`
(and `x ≠ 0`), then `M x` is parallel to `x`. -/
lemma perp_implies_parallel (M : Mat) (x : Vec) (hx : x ≠ 0)
    (H : ∀ h : Vec, x ⬝ᵥ h = 0 → h ⬝ᵥ M *ᵥ x = 0) :
    ∃ Λ : ℚ, M *ᵥ x = Λ • x := by
  have hxx : x ⬝ᵥ x ≠ 0 := fun hc => hx (dotProduct_self_eq_zero.mp hc)
  refine ⟨(x ⬝ᵥ M *ᵥ x) / (x ⬝ᵥ x), ?_⟩
  set Λ : ℚ := (x ⬝ᵥ M *ᵥ x) / (x ⬝ᵥ x) with hΛ
  have hxw : x ⬝ᵥ (M *ᵥ x - Λ • x) = 0 := by
    rw [dotProduct_sub, dotProduct_smul, smul_eq_mul, hΛ]
    field_simp
    rw [dotProduct_comm x (M *ᵥ x)]; ring
  have hwMx : (M *ᵥ x - Λ • x) ⬝ᵥ M *ᵥ x = 0 := H _ hxw
  have hwx : (M *ᵥ x - Λ • x) ⬝ᵥ x = 0 := by rw [dotProduct_comm]; exact hxw
  have hww : (M *ᵥ x - Λ • x) ⬝ᵥ (M *ᵥ x - Λ • x) = 0 := by
    rw [dotProduct_sub, dotProduct_smul, smul_eq_mul, hwMx, hwx]; ring
  exact sub_eq_zero.mp (dotProduct_self_eq_zero.mp hww)

/-! ## Payload 1 — the multiplier field equation -/

/-- **Payload 1.** Constrained stationarity of `S` on the surface `Vol = v0` is
equivalent to the field equation acquiring an identity-proportional term
`A x + c x = Λ x`, with `Λ` the (undetermined) Lagrange multiplier. -/
theorem multiplier_field_equation (Aop : Mat) (hA : Aop.IsSymm) (c : ℚ)
    (x : Vec) (hx : x ≠ 0) :
    Stationary Aop c x ↔ ∃ Λ : ℚ, Aop *ᵥ x + c • x = Λ • x := by
  constructor
  · intro hstat
    have key : ∀ h : Vec, x ⬝ᵥ h = 0 → h ⬝ᵥ (Mc Aop c) *ᵥ x = 0 := by
      intro h hh
      have h1 := hstat h hh
      have h2 := hasDerivAt_S_path Aop hA c x h
      have h3 : 2 * (h ⬝ᵥ (Mc Aop c) *ᵥ x) = 0 := (h1.unique h2).symm
      linarith
    obtain ⟨Λ, hΛ⟩ := perp_implies_parallel (Mc Aop c) x hx key
    exact ⟨Λ, by rw [← Mc_mulVec]; exact hΛ⟩
  · rintro ⟨Λ, hΛ⟩
    intro h hh
    have hMc : (Mc Aop c) *ᵥ x = Λ • x := by rw [Mc_mulVec]; exact hΛ
    have hval : (2 * (h ⬝ᵥ (Mc Aop c) *ᵥ x)) = 0 := by
      rw [hMc, dotProduct_smul, smul_eq_mul, dotProduct_comm, hh]; ring
    have hderiv := hasDerivAt_S_path Aop hA c x h
    rw [hval] at hderiv
    exact hderiv

/-! ## Payload 2 — the vacuum shift is gauge -/

/-- **Payload 2a.** On the constraint surface `Vol x = v0`, shifting the vacuum
coefficient `c → c + δ` changes the action by the state-independent constant
`δ * v0`: the vacuum mean is pure gauge. -/
theorem vacuum_shift_is_gauge (Aop : Mat) (c δ v0 : ℚ) (x : Vec)
    (hv : Vol x = v0) :
    S Aop (c + δ) x = S Aop c x + δ * v0 := by
  simp only [S, Mc_mulVec, dotProduct_add, dotProduct_smul, smul_eq_mul]
  have : x ⬝ᵥ x = v0 := hv
  rw [this]; ring

/-- **Payload 2b.** The explicit solution map: a vacuum shift `c → c + δ` maps
solutions of the field equation to solutions with `Λ → Λ + δ`. -/
theorem gauge_solution_map (Aop : Mat) (c δ Λ : ℚ) (x : Vec)
    (h : Aop *ᵥ x + c • x = Λ • x) :
    Aop *ᵥ x + (c + δ) • x = (Λ + δ) • x := by
  rw [add_smul, add_smul, ← add_assoc, h]

/-! ## Payload 3 — the order-0 coefficient is blind to all dynamics -/

/-- `tr(1) = n`: the order-`0` functional counts the dimension. -/
theorem trace_one_eq_dim : Matrix.trace (1 : Mat) = (n : ℚ) := by
  simp [Matrix.trace_one]

/-- **Payload 3.** The order-`0` term `a0 * tr(1)` is invariant under *every*
deformation `D → D + P` of the dynamical operator: there is no channel pathway
into the order-`0` coefficient. -/
theorem trace_channel_blind (a0 : ℚ) (D P : Mat) :
    order0Term a0 (D + P) = order0Term a0 D := rfl

/-- The order-`0` term is likewise the same for *any* two dynamical operators. -/
theorem order0_operator_blind (a0 : ℚ) (Aop Aop' : Mat) :
    order0Term a0 Aop = order0Term a0 Aop' := rfl

/-- Non-degeneracy of the contrast: the order-`2` term *does* see the dynamics,
so the blindness of the order-`0` term is a genuine statement. -/
theorem a2_term_not_blind :
    Matrix.trace (A * A) ≠ Matrix.trace ((0 : Mat) * (0 : Mat)) := by
  simp only [A, Matrix.trace, Matrix.diag, Matrix.mul_apply, Fin.sum_univ_three]
  norm_num [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons]

/-! ## Non-degeneracy witnesses (explicit rationals) -/

lemma A_isSymm : A.IsSymm := by
  unfold Matrix.IsSymm A; decide

lemma e2_ne_zero : (![0, 1, 0] : Vec) ≠ 0 := by
  intro h; have := congrFun h 1; simp at this

/-- Explicit constrained stationary point: `x = e₂`, `c = 0`, `v0 = 1`, with the
specific nonzero multiplier `Λ = 2`. -/
theorem witness_field_eq : A *ᵥ (![0, 1, 0] : Vec) + (0 : ℚ) • ![0, 1, 0]
    = (2 : ℚ) • ![0, 1, 0] := by
  funext i; fin_cases i <;> simp [A]

theorem witness_vol_one : Vol (![0, 1, 0] : Vec) = 1 := by
  simp [Vol, dotProduct, Fin.sum_univ_three]

theorem witness_stationary : Stationary A 0 (![0, 1, 0] : Vec) :=
  (multiplier_field_equation A A_isSymm 0 _ e2_ne_zero).mpr ⟨2, witness_field_eq⟩

/-- The gauge shift `δ = 5` maps the witness solution `Λ = 2` to `Λ = 7`. -/
theorem witness_gauge_shift : A *ᵥ (![0, 1, 0] : Vec) + (0 + 5 : ℚ) • ![0, 1, 0]
    = (2 + 5 : ℚ) • ![0, 1, 0] :=
  gauge_solution_map A 0 5 2 _ witness_field_eq

/-- Control point: `x = (1,1,0)` is *not* stationary — the equation genuinely
selects.  (It is not an eigenvector of `A`.) -/
theorem control_not_stationary : ¬ Stationary A 0 (![1, 1, 0] : Vec) := by
  intro hstat
  have hx : (![1, 1, 0] : Vec) ≠ 0 := by
    intro h; have := congrFun h 0; simp at this
  obtain ⟨Λ, hΛ⟩ := (multiplier_field_equation A A_isSymm 0 _ hx).mp hstat
  have h0 := congrFun hΛ 0
  have h1 := congrFun hΛ 1
  simp [A] at h0 h1
  rw [← h0] at h1
  norm_num at h1

/-! ## The verdict -/

/-- **The finite unimodular verdict.**  Packaging payloads 1–3 together with the
explicit witnesses:

* (1) constrained stationarity ⇔ the field equation `A x + c x = Λ x` (`Λ` the
  count-constraint multiplier);
* (2a) the vacuum shift `c → c+δ` changes the on-shell action only by the constant
  `δ v0`, and (2b) maps solutions to solutions with `Λ → Λ+δ` — the vacuum mean is gauge;
* (3) the order-`0` coefficient `a0 tr(1)` is blind to all dynamics, equal to `a0·n`;
* explicit witnesses: a stationary point with `Λ = 2`, gauged to `Λ = 7` (`δ = 5`),
  and a control point that is not stationary. -/
theorem unimodular_verdict :
    (∀ (Aop : Mat), Aop.IsSymm → ∀ (c : ℚ) (x : Vec), x ≠ 0 →
        (Stationary Aop c x ↔ ∃ Λ : ℚ, Aop *ᵥ x + c • x = Λ • x)) ∧
      (∀ (Aop : Mat) (c δ v0 : ℚ) (x : Vec), Vol x = v0 →
        S Aop (c + δ) x = S Aop c x + δ * v0) ∧
      (∀ (Aop : Mat) (c δ Λ : ℚ) (x : Vec), Aop *ᵥ x + c • x = Λ • x →
        Aop *ᵥ x + (c + δ) • x = (Λ + δ) • x) ∧
      (∀ (a0 : ℚ) (D P : Mat), order0Term a0 (D + P) = order0Term a0 D) ∧
      Matrix.trace (1 : Mat) = (n : ℚ) ∧
      (Stationary A 0 (![0, 1, 0] : Vec) ∧
        Vol (![0, 1, 0] : Vec) = 1 ∧
        A *ᵥ (![0, 1, 0] : Vec) + (0 : ℚ) • ![0, 1, 0] = (2 : ℚ) • ![0, 1, 0] ∧
        A *ᵥ (![0, 1, 0] : Vec) + (0 + 5 : ℚ) • ![0, 1, 0] = (2 + 5 : ℚ) • ![0, 1, 0] ∧
        ¬ Stationary A 0 (![1, 1, 0] : Vec)) := by
  refine ⟨fun Aop hA c x hx => multiplier_field_equation Aop hA c x hx,
    fun Aop c δ v0 x hv => vacuum_shift_is_gauge Aop c δ v0 x hv,
    fun Aop c δ Λ x h => gauge_solution_map Aop c δ Λ x h,
    fun a0 D P => trace_channel_blind a0 D P,
    trace_one_eq_dim,
    witness_stationary, witness_vol_one, witness_field_eq, witness_gauge_shift,
    control_not_stationary⟩

/-! ## Axiom audit -/

/-- info: 'LambdaUnimodular.multiplier_field_equation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms multiplier_field_equation

/-- info: 'LambdaUnimodular.vacuum_shift_is_gauge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms vacuum_shift_is_gauge

/-- info: 'LambdaUnimodular.gauge_solution_map' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gauge_solution_map

/-- info: 'LambdaUnimodular.trace_channel_blind' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms trace_channel_blind

/-- info: 'LambdaUnimodular.unimodular_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms unimodular_verdict

end LambdaUnimodular
