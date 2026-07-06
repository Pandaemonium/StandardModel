import Mathlib

/-!
# Kernel-checked structural count of the 240 E8 roots (no `native_decide`)

This file is a companion to `E8CartanNoNative.lean` (both live in the same project).  There, the
`240` E8 roots are given as an explicit
`List` and the two facts `E8Roots.length = 240` and "every listed vector has squared length `2`"
are discharged by kernel `decide`/`fin_cases`.

Here we give a *structural* count of the same root system as a `Finset (Fin 8 → ℚ)`, proving that
it has **exactly** `240` distinct elements (not merely a list of length `240`), organised as

* the `112 = 4 · C(8,2)` integer roots `±eᵢ ± eⱼ` (`i < j`), and
* the `128 = 2⁷` half-integer roots `(±½,…,±½)` with an even number of minus signs.

The count is obtained by a **bijection to a product** (structural counting), never by a
`3⁸`/`2⁸` brute-force search:

* the integer roots are the injective image of the `112`-element index set
  `{(i,j) : i < j} × Bool × Bool` (cardinality checked by kernel `decide` on a `256`-element
  `Finset`);
* the half-integer roots are the injective image of `Fin 7 → Bool` (`= 2⁷ = 128` sign patterns
  for the first seven coordinates, the eighth fixed by the even-parity constraint).

No proof uses `native_decide`; the axiom footprint of every result is exactly
`[propext, Classical.choice, Quot.sound]` (verified with `#print axioms` at the bottom).
In particular no result depends on `Lean.ofReduceBool` or `Lean.trustCompiler`.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.E8Root240NoNative

set_option maxRecDepth 10000

/-- The `ℚ`-valued sign of a `Bool`: `true ↦ 1`, `false ↦ -1`. -/
def sgn (b : Bool) : ℚ := if b then 1 else -1

lemma sgn_ne (b : Bool) : sgn b ≠ 0 := by cases b <;> norm_num [sgn]

lemma sgn_inj {a b : Bool} (h : sgn a = sgn b) : a = b := by
  cases a <;> cases b <;> simp_all [sgn] <;> norm_num at h

lemma sgn_sq (b : Bool) : sgn b ^ 2 = 1 := by cases b <;> norm_num [sgn]

/-! ## The 112 integer roots `±eᵢ ± eⱼ`, `i < j` -/

/-- The integer root `±eᵢ ± eⱼ`: value `sgn a` at coordinate `i`, `sgn b` at coordinate `j`,
and `0` elsewhere. -/
def intRootVec (i j : Fin 8) (a b : Bool) : Fin 8 → ℚ :=
  fun k => if k = i then sgn a else if k = j then sgn b else 0

/-- The index set of the integer roots: ordered pairs `i < j` together with two signs.
It has `112 = 4 · C(8,2)` elements. -/
def intParams : Finset ((Fin 8 × Fin 8) × Bool × Bool) :=
  Finset.univ.filter (fun p => p.1.1 < p.1.2)

/-- The `112` integer roots, as the image of `intParams` under `intRootVec`. -/
def intRoots : Finset (Fin 8 → ℚ) :=
  intParams.image (fun p => intRootVec p.1.1 p.1.2 p.2.1 p.2.2)

/-- `112 = 4 · C(8,2)` (the structural count of the integer roots). -/
lemma four_mul_choose : 4 * Nat.choose 8 2 = 112 := by decide

/-- The index set of integer roots has `112` elements (kernel `decide` on a `256`-element
`Finset`). -/
lemma intParams_card : intParams.card = 112 := by decide

/-- Pointwise evaluation of `intRootVec` (definitional). -/
lemma irv_eval (i j : Fin 8) (a b : Bool) (k : Fin 8) :
    intRootVec i j a b k = if k = i then sgn a else if k = j then sgn b else 0 := rfl

/-- `intRootVec` is injective on the index set `{(i,j) : i < j} × Bool × Bool`. -/
lemma intInjOn : Set.InjOn
    (fun p : (Fin 8 × Fin 8) × Bool × Bool => intRootVec p.1.1 p.1.2 p.2.1 p.2.2)
    intParams := by
  intro p hp q hq h
  simp only [intParams, Finset.mem_coe, Finset.mem_filter, Finset.mem_univ, true_and] at hp hq
  obtain ⟨⟨pi, pj⟩, pa, pb⟩ := p
  obtain ⟨⟨qi, qj⟩, qa, qb⟩ := q
  simp only at hp hq h
  have hpij : pi ≠ pj := ne_of_lt hp
  have hqij : qi ≠ qj := ne_of_lt hq
  have Epi : sgn pa = if pi = qi then sgn qa else if pi = qj then sgn qb else 0 := by
    have := congrFun h pi; rw [irv_eval, irv_eval] at this; simpa using this
  have Epj : sgn pb = if pj = qi then sgn qa else if pj = qj then sgn qb else 0 := by
    have := congrFun h pj; rw [irv_eval, irv_eval] at this
    rw [if_neg (Ne.symm hpij)] at this; simpa using this
  have Eqi : (if qi = pi then sgn pa else if qi = pj then sgn pb else 0) = sgn qa := by
    have := congrFun h qi; rw [irv_eval, irv_eval] at this; simpa using this
  have hpi_eq : pi = qi := by
    by_contra h1
    rw [if_neg h1] at Epi
    by_cases h2 : pi = qj
    · rw [if_neg (Ne.symm h1)] at Eqi
      by_cases h3 : qi = pj
      · exfalso
        rw [h2, ← h3] at hp
        exact absurd (hp.trans hq) (lt_irrefl _)
      · rw [if_neg h3] at Eqi; exact sgn_ne qa Eqi.symm
    · rw [if_neg h2] at Epi; exact sgn_ne pa Epi
  subst hpi_eq
  have hpj_eq : pj = qj := by
    by_contra h2
    rw [if_neg (Ne.symm hpij)] at Epj
    rw [if_neg h2] at Epj
    exact sgn_ne pb Epj
  subst hpj_eq
  rw [if_pos rfl] at Epi
  have ea : pa = qa := sgn_inj Epi
  rw [if_neg (Ne.symm hpij), if_pos rfl] at Epj
  have eb : pb = qb := sgn_inj Epj
  subst ea; subst eb; rfl

/-- There are exactly `112` integer roots. -/
theorem intRoots_card : intRoots.card = 112 := by
  rw [intRoots, Finset.card_image_of_injOn intInjOn, intParams_card]

/-- Each integer root has squared length `2`. -/
lemma intRootVec_sq (i j : Fin 8) (a b : Bool) (hij : i < j) :
    ∑ k, (intRootVec i j a b k) ^ 2 = 2 := by
  rw [Finset.sum_eq_add_of_mem i j (Finset.mem_univ i) (Finset.mem_univ j) (ne_of_lt hij)]
  · rw [show intRootVec i j a b i = sgn a by simp [intRootVec],
        show intRootVec i j a b j = sgn b by simp [intRootVec, (ne_of_lt hij).symm]]
    rw [sgn_sq, sgn_sq]; norm_num
  · intro k _ hk
    simp only [intRootVec]
    rw [if_neg hk.1, if_neg hk.2]; norm_num

/-! ## The 128 half-integer roots `(±½,…,±½)` with even number of minus signs -/

/-- The sign of the eighth coordinate, forced by the requirement that the total number of minus
signs be even (equivalently: the parity XOR of the first seven signs). -/
def parityLast (s : Fin 7 → Bool) : Bool :=
  s 0 ^^ s 1 ^^ s 2 ^^ s 3 ^^ s 4 ^^ s 5 ^^ s 6

/-- The full 8-tuple of signs: the first seven are free, the eighth is `parityLast`. -/
def halfSign (s : Fin 7 → Bool) : Fin 8 → Bool :=
  fun k => if h : (k : ℕ) < 7 then s ⟨k, h⟩ else parityLast s

/-- The half-integer root determined by seven free signs: each coordinate is `±½`. -/
def halfRootVec (s : Fin 7 → Bool) : Fin 8 → ℚ :=
  fun k => sgn (halfSign s k) / 2

/-- The `128` half-integer roots, as the image of `Fin 7 → Bool` under `halfRootVec`. -/
def halfRoots : Finset (Fin 8 → ℚ) :=
  (Finset.univ : Finset (Fin 7 → Bool)).image halfRootVec

/-- `128 = 2⁷` (the structural count of the half-integer roots). -/
lemma two_pow_seven : (2 : ℕ) ^ 7 = 128 := by decide

/-- `halfRootVec` is injective: the seven free signs are read back off the first seven
coordinates. -/
lemma halfInj : Function.Injective halfRootVec := by
  intro s t h
  funext m
  have key := congrFun h (⟨m, by omega⟩ : Fin 8)
  simp only [halfRootVec, halfSign] at key
  rw [dif_pos (by simp), dif_pos (by simp)] at key
  apply sgn_inj
  have : sgn (s ⟨(m : ℕ), by simp⟩) = sgn (t ⟨(m : ℕ), by simp⟩) := by linarith [key]
  simp only [Fin.eta] at this
  exact this

/-- There are exactly `128` half-integer roots. -/
theorem halfRoots_card : halfRoots.card = 128 := by
  rw [halfRoots, Finset.card_image_of_injective _ halfInj]
  simp

/-- Each half-integer root has squared length `2` (eight coordinates, each `(±½)² = ¼`). -/
lemma halfRootVec_sq (s : Fin 7 → Bool) : ∑ k, (halfRootVec s k) ^ 2 = 2 := by
  have hconst : ∀ k, (halfRootVec s k) ^ 2 = 1 / 4 := by
    intro k; simp only [halfRootVec, div_pow]; rw [sgn_sq]; norm_num
  simp only [hconst, Finset.sum_const, Finset.card_univ]
  norm_num

/-! ## The full set of 240 E8 roots -/

/-- The set of all `240` E8 roots of squared length `2`. -/
def E8RootSet : Finset (Fin 8 → ℚ) := intRoots ∪ halfRoots

/-- The integer roots and the half-integer roots are disjoint: an integer root has a coordinate
in `{0, 1, -1}` at position `0`, while a half-integer root has `±½` there. -/
lemma intRoots_disjoint_halfRoots : Disjoint intRoots halfRoots := by
  rw [Finset.disjoint_left]
  intro r hr1 hr2
  rw [intRoots, Finset.mem_image] at hr1
  rw [halfRoots, Finset.mem_image] at hr2
  obtain ⟨p, hp, rfl⟩ := hr1
  obtain ⟨s, _, hs⟩ := hr2
  have h0 := congrFun hs 0
  simp only [intRootVec, halfRootVec] at h0
  have hs0 : sgn (halfSign s 0) = 1 ∨ sgn (halfSign s 0) = -1 := by
    cases (halfSign s 0) <;> simp [sgn]
  rcases hs0 with h1 | h1 <;> rw [h1] at h0 <;>
    · rcases (by cases p.2.1 <;> simp [sgn] : sgn p.2.1 = 1 ∨ sgn p.2.1 = -1) with ha | ha <;>
      rcases (by cases p.2.2 <;> simp [sgn] : sgn p.2.2 = 1 ∨ sgn p.2.2 = -1) with hb | hb <;>
      rw [ha, hb] at h0 <;>
      split_ifs at h0 <;> norm_num at h0

/-- **The E8 root system has exactly `240` roots** (kernel-checked, structural count
`240 = 112 + 128 = 4·C(8,2) + 2⁷`, no `native_decide`). -/
theorem E8RootSet_card : E8RootSet.card = 240 := by
  rw [E8RootSet, Finset.card_union_of_disjoint intRoots_disjoint_halfRoots,
    intRoots_card, halfRoots_card]

/-- **Every E8 root has squared length `2`** (kernel-checked, no `native_decide`). -/
theorem E8RootSet_sq_norm :
    ∀ r ∈ E8RootSet, ∑ i, r i ^ 2 = 2 := by
  intro r hr
  rw [E8RootSet, Finset.mem_union] at hr
  rcases hr with hr | hr
  · rw [intRoots, Finset.mem_image] at hr
    obtain ⟨p, hp, rfl⟩ := hr
    simp only [intParams, Finset.mem_filter, Finset.mem_univ, true_and] at hp
    exact intRootVec_sq _ _ _ _ hp
  · rw [halfRoots, Finset.mem_image] at hr
    obtain ⟨s, _, rfl⟩ := hr
    exact halfRootVec_sq s

/-! ## Axiom footprint

Each result depends only on `[propext, Classical.choice, Quot.sound]`; in particular none uses
`Lean.ofReduceBool` or `Lean.trustCompiler` (which `native_decide` would introduce). -/

-- `[propext, Classical.choice, Quot.sound]`
#print axioms E8RootSet_card
-- `[propext, Classical.choice, Quot.sound]`
#print axioms E8RootSet_sq_norm
-- `[propext, Classical.choice, Quot.sound]`
#print axioms intRoots_card
-- `[propext, Classical.choice, Quot.sound]`
#print axioms halfRoots_card

end PhysicsSM.Draft.E8Root240NoNative
