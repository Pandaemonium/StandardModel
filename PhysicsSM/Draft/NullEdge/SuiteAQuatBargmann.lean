import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# Suite A kill-test: no composable abelian Bargmann CP phase over the quaternions

This file turns the `H`-discriminator of the `DivisionDimensionSelection` argument into a
theorem.  The selection argument for `K = ℂ` (dimension `d = 4`) relies on a **composable,
cyclic, rephasing-invariant** Bargmann invariant.  We show, with fully explicit
rational/integer (quaternion) witnesses, that:

* over `ℂ` the Bargmann triple `⟨ψ₁|ψ₂⟩⟨ψ₂|ψ₃⟩⟨ψ₃|ψ₁⟩` is **rephasing-invariant**
  (the unit phases cancel in the cyclic product), and
* over `ℍ` (the Hamilton quaternions) the analogous object is **neither** rephasing-invariant
  **nor** cyclic — noncommutativity destroys both, and the failures are witnessed by
  *nonzero* triple products (so they are not vacuous).

## Conventions

`bInner x y = star x.1 * y.1 + star x.2 * y.2` is the standard sesquilinear inner product on
two-component vectors (conjugate-linear in the first slot).  `bTriple a b c` is the cyclic
Bargmann triple `⟨a|b⟩⟨b|c⟩⟨c|a⟩`.  A *rephasing* multiplies a vector on the right by a unit
scalar `u` (`scaleR x u`).

### Why right-rephasing *one* vector fails over `ℍ`

For the pivot vector `a` (which appears as the ket of the first factor and the bra of the last
factor), a right-rephasing by a unit `u` produces `bTriple (scaleR a u) b c = star u * B * u`,
i.e. conjugation of `B` by `u`.  Over `ℂ` this is `star u * u * B = B`.  Over `ℍ` conjugation
genuinely moves `B` whenever `u` and `B` do not commute — that is the kill-test payload.
-/

namespace SuiteA_QuatBargmann

/-- Rational Hamilton quaternions: components in `ℚ`, all arithmetic `norm_num`-able. -/
abbrev H := Quaternion ℚ

/-- Sesquilinear inner product of two-component vectors (conjugate-linear in the first slot). -/
def bInner {A : Type*} [Mul A] [Add A] [Star A] (x y : A × A) : A :=
  star x.1 * y.1 + star x.2 * y.2

/-- Right-rephasing: multiply both components of a vector by a scalar `u` on the right. -/
def scaleR {A : Type*} [Mul A] (x : A × A) (u : A) : A × A := (x.1 * u, x.2 * u)

/-- The cyclic Bargmann triple `⟨a|b⟩⟨b|c⟩⟨c|a⟩`. -/
def bTriple {A : Type*} [Mul A] [Add A] [Star A] (a b c : A × A) : A :=
  bInner a b * bInner b c * bInner c a

/-! ### Key algebraic step: how a rephasing acts on an inner product -/

/-- Over a commutative `*`-ring the two right-phases pull out as `star u * v`. -/
theorem bInner_scaleR {A : Type*} [CommRing A] [StarRing A] (x y : A × A) (u v : A) :
    bInner (scaleR x u) (scaleR y v) = star u * v * bInner x y := by
  simp only [bInner, scaleR, star_mul']; ring

/-! ## 1. Complex control: rephasing invariance HOLDS over `ℂ` -/

/-- **Complex control.** For arbitrary two-component complex vectors and arbitrary unit
phases `u₁, u₂, u₃` (`star uₖ * uₖ = 1`), the cyclic Bargmann triple is invariant under the
gauge transformation `ψₖ ↦ ψₖ * uₖ`: the phases cancel in the cyclic product. -/
theorem complex_control (a b c : ℂ × ℂ) (u1 u2 u3 : ℂ)
    (h1 : star u1 * u1 = 1) (h2 : star u2 * u2 = 1) (h3 : star u3 * u3 = 1) :
    bTriple (scaleR a u1) (scaleR b u2) (scaleR c u3) = bTriple a b c := by
  simp only [bTriple, bInner_scaleR]
  have e : star u1 * u2 * bInner a b * (star u2 * u3 * bInner b c) * (star u3 * u1 * bInner c a)
      = (star u1 * u1) * (star u2 * u2) * (star u3 * u3)
          * (bInner a b * bInner b c * bInner c a) := by ring
  rw [e, h1, h2, h3]; ring

/-- Explicit **rational Gaussian-integer** witness for the complex control:
`c1 = (1, i)`. -/
def c1 : ℂ × ℂ := (⟨1, 0⟩, ⟨0, 1⟩)
/-- `c2 = (1+i, 1)`. -/
def c2 : ℂ × ℂ := (⟨1, 1⟩, ⟨1, 0⟩)
/-- `c3 = (i, 1+i)`. -/
def c3 : ℂ × ℂ := (⟨0, 1⟩, ⟨1, 1⟩)
/-- A **Gaussian-rational unit** `(3 + 4i)/5`, used as a nontrivial complex phase. -/
noncomputable def cu : ℂ := ⟨3 / 5, 4 / 5⟩

/-- `(3 + 4i)/5` is a genuine unit phase. -/
theorem cu_unit : star cu * cu = 1 := by
  simp only [cu]; apply Complex.ext <;> simp <;> norm_num

/-- The complex triple product for the Gaussian witness is the nonzero value `2 + 2i`;
so the complex invariance is not vacuous. -/
theorem cB_val : bTriple c1 c2 c3 = (⟨2, 2⟩ : ℂ) := by
  simp only [bTriple, bInner, c1, c2, c3]; apply Complex.ext <;> simp <;> norm_num

/-- Non-degeneracy of the complex witness: its Bargmann triple is nonzero. -/
theorem cB_ne_zero : bTriple c1 c2 c3 ≠ 0 := by
  rw [cB_val]; simp [Complex.ext_iff]

/-! ## 2 & 3. Quaternionic failures -/

/-- Quaternion units `i, j, k`. -/
def qi : H := ⟨0, 1, 0, 0⟩
/-- Quaternion unit `j`. -/
def qj : H := ⟨0, 0, 1, 0⟩
/-- Quaternion unit `k`. -/
def qk : H := ⟨0, 0, 0, 1⟩

/-- Two-component quaternionic witness `p1 = (1, i)`. -/
def p1 : H × H := (1, qi)
/-- `p2 = (j, 1)`. -/
def p2 : H × H := (qj, 1)
/-- `p3 = (1, k)`. -/
def p3 : H × H := (1, qk)

/-- `j` is a genuine unit quaternion (a valid phase). -/
theorem qj_unit : star qj * qj = (1 : H) := by
  simp only [qj]; ext <;> simp

/-- Base value of the quaternionic Bargmann triple: `B = 2 + 2i` (nonzero). -/
theorem qB_val : bTriple p1 p2 p3 = (⟨2, 2, 0, 0⟩ : H) := by
  simp only [bTriple, bInner, p1, p2, p3, qi, qj, qk]; ext <;> simp <;> norm_num

/-- Value after right-rephasing the pivot vector `p1` by the unit `j`:
`B' = star j * B * j = 2 - 2i ≠ B`. -/
theorem qBrephase_val : bTriple (scaleR p1 qj) p2 p3 = (⟨2, -2, 0, 0⟩ : H) := by
  simp only [bTriple, bInner, scaleR, p1, p2, p3, qi, qj, qk]; ext <;> simp <;> norm_num

/-- Value of the cyclically reordered triple: `⟨2|3⟩⟨3|1⟩⟨1|2⟩ = 2 - 2j ≠ B`. -/
theorem qBcyclic_val : bTriple p2 p3 p1 = (⟨2, 0, -2, 0⟩ : H) := by
  simp only [bTriple, bInner, p1, p2, p3, qi, qj, qk]; ext <;> simp <;> norm_num

/-- **Quaternionic rephasing failure (payload).** With explicit integer-quaternion vectors
and the unit quaternion `j`, right-rephasing the pivot vector `p1 ↦ p1 * j` *changes* the
cyclic Bargmann triple.  The statement exhibits both nonzero values `B = 2 + 2i`,
`B' = 2 - 2i`, that `B' ≠ B`, that `B ≠ 0`, and that `j` is a genuine unit — so the failure
is non-vacuous. -/
theorem quaternion_rephasing_fails :
    bTriple p1 p2 p3 = (⟨2, 2, 0, 0⟩ : H)
    ∧ bTriple (scaleR p1 qj) p2 p3 = (⟨2, -2, 0, 0⟩ : H)
    ∧ star qj * qj = (1 : H)
    ∧ bTriple (scaleR p1 qj) p2 p3 ≠ bTriple p1 p2 p3
    ∧ bTriple p1 p2 p3 ≠ 0 := by
  refine ⟨qB_val, qBrephase_val, qj_unit, ?_, ?_⟩
  · rw [qB_val, qBrephase_val]; norm_num [Quaternion.ext_iff]
  · rw [qB_val]; norm_num [Quaternion.ext_iff]

/-- **Quaternionic cyclicity failure (second kill direction).** Over `ℍ` the cyclic
reordering of the *same* triple product gives a different value:
`⟨1|2⟩⟨2|3⟩⟨3|1⟩ = 2 + 2i ≠ 2 - 2j = ⟨2|3⟩⟨3|1⟩⟨1|2⟩`.  Both values are nonzero. -/
theorem quaternion_cyclic_fails :
    bTriple p1 p2 p3 = (⟨2, 2, 0, 0⟩ : H)
    ∧ bTriple p2 p3 p1 = (⟨2, 0, -2, 0⟩ : H)
    ∧ bTriple p1 p2 p3 ≠ bTriple p2 p3 p1
    ∧ bTriple p2 p3 p1 ≠ 0 := by
  refine ⟨qB_val, qBcyclic_val, ?_, ?_⟩
  · rw [qB_val, qBcyclic_val]; norm_num [Quaternion.ext_iff]
  · rw [qBcyclic_val]; norm_num [Quaternion.ext_iff]

/-! ## 4. Selection corollary -/

/-- **Selection corollary.** Packaging 1–3.  The complex Bargmann object is rephasing-invariant
(first conjunct, for *all* complex vectors and unit phases) and cyclic; the quaternionic
analogue of *this same form* is **neither** — there is an explicit unit phase `j` and explicit
nonzero triple products for which right-rephasing changes the value, and the cyclic reordering
changes the value.

Honest scope: this rules out *this construction* — the standard sesquilinear cyclic Bargmann
triple with right-rephasing — over `ℍ`.  It is a kill-test for that specific composable cyclic
abelian Bargmann CP invariant, not a claim about every conceivable invariant. -/
theorem selection_corollary :
    (∀ (a b c : ℂ × ℂ) (u1 u2 u3 : ℂ), star u1 * u1 = 1 → star u2 * u2 = 1 →
        star u3 * u3 = 1 →
        bTriple (scaleR a u1) (scaleR b u2) (scaleR c u3) = bTriple a b c)
    ∧ star qj * qj = (1 : H)
    ∧ bTriple (scaleR p1 qj) p2 p3 ≠ bTriple p1 p2 p3
    ∧ bTriple p1 p2 p3 ≠ bTriple p2 p3 p1
    ∧ bTriple p1 p2 p3 ≠ 0 :=
  ⟨complex_control, qj_unit,
    (quaternion_rephasing_fails.2.2.2.1),
    (quaternion_cyclic_fails.2.2.1),
    (quaternion_rephasing_fails.2.2.2.2)⟩

/-! ## Kernel-checked axiom footprint of every headline -/

/-- info: 'SuiteA_QuatBargmann.complex_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms complex_control

/-- info: 'SuiteA_QuatBargmann.quaternion_rephasing_fails' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quaternion_rephasing_fails

/-- info: 'SuiteA_QuatBargmann.quaternion_cyclic_fails' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quaternion_cyclic_fails

/-- info: 'SuiteA_QuatBargmann.selection_corollary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms selection_corollary

end SuiteA_QuatBargmann
