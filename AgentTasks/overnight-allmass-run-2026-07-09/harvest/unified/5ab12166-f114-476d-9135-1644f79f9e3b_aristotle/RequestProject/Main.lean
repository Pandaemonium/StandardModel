import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# One spectral action, both field equations (finite avatar)

This file develops a fully explicit, finite-matrix "spectral action" avatar of the
unification idea that a single functional `S(D)` yields *two* field equations:

* varying `S` in the **soldering / geometry** parameter `E` (`dS/dE = 0`) gives the
  finite **gravity** field equation;
* varying `S` in the **matter coupling** parameter `g` (`dS/dg = 0`) gives the finite
  **matter** field equation.

The Dirac operator is the explicit rational `2×2` operator

`D(E,g) = Dkin + E • Dsold + g • Dmatter`

and the action is the finite spectral action

`S(E,g) = a₀·tr(1) + a₂·tr(D²) + a₄·tr(D⁴)`

with `a₀ = 5, a₂ = -4, a₄ = 1`.  With the chosen (nilpotent, distinct, nonzero) decorations
`Dsold, Dmatter` the action collapses to a rational polynomial in the single combination
`w = (2+E)(3+g)`, namely `S = 10 - 8·w + 2·w²`.  Consequently both stationarity conditions
are *linear* in the varied parameter (clean "both directions" characterizations), and they are
genuinely coupled: the gravity equation reads `E* = (-4-2g)/(3+g)` and the matter equation reads
`g* = (-4-3E)/(2+E)`, meeting at the joint rational stationary point `(E*, g*) = (-1, -1)`.

**Honest scope.**  This is a finite polynomial-action avatar, *not* the continuum spectral
action; `tr(1), tr(D²), tr(D⁴)` are the order-0/2/4 "rungs" of the finite functional.
-/

namespace UnifiedActionVariation

/-- Kinetic part of the Dirac operator (explicit, nonzero, distinct from the decorations). -/
def Dkin : Matrix (Fin 2) (Fin 2) ℝ := !![0, 2; 3, 0]

/-- Soldering (geometry) decoration, coupled to `E`.  Nilpotent (`Dsold² = 0`). -/
def Dsold : Matrix (Fin 2) (Fin 2) ℝ := !![0, 1; 0, 0]

/-- Matter decoration, coupled to `g`.  Nilpotent (`Dmatter² = 0`). -/
def Dmatter : Matrix (Fin 2) (Fin 2) ℝ := !![0, 0; 1, 0]

/-- The explicit rational Dirac operator `D(E,g) = Dkin + E•Dsold + g•Dmatter`. -/
def D (E g : ℝ) : Matrix (Fin 2) (Fin 2) ℝ := Dkin + E • Dsold + g • Dmatter

/-- Order-0 spectral coefficient (cosmological-constant rung). -/
def coeff0 : ℝ := 5
/-- Order-2 spectral coefficient (gravity rung). -/
def coeff2 : ℝ := -4
/-- Order-4 spectral coefficient (matter rung). -/
def coeff4 : ℝ := 1

/-- The finite spectral action `S = a₀·tr(1) + a₂·tr(D²) + a₄·tr(D⁴)`. -/
def S (E g : ℝ) : ℝ :=
  coeff0 * Matrix.trace (1 : Matrix (Fin 2) (Fin 2) ℝ)
  + coeff2 * Matrix.trace ((D E g) ^ 2)
  + coeff4 * Matrix.trace ((D E g) ^ 4)

/-- The single scalar combination through which both couplings enter the action. -/
def wComb (E g : ℝ) : ℝ := (2 + E) * (3 + g)

/-! ## Non-degeneracy of the data -/

/-- The three building blocks are all nonzero and pairwise distinct. -/
theorem matrices_nondegenerate :
    Dkin ≠ 0 ∧ Dsold ≠ 0 ∧ Dmatter ≠ 0 ∧
    Dkin ≠ Dsold ∧ Dkin ≠ Dmatter ∧ Dsold ≠ Dmatter := by
  refine' ⟨ _, _, _, _, _, _ ⟩ <;> intro h <;> have := congr_fun ( congr_fun h 0 ) 1 <;> norm_num [ UnifiedActionVariation.Dkin, UnifiedActionVariation.Dsold, UnifiedActionVariation.Dmatter ] at this;
  exact absurd ( congr_fun ( congr_fun h 1 ) 0 ) ( by norm_num [ UnifiedActionVariation.Dmatter ] )

/-! ## Target 1 : closed form of the action -/

/-- Closed form of the order-2 trace: `tr(D²) = 2·w` with `w = (2+E)(3+g)`. -/
theorem trace_sq_closed (E g : ℝ) :
    Matrix.trace ((D E g) ^ 2) = 2 * wComb E g := by
  simp only [D, Dkin, Dsold, Dmatter, wComb, pow_two, Matrix.trace_fin_two, Matrix.mul_apply,
    Fin.sum_univ_two, Matrix.add_apply, Matrix.smul_apply, Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.of_apply, smul_eq_mul]
  ring

/-- Closed form of the order-4 trace: `tr(D⁴) = 2·w²`. -/
theorem trace_quartic_closed (E g : ℝ) :
    Matrix.trace ((D E g) ^ 4) = 2 * (wComb E g) ^ 2 := by
  simp only [D, Dkin, Dsold, Dmatter, wComb, show (4:ℕ) = 2 + 2 from rfl, pow_add, pow_two,
    Matrix.trace_fin_two, Matrix.mul_apply, Fin.sum_univ_two, Matrix.add_apply, Matrix.smul_apply,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.of_apply, smul_eq_mul]
  ring

/-- **Target 1** `action_closed_form`: the finite spectral action as an explicit rational
polynomial, with the order-0 (constant `10`), order-2 (`-8w`, gravity rung) and order-4
(`2w²`, matter rung) parts identified through `w = (2+E)(3+g)`. -/
theorem action_closed_form (E g : ℝ) :
    S E g = 10 - 8 * wComb E g + 2 * (wComb E g) ^ 2 := by
  rw [S, trace_sq_closed, trace_quartic_closed, Matrix.trace_one]
  simp only [coeff0, coeff2, coeff4, Fintype.card_fin, Nat.cast_ofNat]
  ring

/-! ## Target 2 : gravity equation `dS/dE = 0` -/

/-- The derivative of `E ↦ S(E,g)` (geometry variation), via `HasDerivAt`. -/
theorem gravity_hasDerivAt (g E : ℝ) :
    HasDerivAt (fun E => S E g) ((-8 + 4 * wComb E g) * (3 + g)) E := by
  have hfun : (fun E => S E g)
      = (fun E => 10 - 8 * wComb E g + 2 * (wComb E g) ^ 2) := by
    funext E; exact action_closed_form E g
  rw [hfun]
  have hw : HasDerivAt (fun E => wComb E g) (3 + g) E := by
    have : HasDerivAt (fun E => (2 + E) * (3 + g)) (1 * (3 + g)) E :=
      ((hasDerivAt_id E).const_add 2).mul_const (3 + g)
    simpa [wComb, one_mul] using this
  have hd := (((hasDerivAt_const E (10 : ℝ)).sub (hw.const_mul 8)).add ((hw.pow 2).const_mul 2))
  convert hd using 1
  ring

/-- **Target 2** `gravity_equation`: soldering stationarity.  Whenever `3+g ≠ 0`, the gravity
field equation `dS/dE = 0` holds **iff** the geometry responds to the matter coupling by
`E = (-4-2g)/(3+g)`.  (Both directions.) -/
theorem gravity_equation (g E : ℝ) (hg : (3 : ℝ) + g ≠ 0) :
    (-8 + 4 * wComb E g) * (3 + g) = 0 ↔ E = (-4 - 2 * g) / (3 + g) := by
  grind +locals

/-! ## Target 3 : matter equation `dS/dg = 0` -/

/-- The derivative of `g ↦ S(E,g)` (matter variation), via `HasDerivAt`. -/
theorem matter_hasDerivAt (E g : ℝ) :
    HasDerivAt (fun g => S E g) ((-8 + 4 * wComb E g) * (2 + E)) g := by
  have hfun : (fun g => S E g)
      = (fun g => 10 - 8 * wComb E g + 2 * (wComb E g) ^ 2) := by
    funext g; exact action_closed_form E g
  rw [hfun]
  have hw : HasDerivAt (fun g => wComb E g) (2 + E) g := by
    have : HasDerivAt (fun g => (2 + E) * (3 + g)) ((2 + E) * 1) g :=
      ((hasDerivAt_id g).const_add 3).const_mul (2 + E)
    simpa [wComb, mul_one] using this
  have hd := (((hasDerivAt_const g (10 : ℝ)).sub (hw.const_mul 8)).add ((hw.pow 2).const_mul 2))
  convert hd using 1
  ring

/-- **Target 3** `matter_equation`: matter stationarity.  Whenever `2+E ≠ 0`, the matter field
equation `dS/dg = 0` holds **iff** the matter coupling responds to the geometry by
`g = (-4-3E)/(2+E)`.  (Both directions.) -/
theorem matter_equation (E g : ℝ) (hE : (2 : ℝ) + E ≠ 0) :
    (-8 + 4 * wComb E g) * (2 + E) = 0 ↔ g = (-4 - 3 * E) / (2 + E) := by
  grind +locals

/-! ## Target 4 : the coupled joint stationary point -/

/-- The gravity and matter equations are **genuinely distinct**: their derivative functions
differ (here evidenced at the control point `(0,0)`, where the values are `48 ≠ 32`). -/
theorem derivatives_distinct :
    (-8 + 4 * wComb 0 0) * (3 + 0) ≠ (-8 + 4 * wComb 0 0) * (2 + 0) := by
  norm_num [ UnifiedActionVariation.wComb ]

/-- A control point `(E,g) = (0,0)` at which **neither** field equation holds. -/
theorem control_point_neither :
    (-8 + 4 * wComb 0 0) * (3 + 0) ≠ 0 ∧ (-8 + 4 * wComb 0 0) * (2 + 0) ≠ 0 := by
  norm_num [ UnifiedActionVariation.wComb ]

/-- **Target 4** `coupled_stationary_point`: the explicit nonzero rational pair `(E*,g*) = (-1,-1)`
simultaneously solves the gravity equation `E* = (-4-2g*)/(3+g*)`, the matter equation
`g* = (-4-3E*)/(2+E*)`, and makes both derivatives vanish. -/
theorem coupled_stationary_point :
    (-8 + 4 * wComb (-1) (-1)) * (3 + (-1)) = 0 ∧
    (-8 + 4 * wComb (-1) (-1)) * (2 + (-1)) = 0 ∧
    (-1 : ℝ) = (-4 - 2 * (-1)) / (3 + (-1)) ∧
    (-1 : ℝ) = (-4 - 3 * (-1)) / (2 + (-1)) := by
  norm_num [ UnifiedActionVariation.wComb ]

/-- The joint point `(-1,-1)` seen through `HasDerivAt`: both variations of the single action
have vanishing derivative there. -/
theorem coupled_hasDerivAt :
    HasDerivAt (fun E => S E (-1)) 0 (-1) ∧ HasDerivAt (fun g => S (-1) g) 0 (-1) := by
  refine ⟨?_, ?_⟩
  · have h := gravity_hasDerivAt (-1) (-1)
    norm_num [wComb] at h
    exact h
  · have h := matter_hasDerivAt (-1) (-1)
    norm_num [wComb] at h
    exact h

/-! ## The capstone verdict -/

/-- **`one_action_verdict`**: one functional `S(D)`, two field equations.  It packages: the
closed form of the finite spectral action; the two `HasDerivAt` variations (gravity `dS/dE`,
matter `dS/dg`); their vanishing at the coupled joint stationary point `(-1,-1)`; and a control
point where neither equation holds.  Gravity, matter, and the order-0 (Λ) constant are all rungs
of the single action `S`.  Finite avatar, not the continuum spectral action. -/
theorem one_action_verdict :
    (∀ E g : ℝ, S E g = 10 - 8 * wComb E g + 2 * (wComb E g) ^ 2) ∧
    (∀ g E : ℝ, HasDerivAt (fun E => S E g) ((-8 + 4 * wComb E g) * (3 + g)) E) ∧
    (∀ E g : ℝ, HasDerivAt (fun g => S E g) ((-8 + 4 * wComb E g) * (2 + E)) g) ∧
    (HasDerivAt (fun E => S E (-1)) 0 (-1) ∧ HasDerivAt (fun g => S (-1) g) 0 (-1)) ∧
    ((-8 + 4 * wComb 0 0) * (3 + 0) ≠ 0 ∧ (-8 + 4 * wComb 0 0) * (2 + 0) ≠ 0) := by
  exact ⟨action_closed_form, gravity_hasDerivAt, matter_hasDerivAt, coupled_hasDerivAt,
    control_point_neither⟩

/-! ## Axiom audit -/

/-- info: 'UnifiedActionVariation.action_closed_form' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms action_closed_form

/-- info: 'UnifiedActionVariation.gravity_equation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gravity_equation

/-- info: 'UnifiedActionVariation.matter_equation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms matter_equation

/-- info: 'UnifiedActionVariation.coupled_stationary_point' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coupled_stationary_point

/-- info: 'UnifiedActionVariation.one_action_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms one_action_verdict

end UnifiedActionVariation
