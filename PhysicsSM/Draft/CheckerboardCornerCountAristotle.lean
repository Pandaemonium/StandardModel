import Mathlib
import PhysicsSM.Spinor.Checkerboard

/-!
# Draft.CheckerboardCornerCountAristotle

Aristotle handoff: the closed binomial formulas for the 1+1D Feynman
checkerboard corner-counting combinatorics, on top of the trusted module
`PhysicsSM.Spinor.Checkerboard`.

## Mathematical intent

Item 3 of the "next theorem sequence" in
`Sources/Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md`
(research program: `Sources/Luminal_Motion_Checkerboard_Research_Program.md`).
The kernel of the 1+1D checkerboard is determined by the number of histories
with a fixed endpoint, terminal direction, and number of corners; these
numbers are products of two binomial coefficients (runs/compositions
counting; cf. Feynman--Hibbs Problem 2-6 and Skopenkov--Ustinov,
arXiv:2007.12879, where the analogous closed forms drive the whole analytic
theory).  Combined with `pathWeight mu d h = mu ^ turnCount d h` (a target of
`PhysicsSM.Draft.CheckerboardSpinorRecursionAristotle`; restated here as a
local target so this file is self-contained) the path sum becomes an explicit
polynomial in `mu` with binomial coefficients -- the discrete Bessel kernel.

**Every closed form below was validated by brute-force enumeration** for all
parameters with `p + q <= 11` in `Scripts/oracle/validate_checkerboard.py`
(section "corner-count closed forms").  The oracle justifies the statements,
not the proofs.

## Conventions

- A history is a `List Direction` of future steps; the incoming direction is
  carried separately and the corner between the incoming direction and the
  first step **is counted** (`turnCount`).
- `p` denotes the number of `right` steps and `q` the number of `left`
  steps, so the length is `p + q` and the displacement is `p - q`.
- Combinatorial origin of the closed forms (runs counting): a history with
  incoming direction `right`, terminal direction `right`, and `2 * r`
  corners decomposes into right-runs and left-runs; splitting `p` rights
  into runs and `q` lefts into runs and absorbing the two subcases (first
  step right or left) via Pascal's rule gives
  `p.choose r * (q - 1).choose (r - 1)`.  Ending `left` with `2 * r + 1`
  corners gives `p.choose r * (q - 1).choose r`.

## Proof guidance

- `turnHistories` is a `List.filter` over `histories`; lengths of filtered
  sublists can be computed by induction on the recursive structure
  `histories_succ`, splitting on the first step.  A clean route is to prove
  a *joint* recursion for the four direction/parity cases (in the style of
  Pascal's rule) and then identify it with the binomial product by induction
  on `p + q`.
- `Nat.choose` conventions make out-of-range cases zero, which matches the
  enumeration; the hypotheses `0 < q` (and `0 < r` in the even case) below
  are genuinely needed (checked by the oracle: dropping them produces
  counterexamples at `q = 0`).
- For `pathSum_eq_sum_turnHistories`: first prove
  `endpoint_shift : endpoint x d h = x + endpoint 0 d h`, then partition the
  histories list by `turnCount` value; `pathWeight_eq_pow_turnCount` turns
  each class into `card * mu ^ k`.
- `length_turnHistories_flipAll`: the involution `List.map Direction.flip`
  on histories negates endpoints, flips terminal directions, and preserves
  `turnCount`; transport the count along it
  (`List.length_filter`-respecting bijection, or `List.count` via an
  injective map on `histories n`).

Do not change any definition of `PhysicsSM.Spinor.Checkerboard`.  Helper
lemmas are welcome.  No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and
**no `native_decide`** in the final state.

This is draft code: the statements below contain documented `sorry`s and
must not be imported from trusted code until the holes are eliminated.
-/

namespace PhysicsSM.Draft.CheckerboardCornerCount

open PhysicsSM.Spinor.Checkerboard
open PhysicsSM.Spinor.Checkerboard.Direction

variable {S : Type*}

/-! ## The corner-classified histories -/

/-- The histories of length `n` with incoming direction `startDir`,
displacement `dx` (endpoint relative to the start), terminal direction
`finishDir`, and exactly `k` corners. -/
def turnHistories (n : Nat) (startDir : Direction) (dx : Int)
    (finishDir : Direction) (k : Nat) : List (List Direction) :=
  (histories n).filter fun h =>
    decide (endpoint 0 startDir h = dx
      ∧ terminalDirection startDir h = finishDir
      ∧ turnCount startDir h = k)

/-! ## Target 1: elementary bridges -/

/-- The endpoint depends on the start position only by translation. -/
theorem endpoint_shift (x : Int) (d : Direction) (h : List Direction) :
    endpoint x d h = x + endpoint 0 d h := by
  induction' h with e rest ih generalizing x d
  · simp
  · grind +suggestions

/-- Local restatement of the corner-count form of the path weight (also a
target of `PhysicsSM.Draft.CheckerboardSpinorRecursionAristotle`; proved
independently here so that this file stands alone). -/
theorem pathWeight_eq_pow_turnCount [Semiring S] (mu : S)
    (d : Direction) (h : List Direction) :
    pathWeight mu d h = mu ^ turnCount d h := by
  induction' h with e rest ih generalizing d;
  · simp +decide;
  · cases d <;> cases e <;> simp +decide [ *, pow_add ];
    · rw [ turnCount_cons ] ; simp +decide;
    · simp +decide [ *, turnWeight, turnCount ];
      rw [ pow_add, pow_one ];
    · simp +decide [ turnWeight, turnCount ];
      rw [ pow_add, pow_one ];
    · rw [ turnCount_cons ] ; simp +decide

/-! ## Target 2: the path sum as a corner-counting polynomial -/

/-
**Discrete kernel expansion.**  The finite checkerboard path sum is the
polynomial in the corner weight `mu` whose `k`-th coefficient is the number
of length-`n` histories with the prescribed endpoint data and exactly `k`
corners.
-/
theorem pathSum_eq_sum_turnHistories [Semiring S] (mu : S) (x : Int)
    (d : Direction) (n : Nat) (y : Int) (e : Direction) :
    pathSum mu x d n y e
      =
        ∑ k ∈ Finset.range (n + 1),
          ((turnHistories n d (y - x) e k).length : S) * mu ^ k := by
  have h_path_sum : pathSum mu x d n y e = (∑ h ∈ (histories n).toFinset, if endpoint x d h = y ∧ terminalDirection d h = e then pathWeight mu d h else 0) := by
    unfold pathSum;
    rw [ List.sum_toFinset ];
    induction' n with n ih;
    · exact List.nodup_singleton _;
    · rw [ histories_succ ];
      grind;
  -- By definition of `pathWeight`, we can rewrite the sum as a sum over `k` of the number of histories with `k` corners.
  have h_path_weight : (∑ h ∈ (histories n).toFinset, if endpoint x d h = y ∧ terminalDirection d h = e then pathWeight mu d h else 0) =
    (∑ k ∈ Finset.range (n + 1), (∑ h ∈ (histories n).toFinset, if endpoint x d h = y ∧ terminalDirection d h = e ∧ turnCount d h = k then mu ^ k else 0)) := by
      have h_path_weight : ∀ h ∈ (histories n).toFinset, pathWeight mu d h = ∑ k ∈ Finset.range (n + 1), if turnCount d h = k then mu ^ k else 0 := by
        intro h hh
        have h_turnCount : turnCount d h ≤ n := by
          have h_turnCount : ∀ (d : Direction) (h : List Direction), turnCount d h ≤ h.length := by
            intro d h; induction h generalizing d <;> simp +decide [ * ] ;
            rename_i k hk ih; exact le_trans ( by rw [ turnCount_cons ] ; split_ifs <;> simp +arith +decide ) ( Nat.succ_le_succ ( ih _ ) ) ;
          exact le_trans ( h_turnCount d h ) ( by simpa using mem_histories_length ( List.mem_toFinset.mp hh ) |> le_of_eq );
        simp +decide [ Finset.sum_ite, pathWeight_eq_pow_turnCount ];
        exact fun h => False.elim <| h.not_ge h_turnCount;
      rw [ Finset.sum_comm, Finset.sum_congr rfl ];
      intro h hh; specialize h_path_weight h hh; split_ifs <;> simp_all +decide [ Finset.sum_ite ] ;
      rw [ Finset.sum_eq_zero ] ; aesop;
  simp_all +decide [ Finset.sum_ite ];
  refine' Finset.sum_congr rfl fun k hk => _;
  rw [ ← Multiset.coe_card ];
  rw [ ← Multiset.toFinset_card_of_nodup ];
  · congr! 2;
    refine' Finset.card_bij ( fun h hh => h ) _ _ _ <;> simp +decide [ turnHistories ];
    · intro a ha hy he hk; rw [ endpoint_shift ] at hy; exact ⟨ ha, by linarith, he, hk ⟩ ;
    · intro b hb hy he hk; rw [ endpoint_shift ] ; aesop;
  · refine' List.Nodup.filter _ _;
    refine' Nat.recOn n _ _ <;> simp_all +decide [ histories ];
    intro n hn; rw [ List.nodup_append ] ; simp_all +decide [ List.nodup_map_iff_inj_on ] ;

/-! ## Helper lemmas for the corner-count combinatorics -/

/-- Each lightlike step moves the endpoint by at most one unit, so the
displacement after `h` steps is bounded by the number of steps. -/
theorem abs_endpoint_le_length (s : Direction) (h : List Direction) :
    |endpoint 0 s h| ≤ (h.length : Int) := by
  have h_step : ∀ d : Direction, |d.step| ≤ 1 := by
    exact fun d => by cases d <;> decide;
  induction' h with d h ih generalizing s;
  · cases s <;> trivial;
  · have h_step : endpoint 0 s (d :: h) = d.step + endpoint 0 d h := by
      rw [ endpoint_cons ];
      rw [ endpoint_shift ] ; aesop;
    grind +splitIndPred

/-
A displacement larger in absolute value than the number of steps is
unreachable, so its corner class is empty.
-/
theorem length_turnHistories_eq_zero_of_lt (n : Nat) (s : Direction) (dx : Int)
    (e : Direction) (k : Nat) (h : (n : Int) < |dx|) :
    (turnHistories n s dx e k).length = 0 := by
  simp_all +decide [ turnHistories ];
  intro a ha h₁ h₂ h₃; have := mem_histories_length ha; have := abs_endpoint_le_length s a; simp_all +decide ;
  linarith

/-- The displacement is maximal (`= length`) exactly for the all-`right`
history. -/
theorem endpoint_eq_length_iff (s : Direction) (h : List Direction) :
    endpoint 0 s h = (h.length : Int)
      ↔ h = List.replicate h.length Direction.right := by
  constructor <;> intro h';
  · induction' h with e rest ih generalizing s;
    · rfl;
    · rcases e with ( _ | _ ) <;> simp_all +decide [ endpoint ];
      · rw [ endpoint_shift ] at h' ; cases abs_cases ( -1 + endpoint 0 left rest ) <;> cases abs_cases ( endpoint 0 left rest ) <;> linarith [ abs_le.mp ( abs_endpoint_le_length left rest ) ];
      · rw [ show endpoint 1 right rest = 1 + endpoint 0 right rest from ?_ ] at h';
        · grind;
        · convert endpoint_shift 1 right rest using 1;
  · rw [ h' ];
    induction' h.length with n ih generalizing s <;> simp +decide [ List.replicate ] at *;
    grind +suggestions

/-- The displacement is minimal (`= -length`) exactly for the all-`left`
history. -/
theorem endpoint_eq_neg_length_iff (s : Direction) (h : List Direction) :
    endpoint 0 s h = -(h.length : Int)
      ↔ h = List.replicate h.length Direction.left := by
  constructor;
  · induction' h with e rest ih generalizing s;
    · aesop;
    · cases e <;> simp_all +decide [ endpoint_cons ];
      · grind +suggestions;
      · have h_abs : |endpoint 0 right rest| ≤ (rest.length : ℤ) := by
          exact abs_endpoint_le_length _ _;
        rw [ show endpoint 1 right rest = 1 + endpoint 0 right rest from ?_ ];
        · grind;
        · convert endpoint_shift 1 right rest using 1;
  · intro h_eq_replicate
    rw [h_eq_replicate];
    induction' h.length with n ih generalizing s <;> norm_num [ endpoint ] at *;
    rw [ List.replicate_succ, endpoint_cons, endpoint_shift ] ; norm_num [ ih ]

/-
A history with incoming direction `right` has no corner iff it is the
all-`right` history.
-/
theorem turnCount_right_eq_zero_iff (h : List Direction) :
    turnCount Direction.right h = 0
      ↔ h = List.replicate h.length Direction.right := by
  have h_ind : ∀ (h : List Direction), turnCount right h = 0 ↔ h = List.replicate h.length Direction.right := by
    intro h; induction' h with hd tl ih <;> simp +decide [ *, turnCount ] ;
    cases hd <;> simp_all +decide [ List.replicate ];
  exact h_ind h

/-
The terminal direction of a nonempty all-`left` history is `left`.
-/
theorem terminalDirection_replicate_left (s : Direction) (n : Nat) (hn : 0 < n) :
    terminalDirection s (List.replicate n Direction.left) = Direction.left := by
  induction hn <;> simp_all +decide [ List.replicate ];
  rename_i k hk ih;
  induction hk <;> simp_all +decide [ List.replicate ]

/-
A nonempty all-`left` history from incoming `right` has exactly one corner.
-/
theorem turnCount_right_replicate_left (n : Nat) (hn : 0 < n) :
    turnCount Direction.right (List.replicate n Direction.left) = 1 := by
  induction hn <;> simp_all +decide [ List.replicate ];
  rename_i k hk ih;
  induction hk <;> simp_all +decide [ List.replicate ];
  simp_all +decide [ turnCount ]

/-
The terminal direction of an all-`right` history.
-/
theorem terminalDirection_replicate_right (s : Direction) (n : Nat) :
    terminalDirection s (List.replicate n Direction.right)
      = if n = 0 then s else Direction.right := by
  induction n <;> simp_all +decide [ terminalDirection ];
  induction ‹ℕ› <;> simp_all +decide [ List.replicate ]

/-
An all-`right` history from incoming `right` has no corner.
-/
theorem turnCount_right_replicate_right (n : Nat) :
    turnCount Direction.right (List.replicate n Direction.right) = 0 := by
  convert turnCount_right_eq_zero_iff ( List.replicate n Direction.right ) |>.2 _;
  norm_num

/-
Flipping every step negates the endpoint.
-/
theorem endpoint_map_flip (s : Direction) (h : List Direction) :
    endpoint 0 s.flip (h.map Direction.flip) = - endpoint 0 s h := by
  induction h generalizing s <;> simp_all +decide [ endpoint ];
  rename_i k hk ih; rw [ endpoint_shift, endpoint_shift ] ; simp_all +decide [ Direction.flip ] ; ring;
  rw [ show endpoint k.step k hk = k.step + endpoint 0 k hk from ?_ ] ; ring!;
  · rcases k with ( _ | _ ) <;> norm_num [ Direction.step ] <;> ring!;
  · convert endpoint_shift _ _ _ using 1

/-
Flipping every step flips the terminal direction.
-/
theorem terminalDirection_map_flip (s : Direction) (h : List Direction) :
    terminalDirection s.flip (h.map Direction.flip)
      = (terminalDirection s h).flip := by
  induction h generalizing s <;> aesop

/-
Flipping every step preserves the number of corners.
-/
theorem turnCount_map_flip (s : Direction) (h : List Direction) :
    turnCount s.flip (h.map Direction.flip) = turnCount s h := by
  induction h generalizing s <;> simp_all +decide [ turnCount ];
  cases s <;> cases ‹Direction› <;> rfl

/-
Flipping every step is a bijection of the length-`n` histories with
themselves (as a permutation of the enumeration list).
-/
theorem histories_perm_map_flip (n : Nat) :
    ((histories n).map (List.map Direction.flip)).Perm (histories n) := by
  induction' n with n ih <;> simp_all +decide [ List.map, List.map_map ];
  rw [ show ( List.map ( List.map Direction.flip ∘ fun rest => left :: rest ) ( histories n ) ) = List.map ( fun rest => right :: rest ) ( List.map ( List.map Direction.flip ) ( histories n ) ) by ext; simp +decide [ Function.comp ], show ( List.map ( List.map Direction.flip ∘ fun rest => right :: rest ) ( histories n ) ) = List.map ( fun rest => left :: rest ) ( List.map ( List.map Direction.flip ) ( histories n ) ) by ext; simp +decide [ Function.comp ] ];
  grind

/-
**First-step recursion, zero corners.**  A length-`n+1` history from
incoming `right` with no corner must begin with a `right` step.
-/
theorem length_turnHistories_succ_zero (n : Nat) (dx : Int) (e : Direction) :
    (turnHistories (n + 1) Direction.right dx e 0).length
      = (turnHistories n Direction.right (dx - 1) e 0).length := by
  unfold turnHistories; simp +decide [ List.countP_eq_length_filter ] ;
  simp +decide [ List.filter_map, Function.comp ];
  rw [ List.filter_eq_nil_iff.mpr ] <;> norm_num;
  · congr! 2;
    grind +suggestions;
  · intro a ha hdx he; rw [ turnCount_cons ] ; simp +decide [ hdx, he ] ;

/-
**First-step recursion, positive corners.**  Splitting on the first step
of a length-`n+1` history from incoming `right`: a `left` first step adds a
corner (decrementing the remaining count) and moves left; a `right` first
step adds no corner and moves right.
-/
theorem length_turnHistories_succ_succ (n : Nat) (dx : Int) (e : Direction)
    (k : Nat) :
    (turnHistories (n + 1) Direction.right dx e (k + 1)).length
      = (turnHistories n Direction.left (dx + 1) e k).length
        + (turnHistories n Direction.right (dx - 1) e (k + 1)).length := by
  rw [ turnHistories, histories_succ ];
  simp [List.filter_append, List.filter_map];
  congr! 2;
  · refine' List.filter_congr fun x hx => _;
    simp +decide [ endpoint, terminalDirection, turnCount ];
    rw [ show endpoint ( -1 ) left x = endpoint 0 left x - 1 from ?_ ];
    · grind;
    · rw [ endpoint_shift ] ; ring;
  · refine' List.filter_congr fun x hx => _;
    simp +decide [ endpoint_cons, terminalDirection_cons, turnCount_cons ];
    grind +suggestions

/-! ## Target 3: flip symmetry

Flipping every step is an involution on histories exchanging left and right;
it lets the closed forms below (stated for incoming direction `right`) cover
the incoming-`left` cases. -/

/-
Corner-class cardinalities are invariant under flipping all directions
and negating the displacement.
-/
theorem length_turnHistories_flipAll (n : Nat) (d : Direction) (dx : Int)
    (e : Direction) (k : Nat) :
    (turnHistories n d dx e k).length
      = (turnHistories n d.flip (-dx) e.flip k).length := by
  unfold turnHistories;
  convert List.Perm.length_eq ( List.Perm.filter _ <| histories_perm_map_flip n ) using 1;
  rw [ List.filter_map ];
  simp +zetaDelta at *;
  congr! 2;
  ext h; simp +decide [ endpoint_map_flip, terminalDirection_map_flip, turnCount_map_flip ] ;
  cases terminalDirection d h <;> cases e <;> simp +decide [ * ]

/-
**Maximal displacement.**  The only history reaching displacement `n` in
`n` steps is the all-`right` one, which is cornerless and terminates `right`.
-/
theorem length_turnHistories_max_disp (n : Nat) (e : Direction) (k : Nat) :
    (turnHistories n Direction.right (n : Int) e k).length
      = if e = Direction.right ∧ k = 0 then 1 else 0 := by
  induction' n with n ih generalizing e k;
  · unfold turnHistories; aesop;
  · rcases k with ( _ | k );
    · rw [ length_turnHistories_succ_zero ] ; aesop;
    · rw [ length_turnHistories_succ_succ ];
      rw [ length_turnHistories_eq_zero_of_lt ] <;> norm_num;
      · specialize ih e ( k + 1 ) ; aesop;
      · grind

/-
**Minimal displacement.**  The only history reaching displacement `-n` in
`n` steps is the all-`left` one.
-/
theorem length_turnHistories_min_disp (n : Nat) (e : Direction) (k : Nat) :
    (turnHistories n Direction.right (-(n : Int)) e k).length
      = if n = 0 then (if e = Direction.right ∧ k = 0 then 1 else 0)
        else (if e = Direction.left ∧ k = 1 then 1 else 0) := by
  rcases n with ( _ | n ) <;> simp_all +decide [ turnHistories ];
  · cases e <;> cases k <;> simp +decide [ endpoint, terminalDirection, turnCount ];
  · rcases k with ( _ | k ) <;> simp_all +decide [ List.filter_map ];
    · grind +suggestions;
    · convert length_turnHistories_succ_succ n ( - ( n + 1 ) ) e k using 1;
      · unfold turnHistories; simp +decide [ List.filter_append, List.filter_map ] ;
      · rw [ length_turnHistories_flipAll ] ; norm_num [ add_assoc, sub_eq_add_neg ];
        rw [ length_turnHistories_max_disp ] ; ring;
        rw [ length_turnHistories_eq_zero_of_lt ] <;> norm_num;
        · cases e <;> simp +decide [ Direction.flip ];
        · rw [ abs_of_nonpos ] <;> linarith

/-
**Cornerless histories.**  A history with no corner is the straight-line
history, so the count at `k = 0` (incoming and terminal `right`) is `1`
exactly when the displacement is maximal (`dx = n`), else `0`.
-/
theorem length_turnHistories_zero (n : Nat) (dx : Int) :
    (turnHistories n Direction.right dx Direction.right 0).length
      = if dx = (n : Int) then 1 else 0 := by
  induction' n with n ih generalizing dx <;> simp_all +decide [ Nat.even_add_one ];
  · split_ifs <;> simp_all +decide [ turnHistories ];
    grind;
  · rw [ length_turnHistories_succ_zero, ih ];
    grind

/-
**Parity vanishing (joint form).**  From incoming `right`: terminal
`right` forces an even number of corners and terminal `left` forces an odd
number, so the wrong-parity classes are empty.
-/
theorem length_turnHistories_parity (n : Nat) :
    ∀ (dx : Int) (r : Nat),
      (turnHistories n Direction.right dx Direction.right (2 * r + 1)).length = 0
        ∧ (turnHistories n Direction.right dx Direction.left (2 * r)).length = 0 := by
  induction' n with n ih;
  · unfold turnHistories; aesop;
  · intros dx r
    constructor;
    · convert length_turnHistories_succ_succ n dx Direction.right ( 2 * r ) using 1;
      rw [ length_turnHistories_flipAll ] ; aesop;
    · induction' r with r ih' generalizing dx;
      · rw [ length_turnHistories_succ_zero ];
        exact ih _ 0 |>.2;
      · convert length_turnHistories_succ_succ n dx Direction.left ( 2 * r + 1 ) using 1;
        rw [ length_turnHistories_flipAll ];
        convert congr_arg₂ ( · + · ) ( ih ( - ( dx + 1 ) ) r |>.1.symm ) ( ih ( dx - 1 ) ( r + 1 ) |>.2.symm ) using 1

/-- **Parity vanishing.**  A history from incoming `right` to terminal
`right` has an even number of corners; the odd classes are empty.  (Stated
as the mirror sanity check of the closed forms; the analogous even-class
vanishing for terminal `left` follows by the same argument.) -/
theorem length_turnHistories_right_right_odd (n : Nat) (dx : Int) (r : Nat) :
    (turnHistories n Direction.right dx Direction.right (2 * r + 1)).length
      = 0 :=
  (length_turnHistories_parity n dx r).1

/-! ## Target 4: the closed binomial formulas

Below `p` is the number of right steps and `q` the number of left steps, so
the history length is `p + q` and the displacement is `(p : Int) - q`. -/

/-
**Joint closed form.**  By simultaneous strong induction on `p + q`, the
even (terminal `right`) and odd (terminal `left`) corner-classes have the
binomial product cardinalities, for all `p`, with `0 < q`.
-/
theorem length_turnHistories_closed (N : Nat) :
    ∀ (p q r : Nat), p + q = N → 0 < q →
      (turnHistories (p + q) Direction.right ((p : Int) - (q : Int))
            Direction.right (2 * r)).length
          = (if r = 0 then 0 else p.choose r * (q - 1).choose (r - 1))
        ∧ (turnHistories (p + q) Direction.right ((p : Int) - (q : Int))
            Direction.left (2 * r + 1)).length
          = p.choose r * (q - 1).choose r := by
  intro p q r hpq hq
  induction' N using Nat.strong_induction_on with N ih generalizing p q r;
  rcases r with ( _ | r ) <;> simp_all +decide;
  · constructor;
    · convert length_turnHistories_zero ( p + q ) ( p - q ) using 1;
      grind +revert;
    · rcases p with ( _ | p ) <;> rcases q with ( _ | q ) <;> simp_all +decide;
      · subst hpq; exact length_turnHistories_min_disp _ _ _ |>.trans ( by aesop ) ;
      · have h_split : (turnHistories N right (p - q) left 1).length = (turnHistories (N - 1) left (p - q + 1) left 0).length + (turnHistories (N - 1) right (p - q - 1) left 1).length := by
          convert length_turnHistories_succ_succ ( N - 1 ) ( p - q ) Direction.left 0 using 1;
          rw [ Nat.sub_add_cancel ( by linarith ) ];
        have h_flip : (turnHistories (N - 1) left (p - q + 1) left 0).length = (turnHistories (N - 1) right (-(p - q + 1)) right 0).length := by
          convert length_turnHistories_flipAll ( N - 1 ) left ( p - q + 1 ) left 0 using 1;
        have h_flip : (turnHistories (N - 1) right (-(p - q + 1)) right 0).length = if -(p - q + 1 : ℤ) = (N - 1 : ℤ) then 1 else 0 := by
          convert length_turnHistories_zero ( N - 1 ) ( - ( p - q + 1 ) ) using 1;
          rw [ Nat.cast_pred ( by linarith ) ];
        have := ih ( N - 1 ) ( Nat.sub_lt ( by linarith ) zero_lt_one ) p ( q + 1 ) 0 ; simp_all +decide [ Nat.choose ];
        grind;
  · constructor;
    · rcases p with ( _ | p ) <;> simp_all +decide [ Nat.choose_succ_succ ];
      · have := length_turnHistories_min_disp N right ( 2 * ( r + 1 ) ) ; aesop;
      · have h_split : (turnHistories (p + 1 + q) Direction.right (p + 1 - q) Direction.right (2 * (r + 1))).length =
          (turnHistories (p + q) Direction.left (p + 1 - q + 1) Direction.right (2 * r + 1)).length +
          (turnHistories (p + q) Direction.right (p + 1 - q - 1) Direction.right (2 * (r + 1))).length := by
            convert length_turnHistories_succ_succ ( p + q ) ( p + 1 - q ) Direction.right ( 2 * r + 1 ) using 1 ; ring;
        have h_flip : (turnHistories (p + q) Direction.left (p + 1 - q + 1) Direction.right (2 * r + 1)).length =
            (turnHistories (p + q) Direction.right (-(p + 1 - q + 1)) Direction.left (2 * r + 1)).length := by
              convert length_turnHistories_flipAll ( p + q ) Direction.left ( p + 1 - q + 1 ) Direction.right ( 2 * r + 1 ) using 1;
        have h_ind : (turnHistories (p + q) Direction.right (-(p + 1 - q + 1)) Direction.left (2 * r + 1)).length =
            (q - 1).choose r * p.choose r := by
              convert ih ( p + q ) ( by linarith ) ( q - 1 ) ( p + 1 ) r _ _ |>.2 using 1 <;> norm_num [ Nat.cast_sub hq ] ; ring;
              omega;
        have h_ind2 : (turnHistories (p + q) Direction.right (p - q) Direction.right (2 * (r + 1))).length =
            p.choose (r + 1) * (q - 1).choose r := by
              convert ih ( p + q ) ( by linarith ) p q ( r + 1 ) rfl hq |>.1 using 1;
        grind;
    · rcases p with ( _ | p ) <;> simp_all +decide [ Nat.choose_succ_succ ];
      · have := length_turnHistories_min_disp N left ( 2 * ( r + 1 ) + 1 ) ; aesop;
      · have h_split :
            (turnHistories N Direction.right (p + 1 - q : ℤ) Direction.left
                (2 * (r + 1) + 1)).length =
              (turnHistories (p + q) Direction.left (p + 1 - q + 1 : ℤ) Direction.left
                  (2 * (r + 1))).length +
              (turnHistories (p + q) Direction.right (p + 1 - q - 1 : ℤ) Direction.left
                  (2 * (r + 1) + 1)).length := by
            grind +suggestions;
        have h_split_left :
            (turnHistories (p + q) Direction.left (p + 1 - q + 1 : ℤ) Direction.left
                (2 * (r + 1))).length =
              (turnHistories (p + q) Direction.right (-(p + 1 - q + 1) : ℤ) Direction.right
                  (2 * (r + 1))).length := by
              convert length_turnHistories_flipAll ( p + q ) Direction.left ( p + 1 - q + 1 )
                Direction.left ( 2 * ( r + 1 ) ) using 1;
        have := ih ( p + q ) ( by linarith ) ( q - 1 ) ( p + 1 ) ( r + 1 ) ; simp_all +decide [ Nat.choose_succ_succ ] ;
        convert congr_arg₂ ( · + · ) ( this ( by omega ) |>.1 )
            ( ih ( p + q ) ( by linarith ) p q ( r + 1 ) ( by linarith ) hq |>.2 ) using 1 <;>
          ring

/-- **Even closed form.**  Histories with incoming and terminal direction
`right`, `p` right steps, `q >= 1` left steps, and exactly `2 * r` corners
(`r >= 1`) number `p.choose r * (q - 1).choose (r - 1)`.
Oracle-validated for all `p + q <= 11`. -/
theorem length_turnHistories_even (p q r : Nat) (hq : 0 < q) (hr : 0 < r) :
    (turnHistories (p + q) Direction.right ((p : Int) - (q : Int))
        Direction.right (2 * r)).length
      = p.choose r * (q - 1).choose (r - 1) := by
  have h := (length_turnHistories_closed (p + q) p q r rfl hq).1
  rw [if_neg (by omega : r ≠ 0)] at h
  exact h

/-- **Odd closed form.**  Histories with incoming direction `right`,
terminal direction `left`, `p` right steps, `q >= 1` left steps, and exactly
`2 * r + 1` corners number `p.choose r * (q - 1).choose r`.
Oracle-validated for all `p + q <= 11`. -/
theorem length_turnHistories_odd (p q r : Nat) (hq : 0 < q) :
    (turnHistories (p + q) Direction.right ((p : Int) - (q : Int))
        Direction.left (2 * r + 1)).length
      = p.choose r * (q - 1).choose r :=
  (length_turnHistories_closed (p + q) p q r rfl hq).2

end PhysicsSM.Draft.CheckerboardCornerCount
