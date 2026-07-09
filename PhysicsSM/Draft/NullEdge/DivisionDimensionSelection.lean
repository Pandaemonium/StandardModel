import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise
open scoped Quaternion

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# Division-algebra dimension selection (Conjecture N): why `d = 4`

This file formalizes the two *finite, algebraic* discriminators that, in the
null-edge mass program, pick out `K = ℂ` (Minkowski dimension `d = 4`) from the
four normed division algebras

  `K = ℝ, ℂ, ℍ, 𝕆`  with  `d = 3, 4, 6, 10`

(the dimensions of `2×2` Hermitian matrices over `K`, i.e. the Minkowski spaces on
which `SL(2,K)` acts as the Lorentz group).

We work with the concrete Mathlib types `ℝ`, `ℂ`, `Quaternion ℝ`, and — since
octonions are not in Mathlib — a from-scratch **Cayley–Dickson double** of the
quaternions, `Oct := Quaternion ℝ × Quaternion ℝ`, with the standard product.

Two discriminators, each a genuine theorem about the concrete algebras:

* **Composition discriminator** (multi-particle systems / tensor products): a
  well-defined bilinear tensor product of "direction registers" needs a
  *commutative* base algebra.  `ℝ` and `ℂ` are commutative; `ℍ` and `𝕆` are not.

* **Wedge / Bargmann-phase discriminator** (CP phase): the CP phase is the phase
  of a two-spinor bracket.  It must be
    - *continuous* (a positive-dimensional / infinite phase group), which fails
      over `ℝ` (only the two signs `{+1,-1}`), and
    - *order-independent / cyclic* and *abelian*, which fails over `ℍ` (the
      Bargmann triple product is not cyclically invariant) and over `𝕆` (the
      associator obstructs even the triple product).

Assembling the two premises **composition ∧ continuous CP phase** singles out
`ℂ`, hence `d = 4`.  See `division_algebra_selection` and `selects_dim_four`.
-/

namespace NullEdge

/-! ## The four-member family and its Minkowski dimensions -/

/-- The four normed division algebras, indexing the four-member family. -/
inductive DivAlg
  | R
  | C
  | H
  | O
deriving DecidableEq

/-- Minkowski dimension `d` of the `2×2`-Hermitian space over each `K`:
`ℝ ↦ 3, ℂ ↦ 4, ℍ ↦ 6, 𝕆 ↦ 10`. -/
def DivAlg.minkowskiDim : DivAlg → ℕ
  | .R => 3
  | .C => 4
  | .H => 6
  | .O => 10

/-! ## Octonions via the Cayley–Dickson construction

Octonions are absent from Mathlib, so we build them as the Cayley–Dickson double
of the quaternions: `Oct = Quaternion ℝ × Quaternion ℝ` with

  `(a, b) * (c, d) = (a·c - d̄·b, d·a + b·c̄)`.

We only need its (non)commutativity and (non)associativity, so we give the
product as a plain function `omul` rather than a full algebra instance. -/

/-- The octonions as the Cayley–Dickson double of `Quaternion ℝ`. -/
noncomputable abbrev Oct : Type := Quaternion ℝ × Quaternion ℝ

/-- The octonion (Cayley–Dickson) product. -/
noncomputable def omul (x y : Oct) : Oct :=
  (x.1 * y.1 - star y.2 * x.2, y.2 * x.1 + x.2 * star y.1)

/-- Basis octonions used as witnesses (`e 1 = e₁`, `e 2 = e₂`, `e 4 = e₄`). -/
noncomputable def oe (n : ℕ) : Oct :=
  match n with
  | 1 => (⟨0, 1, 0, 0⟩, 0)
  | 2 => (⟨0, 0, 1, 0⟩, 0)
  | _ => (0, ⟨1, 0, 0, 0⟩)

/-! ## Composition discriminator: only `ℝ` and `ℂ` are commutative -/

/-- `ℝ` is commutative: tensor composition is available. -/
theorem comm_real : ∀ x y : ℝ, x * y = y * x := mul_comm

/-- `ℂ` is commutative: tensor composition is available. -/
theorem comm_complex : ∀ x y : ℂ, x * y = y * x := mul_comm

/-- `ℍ` is **not** commutative: no bilinear tensor product of registers. -/
theorem noncomposes_quat : ¬ (∀ x y : Quaternion ℝ, x * y = y * x) := by
  intro h
  have hc := h ⟨0, 1, 0, 0⟩ ⟨0, 0, 1, 0⟩
  simp only [Quaternion.ext_iff] at hc
  norm_num at hc

/-- `𝕆` is **not** commutative: no bilinear tensor product of registers. -/
theorem noncomposes_oct : ¬ (∀ x y : Oct, omul x y = omul y x) := by
  intro h
  have hc := h (oe 1) (oe 2)
  simp only [omul, oe, Prod.mk.injEq, Quaternion.ext_iff] at hc
  norm_num at hc

/-! ## Wedge / Bargmann-phase discriminator

### (a) Order-independence: cyclic invariance of the Bargmann triple product

Over a commutative algebra the triple bracket `a·b·c` is invariant under cyclic
permutation, so the Bargmann phase is order-independent.  Over `ℍ` it is not. -/

/-- Over `ℂ` the Bargmann triple product is cyclically invariant (order-independent). -/
theorem bargmann_cyclic_complex : ∀ a b c : ℂ, a * b * c = c * a * b := by
  intro a b c; ring

/-- Over `ℍ` the Bargmann triple product is **not** cyclically invariant: the
noncommutative `Sp(1)` "phase" loses order-independent well-definedness. -/
theorem bargmann_noncyclic_quat : ∃ a b c : Quaternion ℝ, a * b * c ≠ c * a * b := by
  refine ⟨⟨0, 1, 0, 0⟩, ⟨0, 0, 1, 0⟩, ⟨0, 1, 0, 0⟩, ?_⟩
  simp only [ne_eq, Quaternion.ext_iff]
  norm_num

/-- Over `𝕆` the associator obstructs the triple product itself: multiplication
is not associative, so there is no well-defined `a·b·c`. -/
theorem oct_nonassoc : ∃ a b c : Oct, omul (omul a b) c ≠ omul a (omul b c) := by
  refine ⟨oe 1, oe 2, oe 4, ?_⟩
  simp only [omul, oe, ne_eq, Prod.mk.injEq, not_and_or, Quaternion.ext_iff]
  norm_num

/-! ### (b) Continuity: the phase group is infinite only for `ℂ` (and `ℍ`), not `ℝ` -/

/-- The unit-norm ("phase") set of `ℝ`. -/
def phaseR : Set ℝ := {x : ℝ | ‖x‖ = 1}

/-- The unit-norm ("phase") set of `ℂ`. -/
def phaseC : Set ℂ := {x : ℂ | ‖x‖ = 1}

/-- Over `ℝ` the phase set is exactly the two signs `{1, -1}`. -/
theorem phaseR_eq : phaseR = {1, -1} := by
  ext x
  simp only [phaseR, Set.mem_setOf_eq, Real.norm_eq_abs, Set.mem_insert_iff,
    Set.mem_singleton_iff]
  rw [abs_eq (by norm_num : (0 : ℝ) ≤ 1)]

/-- Over `ℝ` the phase set is finite: there is no *continuous* phase, only `CP = ±1`. -/
theorem phaseR_finite : phaseR.Finite := by
  rw [phaseR_eq]; exact (Set.finite_singleton _).insert _

/-- Consequently the real phase set is not infinite. -/
theorem phaseR_not_infinite : ¬ phaseR.Infinite := by
  rw [Set.not_infinite]; exact phaseR_finite

/-
Over `ℂ` the phase set (unit circle) is infinite: a genuine continuous phase.
-/
theorem phaseC_infinite : phaseC.Infinite := by
  convert Set.infinite_of_injective_forall_mem ( show Function.Injective ( fun n : ℕ => ( Complex.exp ( 2 * Real.pi * Complex.I / ( n + 1 ) ) : ℂ ) ) from ?_ ) ( fun n => ?_ ) using 1;
  · intros m n hmn;
    rw [ Complex.exp_eq_exp_iff_exists_int ] at hmn;
    obtain ⟨ k, hk ⟩ := hmn; rw [ div_add', div_eq_div_iff ] at hk <;> norm_num [ Complex.ext_iff, Real.pi_ne_zero ] at *;
    · rcases k with ⟨ _ | k ⟩ <;> norm_num at hk;
      · exact hk.symm;
      · exact False.elim <| by nlinarith [ Real.pi_pos, mul_pos Real.pi_pos ( Nat.cast_add_one_pos n ), mul_pos Real.pi_pos ( Nat.cast_add_one_pos m ), mul_pos ( mul_pos Real.pi_pos ( Nat.cast_add_one_pos n ) ) ( Nat.cast_add_one_pos m ) ] ;
      · nlinarith [ Real.pi_pos, mul_pos Real.pi_pos ( Nat.cast_add_one_pos n ), mul_pos Real.pi_pos ( Nat.cast_add_one_pos m ), mul_pos ( mul_pos Real.pi_pos ( Nat.cast_add_one_pos n ) ) ( Nat.cast_add_one_pos m ) ];
    · linarith;
    · linarith;
    · linarith;
  · norm_num [ phaseC, Complex.norm_exp ];
    norm_num [ div_eq_mul_inv ]

/-! ## Assembly: composition ∧ continuous CP phase force `K = ℂ`, hence `d = 4` -/

/-- `Composes K`: the base algebra `K` is commutative, so a bilinear tensor
product of direction registers (multi-particle composition) exists. -/
def Composes : DivAlg → Prop
  | .R => ∀ x y : ℝ, x * y = y * x
  | .C => ∀ x y : ℂ, x * y = y * x
  | .H => ∀ x y : Quaternion ℝ, x * y = y * x
  | .O => ∀ x y : Oct, omul x y = omul y x

/-- `ContinuousPhase K`: the unit-norm phase set of `K` is infinite (a continuous,
positive-dimensional phase group, as needed to carry a measurable CP phase). -/
def ContinuousPhase : DivAlg → Prop
  | .R => phaseR.Infinite
  | .C => phaseC.Infinite
  | .H => {x : Quaternion ℝ | ‖x‖ = 1}.Infinite
  | .O => {x : Oct | ‖x‖ = 1}.Infinite

/-- **Dimension-selection theorem.** Among the four normed division algebras,
`ℂ` is the *unique* member that simultaneously supports composition (tensor
products / multi-particle systems) and a continuous CP phase. -/
theorem division_algebra_selection (k : DivAlg) :
    (Composes k ∧ ContinuousPhase k) ↔ k = DivAlg.C := by
  constructor
  · rintro ⟨hcomp, hphase⟩
    cases k with
    | R => exact absurd hphase phaseR_not_infinite
    | C => rfl
    | H => exact absurd hcomp noncomposes_quat
    | O => exact absurd hcomp noncomposes_oct
  · rintro rfl
    exact ⟨comm_complex, phaseC_infinite⟩

/-- The selected member `ℂ` has Minkowski dimension `d = 4`. -/
theorem selects_dim_four : DivAlg.C.minkowskiDim = 4 := rfl

/-- **Corollary (the full selection statement).** The two physical premises
— composition exists and the CP phase is continuous — hold for a unique `K`, and
that `K = ℂ` sits in Minkowski dimension `4`. -/
theorem dimension_is_four (k : DivAlg)
    (h : Composes k ∧ ContinuousPhase k) : k.minkowskiDim = 4 := by
  rw [(division_algebra_selection k).mp h]; rfl

/-! ## In-file axiom guard

All results below must rest only on `propext`, `Classical.choice`, `Quot.sound`. -/

#print axioms division_algebra_selection
#print axioms dimension_is_four
#print axioms selects_dim_four
#print axioms noncomposes_quat
#print axioms noncomposes_oct
#print axioms bargmann_cyclic_complex
#print axioms bargmann_noncyclic_quat
#print axioms oct_nonassoc
#print axioms phaseR_finite
#print axioms phaseC_infinite

end NullEdge
