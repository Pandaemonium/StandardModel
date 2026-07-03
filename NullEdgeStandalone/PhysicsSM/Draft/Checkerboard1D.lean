import Mathlib

/-!
# 1+1D checkerboard seed

This module starts the dynamical lane recommended by Aristotle's 2026-07-01
evaluation of `NullEdgeStandalone`.

The model is the finite two-direction skeleton of the Feynman checkerboard:

* `rightState` and `leftState` are the two null directions in 1+1 dimensions.
* `nullTransport r l` preserves the current null direction with amplitudes
  `r` and `l`.
* `massFlip mu` reverses the null direction with amplitude `mu`.
* `checkerStep r l mu = nullTransport r l + massFlip mu`.

The proved content is intentionally modest but load-bearing: in this finite
transfer model, the mass parameter is exactly the off-diagonal reversal
amplitude. When `mu = 0`, the two null directions decouple. When `mu` is present,
the flip term anticommutes with the direction grading, while the massless
transport commutes with it.

This is not a continuum-limit theorem and not yet the Feynman path-sum
convergence theorem. It is the kernel-checked algebraic seed for that Aristotle
handoff.
-/

noncomputable section

namespace PhysicsSM.Draft.Checkerboard1D

open Matrix

/-- The two null directions in 1+1 dimensions. Convention: `0` is right-moving,
`1` is left-moving. -/
abbrev Direction := Fin 2

/-- Right-moving basis state. -/
def rightState : Direction -> Complex := ![1, 0]

/-- Left-moving basis state. -/
def leftState : Direction -> Complex := ![0, 1]

/-- Direction grading: `+1` on right-moving states and `-1` on left-moving
states. -/
def directionGrade : Matrix Direction Direction Complex := !![1, 0; 0, -1]

/-- Direction reversal operator. This is the finite checkerboard mass channel. -/
def reversal : Matrix Direction Direction Complex := !![0, 1; 1, 0]

/-- Direction-preserving null transport. -/
def nullTransport (r l : Complex) : Matrix Direction Direction Complex :=
  !![r, 0; 0, l]

/-- Mass/reversal term with amplitude `mu`. -/
def massFlip (mu : Complex) : Matrix Direction Direction Complex :=
  fun i j => mu * reversal i j

/-- One checkerboard transfer step: preserve the current null direction, or
reverse it through the mass channel. -/
def checkerStep (r l mu : Complex) : Matrix Direction Direction Complex :=
  nullTransport r l + massFlip mu

/-- Entry form of one checkerboard step. -/
theorem checkerStep_eq (r l mu : Complex) :
    checkerStep r l mu = !![r, mu; mu, l] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [checkerStep, nullTransport, massFlip, reversal]

/-- A massless checkerboard step is purely direction-preserving. -/
theorem checkerStep_zero_mass (r l : Complex) :
    checkerStep r l 0 = nullTransport r l := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [checkerStep, nullTransport, massFlip, reversal]

/-- The right-to-left entry of the step is exactly the mass/reversal amplitude. -/
@[simp] theorem checkerStep_right_to_left (r l mu : Complex) :
    checkerStep r l mu 1 0 = mu := by
  simp [checkerStep_eq]

/-- The left-to-right entry of the step is exactly the mass/reversal amplitude. -/
@[simp] theorem checkerStep_left_to_right (r l mu : Complex) :
    checkerStep r l mu 0 1 = mu := by
  simp [checkerStep_eq]

/-- With zero mass, the right-moving basis state remains right-moving. -/
theorem massless_step_right (r l : Complex) :
    (checkerStep r l 0).mulVec rightState = fun i => r * rightState i := by
  ext i
  fin_cases i <;>
    simp [checkerStep_zero_mass, nullTransport, rightState, Matrix.mulVec, dotProduct,
      Fin.sum_univ_two]

/-- With zero mass, the left-moving basis state remains left-moving. -/
theorem massless_step_left (r l : Complex) :
    (checkerStep r l 0).mulVec leftState = fun i => l * leftState i := by
  ext i
  fin_cases i <;>
    simp [checkerStep_zero_mass, nullTransport, leftState, Matrix.mulVec, dotProduct,
      Fin.sum_univ_two]

/-- The mass channel sends a right-moving state to a left-moving state. -/
theorem massFlip_right (mu : Complex) :
    (massFlip mu).mulVec rightState = fun i => mu * leftState i := by
  ext i
  fin_cases i <;>
    simp [massFlip, reversal, rightState, leftState, Matrix.mulVec, dotProduct,
      Fin.sum_univ_two]

/-- The mass channel sends a left-moving state to a right-moving state. -/
theorem massFlip_left (mu : Complex) :
    (massFlip mu).mulVec leftState = fun i => mu * rightState i := by
  ext i
  fin_cases i <;>
    simp [massFlip, reversal, rightState, leftState, Matrix.mulVec, dotProduct,
      Fin.sum_univ_two]

/-- Massless transport commutes with the direction grading. -/
theorem nullTransport_commutes_directionGrade (r l : Complex) :
    directionGrade * nullTransport r l = nullTransport r l * directionGrade := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [directionGrade, nullTransport, Matrix.mul_apply, Fin.sum_univ_two]

/-- The mass/reversal term anticommutes with the direction grading. -/
theorem massFlip_anticommutes_directionGrade (mu : Complex) :
    directionGrade * massFlip mu + massFlip mu * directionGrade = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [directionGrade, massFlip, reversal, Matrix.mul_apply, Matrix.vecMul, dotProduct,
      Fin.sum_univ_two]

/-- Two-step checkerboard expansion. The off-diagonal entries are exactly the
two one-turn paths: preserve then reverse, or reverse then preserve. -/
theorem checkerStep_sq (r l mu : Complex) :
    checkerStep r l mu * checkerStep r l mu =
      !![r * r + mu * mu, r * mu + mu * l;
         mu * r + l * mu, mu * mu + l * l] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [checkerStep_eq, Matrix.mul_apply, Fin.sum_univ_two]

/-- In the massless case, even two steps have no direction reversal amplitude. -/
theorem checkerStep_sq_zero_mass (r l : Complex) :
    checkerStep r l 0 * checkerStep r l 0 = !![r * r, 0; 0, l * l] := by
  rw [checkerStep_sq]
  ext i j
  fin_cases i <;> fin_cases j <;> simp

/-! ## Two-component recurrence -/

/-- Applying one checkerboard step to a two-component state gives the finite
right/left recurrence. -/
theorem checkerStep_mulVec (r l mu : Complex) (psi : Direction -> Complex) :
    (checkerStep r l mu).mulVec psi =
      ![r * psi 0 + mu * psi 1, mu * psi 0 + l * psi 1] := by
  ext i
  fin_cases i <;>
    simp [checkerStep_eq, Matrix.mulVec, dotProduct, Fin.sum_univ_two]

/-- Right-moving component of the finite checkerboard recurrence. -/
theorem checkerboard_recurrence_right (r l mu : Complex)
    (psi : Direction -> Complex) :
    (checkerStep r l mu).mulVec psi 0 = r * psi 0 + mu * psi 1 := by
  rw [checkerStep_mulVec]
  simp

/-- Left-moving component of the finite checkerboard recurrence. -/
theorem checkerboard_recurrence_left (r l mu : Complex)
    (psi : Direction -> Complex) :
    (checkerStep r l mu).mulVec psi 1 = mu * psi 0 + l * psi 1 := by
  rw [checkerStep_mulVec]
  simp

/-- Bundled two-component finite checkerboard recurrence. -/
theorem checkerboard_recurrence (r l mu : Complex) (psi : Direction -> Complex) :
    And ((checkerStep r l mu).mulVec psi 0 = r * psi 0 + mu * psi 1)
      ((checkerStep r l mu).mulVec psi 1 = mu * psi 0 + l * psi 1) := by
  exact And.intro (checkerboard_recurrence_right r l mu psi)
    (checkerboard_recurrence_left r l mu psi)

/-! ## Finite path amplitudes -/

/-- Amplitude for one directed edge in a checkerboard path. The first direction
is the incoming direction and the second is the outgoing direction. A change of
direction contributes exactly `mu`. -/
def edgeAmp (r l mu : Complex) (incoming outgoing : Direction) : Complex :=
  if incoming = outgoing then
    if incoming = 0 then r else l
  else
    mu

/-- The matrix entry of `checkerStep` is the corresponding one-edge path
amplitude. Rows are outgoing directions and columns are incoming directions. -/
theorem edgeAmp_eq_checkerStep_entry (r l mu : Complex) (incoming outgoing : Direction) :
    edgeAmp r l mu incoming outgoing = checkerStep r l mu outgoing incoming := by
  fin_cases incoming <;> fin_cases outgoing <;> simp [edgeAmp, checkerStep_eq]

/-- Product amplitude of a finite checkerboard path, recorded as its successive
directions. A path with zero or one recorded direction has empty product `1`. -/
def pathAmp (r l mu : Complex) : List Direction -> Complex
  | [] => 1
  | [_] => 1
  | incoming :: outgoing :: rest =>
      edgeAmp r l mu incoming outgoing * pathAmp r l mu (outgoing :: rest)

/-- A path contains at least one turn. -/
def HasTurn : List Direction -> Prop
  | [] => False
  | [_] => False
  | incoming :: outgoing :: rest =>
      Or (Ne incoming outgoing) (HasTurn (outgoing :: rest))

/-- At zero mass, a single turn has zero amplitude. -/
theorem edgeAmp_zero_mass_of_turn (r l : Complex) {incoming outgoing : Direction}
    (hturn : Ne incoming outgoing) :
    edgeAmp r l 0 incoming outgoing = 0 := by
  simp [edgeAmp, hturn]

/-- Straight right-moving edge amplitude. -/
@[simp] theorem edgeAmp_right_right (r l mu : Complex) :
    edgeAmp r l mu 0 0 = r := by
  simp [edgeAmp]

/-- Straight left-moving edge amplitude. -/
@[simp] theorem edgeAmp_left_left (r l mu : Complex) :
    edgeAmp r l mu 1 1 = l := by
  simp [edgeAmp]

/-- Every turn carries exactly the mass/reversal amplitude. -/
theorem edgeAmp_of_turn (r l mu : Complex) {incoming outgoing : Direction}
    (hturn : Ne incoming outgoing) :
    edgeAmp r l mu incoming outgoing = mu := by
  simp [edgeAmp, hturn]

/-- Turn amplitudes are symmetric: either direction change carries `mu`. -/
theorem edgeAmp_turn_symmetric (r l mu : Complex) {incoming outgoing : Direction}
    (hturn : Ne incoming outgoing) :
    edgeAmp r l mu incoming outgoing = edgeAmp r l mu outgoing incoming := by
  rw [edgeAmp_of_turn r l mu hturn, edgeAmp_of_turn r l mu (Ne.symm hturn)]

/-- Number of direction changes in a finite checkerboard path. -/
def turnCount : List Direction -> Nat
  | [] => 0
  | [_] => 0
  | incoming :: outgoing :: rest =>
      (if incoming = outgoing then 0 else 1) + turnCount (outgoing :: rest)

/-- A path has a turn exactly when its turn count is positive. -/
theorem hasTurn_iff_turnCount_pos :
    forall path : List Direction, HasTurn path <-> 0 < turnCount path := by
  intro path
  induction path with
  | nil =>
      simp [HasTurn, turnCount]
  | cons incoming tail ih =>
      cases tail with
      | nil =>
          simp [HasTurn, turnCount]
      | cons outgoing rest =>
          by_cases hsame : incoming = outgoing
          case pos =>
            simp [HasTurn, turnCount, hsame, ih]
          case neg =>
            simp [HasTurn, turnCount, hsame, ih]

/-- Forward direction of `hasTurn_iff_turnCount_pos`. -/
theorem turnCount_pos_of_hasTurn {path : List Direction} (hturn : HasTurn path) :
    0 < turnCount path :=
  (hasTurn_iff_turnCount_pos path).mp hturn

/-- Reverse direction of `hasTurn_iff_turnCount_pos`. -/
theorem hasTurn_of_turnCount_pos {path : List Direction} (hturn : 0 < turnCount path) :
    HasTurn path :=
  (hasTurn_iff_turnCount_pos path).mpr hturn

/-- Zero turn count is equivalent to no direction change. -/
theorem turnCount_eq_zero_iff_not_hasTurn (path : List Direction) :
    turnCount path = 0 <-> Not (HasTurn path) := by
  rw [hasTurn_iff_turnCount_pos path]
  constructor
  case mp =>
    intro hzero hpos
    omega
  case mpr =>
    intro hnot
    by_contra hne
    exact hnot (Nat.pos_of_ne_zero hne)

/-- Forward direction of `turnCount_eq_zero_iff_not_hasTurn`. -/
theorem not_hasTurn_of_turnCount_eq_zero {path : List Direction}
    (hzero : turnCount path = 0) :
    Not (HasTurn path) :=
  (turnCount_eq_zero_iff_not_hasTurn path).mp hzero

/-- Reverse direction of `turnCount_eq_zero_iff_not_hasTurn`. -/
theorem turnCount_eq_zero_of_not_hasTurn {path : List Direction}
    (hnot : Not (HasTurn path)) :
    turnCount path = 0 :=
  (turnCount_eq_zero_iff_not_hasTurn path).mpr hnot

/-- If a path has zero turn count, its first edge is straight. -/
theorem first_step_eq_of_turnCount_zero {incoming outgoing : Direction}
    {rest : List Direction} (hzero : turnCount (incoming :: outgoing :: rest) = 0) :
    incoming = outgoing := by
  by_cases hsame : incoming = outgoing
  case pos =>
    exact hsame
  case neg =>
    simp [turnCount, hsame] at hzero

/-- Finite checkerboard slogan: at zero mass, every path containing a direction
reversal has zero amplitude. -/
theorem pathAmp_zero_mass_of_hasTurn (r l : Complex) :
    forall path : List Direction, HasTurn path -> pathAmp r l 0 path = 0 := by
  intro path
  induction path with
  | nil =>
      intro h
      cases h
  | cons incoming tail ih =>
      cases tail with
      | nil =>
          intro h
          cases h
      | cons outgoing rest =>
          intro h
          simp [HasTurn] at h
          rw [pathAmp]
          cases h with
          | inl hturn =>
              rw [edgeAmp_zero_mass_of_turn r l hturn]
              simp
          | inr htail =>
              rw [ih htail]
              simp

/-- Turn-count version of the zero-mass obstruction theorem. -/
theorem pathAmp_zero_mass_of_turnCount_pos (r l : Complex) (path : List Direction)
    (hturn : 0 < turnCount path) :
    pathAmp r l 0 path = 0 :=
  pathAmp_zero_mass_of_hasTurn r l path (hasTurn_of_turnCount_pos hturn)

/-- No turns iff all consecutive directions agree. -/
theorem turnCount_eq_zero_iff_isChain :
    forall path : List Direction,
      turnCount path = 0 <-> List.IsChain (fun a b => a = b) path := by
  intro path
  induction path with
  | nil =>
      tauto
  | cons incoming tail ih =>
      cases tail with
      | nil =>
          simp [turnCount]
      | cons outgoing rest =>
          simp [turnCount, ih]

/-- Quantitative checkerboard slogan: every finite path amplitude factors as
the unit-mass path amplitude times `mu` to the number of direction reversals. -/
theorem pathAmp_factor (r l mu : Complex) :
    forall path : List Direction,
      pathAmp r l mu path = mu ^ turnCount path * pathAmp r l 1 path := by
  intro path
  induction path with
  | nil =>
      simp [pathAmp, turnCount]
  | cons incoming tail ih =>
      cases tail with
      | nil =>
          simp [pathAmp, turnCount]
      | cons outgoing rest =>
          unfold pathAmp turnCount
          rw [ih]
          unfold edgeAmp
          by_cases hsame : incoming = outgoing
          case pos =>
            simp [hsame, mul_assoc, mul_comm]
          case neg =>
            simp [hsame, pow_add, mul_comm, mul_left_comm]

/-! ## Path-sum expansion of matrix powers -/

/-- Amplitude of a finite checkerboard path recorded as a vertex tuple
`v : Fin (n + 1) -> Direction`, i.e. the product of the `n` successive edge
amplitudes. This is the tuple form of `pathAmp`. -/
def pathAmpVec (r l mu : Complex) {n : Nat}
    (v : Fin (n + 1) -> Direction) : Complex :=
  Finset.univ.prod (fun i : Fin n =>
    edgeAmp r l mu (v i.castSucc) (v i.succ))

/-- Number of turns in a fixed-length tuple path. -/
def turnCountVec {n : Nat} (v : Fin (n + 1) -> Direction) : Nat :=
  Finset.univ.sum (fun i : Fin n =>
    if v i.castSucc = v i.succ then 0 else 1)

/-- Peeling the first vertex off a tuple path multiplies in the leading edge
amplitude. -/
theorem pathAmpVec_cons (r l mu : Complex) {n : Nat} (d : Direction)
    (v : Fin (n + 1) -> Direction) :
    pathAmpVec r l mu (Fin.cons d v) =
      edgeAmp r l mu d (v 0) * pathAmpVec r l mu v := by
  simp +decide [pathAmpVec, Fin.prod_univ_succ]

/-- Peeling the first vertex off a tuple path adds the leading turn indicator. -/
theorem turnCountVec_cons {n : Nat} (d : Direction)
    (v : Fin (n + 1) -> Direction) :
    turnCountVec (Fin.cons d v) =
      (if d = v 0 then 0 else 1) + turnCountVec v := by
  simp +decide [turnCountVec, Fin.sum_univ_succ]

/-- Tuple-path version of `pathAmp_factor`: every fixed-length path amplitude
factors as the unit-mass tuple amplitude times `mu` to the tuple turn count. -/
theorem pathAmpVec_factor (r l mu : Complex) :
    forall {n : Nat} (v : Fin (n + 1) -> Direction),
      pathAmpVec r l mu v =
        mu ^ turnCountVec v * pathAmpVec r l 1 v := by
  intro n
  induction n with
  | zero =>
      intro v
      simp [pathAmpVec, turnCountVec]
  | succ n ih =>
      intro v
      rw [<- Fin.cons_self_tail v]
      rw [pathAmpVec_cons, pathAmpVec_cons, turnCountVec_cons, ih]
      unfold edgeAmp
      by_cases hsame : v 0 = Fin.tail v 0
      case pos =>
        simp [hsame, mul_assoc, mul_comm]
      case neg =>
        simp [hsame, pow_add, mul_comm, mul_left_comm]

/-- A tuple path of length `n` has at most `n` turns. -/
theorem turnCountVec_le_length :
    forall {n : Nat} (v : Fin (n + 1) -> Direction), turnCountVec v <= n := by
  intro n
  induction n with
  | zero =>
      intro v
      simp [turnCountVec]
  | succ n ih =>
      intro v
      rw [<- Fin.cons_self_tail v, turnCountVec_cons]
      have htail : turnCountVec (Fin.tail v) <= n := ih (Fin.tail v)
      by_cases hsame : v 0 = Fin.tail v 0
      case pos =>
        simp [hsame]
        omega
      case neg =>
        simp [hsame]
        omega

/-- In the isotropic unit-mass specialization, the tuple path amplitude is
`a` to the number of straight edges. -/
theorem pathAmpVec_unit_mass_isotropic (a : Complex) :
    forall {n : Nat} (v : Fin (n + 1) -> Direction),
      pathAmpVec a a 1 v = a ^ (n - turnCountVec v) := by
  intro n
  induction n with
  | zero =>
      intro v
      simp [pathAmpVec, turnCountVec]
  | succ n ih =>
      intro v
      rw [<- Fin.cons_self_tail v]
      rw [pathAmpVec_cons, turnCountVec_cons, ih]
      unfold edgeAmp
      by_cases hsame : v 0 = Fin.tail v 0
      case pos =>
        have htail : turnCountVec (Fin.tail v) <= n :=
          turnCountVec_le_length (Fin.tail v)
        have hsub :
            n + 1 - turnCountVec (Fin.tail v) =
              (n - turnCountVec (Fin.tail v)) + 1 := by
          omega
        simp [hsame, hsub, pow_succ, mul_comm]
      case neg =>
        have hsub :
            n + 1 - (1 + turnCountVec (Fin.tail v)) =
              n - turnCountVec (Fin.tail v) := by
          omega
        simp [hsame, hsub]

/-- Isotropic tuple path weight: straight edges contribute `a`, turns
contribute `mu`. -/
theorem pathAmpVec_isotropic (a mu : Complex) :
    forall {n : Nat} (v : Fin (n + 1) -> Direction),
      pathAmpVec a a mu v =
        mu ^ turnCountVec v * a ^ (n - turnCountVec v) := by
  intro n v
  rw [pathAmpVec_factor, pathAmpVec_unit_mass_isotropic]

/-- Reindexing lemma for separating the first edge in a path sum. -/
theorem pathAmpVec_sum_succ (r l mu : Complex) (n : Nat) (out inc : Direction) :
    Finset.univ.sum (fun v : Fin (n + 2) -> Direction =>
        if And (v 0 = inc) (v (Fin.last (n + 1)) = out) then
          pathAmpVec r l mu v
        else
          0) =
      Finset.univ.sum (fun w : Fin (n + 1) -> Direction =>
        if w (Fin.last n) = out then
          edgeAmp r l mu inc (w 0) * pathAmpVec r l mu w
        else
          0) := by
  convert Finset.sum_congr rfl (fun v hv => ?_) using 1
  rotate_left
  use fun v =>
    if v 0 = inc then
      if v (Fin.last (n + 1)) = out then
        edgeAmp r l mu (v 0) (v 1) * pathAmpVec r l mu (Fin.tail v)
      else
        0
    else
      0
  {
    cases n with
    | zero =>
        simp_all +decide [Fin.tail, pathAmpVec]
        grind
    | succ n =>
        simp_all +decide [Fin.tail, pathAmpVec]
        rw [Fin.prod_univ_succ]
        aesop
  }
  {
    rw [<- Equiv.sum_comp (Fin.consEquiv (fun _ : Fin (n + 2) => Direction))]
    simp +decide [Fin.consEquiv]
    rw [<- Finset.sum_filter]
    rw [<- Finset.sum_filter]
    rw [<- Finset.sum_filter]
    refine' Finset.sum_bij (fun x hx => (inc, x)) _ _ _ _ <;> aesop
  }

/-- Matrix-power/path-sum theorem for the finite checkerboard transfer. The
`(out, inc)` entry of `checkerStep r l mu ^ n` is the sum over all length-`n`
vertex tuples that start at `inc` and end at `out`, weighted by the product of
their edge amplitudes. -/
theorem checkerStep_pow_apply (r l mu : Complex) (n : Nat)
    (out inc : Direction) :
    (checkerStep r l mu ^ n) out inc =
      Finset.univ.sum (fun v : Fin (n + 1) -> Direction =>
        if And (v 0 = inc) (v (Fin.last n) = out) then
          pathAmpVec r l mu v
        else
          0) := by
  revert out inc
  induction n with
  | zero =>
    intro out inc
    fin_cases out <;> fin_cases inc <;>
      simp +decide [pathAmpVec] <;> norm_cast
  | succ n ih =>
    intro out inc
    rw [pow_succ, Matrix.mul_apply]
    simp only [ih, pathAmpVec_sum_succ, Fin.sum_univ_two, Fin.isValue]
    rw [Finset.sum_mul, Finset.sum_mul, <- Finset.sum_add_distrib]
    congr 1
    ext v
    fin_cases inc <;>
      simp only [edgeAmp_eq_checkerStep_entry] <;>
      cases Fin.exists_fin_two.mp (Exists.intro (v 0) rfl) <;>
      simp +decide [*, mul_comm]

/-- Factored matrix-power/path-sum theorem: each tuple path summand exposes the
exact power of the mass/reversal amplitude through `turnCountVec`. -/
theorem checkerStep_pow_apply_factored (r l mu : Complex) (n : Nat)
    (out inc : Direction) :
    (checkerStep r l mu ^ n) out inc =
      Finset.univ.sum (fun v : Fin (n + 1) -> Direction =>
        if And (v 0 = inc) (v (Fin.last n) = out) then
          mu ^ turnCountVec v * pathAmpVec r l 1 v
        else
          0) := by
  rw [checkerStep_pow_apply]
  refine Finset.sum_congr rfl ?_
  intro v _
  by_cases hend : And (v 0 = inc) (v (Fin.last n) = out)
  case pos =>
    simp only [hend]
    exact pathAmpVec_factor r l mu v
  case neg =>
    simp [hend]

/-- Turn-graded matrix-power/path-sum theorem. Each entry of `checkerStep ^ n`
is a finite polynomial in `mu`, grouped by the exact number of turns. -/
theorem checkerStep_pow_apply_turnGrouped (r l mu : Complex) (n : Nat)
    (out inc : Direction) :
    (checkerStep r l mu ^ n) out inc =
      (Finset.range (n + 1)).sum (fun k =>
        mu ^ k *
          (Finset.univ.filter (fun v : Fin (n + 1) -> Direction =>
            turnCountVec v = k)).sum (fun v =>
              if And (v 0 = inc) (v (Fin.last n) = out) then
                pathAmpVec r l 1 v
              else
                0)) := by
  rw [checkerStep_pow_apply_factored]
  symm
  calc
    (Finset.range (n + 1)).sum (fun k =>
        mu ^ k *
          (Finset.univ.filter (fun v : Fin (n + 1) -> Direction =>
            turnCountVec v = k)).sum (fun v =>
              if And (v 0 = inc) (v (Fin.last n) = out) then
                pathAmpVec r l 1 v
              else
                0))
        =
          (Finset.range (n + 1)).sum (fun k =>
            ((Finset.univ.filter (fun v : Fin (n + 1) -> Direction =>
              turnCountVec v = k)).sum (fun v =>
                if And (v 0 = inc) (v (Fin.last n) = out) then
                  mu ^ turnCountVec v * pathAmpVec r l 1 v
                else
                  0))) := by
            refine Finset.sum_congr rfl ?_
            intro k _
            rw [Finset.mul_sum]
            refine Finset.sum_congr rfl ?_
            intro v hv
            have hturn : turnCountVec v = k := by
              simpa using (Finset.mem_filter.mp hv).2
            by_cases hend : And (v 0 = inc) (v (Fin.last n) = out)
            case pos =>
              simp [hend, hturn]
            case neg =>
              simp [hend]
    _ =
          Finset.univ.sum (fun v : Fin (n + 1) -> Direction =>
            if And (v 0 = inc) (v (Fin.last n) = out) then
              mu ^ turnCountVec v * pathAmpVec r l 1 v
            else
              0) := by
            simpa using
              (Finset.sum_fiberwise_of_maps_to
                (s := (Finset.univ : Finset (Fin (n + 1) -> Direction)))
                (t := Finset.range (n + 1))
                (g := fun v : Fin (n + 1) -> Direction => turnCountVec v)
                (fun v _ => by
                  simp [turnCountVec_le_length v])
                (f := fun v : Fin (n + 1) -> Direction =>
                  if And (v 0 = inc) (v (Fin.last n) = out) then
                    mu ^ turnCountVec v * pathAmpVec r l 1 v
                  else
                    0))

/-- Isotropic checkerboard path-sum: for `r = l = a`, each length-`n` path
contributes `a` to the number of straight edges and `mu` to the number of
turns. -/
theorem checkerStep_pow_apply_isotropic (a mu : Complex) (n : Nat)
    (out inc : Direction) :
    (checkerStep a a mu ^ n) out inc =
      Finset.univ.sum (fun v : Fin (n + 1) -> Direction =>
        if And (v 0 = inc) (v (Fin.last n) = out) then
          mu ^ turnCountVec v * a ^ (n - turnCountVec v)
        else
          0) := by
  rw [checkerStep_pow_apply]
  refine Finset.sum_congr rfl ?_
  intro v _
  by_cases hend : And (v 0 = inc) (v (Fin.last n) = out)
  case pos =>
    simp only [hend]
    exact pathAmpVec_isotropic a mu v
  case neg =>
    simp [hend]

/-! ## Reverse-path turn invariance -/

/-- Appending `a` to `path` adds a turn iff `a` differs from the last recorded
direction of `path`. -/
theorem turnCount_snoc (path : List Direction) (a : Direction) :
    turnCount (path ++ [a]) =
      turnCount path + (match path.getLast? with
        | none => 0
        | some b => if b = a then 0 else 1) := by
  induction' path with head tail ih
  {
    rfl
  }
  {
    cases tail <;> simp_all +decide [turnCount]
    ring
  }

/-- Reversing a finite checkerboard path preserves its number of turns. -/
theorem turnCount_reverse (path : List Direction) :
    turnCount path.reverse = turnCount path := by
  cases path <;> simp +decide [turnCount_snoc]
  rename_i head tail
  induction' tail with tail_head tail_tail ih generalizing head <;>
    simp +decide [*, turnCount]
  rw [turnCount_snoc, add_comm]
  rw [<- ih tail_head]
  cases tail_tail <;> simp +decide [eq_comm]

/-! ## Tuple/list bridge -/

/-- The tuple path amplitude equals the list path amplitude of the vertex list
`List.ofFn v`. -/
theorem pathAmpVec_eq_pathAmp_ofFn (r l mu : Complex) :
    forall {n : Nat} (v : Fin (n + 1) -> Direction),
      pathAmpVec r l mu v = pathAmp r l mu (List.ofFn v) := by
  intro n v
  induction' n with n ih <;> simp_all +decide [pathAmpVec]
  {
    rfl
  }
  {
    convert congr_arg (fun x => edgeAmp r l mu (v 0) (v 1) * x)
      (ih (fun i => v i.succ)) using 1
    convert Fin.prod_univ_succ _ using 2
  }

/-- The tuple turn count equals the list turn count of the vertex list
`List.ofFn v`. -/
theorem turnCountVec_eq_turnCount_ofFn :
    forall {n : Nat} (v : Fin (n + 1) -> Direction),
      turnCountVec v = turnCount (List.ofFn v) := by
  intro n v
  induction' n with n ih <;> simp_all +decide
  {
    fin_cases v <;> rfl
  }
  {
    cases n with
    | zero =>
        simp_all +decide [turnCountVec, turnCount]
    | succ n =>
        simp_all +decide [turnCountVec, turnCount]
        convert congr_arg
          (fun x : Nat => (if v 0 = v 1 then 0 else 1) + x)
          (ih (fun i => v i.succ)) using 1
        rw [Fin.sum_univ_succ]
        aesop
  }

/-! ## Unitarity of the isotropic transfer -/

/-- The isotropic checkerboard step with diagonal `cos theta` and off-diagonal
`i sin theta` is unitary: its conjugate transpose times itself is the identity. -/
theorem checkerStep_isotropic_unitary (theta : Real) :
    Matrix.conjTranspose
        (checkerStep (Real.cos theta : Complex) (Real.cos theta : Complex)
          (Complex.I * (Real.sin theta : Complex))) *
      checkerStep (Real.cos theta : Complex) (Real.cos theta : Complex)
        (Complex.I * (Real.sin theta : Complex)) = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [checkerStep, Complex.ext_iff]
  {
    norm_num [Matrix.mul_apply, nullTransport, massFlip]
    norm_cast
    norm_num [reversal]
    ring_nf
    norm_num [Real.sin_sq, Real.cos_sq]
  }
  {
    unfold nullTransport massFlip
    norm_num [Matrix.mul_apply]
    ring_nf
    unfold reversal
    norm_num
  }
  {
    unfold nullTransport massFlip
    norm_num [Matrix.mul_apply]
    ring_nf
    unfold reversal
    norm_num
  }
  {
    unfold nullTransport massFlip
    norm_num [Matrix.mul_apply]
    ring_nf
    norm_cast
    norm_num [Real.sin_sq, Real.cos_sq]
    ring_nf
    unfold reversal
    norm_num
  }

/-!
The missing analytic theorem is the scaling limit of the finite path sum.
The definitions above are deliberately shaped so that an Aristotle job can
target arbitrary powers/path sums without depending on the 3+1D Gate C stack.
-/

end PhysicsSM.Draft.Checkerboard1D
