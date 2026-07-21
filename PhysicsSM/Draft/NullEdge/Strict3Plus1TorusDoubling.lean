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
3. The once-proposed universal `admissible_doubling_torus` claim is false
   for `AdmissibleWalk`: that interface has continuity, periodicity,
   unitarity, and the local Dirac tangent, but no locality or global
   charge-balance hypothesis.  `WilsonCayleyWalk` gives the exact
   counterexample.  The repaired theorem below makes the missing finite
   combined-charge balance and fundamental-domain control explicit.

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

/-
The former universal target

`forall W : AdmissibleWalk, exists q, not LatticeCongruentZero q and
  ZeroOrPiAlias (W.U q)`

is refuted in `WilsonCayleyWalk`.  It is intentionally not retained as an
active declaration.
-/

/-- A finite combined crossing set with balanced integer charge and nonzero
origin charge has a torus-distinct crossing, provided the chosen fundamental
domain contains no other origin-lattice representative. -/
theorem admissible_doubling_torus_of_combined_balance
    (W : AdmissibleWalk) (S : Finset (Fin 3 → ℝ)) (chi : (Fin 3 → ℝ) → ℤ)
    (hS : ∀ q ∈ S, ZeroOrPiAlias (W.U q))
    (hbal : ∑ q ∈ S, chi q = 0)
    (h0 : (fun _ => (0 : ℝ)) ∈ S)
    (hchi0 : chi (fun _ => 0) ≠ 0)
    (hfund : ∀ q ∈ S, LatticeCongruentZero q → q = fun _ => 0) :
    ∃ q : Fin 3 → ℝ, ¬ LatticeCongruentZero q ∧ ZeroOrPiAlias (W.U q) := by
  obtain ⟨q, hqS, hq0, hqAlias⟩ :=
    doubling_from_combined_balance W.U S chi hS hbal (fun _ => 0) h0 hchi0
  refine ⟨q, ?_, hqAlias⟩
  intro hqCongruent
  exact hq0 (hfund q hqS hqCongruent)

/-- info: 'PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier.admissible_doubling_torus_of_combined_balance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms admissible_doubling_torus_of_combined_balance

end PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier
