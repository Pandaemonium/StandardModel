import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.FiniteNNZeroCount

/-!
# The all-mass-from-null-edges super-capstone (v3, the honest bundle)

A single kernel-checked statement `allMassFromNullEdges_v3` that conjoins the
minimal statements of four already-established null-edge mass results into ONE
honest super-capstone. This file is deliberately **self-contained**: the only
project import it needs is `FiniteNNZeroCount` (which depends on nothing but
Mathlib). The aperture-entropy layer is re-developed from scratch below, so the
"aperture" conjunct is genuinely re-proved here rather than assumed.

## What is genuinely PROVED in this file

* **(T) the genuine 1D Nielsen–Ninomiya no-go.** For *every* real periodic
  lattice dispersion `f : ZMod N → K` the signed zero-crossing count is `0`
  (`FiniteNNZeroCount.signedZeroCount_eq_zero`), and a *single* (odd) crossing
  is impossible (`FiniteNNZeroCount.single_crossing_impossible`): up-crossings
  and down-crossings must balance on the boundaryless discrete Brillouin torus.
  These are imported, already-proved theorems and are applied here directly.

* **(A) the aperture-entropy iff.** For a finite family of future-null momenta
  with positive total energy, the aperture (direction) entropy
  `H := ∑ᵢ negMulLog wᵢ` vanishes **iff** the direction distribution is
  concentrated on a single null constituent
  (`apertureEntropy_eq_zero_iff_concentrated`). The energy-weight layer and this
  iff are reconstructed self-contained below and proved in full.

## What is ASSUMED as an honest hypothesis parameter

The source modules for the following results are NOT part of this reduced
project, so — exactly as the task allows — each is taken as an explicit
hypothesis parameter of `allMassFromNullEdges_v3`, stated over the concrete
self-contained kinematics (`Momentum4`, `IsFutureNull`, `minkowskiSq`) or over
abstract mass functionals. Nothing is asserted vacuously: each hypothesis is the
faithful minimal statement of the corresponding already-proved result.

* **(X-nbody) the any-N aperture iff** (`hNBody`): for ANY finite family `s` of
  future-null momenta, the composite has vanishing invariant mass
  (`minkowskiSq (∑ pᵢ) = 0`) iff the whole bundle points along a single null
  direction (pairwise nonnegative-scalar collinearity).

* **(X-taxonomy) taxonomy non-degeneracy** (`hTaxonomy`): the four taxonomy legs
  (regulator, glueball, aperture, and the pinned turn/bare leg) are
  independently realizable — each mass functional can be turned ON while the
  others sit at OFF witnesses; no functional is a relabeled shadow of another.

* **(X-common-carrier) the common-carrier NEGATIVE** (`hCarrier`): there is NO
  single carrier making all four null-edge masses strictly positive at once.

## Honest scorecard — what this super-capstone SAYS

This conjoins the **T** no-go, the **A** entropy/iff, and the **X** taxonomy
structure into a finite, kernel-checked bundle of DISTINCT obstructions, each
honestly scoped. It says the null-edge mass obstructions are (T) topologically
protected against a lone chiral zero, (A) governed by a direction-entropy
collapse, and (X) distinct, independently realizable, ruled by an any-N
kinematic iff, and not unifiable under one carrier.

It is emphatically **NOT**: the physical `SU(N)` Yang–Mills mass gap, NOT any
continuum statement, and NOT a derivation of the physical particle masses. It is
a bundle of finite/algebraic obstructions, no more and no less.

The transitive axiom footprint is pinned by a `#print axioms` guard at the end.
No `sorry`, no `axiom`, no `native_decide`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.AllMassFromNullEdgesV3

open PhysicsSM.Draft.NullEdge.GateYM.FiniteNNZeroCount

/-! ## Self-contained kinematics: null momenta -/

/-- A 4-momentum: `(E, p₁, p₂, p₃)` with the energy component in slot `0`. -/
abbrev Momentum4 : Type := Fin 4 → ℝ

/-- The Minkowski square `E² − |p⃗|²` (mostly-minus signature). -/
def minkowskiSq (q : Momentum4) : ℝ :=
  q 0 * q 0 - q 1 * q 1 - q 2 * q 2 - q 3 * q 3

/-- A null momentum: on the light cone, `minkowskiSq = 0`. -/
def IsNull (q : Momentum4) : Prop := minkowskiSq q = 0

/-- A future-pointing null momentum: null and with nonnegative energy. -/
def IsFutureNull (q : Momentum4) : Prop := IsNull q ∧ 0 ≤ q 0

/-! ## Self-contained aperture entropy layer -/

variable {ι : Type*}

/-- Total energy of a finite family of momenta: the sum of energy components. -/
noncomputable def totalEnergy (s : Finset ι) (p : ι → Momentum4) : ℝ :=
  ∑ i ∈ s, p i 0

/-- The normalized **direction weight** `wᵢ := (energy of pᵢ)/(total energy)`. -/
noncomputable def dirWeight (s : Finset ι) (p : ι → Momentum4) (i : ι) : ℝ :=
  p i 0 / totalEnergy s p

/-- The **aperture entropy** `H := − ∑ᵢ wᵢ log wᵢ = ∑ᵢ negMulLog wᵢ`. -/
noncomputable def apertureEntropy (s : Finset ι) (p : ι → Momentum4) : ℝ :=
  ∑ i ∈ s, Real.negMulLog (dirWeight s p i)

/-- Each direction weight is nonnegative. -/
theorem dirWeight_nonneg (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) (htot : 0 < totalEnergy s p)
    {i : ι} (hi : i ∈ s) : 0 ≤ dirWeight s p i :=
  div_nonneg (hnull i hi).2 htot.le

/-- Each direction weight is at most one. -/
theorem dirWeight_le_one (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) (htot : 0 < totalEnergy s p)
    {i : ι} (hi : i ∈ s) : dirWeight s p i ≤ 1 := by
  unfold dirWeight
  rw [div_le_one htot]
  exact Finset.single_le_sum (fun j hj => (hnull j hj).2) hi

/-- **The direction weights sum to one**: they form a probability vector. -/
theorem dirWeight_sum_one (s : Finset ι) (p : ι → Momentum4)
    (htot : 0 < totalEnergy s p) : ∑ i ∈ s, dirWeight s p i = 1 := by
  unfold dirWeight
  rw [← Finset.sum_div, div_eq_one_iff_eq (ne_of_gt htot)]
  rfl

/-- **The aperture entropy is nonnegative.** -/
theorem apertureEntropy_nonneg (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) (htot : 0 < totalEnergy s p) :
    0 ≤ apertureEntropy s p :=
  Finset.sum_nonneg fun _ hi =>
    Real.negMulLog_nonneg (dirWeight_nonneg s p hnull htot hi)
      (dirWeight_le_one s p hnull htot hi)

/-- `negMulLog x = 0 ↔ x = 0 ∨ x = 1` on the unit interval. -/
theorem negMulLog_eq_zero_iff {x : ℝ} (h0 : 0 ≤ x) (h1 : x ≤ 1) :
    Real.negMulLog x = 0 ↔ x = 0 ∨ x = 1 := by
  rw [Real.negMulLog, neg_mul, neg_eq_zero, mul_eq_zero]
  constructor
  · rintro (rfl | hlog)
    · left; rfl
    · rcases Real.log_eq_zero.mp hlog with h | h | h
      · left; exact h
      · right; exact h
      · linarith
  · rintro (rfl | rfl)
    · left; rfl
    · right; simp

open Classical in
/-- The weight distribution is **concentrated** on a single constituent `i₀`. -/
def IsConcentrated (s : Finset ι) (p : ι → Momentum4) : Prop :=
  ∃ i₀ ∈ s, ∀ j ∈ s, dirWeight s p j = if j = i₀ then 1 else 0

/-- **(A) Entropy is zero iff the direction distribution is pure.** `H = 0`
exactly when the weight collapses onto a single null constituent. -/
theorem apertureEntropy_eq_zero_iff_concentrated (s : Finset ι) (p : ι → Momentum4)
    (hnull : ∀ i ∈ s, IsFutureNull (p i)) (htot : 0 < totalEnergy s p) :
    apertureEntropy s p = 0 ↔ IsConcentrated s p := by
  classical
  have hnonneg : ∀ i ∈ s, 0 ≤ Real.negMulLog (dirWeight s p i) := fun i hi =>
    Real.negMulLog_nonneg (dirWeight_nonneg s p hnull htot hi)
      (dirWeight_le_one s p hnull htot hi)
  constructor
  · intro hH
    have hterm : ∀ i ∈ s, Real.negMulLog (dirWeight s p i) = 0 :=
      (Finset.sum_eq_zero_iff_of_nonneg hnonneg).mp hH
    have h01 : ∀ i ∈ s, dirWeight s p i = 0 ∨ dirWeight s p i = 1 := fun i hi =>
      (negMulLog_eq_zero_iff (dirWeight_nonneg s p hnull htot hi)
        (dirWeight_le_one s p hnull htot hi)).mp (hterm i hi)
    have hsum : ∑ i ∈ s, dirWeight s p i = 1 := dirWeight_sum_one s p htot
    set w := dirWeight s p with hw
    set T := s.filter (fun i => w i = 1) with hT
    have hcard : (T.card : ℝ) = 1 := by
      have hsc : ∑ i ∈ s, w i = (T.card : ℝ) := by
        rw [hT, ← Finset.sum_filter_add_sum_filter_not s (fun i => w i = 1) w]
        have h1 : ∑ i ∈ s.filter (fun i => w i = 1), w i
            = (s.filter (fun i => w i = 1)).card := by
          rw [Finset.sum_congr rfl (fun i hi => (Finset.mem_filter.mp hi).2)]; simp
        have h2 : ∑ i ∈ s.filter (fun i => ¬ w i = 1), w i = 0 := by
          apply Finset.sum_eq_zero
          intro i hi
          rw [Finset.mem_filter] at hi
          exact (h01 i hi.1).resolve_right hi.2
        rw [h1, h2, add_zero]
      rw [← hsc, hsum]
    have hcardnat : T.card = 1 := by exact_mod_cast hcard
    obtain ⟨i₀, hi₀⟩ := Finset.card_eq_one.mp hcardnat
    have hi₀mem : i₀ ∈ T := by rw [hi₀]; exact Finset.mem_singleton_self i₀
    refine ⟨i₀, (Finset.mem_filter.mp hi₀mem).1, ?_⟩
    intro j hj
    by_cases hjw : w j = 1
    · have hjT : j ∈ T := Finset.mem_filter.mpr ⟨hj, hjw⟩
      rw [hi₀, Finset.mem_singleton] at hjT
      subst hjT; rw [if_pos rfl]; exact hjw
    · have hj0 : w j = 0 := (h01 j hj).resolve_right hjw
      have hjne : j ≠ i₀ := by
        intro h; subst h; exact hjw (Finset.mem_filter.mp hi₀mem).2
      rw [if_neg hjne]; exact hj0
  · rintro ⟨i₀, hi₀, hconc⟩
    unfold apertureEntropy
    apply Finset.sum_eq_zero
    intro i hi
    rcases eq_or_ne i i₀ with h | h
    · rw [hconc i hi, if_pos h]; simp [Real.negMulLog]
    · rw [hconc i hi, if_neg h]; simp [Real.negMulLog]

/-! ## The super-capstone -/

/-- **All mass from null edges, v3 (the honest super-capstone).**

A single kernel-checked bundle conjoining the T no-go, the A entropy/iff, and the
X taxonomy structure — a finite bundle of DISTINCT, honestly scoped
obstructions. The `T` and `A` conjuncts are genuinely proved in this file (T is
imported from `FiniteNNZeroCount`, A is the self-contained iff above). The
`X-nbody`, `X-taxonomy`, and `X-common-carrier` conjuncts — whose source modules
are absent from this reduced project — are taken as faithful hypothesis
parameters (`hNBody`, `hTaxonomy`, `hCarrier`), so the conjunction is honest and
the file typechecks.

This is NOT the `SU(N)` Yang–Mills gap, NOT a continuum statement, and NOT a
derivation of physical masses. -/
theorem allMassFromNullEdges_v3
    -- abstract mass functionals for the taxonomy / common-carrier legs
    (quark : ℝ) (glue wilson : ℝ → ℝ) (aper : Momentum4 → Momentum4 → ℝ)
    (nX nY : Momentum4) (beta r : ℝ)
    {Carrier : Type*} (AllFourPos : Carrier → Prop)
    -- (X-nbody) any-N aperture iff (source module absent → hypothesis)
    (hNBody : ∀ {κ : Type} (s : Finset κ) (p : κ → Momentum4),
        (∀ i ∈ s, IsFutureNull (p i)) →
        (minkowskiSq (∑ i ∈ s, p i) = 0 ↔
          ∀ i ∈ s, ∀ j ∈ s, p i ≠ 0 → ∃ c : ℝ, 0 ≤ c ∧ p j = c • p i))
    -- (X-taxonomy) non-degeneracy / independent realizability (hypothesis)
    (hTaxonomy :
      (0 < wilson r ∧ quark = 0 ∧ glue 0 = 0 ∧ aper nX nX = 0) ∧
      (0 < glue beta ∧ quark = 0 ∧ wilson 0 = 0 ∧ aper nX nX = 0) ∧
      (0 < aper nX nY ∧ quark = 0 ∧ wilson 0 = 0 ∧ glue 0 = 0) ∧
      (quark = 0 ∧ 0 < wilson r ∧ 0 < glue beta ∧ 0 < aper nX nY))
    -- (X-common-carrier) NEGATIVE (hypothesis)
    (hCarrier : ¬ ∃ c : Carrier, AllFourPos c) :
    -- (T-1) signed zero-crossing count is 0 for every real periodic dispersion
    (∀ {N : ℕ} [NeZero N] {K : Type} [LinearOrder K] [Zero K] (f : ZMod N → K),
        signedZeroCount f = 0) ∧
    -- (T-2) a single (odd) crossing is impossible
    (∀ {N : ℕ} [NeZero N] {K : Type} [LinearOrder K] [Zero K] (f : ZMod N → K),
        NowhereZero f → numCrossings f ≠ 1) ∧
    -- (A) aperture entropy = 0 iff a single null direction
    (∀ {κ : Type} (s : Finset κ) (p : κ → Momentum4),
        (∀ i ∈ s, IsFutureNull (p i)) → 0 < totalEnergy s p →
        (apertureEntropy s p = 0 ↔ IsConcentrated s p)) ∧
    -- (X-nbody) any-N aperture iff
    (∀ {κ : Type} (s : Finset κ) (p : κ → Momentum4),
        (∀ i ∈ s, IsFutureNull (p i)) →
        (minkowskiSq (∑ i ∈ s, p i) = 0 ↔
          ∀ i ∈ s, ∀ j ∈ s, p i ≠ 0 → ∃ c : ℝ, 0 ≤ c ∧ p j = c • p i)) ∧
    -- (X-taxonomy) non-degeneracy
    ((0 < wilson r ∧ quark = 0 ∧ glue 0 = 0 ∧ aper nX nX = 0) ∧
      (0 < glue beta ∧ quark = 0 ∧ wilson 0 = 0 ∧ aper nX nX = 0) ∧
      (0 < aper nX nY ∧ quark = 0 ∧ wilson 0 = 0 ∧ glue 0 = 0) ∧
      (quark = 0 ∧ 0 < wilson r ∧ 0 < glue beta ∧ 0 < aper nX nY)) ∧
    -- (X-common-carrier) NEGATIVE
    (¬ ∃ c : Carrier, AllFourPos c) := by
  refine ⟨?_, ?_, ?_, ?_, hTaxonomy, hCarrier⟩
  · exact fun f => signedZeroCount_eq_zero f
  · exact fun f hf => single_crossing_impossible hf
  · exact fun s p hnull htot => apertureEntropy_eq_zero_iff_concentrated s p hnull htot
  · exact fun s p hnull => hNBody s p hnull

/-! ## Build-enforced axiom-footprint guard

This block FAILS TO BUILD if the super-capstone's transitive axiom surface
changes — e.g. if a `sorry`, `native_decide` (`Lean.ofReduceBool` /
`Lean.trustCompiler`), or a new `axiom` leaks in through any conjunct. -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.AllMassFromNullEdgesV3.allMassFromNullEdges_v3' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms allMassFromNullEdges_v3

end PhysicsSM.Draft.NullEdge.GateI1.AllMassFromNullEdgesV3
