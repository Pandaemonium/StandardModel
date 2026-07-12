import Mathlib

/-!
# Two-band 1+1 flow-count theorem: signed 0-crossings minus signed pi-crossings vanish

The general 1+1 warm-up of the strict-3+1 program (design and proof
sketch in `context/WARMUP_DESIGN.md`; the fixture layer is already
kernel-landed in `context/TwoBandCrossingDoubling.lean`, whose flow-one
walk has exactly one 0-crossing and one pi-crossing at the same
momentum - the count anchor `1 - 1 = 0`).

Setting: `U : Real -> Matrix (Fin 2) (Fin 2) Complex`, a continuous
(2-pi-periodic) family of unitaries - the momentum parametrization
`k |-> U(e^{ik})` of a finite-range walk symbol.  A 0-crossing is a
momentum where `+1` is an eigenvalue; a pi-crossing where `-1` is.

The design memo's invariant: the integer
`n(k) := #(eigenvalues of U(k) with eigenphase in the open (0, pi))`
is locally constant off the crossing set and jumps by the transversality
sign `q` at each crossing: `+q` at a 0-crossing, `-q` at a pi-crossing
(with `q = sign` of the eigenphase velocity).  Periodicity of `n` over
`[0, 2*pi]` forces

  (sum of q over 0-crossings) - (sum of q over pi-crossings) = 0,

and consequently a walk cannot have a SINGLE nondegenerate crossing in
total: at least one 0-crossing and one pi-crossing partner each other
(the pseudo-doubler law; the flow-one fixture realizes it sharply).

## What is landed here (route R2 of the design memo)

This file lands the **telescoping hinge** as a genuine finite theorem
with the analytic content isolated as explicit hypotheses over an ordered
crossing list (route R2 of the design memo).  The semicircle-count
function is represented by its values `n : ℕ → ℤ` on the ordered
intervals that the crossings cut the circle into: `n 0` is the value on
the interval before the first crossing, `n (i+1)` the value just after
the `i`-th crossing.  The three analytic facts of the proof sketch become
hypotheses of the theorem:

* *local constancy off the crossing set* — encoded structurally, since
  `n` is a function of the interval index (one value per interval);
* *the jump law* — `hjump`: the `i`-th crossing changes `n` by exactly
  `jumpOf (cs[i])`, namely `+sign` at a 0-crossing and `-sign` at a
  pi-crossing;
* *2-pi periodicity of `n`* — `hper`: the value after the last crossing
  equals the value before the first, `n cs.length = n 0`.

The statements are packaged so that the kernel-landed flow-one fixture
from `context/TwoBandCrossingDoubling.lean` (two crossings at `z = -1`,
a 0-crossing and its pi-partner, with `flowDiff = 1 - 1 = 0`) can later
discharge the hypotheses.

The memo's route R1 (defining `n(k)` intrinsically from `trace`/`det` via
`Complex.arg` and *proving* local constancy and the jump law from
transversality) is a strictly stronger, analysis-heavy elaboration that
would discharge `hjump`/`hper` from the eigenphase geometry; it is not
carried out here.  Nothing below weakens the jump law or the periodicity
hypothesis.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.TwoBandFlowCount

/-- Crossing record: momentum in `[0, 2*pi)`, gap (`true` = 0-crossing at
eigenvalue `+1`, `false` = pi-crossing at `-1`), transversality sign. -/
structure Crossing where
  momentum : ℝ
  gapZero : Bool
  sign : ℤ

/-- The signed flow difference of a finite crossing list:
sum of signs at gap 0 minus sum of signs at gap pi. -/
def flowDiff (cs : List Crossing) : ℤ :=
  (cs.filter (·.gapZero)).foldl (· + ·.sign) 0
    - (cs.filter (¬ ·.gapZero)).foldl (· + ·.sign) 0

/-- The jump of the semicircle count at a single crossing: an eigenphase
crossing `+1` (a 0-crossing) moves `n` by `+sign`, one crossing `-1`
(a pi-crossing) moves it by `-sign`.  This is exactly the summand whose
telescoping sum is `flowDiff`. -/
def jumpOf (c : Crossing) : ℤ := if c.gapZero then c.sign else -c.sign

/-- The `foldl (· + ·.sign)` accumulator used in `flowDiff` is the ordinary
sum of the signs. -/
theorem foldl_sign_eq (l : List Crossing) :
    l.foldl (· + ·.sign) 0 = (l.map (·.sign)).sum := by
  rw [List.sum_eq_foldl]
  induction l using List.reverseRecOn with
  | nil => simp
  | append_singleton xs x ih => simp [ih]

/-- `flowDiff` is the plain sum of the per-crossing jumps `jumpOf`
(gap-0 signs enter with `+`, gap-pi signs with `−`). -/
theorem flowDiff_eq_map_sum (cs : List Crossing) :
    flowDiff cs = (cs.map jumpOf).sum := by
  induction cs with
  | nil => simp [flowDiff]
  | cons c cs ih =>
    unfold flowDiff at *
    rw [foldl_sign_eq, foldl_sign_eq] at ih ⊢
    simp only [List.map_cons, List.sum_cons, List.filter_cons, decide_not]
    rcases hc : c.gapZero with _ | _ <;> simp_all [jumpOf] <;> omega

/-- A list sum of a mapped function, reindexed as a `Finset` sum over the
positions of the list. -/
theorem map_sum_eq_fin_sum {α β : Type*} [AddCommMonoid β] (l : List α)
    (f : α → β) : (l.map f).sum = ∑ i : Fin l.length, f l[i] := by
  conv_lhs => rw [← List.ofFn_get l]
  rw [List.map_ofFn, List.sum_ofFn]; rfl

/-- **T1 — the telescoping hinge (route R2).**

Let `cs` be a finite ordered list of crossings and let `n : ℕ → ℤ` record
the value of the semicircle count on each interval between consecutive
crossings (`n 0` before the first crossing, `n (i+1)` just after the
`i`-th).  Assume:

* `hjump` (the jump law): at the `i`-th crossing the count changes by
  exactly `jumpOf (cs[i])`, i.e. `+sign` at a 0-crossing and `−sign` at a
  pi-crossing;
* `hper` (2-pi periodicity): the count returns to its starting value after
  the last crossing, `n cs.length = n 0`.

Then the signed flow difference vanishes: `flowDiff cs = 0`.

The proof telescopes `flowDiff cs = ∑ i, jumpOf cs[i] = ∑ i, (n (i+1) − n i)
= n cs.length − n 0 = 0`. -/
theorem flowDiff_eq_zero_of_periodic_jumps
    (cs : List Crossing) (n : ℕ → ℤ)
    (hjump : ∀ i : Fin cs.length, n (i + 1) - n i = jumpOf cs[i])
    (hper : n cs.length = n 0) :
    flowDiff cs = 0 := by
  rw [flowDiff_eq_map_sum, map_sum_eq_fin_sum]
  have h1 : ∑ i : Fin cs.length, jumpOf cs[i]
          = ∑ i : Fin cs.length, (n (i + 1) - n i) :=
    Finset.sum_congr rfl (fun i _ => (hjump i).symm)
  rw [h1, Fin.sum_univ_eq_sum_range (fun i => n (i + 1) - n i),
    Finset.sum_range_sub, hper, sub_self]

/-- **T2 — the no-single-crossing corollary.**

Under the same hypotheses as `flowDiff_eq_zero_of_periodic_jumps`, if every
crossing carries a nonzero transversality sign (`±1`), then the walk cannot
have exactly one crossing in total.  A single crossing would force
`flowDiff = ±1 ≠ 0`, contradicting the vanishing of the signed flow
difference: the lone crossing must be partnered (a 0-crossing pairs with a
pi-crossing — the pseudo-doubler law). -/
theorem no_single_crossing
    (cs : List Crossing) (n : ℕ → ℤ)
    (hjump : ∀ i : Fin cs.length, n (i + 1) - n i = jumpOf cs[i])
    (hper : n cs.length = n 0)
    (hsign : ∀ c ∈ cs, c.sign = 1 ∨ c.sign = -1) :
    cs.length ≠ 1 := by
  intro hlen
  have hflow : flowDiff cs = 0 :=
    flowDiff_eq_zero_of_periodic_jumps cs n hjump hper
  obtain ⟨c, rfl⟩ : ∃ c, cs = [c] := List.length_eq_one_iff.mp hlen
  have hc : c.sign = 1 ∨ c.sign = -1 := hsign c (by simp)
  rw [flowDiff_eq_map_sum] at hflow
  simp only [List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    add_zero, jumpOf] at hflow
  rcases hc with h | h <;> rcases Bool.eq_false_or_eq_true c.gapZero with hg | hg <;>
    simp_all

end PhysicsSM.Draft.NullEdge.TwoBandFlowCount
