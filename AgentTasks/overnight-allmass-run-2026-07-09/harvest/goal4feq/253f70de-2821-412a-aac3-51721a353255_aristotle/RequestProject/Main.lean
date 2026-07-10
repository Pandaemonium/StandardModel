import Mathlib

open scoped BigOperators
open scoped Classical

open Matrix

namespace Goal4FieldEquation

/-!
# Goal IV — the finite gravitational field equation (γ-stationarity)

A finite null-edge program's E-slot (soldering / geometric channel) dynamics, modeled with a
single edge's soldering covector `γ = (g0, g1) ∈ ℝ²` subject to the null-cone constraint
`Q(γ) = g0² - g1² = 0`.  A fixed nonzero rational spinor/state `ψ = (p, q) ∈ ℝ²` sources a
finite quadratic action built from the soldered operator

  `D(γ) = g0 • A0 + g1 • A1`

with the explicit fixed rational `2×2` matrices `A0`, `A1`.  The finite action is the
Minkowski norm of `D(γ) ψ`:

  `S(γ) = ⟪D(γ) ψ , D(γ) ψ⟫_η  =  (D(γ) ψ)ᵀ η (D(γ) ψ)`,   `η = diag(1, -1)`.

Constrained stationarity (Lagrange multiplier `μ`) of `S` on the cone `Q = 0` is a finite
teleparallel-Einstein–shaped **field equation**

  `M(ψ) · γ = μ · η · γ`,

an eigenvalue problem pairing the channel stress `M(ψ)` with the geometry `η`.

*Honest scope.*  This is a single-edge, 2D toy cone; not the full complex.  All data are real
and rational; everything is kernel-checked (`ring`/`norm_num`/`fin_cases` + `HasDerivAt`
column-by-column).
-/

/-- Soldering matrix channel `A0` (identity channel). -/
noncomputable def A0 : Matrix (Fin 2) (Fin 2) ℝ := !![1, 0; 0, 1]

/-- Soldering matrix channel `A1`. -/
noncomputable def A1 : Matrix (Fin 2) (Fin 2) ℝ := !![2, 0; 0, 1]

/-- The metric `η = diag(1, -1)`, which is also the gradient direction of the cone form `Q`. -/
noncomputable def eta : Matrix (Fin 2) (Fin 2) ℝ := !![1, 0; 0, -1]

/-- The soldered operator `D(γ) = g0 • A0 + g1 • A1`. -/
noncomputable def Dmat (g0 g1 : ℝ) : Matrix (Fin 2) (Fin 2) ℝ := g0 • A0 + g1 • A1

/-- The finite quadratic action `S(γ) = (D(γ)ψ)ᵀ η (D(γ)ψ)` (Minkowski norm of the soldered
state). -/
noncomputable def Saction (p q g0 g1 : ℝ) : ℝ :=
  (Dmat g0 g1 *ᵥ ![p, q]) ⬝ᵥ (eta *ᵥ (Dmat g0 g1 *ᵥ ![p, q]))

/-- The channel **stress matrix** `M(ψ)`, exhibited entrywise:
`M(ψ) = !![p²-q², 2p²-q²; 2p²-q², 4p²-q²]`. -/
noncomputable def Mmat (p q : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![p ^ 2 - q ^ 2, 2 * p ^ 2 - q ^ 2; 2 * p ^ 2 - q ^ 2, 4 * p ^ 2 - q ^ 2]

/-- The null-cone quadratic form `Q(γ) = g0² - g1²`. -/
def Qform (g0 g1 : ℝ) : ℝ := g0 ^ 2 - g1 ^ 2

/-- The finite Lagrangian `L(γ, μ) = S(γ) - μ Q(γ)`. -/
noncomputable def Lag (p q mu g0 g1 : ℝ) : ℝ := Saction p q g0 g1 - mu * Qform g0 g1

/-! ## Target 1 : closed form of the action -/

/-- The action reduces to the closed polynomial `p²(g0+2g1)² - q²(g0+g1)²`. -/
lemma Saction_eq_poly (p q g0 g1 : ℝ) :
    Saction p q g0 g1 = p ^ 2 * (g0 + 2 * g1) ^ 2 - q ^ 2 * (g0 + g1) ^ 2 := by
  simp only [Saction, Dmat, A0, A1, eta, dotProduct, mulVec, Fin.sum_univ_two,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.of_apply, Matrix.cons_val',
    Matrix.empty_val', Matrix.cons_val_fin_one, Matrix.add_apply, Matrix.smul_apply, smul_eq_mul]
  ring

/-- `M(ψ) *ᵥ γ` computed entrywise. -/
lemma Mmul (p q g0 g1 : ℝ) :
    Mmat p q *ᵥ ![g0, g1] =
      ![(p ^ 2 - q ^ 2) * g0 + (2 * p ^ 2 - q ^ 2) * g1,
        (2 * p ^ 2 - q ^ 2) * g0 + (4 * p ^ 2 - q ^ 2) * g1] := by
  funext i; fin_cases i <;> simp [Mmat, mulVec_eq_sum, Fin.sum_univ_two, mul_comm]

/-- `μ • (η *ᵥ γ)` computed entrywise: `μ • η γ = (μ g0, -μ g1)`. -/
lemma etamul (g0 g1 mu : ℝ) :
    mu • (eta *ᵥ ![g0, g1]) = ![mu * g0, mu * (-g1)] := by
  funext i; fin_cases i <;> simp [eta, mulVec_eq_sum, Fin.sum_univ_two, mul_comm]

private lemma vec2eq' (a b c d : ℝ) : (![a, b] : Fin 2 → ℝ) = ![c, d] ↔ a = c ∧ b = d := by
  constructor
  · intro h; exact ⟨congrFun h 0, congrFun h 1⟩
  · rintro ⟨h1, h2⟩; subst h1; subst h2; rfl

/-- **Target 1 — `action_closed_form`.**  The action is the quadratic form of the channel
stress `M(ψ)`: `S(γ) = γᵀ M(ψ) γ`, with `M(ψ)` the explicit stress matrix. -/
theorem action_closed_form (p q g0 g1 : ℝ) :
    Saction p q g0 g1 = (![g0, g1] : Fin 2 → ℝ) ⬝ᵥ (Mmat p q *ᵥ ![g0, g1]) := by
  rw [Saction_eq_poly, Mmul]
  simp only [dotProduct, Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one]
  ring

/-! ## Target 2 : the field equation via Lagrange-multiplier stationarity -/

/-- Column-`0` partial of the Lagrangian, with its exact derivative value. -/
lemma hderiv0 (p q g0 g1 mu : ℝ) :
    HasDerivAt (fun x => Lag p q mu x g1)
      (2 * (((p ^ 2 - q ^ 2) * g0 + (2 * p ^ 2 - q ^ 2) * g1) - mu * g0)) g0 := by
  have hfun : (fun x => Lag p q mu x g1)
      = (fun x : ℝ => (p ^ 2 * (x + 2 * g1) ^ 2 - q ^ 2 * (x + g1) ^ 2) - mu * (x ^ 2 - g1 ^ 2)) := by
    funext x; rw [Lag, Saction_eq_poly, Qform]
  rw [hfun]
  have h :=
    (((((hasDerivAt_id' (x := g0)).add_const (2 * g1)).pow 2).const_mul (p ^ 2)).sub
      ((((hasDerivAt_id' (x := g0)).add_const g1).pow 2).const_mul (q ^ 2))).sub
      ((((hasDerivAt_id' (x := g0)).pow 2).sub_const (g1 ^ 2)).const_mul mu)
  convert h using 1
  push_cast; ring

/-- Column-`1` partial of the Lagrangian, with its exact derivative value. -/
lemma hderiv1 (p q g0 g1 mu : ℝ) :
    HasDerivAt (fun y => Lag p q mu g0 y)
      (2 * (((2 * p ^ 2 - q ^ 2) * g0 + (4 * p ^ 2 - q ^ 2) * g1) - mu * (-g1))) g1 := by
  have hfun : (fun y => Lag p q mu g0 y)
      = (fun y : ℝ => (p ^ 2 * (g0 + 2 * y) ^ 2 - q ^ 2 * (g0 + y) ^ 2) - mu * (g0 ^ 2 - y ^ 2)) := by
    funext y; rw [Lag, Saction_eq_poly, Qform]
  rw [hfun]
  have e1 : HasDerivAt (fun y : ℝ => p ^ 2 * (g0 + 2 * y) ^ 2)
      (p ^ 2 * (2 * (g0 + 2 * g1) ^ (2 - 1) * (2 * 1))) g1 :=
    ((((hasDerivAt_id' (x := g1)).const_mul (2 : ℝ)).const_add g0).pow 2).const_mul (p ^ 2)
  have e2 : HasDerivAt (fun y : ℝ => q ^ 2 * (g0 + y) ^ 2)
      (q ^ 2 * (2 * (g0 + g1) ^ (2 - 1) * 1)) g1 :=
    (((hasDerivAt_id' (x := g1)).const_add g0).pow 2).const_mul (q ^ 2)
  have e3 : HasDerivAt (fun y : ℝ => mu * (g0 ^ 2 - y ^ 2)) (mu * (0 - 2 * g1 ^ (2 - 1) * 1)) g1 := by
    exact ((hasDerivAt_const g1 (g0 ^ 2)).sub ((hasDerivAt_id' (x := g1)).pow 2)).const_mul mu
  have h := (e1.sub e2).sub e3
  convert h using 1
  push_cast; ring

/-- The matrix field equation `M(ψ) γ = μ η γ` in scalar componentwise form. -/
lemma mateq_iff (p q g0 g1 mu : ℝ) :
    Mmat p q *ᵥ ![g0, g1] = mu • (eta *ᵥ ![g0, g1]) ↔
      ((p ^ 2 - q ^ 2) * g0 + (2 * p ^ 2 - q ^ 2) * g1 = mu * g0 ∧
       (2 * p ^ 2 - q ^ 2) * g0 + (4 * p ^ 2 - q ^ 2) * g1 = mu * (-g1)) := by
  rw [Mmul, etamul, vec2eq']

/-- `γ` is a constrained stationary point (of `S - μ Q`) when both column partials of the
Lagrangian vanish. -/
def Stationary (p q g0 g1 mu : ℝ) : Prop :=
  HasDerivAt (fun x => Lag p q mu x g1) 0 g0 ∧ HasDerivAt (fun y => Lag p q mu g0 y) 0 g1

/-- **Target 2 — `field_equation`.**  Constrained stationarity of `S - μ Q` (both Lagrangian
column partials vanish) is *equivalent* to the finite field equation
`M(ψ) · γ = μ · η · γ`.  Both directions, via the `HasDerivAt` column-by-column partials. -/
theorem field_equation (p q g0 g1 mu : ℝ) :
    Stationary p q g0 g1 mu ↔ Mmat p q *ᵥ ![g0, g1] = mu • (eta *ᵥ ![g0, g1]) := by
  rw [mateq_iff]
  constructor
  · rintro ⟨d0, d1⟩
    have h0 := d0.unique (hderiv0 p q g0 g1 mu)
    have h1 := d1.unique (hderiv1 p q g0 g1 mu)
    exact ⟨by linarith, by linarith⟩
  · rintro ⟨h0, h1⟩
    refine ⟨?_, ?_⟩
    · have := hderiv0 p q g0 g1 mu
      have hz : (2 * (((p ^ 2 - q ^ 2) * g0 + (2 * p ^ 2 - q ^ 2) * g1) - mu * g0)) = 0 := by
        rw [h0]; ring
      rwa [hz] at this
    · have := hderiv1 p q g0 g1 mu
      have hz : (2 * (((2 * p ^ 2 - q ^ 2) * g0 + (4 * p ^ 2 - q ^ 2) * g1) - mu * (-g1))) = 0 := by
        rw [h1]; ring
      rwa [hz] at this

/-! ## Target 3 : non-degeneracy — an explicit nonzero-multiplier witness -/

/-- **Target 3 — `multiplier_nonzero`.**  Explicit rational witness `ψ* = (2, 3)`,
`γ* = (1, 1)` *on the cone* (`g0 = g1 ≠ 0`) where the field equation holds with the specific
nonzero multiplier `μ = -6`.  This rules out the vacuous `0 = 0` (constrained-away) mode. -/
theorem multiplier_nonzero :
    Qform 1 1 = 0 ∧
      (Mmat 2 3 *ᵥ ![(1 : ℝ), 1] = (-6 : ℝ) • (eta *ᵥ ![1, 1])) ∧ (-6 : ℝ) ≠ 0 := by
  refine ⟨by norm_num [Qform], ?_, by norm_num⟩
  rw [mateq_iff]; norm_num

/-! ## Target 4 : channel-blind coupling (WEP shape) -/

/-- **Target 4 — `wep_corollary`.**  The stationary `(γ, μ)` set depends on `ψ` only through
the *total* stress `M(ψ)`: any two states with the same stress matrix solder identically. -/
theorem wep_corollary (p1 q1 p2 q2 g0 g1 mu : ℝ) (h : Mmat p1 q1 = Mmat p2 q2) :
    Stationary p1 q1 g0 g1 mu ↔ Stationary p2 q2 g0 g1 mu := by
  rw [field_equation, field_equation, h]

/-! ## Target 5 : the equation genuinely selects -/

/-- **Target 5 — `nontrivial_variation_control`.**  The field equation is *not* satisfied by all
cone points: for `ψ' = (1, 0)`, the cone point `γ' = (1, 1)` fails the field equation for
*every* multiplier `μ`.  The equation genuinely selects. -/
theorem nontrivial_variation_control :
    Qform 1 1 = 0 ∧
      ∀ mu : ℝ, ¬ (Mmat 1 0 *ᵥ ![(1 : ℝ), 1] = mu • (eta *ᵥ ![1, 1])) := by
  refine ⟨by norm_num [Qform], ?_⟩
  intro mu h
  rw [mateq_iff] at h
  obtain ⟨h0, h1⟩ := h
  norm_num at h0 h1
  linarith

/-! ## Axiom footprint audits (headlines) -/

/-- info: 'Goal4FieldEquation.action_closed_form' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms action_closed_form

/-- info: 'Goal4FieldEquation.field_equation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms field_equation

/-- info: 'Goal4FieldEquation.multiplier_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms multiplier_nonzero

/-- info: 'Goal4FieldEquation.wep_corollary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wep_corollary

/-- info: 'Goal4FieldEquation.nontrivial_variation_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nontrivial_variation_control

end Goal4FieldEquation
