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

set_option grind.warning false

/-!
# The finite gravitational equation of state (Clausius ⇒ field equation)

This file builds a **finite, fully kernel-checked avatar** of Jacobson's 1995 derivation of the
Einstein equation as an *equation of state*: the Clausius relation `δQ = T δS` (with entropy
proportional to horizon **area**) across a local causal horizon is equivalent to a field equation.

We model the **null-edge soldering (gravity) channel** of a small causal slab by explicit rational
functions of a soldering-decoration vector `γ = (g₀, g₁) : ℝ × ℝ` (all constants rational):

* `area γ = g₀ + g₁`           — the pierced-edge count / boundary measure;
* `entropy γ = alpha * area γ`  — with `alpha = 1/4`;
* `heat γ = g₀²/2 + g₁²/2 + 7`  — the soldering-channel budget flux (the `E_#` E-slot flux);
* `temp = 4`                    — a fixed nonzero Unruh-type temperature.

A soldering variation is the path `γ ↦ γ + t·v`. The Clausius relation is
`d/dt heat = T · d/dt entropy` along that path (finite gradients via `HasDerivAt`).

The gradients are `grad heat γ = (g₀, g₁)` and `grad area = (1,1)`, so the **finite field equation**
is `grad heat γ = (T·alpha) • grad area`. The payload `equation_of_state` proves that the Clausius
relation holds **for all variation directions `v`** *iff* the field equation holds — i.e. the field
equation is the integrability condition of the thermodynamic equation of state.

Non-degeneracy is witnessed explicitly: `γ* = (1,1)`, `v = (1,0)` satisfies the field equation with
`δheat = T·δS = 1 ≠ 0`, while the control `γ = (2,2)`, `v = (1,0)` violates it.

This is a **finite slab avatar** of the equation-of-state derivation, not continuum general
relativity.
-/

namespace JacobsonClausius

/-- The entropy/area coefficient (`S = α·A`); Bekenstein–Hawking `1/4`. -/
noncomputable def alpha : ℝ := 1 / 4

/-- The fixed rational Unruh-type temperature (nonzero). -/
noncomputable def temp : ℝ := 4

/-- Pierced-edge count / boundary measure: an explicit linear function of the soldering vector. -/
def area (g : ℝ × ℝ) : ℝ := g.1 + g.2

/-- Horizon entropy `S = α·A`. -/
noncomputable def entropy (g : ℝ × ℝ) : ℝ := alpha * area g

/-- Soldering-channel budget flux (the `E_#` E-slot flux) across the boundary. -/
noncomputable def heat (g : ℝ × ℝ) : ℝ := g.1 ^ 2 / 2 + g.2 ^ 2 / 2 + 7

/-- A soldering variation: deform the slab along direction `v` with parameter `t`. -/
def path (g v : ℝ × ℝ) (t : ℝ) : ℝ × ℝ := (g.1 + t * v.1, g.2 + t * v.2)

/-- The soldering-flux gradient `grad heat γ = (g₀, g₁)`. -/
def gradHeat (g : ℝ × ℝ) : ℝ × ℝ := (g.1, g.2)

/-- The area gradient `grad area = (1, 1)` (constant, since `area` is linear). -/
def gradArea : ℝ × ℝ := (1, 1)

/-- Derivative of a scalar affine motion `t ↦ a + t·b` is `b`. -/
lemma comp1 (a b : ℝ) : HasDerivAt (fun t : ℝ => a + t * b) b 0 := by
  simpa using ((hasDerivAt_id (0 : ℝ)).mul_const b).const_add a

/-- The finite heat gradient along a soldering variation, via `HasDerivAt`. -/
lemma heat_deriv (g v : ℝ × ℝ) :
    HasDerivAt (fun t => heat (path g v t)) (g.1 * v.1 + g.2 * v.2) 0 := by
  have h1 := comp1 g.1 v.1
  have h2 := comp1 g.2 v.2
  have H := (((h1.pow 2).div_const 2).add ((h2.pow 2).div_const 2)).add_const (7 : ℝ)
  have key : (fun t => heat (path g v t))
      = fun t => (g.1 + t * v.1) ^ 2 / 2 + (g.2 + t * v.2) ^ 2 / 2 + 7 := by
    funext t; simp [heat, path]
  rw [key]; convert H using 1; simp; ring

/-- The finite entropy gradient along a soldering variation, via `HasDerivAt`. -/
lemma entropy_deriv (g v : ℝ × ℝ) :
    HasDerivAt (fun t => entropy (path g v t)) (alpha * (v.1 + v.2)) 0 := by
  have h1 := comp1 g.1 v.1
  have h2 := comp1 g.2 v.2
  have H := (h1.add h2).const_mul alpha
  have key : (fun t => entropy (path g v t))
      = fun t => alpha * ((g.1 + t * v.1) + (g.2 + t * v.2)) := by
    funext t; simp [entropy, area, path]
  rw [key]; exact H

/-- Closed form for `δheat`: the heat gradient dotted with the variation direction. -/
lemma dHeat (g v : ℝ × ℝ) :
    deriv (fun t => heat (path g v t)) 0 = (gradHeat g).1 * v.1 + (gradHeat g).2 * v.2 := by
  rw [(heat_deriv g v).deriv]; simp [gradHeat]

/-- Closed form for `δentropy`: `α` times the area gradient dotted with the variation direction. -/
lemma dEntropy (g v : ℝ × ℝ) :
    deriv (fun t => entropy (path g v t)) 0
      = alpha * ((gradArea).1 * v.1 + (gradArea).2 * v.2) := by
  rw [(entropy_deriv g v).deriv]; simp only [gradArea]; ring

/-- **Target 1 — closed forms for the Clausius LHS/RHS** under the soldering variation
`γ ↦ γ + t·v`: `δheat = grad heat · v` and `T·δS = (T·α)·(grad area · v)`. -/
theorem clausius_lhs_rhs (g v : ℝ × ℝ) :
    deriv (fun t => heat (path g v t)) 0 = (gradHeat g).1 * v.1 + (gradHeat g).2 * v.2
    ∧ temp * deriv (fun t => entropy (path g v t)) 0
        = temp * alpha * ((gradArea).1 * v.1 + (gradArea).2 * v.2) := by
  refine ⟨dHeat g v, ?_⟩; rw [dEntropy]; ring

/-- The finite soldering field equation: `grad heat γ = (T·α) • grad area`. -/
def FieldEq (g : ℝ × ℝ) : Prop := gradHeat g = (temp * alpha) • gradArea

/-- The Clausius relation along every soldering variation direction. -/
def ClausiusHolds (g : ℝ × ℝ) : Prop :=
  ∀ v : ℝ × ℝ, deriv (fun t => heat (path g v t)) 0
    = temp * deriv (fun t => entropy (path g v t)) 0

/-- **Target 2 — the equation of state (payload).** The Clausius relation
`d/dt heat = T · d/dt entropy` holds for **all** variation directions `v` **iff** the finite field
equation `grad heat γ = (T·α) • grad area` holds. The field equation is exactly the integrability
condition of the equation of state. -/
theorem equation_of_state (g : ℝ × ℝ) : ClausiusHolds g ↔ FieldEq g := by
  unfold ClausiusHolds FieldEq
  simp only [dHeat, dEntropy, gradHeat, gradArea, Prod.smul_mk, smul_eq_mul, Prod.mk.injEq]
  constructor
  · intro h
    have hx := h (1, 0)
    have hy := h (0, 1)
    exact ⟨by linear_combination hx, by linear_combination hy⟩
  · intro h v
    obtain ⟨h1, h2⟩ := h
    rw [h1, h2]; ring

/-- **Non-degeneracy witness.** At `γ* = (1,1)` with `v = (1,0)` the field equation holds and the
Clausius relation is satisfied with all quantities nonzero: `δheat = T·δS = 1 ≠ 0`. -/
theorem nondegenerate_witness :
    FieldEq ((1 : ℝ), (1 : ℝ)) ∧
    deriv (fun t => heat (path ((1 : ℝ), (1 : ℝ)) ((1 : ℝ), (0 : ℝ)) t)) 0
      = temp * deriv (fun t => entropy (path ((1 : ℝ), (1 : ℝ)) ((1 : ℝ), (0 : ℝ)) t)) 0
    ∧ deriv (fun t => heat (path ((1 : ℝ), (1 : ℝ)) ((1 : ℝ), (0 : ℝ)) t)) 0 ≠ 0 := by
  refine ⟨?_, ?_, ?_⟩
  · unfold FieldEq gradHeat gradArea temp alpha; norm_num
  · rw [dHeat, dEntropy]; unfold gradHeat gradArea temp alpha; norm_num
  · rw [dHeat]; unfold gradHeat; norm_num

/-- **Control witness.** At `γ = (2,2)` with `v = (1,0)` the field equation is violated and the
Clausius relation fails: `δheat = 2 ≠ 1 = T·δS`. So the equivalence is not vacuous. -/
theorem control_witness :
    ¬ FieldEq ((2 : ℝ), (2 : ℝ)) ∧
    deriv (fun t => heat (path ((2 : ℝ), (2 : ℝ)) ((1 : ℝ), (0 : ℝ)) t)) 0
      ≠ temp * deriv (fun t => entropy (path ((2 : ℝ), (2 : ℝ)) ((1 : ℝ), (0 : ℝ)) t)) 0 := by
  constructor
  · unfold FieldEq gradHeat gradArea temp alpha
    simp only [Prod.smul_mk, smul_eq_mul, Prod.mk.injEq, not_and]
    intro h; norm_num at h
  · rw [dHeat, dEntropy]; unfold gradHeat gradArea temp alpha; norm_num

/-- **Target 3 — Jacobson verdict (package).** The finite soldering (gravity) field equation is
equivalent to imposing the Clausius law `δQ = T δS` with `S ∝ area` across the slab, for every
soldering decoration; and the equivalence is non-degenerate (a witness where everything is nonzero
and a control where Clausius fails). The gravity channel obeys a thermodynamic equation of state,
finitely and kernel-checked. -/
theorem jacobson_verdict :
    (∀ g : ℝ × ℝ, ClausiusHolds g ↔ FieldEq g)
    ∧ (∃ g v : ℝ × ℝ, FieldEq g ∧
        deriv (fun t => heat (path g v t)) 0
          = temp * deriv (fun t => entropy (path g v t)) 0
        ∧ deriv (fun t => heat (path g v t)) 0 ≠ 0)
    ∧ (∃ g v : ℝ × ℝ, ¬ FieldEq g ∧
        deriv (fun t => heat (path g v t)) 0
          ≠ temp * deriv (fun t => entropy (path g v t)) 0) :=
  ⟨equation_of_state,
    ⟨(1, 1), (1, 0), nondegenerate_witness⟩,
    ⟨(2, 2), (1, 0), control_witness⟩⟩

-- Kernel-footprint checks on every headline: exactly [propext, Classical.choice, Quot.sound].
/-- info: 'JacobsonClausius.clausius_lhs_rhs' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms clausius_lhs_rhs
/-- info: 'JacobsonClausius.equation_of_state' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms equation_of_state
/-- info: 'JacobsonClausius.nondegenerate_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms nondegenerate_witness
/-- info: 'JacobsonClausius.control_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms control_witness
/-- info: 'JacobsonClausius.jacobson_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms jacobson_verdict

end JacobsonClausius
