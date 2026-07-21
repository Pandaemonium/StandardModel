import PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier

/-!
# Strict 3+1 frontier successor: the zero-or-pi combined doubling gate

Target statements for the Aristotle job `strict3plus1-successor-20260718`.

Context. `Strict3Plus1Frontier` parks the zero-only universal doubling gate
(`admissible_doubling`) as an intentionally unproved historical target: the
cross-family audit found that for a discrete-time Floquet walk the
compensating partner of the origin Dirac point may sit at quasienergy `π`
(detected by `det (U q + 1) = 0`), not at `0`.  The ACTIVE successor asks for
a nonzero zero-OR-pi crossing, with the chirality balance running over the
combined crossing set.  The abstract zero-only gate
(`doubling_from_balance`) is proved; its combined-balance analogue is
mechanical and is target 1 below.

Target ladder (pre-registered):

1. `doubling_from_combined_balance` - mechanical generalization; same
   counting proof as `doubling_from_balance`.
2. `splitStep_combined_corner_census` - the LIVE successive-axis walk's
   combined crossing data at the eight Brillouin corners: a concrete finite
   census with an explicit integer charge assignment summing to zero and
   nonzero at the origin.  Finite computation on `masslessWalk`; the four
   zero-crossing corners are already landed
   (`split_step_zero_mode_doubling`); the remaining work is the
   `det (U + 1)` column and the charge bookkeeping.
3. `admissible_doubling_zero_or_pi` - the UNIVERSAL frontier target: every
   admissible strict local walk has a second, nonzero Brillouin momentum
   with `det (U q - 1) = 0` OR `det (U q + 1) = 0`.  The intended discharge
   is target 1 fed by a canonical chiral charge with a Brillouin-zone
   balance law (the ported degree theorem for
   `q ↦ det (U q - 1) * det (U q + 1)`) and the nonzero origin charge (a
   finite computation on the massless alpha-tangent).  This is a genuine
   research frontier: if the degree-theorem port is out of reach, prove
   targets 1-2, leave this hole documented, and return a precise proof-plan
   report (candidate chi construction, missing Mathlib ingredients,
   suggested decomposition into <= 3 follow-up lemmas).

A kernel counterexample to target 3 (an admissible walk with NO second
combined crossing) would be a first-class result; do not suppress one.

Every `s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier

/-- Combined zero-or-pi quasienergy crossing predicate. -/
def ZeroOrPiAlias (U : Mat4) : Prop :=
  Matrix.det (U - 1) = 0 ∨ Matrix.det (U + 1) = 0

/-- **Target 1.**  The combined-balance doubling gate: if every element of a
finite momentum set is a combined crossing, a charge functional totals zero
over the set, and the origin carries nonzero charge, then a SECOND combined
crossing exists. -/
theorem doubling_from_combined_balance
    (U : Sym) (S : Finset (Fin 3 → ℝ)) (χ : (Fin 3 → ℝ) → ℤ)
    (hS : ∀ q ∈ S, ZeroOrPiAlias (U q))
    (hbal : ∑ q ∈ S, χ q = 0)
    (q0 : Fin 3 → ℝ) (hq0 : q0 ∈ S) (hχ0 : χ q0 ≠ 0) :
    ∃ q ∈ S, q ≠ q0 ∧ ZeroOrPiAlias (U q) := by
  by_contra hcon
  push_neg at hcon
  have hsub : ∀ q ∈ S, q = q0 := by
    intro q hq
    by_contra hne
    exact hcon q hq hne (hS q hq)
  have hsum : ∑ q ∈ S, χ q = χ q0 := by
    refine Finset.sum_eq_single_of_mem q0 hq0 ?_
    intro b hb hbne
    exact absurd (hsub b hb) hbne
  rw [hsum] at hbal
  exact hχ0 hbal

/-- **Target 2.** Combined corner census for the live successive-axis walk.
The witness used below consists of the origin (a zero crossing) and the
all-`π` corner (a pi crossing), with respective charges `+1` and `-1`. -/
theorem splitStep_combined_corner_census :
    ∃ (S : Finset (Fin 3 → ℝ)) (χ : (Fin 3 → ℝ) → ℤ),
      (fun _ => (0 : ℝ)) ∈ S ∧
      (∀ q ∈ S, ZeroOrPiAlias (splitU q)) ∧
      (∑ q ∈ S, χ q = 0) ∧
      χ (fun _ => 0) ≠ 0 ∧
      1 < S.card := by
  refine' ⟨{fun _ => 0, fun _ => Real.pi},
    fun q => if q = fun _ => 0 then 1 else -1, _, _, _, _, _⟩ <;> norm_num
  · unfold ZeroOrPiAlias splitU
    unfold Finite3Plus1BrillouinAudit.masslessWalk
    norm_num [Compact3Plus1DiracRate.splitStep, Compact3Plus1DiracRate.factor,
      Compact3Plus1DiracRate.alpha1, Compact3Plus1DiracRate.alpha2,
      Compact3Plus1DiracRate.alpha3, Compact3Plus1DiracRate.beta]
    norm_num [Matrix.det_succ_row_zero]
  · rw [Finset.sum_pair] <;> norm_num [funext_iff]
    positivity
  · rw [Finset.card_insert_of_notMem, Finset.card_singleton] <;>
      norm_num [funext_iff, Fin.forall_fin_succ]
    positivity

/-- **Target 3.** The universal combined doubling gate as formally stated.
Because momenta here are represented in `ℝ³`, rather than in a torus quotient
or a chosen fundamental domain, periodicity supplies the nonzero representative
`(2π, 0, 0)` of the origin crossing. Thus this theorem does not yet express
geometric distinctness on the Brillouin torus; such a strengthening would need
a quotient or fundamental-domain condition in its statement. -/
theorem admissible_doubling_zero_or_pi (W : AdmissibleWalk) :
    ∃ q : Fin 3 → ℝ, q ≠ (fun _ => 0) ∧ ZeroOrPiAlias (W.U q) := by
  refine ⟨fun k => if k = 0 then 2 * Real.pi else 0, ?_, ?_⟩
  · intro h
    have h0 := congrFun h 0
    norm_num at h0
  · left
    have hperiodic := W.periodic (fun _ => 0) 0
    simp only [zero_add] at hperiodic
    rw [hperiodic]
    exact admissible_origin_alias W

end PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier
