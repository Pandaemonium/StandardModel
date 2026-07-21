import Mathlib

/-!
# Changing momentum-box exhaustion

This is D-R3-2. It separates physical box exhaustion from lattice-density and
walk-dynamics claims. A radius schedule tending to infinity eventually contains
every fixed momentum. A bounded schedule has an explicit point outside every
box.
-/

noncomputable section

open Filter Set
open scoped BigOperators Topology

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumBoxExhaustion

abbrev Momentum3 := Fin 3 -> Real

def momentumBox (r : Real) : Set Momentum3 :=
  Set.pi Set.univ (fun _ : Fin 3 => Set.Icc (-r) r)

def physicalRadius (h : Nat -> Real) (N : Nat) : Real :=
  (N : Real) * h N

theorem momentumBox_mono : Monotone momentumBox := by
  intro r s hrs x hx i hi
  have hxi := hx i (Set.mem_univ i)
  exact ⟨by linarith [hxi.1], by linarith [hxi.2]⟩

lemma coord_abs_le_sum (x : Momentum3) (i : Fin 3) :
    |x i| <= ∑ j : Fin 3, |x j| := by
  exact Finset.single_le_sum (fun j _ => abs_nonneg (x j)) (Finset.mem_univ i)

/-- If the physical radius tends to infinity, every fixed momentum eventually
lies in every later box. -/
theorem eventually_mem_momentumBox {r : Nat -> Real}
    (hr : Tendsto r atTop atTop) (x : Momentum3) :
    ∀ᶠ N in atTop, x ∈ momentumBox (r N) := by
  have hrad : ∀ᶠ N in atTop, (∑ i : Fin 3, |x i|) <= r N :=
    (tendsto_atTop.1 hr) (∑ i : Fin 3, |x i|)
  filter_upwards [hrad] with N hN
  intro i hi
  have hxi := coord_abs_le_sum x i
  exact abs_le.mp (hxi.trans hN)

/-- Pointwise exhaustion formulation. -/
theorem momentumBox_exhausts {r : Nat -> Real}
    (hr : Tendsto r atTop atTop) (x : Momentum3) :
    ∃ N, x ∈ momentumBox (r N) := by
  exact (eventually_mem_momentumBox hr x).exists

def boundedOutsidePoint (R : Real) : Momentum3 :=
  fun _ => |R| + 1

/-- A uniformly bounded radius schedule cannot exhaust momentum space. -/
theorem bounded_schedule_has_outside_point {r : Nat -> Real} (R : Real)
    (hR : ∀ N, r N <= R) :
    ∀ N, boundedOutsidePoint R ∉ momentumBox (r N) := by
  intro N hx
  have hcoord := (hx (0 : Fin 3) (Set.mem_univ 0)).2
  dsimp [boundedOutsidePoint] at hcoord
  have hRabs : R <= |R| := le_abs_self R
  linarith [hR N]

/-- The bounded-schedule kill is witnessed by one fixed point for all boxes. -/
theorem bounded_schedule_not_exhaustive {r : Nat -> Real} (R : Real)
    (hR : ∀ N, r N <= R) :
    ∃ x : Momentum3, ∀ N, x ∉ momentumBox (r N) := by
  exact ⟨boundedOutsidePoint R, bounded_schedule_has_outside_point R hR⟩

/-! ## Assumption-footprint audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumBoxExhaustion.momentumBox_exhausts' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms momentumBox_exhausts

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumBoxExhaustion.bounded_schedule_not_exhaustive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bounded_schedule_not_exhaustive

end PhysicsSM.Draft.NullEdge.ChangingMomentumBoxExhaustion
