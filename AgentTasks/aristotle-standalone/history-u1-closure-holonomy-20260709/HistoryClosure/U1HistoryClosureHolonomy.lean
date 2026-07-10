import Mathlib

/-!
# Gauge-invariant closure phase on finite histories

Focused Mathlib-only target extending the landed history-local action algebra.
The turn phase is already local and exact. This target supplies the next
missing channel: a multiplicative U(1) transport along vertices, endpoint
gauge covariance on open histories, and gauge invariance on closed histories.

The exact Fin 4 loop carries nontrivial holonomy I, so the result cannot be
satisfied by the identity phase alone. This is a finite closure-phase theorem,
not a continuum gauge field, path integral, or Yang-Mills action.
-/

open Complex

namespace U1HistoryClosureHolonomy

variable {V : Type*}

/-- A complex edge transport between finite history vertices. -/
abbrev EdgeField (V : Type*) := V → V → ℂ

/-- A vertex gauge transformation. -/
abbrev Gauge (V : Type*) := V → ℂ

/-- Endpoint gauge action U'(x,y) = g(y) U(x,y) star(g(x)). -/
def gaugeTransform (g : Gauge V) (U : EdgeField V) : EdgeField V :=
  fun x y => g y * U x y * star (g x)

/-- Ordered transport from start x through the listed subsequent vertices. -/
def pathHolonomyFrom (U : EdgeField V) : V → List V → ℂ
  | _, [] => 1
  | x, y :: ys => U x y * pathHolonomyFrom U y ys

/-- Final vertex reached from x through a list of subsequent vertices. -/
def finishFrom : V → List V → V
  | x, [] => x
  | _, y :: ys => finishFrom y ys

/-- Concatenating vertex histories multiplies their ordered holonomies. -/
theorem pathHolonomyFrom_append
    (U : EdgeField V) (x : V) (xs ys : List V) :
    pathHolonomyFrom U x (xs ++ ys) =
      pathHolonomyFrom U x xs * pathHolonomyFrom U (finishFrom x xs) ys := by
  sorry

/-- Finishing a concatenated history agrees with sequential finishing. -/
theorem finishFrom_append (x : V) (xs ys : List V) :
    finishFrom x (xs ++ ys) = finishFrom (finishFrom x xs) ys := by
  sorry

/-- Open-history holonomy transforms only at its two endpoints. -/
theorem pathHolonomyFrom_gauge_covariant
    (g : Gauge V) (U : EdgeField V)
    (hg : ∀ v, normSq (g v) = 1)
    (x : V) (xs : List V) :
    pathHolonomyFrom (gaugeTransform g U) x xs =
      g (finishFrom x xs) * pathHolonomyFrom U x xs * star (g x) := by
  sorry

/-- Closed-history holonomy is gauge invariant. -/
theorem closed_pathHolonomy_gauge_invariant
    (g : Gauge V) (U : EdgeField V)
    (hg : ∀ v, normSq (g v) = 1)
    (x : V) (xs : List V) (hclosed : finishFrom x xs = x) :
    pathHolonomyFrom (gaugeTransform g U) x xs =
      pathHolonomyFrom U x xs := by
  sorry

/-- Two closed histories based at the same vertex have multiplicative closure
phase under concatenation. -/
theorem closed_pathHolonomy_append
    (U : EdgeField V) (x : V) (xs ys : List V)
    (hx : finishFrom x xs = x) :
    pathHolonomyFrom U x (xs ++ ys) =
      pathHolonomyFrom U x xs * pathHolonomyFrom U x ys := by
  sorry

/-! ## Exact nontrivial square-loop fixture -/

/-- All square edges are trivial except 3 -> 0, which carries phase I. -/
def squareEdgeField : EdgeField (Fin 4) :=
  fun x y => if x = 3 ∧ y = 0 then I else 1

/-- A nonidentity unit gauge transformation at vertex zero. -/
def squareGauge : Gauge (Fin 4) :=
  fun x => if x = 0 then -1 else 1

/-- The oriented square begins and ends at zero. -/
theorem square_loop_closes :
    finishFrom (0 : Fin 4) [1, 2, 3, 0] = 0 := by
  sorry

/-- The square gauge is unit norm at every vertex and is nonidentity. -/
theorem squareGauge_unit_and_nontrivial :
    (∀ v, normSq (squareGauge v) = 1) ∧ squareGauge ≠ fun _ => 1 := by
  sorry

/-- Exact nontrivial closure phase and its invariance under a nonidentity
gauge transformation. -/
theorem square_nontrivial_gauge_invariant_witness :
    pathHolonomyFrom squareEdgeField (0 : Fin 4) [1, 2, 3, 0] = I
      ∧ I ≠ 1
      ∧ pathHolonomyFrom (gaugeTransform squareGauge squareEdgeField)
          (0 : Fin 4) [1, 2, 3, 0] = I := by
  sorry

/-- Finite closure-phase verdict: composition, endpoint covariance, closed-loop
gauge invariance, and a nontrivial exact loop all coexist. -/
theorem u1_history_closure_holonomy_verdict :
    (∀ (U : EdgeField (Fin 4)) (x : Fin 4) (xs ys : List (Fin 4)),
      pathHolonomyFrom U x (xs ++ ys) =
        pathHolonomyFrom U x xs *
          pathHolonomyFrom U (finishFrom x xs) ys)
      ∧ pathHolonomyFrom squareEdgeField (0 : Fin 4) [1, 2, 3, 0] = I
      ∧ I ≠ 1
      ∧ pathHolonomyFrom (gaugeTransform squareGauge squareEdgeField)
          (0 : Fin 4) [1, 2, 3, 0] = I := by
  sorry

end U1HistoryClosureHolonomy
