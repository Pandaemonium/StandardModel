import Mathlib

/-!
# Gauge-invariant closure phase on finite histories

The turn phase is already local and exact.  This module supplies the next
history channel: multiplicative `U(1)` transport, endpoint gauge covariance on
open histories, and gauge invariance on closed histories.  An exact four-vertex
loop carries nontrivial holonomy `I`, so the result is not satisfied by the
identity phase alone.

This is a finite closure-phase theorem, not a nonabelian Wilson action, a
continuum gauge field, a path-integral measure, or a Yang-Mills limit.  The
theorem shapes follow finite quiver-holonomy and Wilson-loop constructions;
no external code is imported.

Recovered from Aristotle project `91343f7e-d1da-4e79-8227-ecbce9952bae`.
-/

open Complex

namespace PhysicsSM.Draft.NullEdge.U1HistoryClosureHolonomy

variable {V : Type*}

/-- A complex edge transport between finite-history vertices. -/
abbrev EdgeField (V : Type*) := V → V → ℂ

/-- A vertex gauge transformation. -/
abbrev Gauge (V : Type*) := V → ℂ

/-- Endpoint gauge action `U'(x,y) = g(y) U(x,y) star(g(x))`. -/
def gaugeTransform (g : Gauge V) (U : EdgeField V) : EdgeField V :=
  fun x y => g y * U x y * star (g x)

/-- Ordered transport from a start vertex through subsequent vertices. -/
def pathHolonomyFrom (U : EdgeField V) : V → List V → ℂ
  | _, [] => 1
  | x, y :: ys => U x y * pathHolonomyFrom U y ys

/-- Final vertex reached from a start vertex through a history. -/
def finishFrom : V → List V → V
  | x, [] => x
  | _, y :: ys => finishFrom y ys

/-- Concatenating histories multiplies their ordered holonomies. -/
theorem pathHolonomyFrom_append
    (U : EdgeField V) (x : V) (xs ys : List V) :
    pathHolonomyFrom U x (xs ++ ys) =
      pathHolonomyFrom U x xs * pathHolonomyFrom U (finishFrom x xs) ys := by
  induction xs generalizing x with
  | nil => simp [pathHolonomyFrom, finishFrom]
  | cons a as ih => simp [pathHolonomyFrom, finishFrom, ih, mul_assoc]

/-- Finishing a concatenated history agrees with sequential finishing. -/
theorem finishFrom_append (x : V) (xs ys : List V) :
    finishFrom x (xs ++ ys) = finishFrom (finishFrom x xs) ys := by
  induction xs generalizing x with
  | nil => rfl
  | cons a as ih => simp [finishFrom, ih]

/-- Open-history holonomy transforms only at its endpoints. -/
theorem pathHolonomyFrom_gauge_covariant
    (g : Gauge V) (U : EdgeField V)
    (hg : ∀ v, normSq (g v) = 1)
    (x : V) (xs : List V) :
    pathHolonomyFrom (gaugeTransform g U) x xs =
      g (finishFrom x xs) * pathHolonomyFrom U x xs * star (g x) := by
  induction xs generalizing x with
  | nil =>
      simp only [pathHolonomyFrom, finishFrom, mul_one]
      have h : g x * star (g x) = ((normSq (g x) : ℝ) : ℂ) :=
        Complex.mul_conj (g x)
      rw [h, hg x]
      norm_num
  | cons a as ih =>
      simp only [pathHolonomyFrom, finishFrom, gaugeTransform]
      rw [ih a]
      have hstar : g a * star (g a) = 1 := by
        have h : g a * star (g a) = ((normSq (g a) : ℝ) : ℂ) :=
          Complex.mul_conj (g a)
        rw [h, hg a]
        norm_num
      calc
        g a * U x a * star (g x) *
              (g (finishFrom a as) * pathHolonomyFrom U a as * star (g a)) =
            g (finishFrom a as) * (U x a * pathHolonomyFrom U a as) *
              star (g x) * (g a * star (g a)) := by ring
        _ = g (finishFrom a as) * (U x a * pathHolonomyFrom U a as) *
              star (g x) := by rw [hstar]; ring

/-- Closed-history holonomy is gauge invariant. -/
theorem closed_pathHolonomy_gauge_invariant
    (g : Gauge V) (U : EdgeField V)
    (hg : ∀ v, normSq (g v) = 1)
    (x : V) (xs : List V) (hclosed : finishFrom x xs = x) :
    pathHolonomyFrom (gaugeTransform g U) x xs =
      pathHolonomyFrom U x xs := by
  rw [pathHolonomyFrom_gauge_covariant g U hg x xs, hclosed]
  have hstar : g x * star (g x) = 1 := by
    have h : g x * star (g x) = ((normSq (g x) : ℝ) : ℂ) :=
      Complex.mul_conj (g x)
    rw [h, hg x]
    norm_num
  calc
    g x * pathHolonomyFrom U x xs * star (g x) =
        pathHolonomyFrom U x xs * (g x * star (g x)) := by ring
    _ = pathHolonomyFrom U x xs := by rw [hstar]; ring

/-- Two closed histories based at the same vertex have multiplicative closure
phase under concatenation. -/
theorem closed_pathHolonomy_append
    (U : EdgeField V) (x : V) (xs ys : List V)
    (hx : finishFrom x xs = x) :
    pathHolonomyFrom U x (xs ++ ys) =
      pathHolonomyFrom U x xs * pathHolonomyFrom U x ys := by
  rw [pathHolonomyFrom_append, hx]

/-! ## Exact nontrivial square-loop fixture -/

/-- All square edges are trivial except `3 -> 0`, which carries phase `I`. -/
def squareEdgeField : EdgeField (Fin 4) :=
  fun x y => if x = 3 ∧ y = 0 then I else 1

/-- A nonidentity unit gauge transformation at vertex zero. -/
def squareGauge : Gauge (Fin 4) :=
  fun x => if x = 0 then -1 else 1

/-- The oriented square begins and ends at zero. -/
theorem square_loop_closes :
    finishFrom (0 : Fin 4) [1, 2, 3, 0] = 0 := rfl

/-- The square gauge is unit norm at every vertex and is nonidentity. -/
theorem squareGauge_unit_and_nontrivial :
    (∀ v, normSq (squareGauge v) = 1) ∧ squareGauge ≠ fun _ => 1 := by
  constructor
  · intro v
    fin_cases v <;> simp [squareGauge, Complex.normSq]
  · intro h
    have h0 := congrFun h 0
    norm_num [squareGauge] at h0

/-- Exact nontrivial closure phase and its invariance under a nonidentity gauge
transformation. -/
theorem square_nontrivial_gauge_invariant_witness :
    pathHolonomyFrom squareEdgeField (0 : Fin 4) [1, 2, 3, 0] = I
      ∧ I ≠ 1
      ∧ pathHolonomyFrom (gaugeTransform squareGauge squareEdgeField)
          (0 : Fin 4) [1, 2, 3, 0] = I := by
  refine ⟨?_, ?_, ?_⟩
  · simp [pathHolonomyFrom, squareEdgeField]
  · intro h
    simpa using congrArg Complex.im h
  · simp [pathHolonomyFrom, gaugeTransform, squareEdgeField, squareGauge]

/-- Finite closure-phase verdict: composition, endpoint covariance,
closed-loop gauge invariance, and a nontrivial exact loop coexist. -/
theorem u1_history_closure_holonomy_verdict :
    (∀ (U : EdgeField (Fin 4)) (x : Fin 4) (xs ys : List (Fin 4)),
      pathHolonomyFrom U x (xs ++ ys) =
        pathHolonomyFrom U x xs * pathHolonomyFrom U (finishFrom x xs) ys)
      ∧ (∀ (g : Gauge (Fin 4)) (U : EdgeField (Fin 4)),
          (∀ v, normSq (g v) = 1) → ∀ (x : Fin 4) (xs : List (Fin 4)),
            pathHolonomyFrom (gaugeTransform g U) x xs =
              g (finishFrom x xs) * pathHolonomyFrom U x xs * star (g x))
      ∧ (∀ (g : Gauge (Fin 4)) (U : EdgeField (Fin 4)),
          (∀ v, normSq (g v) = 1) → ∀ (x : Fin 4) (xs : List (Fin 4)),
            finishFrom x xs = x →
            pathHolonomyFrom (gaugeTransform g U) x xs =
              pathHolonomyFrom U x xs)
      ∧ pathHolonomyFrom squareEdgeField (0 : Fin 4) [1, 2, 3, 0] = I
      ∧ I ≠ 1
      ∧ pathHolonomyFrom (gaugeTransform squareGauge squareEdgeField)
          (0 : Fin 4) [1, 2, 3, 0] = I := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact fun U x xs ys => pathHolonomyFrom_append U x xs ys
  · exact fun g U hg x xs => pathHolonomyFrom_gauge_covariant g U hg x xs
  · exact fun g U hg x xs h =>
      closed_pathHolonomy_gauge_invariant g U hg x xs h
  · exact square_nontrivial_gauge_invariant_witness.1
  · intro h
    simpa using congrArg Complex.im h
  · exact square_nontrivial_gauge_invariant_witness.2.2

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.U1HistoryClosureHolonomy.pathHolonomyFrom_gauge_covariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.U1HistoryClosureHolonomy.pathHolonomyFrom_gauge_covariant

/-- info: 'PhysicsSM.Draft.NullEdge.U1HistoryClosureHolonomy.square_nontrivial_gauge_invariant_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.U1HistoryClosureHolonomy.square_nontrivial_gauge_invariant_witness

/-- info: 'PhysicsSM.Draft.NullEdge.U1HistoryClosureHolonomy.u1_history_closure_holonomy_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.U1HistoryClosureHolonomy.u1_history_closure_holonomy_verdict

end PhysicsSM.Draft.NullEdge.U1HistoryClosureHolonomy
