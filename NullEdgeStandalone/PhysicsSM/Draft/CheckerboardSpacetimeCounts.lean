import PhysicsSM.Draft.CheckerboardContinuumNext

/-!
# Checkerboard spacetime endpoint count scaffold

This module refines the velocity endpoint count by also fixing the outgoing
right/left edge counts. It proves the immediate impossibility lemmas, boundary
closed forms, a marginalization theorem back to the velocity endpoint count,
and the Earle/Jacobson-Schulman binomial-product closed form.
-/

noncomputable section

set_option linter.unusedSimpArgs false

namespace PhysicsSM.Draft.CheckerboardSpacetimeCounts

open PhysicsSM.Draft.Checkerboard1D
open PhysicsSM.Draft.CheckerboardContinuumScaffold
open PhysicsSM.Draft.CheckerboardContinuumNext

/-- Count fixed-length checkerboard velocity paths with fixed initial/final
velocity, fixed outgoing right/left edge counts, and exact turn count. This is
the refined spacetime-endpoint count; `r - l` is the lattice displacement and
`r + l` is the number of outgoing edges. -/
def spacetimeEndpointTurnClassCount
    (n r l k : Nat) (inc out : Direction) : Nat :=
  Fintype.card {v : Fin (n + 1) -> Direction //
    v 0 = inc /\
    v (Fin.last n) = out /\
    outgoingRightCount v = r /\
    outgoingLeftCount v = l /\
    turnCountVec v = k}

/-- Any path counted by `spacetimeEndpointTurnClassCount` has `r + l = n`. -/
theorem right_left_sum_of_spacetimeEndpoint_mem
    {n r l k : Nat} {inc out : Direction}
    (v : {v : Fin (n + 1) -> Direction //
      v 0 = inc /\
      v (Fin.last n) = out /\
      outgoingRightCount v = r /\
      outgoingLeftCount v = l /\
      turnCountVec v = k}) :
    r + l = n := by
  rcases v with ⟨v, hv0, hvlast, hright, hleft, hturn⟩
  rw [<- hright, <- hleft]
  exact outgoingRightCount_add_outgoingLeftCount v

/-- The refined count is zero unless the fixed right/left edge counts add to
the path length. -/
theorem spacetimeEndpointTurnClassCount_eq_zero_of_right_left_sum_ne
    {n r l k : Nat} {inc out : Direction}
    (h : r + l ≠ n) :
    spacetimeEndpointTurnClassCount n r l k inc out = 0 := by
  rw [spacetimeEndpointTurnClassCount, Fintype.card_eq_zero_iff]
  exact ⟨fun v => h (right_left_sum_of_spacetimeEndpoint_mem v)⟩

/-- The refined count is zero when the turn-count parity is incompatible with
the fixed endpoint velocities. -/
theorem spacetimeEndpointTurnClassCount_eq_zero_of_parity_ne
    {n r l k : Nat} {inc out : Direction}
    (h : k % 2 ≠ (if inc = out then 0 else 1)) :
    spacetimeEndpointTurnClassCount n r l k inc out = 0 := by
  rw [spacetimeEndpointTurnClassCount, Fintype.card_eq_zero_iff]
  refine ⟨?_⟩
  intro v
  rcases v with ⟨v, hv0, hvlast, hright, hleft, hturn⟩
  apply h
  have hpar := turnCountVec_mod_two_eq_endpoint n v
  rw [hturn, hv0, hvlast] at hpar
  exact hpar

/-- The refined count is zero when the requested turn count exceeds the number
of available edge slots. -/
theorem spacetimeEndpointTurnClassCount_eq_zero_of_turn_gt_length
    {n r l k : Nat} {inc out : Direction}
    (h : n < k) :
    spacetimeEndpointTurnClassCount n r l k inc out = 0 := by
  rw [spacetimeEndpointTurnClassCount, Fintype.card_eq_zero_iff]
  refine ⟨?_⟩
  intro v
  rcases v with ⟨v, hv0, hvlast, hright, hleft, hturn⟩
  exact (not_le_of_gt h) (by simpa [hturn] using turnCountVec_le_length v)

/-! ## Boundary closed forms (`n = 0`, `l = 0`, `r = 0`) -/

/-- Length-zero paths: the only vertex tuple is the constant `inc`, so the
refined count is `1` exactly when all data are trivial and the endpoints agree. -/
theorem spacetimeEndpointTurnClassCount_length_zero
    (r l k : Nat) (inc out : Direction) :
    spacetimeEndpointTurnClassCount 0 r l k inc out =
      if r = 0 ∧ l = 0 ∧ k = 0 ∧ inc = out then 1 else 0 := by
  unfold spacetimeEndpointTurnClassCount
  split_ifs <;> simp_all +decide [Fintype.card_subtype]
  · rw [Finset.card_eq_one]
    use fun _ => out
    ext x
    simp [outgoingRightCount, outgoingLeftCount, turnCountVec]
    exact ⟨fun hx => funext fun i => by fin_cases i; exact hx, fun hx => hx ▸ rfl⟩
  · unfold outgoingRightCount outgoingLeftCount turnCountVec
    aesop

set_option maxHeartbeats 1000000 in
/-- No left edges (`l = 0`, hence `r = n`) with positive length: the path is
forced to travel right from the first edge on, so the final velocity must be
right and the turn count is exactly the leading indicator `inc != right`. -/
theorem spacetimeEndpointTurnClassCount_left_zero
    (n k : Nat) (hn : 0 < n) (inc out : Direction) :
    spacetimeEndpointTurnClassCount n n 0 k inc out =
      if out = 0 ∧ k = (if inc = 0 then 0 else 1) then 1 else 0 := by
  split_ifs
  · refine' Fintype.card_eq_one_iff.mpr _
    refine' ⟨⟨fun i => if i = 0 then inc else 0, _⟩, _⟩ <;>
      simp_all +decide [outgoingRightCount, outgoingLeftCount, turnCountVec]
    intro a ha₁ ha₂ ha₃ ha₄ ha₅
    ext i
    induction i using Fin.inductionOn <;> aesop
  · refine' Fintype.card_eq_zero_iff.mpr _
    constructor
    rintro ⟨v, hv⟩
    simp_all +decide [outgoingLeftCount]
    have h_all_right : ∀ i : Fin (n + 1), v i = 0 := by
      intro i
      induction i using Fin.inductionOn <;> simp_all +decide [outgoingRightCount]
      grind +revert
    simp_all +decide [turnCountVec]
  · refine' Fintype.card_eq_one_iff.mpr _
    refine' ⟨⟨fun i => if i = 0 then inc else 0, _, _, _, _, _⟩, _⟩ <;>
      simp_all +decide [outgoingRightCount, outgoingLeftCount, turnCountVec]
    · linarith
    · convert Finset.card_eq_one.mpr _
      use ⟨0, by linarith⟩
      ext
      simp +decide [Fin.ext_iff]
    · intro a ha₁ ha₂ ha₃ ha₄ ha₅
      ext i
      induction i using Fin.inductionOn <;> simp_all +decide
      grind
  · rw [spacetimeEndpointTurnClassCount]
    simp +decide [Fintype.card_subtype, outgoingLeftCount]
    intro x hx₁ hx₂ hx₃ hx₄
    contrapose! hx₂
    simp_all +decide [outgoingRightCount, turnCountVec]
    have h_all_zero : ∀ i : Fin n, x (Fin.succ i) = 0 := by
      grind
    rcases n with (_ | n) <;> simp_all +decide [Fin.sum_univ_succ]
    exact fun h => ‹¬out = 0› (h.symm.trans (h_all_zero ⟨n, by linarith⟩))

set_option maxHeartbeats 1000000 in
/-- No right edges (`r = 0`, hence `l = n`) with positive length: the path is
forced to travel left from the first edge on, so the final velocity must be left
and the turn count is exactly the leading indicator `inc != left`. -/
theorem spacetimeEndpointTurnClassCount_right_zero
    (n k : Nat) (hn : 0 < n) (inc out : Direction) :
    spacetimeEndpointTurnClassCount n 0 n k inc out =
      if out = 1 ∧ k = (if inc = 1 then 0 else 1) then 1 else 0 := by
  unfold spacetimeEndpointTurnClassCount; split_ifs <;> simp_all +decide [ Fintype.card_subtype ] ;
  · have h_all_left : ∀ x : Fin (n + 1) -> Direction, outgoingRightCount x = 0 → ∀ j : Fin (n + 1), j ≠ 0 → x j = 1 := by
      intros x hx j hj_ne_zero
      have h_step_left : ∀ i : Fin n, x (i.succ) = 1 := by
        intro i; contrapose! hx; simp_all +decide [ outgoingRightCount ] ;
        exact ⟨ i, Or.resolve_right ( Fin.exists_fin_two.mp ( by tauto ) ) hx ⟩;
      induction j using Fin.inductionOn <;> aesop;
    refine' Finset.card_eq_one.mpr ⟨ fun _ => 1, _ ⟩ ; simp +decide [ Finset.ext_iff ];
    intro x; specialize h_all_left x; by_cases hx : x = fun _ => 1 <;> simp_all +decide [ funext_iff ] ;
    · unfold outgoingRightCount outgoingLeftCount turnCountVec; simp +decide [ hx ] ;
    · grind;
  · intro v hv hv' hv'' hv''' hv''''; simp_all +decide [ outgoingRightCount, outgoingLeftCount, turnCountVec ] ;
    have h_left : ∀ j : Fin (n + 1), j ≠ 0 → v j = 1 := by
      intro j hj; induction j using Fin.inductionOn <;> simp_all +decide ;
      grind;
    rcases n with ( _ | n ) <;> simp_all +decide [ Fin.sum_univ_succ ];
  · rw [ Finset.card_eq_one ] ; use fun i => if i = 0 then inc else 1 ; ext x ; simp_all +decide [ outgoingRightCount, outgoingLeftCount, turnCountVec ] ; (
    constructor <;> intro h <;> simp_all +decide [ funext_iff, Fin.forall_fin_succ ] ;
    · grind;
    · rcases n with ( _ | n ) <;> simp_all +decide [ Fin.sum_univ_succ ];
      exact h.2 ( Fin.last _ ));
  · intro v h0 hlast hright hleft
    have h_all_left : ∀ i : Fin (n + 1), i ≠ 0 → v i = 1 := by
      intro i hi; contrapose! hright; simp_all +decide [ outgoingRightCount ] ;
      exact ⟨ Fin.pred i hi, by have := Fin.exists_fin_two.mp ⟨ v i, rfl ⟩ ; aesop ⟩
    have h_out : out = 1 := by
      rw [ ← hlast, h_all_left _ ( ne_of_gt ( Fin.pos_iff_ne_zero.mpr ( by aesop ) ) ) ]
    have h_turn : turnCountVec v = if inc = 1 then 0 else 1 := by
      rcases n with ( _ | n ) <;> simp_all +decide [ Fin.sum_univ_succ, turnCountVec ]
    aesop

/-! ## Marginalization back to the velocity-endpoint count -/

/-- Summing the refined spacetime-endpoint count over all right/left splits
recovers the coarser velocity-endpoint turn-class count. The velocity paths are
fibered by their outgoing right-edge count `r` in `{0, ..., n}`, with the left
count forced to `n - r`. -/
theorem spacetimeEndpointTurnClassCount_sum_eq_velocity
    (n k : Nat) (inc out : Direction) :
    (Finset.range (n + 1)).sum
        (fun r => spacetimeEndpointTurnClassCount n r (n - r) k inc out)
      = velocityEndpointTurnClassCount n k inc out := by
  unfold spacetimeEndpointTurnClassCount velocityEndpointTurnClassCount
  simp +decide only [Fintype.card_subtype]
  rw [← Finset.card_biUnion]
  · congr with x
    simp +decide
    exact ⟨fun h => ⟨h.2.1, h.2.2.1, h.2.2.2.2⟩, fun h => ⟨by
      exact le_trans
        (Finset.sum_le_sum fun _ _ =>
          Nat.le_of_lt_succ
            (show (if x (Fin.succ _) = 0 then 1 else 0) < 2 by
              split_ifs <;> norm_num))
        (by norm_num),
      h.1, h.2.1, by
      exact eq_tsub_of_add_eq (by
        linarith [outgoingRightCount_add_outgoingLeftCount x]), h.2.2⟩⟩
  · exact fun x hx y hy hxy =>
      Finset.disjoint_left.mpr fun z hz₁ hz₂ => hxy <| by aesop

/-- Summing the refined spacetime endpoint counts over all right/left splits
recovers the closed binomial velocity count. This is the cheap consistency
corollary tying the refined count back to the previous checkerboard theorem. -/
theorem spacetimeEndpointTurnClassCount_sum_eq_choose
    (n k : Nat) (inc out : Direction) :
    (Finset.range (n + 1)).sum
        (fun r => spacetimeEndpointTurnClassCount n r (n - r) k inc out)
      =
      if k % 2 = (if inc = out then 0 else 1) then Nat.choose n k else 0 := by
  rw [spacetimeEndpointTurnClassCount_sum_eq_velocity,
    velocityEndpointTurnClassCount_eq_choose]

/-! ## Earle/Jacobson-Schulman binomial-product closed form -/

/-- Number of compositions of `m` into exactly `j` positive parts.

For `j >= 1` and `m >= 1` this is `Nat.choose (m - 1) (j - 1)`. For `j = 0`
it is `1` when `m = 0` and `0` otherwise. For `m = 0` and `j >= 1` it is `0`. -/
def runCount (m j : Nat) : Nat :=
  if j = 0 then (if m = 0 then 1 else 0)
  else if m = 0 then 0 else Nat.choose (m - 1) (j - 1)

/-- `runCount` with no parts is the empty-composition indicator. -/
theorem runCount_zero_parts (m : Nat) :
    runCount m 0 = if m = 0 then 1 else 0 := rfl

/-- `runCount` of zero into a positive number of positive parts is zero. -/
theorem runCount_zero_of_pos_parts (j : Nat) :
    runCount 0 (j + 1) = 0 := by simp [runCount]

/-- Composition count in binomial form on the generic positive range. -/
theorem runCount_succ_succ (m j : Nat) :
    runCount (m + 1) (j + 1) = Nat.choose m j := by
  simp [runCount]

/-- There is no composition of `m` into strictly more than `m` positive parts:
requesting more positive parts than the total forces the count to zero. -/
theorem runCount_eq_zero_of_lt {m j : Nat} (h : m < j) : runCount m j = 0 := by
  unfold runCount
  split_ifs <;>
    first
      | rfl
      | (exfalso; omega)
      | exact Nat.choose_eq_zero_of_lt (by omega)

/-- One-part special case: `m` has a single positive-part composition iff
`m` is positive. -/
theorem runCount_one_part (m : Nat) :
    runCount m 1 = if m = 0 then 0 else 1 := by
  unfold runCount
  split_ifs <;> simp_all

/-- All-one-parts special case: the unique composition of `m` into `m` positive
parts is the all-ones composition, so the count is always `1`. -/
theorem runCount_self (m : Nat) : runCount m m = 1 := by
  unfold runCount
  split_ifs <;> simp_all [Nat.choose_self]

/-- Closed-form right-hand side for the refined spacetime endpoint turn-class
count. This packages the Earle/Jacobson-Schulman binomial-product expression as
a reusable finite function. -/
def spacetimeEndpointTurnClassClosedForm
    (n r l k : Nat) (inc out : Direction) : Nat :=
  if r + l = n ∧ k % 2 = (if inc = out then 0 else 1) then
    (if inc = 0 then
      runCount (r + 1) ((k + 2) / 2) * runCount l ((k + 1) / 2)
    else
      runCount (l + 1) ((k + 2) / 2) * runCount r ((k + 1) / 2))
  else 0

set_option maxHeartbeats 4000000 in
/-- Earle/Jacobson-Schulman closed form for the refined spacetime-endpoint turn
class count.

Decomposing a checkerboard velocity path into its `k + 1` maximal alternating
runs, the run values alternate starting from `inc`. Fixing the outgoing right
count `r` and left count `l = n - r` fixes the total number of right/left
symbols, and the count becomes a product of two composition numbers: one for
distributing the right symbols across the right-valued runs and one for the left
symbols across the left-valued runs. The number of runs of each value is
`(k + 2) / 2` and `(k + 1) / 2`, and the initial velocity `inc` selects which
symbol owns the extra vertex at position `0`. -/
theorem spacetimeEndpointTurnClassCount_eq
    (n r l k : Nat) (inc out : Direction) :
    spacetimeEndpointTurnClassCount n r l k inc out =
      if r + l = n ∧ k % 2 = (if inc = out then 0 else 1) then
        (if inc = 0 then
          runCount (r + 1) ((k + 2) / 2) * runCount l ((k + 1) / 2)
        else
          runCount (l + 1) ((k + 2) / 2) * runCount r ((k + 1) / 2))
      else 0 := by
  by_contra h_contra
  induction' n with n ih generalizing r l k inc out
  · contrapose! h_contra
    simp_all +decide [spacetimeEndpointTurnClassCount_length_zero]
    rcases k with (_ | _ | k) <;> simp_all +decide [runCount]
    grind
  · by_cases h_cases : r + l = n + 1 ∧ k % 2 = (if inc = out then 0 else 1)
    · have h_split :
          spacetimeEndpointTurnClassCount (n + 1) r l k inc out =
            ∑ d : Direction,
              spacetimeEndpointTurnClassCount n
                (r - (if d = 0 then 1 else 0))
                (l - (if d = 1 then 1 else 0))
                (k - (if inc = d then 0 else 1)) d out := by
        unfold spacetimeEndpointTurnClassCount
        simp +decide only [Fintype.card_subtype]
        rw [← Finset.card_biUnion]
        · refine' Finset.card_bij (fun x hx => Fin.tail x) _ _ _ <;>
            simp +decide [Fin.tail]
          · intro a ha₁ ha₂ ha₃ ha₄ ha₅
            simp_all +decide [Fin.tail, outgoingRightCount, outgoingLeftCount,
              turnCountVec]
            refine' ⟨_, _, _⟩
            · rw [Finset.card_filter] at *
              rw [← ha₃, Fin.sum_univ_succ]
              aesop
            · rw [← ha₄, Finset.card_filter]
              rw [Finset.card_filter]
              rw [Fin.sum_univ_succ]
              aesop
            · rw [← ha₅, Fin.sum_univ_succ]
              simp +decide [← ha₁]
          · intro a₁ ha₁ ha₂ ha₃ ha₄ ha₅ a₂ ha₆ ha₇ ha₈ ha₉ ha₁₀ ha₁₁
            funext i
            rcases Fin.eq_zero_or_eq_succ i with rfl | ⟨j, rfl⟩
            · rw [ha₁, ha₆]
            · have hj := congrFun ha₁₁ j
              simpa [Fin.tail] using hj
          · intro b hb₁ hb₂ hb₃ hb₄
            refine' ⟨Fin.cons inc b, _, _⟩ <;>
              simp +decide [Fin.tail, outgoingRightCount, outgoingLeftCount,
                turnCountVec] at *
            refine' ⟨hb₁, _, _, _⟩
            · rw [Finset.card_filter] at *
              rw [Fin.sum_univ_succ]
              simp +decide [*]
              split_ifs <;> simp_all +decide [Nat.add_sub_of_le]
              rw [add_tsub_cancel_of_le]
              rcases r with (_ | r) <;> simp_all +decide
              have := Finset.eq_of_subset_of_card_le
                (show Finset.univ.filter
                    (fun x : Fin (n + 1) => b x = 1) ⊇
                    Finset.image (fun x : Fin n => Fin.succ x) Finset.univ
                  from ?_)
              simp_all +decide [Finset.card_image_of_injective, Function.Injective]
              · simp_all +decide [Finset.ext_iff]
                exact absurd hb₃
                  (ne_of_lt (lt_of_le_of_lt (Finset.card_le_univ _) (by norm_num)))
              · grind
            · rw [Finset.card_filter] at *
              rw [Fin.sum_univ_succ]
              simp +decide [*]
              split_ifs <;> simp_all +decide [Finset.sum_ite]
              rcases l with (_ | _ | l) <;> simp_all +arith +decide
              have := Finset.eq_of_subset_of_card_le
                (show Finset.univ.filter
                    (fun x : Fin (n + 1) => b x = 0) ⊆ Finset.univ
                  from Finset.subset_univ _)
              simp_all +decide [Finset.card_univ]
              exact absurd
                (this (by
                  linarith [show
                    Finset.card (Finset.filter
                      (fun x : Fin (n + 1) => b x = 0) Finset.univ) ≥ n + 1
                    from by
                      rw [Finset.card_filter] at *
                      rw [Fin.sum_univ_succ]
                      simp_all +decide [Finset.sum_ite]]) 0)
                (by simp +decide [*])
            · convert
                congr_arg (fun x => x + (if inc = b 0 then 0 else 1)) hb₄
                using 1
              · rw [Fin.sum_univ_succ]
                simp +decide [Fin.sum_univ_succ]
                ring
              · split_ifs <;> simp_all +decide [Nat.sub_add_cancel]
                rcases k with (_ | k) <;> simp_all +decide [Nat.sub_add_cancel]
                have h_const : ∀ i : Fin (n + 1), b i = b 0 := by
                  intro i
                  induction i using Fin.inductionOn <;> simp_all +decide
                grind
        · exact fun x _ y _ hxy =>
            Finset.disjoint_left.mpr fun z hz₁ hz₂ => hxy <| by aesop
      simp_all +decide [Fin.sum_univ_succ]
      rcases inc with (_ | _ | inc) <;> rcases out with (_ | _ | out) <;>
        norm_cast
      · rcases r with (_ | r) <;> rcases l with (_ | l) <;>
          simp_all +arith +decide
        · rcases k with (_ | _ | k) <;>
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
          · exact h_contra (by unfold runCount; aesop)
          · unfold runCount at h_contra
            simp_all +arith +decide [Nat.add_div]
        · unfold runCount at h_contra
          simp_all +arith +decide
          norm_num [h_contra.2] at h_contra
        · rcases Nat.even_or_odd' k with ⟨k, rfl | rfl⟩ <;>
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
          rcases k with (_ | k) <;>
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod, runCount_succ_succ]
          norm_num [Nat.add_div, Nat.mul_div_assoc, Nat.mul_mod, Nat.add_mod,
            runCount_succ_succ] at *
          exact h_contra (by rw [Nat.choose_succ_succ, add_mul]; ring)
      · rcases r with (_ | r) <;> rcases l with (_ | l) <;>
          simp_all +arith +decide
        · rcases k with (_ | _ | k) <;>
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
          · exact h_contra (by unfold runCount; simp +decide [Nat.choose])
          · unfold runCount at h_contra
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
        · unfold runCount at h_contra
          simp_all +arith +decide
        · rcases Nat.even_or_odd' k with ⟨k, rfl | rfl⟩ <;>
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
          norm_num [Nat.add_div, runCount_succ_succ] at *
          rcases k with (_ | k) <;>
            simp_all +arith +decide [Nat.choose_succ_succ, runCount_succ_succ]
          · exact h_contra (by unfold runCount; aesop)
          · exact h_contra (by ring)
      · rcases r with (_ | r) <;> rcases l with (_ | l) <;>
          simp_all +decide [Nat.add_mod, Nat.mul_mod]
        · unfold runCount at h_contra
          aesop
        · rcases k with (_ | _ | k) <;>
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
          · exact h_contra (by unfold runCount; simp +decide [Nat.choose])
          · unfold runCount at h_contra
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
        · rcases k with (_ | k) <;>
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
          cases Nat.mod_two_eq_zero_or_one k <;> simp_all +decide [Nat.add_div]
          unfold runCount at *
          simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
          rcases k with (_ | _ | k) <;>
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
          exact h_contra (by rw [Nat.add_one, Nat.choose_succ_succ]; ring)
      · rcases r with (_ | r) <;> rcases l with (_ | l) <;>
          simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
        · unfold runCount at h_contra
          simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
          aesop
        · rcases k with (_ | _ | k) <;>
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
          · exact h_contra (by unfold runCount; aesop)
          · unfold runCount at h_contra
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
        · rcases Nat.even_or_odd' k with ⟨k, rfl | rfl⟩ <;>
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod]
          rcases k with (_ | k) <;>
            simp_all +arith +decide [Nat.add_mod, Nat.mul_mod, runCount_succ_succ]
          norm_num [Nat.add_div, Nat.mul_div_assoc, Nat.mul_mod, Nat.add_mod,
            runCount_succ_succ] at *
          exact h_contra (by
            nlinarith only [Nat.add_one_mul_choose_eq l k, Nat.choose_succ_succ l k])
    · grind +suggestions

/-- Definition-packaged form of `spacetimeEndpointTurnClassCount_eq`. -/
theorem spacetimeEndpointTurnClassCount_eq_closedForm
    (n r l k : Nat) (inc out : Direction) :
    spacetimeEndpointTurnClassCount n r l k inc out =
      spacetimeEndpointTurnClassClosedForm n r l k inc out := by
  rw [spacetimeEndpointTurnClassCount_eq]
  rfl

/-- Common marginalization specialization of the closed form. If the right-edge
count `r` is in range, the left-edge count `n - r` automatically satisfies the
spacetime endpoint constraint. -/
theorem spacetimeEndpointTurnClassCount_eq_of_right_le_length
    {n r k : Nat} (hr : r <= n) (inc out : Direction) :
    spacetimeEndpointTurnClassCount n r (n - r) k inc out =
      if k % 2 = (if inc = out then 0 else 1) then
        (if inc = 0 then
          runCount (r + 1) ((k + 2) / 2) *
            runCount (n - r) ((k + 1) / 2)
        else
          runCount ((n - r) + 1) ((k + 2) / 2) *
            runCount r ((k + 1) / 2))
      else 0 := by
  rw [spacetimeEndpointTurnClassCount_eq]
  have hsum : r + (n - r) = n := Nat.add_sub_of_le hr
  simp [hsum]

/-- Summing the explicit Earle/Jacobson-Schulman closed form over all spacetime
right/left endpoint splits recovers the coarser binomial velocity-endpoint
count. This is a closed-form consistency check for
`spacetimeEndpointTurnClassCount_eq`. -/
theorem spacetimeEndpointTurnClassCount_closed_form_sum_eq_choose
    (n k : Nat) (inc out : Direction) :
    (Finset.range (n + 1)).sum
        (fun r =>
          if r + (n - r) = n ∧ k % 2 = (if inc = out then 0 else 1) then
            (if inc = 0 then
              runCount (r + 1) ((k + 2) / 2) *
                runCount (n - r) ((k + 1) / 2)
            else
              runCount ((n - r) + 1) ((k + 2) / 2) *
                runCount r ((k + 1) / 2))
          else 0)
      =
      if k % 2 = (if inc = out then 0 else 1) then Nat.choose n k else 0 := by
  calc
    (Finset.range (n + 1)).sum
        (fun r =>
          if r + (n - r) = n ∧ k % 2 = (if inc = out then 0 else 1) then
            (if inc = 0 then
              runCount (r + 1) ((k + 2) / 2) *
                runCount (n - r) ((k + 1) / 2)
            else
              runCount ((n - r) + 1) ((k + 2) / 2) *
                runCount r ((k + 1) / 2))
          else 0)
        =
        (Finset.range (n + 1)).sum
          (fun r => spacetimeEndpointTurnClassCount n r (n - r) k inc out) := by
      refine Finset.sum_congr rfl ?_
      intro r hr
      rw [spacetimeEndpointTurnClassCount_eq]
    _ = if k % 2 = (if inc = out then 0 else 1) then Nat.choose n k else 0 := by
      exact spacetimeEndpointTurnClassCount_sum_eq_choose n k inc out

/-! ## Right/left over-count vanishing -/

/-- Requesting more outgoing right edges than the path has edges forces the
refined spacetime-endpoint count to zero, because `r + l = n` is impossible. -/
theorem spacetimeEndpointTurnClassCount_eq_zero_of_right_gt_length
    {n r l k : Nat} {inc out : Direction} (h : n < r) :
    spacetimeEndpointTurnClassCount n r l k inc out = 0 := by
  apply spacetimeEndpointTurnClassCount_eq_zero_of_right_left_sum_ne
  omega

/-- Requesting more outgoing left edges than the path has edges forces the
refined spacetime-endpoint count to zero, because `r + l = n` is impossible. -/
theorem spacetimeEndpointTurnClassCount_eq_zero_of_left_gt_length
    {n r l k : Nat} {inc out : Direction} (h : n < l) :
    spacetimeEndpointTurnClassCount n r l k inc out = 0 := by
  apply spacetimeEndpointTurnClassCount_eq_zero_of_right_left_sum_ne
  omega

/-! ## Closed-form marginal sum to the velocity-endpoint count -/

/-- Companion to `spacetimeEndpointTurnClassCount_closed_form_sum_eq_choose`:
summing the explicit Earle/Jacobson-Schulman closed form over all right/left
endpoint splits equals the coarser `velocityEndpointTurnClassCount` directly,
without first collapsing to `Nat.choose`. This is the auditor-friendly
marginalization identity for the closed form. -/
theorem spacetimeEndpointTurnClassCount_closed_form_sum_eq_velocity
    (n k : Nat) (inc out : Direction) :
    (Finset.range (n + 1)).sum
        (fun r =>
          if r + (n - r) = n ∧ k % 2 = (if inc = out then 0 else 1) then
            (if inc = 0 then
              runCount (r + 1) ((k + 2) / 2) *
                runCount (n - r) ((k + 1) / 2)
            else
              runCount ((n - r) + 1) ((k + 2) / 2) *
                runCount r ((k + 1) / 2))
          else 0)
      = velocityEndpointTurnClassCount n k inc out := by
  rw [← spacetimeEndpointTurnClassCount_sum_eq_velocity]
  refine Finset.sum_congr rfl ?_
  intro r hr
  rw [spacetimeEndpointTurnClassCount_eq]

/-! ## Small kernel-checked examples (path lengths `0`, `1`, `2`, `3`)

These examples evaluate the refined count directly through its `Fintype.card`
definition with the kernel (`decide`), so they are independent numeric checks of
the count itself, not re-derivations of the closed form. The final example
cross-checks the closed form against the same value on the length-`3` case. -/

/-- Length `0`: the single constant path with matching endpoints is counted once. -/
theorem spacetimeEndpointTurnClassCount_example_len0 :
    spacetimeEndpointTurnClassCount 0 0 0 0 0 0 = 1 := by
  unfold spacetimeEndpointTurnClassCount; decide

/-- Length `1`: a single left edge, one turn, from right to left is counted once. -/
theorem spacetimeEndpointTurnClassCount_example_len1 :
    spacetimeEndpointTurnClassCount 1 0 1 1 0 1 = 1 := by
  unfold spacetimeEndpointTurnClassCount; decide

/-- Length `2`: one right and one left edge with a single turn, from right to
left, is counted once. -/
theorem spacetimeEndpointTurnClassCount_example_len2 :
    spacetimeEndpointTurnClassCount 2 1 1 1 0 1 = 1 := by
  unfold spacetimeEndpointTurnClassCount; decide

/-- A vanishing example: length `2` with a turn count of parity incompatible
with the endpoints has no paths. -/
theorem spacetimeEndpointTurnClassCount_example_len2_zero :
    spacetimeEndpointTurnClassCount 2 1 1 0 0 1 = 0 := by
  unfold spacetimeEndpointTurnClassCount; decide

/-- Length `3`: two right edges and one left edge with two turns, returning to
right, has exactly two paths. -/
theorem spacetimeEndpointTurnClassCount_example_len3 :
    spacetimeEndpointTurnClassCount 3 2 1 2 0 0 = 2 := by
  unfold spacetimeEndpointTurnClassCount; decide

/-- Cross-check: the closed form agrees with the direct count on the length-`3`
example. -/
theorem spacetimeEndpointTurnClassCount_example_len3_closed_form :
    spacetimeEndpointTurnClassCount 3 2 1 2 0 0 = 2 := by
  rw [spacetimeEndpointTurnClassCount_eq]; decide

/-! ## Entrywise generating-function bridges -/

/-- Entrywise finite generating-function form of the isotropic checkerboard
propagator. The `(out, inc)` matrix entry is recovered by summing exact
velocity endpoint turn classes with weight `mu ^ k * a ^ (n - k)`. -/
theorem checkerStep_pow_apply_isotropic_velocityEndpoint
    (a mu : Complex) (n : Nat) (out inc : Direction) :
    (checkerStep a a mu ^ n) out inc =
      (Finset.range (n + 1)).sum (fun k =>
        (velocityEndpointTurnClassCount n k inc out : Complex) *
          mu ^ k * a ^ (n - k)) := by
  rw [checkerStep_pow_apply_turnGrouped]
  refine Finset.sum_congr rfl ?_
  intro k hk
  have hinner :
      (Finset.univ.filter (fun v : Fin (n + 1) -> Direction =>
        turnCountVec v = k)).sum (fun v =>
          if And (v 0 = inc) (v (Fin.last n) = out) then
            pathAmpVec a a 1 v
          else
            0) =
        (velocityEndpointTurnClassCount n k inc out : Complex) * a ^ (n - k) := by
    rw [← Finset.sum_filter]
    rw [Finset.filter_filter]
    calc
      ((Finset.univ : Finset (Fin (n + 1) -> Direction)).filter
          (fun v =>
            turnCountVec v = k ∧ And (v 0 = inc) (v (Fin.last n) = out))).sum
          (fun v => pathAmpVec a a 1 v)
          =
          (((Finset.univ : Finset (Fin (n + 1) -> Direction)).filter
            (fun v =>
              turnCountVec v = k ∧ And (v 0 = inc) (v (Fin.last n) = out))).card :
            Complex) * a ^ (n - k) := by
            have hconst :
                ((Finset.univ : Finset (Fin (n + 1) -> Direction)).filter
                  (fun v =>
                    turnCountVec v = k ∧
                      And (v 0 = inc) (v (Fin.last n) = out))).sum
                    (fun v => pathAmpVec a a 1 v)
                  =
                ((Finset.univ : Finset (Fin (n + 1) -> Direction)).filter
                  (fun v =>
                    turnCountVec v = k ∧
                      And (v 0 = inc) (v (Fin.last n) = out))).sum
                    (fun _ => a ^ (n - k)) := by
              refine Finset.sum_congr rfl ?_
              intro v hv
              have hv' :
                  turnCountVec v = k ∧
                    And (v 0 = inc) (v (Fin.last n) = out) := by
                simpa using hv
              rw [pathAmpVec_unit_mass_isotropic, hv'.1]
            rw [hconst, Finset.sum_const]
            simp
      _ = (velocityEndpointTurnClassCount n k inc out : Complex) * a ^ (n - k) := by
            congr 1
            rw [velocityEndpointTurnClassCount]
            simp [Fintype.card_subtype, and_assoc, and_left_comm, and_comm]
  rw [hinner]
  ring

/-- Spacetime-endpoint refinement of
`checkerStep_pow_apply_isotropic_velocityEndpoint`. The finite propagator entry
is recovered by summing the refined spacetime endpoint counts over right-edge
splits and turn classes. -/
theorem checkerStep_pow_apply_isotropic_spacetimeEndpoint
    (a mu : Complex) (n : Nat) (out inc : Direction) :
    (checkerStep a a mu ^ n) out inc =
      (Finset.range (n + 1)).sum (fun k =>
        ((Finset.range (n + 1)).sum (fun r =>
          (spacetimeEndpointTurnClassCount n r (n - r) k inc out : Complex))) *
          mu ^ k * a ^ (n - k)) := by
  rw [checkerStep_pow_apply_isotropic_velocityEndpoint]
  refine Finset.sum_congr rfl ?_
  intro k hk
  rw [← spacetimeEndpointTurnClassCount_sum_eq_velocity n k inc out]
  simp [Nat.cast_sum]

/-- Fully explicit finite propagator formula: substitute the packaged
Earle/Jacobson-Schulman closed form into the spacetime endpoint generating
function. This is still a finite identity, not a continuum limit theorem. -/
theorem checkerStep_pow_apply_isotropic_spacetimeClosedForm
    (a mu : Complex) (n : Nat) (out inc : Direction) :
    (checkerStep a a mu ^ n) out inc =
      (Finset.range (n + 1)).sum (fun k =>
        ((Finset.range (n + 1)).sum (fun r =>
          (spacetimeEndpointTurnClassClosedForm n r (n - r) k inc out : Complex))) *
          mu ^ k * a ^ (n - k)) := by
  rw [checkerStep_pow_apply_isotropic_spacetimeEndpoint]
  refine Finset.sum_congr rfl ?_
  intro k hk
  congr 2
  refine Finset.sum_congr rfl ?_
  intro r hr
  rw [spacetimeEndpointTurnClassCount_eq_closedForm]

end PhysicsSM.Draft.CheckerboardSpacetimeCounts
