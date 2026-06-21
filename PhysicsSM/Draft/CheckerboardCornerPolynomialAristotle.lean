import Mathlib
import PhysicsSM.Spinor.Checkerboard

/-!
# Draft.CheckerboardCornerPolynomialAristotle

Focused Aristotle handoff: the finite checkerboard kernel as a polynomial in
the corner weight.

This splits the larger corner-count package into the structural part only:

* endpoints translate by the starting position;
* the path weight is `mu ^ turnCount`;
* the path sum is the finite sum over corner classes;
* flipping every step preserves corner-class cardinalities.

The binomial closed forms for those cardinalities live in
`PhysicsSM.Draft.CheckerboardCornerClosedFormsAristotle`.

Trusted code should not import this module while it contains `s o r r y`.
-/

namespace PhysicsSM.Draft.CheckerboardCornerPolynomial

open PhysicsSM.Spinor.Checkerboard
open PhysicsSM.Spinor.Checkerboard.Direction

variable {S : Type*}

/-- The histories of length `n` with incoming direction `startDir`,
displacement `dx`, terminal direction `finishDir`, and exactly `k` corners. -/
def turnHistories (n : Nat) (startDir : Direction) (dx : Int)
    (finishDir : Direction) (k : Nat) : List (List Direction) :=
  (histories n).filter fun h =>
    decide (endpoint 0 startDir h = dx
      ∧ terminalDirection startDir h = finishDir
      ∧ turnCount startDir h = k)

/-! ## Helper lemmas -/

/-- The endpoint does not depend on the (unused) initial direction. -/
theorem endpoint_dir (x : Int) (d d' : Direction) (h : List Direction) :
    endpoint x d h = endpoint x d' h := by
  induction' h with e rest ih generalizing x d d';
  · rfl;
  · cases d <;> cases d' <;> tauto

/-- The endpoint depends on the start position only by translation. -/
theorem endpoint_shift (x : Int) (d : Direction) (h : List Direction) :
    endpoint x d h = x + endpoint 0 d h := by
  induction' h with e rest ih generalizing x d;
  · exact Eq.symm ( by simp [ endpoint ] );
  · convert ih ( x + e.step ) e using 1;
    rw [ endpoint_cons, add_assoc ];
    grind

/-- Flipping every step negates the displacement. -/
theorem endpoint_zero_map_flip (d : Direction) (h : List Direction) :
    endpoint 0 d (h.map Direction.flip) = - endpoint 0 d h := by
  -- We'll use induction on the length of the list `h`.
  induction' h with e h ih generalizing d;
  · rfl;
  · cases e <;> simp_all +decide [ endpoint_cons ];
    · convert congr_arg ( fun x : Int => 1 + x ) ( ih right ) using 1;
      · convert endpoint_shift 1 right ( List.map Direction.flip h ) using 1;
      · rw [ endpoint_shift ] ; norm_num;
        rw [ add_comm, endpoint_dir ];
    · rw [ endpoint_shift, endpoint_shift ] ; simp +decide [ ih ];
      rw [ show endpoint 1 right h = 1 + endpoint 0 right h by rw [ endpoint_shift ] ] ; ring;
      rw [ endpoint_dir ]

/-- Flipping every step (and the incoming direction) flips the terminal
direction. -/
theorem terminalDirection_map_flip (d : Direction) (h : List Direction) :
    terminalDirection d.flip (h.map Direction.flip) = (terminalDirection d h).flip := by
  induction h generalizing d <;> simp_all +decide [ terminalDirection ]

/-- Flipping every step (and the incoming direction) preserves the corner
count. -/
theorem turnCount_map_flip (d : Direction) (h : List Direction) :
    turnCount d.flip (h.map Direction.flip) = turnCount d h := by
  induction' h with e rest ih generalizing d;
  · rfl;
  · cases e <;> cases d <;> simp +decide [ turnCount ];
    · exact ih left;
    · exact ih left;
    · convert ih right using 1;
    · convert ih right using 1

/-- The corner count is bounded by the length of the history. -/
theorem turnCount_le_length (d : Direction) (h : List Direction) :
    turnCount d h ≤ h.length := by
  induction h generalizing d <;> simp_all +decide [ turnCount ];
  grind

/-- Flipping every step is a permutation of the set of histories of a fixed
length. -/
theorem histories_map_flip_perm (n : Nat) :
    ((histories n).map (fun h => h.map Direction.flip)).Perm (histories n) := by
  induction' n with n ih <;> simp_all +decide [ List.map_map, Function.comp ];
  refine' List.Perm.trans _ ( List.Perm.append ( List.Perm.map _ ih ) ( List.Perm.map _ ih ) );
  simp +decide [ List.map_map, Function.comp_def ];
  exact List.perm_append_comm

/-- A polynomial regrouping: a list-sum of `mu`-powers indexed by a weight
`w a ≤ N` equals the sum over `k ≤ N` of the number of elements of weight `k`
times `mu ^ k`. -/
theorem sum_map_ite_pow_eq [Semiring S] {α : Type*} (L : List α) (N : Nat)
    (mu : S) (cond : α → Prop) [DecidablePred cond] (w : α → Nat)
    (hN : ∀ a ∈ L, w a ≤ N) :
    (L.map (fun a => if cond a then mu ^ w a else 0)).sum
      = ∑ k ∈ Finset.range (N + 1),
          ((L.filter (fun a => decide (cond a ∧ w a = k))).length : S) * mu ^ k := by
  induction L <;> simp_all +decide [ Finset.sum_range_succ ];
  simp +decide [ Finset.sum_add_distrib, List.filter_cons ];
  split_ifs <;> simp_all +decide [ Finset.sum_add_distrib, add_mul, mul_add, Finset.mul_sum _ _ _, Finset.sum_mul ];
  · simp +decide [ add_comm, add_left_comm, add_assoc, Finset.sum_add_distrib ];
    exact congrArg _ ( congrArg _ ( Finset.sum_congr rfl fun x hx => by aesop ) );
  · simp +decide [ ← add_assoc, Finset.sum_eq_add_sum_diff_singleton ( Finset.mem_range.mpr ( lt_of_le_of_ne hN.1 ‹_› ) ) ];
    simp +decide [ add_mul, Finset.sum_add_distrib, add_assoc, add_left_comm, add_comm ];
    exact congr_arg _ ( congr_arg _ ( congr_arg _ ( Finset.sum_congr rfl fun x hx => by aesop ) ) )

/-! ## Main statements -/

/-- The path weight is exactly the corner weight raised to the number of
corners, with the incoming direction included in the corner count. -/
theorem pathWeight_eq_pow_turnCount [Semiring S] (mu : S)
    (d : Direction) (h : List Direction) :
    pathWeight mu d h = mu ^ turnCount d h := by
  induction' h with e rest ih generalizing d;
  · cases d <;> simp +decide [ pathWeight, turnCount ];
  · cases h : e == d <;> simp_all +decide [ pow_add, turnCount_cons ];
    cases d <;> cases e <;> tauto

/-- The finite checkerboard path sum is the polynomial in `mu` whose
coefficients count histories with fixed endpoint data and fixed corner count. -/
theorem pathSum_eq_sum_turnHistories [Semiring S] (mu : S) (x : Int)
    (d : Direction) (n : Nat) (y : Int) (e : Direction) :
    pathSum mu x d n y e
      =
        ∑ k ∈ Finset.range (n + 1),
          ((turnHistories n d (y - x) e k).length : S) * mu ^ k := by
  convert sum_map_ite_pow_eq ( histories n ) n mu ( fun h => decide ( endpoint 0 d h = y - x ∧ terminalDirection d h = e ) ) ( fun h => turnCount d h ) _ using 1;
  · refine' congr_arg _ ( List.map_congr_left _ );
    grind +suggestions;
  · unfold turnHistories; simp +decide [ and_assoc ] ;
  · exact fun h hh => le_trans ( turnCount_le_length d h ) ( mem_histories_length hh ▸ le_rfl )

/-- Corner-class cardinalities are invariant under flipping all directions
and negating the displacement. -/
theorem length_turnHistories_flipAll (n : Nat) (d : Direction) (dx : Int)
    (e : Direction) (k : Nat) :
    (turnHistories n d dx e k).length
      = (turnHistories n d.flip (-dx) e.flip k).length := by
  convert List.Perm.length_eq ( List.Perm.filter _ <| histories_map_flip_perm n ) using 1;
  rw [ List.filter_map ];
  simp +decide [ turnHistories, Function.comp ];
  congr! 2;
  ext h; simp +decide [ endpoint_zero_map_flip, terminalDirection_map_flip, turnCount_map_flip ] ;
  cases d <;> cases e <;> simp +decide [ Direction.flip ];
  · cases terminalDirection left h <;> simp +decide [ * ];
    rw [ endpoint_dir ];
  · cases terminalDirection left h <;> simp +decide [ * ];
    rw [ endpoint_dir ];
  · cases terminalDirection right h <;> simp +decide [ * ];
    rw [ endpoint_dir ];
  · rw [ endpoint_dir 0 right left h ];
    cases terminalDirection right h <;> simp +decide [ * ]

end PhysicsSM.Draft.CheckerboardCornerPolynomial
