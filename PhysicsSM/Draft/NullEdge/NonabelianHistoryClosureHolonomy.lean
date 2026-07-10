import Mathlib

/-!
# Nonabelian closure holonomy on finite histories

`PhysicsSM.Draft.NullEdge.U1HistoryClosureHolonomy` established the closure
channel for abelian `U(1)` edge phases: open histories transform only at their
endpoints, and closed histories are exactly gauge invariant.  This module
upgrades the same finite history framework to an arbitrary (generally
nonabelian) transport group:

* open-history transport is gauge covariant at its endpoints only
  (`transportFrom_gauge_covariant`);
* a closed history based at `x` is conjugated by the basepoint gauge `g x`
  (`closed_transport_gauge_conj`), so the raw holonomy is *not* gauge
  invariant in the nonabelian case;
* for commutative transport the conjugation collapses and the abelian
  closed-history gauge invariance is recovered
  (`closed_transport_gauge_invariant_of_comm`);
* conjugacy-class data survives: for matrix transport, the trace of a closed
  history is exactly gauge invariant
  (`closed_transport_trace_gauge_invariant`);
* an exact rational `2 x 2` witness realizes all of this with noncommuting
  shear transports: the square-loop holonomy differs from the identity, a
  nonidentity diagonal gauge change moves the holonomy itself, and the trace
  is unchanged (`nonabelian_history_closure_holonomy_verdict`).

## Conventions

Transport along a history is taken in composition order: for a vertex history
`x, y_1, ..., y_n` the transport is `U(y_{n-1}, y_n) * ... * U(x, y_1)`, the
last edge acting leftmost.  This matches the closure-loop convention
`H = U_30 * U_23 * U_12 * U_01` used in the null-edge manuscripts.  The
abelian `U(1)` module multiplies in the opposite order; for commutative
transport the two orders agree, so no convention drift is introduced.  The
endpoint gauge action is `U'(x, y) = g y * U(x, y) * (g x)⁻¹`, which
specializes to the `U(1)` action there (where `(g x)⁻¹ = star (g x)` on unit
phases).

## Boundaries

This is a finite group-theoretic statement about ordered products over a
labeled vertex list.  It supplies no continuum connection, no Wilson action or
lattice measure, no Yang-Mills dynamics, and no link yet from this history
holonomy to the carrier's closure block; that link remains a separate open
step of the program.  Clean-room formalization of standard finite Wilson-line
endpoint covariance; no external code consulted.
-/

namespace PhysicsSM.Draft.NullEdge.NonabelianHistoryClosureHolonomy

variable {V G : Type*}

/-- A group-valued edge transport between finite-history vertices. -/
abbrev EdgeField (V G : Type*) := V → V → G

/-- A vertex gauge transformation. -/
abbrev Gauge (V G : Type*) := V → G

/-- Endpoint gauge action `U'(x, y) = g y * U(x, y) * (g x)⁻¹`. -/
def gaugeTransform [Group G] (g : Gauge V G) (U : EdgeField V G) : EdgeField V G :=
  fun x y => g y * U x y * (g x)⁻¹

/-- Final vertex reached from a start vertex through a history. -/
def finishFrom : V → List V → V
  | x, [] => x
  | _, y :: ys => finishFrom y ys

/-- Ordered transport from a start vertex through subsequent vertices, in
composition order: the last edge acts leftmost, `U(y_{n-1}, y_n) * ... *
U(x, y_1)`. -/
def transportFrom [Monoid G] (U : EdgeField V G) : V → List V → G
  | _, [] => 1
  | x, y :: ys => transportFrom U y ys * U x y

/-- Finishing a concatenated history agrees with sequential finishing. -/
theorem finishFrom_append (x : V) (xs ys : List V) :
    finishFrom x (xs ++ ys) = finishFrom (finishFrom x xs) ys := by
  induction xs generalizing x with
  | nil => rfl
  | cons a as ih => simp [finishFrom, ih]

/-- Concatenating histories composes their transports in composition order:
the later history acts on the left. -/
theorem transportFrom_append [Monoid G] (U : EdgeField V G)
    (x : V) (xs ys : List V) :
    transportFrom U x (xs ++ ys) =
      transportFrom U (finishFrom x xs) ys * transportFrom U x xs := by
  induction xs generalizing x with
  | nil => simp [transportFrom, finishFrom]
  | cons a as ih => simp [transportFrom, finishFrom, ih, mul_assoc]

/-- Open-history transport transforms only at its endpoints: the gauged
transport is the bare transport dressed by the finish gauge on the left and
the inverse start gauge on the right.  No unitarity or norm hypothesis is
needed; the statement holds for every group-valued gauge. -/
theorem transportFrom_gauge_covariant [Group G] (g : Gauge V G)
    (U : EdgeField V G) (x : V) (xs : List V) :
    transportFrom (gaugeTransform g U) x xs =
      g (finishFrom x xs) * transportFrom U x xs * (g x)⁻¹ := by
  induction xs generalizing x with
  | nil => simp [transportFrom, finishFrom]
  | cons a as ih =>
      simp only [transportFrom, finishFrom, gaugeTransform, ih]
      group

/-- A closed history is conjugated by its basepoint gauge.  In the nonabelian
case the raw closure holonomy is therefore gauge covariant, not gauge
invariant; only conjugation-stable data of it can be observable. -/
theorem closed_transport_gauge_conj [Group G] (g : Gauge V G)
    (U : EdgeField V G) (x : V) (xs : List V)
    (hclosed : finishFrom x xs = x) :
    transportFrom (gaugeTransform g U) x xs =
      g x * transportFrom U x xs * (g x)⁻¹ := by
  rw [transportFrom_gauge_covariant, hclosed]

/-- For commutative transport the basepoint conjugation collapses, recovering
the abelian closed-history gauge invariance proved for `U(1)` phases. -/
theorem closed_transport_gauge_invariant_of_comm [CommGroup G] (g : Gauge V G)
    (U : EdgeField V G) (x : V) (xs : List V)
    (hclosed : finishFrom x xs = x) :
    transportFrom (gaugeTransform g U) x xs = transportFrom U x xs := by
  rw [closed_transport_gauge_conj g U x xs hclosed,
    mul_comm (g x) (transportFrom U x xs), mul_assoc, mul_inv_cancel, mul_one]

/-- The matrix trace of a closed-history holonomy is exactly gauge invariant:
conjugacy-class data survives the nonabelian gauge ambiguity. -/
theorem closed_transport_trace_gauge_invariant
    {n R : Type*} [Fintype n] [DecidableEq n] [CommRing R]
    (g : Gauge V (Matrix n n R)ˣ) (U : EdgeField V (Matrix n n R)ˣ)
    (x : V) (xs : List V) (hclosed : finishFrom x xs = x) :
    Matrix.trace
        (↑(transportFrom (gaugeTransform g U) x xs) : Matrix n n R) =
      Matrix.trace (↑(transportFrom U x xs) : Matrix n n R) := by
  rw [closed_transport_gauge_conj g U x xs hclosed]
  simp only [Units.val_mul]
  rw [Matrix.trace_mul_comm, ← mul_assoc, Units.inv_mul, one_mul]

/-! ## Exact noncommuting rational square-loop fixture -/

/-- Upper shear transport `[[1, 1], [0, 1]]` as a unit of the rational
`2 x 2` matrix ring. -/
def shearUp : (Matrix (Fin 2) (Fin 2) ℚ)ˣ where
  val := !![1, 1; 0, 1]
  inv := !![1, -1; 0, 1]
  val_inv := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply]
  inv_val := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply]

/-- Lower shear transport `[[1, 0], [1, 1]]` as a unit of the rational
`2 x 2` matrix ring. -/
def shearDown : (Matrix (Fin 2) (Fin 2) ℚ)ˣ where
  val := !![1, 0; 1, 1]
  inv := !![1, 0; -1, 1]
  val_inv := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply]
  inv_val := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply]

/-- Nonidentity diagonal gauge factor `[[2, 0], [0, 1]]`, invertible over the
rationals. -/
def diagGauge : (Matrix (Fin 2) (Fin 2) ℚ)ˣ where
  val := !![2, 0; 0, 1]
  inv := !![1/2, 0; 0, 1]
  val_inv := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply]
  inv_val := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply]

/-- Square edge transports: `0 -> 1` shears up, `1 -> 2` shears down, all
other edges are trivial.  The two nontrivial transports do not commute. -/
def squareEdgeField : EdgeField (Fin 4) (Matrix (Fin 2) (Fin 2) ℚ)ˣ :=
  fun x y =>
    if x = 0 ∧ y = 1 then shearUp
    else if x = 1 ∧ y = 2 then shearDown
    else 1

/-- A nonidentity gauge change concentrated at the loop basepoint. -/
def squareGauge : Gauge (Fin 4) (Matrix (Fin 2) (Fin 2) ℚ)ˣ :=
  fun v => if v = 0 then diagGauge else 1

/-- The oriented square begins and ends at zero. -/
theorem square_loop_closes :
    finishFrom (0 : Fin 4) [1, 2, 3, 0] = 0 := rfl

/-- The two shear transports genuinely fail to commute, so the fixture is
honestly nonabelian rather than a relabeled phase example. -/
theorem shear_noncomm : shearUp * shearDown ≠ shearDown * shearUp := by
  intro h
  have hval := congrArg Units.val h
  simp only [Units.val_mul] at hval
  have hentry := congrFun (congrFun hval 0) 0
  norm_num [shearUp, shearDown, Matrix.mul_apply, Fin.sum_univ_two] at hentry

/-- The bare square-loop holonomy is the ordered product of the two shears. -/
theorem square_holonomy_eq :
    transportFrom squareEdgeField (0 : Fin 4) [1, 2, 3, 0] =
      shearDown * shearUp := by
  simp [transportFrom, squareEdgeField]

/-- Exact value of the bare square-loop holonomy. -/
theorem square_holonomy_val :
    (↑(transportFrom squareEdgeField (0 : Fin 4) [1, 2, 3, 0]) :
        Matrix (Fin 2) (Fin 2) ℚ) = !![1, 1; 1, 2] := by
  rw [square_holonomy_eq, Units.val_mul]
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [shearUp, shearDown, Matrix.mul_apply, Fin.sum_univ_two]

/-- The bare holonomy is not the identity: the loop stores nontrivial
closure data. -/
theorem square_holonomy_ne_one :
    transportFrom squareEdgeField (0 : Fin 4) [1, 2, 3, 0] ≠ 1 := by
  intro h
  have hval := congrArg Units.val h
  rw [square_holonomy_val, Units.val_one] at hval
  have hentry := congrFun (congrFun hval 0) 1
  norm_num [Matrix.one_apply] at hentry

/-- Exact value of the gauged square-loop holonomy: the basepoint conjugate
of the bare holonomy. -/
theorem square_gauged_holonomy_val :
    (↑(transportFrom (gaugeTransform squareGauge squareEdgeField)
          (0 : Fin 4) [1, 2, 3, 0]) :
        Matrix (Fin 2) (Fin 2) ℚ) = !![1, 2; 1/2, 2] := by
  rw [closed_transport_gauge_conj squareGauge squareEdgeField 0 _
    square_loop_closes]
  simp only [Units.val_mul]
  rw [square_holonomy_val]
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [squareGauge, diagGauge, Units.inv_mk,
      Matrix.mul_apply, Fin.sum_univ_two]

/-- The nonidentity gauge change moves the raw holonomy: unlike the abelian
case, the closed-loop transport itself is not gauge invariant. -/
theorem square_gauge_moves_holonomy :
    transportFrom (gaugeTransform squareGauge squareEdgeField)
        (0 : Fin 4) [1, 2, 3, 0] ≠
      transportFrom squareEdgeField (0 : Fin 4) [1, 2, 3, 0] := by
  intro h
  have hval := congrArg Units.val h
  rw [square_gauged_holonomy_val, square_holonomy_val] at hval
  have hentry := congrFun (congrFun hval 0) 1
  norm_num at hentry

/-- The trace of the square-loop holonomy is `3` before and after the gauge
change: the conjugacy-class observable survives exactly. -/
theorem square_trace_gauge_invariant :
    Matrix.trace
        (↑(transportFrom (gaugeTransform squareGauge squareEdgeField)
              (0 : Fin 4) [1, 2, 3, 0]) : Matrix (Fin 2) (Fin 2) ℚ) = 3
      ∧ Matrix.trace
          (↑(transportFrom squareEdgeField (0 : Fin 4) [1, 2, 3, 0]) :
            Matrix (Fin 2) (Fin 2) ℚ) = 3 := by
  constructor
  · rw [square_gauged_holonomy_val]
    norm_num [Matrix.trace_fin_two_of]
  · rw [square_holonomy_val]
    norm_num [Matrix.trace_fin_two_of]

/-- Nonabelian closure verdict: endpoint covariance, basepoint conjugation on
closed histories, gauge-invariant trace, and an exact noncommuting rational
witness whose holonomy moves under a gauge change while its trace does not. -/
theorem nonabelian_history_closure_holonomy_verdict :
    (∀ (g : Gauge (Fin 4) (Matrix (Fin 2) (Fin 2) ℚ)ˣ)
        (U : EdgeField (Fin 4) (Matrix (Fin 2) (Fin 2) ℚ)ˣ)
        (x : Fin 4) (xs : List (Fin 4)),
      transportFrom (gaugeTransform g U) x xs =
        g (finishFrom x xs) * transportFrom U x xs * (g x)⁻¹)
      ∧ (∀ (g : Gauge (Fin 4) (Matrix (Fin 2) (Fin 2) ℚ)ˣ)
            (U : EdgeField (Fin 4) (Matrix (Fin 2) (Fin 2) ℚ)ˣ)
            (x : Fin 4) (xs : List (Fin 4)), finishFrom x xs = x →
          Matrix.trace
              (↑(transportFrom (gaugeTransform g U) x xs) :
                Matrix (Fin 2) (Fin 2) ℚ) =
            Matrix.trace (↑(transportFrom U x xs) : Matrix (Fin 2) (Fin 2) ℚ))
      ∧ shearUp * shearDown ≠ shearDown * shearUp
      ∧ transportFrom squareEdgeField (0 : Fin 4) [1, 2, 3, 0] ≠ 1
      ∧ transportFrom (gaugeTransform squareGauge squareEdgeField)
            (0 : Fin 4) [1, 2, 3, 0] ≠
          transportFrom squareEdgeField (0 : Fin 4) [1, 2, 3, 0]
      ∧ Matrix.trace
            (↑(transportFrom (gaugeTransform squareGauge squareEdgeField)
                  (0 : Fin 4) [1, 2, 3, 0]) : Matrix (Fin 2) (Fin 2) ℚ) =
          Matrix.trace
            (↑(transportFrom squareEdgeField (0 : Fin 4) [1, 2, 3, 0]) :
              Matrix (Fin 2) (Fin 2) ℚ) := by
  refine ⟨?_, ?_, shear_noncomm, square_holonomy_ne_one,
    square_gauge_moves_holonomy, ?_⟩
  · exact fun g U x xs => transportFrom_gauge_covariant g U x xs
  · exact fun g U x xs h =>
      closed_transport_trace_gauge_invariant g U x xs h
  · rw [square_trace_gauge_invariant.1, square_trace_gauge_invariant.2]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonabelianHistoryClosureHolonomy.transportFrom_gauge_covariant' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NonabelianHistoryClosureHolonomy.transportFrom_gauge_covariant

/-- info: 'PhysicsSM.Draft.NullEdge.NonabelianHistoryClosureHolonomy.closed_transport_trace_gauge_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NonabelianHistoryClosureHolonomy.closed_transport_trace_gauge_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.NonabelianHistoryClosureHolonomy.nonabelian_history_closure_holonomy_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NonabelianHistoryClosureHolonomy.nonabelian_history_closure_holonomy_verdict

end PhysicsSM.Draft.NullEdge.NonabelianHistoryClosureHolonomy
