import Mathlib
import PhysicsSM.Spinor.Checkerboard

/-!
# Draft.CheckerboardCornerClosedFormsAristotle

Focused Aristotle handoff: binomial closed forms for checkerboard histories
with fixed endpoint, terminal direction, and number of corners.

This file deliberately omits the kernel-polynomial theorem, which is split out
to `PhysicsSM.Draft.CheckerboardCornerPolynomialAristotle`.  Here the hard
mathematical content is the run-counting formula:

* right-to-right, `2*r` corners:
  `p.choose r * (q - 1).choose (r - 1)`;
* right-to-left, `2*r+1` corners:
  `p.choose r * (q - 1).choose r`.

The hypotheses `0 < q` and `0 < r` are part of the convention and were checked
against brute-force enumeration in `Scripts/oracle/validate_checkerboard.py`.

Trusted code should not import this module while it contains `sorry`.
-/

namespace PhysicsSM.Draft.CheckerboardCornerClosedForms

open PhysicsSM.Spinor.Checkerboard
open PhysicsSM.Spinor.Checkerboard.Direction

/-- The histories of length `n` with incoming direction `startDir`,
displacement `dx`, terminal direction `finishDir`, and exactly `k` corners. -/
def turnHistories (n : Nat) (startDir : Direction) (dx : Int)
    (finishDir : Direction) (k : Nat) : List (List Direction) :=
  (histories n).filter fun h =>
    decide (endpoint 0 startDir h = dx
      ∧ terminalDirection startDir h = finishDir
      ∧ turnCount startDir h = k)

/-! ## Elementary helpers about `endpoint` and `terminalDirection` -/

/-- `endpoint` is translation-equivariant in the starting coordinate. -/
theorem endpoint_add (x : Int) (s : Direction) (h : List Direction) :
    endpoint x s h = x + endpoint 0 s h := by
  induction' h with e rest ih generalizing x s;
  · aesop;
  · grind +suggestions

/-- The endpoint after prepending a step `c`. -/
theorem endpoint_zero_cons (s c : Direction) (rest : List Direction) :
    endpoint 0 s (c :: rest) = c.step + endpoint 0 c rest := by
  rw [ endpoint_cons, endpoint_add ] ; ring

/-- The displacement of a length-`n` history is bounded by `n`. -/
theorem abs_endpoint_le_length (s : Direction) (h : List Direction) :
    |endpoint 0 s h| ≤ (h.length : Int) := by
  induction h generalizing s <;> simp_all +decide [ endpoint ];
  rename_i k hk ih; rw [ show endpoint _ _ _ = _ + _ from endpoint_add _ _ _ ] ; exact abs_le.mpr ⟨ by linarith [ abs_le.mp ( ih k ), abs_le.mp ( show |Direction.step k| ≤ 1 from by cases k <;> simp +decide ) ], by linarith [ abs_le.mp ( ih k ), abs_le.mp ( show |Direction.step k| ≤ 1 from by cases k <;> simp +decide ) ] ⟩ ;

/-- The terminal direction is the start direction flipped `turnCount`-many
times, i.e. it is determined by the parity of the corner count. -/
theorem terminalDirection_eq_ite (s : Direction) (h : List Direction) :
    terminalDirection s h = if Even (turnCount s h) then s else s.flip := by
  induction' h with e rest ih generalizing s;
  · cases s <;> rfl;
  · rw [ turnCount_cons ];
    cases e <;> cases s <;> simp +decide [ *, Nat.even_add ];
    · grind +revert;
    · grind

/-! ## Compositions and the answer function -/

/-- `compCount m j` is the number of compositions of `m` into `j` positive
parts.  (Number of ways to write `m = a₁ + ⋯ + a_j` with each `aᵢ ≥ 1`.) -/
def compCount : Nat → Nat → Nat
  | m, 0 => if m = 0 then 1 else 0
  | 0, _ + 1 => 0
  | m + 1, j + 1 => compCount m j + compCount m (j + 1)

/-- Closed form for compositions into a positive number of parts. -/
theorem compCount_pos (m j : Nat) (hm : 0 < m) :
    compCount m (j + 1) = (m - 1).choose j := by
  induction' m with m ih generalizing j <;> induction' j with j ih' <;> simp_all +decide;
  · cases m <;> simp_all +decide [ compCount ];
    specialize ih 0 ; simp_all +decide [ compCount ];
  · cases m <;> simp_all +decide [ Nat.choose_succ_succ, compCount ]

/-- The closed-form run count for a right-incoming history with `p` right
steps, `q` left steps, and `k` corners. -/
def ansR (p q k : Nat) : Nat := p.choose (k / 2) * compCount q (k - k / 2)

theorem ansR_even (p q r : Nat) : ansR p q (2 * r) = p.choose r * compCount q r := by
  unfold ansR; ring;
  grind

theorem ansR_odd (p q r : Nat) :
    ansR p q (2 * r + 1) = p.choose r * compCount q (r + 1) := by
  unfold ansR;
  grind

theorem ansR_base (k : Nat) : ansR 0 0 k = if k = 0 then 1 else 0 := by
  rcases k with ( _ | _ | k ) <;> simp +arith +decide [ *, ansR ]

/-- The combinatorial recursion satisfied by `ansR` away from the origin. -/
theorem ansR_rec (p q k : Nat) (hpq : 0 < p + q) :
    ansR p q k
      = (if 0 < p then ansR (p - 1) q k else 0)
        + (if 0 < q ∧ 0 < k then ansR (q - 1) p (k - 1) else 0) := by
  rcases k with ( _ | k ) <;> simp_all +decide [ ansR_even, ansR_odd ];
  · rcases p with ( _ | p ) <;> simp_all +decide [ ansR ];
    cases q <;> trivial;
  · rcases Nat.even_or_odd' k with ⟨ r, rfl | rfl ⟩;
    · split_ifs <;> simp_all +decide [ ansR_even, ansR_odd ];
      · rcases p with ( _ | p ) <;> rcases q with ( _ | q ) <;> simp_all +decide [ Nat.choose_succ_succ, compCount_pos ];
        rcases r with ( _ | r ) <;> simp_all +decide [ Nat.choose_succ_succ, compCount_pos ];
        · cases p <;> trivial;
        · ring;
      · exact Or.inr ( by cases r <;> rfl );
      · cases r <;> simp_all +decide [ Nat.choose_eq_zero_of_lt ];
        · cases q <;> simp_all +decide [ compCount_pos ];
        · exact Or.inr rfl;
    · rcases p with ( _ | p ) <;> rcases q with ( _ | q ) <;> simp +arith +decide [ ansR_even, ansR_odd, compCount_pos ];
      · grind;
      · unfold ansR; simp +arith +decide [ compCount ] ;
      · unfold ansR;
        norm_num [ Nat.add_div ];
        exact Or.inr ( by rw [ show 2 * r + 2 - ( r + 1 ) = r + 1 by rw [ Nat.sub_eq_of_eq_add ] ; ring ] ; exact Nat.recOn r ( by trivial ) fun n ihn => by trivial );
      · unfold ansR; simp +arith +decide [ Nat.choose_succ_succ, compCount ] ; ring;
        rw [ show 1 + r * 2 - r = r + 1 by rw [ Nat.sub_eq_of_eq_add ] ; ring ] ; rw [ compCount_pos ] ; ring;
        · norm_num;
        · grind

/-! ## The enumeration count and its recursion -/

/-- Number of length-`n` histories with incoming direction `s`, displacement
`dx`, and exactly `k` corners (ignoring the terminal direction). -/
def gcount (n : Nat) (s : Direction) (dx : Int) (k : Nat) : Nat :=
  ((histories n).filter (fun h =>
    decide (endpoint 0 s h = dx ∧ turnCount s h = k))).length

theorem gcount_base (s : Direction) (dx : Int) (k : Nat) :
    gcount 0 s dx k = if dx = 0 ∧ k = 0 then 1 else 0 := by
  unfold gcount; split_ifs <;> simp_all +decide [ endpoint, turnCount ] ;
  grind

/-- First-step decomposition of the enumeration count. -/
theorem gcount_succ (n : Nat) (s : Direction) (dx : Int) (k : Nat) :
    gcount (n + 1) s dx k
      = (if left = s then gcount n left (dx + 1) k
         else if 0 < k then gcount n left (dx + 1) (k - 1) else 0)
        + (if right = s then gcount n right (dx - 1) k
           else if 0 < k then gcount n right (dx - 1) (k - 1) else 0) := by
  have h_split : ∀ (l : List (List Direction)), ((l.map (left :: ·)).filter (fun h => endpoint 0 s h = dx ∧ turnCount s h = k)).length
      = ((l.filter (fun rest => endpoint 0 left rest = dx + 1 ∧ turnCount left rest = k)).length * if left = s then 1 else 0)
        + ((l.filter (fun rest => endpoint 0 left rest = dx + 1 ∧ turnCount left rest = k - 1)).length * if left ≠ s ∧ 0 < k then 1 else 0) := by
          intro l
          induction' l with rest l ih;
          · grind;
          · simp_all +decide [ List.filter_cons ];
            split_ifs <;> simp_all +decide [ turnCount_cons ];
            · grind +suggestions;
            · rename_i h₁ h₂ h₃;
              exact h₃ ( by linarith [ endpoint_add ( -1 ) left rest ] ) ( by omega );
            · subst_vars; exact ‹¬endpoint ( -1 ) left rest = dx› ( by linarith [ endpoint_add ( -1 ) left rest ] ) ;
            · grind +suggestions;
  have h_split_right : ∀ (l : List (List Direction)), ((l.map (right :: ·)).filter (fun h => endpoint 0 s h = dx ∧ turnCount s h = k)).length
      = ((l.filter (fun rest => endpoint 0 right rest = dx - 1 ∧ turnCount right rest = k)).length * if right = s then 1 else 0)
        + ((l.filter (fun rest => endpoint 0 right rest = dx - 1 ∧ turnCount right rest = k - 1)).length * if right ≠ s ∧ 0 < k then 1 else 0) := by
          intro l
          induction' l with rest l ih;
          · simp +decide;
          · by_cases h : right = s <;> by_cases h' : 0 < k <;> simp +decide [ h, h' ];
            · simp +decide [ List.filter_cons ];
              split_ifs <;> simp_all +decide [ turnCount_cons ];
              · grind +suggestions;
              · rw [ endpoint_add ] at * ; aesop;
            · simp_all +decide [ List.filter_cons ];
              cases s <;> simp_all +decide [ turnCount_cons ];
              rw [ show endpoint 1 right rest = endpoint 0 right rest + 1 from ?_ ];
              · grind;
              · convert endpoint_add 1 right rest using 1;
                ring;
            · cases s <;> cases k <;> simp_all +decide [ List.filter_cons ];
              grind +suggestions;
            · simp_all +decide [ turnCount_cons ];
  unfold gcount; aesop;

/-- Counts vanish outside the reachable displacement range. -/
theorem gcount_eq_zero_of_abs (n : Nat) (s : Direction) (dx : Int) (k : Nat)
    (h : (n : Int) < |dx|) : gcount n s dx k = 0 := by
  convert List.length_eq_zero_iff.mpr _;
  refine' List.filter_eq_nil_iff.mpr _;
  intro a ha; contrapose! h; simp_all +decide ;
  exact h.1 ▸ abs_endpoint_le_length s a |> le_trans <| mod_cast by simp +decide [ mem_histories_length ha ] ;

/-- Cornerless count: only the straight history survives. -/
theorem gcount_zero_corner (n : Nat) (dx : Int) :
    gcount n right dx 0 = if dx = (n : Int) then 1 else 0 := by
  induction' n with n ih generalizing dx <;> simp_all +decide [ gcount_succ ];
  · rw [ gcount_base ] ; aesop;
  · grind

/-! ## The coupled run-count recursion -/

/-- Right-incoming run count with `p` right steps and `q` left steps. -/
def Rcnt (p q k : Nat) : Nat := gcount (p + q) right ((p : Int) - (q : Int)) k

/-- Left-incoming run count with `p` right steps and `q` left steps. -/
def Lcnt (p q k : Nat) : Nat := gcount (p + q) left ((p : Int) - (q : Int)) k

theorem Rcnt_rec (p q k : Nat) (hpq : 0 < p + q) :
    Rcnt p q k
      = (if 0 < p then Rcnt (p - 1) q k else 0)
        + (if 0 < q ∧ 0 < k then Lcnt p (q - 1) (k - 1) else 0) := by
  convert gcount_succ ( p + q - 1 ) right ( ( p : Int ) - q ) k using 1;
  · rw [ Nat.sub_add_cancel hpq ] ; rfl;
  · rcases p with ( _ | p ) <;> rcases q with ( _ | q ) <;> simp_all +decide [ Rcnt, Lcnt ];
    · convert gcount_eq_zero_of_abs q right ( -1 + -↑q - 1 ) k _ using 1;
      rw [ abs_of_nonpos ] <;> linarith;
    · exact fun hk => gcount_eq_zero_of_abs _ _ _ _ <| by cases abs_cases ( ( p : ℤ ) + 1 + 1 ) <;> omega;
    · grind

theorem Lcnt_rec (p q k : Nat) (hpq : 0 < p + q) :
    Lcnt p q k
      = (if 0 < q then Lcnt p (q - 1) k else 0)
        + (if 0 < p ∧ 0 < k then Rcnt (p - 1) q (k - 1) else 0) := by
  unfold Lcnt Rcnt;
  convert gcount_succ ( p + q - 1 ) left ( p - q ) k using 1;
  · rw [ Nat.sub_add_cancel hpq ];
  · rcases p with ( _ | p ) <;> rcases q with ( _ | q ) <;> simp_all +decide [ add_comm, add_left_comm ];
    · intro hk;
      convert gcount_eq_zero_of_abs q right ( -q + -1 - 1 ) ( k - 1 ) _ using 1;
      rw [ abs_of_nonpos ] <;> linarith;
    · convert gcount_eq_zero_of_abs p left ( p + 2 ) k _ using 1;
      rw [ abs_of_nonneg ] <;> linarith;
    · grind

/-- The master closed-form identity, proved simultaneously for both incoming
directions by strong induction on `p + q`. -/
theorem main_count (p q k : Nat) :
    Rcnt p q k = ansR p q k ∧ Lcnt p q k = ansR q p k := by
  induction' n : p + q using Nat.strong_induction_on with n ih generalizing p q k;
  by_cases hpq : 0 < p + q <;> simp_all +decide [ Rcnt_rec, Lcnt_rec, ansR_rec ];
  · constructor;
    · grind +splitIndPred;
    · rw [ ansR_rec ];
      · grind;
      · linarith;
  · unfold Rcnt Lcnt ansR; simp +decide [ gcount_base ] ;
    rcases k with ( _ | _ | k ) <;> simp +arith +decide

/-! ## The four target closed forms -/

/-- Even corner-count closed form for histories starting and ending right. -/
theorem length_turnHistories_even (p q r : Nat) (hq : 0 < q) (hr : 0 < r) :
    (turnHistories (p + q) Direction.right ((p : Int) - (q : Int))
        Direction.right (2 * r)).length
      = p.choose r * (q - 1).choose (r - 1) := by
  convert ( main_count p q ( 2 * r ) ) |>.1 using 1;
  · convert congr_arg _ ?_;
    refine' List.filter_congr fun x hx => _;
    by_cases h : turnCount right x = 2 * r <;> simp +decide [ h ];
    rw [ terminalDirection_eq_ite ] ; aesop;
  · rw [ ansR_even ];
    cases q <;> cases r <;> simp_all +decide [ compCount_pos ]

/-- Odd corner-count closed form for histories starting right and ending left. -/
theorem length_turnHistories_odd (p q r : Nat) (hq : 0 < q) :
    (turnHistories (p + q) Direction.right ((p : Int) - (q : Int))
        Direction.left (2 * r + 1)).length
      = p.choose r * (q - 1).choose r := by
  convert main_count p q ( 2 * r + 1 ) |>.1 using 1;
  · refine' congr_arg List.length ( List.filter_congr fun x hx => _ );
    rw [ terminalDirection_eq_ite ] ; simp +decide;
    grind;
  · rw [ ansR_odd, compCount_pos ] ; aesop

/-- Cornerless histories are exactly the straight right-moving line. -/
theorem length_turnHistories_zero (n : Nat) (dx : Int) :
    (turnHistories n Direction.right dx Direction.right 0).length
      = if dx = (n : Int) then 1 else 0 := by
  convert gcount_zero_corner n dx using 2;
  unfold turnHistories gcount;
  congr! 2;
  grind +suggestions

/-- A history starting and ending right has an even number of corners. -/
theorem length_turnHistories_right_right_odd (n : Nat) (dx : Int) (r : Nat) :
    (turnHistories n Direction.right dx Direction.right (2 * r + 1)).length
      = 0 := by
  unfold turnHistories;
  rw [ List.filter_eq_nil_iff.mpr ] ; simp +decide;
  intro h hh H; have := terminalDirection_eq_ite right h; simp_all +decide ;
  grind

end PhysicsSM.Draft.CheckerboardCornerClosedForms
