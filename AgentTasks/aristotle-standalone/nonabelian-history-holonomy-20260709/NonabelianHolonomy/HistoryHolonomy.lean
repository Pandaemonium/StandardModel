import Mathlib

namespace NonabelianHistoryHolonomy

variable {V G : Type*} [Group G]

abbrev EdgeField (V G : Type*) := V → V → G
abbrev Gauge (V G : Type*) := V → G

/-- Nonabelian endpoint gauge action. -/
def gaugeTransform (g : Gauge V G) (U : EdgeField V G) : EdgeField V G :=
  fun x y => g y * U x y * (g x)⁻¹

/-- Ordered transport, with later edges multiplying on the left. -/
def pathHolonomyFrom (U : EdgeField V G) : V → List V → G
  | _, [] => 1
  | x, y :: ys => pathHolonomyFrom U y ys * U x y

def finishFrom : V → List V → V
  | x, [] => x
  | _, y :: ys => finishFrom y ys

/-- Concatenation composes ordered transports in noncommutative order. -/
theorem pathHolonomyFrom_append
    (U : EdgeField V G) (x : V) (xs ys : List V) :
    pathHolonomyFrom U x (xs ++ ys) =
      pathHolonomyFrom U (finishFrom x xs) ys * pathHolonomyFrom U x xs := by
  sorry

/-- Open nonabelian holonomy transforms only at its endpoints. -/
theorem pathHolonomyFrom_gauge_covariant
    (g : Gauge V G) (U : EdgeField V G) (x : V) (xs : List V) :
    pathHolonomyFrom (gaugeTransform g U) x xs =
      g (finishFrom x xs) * pathHolonomyFrom U x xs * (g x)⁻¹ := by
  sorry

/-- Closed nonabelian holonomy transforms by conjugation, not by equality. -/
theorem closed_pathHolonomy_conjugates
    (g : Gauge V G) (U : EdgeField V G) (x : V) (xs : List V)
    (hclosed : finishFrom x xs = x) :
    pathHolonomyFrom (gaugeTransform g U) x xs =
      g x * pathHolonomyFrom U x xs * (g x)⁻¹ := by
  sorry

/-- Conjugacy-invariant observables of closed holonomy are gauge invariant. -/
theorem closed_classFunction_gauge_invariant
    {A : Type*} (f : G → A)
    (hf : ∀ g h : G, f (g * h * g⁻¹) = f h)
    (g : Gauge V G) (U : EdgeField V G) (x : V) (xs : List V)
    (hclosed : finishFrom x xs = x) :
    f (pathHolonomyFrom (gaugeTransform g U) x xs) =
      f (pathHolonomyFrom U x xs) := by
  sorry

/-! ## Exact nonabelian permutation witness -/

abbrev S3 := Equiv.Perm (Fin 3)

def swap01 : S3 := Equiv.swap 0 1
def swap12 : S3 := Equiv.swap 1 2
def cycleGauge : S3 := swap01 * swap12

def triangleEdge : EdgeField (Fin 3) S3 :=
  fun x y => if x = 2 ∧ y = 0 then swap01 else 1

def triangleGauge : Gauge (Fin 3) S3 :=
  fun x => if x = 0 then cycleGauge else 1

theorem triangle_closes : finishFrom (0 : Fin 3) [1, 2, 0] = 0 := rfl

/-- The loop has nonidentity holonomy in the nonabelian group `S3`. -/
theorem triangle_nontrivial :
    pathHolonomyFrom triangleEdge (0 : Fin 3) [1, 2, 0] = swap01
      ∧ swap01 ≠ 1 := by
  sorry

/-- A nonidentity gauge conjugates the loop holonomy nontrivially while
preserving its conjugacy class. -/
theorem triangle_gauge_conjugacy_witness :
    triangleGauge ≠ (fun _ => 1)
      ∧ pathHolonomyFrom (gaugeTransform triangleGauge triangleEdge)
          (0 : Fin 3) [1, 2, 0] =
        cycleGauge * swap01 * cycleGauge⁻¹
      ∧ cycleGauge * swap01 * cycleGauge⁻¹ ≠ swap01 := by
  sorry

/-! ## Matrix trace as the Wilson-loop observable -/

open Matrix

/-- Trace is invariant under an explicitly invertible matrix conjugation. -/
theorem trace_conjugation_invariant
    {n R : Type*} [Fintype n] [DecidableEq n] [CommRing R]
    (g gInv H : Matrix n n R)
    (hLeft : gInv * g = 1) :
    (g * H * gInv).trace = H.trace := by
  sorry

/-- Compact verdict: generic endpoint covariance, closed-loop conjugacy,
gauge-invariant class observables, and a nontrivial exact nonabelian loop. -/
theorem nonabelian_history_holonomy_verdict :
    (∀ (g : Gauge (Fin 3) S3) (U : EdgeField (Fin 3) S3)
        (x : Fin 3) (xs : List (Fin 3)),
      pathHolonomyFrom (gaugeTransform g U) x xs =
        g (finishFrom x xs) * pathHolonomyFrom U x xs * (g x)⁻¹)
      ∧ pathHolonomyFrom triangleEdge (0 : Fin 3) [1, 2, 0] ≠ 1
      ∧ triangleGauge ≠ (fun _ => 1)
      ∧ pathHolonomyFrom (gaugeTransform triangleGauge triangleEdge)
          (0 : Fin 3) [1, 2, 0] ≠
        pathHolonomyFrom triangleEdge (0 : Fin 3) [1, 2, 0] := by
  sorry

end NonabelianHistoryHolonomy
