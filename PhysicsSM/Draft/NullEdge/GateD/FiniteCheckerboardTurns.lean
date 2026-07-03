import PhysicsSM.Draft.NullEdge.GateD.FiniteBernoulliMaxEntropy

/-!
# Gate D6: finite checkerboard turn weights

This Draft module banks the classical finite-probability slice of Gate D6 from
`Sources/Null_Edge_Dynamics_Gate_D.md`, section 5.2.

A checkerboard history with `n` possible turn sites is represented as a binary
turn sequence `Fin n -> Bool`.  At fixed turn probability `p`, the classical
growth weight is the Bernoulli product over turn sites:

* a turn contributes `p`;
* a non-turn contributes `1 - p`.

The main theorem here is the finite normalization identity
`sum_s prod_i weight_i(s_i) = 1`.  This proves the classical probability
measure part of D6(ii).  The fixed-mean maximum-entropy theorem is supplied by
the D1 product-marginal/subadditivity layer in
`FiniteBernoulliMaxEntropy`; the Lorentzian continuation to turn amplitudes is
the separate sign-problem gap and is not asserted here.

Claim label: **finite identity / structural toy theorem**.

Status: draft-trust; no `s o r r y`, no `n a t i v e _ d e c i d e`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateD
namespace FiniteCheckerboardTurns

open scoped BigOperators

/-- Binary turn sequences with `n` possible turn sites. -/
abbrev TurnSeq (n : Nat) := Fin n -> Bool

/-- Number of turns in a binary turn sequence. -/
def turnCount {n : Nat} (s : TurnSeq n) : Nat :=
  ∑ i : Fin n, if s i then 1 else 0

/-- Real-valued turn count, convenient for expectation identities. -/
def turnCountReal {n : Nat} (s : TurnSeq n) : ℝ :=
  ∑ i : Fin n, if s i then 1 else 0

/-- Bernoulli product weight of a checkerboard turn sequence. -/
def bernoulliTurnWeight {n : Nat} (p : ℝ) (s : TurnSeq n) : ℝ :=
  ∏ i : Fin n, if s i then p else 1 - p

/-- Bernoulli turn weights are nonnegative for `0 <= p <= 1`. -/
theorem bernoulliTurnWeight_nonneg {n : Nat} {p : ℝ}
    (hp0 : 0 <= p) (hp1 : p <= 1) (s : TurnSeq n) :
    0 <= bernoulliTurnWeight p s := by
  unfold bernoulliTurnWeight
  exact Finset.prod_nonneg fun i _ => by
    by_cases h : s i
    · simp [h, hp0]
    · simp [h, sub_nonneg.mpr hp1]

/-- The Bernoulli turn weights sum to one over all binary turn sequences. -/
theorem bernoulliTurnWeight_sum {n : Nat} (p : ℝ) :
    (∑ s : TurnSeq n, bernoulliTurnWeight p s) = 1 := by
  unfold bernoulliTurnWeight TurnSeq
  rw [← Fintype.piFinset_univ]
  have h := Finset.prod_univ_sum
    (t := fun _ : Fin n => (Finset.univ : Finset Bool))
    (f := fun (_ : Fin n) (b : Bool) => if b then p else 1 - p)
  rw [← h]
  simp

/-- Under Bernoulli turn weights, each individual turn site has expectation `p`. -/
theorem bernoulliTurnWeight_marginal_turn {n : Nat} (p : ℝ) (k : Fin n) :
    (∑ s : TurnSeq n,
        (if s k then (1 : ℝ) else 0) * bernoulliTurnWeight p s) = p := by
  unfold bernoulliTurnWeight TurnSeq
  rw [← Fintype.piFinset_univ]
  let f : (i : Fin n) -> Bool -> ℝ :=
    fun i b => if i = k then (if b then 1 else 0) * (if b then p else 1 - p)
      else (if b then p else 1 - p)
  have hprod := Finset.prod_univ_sum
    (t := fun _ : Fin n => (Finset.univ : Finset Bool))
    (f := f)
  calc
    (∑ s ∈ Fintype.piFinset fun _ : Fin n => (Finset.univ : Finset Bool),
        (if s k then (1 : ℝ) else 0) * ∏ i, if s i then p else 1 - p)
        = ∑ s ∈ Fintype.piFinset fun _ : Fin n => (Finset.univ : Finset Bool),
            ∏ i, f i (s i) := by
          apply Finset.sum_congr rfl
          intro s _
          by_cases hk : s k
          · have hfactor :
                ∀ i : Fin n, f i (s i) = if s i then p else 1 - p := by
              intro i
              by_cases hi : i = k
              · subst hi
                simp [f, hk]
              · simp [f, hi]
            simp [hk]
            exact Finset.prod_congr rfl (fun i _ => (hfactor i).symm)
          · have hzero : ∏ i : Fin n, f i (s i) = 0 := by
              exact Finset.prod_eq_zero_iff.mpr
                ⟨k, Finset.mem_univ k, by simp [f, hk]⟩
            simp [hk, hzero]
    _ = ∏ i : Fin n, ∑ b : Bool, f i b := by rw [← hprod]
    _ = p := by
      have hsum_k : (∑ b : Bool, f k b) = p := by
        simp [f]
      have hsum_ne : ∀ i : Fin n, i ≠ k -> (∑ b : Bool, f i b) = 1 := by
        intro i hi
        simp [f, hi]
      calc
        (∏ i : Fin n, ∑ b : Bool, f i b) = ∑ b : Bool, f k b := by
          rw [Finset.prod_eq_single k]
          · intro i _ hi
            exact hsum_ne i hi
          · intro hnot
            simp at hnot
        _ = p := hsum_k

/-- Bernoulli turn weights have fixed mean turn count `n * p`. -/
theorem bernoulliTurnWeight_turnCountReal_mean {n : Nat} (p : ℝ) :
    (∑ s : TurnSeq n, turnCountReal s * bernoulliTurnWeight p s) =
      (n : ℝ) * p := by
  unfold turnCountReal
  calc
    (∑ s : TurnSeq n,
        (∑ i : Fin n, if s i then (1 : ℝ) else 0) * bernoulliTurnWeight p s)
        = ∑ s : TurnSeq n, ∑ i : Fin n,
            (if s i then (1 : ℝ) else 0) * bernoulliTurnWeight p s := by
          apply Finset.sum_congr rfl
          intro s _
          rw [Finset.sum_mul]
    _ = ∑ i : Fin n, ∑ s : TurnSeq n,
            (if s i then (1 : ℝ) else 0) * bernoulliTurnWeight p s := by
          rw [Finset.sum_comm]
    _ = ∑ i : Fin n, p := by
          apply Finset.sum_congr rfl
          intro i _
          exact bernoulliTurnWeight_marginal_turn p i
    _ = (n : ℝ) * p := by simp

/--
Classical checkerboard growth weight at fixed turn probability.

This is an alias, kept separate so Gate D prose can refer to the checkerboard
growth measure while the proof reuses the Bernoulli product theorem.
-/
def classicalCheckerboardGrowthWeight {n : Nat} (turnProb : ℝ)
    (s : TurnSeq n) : ℝ :=
  bernoulliTurnWeight turnProb s

/-- D6(ii), classical layer: the checkerboard growth weight is Bernoulli. -/
theorem d6_classical_growth_is_bernoulli {n : Nat} (turnProb : ℝ)
    (s : TurnSeq n) :
    classicalCheckerboardGrowthWeight turnProb s =
      bernoulliTurnWeight turnProb s := by
  rfl

/-- Classical checkerboard growth weights are nonnegative for `0 <= p <= 1`. -/
theorem classicalCheckerboardGrowthWeight_nonneg {n : Nat} {turnProb : ℝ}
    (hp0 : 0 <= turnProb) (hp1 : turnProb <= 1) (s : TurnSeq n) :
    0 <= classicalCheckerboardGrowthWeight turnProb s := by
  exact bernoulliTurnWeight_nonneg hp0 hp1 s

/-- The classical checkerboard growth weights form a normalized probability vector. -/
theorem classicalCheckerboardGrowthWeight_sum {n : Nat} (turnProb : ℝ) :
    (∑ s : TurnSeq n, classicalCheckerboardGrowthWeight turnProb s) = 1 := by
  exact bernoulliTurnWeight_sum turnProb

/-- The classical checkerboard growth measure has mean turn count `n * p`. -/
theorem classicalCheckerboardGrowthWeight_turnCountReal_mean
    {n : Nat} (turnProb : ℝ) :
    (∑ s : TurnSeq n,
        turnCountReal s * classicalCheckerboardGrowthWeight turnProb s) =
      (n : ℝ) * turnProb := by
  exact bernoulliTurnWeight_turnCountReal_mean turnProb

end FiniteCheckerboardTurns
end GateD
end NullEdge
end Draft
end PhysicsSM
