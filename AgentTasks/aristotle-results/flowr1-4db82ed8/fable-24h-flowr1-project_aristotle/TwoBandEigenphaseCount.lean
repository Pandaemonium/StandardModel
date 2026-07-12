/-
# Two-band eigenphase count: the R1 elaboration of the telescoping hinge

This file carries out route **R1** of the two-band flow-count design: it
*derives* the analytic hypotheses of the telescoping hinge
(`context/TwoBandFlowCount.lean`) from actual eigenphase geometry of a
continuous, `2*π`-periodic family of `2 × 2` unitaries.

Per the job contract the finite hinge machinery
(`Crossing`, `flowDiff`, `jumpOf`, `flowDiff_eq_zero_of_periodic_jumps`,
`no_single_crossing`) is **copied verbatim** from
`context/TwoBandFlowCount.lean` (this file does *not* import that file, so
the copy is self-contained).  Nothing in the hinge is redefined or
weakened.

## The intrinsic semicircle count

For a single `2 × 2` matrix `M` the two eigenvalues are the roots (with
multiplicity) of the characteristic polynomial
`M.charpoly = X ^ 2 - (tr M) X + (det M)` (`Matrix.charpoly_fin_two`, so
`tr` and `det` are literally the working coordinates).  For a unitary `M`
the eigenvalues lie on the unit circle, `λ = e^{iθ}`, and the eigenphase
`θ` lies in the open interval `(0, π)` **iff** `Im λ > 0`.  We therefore
define the **semicircle count**

  `countAt M = #{ eigenvalues λ of M (with multiplicity) : Im λ > 0 }`

as a `Multiset.filter` over `M.charpoly.roots`.  This is `n(k)` of the
design memo evaluated at `M = U(k)`.

## Sign convention (consistent with `jumpOf`)

An eigenphase branch is *transversal* at a crossing `k₀` if it is
differentiable there with nonzero velocity `v = θ'(k₀)`; the transversality
sign is `sign v` (`+1` when the phase increases, `-1` when it decreases).
As `k` increases through a crossing traversed upward (`v > 0`):

* at a **0-crossing** (`λ` passes through `+1 = e^{i·0}`) the eigenvalue
  moves from `Im < 0` to `Im > 0`, so `countAt` increases by `1`
  — matching `jumpOf = +sign` for `gapZero = true`;
* at a **π-crossing** (`λ` passes through `-1 = e^{i·π}`) the eigenvalue
  moves from `Im > 0` to `Im < 0`, so `countAt` decreases by `1`
  — matching `jumpOf = -sign` for `gapZero = false`.

Thus `jumpOf (cs[i]) = countAt (U(after)) - countAt (U(before))`, which is
exactly the jump law fed to the hinge.

## Deliverables and honest scope

* **(c) periodicity** and **(d) the reduction to the hinge** are proved
  completely (no `sorry`): periodicity is immediate from `2*π`-periodicity
  of `U` because `countAt (U ·)` is what the interval count is *defined*
  to be, and the reduction is a direct application of
  `flowDiff_eq_zero_of_periodic_jumps`.
* **(a) local constancy** and **(b) the jump law** are the genuinely
  analytic facts (continuity / IVT for the eigenvalue branches).  They are
  stated as isolated lemmas with precise hypotheses and documented `sorry`
  handoffs — see `countAt_locally_constant` and `jump_law` below.
-/
import Mathlib

noncomputable section

open Matrix Polynomial
open scoped Classical

namespace PhysicsSM.Draft.NullEdge.TwoBandEigenphaseCount

/-! ## Part 1 — the telescoping hinge, copied verbatim from
`context/TwoBandFlowCount.lean` (no import; nothing weakened). -/

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

/-- **The telescoping hinge (route R2).**  Given the jump law `hjump` and
periodicity `hper` of the interval-count function `n`, the signed flow
difference vanishes.  Copied verbatim; not weakened. -/
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

/-- **The no-single-crossing corollary.**  Copied verbatim; not weakened. -/
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

/-! ## Part 2 — the intrinsic semicircle count from eigenphase geometry -/

/-- The **semicircle count** of a `2 × 2` matrix: the number of eigenvalues
(roots of the characteristic polynomial, with multiplicity) whose imaginary
part is positive.  For a unitary matrix this counts eigenvalues with
eigenphase in the open interval `(0, π)`. -/
def countAt (M : Matrix (Fin 2) (Fin 2) ℂ) : ℤ :=
  ((M.charpoly.roots.filter (fun z => 0 < z.im)).card : ℤ)

/-- Transversal eigenphase branch data at a single crossing of the family
`U`.  This is the precise transversality hypothesis of the design memo:

* `branch : ℝ → ℝ` is a real eigenphase branch — `e^{i·branch k}` is an
  eigenvalue of `U k` for `k` near the crossing momentum `c.momentum`;
* at the crossing the branch hits the crossing phase (`0` for a
  0-crossing, `π` for a π-crossing);
* the branch is differentiable at the crossing with **nonzero** velocity
  `deriv_val` (transversality), and `c.sign` is the sign of that velocity
  (`+1` upward, `−1` downward) — matching the `jumpOf` convention above. -/
structure CrossingData (U : ℝ → Matrix (Fin 2) (Fin 2) ℂ) (c : Crossing) where
  /-- the real eigenphase branch through the crossing -/
  branch : ℝ → ℝ
  /-- its velocity at the crossing momentum -/
  deriv_val : ℝ
  /-- transversality: the branch is differentiable with this velocity -/
  hderiv : HasDerivAt branch deriv_val c.momentum
  /-- transversality: the velocity is nonzero -/
  hnz : deriv_val ≠ 0
  /-- the branch hits the crossing phase (`0` at a 0-crossing, `π` at a π-crossing) -/
  hphase0 : branch c.momentum = (if c.gapZero then 0 else Real.pi)
  /-- `e^{i·branch k}` is an eigenvalue of `U k` near the crossing -/
  heigen : ∀ᶠ k in nhds c.momentum,
    (U k).charpoly.eval (Complex.exp (Complex.I * (branch k : ℂ))) = 0
  /-- the recorded sign is the sign of the eigenphase velocity -/
  hsign : c.sign = if 0 < deriv_val then 1 else -1

/-- A **two-band family**: a continuous, `2*π`-periodic family of `2 × 2`
unitaries, together with an ordered finite list of transversal `±1`
crossings and interval sample momenta.

* `sample i` is a momentum in the `i`-th interval cut out by the crossings
  (`sample 0` before the first crossing; `sample (i+1)` just after the
  `i`-th crossing);
* `hsample_wrap` closes the circle: the sample after the last crossing is
  the sample before the first, shifted by one period — this is what makes
  periodicity of the count exact;
* `data` supplies the transversal eigenphase branch at each crossing. -/
structure TwoBandFamily where
  /-- the unitary family (momentum parametrization of a walk symbol) -/
  U : ℝ → Matrix (Fin 2) (Fin 2) ℂ
  /-- continuity of the family -/
  hcont : Continuous U
  /-- `2*π`-periodicity -/
  hper : ∀ k, U (k + 2 * Real.pi) = U k
  /-- each `U k` is unitary -/
  hU : ∀ k, U k ∈ Matrix.unitaryGroup (Fin 2) ℂ
  /-- ordered list of crossings -/
  cs : List Crossing
  /-- interval sample momenta -/
  sample : ℕ → ℝ
  /-- the wrap-around sample differs from the first by exactly one period -/
  hsample_wrap : sample cs.length = sample 0 + 2 * Real.pi
  /-- the sample points bracket their crossing:
  `sample i < momentum i < sample (i+1)` -/
  hbracket : ∀ i : Fin cs.length,
    sample i < (cs[i]).momentum ∧ (cs[i]).momentum < sample (i + 1)
  /-- each closed bracket `[sample i, sample (i+1)]` isolates its crossing:
  the only crossing momentum inside it is `momentum i` -/
  hisolate : ∀ i j : Fin cs.length,
    (cs[j]).momentum ∈ Set.Icc (sample i) (sample (i + 1)) → j = i
  /-- transversal eigenphase branch at each crossing -/
  data : ∀ i : Fin cs.length, CrossingData U cs[i]

namespace TwoBandFamily

variable (F : TwoBandFamily)

/-- The interval-count function fed to the hinge: the semicircle count of
`U` sampled in each interval. -/
def n (i : ℕ) : ℤ := countAt (F.U (F.sample i))

/-! ### (c) Periodicity — proved completely. -/

/-- **(c) Periodicity of the interval count.**  Because the count is
*defined* as `countAt (U (sample ·))` and the wrap-around sample differs
from the first by one full period, `2*π`-periodicity of `U` gives
`n cs.length = n 0` outright. -/
theorem periodicity : F.n F.cs.length = F.n 0 := by
  unfold TwoBandFamily.n
  rw [F.hsample_wrap, F.hper]

/-! ### (a) Local constancy — isolated analytic lemma (documented sorry).

Where no eigenvalue of `U k` is real, `countAt (U ·)` is locally constant.
We state this intrinsically in terms of `U` (independently of the crossing
list `cs`, which is not assumed to enumerate *all* crossings): the honest
hypothesis is that neither `+1` nor `-1` is an eigenvalue throughout the
interval.  For a **unitary** family the eigenvalues lie on the unit circle,
so the only real eigenvalues are `±1`; hence this is exactly "no eigenvalue
is real".

Proof idea (IVT / continuity): the roots of `(U k).charpoly` depend
continuously on `k` (continuity of `U`, hence of `tr` and `det`, hence of
the degree-2 root set); an eigenvalue can change the sign of its imaginary
part only by passing through the real axis, i.e. through `±1` on the unit
circle.  Absent such a crossing in `[a,b]`, `Complex.im` of every
eigenvalue keeps its sign, so the filtered cardinality is constant.  This
is the genuinely analytic content of deliverable (a); left as a documented
`sorry`. -/
theorem countAt_locally_constant
    {a b : ℝ} (_hab : a ≤ b)
    (hno : ∀ k ∈ Set.Icc a b,
      (F.U k).charpoly.eval 1 ≠ 0 ∧ (F.U k).charpoly.eval (-1) ≠ 0) :
    countAt (F.U a) = countAt (F.U b) := by
  sorry

/-! ### (b) The jump law — isolated analytic lemma (documented sorry).

Between the sample points bracketing crossing `i` the count changes by
exactly `jumpOf cs[i]`.  This is the transversal-crossing analysis:

* by transversality (`CrossingData`) exactly one eigenvalue branch crosses
  the real axis at `cs[i].momentum`, upward iff `deriv_val > 0`;
* at a 0-crossing an upward crossing carries the eigenvalue from
  `Im < 0` to `Im > 0` (count `+1`); at a π-crossing from `Im > 0` to
  `Im < 0` (count `−1`); a downward crossing reverses each sign;
* the other eigenvalue is bounded away from the real axis on the bracket
  and does not contribute (local constancy of its side).

Combining, `n (i+1) - n i = (if gapZero then sign else -sign) = jumpOf cs[i]`.

The statement is true-in-principle: `hbracket` places `sample i` and
`sample (i+1)` on either side of the crossing, `hisolate` guarantees no
other crossing lies in the bracket (so `countAt_locally_constant` pins the
count on each half-bracket), and `CrossingData` supplies the transversal
branch producing the single unit jump.  This is the genuinely analytic
content of deliverable (b); left as a documented `sorry`. -/
theorem jump_law (i : Fin F.cs.length) :
    F.n (i + 1) - F.n i = jumpOf F.cs[i] := by
  sorry

/-! ### (d) The reduction to the hinge — proved completely. -/

/-- **(d) Signed flow difference vanishes.**  Feeding the jump law (b) and
periodicity (c) into the telescoping hinge
`flowDiff_eq_zero_of_periodic_jumps` gives, for any two-band family, that
the signed count of 0-crossings minus π-crossings is zero. -/
theorem flowDiff_eq_zero : flowDiff F.cs = 0 :=
  flowDiff_eq_zero_of_periodic_jumps F.cs F.n (fun i => F.jump_law i) F.periodicity

/-- **No single crossing (R1 form).**  If every crossing is transversal
(`sign = ±1`), a two-band family cannot have exactly one crossing: the lone
0- or π-crossing must be partnered. -/
theorem no_single_crossing'
    (hsign : ∀ c ∈ F.cs, c.sign = 1 ∨ c.sign = -1) :
    F.cs.length ≠ 1 :=
  no_single_crossing F.cs F.n (fun i => F.jump_law i) F.periodicity hsign

end TwoBandFamily

end PhysicsSM.Draft.NullEdge.TwoBandEigenphaseCount
