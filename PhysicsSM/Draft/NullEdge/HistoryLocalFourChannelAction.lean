import Mathlib

/-!
# History-local four-channel action and checkerboard phase

DRAFT (kernel-clean). This module takes the next finite step after the carrier
quadratic-action identity. It localizes action contributions to a list of
history events, proves concatenation/refinement factorization, and specializes
to a checkerboard whose turns carry the exact quarter-turn phase `I^r`.

The general four channel weights remain input data. In the flat `1+1`
specialization, closure and soldering event counts are proved to vanish, while
turns occur exactly at direction reversals. This is a finite path-action theorem,
not a sum over all paths or a continuum propagator limit.

Provenance: clean-room formalization of the local bend factor in the Feynman
checkerboard, following the mathematical description in Foster--Jacobson,
arXiv:1610.01142. Aristotle job
`2a29ad97-9626-47ce-9b4c-895e8f788d5d` supplied the proof.
-/

open Complex

namespace HistoryLocalFourChannelAction

/-- The four event labels inherited from the carrier-square decomposition. -/
inductive Channel
  | aperture
  | closure
  | turn
  | soldering
  deriving DecidableEq

/-- Real local action weight assigned to each event type. -/
structure ChannelWeights where
  aperture : ℝ
  closure : ℝ
  turn : ℝ
  soldering : ℝ

/-- Select the local action weight of a channel event. -/
def ChannelWeights.weight (w : ChannelWeights) : Channel → ℝ
  | .aperture => w.aperture
  | .closure => w.closure
  | .turn => w.turn
  | .soldering => w.soldering

/-- A finite history is a list of local channel events. -/
abbrev History := List Channel

/-- The action of a finite history is the sum of its local event actions. -/
def historyAction (w : ChannelWeights) (h : History) : ℝ :=
  (h.map w.weight).sum

/-- Number of events of one channel type in a history. -/
def channelCount (c : Channel) (h : History) : ℕ := h.count c

/-- Feynman phase associated with a real action. -/
noncomputable def phaseOf (S : ℝ) : ℂ :=
  Complex.exp (Complex.I * (S : ℂ))

/-- Locality under concatenation: actions add under history composition. -/
theorem historyAction_append (w : ChannelWeights) (h₁ h₂ : History) :
    historyAction w (h₁ ++ h₂) = historyAction w h₁ + historyAction w h₂ := by
  simp [historyAction, List.map_append, List.sum_append]

/-- Action is exactly the weighted count of the four event types. -/
theorem historyAction_eq_channel_counts (w : ChannelWeights) (h : History) :
    historyAction w h =
      channelCount .aperture h * w.aperture +
      channelCount .closure h * w.closure +
      channelCount .turn h * w.turn +
      channelCount .soldering h * w.soldering := by
  induction h with
  | nil => simp [historyAction, channelCount]
  | cons c t ih =>
    simp only [historyAction, List.map_cons, List.sum_cons] at ih ⊢
    rw [ih]
    cases c <;>
      simp only [channelCount, List.count_cons, ChannelWeights.weight, beq_self_eq_true,
        if_true, beq_iff_eq, reduceCtorEq, if_false, add_zero] <;>
      push_cast <;> ring

/-- The phase of a sum factorizes. -/
theorem phaseOf_add (S T : ℝ) : phaseOf (S + T) = phaseOf S * phaseOf T := by
  simp only [phaseOf, Complex.ofReal_add, mul_add, Complex.exp_add]

/-- Repeating an action `n` times raises its phase to the `n`-th power. -/
theorem phaseOf_nsmul (n : ℕ) (S : ℝ) : phaseOf ((n : ℝ) * S) = phaseOf S ^ n := by
  simp only [phaseOf, Complex.ofReal_mul, Complex.ofReal_natCast]
  rw [show I * ((n : ℂ) * (S : ℂ)) = (n : ℂ) * (I * (S : ℂ)) by ring, Complex.exp_nat_mul]

/-- The quarter-turn action `π/2` has phase exactly `I`. -/
theorem phaseOf_pi_div_two : phaseOf (Real.pi / 2) = Complex.I := by
  simp only [phaseOf]
  rw [show I * ((Real.pi / 2 : ℝ) : ℂ) = (Real.pi : ℂ) / 2 * I by push_cast; ring]
  exact Complex.exp_pi_div_two_mul_I

/-- Local history composition becomes multiplication of amplitudes. -/
theorem historyPhase_append (w : ChannelWeights) (h₁ h₂ : History) :
    phaseOf (historyAction w (h₁ ++ h₂)) =
      phaseOf (historyAction w h₁) * phaseOf (historyAction w h₂) := by
  rw [historyAction_append, phaseOf_add]

/-- The history phase factors into one power for each channel count. -/
theorem historyPhase_eq_channel_powers (w : ChannelWeights) (h : History) :
    phaseOf (historyAction w h) =
      phaseOf w.aperture ^ channelCount .aperture h *
      phaseOf w.closure ^ channelCount .closure h *
      phaseOf w.turn ^ channelCount .turn h *
      phaseOf w.soldering ^ channelCount .soldering h := by
  rw [historyAction_eq_channel_counts]
  simp only [phaseOf_add, phaseOf_nsmul]

/-! ## Checkerboard specialization -/

/-- Left- and right-moving null steps. -/
inductive Move
  | left
  | right
  deriving DecidableEq

/-- Number of direction reversals in a finite null-step history. -/
def turnCount : List Move → ℕ
  | [] => 0
  | [_] => 0
  | a :: b :: rest => (if a = b then 0 else 1) + turnCount (b :: rest)

/-- Flat `1+1` checkerboard events: one aperture event per null step and one
turn event at each direction reversal; closure and soldering events are absent. -/
def flatCheckerboardEvents : List Move → History
  | [] => []
  | [_] => [.aperture]
  | a :: b :: rest =>
      .aperture :: (if a = b then [] else [.turn]) ++ flatCheckerboardEvents (b :: rest)

/-- The event translation preserves the number of null steps. -/
theorem flatCheckerboard_aperture_count (moves : List Move) :
    channelCount .aperture (flatCheckerboardEvents moves) = moves.length := by
  induction moves using flatCheckerboardEvents.induct with
  | case1 => rfl
  | case2 x => rfl
  | case3 a b rest ih =>
    simp only [flatCheckerboardEvents, channelCount, List.count_cons,
      List.count_append, List.length_cons] at ih ⊢
    split <;> simp_all <;> omega

/-- The event translation records exactly the direction reversals. -/
theorem flatCheckerboard_turn_count (moves : List Move) :
    channelCount .turn (flatCheckerboardEvents moves) = turnCount moves := by
  induction moves using flatCheckerboardEvents.induct with
  | case1 => rfl
  | case2 x => rfl
  | case3 a b rest ih =>
    simp only [flatCheckerboardEvents, turnCount, channelCount, List.count_cons,
      List.count_append] at ih ⊢
    split <;> simp_all

/-- Flat checkerboard histories contain no closure events. -/
theorem flatCheckerboard_closure_count (moves : List Move) :
    channelCount .closure (flatCheckerboardEvents moves) = 0 := by
  induction moves using flatCheckerboardEvents.induct with
  | case1 => rfl
  | case2 x => rfl
  | case3 a b rest ih =>
    simp only [flatCheckerboardEvents, channelCount, List.count_cons,
      List.count_append] at ih ⊢
    split <;> simp_all

/-- Flat checkerboard histories contain no soldering events. -/
theorem flatCheckerboard_soldering_count (moves : List Move) :
    channelCount .soldering (flatCheckerboardEvents moves) = 0 := by
  induction moves using flatCheckerboardEvents.induct with
  | case1 => rfl
  | case2 x => rfl
  | case3 a b rest ih =>
    simp only [flatCheckerboardEvents, channelCount, List.count_cons,
      List.count_append] at ih ⊢
    split <;> simp_all

/-- The local checkerboard action is step count times aperture weight plus turn
count times corner weight. -/
theorem flatCheckerboard_action (w : ChannelWeights) (moves : List Move) :
    historyAction w (flatCheckerboardEvents moves) =
      moves.length * w.aperture + turnCount moves * w.turn := by
  rw [historyAction_eq_channel_counts, flatCheckerboard_aperture_count,
    flatCheckerboard_turn_count, flatCheckerboard_closure_count,
    flatCheckerboard_soldering_count]
  push_cast
  ring

/-- Flat turn-only weights with one right-angle phase per corner. -/
noncomputable def quarterTurnWeights : ChannelWeights where
  aperture := 0
  closure := 0
  turn := Real.pi / 2
  soldering := 0

/-- The local corner action gives exactly `I^r`, where `r` is the number of
checkerboard turns. -/
theorem quarterTurn_history_phase (moves : List Move) :
    phaseOf (historyAction quarterTurnWeights (flatCheckerboardEvents moves)) =
      Complex.I ^ turnCount moves := by
  rw [flatCheckerboard_action]
  simp only [quarterTurnWeights, mul_zero, zero_add]
  rw [phaseOf_nsmul, phaseOf_pi_div_two]

/-- Complex checkerboard amplitude: a real corner factor times the
history-local phase. -/
noncomputable def checkerboardAmplitude (eps m : ℝ) (moves : List Move) : ℂ :=
  (((eps * m : ℝ) : ℂ) ^ turnCount moves) *
    phaseOf (historyAction quarterTurnWeights (flatCheckerboardEvents moves))

/-- The local-action amplitude is exactly the standard corner weight
`(i eps m)^r`. -/
theorem checkerboardAmplitude_eq_corner_power (eps m : ℝ) (moves : List Move) :
    checkerboardAmplitude eps m moves =
      (Complex.I * ((eps * m : ℝ) : ℂ)) ^ turnCount moves := by
  rw [checkerboardAmplitude, quarterTurn_history_phase, mul_pow, mul_comm]

/-- A nondegenerate two-step turn has phase `I` and nonzero amplitude whenever
`eps*m` is nonzero. -/
theorem one_turn_nonzero_witness (eps m : ℝ) (h : eps * m ≠ 0) :
    turnCount [.left, .right] = 1 ∧
      phaseOf (historyAction quarterTurnWeights
        (flatCheckerboardEvents [.left, .right])) = Complex.I ∧
      checkerboardAmplitude eps m [.left, .right] ≠ 0 := by
  have ht : turnCount [Move.left, Move.right] = 1 := by decide
  refine ⟨ht, ?_, ?_⟩
  · rw [quarterTurn_history_phase, ht, pow_one]
  · rw [checkerboardAmplitude_eq_corner_power, ht, pow_one]
    simp only [ne_eq, mul_eq_zero, not_or]
    exact ⟨Complex.I_ne_zero, by exact_mod_cast h⟩

/-- The flat finite verdict: local action is additive, its phase composes, and
the checkerboard turn phase reproduces the standard exact corner weight. -/
theorem history_local_four_channel_action_verdict (eps m : ℝ) (h : eps * m ≠ 0) :
    (∀ w : ChannelWeights, ∀ h₁ h₂ : History,
      historyAction w (h₁ ++ h₂) = historyAction w h₁ + historyAction w h₂)
      ∧ (∀ moves : List Move,
        phaseOf (historyAction quarterTurnWeights (flatCheckerboardEvents moves)) =
          Complex.I ^ turnCount moves)
      ∧ checkerboardAmplitude eps m [.left, .right] ≠ 0 :=
  ⟨fun w h₁ h₂ => historyAction_append w h₁ h₂,
    fun moves => quarterTurn_history_phase moves,
    (one_turn_nonzero_witness eps m h).2.2⟩

/-! ## Axiom-footprint guard pins

These `#guard_msgs` blocks pin the transitive axiom footprint of every headline
theorem to the standard Mathlib base (`propext`, `Classical.choice`, `Quot.sound`),
so any accidental new axiom dependency breaks the build. -/

/-- info: 'HistoryLocalFourChannelAction.historyAction_append' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms historyAction_append

/-- info: 'HistoryLocalFourChannelAction.historyAction_eq_channel_counts' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms historyAction_eq_channel_counts

/-- info: 'HistoryLocalFourChannelAction.phaseOf_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phaseOf_add

/-- info: 'HistoryLocalFourChannelAction.historyPhase_append' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms historyPhase_append

/-- info: 'HistoryLocalFourChannelAction.historyPhase_eq_channel_powers' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms historyPhase_eq_channel_powers

/-- info: 'HistoryLocalFourChannelAction.flatCheckerboard_aperture_count' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms flatCheckerboard_aperture_count

/-- info: 'HistoryLocalFourChannelAction.flatCheckerboard_turn_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms flatCheckerboard_turn_count

/-- info: 'HistoryLocalFourChannelAction.flatCheckerboard_closure_count' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms flatCheckerboard_closure_count

/-- info: 'HistoryLocalFourChannelAction.flatCheckerboard_soldering_count' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms flatCheckerboard_soldering_count

/-- info: 'HistoryLocalFourChannelAction.flatCheckerboard_action' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms flatCheckerboard_action

/-- info: 'HistoryLocalFourChannelAction.quarterTurn_history_phase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quarterTurn_history_phase

/-- info: 'HistoryLocalFourChannelAction.checkerboardAmplitude_eq_corner_power' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms checkerboardAmplitude_eq_corner_power

/-- info: 'HistoryLocalFourChannelAction.one_turn_nonzero_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms one_turn_nonzero_witness

/-- info: 'HistoryLocalFourChannelAction.history_local_four_channel_action_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms history_local_four_channel_action_verdict

end HistoryLocalFourChannelAction
