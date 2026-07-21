import PhysicsSM.Draft.NullEdge.Strict3Plus1FrontierSuccessor

/-!
# Strict 3+1 torus-genuine doubling: excluding the lattice aliases

Target statements for the Aristotle job `strict3plus1-torus-20260719`.

Context.  The successor job (359f9b48, integrated) proved the combined
balance gate and the live two-point census (origin zero-crossing, all-`π`
corner PI-crossing, charges `+1` and `-1`) - and proved
`admissible_doubling_zero_or_pi` AS STATED while exposing its false shape:
with momenta in `ℝ³`, periodicity makes `(2π, 0, 0)` a "nonzero"
representative of the origin crossing, so the theorem does not express
geometric distinctness on the Brillouin torus.  This module states the
torus-genuine version: the second crossing must be NON-CONGRUENT to the
origin modulo the `2π` lattice.

Target ladder (pre-registered):

1. `LatticeCongruentZero` plumbing: the origin and `(2π, 0, 0)` are
   congruent; the all-`π` corner is NOT (each coordinate needs
   `π = 2πn → n ∉ ℤ`-style arithmetic; `Real.pi_ne_zero`,
   `Real.pi_pos` suffice - no irrationality needed).
2. `splitU_torus_doubling`: the LIVE walk satisfies the torus-genuine
   statement - witness the all-`π` corner, whose pi-crossing was
   established inside the census proof (re-derive the crossing as a named
   lemma if extraction is awkward).
3. `admissible_doubling_torus` - the RESEARCH FRONTIER, now correctly
   shaped: every admissible walk has a combined crossing NOT congruent to
   the origin.  Intended route: the ported degree/winding argument for
   `q ↦ det (U q - 1) * det (U q + 1)` over a fundamental domain, fed into
   the proved combined-balance gate.  If the port is out of reach, prove
   targets 1-2 and return a precise proof-plan report (candidate charge
   construction, missing Mathlib ingredients, <= 3 follow-up lemmas).  A
   kernel counterexample (an admissible walk whose combined crossings all
   sit on the origin lattice) would be a first-class result.

Every `s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier

/-- Congruence to the origin modulo the `2π` momentum lattice. -/
def LatticeCongruentZero (q : Fin 3 → ℝ) : Prop :=
  ∃ n : Fin 3 → ℤ, ∀ k, q k = 2 * Real.pi * (n k : ℝ)

/-- The origin is lattice-congruent to zero. -/
theorem latticeCongruentZero_origin :
    LatticeCongruentZero (fun _ => 0) := by
  exact ⟨ fun _ => 0, fun _ => by norm_num ⟩

/-- The exposed `ℝ³` alias `(2π, 0, 0)` is lattice-congruent to zero. -/
theorem latticeCongruentZero_two_pi :
    LatticeCongruentZero (fun k => if k = 0 then 2 * Real.pi else 0) := by
  exact ⟨ fun k => if k = 0 then 1 else 0, fun k => by fin_cases k <;> simp +decide ⟩

/-- The all-`π` corner is NOT lattice-congruent to zero. -/
theorem not_latticeCongruentZero_all_pi :
    ¬ LatticeCongruentZero (fun _ => Real.pi) := by
  rintro ⟨n, hn⟩
  have h := hn 0
  norm_num at h
  rcases n0 : n 0 with ⟨_ | _ | n⟩ <;>
    norm_num [n0] at h <;> nlinarith [Real.pi_pos]

/-- **Live torus-genuine doubling.**  The successive-axis walk has a
combined crossing that is not congruent to the origin: the all-`π`
corner's pi-crossing. -/
theorem splitU_torus_doubling :
    ∃ q : Fin 3 → ℝ, ¬ LatticeCongruentZero q ∧ ZeroOrPiAlias (splitU q) := by
  unfold ZeroOrPiAlias splitU
  use fun _ => Real.pi
  refine ⟨not_latticeCongruentZero_all_pi, ?_⟩
  unfold Finite3Plus1BrillouinAudit.masslessWalk
  norm_num [Compact3Plus1DiracRate.splitStep, Compact3Plus1DiracRate.factor,
    Compact3Plus1DiracRate.alpha1, Compact3Plus1DiracRate.alpha2,
    Compact3Plus1DiracRate.alpha3, Compact3Plus1DiracRate.beta]
  norm_num [Matrix.det_apply']

/-- **Research frontier, correctly shaped.**  Every admissible strict
local walk has a combined zero-or-pi crossing away from the origin
lattice. -/
theorem admissible_doubling_torus (W : AdmissibleWalk) :
    ∃ q : Fin 3 → ℝ, ¬ LatticeCongruentZero q ∧ ZeroOrPiAlias (W.U q) := by
  sorry

end PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier
